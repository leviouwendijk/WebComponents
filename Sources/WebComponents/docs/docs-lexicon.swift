public enum DocsThemeToggleLabelStyle: String, Sendable {
    case symbols
    case words
}

public struct DocsLexicon: Sendable {
    public let docs: String
    public let allDocs: String
    public let projectHome: String
    public let projects: String

    public let docsContextAriaLabel: String
    public let categoryNavAriaLabel: String
    public let tocTitle: String
    public let contentKicker: String

    public let referencesTitle: String
    public let footnotesTitle: String

    public let searchProjectsPlaceholder: String
    public let searchProjectsAriaLabel: String
    public let searchKnowledgeBasePlaceholder: String
    public let searchKnowledgeBaseAriaLabel: String
    public let searchButton: String

    public let lightModeLabel: String
    public let darkModeLabel: String
    public let lightModeSymbol: String
    public let darkModeSymbol: String
    public let themeToggleLabelStyle: DocsThemeToggleLabelStyle

    public let categorySingularLabel: String
    public let categoryPluralLabel: String
    public let entrySingularLabel: String
    public let entryPluralLabel: String
    public let definitionSingularLabel: String
    public let definitionPluralLabel: String
    public let definitionRelatedLinksLabel: String
    public let aiContentNoticeTitle: String
    public let aiContentNoticeMessage: String

    public init(
        docs: String,
        allDocs: String,
        projectHome: String,
        projects: String,
        docsContextAriaLabel: String,
        categoryNavAriaLabel: String,
        tocTitle: String,
        contentKicker: String,
        referencesTitle: String,
        footnotesTitle: String,
        searchProjectsPlaceholder: String,
        searchProjectsAriaLabel: String,
        searchKnowledgeBasePlaceholder: String,
        searchKnowledgeBaseAriaLabel: String,
        searchButton: String,
        lightModeLabel: String,
        darkModeLabel: String,
        lightModeSymbol: String = "☀︎",
        darkModeSymbol: String = "☾",
        themeToggleLabelStyle: DocsThemeToggleLabelStyle = .symbols,
        categorySingularLabel: String,
        categoryPluralLabel: String,
        entrySingularLabel: String,
        entryPluralLabel: String,
        definitionSingularLabel: String,
        definitionPluralLabel: String,
        definitionRelatedLinksLabel: String,
        aiContentNoticeTitle: String = "AI-assisted content",
        aiContentNoticeMessage: String = "This section was created in whole or in part with the assistance of artificial intelligence and may therefore contain errors. This notice applies only to the content on which it is displayed and does not apply to other parts of this documentation."
    ) {
        self.docs = docs
        self.allDocs = allDocs
        self.projectHome = projectHome
        self.projects = projects
        self.docsContextAriaLabel = docsContextAriaLabel
        self.categoryNavAriaLabel = categoryNavAriaLabel
        self.tocTitle = tocTitle
        self.contentKicker = contentKicker
        self.referencesTitle = referencesTitle
        self.footnotesTitle = footnotesTitle
        self.searchProjectsPlaceholder = searchProjectsPlaceholder
        self.searchProjectsAriaLabel = searchProjectsAriaLabel
        self.searchKnowledgeBasePlaceholder = searchKnowledgeBasePlaceholder
        self.searchKnowledgeBaseAriaLabel = searchKnowledgeBaseAriaLabel
        self.searchButton = searchButton
        self.lightModeLabel = lightModeLabel
        self.darkModeLabel = darkModeLabel
        self.lightModeSymbol = lightModeSymbol
        self.darkModeSymbol = darkModeSymbol
        self.themeToggleLabelStyle = themeToggleLabelStyle
        self.categorySingularLabel = categorySingularLabel
        self.categoryPluralLabel = categoryPluralLabel
        self.entrySingularLabel = entrySingularLabel
        self.entryPluralLabel = entryPluralLabel
        self.definitionSingularLabel = definitionSingularLabel
        self.definitionPluralLabel = definitionPluralLabel
        self.definitionRelatedLinksLabel = definitionRelatedLinksLabel
        self.aiContentNoticeTitle = aiContentNoticeTitle
        self.aiContentNoticeMessage = aiContentNoticeMessage
    }

    public func lightModeDisplayLabel(
        style: DocsThemeToggleLabelStyle? = nil
    ) -> String {
        switch style ?? themeToggleLabelStyle {
        case .symbols:
            return lightModeSymbol
        case .words:
            return lightModeLabel
        }
    }

    public func darkModeDisplayLabel(
        style: DocsThemeToggleLabelStyle? = nil
    ) -> String {
        switch style ?? themeToggleLabelStyle {
        case .symbols:
            return darkModeSymbol
        case .words:
            return darkModeLabel
        }
    }

    public func categoryCountLabel(
        _ count: Int
    ) -> String {
        countLabel(
            count,
            singular: categorySingularLabel,
            plural: categoryPluralLabel
        )
    }

    public func entryCountLabel(
        _ count: Int
    ) -> String {
        countLabel(
            count,
            singular: entrySingularLabel,
            plural: entryPluralLabel
        )
    }

    private func countLabel(
        _ count: Int,
        singular: String,
        plural: String
    ) -> String {
        "\(count) \(count == 1 ? singular : plural)"
    }

    public static let english = DocsLexicon(
        docs: "Docs",
        allDocs: "~",
        projectHome: "Project home",
        projects: "Projects",
        docsContextAriaLabel: "Docs context",
        categoryNavAriaLabel: "Knowledge base sections",
        tocTitle: "Contents",
        contentKicker: "Knowledge base",
        referencesTitle: "References",
        footnotesTitle: "Footnotes",
        searchProjectsPlaceholder: "Search projects...",
        searchProjectsAriaLabel: "Search docs projects",
        searchKnowledgeBasePlaceholder: "Search knowledge base...",
        searchKnowledgeBaseAriaLabel: "Search knowledge base",
        searchButton: "Search",
        lightModeLabel: "Light",
        darkModeLabel: "Dark",
        lightModeSymbol: "☀︎",
        darkModeSymbol: "☾",
        themeToggleLabelStyle: .symbols,
        categorySingularLabel: "category",
        categoryPluralLabel: "categories",
        entrySingularLabel: "entry",
        entryPluralLabel: "entries",
        definitionSingularLabel: "Definition",
        definitionPluralLabel: "Definitions",
        definitionRelatedLinksLabel: "See also",
        aiContentNoticeTitle: "AI-assisted content",
        aiContentNoticeMessage: "This section was created in whole or in part with the assistance of artificial intelligence and may therefore contain errors. This notice applies only to the content on which it is displayed and does not apply to other parts of this documentation."
    )

    public static let dutch = DocsLexicon(
        docs: "Documentatie",
        allDocs: "~",
        projectHome: "Projectoverzicht",
        projects: "Onderdelen",
        docsContextAriaLabel: "Documentatiecontext",
        categoryNavAriaLabel: "Kennisbankonderdelen",
        tocTitle: "Inhoud",
        contentKicker: "Kennisbank",
        referencesTitle: "Referenties",
        footnotesTitle: "Voetnoten",
        searchProjectsPlaceholder: "Zoek onderdelen...",
        searchProjectsAriaLabel: "Zoek in documentatieonderdelen",
        searchKnowledgeBasePlaceholder: "Zoek in de kennisbank...",
        searchKnowledgeBaseAriaLabel: "Zoek in de kennisbank",
        searchButton: "Zoeken",
        lightModeLabel: "licht",
        darkModeLabel: "donker",
        lightModeSymbol: "☀︎",
        darkModeSymbol: "☾",
        themeToggleLabelStyle: .symbols,
        categorySingularLabel: "categorie",
        categoryPluralLabel: "categorieën",
        entrySingularLabel: "onderdeel",
        entryPluralLabel: "onderdelen",
        definitionSingularLabel: "Definitie",
        definitionPluralLabel: "Definities",
        definitionRelatedLinksLabel: "Raadpleeg ook",
        aiContentNoticeTitle: "Bevat AI-gegenereerde inhoud",
        aiContentNoticeMessage: "Dit onderdeel is geheel of gedeeltelijk tot stand gekomen met behulp van kunstmatige intelligentie en kan daarom fouten bevatten. Deze melding geldt uitsluitend voor de inhoud waarbij zij wordt weergegeven en zegt niets over andere onderdelen van deze documentatie."
    )
}
