import Constructors
import CSS
import HTML

public struct QuizResultReport: ReusableComponent, Sendable {
    public let itemCount: Int

    public init(
        itemCount: Int
    ) {
        self.itemCount = itemCount
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.section(
                    [
                        "class": "wc-quiz-report",
                        "data-quiz-report": "",
                        "aria-label": "Quizrapport"
                    ]
                ) {
                    HTML.div(["class": "wc-quiz-report__header"]) {
                        HTML.div {
                            HTML.p(["class": "wc-quiz-report__eyebrow"]) {
                                HTML.text("Resultaat")
                            }

                            HTML.h2 {
                                HTML.text("Quizrapport")
                            }

                            HTML.p(["data-quiz-report-lead": ""]) {
                                HTML.text("Beantwoord vragen om je rapport op te bouwen.")
                            }
                        }

                        HTML.div(["class": "wc-quiz-report__actions"]) {
                            HTML.button(
                                [
                                    "type": "button",
                                    "class": "wc-quiz-report__button",
                                    "data-quiz-report-toggle": "",
                                    "aria-expanded": "false"
                                ]
                            ) {
                                HTML.text("Toon details")
                            }

                            HTML.button(
                                [
                                    "type": "button",
                                    "class": "wc-quiz-report__button wc-quiz-report__button--print",
                                    "data-quiz-report-print": ""
                                ]
                            ) {
                                HTML.text("Print rapport")
                            }
                        }
                    }

                    HTML.div(["class": "wc-quiz-report__metrics"]) {
                        metric("Score", "Nog geen score", "data-quiz-report-score")
                        metric("Voortgang", "0 van \(itemCount)", "data-quiz-report-answered")
                        metric("Tijd", "0s", "data-quiz-report-time")
                        metric("Pogingen", "0", "data-quiz-report-attempts")
                        metric("Hints", "0 gebruikt", "data-quiz-report-hints")
                    }

                    HTML.div(
                        [
                            "class": "wc-quiz-report__details",
                            "data-quiz-report-details": "",
                            "data-quiz-report-details-state": "collapsed",
                            "aria-hidden": "true"
                        ]
                    ) {
                        HTML.div(["class": "wc-quiz-report__focus"]) {
                            HTML.h3 {
                                HTML.text("Focusgebieden")
                            }

                            HTML.div(["data-quiz-report-focus": ""]) {
                                HTML.p(["class": "wc-quiz-report__empty"]) {
                                    HTML.text("Nog geen focusgebied beschikbaar.")
                                }
                            }
                        }

                        HTML.div(["class": "wc-quiz-report__questions"]) {
                            HTML.h3 {
                                HTML.text("Vraagdetails")
                            }

                            HTML.div(["data-quiz-report-rows": ""]) {
                                HTML.p(["class": "wc-quiz-report__empty"]) {
                                    HTML.text("Nog geen vragen beantwoord.")
                                }
                            }
                        }
                    }
                }
            ],
            stylesheets: [
                Self.stylesheet()
            ]
        )
    }

    private func metric(
        _ label: String,
        _ value: String,
        _ dataAttribute: String
    ) -> any HTMLNode {
        HTML.div(["class": "wc-quiz-report__metric"]) {
            HTML.span {
                HTML.text(label)
            }

            HTML.strong([dataAttribute: ""]) {
                HTML.text(value)
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-quiz-report",
                    CSS.decl("margin-top", "24px"),
                    CSS.decl("padding", "22px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "24px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("box-shadow", "0 18px 44px rgba(15, 23, 42, .06)")
                ),

                CSS.rule(
                    ".wc-quiz-report__header",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) auto"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("align-items", "start")
                ),

                CSS.rule(
                    ".wc-quiz-report__eyebrow",
                    CSS.decl("margin", "0 0 8px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-report h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.35rem"),
                    CSS.decl("line-height", "1.12"),
                    CSS.decl("letter-spacing", "-.025em")
                ),

                CSS.rule(
                    ".wc-quiz-report p",
                    CSS.decl("margin", "8px 0 0"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-report__actions",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("justify-content", "flex-end")
                ),

                CSS.rule(
                    ".wc-quiz-report__button",
                    CSS.decl("appearance", "none"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("padding", "9px 13px"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".wc-quiz-report__button--print",
                    CSS.decl("border-color", "var(--link-color)"),
                    CSS.decl("background", "var(--link-color)"),
                    CSS.decl("color", "white")
                ),

                CSS.rule(
                    ".wc-quiz-report__metrics",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(5, minmax(0, 1fr))"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("margin-top", "18px")
                ),

                CSS.rule(
                    ".wc-quiz-report__metric",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 92%, var(--text-color) 8%)")
                ),

                CSS.rule(
                    ".wc-quiz-report__metric span",
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("letter-spacing", ".1em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-report__metric strong",
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".wc-quiz-report__details",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(220px, .75fr) minmax(0, 1.25fr)"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("will-change", "max-height, opacity, transform, margin-top"),
                    CSS.decl("transition", "max-height .28s ease, opacity .2s ease, transform .28s ease, margin-top .28s ease")
                ),

                CSS.rule(
                    ".wc-quiz-report__details[data-quiz-report-details-state=\"collapsed\"]",
                    CSS.decl("max-height", "0"),
                    CSS.decl("margin-top", "0"),
                    CSS.decl("opacity", "0"),
                    CSS.decl("transform", "translateY(-6px)"),
                    CSS.decl("pointer-events", "none")
                ),

                CSS.rule(
                    ".wc-quiz-report__details[data-quiz-report-details-state=\"expanded\"]",
                    CSS.decl("max-height", "1400px"),
                    CSS.decl("margin-top", "18px"),
                    CSS.decl("opacity", "1"),
                    CSS.decl("transform", "translateY(0)"),
                    CSS.decl("pointer-events", "auto")
                ),

                CSS.rule(
                    ".wc-quiz-report__focus, .wc-quiz-report__questions",
                    CSS.decl("padding", "16px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "20px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)")
                ),

                CSS.rule(
                    ".wc-quiz-report h3",
                    CSS.decl("margin", "0 0 12px"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("letter-spacing", ".1em"),
                    CSS.decl("text-transform", "uppercase")
                ),

                CSS.rule(
                    ".wc-quiz-report__focus-list, .wc-quiz-report__row-list",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("list-style", "none")
                ),

                CSS.rule(
                    ".wc-quiz-report__focus-list li, .wc-quiz-report__row",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("padding", "12px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))")
                ),

                CSS.rule(
                    ".wc-quiz-report__row-head",
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".wc-quiz-report__row-meta",
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--muted-text-color)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 860px)",
                    CSS.rule(
                        ".wc-quiz-report__header",
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        ".wc-quiz-report__actions",
                        CSS.decl("justify-content", "flex-start")
                    ),
                    CSS.rule(
                        ".wc-quiz-report__metrics",
                        CSS.decl("grid-template-columns", "1fr 1fr")
                    ),
                    CSS.rule(
                        ".wc-quiz-report__details",
                        CSS.decl("grid-template-columns", "1fr")
                    )
                ),

                CSS.media(
                    "(max-width: 560px)",
                    CSS.rule(
                        ".wc-quiz-report__metrics",
                        CSS.decl("grid-template-columns", "1fr")
                    )
                ),

                CSS.media(
                    "print",
                    CSS.rule(
                        ".wc-quiz-printing-report body *",
                        CSS.decl("visibility", "hidden")
                    ),
                    CSS.rule(
                        ".wc-quiz-printing-report .wc-quiz-report__details",
                        CSS.decl("max-height", "none"),
                        CSS.decl("margin-top", "18px"),
                        CSS.decl("opacity", "1"),
                        CSS.decl("overflow", "visible"),
                        CSS.decl("transform", "none")
                    ),
                    CSS.rule(
                        ".wc-quiz-printing-report .wc-quiz-report, .wc-quiz-printing-report .wc-quiz-report *",
                        CSS.decl("visibility", "visible")
                    ),
                    CSS.rule(
                        ".wc-quiz-printing-report .wc-quiz-report",
                        CSS.decl("position", "absolute"),
                        CSS.decl("inset", "0"),
                        CSS.decl("margin", "0"),
                        CSS.decl("box-shadow", "none")
                    ),
                    CSS.rule(
                        ".wc-quiz-report__actions",
                        CSS.decl("display", "none !important")
                    )
                )
            ]
        )
    }
}
