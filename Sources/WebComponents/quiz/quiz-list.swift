import Foundation
import Constructors
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
        .body(
            [
                HTML.el(
                    "main",
                    [
                        "id": "content-area",
                        "class": "wc-quiz wc-quiz--list",
                        "data-quiz-root": ""
                    ]
                ) {
                    HTML.el("section", ["class": "wc-quiz__hero"]) {
                        HTML.p(["class": "wc-quiz__eyebrow"]) {
                            HTML.text(eyebrow)
                        }

                        HTML.h1 {
                            HTML.text(set.title)
                        }

                        HTML.p(["class": "wc-quiz__lead"]) {
                            HTML.text(set.lead)
                        }
                    }

                    HTML.el("section", ["class": "wc-quiz-list", "aria-label": "Vragen"]) {
                        for (index, item) in set.items.enumerated() {
                            QuizCard(
                                item: item,
                                index: index + 1
                            ).nodes.body
                        }
                    }

                    HTML.el(
                        "script",
                        [
                            "type": "application/json",
                            "data-quiz-data": ""
                        ]
                    ) {
                        HTML.raw(json())
                    }

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
                }
            ],
            stylesheets: styles ? [QuizCSS.sheet()] : [],
            scripts: script ? QuizScript().nodes.scripts : []
        )
    }

    private func json() -> String {
        let payload = QuizData(
            set,
            timerSeconds: timerSeconds
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [
            .sortedKeys
        ]

        guard let data = try? encoder.encode(payload) else {
            return "{}"
        }

        let raw = String(
            decoding: data,
            as: UTF8.self
        )

        return raw
            .replacingOccurrences(of: "&", with: "\\u0026")
            .replacingOccurrences(of: "<", with: "\\u003C")
            .replacingOccurrences(of: ">", with: "\\u003E")
    }
}
