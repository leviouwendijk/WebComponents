import DSL
import Constructors
import HTML
import CSS
import Path

public struct FigureExplanationBlock: SelectableComponent, Sendable {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-figure-explanation"

    public struct Selectors: Sendable {
        private let api = BlockSelectorAPI<Namespace>(
            block: FigureExplanationBlock.block
        )

        public init() {}

        public var root: HTMLClass<Namespace> {
            api.root
        }

        public var media: HTMLClass<Namespace> {
            api.element("media")
        }

        public var image: HTMLClass<Namespace> {
            api.element("image")
        }

        public var body: HTMLClass<Namespace> {
            api.element("body")
        }

        public var caption: HTMLClass<Namespace> {
            api.element("caption")
        }

        public var explanation: HTMLClass<Namespace> {
            api.element("explanation")
        }

        public var stacked: HTMLClass<Namespace> {
            api.modifier("stacked")
        }

        public var figureLeft: HTMLClass<Namespace> {
            api.modifier("figure-left")
        }

        public var figureRight: HTMLClass<Namespace> {
            api.modifier("figure-right")
        }

        public var compact: HTMLClass<Namespace> {
            api.modifier("compact")
        }
    }

    public struct Vars: Sendable {
        private let api = BlockSelectorAPI<Namespace>(
            block: FigureExplanationBlock.block
        )

        public init() {}

        public var mediaBackground: CSSVariable<Namespace> {
            api.variable("media-background")
        }

        public var mediaBorder: CSSVariable<Namespace> {
            api.variable("media-border")
        }

        public var mediaShadow: CSSVariable<Namespace> {
            api.variable("media-shadow")
        }

        public var captionText: CSSVariable<Namespace> {
            api.variable("caption-text")
        }

        public var explanationText: CSSVariable<Namespace> {
            api.variable("explanation-text")
        }
    }

    public static let selectors = Selectors()
    public static let vars = Vars()

    public struct Model: Sendable {
        public enum Layout: Sendable {
            case stacked
            case figureLeft
            case figureRight
        }

        public let header: EditorialSectionHeader.Model?
        public let src: StandardPath
        public let alt: String
        public let caption: HTMLFragment?
        public let explanation: HTMLFragment?
        public let layout: Layout
        // public let isCompact: Bool

        public init(
            header: EditorialSectionHeader.Model? = nil,
            src: StandardPath,
            alt: String,
            caption: HTMLFragment? = nil,
            explanation: HTMLFragment? = nil,
            layout: Layout = .stacked,
            // isCompact: Bool = false
        ) {
            self.header = header
            self.src = src
            self.alt = alt
            self.caption = caption
            self.explanation = explanation
            self.layout = layout
            // self.isCompact = isCompact
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

        switch model.layout {
        case .stacked:
            attrs.merge(.class(s.stacked))
        case .figureLeft:
            attrs.merge(.class(s.figureLeft))
        case .figureRight:
            attrs.merge(.class(s.figureRight))
        }

        // if model.isCompact {
        //     attrs.merge(.class(s.compact))
        // }

        return .body(
            [
                HTML.div(attrs) {
                    if let header = model.header {
                        EditorialSectionHeader(header).nodes.body
                    }

                    HTML.div(.class(s.media)) {
                        HTML.img(
                            src: model.src.render(as: .root, filetype: true),
                            alt: model.alt,
                            .class(s.image)
                        )
                    }

                    if model.caption != nil || model.explanation != nil {
                        HTML.div(.class(s.body)) {
                            if let caption = model.caption {
                                HTML.div(.class(s.caption)) {
                                    caption
                                }
                            }

                            if let explanation = model.explanation {
                                HTML.div(.class(s.explanation)) {
                                    explanation
                                }
                            }
                        }
                    }
                }
            ],
            stylesheets: [
                EditorialSectionHeader.css(),
                Self.css()
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

public extension FigureExplanationBlock {
    static func css() -> CSSStyleSheet {
        let s = Self.selectors
        let v = Self.vars

        let captionParagraphs = s.caption
            .descendant(CSSSelector.element("p"))

        let explanationParagraphs = s.explanation
            .descendant(CSSSelector.element("p"))

        let explanationLists = CSSSelector.group(
            s.explanation.descendant(CSSSelector.element("ul")),
            s.explanation.descendant(CSSSelector.element("ol"))
        )

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    s.root,
                    decl(v.mediaBackground, "var(--surface-strong, var(--code-bg-color, #ffffff))"),
                    decl(v.mediaBorder, "var(--border-color, rgba(15, 23, 42, 0.10))"),
                    decl(v.mediaShadow, "var(--shadow-soft, none)"),
                    decl(v.captionText, "var(--ref-meta-text-color, var(--text-color, #0f172a))"),
                    decl(v.explanationText, "var(--text-color, #0f172a)"),

                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("margin", "16px 0 24px 0")
                ),

                CSS.rule(
                    s.compact,
                    CSS.decl("gap", "10px"),
                    CSS.decl("margin", "12px 0 18px 0")
                ),

                CSS.rule(
                    s.stacked,
                    CSS.decl("grid-template-columns", "1fr")
                ),

                CSS.rule(
                    s.figureLeft,
                    CSS.decl("grid-template-columns", "minmax(180px, 320px) minmax(0, 1fr)"),
                    CSS.decl("align-items", "start")
                ),

                CSS.rule(
                    s.figureRight,
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) minmax(180px, 320px)"),
                    CSS.decl("align-items", "start")
                ),

                CSS.rule(
                    s.figureRight
                        .descendant(s.media),
                    CSS.decl("order", "2")
                ),

                CSS.rule(
                    s.figureRight
                        .descendant(s.body),
                    CSS.decl("order", "1")
                ),

                CSS.rule(
                    s.media,
                    CSS.decl("min-width", "0"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "12px"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", cssvar(v.mediaBackground, fallback: "#ffffff")),
                    CSS.decl("border", "1px solid \(cssvar(v.mediaBorder, fallback: "rgba(15, 23, 42, 0.10)"))"),
                    CSS.decl("box-shadow", cssvar(v.mediaShadow, fallback: "none"))
                ),

                CSS.rule(
                    s.image,
                    CSS.decl("display", "block"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "auto"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("object-fit", "cover")
                ),

                CSS.rule(
                    s.body,
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    s.caption,
                    CSS.decl("font-size", "0.92rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", cssvar(v.captionText, fallback: "#475569"))
                ),

                CSS.rule(
                    captionParagraphs,
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    s.explanation,
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("line-height", "1.58"),
                    CSS.decl("color", cssvar(v.explanationText, fallback: "#0f172a"))
                ),

                CSS.rule(
                    explanationParagraphs,
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    explanationLists,
                    CSS.decl("margin", "0"),
                    CSS.decl("padding-left", "1.2rem")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 820px)",
                    CSS.rule(
                        s.figureLeft,
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        s.figureRight,
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        s.figureRight
                            .descendant(s.media),
                        CSS.decl("order", "0")
                    ),
                    CSS.rule(
                        s.figureRight
                            .descendant(s.body),
                        CSS.decl("order", "0")
                    )
                )
            ]
        )
    }
}

// public extension FigureExplanationBlock {
//     static func css() -> CSSStyleSheet {
//         let s = Self.selectors

//         let captionParagraphs = s.caption
//             .descendant(CSSSelector.element("p"))

//         let explanationParagraphs = s.explanation
//             .descendant(CSSSelector.element("p"))

//         let explanationLists = CSSSelector.group(
//             s.explanation.descendant(CSSSelector.element("ul")),
//             s.explanation.descendant(CSSSelector.element("ol"))
//         )

//         return CSSStyleSheet(
//             rules: [
//                 CSS.rule(
//                     s.root,
//                     CSS.decl("display", "grid"),
//                     CSS.decl("gap", "14px"),
//                     CSS.decl("margin", "16px 0 24px 0")
//                 ),

//                 CSS.rule(
//                     s.compact,
//                     CSS.decl("gap", "10px"),
//                     CSS.decl("margin", "12px 0 18px 0")
//                 ),

//                 CSS.rule(
//                     s.stacked,
//                     CSS.decl("grid-template-columns", "1fr")
//                 ),

//                 CSS.rule(
//                     s.figureLeft,
//                     CSS.decl("grid-template-columns", "minmax(180px, 320px) minmax(0, 1fr)"),
//                     CSS.decl("align-items", "start")
//                 ),

//                 CSS.rule(
//                     s.figureRight,
//                     CSS.decl("grid-template-columns", "minmax(0, 1fr) minmax(180px, 320px)"),
//                     CSS.decl("align-items", "start")
//                 ),

//                 CSS.rule(
//                     s.figureRight
//                         .descendant(s.media),
//                     CSS.decl("order", "2")
//                 ),

//                 CSS.rule(
//                     s.figureRight
//                         .descendant(s.body),
//                     CSS.decl("order", "1")
//                 ),

//                 CSS.rule(
//                     s.media,
//                     CSS.decl("min-width", "0")
//                 ),

//                 CSS.rule(
//                     s.image,
//                     CSS.decl("display", "block"),
//                     CSS.decl("width", "100%"),
//                     CSS.decl("height", "auto"),
//                     CSS.decl("border-radius", "12px"),
//                     CSS.decl("object-fit", "cover"),
//                     CSS.decl("border", "1px solid var(--border-color, rgba(15, 23, 42, 0.10))"),
//                     CSS.decl("background", "var(--background-color, #fff)")
//                 ),

//                 CSS.rule(
//                     s.body,
//                     CSS.decl("display", "flex"),
//                     CSS.decl("flex-direction", "column"),
//                     CSS.decl("gap", "10px"),
//                     CSS.decl("min-width", "0")
//                 ),

//                 CSS.rule(
//                     s.caption,
//                     CSS.decl("font-size", "0.92rem"),
//                     CSS.decl("line-height", "1.45"),
//                     CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))")
//                 ),

//                 CSS.rule(
//                     captionParagraphs,
//                     CSS.decl("margin", "0")
//                 ),

//                 CSS.rule(
//                     s.explanation,
//                     CSS.decl("font-size", "1rem"),
//                     CSS.decl("line-height", "1.58"),
//                     CSS.decl("color", "var(--text-color, #0f172a)")
//                 ),

//                 CSS.rule(
//                     explanationParagraphs,
//                     CSS.decl("margin", "0")
//                 ),

//                 CSS.rule(
//                     explanationLists,
//                     CSS.decl("margin", "0"),
//                     CSS.decl("padding-left", "1.2rem")
//                 )
//             ],
//             media: [
//                 CSS.media(
//                     "(max-width: 820px)",
//                     CSS.rule(
//                         s.figureLeft,
//                         CSS.decl("grid-template-columns", "1fr")
//                     ),
//                     CSS.rule(
//                         s.figureRight,
//                         CSS.decl("grid-template-columns", "1fr")
//                     ),
//                     CSS.rule(
//                         s.figureRight
//                             .descendant(s.media),
//                         CSS.decl("order", "0")
//                     ),
//                     CSS.rule(
//                         s.figureRight
//                             .descendant(s.body),
//                         CSS.decl("order", "0")
//                     )
//                 )
//             ]
//         )
//     }
// }
