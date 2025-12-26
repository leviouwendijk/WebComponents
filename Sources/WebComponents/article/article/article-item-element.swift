import HTML
import CSS
// import Path

public enum ArticleItemElement {
    public enum HoverCard {
        public static func html(
            href: String,
            label: HTMLFragment,
            item: ArticleItem
        ) -> any HTMLNode {
            HTML.span(["class": "hoverref"]) {
                HTML.a(href, ["class": "hoverref__link"]) {
                    label
                }

                HTML.span(["class": "hoverref__card"]) {
                    if let thumb = item.thumbnail_src {
                        HTML.img(
                            src: thumb.rendered(asRootPath: true),
                            alt: item.title,
                            ["class": "hoverref__thumb"]
                        )
                    }

                    HTML.span(["class": "hoverref__meta"]) {
                        HTML.span(["class": "hoverref__title"]) { HTML.text(item.title) }
                        HTML.span(["class": "hoverref__def"]) { item.definition() }
                    }
                }
            }
        }

        public static func css(z_index: Int = 1000) -> CSSStyleSheet {
            CSSStyleSheet(
                rules: [
                    // Anchor point for the absolute-positioned card
                    CSS.rule(
                        ".hoverref",
                        CSS.decl("position", "relative"),
                        CSS.decl("display", "inline-block")
                    ),

                    // The card itself (hidden by default)
                    CSS.rule(
                        ".hoverref__card",
                        CSS.decl("position", "absolute"),
                        CSS.decl("left", "0"),
                        CSS.decl("bottom", "calc(100% + 10px)"), // place above link with gap
                        CSS.decl("z-index", "\(z_index)"),

                        CSS.decl("min-width", "260px"),
                        CSS.decl("max-width", "360px"),

                        CSS.decl("padding", "12px"),
                        CSS.decl("border-radius", "12px"),

                        CSS.decl("background", "rgba(16, 16, 16, 0.92)"),
                        CSS.decl("color", "rgba(255, 255, 255, 0.92)"),
                        CSS.decl("border", "1px solid rgba(255, 255, 255, 0.12)"),
                        CSS.decl("box-shadow", "0 12px 30px rgba(0, 0, 0, 0.35)"),

                        // hidden state
                        CSS.decl("opacity", "0"),
                        CSS.decl("visibility", "hidden"),
                        CSS.decl("pointer-events", "none"),
                        CSS.decl("transform", "translateY(6px)"),
                        CSS.decl("transition", "opacity 120ms ease, transform 120ms ease, visibility 0s linear 120ms")
                    ),

                    // Show on hover/focus
                    CSS.rule(
                        ".hoverref:hover .hoverref__card, .hoverref:focus-within .hoverref__card",
                        CSS.decl("opacity", "1"),
                        CSS.decl("visibility", "visible"),
                        CSS.decl("pointer-events", "auto"),
                        CSS.decl("transform", "translateY(0)"),
                        CSS.decl("transition", "opacity 120ms ease, transform 120ms ease, visibility 0s")
                    ),

                    // Optional caret/arrow pointing down to link
                    CSS.rule(
                        ".hoverref__card::after",
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

                    // Layout inside card
                    CSS.rule(
                        ".hoverref__card",
                        CSS.decl("display", "flex"),
                        CSS.decl("gap", "10px"),
                        CSS.decl("align-items", "flex-start")
                    ),

                    CSS.rule(
                        ".hoverref__thumb",
                        CSS.decl("width", "64px"),
                        CSS.decl("height", "64px"),
                        CSS.decl("flex", "0 0 auto"),
                        CSS.decl("border-radius", "10px"),
                        CSS.decl("object-fit", "cover"),
                        CSS.decl("border", "1px solid rgba(255, 255, 255, 0.10)")
                    ),

                    CSS.rule(
                        ".hoverref__meta",
                        CSS.decl("display", "flex"),
                        CSS.decl("flex-direction", "column"),
                        CSS.decl("gap", "6px"),
                        CSS.decl("min-width", "0") // allow text wrapping
                    ),

                    CSS.rule(
                        ".hoverref__title",
                        CSS.decl("font-weight", "700"),
                        CSS.decl("font-size", "14px"),
                        CSS.decl("line-height", "1.2")
                    ),

                    CSS.rule(
                        ".hoverref__def",
                        CSS.decl("font-size", "13px"),
                        CSS.decl("line-height", "1.35"),
                        CSS.decl("opacity", "0.92")
                    ),

                    // Ensure nested p/b/etc inside definition look reasonable
                    CSS.rule(
                        ".hoverref__def p",
                        CSS.decl("margin", "0")
                    )
                ]
            )
        }
    }
}
