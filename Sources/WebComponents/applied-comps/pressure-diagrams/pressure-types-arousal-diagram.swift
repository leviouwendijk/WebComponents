import Constructors
import CSS
import HTML

public struct PressureArousalCurveDiagram: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-pressure-arousal-curve"
        static let switchRoot = "wc-pressure-arousal-curve__switch-root"
        static let controls = "wc-pressure-arousal-curve__controls"
        static let button = "wc-pressure-arousal-curve__button"
        static let stage = "wc-pressure-arousal-curve__stage"
        static let legend = "wc-pressure-arousal-curve__legend"
        static let legendItem = "wc-pressure-arousal-curve__legend-item"
        static let legendLine = "wc-pressure-arousal-curve__legend-line"
        static let legendLinePressure = "wc-pressure-arousal-curve__legend-line--pressure"
        static let legendLineArousal = "wc-pressure-arousal-curve__legend-line--arousal"
        static let chart = "wc-pressure-arousal-curve__chart"
        static let svg = "wc-pressure-arousal-curve__svg"
        static let field = "wc-pressure-arousal-curve__field"
        static let band = "wc-pressure-arousal-curve__band"
        static let grid = "wc-pressure-arousal-curve__grid"
        static let axis = "wc-pressure-arousal-curve__axis"
        static let divider = "wc-pressure-arousal-curve__divider"
        static let pressureCurve = "wc-pressure-arousal-curve__pressure-curve"
        static let arousalCurve = "wc-pressure-arousal-curve__arousal-curve"
        static let label = "wc-pressure-arousal-curve__label"
        static let labelMuted = "wc-pressure-arousal-curve__label--muted"
        static let codeLabel = "wc-pressure-arousal-curve__code-label"
        static let details = "wc-pressure-arousal-curve__details"
        static let detail = "wc-pressure-arousal-curve__detail"
        static let detailCode = "wc-pressure-arousal-curve__detail-code"
        static let detailTitle = "wc-pressure-arousal-curve__detail-title"
        static let detailText = "wc-pressure-arousal-curve__detail-text"
        static let live = "wc-pressure-arousal-curve__live"
        static let caption = "wc-pressure-arousal-curve__caption"
    }

    public let id: String
    public let caption: String?
    public let initial: PressureArousalMode
    public let operantConditioningHref: String
    public let operantConditioningPreview: HoverPreview?
    public let includeStyles: Bool

    public init(
        id: String = "pressure-arousal-curve",
        caption: String? = "Druk en arousal lopen niet altijd netjes gelijk. Bij hogere arousal kan gedrag sneller, grover en minder gevoelig voor subtiele feedback worden.",
        initial: PressureArousalMode = .negativeReinforcement,
        operantConditioningHref: String = "/hondengedrag/operante-conditionering/",
        operantConditioningPreview: HoverPreview? = nil,
        includeStyles: Bool = true
    ) {
        self.id = id
        self.caption = caption
        self.initial = initial
        self.operantConditioningHref = operantConditioningHref
        self.operantConditioningPreview = operantConditioningPreview
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
                            "class": ClassName.switchRoot,
                            "data-pressure-switch": "true",
                            "data-state": initial.rawValue
                        ]
                    ) {
                        HTML.div(
                            [
                                "class": ClassName.controls,
                                "role": "group",
                                "aria-label": "Kies welk druktype wordt uitgelicht."
                            ]
                        ) {
                            for mode in PressureArousalMode.allCases {
                                Self.switchButton(
                                    mode,
                                    active: mode == initial
                                )
                            }
                        }

                        HTML.div(
                            [
                                "class": ClassName.stage,
                                "role": "img",
                                "aria-label": "Drukcurve met drie drukzones. De arousalcurve is dezelfde curve met een hogere baseline."
                            ]
                        ) {
                            Self.legend()
                            Self.svg()
                        }

                        HTML.div([ "class": ClassName.details ]) {
                            for mode in PressureArousalMode.allCases {
                                Self.detail(
                                    mode,
                                    href: operantConditioningHref,
                                    preview: operantConditioningPreview
                                )
                            }
                        }

                        HTML.span(
                            [
                                "class": ClassName.live,
                                "data-pressure-switch-live": "true",
                                "aria-live": "polite"
                            ]
                        ) {
                            HTML.text(initial.statusText)
                        }
                    }

                    HTML.el("script") {
                        HTML.raw(Self.switchScript)
                    }

                    if let caption, !caption.isEmpty {
                        HTML.figcaption([ "class": ClassName.caption ]) {
                            HTML.text(caption)
                        }
                    }
                }
            ],
            stylesheets: includeStyles
                ? [
                    HoverPreviewLink.stylesheet(),
                    Self.stylesheet()
                ]
                : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    private static func switchButton(
        _ mode: PressureArousalMode,
        active: Bool
    ) -> any HTMLNode {
        HTML.button(
            [
                "class": ClassName.button,
                "type": "button",
                "data-pressure-option": "true",
                "data-state": mode.rawValue,
                "data-status": mode.statusText,
                "aria-pressed": active ? "true" : "false"
            ]
        ) {
            HTML.text(mode.shortLabel)
        }
    }

    private static func legend() -> any HTMLNode {
        HTML.div(
            [
                "class": ClassName.legend,
                "aria-hidden": "true"
            ]
        ) {
            HTML.span([ "class": ClassName.legendItem ]) {
                HTML.span([
                    "class": "\(ClassName.legendLine) \(ClassName.legendLinePressure)"
                ]) {}
                HTML.text("drukcurve")
            }

            HTML.span([ "class": ClassName.legendItem ]) {
                HTML.span([
                    "class": "\(ClassName.legendLine) \(ClassName.legendLineArousal)"
                ]) {}
                HTML.text("arousalcurve · zelfde curve, hogere baseline")
            }
        }
    }

    private static let pressureCurvePath = """
    M 72 318
    C 110 250 150 242 210 242
    C 282 242 312 236 366 201
    C 425 163 468 160 528 161
    C 602 163 650 155 720 123
    C 784 94 828 86 928 84
    """

    private static func svg() -> any HTMLNode {
        HTML.div([ "class": ClassName.chart ]) {
            HTML.el(
                "svg",
                [
                    "class": ClassName.svg,
                    "viewBox": "0 0 1000 410",
                    "role": "presentation",
                    "aria-hidden": "true",
                    "focusable": "false"
                ]
            ) {
                HTML.el(
                    "rect",
                    [
                        "class": ClassName.field,
                        "x": "44",
                        "y": "38",
                        "width": "912",
                        "height": "318",
                        "rx": "22"
                    ]
                ) {}

                Self.band(
                    mode: .negativePunishment,
                    x: 64,
                    y: 62,
                    width: 286,
                    height: 258
                )

                Self.band(
                    mode: .negativeReinforcement,
                    x: 360,
                    y: 62,
                    width: 286,
                    height: 258
                )

                Self.band(
                    mode: .positivePunishment,
                    x: 656,
                    y: 62,
                    width: 286,
                    height: 258
                )

                for y in [92, 154, 216, 278] {
                    HTML.el(
                        "line",
                        [
                            "class": ClassName.grid,
                            "x1": "72",
                            "y1": "\(y)",
                            "x2": "928",
                            "y2": "\(y)"
                        ]
                    ) {}
                }

                for x in [360, 656] {
                    HTML.el(
                        "line",
                        [
                            "class": ClassName.divider,
                            "x1": "\(x)",
                            "y1": "54",
                            "x2": "\(x)",
                            "y2": "338"
                        ]
                    ) {}
                }

                HTML.el(
                    "line",
                    [
                        "class": ClassName.axis,
                        "x1": "72",
                        "y1": "54",
                        "x2": "72",
                        "y2": "338"
                    ]
                ) {}

                HTML.el(
                    "line",
                    [
                        "class": ClassName.axis,
                        "x1": "72",
                        "y1": "338",
                        "x2": "944",
                        "y2": "338"
                    ]
                ) {}

                HTML.el(
                    "path",
                    [
                        "class": ClassName.pressureCurve,
                        "d": Self.pressureCurvePath
                    ]
                ) {}

                HTML.el(
                    "g",
                    [
                        "transform": "translate(0 -56)"
                    ]
                ) {
                    HTML.el(
                        "path",
                        [
                            "class": ClassName.arousalCurve,
                            "d": Self.pressureCurvePath
                        ]
                    ) {}
                }

                Self.codeLabel(
                    .negativePunishment,
                    x: 207,
                    y: 365
                )

                Self.codeLabel(
                    .negativeReinforcement,
                    x: 503,
                    y: 365
                )

                Self.codeLabel(
                    .positivePunishment,
                    x: 799,
                    y: 365
                )
            }
        }
    }

    private static func band(
        mode: PressureArousalMode,
        x: Int,
        y: Int,
        width: Int,
        height: Int
    ) -> any HTMLNode {
        HTML.el(
            "rect",
            [
                "class": "\(ClassName.band) \(ClassName.band)--\(mode.rawValue)",
                "data-pressure-track": mode.rawValue,
                "x": "\(x)",
                "y": "\(y)",
                "width": "\(width)",
                "height": "\(height)",
                "rx": "18"
            ]
        ) {}
    }

    private static func codeLabel(
        _ mode: PressureArousalMode,
        x: Int,
        y: Int
    ) -> any HTMLNode {
        HTML.el(
            "text",
            [
                "class": "\(ClassName.codeLabel) \(ClassName.codeLabel)--\(mode.rawValue)",
                "data-pressure-track": mode.rawValue,
                "x": "\(x)",
                "y": "\(y)",
                "text-anchor": "middle"
            ]
        ) {
            HTML.text(mode.code)
        }
    }

    private static func detail(
        _ mode: PressureArousalMode,
        href: String,
        preview: HoverPreview?
    ) -> any HTMLNode {
        HTML.article(
            [
                "class": "\(ClassName.detail) \(ClassName.detail)--\(mode.rawValue)",
                "data-pressure-track": mode.rawValue
            ]
        ) {
            Self.operantCodeLink(
                mode,
                href: href,
                preview: preview
            )

            HTML.div {
                HTML.h3([ "class": ClassName.detailTitle ]) {
                    HTML.text(mode.title)
                }

                HTML.p([ "class": ClassName.detailText ]) {
                    HTML.text(Self.detailBody(for: mode))
                }
            }
        }
    }

    private static func operantCodeLink(
        _ mode: PressureArousalMode,
        href: String,
        preview: HoverPreview?
    ) -> any HTMLNode {
        let label: HTMLFragment = [
            HTML.span([ "class": ClassName.detailCode ]) {
                HTML.text(mode.code)
            }
        ]

        guard let preview else {
            return HTML.a(
                href,
                [
                    "class": ClassName.detailCode,
                    "aria-label": "\(mode.code), operante conditionering"
                ]
            ) {
                HTML.text(mode.code)
            }
        }

        return HoverPreviewLink(
            href: href,
            label: label,
            preview: preview,
            destinationScope: .sameSite
        ).nodes.body[0]
    }

    private static func detailBody(
        for mode: PressureArousalMode
    ) -> String {
        switch mode {
        case .negativePunishment:
            return "Toegang wordt begrensd of tijdelijk onbereikbaar. De druk zit vooral in barrière, frustratie of gemis: de hond kan iets niet bereiken, verliezen of voortzetten."

        case .negativeReinforcement:
            return "Milde druk blijft aanwezig tot de hond een richting, houding of keuze vindt die de druk lichter maakt of stopt. De release is het leerpunt: opluchting bekrachtigt."

        case .positivePunishment:
            return "Een korte hogere drukpiek wordt toegevoegd om gedrag te onderbreken of te verminderen. Dit vraagt duidelijke timing, proportionaliteit en een herkenbaar alternatief."
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: PressureDiagrams.commonRules(
                root: ClassName.root,
                switchRoot: ClassName.switchRoot,
                controls: ClassName.controls,
                button: ClassName.button,
                stage: ClassName.stage,
                live: ClassName.live,
                caption: ClassName.caption
            ) + [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("font-family", "inherit"),
                    CSS.decl("--wc-pressure-ink", "var(--text-color, #202124)"),
                    CSS.decl("--wc-pressure-muted", "var(--muted-text-color, rgba(32, 33, 36, .66))"),
                    CSS.decl("--wc-pressure-border", "var(--border-color, rgba(15, 23, 42, .12))"),
                    CSS.decl("--wc-pressure-surface", "var(--surface-color, #fff)"),
                    CSS.decl("--wc-pressure-soft", "var(--surface-soft-color, #f1f5f9)"),
                    CSS.decl("--wc-pressure-pressure", "color-mix(in srgb, var(--wc-pressure-ink) 88%, transparent)"),
                    CSS.decl("--wc-pressure-arousal", "var(--link-color, #2563eb)")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("padding", "18px"),
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
                    CSS.decl("font-weight", "650"),
                    CSS.decl("color", "var(--wc-pressure-muted)")
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
                    CSS.decl("width", "28px"),
                    CSS.decl("height", "4px"),
                    CSS.decl("border-radius", "999px")
                ),

                CSS.rule(
                    ".\(ClassName.legendLinePressure)",
                    CSS.decl("background", "var(--wc-pressure-pressure)")
                ),

                CSS.rule(
                    ".\(ClassName.legendLineArousal)",
                    CSS.decl("background", "var(--wc-pressure-arousal)")
                ),

                CSS.rule(
                    ".\(ClassName.chart)",
                    CSS.decl("width", "100%"),
                    CSS.decl("overflow-x", "auto"),
                    CSS.decl("overflow-y", "hidden"),
                    CSS.decl("-webkit-overflow-scrolling", "touch")
                ),

                CSS.rule(
                    ".\(ClassName.svg)",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "100%"),
                    CSS.decl("min-width", "780px"),
                    CSS.decl("height", "auto")
                ),

                CSS.rule(
                    ".\(ClassName.field)",
                    CSS.decl("fill", "color-mix(in srgb, var(--wc-pressure-soft) 72%, transparent)"),
                    CSS.decl("stroke", "var(--wc-pressure-border)"),
                    CSS.decl("stroke-width", "1")
                ),

                CSS.rule(
                    ".\(ClassName.band)",
                    CSS.decl("fill", "var(--wc-pressure-arousal)"),
                    CSS.decl("opacity", ".08"),
                    CSS.decl("transition", "opacity 160ms ease")
                ),

                CSS.rule(
                    ".\(ClassName.grid)",
                    CSS.decl("stroke", "color-mix(in srgb, var(--wc-pressure-ink) 17%, transparent)"),
                    CSS.decl("stroke-width", "1"),
                    CSS.decl("stroke-dasharray", "9 12")
                ),

                CSS.rule(
                    ".\(ClassName.axis), .\(ClassName.divider)",
                    CSS.decl("stroke", "color-mix(in srgb, var(--wc-pressure-ink) 24%, transparent)"),
                    CSS.decl("stroke-width", "1")
                ),

                CSS.rule(
                    ".\(ClassName.divider)",
                    CSS.decl("stroke-dasharray", "10 12")
                ),

                CSS.rule(
                    ".\(ClassName.pressureCurve), .\(ClassName.arousalCurve)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round"),
                    CSS.decl("stroke-width", "5")
                ),

                CSS.rule(
                    ".\(ClassName.pressureCurve)",
                    CSS.decl("stroke", "var(--wc-pressure-pressure)")
                ),

                CSS.rule(
                    ".\(ClassName.arousalCurve)",
                    CSS.decl("stroke", "var(--wc-pressure-arousal)")
                ),

                CSS.rule(
                    ".\(ClassName.codeLabel)",
                    CSS.decl("font-family", "inherit"),
                    CSS.decl("font-size", "20px"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("fill", "var(--wc-pressure-muted)"),
                    CSS.decl("opacity", ".52"),
                    CSS.decl("transition", "opacity 160ms ease, fill 160ms ease")
                ),

                CSS.rule(
                    ".\(ClassName.switchRoot) [data-pressure-track]",
                    CSS.decl("transition", "opacity 160ms ease, border-color 160ms ease, box-shadow 160ms ease, background-color 160ms ease, fill 160ms ease")
                ),

                CSS.rule(
                    activeTrackSelector(.negativePunishment),
                    CSS.decl("opacity", "1")
                ),

                CSS.rule(
                    activeTrackSelector(.negativeReinforcement),
                    CSS.decl("opacity", "1")
                ),

                CSS.rule(
                    activeTrackSelector(.positivePunishment),
                    CSS.decl("opacity", "1")
                ),

                CSS.rule(
                    activeBandSelector(.negativePunishment),
                    CSS.decl("opacity", ".16")
                ),

                CSS.rule(
                    activeBandSelector(.negativeReinforcement),
                    CSS.decl("opacity", ".14")
                ),

                CSS.rule(
                    activeBandSelector(.positivePunishment),
                    CSS.decl("opacity", ".13")
                ),

                CSS.rule(
                    activeCodeSelector(.negativePunishment),
                    CSS.decl("fill", "var(--wc-pressure-ink)")
                ),

                CSS.rule(
                    activeCodeSelector(.negativeReinforcement),
                    CSS.decl("fill", "var(--wc-pressure-ink)")
                ),

                CSS.rule(
                    activeCodeSelector(.positivePunishment),
                    CSS.decl("fill", "var(--wc-pressure-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.details)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(3, minmax(0, 1fr))"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("margin-top", "14px")
                ),

                CSS.rule(
                    ".\(ClassName.detail)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "auto minmax(0, 1fr)"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border", "1px solid var(--wc-pressure-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-pressure-surface) 94%, transparent)"),
                    CSS.decl("opacity", ".56")
                ),

                CSS.rule(
                    activeDetailSelector(.negativePunishment),
                    CSS.decl("opacity", "1"),
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color, #2563eb) 54%, var(--wc-pressure-border))"),
                    CSS.decl("box-shadow", "0 16px 34px color-mix(in srgb, var(--link-color, #2563eb) 12%, transparent)")
                ),

                CSS.rule(
                    activeDetailSelector(.negativeReinforcement),
                    CSS.decl("opacity", "1"),
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color, #2563eb) 42%, var(--wc-pressure-border))"),
                    CSS.decl("box-shadow", "0 16px 34px color-mix(in srgb, var(--link-color, #2563eb) 10%, transparent)")
                ),

                CSS.rule(
                    activeDetailSelector(.positivePunishment),
                    CSS.decl("opacity", "1"),
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color, #2563eb) 36%, var(--wc-pressure-border))"),
                    CSS.decl("box-shadow", "0 16px 34px color-mix(in srgb, var(--link-color, #2563eb) 8%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.detail) .wc-hover-preview",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("width", "fit-content")
                ),

                CSS.rule(
                    ".\(ClassName.detail) .wc-hover-preview__link",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("color", "inherit")
                ),

                CSS.rule(
                    ".\(ClassName.detail) .wc-hover-preview__link::after",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(ClassName.detailCode)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("min-width", "34px"),
                    CSS.decl("height", "28px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-family", "inherit"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("color", "var(--wc-hover-preview-accent, var(--link-color, #2563eb))"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-hover-preview-accent, var(--link-color, #2563eb)) 10%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--wc-hover-preview-accent, var(--link-color, #2563eb)) 22%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.detailTitle)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-family", "inherit"),
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("line-height", "1.2"),
                    CSS.decl("color", "var(--wc-pressure-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.detailText)",
                    CSS.decl("margin", "6px 0 0"),
                    CSS.decl("font-family", "inherit"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.48"),
                    CSS.decl("color", "var(--wc-pressure-muted)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 760px)",
                    CSS.rule(
                        ".\(ClassName.stage)",
                        CSS.decl("padding", "14px")
                    ),

                    CSS.rule(
                        ".\(ClassName.details)",
                        CSS.decl("grid-template-columns", "1fr")
                    )
                )
            ]
        )
    }

    private static func activeTrackSelector(
        _ mode: PressureArousalMode
    ) -> String {
        ".\(ClassName.switchRoot)[data-state=\"\(mode.rawValue)\"] [data-pressure-track=\"\(mode.rawValue)\"]"
    }

    private static func activeBandSelector(
        _ mode: PressureArousalMode
    ) -> String {
        ".\(ClassName.switchRoot)[data-state=\"\(mode.rawValue)\"] .\(ClassName.band)[data-pressure-track=\"\(mode.rawValue)\"]"
    }

    private static func activeCodeSelector(
        _ mode: PressureArousalMode
    ) -> String {
        ".\(ClassName.switchRoot)[data-state=\"\(mode.rawValue)\"] .\(ClassName.codeLabel)[data-pressure-track=\"\(mode.rawValue)\"]"
    }

    private static func activeDetailSelector(
        _ mode: PressureArousalMode
    ) -> String {
        ".\(ClassName.switchRoot)[data-state=\"\(mode.rawValue)\"] .\(ClassName.detail)[data-pressure-track=\"\(mode.rawValue)\"]"
    }
}
