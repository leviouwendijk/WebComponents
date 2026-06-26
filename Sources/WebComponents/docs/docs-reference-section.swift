import Constructors
import CSS
import HTML

public struct DocsReferenceSection: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-reference-section"

    public let references: [Reference]
    public let title: String
    public let includeStyles: Bool

    public init(
        references: [Reference],
        title: String,
        includeStyles: Bool = true
    ) {
        self.references = references
        self.title = title
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        guard !references.isEmpty else {
            return .init()
        }

        return .body(
            [
                HTML.section(
                    [
                        "id": "references",
                        "class": "docs-reference-section \(Self.block)",
                        "data-docs-section": "references",
                        "data-scroll-section": "references"
                    ]
                ) {
                    HTML.h2 {
                        HTML.text(title)
                    }

                    HTML.ol(["class": "refs-list \(Self.block)__list"]) {
                        for reference in references {
                            reference
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet(), ReferenceReviewNotes.stylesheet()] : []
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("margin-top", "56px"),
                    CSS.decl("padding-top", "28px"),
                    CSS.decl("border-top", "1px solid var(--border-color)"),
                    CSS.decl("scroll-margin-top", "calc(var(--wc-docs-sticky-offset, 112px) + 24px)")
                ),

                CSS.rule(
                    ".\(block) h2",
                    CSS.decl("margin", "0 0 18px"),
                    CSS.decl("font-size", "1.35rem"),
                    CSS.decl("letter-spacing", "-.02em")
                ),

                CSS.rule(
                    ".\(block)__list",
                    CSS.decl("list-style", "none"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "0")
                ),

                CSS.rule(
                    ".\(block) .ref-item",
                    CSS.decl("margin", "0 0 14px"),
                    CSS.decl("padding", "12px 14px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "10px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))")
                ),

                CSS.rule(
                    ".\(block) .ref-author, .\(block) .ref-date, .\(block) .ref-doi",
                    CSS.decl("display", "block"),
                    CSS.decl("margin-top", "4px"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block) .ref-comment",
                    CSS.decl("margin-top", "10px"),
                    CSS.decl("padding", "10px 12px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "8px")
                )
            ]
        )
    }
}
