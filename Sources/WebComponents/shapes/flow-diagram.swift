import Constructors
import HTML
import CSS

public enum BoxAlign: Sendable {
    case center
    case start
}

public enum Item: Sendable {
    case box(Box)
    case arrow(Arrow)
}

public struct Box: Sendable {
    public let classes: [String]
    public let attrs: HTMLAttribute
    public let align: BoxAlign
    public let content: @Sendable () -> HTMLFragment

    public init(
        classes: [String] = [],
        attrs: HTMLAttribute = HTMLAttribute(),
        align: BoxAlign = .center,
        content: @escaping @Sendable () -> HTMLFragment
    ) {
        self.classes = classes
        self.attrs = attrs
        self.align = align
        self.content = content
    }
}

public struct Arrow: Sendable {
    public let classes: [String]
    public let attrs: HTMLAttribute
    public let label: String?

    public init(
        classes: [String] = [],
        attrs: HTMLAttribute = HTMLAttribute(),
        label: String? = nil
    ) {
        self.classes = classes
        self.attrs = attrs
        self.label = label
    }
}

public enum DiagramPrimitives {
    public static func makeAttrs(
        baseClasses: [String],
        attrs: HTMLAttribute
    ) -> HTMLAttribute {
        var out = HTMLAttribute()
        out.merge(.class(normalizeClasses(baseClasses)))
        out.merge(attrs)
        return out
    }

    public static func normalizeClasses(_ parts: [String]) -> [String] {
        parts
            .flatMap { $0.split(separator: " ").map(String.init) }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    public static func boxHTML(
        _ b: Box,
        baseClass: String = "wc-diagram__box",
        innerClass: String = "wc-diagram__box-inner",
        alignCenterClass: String = "wc-diagram__box--center",
        alignStartClass: String = "wc-diagram__box--start"
    ) -> any HTMLNode {
        let alignClass: String = {
            switch b.align {
            case .center: return alignCenterClass
            case .start:  return alignStartClass
            }
        }()

        let a = makeAttrs(
            baseClasses: [baseClass, alignClass] + b.classes,
            attrs: b.attrs
        )

        return HTML.div(a) {
            HTML.div(.class([innerClass])) {
                b.content()
            }
        }
    }

    public static func arrowHTML(
        _ ar: Arrow,
        arrowWrapClass: String = "wc-diagram__arrow-wrap",
        arrowClass: String = "wc-diagram__arrow",
        labelClass: String = "wc-diagram__arrow-label"
    ) -> any HTMLNode {
        // aria-hidden default (append-only; if you add your own aria-hidden you’ll get duplicates)
        var finalAttrs = HTMLAttribute()
        finalAttrs.merge(.aria("hidden", "true"))
        finalAttrs.merge(ar.attrs)

        let a = makeAttrs(
            baseClasses: [arrowClass] + ar.classes,
            attrs: finalAttrs
        )

        return HTML.div(.class([arrowWrapClass])) {
            HTML.span(a) {}

            if let label = ar.label, !label.isEmpty {
                HTML.span(.class([labelClass])) {
                    HTML.text(label)
                }
            }
        }
    }
}

public enum DiagramSharedStyles {
    public static func css() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                // ----- Box surface (alias old flow classes too) -----

                CSS.rule(
                    ".wc-diagram__box, .wc-flow__box",
                    CSS.decl("background", "var(--background-color, #fff)"),
                    CSS.decl("color", "var(--text-color, #0f172a)"),
                    CSS.decl("border", "1px solid var(--border-color, rgba(0,0,0,0.12))"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("box-shadow", "var(--shadow-soft, 0 12px 28px rgba(0,0,0,0.08))"),
                    CSS.decl("padding", "14px 16px"),
                    CSS.decl("min-width", "160px"),
                    CSS.decl("max-width", "320px")
                ),

                CSS.rule(
                    ".dark-mode .wc-diagram__box, .dark-mode .wc-flow__box",
                    CSS.decl("background", "var(--submenu-bg-color, var(--background-color, #1e1e1e))")
                ),

                CSS.rule(
                    ".wc-diagram__box-inner, .wc-flow__box-inner",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("min-height", "56px")
                ),

                CSS.rule(
                    ".wc-diagram__box-inner b, .wc-diagram__box-inner strong, .wc-flow__box-inner b, .wc-flow__box-inner strong",
                    CSS.decl("color", "var(--text-color, #0f172a)"),
                    CSS.decl("font-weight", "700")
                ),

                CSS.rule(
                    ".wc-diagram__box-inner span, .wc-diagram__box-inner p, .wc-flow__box-inner span, .wc-flow__box-inner p",
                    CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))")
                ),

                CSS.rule(
                    ".wc-diagram__box--center .wc-diagram__box-inner, .wc-flow__box--center .wc-flow__box-inner",
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("text-align", "center")
                ),

                CSS.rule(
                    ".wc-diagram__box--start .wc-diagram__box-inner, .wc-flow__box--start .wc-flow__box-inner",
                    CSS.decl("align-items", "flex-start"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("text-align", "left")
                ),

                // ----- Arrow (alias old flow classes too) -----

                CSS.rule(
                    ".wc-diagram__arrow-wrap, .wc-flow__arrow-wrap",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("min-width", "48px")
                ),

                CSS.rule(
                    ".wc-diagram__arrow, .wc-flow__arrow",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "inline-block"),
                    CSS.decl("width", "54px"),
                    CSS.decl("height", "2px"),
                    CSS.decl("color", "var(--flow-arrow-color, var(--text-color, #0f172a))"),
                    CSS.decl("background", "currentColor"),
                    CSS.decl("border-radius", "999px")
                ),

                CSS.rule(
                    ".wc-diagram__arrow::after, .wc-flow__arrow::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("right", "-1px"),
                    CSS.decl("top", "50%"),
                    CSS.decl("transform", "translateY(-50%)"),
                    CSS.decl("width", "0"),
                    CSS.decl("height", "0"),
                    CSS.decl("border-top", "7px solid transparent"),
                    CSS.decl("border-bottom", "7px solid transparent"),
                    CSS.decl("border-left", "10px solid currentColor")
                ),

                CSS.rule(
                    ".wc-diagram__arrow-label, .wc-flow__arrow-label",
                    CSS.decl("font-size", "0.9rem"),
                    CSS.decl(
                        "color",
                        "var(--flow-label-color, var(--ref-meta-text-color, var(--text-color, #0f172a)))"
                    ),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("text-align", "center"),
                    CSS.decl("max-width", "180px")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 900px)",
                    CSS.rule(
                        ".wc-diagram__box, .wc-flow__box",
                        CSS.decl("min-width", "148px"),
                        CSS.decl("max-width", "280px")
                    ),
                    CSS.rule(
                        ".wc-diagram__arrow, .wc-flow__arrow",
                        CSS.decl("width", "48px")
                    )
                ),

                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".wc-diagram__arrow, .wc-flow__arrow",
                        CSS.decl("width", "32px")
                    ),
                    CSS.rule(
                        ".wc-diagram__box, .wc-flow__box",
                        CSS.decl("min-width", "132px"),
                        CSS.decl("max-width", "240px"),
                        CSS.decl("padding", "12px 12px")
                    ),
                    CSS.rule(
                        ".wc-diagram__box-inner, .wc-flow__box-inner",
                        CSS.decl("min-height", "48px"),
                        CSS.decl("gap", "5px")
                    ),
                    CSS.rule(
                        ".wc-diagram__arrow-wrap, .wc-flow__arrow-wrap",
                        CSS.decl("min-width", "30px")
                    ),
                    CSS.rule(
                        ".wc-diagram__box-inner, .wc-diagram__arrow-label, .wc-flow__box-inner, .wc-flow__arrow-label",
                        CSS.decl("font-size", "0.95rem")
                    )
                )
            ]
        )
    }
}

// MARK: - FlowDiagram (unchanged behavior, now uses shared primitives)

public struct FlowDiagram: WebComponent {
    public enum Axis: Sendable {
        case row
        case column
    }

    public let axis: Axis
    public let classes: [String]
    public let attrs: HTMLAttribute
    public let items: [Item]

    public init(
        axis: Axis = .row,
        classes: [String] = [],
        attrs: HTMLAttribute = HTMLAttribute(),
        items: [Item]
    ) {
        self.axis = axis
        self.classes = classes
        self.attrs = attrs
        self.items = items
    }

    public func html() -> HTMLFragment {
        let axisClass = (axis == .row) ? "wc-flow--row" : "wc-flow--col"
        let a = DiagramPrimitives.makeAttrs(
            baseClasses: ["wc-flow", axisClass] + classes,
            attrs: attrs
        )

        return [
            HTML.div(a) {
                for item in items {
                    switch item {
                    case .box(let b):
                        DiagramPrimitives.boxHTML(
                            b,
                            baseClass: "wc-flow__box",
                            innerClass: "wc-flow__box-inner",
                            alignCenterClass: "wc-flow__box--center",
                            alignStartClass: "wc-flow__box--start"
                        )

                    case .arrow(let ar):
                        DiagramPrimitives.arrowHTML(
                            ar,
                            arrowWrapClass: "wc-flow__arrow-wrap",
                            arrowClass: "wc-flow__arrow",
                            labelClass: "wc-flow__arrow-label"
                        )
                    }
                }
            }
        ]
    }

    public func styles() -> [CSSStyleSheet] {
        [
            DiagramSharedStyles.css(),
            Self.css()
        ]
    }
}

extension FlowDiagram {
    public static func css() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-flow",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("margin", "18px 0"),
                    CSS.decl("flex-wrap", "wrap")
                ),

                CSS.rule(
                    ".wc-flow--row",
                    CSS.decl("flex-direction", "row")
                ),

                CSS.rule(
                    ".wc-flow--col",
                    CSS.decl("flex-direction", "column")
                ),

                CSS.rule(
                    ".wc-flow--col .wc-flow__arrow",
                    CSS.decl("transform", "rotate(90deg)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".wc-flow",
                        CSS.decl("gap", "10px")
                    )
                )
            ]
        )
    }
}

// MARK: - MatrixDiagram (grid / quadrant capable)

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

    // Optional header rails
    public let columnHeaders: [Cell]?
    public let rowHeaders: [Cell]?
    public let cornerHeader: Cell?

    // Optional axis captions
    public let xAxisLabel: (@Sendable () -> HTMLFragment)?
    public let yAxisLabel: (@Sendable () -> HTMLFragment)?

    // Optional quadrant crosshair (useful for 2x2)
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

        var a = DiagramPrimitives.makeAttrs(
            baseClasses: baseClasses + classes,
            attrs: attrs
        )

        // Pass grid dimensions as CSS custom properties
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
                    // Top header row
                    if hasColHeaders {
                        if hasRowHeaders {
                            Self.renderCell(cornerHeader ?? .empty, extraClasses: ["wc-matrix__cell", "wc-matrix__cell--header"])
                        }

                        for c in (columnHeaders ?? []) {
                            Self.renderCell(c, extraClasses: ["wc-matrix__cell", "wc-matrix__cell--header"])
                        }
                    }

                    // Data rows (+ optional row header at row start)
                    for r in 0..<rows {
                        if hasRowHeaders {
                            let rh = (rowHeaders?.count ?? 0) > r ? rowHeaders?[r] ?? .empty : .empty
                            Self.renderCell(rh, extraClasses: ["wc-matrix__cell", "wc-matrix__cell--header"])
                        }

                        let rowCells: [Cell] = (cells.count > r) ? cells[r] : []
                        for c in 0..<columns {
                            let cell: Cell = (rowCells.count > c) ? rowCells[c] : .empty
                            Self.renderCell(cell, extraClasses: ["wc-matrix__cell"])
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
        [
            DiagramSharedStyles.css(),
            Self.css()
        ]
    }
}

extension MatrixDiagram {
    private static func renderCell(
        _ cell: Cell,
        extraClasses: [String]
    ) -> any HTMLNode {
        switch cell {
        case .empty:
            return HTML.div(.class(extraClasses + ["wc-matrix__cell--empty"])) {}

        case .box(let b):
            let bb = Self.boxWithExtraClasses(b, extraClasses)
            return DiagramPrimitives.boxHTML(
                bb,
                baseClass: "wc-diagram__box",
                innerClass: "wc-diagram__box-inner",
                alignCenterClass: "wc-diagram__box--center",
                alignStartClass: "wc-diagram__box--start"
            )
        }
    }

    private static func boxWithExtraClasses(_ b: Box, _ extra: [String]) -> Box {
        Box(
            classes: extra + b.classes,
            attrs: b.attrs,
            align: b.align,
            content: b.content
        )
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

                    // Base: no headers
                    CSS.decl(
                        "grid-template-columns",
                        "repeat(var(--wc-matrix-cols, 2), minmax(160px, 1fr))"
                    )
                ),

                // Column headers add one extra top row but grid auto-placement already handles it.
                // Row headers require an additional first column.
                CSS.rule(
                    ".wc-matrix--rowheaders",
                    CSS.decl(
                        "grid-template-columns",
                        "minmax(160px, 0.9fr) repeat(var(--wc-matrix-cols, 2), minmax(160px, 1fr))"
                    )
                ),

                CSS.rule(
                    ".wc-matrix__cell--empty",
                    CSS.decl("min-height", "56px")
                ),

                // Header cells: slightly toned down
                CSS.rule(
                    ".wc-matrix__cell--header",
                    CSS.decl("opacity", "0.95")
                ),

                // Crosshair (great for 2x2 quadrants)
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

                // Axis labels
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
                        ".wc-matrix",
                        // Allow horizontal scroll instead of destroying the matrix
                        CSS.decl("overflow-x", "auto"),
                        CSS.decl("justify-content", "flex-start"),
                        CSS.decl("padding-bottom", "6px")
                    ),
                    CSS.rule(
                        ".wc-matrix-wrap",
                        CSS.decl("overflow-x", "auto")
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

// MARK: - BoxAndContent (boxed shape with contents beside it)

public struct BoxAndContent: WebComponent {
    public enum Layout: Sendable {
        case boxLeft
        case boxRight
    }

    public let layout: Layout
    public let classes: [String]
    public let attrs: HTMLAttribute

    public let box: Box
    public let content: @Sendable () -> HTMLFragment

    public init(
        layout: Layout = .boxLeft,
        classes: [String] = [],
        attrs: HTMLAttribute = HTMLAttribute(),
        box: Box,
        content: @escaping @Sendable () -> HTMLFragment
    ) {
        self.layout = layout
        self.classes = classes
        self.attrs = attrs
        self.box = box
        self.content = content
    }

    public func html() -> HTMLFragment {
        let layoutClass: String = (layout == .boxLeft) ? "wc-box-and-content--box-left" : "wc-box-and-content--box-right"

        let a = DiagramPrimitives.makeAttrs(
            baseClasses: ["wc-box-and-content", layoutClass] + classes,
            attrs: attrs
        )

        return [
            HTML.div(a) {
                HTML.div(.class(["wc-box-and-content__box"])) {
                    DiagramPrimitives.boxHTML(
                        box,
                        baseClass: "wc-diagram__box",
                        innerClass: "wc-diagram__box-inner",
                        alignCenterClass: "wc-diagram__box--center",
                        alignStartClass: "wc-diagram__box--start"
                    )
                }

                HTML.div(.class(["wc-box-and-content__content"])) {
                    content()
                }
            }
        ]
    }

    public func styles() -> [CSSStyleSheet] {
        [
            DiagramSharedStyles.css(),
            Self.css()
        ]
    }
}

extension BoxAndContent {
    public static func css() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-box-and-content",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(240px, 0.9fr) minmax(320px, 1.2fr)"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("margin", "18px 0")
                ),

                CSS.rule(
                    ".wc-box-and-content__box",
                    CSS.decl("display", "block")
                ),

                CSS.rule(
                    ".wc-box-and-content__content",
                    CSS.decl("display", "block")
                ),

                CSS.rule(
                    ".wc-box-and-content--box-right",
                    CSS.decl("grid-template-columns", "minmax(320px, 1.2fr) minmax(240px, 0.9fr)")
                ),

                CSS.rule(
                    ".wc-box-and-content--box-right .wc-box-and-content__box",
                    CSS.decl("grid-column", "2")
                ),

                CSS.rule(
                    ".wc-box-and-content--box-right .wc-box-and-content__content",
                    CSS.decl("grid-column", "1")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 900px)",
                    CSS.rule(
                        ".wc-box-and-content",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "14px")
                    ),
                    CSS.rule(
                        ".wc-box-and-content--box-right .wc-box-and-content__box",
                        CSS.decl("grid-column", "auto")
                    ),
                    CSS.rule(
                        ".wc-box-and-content--box-right .wc-box-and-content__content",
                        CSS.decl("grid-column", "auto")
                    )
                )
            ]
        )
    }
}
