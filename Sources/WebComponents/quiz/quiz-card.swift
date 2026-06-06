import Constructors
import HTML

public struct QuizCard: ReusableComponent, Sendable {
    public let item: QuizItem
    public let index: Int?

    public init(
        item: QuizItem,
        index: Int? = nil
    ) {
        self.item = item
        self.index = index
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
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

                            HTML.span(["class": "wc-quiz-card__status", "data-quiz-card-status": ""]) {
                                HTML.text("Onbeantwoord")
                            }

                            HTML.span(["class": "wc-quiz-card__attempts", "data-quiz-card-attempts-label": ""]) {
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
}
