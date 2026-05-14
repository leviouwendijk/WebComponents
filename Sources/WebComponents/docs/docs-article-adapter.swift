import HTML

public enum DocsArticleRenderMode: Sendable {
    case leadAndContent
    case article
    case articleWithTOC
}

public extension DocsItem {
    init(
        id: String,
        href: String? = nil,
        title: String? = nil,
        summary: String,
        article: ArticleItem,
        renderMode: DocsArticleRenderMode = .article
    ) {
        self.init(
            id: id,
            title: title ?? article.title,
            summary: summary,
            href: href,
            body: {
                switch renderMode {
                case .leadAndContent:
                    return article.lead_and_content()

                case .article:
                    return article.article()

                case .articleWithTOC:
                    return article.article_with_toc()
                }
            }
        )
    }
}

public extension DocsSection {
    init(
        id: String,
        title: String,
        summary: String? = nil,
        articles: [DocsArticleEntry]
    ) {
        self.init(
            id: id,
            title: title,
            summary: summary,
            items: articles.map { entry in
                DocsItem(
                    id: entry.id,
                    href: entry.href,
                    title: entry.title,
                    summary: entry.summary,
                    article: entry.article,
                    renderMode: entry.renderMode
                )
            }
        )
    }
}

public struct DocsArticleEntry: Sendable {
    public let id: String
    public let href: String?
    public let title: String?
    public let summary: String
    public let article: ArticleItem
    public let renderMode: DocsArticleRenderMode

    public init(
        id: String,
        href: String? = nil,
        title: String? = nil,
        summary: String,
        article: ArticleItem,
        renderMode: DocsArticleRenderMode = .article
    ) {
        self.id = id
        self.href = href
        self.title = title
        self.summary = summary
        self.article = article
        self.renderMode = renderMode
    }
}
