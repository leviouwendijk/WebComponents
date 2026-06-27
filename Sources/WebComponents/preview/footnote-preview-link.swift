import Constructors
import HTML

public struct FootnotePreviewLink: ReusableComponent, Sendable {
    public let number: Int
    public let text: String
    public let anchorHref: String?
    public let includeStyles: Bool

    public init(
        number: Int,
        text: String,
        anchorHref: String? = nil,
        includeStyles: Bool = true
    ) {
        self.number = number
        self.text = text
        self.anchorHref = anchorHref
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        InlinePreviewLink(
            kind: .footnote,
            number: number,
            accessibilityLabel: "Toon noot \(number)",
            rootID: "footnote-ref-\(number)",
            cardID: "footnote-preview-\(number)",
            includeStyles: includeStyles
        ) {
            var body: HTMLFragment = [
                HTML.span([ "class": "wc-reference-preview__eyebrow wc-inline-preview__eyebrow" ]) {
                    HTML.text("Noot \(number)")
                },

                HTML.span([ "class": "wc-reference-preview__comments wc-inline-preview__body" ]) {
                    HTML.span([ "class": "wc-reference-preview__comment wc-inline-preview__text" ]) {
                        HTML.text(text)
                    }
                }
            ]

            if let anchorHref, !anchorHref.isEmpty {
                body.append(
                    HTML.span([ "class": "wc-reference-preview__footer wc-inline-preview__footer" ]) {
                        HTML.a(
                            anchorHref,
                            [ "class": "wc-reference-preview__anchor-link wc-inline-preview__anchor-link" ]
                        ) {
                            HTML.text("Naar noot")
                        }
                    }
                )
            }

            return body
        }.nodes
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }
}
