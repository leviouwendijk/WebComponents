import HTML

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

// public struct Reference: HTMLNode {
//     public let reference: any Referencable
//     public let comments: [String]

//     public init(
//         _ reference: any Referencable,
//         comments: [String] = []
//     ) {
//         self.reference = reference
//         self.comments = comments
//     }

//     public func render(options: HTMLRenderOptions, indent: Int) -> String {
//         let ref = reference

//         var meta: [any HTMLNode] = []

//         if let author = ref.authorLine, !author.isEmpty {
//             meta.append(
//                 HTMLElement(
//                     "div",
//                     attrs: ["class": "ref-author"],
//                     children: [
//                         HTMLText(author)
//                     ]
//                 )
//             )
//         }

//         if let date = ref.dateISO8601, !date.isEmpty {
//             meta.append(
//                 HTMLElement(
//                     "div",
//                     attrs: ["class": "ref-date"],
//                     children: [
//                         HTMLText(date)
//                     ]
//                 )
//             )
//         }

//         if let doi = ref.doi, !doi.isEmpty {
//             meta.append(
//                 HTMLElement(
//                     "div",
//                     attrs: ["class": "ref-doi"],
//                     children: [
//                         HTMLText("DOI: \(doi)")
//                     ]
//                 )
//             )
//         }

//         var children: [any HTMLNode] = [
//             HTMLElement(
//                 "div",
//                 attrs: ["class": "ref-title"],
//                 children: [
//                     HTMLElement(
//                         "a",
//                         attrs: ["href": ref.url],
//                         children: [
//                             HTMLText(ref.title)
//                         ]
//                     )
//                 ]
//             )
//         ]

//         if !meta.isEmpty {
//             children.append(
//                 HTMLElement(
//                     "div",
//                     attrs: ["class": "ref-meta"],
//                     children: meta
//                 )
//             )
//         }

//         // for c in comments where !c.isEmpty {
//         //     children.append(
//         //         HTMLElement(
//         //             "div",
//         //             attrs: ["class": "ref-comment"],
//         //             children: [
//         //                 HTMLText(c)
//         //             ]
//         //         )
//         //     )
//         // }

//         if !comments.isEmpty {
//             var commentItems: [any HTMLNode] = []

//             for c in comments where !c.isEmpty {
//                 commentItems.append(
//                     HTMLElement(
//                         "div",
//                         attrs: ["class": "ref-comment__item"],
//                         children: [
//                             HTMLText(c)
//                         ]
//                     )
//                 )
//             }

//             if !commentItems.isEmpty {
//                 children.append(
//                     HTMLElement(
//                         "div",
//                         attrs: ["class": "ref-comment"],
//                         children: commentItems
//                     )
//                 )
//             }
//         }

//         return HTMLElement(
//             "li",
//             attrs: [
//                 "class": "ref-item",
//                 "id": "ref-\(ref.public_name_or_id)"
//             ],
//             children: children
//         ).render(options: options, indent: indent)
//     }

//     // public func render(options: HTMLRenderOptions, indent: Int) -> String {
//     //     let ref = reference

//     //     var children: [any HTMLNode] = []

//     //     children.append(
//     //         HTMLElement(
//     //             "span",
//     //             attrs: ["class": "ref-title"],
//     //             children: [
//     //                 HTMLElement(
//     //                     "a",
//     //                     attrs: ["href": ref.url],
//     //                     children: [
//     //                         HTMLText(ref.title)
//     //                     ]
//     //                 )
//     //             ]
//     //         )
//     //     )

//     //     if let author = ref.authorLine, !author.isEmpty {
//     //         children.append(
//     //             HTMLElement(
//     //                 "span",
//     //                 attrs: ["class": "ref-author"],
//     //                 children: [
//     //                     HTMLText(" — \(author)")
//     //                 ]
//     //             )
//     //         )
//     //     }

//     //     if let date = ref.dateISO8601, !date.isEmpty {
//     //         children.append(
//     //             HTMLElement(
//     //                 "span",
//     //                 attrs: ["class": "ref-date"],
//     //                 children: [
//     //                     HTMLText(" (\(date))")
//     //                 ]
//     //             )
//     //         )
//     //     }

//     //     if let doi = ref.doi, !doi.isEmpty {
//     //         children.append(
//     //             HTMLElement(
//     //                 "span",
//     //                 attrs: ["class": "ref-doi"],
//     //                 children: [
//     //                     HTMLText(" DOI: \(doi)")
//     //                 ]
//     //             )
//     //         )
//     //     }

//     //     for c in comments where !c.isEmpty {
//     //         children.append(
//     //             HTMLElement(
//     //                 "div",
//     //                 attrs: ["class": "ref-comment"],
//     //                 children: [
//     //                     HTMLText(c)
//     //                 ]
//     //             )
//     //         )
//     //     }

//     //     return HTMLElement(
//     //         "li",
//     //         attrs: [
//     //             "class": "ref-item",
//     //             "id": "ref-\(ref.public_name_or_id)"
//     //         ],
//     //         children: children
//     //     ).render(options: options, indent: indent)
//     // }
// }
