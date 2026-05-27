import Constructors
import CSS
import HTML

public struct DocsHubCard: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-hub-card"

    public let category: DocsCategory
    public let lexicon: DocsLexicon
    public let includeStyles: Bool

    public init(
        category: DocsCategory,
        lexicon: DocsLexicon = .english,
        includeStyles: Bool = true
    ) {
        self.category = category
        self.lexicon = lexicon
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        let eyebrow = category.subtitle ?? category.id

        return .body(
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
                        HTML.text(eyebrow)
                    }

                    HTML.h2 {
                        HTML.text(category.label)
                    }

                    HTML.p {
                        HTML.text(category.description)
                    }

                    HTML.span(["class": "docs-hub-card__meta \(Self.block)__meta"]) {
                        HTML.text(lexicon.entryCountLabel(category.items.count))
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

        return "\(category.id) \(category.label) \(category.subtitle ?? "") \(category.description) \(itemText)"
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
