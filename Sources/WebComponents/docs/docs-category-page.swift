import Constructors
import CSS
import HTML
import JS

public struct DocsCategoryPage: ReusableComponent {
    public let knowledgeBase: DocsKnowledgeBase
    public let category: DocsCategory
    public let categoryNavCategories: [DocsCategory]?
    public let mode: DocsCategoryContentMode
    public let header: @Sendable () -> HTMLFragment
    public let currentHref: String?
    public let lexicon: DocsLexicon
    public let definitionRelatedLinks: DocsDefinitionRelatedLinkProvider

    public init(
        knowledgeBase: DocsKnowledgeBase,
        category: DocsCategory,
        categoryNavCategories: [DocsCategory]? = nil,
        mode: DocsCategoryContentMode = .scrollDocument,
        currentHref: String? = nil,
        lexicon: DocsLexicon = .english,
        definitionRelatedLinks: @escaping DocsDefinitionRelatedLinkProvider = { _, _ in [] },
        header: @escaping @Sendable () -> HTMLFragment
    ) {
        self.knowledgeBase = knowledgeBase
        self.category = category
        self.categoryNavCategories = categoryNavCategories
        self.mode = mode
        self.currentHref = currentHref
        self.lexicon = lexicon
        self.definitionRelatedLinks = definitionRelatedLinks
        self.header = header
    }

    public var nodes: ReusableComponentNodes {
        let navNodes = DocsCategoryNav(
            categories: categoryNavCategories
                ?? knowledgeBase.categories,
            activeID: category.id,
            ariaLabel: lexicon.categoryNavAriaLabel,
            includeStyles: false
        ).nodes

        let paneNodes = DocsCategoryPane(
            category: category,
            mode: mode,
            surface: .page,
            currentHref: currentHref,
            lexicon: lexicon,
            definitionRelatedLinks: definitionRelatedLinks,
            includeReferences: true,
            includeStyles: true,
            includeScript: true
        ).nodes

        let body: HTMLFragment = [
            HTML.div(
                [
                    "class": "layout docs-category-layout wc-docs-category-page",
                    "data-wc-docs-category-page": category.id
                ]
            ) {
                header()
                navNodes.body
                paneNodes.body
            }
        ]

        return .init(
            head: navNodes.head + paneNodes.head,
            body: body,
            stylesheets: [
                DocsShell.stylesheet(),
                DocsCategoryNav.stylesheet(),
                Self.stylesheet()
            ]
                + navNodes.stylesheets
                + paneNodes.stylesheets,
            scripts: DocsThemeScript().nodes.scripts
                + DocsCategoryNavScript().nodes.scripts
                + navNodes.scripts
                + paneNodes.scripts
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-docs-category-page",
                    CSS.decl("--wc-docs-header-height", "60px"),
                    CSS.decl(
                        "--wc-docs-project-context-height",
                        "44px"
                    ),
                    CSS.decl(
                        "--wc-docs-category-nav-height",
                        "66px"
                    ),
                    CSS.decl(
                        "--wc-docs-category-nav-top",
                        "calc(var(--wc-docs-header-height) + var(--wc-docs-project-context-height))"
                    ),
                    CSS.decl(
                        "--wc-docs-sticky-offset",
                        "calc(var(--wc-docs-category-nav-top) + var(--wc-docs-category-nav-height))"
                    ),
                    CSS.decl(
                        "background",
                        "var(--background-color)"
                    ),
                    CSS.decl(
                        "color",
                        "var(--text-color)"
                    )
                ),

                CSS.rule(
                    ".wc-docs-category-page .docs-project-context-nav",
                    CSS.decl(
                        "top",
                        "var(--wc-docs-header-height)"
                    ),
                    CSS.decl("z-index", "999")
                ),

                CSS.rule(
                    ".wc-docs-category-page .docs-category-nav",
                    CSS.decl(
                        "top",
                        "var(--wc-docs-category-nav-top)"
                    ),
                    CSS.decl("z-index", "998")
                ),

                CSS.rule(
                    ".wc-docs-category-page nav#toc",
                    CSS.decl(
                        "top",
                        "var(--wc-docs-sticky-offset)"
                    ),
                    CSS.decl(
                        "height",
                        "calc(100dvh - var(--wc-docs-sticky-offset))"
                    )
                ),

                CSS.rule(
                    ".wc-docs-category-page #content-area",
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".wc-docs-category-page [data-docs-section]",
                    CSS.decl(
                        "scroll-margin-top",
                        "calc(var(--wc-docs-sticky-offset) + 24px)"
                    )
                )
            ],

            media: [
                CSS.media(
                    "(max-width: 720px)",

                    CSS.rule(
                        ".wc-docs-category-page",
                        CSS.decl(
                            "--wc-docs-category-nav-height",
                            "46px"
                        )
                    )
                )
            ]
        )
    }
}
