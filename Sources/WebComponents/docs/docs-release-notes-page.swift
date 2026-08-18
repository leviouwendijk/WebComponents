import Foundation
import Constructors
import CSS
import HTML
import Version
import Primitives
import Difference

public struct DocsReleaseNotesPage: ReusableComponent, Sendable {
    public enum MutationType: String, Sendable, CaseIterable {
        case added
        case changed
        case removed

        public var symbol: String {
            switch self {
            case .added:
                return "+"
            case .changed:
                return "~"
            case .removed:
                return "−"
            }
        }

        public var label: String {
            switch self {
            case .added:
                return "Nieuw"
            case .changed:
                return "Gewijzigd"
            case .removed:
                return "Verwijderd"
            }
        }

        var sortRank: Int {
            switch self {
            case .added:
                return 0
            case .changed:
                return 1
            case .removed:
                return 2
            }
        }
    }

    public enum ChangeAnnotation: Sendable {
        case note(
            title: String,
            body: String
        )

        case diff(
            title: String,
            layout: DifferenceLayout
        )
    }

    public struct Change: Sendable {
        public let mutation: MutationType
        public let text: String
        public let label: @Sendable () -> HTMLFragment
        public let annotation: ChangeAnnotation?

        public init(
            mutation: MutationType,
            text: String,
            annotation: ChangeAnnotation? = nil
        ) {
            self.mutation = mutation
            self.text = text
            self.label = {
                [
                    HTML.text(text)
                ]
            }
            self.annotation = annotation
        }

        public init(
            mutation: MutationType,
            text: String,
            label: @escaping @Sendable () -> HTMLFragment,
            annotation: ChangeAnnotation? = nil
        ) {
            self.mutation = mutation
            self.text = text
            self.label = label
            self.annotation = annotation
        }
    }

    public enum EntryError:
        Swift.Error,
        LocalizedError,
        Sendable
    {
        case incompleteDate
        case invalidYear(Int)

        public var errorDescription: String? {
            switch self {
            case .incompleteDate:
                return "Release note date must be a complete day-level date."

            case .invalidYear(
                let year
            ):
                return "Release note year must be greater than zero, got \(year)."
            }
        }
    }

    public struct Entry: Sendable {
        public let release: ReleaseVersion
        public let date: PartialDate
        public let title: String
        public let summary: String
        public let changes: [Change]

        private let dateYear: Int
        private let dateMonth: Int
        private let dateDay: Int

        public var version: ObjectVersion {
            release.version
        }

        public var versionLabel: String {
            release.string(
                prefixStyle: .short,
                includeMaturitySuffix: false
            )
        }

        public var maturityLabel: String? {
            release.maturityLabel
        }

        public var lifecycleLabel: String? {
            release.lifecycleLabel
        }

        public var dateValue: String {
            "\(dateYear)-\(Self.twoDigit(dateMonth))-\(Self.twoDigit(dateDay))"
        }

        public var dateLabel: String {
            "\(dateDay) \(Self.monthName(dateMonth)) \(dateYear)"
        }

        public init(
            release: ReleaseVersion,
            date: PartialDate,
            title: String,
            summary: String,
            changes: [Change]
        ) throws {
            let parts: (
                year: Int,
                month: Int,
                day: Int
            )

            do {
                parts = try date.requireComplete()
            } catch {
                throw EntryError.incompleteDate
            }

            guard parts.year > 0 else {
                throw EntryError.invalidYear(
                    parts.year
                )
            }

            self.release = release
            self.date = date
            self.title = title
            self.summary = summary
            self.changes = changes
            self.dateYear = parts.year
            self.dateMonth = parts.month
            self.dateDay = parts.day
        }

        public init(
            version: ObjectVersion,
            maturity: ReleaseMaturity = .stable,
            lifecycle: Lifecycle = .active,
            date: PartialDate,
            title: String,
            summary: String,
            changes: [Change]
        ) throws {
            try self.init(
                release: ReleaseVersion(
                    version: version,
                    maturity: maturity,
                    lifecycle: lifecycle
                ),
                date: date,
                title: title,
                summary: summary,
                changes: changes
            )
        }

        private static func twoDigit(
            _ value: Int
        ) -> String {
            value < 10
                ? "0\(value)"
                : "\(value)"
        }

        private static func monthName(
            _ month: Int
        ) -> String {
            switch month {
            case 1:
                return "januari"
            case 2:
                return "februari"
            case 3:
                return "maart"
            case 4:
                return "april"
            case 5:
                return "mei"
            case 6:
                return "juni"
            case 7:
                return "juli"
            case 8:
                return "augustus"
            case 9:
                return "september"
            case 10:
                return "oktober"
            case 11:
                return "november"
            case 12:
                return "december"
            default:
                return "\(month)"
            }
        }
    }

    public static let block = "wc-docs-release-notes"

    public let eyebrow: String
    public let title: String
    public let lead: String
    public let entries: [Entry]
    public let includeStyles: Bool

    private var sortedEntries: [Entry] {
        entries.sorted { lhs, rhs in
            lhs.release > rhs.release
        }
    }

    private var currentEntry: Entry? {
        sortedEntries.first
    }

    private var currentVersionLabel: String {
        currentEntry?.versionLabel ?? ""
    }

    private var currentMaturityLabel: String? {
        currentEntry?.maturityLabel
    }

    private var currentLifecycleLabel: String? {
        currentEntry?.lifecycleLabel
    }

    public init(
        eyebrow: String = "Documentatie",
        title: String = "Release notes",
        lead: String = "Een overzicht van zichtbare wijzigingen in de documentatie.",
        entries: [Entry],
        includeStyles: Bool = true
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.lead = lead
        self.entries = entries
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.main(
                    [
                        "id": "content-area",
                        "class": "docs-project-hub \(Self.block)"
                    ]
                ) {
                    HTML.section(["class": "\(Self.block)__hero docs-project-hub__hero"]) {
                        HTML.p(["class": "\(Self.block)__eyebrow docs-project-hub__eyebrow"]) {
                            HTML.text(eyebrow)
                        }

                        HTML.div(["class": "\(Self.block)__hero-title-row"]) {
                            HTML.h1 {
                                HTML.text(title)
                            }

                            if !currentVersionLabel.isEmpty {
                                HTML.span(["class": "\(Self.block)__current-version"]) {
                                    HTML.text(currentVersionLabel)
                                }
                            }

                            if let currentMaturityLabel {
                                release_badge(
                                    currentMaturityLabel,
                                    kind: "maturity"
                                )
                            }

                            if let currentLifecycleLabel {
                                release_badge(
                                    currentLifecycleLabel,
                                    kind: "lifecycle"
                                )
                            }
                        }

                        HTML.p(["class": "\(Self.block)__lead docs-project-hub__lead"]) {
                            HTML.text(lead)
                        }
                    }

                    HTML.section(
                        [
                            "class": sortedEntries.count <= 1
                                ? "\(Self.block)__timeline \(Self.block)__timeline--single"
                                : "\(Self.block)__timeline",
                            "aria-label": "Release notes"
                        ]
                    ) {
                        for entry in sortedEntries {
                            entry_node(entry)
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    private func release_badge(
        _ label: String,
        kind: String
    ) -> any HTMLNode {
        HTML.span(["class": "\(Self.block)__badge \(Self.block)__badge--\(kind)"]) {
            HTML.text(label)
        }
    }

    private func entry_node(
        _ entry: Entry
    ) -> any HTMLNode {
        let titleID = "\(Self.block)-\(slug(entry.versionLabel))-title"
        let current = isCurrent(entry)

        return HTML.el(
            "article",
            [
                "class": current
                    ? "\(Self.block)__entry \(Self.block)__entry--current"
                    : "\(Self.block)__entry",
                "aria-labelledby": titleID
            ]
        ) {
            HTML.div(["class": "\(Self.block)__entry-marker"]) {
                HTML.span(["class": "\(Self.block)__dot"]) {}
            }

            HTML.div(["class": "\(Self.block)__entry-card"]) {
                HTML.div(["class": "\(Self.block)__entry-header"]) {
                    HTML.div(["class": "\(Self.block)__version-group"]) {
                        HTML.span(["class": "\(Self.block)__version"]) {
                            HTML.text(entry.versionLabel)
                        }

                        if let maturityLabel = entry.maturityLabel {
                            release_badge(
                                maturityLabel,
                                kind: "maturity"
                            )
                        }

                        if let lifecycleLabel = entry.lifecycleLabel {
                            release_badge(
                                lifecycleLabel,
                                kind: "lifecycle"
                            )
                        }

                        if current {
                            release_badge(
                                "Actueel",
                                kind: "current"
                            )
                        }
                    }

                    HTML.el(
                        "time",
                        [
                            "class": "\(Self.block)__date",
                            "datetime": entry.dateValue
                        ]
                    ) {
                        HTML.text(entry.dateLabel)
                    }
                }

                HTML.h2(
                    [
                        "id": titleID,
                        "class": "\(Self.block)__entry-title"
                    ]
                ) {
                    HTML.text(entry.title)
                }

                HTML.p(["class": "\(Self.block)__summary"]) {
                    HTML.text(entry.summary)
                }

                if !entry.changes.isEmpty {
                    HTML.ul(["class": "\(Self.block)__change-list"]) {
                        for change in ordered_changes(entry.changes) {
                            change_node(change)
                        }
                    }
                }
            }
        }
    }

    private func isCurrent(
        _ entry: Entry
    ) -> Bool {
        guard let currentEntry else {
            return false
        }

        return entry.release == currentEntry.release
    }

    private func ordered_changes(
        _ changes: [Change]
    ) -> [Change] {
        changes
            .enumerated()
            .sorted { lhs, rhs in
                let lhsRank = lhs.element.mutation.sortRank
                let rhsRank = rhs.element.mutation.sortRank

                if lhsRank != rhsRank {
                    return lhsRank < rhsRank
                }

                return lhs.offset < rhs.offset
            }
            .map { indexed in
                indexed.element
            }
    }

    private func change_node(
        _ change: Change
    ) -> any HTMLNode {
        HTML.el(
            "li",
            [
                "class": "\(Self.block)__change \(Self.block)__change--\(change.mutation.rawValue)",
                "aria-label": "\(change.mutation.label): \(change.text)"
            ]
        ) {
            HTML.span(
                [
                    "class": "\(Self.block)__change-symbol",
                    "aria-hidden": "true"
                ]
            ) {
                HTML.text(change.mutation.symbol)
            }

            HTML.div(["class": "\(Self.block)__change-body"]) {
                // HTML.span(["class": "\(Self.block)__change-text"]) {
                //     HTML.text(change.text)
                // }
                HTML.span(["class": "\(Self.block)__change-text"]) {
                    change.label()
                }

                if let annotation = change.annotation {
                    annotation_node(annotation)
                }
            }
        }
    }

    private func annotation_node(
        _ annotation: ChangeAnnotation
    ) -> any HTMLNode {
        switch annotation {
        case .note(let title, let body):
            return note_annotation_node(
                title: title,
                body: body
            )

        case .diff(let title, let layout):
            return diff_annotation_node(
                title: title,
                layout: layout
            )
        }
    }

    private func note_annotation_node(
        title: String,
        body: String
    ) -> any HTMLNode {
        HTML.el(
            "details",
            [
                "class": "\(Self.block)__annotation \(Self.block)__annotation--note"
            ]
        ) {
            HTML.el("summary", ["class": "\(Self.block)__annotation-summary"]) {
                HTML.span(["class": "\(Self.block)__annotation-title"]) {
                    HTML.text(title)
                }
            }

            HTML.div(["class": "\(Self.block)__annotation-body"]) {
                HTML.p(["class": "\(Self.block)__annotation-note"]) {
                    HTML.text(body)
                }
            }
        }
    }

    private func diff_annotation_node(
        title: String,
        layout: DifferenceLayout
    ) -> any HTMLNode {
        HTML.el(
            "details",
            [
                "class": "\(Self.block)__annotation \(Self.block)__annotation--diff"
            ]
        ) {
            HTML.el("summary", ["class": "\(Self.block)__annotation-summary"]) {
                HTML.span(["class": "\(Self.block)__annotation-title"]) {
                    HTML.text(title)
                }
            }

            HTML.div(["class": "\(Self.block)__annotation-body"]) {
                HTML.div(
                    [
                        "class": "\(Self.block)__diff",
                        "role": "list"
                    ]
                ) {
                    for line in layout.lines {
                        diff_line_node(line)
                    }
                }
            }
        }
    }

    private func diff_line_node(
        _ line: DifferenceLayout.Line
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "\(Self.block)__diff-line \(Self.block)__diff-line--\(diff_role_class(line.role))",
                "role": "listitem"
            ]
        ) {
            HTML.span(
                [
                    "class": "\(Self.block)__diff-prefix",
                    "aria-hidden": "true"
                ]
            ) {
                HTML.text(diff_prefix(line.role))
            }

            HTML.el("code", ["class": "\(Self.block)__diff-code"]) {
                HTML.text(line.text)
            }
        }
    }

    private func diff_prefix(
        _ role: DifferenceLayout.Role
    ) -> String {
        switch role {
        case .headerOld:
            return "---"
        case .headerNew:
            return "+++"
        case .equal:
            return " "
        case .insert:
            return "+"
        case .delete:
            return "−"
        case .separator:
            return "…"
        }
    }

    private func diff_role_class(
        _ role: DifferenceLayout.Role
    ) -> String {
        switch role {
        case .headerOld:
            return "header-old"
        case .headerNew:
            return "header-new"
        case .equal:
            return "equal"
        case .insert:
            return "insert"
        case .delete:
            return "delete"
        case .separator:
            return "separator"
        }
    }

    private func slug(
        _ value: String
    ) -> String {
        value
            .lowercased()
            .map { char in
                char.isLetter || char.isNumber ? char : "-"
            }
            .reduce(into: "") { result, char in
                if char == "-", result.last == "-" {
                    return
                }

                result.append(char)
            }
            .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("--wc-docs-release-surface", "var(--surface-color, #fff)"),
                    CSS.decl("--wc-docs-release-soft", "var(--surface-soft-color, #f1f5f9)"),
                    CSS.decl("--wc-docs-release-border", "var(--border-color, rgba(15, 23, 42, .12))"),
                    CSS.decl("--wc-docs-release-muted", "var(--muted-text-color, rgba(32, 33, 36, .66))"),
                    CSS.decl("--wc-docs-release-accent", "var(--link-color, #2563eb)"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("width", "min(1120px, calc(100% - 48px))"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "clamp(34px, 5vw, 56px) 0 64px")
                ),

                CSS.rule(
                    ".dark-mode .\(block)",
                    CSS.decl("--wc-docs-release-surface", "var(--surface-color, #1b1c1f)"),
                    CSS.decl("--wc-docs-release-soft", "var(--surface-soft-color, #232429)"),
                    CSS.decl("--wc-docs-release-border", "var(--border-color, rgba(255, 255, 255, .13))"),
                    CSS.decl("--wc-docs-release-muted", "var(--muted-text-color, rgba(244, 244, 245, .68))")
                ),

                CSS.rule(
                    ".\(block)__hero",
                    CSS.decl("max-width", "880px"),
                    CSS.decl("margin", "0 auto clamp(26px, 4vw, 40px)"),
                    CSS.decl("padding", "0")
                ),

                CSS.rule(
                    ".\(block)__eyebrow",
                    CSS.decl("margin", "0 0 8px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".1em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--wc-docs-release-muted)")
                ),

                CSS.rule(
                    ".\(block)__hero h1",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(2rem, 4vw, 3.15rem)"),
                    CSS.decl("line-height", ".95"),
                    CSS.decl("letter-spacing", "-.055em")
                ),

                CSS.rule(
                    ".\(block)__lead",
                    CSS.decl("max-width", "70ch"),
                    CSS.decl("margin", "14px 0 0")
                ),

                CSS.rule(
                    ".\(block)__hero-title-row",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("flex-wrap", "wrap")
                ),

                CSS.rule(
                    ".\(block)__current-version",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("height", "30px"),
                    CSS.decl("padding", "0 11px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--wc-docs-release-accent) 28%, var(--wc-docs-release-border))"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-docs-release-accent) 10%, transparent)"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "650")
                ),

                CSS.rule(
                    ".\(block)__timeline",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "20px"),
                    CSS.decl("max-width", "880px"),
                    CSS.decl("margin", "0 auto 56px"),
                    CSS.decl("padding", "0 0 0 28px")
                ),

                CSS.rule(
                    ".\(block)__timeline::before",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "8px"),
                    CSS.decl("top", "8px"),
                    CSS.decl("bottom", "8px"),
                    CSS.decl("width", "2px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 12%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__entry",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "0 minmax(0, 1fr)")
                ),

                CSS.rule(
                    ".\(block)__entry-marker",
                    CSS.decl("position", "relative")
                ),

                CSS.rule(
                    ".\(block)__dot",
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "-26px"),
                    CSS.decl("top", "20px"),
                    CSS.decl("width", "14px"),
                    CSS.decl("height", "14px"),
                    CSS.decl("border", "3px solid var(--background-color)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 34%, var(--wc-docs-release-surface))"),
                    CSS.decl("box-shadow", "0 0 0 1px var(--wc-docs-release-border)")
                ),

                CSS.rule(
                    ".\(block)__entry--current .\(block)__dot",
                    CSS.decl("background", "var(--wc-docs-release-accent)"),
                    CSS.decl("box-shadow", "0 0 0 4px color-mix(in srgb, var(--wc-docs-release-accent) 14%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__timeline--single",
                    CSS.decl("padding", "0"),
                    CSS.decl("margin", "0 auto 56px")
                ),

                CSS.rule(
                    ".\(block)__timeline--single::before, .\(block)__timeline--single .\(block)__entry-marker",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(block)__timeline--single .\(block)__entry",
                    CSS.decl("grid-template-columns", "minmax(0, 1fr)")
                ),

                CSS.rule(
                    ".\(block)__entry-card",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("padding", "20px"),
                    CSS.decl("border", "1px solid var(--wc-docs-release-border)"),
                    CSS.decl("border-radius", "20px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-docs-release-surface) 94%, var(--text-color) 6%)"),
                    CSS.decl("box-shadow", "0 18px 44px rgba(15, 23, 42, .06)")
                ),

                CSS.rule(
                    ".dark-mode .\(block)__entry-card",
                    CSS.decl("box-shadow", "0 18px 40px rgba(0, 0, 0, .24)")
                ),

                CSS.rule(
                    ".\(block)__entry-header",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("flex-wrap", "wrap")
                ),

                CSS.rule(
                    ".\(block)__version-group",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("flex-wrap", "wrap")
                ),

                CSS.rule(
                    ".\(block)__version",
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "680"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block)__badge",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("height", "24px"),
                    CSS.decl("padding", "0 8px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 8%, transparent)"),
                    CSS.decl("color", "var(--wc-docs-release-muted)"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "760")
                ),

                CSS.rule(
                    ".\(block)__badge--current, .\(block)__badge--maturity",
                    CSS.decl(
                        "background",
                        "color-mix(in srgb, var(--wc-docs-release-accent) 12%, transparent)"),
                    CSS.decl("color", "var(--wc-docs-release-accent)")
                ),

                CSS.rule(
                    ".\(block)__badge--lifecycle",
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 9%, transparent)"),
                    CSS.decl("color", "var(--wc-docs-release-muted)")
                ),

                CSS.rule(
                    ".\(block)__date",
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("color", "var(--wc-docs-release-muted)")
                ),

                CSS.rule(
                    ".\(block)__entry-title",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.15rem"),
                    CSS.decl("line-height", "1.18"),
                    CSS.decl("letter-spacing", "-.02em")
                ),

                CSS.rule(
                    ".\(block)__summary",
                    CSS.decl("margin", "0"),
                    CSS.decl("max-width", "70ch"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("color", "var(--wc-docs-release-muted)")
                ),

                CSS.rule(
                    ".\(block)__change-list",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "0"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("list-style", "none")
                ),

                CSS.rule(
                    ".\(block)__change",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "24px minmax(0, 1fr)"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("column-gap", "10px"),
                    CSS.decl("row-gap", "10px"),
                    CSS.decl("padding", "0 0 12px"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.48"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block)__change:last-child",
                    CSS.decl("padding-bottom", "0")
                ),

                CSS.rule(
                    ".\(block)__change:not(:last-child)::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("grid-column", "2 / -1"),
                    CSS.decl("display", "block"),
                    CSS.decl("height", "1px"),
                    CSS.decl("margin-top", "2px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 10%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__change-symbol",
                    CSS.decl("display", "inline-grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "21px"),
                    CSS.decl("height", "21px"),
                    CSS.decl("margin-top", ".08em"),
                    CSS.decl("border", "1px solid currentColor"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("background", "color-mix(in srgb, currentColor 10%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__change--added .\(block)__change-symbol",
                    CSS.decl("color", "var(--success, #2E8B57)")
                ),

                CSS.rule(
                    ".\(block)__change--changed .\(block)__change-symbol",
                    CSS.decl("color", "var(--wc-docs-release-accent)")
                ),

                CSS.rule(
                    ".\(block)__change--removed .\(block)__change-symbol",
                    CSS.decl("color", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".\(block)__change-body",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__change-text",
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__annotation",
                    CSS.decl("width", "100%"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--wc-docs-release-border) 82%, transparent)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-docs-release-surface) 90%, var(--text-color) 10%)")
                ),

                CSS.rule(
                    ".\(block)__annotation-summary",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("padding", "8px 10px"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("list-style", "none"),
                    CSS.decl("color", "var(--wc-docs-release-muted)"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "760")
                ),

                CSS.rule(
                    ".\(block)__annotation-summary::-webkit-details-marker",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(block)__annotation-summary::before",
                    CSS.decl("content", "\"›\""),
                    CSS.decl("display", "inline-grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "16px"),
                    CSS.decl("height", "16px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 8%, transparent)"),
                    CSS.decl("transition", "transform .16s ease")
                ),

                CSS.rule(
                    ".\(block)__annotation[open] .\(block)__annotation-summary::before",
                    CSS.decl("transform", "rotate(90deg)")
                ),

                CSS.rule(
                    ".\(block)__annotation-title",
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__annotation-body",
                    CSS.decl("padding", "0 10px 10px 34px"),
                    CSS.decl("border-top", "1px solid color-mix(in srgb, var(--wc-docs-release-border) 72%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__annotation-note",
                    CSS.decl("margin", "10px 0 0"),
                    CSS.decl("color", "var(--wc-docs-release-muted)"),
                    CSS.decl("font-size", ".86rem"),
                    CSS.decl("line-height", "1.5")
                ),

                CSS.rule(
                    ".\(block)__diff",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "1px"),
                    CSS.decl("overflow-x", "auto"),
                    CSS.decl("margin-top", "10px"),
                    CSS.decl("padding", "6px"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 7%, transparent)"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("line-height", "1.45")
                ),

                CSS.rule(
                    ".\(block)__diff-line",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "34px max-content"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("min-width", "100%"),
                    CSS.decl("padding", "2px 6px"),
                    CSS.decl("border-radius", "8px"),
                    CSS.decl("white-space", "pre"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block)__diff-prefix",
                    CSS.decl("text-align", "right"),
                    CSS.decl("color", "var(--wc-docs-release-muted)"),
                    CSS.decl("user-select", "none")
                ),

                CSS.rule(
                    ".\(block)__diff-code",
                    CSS.decl("font", "inherit"),
                    CSS.decl("color", "inherit"),
                    CSS.decl("white-space", "pre")
                ),

                CSS.rule(
                    ".\(block)__diff-line--insert",
                    CSS.decl("color", "var(--success, #2E8B57)"),
                    CSS.decl("background", "color-mix(in srgb, var(--success, #2E8B57) 10%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__diff-line--delete",
                    CSS.decl("color", "var(--danger, #D64545)"),
                    CSS.decl("background", "color-mix(in srgb, var(--danger, #D64545) 10%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__diff-line--header-old, .\(block)__diff-line--header-new",
                    CSS.decl("color", "var(--wc-docs-release-muted)"),
                    CSS.decl("font-weight", "780")
                ),

                CSS.rule(
                    ".\(block)__diff-line--separator",
                    CSS.decl("color", "var(--wc-docs-release-muted)"),
                    CSS.decl("font-style", "italic")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".\(block)__timeline",
                        CSS.decl("padding-left", "22px")
                    ),

                    CSS.rule(
                        ".\(block)__timeline::before",
                        CSS.decl("left", "5px")
                    ),

                    CSS.rule(
                        ".\(block)__dot",
                        CSS.decl("left", "-22px")
                    ),

                    CSS.rule(
                        ".\(block)__entry-card",
                        CSS.decl("padding", "16px"),
                        CSS.decl("border-radius", "18px")
                    )
                )
            ]
        )
    }
}
