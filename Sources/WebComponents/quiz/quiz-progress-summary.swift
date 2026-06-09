import Constructors
import CSS
import HTML

public struct QuizProgressSummary: ReusableComponent, Sendable {
    public let itemCount: Int

    public init(
        itemCount: Int
    ) {
        self.itemCount = itemCount
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.div(
                    [
                        "class": "wc-quiz-progress",
                        "data-quiz-progress": ""
                    ]
                ) {
                    HTML.div(["class": "wc-quiz-progress__text"]) {
                        HTML.strong(["data-quiz-progress-count": ""]) {
                            HTML.text("0 van \(itemCount) beantwoord")
                        }

                        HTML.span(["data-quiz-progress-detail": ""]) {
                            HTML.text("Nog geen antwoorden")
                        }
                    }

                    HTML.button(
                        [
                            "type": "button",
                            "class": "wc-quiz-progress__reset",
                            "data-quiz-reset-all": "",
                            "disabled": ""
                        ]
                    ) {
                        HTML.text("Reset alle antwoorden")
                    }
                }
            ],
            stylesheets: [
                Self.stylesheet()
            ]
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-quiz-progress",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("margin-top", "20px"),
                    CSS.decl("padding", "14px 16px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 92%, var(--text-color) 8%)")
                ),

                CSS.rule(
                    ".wc-quiz-progress__text",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px")
                ),

                CSS.rule(
                    ".wc-quiz-progress__text strong",
                    CSS.decl("font-size", ".95rem"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".wc-quiz-progress__text span",
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-progress__reset",
                    CSS.decl("appearance", "none"),
                    CSS.decl("flex", "0 0 auto"),
                    CSS.decl("height", "34px"),
                    CSS.decl("padding", "0 12px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--danger, #D64545) 28%, var(--border-color))"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--danger, #D64545) 7%, transparent)"),
                    CSS.decl("color", "var(--danger, #D64545)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".wc-quiz-progress__reset:disabled",
                    CSS.decl("opacity", ".44"),
                    CSS.decl("cursor", "not-allowed")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 760px)",
                    CSS.rule(
                        ".wc-quiz-progress",
                        CSS.decl("align-items", "flex-start"),
                        CSS.decl("flex-direction", "column")
                    ),

                    CSS.rule(
                        ".wc-quiz-progress__reset",
                        CSS.decl("width", "100%"),
                        CSS.decl("justify-content", "center")
                    )
                )
            ]
        )
    }
}
