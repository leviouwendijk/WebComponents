import Constructors
import HTML
import CSS

public struct DriveDiagram: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-drive-diagram"
        static let svg = "wc-drive-diagram__svg"

        static let nodeBox = "wc-drive-diagram__node-box"
        static let nodeTitle = "wc-drive-diagram__node-title"
        static let nodeSubtitle = "wc-drive-diagram__node-subtitle"

        static let dog = "wc-drive-diagram__dog"

        static let field = "wc-drive-diagram__field"
        static let slit = "wc-drive-diagram__slit"
        static let movement = "wc-drive-diagram__movement"
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
                    HTML.el(
                        "svg",
                        [
                            "class": ClassName.svg,
                            "viewBox": "0 0 1000 560",
                            "role": "img",
                            "aria-label": "Drijfveren: een hond beweegt weg van demotivatoren en zoekt toegang tot motivatoren."
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
                                    "markerWidth": "8",
                                    "markerHeight": "8",
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

                        // MARK: Demotivator node

                        HTML.el(
                            "rect",
                            [
                                "class": ClassName.nodeBox,
                                "x": "110",
                                "y": "72",
                                "width": "300",
                                "height": "92",
                                "rx": "6"
                            ]
                        ) {}

                        HTML.el(
                            "text",
                            [
                                "class": ClassName.nodeTitle,
                                "x": "260",
                                "y": "108",
                                "text-anchor": "middle"
                            ]
                        ) {
                            HTML.text("Demotivator")
                        }

                        HTML.el(
                            "text",
                            [
                                "class": ClassName.nodeSubtitle,
                                "x": "260",
                                "y": "138",
                                "text-anchor": "middle"
                            ]
                        ) {
                            HTML.text("afstoter")
                        }

                        // Repelling field: the curve is the local “force surface”.
                        HTML.el(
                            "path",
                            [
                                "class": ClassName.field,
                                "d": "M 420 92 C 430 205 362 292 252 312"
                            ]
                        ) {}

                        // Movement away from the demotivator.
                        HTML.el(
                            "path",
                            [
                                "class": ClassName.movement,
                                "d": "M 386 205 L 438 244",
                                "marker-end": "url(#\(markerID))"
                            ]
                        ) {}

                        HTML.el(
                            "path",
                            [
                                "class": ClassName.movement,
                                "d": "M 345 258 L 412 318",
                                "marker-end": "url(#\(markerID))"
                            ]
                        ) {}

                        HTML.el(
                            "path",
                            [
                                "class": ClassName.movement,
                                "d": "M 285 316 L 443 368",
                                "marker-end": "url(#\(markerID))"
                            ]
                        ) {}

                        // MARK: Motivator node

                        HTML.el(
                            "rect",
                            [
                                "class": ClassName.nodeBox,
                                "x": "590",
                                "y": "72",
                                "width": "300",
                                "height": "92",
                                "rx": "6"
                            ]
                        ) {}

                        HTML.el(
                            "text",
                            [
                                "class": ClassName.nodeTitle,
                                "x": "740",
                                "y": "108",
                                "text-anchor": "middle"
                            ]
                        ) {
                            HTML.text("Motivator")
                        }

                        HTML.el(
                            "text",
                            [
                                "class": ClassName.nodeSubtitle,
                                "x": "740",
                                "y": "138",
                                "text-anchor": "middle"
                            ]
                        ) {
                            HTML.text("aantrekker")
                        }

                        // Access / seeking slit around the attractor.
                        HTML.el(
                            "path",
                            [
                                "class": ClassName.slit,
                                "d": "M 574 190 L 540 156"
                            ]
                        ) {}

                        HTML.el(
                            "path",
                            [
                                "class": ClassName.slit,
                                "d": "M 626 222 L 772 368"
                            ]
                        ) {}

                        HTML.el(
                            "path",
                            [
                                "class": ClassName.slit,
                                "d": "M 820 190 L 854 156"
                            ]
                        ) {}

                        // Movement toward the motivator.
                        HTML.el(
                            "path",
                            [
                                "class": ClassName.movement,
                                "d": "M 540 342 L 654 228",
                                "marker-end": "url(#\(markerID))"
                            ]
                        ) {}

                        HTML.el(
                            "path",
                            [
                                "class": ClassName.movement,
                                "d": "M 572 374 L 704 242",
                                "marker-end": "url(#\(markerID))"
                            ]
                        ) {}

                        // Dog / behaving organism.
                        HTML.el(
                            "circle",
                            [
                                "class": ClassName.dog,
                                "cx": "500",
                                "cy": "390",
                                "r": "32"
                            ]
                        ) {}
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
                    ".\(ClassName.svg)",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "auto"),
                    CSS.decl("max-width", "1000px"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("overflow", "visible"),
                    CSS.decl("border-bottom", "1px solid var(--border-color, rgba(255,255,255,0.65))")
                ),

                CSS.rule(
                    ".\(ClassName.nodeBox)",
                    CSS.decl("fill", "transparent"),
                    CSS.decl("stroke", "currentColor"),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("vector-effect", "non-scaling-stroke")
                ),

                CSS.rule(
                    ".\(ClassName.nodeTitle)",
                    CSS.decl("fill", "currentColor"),
                    CSS.decl("font-family", "ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", "30px"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("letter-spacing", "0.04em")
                ),

                CSS.rule(
                    ".\(ClassName.nodeSubtitle)",
                    CSS.decl("fill", "currentColor"),
                    CSS.decl("font-family", "ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", "17px"),
                    CSS.decl("font-weight", "500"),
                    CSS.decl("letter-spacing", "0.06em"),
                    CSS.decl("opacity", "0.68")
                ),

                CSS.rule(
                    ".\(ClassName.dog)",
                    CSS.decl("fill", "currentColor")
                ),

                CSS.rule(
                    ".\(ClassName.field), .\(ClassName.slit), .\(ClassName.movement)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "currentColor"),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round"),
                    CSS.decl("vector-effect", "non-scaling-stroke")
                ),

                CSS.rule(
                    ".\(ClassName.field)",
                    CSS.decl("opacity", "0.84")
                ),

                CSS.rule(
                    ".\(ClassName.slit)",
                    CSS.decl("opacity", "0.78")
                ),

                CSS.rule(
                    ".\(ClassName.movement)",
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
                        ".\(ClassName.nodeTitle)",
                        CSS.decl("font-size", "28px")
                    ),
                    CSS.rule(
                        ".\(ClassName.nodeSubtitle)",
                        CSS.decl("font-size", "16px")
                    )
                )
            ]
        )
    }
}
