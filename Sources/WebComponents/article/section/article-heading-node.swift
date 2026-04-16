import HTML

public struct ArticleHeading: HTMLNode, Sendable {
    public let id: String
    public let level: Int
    public let label: HTMLFragment

    public init(id: String, level: Int = 2, label: HTMLFragment) {
        self.id = id
        self.level = level
        self.label = label
    }

    public func render(options: HTMLRenderOptions, indent: Int) -> String {
        HTMLElement(
            "h\(level)",
            attrs: ["id": id, "class": "article-heading article-heading--h\(level)"],
            children: label
        ).render(options: options, indent: indent)
    }
}
