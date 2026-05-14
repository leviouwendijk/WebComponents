import Constructors
import CSS
import HTML

public struct DocsDefinitionIndex: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-definition-index"

    public let category: DocsCategory
    public let eyebrow: String
    public let includeStyles: Bool

    public init(
        category: DocsCategory,
        eyebrow: String = "Definities",
        includeStyles: Bool = true
    ) {
        self.category = category
        self.eyebrow = eyebrow
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
            stylesheets: includeStyles ? [Self.stylesheet()] : []
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
                    CSS.decl("--definition-card", "color-mix(in srgb, var(--background-color) 92%, var(--text-color) 8%)"),
                    CSS.decl("--definition-border", "var(--border-color)"),
                    CSS.decl("--definition-muted", "color-mix(in srgb, var(--text-color) 62%, transparent)"),
                    CSS.decl("width", "min(980px, calc(100% - 48px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "56px 0 96px"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".dark-mode .\(block)",
                    CSS.decl("--definition-card", "color-mix(in srgb, var(--background-color) 86%, var(--text-color) 8%)")
                ),

                CSS.rule(
                    ".\(block)__header",
                    CSS.decl("margin", "0 0 38px"),
                    CSS.decl("padding-bottom", "24px"),
                    CSS.decl("border-bottom", "1px solid var(--definition-border)")
                ),

                CSS.rule(
                    ".\(block)__eyebrow",
                    CSS.decl("margin", "0 0 10px"),
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--definition-muted)")
                ),

                CSS.rule(
                    ".\(block)__header h1",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(2.1rem, 5vw, 4rem)"),
                    CSS.decl("line-height", "1.02"),
                    CSS.decl("letter-spacing", "-.04em")
                ),

                CSS.rule(
                    ".\(block)__header > p:last-child",
                    CSS.decl("max-width", "760px"),
                    CSS.decl("margin", "18px 0 0"),
                    CSS.decl("font-size", "1.04rem"),
                    CSS.decl("line-height", "1.65"),
                    CSS.decl("color", "var(--definition-muted)")
                ),

                CSS.rule(
                    ".\(block)__section",
                    CSS.decl("scroll-margin-top", "calc(var(--wc-docs-sticky-offset, 112px) + 24px)"),
                    CSS.decl("margin", "0 0 44px")
                ),

                CSS.rule(
                    ".\(block)__section-header",
                    CSS.decl("margin", "0 0 18px")
                ),

                CSS.rule(
                    ".\(block)__section-header h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.35rem")
                ),

                CSS.rule(
                    ".\(block)__section-header p",
                    CSS.decl("max-width", "720px"),
                    CSS.decl("margin", "8px 0 0"),
                    CSS.decl("color", "var(--definition-muted)")
                ),

                CSS.rule(
                    ".\(block)__grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(2, minmax(0, 1fr))"),
                    CSS.decl("gap", "14px")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("width", "calc(100% - 32px)"),
                        CSS.decl("padding", "38px 0 72px")
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

public struct DocsDefinitionCard: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-definition-card"

    public let item: DocsItem
    public let includeStyles: Bool

    public init(
        item: DocsItem,
        includeStyles: Bool = true
    ) {
        self.item = item
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.a(
                    item.href,
                    [
                        "id": item.id,
                        "class": "docs-definition-card \(Self.block)",
                        "data-docs-section": item.id
                    ]
                ) {
                    HTML.span(["class": "docs-definition-card__kicker \(Self.block)__kicker"]) {
                        HTML.text("Definitie")
                    }

                    HTML.h3 {
                        HTML.text(item.title)
                    }

                    HTML.p {
                        HTML.text(item.summary)
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
                    CSS.decl("min-height", "0"),
                    CSS.decl("padding", "18px 18px 16px"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("border", "1px solid var(--definition-border, var(--border-color))"),
                    CSS.decl("background", "var(--definition-card, var(--background-color))"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("scroll-margin-top", "calc(var(--wc-docs-sticky-offset, 112px) + 24px)")
                ),

                CSS.rule(
                    ".\(block):hover",
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("border-color", "color-mix(in srgb, var(--text-color) 28%, var(--border-color))"),
                    CSS.decl("background", "color-mix(in srgb, var(--definition-card, var(--background-color)) 88%, var(--text-color) 6%)")
                ),

                CSS.rule(
                    ".\(block)__kicker",
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "0 0 8px"),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".1em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color) 50%, transparent)")
                ),

                CSS.rule(
                    ".\(block) h3",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.05rem"),
                    CSS.decl("line-height", "1.18")
                ),

                CSS.rule(
                    ".\(block) p",
                    CSS.decl("margin", "9px 0 0"),
                    CSS.decl("font-size", ".93rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color) 64%, transparent)")
                )
            ]
        )
    }
}
