import Constructors
import HTML
import Primitives

public struct DocsKnowledgeBase: Sendable {
    public let title: String
    public let subtitle: String?
    public let homeHref: String
    public let categories: [DocsCategory]
    public let visibility: Set<BuildEnvironment>

    public init(
        title: String,
        subtitle: String? = nil,
        homeHref: String = "/",
        categories: [DocsCategory],
        visibility: Set<BuildEnvironment> = DocsVisibility.live
    ) {
        self.title = title
        self.subtitle = subtitle
        self.homeHref = homeHref
        self.categories = categories
        self.visibility = visibility
    }

    public func isVisible(
        in environment: BuildEnvironment
    ) -> Bool {
        visibility.contains(environment)
    }

    public func visible(
        in environment: BuildEnvironment
    ) -> DocsKnowledgeBase? {
        guard isVisible(in: environment) else {
            return nil
        }

        return DocsKnowledgeBase(
            title: title,
            subtitle: subtitle,
            homeHref: homeHref,
            categories: categories.compactMap { category in
                category.visible(in: environment)
            },
            visibility: visibility
        )
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
    public let subtitle: String?
    public let description: String
    public let href: String
    public let sections: [DocsSection]
    public let visibility: Set<BuildEnvironment>

    public init(
        id: String,
        label: String,
        subtitle: String? = nil,
        description: String,
        href: String,
        sections: [DocsSection],
        visibility: Set<BuildEnvironment> = DocsVisibility.live
    ) {
        self.id = id
        self.label = label
        self.subtitle = subtitle
        self.description = description
        self.href = href
        self.sections = sections
        self.visibility = visibility
    }

    public func isVisible(
        in environment: BuildEnvironment
    ) -> Bool {
        visibility.contains(environment)
    }

    public func visible(
        in environment: BuildEnvironment
    ) -> DocsCategory? {
        guard isVisible(in: environment) else {
            return nil
        }

        return DocsCategory(
            id: id,
            label: label,
            subtitle: subtitle,
            description: description,
            href: href,
            sections: sections.compactMap { section in
                section.visible(in: environment)
            },
            visibility: visibility
        )
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
    public let visibility: Set<BuildEnvironment>

    public init(
        id: String,
        title: String,
        summary: String? = nil,
        items: [DocsItem],
        visibility: Set<BuildEnvironment> = DocsVisibility.live
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.items = items
        self.visibility = visibility
    }

    public func isVisible(
        in environment: BuildEnvironment
    ) -> Bool {
        visibility.contains(environment)
    }

    public func visible(
        in environment: BuildEnvironment
    ) -> DocsSection? {
        guard isVisible(in: environment) else {
            return nil
        }

        return DocsSection(
            id: id,
            title: title,
            summary: summary,
            items: items.compactMap { item in
                item.visible(in: environment)
            },
            visibility: visibility
        )
    }
}

public struct DocsItem: Sendable {
    public let id: String
    public let title: String
    public let summary: String
    public let href: String
    public let body: @Sendable () -> HTMLFragment
    public let visibility: Set<BuildEnvironment>

    public init(
        id: String,
        title: String,
        summary: String,
        href: String? = nil,
        visibility: Set<BuildEnvironment> = DocsVisibility.live,
        body: @escaping @Sendable () -> HTMLFragment = { [] }
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.href = href ?? "#\(id)"
        self.visibility = visibility
        self.body = body
    }

    public func isVisible(
        in environment: BuildEnvironment
    ) -> Bool {
        visibility.contains(environment)
    }

    public func visible(
        in environment: BuildEnvironment
    ) -> DocsItem? {
        guard isVisible(in: environment) else {
            return nil
        }

        return self
    }
}
