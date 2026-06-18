import Constructors
import CSS
import HTML

public struct ReferencePreviewLink: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-reference-preview"
        static let trigger = "wc-reference-preview__trigger"
        static let card = "wc-reference-preview__card"
        static let eyebrow = "wc-reference-preview__eyebrow"
        static let title = "wc-reference-preview__title"
        static let meta = "wc-reference-preview__meta"
        static let metaItem = "wc-reference-preview__meta-item"
        static let comments = "wc-reference-preview__comments"
        static let comment = "wc-reference-preview__comment"
        static let commentPointer = "wc-reference-preview__comment-pointer"
        static let footer = "wc-reference-preview__footer"
        static let anchorLink = "wc-reference-preview__anchor-link"
    }

    public let reference: any Referencable
    public let number: Int
    public let comments: [Reference.Comment]
    public let anchorHref: String?
    public let includeStyles: Bool

    public init(
        reference: any Referencable,
        number: Int,
        comments: [Reference.Comment] = [],
        anchorHref: String? = nil,
        includeStyles: Bool = true
    ) {
        self.reference = reference
        self.number = number
        self.comments = comments
        self.anchorHref = anchorHref
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        let cardID = "reference-preview-\(number)"

        return .body(
            [
                HTML.sup(
                    [
                        "class": "\(ClassName.root) cite",
                        "data-cite": "\(number)",
                        "id": "cite-\(number)"
                    ]
                ) {
                    HTML.button(
                        [
                            "class": ClassName.trigger,
                            "type": "button",
                            "aria-label": "Toon bron \(number)",
                            "aria-describedby": cardID
                        ]
                    ) {
                        HTML.text("[\(number)]")
                    }

                    HTML.span(
                        [
                            "class": ClassName.card,
                            "id": cardID,
                            "role": "note"
                        ]
                    ) {
                        HTML.span([ "class": ClassName.eyebrow ]) {
                            HTML.text("Bron \(number)")
                        }

                        titleNode()

                        metaNodes()

                        commentNodes()

                        if let anchorHref, !anchorHref.isEmpty {
                            HTML.span([ "class": ClassName.footer ]) {
                                HTML.a(
                                    anchorHref,
                                    [ "class": ClassName.anchorLink ]
                                ) {
                                    HTML.text("Naar referentieblok")
                                }
                            }
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    private func titleNode() -> any HTMLNode {
        if reference.url.isEmpty {
            return HTML.span([ "class": ClassName.title ]) {
                HTML.text(reference.title)
            }
        }

        return HTML.a(
            reference.url,
            [
                "class": ClassName.title,
                "target": "_blank",
                "rel": "noopener noreferrer"
            ]
        ) {
            HTML.text(reference.title)
        }
    }

    private func metaNodes() -> any HTMLNode {
        HTML.span([ "class": ClassName.meta ]) {
            if let author = reference.authorLine, !author.isEmpty {
                HTML.span([ "class": ClassName.metaItem ]) {
                    HTML.text(author)
                }
            }

            if let date = reference.dateISO8601, !date.isEmpty {
                HTML.el(
                    "time",
                    [
                        "class": ClassName.metaItem,
                        "datetime": date
                    ]
                ) {
                    HTML.text(date)
                }
            }

            if let doi = reference.doi, !doi.isEmpty {
                HTML.span([ "class": ClassName.metaItem ]) {
                    HTML.text("DOI: \(doi)")
                }
            }
        }
    }

    private func commentNodes() -> any HTMLNode {
        HTML.span([ "class": ClassName.comments ]) {
            for comment in comments where !comment.text.isEmpty {
                commentNode(comment)
            }
        }
    }

    private func commentNode(
        _ comment: Reference.Comment
    ) -> any HTMLNode {
        HTML.span([ "class": ClassName.comment ]) {
            if !comment.pointers.isEmpty {
                HTML.span([ "class": ClassName.commentPointer ]) {
                    HTML.text("[\(comment.pointers.map(String.init).joined(separator: ", "))]")
                }
            }

            HTML.text(comment.text)
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("position", "relative"),
                    CSS.decl("z-index", "0"),
                    CSS.decl("display", "inline-block"),
                    CSS.decl("vertical-align", "super"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("isolation", "isolate"),
                    CSS.decl("--wc-reference-preview-surface", "var(--surface-color, #fff)"),
                    CSS.decl("--wc-reference-preview-soft", "var(--surface-soft-color, #f1f5f9)"),
                    CSS.decl("--wc-reference-preview-border", "var(--border-color, rgba(15, 23, 42, .12))"),
                    CSS.decl("--wc-reference-preview-ink", "var(--text-color, #202124)"),
                    CSS.decl("--wc-reference-preview-muted", "var(--muted-text-color, rgba(32, 33, 36, .66))"),
                    CSS.decl("--wc-reference-preview-accent", "var(--link-color, #2563eb)")
                ),

                CSS.rule(
                    ".\(ClassName.root):hover, .\(ClassName.root):focus-within",
                    CSS.decl("z-index", "1000")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.root)",
                    CSS.decl("--wc-reference-preview-surface", "var(--surface-color, #1b1c1f)"),
                    CSS.decl("--wc-reference-preview-soft", "var(--surface-soft-color, #232429)"),
                    CSS.decl("--wc-reference-preview-border", "var(--border-color, rgba(255, 255, 255, .13))"),
                    CSS.decl("--wc-reference-preview-ink", "var(--text-color, #f4f4f5)"),
                    CSS.decl("--wc-reference-preview-muted", "var(--muted-text-color, rgba(244, 244, 245, .68))")
                ),

                CSS.rule(
                    ".\(ClassName.trigger)",
                    CSS.decl("-webkit-appearance", "none"),
                    CSS.decl("appearance", "none"),
                    CSS.decl("border", "0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("margin", "0"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", ".72em"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("color", "var(--wc-reference-preview-accent)"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(ClassName.trigger):hover, .\(ClassName.trigger):focus-visible",
                    CSS.decl("text-decoration", "underline"),
                    CSS.decl("text-decoration-thickness", ".08em"),
                    CSS.decl("text-underline-offset", ".16em")
                ),

                CSS.rule(
                    ".\(ClassName.card)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "50%"),
                    CSS.decl("bottom", "calc(100% + 12px)"),
                    CSS.decl("z-index", "1000"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "7px"),
                    CSS.decl("width", "min(420px, calc(100vw - 32px))"),
                    CSS.decl("min-width", "300px"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("border", "1px solid var(--wc-reference-preview-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-reference-preview-surface) 96%, var(--wc-reference-preview-ink) 4%)"),
                    CSS.decl("box-shadow", "0 20px 52px rgba(15, 23, 42, .18)"),
                    CSS.decl("color", "var(--wc-reference-preview-ink)"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "400"),
                    CSS.decl("line-height", "1.35"),
                    CSS.decl("text-align", "left"),
                    CSS.decl("opacity", "0"),
                    CSS.decl("visibility", "hidden"),
                    CSS.decl("pointer-events", "none"),
                    CSS.decl("transform", "translate(-50%, 8px) scale(.985)"),
                    CSS.decl("transform-origin", "bottom center"),
                    CSS.decl("transition", "opacity .16s ease, transform .16s ease, visibility 0s linear .16s")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.card)",
                    CSS.decl("box-shadow", "0 20px 48px rgba(0, 0, 0, .34)")
                ),

                CSS.rule(
                    ".\(ClassName.root):hover .\(ClassName.card), .\(ClassName.root):focus-within .\(ClassName.card)",
                    CSS.decl("opacity", "1"),
                    CSS.decl("visibility", "visible"),
                    CSS.decl("pointer-events", "auto"),
                    CSS.decl("transform", "translate(-50%, 0) scale(1)"),
                    CSS.decl("transition-delay", "0s")
                ),

                CSS.rule(
                    ".\(ClassName.card)::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "50%"),
                    CSS.decl("bottom", "-7px"),
                    CSS.decl("width", "14px"),
                    CSS.decl("height", "14px"),
                    CSS.decl("border-right", "1px solid var(--wc-reference-preview-border)"),
                    CSS.decl("border-bottom", "1px solid var(--wc-reference-preview-border)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-reference-preview-surface) 96%, var(--wc-reference-preview-ink) 4%)"),
                    CSS.decl("transform", "translateX(-50%) rotate(45deg)")
                ),

                CSS.rule(
                    ".\(ClassName.eyebrow)",
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--wc-reference-preview-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.title)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("width", "fit-content"),
                    CSS.decl("font-size", ".98rem"),
                    CSS.decl("font-weight", "820"),
                    CSS.decl("letter-spacing", "-.01em"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("color", "var(--wc-reference-preview-ink)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    "a.\(ClassName.title):hover, a.\(ClassName.title):focus-visible",
                    CSS.decl("color", "var(--wc-reference-preview-accent)"),
                    CSS.decl("text-decoration", "underline"),
                    CSS.decl("text-decoration-thickness", ".08em"),
                    CSS.decl("text-underline-offset", ".18em")
                ),

                CSS.rule(
                    ".\(ClassName.meta)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "5px")
                ),

                CSS.rule(
                    ".\(ClassName.metaItem)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("width", "fit-content"),
                    CSS.decl("padding", "3px 7px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("color", "var(--wc-reference-preview-accent)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-reference-preview-accent) 10%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.comments)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("margin-top", "2px")
                ),

                CSS.rule(
                    ".\(ClassName.comment)",
                    CSS.decl("display", "block"),
                    CSS.decl("padding", "8px 10px"),
                    CSS.decl("border", "1px solid var(--wc-reference-preview-border)"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-reference-preview-soft) 60%, transparent)"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("line-height", "1.4"),
                    CSS.decl("color", "var(--wc-reference-preview-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.commentPointer)",
                    CSS.decl("margin-right", "5px"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("color", "var(--wc-reference-preview-accent)")
                ),

                CSS.rule(
                    ".\(ClassName.footer)",
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "flex-start"),
                    CSS.decl("padding-top", "2px")
                ),

                CSS.rule(
                    ".\(ClassName.anchorLink)",
                    CSS.decl("font-size", ".74rem"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("line-height", "1.2"),
                    CSS.decl("color", "var(--wc-reference-preview-accent)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".\(ClassName.anchorLink):hover, .\(ClassName.anchorLink):focus-visible",
                    CSS.decl("text-decoration", "underline"),
                    CSS.decl("text-decoration-thickness", ".08em"),
                    CSS.decl("text-underline-offset", ".18em")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".\(ClassName.card)",
                        CSS.decl("position", "fixed"),
                        CSS.decl("left", "max(14px, env(safe-area-inset-left))"),
                        CSS.decl("right", "max(14px, env(safe-area-inset-right))"),
                        CSS.decl("bottom", "calc(88px + env(safe-area-inset-bottom))"),
                        CSS.decl("width", "auto"),
                        CSS.decl("min-width", "0"),
                        CSS.decl("max-width", "none"),
                        CSS.decl("max-height", "min(52vh, 420px)"),
                        CSS.decl("overflow", "auto"),
                        CSS.decl("transform", "translateY(8px) scale(.985)"),
                        CSS.decl("transform-origin", "center bottom")
                    ),

                    CSS.rule(
                        ".\(ClassName.root):hover .\(ClassName.card), .\(ClassName.root):focus-within .\(ClassName.card)",
                        CSS.decl("transform", "translateY(0) scale(1)")
                    ),

                    CSS.rule(
                        ".\(ClassName.card)::after",
                        CSS.decl("display", "none")
                    )
                )
            ]
        )
    }
}
