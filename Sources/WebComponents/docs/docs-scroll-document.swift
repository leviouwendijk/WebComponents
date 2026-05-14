import Constructors
import CSS
import HTML

public struct DocsScrollDocument: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-scroll-document"

    public let category: DocsCategory
    public let kicker: String
    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        category: DocsCategory,
        kicker: String = "Kennisbank",
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
        self.category = category
        self.kicker = kicker
        self.includeStyles = includeStyles
        self.includeScript = includeScript
    }

    public var nodes: ReusableComponentNodes {
        let body: HTMLFragment = [
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

        return .body(
            body,
            stylesheets: includeStyles ? [Self.stylesheet()] : [],
            scripts: includeScript ? DocsScrollSpyScript().nodes.scripts : []
        )
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
                "class": "docs-scroll-section \(Self.block)__item",
                "data-docs-section": item.id,
                "data-scroll-section": item.id
            ]
        ) {
            HTML.div(["class": "docs-scroll-section__number \(Self.block)__item-id"]) {
                HTML.text(item.id)
            }

            HTML.div(["class": "docs-scroll-section__body \(Self.block)__item-body"]) {
                HTML.header(["class": "\(Self.block)__item-header"]) {
                    HTML.h2 {
                        HTML.a("#\(item.id)", ["class": "\(Self.block)__heading-link"]) {
                            HTML.text(item.title)
                        }
                    }

                    HTML.p {
                        HTML.text(item.summary)
                    }
                }

                item.body()
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("background", "var(--background-color)"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block) #content-text-container",
                    CSS.decl("width", "min(880px, calc(100% - 48px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(block)__hero",
                    CSS.decl("padding", "56px 0 34px"),
                    CSS.decl("border-bottom", "1px solid var(--border-color)")
                ),

                CSS.rule(
                    ".\(block)__kicker",
                    CSS.decl("margin", "0 0 10px"),
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color) 48%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__hero h1",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(2.2rem, 5vw, 4.2rem)"),
                    CSS.decl("line-height", "1.02"),
                    CSS.decl("letter-spacing", "-.04em"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block)__lead",
                    CSS.decl("max-width", "760px"),
                    CSS.decl("margin", "18px 0 0"),
                    CSS.decl("font-size", "1.05rem"),
                    CSS.decl("line-height", "1.65"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color) 66%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__body",
                    CSS.decl("padding", "0 0 88px")
                ),

                CSS.rule(
                    ".\(block)__section",
                    CSS.decl("scroll-margin-top", "calc(var(--wc-docs-sticky-offset, 112px) + 24px)"),
                    CSS.decl("padding", "42px 0 8px"),
                    CSS.decl("border-bottom", "1px solid var(--border-color)")
                ),

                CSS.rule(
                    ".\(block)__section-header",
                    CSS.decl("margin", "0 0 26px")
                ),

                CSS.rule(
                    ".\(block)__section-header h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.55rem"),
                    CSS.decl("line-height", "1.16"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block)__section-header p",
                    CSS.decl("max-width", "720px"),
                    CSS.decl("margin", "10px 0 0"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color) 62%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__item",
                    CSS.decl("scroll-margin-top", "calc(var(--wc-docs-sticky-offset, 112px) + 24px)")
                ),

                CSS.rule(
                    ".\(block)__item-header h2",
                    CSS.decl("margin", "0 0 7px"),
                    CSS.decl("font-size", "1.25rem"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".\(block)__item-header p",
                    CSS.decl("margin", "0 0 14px"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color) 62%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__heading-link",
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".\(block)__heading-link:hover",
                    CSS.decl("color", "var(--link-color)"),
                    CSS.decl("text-decoration", "underline")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(block) #content-text-container",
                        CSS.decl("width", "calc(100% - 32px)")
                    ),
                    CSS.rule(
                        ".\(block)__hero",
                        CSS.decl("padding", "38px 0 26px")
                    ),
                    CSS.rule(
                        ".\(block)__section",
                        CSS.decl("padding", "34px 0 6px")
                    )
                )
            ]
        )
    }
}
