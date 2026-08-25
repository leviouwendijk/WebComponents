import DSL
import Constructors
import HTML
import CSS

public struct MatrixDiagram:
    ComponentOutputProviding,
    SelectableComponent,
    Sendable
{
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-matrix"

    private enum Contribution:
        String,
        CSSContributionIdentifying
    {
        case styles =
            "webcomponents.shapes.matrix-diagram.styles"
    }

    public struct Selectors: Sendable {
        private let api = BlockSelectorAPI<Namespace>(
            block: MatrixDiagram.block
        )

        public init() {}

        public var wrap: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)-wrap")
        }

        public var root: HTMLClass<Namespace> {
            api.root
        }

        public var colHeaders: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)--colheaders")
        }

        public var rowHeaders: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)--rowheaders")
        }

        public var rootCrosshair: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)--crosshair")
        }

        public var cell: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)__cell")
        }

        public var cellEmpty: HTMLClass<Namespace> {
            HTMLClass("\(cell.rawValue)--empty")
        }

        public var cellHeader: HTMLClass<Namespace> {
            HTMLClass("\(cell.rawValue)--header")
        }

        public var label: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)__label")
        }

        public var crosshair: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)__crosshair")
        }

        public var axis: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)__axis")
        }

        public var axisX: HTMLClass<Namespace> {
            HTMLClass("\(axis.rawValue)--x")
        }

        public var axisY: HTMLClass<Namespace> {
            HTMLClass("\(axis.rawValue)--y")
        }
    }

    public static let selectors = Selectors()

    public enum Cell: Sendable {
        case empty
        case box(Box)
    }

    public let classes: [HTMLClassToken]
    public let attrs: HTMLAttribute

    public let columns: Int
    public let rows: Int
    public let cells: [[Cell]]

    public let columnHeaders: [Cell]?
    public let rowHeaders: [Cell]?
    public let cornerHeader: Cell?

    public let xAxisLabel: (@Sendable () -> HTMLFragment)?
    public let yAxisLabel: (@Sendable () -> HTMLFragment)?

    public let showsCrosshair: Bool

    public init(
        columns: Int,
        rows: Int,
        cells: [[Cell]],
        columnHeaders: [Cell]? = nil,
        rowHeaders: [Cell]? = nil,
        cornerHeader: Cell? = nil,
        xAxisLabel: (@Sendable () -> HTMLFragment)? = nil,
        yAxisLabel: (@Sendable () -> HTMLFragment)? = nil,
        showsCrosshair: Bool = false,
        classes: [HTMLClassToken] = [],
        attrs: HTMLAttribute = HTMLAttribute()
    ) {
        self.columns = max(0, columns)
        self.rows = max(0, rows)
        self.cells = cells

        self.columnHeaders = columnHeaders
        self.rowHeaders = rowHeaders
        self.cornerHeader = cornerHeader

        self.xAxisLabel = xAxisLabel
        self.yAxisLabel = yAxisLabel
        self.showsCrosshair = showsCrosshair

        self.classes = classes
        self.attrs = attrs
    }

    public var output: ComponentOutput {
        let s = selectors

        let hasColHeaders =
            columnHeaders?.isEmpty
                == false

        let hasRowHeaders =
            rowHeaders?.isEmpty
                == false

        var baseClasses:
            [AnyHTMLClass] =
                [
                    s.root.erased
                ]

        if hasColHeaders {
            baseClasses.append(
                s.colHeaders.erased
            )
        }

        if hasRowHeaders {
            baseClasses.append(
                s.rowHeaders.erased
            )
        }

        if showsCrosshair {
            baseClasses.append(
                s.rootCrosshair.erased
            )
        }

        var a =
            makeAttrs(
                baseClasses:
                    baseClasses,
                classes:
                    classes,
                attrs:
                    attrs
            )

        a.merge(
            .style(
                "--wc-matrix-cols: \(columns); --wc-matrix-rows: \(rows);"
            )
        )

        let childOutputs =
            renderedCellsInOrder()
                .compactMap {
                    cell
                        -> ComponentOutput?
                    in

                    guard
                        case .box(
                            let box
                        ) =
                            cell
                    else {
                        return nil
                    }

                    return
                        FlowBox(
                            box
                        )
                        .output
                }

        let childDependencies =
            childOutputs.reduce(
                ComponentDependencies.empty
            ) {
                partial,
                child in

                partial.merging(
                    child.dependencies
                )
            }

        let ownDependencies =
            ComponentDependencies(
                styles:
                    CSSContributions([
                        Self.styleContribution()
                    ])
            )

        return ComponentOutput(
            content:
                ComponentContent(
                    body: [
                        HTML.div(
                            .class(
                                s.wrap
                            )
                        ) {
                            if let yAxisLabel {
                                HTML.div(
                                    .class([
                                        s.axis,
                                        s.axisY
                                    ])
                                ) {
                                    yAxisLabel()
                                }
                            }

                            HTML.div(a) {
                                if hasColHeaders {
                                    if hasRowHeaders {
                                        renderCell(
                                            cornerHeader
                                                ?? .empty,
                                            wrapperClasses: [
                                                s.cell,
                                                s.cellHeader
                                            ]
                                        )
                                    }

                                    for h in columnHeaders ?? [] {
                                        renderCell(
                                            h,
                                            wrapperClasses: [
                                                s.cell,
                                                s.cellHeader
                                            ]
                                        )
                                    }
                                }

                                for r in 0..<rows {
                                    if hasRowHeaders {
                                        let rowHeader:
                                            Cell =
                                                (
                                                    rowHeaders?
                                                        .count
                                                        ?? 0
                                                )
                                                > r
                                                ? (
                                                    rowHeaders?[
                                                        r
                                                    ]
                                                    ?? .empty
                                                )
                                                : .empty

                                        renderCell(
                                            rowHeader,
                                            wrapperClasses: [
                                                s.cell,
                                                s.cellHeader
                                            ]
                                        )
                                    }

                                    let rowCells:
                                        [Cell] =
                                            cells.count
                                                > r
                                            ? cells[
                                                r
                                            ]
                                            : []

                                    for c in 0..<columns {
                                        let cell:
                                            Cell =
                                                rowCells.count
                                                    > c
                                                ? rowCells[
                                                    c
                                                ]
                                                : .empty

                                        renderCell(
                                            cell,
                                            wrapperClasses: [
                                                s.cell
                                            ]
                                        )
                                    }
                                }
                            }

                            if let xAxisLabel {
                                HTML.div(
                                    .class([
                                        s.axis,
                                        s.axisX
                                    ])
                                ) {
                                    xAxisLabel()
                                }
                            }
                        }
                    ]
                ),
            dependencies:
                childDependencies
                    .merging(
                        ownDependencies
                    )
        )
    }

    public var nodes: ReusableComponentNodes {
        let semantic =
            output

        let resolvedStyles:
            ResolvedCSSContributions

        do {
            resolvedStyles =
                try semantic
                    .dependencies
                    .styles
                    .resolve()
        } catch {
            preconditionFailure(
                "MatrixDiagram semantic CSS conflict: \(error)"
            )
        }

        return .body(
            semantic.content.body,
            stylesheets:
                resolvedStyles
                    .contributions
                    .map {
                        $0.content.sheet
                    },
            scripts:
                semantic
                    .dependencies
                    .scripts
                    .contributions
                    .map(\.script)
        )
    }

    @available(*, deprecated, message: "use nodes.body")
    public func html() -> HTMLFragment {
        nodes.body
    }

    @available(*, deprecated, message: "use nodes.stylesheets")
    public func styles() -> [CSSStyleSheet] {
        nodes.stylesheets
    }
}

extension MatrixDiagram {
    private func renderCell(
        _ cell: Cell,
        wrapperClasses: [HTMLClass<Namespace>]
    ) -> any HTMLNode {
        let s = selectors

        switch cell {
        case .empty:
            return HTML.div(
                .class(wrapperClasses + [s.cellEmpty])
            ) {}

        case .box(let b):
            let child =
                FlowBox(
                    b
                )
                .output

            return HTML.div(
                .class(
                    wrapperClasses
                )
            ) {
                child.content.body
            }
        }
    }

    private func renderedCellsInOrder()
        -> [Cell]
    {
        let hasColHeaders =
            columnHeaders?.isEmpty
                == false

        let hasRowHeaders =
            rowHeaders?.isEmpty
                == false

        var result:
            [Cell] =
                []

        if hasColHeaders {
            if hasRowHeaders {
                result.append(
                    cornerHeader
                        ?? .empty
                )
            }

            result.append(
                contentsOf:
                    columnHeaders
                        ?? []
            )
        }

        for r in 0..<rows {
            if hasRowHeaders {
                let rowHeader:
                    Cell =
                        (
                            rowHeaders?
                                .count
                                ?? 0
                        )
                        > r
                        ? (
                            rowHeaders?[
                                r
                            ]
                            ?? .empty
                        )
                        : .empty

                result.append(
                    rowHeader
                )
            }

            let rowCells:
                [Cell] =
                    cells.count
                        > r
                    ? cells[
                        r
                    ]
                    : []

            for c in 0..<columns {
                result.append(
                    rowCells.count
                        > c
                    ? rowCells[
                        c
                    ]
                    : .empty
                )
            }
        }

        return result
    }

    private func makeAttrs(
        baseClasses: [AnyHTMLClass],
        classes: [HTMLClassToken],
        attrs: HTMLAttribute
    ) -> HTMLAttribute {
        var out = HTMLAttribute.classes(
            base: baseClasses,
            appending: classes
        )
        out.merge(attrs)
        return out
    }

    private static func authoredStylesheet() -> CSSStyleSheet {
        let s = Self.selectors

        let wrap = s.wrap.rawValue
        let root = s.root.rawValue
        let rowHeaders = s.rowHeaders.rawValue
        let cell = s.cell.rawValue
        let cellEmpty = s.cellEmpty.rawValue
        let cellHeader = s.cellHeader.rawValue
        let crosshair = s.crosshair.rawValue
        let axis = s.axis.rawValue
        let axisX = s.axisX.rawValue
        let axisY = s.axisY.rawValue

        let flowLabelBox = FlowBox.selectors.box
            .compound(s.label)

        let flowLabelInner = flowLabelBox
            .descendant(FlowBox.selectors.boxInner)

        let flowLabelInnerSpan = flowLabelInner
            .descendant(CSSSelector.element("span"))

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(wrap)",
                    CSS.decl("position", "relative"),
                    CSS.decl("margin", "18px 0")
                ),

                CSS.rule(
                    ".\(root)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("align-items", "stretch"),
                    CSS.decl(
                        "grid-template-columns",
                        "repeat(var(--wc-matrix-cols, 2), minmax(160px, 1fr))"
                    )
                ),

                CSS.rule(
                    ".\(rowHeaders)",
                    CSS.decl(
                        "grid-template-columns",
                        "minmax(160px, 0.9fr) repeat(var(--wc-matrix-cols, 2), minmax(160px, 1fr))"
                    )
                ),

                CSS.rule(
                    ".\(cell)",
                    CSS.decl("display", "block")
                ),

                CSS.rule(
                    ".\(cellEmpty)",
                    CSS.decl("min-height", "56px")
                ),

                CSS.rule(
                    ".\(cellHeader)",
                    CSS.decl("opacity", "0.95")
                ),

                CSS.rule(
                    ".\(cellHeader)",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center")
                ),

                CSS.rule(
                    flowLabelBox,
                    CSS.decl("background", "transparent"),
                    CSS.decl("border", "0"),
                    CSS.decl("box-shadow", "none"),
                    CSS.decl("padding", "0"),
                    CSS.decl("min-width", "auto"),
                    CSS.decl("max-width", "none")
                ),

                CSS.rule(
                    flowLabelInner,
                    CSS.decl("min-height", "0"),
                    CSS.decl("gap", "4px")
                ),

                CSS.rule(
                    flowLabelInnerSpan,
                    CSS.decl(
                        "color",
                        "var(--ref-meta-text-color, var(--text-color, #0f172a))"
                    )
                ),

                // CSS.rule(
                //     ".wc-flow__box.wc-matrix__label",
                //     CSS.decl("background", "transparent"),
                //     CSS.decl("border", "0"),
                //     CSS.decl("box-shadow", "none"),
                //     CSS.decl("padding", "0"),
                //     CSS.decl("min-width", "auto"),
                //     CSS.decl("max-width", "none")
                // ),

                // CSS.rule(
                //     ".wc-flow__box.wc-matrix__label .wc-flow__box-inner",
                //     CSS.decl("min-height", "0"),
                //     CSS.decl("gap", "4px")
                // ),

                // CSS.rule(
                //     ".wc-flow__box.wc-matrix__label .wc-flow__box-inner span",
                //     CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))")
                // ),

                CSS.rule(
                    ".\(cell)",
                    CSS.decl("position", "relative"),
                    CSS.decl("z-index", "1")
                ),

                CSS.rule(
                    ".\(crosshair)",
                    CSS.decl("position", "relative"),
                    CSS.decl("pointer-events", "none"),
                    CSS.decl("z-index", "0")
                ),

                CSS.rule(
                    ".\(crosshair)::before",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "50%"),
                    CSS.decl("top", "0"),
                    CSS.decl("transform", "translateX(-50%)"),
                    CSS.decl("width", "1px"),
                    CSS.decl("height", "100%"),
                    CSS.decl("background", "var(--border-color, rgba(0,0,0,0.12))")
                ),

                CSS.rule(
                    ".\(crosshair)::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "0"),
                    CSS.decl("top", "50%"),
                    CSS.decl("transform", "translateY(-50%)"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "1px"),
                    CSS.decl("background", "var(--border-color, rgba(0,0,0,0.12))")
                ),

                CSS.rule(
                    ".\(axis)",
                    CSS.decl("font-size", "0.95rem"),
                    CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".\(axisX)",
                    CSS.decl("text-align", "center"),
                    CSS.decl("margin-top", "10px")
                ),

                CSS.rule(
                    ".\(axisY)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "-10px"),
                    CSS.decl("top", "50%"),
                    CSS.decl("transform", "translate(-100%, -50%) rotate(-90deg)"),
                    CSS.decl("transform-origin", "center")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 900px)",
                    CSS.rule(
                        ".\(root)",
                        CSS.decl("gap", "12px"),
                        CSS.decl(
                            "grid-template-columns",
                            "repeat(var(--wc-matrix-cols, 2), minmax(148px, 1fr))"
                        )
                    ),
                    CSS.rule(
                        ".\(rowHeaders)",
                        CSS.decl(
                            "grid-template-columns",
                            "minmax(148px, 0.9fr) repeat(var(--wc-matrix-cols, 2), minmax(148px, 1fr))"
                        )
                    ),
                    CSS.rule(
                        ".\(axisY)",
                        CSS.decl("position", "static"),
                        CSS.decl("transform", "none"),
                        CSS.decl("margin-bottom", "10px"),
                        CSS.decl("text-align", "center")
                    )
                ),

                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".\(wrap)",
                        CSS.decl("overflow-x", "auto")
                    ),
                    CSS.rule(
                        ".\(root)",
                        CSS.decl("overflow-x", "auto"),
                        CSS.decl("justify-content", "flex-start"),
                        CSS.decl("padding-bottom", "6px")
                    ),
                    CSS.rule(
                        ".\(axisX)",
                        CSS.decl("margin-top", "8px")
                    )
                )
            ]
        )
    }
    private static func styleContribution() -> CSSContribution {
        let sheet = authoredStylesheet()

        let units =
            sheet.rules.map {
                CSSContributionUnit.block(
                    .rule($0)
                )
            }
            + sheet.media.map {
                CSSContributionUnit.block(
                    .media($0)
                )
            }
            + sheet.keyframes.map {
                CSSContributionUnit.block(
                    .keyframes($0)
                )
            }

        return CSS.contribution(
            Contribution.styles
        ) {
            units
        }
    }

    public static func css() -> CSSStyleSheet {
        styleContribution().content.sheet
    }

}

// public struct MatrixDiagram: WebComponent {
//     public enum Cell: Sendable {
//         case empty
//         case box(Box)
//     }

//     public let classes: [String]
//     public let attrs: HTMLAttribute

//     public let columns: Int
//     public let rows: Int
//     public let cells: [[Cell]]

//     public let columnHeaders: [Cell]?
//     public let rowHeaders: [Cell]?
//     public let cornerHeader: Cell?

//     public let xAxisLabel: (@Sendable () -> HTMLFragment)?
//     public let yAxisLabel: (@Sendable () -> HTMLFragment)?

//     public let showsCrosshair: Bool

//     public init(
//         columns: Int,
//         rows: Int,
//         cells: [[Cell]],
//         columnHeaders: [Cell]? = nil,
//         rowHeaders: [Cell]? = nil,
//         cornerHeader: Cell? = nil,
//         xAxisLabel: (@Sendable () -> HTMLFragment)? = nil,
//         yAxisLabel: (@Sendable () -> HTMLFragment)? = nil,
//         showsCrosshair: Bool = false,
//         classes: [String] = [],
//         attrs: HTMLAttribute = HTMLAttribute()
//     ) {
//         self.columns = max(0, columns)
//         self.rows = max(0, rows)
//         self.cells = cells

//         self.columnHeaders = columnHeaders
//         self.rowHeaders = rowHeaders
//         self.cornerHeader = cornerHeader

//         self.xAxisLabel = xAxisLabel
//         self.yAxisLabel = yAxisLabel
//         self.showsCrosshair = showsCrosshair

//         self.classes = classes
//         self.attrs = attrs
//     }

//     public func html() -> HTMLFragment {
//         let hasColHeaders = (columnHeaders?.isEmpty == false)
//         let hasRowHeaders = (rowHeaders?.isEmpty == false)

//         var baseClasses: [String] = ["wc-matrix"]
//         if hasColHeaders { baseClasses.append("wc-matrix--colheaders") }
//         if hasRowHeaders { baseClasses.append("wc-matrix--rowheaders") }
//         if showsCrosshair { baseClasses.append("wc-matrix--crosshair") }

//         var a = makeAttrs(
//             baseClasses: baseClasses + classes,
//             attrs: attrs
//         )

//         a.merge(
//             .style(
//                 "--wc-matrix-cols: \(columns); --wc-matrix-rows: \(rows);"
//             )
//         )

//         return [
//             HTML.div(.class(["wc-matrix-wrap"])) {
//                 if let yAxisLabel {
//                     HTML.div(.class(["wc-matrix__axis", "wc-matrix__axis--y"])) {
//                         yAxisLabel()
//                     }
//                 }

//                 HTML.div(a) {
//                     if hasColHeaders {
//                         if hasRowHeaders {
//                             renderCell(
//                                 cornerHeader ?? .empty,
//                                 wrapperClasses: ["wc-matrix__cell", "wc-matrix__cell--header"]
//                             )
//                         }

//                         for h in (columnHeaders ?? []) {
//                             renderCell(
//                                 h,
//                                 wrapperClasses: ["wc-matrix__cell", "wc-matrix__cell--header"]
//                             )
//                         }
//                     }

//                     for r in 0..<rows {
//                         if hasRowHeaders {
//                             let rh: Cell = (rowHeaders?.count ?? 0) > r ? (rowHeaders?[r] ?? .empty) : .empty
//                             renderCell(
//                                 rh,
//                                 wrapperClasses: ["wc-matrix__cell", "wc-matrix__cell--header"]
//                             )
//                         }

//                         let rowCells: [Cell] = (cells.count > r) ? cells[r] : []
//                         for c in 0..<columns {
//                             let cell: Cell = (rowCells.count > c) ? rowCells[c] : .empty
//                             renderCell(
//                                 cell,
//                                 wrapperClasses: ["wc-matrix__cell"]
//                             )
//                         }
//                     }

//                     // if showsCrosshair {
//                     //     let dataColStart = (hasRowHeaders ? 2 : 1)
//                     //     let dataColEnd   = dataColStart + columns

//                     //     let dataRowStart = (hasColHeaders ? 2 : 1)
//                     //     let dataRowEnd   = dataRowStart + rows

//                     //     HTML.div(
//                     //         HTML.attrs(
//                     //             .class(["wc-matrix__crosshair"]),
//                     //             [
//                     //                 "style":
//                     //                     "grid-column: \(dataColStart) / \(dataColEnd); grid-row: \(dataRowStart) / \(dataRowEnd);"
//                     //             ]
//                     //         )
//                     //     ) { [] }
//                     // }
//                 }

//                 if let xAxisLabel {
//                     HTML.div(.class(["wc-matrix__axis", "wc-matrix__axis--x"])) {
//                         xAxisLabel()
//                     }
//                 }
//             }
//         ]
//     }

//     public func styles() -> [CSSStyleSheet] {
//         [Self.css()]
//     }
// }

// extension MatrixDiagram {
//     private func renderCell(
//         _ cell: Cell,
//         wrapperClasses: [String]
//     ) -> any HTMLNode {
//         switch cell {
//         case .empty:
//             return HTML.div(.class(wrapperClasses + ["wc-matrix__cell--empty"])) {}

//         case .box(let b):
//             return HTML.div(.class(wrapperClasses)) {
//                 // Emit EXACT same markup/classes as FlowDiagram’s boxHTML,
//                 // so you reuse existing .wc-flow__box CSS without touching FlowDiagram.
//                 boxHTML(b)
//             }
//         }
//     }

//     private func boxHTML(_ b: Box) -> any HTMLNode {
//         let alignClass: String = {
//             switch b.align {
//             case .center: return "wc-flow__box--center"
//             case .start:  return "wc-flow__box--start"
//             }
//         }()

//         let a = makeAttrs(
//             baseClasses: ["wc-flow__box", alignClass] + b.classes,
//             attrs: b.attrs
//         )

//         return HTML.div(a) {
//             HTML.div(.class(["wc-flow__box-inner"])) {
//                 b.content()
//             }
//         }
//     }

//     private func makeAttrs(
//         baseClasses: [String],
//         attrs: HTMLAttribute
//     ) -> HTMLAttribute {
//         var out = HTMLAttribute()
//         out.merge(.class(normalizeClasses(baseClasses)))
//         out.merge(attrs)
//         return out
//     }

//     private func normalizeClasses(_ parts: [String]) -> [String] {
//         parts
//             .flatMap { $0.split(separator: " ").map(String.init) }
//             .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
//             .filter { !$0.isEmpty }
//     }

//     public static func css() -> CSSStyleSheet {
//         CSSStyleSheet(
//             rules: [
//                 CSS.rule(
//                     ".wc-matrix-wrap",
//                     CSS.decl("position", "relative"),
//                     CSS.decl("margin", "18px 0")
//                 ),

//                 CSS.rule(
//                     ".wc-matrix",
//                     CSS.decl("position", "relative"),
//                     CSS.decl("display", "grid"),
//                     CSS.decl("gap", "14px"),
//                     CSS.decl("justify-content", "center"),
//                     CSS.decl("align-items", "stretch"),
//                     CSS.decl(
//                         "grid-template-columns",
//                         "repeat(var(--wc-matrix-cols, 2), minmax(160px, 1fr))"
//                     )
//                 ),

//                 CSS.rule(
//                     ".wc-matrix--rowheaders",
//                     CSS.decl(
//                         "grid-template-columns",
//                         "minmax(160px, 0.9fr) repeat(var(--wc-matrix-cols, 2), minmax(160px, 1fr))"
//                     )
//                 ),

//                 CSS.rule(
//                     ".wc-matrix__cell",
//                     CSS.decl("display", "block")
//                 ),

//                 CSS.rule(
//                     ".wc-matrix__cell--empty",
//                     CSS.decl("min-height", "56px")
//                 ),

//                 CSS.rule(
//                     ".wc-matrix__cell--header",
//                     CSS.decl("opacity", "0.95")
//                 ),

//                 CSS.rule(
//                     ".wc-matrix__cell--header",
//                     CSS.decl("display", "flex"),
//                     CSS.decl("align-items", "center"),
//                     CSS.decl("justify-content", "center")
//                 ),

//                 CSS.rule(
//                     ".wc-flow__box.wc-matrix__label",
//                     CSS.decl("background", "transparent"),
//                     CSS.decl("border", "0"),
//                     CSS.decl("box-shadow", "none"),
//                     CSS.decl("padding", "0"),
//                     CSS.decl("min-width", "auto"),
//                     CSS.decl("max-width", "none")
//                 ),

//                 CSS.rule(
//                     ".wc-flow__box.wc-matrix__label .wc-flow__box-inner",
//                     CSS.decl("min-height", "0"),
//                     CSS.decl("gap", "4px")
//                 ),

//                 CSS.rule(
//                     ".wc-flow__box.wc-matrix__label .wc-flow__box-inner span",
//                     CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))")
//                 ),

//                 // CSS.rule(
//                 //     ".wc-matrix--crosshair::before",
//                 //     CSS.decl("content", "\"\""),
//                 //     CSS.decl("position", "absolute"),
//                 //     CSS.decl("left", "50%"),
//                 //     CSS.decl("top", "0"),
//                 //     CSS.decl("transform", "translateX(-50%)"),
//                 //     CSS.decl("width", "1px"),
//                 //     CSS.decl("height", "100%"),
//                 //     CSS.decl("background", "var(--border-color, rgba(0,0,0,0.12))"),
//                 //     CSS.decl("pointer-events", "none")
//                 // ),

//                 // CSS.rule(
//                 //     ".wc-matrix--crosshair::after",
//                 //     CSS.decl("content", "\"\""),
//                 //     CSS.decl("position", "absolute"),
//                 //     CSS.decl("left", "0"),
//                 //     CSS.decl("top", "50%"),
//                 //     CSS.decl("transform", "translateY(-50%)"),
//                 //     CSS.decl("width", "100%"),
//                 //     CSS.decl("height", "1px"),
//                 //     CSS.decl("background", "var(--border-color, rgba(0,0,0,0.12))"),
//                 //     CSS.decl("pointer-events", "none")
//                 // ),

//                 CSS.rule(
//                     ".wc-matrix__cell",
//                     CSS.decl("position", "relative"),
//                     CSS.decl("z-index", "1")
//                 ),

//                 CSS.rule(
//                     ".wc-matrix__crosshair",
//                     CSS.decl("position", "relative"),
//                     CSS.decl("pointer-events", "none"),
//                     CSS.decl("z-index", "0")
//                 ),

//                 CSS.rule(
//                     ".wc-matrix__crosshair::before",
//                     CSS.decl("content", "\"\""),
//                     CSS.decl("position", "absolute"),
//                     CSS.decl("left", "50%"),
//                     CSS.decl("top", "0"),
//                     CSS.decl("transform", "translateX(-50%)"),
//                     CSS.decl("width", "1px"),
//                     CSS.decl("height", "100%"),
//                     CSS.decl("background", "var(--border-color, rgba(0,0,0,0.12))")
//                 ),

//                 CSS.rule(
//                     ".wc-matrix__crosshair::after",
//                     CSS.decl("content", "\"\""),
//                     CSS.decl("position", "absolute"),
//                     CSS.decl("left", "0"),
//                     CSS.decl("top", "50%"),
//                     CSS.decl("transform", "translateY(-50%)"),
//                     CSS.decl("width", "100%"),
//                     CSS.decl("height", "1px"),
//                     CSS.decl("background", "var(--border-color, rgba(0,0,0,0.12))")
//                 ),

//                 CSS.rule(
//                     ".wc-matrix__axis",
//                     CSS.decl("font-size", "0.95rem"),
//                     CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))"),
//                     CSS.decl("line-height", "1.2")
//                 ),

//                 CSS.rule(
//                     ".wc-matrix__axis--x",
//                     CSS.decl("text-align", "center"),
//                     CSS.decl("margin-top", "10px")
//                 ),

//                 CSS.rule(
//                     ".wc-matrix__axis--y",
//                     CSS.decl("position", "absolute"),
//                     CSS.decl("left", "-10px"),
//                     CSS.decl("top", "50%"),
//                     CSS.decl("transform", "translate(-100%, -50%) rotate(-90deg)"),
//                     CSS.decl("transform-origin", "center")
//                 )
//             ],
//             media: [
//                 CSS.media(
//                     "(max-width: 900px)",
//                     CSS.rule(
//                         ".wc-matrix",
//                         CSS.decl("gap", "12px"),
//                         CSS.decl("grid-template-columns", "repeat(var(--wc-matrix-cols, 2), minmax(148px, 1fr))")
//                     ),
//                     CSS.rule(
//                         ".wc-matrix--rowheaders",
//                         CSS.decl(
//                             "grid-template-columns",
//                             "minmax(148px, 0.9fr) repeat(var(--wc-matrix-cols, 2), minmax(148px, 1fr))"
//                         )
//                     ),
//                     CSS.rule(
//                         ".wc-matrix__axis--y",
//                         CSS.decl("position", "static"),
//                         CSS.decl("transform", "none"),
//                         CSS.decl("margin-bottom", "10px"),
//                         CSS.decl("text-align", "center")
//                     )
//                 ),

//                 CSS.media(
//                     "(max-width: 640px)",
//                     CSS.rule(
//                         ".wc-matrix-wrap",
//                         CSS.decl("overflow-x", "auto")
//                     ),
//                     CSS.rule(
//                         ".wc-matrix",
//                         CSS.decl("overflow-x", "auto"),
//                         CSS.decl("justify-content", "flex-start"),
//                         CSS.decl("padding-bottom", "6px")
//                     ),
//                     CSS.rule(
//                         ".wc-matrix__axis--x",
//                         CSS.decl("margin-top", "8px")
//                     )
//                 )
//             ]
//         )
//     }
// }
