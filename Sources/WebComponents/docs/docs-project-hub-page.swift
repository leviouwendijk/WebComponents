import Constructors
import CSS
import HTML

public struct DocsProjectHubPage: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-project-hub"

    public let title: String
    public let lead: String
    public let projects: [DocsProject]
    public let eyebrow: String
    public let searchPlaceholder: String?
    public let lexicon: DocsLexicon
    public let includeStyles: Bool

    public init(
        title: String,
        lead: String,
        projects: [DocsProject],
        eyebrow: String? = nil,
        searchPlaceholder: String? = nil,
        lexicon: DocsLexicon = .english,
        includeStyles: Bool = true
    ) {
        self.title = title
        self.lead = lead
        self.projects = projects
        self.lexicon = lexicon
        self.eyebrow = eyebrow ?? lexicon.docs
        self.searchPlaceholder = searchPlaceholder ?? lexicon.searchProjectsPlaceholder
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.main(
                    [
                        "id": "content-area",
                        "class": "docs-project-hub \(Self.block)",
                        "data-docs-search": ""
                    ]
                ) {
                    HTML.section(["class": "docs-project-hub__hero \(Self.block)__hero"]) {
                        HTML.p(["class": "docs-project-hub__eyebrow \(Self.block)__eyebrow"]) {
                            HTML.text(eyebrow)
                        }

                        HTML.h1 {
                            HTML.text(title)
                        }

                        HTML.p(["class": "docs-project-hub__lead \(Self.block)__lead"]) {
                            HTML.text(lead)
                        }

                        if let searchPlaceholder {
                            HTML.div(["class": "docs-project-hub__search \(Self.block)__search"]) {
                                HTML.input([
                                    "type": "search",
                                    "placeholder": searchPlaceholder,
                                    "aria-label": lexicon.searchProjectsAriaLabel,
                                    "data-docs-search-input": ""
                                ])
                            }
                        }
                    }

                    HTML.section(["class": "docs-project-hub__grid \(Self.block)__grid"]) {
                        for project in projects {
                            DocsProjectCard(
                                project: project,
                                lexicon: lexicon,
                                includeStyles: false
                            ).nodes.body
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [
                Self.stylesheet(),
                DocsProjectCard.stylesheet(),
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
                    CSS.decl("--project-hub-surface", "var(--surface-color, #ffffff)"),
                    CSS.decl("--project-hub-soft", "var(--surface-soft-color, #eeeeee)"),
                    CSS.decl("--project-hub-border", "var(--border-color, rgba(0, 0, 0, .12))"),
                    CSS.decl("--project-hub-text", "var(--text-color, #222222)"),
                    CSS.decl("--project-hub-muted", "var(--muted-text-color, rgba(0, 0, 0, .62))"),
                    CSS.decl("width", "min(1180px, calc(100% - 48px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "68px 0 104px"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("color", "var(--project-hub-text)")
                ),

                CSS.rule(
                    ".\(block)__hero",
                    CSS.decl("max-width", "900px"),
                    CSS.decl("margin", "0 0 44px")
                ),

                CSS.rule(
                    ".\(block)__eyebrow",
                    CSS.decl("margin", "0 0 12px"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--project-hub-muted)")
                ),

                CSS.rule(
                    ".\(block)__hero h1",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(2.4rem, 6vw, 5.2rem)"),
                    CSS.decl("line-height", ".98"),
                    CSS.decl("letter-spacing", "-.055em")
                ),

                CSS.rule(
                    ".\(block)__lead",
                    CSS.decl("max-width", "760px"),
                    CSS.decl("margin", "22px 0 0"),
                    CSS.decl("font-size", "1.08rem"),
                    CSS.decl("line-height", "1.68"),
                    CSS.decl("color", "var(--project-hub-muted)")
                ),

                CSS.rule(
                    ".\(block)__search",
                    CSS.decl("max-width", "680px"),
                    CSS.decl("margin", "28px 0 0")
                ),

                CSS.rule(
                    ".\(block)__search input",
                    CSS.decl("width", "100%"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("border", "1px solid var(--project-hub-border)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "var(--project-hub-surface)"),
                    CSS.decl("color", "var(--project-hub-text)"),
                    CSS.decl("padding", "13px 15px"),
                    CSS.decl("font", "inherit")
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
                        CSS.decl("padding", "44px 0 78px")
                    ),
                    CSS.rule(
                        ".\(block)__grid",
                        CSS.decl("grid-template-columns", "1fr")
                    )
                )
            ]
        )
    }
}

public struct DocsProjectCard: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-project-card"

    public let project: DocsProject
    public let lexicon: DocsLexicon
    public let includeStyles: Bool

    public init(
        project: DocsProject,
        lexicon: DocsLexicon = .english,
        includeStyles: Bool = true
    ) {
        self.project = project
        self.lexicon = lexicon
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.a(
                    project.href,
                    [
                        "class": "docs-project-card \(Self.block)",
                        "data-docs-search-item": "",
                        "data-docs-search-text": "\(project.id) \(project.label) \(project.description)"
                    ]
                ) {
                    HTML.span(["class": "\(Self.block)__eyebrow"]) {
                        HTML.text(project.id)
                    }

                    HTML.h2 {
                        HTML.text(project.label)
                    }

                    HTML.p {
                        HTML.text(project.description)
                    }

                    HTML.span(["class": "\(Self.block)__meta"]) {
                        HTML.text(
                            "\(lexicon.categoryCountLabel(project.categoryCount)) · \(lexicon.entryCountLabel(project.itemCount))"
                        )
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
                    CSS.decl("padding", "25px"),
                    CSS.decl("border-radius", "20px"),
                    CSS.decl("border", "1px solid var(--project-hub-border, var(--border-color))"),
                    CSS.decl("background", "var(--project-hub-surface, var(--surface-color))"),
                    CSS.decl("color", "var(--project-hub-text, var(--text-color))"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("min-height", "220px")
                ),

                CSS.rule(
                    ".\(block):hover",
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("background", "var(--project-hub-soft, var(--surface-soft-color))")
                ),

                CSS.rule(
                    ".\(block)__eyebrow",
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "0 0 14px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".1em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--project-hub-muted, var(--muted-text-color))")
                ),

                CSS.rule(
                    ".\(block) h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.55rem"),
                    CSS.decl("line-height", "1.08"),
                    CSS.decl("letter-spacing", "-.025em")
                ),

                CSS.rule(
                    ".\(block) p",
                    CSS.decl("margin", "14px 0 0"),
                    CSS.decl("max-width", "560px"),
                    CSS.decl("line-height", "1.56"),
                    CSS.decl("color", "var(--project-hub-muted, var(--muted-text-color))")
                ),

                CSS.rule(
                    ".\(block)__meta",
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "22px 0 0"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("color", "var(--project-hub-muted, var(--muted-text-color))")
                )
            ]
        )
    }
}
