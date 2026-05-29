import DSL
import Constructors
import CSS
import HTML

public enum OperantQuadrant: String, Sendable, CaseIterable {
    case positive_reinforcement
    case positive_punishment
    case negative_reinforcement
    case negative_punishment

    public enum positive {
        public static let reinforcement: OperantQuadrant = .positive_reinforcement
        public static let punishment: OperantQuadrant = .positive_punishment
    }

    public enum negative {
        public static let reinforcement: OperantQuadrant = .negative_reinforcement
        public static let punishment: OperantQuadrant = .negative_punishment
    }

    public var code: String {
        switch self {
        case .positive_reinforcement:
            return "R+"

        case .positive_punishment:
            return "P+"

        case .negative_reinforcement:
            return "R-"

        case .negative_punishment:
            return "P-"
        }
    }

    public var family: String {
        switch self {
        case .positive_reinforcement,
             .negative_reinforcement:
            return "\"reinforcement\""

        case .positive_punishment,
             .negative_punishment:
            return "\"punishment\""
        }
    }

    public var object: String {
        switch self {
        case .positive_reinforcement,
             .negative_punishment:
            return "motivator"

        case .positive_punishment,
             .negative_reinforcement:
            return "demotivator"
        }
    }

    public var direction: String {
        switch self {
        case .positive_reinforcement,
             .positive_punishment:
            return "positive (+)"

        case .negative_reinforcement,
             .negative_punishment:
            return "negative (-)"
        }
    }
}

public enum OperantFlowBox: String, Sendable, CaseIterable {
    case stimulus
    case choice
    case outcome
}

public enum OperantOutcomeTarget: String, Sendable, CaseIterable {
    case aantrekker
    case afstoter

    public var title: String {
        switch self {
        case .aantrekker:
            return "Aantrekker"

        case .afstoter:
            return "Afstoter"
        }
    }

    public var subtitle: String {
        switch self {
        case .aantrekker:
            return "toegang / behoud"

        case .afstoter:
            return "vermijding / opheffing"
        }
    }
}

public enum OperantOutcomeEffect: String, Sendable, CaseIterable {
    case versterkt
    case verzwakt

    public var title: String {
        switch self {
        case .versterkt:
            return "Versterkt"

        case .verzwakt:
            return "Verzwakt"
        }
    }

    public var subtitle: String {
        switch self {
        case .versterkt:
            return "keuze neemt toe"

        case .verzwakt:
            return "keuze neemt af"
        }
    }
}

public struct OperantConditioningDiagram: ReusableComponent, Sendable {
    public typealias Quadrant = OperantQuadrant
    public typealias OutcomeTarget = OperantOutcomeTarget
    public typealias OutcomeEffect = OperantOutcomeEffect

    private enum ClassName {
        static let root = "wc-operant-conditioning-diagram"
        static let stage = "wc-operant-conditioning-diagram__stage"
        static let flow = "wc-operant-conditioning-diagram__flow"
        static let matrix = "wc-operant-conditioning-diagram__matrix"
        static let caption = "wc-operant-conditioning-diagram__caption"

        static let codeFigure = "wc-operant-conditioning-diagram__code-figure"
        static let codeBlock = "wc-operant-conditioning-diagram__code-block"

        static let flowFigure = "wc-operant-conditioning-diagram__flow-figure"
        static let matrixFigure = "wc-operant-conditioning-diagram__matrix-figure"
        static let quadrantFigure = "wc-operant-conditioning-diagram__quadrant-figure"

        static let flowBox = "wc-operant-conditioning-diagram__flow-box"
        static let flowBoxStimulus = "wc-operant-conditioning-diagram__flow-box--stimulus"
        static let flowBoxChoice = "wc-operant-conditioning-diagram__flow-box--choice"
        static let flowBoxOutcome = "wc-operant-conditioning-diagram__flow-box--outcome"
        static let highlighted = "wc-operant-conditioning-diagram__flow-box--highlighted"

        static let quadrantBox = "wc-operant-conditioning-diagram__quadrant-box"
        static let quadrantHeader = "wc-operant-conditioning-diagram__quadrant-header"
        static let quadrantCode = "wc-operant-conditioning-diagram__quadrant-code"
        static let quadrantFamily = "wc-operant-conditioning-diagram__quadrant-family"
        static let quadrantRule = "wc-operant-conditioning-diagram__quadrant-rule"
        static let quadrantBody = "wc-operant-conditioning-diagram__quadrant-body"
        static let quadrantObject = "wc-operant-conditioning-diagram__quadrant-object"
        static let quadrantDirection = "wc-operant-conditioning-diagram__quadrant-direction"

        static let splitFlowFigure = "wc-operant-conditioning-diagram__split-flow-figure"
        static let splitFlowStage = "wc-operant-conditioning-diagram__split-flow-stage"
        static let splitFlowGrid = "wc-operant-conditioning-diagram__split-flow-grid"
        static let splitFlowMiddle = "wc-operant-conditioning-diagram__split-flow-middle"
        static let splitFlowChoiceSlot = "wc-operant-conditioning-diagram__split-flow-choice-slot"

        static let splitFlowBox = "wc-operant-conditioning-diagram__split-flow-box"
        static let splitFlowBoxStimulus = "wc-operant-conditioning-diagram__split-flow-box--stimulus"
        static let splitFlowBoxChoice = "wc-operant-conditioning-diagram__split-flow-box--choice"
        static let splitFlowBoxAantrekker = "wc-operant-conditioning-diagram__split-flow-box--aantrekker"
        static let splitFlowBoxAfstoter = "wc-operant-conditioning-diagram__split-flow-box--afstoter"
        static let splitFlowBoxVersterkt = "wc-operant-conditioning-diagram__split-flow-box--versterkt"
        static let splitFlowBoxVerzwakt = "wc-operant-conditioning-diagram__split-flow-box--verzwakt"

        static let splitFlowTitle = "wc-operant-conditioning-diagram__split-flow-title"
        static let splitFlowSubtitle = "wc-operant-conditioning-diagram__split-flow-subtitle"
        static let splitFlowOutcomes = "wc-operant-conditioning-diagram__split-flow-outcomes"
        static let splitFlowEffects = "wc-operant-conditioning-diagram__split-flow-effects"
        static let splitFlowArrowLayer = "wc-operant-conditioning-diagram__split-flow-arrow-layer"
        static let splitFlowPath = "wc-operant-conditioning-diagram__split-flow-path"
        static let splitFlowForward = "wc-operant-conditioning-diagram__split-flow-path--forward"
        static let splitFlowReturn = "wc-operant-conditioning-diagram__split-flow-path--return"
        static let splitFlowMarkerHead = "wc-operant-conditioning-diagram__split-flow-marker-head"
    }

    public let id: String
    public let caption: String?
    public let includeStyles: Bool

    public init(
        id: String = "operant-conditioning-diagram",
        caption: String? = "Operante conditionering betrekt een keuze: de uitkomst verandert de waarschijnlijkheid van toekomstig gedrag.",
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
                            "aria-label": "Operante conditionering: prikkel, keuze, uitkomst en de vier operante kwadranten."
                        ]
                    ) {
                        HTML.div(["class": ClassName.flow]) {
                            Self.flow().nodes.body
                        }

                        HTML.div(["class": ClassName.matrix]) {
                            Self.matrix().nodes.body
                        }
                    }

                    if let caption, !caption.isEmpty {
                        HTML.figcaption(["class": ClassName.caption]) {
                            HTML.text(caption)
                        }
                    }
                }
            ],
            stylesheets: includeStyles
                ? [
                    FlowDiagram.css(),
                    MatrixDiagram.css(),
                    Self.stylesheet()
                ]
                : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public static func flow(
        highlighted: OperantFlowBox? = .choice
    ) -> FlowDiagram {
        FlowDiagram(
            axis: .row,
            classes: [
                .raw(ClassName.flow)
            ],
            items: [
                .box(
                    flow_box(
                        kind: .stimulus,
                        highlighted: highlighted
                    ) {
                        [
                            HTML.b { HTML.text("Prikkel") },
                            HTML.span { HTML.text("Omgeving") }
                        ]
                    }
                ),

                .arrow(.init()),

                .box(
                    flow_box(
                        kind: .choice,
                        highlighted: highlighted
                    ) {
                        [
                            HTML.b { HTML.text("Keuze") },
                            HTML.span { HTML.text("Gedrag") }
                        ]
                    }
                ),

                .arrow(.init()),

                .box(
                    flow_box(
                        kind: .outcome,
                        highlighted: highlighted
                    ) {
                        [
                            HTML.b { HTML.text("Uitkomst") },
                            HTML.span { HTML.text("Gevolg") }
                        ]
                    }
                )
            ]
        )
    }

    public static func flow_node(
        id: String = "operant-conditioning-flow",
        caption: String? = nil,
        highlighted: OperantFlowBox? = .choice
    ) -> any HTMLNode {
        figure(
            id: id,
            className: "\(ClassName.root) \(ClassName.flowFigure)",
            roleLabel: "Prikkel leidt tot keuze; keuze leidt tot uitkomst.",
            caption: caption
        ) {
            [
                flow(
                    highlighted: highlighted
                ).nodes.body[0]
            ]
        }
    }

    public static func split_outcome_flow_node(
        id: String = "operant-conditioning-split-outcome-flow",
        caption: String? = "De keuze leidt naar een uitkomst. Die uitkomst werkt via versterking of verzwakking terug op de waarschijnlijkheid van die keuze.",
        highlighted: OperantFlowBox? = .choice
    ) -> any HTMLNode {
        HTML.figure(
            [
                "id": id,
                "class": "\(ClassName.root) \(ClassName.splitFlowFigure)"
            ]
        ) {
            split_outcome_flow_body(
                markerID: "\(id)-arrowhead",
                highlighted: highlighted
            )

            if let caption, !caption.isEmpty {
                HTML.figcaption(["class": ClassName.caption]) {
                    HTML.text(caption)
                }
            }
        }
    }

    public static func split_outcome_code_node(
        id: String = "operant-conditioning-split-outcome-code",
        caption: String? = "De terugkoppeling als codeblok: een aantrekker versterkt de volgende keuze; een afstoter verzwakt die keuze."
    ) -> any HTMLNode {
        HTML.figure(
            [
                "id": id,
                "class": "\(ClassName.root) \(ClassName.codeFigure)"
            ]
        ) {
            HTML.pre(
                [
                    "class": ClassName.codeBlock,
                    "aria-label": "Operante terugkoppeling als codeblok."
                ]
            ) {
                HTML.code {
                    HTML.text(Self.splitOutcomeCodeText)
                }
            }

            if let caption, !caption.isEmpty {
                HTML.figcaption(["class": ClassName.caption]) {
                    HTML.text(caption)
                }
            }
        }
    }

    public static let splitOutcomeCodeText = """
    Prikkel ------> [keuze] Gedrag <-----------------------------.
                         |                                      |
                     uitkomst?                                  |
                     |-- Aantrekker                             |
                     |   -> Versterkt --------------------------|
                     |                                          |
                     `-- Afstoter                               |
                         -> Verzwakt ---------------------------'
    """

    // public static let splitOutcomeCodeText = """
    // Prikkel ───────▶ [keuze] Gedrag ◀──────────────────────────────┐
    //                      ↓                                         │
    //                  uitkomst?                                     │
    //                  ├─ Aantrekker                                 │
    //                  │   → Versterkt ──────────────────────────────┤
    //                  │                                             │
    //                  └─ Afstoter                                   │
    //                      → Verzwakt ───────────────────────────────┘
    // """

    public static func split_outcome_flow_body(
        markerID: String = "operant-split-flow-arrowhead",
        highlighted: OperantFlowBox? = .choice
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": ClassName.splitFlowStage,
                "role": "img",
                "aria-label": "Operante conditionering: prikkel leidt tot keuze, keuze leidt tot aantrekker of afstoter, en die uitkomst versterkt of verzwakt de volgende keuze."
            ]
        ) {
            split_outcome_flow_arrow_layer(
                markerID: markerID
            )

            HTML.div(["class": ClassName.splitFlowGrid]) {
                split_flow_box(
                    classes: [
                        ClassName.splitFlowBoxStimulus
                    ],
                    title: "Prikkel",
                    subtitle: "Omgeving",
                    highlighted: highlighted == .stimulus
                )

                HTML.div(["class": ClassName.splitFlowMiddle]) {
                    HTML.div(["class": ClassName.splitFlowEffects]) {
                        split_flow_box(
                            classes: [
                                ClassName.splitFlowBoxVersterkt
                            ],
                            title: OperantOutcomeEffect.versterkt.title,
                            subtitle: OperantOutcomeEffect.versterkt.subtitle,
                            highlighted: false
                        )
                    }

                    HTML.div(["class": ClassName.splitFlowChoiceSlot]) {
                        split_flow_box(
                            classes: [
                                ClassName.splitFlowBoxChoice
                            ],
                            title: "Keuze",
                            subtitle: "Gedrag",
                            highlighted: highlighted == .choice
                        )
                    }

                    HTML.div(["class": ClassName.splitFlowEffects]) {
                        split_flow_box(
                            classes: [
                                ClassName.splitFlowBoxVerzwakt
                            ],
                            title: OperantOutcomeEffect.verzwakt.title,
                            subtitle: OperantOutcomeEffect.verzwakt.subtitle,
                            highlighted: false
                        )
                    }
                }

                HTML.div(["class": ClassName.splitFlowOutcomes]) {
                    split_flow_box(
                        classes: [
                            ClassName.splitFlowBoxAantrekker
                        ],
                        title: OperantOutcomeTarget.aantrekker.title,
                        subtitle: OperantOutcomeTarget.aantrekker.subtitle,
                        highlighted: highlighted == .outcome
                    )

                    split_flow_box(
                        classes: [
                            ClassName.splitFlowBoxAfstoter
                        ],
                        title: OperantOutcomeTarget.afstoter.title,
                        subtitle: OperantOutcomeTarget.afstoter.subtitle,
                        highlighted: highlighted == .outcome
                    )
                }
            }
        }
    }

    public static func matrix() -> MatrixDiagram {
        MatrixDiagram(
            columns: 2,
            rows: 2,
            cells: [
                [
                    quadrant_cell(.positive.reinforcement),
                    quadrant_cell(.positive.punishment)
                ],
                [
                    quadrant_cell(.negative.reinforcement),
                    quadrant_cell(.negative.punishment)
                ]
            ],
            columnHeaders: [
                matrix_label(
                    title: "Aansporing (Versterking)",
                    arrow: "↓"
                ),
                matrix_label(
                    title: "Ontmoediging (Ontkrachting)",
                    arrow: "↓"
                )
            ],
            rowHeaders: [
                matrix_label(
                    title: "Toevoeging",
                    arrow: "→"
                ),
                matrix_label(
                    title: "Opheffing",
                    arrow: "→"
                )
            ]
        )
    }

    public static func matrix_node(
        id: String = "operant-conditioning-matrix",
        caption: String? = nil
    ) -> any HTMLNode {
        figure(
            id: id,
            className: "\(ClassName.root) \(ClassName.matrixFigure)",
            roleLabel: "Matrix met de vier operante kwadranten.",
            caption: caption
        ) {
            [
                matrix().nodes.body[0]
            ]
        }
    }

    public static func quadrant_cell(
        _ quadrant: OperantQuadrant
    ) -> MatrixDiagram.Cell {
        .box(
            quadrant_box(quadrant)
        )
    }

    public static func quadrant_box(
        _ quadrant: OperantQuadrant
    ) -> Box {
        Box(
            classes: [
                .raw(ClassName.quadrantBox),
                .raw("\(ClassName.quadrantBox)--\(quadrant.rawValue)")
            ],
            align: .start
        ) {
            [
                HTML.div(["class": ClassName.quadrantHeader]) {
                    HTML.b(["class": ClassName.quadrantCode]) {
                        HTML.text(quadrant.code)
                    }

                    HTML.span(["class": ClassName.quadrantFamily]) {
                        HTML.text(quadrant.family)
                    }
                },

                HTML.hr(["class": ClassName.quadrantRule]),

                HTML.div(["class": ClassName.quadrantBody]) {
                    HTML.span(["class": ClassName.quadrantObject]) {
                        HTML.text(quadrant.object)
                    }

                    HTML.span(["class": ClassName.quadrantDirection]) {
                        HTML.text(quadrant.direction)
                    }
                }
            ]
        }
    }

    public static func quadrant_node(
        _ quadrant: OperantQuadrant,
        id: String? = nil,
        caption: String? = nil
    ) -> any HTMLNode {
        let resolvedID = id ?? "operant-quadrant-\(quadrant.rawValue)"

        return figure(
            id: resolvedID,
            className: "\(ClassName.root) \(ClassName.quadrantFigure)",
            roleLabel: "Operant kwadrant \(quadrant.code): \(quadrant.family), \(quadrant.object), \(quadrant.direction).",
            caption: caption
        ) {
            [
                MatrixDiagram(
                    columns: 1,
                    rows: 1,
                    cells: [
                        [
                            quadrant_cell(quadrant)
                        ]
                    ]
                ).nodes.body[0]
            ]
        }
    }

    private static func split_outcome_flow_arrow_layer(
        markerID: String
    ) -> any HTMLNode {
        HTML.el(
            "svg",
            [
                "class": ClassName.splitFlowArrowLayer,
                "viewBox": "0 0 1000 420",
                "preserveAspectRatio": "none",
                "aria-hidden": "true"
            ]
        ) {
            HTML.el("defs") {
                HTML.el(
                    "marker",
                    [
                        "id": markerID,
                        "viewBox": "0 0 10 10",
                        "refX": "9",
                        "refY": "5",
                        "markerWidth": "7",
                        "markerHeight": "7",
                        "orient": "auto"
                    ]
                ) {
                    HTML.el(
                        "path",
                        [
                            "class": ClassName.splitFlowMarkerHead,
                            "d": "M 0 0 L 10 5 L 0 10 z"
                        ]
                    ) {}
                }
            }

            HTML.el(
                "path",
                [
                    "class": "\(ClassName.splitFlowPath) \(ClassName.splitFlowForward)",
                    "d": "M 230 210 H 360",
                    "marker-end": "url(#\(markerID))"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": "\(ClassName.splitFlowPath) \(ClassName.splitFlowForward)",
                    "d": "M 545 210 H 620 V 112 H 765",
                    "marker-end": "url(#\(markerID))"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": "\(ClassName.splitFlowPath) \(ClassName.splitFlowForward)",
                    "d": "M 545 210 H 620 V 308 H 765",
                    "marker-end": "url(#\(markerID))"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": "\(ClassName.splitFlowPath) \(ClassName.splitFlowReturn)",
                    "d": "M 765 112 H 545",
                    "marker-end": "url(#\(markerID))"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": "\(ClassName.splitFlowPath) \(ClassName.splitFlowReturn)",
                    "d": "M 765 308 H 545",
                    "marker-end": "url(#\(markerID))"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": "\(ClassName.splitFlowPath) \(ClassName.splitFlowReturn)",
                    "d": "M 450 145 V 168",
                    "marker-end": "url(#\(markerID))"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": "\(ClassName.splitFlowPath) \(ClassName.splitFlowReturn)",
                    "d": "M 450 275 V 252",
                    "marker-end": "url(#\(markerID))"
                ]
            ) {}
        }
    }

    private static func split_flow_box(
        classes: [String],
        title: String,
        subtitle: String,
        highlighted: Bool
    ) -> any HTMLNode {
        var allClasses = [
            ClassName.splitFlowBox
        ] + classes

        if highlighted {
            allClasses.append(
                ClassName.highlighted
            )
        }

        return HTML.div(["class": allClasses.joined(separator: " ")]) {
            HTML.b(["class": ClassName.splitFlowTitle]) {
                HTML.text(title)
            }

            HTML.span(["class": ClassName.splitFlowSubtitle]) {
                HTML.text(subtitle)
            }
        }
    }

    private static func flow_box(
        kind: OperantFlowBox,
        highlighted: OperantFlowBox?,
        content: @escaping @Sendable () -> HTMLFragment
    ) -> Box {
        var classes: [HTMLClassToken] = [
            .raw(ClassName.flowBox),
            .raw(flow_box_class(kind))
        ]

        if highlighted == kind {
            classes.append(
                .raw(ClassName.highlighted)
            )
        }

        return Box(
            classes: classes,
            content: content
        )
    }

    private static func flow_box_class(
        _ kind: OperantFlowBox
    ) -> String {
        switch kind {
        case .stimulus:
            return ClassName.flowBoxStimulus

        case .choice:
            return ClassName.flowBoxChoice

        case .outcome:
            return ClassName.flowBoxOutcome
        }
    }

    private static func matrix_label(
        title: String,
        arrow: String
    ) -> MatrixDiagram.Cell {
        .box(
            .init(
                classes: [
                    "wc-matrix__label"
                ],
                align: .center
            ) {
                [
                    HTML.span {
                        HTML.text(title)
                    },
                    HTML.span(["style": "font-size:1.2rem;line-height:1;"]) {
                        HTML.text(arrow)
                    }
                ]
            }
        )
    }

    private static func figure(
        id: String,
        className: String,
        roleLabel: String,
        caption: String?,
        body: @escaping @Sendable () -> HTMLFragment
    ) -> any HTMLNode {
        HTML.figure(
            [
                "id": id,
                "class": className
            ]
        ) {
            HTML.div(
                [
                    "class": ClassName.stage,
                    "role": "img",
                    "aria-label": roleLabel
                ]
            ) {
                body()
            }

            if let caption, !caption.isEmpty {
                HTML.figcaption(["class": ClassName.caption]) {
                    HTML.text(caption)
                }
            }
        }
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
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "20px"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)"),
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".\(ClassName.root), .\(ClassName.stage), .\(ClassName.splitFlowStage)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("max-width", "100%")
                ),

                CSS.rule(
                    ".\(ClassName.flow).wc-flow, .\(ClassName.flow) .wc-flow",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("margin", "0"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("width", "100%")
                ),

                CSS.rule(
                    ".\(ClassName.flow).wc-flow--row, .\(ClassName.flow) .wc-flow--row",
                    CSS.decl("flex-wrap", "nowrap"),
                    CSS.decl("align-items", "stretch")
                ),

                CSS.rule(
                    ".\(ClassName.flow).wc-flow .wc-flow__box, .\(ClassName.flow) .wc-flow__box",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("flex", "1 1 0")
                ),

                CSS.rule(
                    ".\(ClassName.flow).wc-flow .wc-flow__box-inner, .\(ClassName.flow) .wc-flow__box-inner",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("max-width", "100%")
                ),

                CSS.rule(
                    ".\(ClassName.flow).wc-flow .wc-flow__arrow-wrap, .\(ClassName.flow) .wc-flow__arrow-wrap",
                    CSS.decl("flex", "0 0 44px")
                ),

                CSS.rule(
                    ".\(ClassName.flowBox)",
                    CSS.decl("position", "relative")
                ),

                CSS.rule(
                    ".\(ClassName.highlighted)",
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 10%, var(--surface-color, #fff))"),
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 38%, var(--border-color))"),
                    CSS.decl("box-shadow", "0 18px 44px color-mix(in srgb, var(--link-color) 15%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.matrix) .wc-matrix-wrap, .\(ClassName.matrixFigure) .wc-matrix-wrap, .\(ClassName.quadrantFigure) .wc-matrix-wrap",
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    ".\(ClassName.quadrantHeader), .\(ClassName.quadrantBody)",
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("align-items", "baseline")
                ),

                CSS.rule(
                    ".\(ClassName.quadrantFamily), .\(ClassName.quadrantObject)",
                    CSS.decl("font-style", "italic")
                ),

                CSS.rule(
                    ".\(ClassName.quadrantDirection)",
                    CSS.decl("font-size", ".9rem")
                ),

                CSS.rule(
                    ".\(ClassName.quadrantRule)",
                    CSS.decl("border", "0"),
                    CSS.decl("border-top", "1px solid var(--border-color, rgba(0,0,0,0.12))"),
                    CSS.decl("margin", "10px 0")
                ),

                CSS.rule(
                    ".\(ClassName.splitFlowStage)",
                    CSS.decl("position", "relative"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)"),
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".\(ClassName.splitFlowGrid)",
                    CSS.decl("position", "relative"),
                    CSS.decl("z-index", "1"),
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(150px, .9fr) minmax(190px, 1fr) minmax(190px, 1fr)"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "88px"),
                    CSS.decl("min-height", "320px")
                ),

                CSS.rule(
                    ".\(ClassName.splitFlowMiddle)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-rows", "auto auto auto"),
                    CSS.decl("gap", "22px"),
                    CSS.decl("align-items", "center")
                ),

                CSS.rule(
                    ".\(ClassName.splitFlowChoiceSlot)",
                    CSS.decl("display", "grid")
                ),

                CSS.rule(
                    ".\(ClassName.splitFlowOutcomes)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "58px")
                ),

                CSS.rule(
                    ".\(ClassName.splitFlowEffects)",
                    CSS.decl("display", "grid")
                ),

                CSS.rule(
                    ".\(ClassName.splitFlowBox)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("min-height", "76px"),
                    CSS.decl("padding", "14px 16px"),
                    CSS.decl("border", "1px solid var(--border-color, rgba(0,0,0,0.12))"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "var(--background-color, #fff)"),
                    CSS.decl("box-shadow", "var(--shadow-soft, 0 12px 28px rgba(0,0,0,0.08))"),
                    CSS.decl("text-align", "center")
                ),

                CSS.rule(
                    ".\(ClassName.splitFlowTitle)",
                    CSS.decl("font-weight", "760"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("color", "var(--text-color, #0f172a)")
                ),

                CSS.rule(
                    ".\(ClassName.splitFlowSubtitle)",
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.25"),
                    CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))")
                ),

                CSS.rule(
                    ".\(ClassName.splitFlowArrowLayer)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("inset", "0"),
                    CSS.decl("z-index", "0"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "100%"),
                    CSS.decl("pointer-events", "none")
                ),

                CSS.rule(
                    ".\(ClassName.splitFlowPath)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "var(--flow-arrow-color, var(--text-color, #0f172a))"),
                    CSS.decl("stroke-width", "2.2"),
                    CSS.decl("stroke-linecap", "square"),
                    CSS.decl("stroke-linejoin", "miter")
                ),

                CSS.rule(
                    ".\(ClassName.splitFlowReturn)",
                    CSS.decl("stroke-dasharray", "7 7"),
                    CSS.decl("opacity", ".72")
                ),

                CSS.rule(
                    ".\(ClassName.splitFlowMarkerHead)",
                    CSS.decl("fill", "var(--flow-arrow-color, var(--text-color, #0f172a))")
                ),

                CSS.rule(
                    ".\(ClassName.codeFigure)",
                    CSS.decl("width", "min(860px, 100%)"),
                    CSS.decl("margin", "24px 0 30px")
                ),

                CSS.rule(
                    ".\(ClassName.codeBlock)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("overflow-x", "auto"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", "clamp(.78rem, 2.8vw, .92rem)"),
                    CSS.decl("line-height", "1.65"),
                    CSS.decl("white-space", "pre"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.codeBlock) code",
                    CSS.decl("font", "inherit"),
                    CSS.decl("color", "inherit")
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
                        CSS.decl("padding", "14px"),
                        CSS.decl("gap", "16px")
                    ),

                    CSS.rule(
                        ".\(ClassName.flow).wc-flow--row, .\(ClassName.flow) .wc-flow--row",
                        CSS.decl("flex-direction", "column"),
                        CSS.decl("align-items", "stretch")
                    ),

                    CSS.rule(
                        ".\(ClassName.flow).wc-flow .wc-flow__box, .\(ClassName.flow) .wc-flow__box",
                        CSS.decl("width", "100%"),
                        CSS.decl("flex", "0 1 auto")
                    ),

                    CSS.rule(
                        ".\(ClassName.flow).wc-flow .wc-flow__arrow-wrap, .\(ClassName.flow) .wc-flow__arrow-wrap",
                        CSS.decl("width", "100%"),
                        CSS.decl("min-width", "0"),
                        CSS.decl("height", "34px"),
                        CSS.decl("flex", "0 0 34px"),
                        CSS.decl("transform", "rotate(90deg)")
                    ),

                    CSS.rule(
                        ".\(ClassName.splitFlowStage)",
                        CSS.decl("padding", "14px")
                    ),

                    CSS.rule(
                        ".\(ClassName.splitFlowGrid)",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "14px"),
                        CSS.decl("min-height", "0")
                    ),

                    CSS.rule(
                        ".\(ClassName.splitFlowMiddle)",
                        CSS.decl("gap", "14px")
                    ),

                    CSS.rule(
                        ".\(ClassName.splitFlowOutcomes)",
                        CSS.decl("gap", "14px")
                    ),

                    CSS.rule(
                        ".\(ClassName.splitFlowArrowLayer)",
                        CSS.decl("display", "none")
                    ),

                    CSS.rule(
                        ".\(ClassName.splitFlowBox)",
                        CSS.decl("min-height", "64px")
                    ),

                    CSS.rule(
                        ".\(ClassName.codeBlock)",
                        CSS.decl("padding", "14px"),
                        CSS.decl("font-size", ".78rem")
                    )
                )
            ]
        )
    }
}
