import Constructors
import CSS
import HTML
import JS

public struct DocsPreviewEmbedded: ReusableComponent, Sendable {
    private struct RenderedCategory: Sendable {
        let category: DocsCategory
        let key: String
        let panelID: String
        let nodes: ReusableComponentNodes
    }

    public let id: String
    public let site: DocsSite
    public let projectID: String
    public let categoryIDs: [String]?
    public let contentMode: DocsCategoryContentMode
    public let lexicon: DocsLexicon
    public let destinationOrigin: String?
    public let initialCategoryID: String?
    public let openCategoryLabel: String
    public let openLinksInNewTab: Bool
    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        id: String = "docs-project-preview",
        site: DocsSite,
        projectID: String,
        categoryIDs: [String]? = nil,
        contentMode: DocsCategoryContentMode = .scrollDocument,
        lexicon: DocsLexicon = .english,
        destinationOrigin: String? = nil,
        initialCategoryID: String? = nil,
        openCategoryLabel: String = "Open section",
        openLinksInNewTab: Bool = false,
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
        self.id = id
        self.site = site
        self.projectID = projectID
        self.categoryIDs = categoryIDs
        self.contentMode = contentMode
        self.lexicon = lexicon
        self.destinationOrigin = destinationOrigin
        self.initialCategoryID = initialCategoryID
        self.openCategoryLabel = openCategoryLabel
        self.openLinksInNewTab = openLinksInNewTab
        self.includeStyles = includeStyles
        self.includeScript = includeScript
    }

    public var nodes: ReusableComponentNodes {
        guard let project = site.project(
            id: projectID
        ) else {
            return .init()
        }

        let rendered = renderedCategories(
            in: project
        )

        guard let active = rendered.first(where: { item in
            item.category.id == initialCategoryID
        }) ?? rendered.first else {
            return .init()
        }

        let contextNodes = DocsProjectContextNav(
            site: site,
            context: .projectHub(project),
            lexicon: lexicon,
            includeStyles: false
        ).nodes

        let categoryNavigationNodes = DocsCategoryNav(
            categories: rendered.map(\.category),
            activeID: active.category.id,
            ariaLabel: lexicon.categoryNavAriaLabel,
            includeStyles: false
        ).nodes

        let inlinePreviewRuntime = ReusableComponentNodes(
            stylesheets: includeStyles
                ? [
                    HoverPreviewLink.stylesheet(),
                    ReferencePreviewLink.stylesheet()
                ]
                : [],
            scripts: includeScript
                ? PreviewCoordinatorScript().nodes.scripts
                : []
        )

        var stylesheets: [CSSStyleSheet] = []
        var scripts: [JSScript] = []

        if includeStyles {
            stylesheets = [
                Self.stylesheet(),
                DocsProjectContextNav.stylesheet(),
                DocsCategoryNav.stylesheet()
            ]
                + contextNodes.stylesheets
                + categoryNavigationNodes.stylesheets
                + rendered.flatMap { item in
                    item.nodes.stylesheets
                }
                + inlinePreviewRuntime.stylesheets
        }

        if includeScript {
            scripts = contextNodes.scripts
                + categoryNavigationNodes.scripts
                + rendered.flatMap { item in
                    item.nodes.scripts
                }
                + inlinePreviewRuntime.scripts
                + DocsProjectContextNavScript().nodes.scripts
                + DocsCategoryNavScript().nodes.scripts
                + DocsPreviewEmbeddedScript().nodes.scripts
        }

        return .init(
            head: contextNodes.head
                + categoryNavigationNodes.head
                + rendered.flatMap { item in
                    item.nodes.head
                },
            body: [
                rootNode(
                    project: project,
                    rendered: rendered,
                    active: active,
                    contextNodes: contextNodes,
                    categoryNavigationNodes: categoryNavigationNodes
                )
            ],
            stylesheets: stylesheets,
            scripts: scripts
        )
    }

    private func selectedCategories(
        in project: DocsProject
    ) -> [DocsCategory] {
        guard let categoryIDs else {
            return project.knowledgeBase.categories
        }

        return categoryIDs.compactMap { categoryID in
            project.category(
                id: categoryID
            )
        }
    }

    private func renderedCategories(
        in project: DocsProject
    ) -> [RenderedCategory] {
        selectedCategories(
            in: project
        ).map { category in
            let panelID = "\(id)-panel-\(category.id)"

            let pane = DocsCategoryPane(
                category: category,
                mode: contentMode,
                surface: .embedded(
                    id: "\(panelID)-pane"
                ),
                currentHref: category.href,
                lexicon: lexicon,
                includeReferences: true,
                includeStyles: includeStyles,
                includeScript: includeScript
            )

            return RenderedCategory(
                category: category,
                key: category.id,
                panelID: panelID,
                nodes: pane.nodes
            )
        }
    }

    private func rootNode(
        project: DocsProject,
        rendered: [RenderedCategory],
        active: RenderedCategory,
        contextNodes: ReusableComponentNodes,
        categoryNavigationNodes: ReusableComponentNodes
    ) -> any HTMLNode {
        HTML.div(
            [
                "id": id,
                "class": "wc-docs-project-preview",
                "role": "region",
                "aria-label": project.label,
                "data-docs-project-preview": "",
                "data-docs-project-preview-active": active.key,
                "data-docs-project-preview-origin": destinationOrigin ?? "",
                "data-docs-project-preview-new-tab": openLinksInNewTab
                    ? "true"
                    : "false"
            ]
        ) {
            contextNodes.body
            categoryNavigationNodes.body

            HTML.div(
                [
                    "class": "wc-docs-project-preview__viewport",
                    "data-docs-project-preview-viewport": ""
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

    private func panelNode(
        _ item: RenderedCategory,
        isActive: Bool
    ) -> any HTMLNode {
        var attributes: HTMLAttribute = [
            "id": item.panelID,
            "class": "wc-docs-project-preview__panel",
            "role": "region",
            "aria-label": item.category.label,
            "data-docs-project-preview-panel": item.key
        ]

        if !isActive {
            attributes.merge(
                [
                    "hidden": ""
                ]
            )
        }

        return HTML.div(attributes) {
            item.nodes.body
        }
    }

    private func destinationHref(
        _ href: String
    ) -> String {
        guard !href.hasPrefix("#"),
              !href.hasPrefix("http://"),
              !href.hasPrefix("https://"),
              !href.hasPrefix("mailto:"),
              !href.hasPrefix("tel:"),
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
        var attributes: HTMLAttribute = [
            "class": "wc-docs-project-preview__destination",
            "data-docs-project-preview-destination": ""
        ]

        if openLinksInNewTab {
            attributes.merge(
                [
                    "target": "_blank",
                    "rel": "noopener noreferrer"
                ]
            )
        }

        return attributes
    }
}
