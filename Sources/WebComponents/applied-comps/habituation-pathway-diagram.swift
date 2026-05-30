import Constructors
import CSS
import HTML

public struct HabituationPathwayDiagram: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-habituation-pathway-diagram"
        static let stage = "wc-habituation-pathway-diagram__stage"
        static let svg = "wc-habituation-pathway-diagram__svg"
        static let caption = "wc-habituation-pathway-diagram__caption"

        static let field = "wc-habituation-pathway-diagram__field"
        static let fieldDot = "wc-habituation-pathway-diagram__field-dot"

        static let connection = "wc-habituation-pathway-diagram__connection"
        static let connectionWeak = "wc-habituation-pathway-diagram__connection--weak"
        static let connectionDetached = "wc-habituation-pathway-diagram__connection--detached"

        static let groove = "wc-habituation-pathway-diagram__groove"
        static let activePath = "wc-habituation-pathway-diagram__active-path"
        static let activePulse = "wc-habituation-pathway-diagram__active-pulse"

        static let node = "wc-habituation-pathway-diagram__node"
        static let nodeActive = "wc-habituation-pathway-diagram__node--active"
        static let nodeWeak = "wc-habituation-pathway-diagram__node--weak"
        static let nodeDetached = "wc-habituation-pathway-diagram__node--detached"

        static let label = "wc-habituation-pathway-diagram__label"
        static let labelTitle = "wc-habituation-pathway-diagram__label-title"
        static let labelBody = "wc-habituation-pathway-diagram__label-body"
        static let calloutLine = "wc-habituation-pathway-diagram__callout-line"
    }

    public let id: String
    public let caption: String?
    public let includeStyles: Bool

    public init(
        id: String = "habituation-pathway-diagram",
        caption: String? = "Bij herhaling zonder wezenlijke verandering wordt dezelfde verwerkingsroute makkelijker beschikbaar. Andere routes blijven mogelijk, maar worden minder vanzelfsprekend geactiveerd.",
        includeStyles: Bool = true
    ) {
        self.id = id
        self.caption = caption
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.figure(
                    [
                        "id": id,
                        "class": ClassName.root
                    ]
                ) {
                    HTML.div(
                        [
                            "class": ClassName.stage,
                            "role": "img",
                            "aria-label": "Vergewoontelijking: herhaling maakt een route sterker, terwijl zwakkere en nog losstaande routes minder beschikbaar blijven."
                        ]
                    ) {
                        Self.svg()
                    }

                    if let caption, !caption.isEmpty {
                        HTML.figcaption(["class": ClassName.caption]) {
                            HTML.text(caption)
                        }
                    }
                }
            ],
            stylesheets: includeStyles
                ? [
                    Self.stylesheet()
                ]
                : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public static func svg() -> any HTMLNode {
        HTML.el(
            "svg",
            [
                "class": ClassName.svg,
                "viewBox": "0 0 760 360",
                "preserveAspectRatio": "xMidYMid meet",
                "role": "img",
                "aria-label": "Een veld met neurale knooppunten. Een centrale route is dik en actief; zijroutes zijn dunner; losstaande routes zijn gestippeld."
            ]
        ) {
            HTML.el("defs") {
                HTML.el(
                    "radialGradient",
                    [
                        "id": "habituation-field-glow",
                        "cx": "50%",
                        "cy": "48%",
                        "r": "70%"
                    ]
                ) {
                    HTML.el(
                        "stop",
                        [
                            "offset": "0%",
                            "stop-color": "currentColor",
                            "stop-opacity": ".09"
                        ]
                    ) {}

                    HTML.el(
                        "stop",
                        [
                            "offset": "58%",
                            "stop-color": "currentColor",
                            "stop-opacity": ".035"
                        ]
                    ) {}

                    HTML.el(
                        "stop",
                        [
                            "offset": "100%",
                            "stop-color": "currentColor",
                            "stop-opacity": "0"
                        ]
                    ) {}
                }

                HTML.el(
                    "filter",
                    [
                        "id": "habituation-soft-shadow",
                        "x": "-20%",
                        "y": "-20%",
                        "width": "140%",
                        "height": "140%"
                    ]
                ) {
                    HTML.el(
                        "feDropShadow",
                        [
                            "dx": "0",
                            "dy": "8",
                            "stdDeviation": "8",
                            "flood-color": "currentColor",
                            "flood-opacity": ".10"
                        ]
                    ) {}
                }
            }

            HTML.el(
                "rect",
                [
                    "class": ClassName.field,
                    "x": "18",
                    "y": "18",
                    "width": "724",
                    "height": "324",
                    "rx": "28",
                    "ry": "28"
                ]
            ) {}

            field_dot(x: 86, y: 82, r: 3)
            field_dot(x: 134, y: 136, r: 2)
            field_dot(x: 162, y: 62, r: 2)
            field_dot(x: 210, y: 266, r: 3)
            field_dot(x: 252, y: 96, r: 2)
            field_dot(x: 322, y: 292, r: 2)
            field_dot(x: 408, y: 72, r: 3)
            field_dot(x: 478, y: 278, r: 2)
            field_dot(x: 544, y: 92, r: 2)
            field_dot(x: 614, y: 250, r: 3)
            field_dot(x: 668, y: 118, r: 2)
            field_dot(x: 690, y: 300, r: 2)

            path(
                className: "\(ClassName.connection) \(ClassName.connectionWeak)",
                d: "M 164 190 C 222 132, 285 112, 348 128"
            )

            path(
                className: "\(ClassName.connection) \(ClassName.connectionWeak)",
                d: "M 348 128 C 430 120, 486 150, 544 116"
            )

            path(
                className: "\(ClassName.connection) \(ClassName.connectionWeak)",
                d: "M 280 210 C 330 264, 410 282, 480 244"
            )

            path(
                className: "\(ClassName.connection) \(ClassName.connectionDetached)",
                d: "M 92 274 C 132 238, 170 238, 210 266"
            )

            path(
                className: "\(ClassName.connection) \(ClassName.connectionDetached)",
                d: "M 552 244 C 602 216, 650 222, 690 254"
            )

            path(
                className: "\(ClassName.connection) \(ClassName.connectionDetached)",
                d: "M 570 154 C 616 126, 652 134, 688 166"
            )

            path(
                className: ClassName.groove,
                d: "M 88 198 C 166 174, 210 224, 284 204 C 370 180, 422 136, 506 154 C 584 170, 630 144, 690 112"
            )

            path(
                className: ClassName.activePath,
                d: "M 88 198 C 166 174, 210 224, 284 204 C 370 180, 422 136, 506 154 C 584 170, 630 144, 690 112"
            )

            path(
                className: ClassName.activePulse,
                d: "M 88 198 C 166 174, 210 224, 284 204 C 370 180, 422 136, 506 154 C 584 170, 630 144, 690 112"
            )

            active_node(x: 88, y: 198, label: "1")
            active_node(x: 164, y: 190, label: "2")
            active_node(x: 284, y: 204, label: "3")
            active_node(x: 410, y: 148, label: "4")
            active_node(x: 506, y: 154, label: "5")
            active_node(x: 610, y: 144, label: "6")
            active_node(x: 690, y: 112, label: "7")

            weak_node(x: 348, y: 128)
            weak_node(x: 544, y: 116)
            weak_node(x: 480, y: 244)

            detached_node(x: 92, y: 274)
            detached_node(x: 210, y: 266)
            detached_node(x: 552, y: 244)
            detached_node(x: 690, y: 254)
            detached_node(x: 570, y: 154)
            detached_node(x: 688, y: 166)

            callout(
                x: 70,
                y: 54,
                width: 170,
                title: "Herhaling",
                body: "dezelfde route vuurt opnieuw",
                lineD: "M 154 112 C 140 140, 118 168, 88 198"
            )

            callout(
                x: 300,
                y: 234,
                width: 188,
                title: "Ingesleten route",
                body: "sterker, dikker, makkelijker beschikbaar",
                lineD: "M 394 234 C 402 208, 416 178, 410 148"
            )

            callout(
                x: 530,
                y: 36,
                width: 166,
                title: "Losse routes",
                body: "mogelijk, maar nog niet stabiel verbonden",
                lineD: "M 590 96 C 600 124, 604 142, 570 154"
            )
        }
    }

    private static func path(
        className: String,
        d: String
    ) -> any HTMLNode {
        HTML.el(
            "path",
            [
                "class": className,
                "d": d
            ]
        ) {}
    }

    private static func field_dot(
        x: Int,
        y: Int,
        r: Int
    ) -> any HTMLNode {
        HTML.el(
            "circle",
            [
                "class": ClassName.fieldDot,
                "cx": "\(x)",
                "cy": "\(y)",
                "r": "\(r)"
            ]
        ) {}
    }

    private static func active_node(
        x: Int,
        y: Int,
        label: String
    ) -> any HTMLNode {
        HTML.el(
            "g",
            [
                "class": "\(ClassName.node) \(ClassName.nodeActive)"
            ]
        ) {
            HTML.el(
                "circle",
                [
                    "cx": "\(x)",
                    "cy": "\(y)",
                    "r": "11"
                ]
            ) {}

            HTML.el(
                "text",
                [
                    "x": "\(x)",
                    "y": "\(y + 4)",
                    "text-anchor": "middle"
                ]
            ) {
                HTML.text(label)
            }
        }
    }

    private static func weak_node(
        x: Int,
        y: Int
    ) -> any HTMLNode {
        HTML.el(
            "circle",
            [
                "class": "\(ClassName.node) \(ClassName.nodeWeak)",
                "cx": "\(x)",
                "cy": "\(y)",
                "r": "8"
            ]
        ) {}
    }

    private static func detached_node(
        x: Int,
        y: Int
    ) -> any HTMLNode {
        HTML.el(
            "circle",
            [
                "class": "\(ClassName.node) \(ClassName.nodeDetached)",
                "cx": "\(x)",
                "cy": "\(y)",
                "r": "7"
            ]
        ) {}
    }

    private static func callout(
        x: Int,
        y: Int,
        width: Int,
        title: String,
        body: String,
        lineD: String
    ) -> HTMLFragment {
        [
            path(
                className: ClassName.calloutLine,
                d: lineD
            ),

            HTML.el(
                "g",
                [
                    "class": ClassName.label,
                    "transform": "translate(\(x) \(y))"
                ]
            ) {
                HTML.el(
                    "rect",
                    [
                        "x": "0",
                        "y": "0",
                        "width": "\(width)",
                        "height": "62",
                        "rx": "14",
                        "ry": "14"
                    ]
                ) {}

                HTML.el(
                    "text",
                    [
                        "class": ClassName.labelTitle,
                        "x": "14",
                        "y": "24"
                    ]
                ) {
                    HTML.text(title)
                }

                HTML.el(
                    "text",
                    [
                        "class": ClassName.labelBody,
                        "x": "14",
                        "y": "44"
                    ]
                ) {
                    HTML.text(body)
                }
            }
        ]
    }

    public static func css() -> CSSStyleSheet {
        stylesheet()
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("width", "min(820px, 100%)"),
                    CSS.decl("margin", "24px 0 30px")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("padding", "12px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)"),
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".\(ClassName.svg)",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "auto"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("color", "var(--text-color, #0f172a)"),
                    CSS.decl("overflow", "visible")
                ),

                CSS.rule(
                    ".\(ClassName.field)",
                    CSS.decl("fill", "url(#habituation-field-glow)"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--border-color) 82%, var(--text-color) 18%)"),
                    CSS.decl("stroke-width", "1")
                ),

                CSS.rule(
                    ".\(ClassName.fieldDot)",
                    CSS.decl("fill", "color-mix(in srgb, var(--text-color) 22%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.connection)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round")
                ),

                CSS.rule(
                    ".\(ClassName.connectionWeak)",
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 22%, var(--border-color))"),
                    CSS.decl("stroke-width", "1.6"),
                    CSS.decl("opacity", ".54")
                ),

                CSS.rule(
                    ".\(ClassName.connectionDetached)",
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 26%, var(--border-color))"),
                    CSS.decl("stroke-width", "1.6"),
                    CSS.decl("stroke-dasharray", "3 8"),
                    CSS.decl("opacity", ".46")
                ),

                CSS.rule(
                    ".\(ClassName.groove)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--link-color) 18%, var(--text-color) 82%)"),
                    CSS.decl("stroke-width", "18"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round"),
                    CSS.decl("opacity", ".12"),
                    CSS.decl("filter", "url(#habituation-soft-shadow)")
                ),

                CSS.rule(
                    ".\(ClassName.activePath)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--link-color) 48%, var(--text-color) 52%)"),
                    CSS.decl("stroke-width", "6.5"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round"),
                    CSS.decl("opacity", ".86"),
                    CSS.decl("animation", "wc-habituation-path-deepen 2400ms ease-in-out infinite")
                ),

                CSS.rule(
                    ".\(ClassName.activePulse)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--link-color) 72%, var(--background-color, #fff) 28%)"),
                    CSS.decl("stroke-width", "3"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round"),
                    CSS.decl("stroke-dasharray", "28 440"),
                    CSS.decl("stroke-dashoffset", "0"),
                    CSS.decl("opacity", ".95"),
                    CSS.decl("animation", "wc-habituation-firing 1650ms linear infinite")
                ),

                CSS.rule(
                    ".\(ClassName.node)",
                    CSS.decl("vector-effect", "non-scaling-stroke")
                ),

                CSS.rule(
                    ".\(ClassName.nodeActive) circle",
                    CSS.decl("fill", "color-mix(in srgb, var(--link-color) 20%, var(--background-color, #fff))"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--link-color) 58%, var(--text-color) 42%)"),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("filter", "drop-shadow(0 5px 10px rgba(15, 23, 42, .16))"),
                    CSS.decl("animation", "wc-habituation-node-fire 1650ms ease-in-out infinite")
                ),

                CSS.rule(
                    ".\(ClassName.nodeActive) text",
                    CSS.decl("font-size", "9px"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("fill", "var(--text-color, #0f172a)"),
                    CSS.decl("pointer-events", "none")
                ),

                CSS.rule(
                    ".\(ClassName.nodeWeak)",
                    CSS.decl("fill", "var(--background-color, #fff)"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 30%, var(--border-color))"),
                    CSS.decl("stroke-width", "1.5"),
                    CSS.decl("opacity", ".68")
                ),

                CSS.rule(
                    ".\(ClassName.nodeDetached)",
                    CSS.decl("fill", "color-mix(in srgb, var(--background-color, #fff) 86%, var(--text-color) 14%)"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 24%, var(--border-color))"),
                    CSS.decl("stroke-width", "1.25"),
                    CSS.decl("stroke-dasharray", "2 3"),
                    CSS.decl("opacity", ".58")
                ),

                CSS.rule(
                    ".\(ClassName.calloutLine)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 30%, var(--border-color))"),
                    CSS.decl("stroke-width", "1.4"),
                    CSS.decl("stroke-dasharray", "4 5"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("opacity", ".72")
                ),

                CSS.rule(
                    ".\(ClassName.label) rect",
                    CSS.decl("fill", "color-mix(in srgb, var(--background-color, #fff) 88%, var(--text-color) 12%)"),
                    CSS.decl("stroke", "var(--border-color, rgba(0, 0, 0, .12))"),
                    CSS.decl("stroke-width", "1"),
                    CSS.decl("filter", "drop-shadow(0 8px 16px rgba(15, 23, 42, .08))")
                ),

                CSS.rule(
                    ".\(ClassName.labelTitle)",
                    CSS.decl("font-size", "13px"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("fill", "var(--text-color, #0f172a)")
                ),

                CSS.rule(
                    ".\(ClassName.labelBody)",
                    CSS.decl("font-size", "11px"),
                    CSS.decl("font-weight", "470"),
                    CSS.decl("fill", "color-mix(in srgb, var(--text-color, #0f172a) 70%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.caption)",
                    CSS.decl("margin", "10px 0 0"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.48"),
                    CSS.decl("color", "var(--muted-text-color)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(ClassName.stage)",
                        CSS.decl("padding", "8px"),
                        CSS.decl("border-radius", "14px"),
                        CSS.decl("overflow-x", "auto"),
                        CSS.decl("overflow-y", "hidden"),
                        CSS.decl("scrollbar-width", "thin"),
                        CSS.decl("-webkit-overflow-scrolling", "touch"),
                        CSS.decl("overscroll-behavior-x", "contain")
                    ),

                    CSS.rule(
                        ".\(ClassName.svg)",
                        CSS.decl("width", "760px"),
                        CSS.decl("min-width", "760px"),
                        CSS.decl("max-width", "none"),
                        CSS.decl("height", "auto")
                    )
                ),

                CSS.media(
                    "(prefers-reduced-motion: reduce)",
                    CSS.rule(
                        ".\(ClassName.activePath), .\(ClassName.activePulse), .\(ClassName.nodeActive) circle",
                        CSS.decl("animation", "none")
                    )
                )
            ],
            keyframes: [
                CSS.keyframes("wc-habituation-firing") {
                    CSS.to {
                        CSS.decl("stroke-dashoffset", "-468")
                    }
                },

                CSS.keyframes("wc-habituation-path-deepen") {
                    CSS.step("0%, 100%") {
                        CSS.decl("stroke-width", "6.5")
                    }

                    CSS.step("45%") {
                        CSS.decl("stroke-width", "8.4")
                    }
                },

                CSS.keyframes("wc-habituation-node-fire") {
                    CSS.step("0%, 100%") {
                        CSS.decl("transform", "scale(1)")
                    }

                    CSS.step("42%") {
                        CSS.decl("transform", "scale(1.08)")
                    }
                }
            ]
        )
    }
}
