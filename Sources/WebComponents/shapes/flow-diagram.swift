import DSL
import Constructors
import HTML
import CSS

public struct FlowDiagram: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-flow"

    public struct Selectors: Sendable {
        private let api = BlockSelectorAPI<Namespace>(
            block: FlowDiagram.block
        )

        public init() {}

        public var root: HTMLClass<Namespace> {
            api.root
        }

        public var row: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)--row")
        }

        public var col: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)--col")
        }

        public var box: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)__box")
        }

        public var boxInner: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)__box-inner")
        }

        public var boxCenter: HTMLClass<Namespace> {
            HTMLClass("\(box.rawValue)--center")
        }

        public var boxStart: HTMLClass<Namespace> {
            HTMLClass("\(box.rawValue)--start")
        }

        public var arrowWrap: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)__arrow-wrap")
        }

        public var arrow: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)__arrow")
        }

        public var arrowLabel: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)__arrow-label")
        }

        public var arrowLeft: HTMLClass<Namespace> {
            HTMLClass("\(arrow.rawValue)--left")
        }

        public var arrowBoth: HTMLClass<Namespace> {
            HTMLClass("\(arrow.rawValue)--both")
        }
    }

    public static let selectors = Selectors()

    public let axis: Axis
    public let classes: [HTMLClassToken]
    public let attrs: HTMLAttribute
    public let items: [Item]

    public init(
        axis: Axis = .row,
        classes: [HTMLClassToken] = [],
        attrs: HTMLAttribute = HTMLAttribute(),
        items: [Item]
    ) {
        self.axis = axis
        self.classes = classes
        self.attrs = attrs
        self.items = items
    }

    public var nodes: ReusableComponentNodes {
        let s = selectors

        let axisClass: AnyHTMLClass = (axis == .row)
            ? s.row.erased
            : s.col.erased

        let a = Self.makeAttrs(
            baseClasses: [
                s.root.erased,
                axisClass
            ],
            classes: classes,
            attrs: attrs
        )

        return .body(
            [
                HTML.div(a) {
                    for item in items {
                        switch item {
                        case .box(let b):
                            Self.boxHTML(b)

                        case .arrow(let ar):
                            Self.arrowHTML(ar)
                        }
                    }
                }
            ],
            stylesheets: [Self.css()]
        )
    }

    @available(*, deprecated, message: "use nodes.body")
    public func html() -> HTMLFragment {
        nodes.body
    }

    @available(*, deprecated, message: "use nodes.stylesheets")
    public func styles() -> [CSSStyleSheet] {
        nodes.stylesheets
    }
}

extension FlowDiagram {
    private static func makeAttrs(
        baseClasses: [AnyHTMLClass],
        classes: [HTMLClassToken],
        attrs: HTMLAttribute
    ) -> HTMLAttribute {
        var out = HTMLAttribute.classes(
            base: baseClasses,
            appending: classes
        )
        out.merge(attrs)
        return out
    }

    // private static func normalizeClasses(_ parts: [String]) -> [String] {
    //     parts
    //         .flatMap { $0.split(separator: " ").map(String.init) }
    //         .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    //         .filter { !$0.isEmpty }
    // }

    private static func boxHTML(_ b: Box) -> any HTMLNode {
        let s = selectors

        let alignClass: AnyHTMLClass = {
            switch b.align {
            case .center:
                return s.boxCenter.erased
            case .start:
                return s.boxStart.erased
            }
        }()

        let a = makeAttrs(
            baseClasses: [
                s.box.erased,
                alignClass
            ],
            classes: b.classes,
            attrs: b.attrs
        )

        return HTML.div(a) {
            HTML.div(.class(s.boxInner)) {
                b.content()
            }
        }

        // return HTML.div(a) {
        //     HTML.div(.class([s.boxInner.rawValue])) {
        //         b.content()
        //     }
        // }
    }

    private static func arrowHTML(_ ar: Arrow) -> any HTMLNode {
        let s = selectors

        var finalAttrs = HTMLAttribute()
        finalAttrs.merge(.aria("hidden", "true"))
        finalAttrs.merge(ar.attrs)

        let directionClasses: [AnyHTMLClass] = {
            switch ar.direction {
            case .right:
                return []
            case .left:
                return [s.arrowLeft.erased]
            case .both:
                return [s.arrowBoth.erased]
            }
        }()

        let a = makeAttrs(
            baseClasses: [s.arrow.erased] + directionClasses,
            classes: ar.classes,
            attrs: finalAttrs
        )

        return HTML.div(.class(s.arrowWrap)) {
            HTML.span(a) {}

            if let label = ar.label, !label.isEmpty {
                HTML.span(.class(s.arrowLabel)) {
                    HTML.text(label)
                }
            }
        }
    }

    public static func css() -> CSSStyleSheet {
        let s = selectors

        let root = s.root.rawValue
        let row = s.row.rawValue
        let col = s.col.rawValue
        let box = s.box.rawValue
        let boxInner = s.boxInner.rawValue
        let boxCenter = s.boxCenter.rawValue
        let boxStart = s.boxStart.rawValue
        let arrowWrap = s.arrowWrap.rawValue
        let arrow = s.arrow.rawValue
        let arrowLabel = s.arrowLabel.rawValue

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(root)",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("margin", "18px 0"),
                    CSS.decl("flex-wrap", "wrap")
                ),

                CSS.rule(
                    ".\(row)",
                    CSS.decl("flex-direction", "row")
                ),

                CSS.rule(
                    ".\(col)",
                    CSS.decl("flex-direction", "column")
                ),

                CSS.rule(
                    ".\(box)",
                    CSS.decl("background", "var(--background-color, #fff)"),
                    CSS.decl("color", "var(--text-color, #0f172a)"),
                    CSS.decl("border", "1px solid var(--border-color, rgba(0,0,0,0.12))"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("box-shadow", "var(--shadow-soft, 0 12px 28px rgba(0,0,0,0.08))"),
                    CSS.decl("padding", "14px 16px"),
                    CSS.decl("min-width", "160px"),
                    CSS.decl("max-width", "320px")
                ),

                CSS.rule(
                    ".dark-mode .\(box)",
                    CSS.decl(
                        "background",
                        "var(--submenu-bg-color, var(--background-color, #1e1e1e))"
                    )
                ),

                CSS.rule(
                    ".\(boxInner)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("min-height", "56px")
                ),

                CSS.rule(
                    ".\(boxInner) b, .\(boxInner) strong",
                    CSS.decl("color", "var(--text-color, #0f172a)"),
                    CSS.decl("font-weight", "700")
                ),

                CSS.rule(
                    ".\(boxInner) span, .\(boxInner) p",
                    CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))")
                ),

                CSS.rule(
                    ".\(boxCenter) .\(boxInner)",
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("text-align", "center")
                ),

                CSS.rule(
                    ".\(boxStart) .\(boxInner)",
                    CSS.decl("align-items", "flex-start"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("text-align", "left")
                ),

                CSS.rule(
                    ".\(arrowWrap)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("min-width", "48px")
                ),

                CSS.rule(
                    ".\(arrow)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "inline-block"),
                    CSS.decl("width", "54px"),
                    CSS.decl("height", "2px"),
                    CSS.decl("color", "var(--flow-arrow-color, var(--text-color, #0f172a))"),
                    CSS.decl("background", "currentColor"),
                    CSS.decl("border-radius", "999px")
                ),

                CSS.rule(
                    ".\(arrow)::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("right", "-1px"),
                    CSS.decl("top", "50%"),
                    CSS.decl("transform", "translateY(-50%)"),
                    CSS.decl("width", "0"),
                    CSS.decl("height", "0"),
                    CSS.decl("border-top", "7px solid transparent"),
                    CSS.decl("border-bottom", "7px solid transparent"),
                    CSS.decl("border-left", "10px solid currentColor")
                ),

                CSS.rule(
                    ".\(col) .\(arrow)",
                    CSS.decl("transform", "rotate(90deg)")
                ),

                CSS.rule(
                    ".\(arrowLabel)",
                    CSS.decl("font-size", "0.9rem"),
                    CSS.decl(
                        "color",
                        "var(--flow-label-color, var(--ref-meta-text-color, var(--text-color, #0f172a)))"
                    ),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("text-align", "center"),
                    CSS.decl("max-width", "180px")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 900px)",
                    CSS.rule(
                        ".\(box)",
                        CSS.decl("min-width", "148px"),
                        CSS.decl("max-width", "280px")
                    ),
                    CSS.rule(
                        ".\(arrow)",
                        CSS.decl("width", "48px")
                    )
                ),

                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".\(root)",
                        CSS.decl("gap", "10px")
                    ),
                    CSS.rule(
                        ".\(arrow)",
                        CSS.decl("width", "32px")
                    ),
                    CSS.rule(
                        ".\(box)",
                        CSS.decl("min-width", "132px"),
                        CSS.decl("max-width", "240px"),
                        CSS.decl("padding", "12px 12px")
                    ),
                    CSS.rule(
                        ".\(boxInner)",
                        CSS.decl("min-height", "48px"),
                        CSS.decl("gap", "5px")
                    ),
                    CSS.rule(
                        ".\(arrowWrap)",
                        CSS.decl("min-width", "30px")
                    ),
                    CSS.rule(
                        ".\(boxInner), .\(arrowLabel)",
                        CSS.decl("font-size", "0.95rem")
                    )
                )
            ]
        )
    }
}

// public struct FlowDiagram: WebComponent {
//     public let axis: Axis
//     public let classes: [String]
//     public let attrs: HTMLAttribute
//     public let items: [Item]

//     public init(
//         axis: Axis = .row,
//         classes: [String] = [],
//         attrs: HTMLAttribute = HTMLAttribute(),
//         items: [Item]
//     ) {
//         self.axis = axis
//         self.classes = classes
//         self.attrs = attrs
//         self.items = items
//     }

//     public func html() -> HTMLFragment {
//         let axisClass = (axis == .row) ? "wc-flow--row" : "wc-flow--col"
//         let a = Self.makeAttrs(
//             baseClasses: ["wc-flow", axisClass] + classes,
//             attrs: attrs
//         )

//         return [
//             HTML.div(a) {
//                 for item in items {
//                     switch item {
//                     case .box(let b):
//                         Self.boxHTML(b)

//                     case .arrow(let ar):
//                         Self.arrowHTML(ar)
//                     }
//                 }
//             }
//         ]
//     }

//     public func styles() -> [CSSStyleSheet] {
//         [Self.css()]
//     }
// }

// extension FlowDiagram {
//     private static func makeAttrs(
//         baseClasses: [String],
//         attrs: HTMLAttribute
//     ) -> HTMLAttribute {
//         var out = HTMLAttribute()
//         out.merge(.class(Self.normalizeClasses(baseClasses)))
//         out.merge(attrs)
//         return out
//     }

//     private static func normalizeClasses(_ parts: [String]) -> [String] {
//         parts
//             .flatMap { $0.split(separator: " ").map(String.init) }
//             .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
//             .filter { !$0.isEmpty }
//     }

//     private static func boxHTML(_ b: Box) -> any HTMLNode {
//         let alignClass: String = {
//             switch b.align {
//             case .center: return "wc-flow__box--center"
//             case .start:  return "wc-flow__box--start"
//             }
//         }()

//         let a = makeAttrs(
//             baseClasses: ["wc-flow__box", alignClass] + b.classes,
//             attrs: b.attrs
//         )

//         return HTML.div(a) {
//             HTML.div(.class(["wc-flow__box-inner"])) {
//                 b.content()
//             }
//         }
//     }

//     private static func arrowHTML(_ ar: Arrow) -> any HTMLNode {
//         // aria-hidden default (append-only; if you add your own aria-hidden you’ll get duplicates)
//         var finalAttrs = HTMLAttribute()
//         finalAttrs.merge(.aria("hidden", "true"))
//         finalAttrs.merge(ar.attrs)

//         let a = makeAttrs(
//             baseClasses: ["wc-flow__arrow"] + ar.classes,
//             attrs: finalAttrs
//         )

//         return HTML.div(.class(["wc-flow__arrow-wrap"])) {
//             HTML.span(a) {}

//             if let label = ar.label, !label.isEmpty {
//                 HTML.span(.class(["wc-flow__arrow-label"])) {
//                     HTML.text(label)
//                 }
//             }
//         }
//     }

//     public static func css() -> CSSStyleSheet {
//         CSSStyleSheet(
//             rules: [
//                 CSS.rule(
//                     ".wc-flow",
//                     CSS.decl("display", "flex"),
//                     CSS.decl("align-items", "center"),
//                     CSS.decl("justify-content", "center"),
//                     CSS.decl("gap", "14px"),
//                     CSS.decl("margin", "18px 0"),
//                     CSS.decl("flex-wrap", "wrap")
//                 ),

//                 CSS.rule(
//                     ".wc-flow--row",
//                     CSS.decl("flex-direction", "row")
//                 ),

//                 CSS.rule(
//                     ".wc-flow--col",
//                     CSS.decl("flex-direction", "column")
//                 ),

//                 CSS.rule(
//                     ".wc-flow__box",
//                     CSS.decl("background", "var(--background-color, #fff)"),
//                     CSS.decl("color", "var(--text-color, #0f172a)"),
//                     CSS.decl("border", "1px solid var(--border-color, rgba(0,0,0,0.12))"),
//                     CSS.decl("border-radius", "14px"),
//                     CSS.decl("box-shadow", "var(--shadow-soft, 0 12px 28px rgba(0,0,0,0.08))"),
//                     CSS.decl("padding", "14px 16px"),
//                     CSS.decl("min-width", "160px"),
//                     CSS.decl("max-width", "320px")
//                 ),

//                 CSS.rule(
//                     ".dark-mode .wc-flow__box",
//                     CSS.decl(
//                         "background", "var(--submenu-bg-color, var(--background-color, #1e1e1e))")
//                 ),

//                 CSS.rule(
//                     ".wc-flow__box-inner",
//                     CSS.decl("display", "flex"),
//                     CSS.decl("flex-direction", "column"),
//                     CSS.decl("gap", "6px"),
//                     CSS.decl("min-height", "56px")
//                 ),

//                 CSS.rule(
//                     ".wc-flow__box-inner b, .wc-flow__box-inner strong",
//                     CSS.decl("color", "var(--text-color, #0f172a)"),
//                     CSS.decl("font-weight", "700")
//                 ),

//                 CSS.rule(
//                     ".wc-flow__box-inner span, .wc-flow__box-inner p",
//                     CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))")
//                 ),

//                 CSS.rule(
//                     ".wc-flow__box--center .wc-flow__box-inner",
//                     CSS.decl("align-items", "center"),
//                     CSS.decl("justify-content", "center"),
//                     CSS.decl("text-align", "center")
//                 ),

//                 CSS.rule(
//                     ".wc-flow__box--start .wc-flow__box-inner",
//                     CSS.decl("align-items", "flex-start"),
//                     CSS.decl("justify-content", "center"),
//                     CSS.decl("text-align", "left")
//                 ),

//                 CSS.rule(
//                     ".wc-flow__arrow-wrap",
//                     CSS.decl("display", "flex"),
//                     CSS.decl("flex-direction", "column"),
//                     CSS.decl("align-items", "center"),
//                     CSS.decl("justify-content", "center"),
//                     CSS.decl("gap", "6px"),
//                     CSS.decl("min-width", "48px")
//                 ),

//                 CSS.rule(
//                     ".wc-flow__arrow",
//                     CSS.decl("position", "relative"),
//                     CSS.decl("display", "inline-block"),
//                     CSS.decl("width", "54px"),
//                     CSS.decl("height", "2px"),

//                     CSS.decl("color", "var(--flow-arrow-color, var(--text-color, #0f172a))"),

//                     CSS.decl("background", "currentColor"),
//                     CSS.decl("border-radius", "999px")
//                 ),

//                 CSS.rule(
//                     ".wc-flow__arrow::after",
//                     CSS.decl("content", "\"\""),
//                     CSS.decl("position", "absolute"),
//                     CSS.decl("right", "-1px"),
//                     CSS.decl("top", "50%"),
//                     CSS.decl("transform", "translateY(-50%)"),
//                     CSS.decl("width", "0"),
//                     CSS.decl("height", "0"),
//                     CSS.decl("border-top", "7px solid transparent"),
//                     CSS.decl("border-bottom", "7px solid transparent"),
//                     CSS.decl("border-left", "10px solid currentColor")
//                 ),

//                 CSS.rule(
//                     ".wc-flow--col .wc-flow__arrow",
//                     CSS.decl("transform", "rotate(90deg)")
//                 ),

//                 CSS.rule(
//                     ".wc-flow__arrow-label",
//                     CSS.decl("font-size", "0.9rem"),
//                     CSS.decl(
//                         "color",
//                         "var(--flow-label-color, var(--ref-meta-text-color, var(--text-color, #0f172a)))"
//                     ),
//                     CSS.decl("line-height", "1.15"),
//                     CSS.decl("text-align", "center"),
//                     CSS.decl("max-width", "180px")
//                 )
//             ],
//             media: [
//                 CSS.media(
//                     "(max-width: 900px)",
//                     CSS.rule(
//                         ".wc-flow__box",
//                         CSS.decl("min-width", "148px"),
//                         CSS.decl("max-width", "280px")
//                     ),
//                     CSS.rule(
//                         ".wc-flow__arrow",
//                         CSS.decl("width", "48px")
//                     )
//                 ),

//                 CSS.media(
//                     "(max-width: 640px)",
//                     CSS.rule(
//                         ".wc-flow",
//                         CSS.decl("gap", "10px")
//                     ),
//                     CSS.rule(
//                         ".wc-flow__arrow",
//                         CSS.decl("width", "32px")
//                     ),

//                     CSS.rule(
//                         ".wc-flow__box",
//                         CSS.decl("min-width", "132px"),
//                         CSS.decl("max-width", "240px"),
//                         CSS.decl("padding", "12px 12px")
//                     ),
//                     CSS.rule(
//                         ".wc-flow__box-inner",
//                         CSS.decl("min-height", "48px"),
//                         CSS.decl("gap", "5px")
//                     ),
//                     CSS.rule(
//                         ".wc-flow__arrow-wrap",
//                         CSS.decl("min-width", "30px")
//                     ),
//                     CSS.rule(
//                         ".wc-flow__box-inner, .wc-flow__arrow-label",
//                         CSS.decl("font-size", "0.95rem")
//                     )
//                 )
//             ]
//         )
//     }
// }
