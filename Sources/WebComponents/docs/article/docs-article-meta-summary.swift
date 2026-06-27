import Constructors
import CSS
import HTML
import Primitives

public struct DocsArticleMetaLabels: Sendable, Hashable {
    public let article: String
    public let commentary: String
    public let correction: String
    public let note: String
    public let background: String

    public let published: String
    public let revised: String
    public let updated: String
    public let corrected: String
    public let expanded: String
    public let commentaryEvent: String

    public let ariaLabel: String
    public let subjectsLabel: String
    public let months: [String]

    public init(
        article: String,
        commentary: String,
        correction: String,
        note: String,
        background: String,
        published: String,
        revised: String,
        updated: String,
        corrected: String,
        expanded: String,
        commentaryEvent: String,
        ariaLabel: String,
        subjectsLabel: String,
        months: [String]
    ) {
        self.article = article
        self.commentary = commentary
        self.correction = correction
        self.note = note
        self.background = background
        self.published = published
        self.revised = revised
        self.updated = updated
        self.corrected = corrected
        self.expanded = expanded
        self.commentaryEvent = commentaryEvent
        self.ariaLabel = ariaLabel
        self.subjectsLabel = subjectsLabel
        self.months = months
    }

    public func kindLabel(
        _ kind: DocsArticleKind
    ) -> String {
        switch kind {
        case .article:
            return article

        case .commentary:
            return commentary

        case .correction:
            return correction

        case .note:
            return note

        case .background:
            return background
        }
    }

    public func historyLabel(
        _ kind: DocsArticleHistoryKind
    ) -> String {
        switch kind {
        case .published:
            return published

        case .revised:
            return revised

        case .updated:
            return updated

        case .corrected:
            return corrected

        case .expanded:
            return expanded

        case .commentary:
            return commentaryEvent
        }
    }

    public func monthName(
        _ month: Int
    ) -> String? {
        guard (1...months.count).contains(month) else {
            return nil
        }

        return months[month - 1]
    }

    public static let english = DocsArticleMetaLabels(
        article: "Article",
        commentary: "Commentary",
        correction: "Correction",
        note: "Note",
        background: "Background",
        published: "Published",
        revised: "Revised",
        updated: "Updated",
        corrected: "Corrected",
        expanded: "Expanded",
        commentaryEvent: "Commentary",
        ariaLabel: "Article metadata",
        subjectsLabel: "Subjects",
        months: [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"
        ]
    )

    public static let dutch = DocsArticleMetaLabels(
        article: "Artikel",
        commentary: "Commentaar",
        correction: "Correctie",
        note: "Aantekening",
        background: "Achtergrond",
        published: "Gepubliceerd",
        revised: "Herzien",
        updated: "Bijgewerkt",
        corrected: "Gecorrigeerd",
        expanded: "Uitgebreid",
        commentaryEvent: "Commentaar",
        ariaLabel: "Artikelmetadata",
        subjectsLabel: "Onderwerpen",
        months: [
            "januari",
            "februari",
            "maart",
            "april",
            "mei",
            "juni",
            "juli",
            "augustus",
            "september",
            "oktober",
            "november",
            "december"
        ]
    )
}

public extension DocsLexicon {
    var articleMetaLabels: DocsArticleMetaLabels {
        if docs == DocsLexicon.dutch.docs,
           allDocs == DocsLexicon.dutch.allDocs {
            return .dutch
        }

        return .english
    }
}

public struct DocsArticleMetaSummary: ReusableComponent, Sendable {
    public static let block = "wc-docs-article-meta"

    public let meta: DocsArticleMeta
    public let labels: DocsArticleMetaLabels
    public let includeStyles: Bool

    public init(
        meta: DocsArticleMeta,
        labels: DocsArticleMetaLabels = .english,
        includeStyles: Bool = true
    ) {
        self.meta = meta
        self.labels = labels
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        let content = contentNodes()

        guard !content.isEmpty else {
            return .init()
        }

        return .body(
            [
                HTMLElement(
                    "div",
                    attrs: [
                        "class": Self.block,
                        "aria-label": labels.ariaLabel
                    ],
                    children: content
                )
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    private var isMeaningful: Bool {
        meta.kind != .article
            || !meta.history.isEmpty
            || !meta.subjects.isEmpty
            || !meta.relations.isEmpty
    }

    private var latestMutationEvent: DocsArticleHistoryEvent? {
        meta.history.reversed().first { event in
            event.kind != .published
        }
    }

    private func contentNodes() -> HTMLFragment {
        guard isMeaningful else {
            return []
        }

        var out: HTMLFragment = [
            kindNode()
        ]

        if let publishedEvent = meta.publishedEvent {
            out.append(
                historyNode(publishedEvent)
            )
        }

        if let latestMutationEvent {
            out.append(
                historyNode(latestMutationEvent)
            )
        }

        if !meta.subjects.isEmpty {
            out.append(
                subjectsNode()
            )
        }

        return out
    }

    private func kindNode() -> any HTMLNode {
        HTMLElement(
            "span",
            attrs: [
                "class": "\(Self.block)__kind"
            ],
            children: [
                HTMLText(labels.kindLabel(meta.kind))
            ]
        )
    }

    private func historyNode(
        _ event: DocsArticleHistoryEvent
    ) -> any HTMLNode {
        let label = labels.historyLabel(event.kind)
        let formattedDate = dateLabel(event.date)

        guard let formattedDate else {
            return HTMLElement(
                "span",
                attrs: [
                    "class": "\(Self.block)__history \(Self.block)__history--undated"
                ],
                children: [
                    HTMLText(label)
                ]
            )
        }

        return HTMLElement(
            "span",
            attrs: [
                "class": "\(Self.block)__history"
            ],
            children: [
                HTMLElement(
                    "span",
                    attrs: [
                        "class": "\(Self.block)__history-label"
                    ],
                    children: [
                        HTMLText(label)
                    ]
                ),
                HTMLText(" "),
                HTMLElement(
                    "time",
                    attrs: timeAttributes(event.date),
                    children: [
                        HTMLText(formattedDate)
                    ]
                )
            ]
        )
    }

    private func subjectsNode() -> any HTMLNode {
        HTMLElement(
            "span",
            attrs: [
                "class": "\(Self.block)__subjects",
                "aria-label": labels.subjectsLabel
            ],
            children: meta.subjects.map { subject in
                subjectNode(subject)
            }
        )
    }

    private func subjectNode(
        _ subject: DocsArticleSubject
    ) -> any HTMLNode {
        HTMLElement(
            "span",
            attrs: [
                "class": "\(Self.block)__subject",
                "data-docs-article-subject": subject.id.rawValue
            ],
            children: [
                HTMLText(subject.label)
            ]
        )
    }

    private func timeAttributes(
        _ date: PartialDate
    ) -> HTMLAttribute {
        var attrs: HTMLAttribute = [
            "class": "\(Self.block)__date"
        ]

        if let value = dateValue(date) {
            attrs.merge([
                "datetime": value
            ])
        }

        return attrs
    }

    private func dateLabel(
        _ date: PartialDate
    ) -> String? {
        guard let year = date.year else {
            return nil
        }

        guard let month = date.month,
              let monthName = labels.monthName(month)
        else {
            return "\(year)"
        }

        guard let day = date.day,
              (1...31).contains(day)
        else {
            return "\(monthName) \(year)"
        }

        return "\(day) \(monthName) \(year)"
    }

    private func dateValue(
        _ date: PartialDate
    ) -> String? {
        guard let year = date.year else {
            return nil
        }

        guard let month = date.month,
              (1...12).contains(month)
        else {
            return "\(year)"
        }

        guard let day = date.day,
              (1...31).contains(day)
        else {
            return "\(year)-\(twoDigit(month))"
        }

        return "\(year)-\(twoDigit(month))-\(twoDigit(day))"
    }

    private func twoDigit(
        _ value: Int
    ) -> String {
        value < 10 ? "0\(value)" : "\(value)"
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("max-width", "720px"),
                    CSS.decl("margin", "18px 0 0"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__kind, .\(block)__history, .\(block)__subject",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("min-height", "28px"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("white-space", "nowrap")
                ),

                CSS.rule(
                    ".\(block)__kind",
                    CSS.decl("padding", "0 10px"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".02em"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 8%, transparent)"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block)__history",
                    CSS.decl("gap", "4px"),
                    CSS.decl("padding", "0 10px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--text-color) 11%, transparent)"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 92%, var(--text-color) 8%)")
                ),

                CSS.rule(
                    ".\(block)__history-label",
                    CSS.decl("font-weight", "720"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block)__date",
                    CSS.decl("font-variant-numeric", "tabular-nums")
                ),

                CSS.rule(
                    ".\(block)__subjects",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "6px")
                ),

                CSS.rule(
                    ".\(block)__subject",
                    CSS.decl("padding", "0 9px"),
                    CSS.decl("font-weight", "680"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 9%, transparent)"),
                    CSS.decl("color", "color-mix(in srgb, var(--link-color) 74%, var(--text-color) 26%)")
                )
            ]
        )
    }
}
