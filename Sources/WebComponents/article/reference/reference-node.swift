import HTML
import References

public struct Reference: HTMLNode {
    public struct Comment: Sendable {
        public let pointers: [Int]
        public let locators: [ReferenceLocator]
        public let text: String

        public init(
            pointers: [Int],
            locators: [ReferenceLocator] = [],
            text: String
        ) {
            self.pointers = pointers
            self.locators = locators
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

    public func render(
        options: HTMLRenderOptions,
        indent: Int
    ) -> String {
        let ref = reference

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
                        HTMLText(doi)
                    ]
                )
            )
        }

        var children: [any HTMLNode] = [
            HTMLElement(
                "div",
                attrs: ["class": "ref-title"],
                children: pointerBacklinks(
                    pointers,
                    indexClass: "ref-index"
                ) + [
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
            let renderedComments = commentNodes()

            if !renderedComments.isEmpty {
                children.append(
                    HTMLElement(
                        "div",
                        attrs: ["class": "ref-comment"],
                        children: renderedComments
                    )
                )
            }
        }

        if !ref.reviews.isEmpty {
            children.append(
                reviewsNode(ref.reviews)
            )
        }

        let searchText = (
            ref.searchTerms
                + pointers.flatMap { pointer in
                    [
                        "\(pointer)",
                        "[\(pointer)]",
                        "#\(pointer)",
                        "bron \(pointer)",
                        "source \(pointer)",
                    ]
                }
        )
        .joined(separator: " ")
        .lowercased()

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
                "data-reference-search": searchText
            ],
            children: children
        ).render(options: options, indent: indent)
    }

    private func pointerBacklinks(
        _ values: [Int],
        indexClass: String
    ) -> [any HTMLNode] {
        guard !values.isEmpty else {
            return [
                HTMLElement(
                    "span",
                    attrs: [
                        "class": "\(indexClass) ref-backlink ref-backlink--empty"
                    ],
                    children: [
                        HTMLText("[]")
                    ]
                ),
                HTMLText(" ")
            ]
        }

        var children: [any HTMLNode] = []

        for (index, pointer) in values.enumerated() {
            if index > 0 {
                children.append(
                    HTMLText(" ")
                )
            }

            children.append(
                HTMLElement(
                    "a",
                    attrs: [
                        "class": "\(indexClass) ref-backlink",
                        "href": "#cite-\(pointer)",
                        "aria-label": "Terug naar bron \(pointer)"
                    ],
                    children: [
                        HTMLText("[\(pointer)]")
                    ]
                )
            )
        }

        children.append(
            HTMLText(" ")
        )

        return children
    }

    private func commentNodes() -> [any HTMLNode] {
        comments.enumerated().flatMap { index, item -> [any HTMLNode] in
            var nodes: [any HTMLNode] = []

            if index > 0 {
                nodes.append(
                    HTMLElement(
                        "div",
                        attrs: ["class": "ref-comment-sep"],
                        children: []
                    )
                )
            }

            nodes += commentItemChildren(item)

            return nodes
        }
    }

    private func commentItemChildren(
        _ item: Comment
    ) -> [any HTMLNode] {
        var children: [any HTMLNode] = []

        if !item.pointers.isEmpty {
            children.append(
                HTMLElement(
                    "span",
                    attrs: ["class": "ref-comment-pointers"],
                    children: pointerBacklinks(
                        item.pointers,
                        indexClass: "ref-comment-pointer"
                    )
                )
            )
        }

        if !item.locators.isEmpty {
            let locatorText = item.locators
                .map(\.rendered)
                .joined(separator: ", ")

            if !locatorText.isEmpty {
                children.append(
                    HTMLElement(
                        "span",
                        attrs: ["class": "ref-comment-locator"],
                        children: [
                            HTMLText(locatorText)
                        ]
                    )
                )

                if !item.text.isEmpty {
                    children.append(
                        HTMLText(" ")
                    )
                }
            }
        }

        if !item.text.isEmpty {
            children.append(
                HTMLText(item.text)
            )
        }

        return children
    }

    private func reviewsNode(
        _ reviews: [ReferenceReview]
    ) -> any HTMLNode {
        ReferenceReviewNotes(reviews)
    }
}
