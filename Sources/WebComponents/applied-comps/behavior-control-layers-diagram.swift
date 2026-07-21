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

    private struct Point: Sendable {
        let x: Double
        let y: Double
    }

    private struct ArcBoundary: Sendable {
        let left: Point
        let control: Point
        let right: Point

        var labelY: Double {
            (
                left.y
                + (2 * control.y)
                + right.y
            ) / 4
        }
    }

    private struct Geometry: Sendable {
        let width: Double
        let height: Double
        let centerX: Double
        let apex: Point

        let outer: ArcBoundary
        let habit: ArcBoundary
        let emotion: ArcBoundary

        static let standard = Geometry(
            width: 600,
            height: 400,
            centerX: 300,
            apex: Point(
                x: 300,
                y: 372
            ),
            outer: ArcBoundary(
                left: Point(
                    x: 60,
                    y: 118
                ),
                control: Point(
                    x: 300,
                    y: -34
                ),
                right: Point(
                    x: 540,
                    y: 118
                )
            ),
            habit: ArcBoundary(
                left: Point(
                    x: 115,
                    y: 176
                ),
                control: Point(
                    x: 300,
                    y: 58
                ),
                right: Point(
                    x: 485,
                    y: 176
                )
            ),
            emotion: ArcBoundary(
                left: Point(
                    x: 173,
                    y: 238
                ),
                control: Point(
                    x: 300,
                    y: 158
                ),
                right: Point(
                    x: 427,
                    y: 238
                )
            )
        )
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
            subtitle: "Uitkomst-afhankelijk (A–O)"
        ),
        habit: Layer = Layer(
            title: "Patroon",
            subtitle: "Gewoontelijk (S–R)"
        ),
        emotion: Layer = Layer(
            title: "Emotie",
            // subtitle: "Associatie"
            subtitle: "Verwachting"
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
        let geometry = Geometry.standard

        return HTML.figure(
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
                        "viewBox": viewBox(
                            for: geometry
                        ),
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
                            "Een ingezoomde cirkelsector met drie aansluitende lagen. "
                                + "\(choice.title) vormt de buitenste laag, "
                                + "\(habit.title) de middelste laag en "
                                + "\(emotion.title) de diepste kern."
                        )
                    }

                    layerPath(
                        className: "\(ClassName.layer) \(ClassName.choice)",
                        path: bandPath(
                            outer: geometry.outer,
                            inner: geometry.habit
                        )
                    )

                    layerPath(
                        className: "\(ClassName.layer) \(ClassName.habit)",
                        path: bandPath(
                            outer: geometry.habit,
                            inner: geometry.emotion
                        )
                    )

                    layerPath(
                        className: "\(ClassName.layer) \(ClassName.emotion)",
                        path: sectorPath(
                            boundary: geometry.emotion,
                            apex: geometry.apex
                        )
                    )

                    layerLabel(
                        layer: choice,
                        x: geometry.centerX,
                        y: labelY(
                            between: geometry.outer,
                            and: geometry.habit
                        )
                    )

                    layerLabel(
                        layer: habit,
                        x: geometry.centerX,
                        y: labelY(
                            between: geometry.habit,
                            and: geometry.emotion
                        )
                    )

                    layerLabel(
                        layer: emotion,
                        x: geometry.centerX,
                        y: labelY(
                            between: geometry.emotion,
                            and: geometry.apex
                        )
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

    private func viewBox(
        for geometry: Geometry
    ) -> String {
        "0 0 \(number(geometry.width)) \(number(geometry.height))"
    }

    private func bandPath(
        outer: ArcBoundary,
        inner: ArcBoundary
    ) -> String {
        [
            move(to: outer.left),
            quadratic(
                control: outer.control,
                to: outer.right
            ),
            line(to: inner.right),
            quadratic(
                control: inner.control,
                to: inner.left
            ),
            "Z"
        ]
        .joined(separator: " ")
    }

    private func sectorPath(
        boundary: ArcBoundary,
        apex: Point
    ) -> String {
        [
            move(to: boundary.left),
            quadratic(
                control: boundary.control,
                to: boundary.right
            ),
            line(to: apex),
            "Z"
        ]
        .joined(separator: " ")
    }

    private func move(
        to point: Point
    ) -> String {
        "M \(number(point.x)) \(number(point.y))"
    }

    private func line(
        to point: Point
    ) -> String {
        "L \(number(point.x)) \(number(point.y))"
    }

    private func quadratic(
        control: Point,
        to point: Point
    ) -> String {
        "Q \(number(control.x)) \(number(control.y)) \(number(point.x)) \(number(point.y))"
    }

    private func labelY(
        between outer: ArcBoundary,
        and inner: ArcBoundary
    ) -> Double {
        (
            outer.labelY
            + inner.labelY
        ) / 2
    }

    private func labelY(
        between boundary: ArcBoundary,
        and apex: Point
    ) -> Double {
        (
            boundary.labelY
            + apex.y
        ) / 2
    }

    private func number(
        _ value: Double
    ) -> String {
        if value.rounded() == value {
            return String(
                Int(value)
            )
        }

        return String(value)
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
        x: Double,
        y: Double
    ) -> any HTMLNode {
        let renderedX = number(x)
        let renderedY = number(y)

        return HTML.el(
            "text",
            [
                "class": ClassName.label,
                "x": renderedX,
                "y": renderedY,
                "text-anchor": "middle"
            ]
        ) {
            HTML.el(
                "tspan",
                [
                    "class": ClassName.title,
                    "x": renderedX,
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
                        "x": renderedX,
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
                    CSS.decl("stroke-linecap", "round"),
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
