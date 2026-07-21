import Constructors
import CSS
import HTML
import JS

public enum DocsCategoryContentMode: Sendable {
    case scrollDocument
    case definitionsIndex
}

public struct DocsCategoryPane: ReusableComponent {
    public enum Surface: Sendable {
        case page
        case embedded(id: String)
    }

    public let category: DocsCategory
    public let mode: DocsCategoryContentMode
    public let surface: Surface
    public let currentHref: String?
    public let lexicon: DocsLexicon
    public let definitionRelatedLinks: DocsDefinitionRelatedLinkProvider
    public let includeReferences: Bool
    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        category: DocsCategory,
        mode: DocsCategoryContentMode = .scrollDocument,
        surface: Surface = .page,
        currentHref: String? = nil,
        lexicon: DocsLexicon = .english,
        definitionRelatedLinks: @escaping DocsDefinitionRelatedLinkProvider = { _, _ in [] },
        includeReferences: Bool = true,
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
        self.category = category
        self.mode = mode
        self.surface = surface
        self.currentHref = currentHref
        self.lexicon = lexicon
        self.definitionRelatedLinks = definitionRelatedLinks
        self.includeReferences = includeReferences
        self.includeStyles = includeStyles
        self.includeScript = includeScript
    }

    public var nodes: ReusableComponentNodes {
        let contentNodes = content()
        let tocNodes = DocsScopedTOC(
            id: tocID,
            navigation: navigation(),
            title: lexicon.tocTitle,
            currentHref: currentHref,
            includeStyles: false
        ).nodes

        return .init(
            head: tocNodes.head + contentNodes.head,
            body: [
                HTML.div(rootAttributes()) {
                    tocNodes.body
                    contentNodes.body
                }
            ],
            stylesheets: stylesheets(
                content: contentNodes
            ),
            scripts: scripts(
                content: contentNodes
            )
        )
    }

    private var embeddedID: String? {
        switch surface {
        case .page:
            return nil

        case .embedded(let id):
            return id
        }
    }

    private var tocID: String {
        guard let embeddedID else {
            return "toc"
        }

        return "\(embeddedID)-toc"
    }

    private var documentSurface: DocsScrollDocument.Surface {
        guard let embeddedID else {
            return .page
        }

        return .embedded(
            id: "\(embeddedID)-document"
        )
    }

    private func navigation() -> NavigationStructure {
        switch mode {
        case .scrollDocument:
            return DocsScrollDocument(
                category: category,
                lexicon: lexicon,
                surface: documentSurface,
                includeReferences: includeReferences,
                includeStyles: false,
                includeScript: false
            )
            .navigation(
                includeReferencesTitle: lexicon.referencesTitle
            )

        case .definitionsIndex:
            return category.navigation
        }
    }

    private func content() -> ReusableComponentNodes {
        switch mode {
        case .scrollDocument:
            return DocsScrollDocument(
                category: category,
                lexicon: lexicon,
                surface: documentSurface,
                includeReferences: includeReferences,
                includeStyles: includeStyles,
                includeScript: includeScript
            ).nodes

        case .definitionsIndex:
            return DocsDefinitionIndex(
                category: category,
                lexicon: lexicon,
                relatedLinks: definitionRelatedLinks,
                includeStyles: includeStyles
            ).nodes
        }
    }

    private func rootAttributes() -> HTMLAttribute {
        switch surface {
        case .page:
            return [
                "class": "container wc-docs-category-pane wc-docs-category-pane--page",
                "data-wc-docs-category-pane": category.id,
                "data-docs-category-pane-surface": "page"
            ]

        case .embedded(let id):
            return [
                "id": id,
                "class": "wc-docs-category-pane wc-docs-category-pane--embedded",
                "data-wc-docs-category-pane": category.id,
                "data-docs-category-pane-surface": "embedded"
            ]
        }
    }

    private func stylesheets(
        content: ReusableComponentNodes
    ) -> [CSSStyleSheet] {
        guard includeStyles else {
            return []
        }

        var sheets: [CSSStyleSheet] = [
            DocsScopedTOC.stylesheet(),
            Self.stylesheet()
        ]

        if case .definitionsIndex = mode {
            sheets += [
                HoverPreviewLink.stylesheet(),
                DocsDefinitionCard.stylesheet()
            ]
        }

        sheets += content.stylesheets

        return sheets
    }

    private func scripts(
        content: ReusableComponentNodes
    ) -> [JSScript] {
        guard includeScript else {
            return []
        }

        var scripts: [JSScript] = []

        if case .page = surface {
            scripts += DocsMobileTOCMenuScript().nodes.scripts

            if case .scrollDocument = mode {
                scripts += DocsReadingPreferencesScript().nodes.scripts
            }
        }

        scripts += content.scripts

        return scripts
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-docs-category-pane",
                    CSS.decl("display", "grid"),
                    CSS.decl(
                        "grid-template-columns",
                        "280px minmax(0, 1fr)"
                    ),
                    CSS.decl("gap", "0"),
                    CSS.decl("width", "min(1280px, 100%)"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".wc-docs-category-pane > *",
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".wc-docs-category-pane--embedded",
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "100%"),
                    CSS.decl("min-height", "0"),
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    ".wc-docs-category-pane--embedded .wc-docs-toc",
                    CSS.decl("position", "sticky"),
                    CSS.decl("top", "0"),
                    CSS.decl("left", "auto"),
                    CSS.decl("right", "auto"),
                    CSS.decl("bottom", "auto"),
                    CSS.decl("z-index", "1"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "100%"),
                    CSS.decl("max-height", "100%"),
                    CSS.decl("transform", "none"),
                    CSS.decl("border-top", "0")
                ),

                CSS.rule(
                    ".wc-docs-category-pane--embedded .wc-docs-scroll-document--embedded",
                    CSS.decl("min-width", "0")
                )
            ],

            media: [
                CSS.media(
                    "(max-width: 1200px)",

                    CSS.rule(
                        ".wc-docs-category-pane--page",
                        CSS.decl("display", "block"),
                        CSS.decl("width", "100%")
                    )
                ),

                CSS.media(
                    "(max-width: 760px)",

                    CSS.rule(
                        ".wc-docs-category-pane--embedded",
                        CSS.decl(
                            "grid-template-columns",
                            "minmax(0, 1fr)"
                        )
                    ),

                    CSS.rule(
                        ".wc-docs-category-pane--embedded .wc-docs-toc",
                        CSS.decl("display", "none")
                    )
                )
            ]
        )
    }
}
