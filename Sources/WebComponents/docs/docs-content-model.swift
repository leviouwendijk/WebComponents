import Constructors
import HTML

public struct DocsKnowledgeBase: Sendable {
    public let title: String
    public let subtitle: String?
    public let homeHref: String
    public let categories: [DocsCategory]

    public init(
        title: String,
        subtitle: String? = nil,
        homeHref: String = "/",
        categories: [DocsCategory]
    ) {
        self.title = title
        self.subtitle = subtitle
        self.homeHref = homeHref
        self.categories = categories
    }

    public func category(
        id: String
    ) -> DocsCategory? {
        categories.first { category in
            category.id == id
        }
    }
}

public struct DocsCategory: Sendable {
    public let id: String
    public let label: String
    public let description: String
    public let href: String
    public let sections: [DocsSection]

    public init(
        id: String,
        label: String,
        description: String,
        href: String,
        sections: [DocsSection]
    ) {
        self.id = id
        self.label = label
        self.description = description
        self.href = href
        self.sections = sections
    }

    public var items: [DocsItem] {
        sections.flatMap { section in
            section.items
        }
    }

    public var navigation: NavigationStructure {
        NavigationStructure(
            roots: sections.map { section in
                NavigationNode(
                    label: section.title,
                    children: section.items.map { item in
                        NavigationNode(
                            label: item.title,
                            path: item.href
                        )
                    }
                )
            }
        )
    }
}

public struct DocsSection: Sendable {
    public let id: String
    public let title: String
    public let summary: String?
    public let items: [DocsItem]

    public init(
        id: String,
        title: String,
        summary: String? = nil,
        items: [DocsItem]
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.items = items
    }
}

public struct DocsItem: Sendable {
    public let id: String
    public let title: String
    public let summary: String
    public let href: String
    public let body: @Sendable () -> HTMLFragment

    public init(
        id: String,
        title: String,
        summary: String,
        href: String? = nil,
        body: @escaping @Sendable () -> HTMLFragment = { [] }
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.href = href ?? "#\(id)"
        self.body = body
    }
}
