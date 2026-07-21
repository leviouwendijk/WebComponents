import Constructors
import CSS
import HTML

public struct BehaviorControlLayersDiagram:
    ReusableComponent,
    Sendable
{
    public struct Layer: Sendable {
        public let title: String
        public let subtitle: String?

        public init(
            title: String,
            subtitle: String? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
        }
    }

    private enum ClassName {
        static let root = "wc-behavior-control-layers"
        static let figure = "wc-behavior-control-layers__figure"
        static let svg = "wc-behavior-control-layers__svg"

        static let layer = "wc-behavior-control-layers__layer"
        static let choice = "wc-behavior-control-layers__layer--choice"
        static let habit = "wc-behavior-control-layers__layer--habit"
        static let emotion = "wc-behavior-control-layers__layer--emotion"

        static let label = "wc-behavior-control-layers__label"
        static let title = "wc-behavior-control-layers__title"
        static let subtitle = "wc-behavior-control-layers__subtitle"

        static let caption = "wc-behavior-control-layers__caption"
    }

    public let id: String
    public let choice: Layer
    public let habit: Layer
    public let emotion: Layer
    public let caption: String?
    public let includeStyles: Bool

    public init(
        id: String = "behavior-control-layers",
        choice: Layer = Layer(
            title: "Keuze",
            subtitle: "A–O"
        ),
        habit: Layer = Layer(
            title: "Gewoonte",
            subtitle: "S–R"
        ),
        emotion: Layer = Layer(
            title: "Emotie",
            subtitle: "Associatie"
        ),
        caption: String? = nil,
        includeStyles: Bool = true
    ) {
        self.id = id
        self.choice = choice
        self.habit = habit
        self.emotion = emotion
        self.caption = caption
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .init(
            body: [
                node()
            ],
            stylesheets: includeStyles
                ? [
                    Self.stylesheet()
                ]
                : []
        )
    }

    public func node() -> any HTMLNode {
        HTML.figure(
            [
                "id": id,
                "class": ClassName.root,
                "aria-labelledby": "\(id)-title"
            ]
        ) {
            HTML.div(
                [
                    "class": ClassName.figure
                ]
            ) {
                HTML.el(
                    "svg",
                    [
                        "class": ClassName.svg,
                        "viewBox": "0 0 600 400",
                        "role": "img",
                        "aria-labelledby": "\(id)-title \(id)-description",
                        "xmlns": "http://www.w3.org/2000/svg"
                    ]
                ) {
                    HTML.el(
                        "title",
                        [
                            "id": "\(id)-title"
                        ]
                    ) {
                        HTML.text(
                            "\(choice.title), \(habit.title) en \(emotion.title)"
                        )
                    }

                    HTML.el(
                        "desc",
                        [
                            "id": "\(id)-description"
                        ]
                    ) {
                        HTML.text(
                            "Een ingezoomde cirkelsector met drie lagen. "
                                + "\(choice.title) vormt de buitenste laag, "
                                + "\(habit.title) de middelste laag en "
                                + "\(emotion.title) de diepste kern."
                        )
                    }

                    layerPath(
                        className: "\(ClassName.layer) \(ClassName.choice)",
                        path: """
                        M 60 118
                        Q 300 -34 540 118
                        L 300 372
                        Z
                        """
                    )

                    layerPath(
                        className: "\(ClassName.layer) \(ClassName.habit)",
                        path: """
                        M 116 176
                        Q 300 58 484 176
                        L 300 372
                        Z
                        """
                    )

                    layerPath(
                        className: "\(ClassName.layer) \(ClassName.emotion)",
                        path: """
                        M 178 238
                        Q 300 158 422 238
                        L 300 372
                        Z
                        """
                    )

                    layerLabel(
                        layer: choice,
                        y: 91
                    )

                    layerLabel(
                        layer: habit,
                        y: 166
                    )

                    layerLabel(
                        layer: emotion,
                        y: 246
                    )
                }
            }

            if let caption {
                HTML.figcaption(
                    [
                        "class": ClassName.caption
                    ]
                ) {
                    HTML.text(caption)
                }
            }
        }
    }

    private func layerPath(
        className: String,
        path: String
    ) -> any HTMLNode {
        HTML.el(
            "path",
            [
                "class": className,
                "d": path
            ]
        ) {}
    }

    private func layerLabel(
        layer: Layer,
        y: Int
    ) -> any HTMLNode {
        HTML.el(
            "text",
            [
                "class": ClassName.label,
                "x": "300",
                "y": "\(y)",
                "text-anchor": "middle"
            ]
        ) {
            HTML.el(
                "tspan",
                [
                    "class": ClassName.title,
                    "x": "300",
                    "dy": "0"
                ]
            ) {
                HTML.text(layer.title)
            }

            if let subtitle = layer.subtitle {
                HTML.el(
                    "tspan",
                    [
                        "class": ClassName.subtitle,
                        "x": "300",
                        "dy": "22"
                    ]
                ) {
                    HTML.text(subtitle)
                }
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("width", "min(720px, 100%)"),
                    CSS.decl("margin", "1.5rem auto"),
                    CSS.decl(
                        "color",
                        "var(--text-color, #17202a)"
                    ),
                    CSS.decl(
                        "--wc-behavior-layer-ink",
                        "var(--text-color, #17202a)"
                    ),
                    CSS.decl(
                        "--wc-behavior-layer-border",
                        "color-mix(in srgb, var(--wc-behavior-layer-ink) 24%, transparent)"
                    ),
                    CSS.decl(
                        "--wc-behavior-layer-choice",
                        "color-mix(in srgb, var(--link-color, #3568a8) 14%, var(--surface-color, #ffffff))"
                    ),
                    CSS.decl(
                        "--wc-behavior-layer-habit",
                        "color-mix(in srgb, var(--link-color, #3568a8) 23%, var(--surface-color, #ffffff))"
                    ),
                    CSS.decl(
                        "--wc-behavior-layer-emotion",
                        "color-mix(in srgb, var(--link-color, #3568a8) 34%, var(--surface-color, #ffffff))"
                    )
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.root)",
                    CSS.decl(
                        "--wc-behavior-layer-choice",
                        "color-mix(in srgb, var(--link-color, #8ab4f8) 12%, var(--surface-color, #17191d))"
                    ),
                    CSS.decl(
                        "--wc-behavior-layer-habit",
                        "color-mix(in srgb, var(--link-color, #8ab4f8) 21%, var(--surface-color, #17191d))"
                    ),
                    CSS.decl(
                        "--wc-behavior-layer-emotion",
                        "color-mix(in srgb, var(--link-color, #8ab4f8) 32%, var(--surface-color, #17191d))"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.figure)",
                    CSS.decl("width", "100%"),
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".\(ClassName.svg)",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "auto"),
                    CSS.decl("overflow", "visible")
                ),

                CSS.rule(
                    ".\(ClassName.layer)",
                    CSS.decl(
                        "stroke",
                        "var(--wc-behavior-layer-border)"
                    ),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("stroke-linejoin", "round"),
                    CSS.decl("vector-effect", "non-scaling-stroke")
                ),

                CSS.rule(
                    ".\(ClassName.choice)",
                    CSS.decl(
                        "fill",
                        "var(--wc-behavior-layer-choice)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.habit)",
                    CSS.decl(
                        "fill",
                        "var(--wc-behavior-layer-habit)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.emotion)",
                    CSS.decl(
                        "fill",
                        "var(--wc-behavior-layer-emotion)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.label)",
                    CSS.decl(
                        "fill",
                        "var(--wc-behavior-layer-ink)"
                    ),
                    CSS.decl(
                        "font-family",
                        "inherit"
                    ),
                    CSS.decl(
                        "pointer-events",
                        "none"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.title)",
                    CSS.decl("font-size", "24px"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("letter-spacing", "-0.02em")
                ),

                CSS.rule(
                    ".\(ClassName.subtitle)",
                    CSS.decl("font-size", "14px"),
                    CSS.decl("font-weight", "600"),
                    CSS.decl("letter-spacing", "0.08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("opacity", "0.66")
                ),

                CSS.rule(
                    ".\(ClassName.caption)",
                    CSS.decl("max-width", "62ch"),
                    CSS.decl("margin", "0.75rem auto 0"),
                    CSS.decl("font-size", "0.92rem"),
                    CSS.decl("line-height", "1.5"),
                    CSS.decl("text-align", "center"),
                    CSS.decl("opacity", "0.72")
                )
            ]
        )
    }
}
