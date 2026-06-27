import HTML
import Primitives

public struct DocsSite: Sendable {
    public let id: String
    public let title: String
    public let homeHref: String
    public let projects: [DocsProject]
    public let visibility: Set<BuildEnvironment>

    public init(
        id: String,
        title: String,
        homeHref: String = "/",
        projects: [DocsProject],
        visibility: Set<BuildEnvironment> = DocsVisibility.live
    ) {
        self.id = id
        self.title = title
        self.homeHref = homeHref
        self.projects = projects
        self.visibility = visibility
    }

    public func isVisible(
        in environment: BuildEnvironment
    ) -> Bool {
        visibility.contains(environment)
    }

    public func visible(
        in environment: BuildEnvironment
    ) -> DocsSite {
        guard isVisible(in: environment) else {
            return DocsSite(
                id: id,
                title: title,
                homeHref: homeHref,
                projects: [],
                visibility: visibility
            )
        }

        return DocsSite(
            id: id,
            title: title,
            homeHref: homeHref,
            projects: projects.compactMap { project in
                project.visible(in: environment)
            },
            visibility: visibility
        )
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
    public let visibility: Set<BuildEnvironment>

    public init(
        id: String,
        label: String,
        description: String,
        href: String,
        visibility: Set<BuildEnvironment> = DocsVisibility.live,
        knowledgeBase: DocsKnowledgeBase
    ) {
        self.id = id
        self.label = label
        self.description = description
        self.href = href
        self.visibility = visibility
        self.knowledgeBase = knowledgeBase
    }

    public func isVisible(
        in environment: BuildEnvironment
    ) -> Bool {
        visibility.contains(environment)
    }

    public func visible(
        in environment: BuildEnvironment
    ) -> DocsProject? {
        guard isVisible(in: environment) else {
            return nil
        }

        guard let visibleKnowledgeBase = knowledgeBase.visible(in: environment) else {
            return nil
        }

        return DocsProject(
            id: id,
            label: label,
            description: description,
            href: href,
            visibility: visibility,
            knowledgeBase: visibleKnowledgeBase
        )
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

public struct DocsNavigationCrumb: Sendable {
    public let label: String
    public let href: String?
    public let isCurrent: Bool

    public init(
        label: String,
        href: String? = nil,
        isCurrent: Bool = false
    ) {
        self.label = label
        self.href = href
        self.isCurrent = isCurrent
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
    public let parentBreadcrumbs: [DocsNavigationCrumb]
    public let extraBreadcrumbs: [DocsNavigationCrumb]

    public init(
        surface: DocsNavigationSurface,
        activeProjectID: String? = nil,
        activeCategoryID: String? = nil,
        parentBreadcrumbs: [DocsNavigationCrumb] = [],
        extraBreadcrumbs: [DocsNavigationCrumb] = []
    ) {
        self.surface = surface
        self.activeProjectID = activeProjectID
        self.activeCategoryID = activeCategoryID
        self.parentBreadcrumbs = parentBreadcrumbs
        self.extraBreadcrumbs = extraBreadcrumbs
    }

    public static func siteHub(
        parentBreadcrumbs: [DocsNavigationCrumb] = []
    ) -> Self {
        Self(
            surface: .siteHub,
            parentBreadcrumbs: parentBreadcrumbs
        )
    }

    public static func sitePage(
        label: String,
        href: String? = nil,
        parentBreadcrumbs: [DocsNavigationCrumb] = []
    ) -> Self {
        Self(
            surface: .siteHub,
            parentBreadcrumbs: parentBreadcrumbs,
            extraBreadcrumbs: [
                DocsNavigationCrumb(
                    label: label,
                    href: href,
                    isCurrent: true
                )
            ]
        )
    }

    public static func projectHub(
        _ project: DocsProject,
        parentBreadcrumbs: [DocsNavigationCrumb] = []
    ) -> Self {
        Self(
            surface: .projectHub,
            activeProjectID: project.id,
            parentBreadcrumbs: parentBreadcrumbs
        )
    }

    public static func categoryPage(
        project: DocsProject,
        category: DocsCategory,
        parentBreadcrumbs: [DocsNavigationCrumb] = []
    ) -> Self {
        Self(
            surface: .categoryPage,
            activeProjectID: project.id,
            activeCategoryID: category.id,
            parentBreadcrumbs: parentBreadcrumbs
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
