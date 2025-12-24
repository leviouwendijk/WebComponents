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
    public func reference_node(
        index: Int,
        pointers: [Int] = []
    ) -> Reference {
        var comments: [String] = []
        if let c = comment, !c.isEmpty {
            comments.append(c)
        }

        return Reference(
            reference,
            index: index,
            pointers: pointers,
            comments: comments
        )
    }
}
