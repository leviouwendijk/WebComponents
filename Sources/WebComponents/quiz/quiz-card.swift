import Foundation
import Constructors
import CSS
import HTML

public struct QuizCard:
    ComponentOutputProviding,
    ReusableComponent,
    Sendable
{
    public let item: QuizItem
    public let index: Int?

    private static let styleIdentifier: CSSContributionIdentifier =
        "webcomponents.quiz.card.styles"

    public init(
        item: QuizItem,
        index: Int? = nil
    ) {
        self.item = item
        self.index = index
    }

    public var output: ComponentOutput {
        ComponentOutput(
            content: ComponentContent(
                body: [
                    HTML.a(
                        "#\(item.slug)",
                        [
                            "class": "wc-quiz-card",
                            "data-quiz-card": "",
                            "data-quiz-open": item.id,
                            "data-quiz-group": item.group,
                            "data-quiz-level": item.level.rawValue,
                            "data-quiz-card-state": "unanswered",
                            "data-quiz-card-attempts": "0"
                        ]
                    ) {
                        HTML.span(["class": "wc-quiz-card__index"]) {
                            HTML.text(indexLabel)
                        }

                        HTML.div(["class": "wc-quiz-card__body"]) {
                            HTML.div(["class": "wc-quiz-card__line"]) {
                                HTML.h2 {
                                    HTML.text(item.title)
                                }

                                HTML.span(["class": "wc-quiz-card__action"]) {
                                    HTML.text("Start")
                                }
                            }

                            HTML.p {
                                HTML.text(item.prompt)
                            }

                            HTML.div(["class": "wc-quiz-card__meta"]) {
                                HTML.span {
                                    HTML.text(item.group)
                                }

                                HTML.span {
                                    HTML.text(item.level.label)
                                }

                                HTML.span {
                                    HTML.text(kindLabel)
                                }

                                HTML.span([
                                    "class": "wc-quiz-card__status",
                                    "data-quiz-card-status": ""
                                ]) {
                                    HTML.text("Onbeantwoord")
                                }

                                HTML.span([
                                    "class": "wc-quiz-card__attempts",
                                    "data-quiz-card-attempts-label": ""
                                ]) {
                                    HTML.text("0 pogingen")
                                }
                            }

                            HTML.div(
                                [
                                    "class": "wc-quiz-card__history",
                                    "data-quiz-card-history": "",
                                    "aria-hidden": "true"
                                ]
                            ) {}
                        }
                    }
                ]
            ),
            dependencies: ComponentDependencies(
                styles: CSSContributions([
                    Self.styleContribution()
                ])
            )
        )
    }

    public var nodes: ReusableComponentNodes {
        let semantic = output

        return .body(
            semantic.content.body,
            stylesheets:
                semantic
                    .dependencies
                    .styles
                    .contributions
                    .map {
                        $0.content.sheet
                    },
            scripts:
                semantic
                    .dependencies
                    .scripts
                    .contributions
                    .map(\.script)
        )
    }

    private var indexLabel: String {
        guard let index else {
            return "—"
        }

        return String(
            format: "%02d",
            index
        )
    }

    private var kindLabel: String {
        switch item.rule {
        case .one:
            return "\(item.choices.count) keuzes"

        case .many:
            return "meerdere antwoorden"

        case .text:
            return "open antwoord"
        }
    }

    private static func authoredStylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-quiz-card",
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("box-shadow", "0 18px 44px rgba(15, 23, 42, .06)")
                ),

                CSS.rule(
                    ".wc-quiz-card",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "58px minmax(0, 1fr)"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("transition", "transform 140ms ease, box-shadow 140ms ease, border-color 140ms ease, background-color 140ms ease")
                ),

                CSS.rule(
                    ".wc-quiz-card::before",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("inset", "0 auto 0 0"),
                    CSS.decl("width", "4px"),
                    CSS.decl("background", "transparent")
                ),

                CSS.rule(
                    ".wc-quiz-card[data-quiz-card-state=\"right\"]::before",
                    CSS.decl("background", "var(--success, #2E8B57)")
                ),

                CSS.rule(
                    ".wc-quiz-card[data-quiz-card-state=\"wrong\"]::before",
                    CSS.decl("background", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".wc-quiz-card[data-quiz-card-state=\"timeout\"]::before",
                    CSS.decl("background", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".wc-quiz-card[data-quiz-card-state=\"right\"]",
                    CSS.decl("border-color", "color-mix(in srgb, var(--success, #2E8B57) 28%, var(--border-color))"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--success, #2E8B57) 6%)")
                ),

                CSS.rule(
                    ".wc-quiz-card[data-quiz-card-state=\"wrong\"]",
                    CSS.decl("border-color", "color-mix(in srgb, var(--danger, #D64545) 28%, var(--border-color))"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--danger, #D64545) 6%)")
                ),

                CSS.rule(
                    ".wc-quiz-card[data-quiz-card-state=\"timeout\"]",
                    CSS.decl("border-color", "color-mix(in srgb, var(--danger, #D64545) 24%, var(--border-color))"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 95%, var(--danger, #D64545) 5%)")
                ),

                CSS.rule(
                    ".wc-quiz-card:hover",
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("transform", "translateY(-1px)"),
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 38%, var(--border-color))"),
                    CSS.decl("box-shadow", "0 22px 52px rgba(15, 23, 42, .10)")
                ),

                CSS.rule(
                    ".wc-quiz-card:focus-visible",
                    CSS.decl("outline", "2px solid var(--link-color)"),
                    CSS.decl("outline-offset", "3px")
                ),

                CSS.rule(
                    ".wc-quiz-card__index",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("width", "42px"),
                    CSS.decl("height", "42px"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 7%, transparent)"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "620"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-card__body",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".wc-quiz-card__line",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "baseline"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "16px")
                ),

                CSS.rule(
                    ".wc-quiz-card h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.08rem"),
                    CSS.decl("line-height", "1.18"),
                    CSS.decl("letter-spacing", "-.018em")
                ),

                CSS.rule(
                    ".wc-quiz-card p",
                    CSS.decl("margin", "0"),
                    CSS.decl("line-height", "1.48"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-card__meta",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".wc-quiz-card__meta span",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("height", "24px"),
                    CSS.decl("padding", "0 8px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 7%, transparent)"),
                    CSS.decl("font-size", ".74rem"),
                    CSS.decl("font-weight", "680"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-card__meta .wc-quiz-card__status",
                    CSS.decl("font-weight", "760")
                ),

                CSS.rule(
                    ".wc-quiz-card[data-quiz-card-state=\"right\"] .wc-quiz-card__status",
                    CSS.decl("background", "color-mix(in srgb, var(--success, #2E8B57) 13%, transparent)"),
                    CSS.decl("color", "var(--success, #2E8B57)")
                ),

                CSS.rule(
                    ".wc-quiz-card[data-quiz-card-state=\"wrong\"] .wc-quiz-card__status",
                    CSS.decl("background", "color-mix(in srgb, var(--danger, #D64545) 12%, transparent)"),
                    CSS.decl("color", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".wc-quiz-card[data-quiz-card-state=\"timeout\"] .wc-quiz-card__status",
                    CSS.decl("background", "color-mix(in srgb, var(--danger, #D64545) 10%, transparent)"),
                    CSS.decl("color", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".wc-quiz-card__history",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("min-height", "8px")
                ),

                CSS.rule(
                    ".wc-quiz-card__history-dot",
                    CSS.decl("display", "inline-block"),
                    CSS.decl("width", "7px"),
                    CSS.decl("height", "7px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 18%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-card__history-dot[data-quiz-history-result=\"right\"]",
                    CSS.decl("background", "var(--success, #2E8B57)")
                ),

                CSS.rule(
                    ".wc-quiz-card__history-dot[data-quiz-history-result=\"wrong\"]",
                    CSS.decl("background", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".wc-quiz-card__history-dot[data-quiz-history-result=\"timeout\"]",
                    CSS.decl("background", "color-mix(in srgb, var(--danger, #D64545) 68%, var(--warning, #E7A94E) 32%)")
                ),

                CSS.rule(
                    ".wc-quiz-card__action",
                    CSS.decl("flex", "0 0 auto"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("color", "var(--link-color)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 760px)",
                    CSS.rule(
                        ".wc-quiz-card",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "12px")
                    ),

                    CSS.rule(
                        ".wc-quiz-card__line",
                        CSS.decl("align-items", "flex-start"),
                        CSS.decl("flex-direction", "column"),
                        CSS.decl("gap", "6px")
                    )
                )
            ]
        )
    }
    private static func styleContribution() -> CSSContribution {
        let sheet = authoredStylesheet()

        let units =
            sheet.rules.map {
                CSSContributionUnit.block(
                    .rule($0)
                )
            }
            + sheet.media.map {
                CSSContributionUnit.block(
                    .media($0)
                )
            }
            + sheet.keyframes.map {
                CSSContributionUnit.block(
                    .keyframes($0)
                )
            }

        return CSS.contribution(
            styleIdentifier,
            content:
                CSSContributionSet(
                    units:
                        units
                )
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        styleContribution().content.sheet
    }
}
