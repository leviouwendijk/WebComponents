import Foundation
import Constructors
import HTML

public struct QuizDataScript: ReusableComponent, Sendable {
    public let set: QuizSet
    public let timerSeconds: Int?

    public init(
        set: QuizSet,
        timerSeconds: Int? = nil
    ) {
        self.set = set

        if let timerSeconds, timerSeconds > 0 {
            self.timerSeconds = timerSeconds
        } else {
            self.timerSeconds = nil
        }
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.el(
                    "script",
                    [
                        "type": "application/json",
                        "data-quiz-data": ""
                    ]
                ) {
                    HTML.raw(json())
                }
            ]
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
