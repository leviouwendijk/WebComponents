import HTML

public struct DocsSite: Sendable {
    public let id: String
    public let title: String
    public let homeHref: String
    public let projects: [DocsProject]

    public init(
        id: String,
        title: String,
        homeHref: String = "/",
        projects: [DocsProject]
    ) {
        self.id = id
        self.title = title
        self.homeHref = homeHref
        self.projects = projects
    }

    public func project(
        id: String?
    ) -> DocsProject? {
        guard let id else {
            return nil
        }

        return projects.first { project in
            project.id == id
        }
    }
}

public struct DocsProject: Sendable {
    public let id: String
    public let label: String
    public let description: String
    public let href: String
    public let knowledgeBase: DocsKnowledgeBase

    public init(
        id: String,
        label: String,
        description: String,
        href: String,
        knowledgeBase: DocsKnowledgeBase
    ) {
        self.id = id
        self.label = label
        self.description = description
        self.href = href
        self.knowledgeBase = knowledgeBase
    }

    public var categoryCount: Int {
        knowledgeBase.categories.count
    }

    public var itemCount: Int {
        knowledgeBase.categories.reduce(0) { partial, category in
            partial + category.items.count
        }
    }

    public func category(
        id: String?
    ) -> DocsCategory? {
        guard let id else {
            return nil
        }

        return knowledgeBase.categories.first { category in
            category.id == id
        }
    }
}

public enum DocsSiteContent: Sendable {
    case single(DocsKnowledgeBase)
    case projects([DocsProject])

    public var projects: [DocsProject] {
        switch self {
        case .single:
            return []

        case .projects(let projects):
            return projects
        }
    }

    public var singleKnowledgeBase: DocsKnowledgeBase? {
        switch self {
        case .single(let knowledgeBase):
            return knowledgeBase

        case .projects:
            return nil
        }
    }
}

public enum DocsNavigationSurface: Sendable {
    case siteHub
    case projectHub
    case categoryPage
}

public struct DocsNavigationContext: Sendable {
    public let surface: DocsNavigationSurface
    public let activeProjectID: String?
    public let activeCategoryID: String?

    public init(
        surface: DocsNavigationSurface,
        activeProjectID: String? = nil,
        activeCategoryID: String? = nil
    ) {
        self.surface = surface
        self.activeProjectID = activeProjectID
        self.activeCategoryID = activeCategoryID
    }

    public static func siteHub() -> Self {
        Self(
            surface: .siteHub
        )
    }

    public static func projectHub(
        _ project: DocsProject
    ) -> Self {
        Self(
            surface: .projectHub,
            activeProjectID: project.id
        )
    }

    public static func categoryPage(
        project: DocsProject,
        category: DocsCategory
    ) -> Self {
        Self(
            surface: .categoryPage,
            activeProjectID: project.id,
            activeCategoryID: category.id
        )
    }

    public func activeProject(
        in site: DocsSite
    ) -> DocsProject? {
        site.project(
            id: activeProjectID
        )
    }

    public func activeCategory(
        in site: DocsSite
    ) -> DocsCategory? {
        activeProject(in: site)?.category(
            id: activeCategoryID
        )
    }
}
