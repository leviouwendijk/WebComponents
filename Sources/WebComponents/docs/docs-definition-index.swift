import Constructors
import CSS
import HTML

public typealias DocsDefinitionRelatedLinkProvider = @Sendable (
    _ item: DocsItem,
    _ category: DocsCategory
) -> [DocsDefinitionRelatedLink]

public struct DocsDefinitionRelatedLink: Sendable {
    public let label: String
    public let href: String
    public let preview: HoverPreview?

    public init(
        label: String,
        href: String,
        preview: HoverPreview? = nil
    ) {
        self.label = label
        self.href = href
        self.preview = preview
    }
}

public struct DocsDefinitionIndex: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-definition-index"

    public let category: DocsCategory
    public let eyebrow: String
    public let lexicon: DocsLexicon
    public let relatedLinks: DocsDefinitionRelatedLinkProvider
    public let includeStyles: Bool

    public init(
        category: DocsCategory,
        eyebrow: String? = nil,
        lexicon: DocsLexicon = .english,
        relatedLinks: @escaping DocsDefinitionRelatedLinkProvider = { _, _ in [] },
        includeStyles: Bool = true
    ) {
        self.category = category
        self.eyebrow = eyebrow ?? lexicon.definitionPluralLabel
        self.lexicon = lexicon
        self.relatedLinks = relatedLinks
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.section(["class": "docs-definitions-index \(Self.block)"]) {
                    HTML.div(["class": "docs-definitions-index__header \(Self.block)__header"]) {
                        HTML.p(["class": "docs-definitions-index__eyebrow \(Self.block)__eyebrow"]) {
                            HTML.text(eyebrow)
                        }

                        HTML.h1 {
                            HTML.text(category.label)
                        }

                        HTML.p {
                            HTML.text(category.description)
                        }
                    }

                    for section in category.sections {
                        sectionNode(section)
                    }
                }
            ],
            stylesheets: includeStyles ? [
                HoverPreviewLink.stylesheet(),
                Self.stylesheet(),
                DocsDefinitionCard.stylesheet()
            ] : []
        )
    }

    private func sectionNode(
        _ section: DocsSection
    ) -> any HTMLNode {
        HTML.section(
            [
                "id": section.id,
                "class": "docs-definition-section \(Self.block)__section",
                "data-docs-section": section.id
            ]
        ) {
            HTML.div(["class": "docs-definition-section__header \(Self.block)__section-header"]) {
                HTML.h2 {
                    HTML.text(section.title)
                }

                if let summary = section.summary, !summary.isEmpty {
                    HTML.p {
                        HTML.text(summary)
                    }
                }
            }

            HTML.div(["class": "docs-definition-grid \(Self.block)__grid"]) {
                for item in section.items {
                    DocsDefinitionCard(
                        item: item,
                        lexicon: lexicon,
                        relatedLinks: relatedLinks(item, category),
                        includeStyles: false
                    ).nodes.body
                }
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("--definition-surface", "var(--background-color)"),
                    CSS.decl("--definition-card", "color-mix(in srgb, var(--background-color) 96%, var(--text-color) 4%)"),
                    CSS.decl("--definition-card-hover", "color-mix(in srgb, var(--background-color) 92%, var(--text-color) 8%)"),
                    CSS.decl("--definition-border", "color-mix(in srgb, var(--border-color) 82%, transparent)"),
                    CSS.decl("--definition-rule", "color-mix(in srgb, var(--text-color) 14%, transparent)"),
                    CSS.decl("--definition-muted", "color-mix(in srgb, var(--text-color) 62%, transparent)"),
                    CSS.decl("width", "min(820px, calc(100% - 48px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "56px 0 96px"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".dark-mode .\(block)",
                    CSS.decl("--definition-card", "color-mix(in srgb, var(--background-color) 90%, var(--text-color) 6%)"),
                    CSS.decl("--definition-card-hover", "color-mix(in srgb, var(--background-color) 84%, var(--text-color) 9%)"),
                    CSS.decl("--definition-border", "color-mix(in srgb, var(--border-color) 72%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__header",
                    CSS.decl("margin", "0 0 42px"),
                    CSS.decl("padding-bottom", "26px"),
                    CSS.decl("border-bottom", "1px solid var(--definition-border)")
                ),

                CSS.rule(
                    ".\(block)__eyebrow",
                    CSS.decl("margin", "0 0 10px"),
                    CSS.decl("font-size", ".74rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".14em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--definition-muted)")
                ),

                CSS.rule(
                    ".\(block)__header h1",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(2.15rem, 5vw, 3.7rem)"),
                    CSS.decl("line-height", "1.02"),
                    CSS.decl("letter-spacing", "-.045em")
                ),

                CSS.rule(
                    ".\(block)__header > p:last-child",
                    CSS.decl("max-width", "720px"),
                    CSS.decl("margin", "18px 0 0"),
                    CSS.decl("font-size", "1.03rem"),
                    CSS.decl("line-height", "1.68"),
                    CSS.decl("color", "var(--definition-muted)")
                ),

                CSS.rule(
                    ".\(block)__section",
                    CSS.decl("scroll-margin-top", "calc(var(--wc-docs-sticky-offset, 112px) + 24px)"),
                    CSS.decl("margin", "0 0 48px")
                ),

                CSS.rule(
                    ".\(block)__section-header",
                    CSS.decl("margin", "0 0 18px")
                ),

                CSS.rule(
                    ".\(block)__section-header h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.28rem"),
                    CSS.decl("letter-spacing", "-.015em")
                ),

                CSS.rule(
                    ".\(block)__section-header p",
                    CSS.decl("max-width", "700px"),
                    CSS.decl("margin", "8px 0 0"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("color", "var(--definition-muted)")
                ),

                CSS.rule(
                    ".\(block)__grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "1fr"),
                    CSS.decl("gap", "12px")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("width", "calc(100% - 32px)"),
                        CSS.decl("padding", "38px 0 72px")
                    )
                )
            ]
        )
    }
}

public struct DocsDefinitionCard: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-definition-card"

    public let item: DocsItem
    public let lexicon: DocsLexicon
    public let relatedLinks: [DocsDefinitionRelatedLink]
    public let relatedLinksLabel: String
    public let includeStyles: Bool

    public init(
        item: DocsItem,
        lexicon: DocsLexicon = .english,
        relatedLinks: [DocsDefinitionRelatedLink] = [],
        relatedLinksLabel: String? = nil,
        includeStyles: Bool = true
    ) {
        self.item = item
        self.lexicon = lexicon
        self.relatedLinks = relatedLinks
        self.relatedLinksLabel = relatedLinksLabel ?? lexicon.definitionRelatedLinksLabel
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.article(
                    [
                        "id": item.id,
                        "class": "docs-definition-card \(Self.block)",
                        "data-docs-section": item.id
                    ]
                ) {
                    HTML.span(["class": "docs-definition-card__kicker \(Self.block)__kicker"]) {
                        HTML.text(lexicon.definitionSingularLabel)
                    }

                    HTML.h3 {
                        HTML.a(
                            item.href,
                            ["class": "\(Self.block)__title-link"]
                        ) {
                            HTML.text(item.title)
                        }
                    }

                    HTML.p(["class": "\(Self.block)__summary"]) {
                        HTML.text(item.summary)
                    }

                    if !relatedLinks.isEmpty {
                        relatedLinksNode()
                    }
                }
            ],
            stylesheets: includeStyles ? [
                HoverPreviewLink.stylesheet(),
                Self.stylesheet()
            ] : []
        )
    }

    private func relatedLinksNode() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__related"]) {
            HTML.span(["class": "\(Self.block)__related-label"]) {
                HTML.text(relatedLinksLabel)
            }

            HTML.span(["class": "\(Self.block)__related-items"]) {
                for relatedLink in relatedLinks {
                    relatedLinkNode(relatedLink)
                }
            }
        }
    }

    private func relatedLinkNode(
        _ relatedLink: DocsDefinitionRelatedLink
    ) -> HTMLFragment {
        if let preview = relatedLink.preview {
            return HoverPreviewLink(
                href: relatedLink.href,
                label: [HTML.text(relatedLink.label)],
                preview: preview
            ).nodes.body
        }

        return [
            HTML.a(
                relatedLink.href,
                ["class": "\(Self.block)__related-link"]
            ) {
                HTML.text(relatedLink.label)
            }
        ]
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "block"),
                    CSS.decl("min-height", "0"),
                    CSS.decl("padding", "20px 22px 18px"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("border", "1px solid var(--definition-border, var(--border-color))"),
                    CSS.decl("border-left", "3px solid var(--definition-rule, var(--border-color))"),
                    CSS.decl("background", "var(--definition-card, var(--background-color))"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("scroll-margin-top", "calc(var(--wc-docs-sticky-offset, 112px) + 24px)"),
                    CSS.decl("transition", "background-color .16s ease, border-color .16s ease, transform .16s ease")
                ),

                CSS.rule(
                    ".\(block):hover",
                    CSS.decl("border-color", "color-mix(in srgb, var(--text-color) 24%, var(--border-color))"),
                    CSS.decl("border-left-color", "color-mix(in srgb, var(--link-color) 72%, var(--text-color) 8%)"),
                    CSS.decl("background", "var(--definition-card-hover, var(--definition-card, var(--background-color)))")
                ),

                CSS.rule(
                    ".\(block)__kicker",
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "0 0 7px"),
                    CSS.decl("font-size", ".66rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".13em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color) 48%, transparent)")
                ),

                CSS.rule(
                    ".\(block) h3",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.12rem"),
                    CSS.decl("line-height", "1.2"),
                    CSS.decl("letter-spacing", "-.012em")
                ),

                CSS.rule(
                    ".\(block)__title-link",
                    CSS.decl("color", "inherit"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".\(block)__title-link:hover",
                    CSS.decl("color", "var(--link-color)"),
                    CSS.decl("text-decoration", "underline"),
                    CSS.decl("text-underline-offset", ".18em")
                ),

                CSS.rule(
                    ".\(block)__summary",
                    CSS.decl("max-width", "64ch"),
                    CSS.decl("margin", "9px 0 0"),
                    CSS.decl("font-size", ".96rem"),
                    CSS.decl("line-height", "1.58"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color) 66%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__related",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "auto minmax(0, 1fr)"),
                    CSS.decl("align-items", "baseline"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("margin", "16px 0 0"),
                    CSS.decl("padding-top", "12px"),
                    CSS.decl("border-top", "1px solid color-mix(in srgb, var(--text-color) 10%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__related-label",
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color) 48%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__related-items",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "7px 8px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__related-link, .\(block)__related .wc-hover-preview__link",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("min-height", "24px"),
                    CSS.decl("padding", "3px 8px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--link-color) 26%, var(--definition-border, var(--border-color)))"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 7%, transparent)"),
                    CSS.decl("color", "var(--link-color)"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("line-height", "1.2"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("text-underline-offset", ".18em")
                ),

                CSS.rule(
                    ".\(block)__related-link:hover, .\(block)__related .wc-hover-preview__link:hover",
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 12%, transparent)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".\(block)__related .wc-hover-preview__link::after",
                    CSS.decl("display", "none")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 560px)",
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("padding", "18px 18px 16px")
                    ),
                    CSS.rule(
                        ".\(block)__related",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "8px")
                    )
                )
            ]
        )
    }
}
