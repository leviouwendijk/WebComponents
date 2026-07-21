import Constructors
import CSS
import HTML
import JS

public struct DocsPreviewTree: ReusableComponent, Sendable {
    public struct Selection: Sendable {
        public let projectID: String?
        public let categoryID: String?
        public let sectionID: String?
        public let itemID: String?

        public init(
            projectID: String? = nil,
            categoryID: String? = nil,
            sectionID: String? = nil,
            itemID: String? = nil
        ) {
            self.projectID = projectID
            self.categoryID = categoryID
            self.sectionID = sectionID
            self.itemID = itemID
        }
    }

    public struct Labels: Sendable {
        public let project: String
        public let category: String
        public let section: String
        public let item: String
        public let structure: String
        public let directChildren: String
        public let descendants: String
        public let openSelection: String
        public let noDirectDestination: String

        public init(
            project: String,
            category: String,
            section: String,
            item: String,
            structure: String,
            directChildren: String,
            descendants: String,
            openSelection: String,
            noDirectDestination: String
        ) {
            self.project = project
            self.category = category
            self.section = section
            self.item = item
            self.structure = structure
            self.directChildren = directChildren
            self.descendants = descendants
            self.openSelection = openSelection
            self.noDirectDestination = noDirectDestination
        }

        public static let english = Self(
            project: "Project",
            category: "Category",
            section: "Section",
            item: "Document",
            structure: "Documentation structure",
            directChildren: "Direct children",
            descendants: "Contained nodes",
            openSelection: "Open section",
            noDirectDestination: "This structural node has no separate page."
        )

        public static let dutch = Self(
            project: "Project",
            category: "Categorie",
            section: "Sectie",
            item: "Onderdeel",
            structure: "Structuur van de documentatie",
            directChildren: "Directe onderdelen",
            descendants: "Onderliggende knooppunten",
            openSelection: "Open onderdeel",
            noDirectDestination: "Dit structurele knooppunt heeft geen afzonderlijke pagina."
        )
    }

    private enum NodeKind: String, Sendable {
        case project
        case category
        case section
        case item
    }

    private struct Node: Sendable {
        let key: String
        let kind: NodeKind
        let sourceID: String
        let projectID: String?
        let categoryID: String?
        let sectionID: String?
        let title: String
        let summary: String?
        let href: String?
        let path: [String]
        let children: [Node]

        var descendantCount: Int {
            children.reduce(0) { partial, child in
                partial + 1 + child.descendantCount
            }
        }

        func contains(
            key requestedKey: String
        ) -> Bool {
            key == requestedKey
                || children.contains { child in
                    child.contains(
                        key: requestedKey
                    )
                }
        }
    }

    public let id: String
    public let site: DocsSite
    public let destinationOrigin: String?
    public let initialSelection: Selection?
    public let lexicon: DocsLexicon
    public let labels: Labels
    public let openLinksInNewTab: Bool
    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        id: String = "docs-preview-tree",
        site: DocsSite,
        destinationOrigin: String? = nil,
        initialSelection: Selection? = nil,
        lexicon: DocsLexicon = .english,
        labels: Labels = .english,
        openLinksInNewTab: Bool = true,
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
        self.id = id
        self.site = site
        self.destinationOrigin = destinationOrigin
        self.initialSelection = initialSelection
        self.lexicon = lexicon
        self.labels = labels
        self.openLinksInNewTab = openLinksInNewTab
        self.includeStyles = includeStyles
        self.includeScript = includeScript
    }

    public var nodes: ReusableComponentNodes {
        guard !site.projects.isEmpty else {
            return .init()
        }

        let roots = site.projects.map { project in
            projectNode(
                project,
                path: []
            )
        }

        let flattened = roots.flatMap { root in
            flattenedNodes(
                root
            )
        }

        let activeKey = initialKey(
            in: flattened
        )

        guard let active = flattened.first(where: { node in
            node.key == activeKey
        }) else {
            return .init()
        }

        let contextNodes = DocsProjectContextNav(
            site: site,
            context: .siteHub(),
            lexicon: lexicon,
            includeStyles: false
        ).nodes

        return .init(
            head: contextNodes.head,
            body: [
                rootNode(
                    roots: roots,
                    flattened: flattened,
                    active: active,
                    contextNodes: contextNodes
                )
            ],
            stylesheets: includeStyles
                ? [
                    DocsProjectContextNav.stylesheet(),
                    Self.stylesheet()
                ] + contextNodes.stylesheets
                : [],
            scripts: includeScript
                ? contextNodes.scripts
                    + DocsPreviewTreeScript().nodes.scripts
                : []
        )
    }

    // private func siteNode() -> Node {
    //     let path = [
    //         site.title
    //     ]

    //     return Node(
    //         key: siteKey(
    //             site.id
    //         ),
    //         kind: .site,
    //         sourceID: site.id,
    //         projectID: nil,
    //         categoryID: nil,
    //         sectionID: nil,
    //         title: site.title,
    //         summary: nil,
    //         href: destinationHref(
    //             site.homeHref
    //         ),
    //         path: path,
    //         children: site.projects.map { project in
    //             projectNode(
    //                 project,
    //                 path: path
    //             )
    //         }
    //     )
    // }

    private func projectNode(
        _ project: DocsProject,
        path: [String]
    ) -> Node {
        let projectPath = path + [
            project.label
        ]

        return Node(
            key: projectKey(
                project.id
            ),
            kind: .project,
            sourceID: project.id,
            projectID: project.id,
            categoryID: nil,
            sectionID: nil,
            title: project.label,
            summary: project.description,
            href: destinationHref(
                project.href
            ),
            path: projectPath,
            children: project
                .knowledgeBase
                .categories
                .map { category in
                    categoryNode(
                        category,
                        project: project,
                        path: projectPath
                    )
                }
        )
    }

    private func categoryNode(
        _ category: DocsCategory,
        project: DocsProject,
        path: [String]
    ) -> Node {
        let categoryPath = path + [
            category.label
        ]

        let children = category.sections.flatMap { section in
            switch section.presentation {
            case .structural:
                return section.items.map { item in
                    itemNode(
                        item,
                        project: project,
                        category: category,
                        section: section,
                        path: categoryPath
                    )
                }

            case .chapter, .group:
                return [
                    sectionNode(
                        section,
                        project: project,
                        category: category,
                        path: categoryPath
                    )
                ]
            }
        }

        return Node(
            key: categoryKey(
                projectID: project.id,
                categoryID: category.id
            ),
            kind: .category,
            sourceID: category.id,
            projectID: project.id,
            categoryID: category.id,
            sectionID: nil,
            title: category.label,
            summary: category.description,
            href: destinationHref(
                category.href
            ),
            path: categoryPath,
            children: children
        )
    }

    private func sectionNode(
        _ section: DocsSection,
        project: DocsProject,
        category: DocsCategory,
        path: [String]
    ) -> Node {
        let sectionPath = path + [
            section.title
        ]

        return Node(
            key: sectionKey(
                projectID: project.id,
                categoryID: category.id,
                sectionID: section.id
            ),
            kind: .section,
            sourceID: section.id,
            projectID: project.id,
            categoryID: category.id,
            sectionID: section.id,
            title: section.title,
            summary: section.summary,
            href: nil,
            path: sectionPath,
            children: section.items.map { item in
                itemNode(
                    item,
                    project: project,
                    category: category,
                    section: section,
                    path: sectionPath
                )
            }
        )
    }

    private func itemNode(
        _ item: DocsItem,
        project: DocsProject,
        category: DocsCategory,
        section: DocsSection,
        path: [String]
    ) -> Node {
        Node(
            key: itemKey(
                projectID: project.id,
                categoryID: category.id,
                sectionID: section.id,
                itemID: item.id
            ),
            kind: .item,
            sourceID: item.id,
            projectID: project.id,
            categoryID: category.id,
            sectionID: section.id,
            title: item.title,
            summary: item.summary,
            href: itemDestinationHref(
                item.href,
                categoryHref: category.href
            ),
            path: path + [
                item.title
            ],
            children: []
        )
    }

    private func rootNode(
        roots: [Node],
        flattened: [Node],
        active: Node,
        contextNodes: ReusableComponentNodes
    ) -> any HTMLNode {
        HTML.div(
            [
                "id": id,
                "class": "wc-docs-preview-tree",
                "role": "region",
                "aria-label": labels.structure,
                "data-docs-preview-tree": "",
                "data-docs-preview-tree-active": active.key,
                "data-docs-preview-tree-origin": destinationOrigin ?? "",
                "data-docs-preview-tree-new-tab": openLinksInNewTab
                    ? "true"
                    : "false"
            ]
        ) {
            contextNodes.body

            HTML.div(
                [
                    "class": "wc-docs-preview-tree__viewport"
                ]
            ) {
                HTML.nav(
                    [
                        "class": "wc-docs-preview-tree__navigation",
                        "aria-label": labels.structure
                    ]
                ) {
                    HTML.ul(
                        [
                            "class": "wc-docs-preview-tree__tree",
                            "role": "tree"
                        ]
                    ) {
                        for root in roots {
                            treeNode(
                                root,
                                activeKey: active.key,
                                depth: 0
                            )
                        }
                    }
                }

                HTML.div(
                    [
                        "class": "wc-docs-preview-tree__inspector",
                        "aria-live": "polite"
                    ]
                ) {
                    for node in flattened {
                        inspectorPanel(
                            node,
                            isActive: node.key == active.key
                        )
                    }
                }
            }

            footer(
                active
            )
        }
    }

    private func treeNode(
        _ node: Node,
        activeKey: String,
        depth: Int
    ) -> any HTMLNode {
        let hasChildren = !node.children.isEmpty
        let isSelected = node.key == activeKey
        let isExpanded = hasChildren
            && node.contains(
                key: activeKey
            )

        return HTML.li(
            [
                "class": "wc-docs-preview-tree__tree-item",
                "role": "treeitem",
                "aria-level": "\(depth + 1)",
                "aria-selected": isSelected ? "true" : "false",
                "data-docs-preview-tree-item": node.key
            ]
        ) {
            HTML.div(
                [
                    "class": "wc-docs-preview-tree__node-row",
                    "style": "--wc-docs-preview-tree-depth: \(depth);"
                ]
            ) {
                if hasChildren {
                    HTML.button(
                        [
                            "type": "button",
                            "class": "wc-docs-preview-tree__toggle",
                            "aria-label": node.title,
                            "aria-expanded": isExpanded ? "true" : "false",
                            "data-docs-preview-tree-toggle": node.key
                        ]
                    ) {
                        HTML.span(
                            [
                                "aria-hidden": "true"
                            ]
                        ) {
                            HTML.text("›")
                        }
                    }
                } else {
                    HTML.span(
                        [
                            "class": "wc-docs-preview-tree__toggle-placeholder",
                            "aria-hidden": "true"
                        ]
                    ) {}
                }

                HTML.button(
                    [
                        "type": "button",
                        "class": "wc-docs-preview-tree__select",
                        "aria-pressed": isSelected ? "true" : "false",
                        "data-docs-preview-tree-select": node.key
                    ]
                ) {
                    HTML.span(
                        [
                            "class": "wc-docs-preview-tree__node-kind"
                        ]
                    ) {
                        HTML.text(
                            kindLabel(
                                node.kind
                            )
                        )
                    }

                    HTML.span(
                        [
                            "class": "wc-docs-preview-tree__node-title"
                        ]
                    ) {
                        HTML.text(
                            node.title
                        )
                    }
                }

                if let href = node.href {
                    HTML.a(
                        href,
                        linkAttributes(
                            className: "wc-docs-preview-tree__node-open"
                        )
                    ) {
                        HTML.span(
                            [
                                "aria-hidden": "true"
                            ]
                        ) {
                            HTML.text("↗")
                        }

                        HTML.span(
                            [
                                "class": "wc-docs-preview-tree__visually-hidden"
                            ]
                        ) {
                            HTML.text(
                                labels.openSelection
                            )
                        }
                    }
                }
            }

            if hasChildren {
                HTML.ul(
                    HTML.attrs(
                        [
                            "class": "wc-docs-preview-tree__branch",
                            "role": "group",
                            "data-docs-preview-tree-branch": node.key
                        ],
                        .bool(
                            "hidden",
                            !isExpanded
                        )
                    )
                ) {
                    for child in node.children {
                        treeNode(
                            child,
                            activeKey: activeKey,
                            depth: depth + 1
                        )
                    }
                }
            }
        }
    }

    private func inspectorPanel(
        _ node: Node,
        isActive: Bool
    ) -> any HTMLNode {
        var attributes: HTMLAttribute = [
            "class": "wc-docs-preview-tree__panel",
            "data-docs-preview-tree-panel": node.key,
            "data-docs-preview-tree-target": node.href ?? ""
        ]

        if !isActive {
            attributes.merge(
                [
                    "hidden": ""
                ]
            )
        }

        return HTML.section(attributes) {
            HTML.p(
                [
                    "class": "wc-docs-preview-tree__panel-kind"
                ]
            ) {
                HTML.text(
                    kindLabel(
                        node.kind
                    )
                )
            }

            HTML.h3(
                [
                    "class": "wc-docs-preview-tree__panel-title"
                ]
            ) {
                HTML.text(
                    node.title
                )
            }

            HTML.p(
                [
                    "class": "wc-docs-preview-tree__path"
                ]
            ) {
                HTML.text(
                    node.path.joined(
                        separator: " / "
                    )
                )
            }

            if let summary = node.summary,
               !summary.isEmpty {
                HTML.p(
                    [
                        "class": "wc-docs-preview-tree__summary"
                    ]
                ) {
                    HTML.text(summary)
                }
            }

            HTML.div(
                [
                    "class": "wc-docs-preview-tree__metrics"
                ]
            ) {
                metric(
                    label: labels.directChildren,
                    value: node.children.count
                )

                metric(
                    label: labels.descendants,
                    value: node.descendantCount
                )
            }

            if !node.children.isEmpty {
                HTML.div(
                    [
                        "class": "wc-docs-preview-tree__children"
                    ]
                ) {
                    for child in node.children {
                        HTML.button(
                            [
                                "type": "button",
                                "class": "wc-docs-preview-tree__child",
                                "data-docs-preview-tree-select": child.key
                            ]
                        ) {
                            HTML.span {
                                HTML.text(
                                    child.title
                                )
                            }

                            HTML.span(
                                [
                                    "aria-hidden": "true"
                                ]
                            ) {
                                HTML.text("→")
                            }
                        }
                    }
                }
            }

            if node.href == nil {
                HTML.p(
                    [
                        "class": "wc-docs-preview-tree__unavailable"
                    ]
                ) {
                    HTML.text(
                        labels.noDirectDestination
                    )
                }
            }
        }
    }

    private func metric(
        label: String,
        value: Int
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "wc-docs-preview-tree__metric"
            ]
        ) {
            HTML.span(
                [
                    "class": "wc-docs-preview-tree__metric-value"
                ]
            ) {
                HTML.text(
                    "\(value)"
                )
            }

            HTML.span(
                [
                    "class": "wc-docs-preview-tree__metric-label"
                ]
            ) {
                HTML.text(label)
            }
        }
    }

    private func footer(
        _ active: Node
    ) -> any HTMLNode {
        let attributes = HTML.attrs(
            linkAttributes(
                className: "wc-docs-preview-tree__destination"
            ),
            [
                "data-docs-preview-tree-destination": ""
            ],
            .bool(
                "hidden",
                active.href == nil
            )
        )

        return HTML.div(
            [
                "class": "wc-docs-preview-tree__footer"
            ]
        ) {
            HTML.span(
                [
                    "class": "wc-docs-preview-tree__current",
                    "data-docs-preview-tree-current": ""
                ]
            ) {
                HTML.text(
                    active.title
                )
            }

            HTML.a(
                active.href ?? "#",
                attributes
            ) {
                HTML.text(
                    labels.openSelection
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

    private func initialKey(
        in nodes: [Node]
    ) -> String {
        if let itemID = initialSelection?.itemID,
           let match = nodes.first(where: { node in
               node.kind == .item
                   && node.sourceID == itemID
                   && matchesSelectionContext(node)
           }) {
            return match.key
        }

        if let sectionID = initialSelection?.sectionID,
           let match = nodes.first(where: { node in
               node.kind == .section
                   && node.sourceID == sectionID
                   && matchesSelectionContext(node)
           }) {
            return match.key
        }

        if let categoryID = initialSelection?.categoryID,
           let match = nodes.first(where: { node in
               node.kind == .category
                   && node.sourceID == categoryID
                   && (
                       initialSelection?.projectID == nil
                           || node.projectID == initialSelection?.projectID
                   )
           }) {
            return match.key
        }

        if let projectID = initialSelection?.projectID,
           let match = nodes.first(where: { node in
               node.kind == .project
                   && node.sourceID == projectID
           }) {
            return match.key
        }

        return nodes.first(where: { node in
            node.kind == .project
        })?.key ?? nodes[0].key
    }

    private func matchesSelectionContext(
        _ node: Node
    ) -> Bool {
        if let projectID = initialSelection?.projectID,
           node.projectID != projectID {
            return false
        }

        if let categoryID = initialSelection?.categoryID,
           node.categoryID != categoryID {
            return false
        }

        if let sectionID = initialSelection?.sectionID,
           node.sectionID != sectionID {
            return false
        }

        return true
    }

    private func flattenedNodes(
        _ root: Node
    ) -> [Node] {
        [
            root
        ] + root.children.flatMap(
            flattenedNodes
        )
    }

    // private func siteKey(
    //     _ siteID: String
    // ) -> String {
    //     "site|\(siteID)"
    // }

    private func projectKey(
        _ projectID: String
    ) -> String {
        "project|\(projectID)"
    }

    private func categoryKey(
        projectID: String,
        categoryID: String
    ) -> String {
        "category|\(projectID)|\(categoryID)"
    }

    private func sectionKey(
        projectID: String,
        categoryID: String,
        sectionID: String
    ) -> String {
        "section|\(projectID)|\(categoryID)|\(sectionID)"
    }

    private func itemKey(
        projectID: String,
        categoryID: String,
        sectionID: String,
        itemID: String
    ) -> String {
        "item|\(projectID)|\(categoryID)|\(sectionID)|\(itemID)"
    }

    private func kindLabel(
        _ kind: NodeKind
    ) -> String {
        switch kind {
        case .project:
            return labels.project

        case .category:
            return labels.category

        case .section:
            return labels.section

        case .item:
            return labels.item
        }
    }

    private func itemDestinationHref(
        _ itemHref: String,
        categoryHref: String
    ) -> String {
        if itemHref.hasPrefix("#") {
            return destinationHref(
                categoryHref
            ) + itemHref
        }

        return destinationHref(
            itemHref
        )
    }

    private func destinationHref(
        _ href: String
    ) -> String {
        guard !href.hasPrefix("http://"),
              !href.hasPrefix("https://"),
              !href.hasPrefix("mailto:"),
              !href.hasPrefix("tel:"),
              !href.hasPrefix("//"),
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

    private func linkAttributes(
        className: String
    ) -> HTMLAttribute {
        var attributes: HTMLAttribute = [
            "class": className
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
