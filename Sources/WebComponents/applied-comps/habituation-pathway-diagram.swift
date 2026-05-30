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
        static let connectionMedium = "wc-habituation-pathway-diagram__connection--medium"
        static let connectionWeak = "wc-habituation-pathway-diagram__connection--weak"
        static let connectionDetached = "wc-habituation-pathway-diagram__connection--detached"

        static let groove = "wc-habituation-pathway-diagram__groove"
        static let activePath = "wc-habituation-pathway-diagram__active-path"
        static let activePulse = "wc-habituation-pathway-diagram__active-pulse"

        static let node = "wc-habituation-pathway-diagram__node"
        static let nodeHub = "wc-habituation-pathway-diagram__node--hub"
        static let nodeActive = "wc-habituation-pathway-diagram__node--active"
        static let nodeMedium = "wc-habituation-pathway-diagram__node--medium"
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
        caption: String? = "Bij herhaling zonder wezenlijke verandering wordt één route sterker en makkelijker beschikbaar, terwijl alternatieve routes zwakker blijven of los staan.",
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
                            "aria-label": "Vergewoontelijking: vanuit één beginpunt vertakken meerdere routes. Eén herhaald gebruikte route wordt dikker en sterker; andere routes blijven zwakker of nog losstaand."
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
            stylesheets: includeStyles ? [Self.stylesheet()] : []
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
                "viewBox": "0 0 760 320",
                "preserveAspectRatio": "xMidYMid meet",
                "role": "img",
                "aria-label": "Een centraal beginpunt vertakt in meerdere mogelijke routes. Eén route is dik en ingesleten; andere zijn dunner of gestippeld."
            ]
        ) {
            HTML.el("defs") {
                HTML.el(
                    "radialGradient",
                    [
                        "id": "habituation-field-glow",
                        "cx": "50%",
                        "cy": "46%",
                        "r": "76%"
                    ]
                ) {
                    HTML.el(
                        "stop",
                        [
                            "offset": "0%",
                            "stop-color": "currentColor",
                            "stop-opacity": ".08"
                        ]
                    ) {}

                    HTML.el(
                        "stop",
                        [
                            "offset": "62%",
                            "stop-color": "currentColor",
                            "stop-opacity": ".028"
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
                            "dy": "10",
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
                    "height": "284",
                    "rx": "26",
                    "ry": "26"
                ]
            ) {}

            field_dot(x: 86, y: 78, r: 2)
            field_dot(x: 138, y: 120, r: 2)
            field_dot(x: 232, y: 76, r: 3)
            field_dot(x: 292, y: 244, r: 2)
            field_dot(x: 412, y: 70, r: 3)
            field_dot(x: 474, y: 258, r: 2)
            field_dot(x: 602, y: 88, r: 2)
            field_dot(x: 682, y: 198, r: 3)

            path(
                className: "\(ClassName.connection) \(ClassName.connectionMedium)",
                d: "M 182 172 C 214 142, 262 114, 320 104 C 364 96, 394 98, 430 114"
            )

            path(
                className: "\(ClassName.connection) \(ClassName.connectionWeak)",
                d: "M 182 172 C 228 198, 276 238, 336 252 C 380 262, 420 254, 464 228"
            )

            path(
                className: "\(ClassName.connection) \(ClassName.connectionWeak)",
                d: "M 182 172 C 232 170, 290 176, 338 194"
            )

            path(
                className: "\(ClassName.connection) \(ClassName.connectionDetached)",
                d: "M 516 228 C 560 206, 620 212, 682 244"
            )

            path(
                className: ClassName.groove,
                d: "M 182 172 C 242 160, 294 170, 364 198 C 438 226, 506 196, 586 138"
            )

            path(
                className: ClassName.activePath,
                d: "M 182 172 C 242 160, 294 170, 364 198 C 438 226, 506 196, 586 138"
            )

            path(
                className: ClassName.activePulse,
                d: "M 182 172 C 242 160, 294 170, 364 198 C 438 226, 506 196, 586 138"
            )

            hub_node(x: 182, y: 172)
            active_node(x: 364, y: 198)
            active_node(x: 586, y: 138)

            medium_node(x: 320, y: 104)
            medium_node(x: 430, y: 114)

            weak_node(x: 336, y: 252)
            weak_node(x: 464, y: 228)

            detached_node(x: 516, y: 228)
            detached_node(x: 682, y: 244)

            callout(
                x: 82,
                y: 42,
                width: 180,
                title: "Beginpunt",
                body: "meerdere routes vertrekken",
                lineD: "M 176 104 C 170 128, 172 148, 182 172"
            )

            callout(
                x: 286,
                y: 228,
                width: 214,
                title: "Ingesleten route",
                body: "dikker en sneller beschikbaar",
                lineD: "M 394 228 C 392 218, 382 208, 364 198"
            )

            callout(
                x: 468,
                y: 38,
                width: 190,
                title: "Zwakkere routes",
                body: "minder dominant",
                lineD: "M 520 100 C 496 106, 468 112, 430 114"
            )

            callout(
                x: 520,
                y: 248,
                width: 174,
                title: "Losse routes",
                body: "nog niet stevig verbonden",
                lineD: "M 564 248 C 554 240, 542 234, 516 228"
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

    private static func hub_node(
        x: Int,
        y: Int
    ) -> any HTMLNode {
        HTML.el(
            "g",
            [
                "class": "\(ClassName.node) \(ClassName.nodeHub)"
            ]
        ) {
            HTML.el(
                "circle",
                [
                    "cx": "\(x)",
                    "cy": "\(y)",
                    "r": "14"
                ]
            ) {}

            HTML.el(
                "circle",
                [
                    "cx": "\(x)",
                    "cy": "\(y)",
                    "r": "7"
                ]
            ) {}
        }
    }

    private static func active_node(
        x: Int,
        y: Int
    ) -> any HTMLNode {
        HTML.el(
            "circle",
            [
                "class": "\(ClassName.node) \(ClassName.nodeActive)",
                "cx": "\(x)",
                "cy": "\(y)",
                "r": "12"
            ]
        ) {}
    }

    private static func medium_node(
        x: Int,
        y: Int
    ) -> any HTMLNode {
        HTML.el(
            "circle",
            [
                "class": "\(ClassName.node) \(ClassName.nodeMedium)",
                "cx": "\(x)",
                "cy": "\(y)",
                "r": "9"
            ]
        ) {}
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
                    ".\(ClassName.connectionMedium)",
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 26%, var(--border-color))"),
                    CSS.decl("stroke-width", "2.6"),
                    CSS.decl("opacity", ".58")
                ),

                CSS.rule(
                    ".\(ClassName.connectionWeak)",
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 22%, var(--border-color))"),
                    CSS.decl("stroke-width", "1.7"),
                    CSS.decl("opacity", ".48")
                ),

                CSS.rule(
                    ".\(ClassName.connectionDetached)",
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 24%, var(--border-color))"),
                    CSS.decl("stroke-width", "1.6"),
                    CSS.decl("stroke-dasharray", "3 8"),
                    CSS.decl("opacity", ".42")
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
                    CSS.decl("opacity", ".88"),
                    CSS.decl("animation", "wc-habituation-path-deepen 2400ms ease-in-out infinite")
                ),

                CSS.rule(
                    ".\(ClassName.activePulse)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--link-color) 76%, var(--background-color, #fff) 24%)"),
                    CSS.decl("stroke-width", "3"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round"),
                    CSS.decl("stroke-dasharray", "24 320"),
                    CSS.decl("stroke-dashoffset", "0"),
                    CSS.decl("opacity", ".92"),
                    CSS.decl("animation", "wc-habituation-firing 1500ms linear infinite")
                ),

                CSS.rule(
                    ".\(ClassName.node)",
                    CSS.decl("vector-effect", "non-scaling-stroke")
                ),

                CSS.rule(
                    ".\(ClassName.nodeHub) circle:first-child",
                    CSS.decl("fill", "color-mix(in srgb, var(--link-color) 12%, var(--background-color, #fff))"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--link-color) 52%, var(--text-color) 48%)"),
                    CSS.decl("stroke-width", "2.2"),
                    CSS.decl("filter", "drop-shadow(0 5px 10px rgba(15, 23, 42, .14))")
                ),

                CSS.rule(
                    ".\(ClassName.nodeHub) circle:last-child",
                    CSS.decl("fill", "color-mix(in srgb, var(--link-color) 66%, var(--background-color, #fff) 34%)"),
                    CSS.decl("opacity", ".95")
                ),

                CSS.rule(
                    ".\(ClassName.nodeActive)",
                    CSS.decl("fill", "color-mix(in srgb, var(--link-color) 18%, var(--background-color, #fff))"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--link-color) 58%, var(--text-color) 42%)"),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("filter", "drop-shadow(0 5px 10px rgba(15, 23, 42, .14))")
                ),

                CSS.rule(
                    ".\(ClassName.nodeMedium)",
                    CSS.decl("fill", "var(--background-color, #fff)"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 32%, var(--border-color))"),
                    CSS.decl("stroke-width", "1.7"),
                    CSS.decl("opacity", ".72")
                ),

                CSS.rule(
                    ".\(ClassName.nodeWeak)",
                    CSS.decl("fill", "var(--background-color, #fff)"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 28%, var(--border-color))"),
                    CSS.decl("stroke-width", "1.5"),
                    CSS.decl("opacity", ".62")
                ),

                CSS.rule(
                    ".\(ClassName.nodeDetached)",
                    CSS.decl("fill", "color-mix(in srgb, var(--background-color, #fff) 86%, var(--text-color) 14%)"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 24%, var(--border-color))"),
                    CSS.decl("stroke-width", "1.25"),
                    CSS.decl("stroke-dasharray", "2 3"),
                    CSS.decl("opacity", ".54")
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
                        ".\(ClassName.activePath), .\(ClassName.activePulse)",
                        CSS.decl("animation", "none")
                    )
                )
            ],
            keyframes: [
                CSS.keyframes("wc-habituation-firing") {
                    CSS.to {
                        CSS.decl("stroke-dashoffset", "-344")
                    }
                },

                CSS.keyframes("wc-habituation-path-deepen") {
                    CSS.step("0%, 100%") {
                        CSS.decl("stroke-width", "6.5")
                    }

                    CSS.step("45%") {
                        CSS.decl("stroke-width", "8.1")
                    }
                }
            ]
        )
    }
}
