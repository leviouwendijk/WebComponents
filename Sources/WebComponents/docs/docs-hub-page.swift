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
    public let eyebrow: String
    public let searchPlaceholder: String?
    public let lexicon: DocsLexicon
    public let includeStyles: Bool

    public init(
        knowledgeBase: DocsKnowledgeBase,
        title: String,
        lead: String,
        eyebrow: String? = nil,
        searchPlaceholder: String? = nil,
        lexicon: DocsLexicon = .english,
        includeStyles: Bool = true
    ) {
        self.knowledgeBase = knowledgeBase
        self.title = title
        self.lead = lead
        self.eyebrow = eyebrow ?? knowledgeBase.subtitle ?? knowledgeBase.title
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
                            HTML.text(eyebrow)
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
                                lexicon: lexicon,
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
                    CSS.decl("--hub-surface", "var(--surface-color, #ffffff)"),
                    CSS.decl("--hub-surface-soft", "var(--surface-soft-color, #eeeeee)"),
                    CSS.decl("--hub-border", "var(--border-color, rgba(0, 0, 0, .12))"),
                    CSS.decl("--hub-text", "var(--text-color, #222222)"),
                    CSS.decl("--hub-muted", "var(--muted-text-color, rgba(0, 0, 0, .62))"),
                    CSS.decl("width", "min(1180px, calc(100% - 48px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "58px 0 88px"),
                    CSS.decl("color", "var(--hub-text)")
                ),

                CSS.rule(
                    ".\(block)__hero",
                    CSS.decl("max-width", "860px"),
                    CSS.decl("margin", "0 0 34px")
                ),

                CSS.rule(
                    ".\(block)__kicker",
                    CSS.decl("margin", "0 0 10px"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--hub-muted)")
                ),

                CSS.rule(
                    ".\(block)__hero h1",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(2.4rem, 6vw, 5rem)"),
                    CSS.decl("line-height", ".98"),
                    CSS.decl("letter-spacing", "-.055em")
                ),

                CSS.rule(
                    ".\(block)__lead",
                    CSS.decl("max-width", "740px"),
                    CSS.decl("margin", "18px 0 0"),
                    CSS.decl("font-size", "1.08rem"),
                    CSS.decl("line-height", "1.65"),
                    CSS.decl("color", "var(--hub-muted)")
                ),

                CSS.rule(
                    ".\(block)__search",
                    CSS.decl("display", "flex"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("max-width", "620px"),
                    CSS.decl("margin", "28px 0 0")
                ),

                CSS.rule(
                    ".\(block)__search input",
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "44px"),
                    CSS.decl("padding", "0 14px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("border", "1px solid var(--hub-border)"),
                    CSS.decl("background", "var(--hub-surface)"),
                    CSS.decl("color", "var(--hub-text)"),
                    CSS.decl("font", "inherit")
                ),

                CSS.rule(
                    ".\(block)__search button",
                    CSS.decl("height", "44px"),
                    CSS.decl("padding", "0 18px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("border", "1px solid var(--hub-border)"),
                    CSS.decl("background", "var(--hub-text)"),
                    CSS.decl("color", "var(--background-color)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-weight", "700")
                ),

                CSS.rule(
                    ".\(block)__grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(3, minmax(0, 1fr))"),
                    CSS.decl("gap", "16px")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 920px)",
                    CSS.rule(
                        ".\(block)__grid",
                        CSS.decl("grid-template-columns", "repeat(2, minmax(0, 1fr))")
                    )
                ),

                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("width", "calc(100% - 32px)"),
                        CSS.decl("padding", "38px 0 72px")
                    ),
                    CSS.rule(
                        ".\(block)__grid",
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        ".\(block)__search",
                        CSS.decl("display", "block")
                    ),
                    CSS.rule(
                        ".\(block)__search button",
                        CSS.decl("display", "none")
                    )
                )
            ]
        )
    }
}
