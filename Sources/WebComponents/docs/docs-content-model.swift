import Constructors
import HTML
import Primitives

public enum DocsSectionPresentation: Sendable {
    case chapter
    case structural
    case group
}

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
    public let notice: @Sendable () -> HTMLFragment
    public let sections: [DocsSection]
    public let reading: DocsReadingConfiguration
    public let articleMeta: DocsArticleMeta?
    public let articleAuthors: [ArticleAuthorSection.Author]
    public let visibility: Set<BuildEnvironment>

    public init(
        id: String,
        label: String,
        subtitle: String? = nil,
        description: String,
        href: String,
        notice: @escaping @Sendable () -> HTMLFragment = { [] },
        sections: [DocsSection],
        reading: DocsReadingConfiguration = .disabled,
        articleMeta: DocsArticleMeta? = nil,
        articleAuthors: [ArticleAuthorSection.Author] = [],
        visibility: Set<BuildEnvironment> = DocsVisibility.live
    ) {
        self.id = id
        self.label = label
        self.subtitle = subtitle
        self.description = description
        self.href = href
        self.notice = notice
        self.sections = sections
        self.reading = reading
        self.articleMeta = articleMeta
        self.articleAuthors = articleAuthors
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
            notice: notice,
            sections: sections.compactMap { section in
                section.visible(in: environment)
            },
            reading: reading,
            articleMeta: articleMeta,
            articleAuthors: articleAuthors,
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
            roots: sections.flatMap { section in
                switch section.presentation {
                case .chapter, .group:
                    return [
                        NavigationNode(
                            label: section.title,
                            children: section.items.map { item in
                                NavigationNode(
                                    label: item.title,
                                    path: item.href
                                )
                            }
                        )
                    ]

                case .structural:
                    return section.items.map { item in
                        NavigationNode(
                            label: item.title,
                            path: item.href
                        )
                    }
                }
            }
        )
    }
}

public struct DocsSection: Sendable {
    public let id: String
    public let title: String
    public let summary: String?
    public let items: [DocsItem]
    public let presentation: DocsSectionPresentation
    public let visibility: Set<BuildEnvironment>

    public init(
        id: String,
        title: String,
        summary: String? = nil,
        items: [DocsItem],
        presentation: DocsSectionPresentation = .chapter,
        visibility: Set<BuildEnvironment> = DocsVisibility.live
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.items = items
        self.presentation = presentation
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
            presentation: presentation,
            visibility: visibility
        )
    }
}

public extension DocsSection {
    static func structural(
        id: String,
        items: [DocsItem],
        visibility: Set<BuildEnvironment> = DocsVisibility.live
    ) -> DocsSection {
        DocsSection(
            id: id,
            title: id,
            summary: nil,
            items: items,
            presentation: .structural,
            visibility: visibility
        )
    }

    static func group(
        id: String,
        title: String,
        summary: String? = nil,
        items: [DocsItem],
        visibility: Set<BuildEnvironment> = DocsVisibility.live
    ) -> DocsSection {
        DocsSection(
            id: id,
            title: title,
            summary: summary,
            items: items,
            presentation: .group,
            visibility: visibility
        )
    }
}

public enum DocsItemContent: Sendable {
    case fragment(@Sendable () -> HTMLFragment)
    case article(DocsArticleBody)
    case nodes(@Sendable () -> ReusableComponentNodes)

    public var body: @Sendable () -> HTMLFragment {
        switch self {
        case .fragment(let body):
            return body

        case .article(let body):
            return {
                DocsReadableBodyRenderer.plain(body)
            }

        case .nodes(let nodes):
            return {
                nodes().body
            }
        }
    }
}

public struct DocsItem: Sendable {
    public let id: String
    public let title: String
    public let summary: String
    public let href: String
    public let header: Bool
    public let content: DocsItemContent
    public let notice: @Sendable () -> HTMLFragment
    public let visibility: Set<BuildEnvironment>

    public var body: @Sendable () -> HTMLFragment {
        content.body
    }

    public init(
        id: String,
        title: String,
        summary: String,
        href: String? = nil,
        header: Bool = true,
        visibility: Set<BuildEnvironment> = DocsVisibility.live,
        notice: @escaping @Sendable () -> HTMLFragment = { [] },
        body: @escaping @Sendable () -> HTMLFragment = { [] }
    ) {
        self.init(
            id: id,
            title: title,
            summary: summary,
            href: href,
            header: header,
            visibility: visibility,
            notice: notice,
            content: .fragment(body)
        )
    }

    public init(
        id: String,
        title: String,
        summary: String,
        href: String? = nil,
        header: Bool = true,
        visibility: Set<BuildEnvironment> = DocsVisibility.live,
        notice: @escaping @Sendable () -> HTMLFragment = { [] },
        content: DocsItemContent
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.href = href ?? "#\(id)"
        self.header = header
        self.visibility = visibility
        self.notice = notice
        self.content = content
    }

    public init(
        id: String,
        title: String,
        summary: String,
        href: String? = nil,
        header: Bool = true,
        visibility: Set<BuildEnvironment> = DocsVisibility.live,
        notice: @escaping @Sendable () -> HTMLFragment = { [] },
        nodes: @escaping @Sendable () -> ReusableComponentNodes
    ) {
        self.init(
            id: id,
            title: title,
            summary: summary,
            href: href,
            header: header,
            visibility: visibility,
            notice: notice,
            content: .nodes(nodes)
        )
    }

    public static func article(
        id: String,
        title: String,
        summary: String,
        href: String? = nil,
        header: Bool = true,
        visibility: Set<BuildEnvironment> = DocsVisibility.live,
        notice: @escaping @Sendable () -> HTMLFragment = { [] },
        body: DocsArticleBody
    ) -> DocsItem {
        DocsItem(
            id: id,
            title: title,
            summary: summary,
            href: href,
            header: header,
            visibility: visibility,
            notice: notice,
            content: .article(body)
        )
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
