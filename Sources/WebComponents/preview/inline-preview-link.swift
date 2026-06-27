import Constructors
import CSS
import HTML

public struct InlinePreviewLink: ReusableComponent, Sendable {
    public enum Kind: String, Sendable {
        case reference
        case footnote
    }

    public let kind: Kind
    public let number: Int
    public let triggerLabel: String
    public let accessibilityLabel: String
    public let rootID: String
    public let cardID: String
    public let includeStyles: Bool
    public let cardContent: @Sendable () -> HTMLFragment

    public init(
        kind: Kind,
        number: Int,
        triggerLabel: String? = nil,
        accessibilityLabel: String,
        rootID: String? = nil,
        cardID: String? = nil,
        includeStyles: Bool = true,
        cardContent: @escaping @Sendable () -> HTMLFragment
    ) {
        self.kind = kind
        self.number = number
        self.triggerLabel = triggerLabel ?? "[\(number)]"
        self.accessibilityLabel = accessibilityLabel
        self.rootID = rootID ?? "\(kind.rawValue)-ref-\(number)"
        self.cardID = cardID ?? "\(kind.rawValue)-preview-\(number)"
        self.includeStyles = includeStyles
        self.cardContent = cardContent
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.sup(
                    [
                        "id": rootID,
                        "class": "wc-reference-preview wc-inline-preview wc-inline-preview--\(kind.rawValue) \(kind.rawValue)",
                        "data-inline-preview": kind.rawValue,
                        "data-preview-kind": kind.rawValue,
                        "data-preview-number": "\(number)"
                    ]
                ) {
                    HTML.button(
                        [
                            "class": "wc-reference-preview__trigger wc-inline-preview__trigger",
                            "type": "button",
                            "aria-label": accessibilityLabel,
                            "aria-describedby": cardID
                        ]
                    ) {
                        HTML.text(triggerLabel)
                    }

                    HTML.span(
                        [
                            "class": "wc-reference-preview__card wc-inline-preview__card",
                            "id": cardID,
                            "role": "note"
                        ]
                    ) {
                        cardContent()
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public static func stylesheet() -> CSSStyleSheet {
        ReferencePreviewLink.stylesheet()
    }
}
