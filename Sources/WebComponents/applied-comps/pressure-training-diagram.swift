import Constructors
import CSS
import HTML

public enum PressureArousalMode: String, Sendable, CaseIterable {
    case negativePunishment = "negative-punishment"
    case negativeReinforcement = "negative-reinforcement"
    case positivePunishment = "positive-punishment"

    public var code: String {
        switch self {
        case .negativePunishment:
            return "−P"

        case .negativeReinforcement:
            return "−R"

        case .positivePunishment:
            return "+P"
        }
    }

    public var title: String {
        switch self {
        case .negativePunishment:
            return "Restrictie / blokkade"

        case .negativeReinforcement:
            return "Milde constante druk"

        case .positivePunishment:
            return "Hoge piekdruk"
        }
    }

    public var shortLabel: String {
        "\(code) · \(title)"
    }

    public var body: String {
        switch self {
        case .negativePunishment:
            return "Toegang wordt begrensd of tijdelijk onbereikbaar. De druk zit vooral in frustratie, blokkade of gemis."

        case .negativeReinforcement:
            return "Druk blijft mild aanwezig en verdwijnt zodra de hond de gewenste richting kiest. De opluchting bekrachtigt."

        case .positivePunishment:
            return "Een hoge drukpiek wordt toegevoegd om gedrag te onderbreken of te verminderen. Dit vraagt extra voorzichtigheid."
        }
    }

    public var statusText: String {
        "\(shortLabel): \(body)"
    }
}

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
    public let includeStyles: Bool

    public init(
        id: String = "pressure-arousal-curve",
        caption: String? = "Druk en arousal lopen niet altijd netjes gelijk. Bij hogere arousal kan gedrag sneller, grover en minder gevoelig voor subtiele feedback worden.",
        initial: PressureArousalMode = .negativeReinforcement,
        operantConditioningHref: String = "/hondengedrag/operante-conditionering/",
        includeStyles: Bool = true
    ) {
        self.id = id
        self.caption = caption
        self.initial = initial
        self.operantConditioningHref = operantConditioningHref
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
                                    href: operantConditioningHref
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
            stylesheets: includeStyles ? [Self.stylesheet()] : []
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
        href: String
    ) -> any HTMLNode {
        HTML.article(
            [
                "class": "\(ClassName.detail) \(ClassName.detail)--\(mode.rawValue)",
                "data-pressure-track": mode.rawValue
            ]
        ) {
            HTML.a(
                href,
                [
                    "class": ClassName.detailCode,
                    "aria-label": "\(mode.code), operante conditionering"
                ]
            ) {
                HTML.text(mode.code)
            }

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
            rules: commonRules(
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
                    CSS.decl("color", "var(--link-color, #2563eb)"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color, #2563eb) 10%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--link-color, #2563eb) 22%, transparent)")
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

public enum NegativeReinforcementPressurePattern: String, Sendable, CaseIterable {
    case steadyRelease = "steady-release"
    case pulsedEscape = "pulsed-escape"

    public var title: String {
        switch self {
        case .steadyRelease:
            return "Constante druk → release"

        case .pulsedEscape:
            return "Piekjes → escape"
        }
    }

    public var statusText: String {
        switch self {
        case .steadyRelease:
            return "Constante druk: lage druk blijft aanwezig en valt weg bij de juiste keuze."

        case .pulsedEscape:
            return "Piekjes: meerdere korte drukmomenten worden beëindigd wanneer de hond de juiste richting kiest."
        }
    }
}

public struct NegativeReinforcementPressureDiagram: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-negative-reinforcement-pressure"
        static let switchRoot = "wc-negative-reinforcement-pressure__switch-root"
        static let controls = "wc-negative-reinforcement-pressure__controls"
        static let button = "wc-negative-reinforcement-pressure__button"
        static let stage = "wc-negative-reinforcement-pressure__stage"
        static let svg = "wc-negative-reinforcement-pressure__svg"
        static let field = "wc-negative-reinforcement-pressure__field"
        static let axis = "wc-negative-reinforcement-pressure__axis"
        static let threshold = "wc-negative-reinforcement-pressure__threshold"
        static let curve = "wc-negative-reinforcement-pressure__curve"
        static let curveSteady = "wc-negative-reinforcement-pressure__curve--steady"
        static let curvePulsed = "wc-negative-reinforcement-pressure__curve--pulsed"
        static let label = "wc-negative-reinforcement-pressure__label"
        static let release = "wc-negative-reinforcement-pressure__release"
        static let live = "wc-negative-reinforcement-pressure__live"
        static let caption = "wc-negative-reinforcement-pressure__caption"
    }

    public let id: String
    public let caption: String?
    public let initial: NegativeReinforcementPressurePattern
    public let includeStyles: Bool

    public init(
        id: String = "negative-reinforcement-pressure",
        caption: String? = "Bij −R is niet de druk zelf het eindpunt, maar het moment waarop druk verdwijnt. De opluchting maakt de voorafgaande keuze waarschijnlijker.",
        initial: NegativeReinforcementPressurePattern = .steadyRelease,
        includeStyles: Bool = true
    ) {
        self.id = id
        self.caption = caption
        self.initial = initial
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
                                "aria-label": "Kies welk negatief bekrachtigingspatroon wordt getoond."
                            ]
                        ) {
                            for pattern in NegativeReinforcementPressurePattern.allCases {
                                Self.switchButton(
                                    pattern,
                                    active: pattern == initial
                                )
                            }
                        }

                        HTML.div(
                            [
                                "class": ClassName.stage,
                                "role": "img",
                                "aria-label": "Twee patronen voor negatieve bekrachtiging: constante druk met release, of korte piekjes met escape."
                            ]
                        ) {
                            Self.svg()
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
                        HTML.raw(PressureArousalCurveDiagram.switchScript)
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
                "viewBox": "0 0 760 360",
                "preserveAspectRatio": "xMidYMid meet",
                "role": "img",
                "aria-label": "Druk over tijd: constante druk valt weg bij release, of drukpiekjes stoppen bij escape."
            ]
        ) {
            HTML.el(
                "rect",
                [
                    "class": ClassName.field,
                    "x": "24",
                    "y": "24",
                    "width": "712",
                    "height": "274",
                    "rx": "24",
                    "ry": "24"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": ClassName.axis,
                    "d": "M 64 264 V 60 M 64 264 H 700"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": ClassName.threshold,
                    "d": "M 64 174 H 700"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": "\(ClassName.curve) \(ClassName.curveSteady)",
                    "d": "M 82 252 L 150 252 L 150 176 L 450 176 L 450 252 L 682 252"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": "\(ClassName.curve) \(ClassName.curvePulsed)",
                    "d": "M 82 252 L 126 252 L 148 162 L 170 252 L 218 252 L 240 162 L 262 252 L 310 252 L 332 162 L 354 252 L 682 252"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": ClassName.release,
                    "d": "M 450 176 L 450 252 M 354 162 L 354 252"
                ]
            ) {}

            graphText(
                x: 70,
                y: 50,
                text: "druk",
                className: ClassName.label
            )

            graphText(
                x: 635,
                y: 288,
                text: "tijd",
                className: ClassName.label
            )

            graphText(
                x: 492,
                y: 232,
                text: "release",
                className: ClassName.label
            )

            graphText(
                x: 458,
                y: 166,
                text: "keuze → opluchting",
                className: ClassName.label
            )
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

    private static func switchButton(
        _ pattern: NegativeReinforcementPressurePattern,
        active: Bool
    ) -> any HTMLNode {
        HTML.el(
            "button",
            [
                "type": "button",
                "class": ClassName.button,
                "data-pressure-option": "true",
                "data-state": pattern.rawValue,
                "data-status": pattern.statusText,
                "aria-pressed": active ? "true" : "false"
            ]
        ) {
            HTML.text(pattern.title)
        }
    }

    public static func css() -> CSSStyleSheet {
        stylesheet()
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: commonRules(
                root: ClassName.root,
                switchRoot: ClassName.switchRoot,
                controls: ClassName.controls,
                button: ClassName.button,
                stage: ClassName.stage,
                live: ClassName.live,
                caption: ClassName.caption
            ) + [
                CSS.rule(
                    ".\(ClassName.svg)",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "auto"),
                    CSS.decl("min-width", "680px")
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
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 26%, transparent)"),
                    CSS.decl("stroke-width", "1.5"),
                    CSS.decl("stroke-dasharray", "10 10")
                ),

                CSS.rule(
                    ".\(ClassName.curve)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "var(--text-color)"),
                    CSS.decl("stroke-width", "4"),
                    CSS.decl("stroke-linejoin", "round"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(ClassName.switchRoot)[data-state=\"\(NegativeReinforcementPressurePattern.steadyRelease.rawValue)\"] .\(ClassName.curveSteady), .\(ClassName.switchRoot)[data-state=\"\(NegativeReinforcementPressurePattern.pulsedEscape.rawValue)\"] .\(ClassName.curvePulsed)",
                    CSS.decl("display", "inline")
                ),

                CSS.rule(
                    ".\(ClassName.release)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "var(--link-color)"),
                    CSS.decl("stroke-width", "3"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-dasharray", "8 8")
                ),

                CSS.rule(
                    ".\(ClassName.label)",
                    CSS.decl("font-family", "var(--mono-font, ui-monospace, SFMono-Regular, Menlo, monospace)"),
                    CSS.decl("font-size", "12px"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("fill", "var(--text-color)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
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

private extension PressureArousalCurveDiagram {
    static let switchScript = #"""
    (() => {
        if (window.wcPressureSwitch?.initialized) return;

        function setState(root, state) {
            if (!root || !state) return;

            root.setAttribute('data-state', state);

            let status = '';

            root.querySelectorAll('[data-pressure-option]').forEach((option) => {
                const active = option.getAttribute('data-state') === state;
                option.setAttribute('aria-pressed', active ? 'true' : 'false');

                if (active) {
                    status = option.getAttribute('data-status') || option.textContent || '';
                }
            });

            const live = root.querySelector('[data-pressure-switch-live]');

            if (live && status) {
                live.textContent = status;
            }
        }

        function activate(option) {
            const root = option.closest('[data-pressure-switch]');
            const state = option.getAttribute('data-state');

            setState(root, state);
        }

        document.addEventListener('click', (event) => {
            const option = event.target.closest('[data-pressure-option]');

            if (!option) return;

            event.preventDefault();
            activate(option);
        });

        document.addEventListener('keydown', (event) => {
            if (event.key !== 'Enter' && event.key !== ' ') return;

            const option = event.target.closest('[data-pressure-option]');

            if (!option) return;

            event.preventDefault();
            activate(option);
        });

        function init(root = document) {
            root.querySelectorAll('[data-pressure-switch]').forEach((switchRoot) => {
                const current = switchRoot.getAttribute('data-state');
                const first = switchRoot.querySelector('[data-pressure-option]')?.getAttribute('data-state');

                setState(switchRoot, current || first);
            });
        }

        window.wcPressureSwitch = {
            initialized: true,
            init,
            setState
        };

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => init());
        } else {
            init();
        }
    })();
    """#
}
