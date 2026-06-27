import Primitives

public enum DocsNavMode: Sendable {
    case hidden
    case item
    case group
}

public enum DocsHeaderMode: Sendable {
    case hidden
    case visible

    public var isVisible: Bool {
        switch self {
        case .hidden:
            return false

        case .visible:
            return true
        }
    }
}

public struct DocsArticle: Sendable {
    public let meta: DocsArticleMeta
    public let sections: [DocsArticleSection]

    public init(
        meta: DocsArticleMeta = .init(),
        sections: [DocsArticleSection]
    ) {
        self.meta = meta
        self.sections = sections
    }
}

public struct DocsArticleSection: Sendable {
    public let identifier: String
    public let title: String
    public let summary: String?
    public let nav: DocsNavMode
    public let parts: [DocsArticlePart]

    public init(
        identifier: String,
        title: String,
        summary: String? = nil,
        nav: DocsNavMode = .group,
        parts: [DocsArticlePart]
    ) {
        self.identifier = identifier
        self.title = title
        self.summary = summary
        self.nav = nav
        self.parts = parts
    }
}

public struct DocsArticlePart: Sendable {
    public let identifier: String
    public let title: String
    public let summary: String
    public let href: String
    public let header: DocsHeaderMode
    public let body: DocsArticleBody
    public let visibility: Set<BuildEnvironment>

    public init(
        identifier: String,
        title: String,
        summary: String = "",
        href: String? = nil,
        header: DocsHeaderMode = .visible,
        body: DocsArticleBody,
        visibility: Set<BuildEnvironment> = DocsVisibility.live
    ) {
        self.identifier = identifier
        self.title = title
        self.summary = summary
        self.href = href ?? "#\(identifier)"
        self.header = header
        self.body = body
        self.visibility = visibility
    }
}
