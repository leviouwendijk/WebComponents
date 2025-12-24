import HTML

public struct Citation: HTMLNode {
    public let reference: any Referencable
    public let comment: String?

    public init(
        _ reference: any Referencable,
        comment: String? = nil
    ) {
        self.reference = reference
        self.comment = comment
    }

    public func render(options: HTMLRenderOptions, indent: Int) -> String {
        let id = reference.public_name_or_id

        return HTMLElement(
            "sup",
            attrs: ["class": "cite"],
            children: [
                HTMLElement(
                    "a",
                    attrs: [
                        "href": "#ref-\(id)",
                        "data-ref": id,
                        "aria-label": "Citation: Reference \(id)"
                    ],
                    children: []
                )
            ]
        ).render(options: options, indent: indent)
    }

    // public func reference_node() -> Reference {
    //     var comments: [String] = []
    //     if let c = comment { comments.append(c) }
    //     return Reference(reference, comments: comments)
    // }


    @available(
        *, deprecated,
        message:
            "Use CitationResolver.resolve(from:) to build references (needs occurrence pointers + comment pointers)."
    )
    public func reference_node(
        pointers: [Int]
    ) -> Reference {
        var items: [Reference.Comment] = []

        if let c = comment, !c.isEmpty {
            items.append(
                Reference.Comment(
                    pointers: pointers,
                    text: c
                )
            )
        }

        return Reference(
            reference,
            pointers: pointers,
            comments: items
        )
    }
}
