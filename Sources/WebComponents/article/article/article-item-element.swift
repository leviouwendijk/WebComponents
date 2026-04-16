import HTML
import CSS
import Constructors

public enum ArticleHoverCardNamespace {}

public struct ArticleHoverCard: SelectableComponent {
    public typealias SelectorNamespace = ArticleHoverCardNamespace

    public static let block = "hoverref"

    public let href: String
    public let label: HTMLFragment
    public let title: String
    public let definition: @Sendable () -> HTMLFragment
    public let thumbnail_src: String?
    public let z_index: Int

    public init(
        href: String,
        label: HTMLFragment,
        title: String,
        definition: @escaping @Sendable () -> HTMLFragment,
        thumbnail_src: String? = nil,
        z_index: Int = 1000
    ) {
        self.href = href
        self.label = label
        self.title = title
        self.definition = definition
        self.thumbnail_src = thumbnail_src
        self.z_index = z_index
    }

    public var nodes: ReusableComponentNodes {
        let s = selectors

        let reveal = CSSSelector.group(
            s.root
                .pseudoClass("hover")
                .descendant(s.element("card")),
            s.root
                .pseudoClass("focus-within")
                .descendant(s.element("card"))
        )

        let cardCaret = s.element("card")
            .pseudoElement("after")

        let defParagraphs = s.element("def")
            .descendant(CSSSelector.element("p"))

        return .body(
            [
                HTML.span(
                    HTMLAttribute.class(s.root)
                ) {
                    HTML.a(
                        href,
                        HTMLAttribute.class(s.element("link"))
                    ) {
                        label
                    }

                    HTML.span(
                        HTMLAttribute.class(s.element("card"))
                    ) {
                        if let thumb = thumbnail_src {
                            HTML.img(
                                src: thumb,
                                alt: title,
                                HTMLAttribute.class(s.element("thumb"))
                            )
                        }

                        HTML.span(
                            HTMLAttribute.class(s.element("meta"))
                        ) {
                            HTML.span(
                                HTMLAttribute.class(s.element("title"))
                            ) {
                                HTML.text(title)
                            }

                            HTML.span(
                                HTMLAttribute.class(s.element("def"))
                            ) {
                                definition()
                            }
                        }
                    }
                }
            ],
            stylesheets: [
                CSSStyleSheet(
                    rules: [
                        CSS.rule(
                            s.target(s.root),
                            CSS.decl("position", "relative"),
                            CSS.decl("display", "inline-block")
                        ),

                        CSS.rule(
                            s.target(s.element("card")),
                            CSS.decl("position", "absolute"),
                            CSS.decl("left", "0"),
                            CSS.decl("bottom", "calc(100% + 10px)"),
                            CSS.decl("z-index", "\(z_index)"),
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
                            cardCaret,
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
                            s.element("card"),
                            CSS.decl("display", "flex"),
                            CSS.decl("gap", "10px"),
                            CSS.decl("align-items", "flex-start")
                        ),

                        CSS.rule(
                            s.element("thumb"),
                            CSS.decl("width", "64px"),
                            CSS.decl("height", "64px"),
                            CSS.decl("flex", "0 0 auto"),
                            CSS.decl("border-radius", "10px"),
                            CSS.decl("object-fit", "cover"),
                            CSS.decl("border", "1px solid rgba(255, 255, 255, 0.10)")
                        ),

                        CSS.rule(
                            s.element("meta"),
                            CSS.decl("display", "flex"),
                            CSS.decl("flex-direction", "column"),
                            CSS.decl("gap", "6px"),
                            CSS.decl("min-width", "0")
                        ),

                        CSS.rule(
                            s.element("title"),
                            CSS.decl("font-weight", "700"),
                            CSS.decl("font-size", "14px"),
                            CSS.decl("line-height", "1.2")
                        ),

                        CSS.rule(
                            s.element("def"),
                            CSS.decl("font-size", "13px"),
                            CSS.decl("line-height", "1.35"),
                            CSS.decl("opacity", "0.92")
                        ),

                        CSS.rule(
                            defParagraphs,
                            CSS.decl("margin", "0")
                        )
                    ]
                )
            ]
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public func sheet() -> CSSStyleSheet {
        nodes.stylesheets[0]
    }
}

// // backwards compat
// public enum ArticleItemElement {
//     public enum HoverCard {
//         public static func html(
//             href: String,
//             label: HTMLFragment,
//             title: String,
//             definition: @escaping @Sendable () -> HTMLFragment,
//             thumbnail_src: String? = nil
//         ) -> any HTMLNode {
//             ArticleHoverCard(
//                 href: href,
//                 label: label,
//                 title: title,
//                 definition: definition,
//                 thumbnail_src: thumbnail_src
//             ).node()
//         }

//         public static func css(
//             z_index: Int = 1000
//         ) -> CSSStyleSheet {
//             ArticleHoverCard(
//                 href: "#",
//                 label: [],
//                 title: "",
//                 definition: { [] },
//                 thumbnail_src: nil,
//                 z_index: z_index
//             ).sheet()
//         }
//     }
// }

// public enum ArticleItemElement {
//     public enum HoverCard {
//         public static func html(
//             href: String,
//             label: HTMLFragment,
//             title: String,
//             definition: @Sendable () -> HTMLFragment,
//             thumbnail_src: String? = nil
//         ) -> any HTMLNode {
//             HTML.span(["class": "hoverref"]) {
//                 HTML.a(href, ["class": "hoverref__link"]) {
//                     label
//                 }

//                 HTML.span(["class": "hoverref__card"]) {
//                     if let thumb = thumbnail_src {
//                         HTML.img(
//                             src: thumb,
//                             alt: title,
//                             ["class": "hoverref__thumb"]
//                         )
//                     }

//                     HTML.span(["class": "hoverref__meta"]) {
//                         HTML.span(["class": "hoverref__title"]) { HTML.text(title) }
//                         HTML.span(["class": "hoverref__def"]) { definition() }
//                     }
//                 }
//             }
//         }

//         public static func css(z_index: Int = 1000) -> CSSStyleSheet {
//             CSSStyleSheet(
//                 rules: [
//                     // Anchor point for the absolute-positioned card
//                     CSS.rule(
//                         ".hoverref",
//                         CSS.decl("position", "relative"),
//                         CSS.decl("display", "inline-block")
//                     ),

//                     // The card itself (hidden by default)
//                     CSS.rule(
//                         ".hoverref__card",
//                         CSS.decl("position", "absolute"),
//                         CSS.decl("left", "0"),
//                         CSS.decl("bottom", "calc(100% + 10px)"), // place above link with gap
//                         CSS.decl("z-index", "\(z_index)"),

//                         CSS.decl("min-width", "260px"),
//                         CSS.decl("max-width", "360px"),

//                         CSS.decl("padding", "12px"),
//                         CSS.decl("border-radius", "12px"),

//                         CSS.decl("background", "rgba(16, 16, 16, 0.92)"),
//                         CSS.decl("color", "rgba(255, 255, 255, 0.92)"),
//                         CSS.decl("border", "1px solid rgba(255, 255, 255, 0.12)"),
//                         CSS.decl("box-shadow", "0 12px 30px rgba(0, 0, 0, 0.35)"),

//                         // hidden state
//                         CSS.decl("opacity", "0"),
//                         CSS.decl("visibility", "hidden"),
//                         CSS.decl("pointer-events", "none"),
//                         CSS.decl("transform", "translateY(6px)"),
//                         CSS.decl("transition", "opacity 120ms ease, transform 120ms ease, visibility 0s linear 120ms")
//                     ),

//                     // Show on hover/focus
//                     CSS.rule(
//                         ".hoverref:hover .hoverref__card, .hoverref:focus-within .hoverref__card",
//                         CSS.decl("opacity", "1"),
//                         CSS.decl("visibility", "visible"),
//                         CSS.decl("pointer-events", "auto"),
//                         CSS.decl("transform", "translateY(0)"),
//                         CSS.decl("transition", "opacity 120ms ease, transform 120ms ease, visibility 0s")
//                     ),

//                     // Optional caret/arrow pointing down to link
//                     CSS.rule(
//                         ".hoverref__card::after",
//                         CSS.decl("content", "\"\""),
//                         CSS.decl("position", "absolute"),
//                         CSS.decl("left", "14px"),
//                         CSS.decl("top", "100%"),
//                         CSS.decl("width", "0"),
//                         CSS.decl("height", "0"),
//                         CSS.decl("border-left", "8px solid transparent"),
//                         CSS.decl("border-right", "8px solid transparent"),
//                         CSS.decl("border-top", "8px solid rgba(16, 16, 16, 0.92)")
//                     ),

//                     // Layout inside card
//                     CSS.rule(
//                         ".hoverref__card",
//                         CSS.decl("display", "flex"),
//                         CSS.decl("gap", "10px"),
//                         CSS.decl("align-items", "flex-start")
//                     ),

//                     CSS.rule(
//                         ".hoverref__thumb",
//                         CSS.decl("width", "64px"),
//                         CSS.decl("height", "64px"),
//                         CSS.decl("flex", "0 0 auto"),
//                         CSS.decl("border-radius", "10px"),
//                         CSS.decl("object-fit", "cover"),
//                         CSS.decl("border", "1px solid rgba(255, 255, 255, 0.10)")
//                     ),

//                     CSS.rule(
//                         ".hoverref__meta",
//                         CSS.decl("display", "flex"),
//                         CSS.decl("flex-direction", "column"),
//                         CSS.decl("gap", "6px"),
//                         CSS.decl("min-width", "0") // allow text wrapping
//                     ),

//                     CSS.rule(
//                         ".hoverref__title",
//                         CSS.decl("font-weight", "700"),
//                         CSS.decl("font-size", "14px"),
//                         CSS.decl("line-height", "1.2")
//                     ),

//                     CSS.rule(
//                         ".hoverref__def",
//                         CSS.decl("font-size", "13px"),
//                         CSS.decl("line-height", "1.35"),
//                         CSS.decl("opacity", "0.92")
//                     ),

//                     // Ensure nested p/b/etc inside definition look reasonable
//                     CSS.rule(
//                         ".hoverref__def p",
//                         CSS.decl("margin", "0")
//                     )
//                 ]
//             )
//         }
//     }
// }
