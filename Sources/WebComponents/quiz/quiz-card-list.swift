import Constructors
import CSS
import HTML

public struct QuizCardList: ReusableComponent, Sendable {
    public let items: [QuizItem]

    public init(
        items: [QuizItem]
    ) {
        self.items = items
    }

    public var nodes: ReusableComponentNodes {
        let cardNodes = items.enumerated().map { offset, item in
            QuizCard(
                item: item,
                index: offset + 1
            ).nodes
        }

        return .body(
            [
                HTML.el(
                    "section",
                    [
                        "class": "wc-quiz-list",
                        "aria-label": "Vragen",
                        "data-quiz-list": ""
                    ]
                ) {
                    for cardNode in cardNodes {
                        cardNode.body
                    }
                }
            ],
            stylesheets: [
                Self.stylesheet(),
                QuizCard.stylesheet()
            ]
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-quiz-list",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "1fr"),
                    CSS.decl("gap", "10px")
                )
            ]
        )
    }
}
