import Constructors
import CSS
import HTML

public struct DocsHoverCard: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-hover-card"

    public let href: String
    public let label: HTMLFragment
    public let title: String
    public let summary: HTMLFragment
    public let thumbnail: String?
    public let zIndex: Int

    public init(
        href: String,
        label: HTMLFragment,
        title: String,
        summary: HTMLFragment,
        thumbnail: String? = nil,
        zIndex: Int = 1000
    ) {
        self.href = href
        self.label = label
        self.title = title
        self.summary = summary
        self.thumbnail = thumbnail
        self.zIndex = zIndex
    }

    public init(
        item: DocsItem,
        label: HTMLFragment? = nil,
        thumbnail: String? = nil,
        zIndex: Int = 1000
    ) {
        self.init(
            href: item.href,
            label: label ?? [HTML.text(item.title)],
            title: item.title,
            summary: [HTML.text(item.summary)],
            thumbnail: thumbnail,
            zIndex: zIndex
        )
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.span(["class": Self.block]) {
                    HTML.a(href, ["class": "\(Self.block)__link"]) {
                        label
                    }

                    HTML.span(["class": "\(Self.block)__card"]) {
                        if let thumbnail {
                            HTML.img(
                                src: thumbnail,
                                alt: title,
                                ["class": "\(Self.block)__thumb"]
                            )
                        }

                        HTML.span(["class": "\(Self.block)__meta"]) {
                            HTML.span(["class": "\(Self.block)__title"]) {
                                HTML.text(title)
                            }

                            HTML.span(["class": "\(Self.block)__summary"]) {
                                summary
                            }
                        }
                    }
                }
            ],
            stylesheets: [Self.stylesheet(zIndex: zIndex)]
        )
    }

    public static func stylesheet(
        zIndex: Int = 1000
    ) -> CSSStyleSheet {
        let reveal = ".\(block):hover .\(block)__card, .\(block):focus-within .\(block)__card"

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "inline-block")
                ),

                CSS.rule(
                    ".\(block)__card",
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "0"),
                    CSS.decl("bottom", "calc(100% + 10px)"),
                    CSS.decl("z-index", "\(zIndex)"),
                    CSS.decl("display", "flex"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("align-items", "flex-start"),
                    CSS.decl("min-width", "260px"),
                    CSS.decl("max-width", "360px"),
                    CSS.decl("padding", "12px"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("background", "rgba(16, 16, 16, 0.92)"),
                    CSS.decl("color", "rgba(255, 255, 255, 0.92)"),
                    CSS.decl("border", "1px solid rgba(255, 255, 255, 0.12)"),
                    CSS.decl("box-shadow", "0 12px 30px rgba(0, 0, 0, 0.35)"),
                    CSS.decl("opacity", "0"),
                    CSS.decl("visibility", "hidden"),
                    CSS.decl("pointer-events", "none"),
                    CSS.decl("transform", "translateY(6px)"),
                    CSS.decl("transition", "opacity 120ms ease, transform 120ms ease, visibility 0s linear 120ms")
                ),

                CSS.rule(
                    reveal,
                    CSS.decl("opacity", "1"),
                    CSS.decl("visibility", "visible"),
                    CSS.decl("pointer-events", "auto"),
                    CSS.decl("transform", "translateY(0)"),
                    CSS.decl("transition", "opacity 120ms ease, transform 120ms ease, visibility 0s")
                ),

                CSS.rule(
                    ".\(block)__card::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "14px"),
                    CSS.decl("top", "100%"),
                    CSS.decl("width", "0"),
                    CSS.decl("height", "0"),
                    CSS.decl("border-left", "8px solid transparent"),
                    CSS.decl("border-right", "8px solid transparent"),
                    CSS.decl("border-top", "8px solid rgba(16, 16, 16, 0.92)")
                ),

                CSS.rule(
                    ".\(block)__thumb",
                    CSS.decl("width", "64px"),
                    CSS.decl("height", "64px"),
                    CSS.decl("flex", "0 0 auto"),
                    CSS.decl("border-radius", "10px"),
                    CSS.decl("object-fit", "cover"),
                    CSS.decl("border", "1px solid rgba(255, 255, 255, 0.10)")
                ),

                CSS.rule(
                    ".\(block)__meta",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__title",
                    CSS.decl("font-weight", "700"),
                    CSS.decl("font-size", "14px"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".\(block)__summary",
                    CSS.decl("font-size", "13px"),
                    CSS.decl("line-height", "1.35"),
                    CSS.decl("opacity", "0.92")
                ),

                CSS.rule(
                    ".\(block)__summary p",
                    CSS.decl("margin", "0")
                )
            ]
        )
    }
}
