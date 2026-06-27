import Constructors

public struct DocsPageCatalog: Sendable {
    public let title: String
    public let language: String
    public let assetPrefix: String
    public let pages: [DocsPage]

    public init(
        title: String,
        language: String,
        assetPrefix: String,
        pages: [DocsPage]
    ) {
        self.title = title
        self.language = language
        self.assetPrefix = assetPrefix
        self.pages = pages
    }

    public var graph: PageGraph<DocsPage> {
        PageGraph(
            roots: pages
        )
    }
}
