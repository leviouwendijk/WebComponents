import Constructors
import CSS
import HTML

public struct DocsActionCard: ReusableComponent, Sendable {
    public static let block = "wc-docs-action-card"

    public let href: String
    public let eyebrow: String
    public let title: String
    public let summary: String
    public let meta: String?
    public let searchText: String
    public let includeStyles: Bool

    public init(
        href: String,
        eyebrow: String,
        title: String,
        summary: String,
        meta: String? = nil,
        searchText: String? = nil,
        includeStyles: Bool = true
    ) {
        self.href = href
        self.eyebrow = eyebrow
        self.title = title
        self.summary = summary
        self.meta = meta
        self.searchText = searchText ?? "\(eyebrow) \(title) \(summary) \(meta ?? "")"
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.a(
                    href,
                    [
                        "class": "docs-action-card \(Self.block)",
                        "data-docs-search-item": "",
                        "data-docs-search-text": searchText
                    ]
                ) {
                    HTML.span(["class": "\(Self.block)__eyebrow"]) {
                        HTML.text(eyebrow)
                    }

                    HTML.h3 {
                        HTML.text(title)
                    }

                    HTML.p {
                        HTML.text(summary)
                    }

                    if let meta, !meta.isEmpty {
                        HTML.span(["class": "\(Self.block)__meta"]) {
                            HTML.text(meta)
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("display", "block"),
                    CSS.decl("padding", "22px"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("border", "1px solid var(--project-hub-border, var(--border-color, rgba(0, 0, 0, .12)))"),
                    CSS.decl("background", "var(--project-hub-surface, var(--surface-color, #ffffff))"),
                    CSS.decl("color", "var(--project-hub-text, var(--text-color, #222222))"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("min-height", "172px")
                ),

                CSS.rule(
                    ".\(block):hover",
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("background", "var(--project-hub-soft, var(--surface-soft-color, #eeeeee))")
                ),

                CSS.rule(
                    ".\(block)__eyebrow",
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "0 0 12px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".1em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--project-hub-muted, var(--muted-text-color, rgba(0, 0, 0, .62)))")
                ),

                CSS.rule(
                    ".\(block) h3",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.32rem"),
                    CSS.decl("line-height", "1.12"),
                    CSS.decl("letter-spacing", "-.02em")
                ),

                CSS.rule(
                    ".\(block) p",
                    CSS.decl("margin", "12px 0 0"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("color", "var(--project-hub-muted, var(--muted-text-color, rgba(0, 0, 0, .62)))")
                ),

                CSS.rule(
                    ".\(block)__meta",
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "18px 0 0"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("color", "var(--project-hub-muted, var(--muted-text-color, rgba(0, 0, 0, .62)))")
                )
            ]
        )
    }
}

public struct DocsActionSection: ReusableComponent, Sendable {
    public static let block = "wc-docs-action-section"

    public let title: String
    public let lead: String?
    public let cards: [DocsActionCard]
    public let includeStyles: Bool

    public init(
        title: String,
        lead: String? = nil,
        cards: [DocsActionCard],
        includeStyles: Bool = true
    ) {
        self.title = title
        self.lead = lead
        self.cards = cards
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.section(["class": "docs-action-section \(Self.block)"]) {
                    HTML.div(["class": "\(Self.block)__header"]) {
                        HTML.h2 {
                            HTML.text(title)
                        }

                        if let lead, !lead.isEmpty {
                            HTML.p {
                                HTML.text(lead)
                            }
                        }
                    }

                    HTML.div(["class": "\(Self.block)__grid"]) {
                        for card in cards {
                            card.nodes.body
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [
                Self.stylesheet(),
                DocsActionCard.stylesheet()
            ] : []
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("margin", "26px 0 0"),
                    CSS.decl("padding", "24px"),
                    CSS.decl("border-radius", "24px"),
                    CSS.decl("border", "1px solid var(--project-hub-border, var(--border-color, rgba(0, 0, 0, .12)))"),
                    CSS.decl("background", "color-mix(in srgb, var(--project-hub-surface, #ffffff) 82%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__header",
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("align-items", "end"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("margin", "0 0 18px")
                ),

                CSS.rule(
                    ".\(block)__header h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase")
                ),

                CSS.rule(
                    ".\(block)__header p",
                    CSS.decl("max-width", "560px"),
                    CSS.decl("margin", "0"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("color", "var(--project-hub-muted, var(--muted-text-color, rgba(0, 0, 0, .62)))")
                ),

                CSS.rule(
                    ".\(block)__grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(3, minmax(0, 1fr))"),
                    CSS.decl("gap", "14px")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 900px)",
                    CSS.rule(
                        ".\(block)__grid",
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        ".\(block)__header",
                        CSS.decl("display", "block")
                    ),
                    CSS.rule(
                        ".\(block)__header p",
                        CSS.decl("margin", "8px 0 0")
                    )
                )
            ]
        )
    }
}
