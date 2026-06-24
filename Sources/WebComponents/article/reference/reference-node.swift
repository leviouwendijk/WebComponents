import HTML
import References

public struct Reference: HTMLNode {
    public struct Comment: Sendable {
        public let pointers: [Int]
        public let text: String

        public init(
            pointers: [Int],
            text: String
        ) {
            self.pointers = pointers
            self.text = text
        }
    }

    public let reference: any Referencable
    public let pointers: [Int]
    public let comments: [Comment]

    public init(
        _ reference: any Referencable,
        pointers: [Int],
        comments: [Comment] = []
    ) {
        self.reference = reference
        self.pointers = pointers
        self.comments = comments
    }

    public func render(options: HTMLRenderOptions, indent: Int) -> String {
        let ref = reference

        let label: String = {
            guard !pointers.isEmpty else { return "[] " }
            let joined = pointers.map(String.init).joined(separator: ", ")
            return "[\(joined)] "
        }()

        var meta: [any HTMLNode] = []

        if let author = ref.authorLine, !author.isEmpty {
            meta.append(
                HTMLElement(
                    "div",
                    attrs: ["class": "ref-author"],
                    children: [HTMLText(author)]
                )
            )
        }

        if let date = ref.dateISO8601, !date.isEmpty {
            meta.append(
                HTMLElement(
                    "div",
                    attrs: ["class": "ref-date"],
                    children: [HTMLText(date)]
                )
            )
        }

        if let doi = ref.doi, !doi.isEmpty {
            meta.append(
                HTMLElement(
                    "div",
                    attrs: ["class": "ref-doi"],
                    children: [
                        // HTMLText("DOI: \(doi)")
                        HTMLText(doi)
                    ]
                )
            )
        }

        var children: [any HTMLNode] = [
            HTMLElement(
                "div",
                attrs: ["class": "ref-title"],
                children: [
                    HTMLElement(
                        "span",
                        attrs: ["class": "ref-index"],
                        children: [HTMLText(label)]
                    ),
                    // HTMLElement(
                    //     "a",
                    //     attrs: ["href": ref.url],
                    //     children: [HTMLText(ref.title)]
                    // )
                    HTMLElement(
                        "a",
                        attrs: [
                            "href": ref.url,
                            "target": "_blank",
                            "rel": "noopener noreferrer",
                        ],
                        children: [HTMLText(ref.title)]
                    )
                ]
            )
        ]

        if !meta.isEmpty {
            children.append(
                HTMLElement(
                    "div",
                    attrs: ["class": "ref-meta"],
                    children: meta
                )
            )
        }

        if !comments.isEmpty {
            children.append(
                HTMLElement(
                    "div",
                    attrs: ["class": "ref-comment"],
                    children: comments.enumerated().flatMap { (i, item) -> [any HTMLNode] in
                        if item.text.isEmpty { return [] }

                        let prefix: String = {
                            guard !item.pointers.isEmpty else { return "" }
                            let joined = item.pointers.map(String.init).joined(separator: ", ")
                            return "[\(joined)] "
                        }()

                        if i == 0 {
                            return [HTMLText(prefix + item.text)]
                        }

                        return [
                            HTMLElement("div", attrs: ["class": "ref-comment-sep"], children: []),
                            HTMLText(prefix + item.text)
                        ]
                    }
                )
            )
        }

        // return HTMLElement(
        //     "li",
        //     attrs: [
        //         "class": "ref-item",
        //         "id": "ref-\(ref.public_name_or_id)"
        //     ],
        //     children: children
        // ).render(options: options, indent: indent)

        return HTMLElement(
            "li",
            attrs: [
                "class": "ref-item",
                "id": "ref-\(ref.public_name_or_id)",
                "data-reference-item": "",
                "data-reference-id": ref.public_name_or_id,
                "data-reference-title": ref.title,
                "data-reference-authors": ref.authorLine ?? "",
                "data-reference-date": ref.dateISO8601 ?? "",
                "data-reference-doi": ref.doi ?? "",
                "data-reference-url": ref.url,
                "data-reference-kind": ref.kind.rawValue,
                "data-reference-channel": ref.channel.rawValue,
                "data-reference-tags": ref.tags.values.map(\.id).joined(separator: " "),
                "data-reference-search": ref.searchTerms.joined(separator: " ").lowercased()
            ],
            children: children
        ).render(options: options, indent: indent)
    }
}
