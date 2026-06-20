import Foundation
import Constructors
import CSS
import HTML
import Version

public struct DocsReleaseNotesPage: ReusableComponent, Sendable {
    public struct NoteSection: Sendable {
        public let title: String
        public let items: [String]

        public init(
            title: String,
            items: [String]
        ) {
            self.title = title
            self.items = items
        }
    }

    public struct Entry: Sendable {
        public let version: ObjectVersion
        public let date: String
        public let dateLabel: String?
        public let title: String
        public let summary: String
        public let sections: [NoteSection]

        public var versionLabel: String {
            version.string(
                prefixStyle: .short,
                prefixSpace: false
            )
        }

        public init(
            version: ObjectVersion,
            date: String,
            dateLabel: String? = nil,
            title: String,
            summary: String,
            sections: [NoteSection]
        ) {
            self.version = version
            self.date = date
            self.dateLabel = dateLabel
            self.title = title
            self.summary = summary
            self.sections = sections
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
            lhs.version > rhs.version
        }
    }

    private var currentEntry: Entry? {
        sortedEntries.first
    }

    private var currentVersionLabel: String {
        currentEntry?.versionLabel ?? ""
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

                            HTML.span(["class": "\(Self.block)__current-version"]) {
                                HTML.text(currentVersionLabel)
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

                        if current {
                            HTML.span(["class": "\(Self.block)__badge"]) {
                                HTML.text("Actueel")
                            }
                        }
                    }

                    HTML.el(
                        "time",
                        [
                            "class": "\(Self.block)__date",
                            "datetime": entry.date
                        ]
                    ) {
                        HTML.text(entry.dateLabel ?? entry.date)
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

                if !entry.sections.isEmpty {
                    HTML.div(["class": "\(Self.block)__sections"]) {
                        for section in entry.sections {
                            section_node(section)
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

        return entry.version == currentEntry.version
    }

    private func section_node(
        _ section: NoteSection
    ) -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__section"]) {
            HTML.h3(["class": "\(Self.block)__section-title"]) {
                HTML.text(section.title)
            }

            HTML.ul(["class": "\(Self.block)__list"]) {
                for item in section.items {
                    HTML.li {
                        HTML.text(item)
                    }
                }
            }
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
                    CSS.decl("margin", "0 0 8px")
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
                    CSS.decl("background", "color-mix(in srgb, var(--wc-docs-release-accent) 12%, transparent)"),
                    CSS.decl("color", "var(--wc-docs-release-accent)"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "760")
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
                    ".\(block)__sections",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(auto-fit, minmax(220px, 1fr))"),
                    CSS.decl("gap", "12px")
                ),

                CSS.rule(
                    ".\(block)__section",
                    CSS.decl("padding", "14px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--text-color) 9%, transparent)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-docs-release-soft) 74%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__section-title",
                    CSS.decl("margin", "0 0 8px"),
                    CSS.decl("font-size", ".86rem"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".\(block)__list",
                    CSS.decl("margin", "0"),
                    CSS.decl("padding-left", "1.1rem"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.5")
                ),

                CSS.rule(
                    ".\(block)__list li + li",
                    CSS.decl("margin-top", "5px")
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
