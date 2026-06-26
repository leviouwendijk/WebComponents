import CSS
import HTML
import References

public struct ReferenceReviewNotes: HTMLNode {
    public static let block = "wc-reference-review-notes"

    public let reviews: [ReferenceReview]
    public let title: String

    public init(
        _ reviews: [ReferenceReview],
        title: String = "Aantekeningen"
    ) {
        self.reviews = reviews
        self.title = title
    }

    public func render(
        options: HTMLRenderOptions,
        indent: Int
    ) -> String {
        guard !reviews.isEmpty else {
            return ""
        }

        return HTMLElement(
            "details",
            attrs: ["class": "ref-reviews \(Self.block)"],
            children: [
                HTMLElement(
                    "summary",
                    attrs: ["class": "ref-reviews__summary"],
                    children: [
                        HTMLText("\(title) (\(reviews.count))")
                    ]
                ),
                HTMLElement(
                    "div",
                    attrs: ["class": "ref-reviews__body"],
                    children: reviews.map { reviewNode($0) }
                )
            ]
        ).render(options: options, indent: indent)
    }

    private func reviewNode(
        _ review: ReferenceReview
    ) -> any HTMLNode {
        var children: [any HTMLNode] = [
            HTMLElement(
                "div",
                attrs: ["class": "ref-review__header"],
                children: reviewHeaderChildren(review)
            )
        ]

        if let summary = review.summary, !summary.text.isEmpty {
            children.append(
                HTMLElement(
                    "p",
                    attrs: ["class": "ref-review__summary"],
                    children: [
                        HTMLText(summary.text)
                    ]
                )
            )
        }

        if !review.entries.isEmpty {
            children.append(
                HTMLElement(
                    "ul",
                    attrs: ["class": "ref-review__entries"],
                    children: review.entries.map { reviewEntryNode($0) }
                )
            )
        }

        return HTMLElement(
            "article",
            attrs: [
                "class": "ref-review",
                "data-ref-review-id": review.id
            ],
            children: children
        )
    }

    private func reviewHeaderChildren(
        _ review: ReferenceReview
    ) -> [any HTMLNode] {
        var children: [any HTMLNode] = [
            HTMLElement(
                "strong",
                attrs: ["class": "ref-review__title"],
                children: [
                    HTMLText(review.title)
                ]
            )
        ]

        if let date = review.date?.iso8601String {
            children.append(
                HTMLElement(
                    "time",
                    attrs: [
                        "class": "ref-review__date",
                        "datetime": date
                    ],
                    children: [
                        HTMLText(date)
                    ]
                )
            )
        }

        return children
    }

    private func reviewEntryNode(
        _ entry: ReferenceReviewEntry
    ) -> any HTMLNode {
        var mainChildren: [any HTMLNode] = []

        if let title = entry.title, !title.isEmpty {
            mainChildren.append(
                HTMLElement(
                    "strong",
                    attrs: ["class": "ref-review__entry-title"],
                    children: [
                        HTMLText(title)
                    ]
                )
            )
        }

        mainChildren.append(
            HTMLElement(
                "p",
                attrs: ["class": "ref-review__entry-body"],
                children: [
                    HTMLText(entry.body.text)
                ]
            )
        )

        return HTMLElement(
            "li",
            attrs: [
                "class": "ref-review__entry",
                "data-ref-review-kind": entry.kind.rawValue
            ],
            children: [
                HTMLElement(
                    "span",
                    attrs: ["class": "ref-review__entry-kind"],
                    children: [
                        HTMLText(entry.kind.dutch)
                    ]
                ),
                HTMLElement(
                    "div",
                    attrs: ["class": "ref-review__entry-main"],
                    children: mainChildren
                )
            ]
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("max-width", "min(82ch, 100%)"),
                    CSS.decl("margin-top", "14px"),
                    CSS.decl("padding-top", "10px"),
                    CSS.decl("border-top", "1px solid var(--border-color)")
                ),

                CSS.rule(
                    ".\(block) .ref-reviews__summary",
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("padding", "0 0 8px"),
                    CSS.decl("font-size", ".86rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block) .ref-reviews__body",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("padding", "0")
                ),

                CSS.rule(
                    ".\(block) .ref-review",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "9px"),
                    CSS.decl("padding", "2px 0 0")
                ),

                CSS.rule(
                    ".\(block) .ref-review + .ref-review",
                    CSS.decl("padding-top", "14px"),
                    CSS.decl("border-top", "1px solid var(--border-color)")
                ),

                CSS.rule(
                    ".\(block) .ref-review__header",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("align-items", "baseline"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".\(block) .ref-review__title",
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.3")
                ),

                CSS.rule(
                    ".\(block) .ref-review__date",
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("font-size", ".78rem")
                ),

                CSS.rule(
                    ".\(block) .ref-review__summary",
                    CSS.decl("max-width", "76ch"),
                    CSS.decl("margin", "0"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("font-size", ".86rem"),
                    CSS.decl("line-height", "1.5")
                ),

                CSS.rule(
                    ".\(block) .ref-review__entries",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "0"),
                    CSS.decl("margin", "2px 0 0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("list-style", "none")
                ),

                CSS.rule(
                    ".\(block).ref-reviews .ref-review__entry",
                    CSS.decl("--ref-review-accent", "var(--muted-text-color)"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("max-width", "74ch"),
                    CSS.decl("padding", "10px 0 10px 12px"),
                    CSS.decl("border-left", "3px solid var(--ref-review-accent)")
                ),

                CSS.rule(
                    ".\(block) .ref-review__entry + .ref-review__entry",
                    CSS.decl("border-top", "1px solid color-mix(in srgb, var(--border-color) 72%, transparent)")
                ),

                CSS.rule(
                    ".\(block) .ref-review__entry[data-ref-review-kind=\"overview\"]",
                    CSS.decl("--ref-review-accent", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block) .ref-review__entry[data-ref-review-kind=\"method\"]",
                    CSS.decl("--ref-review-accent", "var(--link-color)")
                ),

                CSS.rule(
                    ".\(block) .ref-review__entry[data-ref-review-kind=\"finding\"]",
                    CSS.decl("--ref-review-accent", "var(--success, #2E8B57)")
                ),

                CSS.rule(
                    ".\(block) .ref-review__entry[data-ref-review-kind=\"limitation\"]",
                    CSS.decl("--ref-review-accent", "var(--warning, #E7A94E)")
                ),

                CSS.rule(
                    ".\(block) .ref-review__entry[data-ref-review-kind=\"takeaway\"]",
                    CSS.decl("--ref-review-accent", "var(--success, #2E8B57)")
                ),

                CSS.rule(
                    ".\(block) .ref-review__entry[data-ref-review-kind=\"interpretation\"]",
                    CSS.decl("--ref-review-accent", "var(--link-color)")
                ),

                CSS.rule(
                    ".\(block) .ref-review__entry[data-ref-review-kind=\"caution\"]",
                    CSS.decl("--ref-review-accent", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".\(block) .ref-review__entry[data-ref-review-kind=\"relevance\"]",
                    CSS.decl("--ref-review-accent", "var(--success, #2E8B57)")
                ),

                CSS.rule(
                    ".\(block) .ref-review__entry-kind",
                    CSS.decl("align-self", "start"),
                    CSS.decl("padding-top", "1px"),
                    CSS.decl("color", "var(--ref-review-accent)"),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("letter-spacing", ".045em"),
                    CSS.decl("line-height", "1.25"),
                    CSS.decl("text-transform", "uppercase")
                ),

                CSS.rule(
                    ".\(block) .ref-review__entry-main",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("max-width", "74ch")
                ),

                CSS.rule(
                    ".\(block) .ref-review__entry-title",
                    CSS.decl("display", "block"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("line-height", "1.35")
                ),

                CSS.rule(
                    ".\(block) .ref-review__entry-body",
                    CSS.decl("max-width", "74ch"),
                    CSS.decl("margin", "0"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("line-height", "1.5")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(block) .ref-review__entry",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "4px")
                    )
                )
            ]
        )
    }
}
