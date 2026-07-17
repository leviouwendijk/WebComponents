import Constructors
import CSS
import HTML
import JS

public struct DocsProjectPreview: ReusableComponent, Sendable {
    private struct RenderedCategory: Sendable {
        let category: DocsCategory
        let key: String
        let panelID: String
        let nodes: ReusableComponentNodes
    }

    public let id: String
    public let project: DocsProject
    public let categoryIDs: [String]?
    public let lexicon: DocsLexicon
    public let destinationOrigin: String?
    public let initialCategoryID: String?
    public let itemLimitPerCategory: Int?
    public let openCategoryLabel: String
    public let openLinksInNewTab: Bool
    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        id: String = "docs-project-preview",
        project: DocsProject,
        categoryIDs: [String]? = nil,
        lexicon: DocsLexicon = .english,
        destinationOrigin: String? = nil,
        initialCategoryID: String? = nil,
        itemLimitPerCategory: Int? = 3,
        openCategoryLabel: String = "Open section",
        openLinksInNewTab: Bool = false,
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
        self.id = id
        self.project = project
        self.categoryIDs = categoryIDs
        self.lexicon = lexicon
        self.destinationOrigin = destinationOrigin
        self.initialCategoryID = initialCategoryID
        self.itemLimitPerCategory = itemLimitPerCategory
        self.openCategoryLabel = openCategoryLabel
        self.openLinksInNewTab = openLinksInNewTab
        self.includeStyles = includeStyles
        self.includeScript = includeScript
    }

    public var nodes: ReusableComponentNodes {
        let rendered = renderedCategories()

        guard let active = rendered.first(where: { rendered in
            rendered.category.id == initialCategoryID
        }) ?? rendered.first else {
            return .init()
        }

        return .init(
            head: rendered.flatMap { $0.nodes.head },
            body: [
                rootNode(
                    rendered,
                    active: active
                )
            ],
            stylesheets: includeStyles
                ? [
                    Self.stylesheet()
                ] + rendered.flatMap { $0.nodes.stylesheets }
                : [],
            scripts: includeScript
                ? rendered.flatMap { $0.nodes.scripts }
                    + DocsProjectPreviewScript().nodes.scripts
                : []
        )
    }

    private func renderedCategories() -> [RenderedCategory] {
        let categories: [DocsCategory]

        if let categoryIDs {
            categories = categoryIDs.compactMap { id in
                project.category(
                    id: id
                )
            }
        } else {
            categories = project.knowledgeBase.categories
        }

        return categories.map { category in
            let projected = projectedCategory(
                category
            )
            let panelID = "\(id)-panel-\(category.id)"
            let documentID = "\(panelID)-document"

            let document = DocsScrollDocument(
                category: projected,
                lexicon: lexicon,
                surface: .embedded(
                    id: documentID
                ),
                includeReferences: false,
                includeStyles: includeStyles,
                includeScript: includeScript
            )

            return RenderedCategory(
                category: projected,
                key: category.id,
                panelID: panelID,
                nodes: document.nodes
            )
        }
    }

    private func projectedCategory(
        _ category: DocsCategory
    ) -> DocsCategory {
        guard let itemLimitPerCategory else {
            return category
        }

        var remaining = max(
            itemLimitPerCategory,
            0
        )
        var sections: [DocsSection] = []

        for section in category.sections where remaining > 0 {
            let items = Array(
                section.items.prefix(remaining)
            )

            guard !items.isEmpty else {
                continue
            }

            sections.append(
                DocsSection(
                    id: section.id,
                    title: section.title,
                    summary: section.summary,
                    items: items,
                    presentation: section.presentation,
                    visibility: section.visibility
                )
            )

            remaining -= items.count
        }

        return DocsCategory(
            id: category.id,
            label: category.label,
            subtitle: category.subtitle,
            description: category.description,
            href: category.href,
            sections: sections,
            reading: category.reading,
            articleMeta: category.articleMeta,
            articleAuthors: category.articleAuthors,
            visibility: category.visibility
        )
    }

    private func rootNode(
        _ rendered: [RenderedCategory],
        active: RenderedCategory
    ) -> any HTMLNode {
        HTML.div(
            [
                "id": id,
                "class": "wc-docs-project-preview",
                "data-docs-project-preview": "",
                "data-docs-project-preview-active": active.key
            ]
        ) {
            HTML.div(
                [
                    "class": "wc-docs-project-preview__toolbar"
                ]
            ) {
                HTML.a(
                    destinationHref(
                        project.href
                    ),
                    linkAttributes(
                        className: "wc-docs-project-preview__brand"
                    )
                ) {
                    HTML.span(
                        [
                            "class": "wc-docs-project-preview__brand-mark"
                        ]
                    ) {
                        HTML.text(
                            String(project.label.prefix(1))
                        )
                    }

                    HTML.span(
                        [
                            "class": "wc-docs-project-preview__brand-title"
                        ]
                    ) {
                        HTML.text(
                            project.label
                        )
                    }

                    HTML.span(
                        [
                            "class": "wc-docs-project-preview__brand-product",
                            "aria-hidden": "true"
                        ]
                    ) {
                        HTML.text(
                            "/ \(lexicon.docs)"
                        )
                    }
                }
            }

            HTML.div(
                [
                    "class": "wc-docs-project-preview__body"
                ]
            ) {
                HTML.aside(
                    [
                        "class": "wc-docs-project-preview__navigation",
                        "aria-label": lexicon.categoryNavAriaLabel
                    ]
                ) {
                    HTML.p(
                        [
                            "class": "wc-docs-project-preview__navigation-label"
                        ]
                    ) {
                        HTML.text(
                            lexicon.categoryPluralLabel
                        )
                    }

                    HTML.div(
                        [
                            "class": "wc-docs-project-preview__tabs",
                            "role": "tablist"
                        ]
                    ) {
                        for item in rendered {
                            categoryTab(
                                item,
                                isActive: item.key == active.key
                            )
                        }
                    }
                }

                HTML.div(
                    [
                        "class": "wc-docs-project-preview__content"
                    ]
                ) {
                    HTML.div(
                        [
                            "class": "wc-docs-project-preview__panels"
                        ]
                    ) {
                        for item in rendered {
                            panelNode(
                                item,
                                isActive: item.key == active.key
                            )
                        }
                    }

                    HTML.div(
                        [
                            "class": "wc-docs-project-preview__footer"
                        ]
                    ) {
                        HTML.span(
                            [
                                "class": "wc-docs-project-preview__current",
                                "data-docs-project-preview-current": ""
                            ]
                        ) {
                            HTML.text(
                                active.category.label
                            )
                        }

                        HTML.a(
                            destinationHref(
                                active.category.href
                            ),
                            destinationLinkAttributes()
                        ) {
                            HTML.text(
                                openCategoryLabel
                            )

                            HTML.span(
                                [
                                    "aria-hidden": "true"
                                ]
                            ) {
                                HTML.text(" ↗")
                            }
                        }
                    }
                }
            }
        }
    }

    private func categoryTab(
        _ item: RenderedCategory,
        isActive: Bool
    ) -> any HTMLNode {
        var attrs: HTMLAttribute = [
            "type": "button",
            "class": "wc-docs-project-preview__tab",
            "role": "tab",
            "aria-selected": isActive ? "true" : "false",
            "aria-controls": item.panelID,
            "data-docs-project-preview-tab": item.key,
            "data-docs-project-preview-href": destinationHref(
                item.category.href
            ),
            "data-docs-project-preview-label": item.category.label
        ]

        if !isActive {
            attrs.merge(
                [
                    "tabindex": "-1"
                ]
            )
        }

        return HTML.button(attrs) {
            HTML.span(
                [
                    "class": "wc-docs-project-preview__tab-title"
                ]
            ) {
                HTML.text(
                    item.category.label
                )
            }

            HTML.span(
                [
                    "class": "wc-docs-project-preview__tab-summary"
                ]
            ) {
                HTML.text(
                    item.category.description
                )
            }
        }
    }

    private func panelNode(
        _ item: RenderedCategory,
        isActive: Bool
    ) -> any HTMLNode {
        var attrs: HTMLAttribute = [
            "id": item.panelID,
            "class": "wc-docs-project-preview__panel",
            "role": "tabpanel",
            "aria-label": item.category.label,
            "data-docs-project-preview-panel": item.key
        ]

        if !isActive {
            attrs.merge(
                [
                    "hidden": ""
                ]
            )
        }

        return HTML.div(attrs) {
            item.nodes.body
        }
    }

    private func destinationHref(
        _ href: String
    ) -> String {
        guard !href.hasPrefix("http://"),
              !href.hasPrefix("https://"),
              let destinationOrigin,
              !destinationOrigin.isEmpty else {
            return href
        }

        let origin = destinationOrigin.hasSuffix("/")
            ? String(destinationOrigin.dropLast())
            : destinationOrigin
        let path = href.hasPrefix("/")
            ? href
            : "/\(href)"

        return origin + path
    }

    private func destinationLinkAttributes() -> HTMLAttribute {
        var attrs = linkAttributes(
            className: "wc-docs-project-preview__destination"
        )

        attrs.merge(
            [
                "data-docs-project-preview-destination": ""
            ]
        )

        return attrs
    }

    private func linkAttributes(
        className: String
    ) -> HTMLAttribute {
        var attrs: HTMLAttribute = [
            "class": className
        ]

        if openLinksInNewTab {
            attrs.merge(
                [
                    "target": "_blank",
                    "rel": "noopener noreferrer"
                ]
            )
        }

        return attrs
    }
}
