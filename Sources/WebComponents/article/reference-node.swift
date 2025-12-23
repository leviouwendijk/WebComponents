import HTML

public struct Reference: HTMLNode {
    public let reference: any Referencable
    public let comments: [String]

    public init(
        _ reference: any Referencable,
        comments: [String] = []
    ) {
        self.reference = reference
        self.comments = comments
    }

    public func render(options: HTMLRenderOptions, indent: Int) -> String {
        let ref = reference

        var children: [any HTMLNode] = []

        children.append(
            HTMLElement(
                "span",
                attrs: ["class": "ref-title"],
                children: [
                    HTMLElement(
                        "a",
                        attrs: ["href": ref.url],
                        children: [
                            HTMLText(ref.title)
                        ]
                    )
                ]
            )
        )

        if let author = ref.authorLine, !author.isEmpty {
            children.append(
                HTMLElement(
                    "span",
                    attrs: ["class": "ref-author"],
                    children: [
                        HTMLText(" — \(author)")
                    ]
                )
            )
        }

        if let date = ref.dateISO8601, !date.isEmpty {
            children.append(
                HTMLElement(
                    "span",
                    attrs: ["class": "ref-date"],
                    children: [
                        HTMLText(" (\(date))")
                    ]
                )
            )
        }

        if let doi = ref.doi, !doi.isEmpty {
            children.append(
                HTMLElement(
                    "span",
                    attrs: ["class": "ref-doi"],
                    children: [
                        HTMLText(" DOI: \(doi)")
                    ]
                )
            )
        }

        for c in comments where !c.isEmpty {
            children.append(
                HTMLElement(
                    "div",
                    attrs: ["class": "ref-comment"],
                    children: [
                        HTMLText(c)
                    ]
                )
            )
        }

        return HTMLElement(
            "li",
            attrs: [
                "class": "ref-item",
                "id": "ref-\(ref.public_name_or_id)"
            ],
            children: children
        ).render(options: options, indent: indent)
    }
}
