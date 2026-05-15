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

    public let searchProjectsPlaceholder: String
    public let searchProjectsAriaLabel: String
    public let searchKnowledgeBasePlaceholder: String
    public let searchKnowledgeBaseAriaLabel: String
    public let searchButton: String

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
        searchProjectsPlaceholder: String,
        searchProjectsAriaLabel: String,
        searchKnowledgeBasePlaceholder: String,
        searchKnowledgeBaseAriaLabel: String,
        searchButton: String
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
        self.searchProjectsPlaceholder = searchProjectsPlaceholder
        self.searchProjectsAriaLabel = searchProjectsAriaLabel
        self.searchKnowledgeBasePlaceholder = searchKnowledgeBasePlaceholder
        self.searchKnowledgeBaseAriaLabel = searchKnowledgeBaseAriaLabel
        self.searchButton = searchButton
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
        searchProjectsPlaceholder: "Search projects...",
        searchProjectsAriaLabel: "Search docs projects",
        searchKnowledgeBasePlaceholder: "Search knowledge base...",
        searchKnowledgeBaseAriaLabel: "Search knowledge base",
        searchButton: "Search"
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
        searchProjectsPlaceholder: "Zoek onderdelen...",
        searchProjectsAriaLabel: "Zoek in documentatieonderdelen",
        searchKnowledgeBasePlaceholder: "Zoek in de kennisbank...",
        searchKnowledgeBaseAriaLabel: "Zoek in de kennisbank",
        searchButton: "Zoeken"
    )
}
