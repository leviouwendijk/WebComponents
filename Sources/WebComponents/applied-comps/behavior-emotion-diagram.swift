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
            behaviorSubtitle: String = "Operant (A-O)",
            behaviorItems: [String] = [
                "Keuzes",
                "Beslissingen",
                "Handelingen",
                "Uitkomsten"
            ],
            habitTitle: String = "Gewoonte",
            habitSubtitle: String = "Klassiek (S–R)",
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

        static let cardHeader = "wc-behavior-emotion__card-header"
        static let title = "wc-behavior-emotion__title"
        static let eyebrow = "wc-behavior-emotion__eyebrow"
        static let list = "wc-behavior-emotion__list"
        static let item = "wc-behavior-emotion__item"

        static let bridge = "wc-behavior-emotion__bridge"
        static let bridgeLine = "wc-behavior-emotion__bridge-line"
        static let bridgeLabel = "wc-behavior-emotion__bridge-label"

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

        static let arrowHead = "wc-behavior-emotion__arrow-head"
        static let connector = "wc-behavior-emotion__connector"
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
                    "style": """
                    position: absolute;
                    width: 1px;
                    height: 1px;
                    padding: 0;
                    margin: -1px;
                    overflow: hidden;
                    clip: rect(0, 0, 0, 0);
                    white-space: nowrap;
                    border: 0;
                    """
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
            HTML.header(
                [
                    "class": ClassName.cardHeader
                ]
            ) {
                HTML.h3(
                    [
                        "class": ClassName.title
                    ]
                ) {
                    HTML.text(title)
                }

                HTML.p(
                    [
                        "class": ClassName.eyebrow
                    ]
                ) {
                    HTML.text(subtitle)
                }
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
                    "viewBox": "0 0 820 400",
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
                        "Gedrag genereert ervaringen die emotionele associaties vormen. "
                            + "Emotie beïnvloedt vervolgens welke gedragsopties waarschijnlijk worden. "
                            + "Gewoonte ligt als stimulus-responsverbinding tussen beide."
                    )
                }

                cyclePathLabel(
                    x: 410,
                    y: 39,
                    text: copy.behaviorToEmotion
                )

                cyclePathLabel(
                    x: 410,
                    y: 378,
                    text: copy.emotionToBehavior
                )

                cycleArrow(
                    className: ClassName.pathBehavior,
                    path: """
                    M 300 149
                    C 351 55 469 55 520 149
                    """,
                    arrowHead: """
                    M 520 149
                    L 504.4 137
                    L 518.4 129.4
                    Z
                    """
                )

                cycleArrow(
                    className: ClassName.pathEmotion,
                    path: """
                    M 520 251
                    C 469 345 351 345 300 251
                    """,
                    arrowHead: """
                    M 300 251
                    L 315.6 263
                    L 301.6 270.6
                    Z
                    """
                )

                cycleConnector(
                    fromX: 300,
                    toX: 325,
                    y: 200
                )

                cycleConnector(
                    fromX: 495,
                    toX: 520,
                    y: 200
                )

                cycleNodeBox(
                    x: 60,
                    y: 125,
                    width: 240,
                    height: 150,
                    title: copy.behaviorTitle,
                    subtitle: copy.behaviorSubtitle,
                    className: ClassName.nodeBehavior
                )

                cycleNodeBox(
                    x: 520,
                    y: 125,
                    width: 240,
                    height: 150,
                    title: copy.emotionTitle,
                    subtitle: copy.emotionSubtitle,
                    className: ClassName.nodeEmotion
                )

                cycleNodeBox(
                    x: 325,
                    y: 160,
                    width: 170,
                    height: 80,
                    title: copy.habitTitle,
                    subtitle: copy.habitSubtitle,
                    className: ClassName.nodeHabit
                )
            }
        }
    }

    private func cycleArrow(
        className: String,
        path: String,
        arrowHead: String
    ) -> any HTMLNode {
        HTML.el(
            "g",
            [
                "class": className
            ]
        ) {
            HTML.el(
                "path",
                [
                    "class": ClassName.path,
                    "d": path
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": ClassName.arrowHead,
                    "d": arrowHead
                ]
            ) {}
        }
    }

    private func cycleConnector(
        fromX: Int,
        toX: Int,
        y: Int
    ) -> any HTMLNode {
        HTML.el(
            "path",
            [
                "class": ClassName.connector,
                "d": "M \(fromX) \(y) L \(toX) \(y)"
            ]
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
        let centerY = y + (height / 2)

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
                    "y": "\(centerY - 10)",
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
                    "y": "\(centerY + 25)",
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
        text: String
    ) -> any HTMLNode {
        HTML.el(
            "text",
            [
                "class": ClassName.pathLabel,
                "x": "\(x)",
                "y": "\(y)",
                "text-anchor": "middle"
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
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("width", "min(940px, 100%)"),
                    CSS.decl("margin", "1.75rem auto"),
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
                    ),
                    CSS.decl(
                        "--wc-behavior-emotion-arrow-behavior",
                        "color-mix(in srgb, var(--link-color, #2563eb) 72%, var(--wc-behavior-emotion-ink))"
                    ),
                    CSS.decl(
                        "--wc-behavior-emotion-arrow-emotion",
                        "color-mix(in srgb, var(--link-color, #2563eb) 46%, var(--wc-behavior-emotion-ink))"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.comparisonGrid)",
                    CSS.decl("display", "grid"),
                    CSS.decl(
                        "grid-template-columns",
                        "minmax(0, 1fr) 56px minmax(0, 1fr) 56px minmax(0, 1fr)"
                    ),
                    CSS.decl("gap", "16px"),
                    CSS.decl("align-items", "stretch")
                ),

                CSS.rule(
                    ".\(ClassName.card)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("min-height", "290px"),
                    CSS.decl("padding", "30px 30px 32px"),
                    CSS.decl(
                        "border",
                        "1px solid var(--wc-behavior-emotion-border)"
                    ),
                    CSS.decl("border-radius", "24px"),
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
                    )
                ),

                CSS.rule(
                    ".\(ClassName.cardEmotion)",
                    CSS.decl(
                        "background",
                        "var(--wc-behavior-emotion-emotion)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.cardHeader)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("margin", "0 0 26px")
                ),

                CSS.rule(
                    ".\(ClassName.title)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.62rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("line-height", "1.05"),
                    CSS.decl("letter-spacing", "-.025em")
                ),

                CSS.rule(
                    ".\(ClassName.eyebrow)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("letter-spacing", ".075em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl(
                        "color",
                        "var(--wc-behavior-emotion-muted)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.list)",
                    CSS.decl("display", "grid"),
                    CSS.decl("align-content", "start"),
                    CSS.decl("gap", "13px"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("list-style", "none")
                ),

                CSS.rule(
                    ".\(ClassName.item)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".98rem"),
                    CSS.decl("line-height", "1.3")
                ),

                CSS.rule(
                    ".\(ClassName.bridge)",
                    CSS.decl("display", "grid"),
                    CSS.decl(
                        "grid-template-rows",
                        "minmax(34px, auto) minmax(90px, 1fr) minmax(34px, auto)"
                    ),
                    CSS.decl("gap", "10px"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-items", "center"),
                    CSS.decl("padding", "32px 0")
                ),

                CSS.rule(
                    ".\(ClassName.bridgeLine)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "block"),
                    CSS.decl("width", "2px"),
                    CSS.decl("height", "100%"),
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
                    CSS.decl("bottom", "1px"),
                    CSS.decl("width", "8px"),
                    CSS.decl("height", "8px"),
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
                        "translate(-50%, 1px) rotate(45deg)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.bridgeLabel)",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("width", "100%"),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "680"),
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
                    CSS.decl("font-size", "26px"),
                    CSS.decl("font-weight", "750")
                ),

                CSS.rule(
                    ".\(ClassName.nodeHabit) .\(ClassName.nodeTitle)",
                    CSS.decl("font-size", "21px")
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
                    ".\(ClassName.arrowHead)",
                    CSS.decl("stroke", "none")
                ),

                CSS.rule(
                    ".\(ClassName.pathBehavior) .\(ClassName.path)",
                    CSS.decl(
                        "stroke",
                        "var(--wc-behavior-emotion-arrow-behavior)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.pathBehavior) .\(ClassName.arrowHead)",
                    CSS.decl(
                        "fill",
                        "var(--wc-behavior-emotion-arrow-behavior)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.pathEmotion) .\(ClassName.path)",
                    CSS.decl(
                        "stroke",
                        "var(--wc-behavior-emotion-arrow-emotion)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.pathEmotion) .\(ClassName.arrowHead)",
                    CSS.decl(
                        "fill",
                        "var(--wc-behavior-emotion-arrow-emotion)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.connector)",
                    CSS.decl("fill", "none"),
                    CSS.decl(
                        "stroke",
                        "var(--wc-behavior-emotion-border)"
                    ),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("vector-effect", "non-scaling-stroke")
                ),

                CSS.rule(
                    ".\(ClassName.pathLabel)",
                    CSS.decl(
                        "fill",
                        "var(--wc-behavior-emotion-muted)"
                    ),
                    CSS.decl("font-family", "inherit"),
                    CSS.decl("font-size", "13px"),
                    CSS.decl("font-weight", "680"),
                    CSS.decl("letter-spacing", ".01em")
                ),

                CSS.rule(
                    ".\(ClassName.caption)",
                    CSS.decl("max-width", "66ch"),
                    CSS.decl("margin", "16px auto 0"),
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
                        CSS.decl("gap", "14px")
                    ),

                    CSS.rule(
                        ".\(ClassName.card)",
                        CSS.decl("min-height", "0")
                    ),

                    CSS.rule(
                        ".\(ClassName.bridge)",
                        CSS.decl("grid-template-columns", "auto 1fr auto"),
                        CSS.decl("grid-template-rows", "auto"),
                        CSS.decl("padding", "0 24px")
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
