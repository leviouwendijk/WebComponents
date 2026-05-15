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
                    "data-wc-docs-toc": "",
                    "data-docs-mobile-menu-target": "",
                    "data-docs-mobile-menu-desktop-open": "true"
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
        let hasChildren = node.hasChildren

        var attrs: HTMLAttribute = [
            "class": node.path == nil ? "toc-category" : "toc-category toc-category--linked",
            "data-toc-category": node.label.lowercased()
        ]

        if hasChildren && nodeContainsSelected(node) {
            attrs.merge([
                "data-expanded": "true"
            ])
        }

        return HTML.el(
            "li",
            attrs
        ) {
            HTML.h3 {
                if let path = node.path {
                    link(
                        label: node.label,
                        href: path
                    )
                } else {
                    HTML.text(node.label)
                }
            }

            if hasChildren {
                HTML.el("ul") {
                    renderNodes(node.children)
                }
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
                    ".\(block)",
                    CSS.decl("position", "sticky"),
                    CSS.decl("align-self", "start"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("padding", "24px 18px"),
                    CSS.decl("border-right", "1px solid var(--border-color)"),
                    CSS.decl("background", "var(--background-color)"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("overflow-y", "auto")
                ),

                CSS.rule(
                    ".\(block) ul",
                    CSS.decl("list-style", "none"),
                    CSS.decl("padding-left", "0")
                ),

                CSS.rule(
                    ".\(block) li",
                    CSS.decl("margin", "6px 0")
                ),

                CSS.rule(
                    ".\(block) h2",
                    CSS.decl("margin-top", "0"),
                    CSS.decl("font-size", ".8rem"),
                    CSS.decl("letter-spacing", ".1em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block) h3",
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("margin", "18px 0 8px"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block) a",
                    CSS.decl("display", "block"),
                    CSS.decl("border-radius", "8px"),
                    CSS.decl("padding", "6px 8px"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("font-size", ".88rem"),
                    CSS.decl("scroll-margin-top", "var(--wc-docs-sticky-offset, 112px)")
                ),

                CSS.rule(
                    ".\(block) a:hover",
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 7%, transparent)"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block) a[aria-current=\"location\"]",
                    CSS.decl("font-weight", "700")
                ),

                CSS.rule(
                    ".\(block) a.selected-item",
                    CSS.decl("font-weight", "700"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 18%, transparent)"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block) .toc-category > h3 a",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("color", "inherit"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".\(block) .toc-category > h3 a:hover",
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".dark-mode .\(block)",
                    CSS.decl("background-color", "var(--background-color)"),
                    CSS.decl("color", "var(--text-color)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 1200px)",
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("position", "fixed"),
                        CSS.decl("left", "0"),
                        CSS.decl("right", "0"),
                        CSS.decl("bottom", "0"),
                        CSS.decl("top", "var(--wc-docs-sticky-offset, 112px)"),
                        CSS.decl("z-index", "997"),
                        CSS.decl("height", "auto"),
                        CSS.decl("width", "100%"),
                        CSS.decl("border-right", "0"),
                        CSS.decl("border-top", "1px solid var(--border-color)"),
                        CSS.decl("transform", "translateX(-100%)"),
                        CSS.decl("transition", "transform 180ms ease"),
                        CSS.decl("will-change", "transform")
                    ),

                    CSS.rule(
                        ".\(block).open",
                        CSS.decl("transform", "translateX(0)")
                    )
                )
            ]
        )
    }
}
