import Constructors
import HTML
import CSS

public struct DriveDiagram: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-drive-diagram"
        static let svg = "wc-drive-diagram__svg"
        static let card = "wc-drive-diagram__card"
        static let cardText = "wc-drive-diagram__card-text"
        static let subject = "wc-drive-diagram__subject"
        static let arrow = "wc-drive-diagram__arrow"
        static let ray = "wc-drive-diagram__ray"
        static let forceArc = "wc-drive-diagram__force-arc"
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
                            "viewBox": "0 0 860 420",
                            "role": "img",
                            "aria-label": "Drijfveren: demotivatoren stoten gedrag af, motivatoren trekken gedrag aan."
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
                                    "orient": "auto-start-reverse"
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

                        HTML.el(
                            "rect",
                            [
                                "class": ClassName.card,
                                "x": "88",
                                "y": "58",
                                "width": "238",
                                "height": "70",
                                "rx": "6"
                            ]
                        ) {}

                        HTML.el(
                            "text",
                            [
                                "class": ClassName.cardText,
                                "x": "207",
                                "y": "94",
                                "text-anchor": "middle",
                                "dominant-baseline": "middle"
                            ]
                        ) {
                            HTML.text("Demotivator")
                        }

                        HTML.el(
                            "rect",
                            [
                                "class": ClassName.card,
                                "x": "534",
                                "y": "58",
                                "width": "238",
                                "height": "70",
                                "rx": "6"
                            ]
                        ) {}

                        HTML.el(
                            "text",
                            [
                                "class": ClassName.cardText,
                                "x": "653",
                                "y": "94",
                                "text-anchor": "middle",
                                "dominant-baseline": "middle"
                            ]
                        ) {
                            HTML.text("Motivator")
                        }

                        HTML.el(
                            "path",
                            [
                                "class": "\(ClassName.arrow) \(ClassName.forceArc)",
                                "d": "M 323 118 C 318 174 281 218 226 230"
                            ]
                        ) {}

                        HTML.el(
                            "path",
                            [
                                "class": ClassName.arrow,
                                "d": "M 292 194 L 342 232",
                                "marker-end": "url(#\(markerID))"
                            ]
                        ) {}

                        HTML.el(
                            "path",
                            [
                                "class": ClassName.arrow,
                                "d": "M 338 214 L 386 252",
                                "marker-end": "url(#\(markerID))"
                            ]
                        ) {}

                        HTML.el(
                            "path",
                            [
                                "class": ClassName.arrow,
                                "d": "M 502 252 L 571 184",
                                "marker-end": "url(#\(markerID))"
                            ]
                        ) {}

                        HTML.el(
                            "path",
                            [
                                "class": ClassName.arrow,
                                "d": "M 469 228 L 542 156",
                                "marker-end": "url(#\(markerID))"
                            ]
                        ) {}

                        HTML.el(
                            "path",
                            [
                                "class": ClassName.ray,
                                "d": "M 388 158 L 354 124"
                            ]
                        ) {}

                        HTML.el(
                            "path",
                            [
                                "class": ClassName.ray,
                                "d": "M 572 124 L 606 158"
                            ]
                        ) {}

                        HTML.el(
                            "circle",
                            [
                                "class": ClassName.subject,
                                "cx": "430",
                                "cy": "270",
                                "r": "28"
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
                    CSS.decl("max-width", "860px"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("overflow", "visible"),
                    CSS.decl("border-bottom", "1px solid var(--border-color, rgba(255,255,255,0.65))")
                ),

                CSS.rule(
                    ".\(ClassName.card)",
                    CSS.decl("fill", "transparent"),
                    CSS.decl("stroke", "currentColor"),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("vector-effect", "non-scaling-stroke")
                ),

                CSS.rule(
                    ".\(ClassName.cardText)",
                    CSS.decl("fill", "currentColor"),
                    CSS.decl("font-family", "ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", "30px"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("letter-spacing", "0.04em")
                ),

                CSS.rule(
                    ".\(ClassName.subject)",
                    CSS.decl("fill", "currentColor")
                ),

                CSS.rule(
                    ".\(ClassName.arrow), .\(ClassName.ray), .\(ClassName.forceArc)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "currentColor"),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round"),
                    CSS.decl("vector-effect", "non-scaling-stroke")
                ),

                CSS.rule(
                    ".\(ClassName.forceArc)",
                    CSS.decl("opacity", "0.9")
                ),

                CSS.rule(
                    ".\(ClassName.ray)",
                    CSS.decl("opacity", "0.85")
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
                        ".\(ClassName.cardText)",
                        CSS.decl("font-size", "28px")
                    )
                )
            ]
        )
    }
}
