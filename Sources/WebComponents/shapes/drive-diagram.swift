import Constructors
import HTML
import CSS

public struct DriveDiagram: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-drive-diagram"
        static let stage = "wc-drive-diagram__stage"
        static let fieldLayer = "wc-drive-diagram__field-layer"

        static let node = "wc-drive-diagram__node"
        static let demotivator = "wc-drive-diagram__node--demotivator"
        static let motivator = "wc-drive-diagram__node--motivator"
        static let nodeTitle = "wc-drive-diagram__node-title"
        static let nodeSubtitle = "wc-drive-diagram__node-subtitle"

        static let dog = "wc-drive-diagram__dog"
        static let field = "wc-drive-diagram__field"
        static let repulsion = "wc-drive-diagram__repulsion"
        static let attraction = "wc-drive-diagram__attraction"
        static let access = "wc-drive-diagram__access"
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
                    HTML.div(HTMLAttribute.class(ClassName.stage)) {
                        HTML.el(
                            "svg",
                            [
                                "class": ClassName.fieldLayer,
                                "viewBox": "0 0 1000 560",
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

                            // Left side: repelling surface around the demotivator.
                            HTML.el(
                                "path",
                                [
                                    "class": "\(ClassName.field) \(ClassName.repulsion)",
                                    "d": "M 392 106 C 418 214 356 334 236 368"
                                ]
                            ) {}

                            HTML.el(
                                "path",
                                [
                                    "class": "\(ClassName.field) \(ClassName.repulsion)",
                                    "d": "M 408 142 C 414 242 366 318 292 344"
                                ]
                            ) {}

                            // Dog movement away from the demotivator.
                            HTML.el(
                                "path",
                                [
                                    "class": "\(ClassName.field) \(ClassName.repulsion)",
                                    "d": "M 372 214 C 404 236 432 256 458 282",
                                    "marker-end": "url(#\(markerID))"
                                ]
                            ) {}

                            HTML.el(
                                "path",
                                [
                                    "class": "\(ClassName.field) \(ClassName.repulsion)",
                                    "d": "M 332 306 C 370 338 408 362 456 382",
                                    "marker-end": "url(#\(markerID))"
                                ]
                            ) {}

                            // Right side: access channel / slit toward the motivator.
                            HTML.el(
                                "path",
                                [
                                    "class": "\(ClassName.field) \(ClassName.access)",
                                    "d": "M 594 168 C 548 238 526 315 512 392"
                                ]
                            ) {}

                            HTML.el(
                                "path",
                                [
                                    "class": "\(ClassName.field) \(ClassName.access)",
                                    "d": "M 770 168 C 708 246 626 333 538 392"
                                ]
                            ) {}

                            // Dog movement toward the motivator through the access channel.
                            HTML.el(
                                "path",
                                [
                                    "class": "\(ClassName.field) \(ClassName.attraction)",
                                    "d": "M 530 368 C 574 318 620 268 674 216",
                                    "marker-end": "url(#\(markerID))"
                                ]
                            ) {}

                            HTML.el(
                                "path",
                                [
                                    "class": "\(ClassName.field) \(ClassName.attraction)",
                                    "d": "M 566 392 C 626 332 690 270 748 214",
                                    "marker-end": "url(#\(markerID))"
                                ]
                            ) {}

                            // Dog / behaving organism.
                            HTML.el(
                                "circle",
                                [
                                    "class": ClassName.dog,
                                    "cx": "500",
                                    "cy": "406",
                                    "r": "31"
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
                    CSS.decl("margin", "26px 0 30px"),
                    CSS.decl("padding", "0"),
                    CSS.decl("color", "var(--text-color, #f4f4f4)")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("position", "relative"),
                    CSS.decl("width", "100%"),
                    CSS.decl("max-width", "1000px"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("aspect-ratio", "1000 / 560"),
                    CSS.decl("border-bottom", "1px solid var(--border-color, rgba(255,255,255,0.65))")
                ),

                CSS.rule(
                    ".\(ClassName.fieldLayer)",
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
                    CSS.decl("min-height", "16.5%"),
                    CSS.decl("padding", "0.75rem 1rem"),
                    CSS.decl("border", "2px solid currentColor"),
                    CSS.decl("border-radius", "6px"),
                    CSS.decl("background", "var(--background-color, #171717)")
                ),

                CSS.rule(
                    ".\(ClassName.demotivator)",
                    CSS.decl("left", "11%"),
                    CSS.decl("top", "12%")
                ),

                CSS.rule(
                    ".\(ClassName.motivator)",
                    CSS.decl("right", "11%"),
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
                    CSS.decl("fill", "currentColor")
                ),

                CSS.rule(
                    ".\(ClassName.field)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "currentColor"),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round"),
                    CSS.decl("vector-effect", "non-scaling-stroke")
                ),

                CSS.rule(
                    ".\(ClassName.repulsion)",
                    CSS.decl("opacity", "0.9")
                ),

                CSS.rule(
                    ".\(ClassName.access)",
                    CSS.decl("opacity", "0.62")
                ),

                CSS.rule(
                    ".\(ClassName.attraction)",
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
                        ".\(ClassName.root)",
                        CSS.decl("margin", "18px 0 22px")
                    ),
                    CSS.rule(
                        ".\(ClassName.node)",
                        CSS.decl("width", "31%"),
                        CSS.decl("padding", "0.55rem 0.7rem"),
                        CSS.decl("border-width", "1px")
                    ),
                    CSS.rule(
                        ".\(ClassName.demotivator)",
                        CSS.decl("left", "8%")
                    ),
                    CSS.rule(
                        ".\(ClassName.motivator)",
                        CSS.decl("right", "8%")
                    )
                )
            ]
        )
    }
}
