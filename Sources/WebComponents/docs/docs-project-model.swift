import HTML

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
