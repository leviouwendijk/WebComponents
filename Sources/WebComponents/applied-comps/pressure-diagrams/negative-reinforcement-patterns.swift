import Constructors
import CSS
import HTML

public enum NegativeReinforcementPressurePattern: String, Sendable, CaseIterable {
    case steadyRelease = "steady-release"
    case pulsedEscape = "pulsed-escape"

    public var title: String {
        switch self {
        case .steadyRelease:
            return "mild-constante druk → release"

        case .pulsedEscape:
            return "milde pieken → escape"
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
