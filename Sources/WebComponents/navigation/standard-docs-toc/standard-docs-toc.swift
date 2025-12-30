import Constructors
import HTML
import CSS

public struct StandardDocsTOC: WebComponent {
    public let navigation: NavigationStructure
    public let title: String
    public let currentPath: String?

    public init(
        navigation: NavigationStructure,
        title: String = "Inhoud",
        currentPath: String? = nil
    ) {
        self.navigation = navigation
        self.title = title
        self.currentPath = currentPath
    }

    public func html() -> [any HTMLNode] {
        [
            toc_html()
        ]
    }

    public func styles() -> [CSSStyleSheet] {
        // Keep docs styling in the site (DocsHondenmeestersSite.Style.Toc.build()).
        // Return [] here so WebComponents stays site-agnostic.
        []
    }
}

extension StandardDocsTOC {
    public func toc_html() -> any HTMLNode {
        guard !navigation.roots.isEmpty else {
            return HTML.blank()
        }

        return HTML.nav(
            [
                "id": "toc",
                "class": "toc open"
            ]
        ) {
            HTML.h2 { HTML.text(title) }

            HTML.ul(["id": "toc-list"]) {
                tocRenderRoots(navigation.roots)
            }
        }
    }

    // Root nodes become .toc-category blocks (your CSS expects this)
    public func tocRenderRoots(
        _ nodes: [NavigationNode]
    ) -> HTMLFragment {
        var out: HTMLFragment = []

        for node in nodes {
            out.append(tocRenderCategory(node))
        }

        return out
    }

    public func tocRenderCategory(
        _ node: NavigationNode
    ) -> any HTMLNode {
        return HTML.el("li", ["class": "toc-category"]) {
            HTML.h3 {
                HTML.text(node.label)
            }

            HTML.el("ul") {
                tocRenderNodes(node.children, level: 0)
            }
        }
    }

    // Non-root nodes: links + optional nested .submenu
    public func tocRenderNodes(
        _ nodes: [NavigationNode],
        level: Int
    ) -> HTMLFragment {
        var out: HTMLFragment = []

        for node in nodes {
            out.append(tocRenderNode(node, level: level))
        }

        return out
    }

    public func tocRenderNode(
        _ node: NavigationNode,
        level: Int
    ) -> any HTMLNode {
        let hasChildren = node.hasChildren

        // Optional: keep ancestors of the selected page open on first render
        let shouldExpand = hasChildren && nodeContainsSelected(node)
        let liClass = shouldExpand ? "expanded" : ""

        return HTML.el("li", liClass.isEmpty ? [:] : ["class": liClass]) {
            if let path = node.path {
                let aClass = isSelected(path: path) ? "selected-item" : ""

                if aClass.isEmpty {
                    HTML.a(path) { HTML.text(node.label) }
                } else {
                    HTML.a(path, ["class": aClass]) { HTML.text(node.label) }
                }
            } else {
                HTML.span { HTML.text(node.label) }
            }

            if hasChildren {
                // No inline display style; CSS/JS controls it
                HTML.el("ul", ["class": "submenu"]) {
                    tocRenderNodes(node.children, level: level + 1)
                }
            }
        }
    }

    private func nodeContainsSelected(_ node: NavigationNode) -> Bool {
        if let path = node.path, isSelected(path: path) {
            return true
        }
        for child in node.children {
            if nodeContainsSelected(child) {
                return true
            }
        }
        return false
    }

    private func isSelected(path: String) -> Bool {
        guard let currentPath else { return false }

        // Normalize simple trailing slash differences
        if currentPath == path { return true }
        if currentPath.hasSuffix("/") {
            return String(currentPath.dropLast()) == path
        }
        if path.hasSuffix("/") {
            return currentPath == String(path.dropLast())
        }

        return false
    }
}
