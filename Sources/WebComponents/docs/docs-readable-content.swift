import HTML

public enum DocsReadableHeadingLevel: Int, Sendable {
    case h2 = 2
    case h3 = 3
    case h4 = 4
}

public enum DocsReadableAsideKind: String, Sendable {
    case note
    case warning
    case example
}

public struct DocsReadableListItem: Sendable {
    public let content: @Sendable () -> HTMLFragment

    public init(
        @HTMLBuilder _ content: @escaping @Sendable () -> HTMLFragment
    ) {
        self.content = content
    }
}

public enum DocsReadableBlock: Sendable {
    case paragraph(@Sendable () -> HTMLFragment)
    case heading(level: DocsReadableHeadingLevel, id: String?, body: @Sendable () -> HTMLFragment)
    case unorderedList([DocsReadableListItem])
    case orderedList([DocsReadableListItem])
    case quote(citation: String?, body: @Sendable () -> HTMLFragment)
    case figure(@Sendable () -> HTMLFragment)
    case aside(kind: DocsReadableAsideKind, body: @Sendable () -> HTMLFragment)
    case component(@Sendable () -> HTMLFragment)
    case raw(@Sendable () -> HTMLFragment)
}

public struct DocsArticleBody: Sendable {
    public let blocks: [DocsReadableBlock]

    public init(
        _ blocks: [DocsReadableBlock]
    ) {
        self.blocks = blocks
    }
}

public extension DocsReadableBlock {
    static func p(
        _ text: String
    ) -> DocsReadableBlock {
        .paragraph {
            [
                HTMLText(text)
            ]
        }
    }

    static func p(
        @HTMLBuilder _ body: @escaping @Sendable () -> HTMLFragment
    ) -> DocsReadableBlock {
        .paragraph(body)
    }

    static func h2(
        id: String? = nil,
        @HTMLBuilder _ body: @escaping @Sendable () -> HTMLFragment
    ) -> DocsReadableBlock {
        .heading(
            level: .h2,
            id: id,
            body: body
        )
    }

    static func h3(
        id: String? = nil,
        @HTMLBuilder _ body: @escaping @Sendable () -> HTMLFragment
    ) -> DocsReadableBlock {
        .heading(
            level: .h3,
            id: id,
            body: body
        )
    }

    static func note(
        @HTMLBuilder _ body: @escaping @Sendable () -> HTMLFragment
    ) -> DocsReadableBlock {
        .aside(
            kind: .note,
            body: body
        )
    }
}

public struct DocsReadableBodyRenderer: Sendable {
    private var paragraphIndex: Int
    private var previousWasParagraph: Bool

    public init() {
        self.paragraphIndex = 0
        self.previousWasParagraph = false
    }

    public mutating func render(
        _ body: DocsArticleBody
    ) -> HTMLFragment {
        var nodes: HTMLFragment = []

        for block in body.blocks {
            nodes += render(block)
        }

        return nodes
    }

    public static func plain(
        _ body: DocsArticleBody
    ) -> HTMLFragment {
        var renderer = DocsReadableBodyRenderer()
        return renderer.render(body)
    }

    private mutating func render(
        _ block: DocsReadableBlock
    ) -> HTMLFragment {
        switch block {
        case .paragraph(let body):
            return renderParagraph(body)

        case .heading(let level, let id, let body):
            previousWasParagraph = false

            var attrs: HTMLAttribute = [:]

            if let id, !id.isEmpty {
                attrs.merge([
                    "id": id
                ])
            }

            return [
                HTMLElement(
                    "h\(level.rawValue)",
                    attrs: attrs,
                    children: body()
                )
            ]

        case .unorderedList(let items):
            previousWasParagraph = false
            return renderList(
                tag: "ul",
                items: items
            )

        case .orderedList(let items):
            previousWasParagraph = false
            return renderList(
                tag: "ol",
                items: items
            )

        case .quote(let citation, let body):
            previousWasParagraph = false

            var children = body()

            if let citation, !citation.isEmpty {
                children.append(
                    HTMLElement(
                        "footer",
                        children: [
                            HTMLText(citation)
                        ]
                    )
                )
            }

            return [
                HTMLElement(
                    "blockquote",
                    attrs: [
                        "data-docs-readable-quote": ""
                    ],
                    children: children
                )
            ]

        case .figure(let body):
            previousWasParagraph = false
            return body()

        case .aside(let kind, let body):
            previousWasParagraph = false

            return [
                HTMLElement(
                    "aside",
                    attrs: [
                        "class": "docs-readable-aside docs-readable-aside--\(kind.rawValue)",
                        "data-docs-readable-aside": kind.rawValue
                    ],
                    children: body()
                )
            ]

        case .component(let body):
            previousWasParagraph = false
            return body()

        case .raw(let body):
            previousWasParagraph = false
            return body()
        }
    }

    private mutating func renderParagraph(
        _ body: @Sendable () -> HTMLFragment
    ) -> HTMLFragment {
        paragraphIndex += 1

        let isFirst = paragraphIndex == 1

        var attrs: HTMLAttribute = [
            "data-docs-readable-paragraph": "\(paragraphIndex)",
            "data-docs-readable-first-paragraph": isFirst ? "true" : "false"
        ]

        if previousWasParagraph {
            attrs.merge([
                "data-docs-readable-after-paragraph": "true"
            ])
        }

        previousWasParagraph = true

        return [
            HTMLElement(
                "p",
                attrs: attrs,
                children: body()
            )
        ]
    }

    private func renderList(
        tag: String,
        items: [DocsReadableListItem]
    ) -> HTMLFragment {
        [
            HTMLElement(
                tag,
                children: items.map { item in
                    HTMLElement(
                        "li",
                        children: item.content()
                    )
                }
            )
        ]
    }
}
