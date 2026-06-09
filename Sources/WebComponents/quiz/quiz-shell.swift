import Constructors
import CSS
import HTML

public struct QuizShell: ReusableComponent, Sendable {
    public init() {}

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.div(
                    [
                        "class": "wc-quiz-shell",
                        "data-quiz-shell": "",
                        "hidden": ""
                    ]
                ) {
                    HTML.button(
                        [
                            "class": "wc-quiz-backdrop",
                            "type": "button",
                            "aria-label": "Sluit vraag",
                            "data-quiz-close": ""
                        ]
                    ) {}

                    HTML.div(
                        [
                            "class": "wc-quiz-panel",
                            "data-quiz-panel": "",
                            "role": "dialog",
                            "aria-modal": "true",
                            "aria-labelledby": "wc-quiz-panel-title",
                            "tabindex": "-1"
                        ]
                    ) {}
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
                    ".wc-quiz-shell[hidden]",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".wc-quiz-shell",
                    CSS.decl("position", "fixed"),
                    CSS.decl("inset", "0"),
                    CSS.decl("z-index", "4000"),
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("padding", "24px"),
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".wc-quiz-backdrop",
                    CSS.decl("position", "absolute"),
                    CSS.decl("inset", "0"),
                    CSS.decl("border", "0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("background", "rgba(15, 23, 42, .54)"),
                    CSS.decl("backdrop-filter", "blur(10px)"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".wc-quiz-panel",
                    CSS.decl("position", "relative"),
                    CSS.decl("z-index", "1"),
                    CSS.decl("width", "min(860px, 100%)"),
                    CSS.decl("max-height", "min(820px, calc(100vh - 48px))"),
                    CSS.decl("overflow", "auto"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("padding", "24px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "28px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("box-shadow", "0 32px 90px rgba(15, 23, 42, .28)")
                ),

                CSS.rule(
                    ".wc-quiz-panel:focus",
                    CSS.decl("outline", "none")
                ),

                CSS.rule(
                    ".wc-quiz-panel:focus-visible",
                    CSS.decl("box-shadow", "0 32px 90px rgba(15, 23, 42, .28), inset 0 0 0 2px color-mix(in srgb, var(--link-color) 42%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-is-open",
                    CSS.decl("overflow", "hidden")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 760px)",
                    CSS.rule(
                        ".wc-quiz-shell",
                        CSS.decl("padding", "14px")
                    ),

                    CSS.rule(
                        ".wc-quiz-panel",
                        CSS.decl("max-height", "calc(100vh - 28px)"),
                        CSS.decl("padding", "16px"),
                        CSS.decl("border-radius", "22px")
                    )
                )
            ]
        )
    }
}
