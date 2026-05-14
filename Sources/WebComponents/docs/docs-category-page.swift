import Constructors
import CSS
import HTML
import JS

public enum DocsCategoryContentMode: Sendable {
    case scrollDocument
    case definitionsIndex
}

public struct DocsCategoryPage: ReusableComponent {
    public let knowledgeBase: DocsKnowledgeBase
    public let category: DocsCategory
    public let mode: DocsCategoryContentMode
    public let header: @Sendable () -> HTMLFragment
    public let currentHref: String?

    public init(
        knowledgeBase: DocsKnowledgeBase,
        category: DocsCategory,
        mode: DocsCategoryContentMode = .scrollDocument,
        currentHref: String? = nil,
        header: @escaping @Sendable () -> HTMLFragment
    ) {
        self.knowledgeBase = knowledgeBase
        self.category = category
        self.mode = mode
        self.currentHref = currentHref
        self.header = header
    }

    public var nodes: ReusableComponentNodes {
        let nav = DocsCategoryNav(
            categories: knowledgeBase.categories,
            activeID: category.id,
            includeStyles: false
        )

        let toc = DocsScopedTOC(
            navigation: category.navigation,
            currentHref: currentHref,
            includeStyles: false
        )

        let contentNodes = content()

        let body: HTMLFragment = [
            HTML.div(
                [
                    "class": "layout docs-category-layout wc-docs-category-page",
                    "data-wc-docs-category-page": category.id
                ]
            ) {
                header()
                nav.nodes.body

                HTML.div(["class": "container"]) {
                    toc.nodes.body
                    contentNodes.body
                }
            }
        ]

        return .body(
            body,
            stylesheets: stylesheets(contentNodes),
            scripts: scripts(contentNodes)
        )
    }

    private func content() -> ReusableComponentNodes {
        switch mode {
        case .scrollDocument:
            return DocsScrollDocument(
                category: category,
                includeStyles: false,
                includeScript: false
            ).nodes

        case .definitionsIndex:
            return DocsDefinitionIndex(
                category: category,
                includeStyles: false
            ).nodes
        }
    }

    private func stylesheets(
        _ content: ReusableComponentNodes
    ) -> [CSSStyleSheet] {
        var sheets: [CSSStyleSheet] = [
            DocsShell.stylesheet(),
            DocsCategoryNav.stylesheet(),
            DocsScopedTOC.stylesheet(),
            Self.stylesheet()
        ]

        switch mode {
        case .scrollDocument:
            sheets.append(DocsScrollDocument.stylesheet())

        case .definitionsIndex:
            sheets.append(DocsDefinitionIndex.stylesheet())
            sheets.append(DocsDefinitionCard.stylesheet())
        }

        sheets += content.stylesheets
        return sheets
    }

    private func scripts(
        _ content: ReusableComponentNodes
    ) -> [JSScript] {
        var out: [JSScript] = []
        out += DocsThemeScript().nodes.scripts
        out += DocsMobileTOCMenuScript().nodes.scripts
        out += DocsScrollSpyScript().nodes.scripts
        out += content.scripts
        return out
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-docs-category-page",
                    CSS.decl("--wc-docs-header-height", "60px"),
                    CSS.decl("--wc-docs-project-context-height", "44px"),
                    CSS.decl("--wc-docs-category-nav-height", "52px"),
                    CSS.decl(
                        "--wc-docs-category-nav-top",
                        "calc(var(--wc-docs-header-height) + var(--wc-docs-project-context-height))"
                    ),
                    CSS.decl(
                        "--wc-docs-sticky-offset",
                        "calc(var(--wc-docs-category-nav-top) + var(--wc-docs-category-nav-height))"
                    ),
                    CSS.decl("background", "var(--background-color)"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".wc-docs-category-page .docs-project-context-nav",
                    CSS.decl("top", "var(--wc-docs-header-height)"),
                    CSS.decl("z-index", "999")
                ),

                CSS.rule(
                    ".wc-docs-category-page .docs-category-nav",
                    CSS.decl("top", "var(--wc-docs-category-nav-top)"),
                    CSS.decl("z-index", "998")
                ),

                CSS.rule(
                    ".wc-docs-category-page nav#toc",
                    CSS.decl("top", "var(--wc-docs-sticky-offset)"),
                    CSS.decl("height", "calc(100dvh - var(--wc-docs-sticky-offset))")
                ),

                CSS.rule(
                    ".wc-docs-category-page [data-docs-section]",
                    CSS.decl("scroll-margin-top", "calc(var(--wc-docs-sticky-offset) + 24px)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".wc-docs-category-page",
                        CSS.decl("--wc-docs-category-nav-height", "46px")
                    )
                )
            ]
        )
    }
}
