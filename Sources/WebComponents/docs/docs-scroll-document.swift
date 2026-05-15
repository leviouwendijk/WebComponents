import Constructors
import CSS
import HTML

public struct DocsScrollDocument: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-scroll-document"

    public let category: DocsCategory
    public let kicker: String
    public let lexicon: DocsLexicon
    public let includeReferences: Bool
    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        category: DocsCategory,
        kicker: String? = nil,
        lexicon: DocsLexicon = .english,
        includeReferences: Bool = true,
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
        self.category = category
        self.kicker = kicker ?? lexicon.contentKicker
        self.lexicon = lexicon
        self.includeReferences = includeReferences
        self.includeStyles = includeStyles
        self.includeScript = includeScript
    }

    public var nodes: ReusableComponentNodes {
        let unresolved = unresolvedBody()
        let resolved = CitationResolver.resolve(from: unresolved)

        var body = resolved.body

        if includeReferences {
            body += DocsReferenceSection(
                references: resolved.references,
                title: lexicon.referencesTitle,
                includeStyles: false
            ).nodes.body
        }

        return .body(
            body,
            stylesheets: includeStyles ? [
                Self.stylesheet(),
                DocsReferenceSection.stylesheet()
            ] : [],
            scripts: includeScript ? DocsScrollSpyScript().nodes.scripts : []
        )
    }

    private func unresolvedBody() -> HTMLFragment {
        [
            HTML.comment("Docs Scroll Document"),
            HTML.main(
                [
                    "id": "content-area",
                    "class": "docs-scroll-content \(Self.block)",
                    "data-wc-docs-scroll-document": category.id
                ]
            ) {
                HTML.div(["id": "content-text-container"]) {
                    HTML.header(["class": "docs-scroll-hero \(Self.block)__hero"]) {
                        HTML.p(["class": "docs-scroll-kicker \(Self.block)__kicker"]) {
                            HTML.text(kicker)
                        }

                        HTML.h1 {
                            HTML.text(category.label)
                        }

                        HTML.p(["class": "docs-scroll-lead \(Self.block)__lead"]) {
                            HTML.text(category.description)
                        }
                    }

                    HTML.div(["class": "docs-scroll-sections \(Self.block)__body"]) {
                        for section in category.sections {
                            sectionNode(section)
                        }
                    }
                }
            }
        ]
    }

    private func sectionNode(
        _ section: DocsSection
    ) -> any HTMLNode {
        HTML.section(
            [
                "id": section.id,
                "class": "\(Self.block)__section",
                "data-docs-section": section.id,
                "data-scroll-section": section.id
            ]
        ) {
            HTML.header(["class": "\(Self.block)__section-header"]) {
                HTML.h2 {
                    HTML.text(section.title)
                }

                if let summary = section.summary, !summary.isEmpty {
                    HTML.p {
                        HTML.text(summary)
                    }
                }
            }

            for item in section.items {
                itemNode(item)
            }
        }
    }

    private func itemNode(
        _ item: DocsItem
    ) -> any HTMLNode {
        HTML.article(
            [
                "id": item.id,
                "class": "\(Self.block)__item",
                "data-docs-section": item.id,
                "data-scroll-section": item.id
            ]
        ) {
            HTML.header(["class": "\(Self.block)__item-header"]) {
                HTML.h3 {
                    HTML.text(item.title)
                }

                HTML.p(["class": "\(Self.block)__item-summary"]) {
                    HTML.text(item.summary)
                }
            }

            HTML.div(["class": "\(Self.block)__item-body"]) {
                item.body()
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("width", "min(780px, 100%)"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "52px 0 96px"),
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(block)__hero",
                    CSS.decl("margin", "0 0 48px")
                ),

                CSS.rule(
                    ".\(block)__kicker",
                    CSS.decl("margin", "0 0 8px"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__hero h1",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(2.2rem, 5vw, 4.4rem)"),
                    CSS.decl("line-height", ".95"),
                    CSS.decl("letter-spacing", "-.055em")
                ),

                CSS.rule(
                    ".\(block)__lead",
                    CSS.decl("max-width", "680px"),
                    CSS.decl("margin", "18px 0 0"),
                    CSS.decl("font-size", "1.08rem"),
                    CSS.decl("line-height", "1.56"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__section",
                    CSS.decl("margin", "0 0 56px"),
                    CSS.decl("scroll-margin-top", "calc(var(--wc-docs-sticky-offset, 112px) + 24px)")
                ),

                CSS.rule(
                    ".\(block)__section-header",
                    CSS.decl("margin", "0 0 22px"),
                    CSS.decl("padding-bottom", "16px"),
                    CSS.decl("border-bottom", "1px solid var(--border-color)")
                ),

                CSS.rule(
                    ".\(block)__section-header h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.55rem"),
                    CSS.decl("line-height", "1.08"),
                    CSS.decl("letter-spacing", "-.025em")
                ),

                CSS.rule(
                    ".\(block)__section-header p",
                    CSS.decl("margin", "10px 0 0"),
                    CSS.decl("line-height", "1.52"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__item",
                    CSS.decl("margin", "0 0 34px")
                ),

                CSS.rule(
                    ".\(block)__item-header",
                    CSS.decl("margin", "0 0 14px")
                ),

                CSS.rule(
                    ".\(block)__item h3",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.22rem"),
                    CSS.decl("line-height", "1.18"),
                    CSS.decl("letter-spacing", "-.015em")
                ),

                CSS.rule(
                    ".\(block)__item-summary",
                    CSS.decl("margin", "8px 0 0"),
                    CSS.decl("line-height", "1.5"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__item-body",
                    CSS.decl("margin-top", "14px")
                ),

                CSS.rule(
                    ".\(block)__item-body p",
                    CSS.decl("line-height", "1.68")
                ),

                CSS.rule(
                    ".\(block)__item-body pre",
                    CSS.decl("overflow-x", "auto")
                )
            ]
        )
    }
}
