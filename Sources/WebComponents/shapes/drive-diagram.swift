import Constructors
import HTML
import CSS

public struct DriveDiagram: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-drive-diagram"
        static let stage = "wc-drive-diagram__stage"
        static let layer = "wc-drive-diagram__layer"

        static let node = "wc-drive-diagram__node"
        static let demotivator = "wc-drive-diagram__node--demotivator"
        static let motivator = "wc-drive-diagram__node--motivator"
        static let nodeTitle = "wc-drive-diagram__node-title"
        static let nodeSubtitle = "wc-drive-diagram__node-subtitle"

        static let dog = "wc-drive-diagram__dog"
        static let dogDot = "wc-drive-diagram__dog-dot"
        static let dogLabel = "wc-drive-diagram__dog-label"

        static let label = "wc-drive-diagram__label"
        static let avoidLabel = "wc-drive-diagram__label--avoid"
        static let approachLabel = "wc-drive-diagram__label--approach"

        static let path = "wc-drive-diagram__path"
        static let repel = "wc-drive-diagram__path--repel"
        static let attract = "wc-drive-diagram__path--attract"
        static let markerHead = "wc-drive-diagram__marker-head"

        static let caption = "wc-drive-diagram__caption"
    }

    public let id: String
    public let caption: String?

    public init(
        id: String = "drive-diagram",
        caption: String? = nil
    ) {
        self.id = id
        self.caption = caption
    }

    public var nodes: ReusableComponentNodes {
        let markerID = "\(id)-arrowhead"

        return .body(
            [
                HTML.figure(HTMLAttribute.class(ClassName.root)) {
                    HTML.div(
                        [
                            "class": ClassName.stage,
                            "role": "img",
                            "aria-label": "Drijfveren: de hond beweegt weg van afstoters en naar aantrekkers."
                        ]
                    ) {
                        HTML.el(
                            "svg",
                            [
                                "class": ClassName.layer,
                                "viewBox": "0 0 1000 420",
                                "aria-hidden": "true"
                            ]
                        ) {
                            HTML.el("defs") {
                                HTML.el(
                                    "marker",
                                    [
                                        "id": markerID,
                                        "viewBox": "0 0 10 10",
                                        "refX": "9",
                                        "refY": "5",
                                        "markerWidth": "7",
                                        "markerHeight": "7",
                                        "orient": "auto"
                                    ]
                                ) {
                                    HTML.el(
                                        "path",
                                        [
                                            "class": ClassName.markerHead,
                                            "d": "M 0 0 L 10 5 L 0 10 z"
                                        ]
                                    ) {}
                                }
                            }

                            // Afstoter: movement away from the demotivator.
                            HTML.el(
                                "path",
                                [
                                    "class": "\(ClassName.path) \(ClassName.repel)",
                                    "d": "M 310 186 C 366 210 408 242 444 292",
                                    "marker-end": "url(#\(markerID))"
                                ]
                            ) {}

                            HTML.el(
                                "path",
                                [
                                    "class": "\(ClassName.path) \(ClassName.repel)",
                                    "d": "M 260 244 C 326 284 382 310 448 326",
                                    "marker-end": "url(#\(markerID))"
                                ]
                            ) {}

                            // Aantrekker: movement toward the motivator.
                            HTML.el(
                                "path",
                                [
                                    "class": "\(ClassName.path) \(ClassName.attract)",
                                    "d": "M 552 292 C 600 244 646 210 704 186",
                                    "marker-end": "url(#\(markerID))"
                                ]
                            ) {}

                            HTML.el(
                                "path",
                                [
                                    "class": "\(ClassName.path) \(ClassName.attract)",
                                    "d": "M 552 326 C 624 308 684 276 742 244",
                                    "marker-end": "url(#\(markerID))"
                                ]
                            ) {}
                        }

                        HTML.div(HTMLAttribute.class([ClassName.node, ClassName.demotivator])) {
                            HTML.div(HTMLAttribute.class(ClassName.nodeTitle)) {
                                HTML.text("Demotivator")
                            }

                            HTML.div(HTMLAttribute.class(ClassName.nodeSubtitle)) {
                                HTML.text("afstoter")
                            }
                        }

                        HTML.div(HTMLAttribute.class([ClassName.node, ClassName.motivator])) {
                            HTML.div(HTMLAttribute.class(ClassName.nodeTitle)) {
                                HTML.text("Motivator")
                            }

                            HTML.div(HTMLAttribute.class(ClassName.nodeSubtitle)) {
                                HTML.text("aantrekker")
                            }
                        }

                        HTML.div(HTMLAttribute.class(ClassName.dog)) {
                            HTML.div(HTMLAttribute.class(ClassName.dogDot)) {}
                            HTML.div(HTMLAttribute.class(ClassName.dogLabel)) {
                                HTML.text("hond")
                            }
                        }

                        HTML.div(HTMLAttribute.class([ClassName.label, ClassName.avoidLabel])) {
                            HTML.text("afstand maken")
                        }

                        HTML.div(HTMLAttribute.class([ClassName.label, ClassName.approachLabel])) {
                            HTML.text("toegang zoeken")
                        }
                    }

                    if let caption, !caption.isEmpty {
                        HTML.figcaption(HTMLAttribute.class(ClassName.caption)) {
                            HTML.text(caption)
                        }
                    }
                }
            ],
            stylesheets: [
                Self.css()
            ]
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public static func css() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("margin", "24px 0 28px"),
                    CSS.decl("padding", "0"),
                    CSS.decl("color", "var(--text-color, #f4f4f4)")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("position", "relative"),
                    CSS.decl("width", "100%"),
                    CSS.decl("max-width", "1000px"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("aspect-ratio", "1000 / 420"),
                    CSS.decl("border-bottom", "1px solid var(--border-color, rgba(255,255,255,0.65))")
                ),

                CSS.rule(
                    ".\(ClassName.layer)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("inset", "0"),
                    CSS.decl("display", "block"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "100%"),
                    CSS.decl("overflow", "visible")
                ),

                CSS.rule(
                    ".\(ClassName.node)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("z-index", "2"),
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("gap", "0.18em"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("width", "30%"),
                    CSS.decl("min-height", "18%"),
                    CSS.decl("padding", "0.75rem 1rem"),
                    CSS.decl("border", "2px solid currentColor"),
                    CSS.decl("border-radius", "6px"),
                    CSS.decl("background", "var(--background-color, #171717)")
                ),

                CSS.rule(
                    ".\(ClassName.demotivator)",
                    CSS.decl("left", "7%"),
                    CSS.decl("top", "12%")
                ),

                CSS.rule(
                    ".\(ClassName.motivator)",
                    CSS.decl("right", "7%"),
                    CSS.decl("top", "12%")
                ),

                CSS.rule(
                    ".\(ClassName.nodeTitle)",
                    CSS.decl("font-size", "clamp(1.05rem, 3vw, 1.85rem)"),
                    CSS.decl("line-height", "1.08"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", "0.01em")
                ),

                CSS.rule(
                    ".\(ClassName.nodeSubtitle)",
                    CSS.decl("font-size", "clamp(0.72rem, 1.5vw, 0.95rem)"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("font-weight", "500"),
                    CSS.decl("opacity", "0.66")
                ),

                CSS.rule(
                    ".\(ClassName.dog)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("z-index", "2"),
                    CSS.decl("left", "50%"),
                    CSS.decl("top", "72%"),
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "0.4rem"),
                    CSS.decl("transform", "translate(-50%, -50%)")
                ),

                CSS.rule(
                    ".\(ClassName.dogDot)",
                    CSS.decl("width", "clamp(34px, 6vw, 58px)"),
                    CSS.decl("height", "clamp(34px, 6vw, 58px)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "currentColor")
                ),

                CSS.rule(
                    ".\(ClassName.dogLabel)",
                    CSS.decl("font-size", "0.8rem"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("opacity", "0.68")
                ),

                CSS.rule(
                    ".\(ClassName.label)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("z-index", "2"),
                    CSS.decl("font-size", "clamp(0.78rem, 1.5vw, 0.95rem)"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("opacity", "0.72"),
                    CSS.decl("white-space", "nowrap")
                ),

                CSS.rule(
                    ".\(ClassName.avoidLabel)",
                    CSS.decl("left", "32%"),
                    CSS.decl("top", "54%"),
                    CSS.decl("transform", "translateX(-50%)")
                ),

                CSS.rule(
                    ".\(ClassName.approachLabel)",
                    CSS.decl("right", "29%"),
                    CSS.decl("top", "54%"),
                    CSS.decl("transform", "translateX(50%)")
                ),

                CSS.rule(
                    ".\(ClassName.path)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "currentColor"),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round"),
                    CSS.decl("vector-effect", "non-scaling-stroke")
                ),

                CSS.rule(
                    ".\(ClassName.repel)",
                    CSS.decl("opacity", "0.72")
                ),

                CSS.rule(
                    ".\(ClassName.attract)",
                    CSS.decl("opacity", "0.95")
                ),

                CSS.rule(
                    ".\(ClassName.markerHead)",
                    CSS.decl("fill", "currentColor")
                ),

                CSS.rule(
                    ".\(ClassName.caption)",
                    CSS.decl("margin-top", "10px"),
                    CSS.decl("font-size", "0.95rem"),
                    CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(ClassName.node)",
                        CSS.decl("width", "32%"),
                        CSS.decl("padding", "0.55rem 0.7rem"),
                        CSS.decl("border-width", "1px")
                    ),
                    CSS.rule(
                        ".\(ClassName.demotivator)",
                        CSS.decl("left", "4%")
                    ),
                    CSS.rule(
                        ".\(ClassName.motivator)",
                        CSS.decl("right", "4%")
                    ),
                    CSS.rule(
                        ".\(ClassName.label)",
                        CSS.decl("display", "none")
                    )
                )
            ]
        )
    }
}
