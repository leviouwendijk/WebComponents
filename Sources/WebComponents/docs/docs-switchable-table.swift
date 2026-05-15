import Constructors
import CSS
import HTML
import JS

public struct DocsSwitchableTable: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-switchable-table"

    public struct Mode: Sendable {
        public let id: String
        public let label: String

        public init(
            id: String,
            label: String
        ) {
            self.id = id
            self.label = label
        }

        public static let expanded = Mode(
            id: "expanded",
            label: "Tekst"
        )

        public static let compact = Mode(
            id: "compact",
            label: "Symbool"
        )

        public static let textAndSymbol: [Mode] = [
            .expanded,
            .compact,
        ]
    }

    public struct Column: Sendable {
        public let id: String
        public let title: String
        public let isRowHeader: Bool

        public init(
            id: String,
            title: String,
            isRowHeader: Bool = false
        ) {
            self.id = id
            self.title = title
            self.isRowHeader = isRowHeader
        }
    }

    public struct Cell: Sendable {
        public let body: @Sendable (_ mode: Mode) -> HTMLFragment

        public init(
            body: @escaping @Sendable (_ mode: Mode) -> HTMLFragment
        ) {
            self.body = body
        }

        public init(
            expanded: @escaping @Sendable () -> HTMLFragment,
            compact: (@Sendable () -> HTMLFragment)? = nil
        ) {
            self.body = { mode in
                if mode.id == Mode.compact.id {
                    if let compact {
                        return compact()
                    }

                    return expanded()
                }

                return expanded()
            }
        }

        public init(
            expanded: String,
            compact: String? = nil
        ) {
            let compactValue = compact ?? expanded

            self.body = { mode in
                if mode.id == Mode.compact.id {
                    return [
                        HTML.text(compactValue)
                    ]
                }

                return [
                    HTML.text(expanded)
                ]
            }
        }

        public static let empty = Cell(
            expanded: ""
        )
    }

    public struct Row: Sendable {
        public let id: String
        public let cells: [Cell]

        public init(
            id: String,
            cells: [Cell]
        ) {
            self.id = id
            self.cells = cells
        }
    }

    public let title: String?
    public let note: String?
    public let columns: [Column]
    public let rows: [Row]
    public let modes: [Mode]
    public let defaultModeID: String
    public let stickyFirstColumn: Bool
    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        title: String? = nil,
        note: String? = nil,
        columns: [Column],
        rows: [Row],
        modes: [Mode] = Mode.textAndSymbol,
        defaultModeID: String = Mode.expanded.id,
        stickyFirstColumn: Bool = true,
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
        self.title = title
        self.note = note
        self.columns = columns
        self.rows = rows
        self.modes = modes
        self.defaultModeID = defaultModeID
        self.stickyFirstColumn = stickyFirstColumn
        self.includeStyles = includeStyles
        self.includeScript = includeScript
    }

    public var nodes: ReusableComponentNodes {
        let hasIntro = title != nil || note != nil
        let hasControls = modes.count > 1

        return .body(
            [
                HTML.div(
                    [
                        "class": Self.block,
                        "data-docs-switchable-table": "",
                        "data-docs-switchable-table-mode": defaultModeID
                    ]
                ) {
                    if hasIntro || hasControls {
                        HTML.div(["class": "\(Self.block)__header"]) {
                            if hasIntro {
                                HTML.div(["class": "\(Self.block)__intro"]) {
                                    if let title {
                                        HTML.h3(["class": "\(Self.block)__title header-sub"]) {
                                            HTML.text(title)
                                        }
                                    }

                                    if let note {
                                        HTML.p(["class": "\(Self.block)__note"]) {
                                            HTML.text(note)
                                        }
                                    }
                                }
                            }

                            if hasControls {
                                HTML.div(
                                    [
                                        "class": "\(Self.block)__controls",
                                        "role": "group",
                                        "aria-label": "Weergavemodus"
                                    ]
                                ) {
                                    for mode in modes {
                                        toggleButton(mode)
                                    }
                                }
                            }
                        }
                    }

                    HTML.div(
                        [
                            "class": "\(Self.block)__wrap \(stickyFirstColumn ? "\(Self.block)__wrap--sticky-first-column" : "")"
                        ]
                    ) {
                        HTML.table(["class": "\(Self.block)__table"]) {
                            HTML.thead {
                                HTML.tr {
                                    for column in columns {
                                        HTML.th(
                                            [
                                                "scope": "col",
                                                "class": column.isRowHeader
                                                    ? "\(Self.block)__cell \(Self.block)__cell--row-header"
                                                    : "\(Self.block)__cell"
                                            ]
                                        ) {
                                            HTML.text(column.title)
                                        }
                                    }
                                }
                            }

                            HTML.tbody {
                                for row in rows {
                                    HTML.tr(["data-docs-switchable-table-row": row.id]) {
                                        for index in columns.indices {
                                            let column = columns[index]
                                            let cell = row.cells.indices.contains(index)
                                                ? row.cells[index]
                                                : .empty

                                            if column.isRowHeader {
                                                HTML.th(
                                                    [
                                                        "scope": "row",
                                                        "class": "\(Self.block)__cell \(Self.block)__cell--row-header"
                                                    ]
                                                ) {
                                                    cellContent(cell)
                                                }
                                            } else {
                                                HTML.td(["class": "\(Self.block)__cell"]) {
                                                    cellContent(cell)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : [],
            scripts: includeScript ? DocsSwitchableTableScript().nodes.scripts : []
        )
    }

    private func toggleButton(
        _ mode: Mode
    ) -> any HTMLNode {
        let isActive = mode.id == defaultModeID

        return HTML.button(
            [
                "type": "button",
                "class": "\(Self.block)__toggle\(isActive ? " is-active" : "")",
                "data-docs-switchable-table-toggle": mode.id,
                "aria-pressed": isActive ? "true" : "false"
            ]
        ) {
            HTML.text(mode.label)
        }
    }

    private func cellContent(
        _ cell: Cell
    ) -> HTMLFragment {
        modes.map { mode in
            modeContent(
                mode: mode,
                cell: cell
            )
        }
    }

    private func modeContent(
        mode: Mode,
        cell: Cell
    ) -> any HTMLNode {
        let isDefault = mode.id == defaultModeID

        let attrs: HTMLAttribute = isDefault
            ? [
                "class": "\(Self.block)__cell-mode",
                "data-docs-switchable-table-content": mode.id
            ]
            : [
                "class": "\(Self.block)__cell-mode",
                "data-docs-switchable-table-content": mode.id,
                "hidden": ""
            ]

        return HTML.span(attrs) {
            cell.body(mode)
        }
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public func sheet() -> CSSStyleSheet {
        Self.stylesheet()
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("--switch-table-surface", "color-mix(in srgb, var(--background-color) 94%, var(--text-color) 6%)"),
                    CSS.decl("--switch-table-surface-soft", "color-mix(in srgb, var(--background-color) 88%, var(--text-color) 8%)"),
                    CSS.decl("--switch-table-border", "var(--border-color)"),
                    CSS.decl("--switch-table-muted", "color-mix(in srgb, var(--text-color) 62%, transparent)"),
                    CSS.decl("margin", "22px 0 34px"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block)__header",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "flex-start"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("margin", "0 0 12px")
                ),

                CSS.rule(
                    ".\(block)__intro",
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__title",
                    CSS.decl("margin", "0 0 6px")
                ),

                CSS.rule(
                    ".\(block)__note",
                    CSS.decl("max-width", "760px"),
                    CSS.decl("margin", "0"),
                    CSS.decl("color", "var(--switch-table-muted)"),
                    CSS.decl("font-size", ".94rem"),
                    CSS.decl("line-height", "1.55")
                ),

                CSS.rule(
                    ".\(block)__controls",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("padding", "3px"),
                    CSS.decl("border", "1px solid var(--switch-table-border)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--switch-table-surface)"),
                    CSS.decl("flex", "0 0 auto")
                ),

                CSS.rule(
                    ".\(block)__toggle",
                    CSS.decl("appearance", "none"),
                    CSS.decl("border", "0"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("color", "var(--switch-table-muted)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("height", "30px"),
                    CSS.decl("padding", "0 11px"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(block)__toggle:hover",
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block)__toggle.is-active",
                    CSS.decl("background", "var(--text-color)"),
                    CSS.decl("color", "var(--background-color)")
                ),

                CSS.rule(
                    ".\(block)__wrap",
                    CSS.decl("overflow-x", "auto"),
                    CSS.decl("border", "1px solid var(--switch-table-border)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "var(--switch-table-surface)")
                ),

                CSS.rule(
                    ".\(block)__table",
                    CSS.decl("width", "100%"),
                    CSS.decl("min-width", "760px"),
                    CSS.decl("border-collapse", "separate"),
                    CSS.decl("border-spacing", "0"),
                    CSS.decl("font-size", ".91rem")
                ),

                CSS.rule(
                    ".\(block)__table th, .\(block)__table td",
                    CSS.decl("padding", "12px 14px"),
                    CSS.decl("vertical-align", "top"),
                    CSS.decl("text-align", "left"),
                    CSS.decl("border-bottom", "1px solid var(--switch-table-border)")
                ),

                CSS.rule(
                    ".\(block)__table thead th",
                    CSS.decl("position", "sticky"),
                    CSS.decl("top", "0"),
                    CSS.decl("z-index", "2"),
                    CSS.decl("background", "var(--switch-table-surface-soft)"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--switch-table-muted)")
                ),

                CSS.rule(
                    ".\(block)__table tbody tr:last-child th, .\(block)__table tbody tr:last-child td",
                    CSS.decl("border-bottom", "0")
                ),

                CSS.rule(
                    ".\(block)__cell--row-header",
                    CSS.decl("font-weight", "780"),
                    CSS.decl("white-space", "nowrap"),
                    CSS.decl("background", "var(--switch-table-surface)")
                ),

                CSS.rule(
                    ".\(block)__wrap--sticky-first-column .\(block)__table th:first-child",
                    CSS.decl("position", "sticky"),
                    CSS.decl("left", "0"),
                    CSS.decl("z-index", "3"),
                    CSS.decl("box-shadow", "1px 0 0 var(--switch-table-border)")
                ),

                CSS.rule(
                    ".\(block)__wrap--sticky-first-column .\(block)__table thead th:first-child",
                    CSS.decl("z-index", "4"),
                    CSS.decl("background", "var(--switch-table-surface-soft)")
                ),

                CSS.rule(
                    ".\(block)__cell code",
                    CSS.decl("font-size", ".88em")
                ),

                CSS.rule(
                    ".\(block)__cell-mode[hidden]",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(block)__cell-mode:not([hidden])",
                    CSS.decl("display", "inline")
                ),

                CSS.rule(
                    ".dark-mode .\(block)",
                    CSS.decl("--switch-table-surface", "color-mix(in srgb, var(--background-color) 88%, var(--text-color) 7%)"),
                    CSS.decl("--switch-table-surface-soft", "color-mix(in srgb, var(--background-color) 78%, var(--text-color) 10%)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(block)__header",
                        CSS.decl("display", "block")
                    ),
                    CSS.rule(
                        ".\(block)__controls",
                        CSS.decl("margin-top", "12px")
                    ),
                    CSS.rule(
                        ".\(block)__table",
                        CSS.decl("min-width", "680px"),
                        CSS.decl("font-size", ".86rem")
                    )
                )
            ]
        )
    }
}

public struct DocsSwitchableTableScript: ReusableComponent {
    public init() {}

    public var nodes: ReusableComponentNodes {
        .init(
            scripts: [
                JSSource(Self.source).as_inline_script()
            ]
        )
    }

    private static let source = #"""
    (() => {
        if (window.wcDocsSwitchableTable?.initialized) return;

        function setMode(root, mode) {
            if (!root || !mode) return;

            root.setAttribute('data-docs-switchable-table-mode', mode);

            root
                .querySelectorAll('[data-docs-switchable-table-toggle]')
                .forEach((button) => {
                    const active = button.getAttribute('data-docs-switchable-table-toggle') === mode;
                    button.classList.toggle('is-active', active);
                    button.setAttribute('aria-pressed', active ? 'true' : 'false');
                });

            root
                .querySelectorAll('[data-docs-switchable-table-content]')
                .forEach((node) => {
                    const active = node.getAttribute('data-docs-switchable-table-content') === mode;
                    node.toggleAttribute('hidden', !active);
                });
        }

        function initialize(root) {
            const mode = root.getAttribute('data-docs-switchable-table-mode') || 'expanded';
            setMode(root, mode);
        }

        document.addEventListener('click', (event) => {
            const button = event.target.closest('[data-docs-switchable-table-toggle]');
            if (!button) return;

            const root = button.closest('[data-docs-switchable-table]');
            if (!root) return;

            setMode(
                root,
                button.getAttribute('data-docs-switchable-table-toggle')
            );
        });

        document
            .querySelectorAll('[data-docs-switchable-table]')
            .forEach(initialize);

        window.wcDocsSwitchableTable = { initialized: true };
    })();
    """#
}
