import HTML

public protocol SectionIdentifying:
    CaseIterable,
    RawRepresentable,
    Sendable
    where RawValue == String
{
    var label: String { get }
    var level: Int { get }
}

extension SectionIdentifying {
    public var level: Int { 2 }
}

public struct Section<ID: SectionIdentifying>: HTMLNode, Sendable {
    public let id: ID
    public let body: @Sendable () -> HTMLFragment

    public init(
        _ id: ID,
        @HTMLBuilder body: @escaping @Sendable () -> HTMLFragment
    ) {
        self.id = id
        self.body = body
    }

    public func render(options: HTMLRenderOptions, indent: Int) -> String {
        let heading = ArticleHeading(
            id: id.rawValue,
            level: id.level,
            label: [HTML.text(id.label)]
        )
        let children: HTMLFragment = [heading] + body()
        return children
            .map { $0.render(options: options, indent: indent) }
            .joined()
    }
}
