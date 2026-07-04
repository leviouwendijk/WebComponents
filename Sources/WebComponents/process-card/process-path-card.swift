import Constructors
import CSS
import HTML

public struct ProcessPathCard: ReusableComponent, Sendable {
    public struct Step: Sendable {
        public let id: String?
        public let eyebrow: String?
        public let title: String
        public let summary: String
        public let detail: String?
        public let chips: [String]

        public init(
            id: String? = nil,
            eyebrow: String? = nil,
            title: String,
            summary: String,
            detail: String? = nil,
            chips: [String] = []
        ) {
            self.id = id
            self.eyebrow = eyebrow
            self.title = title
            self.summary = summary
            self.detail = detail
            self.chips = chips
        }
    }

    private enum ClassName {
        static let root = "wc-process-path-card"
        static let stage = "wc-process-path-card__stage"

        static let header = "wc-process-path-card__header"
        static let eyebrow = "wc-process-path-card__eyebrow"
        static let title = "wc-process-path-card__title"
        static let lead = "wc-process-path-card__lead"

        static let steps = "wc-process-path-card__steps"
        static let step = "wc-process-path-card__step"
        static let marker = "wc-process-path-card__marker"
        static let index = "wc-process-path-card__index"
        static let copy = "wc-process-path-card__copy"
        static let stepEyebrow = "wc-process-path-card__step-eyebrow"
        static let stepTitle = "wc-process-path-card__step-title"
        static let stepSummary = "wc-process-path-card__step-summary"
        static let stepDetail = "wc-process-path-card__step-detail"

        static let chips = "wc-process-path-card__chips"
        static let chip = "wc-process-path-card__chip"

        static let caption = "wc-process-path-card__caption"
    }

    public let id: String
    public let eyebrow: String?
    public let title: String
    public let lead: String?
    public let label: String
    public let steps: [Step]
    public let caption: String?
    public let includeStyles: Bool

    public init(
        id: String = "process-path-card",
        eyebrow: String? = nil,
        title: String,
        lead: String? = nil,
        label: String = "hoogtepunten",
        steps: [Step],
        caption: String? = nil,
        includeStyles: Bool = true
    ) {
        self.id = id
        self.eyebrow = eyebrow
        self.title = title
        self.lead = lead
        self.label = label
        self.steps = steps
        self.caption = caption
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                node()
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    public func node() -> any HTMLNode {
        HTML.section(
            [
                "id": id,
                "class": ClassName.root,
                "data-process-path-card": ""
            ]
        ) {
            HTML.div(
                [
                    "class": ClassName.stage,
                    "data-process-path-label": normalized(label) ?? "hoogtepunten"
                ]
            ) {
                headerNode()

                HTML.ol(["class": ClassName.steps]) {
                    for pair in steps.enumerated() {
                        stepNode(
                            pair.element,
                            index: pair.offset
                        )
                    }
                }

                if let caption = normalized(caption) {
                    HTML.p(["class": ClassName.caption]) {
                        HTML.text(caption)
                    }
                }
            }
        }
    }

    private func headerNode() -> any HTMLNode {
        HTML.div(["class": ClassName.header]) {
            if let eyebrow = normalized(eyebrow) {
                HTML.p(["class": ClassName.eyebrow]) {
                    HTML.text(eyebrow)
                }
            }

            HTML.h2(["class": ClassName.title]) {
                HTML.text(title)
            }

            if let lead = normalized(lead) {
                HTML.p(["class": ClassName.lead]) {
                    HTML.text(lead)
                }
            }
        }
    }

    private func stepNode(
        _ step: Step,
        index: Int
    ) -> any HTMLNode {
        var attrs: HTMLAttribute = [
            "class": ClassName.step,
            "data-process-path-step": "\(index + 1)"
        ]

        if let id = normalized(step.id) {
            attrs.merge([
                "id": id
            ])
        }

        return HTML.li(attrs) {
            HTML.div(["class": ClassName.marker]) {
                HTML.span(["class": ClassName.index]) {
                    HTML.text(two_digit(index + 1))
                }
            }

            HTML.div(["class": ClassName.copy]) {
                if let eyebrow = normalized(step.eyebrow) {
                    HTML.p(["class": ClassName.stepEyebrow]) {
                        HTML.text(eyebrow)
                    }
                }

                HTML.h3(["class": ClassName.stepTitle]) {
                    HTML.text(step.title)
                }

                if let summary = normalized(step.summary) {
                    HTML.p(["class": ClassName.stepSummary]) {
                        HTML.text(summary)
                    }
                }

                if let detail = normalized(step.detail) {
                    HTML.p(["class": ClassName.stepDetail]) {
                        HTML.text(detail)
                    }
                }

                let chips = step.chips.compactMap(normalized)

                if !chips.isEmpty {
                    HTML.div(["class": ClassName.chips]) {
                        for chip in chips {
                            HTML.span(["class": ClassName.chip]) {
                                HTML.text(chip)
                            }
                        }
                    }
                }
            }
        }
    }

    private func normalized(
        _ value: String?
    ) -> String? {
        guard let value else {
            return nil
        }

        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private func two_digit(
        _ value: Int
    ) -> String {
        value < 10 ? "0\(value)" : "\(value)"
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("width", "min(760px, 100%)"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("margin", "1rem 0 2.65rem"),
                    CSS.decl("color", "var(--text-color, #17202a)"),
                    CSS.decl("--wc-process-path-ink", "var(--text-color, #17202a)"),
                    CSS.decl("--wc-process-path-muted", "var(--muted-text-color, rgba(32, 33, 36, .66))"),
                    CSS.decl("--wc-process-path-border", "var(--border-color, rgba(15, 23, 42, .13))"),
                    CSS.decl("--wc-process-path-border-soft", "color-mix(in srgb, var(--wc-process-path-border) 68%, transparent)"),
                    CSS.decl("--wc-process-path-surface", "var(--surface-color, #fff)"),
                    CSS.decl("--wc-process-path-panel", "color-mix(in srgb, var(--wc-process-path-surface) 92%, var(--wc-process-path-ink) 8%)"),
                    CSS.decl("--wc-process-path-card", "color-mix(in srgb, var(--wc-process-path-surface) 96%, var(--wc-process-path-ink) 4%)"),
                    CSS.decl("--wc-process-path-accent", "color-mix(in srgb, var(--wc-process-path-ink) 54%, var(--wc-process-path-muted))")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.root)",
                    CSS.decl("--wc-process-path-ink", "var(--text-color, #f4f4f5)"),
                    CSS.decl("--wc-process-path-muted", "var(--muted-text-color, rgba(244, 244, 245, .68))"),
                    CSS.decl("--wc-process-path-border", "var(--border-color, rgba(255, 255, 255, .13))"),
                    CSS.decl("--wc-process-path-border-soft", "color-mix(in srgb, var(--wc-process-path-border) 70%, transparent)"),
                    CSS.decl("--wc-process-path-surface", "var(--surface-color, #1b1c1f)"),
                    CSS.decl("--wc-process-path-panel", "color-mix(in srgb, var(--wc-process-path-surface) 90%, var(--wc-process-path-ink) 10%)"),
                    CSS.decl("--wc-process-path-card", "color-mix(in srgb, var(--wc-process-path-surface) 91%, var(--wc-process-path-ink) 9%)")
                ),

                CSS.rule(
                    ".\(ClassName.root), .\(ClassName.root) *",
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("padding", "22px 22px 24px"),
                    CSS.decl("border", "1px solid var(--wc-process-path-border-soft)"),
                    CSS.decl("border-radius", "24px"),
                    CSS.decl("background", "var(--wc-process-path-panel)"),
                    CSS.decl("box-shadow", "0 18px 42px rgba(15, 23, 42, .05)"),
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".\(ClassName.stage)::after",
                    CSS.decl("content", "attr(data-process-path-label)"),
                    CSS.decl("position", "absolute"),
                    CSS.decl("top", "16px"),
                    CSS.decl("right", "18px"),
                    CSS.decl("padding", "4px 9px"),
                    CSS.decl("border", "1px solid var(--wc-process-path-border-soft)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-process-path-surface) 88%, transparent)"),
                    CSS.decl("font-size", ".64rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".11em"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--wc-process-path-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.header)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("max-width", "560px"),
                    CSS.decl("padding-right", "140px")
                ),

                CSS.rule(
                    ".\(ClassName.eyebrow)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".14em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--wc-process-path-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.title)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(1.22rem, 1.7vw, 1.52rem)"),
                    CSS.decl("line-height", "1.08"),
                    CSS.decl("letter-spacing", "-.035em"),
                    CSS.decl("color", "var(--wc-process-path-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.lead)",
                    CSS.decl("margin", "2px 0 0"),
                    CSS.decl("max-width", "58ch"),
                    CSS.decl("font-size", ".96rem"),
                    CSS.decl("line-height", "1.5"),
                    CSS.decl("color", "var(--wc-process-path-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.steps)",
                    CSS.decl("position", "relative"),
                    CSS.decl("list-style", "none"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("counter-reset", "process-path")
                ),

                CSS.rule(
                    ".\(ClassName.steps)::before",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("top", "32px"),
                    CSS.decl("bottom", "32px"),
                    CSS.decl("left", "17px"),
                    CSS.decl("width", "1px"),
                    CSS.decl("background", "var(--wc-process-path-border-soft)"),
                    CSS.decl("pointer-events", "none")
                ),

                CSS.rule(
                    ".\(ClassName.step)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "36px minmax(0, 1fr)"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("padding", "15px 16px"),
                    CSS.decl("border", "1px solid var(--wc-process-path-border-soft)"),
                    CSS.decl("border-radius", "17px"),
                    CSS.decl("background", "var(--wc-process-path-card)")
                ),

                CSS.rule(
                    ".\(ClassName.step):not(:last-child)::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "29px"),
                    CSS.decl("bottom", "-10px"),
                    CSS.decl("width", "9px"),
                    CSS.decl("height", "9px"),
                    CSS.decl("border-right", "1px solid var(--wc-process-path-border-soft)"),
                    CSS.decl("border-bottom", "1px solid var(--wc-process-path-border-soft)"),
                    CSS.decl("transform", "rotate(45deg)"),
                    CSS.decl("background", "transparent")
                ),

                CSS.rule(
                    ".\(ClassName.marker)",
                    CSS.decl("position", "relative"),
                    CSS.decl("z-index", "1"),
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "34px"),
                    CSS.decl("height", "34px"),
                    CSS.decl("border", "1px solid var(--wc-process-path-border-soft)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--wc-process-path-surface)"),
                    CSS.decl("color", "var(--wc-process-path-accent)")
                ),

                CSS.rule(
                    ".\(ClassName.index)",
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, monospace"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("letter-spacing", "-.04em")
                ),

                CSS.rule(
                    ".\(ClassName.copy)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(ClassName.stepEyebrow)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "740"),
                    CSS.decl("letter-spacing", ".10em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--wc-process-path-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.stepTitle)",
                    CSS.decl("margin", "0"),
                    CSS.decl("max-width", "34ch"),
                    CSS.decl("font-size", "1.02rem"),
                    CSS.decl("line-height", "1.16"),
                    CSS.decl("letter-spacing", "-.025em"),
                    CSS.decl("color", "var(--wc-process-path-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.stepSummary)",
                    CSS.decl("margin", "0"),
                    CSS.decl("max-width", "52ch"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.42"),
                    CSS.decl("color", "var(--wc-process-path-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.stepDetail)",
                    CSS.decl("margin", "2px 0 0"),
                    CSS.decl("max-width", "58ch"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("line-height", "1.4"),
                    CSS.decl("color", "var(--wc-process-path-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.chips)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("margin-top", "6px")
                ),

                CSS.rule(
                    ".\(ClassName.chip)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("min-height", "22px"),
                    CSS.decl("padding", "2px 8px"),
                    CSS.decl("border", "1px solid var(--wc-process-path-border-soft)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-process-path-surface) 82%, var(--wc-process-path-ink) 18%)"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "680"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("color", "var(--wc-process-path-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.caption)",
                    CSS.decl("margin", "0"),
                    CSS.decl("padding-top", "2px"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--wc-process-path-muted)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 680px)",
                    CSS.rule(
                        ".\(ClassName.stage)",
                        CSS.decl("padding", "18px"),
                        CSS.decl("border-radius", "20px")
                    ),

                    CSS.rule(
                        ".\(ClassName.stage)::after",
                        CSS.decl("position", "static"),
                        CSS.decl("justify-self", "start"),
                        CSS.decl("grid-row", "1"),
                        CSS.decl("margin-bottom", "-4px")
                    ),

                    CSS.rule(
                        ".\(ClassName.header)",
                        CSS.decl("padding-right", "0")
                    ),

                    CSS.rule(
                        ".\(ClassName.step)",
                        CSS.decl("grid-template-columns", "34px minmax(0, 1fr)"),
                        CSS.decl("padding", "14px")
                    ),

                    CSS.rule(
                        ".\(ClassName.steps)::before",
                        CSS.decl("left", "16px")
                    ),

                    CSS.rule(
                        ".\(ClassName.step):not(:last-child)::after",
                        CSS.decl("left", "28px")
                    )
                )
            ]
        )
    }
}
