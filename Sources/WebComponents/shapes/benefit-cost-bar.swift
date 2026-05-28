import Constructors
import CSS
import HTML

public struct BenefitCostBar: ReusableComponent, Sendable {
    public struct Segment: Sendable {
        public let label: String
        public let value: Int

        public init(
            label: String,
            value: Int
        ) {
            self.label = label
            self.value = value
        }
    }

    private enum ClassName {
        static let root = "wc-benefit-cost-bar"
        static let stage = "wc-benefit-cost-bar__stage"
        static let row = "wc-benefit-cost-bar__row"
        static let rowLabel = "wc-benefit-cost-bar__row-label"
        static let track = "wc-benefit-cost-bar__track"
        static let fill = "wc-benefit-cost-bar__fill"
        static let benefit = "wc-benefit-cost-bar__fill--benefit"
        static let cost = "wc-benefit-cost-bar__fill--cost"
        static let value = "wc-benefit-cost-bar__value"
        static let equation = "wc-benefit-cost-bar__equation"
        static let result = "wc-benefit-cost-bar__result"
        static let resultPositive = "wc-benefit-cost-bar__result--positive"
        static let resultNegative = "wc-benefit-cost-bar__result--negative"
        static let caption = "wc-benefit-cost-bar__caption"
    }

    public let id: String
    public let benefit: Segment
    public let cost: Segment
    public let caption: String?
    public let includeStyles: Bool

    public init(
        id: String = "benefit-cost-bar",
        benefit: Segment = Segment(
            label: "Opbrengst",
            value: 72
        ),
        cost: Segment = Segment(
            label: "Kost / risico",
            value: 38
        ),
        caption: String? = nil,
        includeStyles: Bool = true
    ) {
        self.id = id
        self.benefit = benefit
        self.cost = cost
        self.caption = caption
        self.includeStyles = includeStyles
    }

    private var result: Int {
        benefit.value - cost.value
    }

    private var magnitude: Int {
        max(
            max(
                max(benefit.value, cost.value),
                abs(result)
            ),
            1
        )
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.figure(
                    [
                        "id": id,
                        "class": ClassName.root
                    ]
                ) {
                    HTML.div(
                        [
                            "class": ClassName.stage,
                            "role": "img",
                            "aria-label": "Gedragseconomie: gedrag wordt waarschijnlijker wanneer verwachte opbrengst groter is dan verwachte kost."
                        ]
                    ) {
                        row(
                            segment: benefit,
                            fillClass: ClassName.benefit
                        )

                        row(
                            segment: cost,
                            fillClass: ClassName.cost
                        )

                        HTML.div(["class": ClassName.equation]) {
                            HTML.span {
                                HTML.text("\(benefit.label) - \(cost.label)")
                            }

                            HTML.span(
                                [
                                    "class": resultClass
                                ]
                            ) {
                                HTML.text(resultText)
                            }
                        }
                    }

                    if let caption, !caption.isEmpty {
                        HTML.figcaption(["class": ClassName.caption]) {
                            HTML.text(caption)
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    private var resultClass: String {
        result >= 0
            ? "\(ClassName.result) \(ClassName.resultPositive)"
            : "\(ClassName.result) \(ClassName.resultNegative)"
    }

    private var resultText: String {
        result >= 0 ? "+\(result)" : "\(result)"
    }

    private func row(
        segment: Segment,
        fillClass: String
    ) -> any HTMLNode {
        HTML.div(["class": ClassName.row]) {
            HTML.div(["class": ClassName.rowLabel]) {
                HTML.text(segment.label)
            }

            HTML.div(["class": ClassName.track]) {
                HTML.div(
                    [
                        "class": "\(ClassName.fill) \(fillClass)",
                        "style": "--wc-benefit-cost-width: \(percentage(segment.value));"
                    ]
                ) {}
            }

            HTML.div(["class": ClassName.value]) {
                HTML.text("\(segment.value)")
            }
        }
    }

    private func percentage(
        _ value: Int
    ) -> String {
        let clamped = max(0, value)
        let percent = clamped * 100 / magnitude

        return "\(percent)%"
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("width", "min(760px, 100%)"),
                    CSS.decl("margin", "28px 0"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)")
                ),

                CSS.rule(
                    ".\(ClassName.row)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(96px, 140px) minmax(0, 1fr) minmax(42px, auto)"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "12px")
                ),

                CSS.rule(
                    ".\(ClassName.rowLabel)",
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("line-height", "1.1")
                ),

                CSS.rule(
                    ".\(ClassName.track)",
                    CSS.decl("height", "16px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 8%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--text-color) 8%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.fill)",
                    CSS.decl("height", "100%"),
                    CSS.decl("width", "var(--wc-benefit-cost-width)"),
                    CSS.decl("border-radius", "inherit")
                ),

                CSS.rule(
                    ".\(ClassName.benefit)",
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 72%, var(--text-color) 12%)")
                ),

                CSS.rule(
                    ".\(ClassName.cost)",
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 48%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.value)",
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("text-align", "right")
                ),

                CSS.rule(
                    ".\(ClassName.equation)",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("padding-top", "12px"),
                    CSS.decl("border-top", "1px solid var(--border-color)"),
                    CSS.decl("font-size", ".88rem"),
                    CSS.decl("font-weight", "680")
                ),

                CSS.rule(
                    ".\(ClassName.result)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("min-width", "52px"),
                    CSS.decl("height", "30px"),
                    CSS.decl("padding", "0 10px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 9%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--text-color) 10%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.caption)",
                    CSS.decl("margin", "10px 0 0"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--muted-text-color)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".\(ClassName.stage)",
                        CSS.decl("padding", "14px")
                    ),

                    CSS.rule(
                        ".\(ClassName.row)",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "7px")
                    ),

                    CSS.rule(
                        ".\(ClassName.value)",
                        CSS.decl("text-align", "left")
                    ),

                    CSS.rule(
                        ".\(ClassName.equation)",
                        CSS.decl("align-items", "flex-start"),
                        CSS.decl("flex-direction", "column")
                    )
                )
            ]
        )
    }
}
