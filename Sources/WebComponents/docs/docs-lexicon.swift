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

    public let categorySingularLabel: String
    public let categoryPluralLabel: String
    public let entrySingularLabel: String
    public let entryPluralLabel: String
    public let definitionSingularLabel: String
    public let definitionPluralLabel: String
    public let definitionRelatedLinksLabel: String

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
        categorySingularLabel: String,
        categoryPluralLabel: String,
        entrySingularLabel: String,
        entryPluralLabel: String,
        definitionSingularLabel: String,
        definitionPluralLabel: String,
        definitionRelatedLinksLabel: String
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
        self.categorySingularLabel = categorySingularLabel
        self.categoryPluralLabel = categoryPluralLabel
        self.entrySingularLabel = entrySingularLabel
        self.entryPluralLabel = entryPluralLabel
        self.definitionSingularLabel = definitionSingularLabel
        self.definitionPluralLabel = definitionPluralLabel
        self.definitionRelatedLinksLabel = definitionRelatedLinksLabel
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
        allDocs: "All docs",
        projectHome: "Project home",
        projects: "Projects",
        docsContextAriaLabel: "Docs context",
        categoryNavAriaLabel: "Knowledge base sections",
        tocTitle: "Contents",
        contentKicker: "Knowledge base",
        referencesTitle: "References",
        footnotesTitle: "Notes",
        searchProjectsPlaceholder: "Search projects...",
        searchProjectsAriaLabel: "Search docs projects",
        searchKnowledgeBasePlaceholder: "Search knowledge base...",
        searchKnowledgeBaseAriaLabel: "Search knowledge base",
        searchButton: "Search",
        lightModeLabel: "Light",
        darkModeLabel: "Dark",
        categorySingularLabel: "category",
        categoryPluralLabel: "categories",
        entrySingularLabel: "entry",
        entryPluralLabel: "entries",
        definitionSingularLabel: "Definition",
        definitionPluralLabel: "Definitions",
        definitionRelatedLinksLabel: "See also"
    )

    public static let dutch = DocsLexicon(
        docs: "Documentatie",
        allDocs: "Alle documentatie",
        projectHome: "Projectoverzicht",
        projects: "Onderdelen",
        docsContextAriaLabel: "Documentatiecontext",
        categoryNavAriaLabel: "Kennisbankonderdelen",
        tocTitle: "Inhoud",
        contentKicker: "Kennisbank",
        referencesTitle: "Referenties",
        footnotesTitle: "Noten",
        searchProjectsPlaceholder: "Zoek onderdelen...",
        searchProjectsAriaLabel: "Zoek in documentatieonderdelen",
        searchKnowledgeBasePlaceholder: "Zoek in de kennisbank...",
        searchKnowledgeBaseAriaLabel: "Zoek in de kennisbank",
        searchButton: "Zoeken",
        lightModeLabel: "Licht",
        darkModeLabel: "Donker",
        categorySingularLabel: "categorie",
        categoryPluralLabel: "categorieën",
        entrySingularLabel: "onderdeel",
        entryPluralLabel: "onderdelen",
        definitionSingularLabel: "Definitie",
        definitionPluralLabel: "Definities",
        definitionRelatedLinksLabel: "Raadpleeg ook"
    )
}
