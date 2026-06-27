import Constructors
import HTML

public struct FootnotePreviewLink: ReusableComponent, Sendable {
    public let number: Int
    public let content: HTMLFragment
    public let anchorHref: String?
    public let includeStyles: Bool

    public var text: String {
        content.plaintext()
    }

    public init(
        number: Int,
        text: String,
        anchorHref: String? = nil,
        includeStyles: Bool = true
    ) {
        self.number = number
        self.content = [
            HTMLText(text)
        ]
        self.anchorHref = anchorHref
        self.includeStyles = includeStyles
    }

    public init(
        number: Int,
        content: HTMLFragment,
        anchorHref: String? = nil,
        includeStyles: Bool = true
    ) {
        self.number = number
        self.content = content
        self.anchorHref = anchorHref
        self.includeStyles = includeStyles
    }

    public init(
        number: Int,
        anchorHref: String? = nil,
        includeStyles: Bool = true,
        @HTMLBuilder content: () -> HTMLFragment
    ) {
        self.number = number
        self.content = content()
        self.anchorHref = anchorHref
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        InlinePreviewLink(
            kind: .footnote,
            number: number,
            accessibilityLabel: "Toon voetnoot \(number)",
            rootID: "footnote-ref-\(number)",
            cardID: "footnote-preview-\(number)",
            includeStyles: includeStyles
        ) {
            var body: HTMLFragment = [
                HTML.span([ "class": "wc-reference-preview__eyebrow wc-inline-preview__eyebrow" ]) {
                    HTML.text("Voetnoot \(number)")
                },

                HTML.span([ "class": "wc-reference-preview__comments wc-inline-preview__body" ]) {
                    HTML.span([ "class": "wc-reference-preview__comment wc-inline-preview__text" ]) {
                        content
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
                            HTML.text("Naar voetnoot")
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
