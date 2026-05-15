import Constructors
import CSS
import HTML

public struct DocsHubPage: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-hub"

    public let knowledgeBase: DocsKnowledgeBase
    public let title: String
    public let lead: String
    public let searchPlaceholder: String?
    public let lexicon: DocsLexicon
    public let includeStyles: Bool

    public init(
        knowledgeBase: DocsKnowledgeBase,
        title: String,
        lead: String,
        searchPlaceholder: String? = nil,
        lexicon: DocsLexicon = .english,
        includeStyles: Bool = true
    ) {
        self.knowledgeBase = knowledgeBase
        self.title = title
        self.lead = lead
        self.searchPlaceholder = searchPlaceholder ?? lexicon.searchKnowledgeBasePlaceholder
        self.lexicon = lexicon
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.main(
                    [
                        "id": "content-area",
                        "class": "docs-hub \(Self.block)",
                        "data-docs-search": ""
                    ]
                ) {
                    HTML.section(["class": "docs-hub-hero \(Self.block)__hero"]) {
                        HTML.p(["class": "docs-hub-kicker \(Self.block)__kicker"]) {
                            HTML.text(knowledgeBase.title)
                        }

                        HTML.h1 {
                            HTML.text(title)
                        }

                        HTML.p(["class": "docs-hub-lead \(Self.block)__lead"]) {
                            HTML.text(lead)
                        }

                        if let searchPlaceholder {
                            HTML.div(["class": "docs-hub-search \(Self.block)__search"]) {
                                HTML.input([
                                    "type": "search",
                                    "placeholder": searchPlaceholder,
                                    "aria-label": lexicon.searchKnowledgeBaseAriaLabel,
                                    "data-docs-search-input": ""
                                ])

                                HTML.button(["type": "button"]) {
                                    HTML.text(lexicon.searchButton)
                                }
                            }
                        }
                    }

                    HTML.section(["class": "docs-hub-primary-grid \(Self.block)__grid"]) {
                        for category in knowledgeBase.categories {
                            DocsHubCard(
                                category: category,
                                includeStyles: false
                            ).nodes.body
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [
                Self.stylesheet(),
                DocsHubCard.stylesheet(),
                DocsFuzzySearchScript.stylesheet()
            ] : [],
            scripts: DocsFuzzySearchScript().nodes.scripts
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("--hub-surface", "#ffffff"),
                    CSS.decl("--hub-surface-soft", "#f5f8fb"),
                    CSS.decl("--hub-border", "rgba(15, 23, 42, .10)"),
                    CSS.decl("--hub-text", "var(--text-color, #222)"),
                    CSS.decl("--hub-muted", "color-mix(in srgb, var(--hub-text) 62%, transparent)"),
                    CSS.decl("--hub-shadow", "0 18px 40px rgba(15, 23, 42, .08)"),
                    CSS.decl("width", "min(1180px, calc(100% - 48px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "64px 0 104px"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("color", "var(--hub-text)")
                ),

                CSS.rule(
                    ".dark-mode .\(block)",
                    CSS.decl("--hub-surface", "#202124"),
                    CSS.decl("--hub-surface-soft", "#18191c"),
                    CSS.decl("--hub-border", "rgba(255, 255, 255, .12)"),
                    CSS.decl("--hub-shadow", "0 18px 40px rgba(0, 0, 0, .28)")
                ),

                CSS.rule(
                    ".\(block)__hero",
                    CSS.decl("max-width", "900px"),
                    CSS.decl("margin", "0 0 44px")
                ),

                CSS.rule(
                    ".\(block)__kicker",
                    CSS.decl("margin", "0 0 12px"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--hub-muted)")
                ),

                CSS.rule(
                    ".\(block)__hero h1",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(2.3rem, 5.5vw, 4.8rem)"),
                    CSS.decl("line-height", ".98"),
                    CSS.decl("letter-spacing", "-.055em")
                ),

                CSS.rule(
                    ".\(block)__lead",
                    CSS.decl("max-width", "780px"),
                    CSS.decl("margin", "22px 0 0"),
                    CSS.decl("font-size", "1.08rem"),
                    CSS.decl("line-height", "1.68"),
                    CSS.decl("color", "var(--hub-muted)")
                ),

                CSS.rule(
                    ".\(block)__search",
                    CSS.decl("display", "flex"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("max-width", "680px"),
                    CSS.decl("margin", "28px 0 0")
                ),

                CSS.rule(
                    ".\(block)__search input",
                    CSS.decl("flex", "1"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("border", "1px solid var(--hub-border)"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("background", "var(--hub-surface)"),
                    CSS.decl("color", "var(--hub-text)"),
                    CSS.decl("padding", "12px 14px"),
                    CSS.decl("font", "inherit")
                ),

                CSS.rule(
                    ".\(block)__search button",
                    CSS.decl("border", "1px solid var(--hub-border)"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("background", "var(--hub-surface-soft)"),
                    CSS.decl("color", "var(--hub-text)"),
                    CSS.decl("padding", "12px 16px"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(block)__grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(2, minmax(0, 1fr))"),
                    CSS.decl("gap", "18px")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 760px)",
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("width", "calc(100% - 32px)"),
                        CSS.decl("padding", "42px 0 78px")
                    ),
                    CSS.rule(
                        ".\(block)__grid",
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        ".\(block)__search",
                        CSS.decl("flex-direction", "column")
                    )
                )
            ]
        )
    }
}

public struct DocsHubCard: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-hub-card"

    public let category: DocsCategory
    public let includeStyles: Bool

    public init(
        category: DocsCategory,
        includeStyles: Bool = true
    ) {
        self.category = category
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.a(
                    category.href,
                    [
                        "class": "docs-hub-card \(Self.block)",
                        "data-docs-search-item": "",
                        "data-docs-search-text": searchText
                    ]
                ) {
                    HTML.span(["class": "docs-hub-card__eyebrow \(Self.block)__eyebrow"]) {
                        HTML.text(category.id)
                    }

                    HTML.h2 {
                        HTML.text(category.label)
                    }

                    HTML.p {
                        HTML.text(category.description)
                    }

                    HTML.span(["class": "docs-hub-card__meta \(Self.block)__meta"]) {
                        HTML.text("\(category.items.count) onderdelen")
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    private var searchText: String {
        let itemText = category.items
            .map { item in
                "\(item.id) \(item.title) \(item.summary)"
            }
            .joined(separator: " ")

        return "\(category.id) \(category.label) \(category.description) \(itemText)"
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("display", "block"),
                    CSS.decl("padding", "24px"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("border", "1px solid var(--hub-border)"),
                    CSS.decl("background", "var(--hub-surface)"),
                    CSS.decl("box-shadow", "var(--hub-shadow)"),
                    CSS.decl("color", "var(--hub-text)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".\(block):hover",
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("background", "var(--hub-surface-soft)")
                ),

                CSS.rule(
                    ".\(block)__eyebrow",
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "0 0 12px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".1em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--hub-muted)")
                ),

                CSS.rule(
                    ".\(block) h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.45rem"),
                    CSS.decl("line-height", "1.12")
                ),

                CSS.rule(
                    ".\(block) p",
                    CSS.decl("margin", "12px 0 0"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("color", "var(--hub-muted)")
                ),

                CSS.rule(
                    ".\(block)__meta",
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "18px 0 0"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("color", "var(--hub-muted)")
                )
            ]
        )
    }
}
