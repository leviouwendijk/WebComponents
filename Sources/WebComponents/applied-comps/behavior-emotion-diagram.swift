import Constructors
import CSS
import HTML

public struct BehaviorEmotionDiagram:
    ReusableComponent,
    Sendable
{
    public enum Mode: Sendable {
        case comparison
        case cycle
    }

    public struct Copy: Sendable {
        public let behaviorTitle: String
        public let behaviorSubtitle: String
        public let behaviorItems: [String]

        public let habitTitle: String
        public let habitSubtitle: String
        public let habitItems: [String]

        public let emotionTitle: String
        public let emotionSubtitle: String
        public let emotionItems: [String]

        public let behaviorToEmotion: String
        public let emotionToBehavior: String

        public init(
            behaviorTitle: String = "Gedrag",
            behaviorSubtitle: String = "A–O / operant",
            behaviorItems: [String] = [
                "Keuzes",
                "Beslissingen",
                "Handelingen",
                "Uitkomsten"
            ],
            habitTitle: String = "Gewoonte",
            habitSubtitle: String = "S–R",
            habitItems: [String] = [
                "Automatische respons",
                "Routine",
                "Onvrijwillig gedrag"
            ],
            emotionTitle: String = "Emotie",
            emotionSubtitle: String = "Associatief",
            emotionItems: [String] = [
                "Gevoel",
                "Associatie",
                "Verwachting",
                "Gemoedstoestand"
            ],
            behaviorToEmotion: String = "Gedrag genereert ervaringen",
            emotionToBehavior: String = "Emotie beïnvloedt gedragsopties"
        ) {
            self.behaviorTitle = behaviorTitle
            self.behaviorSubtitle = behaviorSubtitle
            self.behaviorItems = behaviorItems

            self.habitTitle = habitTitle
            self.habitSubtitle = habitSubtitle
            self.habitItems = habitItems

            self.emotionTitle = emotionTitle
            self.emotionSubtitle = emotionSubtitle
            self.emotionItems = emotionItems

            self.behaviorToEmotion = behaviorToEmotion
            self.emotionToBehavior = emotionToBehavior
        }

        public static let dutch = Self()
    }

    private enum ClassName {
        static let root = "wc-behavior-emotion"
        static let comparison = "wc-behavior-emotion--comparison"
        static let cycle = "wc-behavior-emotion--cycle"

        static let comparisonGrid = "wc-behavior-emotion__comparison-grid"
        static let card = "wc-behavior-emotion__card"
        static let cardBehavior = "wc-behavior-emotion__card--behavior"
        static let cardHabit = "wc-behavior-emotion__card--habit"
        static let cardEmotion = "wc-behavior-emotion__card--emotion"

        static let bridge = "wc-behavior-emotion__bridge"
        static let bridgeLine = "wc-behavior-emotion__bridge-line"
        static let bridgeLabel = "wc-behavior-emotion__bridge-label"

        static let eyebrow = "wc-behavior-emotion__eyebrow"
        static let title = "wc-behavior-emotion__title"
        static let list = "wc-behavior-emotion__list"
        static let item = "wc-behavior-emotion__item"

        static let stage = "wc-behavior-emotion__stage"
        static let svg = "wc-behavior-emotion__svg"
        static let node = "wc-behavior-emotion__node"
        static let nodeBehavior = "wc-behavior-emotion__node--behavior"
        static let nodeHabit = "wc-behavior-emotion__node--habit"
        static let nodeEmotion = "wc-behavior-emotion__node--emotion"

        static let nodeTitle = "wc-behavior-emotion__node-title"
        static let nodeSubtitle = "wc-behavior-emotion__node-subtitle"

        static let path = "wc-behavior-emotion__path"
        static let pathBehavior = "wc-behavior-emotion__path--behavior"
        static let pathEmotion = "wc-behavior-emotion__path--emotion"

        static let pathLabel = "wc-behavior-emotion__path-label"
        static let caption = "wc-behavior-emotion__caption"
    }

    public let id: String
    public let mode: Mode
    public let copy: Copy
    public let caption: String?
    public let includeStyles: Bool

    public init(
        id: String,
        mode: Mode,
        copy: Copy = .dutch,
        caption: String? = nil,
        includeStyles: Bool = true
    ) {
        self.id = id
        self.mode = mode
        self.copy = copy
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
                "class": rootClassName,
                "aria-labelledby": "\(id)-title"
            ]
        ) {
            HTML.span(
                [
                    "id": "\(id)-title",
                    "class": "wc-visually-hidden"
                ]
            ) {
                HTML.text(accessibilityTitle)
            }

            switch mode {
            case .comparison:
                comparisonNode()

            case .cycle:
                cycleNode()
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

    private var rootClassName: String {
        switch mode {
        case .comparison:
            return "\(ClassName.root) \(ClassName.comparison)"

        case .cycle:
            return "\(ClassName.root) \(ClassName.cycle)"
        }
    }

    private var accessibilityTitle: String {
        switch mode {
        case .comparison:
            return "Vergelijking tussen gedrag, gewoonte en emotie."

        case .cycle:
            return "Circulaire beïnvloeding tussen gedrag en emotie, met gewoonte als stimulus-responsverbinding."
        }
    }

    private func comparisonNode() -> any HTMLNode {
        HTML.div(
            [
                "class": ClassName.comparisonGrid
            ]
        ) {
            comparisonCard(
                title: copy.behaviorTitle,
                subtitle: copy.behaviorSubtitle,
                items: copy.behaviorItems,
                className: ClassName.cardBehavior
            )

            comparisonBridge(
                leadingLabel: "Herhaling",
                trailingLabel: "S–R"
            )

            comparisonCard(
                title: copy.habitTitle,
                subtitle: copy.habitSubtitle,
                items: copy.habitItems,
                className: ClassName.cardHabit
            )

            comparisonBridge(
                leadingLabel: "Ervaringen",
                trailingLabel: "Associatie"
            )

            comparisonCard(
                title: copy.emotionTitle,
                subtitle: copy.emotionSubtitle,
                items: copy.emotionItems,
                className: ClassName.cardEmotion
            )
        }
    }

    private func comparisonCard(
        title: String,
        subtitle: String,
        items: [String],
        className: String
    ) -> any HTMLNode {
        HTML.section(
            [
                "class": "\(ClassName.card) \(className)"
            ]
        ) {
            HTML.p(
                [
                    "class": ClassName.eyebrow
                ]
            ) {
                HTML.text(subtitle)
            }

            HTML.h3(
                [
                    "class": ClassName.title
                ]
            ) {
                HTML.text(title)
            }

            HTML.ul(
                [
                    "class": ClassName.list
                ]
            ) {
                for item in items {
                    HTML.li(
                        [
                            "class": ClassName.item
                        ]
                    ) {
                        HTML.text(item)
                    }
                }
            }
        }
    }

    private func comparisonBridge(
        leadingLabel: String,
        trailingLabel: String
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": ClassName.bridge,
                "aria-hidden": "true"
            ]
        ) {
            HTML.span(
                [
                    "class": ClassName.bridgeLabel
                ]
            ) {
                HTML.text(leadingLabel)
            }

            HTML.span(
                [
                    "class": ClassName.bridgeLine
                ]
            ) {}

            HTML.span(
                [
                    "class": ClassName.bridgeLabel
                ]
            ) {
                HTML.text(trailingLabel)
            }
        }
    }

    private func cycleNode() -> any HTMLNode {
        HTML.div(
            [
                "class": ClassName.stage
            ]
        ) {
            HTML.el(
                "svg",
                [
                    "class": ClassName.svg,
                    "viewBox": "0 0 760 500",
                    "role": "img",
                    "aria-labelledby": "\(id)-cycle-title \(id)-cycle-description",
                    "xmlns": "http://www.w3.org/2000/svg"
                ]
            ) {
                HTML.el(
                    "title",
                    [
                        "id": "\(id)-cycle-title"
                    ]
                ) {
                    HTML.text(
                        "Circulaire beïnvloeding tussen gedrag en emotie"
                    )
                }

                HTML.el(
                    "desc",
                    [
                        "id": "\(id)-cycle-description"
                    ]
                ) {
                    HTML.text(
                        "Emotie beïnvloedt welke gedragsopties waarschijnlijk worden. "
                            + "Gedrag genereert ervaringen die emotionele associaties vormen. "
                            + "Gewoonte ligt als stimulus-responsverbinding tussen beide."
                    )
                }

                markerDefinitions()

                cyclePath(
                    className: ClassName.pathEmotion,
                    path: """
                    M 570 154
                    C 676 188 676 312 570 346
                    """,
                    markerID: "\(id)-arrow-emotion"
                )

                cyclePath(
                    className: ClassName.pathBehavior,
                    path: """
                    M 190 346
                    C 84 312 84 188 190 154
                    """,
                    markerID: "\(id)-arrow-behavior"
                )

                cycleNodeBox(
                    x: 80,
                    y: 180,
                    width: 220,
                    height: 140,
                    title: copy.behaviorTitle,
                    subtitle: copy.behaviorSubtitle,
                    className: ClassName.nodeBehavior
                )

                cycleNodeBox(
                    x: 460,
                    y: 180,
                    width: 220,
                    height: 140,
                    title: copy.emotionTitle,
                    subtitle: copy.emotionSubtitle,
                    className: ClassName.nodeEmotion
                )

                cycleNodeBox(
                    x: 305,
                    y: 205,
                    width: 150,
                    height: 90,
                    title: copy.habitTitle,
                    subtitle: copy.habitSubtitle,
                    className: ClassName.nodeHabit
                )

                cyclePathLabel(
                    x: 646,
                    y: 250,
                    text: copy.emotionToBehavior,
                    rotation: 90
                )

                cyclePathLabel(
                    x: 114,
                    y: 250,
                    text: copy.behaviorToEmotion,
                    rotation: -90
                )

                cyclePath(
                    className: ClassName.path,
                    path: """
                    M 300 250
                    L 305 250
                    """,
                    markerID: nil
                )

                cyclePath(
                    className: ClassName.path,
                    path: """
                    M 455 250
                    L 460 250
                    """,
                    markerID: nil
                )
            }
        }
    }

    private func markerDefinitions() -> any HTMLNode {
        HTML.el("defs") {
            arrowMarker(
                id: "\(id)-arrow-emotion",
                className: ClassName.pathEmotion
            )

            arrowMarker(
                id: "\(id)-arrow-behavior",
                className: ClassName.pathBehavior
            )
        }
    }

    private func arrowMarker(
        id: String,
        className: String
    ) -> any HTMLNode {
        HTML.el(
            "marker",
            [
                "id": id,
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
                    "class": "\(ClassName.path) \(className)",
                    "d": "M 0 0 L 10 5 L 0 10 Z"
                ]
            ) {}
        }
    }

    private func cyclePath(
        className: String,
        path: String,
        markerID: String?
    ) -> any HTMLNode {
        var attributes: HTMLAttribute = [
            "class": "\(ClassName.path) \(className)",
            "d": path
        ]

        if let markerID {
            attributes.merge(
                [
                    "marker-end": "url(#\(markerID))"
                ]
            )
        }

        return HTML.el(
            "path",
            attributes
        ) {}
    }

    private func cycleNodeBox(
        x: Int,
        y: Int,
        width: Int,
        height: Int,
        title: String,
        subtitle: String,
        className: String
    ) -> any HTMLNode {
        let centerX = x + (width / 2)
        let titleY = y + (height / 2) - 6
        let subtitleY = titleY + 28

        return HTML.el(
            "g",
            [
                "class": "\(ClassName.node) \(className)"
            ]
        ) {
            HTML.el(
                "rect",
                [
                    "x": "\(x)",
                    "y": "\(y)",
                    "width": "\(width)",
                    "height": "\(height)",
                    "rx": "24"
                ]
            ) {}

            HTML.el(
                "text",
                [
                    "class": ClassName.nodeTitle,
                    "x": "\(centerX)",
                    "y": "\(titleY)",
                    "text-anchor": "middle"
                ]
            ) {
                HTML.text(title)
            }

            HTML.el(
                "text",
                [
                    "class": ClassName.nodeSubtitle,
                    "x": "\(centerX)",
                    "y": "\(subtitleY)",
                    "text-anchor": "middle"
                ]
            ) {
                HTML.text(subtitle)
            }
        }
    }

    private func cyclePathLabel(
        x: Int,
        y: Int,
        text: String,
        rotation: Int
    ) -> any HTMLNode {
        HTML.el(
            "text",
            [
                "class": ClassName.pathLabel,
                "x": "\(x)",
                "y": "\(y)",
                "text-anchor": "middle",
                "transform": "rotate(\(rotation) \(x) \(y))"
            ]
        ) {
            HTML.text(text)
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("width", "min(820px, 100%)"),
                    CSS.decl("margin", "1.5rem auto"),
                    CSS.decl(
                        "--wc-behavior-emotion-ink",
                        "var(--text-color, #202124)"
                    ),
                    CSS.decl(
                        "--wc-behavior-emotion-muted",
                        "var(--muted-text-color, rgba(32, 33, 36, .66))"
                    ),
                    CSS.decl(
                        "--wc-behavior-emotion-border",
                        "var(--border-color, rgba(15, 23, 42, .14))"
                    ),
                    CSS.decl(
                        "--wc-behavior-emotion-surface",
                        "var(--surface-color, #ffffff)"
                    ),
                    CSS.decl(
                        "--wc-behavior-emotion-behavior",
                        "color-mix(in srgb, var(--link-color, #2563eb) 15%, var(--wc-behavior-emotion-surface))"
                    ),
                    CSS.decl(
                        "--wc-behavior-emotion-habit",
                        "color-mix(in srgb, var(--link-color, #2563eb) 24%, var(--wc-behavior-emotion-surface))"
                    ),
                    CSS.decl(
                        "--wc-behavior-emotion-emotion",
                        "color-mix(in srgb, var(--link-color, #2563eb) 34%, var(--wc-behavior-emotion-surface))"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.comparisonGrid)",
                    CSS.decl("display", "grid"),
                    CSS.decl(
                        "grid-template-columns",
                        "minmax(0, 1fr) 72px minmax(0, .82fr) 72px minmax(0, 1fr)"
                    ),
                    CSS.decl("gap", "12px"),
                    CSS.decl("align-items", "stretch")
                ),

                CSS.rule(
                    ".\(ClassName.card)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("padding", "24px"),
                    CSS.decl(
                        "border",
                        "1px solid var(--wc-behavior-emotion-border)"
                    ),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl(
                        "color",
                        "var(--wc-behavior-emotion-ink)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.cardBehavior)",
                    CSS.decl(
                        "background",
                        "var(--wc-behavior-emotion-behavior)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.cardHabit)",
                    CSS.decl(
                        "background",
                        "var(--wc-behavior-emotion-habit)"
                    ),
                    CSS.decl("align-self", "center")
                ),

                CSS.rule(
                    ".\(ClassName.cardEmotion)",
                    CSS.decl(
                        "background",
                        "var(--wc-behavior-emotion-emotion)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.eyebrow)",
                    CSS.decl("margin", "0 0 7px"),
                    CSS.decl("font-size", ".7rem"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl(
                        "color",
                        "var(--wc-behavior-emotion-muted)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.title)",
                    CSS.decl("margin", "0 0 18px"),
                    CSS.decl("font-size", "1.35rem"),
                    CSS.decl("line-height", "1.1")
                ),

                CSS.rule(
                    ".\(ClassName.list)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("list-style", "none")
                ),

                CSS.rule(
                    ".\(ClassName.item)",
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.35")
                ),

                CSS.rule(
                    ".\(ClassName.bridge)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-rows", "auto 1fr auto"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-items", "center"),
                    CSS.decl("padding", "22px 0")
                ),

                CSS.rule(
                    ".\(ClassName.bridgeLine)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "block"),
                    CSS.decl("width", "2px"),
                    CSS.decl("height", "100%"),
                    CSS.decl("min-height", "58px"),
                    CSS.decl(
                        "background",
                        "var(--wc-behavior-emotion-border)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.bridgeLine)::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "50%"),
                    CSS.decl("bottom", "-1px"),
                    CSS.decl("width", "9px"),
                    CSS.decl("height", "9px"),
                    CSS.decl(
                        "border-right",
                        "2px solid var(--wc-behavior-emotion-muted)"
                    ),
                    CSS.decl(
                        "border-bottom",
                        "2px solid var(--wc-behavior-emotion-muted)"
                    ),
                    CSS.decl(
                        "transform",
                        "translateX(-50%) rotate(45deg)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.bridgeLabel)",
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("text-align", "center"),
                    CSS.decl(
                        "color",
                        "var(--wc-behavior-emotion-muted)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
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
                    ".\(ClassName.node) rect",
                    CSS.decl(
                        "stroke",
                        "var(--wc-behavior-emotion-border)"
                    ),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("vector-effect", "non-scaling-stroke")
                ),

                CSS.rule(
                    ".\(ClassName.nodeBehavior) rect",
                    CSS.decl(
                        "fill",
                        "var(--wc-behavior-emotion-behavior)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.nodeHabit) rect",
                    CSS.decl(
                        "fill",
                        "var(--wc-behavior-emotion-habit)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.nodeEmotion) rect",
                    CSS.decl(
                        "fill",
                        "var(--wc-behavior-emotion-emotion)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.nodeTitle)",
                    CSS.decl(
                        "fill",
                        "var(--wc-behavior-emotion-ink)"
                    ),
                    CSS.decl("font-family", "inherit"),
                    CSS.decl("font-size", "25px"),
                    CSS.decl("font-weight", "750")
                ),

                CSS.rule(
                    ".\(ClassName.nodeHabit) .\(ClassName.nodeTitle)",
                    CSS.decl("font-size", "20px")
                ),

                CSS.rule(
                    ".\(ClassName.nodeSubtitle)",
                    CSS.decl(
                        "fill",
                        "var(--wc-behavior-emotion-muted)"
                    ),
                    CSS.decl("font-family", "inherit"),
                    CSS.decl("font-size", "14px"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("letter-spacing", ".06em")
                ),

                CSS.rule(
                    ".\(ClassName.path)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke-width", "3"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round"),
                    CSS.decl("vector-effect", "non-scaling-stroke")
                ),

                CSS.rule(
                    ".\(ClassName.pathBehavior)",
                    CSS.decl(
                        "stroke",
                        "color-mix(in srgb, var(--link-color, #2563eb) 70%, var(--wc-behavior-emotion-ink))"
                    ),
                    CSS.decl(
                        "fill",
                        "color-mix(in srgb, var(--link-color, #2563eb) 70%, var(--wc-behavior-emotion-ink))"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.pathEmotion)",
                    CSS.decl(
                        "stroke",
                        "color-mix(in srgb, var(--link-color, #2563eb) 42%, var(--wc-behavior-emotion-ink))"
                    ),
                    CSS.decl(
                        "fill",
                        "color-mix(in srgb, var(--link-color, #2563eb) 42%, var(--wc-behavior-emotion-ink))"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.pathLabel)",
                    CSS.decl(
                        "fill",
                        "var(--wc-behavior-emotion-muted)"
                    ),
                    CSS.decl("font-family", "inherit"),
                    CSS.decl("font-size", "13px"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("letter-spacing", ".02em")
                ),

                CSS.rule(
                    ".\(ClassName.caption)",
                    CSS.decl("max-width", "66ch"),
                    CSS.decl("margin", "14px auto 0"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.5"),
                    CSS.decl("text-align", "center"),
                    CSS.decl(
                        "color",
                        "var(--wc-behavior-emotion-muted)"
                    )
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 760px)",
                    CSS.rule(
                        ".\(ClassName.comparisonGrid)",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "12px")
                    ),
                    CSS.rule(
                        ".\(ClassName.bridge)",
                        CSS.decl("grid-template-columns", "auto 1fr auto"),
                        CSS.decl("grid-template-rows", "auto"),
                        CSS.decl("padding", "0 22px")
                    ),
                    CSS.rule(
                        ".\(ClassName.bridgeLine)",
                        CSS.decl("width", "100%"),
                        CSS.decl("height", "2px"),
                        CSS.decl("min-height", "0")
                    ),
                    CSS.rule(
                        ".\(ClassName.bridgeLine)::after",
                        CSS.decl("left", "auto"),
                        CSS.decl("right", "-1px"),
                        CSS.decl("bottom", "50%"),
                        CSS.decl(
                            "transform",
                            "translateY(50%) rotate(-45deg)"
                        )
                    )
                )
            ]
        )
    }
}
