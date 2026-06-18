import Constructors
import CSS
import HTML

public struct HighPressurePeakDiagram: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-high-pressure-peak"
        static let stage = "wc-high-pressure-peak__stage"
        static let svg = "wc-high-pressure-peak__svg"
        static let field = "wc-high-pressure-peak__field"
        static let axis = "wc-high-pressure-peak__axis"
        static let threshold = "wc-high-pressure-peak__threshold"
        static let analgesia = "wc-high-pressure-peak__analgesia"
        static let curve = "wc-high-pressure-peak__curve"
        static let branch = "wc-high-pressure-peak__branch"
        static let label = "wc-high-pressure-peak__label"
        static let card = "wc-high-pressure-peak__card"
        static let cardTitle = "wc-high-pressure-peak__card-title"
        static let cardText = "wc-high-pressure-peak__card-text"
        static let caution = "wc-high-pressure-peak__caution"
        static let cautionTitle = "wc-high-pressure-peak__caution-title"
        static let cautionText = "wc-high-pressure-peak__caution-text"
        static let caption = "wc-high-pressure-peak__caption"
    }

    public let id: String
    public let caption: String?
    public let includeCaution: Bool
    public let includeStyles: Bool

    public init(
        id: String = "high-pressure-peak",
        caption: String? = "Hoge druk kan een reactie onderbreken, maar kan ook stress, vermijding, defensie of minder leerbare arousal verhogen.",
        includeCaution: Bool = true,
        includeStyles: Bool = true
    ) {
        self.id = id
        self.caption = caption
        self.includeCaution = includeCaution
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
                            "aria-label": "Hoge drukpiek die boven de arousal- en analgesiedrempel uitkomt, met mogelijke neveneffecten."
                        ]
                    ) {
                        Self.svg()
                    }

                    if includeCaution {
                        Self.cautionBanner()
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
                "viewBox": "0 0 820 430",
                "preserveAspectRatio": "xMidYMid meet",
                "role": "img",
                "aria-label": "Een hoge drukpiek overschrijdt een drempel; daarna vertakken mogelijke effecten zoals onderbreking, vermijding en sociale verstoring."
            ]
        ) {
            HTML.el(
                "rect",
                [
                    "class": ClassName.field,
                    "x": "24",
                    "y": "24",
                    "width": "772",
                    "height": "320",
                    "rx": "26",
                    "ry": "26"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": ClassName.axis,
                    "d": "M 64 300 V 58 M 64 300 H 750"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": ClassName.threshold,
                    "d": "M 64 210 H 750"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": ClassName.analgesia,
                    "d": "M 64 132 H 750"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": ClassName.curve,
                    "d": "M 92 294 C 138 292, 188 292, 238 292 C 282 292, 310 250, 338 176 C 362 112, 382 66, 408 66 C 434 66, 456 112, 482 184 C 512 266, 552 294, 722 294"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": ClassName.branch,
                    "d": "M 410 66 C 468 44, 536 48, 602 82 M 486 184 C 554 192, 620 222, 684 268"
                ]
            ) {}

            graphText(
                x: 74,
                y: 50,
                text: "druk",
                className: ClassName.label
            )

            graphText(
                x: 650,
                y: 324,
                text: "tijd",
                className: ClassName.label
            )

            graphText(
                x: 548,
                y: 124,
                text: "arousal / analgesie-zone",
                className: ClassName.label
            )

            graphText(
                x: 550,
                y: 202,
                text: "functionele drempel",
                className: ClassName.label
            )

            graphText(
                x: 356,
                y: 54,
                text: "hoge piek",
                className: ClassName.label
            )

            effectCard(
                x: 486,
                y: 56,
                title: "Onderbreking",
                text: "gedrag stopt mogelijk direct"
            )

            effectCard(
                x: 584,
                y: 238,
                title: "Bij-effecten",
                text: "vermijding, defensie, herstelverlies"
            )
        }
    }

    private static func effectCard(
        x: Int,
        y: Int,
        title: String,
        text: String
    ) -> any HTMLNode {
        HTML.el(
            "g",
            [
                "class": ClassName.card,
                "transform": "translate(\(x) \(y))"
            ]
        ) {
            HTML.el(
                "rect",
                [
                    "x": "0",
                    "y": "0",
                    "width": "172",
                    "height": "64",
                    "rx": "14",
                    "ry": "14"
                ]
            ) {}

            HTML.el(
                "text",
                [
                    "class": ClassName.cardTitle,
                    "x": "14",
                    "y": "25"
                ]
            ) {
                HTML.text(title)
            }

            HTML.el(
                "text",
                [
                    "class": ClassName.cardText,
                    "x": "14",
                    "y": "45"
                ]
            ) {
                HTML.text(text)
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

    private static func cautionBanner() -> any HTMLNode {
        HTML.div(["class": ClassName.caution]) {
            HTML.div(["class": ClassName.cautionTitle]) {
                HTML.text("Voorzichtig met hoge of niet-contingente druk")
            }

            HTML.div(["class": ClassName.cautionText]) {
                HTML.text("Gebruik straf of druk niet preventief, willekeurig of los van duidelijke criteria. Kies waar mogelijk eerst voor management, motivatie, afstand, shaping of beloningsgerichte alternatieven. Bij risico, agressie of proofing: werk met een professional.")
            }
        }
    }

    public static func css() -> CSSStyleSheet {
        stylesheet()
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("width", "min(860px, 100%)"),
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
                    CSS.decl("min-width", "760px")
                ),

                CSS.rule(
                    ".\(ClassName.field)",
                    CSS.decl("fill", "color-mix(in srgb, var(--surface-color, var(--background-color)) 92%, var(--text-color) 8%)"),
                    CSS.decl("stroke", "var(--border-color)"),
                    CSS.decl("stroke-width", "1")
                ),

                CSS.rule(
                    ".\(ClassName.axis)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 58%, transparent)"),
                    CSS.decl("stroke-width", "1.4"),
                    CSS.decl("stroke-linecap", "round")
                ),

                CSS.rule(
                    ".\(ClassName.threshold)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 30%, transparent)"),
                    CSS.decl("stroke-width", "1.5"),
                    CSS.decl("stroke-dasharray", "10 10")
                ),

                CSS.rule(
                    ".\(ClassName.analgesia)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "var(--link-color)"),
                    CSS.decl("stroke-width", "1.8"),
                    CSS.decl("stroke-dasharray", "8 9"),
                    CSS.decl("opacity", ".8")
                ),

                CSS.rule(
                    ".\(ClassName.curve)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "var(--text-color)"),
                    CSS.decl("stroke-width", "4.5"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round")
                ),

                CSS.rule(
                    ".\(ClassName.branch)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 56%, transparent)"),
                    CSS.decl("stroke-width", "2.2"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-dasharray", "8 8")
                ),

                CSS.rule(
                    ".\(ClassName.label)",
                    CSS.decl("font-family", "var(--mono-font, ui-monospace, SFMono-Regular, Menlo, monospace)"),
                    CSS.decl("font-size", "12px"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("fill", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.card) rect",
                    CSS.decl("fill", "var(--background-color)"),
                    CSS.decl("stroke", "var(--border-color)"),
                    CSS.decl("stroke-width", "1"),
                    CSS.decl("filter", "drop-shadow(0 10px 18px rgba(15, 23, 42, .07))")
                ),

                CSS.rule(
                    ".\(ClassName.cardTitle)",
                    CSS.decl("font-size", "13px"),
                    CSS.decl("font-weight", "820"),
                    CSS.decl("fill", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.cardText)",
                    CSS.decl("font-size", "11px"),
                    CSS.decl("font-weight", "560"),
                    CSS.decl("fill", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.caution)",
                    CSS.decl("margin-top", "12px"),
                    CSS.decl("padding", "12px 14px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--link-color) 34%, var(--border-color))"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 92%, var(--link-color) 8%)")
                ),

                CSS.rule(
                    ".\(ClassName.cautionTitle)",
                    CSS.decl("font-weight", "820"),
                    CSS.decl("font-size", ".94rem"),
                    CSS.decl("line-height", "1.25"),
                    CSS.decl("margin-bottom", "4px")
                ),

                CSS.rule(
                    ".\(ClassName.cautionText)",
                    CSS.decl("font-size", ".88rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--muted-text-color)")
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

private func commonRules(
    root: String,
    switchRoot: String,
    controls: String,
    button: String,
    stage: String,
    live: String,
    caption: String
) -> [CSSRule] {
    [
        CSS.rule(
            ".\(root)",
            CSS.decl("width", "min(920px, 100%)"),
            CSS.decl("margin", "24px 0 30px")
        ),

        CSS.rule(
            ".\(switchRoot)",
            CSS.decl("position", "relative"),
            CSS.decl("display", "grid"),
            CSS.decl("gap", "10px")
        ),

        CSS.rule(
            ".\(controls)",
            CSS.decl("display", "inline-flex"),
            CSS.decl("width", "fit-content"),
            CSS.decl("justify-self", "end"),
            CSS.decl("margin-left", "auto"),
            CSS.decl("align-items", "center"),
            CSS.decl("gap", "4px"),
            CSS.decl("padding", "3px"),
            CSS.decl("border", "1px solid var(--border-color, rgba(0,0,0,0.12))"),
            CSS.decl("border-radius", "999px"),
            CSS.decl("background", "color-mix(in srgb, var(--background-color, #fff) 94%, var(--text-color, #0f172a) 6%)"),
            CSS.decl("box-shadow", "inset 0 1px 0 rgba(255,255,255,.55)"),
            CSS.decl("flex", "0 0 auto")
        ),

        CSS.rule(
            ".\(button)",
            CSS.decl("appearance", "none"),
            CSS.decl("border", "0"),
            CSS.decl("border-radius", "999px"),
            CSS.decl("height", "30px"),
            CSS.decl("padding", "0 12px"),
            CSS.decl("background", "transparent"),
            CSS.decl("color", "color-mix(in srgb, var(--text-color, #0f172a) 62%, transparent)"),
            CSS.decl("font", "inherit"),
            CSS.decl("font-size", ".82rem"),
            CSS.decl("font-weight", "740"),
            CSS.decl("line-height", "30px"),
            CSS.decl("cursor", "pointer"),
            CSS.decl("transition", "background 140ms ease, color 140ms ease, box-shadow 140ms ease")
        ),

        CSS.rule(
            ".\(button):hover",
            CSS.decl("color", "var(--text-color, #0f172a)")
        ),

        CSS.rule(
            ".\(button)[aria-pressed=\"true\"]",
            CSS.decl("background", "var(--text-color, #0f172a)"),
            CSS.decl("color", "var(--background-color, #fff)"),
            CSS.decl("box-shadow", "0 1px 2px rgba(15, 23, 42, .16)")
        ),

        CSS.rule(
            ".\(button):focus-visible",
            CSS.decl("outline", "2px solid color-mix(in srgb, var(--link-color) 70%, transparent)"),
            CSS.decl("outline-offset", "2px")
        ),

        CSS.rule(
            ".\(stage)",
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
            ".\(live)",
            CSS.decl("position", "absolute"),
            CSS.decl("width", "1px"),
            CSS.decl("height", "1px"),
            CSS.decl("padding", "0"),
            CSS.decl("margin", "-1px"),
            CSS.decl("overflow", "hidden"),
            CSS.decl("clip", "rect(0, 0, 0, 0)"),
            CSS.decl("white-space", "nowrap"),
            CSS.decl("border", "0")
        ),

        CSS.rule(
            ".\(caption)",
            CSS.decl("margin", "10px 0 0"),
            CSS.decl("font-size", ".9rem"),
            CSS.decl("line-height", "1.48"),
            CSS.decl("color", "var(--muted-text-color)")
        )
    ]
}
