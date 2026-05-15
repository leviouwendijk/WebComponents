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
        let unresolved = unresolvedContentContainerChildren()
        let resolved = CitationResolver.resolve(from: unresolved)

        var contentChildren = resolved.body

        if includeReferences {
            contentChildren += DocsReferenceSection(
                references: resolved.references,
                title: lexicon.referencesTitle,
                includeStyles: false
            ).nodes.body
        }

        let body: HTMLFragment = [
            HTML.comment("Docs Scroll Document"),
            HTMLElement(
                "main",
                attrs: [
                    "id": "content-area",
                    "class": "docs-scroll-content \(Self.block)",
                    "data-wc-docs-scroll-document": category.id
                ],
                children: [
                    HTMLElement(
                        "div",
                        attrs: [
                            "id": "content-text-container"
                        ],
                        children: contentChildren
                    )
                ]
            )
        ]

        return .body(
            body,
            stylesheets: includeStyles ? [
                Self.stylesheet(),
                DocsReferenceSection.stylesheet()
            ] : [],
            scripts: includeScript ? DocsScrollSpyScript().nodes.scripts : []
        )
    }

    private func unresolvedContentContainerChildren() -> HTMLFragment {
        [
            heroNode(),
            HTMLElement(
                "div",
                attrs: [
                    "class": "docs-scroll-sections \(Self.block)__body"
                ],
                children: category.sections.map { section in
                    sectionNode(section)
                }
            )
        ]
    }

    private func heroNode() -> any HTMLNode {
        HTMLElement(
            "header",
            attrs: [
                "class": "docs-scroll-hero \(Self.block)__hero"
            ],
            children: [
                HTMLElement(
                    "p",
                    attrs: [
                        "class": "docs-scroll-kicker \(Self.block)__kicker"
                    ],
                    children: [
                        HTMLText(kicker)
                    ]
                ),
                HTMLElement(
                    "h1",
                    children: [
                        HTMLText(category.label)
                    ]
                ),
                HTMLElement(
                    "p",
                    attrs: [
                        "class": "docs-scroll-lead \(Self.block)__lead"
                    ],
                    children: [
                        HTMLText(category.description)
                    ]
                )
            ]
        )
    }

    private func sectionNode(
        _ section: DocsSection
    ) -> any HTMLNode {
        var children: [any HTMLNode] = [
            sectionHeaderNode(section)
        ]

        children += section.items.map { item in
            itemNode(item)
        }

        return HTMLElement(
            "section",
            attrs: [
                "id": section.id,
                "class": "\(Self.block)__section",
                "data-docs-section": section.id,
                "data-scroll-section": section.id
            ],
            children: children
        )
    }

    private func sectionHeaderNode(
        _ section: DocsSection
    ) -> any HTMLNode {
        var children: [any HTMLNode] = [
            HTMLElement(
                "h2",
                children: [
                    HTMLText(section.title)
                ]
            )
        ]

        if let summary = section.summary, !summary.isEmpty {
            children.append(
                HTMLElement(
                    "p",
                    children: [
                        HTMLText(summary)
                    ]
                )
            )
        }

        return HTMLElement(
            "header",
            attrs: [
                "class": "\(Self.block)__section-header"
            ],
            children: children
        )
    }

    private func itemNode(
        _ item: DocsItem
    ) -> any HTMLNode {
        [
            itemHeaderNode(item),
            HTMLElement(
                "div",
                attrs: [
                    "class": "\(Self.block)__item-body"
                ],
                children: item.body()
            )
        ].asArticle(
            id: item.id,
            className: "\(Self.block)__item"
        )
    }

    private func itemHeaderNode(
        _ item: DocsItem
    ) -> any HTMLNode {
        HTMLElement(
            "header",
            attrs: [
                "class": "\(Self.block)__item-header"
            ],
            children: [
                HTMLElement(
                    "h3",
                    children: [
                        HTMLText(item.title)
                    ]
                ),
                HTMLElement(
                    "p",
                    attrs: [
                        "class": "\(Self.block)__item-summary"
                    ],
                    children: [
                        HTMLText(item.summary)
                    ]
                )
            ]
        )
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

private extension Array where Element == any HTMLNode {
    func asArticle(
        id: String,
        className: String
    ) -> any HTMLNode {
        HTMLElement(
            "article",
            attrs: [
                "id": id,
                "class": className,
                "data-docs-section": id,
                "data-scroll-section": id
            ],
            children: self
        )
    }
}
