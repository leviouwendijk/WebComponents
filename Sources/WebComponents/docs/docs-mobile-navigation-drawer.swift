import Constructors
import CSS
import HTML

public struct DocsMobileNavigationDrawer: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-mobile-navigation-drawer"

    public let site: DocsSite
    public let context: DocsNavigationContext
    public let lexicon: DocsLexicon
    public let targetID: String
    public let globalNavigation: NavigationStructure?
    public let includeStyles: Bool

    public init(
        site: DocsSite,
        context: DocsNavigationContext,
        lexicon: DocsLexicon = .english,
        targetID: String? = nil,
        globalNavigation: NavigationStructure? = nil,
        includeStyles: Bool = true
    ) {
        self.site = site
        self.context = context
        self.lexicon = lexicon
        self.targetID = targetID ?? Self.targetID(for: context)
        self.globalNavigation = globalNavigation
        self.includeStyles = includeStyles
    }

    public static func targetID(
        for context: DocsNavigationContext
    ) -> String {
        switch context.surface {
        case .categoryPage:
            return "toc"

        case .siteHub,
             .projectHub:
            return "docs-mobile-navigation"
        }
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.nav(
                    [
                        "id": targetID,
                        "class": "docs-mobile-navigation \(Self.block)",
                        "aria-label": lexicon.docsContextAriaLabel,
                        "data-docs-mobile-menu-target": "",
                        "data-docs-mobile-menu-desktop-open": "false"
                    ]
                ) {
                    HTML.div(["class": "\(Self.block)__inner"]) {
                        HTML.p(["class": "\(Self.block)__eyebrow"]) {
                            HTML.text(eyebrow())
                        }

                        HTML.h2(["class": "\(Self.block)__title"]) {
                            HTML.text(title())
                        }

                        HTML.ul(["class": "\(Self.block)__list"]) {
                            renderNodes(navigation().roots)
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    private func eyebrow() -> String {
        switch context.surface {
        case .siteHub,
             .projectHub:
            return lexicon.projects

        case .categoryPage:
            return lexicon.tocTitle
        }
    }

    private func title() -> String {
        switch context.surface {
        case .siteHub,
             .projectHub:
            return site.title

        case .categoryPage:
            return context.activeCategory(in: site)?.label ?? lexicon.tocTitle
        }
    }

    private func navigation() -> NavigationStructure {
        switch context.surface {
        case .siteHub,
             .projectHub:
            if let globalNavigation {
                return globalNavigation
            }

            return NavigationStructure(
                roots: site.projects.map { project in
                    NavigationNode(
                        label: project.label,
                        path: project.href,
                        children: project.knowledgeBase.categories.map { category in
                            NavigationNode(
                                label: category.label,
                                path: category.href
                            )
                        }
                    )
                }
            )

        case .categoryPage:
            guard let category = context.activeCategory(in: site) else {
                return NavigationStructure(roots: [])
            }

            return category.navigation
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
        HTML.li([
            "class": node.hasChildren
                ? "\(Self.block)__item \(Self.block)__item--group"
                : "\(Self.block)__item"
        ]) {
            if let path = node.path {
                HTML.a(path, ["class": "\(Self.block)__link"]) {
                    HTML.text(node.label)
                }
            } else {
                HTML.span(["class": "\(Self.block)__label"]) {
                    HTML.text(node.label)
                }
            }

            if node.hasChildren {
                HTML.ul(["class": "\(Self.block)__sublist"]) {
                    renderNodes(node.children)
                }
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("display", "none")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 1200px)",
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("display", "block"),
                        CSS.decl("position", "fixed"),
                        CSS.decl("left", "0"),
                        CSS.decl("right", "0"),
                        CSS.decl("bottom", "0"),
                        CSS.decl("top", "calc(var(--wc-docs-header-height, 60px) + var(--wc-docs-project-context-height, 44px))"),
                        CSS.decl("z-index", "997"),
                        CSS.decl("box-sizing", "border-box"),
                        CSS.decl("padding", "22px"),
                        CSS.decl("background", "var(--background-color)"),
                        CSS.decl("border-top", "1px solid var(--border-color)"),
                        CSS.decl("overflow-y", "auto"),
                        CSS.decl("transform", "translateX(-100%)"),
                        CSS.decl("transition", "transform 180ms ease"),
                        CSS.decl("will-change", "transform")
                    ),

                    CSS.rule(
                        ".\(block).open",
                        CSS.decl("transform", "translateX(0)")
                    ),

                    CSS.rule(
                        ".\(block)__inner",
                        CSS.decl("width", "min(760px, 100%)"),
                        CSS.decl("margin", "0 auto")
                    ),

                    CSS.rule(
                        ".\(block)__eyebrow",
                        CSS.decl("margin", "0 0 8px"),
                        CSS.decl("font-size", ".76rem"),
                        CSS.decl("font-weight", "800"),
                        CSS.decl("letter-spacing", ".12em"),
                        CSS.decl("text-transform", "uppercase"),
                        CSS.decl("color", "var(--muted-text-color)")
                    ),

                    CSS.rule(
                        ".\(block)__title",
                        CSS.decl("margin", "0 0 20px"),
                        CSS.decl("font-size", "1.35rem"),
                        CSS.decl("line-height", "1.1"),
                        CSS.decl("letter-spacing", "-.03em")
                    ),

                    CSS.rule(
                        ".\(block)__list, .\(block)__sublist",
                        CSS.decl("list-style", "none"),
                        CSS.decl("padding", "0"),
                        CSS.decl("margin", "0")
                    ),

                    CSS.rule(
                        ".\(block)__item",
                        CSS.decl("margin", "6px 0")
                    ),

                    CSS.rule(
                        ".\(block)__item--group",
                        CSS.decl("margin", "12px 0 18px")
                    ),

                    CSS.rule(
                        ".\(block)__link, .\(block)__label",
                        CSS.decl("display", "block"),
                        CSS.decl("box-sizing", "border-box"),
                        CSS.decl("border-radius", "10px"),
                        CSS.decl("padding", "8px 10px"),
                        CSS.decl("color", "var(--text-color)"),
                        CSS.decl("text-decoration", "none"),
                        CSS.decl("font-weight", "700")
                    ),

                    CSS.rule(
                        ".\(block)__link:hover",
                        CSS.decl("background", "color-mix(in srgb, var(--text-color) 8%, transparent)")
                    ),

                    CSS.rule(
                        ".\(block)__sublist",
                        CSS.decl("margin", "4px 0 0 12px"),
                        CSS.decl("padding-left", "10px"),
                        CSS.decl("border-left", "1px solid var(--border-color)")
                    ),

                    CSS.rule(
                        ".\(block)__sublist .\(block)__link",
                        CSS.decl("font-weight", "600"),
                        CSS.decl("color", "var(--muted-text-color)")
                    )
                )
            ]
        )
    }
}
