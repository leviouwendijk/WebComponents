import Constructors
import CSS
import HTML

public struct DocsScopedTOC: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-toc"

    public let navigation: NavigationStructure
    public let title: String
    public let currentHref: String?
    public let includeStyles: Bool

    public init(
        navigation: NavigationStructure,
        title: String = "Inhoud",
        currentHref: String? = nil,
        includeStyles: Bool = true
    ) {
        self.navigation = navigation
        self.title = title
        self.currentHref = currentHref
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        guard !navigation.roots.isEmpty else {
            return .init()
        }

        let body: HTMLFragment = [
            HTML.nav(
                [
                    "id": "toc",
                    "class": "toc open \(Self.block)",
                    "data-wc-docs-toc": ""
                ]
            ) {
                HTML.h2 {
                    HTML.text(title)
                }

                HTML.ul(["id": "toc-list"]) {
                    renderRoots(navigation.roots)
                }
            }
        ]

        return .body(
            body,
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    private func renderRoots(
        _ nodes: [NavigationNode]
    ) -> HTMLFragment {
        nodes.map { node in
            renderCategory(node)
        }
    }

    private func renderCategory(
        _ node: NavigationNode
    ) -> any HTMLNode {
        HTML.el(
            "li",
            [
                "class": "toc-category",
                "data-toc-category": node.label.lowercased()
            ]
        ) {
            HTML.h3 {
                HTML.text(node.label)
            }

            HTML.el("ul") {
                renderNodes(node.children)
            }
        }
    }

    private func renderNodes(
        _ nodes: [NavigationNode]
    ) -> HTMLFragment {
        nodes.map { node in
            renderNode(node)
        }
    }

    private func renderNode(
        _ node: NavigationNode
    ) -> any HTMLNode {
        let hasChildren = node.hasChildren
        let expanded = hasChildren && nodeContainsSelected(node)

        return HTML.el(
            "li",
            expanded ? ["class": "expanded"] : [:]
        ) {
            if let path = node.path {
                link(
                    label: node.label,
                    href: path
                )
            } else {
                HTML.span {
                    HTML.text(node.label)
                }
            }

            if hasChildren {
                HTML.el("ul", ["class": "submenu"]) {
                    renderNodes(node.children)
                }
            }
        }
    }

    private func link(
        label: String,
        href: String
    ) -> any HTMLNode {
        var attrs: HTMLAttribute = [
            "data-docs-spy-link": href
        ]

        if isSelected(href) {
            attrs.merge([
                "class": "selected-item",
                "aria-current": "location"
            ])
        }

        return HTML.a(href, attrs) {
            HTML.text(label)
        }
    }

    private func nodeContainsSelected(
        _ node: NavigationNode
    ) -> Bool {
        if let path = node.path, isSelected(path) {
            return true
        }

        return node.children.contains { child in
            nodeContainsSelected(child)
        }
    }

    private func isSelected(
        _ href: String
    ) -> Bool {
        guard let currentHref else {
            return false
        }

        return href == currentHref
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block) a[aria-current=\"location\"]",
                    CSS.decl("font-weight", "700")
                ),

                CSS.rule(
                    ".\(block) a.selected-item",
                    CSS.decl("font-weight", "700")
                ),

                CSS.rule(
                    ".\(block) a",
                    CSS.decl("scroll-margin-top", "var(--wc-docs-sticky-offset, 112px)")
                ),

                CSS.rule(
                    ".dark-mode .\(block)",
                    CSS.decl("background-color", "var(--background-color)"),
                    CSS.decl("color", "var(--text-color)")
                )
            ]
        )
    }
}
