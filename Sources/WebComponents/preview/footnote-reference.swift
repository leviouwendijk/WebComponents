import HTML

public struct FootnoteReference: HTMLNode, Sendable {
    public let number: Int
    public let text: String

    public init(
        number: Int,
        text: String
    ) {
        self.number = number
        self.text = text
    }

    public func render(
        options: HTMLRenderOptions,
        indent: Int
    ) -> String {
        HTMLElement(
            "li",
            attrs: [
                "id": "footnote-\(number)",
                "class": "footnote-item"
            ],
            children: [
                HTMLElement(
                    "a",
                    attrs: [
                        "class": "footnote-backlink",
                        "href": "#footnote-ref-\(number)",
                        "aria-label": "Terug naar voetnoot \(number)"
                    ],
                    children: [
                        HTMLText("[\(number)]")
                    ]
                ),
                HTMLText(" "),
                HTMLElement(
                    "span",
                    attrs: [
                        "class": "footnote-text"
                    ],
                    children: [
                        HTMLText(text)
                    ]
                )
            ]
        ).render(options: options, indent: indent)
    }
}
