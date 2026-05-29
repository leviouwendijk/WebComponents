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
    case voordeel
    case nadeel

    public var title: String {
        switch self {
        case .voordeel:
            return "Voordeel"

        case .nadeel:
            return "Nadeel"
        }
    }

    public var subtitles: [String] {
        switch self {
        case .voordeel:
            return [
                "winst",
                "toegang tot aantrekker",
                "verlichting van afstoter"
            ]

        case .nadeel:
            return [
                "verlies",
                "verlies van aantrekker",
                "activatie van afstoter"
            ]
        }
    }

    public var subtitle: String {
        subtitles.joined(separator: " · ")
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

        static let codeFigure = "wc-operant-conditioning-diagram__code-figure"
        static let codeBlock = "wc-operant-conditioning-diagram__code-block"

        static let compactFigure = "wc-operant-conditioning-diagram__compact-figure"
        static let compactStage = "wc-operant-conditioning-diagram__compact-stage"
        static let compactSVG = "wc-operant-conditioning-diagram__compact-svg"
        static let compactGroup = "wc-operant-conditioning-diagram__compact-group"
        static let compactBox = "wc-operant-conditioning-diagram__compact-box"
        static let compactBoxHighlighted = "wc-operant-conditioning-diagram__compact-box--highlighted"
        static let compactTitle = "wc-operant-conditioning-diagram__compact-title"
        static let compactSubtitle = "wc-operant-conditioning-diagram__compact-subtitle"
        static let compactPath = "wc-operant-conditioning-diagram__compact-path"
        static let compactForward = "wc-operant-conditioning-diagram__compact-path--forward"
        static let compactReturn = "wc-operant-conditioning-diagram__compact-path--return"
        static let compactMarkerHead = "wc-operant-conditioning-diagram__compact-marker-head"

        static let switchFigure = "wc-operant-conditioning-diagram__switch-figure"
        static let switchRoot = "wc-operant-conditioning-diagram__switch-root"
        static let switchControls = "wc-operant-conditioning-diagram__switch-controls"
        static let switchButton = "wc-operant-conditioning-diagram__switch-button"
        static let switchStage = "wc-operant-conditioning-diagram__switch-stage"
        static let switchLive = "wc-operant-conditioning-diagram__switch-live"
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
        compact_outcome_flow_node(
            id: id,
            caption: caption,
            highlighted: highlighted
        )
    }

    public static func split_outcome_flow_body(
        markerID: String = "operant-split-flow-arrowhead",
        highlighted: OperantFlowBox? = .choice
    ) -> any HTMLNode {
        HTML.div(["class": ClassName.compactStage]) {
            compact_outcome_flow_svg(
                markerID: markerID,
                highlighted: highlighted
            )
        }
    }

    public static func compact_outcome_flow_node(
        id: String = "operant-conditioning-compact-outcome-flow",
        caption: String? = "De terugkoppeling: een aantrekker versterkt de volgende keuze; een afstoter verzwakt die keuze.",
        highlighted: OperantFlowBox? = .choice
    ) -> any HTMLNode {
        HTML.figure(
            [
                "id": id,
                "class": "\(ClassName.root) \(ClassName.compactFigure)"
            ]
        ) {
            HTML.div(["class": ClassName.compactStage]) {
                compact_outcome_flow_svg(
                    markerID: "\(id)-arrowhead",
                    highlighted: highlighted
                )
            }

            if let caption, !caption.isEmpty {
                HTML.figcaption(["class": ClassName.caption]) {
                    HTML.text(caption)
                }
            }
        }
    }

    public static func compact_outcome_flow_svg(
        markerID: String = "operant-compact-flow-arrowhead",
        highlighted: OperantFlowBox? = .choice
    ) -> any HTMLNode {
        HTML.el(
            "svg",
            [
                "class": ClassName.compactSVG,
                "viewBox": "0 0 760 292",
                "preserveAspectRatio": "xMidYMid meet",
                "role": "img",
                "aria-label": "Prikkel leidt tot keuze. Keuze leidt tot voordeel of nadeel. Voordeel versterkt dezelfde keuze; nadeel verzwakt dezelfde keuze."
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
                            "class": ClassName.compactMarkerHead,
                            "d": "M 0 0 L 10 5 L 0 10 z"
                        ]
                    ) {}
                }
            }

            compact_svg_box(
                x: 28,
                y: 122,
                width: 124,
                height: 50,
                title: "Prikkel",
                subtitle: "Omgeving",
                highlighted: highlighted == .stimulus
            )

            compact_svg_box(
                x: 232,
                y: 122,
                width: 124,
                height: 50,
                title: "Keuze",
                subtitle: "Gedrag",
                highlighted: highlighted == .choice
            )

            compact_svg_box(
                x: 232,
                y: 32,
                width: 124,
                height: 46,
                title: "Versterkt",
                subtitle: "keuze neemt toe",
                highlighted: false
            )

            compact_svg_box(
                x: 232,
                y: 214,
                width: 124,
                height: 46,
                title: "Verzwakt",
                subtitle: "keuze neemt af",
                highlighted: false
            )

            compact_svg_box(
                x: 572,
                y: 60,
                width: 154,
                height: 66,
                title: OperantOutcomeTarget.voordeel.title,
                subtitles: OperantOutcomeTarget.voordeel.subtitles,
                highlighted: highlighted == .outcome
            )

            compact_svg_box(
                x: 572,
                y: 168,
                width: 154,
                height: 66,
                title: OperantOutcomeTarget.nadeel.title,
                subtitles: OperantOutcomeTarget.nadeel.subtitles,
                highlighted: highlighted == .outcome
            )

            compact_svg_path(
                d: "M 154 147 H 220",
                markerID: markerID,
                kind: .forward
            )

            compact_svg_path(
                d: "M 358 147 H 458 V 93 H 570",
                markerID: markerID,
                kind: .forward
            )

            compact_svg_path(
                d: "M 358 147 H 458 V 201 H 570",
                markerID: markerID,
                kind: .forward
            )

            compact_svg_path(
                d: "M 649 60 V 24 H 294 V 30",
                markerID: markerID,
                kind: .returning
            )

            compact_svg_path(
                d: "M 294 80 V 118",
                markerID: markerID,
                kind: .returning
            )

            compact_svg_path(
                d: "M 649 234 V 268 H 294 V 262",
                markerID: markerID,
                kind: .returning
            )

            compact_svg_path(
                d: "M 294 212 V 176",
                markerID: markerID,
                kind: .returning
            )
        }
    }

    public static func compact_outcome_switch_node(
        id: String = "operant-conditioning-compact-outcome-switch",
        caption: String? = "Schakel tussen de twee mogelijke uitkomsten: voordeel versterkt deze keuze; nadeel verzwakt deze keuze.",
        initial: OperantOutcomeTarget = .voordeel,
        highlighted: OperantFlowBox? = .choice
    ) -> any HTMLNode {
        HTML.figure(
            [
                "id": id,
                "class": "\(ClassName.root) \(ClassName.switchFigure)"
            ]
        ) {
            HTML.div(
                [
                    "class": ClassName.switchRoot,
                    "data-operant-switch": "true",
                    "data-state": initial.rawValue
                ]
            ) {
                HTML.div(
                    [
                        "class": ClassName.switchControls,
                        "role": "group",
                        "aria-label": "Kies welke uitkomst actief wordt getoond."
                    ]
                ) {
                    switch_button(
                        .voordeel,
                        active: initial == .voordeel
                    )

                    switch_button(
                        .nadeel,
                        active: initial == .nadeel
                    )
                }

                HTML.div(["class": "\(ClassName.compactStage) \(ClassName.switchStage)"]) {
                    compact_outcome_switch_svg(
                        markerID: "\(id)-arrowhead",
                        highlighted: highlighted
                    )
                }

                HTML.span(
                    [
                        "class": ClassName.switchLive,
                        "data-operant-switch-live": "true",
                        "aria-live": "polite"
                    ]
                ) {
                    HTML.text(switch_status_text(initial))
                }
            }

            HTML.el("script") {
                HTML.raw(Self.switchScript)
            }

            if let caption, !caption.isEmpty {
                HTML.figcaption(["class": ClassName.caption]) {
                    HTML.text(caption)
                }
            }
        }
    }

    public static func compact_outcome_switch_svg(
        markerID: String = "operant-compact-switch-arrowhead",
        highlighted: OperantFlowBox? = .choice
    ) -> any HTMLNode {
        HTML.el(
            "svg",
            [
                "class": ClassName.compactSVG,
                "viewBox": "0 0 760 292",
                "preserveAspectRatio": "xMidYMid meet",
                "role": "img",
                "aria-label": "Prikkel leidt tot keuze. De keuze schakelt naar voordeel of nadeel. De actieve uitkomst versterkt of verzwakt dezelfde keuze."
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
                            "class": ClassName.compactMarkerHead,
                            "d": "M 0 0 L 10 5 L 0 10 z"
                        ]
                    ) {}
                }
            }

            compact_svg_switch_box(
                x: 28,
                y: 122,
                width: 124,
                height: 50,
                title: "Prikkel",
                subtitle: "Omgeving",
                highlighted: highlighted == .stimulus
            )

            compact_svg_switch_box(
                x: 232,
                y: 122,
                width: 124,
                height: 50,
                title: "Keuze",
                subtitle: "Gedrag",
                highlighted: highlighted == .choice
            )

            compact_svg_switch_box(
                x: 232,
                y: 32,
                width: 124,
                height: 46,
                title: "Versterkt",
                subtitle: "keuze neemt toe",
                highlighted: false,
                track: .voordeel
            )

            compact_svg_switch_box(
                x: 232,
                y: 214,
                width: 124,
                height: 46,
                title: "Verzwakt",
                subtitle: "keuze neemt af",
                highlighted: false,
                track: .nadeel
            )

            compact_svg_switch_box(
                x: 572,
                y: 60,
                width: 154,
                height: 66,
                title: OperantOutcomeTarget.voordeel.title,
                subtitles: OperantOutcomeTarget.voordeel.subtitles,
                highlighted: highlighted == .outcome,
                track: .voordeel,
                interactive: true
            )

            compact_svg_switch_box(
                x: 572,
                y: 168,
                width: 154,
                height: 66,
                title: OperantOutcomeTarget.nadeel.title,
                subtitles: OperantOutcomeTarget.nadeel.subtitles,
                highlighted: highlighted == .outcome,
                track: .nadeel,
                interactive: true
            )

            compact_svg_path(
                d: "M 154 147 H 220",
                markerID: markerID,
                kind: .forward
            )

            compact_svg_switch_path(
                d: "M 358 147 H 458 V 93 H 570",
                markerID: markerID,
                kind: .forward,
                track: .voordeel
            )

            compact_svg_switch_path(
                d: "M 358 147 H 458 V 201 H 570",
                markerID: markerID,
                kind: .forward,
                track: .nadeel
            )

            compact_svg_switch_path(
                d: "M 649 60 V 24 H 294 V 30",
                markerID: markerID,
                kind: .returning,
                track: .voordeel
            )

            compact_svg_switch_path(
                d: "M 294 80 V 118",
                markerID: markerID,
                kind: .returning,
                track: .voordeel
            )

            compact_svg_switch_path(
                d: "M 649 234 V 268 H 294 V 262",
                markerID: markerID,
                kind: .returning,
                track: .nadeel
            )

            compact_svg_switch_path(
                d: "M 294 212 V 176",
                markerID: markerID,
                kind: .returning,
                track: .nadeel
            )
        }
    }

    public static func split_outcome_code_node(
        id: String = "operant-conditioning-split-outcome-code",
        caption: String? = "De terugkoppeling als codeblok: voordeel versterkt de volgende keuze; nadeel verzwakt die keuze."
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
                     |-- Voordeel                               |
                     |   -> Versterkt --------------------------|
                     |                                          |
                     `-- Nadeel                                 |
                         -> Verzwakt ---------------------------'
    """

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

    private enum CompactPathKind {
        case forward
        case returning
    }

    private static func compact_svg_box(
        x: Int,
        y: Int,
        width: Int,
        height: Int,
        title: String,
        subtitle: String,
        highlighted: Bool
    ) -> HTMLFragment {
        compact_svg_box(
            x: x,
            y: y,
            width: width,
            height: height,
            title: title,
            subtitles: [subtitle],
            highlighted: highlighted
        )
    }

    private static func compact_svg_box(
        x: Int,
        y: Int,
        width: Int,
        height: Int,
        title: String,
        subtitles: [String],
        highlighted: Bool
    ) -> HTMLFragment {
        let className = highlighted
            ? "\(ClassName.compactBox) \(ClassName.compactBoxHighlighted)"
            : ClassName.compactBox

        let centerX = x + (width / 2)
        let cleanedSubtitles = subtitles
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let titleY = cleanedSubtitles.count > 1
            ? y + 17
            : y + 20

        let subtitleStartY = cleanedSubtitles.count > 1
            ? y + 34
            : y + 37

        return [
            HTML.el(
                "rect",
                [
                    "class": className,
                    "x": "\(x)",
                    "y": "\(y)",
                    "width": "\(width)",
                    "height": "\(height)",
                    "rx": "12",
                    "ry": "12"
                ]
            ) {},

            HTML.el(
                "text",
                [
                    "class": ClassName.compactTitle,
                    "x": "\(centerX)",
                    "y": "\(titleY)",
                    "text-anchor": "middle"
                ]
            ) {
                HTML.text(title)
            }
        ] + compact_svg_subtitle_nodes(
            centerX: centerX,
            startY: subtitleStartY,
            subtitles: cleanedSubtitles
        )
    }

    private static func compact_svg_switch_box(
        x: Int,
        y: Int,
        width: Int,
        height: Int,
        title: String,
        subtitle: String,
        highlighted: Bool,
        track: OperantOutcomeTarget? = nil,
        interactive: Bool = false
    ) -> HTMLFragment {
        compact_svg_switch_box(
            x: x,
            y: y,
            width: width,
            height: height,
            title: title,
            subtitles: [subtitle],
            highlighted: highlighted,
            track: track,
            interactive: interactive
        )
    }

    private static func compact_svg_switch_box(
        x: Int,
        y: Int,
        width: Int,
        height: Int,
        title: String,
        subtitles: [String],
        highlighted: Bool,
        track: OperantOutcomeTarget? = nil,
        interactive: Bool = false
    ) -> HTMLFragment {
        let rectClassName = highlighted
            ? "\(ClassName.compactBox) \(ClassName.compactBoxHighlighted)"
            : ClassName.compactBox

        let centerX = x + (width / 2)
        let cleanedSubtitles = subtitles
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let titleY = cleanedSubtitles.count > 1
            ? y + 17
            : y + 20

        let subtitleStartY = cleanedSubtitles.count > 1
            ? y + 34
            : y + 37

        var attrs: HTMLAttribute = [
            "class": ClassName.compactGroup
        ]

        if let track {
            attrs.merge([
                "data-operant-switch-track": track.rawValue
            ])
        }

        if interactive, let track {
            attrs.merge([
                "data-operant-switch-option": "true",
                "data-operant-switch-box": track.rawValue,
                "data-track": track.rawValue,
                "role": "button",
                "tabindex": "0",
                "aria-pressed": "false"
            ])
        }

        return [
            HTML.el(
                "g",
                attrs
            ) {
                [
                    HTML.el(
                        "rect",
                        [
                            "class": rectClassName,
                            "x": "\(x)",
                            "y": "\(y)",
                            "width": "\(width)",
                            "height": "\(height)",
                            "rx": "12",
                            "ry": "12"
                        ]
                    ) {},

                    HTML.el(
                        "text",
                        [
                            "class": ClassName.compactTitle,
                            "x": "\(centerX)",
                            "y": "\(titleY)",
                            "text-anchor": "middle"
                        ]
                    ) {
                        HTML.text(title)
                    }
                ] + compact_svg_subtitle_nodes(
                    centerX: centerX,
                    startY: subtitleStartY,
                    subtitles: cleanedSubtitles
                )
            }
        ]
    }

    private static func compact_svg_subtitle_nodes(
        centerX: Int,
        startY: Int,
        subtitles: [String]
    ) -> HTMLFragment {
        subtitles.enumerated().map { index, subtitle -> any HTMLNode in
            HTML.el(
                "text",
                [
                    "class": ClassName.compactSubtitle,
                    "x": "\(centerX)",
                    "y": "\(startY + (index * 12))",
                    "text-anchor": "middle"
                ]
            ) {
                HTML.text(subtitle)
            }
        }
    }

    private static func compact_svg_path(
        d: String,
        markerID: String,
        kind: CompactPathKind
    ) -> any HTMLNode {
        let kindClass: String = {
            switch kind {
            case .forward:
                return ClassName.compactForward

            case .returning:
                return ClassName.compactReturn
            }
        }()

        return HTML.el(
            "path",
            [
                "class": "\(ClassName.compactPath) \(kindClass)",
                "d": d,
                "marker-end": "url(#\(markerID))"
            ]
        ) {}
    }

    private static func compact_svg_switch_path(
        d: String,
        markerID: String,
        kind: CompactPathKind,
        track: OperantOutcomeTarget
    ) -> any HTMLNode {
        let kindClass: String = {
            switch kind {
            case .forward:
                return ClassName.compactForward

            case .returning:
                return ClassName.compactReturn
            }
        }()

        return HTML.el(
            "path",
            [
                "class": "\(ClassName.compactPath) \(kindClass)",
                "data-operant-switch-track": track.rawValue,
                "d": d,
                "marker-end": "url(#\(markerID))"
            ]
        ) {}
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

    private static func switch_button(
        _ target: OperantOutcomeTarget,
        active: Bool
    ) -> any HTMLNode {
        HTML.el(
            "button",
            [
                "type": "button",
                "class": ClassName.switchButton,
                "data-operant-switch-option": "true",
                "data-track": target.rawValue,
                "aria-pressed": active ? "true" : "false"
            ]
        ) {
            HTML.text(target.title)
        }
    }

    private static func switch_status_text(
        _ target: OperantOutcomeTarget
    ) -> String {
        switch target {
        case .voordeel:
            return "Voordeel geselecteerd: de uitkomst versterkt dezelfde keuze."

        case .nadeel:
            return "Nadeel geselecteerd: de uitkomst verzwakt dezelfde keuze."
        }
    }

    private static let switchScript = #"""
    (() => {
        if (window.wcOperantOutcomeSwitch?.initialized) return;

        const voordeelTrack = '\#(OperantOutcomeTarget.voordeel.rawValue)';
        const nadeelTrack = '\#(OperantOutcomeTarget.nadeel.rawValue)';

        function statusText(track) {
            if (track === nadeelTrack) {
                return '\#(switch_status_text(.nadeel))';
            }

            return '\#(switch_status_text(.voordeel))';
        }

        function setState(root, track) {
            if (!root) return;
            if (track !== voordeelTrack && track !== nadeelTrack) return;

            root.setAttribute('data-state', track);

            root.querySelectorAll('[data-operant-switch-option]').forEach((option) => {
                const active = option.getAttribute('data-track') === track;
                option.setAttribute('aria-pressed', active ? 'true' : 'false');
            });

            const live = root.querySelector('[data-operant-switch-live]');

            if (live) {
                live.textContent = statusText(track);
            }
        }

        function activate(option) {
            const root = option.closest('[data-operant-switch]');
            const track = option.getAttribute('data-track');

            setState(root, track);
        }

        document.addEventListener('click', (event) => {
            const option = event.target.closest('[data-operant-switch-option]');

            if (!option) return;

            event.preventDefault();
            activate(option);
        });

        document.addEventListener('keydown', (event) => {
            if (event.key !== 'Enter' && event.key !== ' ') return;

            const option = event.target.closest('[data-operant-switch-option]');

            if (!option) return;

            event.preventDefault();
            activate(option);
        });

        function init(root = document) {
            root.querySelectorAll('[data-operant-switch]').forEach((switchRoot) => {
                setState(
                    switchRoot,
                    switchRoot.getAttribute('data-state') || voordeelTrack
                );
            });
        }

        window.wcOperantOutcomeSwitch = {
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
                    ".\(ClassName.root), .\(ClassName.stage), .\(ClassName.compactStage)",
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
                    ".\(ClassName.compactFigure)",
                    CSS.decl("width", "min(760px, 100%)"),
                    CSS.decl("margin", "24px 0 30px")
                ),

                CSS.rule(
                    ".\(ClassName.compactStage)",
                    CSS.decl("max-width", "100%"),
                    CSS.decl("padding", "12px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)"),
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".\(ClassName.compactSVG)",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "auto"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("overflow", "visible")
                ),

                CSS.rule(
                    ".\(ClassName.compactBox)",
                    CSS.decl("fill", "var(--background-color, #fff)"),
                    CSS.decl("stroke", "var(--border-color, rgba(0,0,0,0.12))"),
                    CSS.decl("stroke-width", "1.15"),
                    CSS.decl("filter", "drop-shadow(0 10px 18px rgba(15, 23, 42, .08))")
                ),

                CSS.rule(
                    ".\(ClassName.compactBoxHighlighted)",
                    CSS.decl("fill", "color-mix(in srgb, var(--link-color) 10%, var(--background-color, #fff))"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--link-color) 44%, var(--border-color))")
                ),

                CSS.rule(
                    ".\(ClassName.compactTitle)",
                    CSS.decl("font-size", "13px"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("fill", "var(--text-color, #0f172a)"),
                    CSS.decl("pointer-events", "none")
                ),

                CSS.rule(
                    ".\(ClassName.compactSubtitle)",
                    CSS.decl("font-size", "11px"),
                    CSS.decl("font-weight", "430"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("fill", "color-mix(in srgb, var(--text-color, #0f172a) 74%, transparent)"),
                    CSS.decl("pointer-events", "none")
                ),

                CSS.rule(
                    ".\(ClassName.compactPath)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "var(--flow-arrow-color, var(--text-color, #0f172a))"),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round")
                ),

                CSS.rule(
                    ".\(ClassName.compactReturn)",
                    CSS.decl("stroke-dasharray", "5 5"),
                    CSS.decl("opacity", ".72")
                ),

                CSS.rule(
                    ".\(ClassName.compactMarkerHead)",
                    CSS.decl("fill", "var(--flow-arrow-color, var(--text-color, #0f172a))")
                ),

                CSS.rule(
                    ".\(ClassName.switchFigure)",
                    CSS.decl("width", "min(760px, 100%)"),
                    CSS.decl("margin", "24px 0 30px")
                ),

                CSS.rule(
                    ".\(ClassName.switchRoot)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".\(ClassName.switchControls)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("width", "fit-content"),
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
                    ".\(ClassName.switchButton)",
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
                    ".\(ClassName.switchButton):hover",
                    CSS.decl("color", "var(--text-color, #0f172a)")
                ),

                CSS.rule(
                    ".\(ClassName.switchButton)[aria-pressed=\"true\"]",
                    CSS.decl("background", "var(--text-color, #0f172a)"),
                    CSS.decl("color", "var(--background-color, #fff)"),
                    CSS.decl("box-shadow", "0 1px 2px rgba(15, 23, 42, .16)")
                ),

                CSS.rule(
                    ".\(ClassName.switchButton):focus-visible",
                    CSS.decl("outline", "2px solid color-mix(in srgb, var(--link-color) 70%, transparent)"),
                    CSS.decl("outline-offset", "2px")
                ),

                CSS.rule(
                    ".\(ClassName.switchRoot) [data-operant-switch-track]",
                    CSS.decl("opacity", ".18"),
                    CSS.decl("transition", "opacity 140ms ease, filter 140ms ease")
                ),

                CSS.rule(
                    ".\(ClassName.switchRoot)[data-state=\"\(OperantOutcomeTarget.voordeel.rawValue)\"] [data-operant-switch-track=\"\(OperantOutcomeTarget.voordeel.rawValue)\"], .\(ClassName.switchRoot)[data-state=\"\(OperantOutcomeTarget.nadeel.rawValue)\"] [data-operant-switch-track=\"\(OperantOutcomeTarget.nadeel.rawValue)\"]",
                    CSS.decl("opacity", "1")
                ),

                CSS.rule(
                    ".\(ClassName.switchRoot) .\(ClassName.compactPath)[data-operant-switch-track]",
                    CSS.decl("animation", "none")
                ),

                CSS.rule(
                    ".\(ClassName.switchRoot)[data-state=\"\(OperantOutcomeTarget.voordeel.rawValue)\"] .\(ClassName.compactPath)[data-operant-switch-track=\"\(OperantOutcomeTarget.voordeel.rawValue)\"], .\(ClassName.switchRoot)[data-state=\"\(OperantOutcomeTarget.nadeel.rawValue)\"] .\(ClassName.compactPath)[data-operant-switch-track=\"\(OperantOutcomeTarget.nadeel.rawValue)\"]",
                    CSS.decl("stroke-dasharray", "10 8"),
                    CSS.decl("stroke-dashoffset", "0"),
                    CSS.decl("animation", "wc-operant-conditioning-path-flow 900ms linear infinite")
                ),

                CSS.rule(
                    ".\(ClassName.switchRoot) [data-operant-switch-option]",
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(ClassName.switchRoot) [data-operant-switch-option]:focus .\(ClassName.compactBox)",
                    CSS.decl("stroke", "color-mix(in srgb, var(--link-color) 62%, var(--border-color))"),
                    CSS.decl("stroke-width", "1.8")
                ),

                CSS.rule(
                    ".\(ClassName.switchLive)",
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
                        ".\(ClassName.compactStage)",
                        CSS.decl("padding", "8px"),
                        CSS.decl("border-radius", "14px"),
                        CSS.decl("overflow-x", "auto"),
                        CSS.decl("overflow-y", "hidden"),
                        CSS.decl("scrollbar-width", "thin"),
                        CSS.decl("-webkit-overflow-scrolling", "touch"),
                        CSS.decl("overscroll-behavior-x", "contain")
                    ),

                    CSS.rule(
                        ".\(ClassName.compactSVG)",
                        CSS.decl("width", "760px"),
                        CSS.decl("min-width", "760px"),
                        CSS.decl("max-width", "none"),
                        CSS.decl("height", "auto")
                    ),

                    CSS.rule(
                        ".\(ClassName.switchControls)",
                        CSS.decl("gap", "6px")
                    ),

                    CSS.rule(
                        ".\(ClassName.switchButton)",
                        CSS.decl("height", "28px"),
                        CSS.decl("padding", "0 10px"),
                        CSS.decl("font-size", ".8rem"),
                        CSS.decl("line-height", "28px")
                    ),

                    CSS.rule(
                        ".\(ClassName.codeBlock)",
                        CSS.decl("padding", "14px"),
                        CSS.decl("font-size", ".78rem")
                    )
                ),
            ],
            keyframes: [
                CSS.keyframes("wc-operant-conditioning-path-flow") {
                    CSS.to {
                        CSS.decl("stroke-dashoffset", "-18")
                    }
                }
            ]
        )
    }
}
