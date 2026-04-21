import Foundation
import Constructors
import HTML

public struct GoogleTagManagerNoScript: ReusableComponent {
    public let id: String
    public let comment: String?

    public init(
        id: String,
        comment: String? = "Google Tag Manager (noscript)"
    ) {
        self.id = id
        self.comment = comment
    }

    public var nodes: ReusableComponentNodes {
        let trimmed = id.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            return .init()
        }

        var body: HTMLFragment = []

        if let comment, !comment.isEmpty {
            body.append(
                HTML.comment(comment)
            )
        }

        body.append(
            HTML.el("noscript") {
                HTML.el(
                    "iframe",
                    [
                        "src": "https://www.googletagmanager.com/ns.html?id=\(trimmed)",
                        "height": "0",
                        "width": "0",
                        "style": "display:none;visibility:hidden"
                    ]
                ) {}
            }
        )

        return .body(body)
    }
}
