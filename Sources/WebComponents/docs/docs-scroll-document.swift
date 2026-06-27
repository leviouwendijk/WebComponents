import Constructors
import CSS
import HTML
import JS

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

        // self.kicker = kicker ?? lexicon.contentKicker
        self.kicker = kicker ?? category.subtitle ?? lexicon.contentKicker

        self.lexicon = lexicon
        self.includeReferences = includeReferences
        self.includeStyles = includeStyles
        self.includeScript = includeScript
    }

    public var resolvedContent: ArticleItem.ReferenceResolved {
        CitationResolver.resolve(
            from: unresolvedContentContainerChildren()
        )
    }

    public func navigation(
        includeReferencesTitle referencesTitle: String? = nil
    ) -> NavigationStructure {
        var roots = category.navigation.roots
        let resolved = resolvedContent

        if includeReferences,
            let referencesTitle,
            resolved.hasBackmatter
        {
            roots.append(
                NavigationNode(
                    label: resolved.references.isEmpty ? lexicon.footnotesTitle : referencesTitle,
                    path: "#references"
                )
            )
        }

        return NavigationStructure(
            roots: roots
        )
    }

    public var nodes: ReusableComponentNodes {
        let resolved = resolvedContent
        var contentChildren = resolved.body

        if includeReferences {
            contentChildren +=
                DocsReferenceSection(
                    references: resolved.references,
                    footnotes: resolved.footnotes,
                    title: lexicon.referencesTitle,
                    footnotesTitle: lexicon.footnotesTitle,
                    includeStyles: false
                ).nodes.body
        }

        let readingControls = readingControlNodes()

        let body: HTMLFragment = [
            HTML.comment("Docs Scroll Document"),
            HTMLElement(
                "main",
                attrs: rootAttributes(),
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
            stylesheets: stylesheets(
                readingControls: readingControls
            ),
            scripts: scripts(
                readingControls: readingControls
            )
        )
    }

    private func readingControlNodes() -> ReusableComponentNodes {
        guard showsReadingControls else {
            return .init()
        }

        return DocsReadingControls(
            includeStyles: includeStyles,
            includeScript: includeScript
        ).nodes
    }

    private var showsReadingControls: Bool {
        switch category.reading.controls {
        case .enabled:
            return true

        case .disabled:
            return false
        }
    }

    private func rootAttributes() -> HTMLAttribute {
        var attrs: HTMLAttribute = [
            "id": "content-area",
            "class": "docs-scroll-content \(Self.block)",
            "data-wc-docs-scroll-document": category.id
        ]

        guard category.reading.enabled else {
            return attrs
        }

        attrs.merge([
            "data-docs-reading": "enabled",
            "data-docs-default-text-scale": category.reading.textScale.rawValue,
            "data-docs-default-paragraph-mode": category.reading.paragraph.rawValue,
            "data-docs-text-scale": category.reading.textScale.rawValue,
            "data-docs-paragraph-mode": category.reading.paragraph.rawValue,
            "data-docs-drop-cap": category.reading.dropCap.rawValue
        ])

        return attrs
    }

    private func stylesheets(
        readingControls: ReusableComponentNodes
    ) -> [CSSStyleSheet] {
        guard includeStyles else {
            return []
        }

        return [
            Self.stylesheet(),
            DocsArticleMetaSummary.stylesheet(),
            DocsReferenceSection.stylesheet()
        ] + readingControls.stylesheets
    }

    private func scripts(
        readingControls: ReusableComponentNodes
    ) -> [JSScript] {
        guard includeScript else {
            return []
        }

        return DocsScrollSpyScript().nodes.scripts
            + readingControls.scripts
    }

    private func unresolvedContentContainerChildren() -> HTMLFragment {
        var renderer = DocsReadableBodyRenderer()
        var sectionNodes: HTMLFragment = []

        for section in category.sections {
            sectionNodes.append(
                sectionNode(
                    section,
                    renderer: &renderer
                )
            )
        }

        let readingControls = readingControlNodes()

        var children: HTMLFragment = [
            heroNode()
        ]

        children += readingControls.body

        children.append(
            HTMLElement(
                "div",
                attrs: [
                    "class": "docs-scroll-sections \(Self.block)__body"
                ],
                children: sectionNodes
            )
        )

        return children
    }

    private func heroNode() -> any HTMLNode {
        var children: HTMLFragment = [
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

        if let articleMeta = category.articleMeta {
            children += DocsArticleMetaSummary(
                meta: articleMeta,
                labels: lexicon.articleMetaLabels,
                includeStyles: false
            ).nodes.body
        }

        return HTMLElement(
            "header",
            attrs: [
                "class": "docs-scroll-hero \(Self.block)__hero"
            ],
            children: children
        )
    }

    private func sectionNode(
        _ section: DocsSection,
        renderer: inout DocsReadableBodyRenderer
    ) -> any HTMLNode {
        let headingLevel = itemHeadingLevel(
            for: section
        )

        var children: [any HTMLNode] = []

        if section.presentation == .chapter {
            children.append(
                sectionHeaderNode(section)
            )
        }

        for item in section.items {
            children.append(
                itemNode(
                    item,
                    headingLevel: headingLevel,
                    renderer: &renderer
                )
            )
        }

        return HTMLElement(
            "section",
            attrs: sectionAttrs(section),
            children: children
        )
    }

    private func sectionAttrs(
        _ section: DocsSection
    ) -> HTMLAttribute {
        var attrs: HTMLAttribute = [
            "id": section.id,
            "class": sectionClass(section),
            "data-docs-section": section.id
        ]

        if section.presentation == .chapter {
            attrs.merge([
                "data-scroll-section": section.id
            ])
        }

        return attrs
    }

    private func sectionClass(
        _ section: DocsSection
    ) -> String {
        switch section.presentation {
        case .chapter:
            return "\(Self.block)__section \(Self.block)__section--chapter"

        case .structural:
            return "\(Self.block)__section \(Self.block)__section--structural"

        case .group:
            return "\(Self.block)__section \(Self.block)__section--group"
        }
    }

    private func itemHeadingLevel(
        for section: DocsSection
    ) -> Int {
        switch section.presentation {
        case .chapter:
            return 3

        case .structural, .group:
            return 2
        }
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
        _ item: DocsItem,
        headingLevel: Int,
        renderer: inout DocsReadableBodyRenderer
    ) -> any HTMLNode {
        var children: [any HTMLNode] = []

        if item.header {
            children.append(
                itemHeaderNode(
                    item,
                    headingLevel: headingLevel
                )
            )
        }

        children.append(
            HTMLElement(
                "div",
                attrs: [
                    "class": "\(Self.block)__item-body"
                ],
                children: itemContent(
                    item,
                    renderer: &renderer
                )
            )
        )

        return children.asArticle(
            id: item.id,
            className: "\(Self.block)__item"
        )
    }

    private func itemContent(
        _ item: DocsItem,
        renderer: inout DocsReadableBodyRenderer
    ) -> HTMLFragment {
        switch item.content {
        case .fragment(let body):
            return body()

        case .article(let body):
            return renderer.render(body)
        }
    }

    private func itemHeaderNode(
        _ item: DocsItem,
        headingLevel: Int
    ) -> any HTMLNode {
        HTMLElement(
            "header",
            attrs: [
                "class": "\(Self.block)__item-header"
            ],
            children: [
                HTMLElement(
                    "h\(headingLevel)",
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
                    CSS.decl("width", "min(780px, calc(100% - 48px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "52px 0 96px"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("--wc-docs-reading-scale", "1"),
                    CSS.decl("--wc-docs-reading-font-size", "calc(1rem * var(--wc-docs-reading-scale))"),
                    CSS.decl("--wc-docs-reading-line-height", "1.68")
                ),

                CSS.rule(
                    ".\(block)[data-docs-reading=\"enabled\"]",
                    CSS.decl("width", "min(820px, calc(100% - 48px))")
                ),

                CSS.rule(
                    ".\(block)[data-docs-text-scale=\"small\"]",
                    CSS.decl("--wc-docs-reading-scale", ".94")
                ),

                CSS.rule(
                    ".\(block)[data-docs-text-scale=\"normal\"]",
                    CSS.decl("--wc-docs-reading-scale", "1")
                ),

                CSS.rule(
                    ".\(block)[data-docs-text-scale=\"large\"]",
                    CSS.decl("--wc-docs-reading-scale", "1.12")
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
                    ".\(block)__section--structural",
                    CSS.decl("margin-bottom", "0")
                ),

                CSS.rule(
                    ".\(block)__section-header",
                    CSS.decl("margin", "0 0 28px"),
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
                    CSS.decl("margin", "0 0 42px"),
                    CSS.decl("scroll-margin-top", "calc(var(--wc-docs-sticky-offset, 112px) + 24px)")
                ),

                CSS.rule(
                    ".\(block)__item:last-child",
                    CSS.decl("margin-bottom", "0")
                ),

                CSS.rule(
                    ".\(block)__item-header",
                    CSS.decl("margin", "0 0 14px")
                ),

                CSS.rule(
                    ".\(block)__item h2, .\(block)__item h3",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(1.42rem, 2.2vw, 1.78rem)"),
                    CSS.decl("line-height", "1.12"),
                    CSS.decl("letter-spacing", "-.025em")
                ),

                CSS.rule(
                    ".\(block)__section--chapter .\(block)__item h3",
                    CSS.decl("font-size", "1.22rem"),
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
                    CSS.decl("margin-top", "16px")
                ),

                CSS.rule(
                    ".\(block)__item-body p",
                    CSS.decl("font-size", "var(--wc-docs-reading-font-size)"),
                    CSS.decl("line-height", "var(--wc-docs-reading-line-height)")
                ),

                CSS.rule(
                    ".\(block)[data-docs-paragraph-mode=\"book\"] .\(block)__item-body p",
                    CSS.decl("margin-block", "0"),
                    CSS.decl("text-indent", "0"),
                    CSS.decl("text-align", "justify"),
                    CSS.decl("text-align-last", "left"),
                    CSS.decl("-webkit-text-align-last", "left"),
                    CSS.decl("hyphens", "auto"),
                    CSS.decl("-webkit-hyphens", "auto"),
                    CSS.decl("overflow-wrap", "normal"),
                    CSS.decl("word-break", "normal")
                ),

                CSS.rule(
                    ".\(block)[data-docs-paragraph-mode=\"book\"] .\(block)__item-body p + p",
                    CSS.decl("text-indent", "1.55em")
                ),

                CSS.rule(
                    ".\(block)[data-docs-paragraph-mode=\"book\"] [data-docs-readable-paragraph]",
                    CSS.decl("margin-block", "0"),
                    CSS.decl("text-indent", "0"),
                    CSS.decl("text-align", "justify"),
                    CSS.decl("text-align-last", "left"),
                    CSS.decl("-webkit-text-align-last", "left"),
                    CSS.decl("hyphens", "auto"),
                    CSS.decl("-webkit-hyphens", "auto"),
                    CSS.decl("overflow-wrap", "normal"),
                    CSS.decl("word-break", "normal")
                ),

                CSS.rule(
                    ".\(block)[data-docs-paragraph-mode=\"book\"] [data-docs-readable-after-paragraph=\"true\"]",
                    CSS.decl("text-indent", "1.55em")
                ),

                CSS.rule(
                    ".\(block)[data-docs-drop-cap=\"first\"] [data-docs-readable-first-paragraph=\"true\"]::first-letter",
                    CSS.decl("float", "left"),
                    CSS.decl("font-size", "3.55em"),
                    CSS.decl("line-height", ".76"),
                    CSS.decl("margin", ".07em .13em -.08em 0"),
                    CSS.decl("padding-right", "0"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", "-.045em")
                ),

                CSS.rule(
                    ".\(block)__item-body pre",
                    CSS.decl("overflow-x", "auto")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("width", "100%"),
                        CSS.decl("padding", "34px 18px 76px")
                    ),

                    CSS.rule(
                        ".\(block)__hero",
                        CSS.decl("margin-bottom", "36px")
                    ),

                    CSS.rule(
                        ".\(block)__section",
                        CSS.decl("margin-bottom", "44px")
                    )
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
