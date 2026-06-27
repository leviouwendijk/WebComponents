import Constructors
import CSS
import HTML

public struct DocsReferenceSection: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-reference-section"

    public let references: [Reference]
    public let footnotes: [FootnoteReference]
    public let title: String
    public let footnotesTitle: String
    public let includeStyles: Bool

    public init(
        references: [Reference],
        footnotes: [FootnoteReference] = [],
        title: String,
        footnotesTitle: String = "Notes",
        includeStyles: Bool = true
    ) {
        self.references = references
        self.footnotes = footnotes
        self.title = title
        self.footnotesTitle = footnotesTitle
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        guard !references.isEmpty || !footnotes.isEmpty else {
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
                    if !footnotes.isEmpty {
                        HTML.div([ "class": "\(Self.block)__group \(Self.block)__group--footnotes" ]) {
                            HTML.h2 {
                                HTML.text(footnotesTitle)
                            }

                            HTML.ol([ "class": "footnotes-list \(Self.block)__list \(Self.block)__notes-list" ]) {
                                for footnote in footnotes {
                                    footnote
                                }
                            }
                        }
                    }

                    if !references.isEmpty {
                        HTML.div([ "class": "\(Self.block)__group \(Self.block)__group--references" ]) {
                            HTML.h2 {
                                HTML.text(title)
                            }

                            HTML.ol([ "class": "refs-list \(Self.block)__list \(Self.block)__refs-list" ]) {
                                for reference in references {
                                    reference
                                }
                            }
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
                    ".\(block)__group + .\(block)__group",
                    CSS.decl("margin-top", "32px")
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
                    ".\(block) .ref-item, .\(block) .footnote-item",
                    CSS.decl("margin", "0 0 14px"),
                    CSS.decl("padding", "12px 14px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "10px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))")
                ),

                CSS.rule(
                    // ".\(block) .footnote-backlink",
                    ".\(block) .footnote-backlink, .\(block) .ref-backlink",
                    CSS.decl("font-weight", "760"),
                    CSS.decl("color", "var(--link-color)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    // ".\(block) .footnote-backlink:hover, .\(block) .footnote-backlink:focus-visible",
                    ".\(block) .footnote-backlink:hover, .\(block) .footnote-backlink:focus-visible, .\(block) .ref-backlink:hover, .\(block) .ref-backlink:focus-visible",
                    CSS.decl("text-decoration", "underline"),
                    CSS.decl("text-decoration-thickness", ".08em"),
                    CSS.decl("text-underline-offset", ".16em")
                ),

                CSS.rule(
                    ".\(block) .footnote-text",
                    CSS.decl("line-height", "1.55")
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
