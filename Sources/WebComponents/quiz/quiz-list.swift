import Constructors
import CSS
import HTML

public struct QuizList: ReusableComponent, Sendable {
    public let set: QuizSet
    public let eyebrow: String
    public let timerSeconds: Int?
    public let styles: Bool
    public let script: Bool

    public init(
        set: QuizSet,
        eyebrow: String = "Oefenen",
        timerSeconds: Int? = nil,
        styles: Bool = true,
        script: Bool = true
    ) {
        self.set = set
        self.eyebrow = eyebrow

        if let timerSeconds, timerSeconds > 0 {
            self.timerSeconds = timerSeconds
        } else {
            self.timerSeconds = nil
        }

        self.styles = styles
        self.script = script
    }

    public var nodes: ReusableComponentNodes {
        let heroNodes = QuizHero(
            eyebrow: eyebrow,
            title: set.title,
            lead: set.lead
        ).nodes

        let progressNodes = QuizProgressSummary(
            itemCount: set.items.count
        ).nodes

        let cardListNodes = QuizCardList(
            items: set.items
        ).nodes

        let dataNodes = QuizDataScript(
            set: set,
            timerSeconds: timerSeconds
        ).nodes

        let shellNodes = QuizShell().nodes

        let childNodes = [
            heroNodes,
            progressNodes,
            cardListNodes,
            dataNodes,
            shellNodes
        ]

        return .body(
            [
                HTML.el(
                    "main",
                    [
                        "id": "content-area",
                        "class": "wc-quiz wc-quiz--list",
                        "data-quiz-root": ""
                    ]
                ) {
                    heroNodes.body
                    progressNodes.body
                    cardListNodes.body
                    dataNodes.body
                    shellNodes.body
                }
            ],
            stylesheets: styles
                ? [Self.stylesheet()] + childNodes.flatMap(\.stylesheets) + [QuizRuntimePanelStyles.stylesheet()]
                : [],
            scripts: script ? QuizScript().nodes.scripts : []
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-quiz",
                    CSS.decl("width", "min(980px, calc(100% - 48px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "60px 0 96px"),
                    CSS.decl("color", "var(--text-color)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 760px)",
                    CSS.rule(
                        ".wc-quiz",
                        CSS.decl("width", "calc(100% - 32px)"),
                        CSS.decl("padding", "42px 0 78px")
                    )
                )
            ]
        )
    }
}
