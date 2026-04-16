import DSL
import Constructors
import CSS
import HTML

public struct ReviewQuoteStrip: SelectableComponent, Sendable {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-review-quote-strip"

    public struct Selectors: Sendable {
        private let api = BlockSelectorAPI<Namespace>(
            block: ReviewQuoteStrip.block
        )

        public init() {}

        public var root: HTMLClass<Namespace> {
            api.root
        }

        public var item: HTMLClass<Namespace> {
            api.element("item")
        }

        public var quote: HTMLClass<Namespace> {
            api.element("quote")
        }

        public var author: HTMLClass<Namespace> {
            api.element("author")
        }

        public var compact: HTMLClass<Namespace> {
            api.modifier("compact")
        }

        public var centered: HTMLClass<Namespace> {
            api.modifier("centered")
        }
    }

    public struct Vars: Sendable {
        private let api = BlockSelectorAPI<Namespace>(
            block: ReviewQuoteStrip.block
        )

        public init() {}

        public var itemBackground: CSSVariable<Namespace> {
            api.variable("item-background")
        }

        public var itemBorder: CSSVariable<Namespace> {
            api.variable("item-border")
        }

        public var quoteText: CSSVariable<Namespace> {
            api.variable("quote-text")
        }

        public var authorText: CSSVariable<Namespace> {
            api.variable("author-text")
        }

        public var itemShadow: CSSVariable<Namespace> {
            api.variable("item-shadow")
        }
    }

    public static let selectors = Selectors()
    public static let vars = Vars()

    public struct Model: Sendable {
        public struct Quote: Sendable {
            public let text: String
            public let author: String?

            public init(
                text: String,
                author: String? = nil
            ) {
                self.text = text
                self.author = author
            }
        }

        public let quotes: [Quote]
        // public let isCompact: Bool
        public let isCentered: Bool

        public init(
            quotes: [Quote],
            // isCompact: Bool = false,
            isCentered: Bool = false
        ) {
            self.quotes = quotes
            // self.isCompact = isCompact
            self.isCentered = isCentered
        }
    }

    public let model: Model

    public init(
        _ model: Model
    ) {
        self.model = model
    }

    public var nodes: ReusableComponentNodes {
        let s = Self.selectors

        var attrs = HTMLAttribute.class(s.root)

        // if model.isCompact {
        //     attrs.merge(.class(s.compact))
        // }

        if model.isCentered {
            attrs.merge(.class(s.centered))
        }

        return .body(
            [
                HTML.div(attrs) {
                    for quote in model.quotes {
                        HTML.blockquote(.class(s.item)) {
                            HTML.span(.class(s.quote)) {
                                HTML.text(quote.text)
                            }

                            if let author = quote.author, !author.isEmpty {
                                HTML.el("footer", .class(s.author)) {
                                    HTML.text(author)
                                }
                            }
                        }
                    }
                }
            ],
            stylesheets: [Self.css()]
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public func sheet() -> CSSStyleSheet {
        nodes.stylesheets[0]
    }
}

public extension ReviewQuoteStrip {
    static func css() -> CSSStyleSheet {
        let s = Self.selectors
        let v = Self.vars

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    s.root,
                    decl(v.itemBackground, cssvar("--quotes-bg", fallback: "rgba(255, 255, 255, 0.08)")),
                    decl(v.itemBorder, cssvar("--pill-border", fallback: "rgba(255, 255, 255, 0.12)")),
                    decl(v.quoteText, cssvar("--ink-dark", fallback: cssvar("--text", fallback: "inherit"))),
                    decl(v.authorText, cssvar("--muted-dark", fallback: cssvar("--text-muted", fallback: "rgba(255, 255, 255, 0.80)"))),
                    decl(v.itemShadow, cssvar("--shadow-soft", fallback: "none")),

                    CSS.decl("display", "flex"),
                    CSS.decl("gap", "1.25rem"),
                    CSS.decl("overflow-x", "auto"),
                    CSS.decl("padding", "0"),
                    CSS.decl("scrollbar-width", "thin"),
                    CSS.decl("scroll-snap-type", "x proximity")
                ),

                CSS.rule(
                    s.compact,
                    CSS.decl("gap", "0.9rem")
                ),

                CSS.rule(
                    s.centered,
                    CSS.decl("justify-content", "center")
                ),

                CSS.rule(
                    s.item,
                    CSS.decl("margin", "0"),
                    CSS.decl("min-width", "240px"),
                    CSS.decl("max-width", "320px"),
                    CSS.decl("padding", "0.95rem 1rem"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", cssvar(v.itemBackground, fallback: "rgba(255, 255, 255, 0.08)")),
                    CSS.decl("backdrop-filter", "blur(8px)"),
                    CSS.decl("border", "1px solid \(cssvar(v.itemBorder, fallback: "rgba(255, 255, 255, 0.12)"))"),
                    CSS.decl("box-shadow", cssvar(v.itemShadow, fallback: "none")),
                    CSS.decl("color", cssvar(v.quoteText, fallback: "inherit")),
                    CSS.decl("scroll-snap-align", "start")
                ),

                CSS.rule(
                    s.quote,
                    CSS.decl("display", "block"),
                    CSS.decl("font-size", "0.92rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", cssvar(v.quoteText, fallback: "inherit"))
                ),

                CSS.rule(
                    s.author,
                    CSS.decl("margin-top", "0.55rem"),
                    CSS.decl("font-size", "0.82rem"),
                    CSS.decl("opacity", "0.8"),
                    CSS.decl("color", cssvar(v.authorText, fallback: "inherit"))
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        s.root,
                        CSS.decl("gap", "1rem")
                    ),
                    CSS.rule(
                        s.item,
                        CSS.decl("min-width", "200px"),
                        CSS.decl("font-size", "0.82rem")
                    )
                ),
                CSS.media(
                    "(max-width: 420px)",
                    CSS.rule(
                        s.item,
                        CSS.decl("min-width", "180px")
                    )
                )
            ]
        )
    }
}

// public extension ReviewQuoteStrip {
//     static func css() -> CSSStyleSheet {
//         let s = Self.selectors

//         return CSSStyleSheet(
//             rules: [
//                 CSS.rule(
//                     s.root,
//                     CSS.decl("display", "flex"),
//                     CSS.decl("gap", "1.25rem"),
//                     CSS.decl("overflow-x", "auto"),
//                     CSS.decl("padding", "0"),
//                     CSS.decl("scrollbar-width", "thin"),
//                     CSS.decl("scroll-snap-type", "x proximity")
//                 ),

//                 CSS.rule(
//                     s.compact,
//                     CSS.decl("gap", "0.9rem")
//                 ),

//                 CSS.rule(
//                     s.centered,
//                     CSS.decl("justify-content", "center")
//                 ),

//                 CSS.rule(
//                     s.item,
//                     CSS.decl("margin", "0"),
//                     CSS.decl("min-width", "240px"),
//                     CSS.decl("max-width", "320px"),
//                     CSS.decl("padding", "0.95rem 1rem"),
//                     CSS.decl("border-radius", "14px"),
//                     CSS.decl("background", "rgba(255, 255, 255, 0.08)"),
//                     CSS.decl("backdrop-filter", "blur(8px)"),
//                     CSS.decl("border", "1px solid rgba(255, 255, 255, 0.12)"),
//                     CSS.decl("color", "inherit"),
//                     CSS.decl("scroll-snap-align", "start")
//                 ),

//                 CSS.rule(
//                     s.quote,
//                     CSS.decl("display", "block"),
//                     CSS.decl("font-size", "0.92rem"),
//                     CSS.decl("line-height", "1.45")
//                 ),

//                 CSS.rule(
//                     s.author,
//                     CSS.decl("margin-top", "0.55rem"),
//                     CSS.decl("font-size", "0.82rem"),
//                     CSS.decl("opacity", "0.8")
//                 )
//             ],
//             media: [
//                 CSS.media(
//                     "(max-width: 640px)",
//                     CSS.rule(
//                         s.root,
//                         CSS.decl("gap", "1rem")
//                     ),
//                     CSS.rule(
//                         s.item,
//                         CSS.decl("min-width", "200px"),
//                         CSS.decl("font-size", "0.82rem")
//                     )
//                 ),
//                 CSS.media(
//                     "(max-width: 420px)",
//                     CSS.rule(
//                         s.item,
//                         CSS.decl("min-width", "180px")
//                     )
//                 )
//             ]
//         )
//     }
// }
