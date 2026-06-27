import Constructors
import Path
import Primitives

public enum DocsPageKind: Sendable {
    case home
    case group
    case hub
    case category
    case article
    case reference
    case tool
    case quiz
    case system
}

public enum DocsPageContent: Sendable {
    case none
    case component(@Sendable () -> ReusableComponentNodes)
    case category(DocsCategory)
    case article(DocsArticle)
}

public struct DocsPage: Sendable, PageGraphNode {
    public let identifier: DocsPageIdentifier
    public let slug: PathSegment?
    public let title: String
    public let summary: String?
    public let kind: DocsPageKind
    public let visibility: Set<BuildEnvironment>
    public let content: DocsPageContent
    public let children: [DocsPage]

    public init(
        identifier: DocsPageIdentifier,
        slug: PathSegment? = nil,
        title: String,
        summary: String? = nil,
        kind: DocsPageKind,
        visibility: Set<BuildEnvironment> = DocsVisibility.live,
        content: DocsPageContent = .none,
        children: [DocsPage] = []
    ) {
        self.identifier = identifier
        self.slug = slug
        self.title = title
        self.summary = summary
        self.kind = kind
        self.visibility = visibility
        self.content = content
        self.children = children
    }
}

public extension DocsPage {
    static func home(
        identifier: DocsPageIdentifier = "home",
        title: String,
        summary: String? = nil,
        visibility: Set<BuildEnvironment> = DocsVisibility.live,
        content: DocsPageContent
    ) -> DocsPage {
        DocsPage(
            identifier: identifier,
            slug: nil,
            title: title,
            summary: summary,
            kind: .home,
            visibility: visibility,
            content: content
        )
    }

    static func group(
        identifier: DocsPageIdentifier,
        slug: PathSegment,
        title: String,
        summary: String? = nil,
        visibility: Set<BuildEnvironment> = DocsVisibility.live,
        content: DocsPageContent = .none,
        children: [DocsPage]
    ) -> DocsPage {
        DocsPage(
            identifier: identifier,
            slug: slug,
            title: title,
            summary: summary,
            kind: .group,
            visibility: visibility,
            content: content,
            children: children
        )
    }

    static func article(
        identifier: DocsPageIdentifier,
        slug: PathSegment,
        title: String,
        summary: String? = nil,
        visibility: Set<BuildEnvironment> = DocsVisibility.live,
        article: DocsArticle
    ) -> DocsPage {
        DocsPage(
            identifier: identifier,
            slug: slug,
            title: title,
            summary: summary,
            kind: .article,
            visibility: visibility,
            content: .article(article)
        )
    }

    static func category(
        identifier: DocsPageIdentifier,
        slug: PathSegment,
        title: String,
        summary: String? = nil,
        visibility: Set<BuildEnvironment> = DocsVisibility.live,
        category: DocsCategory
    ) -> DocsPage {
        DocsPage(
            identifier: identifier,
            slug: slug,
            title: title,
            summary: summary,
            kind: .category,
            visibility: visibility,
            content: .category(category)
        )
    }
}
