import Constructors
import HTML
import CSS

public struct MatrixDiagram: WebComponent {
    public enum Cell: Sendable {
        case empty
        case box(Box)
    }

    public let classes: [String]
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
        classes: [String] = [],
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

    public func html() -> HTMLFragment {
        let hasColHeaders = (columnHeaders?.isEmpty == false)
        let hasRowHeaders = (rowHeaders?.isEmpty == false)

        var baseClasses: [String] = ["wc-matrix"]
        if hasColHeaders { baseClasses.append("wc-matrix--colheaders") }
        if hasRowHeaders { baseClasses.append("wc-matrix--rowheaders") }
        if showsCrosshair { baseClasses.append("wc-matrix--crosshair") }

        var a = makeAttrs(
            baseClasses: baseClasses + classes,
            attrs: attrs
        )

        a.merge(
            .style(
                "--wc-matrix-cols: \(columns); --wc-matrix-rows: \(rows);"
            )
        )

        return [
            HTML.div(.class(["wc-matrix-wrap"])) {
                if let yAxisLabel {
                    HTML.div(.class(["wc-matrix__axis", "wc-matrix__axis--y"])) {
                        yAxisLabel()
                    }
                }

                HTML.div(a) {
                    if hasColHeaders {
                        if hasRowHeaders {
                            renderCell(
                                cornerHeader ?? .empty,
                                wrapperClasses: ["wc-matrix__cell", "wc-matrix__cell--header"]
                            )
                        }

                        for h in (columnHeaders ?? []) {
                            renderCell(
                                h,
                                wrapperClasses: ["wc-matrix__cell", "wc-matrix__cell--header"]
                            )
                        }
                    }

                    for r in 0..<rows {
                        if hasRowHeaders {
                            let rh: Cell = (rowHeaders?.count ?? 0) > r ? (rowHeaders?[r] ?? .empty) : .empty
                            renderCell(
                                rh,
                                wrapperClasses: ["wc-matrix__cell", "wc-matrix__cell--header"]
                            )
                        }

                        let rowCells: [Cell] = (cells.count > r) ? cells[r] : []
                        for c in 0..<columns {
                            let cell: Cell = (rowCells.count > c) ? rowCells[c] : .empty
                            renderCell(
                                cell,
                                wrapperClasses: ["wc-matrix__cell"]
                            )
                        }
                    }
                }

                if let xAxisLabel {
                    HTML.div(.class(["wc-matrix__axis", "wc-matrix__axis--x"])) {
                        xAxisLabel()
                    }
                }
            }
        ]
    }

    public func styles() -> [CSSStyleSheet] {
        [Self.css()]
    }
}

extension MatrixDiagram {
    private func renderCell(
        _ cell: Cell,
        wrapperClasses: [String]
    ) -> any HTMLNode {
        switch cell {
        case .empty:
            return HTML.div(.class(wrapperClasses + ["wc-matrix__cell--empty"])) {}

        case .box(let b):
            return HTML.div(.class(wrapperClasses)) {
                // Emit EXACT same markup/classes as FlowDiagram’s boxHTML,
                // so you reuse existing .wc-flow__box CSS without touching FlowDiagram.
                boxHTML(b)
            }
        }
    }

    private func boxHTML(_ b: Box) -> any HTMLNode {
        let alignClass: String = {
            switch b.align {
            case .center: return "wc-flow__box--center"
            case .start:  return "wc-flow__box--start"
            }
        }()

        let a = makeAttrs(
            baseClasses: ["wc-flow__box", alignClass] + b.classes,
            attrs: b.attrs
        )

        return HTML.div(a) {
            HTML.div(.class(["wc-flow__box-inner"])) {
                b.content()
            }
        }
    }

    private func makeAttrs(
        baseClasses: [String],
        attrs: HTMLAttribute
    ) -> HTMLAttribute {
        var out = HTMLAttribute()
        out.merge(.class(normalizeClasses(baseClasses)))
        out.merge(attrs)
        return out
    }

    private func normalizeClasses(_ parts: [String]) -> [String] {
        parts
            .flatMap { $0.split(separator: " ").map(String.init) }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    public static func css() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-matrix-wrap",
                    CSS.decl("position", "relative"),
                    CSS.decl("margin", "18px 0")
                ),

                CSS.rule(
                    ".wc-matrix",
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
                    ".wc-matrix--rowheaders",
                    CSS.decl(
                        "grid-template-columns",
                        "minmax(160px, 0.9fr) repeat(var(--wc-matrix-cols, 2), minmax(160px, 1fr))"
                    )
                ),

                CSS.rule(
                    ".wc-matrix__cell",
                    CSS.decl("display", "block")
                ),

                CSS.rule(
                    ".wc-matrix__cell--empty",
                    CSS.decl("min-height", "56px")
                ),

                CSS.rule(
                    ".wc-matrix__cell--header",
                    CSS.decl("opacity", "0.95")
                ),

                CSS.rule(
                    ".wc-matrix--crosshair::before",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "50%"),
                    CSS.decl("top", "0"),
                    CSS.decl("transform", "translateX(-50%)"),
                    CSS.decl("width", "1px"),
                    CSS.decl("height", "100%"),
                    CSS.decl("background", "var(--border-color, rgba(0,0,0,0.12))"),
                    CSS.decl("pointer-events", "none")
                ),

                CSS.rule(
                    ".wc-matrix--crosshair::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "0"),
                    CSS.decl("top", "50%"),
                    CSS.decl("transform", "translateY(-50%)"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "1px"),
                    CSS.decl("background", "var(--border-color, rgba(0,0,0,0.12))"),
                    CSS.decl("pointer-events", "none")
                ),

                CSS.rule(
                    ".wc-matrix__axis",
                    CSS.decl("font-size", "0.95rem"),
                    CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".wc-matrix__axis--x",
                    CSS.decl("text-align", "center"),
                    CSS.decl("margin-top", "10px")
                ),

                CSS.rule(
                    ".wc-matrix__axis--y",
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
                        ".wc-matrix",
                        CSS.decl("gap", "12px"),
                        CSS.decl("grid-template-columns", "repeat(var(--wc-matrix-cols, 2), minmax(148px, 1fr))")
                    ),
                    CSS.rule(
                        ".wc-matrix--rowheaders",
                        CSS.decl(
                            "grid-template-columns",
                            "minmax(148px, 0.9fr) repeat(var(--wc-matrix-cols, 2), minmax(148px, 1fr))"
                        )
                    ),
                    CSS.rule(
                        ".wc-matrix__axis--y",
                        CSS.decl("position", "static"),
                        CSS.decl("transform", "none"),
                        CSS.decl("margin-bottom", "10px"),
                        CSS.decl("text-align", "center")
                    )
                ),

                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".wc-matrix-wrap",
                        CSS.decl("overflow-x", "auto")
                    ),
                    CSS.rule(
                        ".wc-matrix",
                        CSS.decl("overflow-x", "auto"),
                        CSS.decl("justify-content", "flex-start"),
                        CSS.decl("padding-bottom", "6px")
                    ),
                    CSS.rule(
                        ".wc-matrix__axis--x",
                        CSS.decl("margin-top", "8px")
                    )
                )
            ]
        )
    }
}

