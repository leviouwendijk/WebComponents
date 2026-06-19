import Constructors
import CSS
import HTML

public struct PressureReliefRewardDiagram: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-pressure-relief-reward"
        static let stage = "wc-pressure-relief-reward__stage"
        static let svg = "wc-pressure-relief-reward__svg"
        static let field = "wc-pressure-relief-reward__field"
        static let grid = "wc-pressure-relief-reward__grid"
        static let axis = "wc-pressure-relief-reward__axis"
        static let reliefWindow = "wc-pressure-relief-reward__relief-window"
        static let releaseMarker = "wc-pressure-relief-reward__release-marker"
        static let rewardMarker = "wc-pressure-relief-reward__reward-marker"
        static let curve = "wc-pressure-relief-reward__curve"
        static let stressCurve = "wc-pressure-relief-reward__curve--stress"
        static let reliefCurve = "wc-pressure-relief-reward__curve--relief"
        static let rewardCurve = "wc-pressure-relief-reward__curve--reward"
        static let nextCurve = "wc-pressure-relief-reward__curve--next"
        static let label = "wc-pressure-relief-reward__label"
        static let labelMuted = "wc-pressure-relief-reward__label--muted"
        static let callout = "wc-pressure-relief-reward__callout"
        static let calloutTitle = "wc-pressure-relief-reward__callout-title"
        static let calloutText = "wc-pressure-relief-reward__callout-text"
        static let legend = "wc-pressure-relief-reward__legend"
        static let legendItem = "wc-pressure-relief-reward__legend-item"
        static let legendLine = "wc-pressure-relief-reward__legend-line"
        static let legendStress = "wc-pressure-relief-reward__legend-line--stress"
        static let legendRelief = "wc-pressure-relief-reward__legend-line--relief"
        static let legendReward = "wc-pressure-relief-reward__legend-line--reward"
        static let note = "wc-pressure-relief-reward__note"
        static let caption = "wc-pressure-relief-reward__caption"
    }

    public let id: String
    public let caption: String?
    public let includeNote: Bool
    public let includeStyles: Bool

    public init(
        id: String = "pressure-relief-reward",
        caption: String? = "Een aversieve prikkel beëindigen geeft opluchting. Wanneer een appetitieve uitkomst kort daarna verschijnt, kan die opluchting overgaan in positiever en langduriger herstel.",
        includeNote: Bool = true,
        includeStyles: Bool = true
    ) {
        self.id = id
        self.caption = caption
        self.includeNote = includeNote
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
                            "aria-label": "Druk of stress stijgt en wordt opgeheven. Daarna ontstaat een opluchtingsvenster. Een appetitieve beloning binnen dat venster kan positieve herstelwaarde verlengen."
                        ]
                    ) {
                        Self.legend()
                        Self.svg()
                    }

                    if includeNote {
                        Self.note()
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

    public static func css() -> CSSStyleSheet {
        stylesheet()
    }

    public static func svg() -> any HTMLNode {
        HTML.el(
            "svg",
            [
                "class": ClassName.svg,
                "viewBox": "0 0 920 430",
                "preserveAspectRatio": "xMidYMid meet",
                "role": "presentation",
                "aria-hidden": "true",
                "focusable": "false"
            ]
        ) {
            HTML.el(
                "rect",
                [
                    "class": ClassName.field,
                    "x": "24",
                    "y": "24",
                    "width": "872",
                    "height": "326",
                    "rx": "26",
                    "ry": "26"
                ]
            ) {}

            for y in [98, 158, 218, 278] {
                HTML.el(
                    "line",
                    [
                        "class": ClassName.grid,
                        "x1": "72",
                        "y1": "\(y)",
                        "x2": "850",
                        "y2": "\(y)"
                    ]
                ) {}
            }

            HTML.el(
                "path",
                [
                    "class": ClassName.axis,
                    "d": "M 72 302 V 62 M 72 302 H 850"
                ]
            ) {}

            HTML.el(
                "rect",
                [
                    "class": ClassName.reliefWindow,
                    "x": "494",
                    "y": "62",
                    "width": "190",
                    "height": "240",
                    "rx": "20",
                    "ry": "20"
                ]
            ) {}

            HTML.el(
                "line",
                [
                    "class": ClassName.releaseMarker,
                    "x1": "502",
                    "y1": "64",
                    "x2": "502",
                    "y2": "318"
                ]
            ) {}

            HTML.el(
                "line",
                [
                    "class": ClassName.rewardMarker,
                    "x1": "582",
                    "y1": "64",
                    "x2": "582",
                    "y2": "318"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": "\(ClassName.curve) \(ClassName.stressCurve)",
                    "d": "M 94 294 C 128 228, 166 184, 218 184 H 424 C 456 184, 480 184, 498 184 C 506 228, 526 270, 548 294"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": "\(ClassName.curve) \(ClassName.reliefCurve)",
                    "d": "M 482 294 C 500 242, 530 205, 574 192 C 626 176, 692 196, 744 238 C 768 258, 786 280, 802 294"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": "\(ClassName.curve) \(ClassName.rewardCurve)",
                    "d": "M 570 294 C 586 238, 620 208, 672 204 H 814 C 828 238, 846 270, 864 294"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": "\(ClassName.curve) \(ClassName.nextCurve)",
                    "d": "M 714 294 C 734 262, 758 246, 790 246 C 820 246, 838 264, 850 288"
                ]
            ) {}

            graphText(
                x: 82,
                y: 54,
                text: "activatie / waarde",
                className: "\(ClassName.label) \(ClassName.labelMuted)"
            )

            graphText(
                x: 788,
                y: 328,
                text: "tijd",
                className: "\(ClassName.label) \(ClassName.labelMuted)"
            )

            graphText(
                x: 126,
                y: 174,
                text: "druk / stressor",
                className: ClassName.label
            )

            graphText(
                x: 514,
                y: 82,
                text: "opheffing",
                className: ClassName.label
            )

            graphText(
                x: 594,
                y: 82,
                text: "beloning",
                className: ClassName.label
            )

            graphText(
                x: 596,
                y: 326,
                text: "opluchtingsvenster",
                className: "\(ClassName.label) \(ClassName.labelMuted)"
            )

            callout(
                x: 628,
                y: 112,
                width: 224,
                title: "Beloning in opluchtingsvenster",
                lines: [
                    "appetitieve uitkomst",
                    "valt samen met herstel"
                ]
            )

            callout(
                x: 628,
                y: 238,
                width: 224,
                title: "Volgende stressrespons",
                lines: [
                    "lager of korter",
                    "bij voldoende controle"
                ]
            )
        }
    }

    private static func legend() -> any HTMLNode {
        HTML.div(
            [
                "class": ClassName.legend,
                "aria-hidden": "true"
            ]
        ) {
            HTML.span(["class": ClassName.legendItem]) {
                HTML.span([
                    "class": "\(ClassName.legendLine) \(ClassName.legendStress)"
                ]) {}
                HTML.text("druk / stressrespons")
            }

            HTML.span(["class": ClassName.legendItem]) {
                HTML.span([
                    "class": "\(ClassName.legendLine) \(ClassName.legendRelief)"
                ]) {}
                HTML.text("opluchting na opheffing")
            }

            HTML.span(["class": ClassName.legendItem]) {
                HTML.span([
                    "class": "\(ClassName.legendLine) \(ClassName.legendReward)"
                ]) {}
                HTML.text("appetitieve beloning")
            }
        }
    }

    private static func graphText(
        x: Int,
        y: Int,
        text: String,
        className: String
    ) -> any HTMLNode {
        HTML.el(
            "text",
            [
                "class": className,
                "x": "\(x)",
                "y": "\(y)"
            ]
        ) {
            HTML.text(text)
        }
    }

    private static func callout(
        x: Int,
        y: Int,
        width: Int,
        title: String,
        lines: [String]
    ) -> any HTMLNode {
        let height = 42 + (lines.count * 17)

        return HTML.el(
            "g",
            [
                "class": ClassName.callout,
                "transform": "translate(\(x) \(y))"
            ]
        ) {
            HTML.el(
                "rect",
                [
                    "x": "0",
                    "y": "0",
                    "width": "\(width)",
                    "height": "\(height)",
                    "rx": "15",
                    "ry": "15"
                ]
            ) {}

            HTML.el(
                "text",
                [
                    "class": ClassName.calloutTitle,
                    "x": "14",
                    "y": "24"
                ]
            ) {
                HTML.text(title)
            }

            HTML.el(
                "text",
                [
                    "class": ClassName.calloutText,
                    "x": "14",
                    "y": "46"
                ]
            ) {
                for (index, line) in lines.enumerated() {
                    HTML.el(
                        "tspan",
                        [
                            "x": "14",
                            "dy": index == 0 ? "0" : "17"
                        ]
                    ) {
                        HTML.text(line)
                    }
                }
            }
        }
    }

    private static func note() -> any HTMLNode {
        HTML.div(["class": ClassName.note]) {
            HTML.b {
                HTML.text("Toepassing:")
            }

            HTML.text(" niet “meer druk toevoegen”, maar lage en begrijpelijke druk zo doseren dat de hond controle ervaart: keuze → opheffing → opluchting → herstel → appetitieve uitkomst.")
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("width", "min(920px, 100%)"),
                    CSS.decl("margin", "24px 0 30px"),
                    CSS.decl("--wc-relief-stress", "color-mix(in srgb, var(--text-color) 78%, transparent)"),
                    CSS.decl("--wc-relief-blue", "var(--link-color, #2563eb)"),
                    CSS.decl("--wc-relief-green", "var(--success, #2E8B57)"),
                    CSS.decl("--wc-relief-muted", "var(--muted-text-color, rgba(32, 33, 36, .66))")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)"),
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".\(ClassName.legend)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "10px 18px"),
                    CSS.decl("padding", "0 2px"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("line-height", "1.25"),
                    CSS.decl("font-weight", "600"),
                    CSS.decl("color", "var(--wc-relief-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.legendItem)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "7px")
                ),

                CSS.rule(
                    ".\(ClassName.legendLine)",
                    CSS.decl("display", "inline-block"),
                    CSS.decl("width", "30px"),
                    CSS.decl("height", "4px"),
                    CSS.decl("border-radius", "999px")
                ),

                CSS.rule(
                    ".\(ClassName.legendStress)",
                    CSS.decl("background", "var(--wc-relief-stress)")
                ),

                CSS.rule(
                    ".\(ClassName.legendRelief)",
                    CSS.decl("background", "var(--wc-relief-blue)")
                ),

                CSS.rule(
                    ".\(ClassName.legendReward)",
                    CSS.decl("background", "var(--wc-relief-green)")
                ),

                CSS.rule(
                    ".\(ClassName.svg)",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "auto"),
                    CSS.decl("min-width", "760px")
                ),

                CSS.rule(
                    ".\(ClassName.field)",
                    CSS.decl("fill", "color-mix(in srgb, var(--surface-color, var(--background-color)) 92%, var(--text-color) 8%)"),
                    CSS.decl("stroke", "var(--border-color)"),
                    CSS.decl("stroke-width", "1")
                ),

                CSS.rule(
                    ".\(ClassName.grid)",
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 12%, transparent)"),
                    CSS.decl("stroke-width", "1")
                ),

                CSS.rule(
                    ".\(ClassName.axis)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 58%, transparent)"),
                    CSS.decl("stroke-width", "1.5"),
                    CSS.decl("stroke-linecap", "round")
                ),

                CSS.rule(
                    ".\(ClassName.reliefWindow)",
                    CSS.decl("fill", "color-mix(in srgb, var(--wc-relief-blue) 8%, transparent)"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--wc-relief-blue) 18%, transparent)"),
                    CSS.decl("stroke-width", "1")
                ),

                CSS.rule(
                    ".\(ClassName.releaseMarker)",
                    CSS.decl("stroke", "var(--wc-relief-blue)"),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-dasharray", "8 8")
                ),

                CSS.rule(
                    ".\(ClassName.rewardMarker)",
                    CSS.decl("stroke", "var(--wc-relief-green)"),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-dasharray", "8 8")
                ),

                CSS.rule(
                    ".\(ClassName.curve)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke-width", "4.5"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round")
                ),

                CSS.rule(
                    ".\(ClassName.stressCurve)",
                    CSS.decl("stroke", "var(--wc-relief-stress)")
                ),

                CSS.rule(
                    ".\(ClassName.reliefCurve)",
                    CSS.decl("stroke", "var(--wc-relief-blue)")
                ),

                CSS.rule(
                    ".\(ClassName.rewardCurve)",
                    CSS.decl("stroke", "var(--wc-relief-green)")
                ),

                CSS.rule(
                    ".\(ClassName.nextCurve)",
                    CSS.decl("stroke", "color-mix(in srgb, var(--wc-relief-stress) 58%, transparent)"),
                    CSS.decl("stroke-width", "3"),
                    CSS.decl("stroke-dasharray", "7 8")
                ),

                CSS.rule(
                    ".\(ClassName.label)",
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, monospace"),
                    CSS.decl("font-size", "12px"),
                    CSS.decl("font-weight", "520"),
                    CSS.decl("fill", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.labelMuted)",
                    CSS.decl("fill", "var(--wc-relief-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.callout) rect",
                    CSS.decl("fill", "var(--background-color)"),
                    CSS.decl("stroke", "var(--border-color)"),
                    CSS.decl("stroke-width", "1"),
                    CSS.decl("filter", "drop-shadow(0 10px 18px rgba(15, 23, 42, .07))")
                ),

                CSS.rule(
                    ".\(ClassName.calloutTitle)",
                    CSS.decl("font-size", "13px"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("fill", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.calloutText)",
                    CSS.decl("font-size", "11px"),
                    CSS.decl("font-weight", "470"),
                    CSS.decl("fill", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.note)",
                    CSS.decl("margin-top", "12px"),
                    CSS.decl("padding", "12px 14px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--wc-relief-green) 32%, var(--border-color))"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 92%, var(--wc-relief-green) 8%)"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.note) b",
                    CSS.decl("color", "var(--text-color)")
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
                    "(max-width: 760px)",
                    CSS.rule(
                        ".\(ClassName.stage)",
                        CSS.decl("overflow-x", "auto"),
                        CSS.decl("overflow-y", "hidden")
                    )
                )
            ]
        )
    }
}
