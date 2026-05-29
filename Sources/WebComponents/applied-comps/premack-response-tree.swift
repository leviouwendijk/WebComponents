import Constructors
import CSS
import HTML

public struct PremackHorizontalResponseTree: ReusableComponent, Sendable {
    public struct Column: Sendable {
        public let id: String
        public let label: String
        public let weightLabel: String
        public let weight: Int

        public init(
            id: String,
            label: String,
            weightLabel: String,
            weight: Int
        ) {
            self.id = id
            self.label = label
            self.weightLabel = weightLabel
            self.weight = weight
        }

        public var clampedWeight: Int {
            min(100, max(0, weight))
        }
    }

    public enum Slot: String, Sendable {
        case top
        case upper
        case center
        case lower
        case bottom

        var centerY: Int {
            switch self {
            case .top:
                return 48

            case .upper:
                return 104

            case .center:
                return 160

            case .lower:
                return 216

            case .bottom:
                return 272
            }
        }
    }

    public struct Response: Sendable {
        public let id: String
        public let columnID: String
        public let slot: Slot
        public let title: String
        public let detail: String?

        public init(
            id: String,
            columnID: String,
            slot: Slot,
            title: String,
            detail: String? = nil
        ) {
            self.id = id
            self.columnID = columnID
            self.slot = slot
            self.title = title
            self.detail = detail
        }
    }

    public struct Condition: Sendable {
        public let label: String
        public let title: String
        public let detail: String?

        public init(
            label: String = "Conditie",
            title: String = "situatie / context",
            detail: String? = nil
        ) {
            self.label = label
            self.title = title
            self.detail = detail
        }
    }

    private enum ClassName {
        static let root = "wc-premack-horizontal-response-tree"
        static let stage = "wc-premack-horizontal-response-tree__stage"
        static let header = "wc-premack-horizontal-response-tree__header"
        static let title = "wc-premack-horizontal-response-tree__title"
        static let summary = "wc-premack-horizontal-response-tree__summary"

        static let scroller = "wc-premack-horizontal-response-tree__scroller"
        static let canvas = "wc-premack-horizontal-response-tree__canvas"

        static let columns = "wc-premack-horizontal-response-tree__columns"
        static let columnSpacer = "wc-premack-horizontal-response-tree__column-spacer"
        static let column = "wc-premack-horizontal-response-tree__column"
        static let columnLabel = "wc-premack-horizontal-response-tree__column-label"
        static let columnWeight = "wc-premack-horizontal-response-tree__column-weight"
        static let columnMeter = "wc-premack-horizontal-response-tree__column-meter"
        static let columnMeterFill = "wc-premack-horizontal-response-tree__column-meter-fill"

        static let graph = "wc-premack-horizontal-response-tree__graph"
        static let branchLayer = "wc-premack-horizontal-response-tree__branch-layer"
        static let branchLine = "wc-premack-horizontal-response-tree__branch-line"
        static let branchLineTarget = "wc-premack-horizontal-response-tree__branch-line--target"
        static let branchLineAccess = "wc-premack-horizontal-response-tree__branch-line--access"

        static let origin = "wc-premack-horizontal-response-tree__origin"
        static let condition = "wc-premack-horizontal-response-tree__condition"
        static let conditionLabel = "wc-premack-horizontal-response-tree__condition-label"
        static let conditionTitle = "wc-premack-horizontal-response-tree__condition-title"
        static let conditionDetail = "wc-premack-horizontal-response-tree__condition-detail"

        static let response = "wc-premack-horizontal-response-tree__response"
        static let responseTarget = "wc-premack-horizontal-response-tree__response--target"
        static let responseAccess = "wc-premack-horizontal-response-tree__response--access"
        static let responseTitle = "wc-premack-horizontal-response-tree__response-title"
        static let responseDetail = "wc-premack-horizontal-response-tree__response-detail"

        static let relation = "wc-premack-horizontal-response-tree__relation"
        static let relationStep = "wc-premack-horizontal-response-tree__relation-step"
        static let relationLabel = "wc-premack-horizontal-response-tree__relation-label"
        static let relationArrow = "wc-premack-horizontal-response-tree__relation-arrow"

        static let caption = "wc-premack-horizontal-response-tree__caption"
    }

    private enum Layout {
        static let leftWidth = 220
        static let branchGap = 34
        static let columnWidth = 180
        static let graphHeight = 320

        static let conditionWidth = 170
        static let conditionHeight = 96
        static let conditionX = 0
        static let originY = 160

        static let responseWidth = 150
        static let responseHeight = 82

        static let conditionY = originY - conditionHeight / 2
        static let originX = conditionX + conditionWidth + 26
    }

    public let id: String
    public let title: String?
    public let summary: String?
    public let condition: Condition
    public let columns: [Column]
    public let responses: [Response]
    public let targetID: String?
    public let accessID: String?
    public let caption: String?
    public let includeStyles: Bool

    public init(
        id: String = "premack-horizontal-response-tree",
        title: String? = "Premack-principe: responsen naar relatieve waarschijnlijkheid",
        summary: String? = "Een conditie opent meerdere mogelijke responsen. De horizontale rij ordent die responsen naar gewicht; de boom toont hoe de responsen vanuit dezelfde oorsprong vertakken.",
        condition: Condition = .init(),
        columns: [Column],
        responses: [Response],
        targetID: String? = nil,
        accessID: String? = nil,
        caption: String? = nil,
        includeStyles: Bool = true
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.condition = condition
        self.columns = columns
        self.responses = responses
        self.targetID = targetID
        self.accessID = accessID
        self.caption = caption
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                figure_node()
            ],
            stylesheets: includeStyles
                ? [
                    Self.stylesheet()
                ]
                : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    private var canvasWidth: Int {
        Layout.leftWidth + Layout.branchGap + columns.count * Layout.columnWidth
    }

    private func figure_node() -> any HTMLNode {
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
                    "aria-label": aria_label()
                ]
            ) {
                if title != nil || summary != nil {
                    header_node()
                }

                HTML.div(["class": ClassName.scroller]) {
                    HTML.div(
                        [
                            "class": ClassName.canvas,
                            "style": "width: \(canvasWidth)px;"
                        ]
                    ) {
                        columns_node()
                        graph_node()
                    }
                }

                relation_node()
            }

            if let caption, !caption.isEmpty {
                HTML.figcaption(["class": ClassName.caption]) {
                    HTML.text(caption)
                }
            }
        }
    }

    private func header_node() -> any HTMLNode {
        HTML.div(["class": ClassName.header]) {
            if let title, !title.isEmpty {
                HTML.p(["class": ClassName.title]) {
                    HTML.text(title)
                }
            }

            if let summary, !summary.isEmpty {
                HTML.p(["class": ClassName.summary]) {
                    HTML.text(summary)
                }
            }
        }
    }

    private func columns_node() -> any HTMLNode {
        HTML.div(["class": ClassName.columns]) {
            HTML.div(["class": ClassName.columnSpacer]) {}

            for column in columns {
                column_node(column)
            }
        }
    }

    private func column_node(_ column: Column) -> any HTMLNode {
        HTML.div(
            [
                "class": ClassName.column,
                "style": "--wc-premack-column-weight: \(column.clampedWeight)%;"
            ]
        ) {
            HTML.span(["class": ClassName.columnLabel]) {
                HTML.text(column.label)
            }

            HTML.span(["class": ClassName.columnWeight]) {
                HTML.text(column.weightLabel)
            }

            HTML.div(["class": ClassName.columnMeter]) {
                HTML.div(["class": ClassName.columnMeterFill]) {}
            }
        }
    }

    private func graph_node() -> any HTMLNode {
        HTML.div(
            [
                "class": ClassName.graph,
                "style": "height: \(Layout.graphHeight)px;"
            ]
        ) {
            branch_layer_node()
            origin_node()
            condition_node()

            for response in responses {
                response_node(response)
            }
        }
    }

    private func branch_layer_node() -> any HTMLNode {
        HTML.el(
            "svg",
            [
                "class": ClassName.branchLayer,
                "viewBox": "0 0 \(canvasWidth) \(Layout.graphHeight)",
                "preserveAspectRatio": "none",
                "aria-hidden": "true"
            ]
        ) {
            for response in responses {
                if let point = response_point(response) {
                    branch_line_node(
                        response: response,
                        x1: Layout.originX,
                        y1: Layout.originY,
                        x2: point.x,
                        y2: point.y
                    )
                }
            }

            if
                let targetID,
                let accessID,
                let target = responses.first(where: { $0.id == targetID }),
                let access = responses.first(where: { $0.id == accessID }),
                let targetPoint = response_point(target),
                let accessPoint = response_point(access)
            {
                access_line_node(
                    x1: targetPoint.x + Layout.responseWidth,
                    y1: targetPoint.y,
                    x2: accessPoint.x + Layout.responseWidth,
                    y2: accessPoint.y
                )
            }
        }
    }

    private func branch_line_node(
        response: Response,
        x1: Int,
        y1: Int,
        x2: Int,
        y2: Int
    ) -> any HTMLNode {
        HTML.el(
            "line",
            [
                "class": branch_line_class(response),
                "x1": "\(x1)",
                "y1": "\(y1)",
                "x2": "\(x2)",
                "y2": "\(y2)"
            ]
        ) {}
    }

    private func access_line_node(
        x1: Int,
        y1: Int,
        x2: Int,
        y2: Int
    ) -> any HTMLNode {
        HTML.el(
            "path",
            [
                "class": "\(ClassName.branchLine) \(ClassName.branchLineAccess)",
                "d": access_path(
                    x1: x1,
                    y1: y1,
                    x2: x2,
                    y2: y2
                )
            ]
        ) {}
    }

    private func access_path(
        x1: Int,
        y1: Int,
        x2: Int,
        y2: Int
    ) -> String {
        let lift = 32
        let midX = (x1 + x2) / 2
        let topY = min(y1, y2) - lift

        return "M \(x1) \(y1) C \(midX) \(topY), \(midX) \(topY), \(x2) \(y2)"
    }

    private func origin_node() -> any HTMLNode {
        HTML.div(
            [
                "class": ClassName.origin,
                "style": "left: \(Layout.originX - 6)px; top: \(Layout.originY - 6)px;"
            ]
        ) {}
    }

    private func condition_node() -> any HTMLNode {
        HTML.div(
            [
                "class": ClassName.condition,
                "style": "left: \(Layout.conditionX)px; top: \(Layout.conditionY)px; width: \(Layout.conditionWidth)px; min-height: \(Layout.conditionHeight)px;"
            ]
        ) {
            HTML.span(["class": ClassName.conditionLabel]) {
                HTML.text(condition.label)
            }

            HTML.b(["class": ClassName.conditionTitle]) {
                HTML.text(condition.title)
            }

            if let detail = condition.detail, !detail.isEmpty {
                HTML.span(["class": ClassName.conditionDetail]) {
                    HTML.text(detail)
                }
            }
        }
    }

    private func response_node(_ response: Response) -> any HTMLNode {
        let position = response_position(response)

        return HTML.div(
            [
                "class": response_class(response),
                "style": "left: \(position.x)px; top: \(position.y)px; width: \(Layout.responseWidth)px; min-height: \(Layout.responseHeight)px;",
                "data-premack-response": response.id
            ]
        ) {
            HTML.b(["class": ClassName.responseTitle]) {
                HTML.text(response.title)
            }

            if let detail = response.detail, !detail.isEmpty {
                HTML.span(["class": ClassName.responseDetail]) {
                    HTML.text(detail)
                }
            }
        }
    }

    private func relation_node() -> any HTMLNode {
        guard
            let targetID,
            let accessID,
            let target = responses.first(where: { $0.id == targetID }),
            let access = responses.first(where: { $0.id == accessID })
        else {
            return HTML.div(["hidden": "true"]) {}
        }

        return HTML.div(["class": ClassName.relation]) {
            HTML.div(["class": ClassName.relationStep]) {
                HTML.span(["class": ClassName.relationLabel]) {
                    HTML.text("Minder waarschijnlijk")
                }

                HTML.b {
                    HTML.text(target.title)
                }
            }

            HTML.span(
                [
                    "class": ClassName.relationArrow,
                    "aria-hidden": "true"
                ]
            ) {
                HTML.text("→")
            }

            HTML.div(["class": ClassName.relationStep]) {
                HTML.span(["class": ClassName.relationLabel]) {
                    HTML.text("Geeft toegang tot")
                }

                HTML.b {
                    HTML.text(access.title)
                }
            }
        }
    }

    private func response_position(_ response: Response) -> (x: Int, y: Int) {
        let columnIndex = columns.firstIndex(where: { $0.id == response.columnID }) ?? 0
        let x = Layout.leftWidth
            + Layout.branchGap
            + columnIndex * Layout.columnWidth
            + (Layout.columnWidth - Layout.responseWidth) / 2

        let y = response.slot.centerY - Layout.responseHeight / 2

        return (x, y)
    }

    private func response_point(_ response: Response) -> (x: Int, y: Int)? {
        let position = response_position(response)

        return (
            x: position.x,
            y: position.y + Layout.responseHeight / 2
        )
    }

    private func response_class(_ response: Response) -> String {
        var classes = [
            ClassName.response
        ]

        if response.id == targetID {
            classes.append(ClassName.responseTarget)
        }

        if response.id == accessID {
            classes.append(ClassName.responseAccess)
        }

        return classes.joined(separator: " ")
    }

    private func branch_line_class(_ response: Response) -> String {
        var classes = [
            ClassName.branchLine
        ]

        if response.id == targetID {
            classes.append(ClassName.branchLineTarget)
        }

        return classes.joined(separator: " ")
    }

    private func aria_label() -> String {
        let columnText = columns
            .map { "\($0.label), \($0.weightLabel)" }
            .joined(separator: "; ")

        let responseText = responses
            .map { $0.title }
            .joined(separator: ", ")

        return "Premack responsboom. Conditie: \(condition.title). Gewichtskolommen: \(columnText). Responsen: \(responseText)."
    }

    public static func css() -> CSSStyleSheet {
        stylesheet()
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("width", "min(1040px, 100%)"),
                    CSS.decl("margin", "24px 0 30px")
                ),

                CSS.rule(
                    ".\(ClassName.root) *",
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "20px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 95%, var(--text-color) 5%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)"),
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".\(ClassName.header)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("max-width", "780px")
                ),

                CSS.rule(
                    ".\(ClassName.title)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", "-.01em"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.summary)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.48"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.scroller)",
                    CSS.decl("max-width", "100%"),
                    CSS.decl("overflow-x", "auto"),
                    CSS.decl("overflow-y", "hidden"),
                    CSS.decl("scrollbar-width", "thin"),
                    CSS.decl("-webkit-overflow-scrolling", "touch"),
                    CSS.decl("overscroll-behavior-x", "contain"),
                    CSS.decl("padding", "4px 4px 12px"),
                    CSS.decl("margin", "0 -4px")
                ),

                CSS.rule(
                    ".\(ClassName.canvas)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "12px")
                ),

                CSS.rule(
                    ".\(ClassName.columns)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "\(Layout.leftWidth + Layout.branchGap)px repeat(\(4), \(Layout.columnWidth)px)"),
                    CSS.decl("gap", "0"),
                    CSS.decl("align-items", "stretch")
                ),

                CSS.rule(
                    ".\(ClassName.columnSpacer)",
                    CSS.decl("min-width", "\(Layout.leftWidth + Layout.branchGap)px")
                ),

                CSS.rule(
                    ".\(ClassName.column)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-rows", "auto auto 6px"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("min-height", "72px"),
                    CSS.decl("padding", "10px 12px"),
                    CSS.decl("border-top", "1px solid var(--border-color)"),
                    CSS.decl("border-bottom", "1px solid var(--border-color)"),
                    CSS.decl("border-left", "1px solid var(--border-color)"),
                    CSS.decl("background", "color-mix(in srgb, var(--background-color, #fff) 93%, var(--text-color) 7%)")
                ),

                CSS.rule(
                    ".\(ClassName.column):last-child",
                    CSS.decl("border-right", "1px solid var(--border-color)")
                ),

                CSS.rule(
                    ".\(ClassName.columnLabel)",
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "820"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("letter-spacing", ".02em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.columnWeight)",
                    CSS.decl("font-size", ".75rem"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.columnMeter)",
                    CSS.decl("position", "relative"),
                    CSS.decl("height", "6px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 10%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.columnMeterFill)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("inset", "0 auto 0 0"),
                    CSS.decl("width", "var(--wc-premack-column-weight)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 72%, var(--link-color) 28%)")
                ),

                CSS.rule(
                    ".\(ClassName.graph)",
                    CSS.decl("position", "relative"),
                    CSS.decl("isolation", "isolate")
                ),

                CSS.rule(
                    ".\(ClassName.branchLayer)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("inset", "0"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "100%"),
                    CSS.decl("z-index", "1"),
                    CSS.decl("overflow", "visible")
                ),

                CSS.rule(
                    ".\(ClassName.branchLine)",
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 34%, var(--border-color))"),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("vector-effect", "non-scaling-stroke")
                ),

                CSS.rule(
                    ".\(ClassName.branchLineTarget)",
                    CSS.decl("stroke", "var(--link-color)"),
                    CSS.decl("stroke-width", "2.5")
                ),

                CSS.rule(
                    ".\(ClassName.branchLineAccess)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "var(--success-color, #2E8B57)"),
                    CSS.decl("stroke-width", "2.5"),
                    CSS.decl("stroke-dasharray", "6 5")
                ),

                CSS.rule(
                    ".\(ClassName.origin)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("z-index", "3"),
                    CSS.decl("width", "12px"),
                    CSS.decl("height", "12px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 70%, var(--link-color) 30%)"),
                    CSS.decl("box-shadow", "0 0 0 5px color-mix(in srgb, var(--text-color) 8%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.condition)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("z-index", "4"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("padding", "14px 16px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--text-color) 20%, var(--border-color))"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "var(--background-color, #fff)"),
                    CSS.decl("box-shadow", "0 10px 24px rgba(15, 23, 42, .065)")
                ),

                CSS.rule(
                    ".\(ClassName.conditionLabel)",
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "820"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.conditionTitle)",
                    CSS.decl("display", "block"),
                    CSS.decl("font-size", ".96rem"),
                    CSS.decl("line-height", "1.16"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.conditionDetail)",
                    CSS.decl("display", "block"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("line-height", "1.35"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.response)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("z-index", "4"),
                    CSS.decl("display", "grid"),
                    CSS.decl("align-content", "center"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("padding", "12px 13px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "15px"),
                    CSS.decl("background", "var(--background-color, #fff)"),
                    CSS.decl("box-shadow", "0 10px 24px rgba(15, 23, 42, .055)")
                ),

                CSS.rule(
                    ".\(ClassName.responseTarget)",
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 64%, var(--border-color))"),
                    CSS.decl("box-shadow", "0 0 0 3px color-mix(in srgb, var(--link-color) 16%, transparent), 0 12px 26px rgba(15, 23, 42, .07)")
                ),

                CSS.rule(
                    ".\(ClassName.responseAccess)",
                    CSS.decl("border-color", "color-mix(in srgb, var(--success-color, #2E8B57) 58%, var(--border-color))"),
                    CSS.decl("box-shadow", "0 0 0 3px color-mix(in srgb, var(--success-color, #2E8B57) 14%, transparent), 0 12px 26px rgba(15, 23, 42, .07)")
                ),

                CSS.rule(
                    ".\(ClassName.responseTitle)",
                    CSS.decl("display", "block"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.16"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.responseDetail)",
                    CSS.decl("display", "block"),
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("line-height", "1.32"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.relation)",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "stretch"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("width", "fit-content"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("padding", "10px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--background-color, #fff) 92%, var(--text-color) 8%)")
                ),

                CSS.rule(
                    ".\(ClassName.relation)[hidden]",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(ClassName.relationStep)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "3px"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("padding", "4px 6px")
                ),

                CSS.rule(
                    ".\(ClassName.relationLabel)",
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "820"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.relationStep) b",
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.2"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.relationArrow)",
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("font-weight", "800")
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
                        CSS.decl("border-radius", "18px")
                    ),

                    CSS.rule(
                        ".\(ClassName.scroller)",
                        CSS.decl("padding-bottom", "14px")
                    ),

                    CSS.rule(
                        ".\(ClassName.relation)",
                        CSS.decl("width", "100%"),
                        CSS.decl("display", "grid"),
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "4px")
                    ),

                    CSS.rule(
                        ".\(ClassName.relationArrow)",
                        CSS.decl("justify-content", "start"),
                        CSS.decl("padding-left", "6px")
                    )
                )
            ]
        )
    }
}
