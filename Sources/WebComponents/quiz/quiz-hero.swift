import Constructors
import CSS
import HTML

public struct QuizHero: ReusableComponent, Sendable {
    public let eyebrow: String
    public let title: String
    public let lead: String

    public init(
        eyebrow: String,
        title: String,
        lead: String
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.lead = lead
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.el(
                    "section",
                    [
                        "class": "wc-quiz__hero"
                    ]
                ) {
                    HTML.p(["class": "wc-quiz__eyebrow"]) {
                        HTML.text(eyebrow)
                    }

                    HTML.h1 {
                        HTML.text(title)
                    }

                    HTML.p(["class": "wc-quiz__lead"]) {
                        HTML.text(lead)
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
                    ".wc-quiz__hero",
                    CSS.decl("margin", "0 0 34px")
                ),

                CSS.rule(
                    ".wc-quiz__eyebrow",
                    CSS.decl("margin", "0 0 10px"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz__hero h1",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(2.1rem, 5vw, 4.4rem)"),
                    CSS.decl("line-height", ".98"),
                    CSS.decl("letter-spacing", "-.055em")
                ),

                CSS.rule(
                    ".wc-quiz__lead",
                    CSS.decl("max-width", "740px"),
                    CSS.decl("font-size", "1.05rem"),
                    CSS.decl("line-height", "1.62"),
                    CSS.decl("color", "var(--muted-text-color)")
                )
            ]
        )
    }
}
