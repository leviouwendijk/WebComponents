import Constructors
import CSS
import HTML

public struct HoverPreviewLink: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-hover-preview"

    public let href: String
    public let label: HTMLFragment
    public let preview: HoverPreview
    public let zIndex: Int

    public init(
        href: String,
        label: HTMLFragment,
        preview: HoverPreview,
        zIndex: Int = 1000
    ) {
        self.href = href
        self.label = label
        self.preview = preview
        self.zIndex = zIndex
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.span([
                    "class": Self.block,
                    "data-hover-preview": "",
                    "data-hover-preview-variant": preview.variant.rawValue
                ]) {
                    HTML.a(href, ["class": "\(Self.block)__link"]) {
                        label
                    }

                    HTML.span(["class": "\(Self.block)__card"]) {
                        media_nodes()

                        HTML.span(["class": "\(Self.block)__meta"]) {
                            if let eyebrow = preview.eyebrow {
                                HTML.span(["class": "\(Self.block)__eyebrow"]) {
                                    HTML.text(eyebrow)
                                }
                            }

                            HTML.a(
                                href,
                                [
                                    "class": "\(Self.block)__title",
                                    "target": "_blank",
                                    "rel": "noopener noreferrer"
                                ]
                            ) {
                                HTML.text(preview.title)
                            }

                            HTML.span(["class": "\(Self.block)__summary"]) {
                                preview.summary()
                            }

                            if !preview.tags.isEmpty {
                                HTML.span(["class": "\(Self.block)__tags"]) {
                                    for tag in preview.tags {
                                        HTML.span(["class": "\(Self.block)__tag"]) {
                                            HTML.text(tag)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            ],
            stylesheets: [Self.stylesheet(zIndex: zIndex)]
        )
    }

    private func media_nodes() -> HTMLFragment {
        switch preview.media {
        case .none:
            return []

        case let .image(src, alt):
            return [
                HTML.img(
                    src: src,
                    alt: alt,
                    ["class": "\(Self.block)__media \(Self.block)__media--image"]
                )
            ]

        case let .glyph(value):
            return [
                HTML.span(["class": "\(Self.block)__media \(Self.block)__media--glyph"]) {
                    HTML.text(value)
                }
            ]

        case let .custom(nodes):
            return [
                HTML.span(["class": "\(Self.block)__media \(Self.block)__media--custom"]) {
                    nodes()
                }
            ]
        }
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public static func css() -> CSSStyleSheet {
        stylesheet()
    }

    public static func stylesheet(
        zIndex: Int = 1000
    ) -> CSSStyleSheet {
        let root = ".\(Self.block)"
        let link = ".\(Self.block)__link"
        let card = ".\(Self.block)__card"
        let media = ".\(Self.block)__media"
        let image = ".\(Self.block)__media--image"
        let glyph = ".\(Self.block)__media--glyph"
        let custom = ".\(Self.block)__media--custom"
        let meta = ".\(Self.block)__meta"
        let eyebrow = ".\(Self.block)__eyebrow"
        let title = ".\(Self.block)__title"
        let summary = ".\(Self.block)__summary"
        let tags = ".\(Self.block)__tags"
        let tag = ".\(Self.block)__tag"

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    root,
                    CSS.decl("position", "relative"),
                    CSS.decl("z-index", "0"),
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "baseline"),
                    CSS.decl("isolation", "isolate"),
                    CSS.decl("--wc-hover-preview-z", "\(zIndex)"),
                    CSS.decl("--wc-hover-preview-surface", "var(--surface-color, #fff)"),
                    CSS.decl("--wc-hover-preview-soft", "var(--surface-soft-color, #f1f5f9)"),
                    CSS.decl("--wc-hover-preview-border", "var(--border-color, rgba(15, 23, 42, .12))"),
                    CSS.decl("--wc-hover-preview-ink", "var(--text-color, #202124)"),
                    CSS.decl("--wc-hover-preview-muted", "var(--muted-text-color, rgba(32, 33, 36, .66))"),
                    CSS.decl("--wc-hover-preview-accent", "var(--link-color, #2563eb)")
                ),

                CSS.rule(
                    "\(root):hover, \(root):focus-within",
                    CSS.decl("z-index", "var(--wc-hover-preview-z)")
                ),

                CSS.rule(
                    ".dark-mode \(root)",
                    CSS.decl("--wc-hover-preview-surface", "var(--surface-color, #1b1c1f)"),
                    CSS.decl("--wc-hover-preview-soft", "var(--surface-soft-color, #232429)"),
                    CSS.decl("--wc-hover-preview-border", "var(--border-color, rgba(255, 255, 255, .13))"),
                    CSS.decl("--wc-hover-preview-ink", "var(--text-color, #f4f4f5)"),
                    CSS.decl("--wc-hover-preview-muted", "var(--muted-text-color, rgba(244, 244, 245, .68))")
                ),

                CSS.rule(
                    link,
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "inline"),
                    CSS.decl("color", "var(--wc-hover-preview-accent)"),
                    CSS.decl("text-decoration", "underline"),
                    CSS.decl("text-decoration-thickness", ".08em"),
                    CSS.decl("text-underline-offset", ".18em"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    "\(link)::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "0"),
                    CSS.decl("right", "0"),
                    CSS.decl("bottom", "-.18em"),
                    CSS.decl("height", ".12em"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "currentColor"),
                    CSS.decl("opacity", ".16"),
                    CSS.decl("transform", "scaleX(.92)"),
                    CSS.decl("transform-origin", "left center"),
                    CSS.decl("transition", "opacity .16s ease, transform .16s ease")
                ),

                CSS.rule(
                    "\(root):hover \(link)::after, \(root):focus-within \(link)::after",
                    CSS.decl("opacity", ".34"),
                    CSS.decl("transform", "scaleX(1)")
                ),

                CSS.rule(
                    card,
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "50%"),
                    CSS.decl("bottom", "calc(100% + 12px)"),
                    CSS.decl("z-index", "var(--wc-hover-preview-z)"),
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "auto minmax(0, 1fr)"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("width", "min(360px, calc(100vw - 32px))"),
                    CSS.decl("min-width", "280px"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("border", "1px solid var(--wc-hover-preview-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-hover-preview-surface) 96%, var(--wc-hover-preview-ink) 4%)"),
                    CSS.decl("box-shadow", "0 20px 52px rgba(15, 23, 42, .18)"),
                    CSS.decl("color", "var(--wc-hover-preview-ink)"),
                    CSS.decl("text-align", "left"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("opacity", "0"),
                    CSS.decl("visibility", "hidden"),
                    CSS.decl("pointer-events", "none"),
                    CSS.decl("transform", "translate(-50%, 8px) scale(.985)"),
                    CSS.decl("transform-origin", "bottom center"),
                    CSS.decl("transition", "opacity .16s ease, transform .16s ease, visibility 0s linear .16s")
                ),

                CSS.rule(
                    ".dark-mode \(card)",
                    CSS.decl("box-shadow", "0 20px 48px rgba(0, 0, 0, .34)")
                ),

                CSS.rule(
                    "\(root):hover \(card), \(root):focus-within \(card)",
                    CSS.decl("opacity", "1"),
                    CSS.decl("visibility", "visible"),
                    CSS.decl("pointer-events", "auto"),
                    CSS.decl("transform", "translate(-50%, 0) scale(1)"),
                    CSS.decl("transition-delay", "0s")
                ),

                CSS.rule(
                    "\(card)::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "50%"),
                    CSS.decl("bottom", "-7px"),
                    CSS.decl("width", "14px"),
                    CSS.decl("height", "14px"),
                    CSS.decl("border-right", "1px solid var(--wc-hover-preview-border)"),
                    CSS.decl("border-bottom", "1px solid var(--wc-hover-preview-border)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-hover-preview-surface) 96%, var(--wc-hover-preview-ink) 4%)"),
                    CSS.decl("transform", "translateX(-50%) rotate(45deg)")
                ),

                CSS.rule(
                    media,
                    CSS.decl("display", "inline-grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "54px"),
                    CSS.decl("height", "54px"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-hover-preview-accent) 10%, var(--wc-hover-preview-soft))"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--wc-hover-preview-accent) 18%, transparent)")
                ),

                CSS.rule(
                    image,
                    CSS.decl("object-fit", "cover")
                ),

                CSS.rule(
                    glyph,
                    CSS.decl("font-size", "1.35rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("color", "var(--wc-hover-preview-accent)")
                ),

                CSS.rule(
                    custom,
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("color", "var(--wc-hover-preview-accent)")
                ),

                CSS.rule(
                    meta,
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    eyebrow,
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--wc-hover-preview-muted)")
                ),

                CSS.rule(
                    title,
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("width", "fit-content"),
                    CSS.decl("font-size", ".98rem"),
                    CSS.decl("font-weight", "820"),
                    CSS.decl("letter-spacing", "-.01em"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("color", "var(--wc-hover-preview-ink)"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    "\(title):hover, \(title):focus-visible",
                    CSS.decl("color", "var(--wc-hover-preview-accent)"),
                    CSS.decl("text-decoration", "underline"),
                    CSS.decl("text-decoration-thickness", ".08em"),
                    CSS.decl("text-underline-offset", ".18em")
                ),

                CSS.rule(
                    summary,
                    CSS.decl("display", "block"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("line-height", "1.38"),
                    CSS.decl("color", "var(--wc-hover-preview-muted)")
                ),

                CSS.rule(
                    "\(summary) p",
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    tags,
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("padding-top", "3px")
                ),

                CSS.rule(
                    tag,
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("width", "fit-content"),
                    CSS.decl("padding", "3px 7px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("color", "var(--wc-hover-preview-accent)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-hover-preview-accent) 10%, transparent)")
                ),

                CSS.rule(
                    "\(root)[data-hover-preview-variant=\"problem\"]",
                    CSS.decl("--wc-hover-preview-accent", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    "\(root)[data-hover-preview-variant=\"process\"]",
                    CSS.decl("--wc-hover-preview-accent", "var(--success, #2E8B57)")
                ),

                CSS.rule(
                    "\(root)[data-hover-preview-variant=\"article\"]",
                    CSS.decl("--wc-hover-preview-accent", "var(--warning, #E7A94E)")
                ),

                CSS.rule(
                    "\(root)[data-hover-preview-variant=\"definition\"]",
                    CSS.decl("--wc-hover-preview-accent", "var(--link-color, #2563eb)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        root,
                        CSS.decl("position", "relative")
                    ),
                    CSS.rule(
                        card,
                        CSS.decl("width", "min(360px, calc(100vw - 32px))"),
                        CSS.decl("min-width", "0")
                    ),
                    CSS.rule(
                        "\(card)::after",
                        CSS.decl("display", "none")
                    )
                )
            ]
        )
    }
}
