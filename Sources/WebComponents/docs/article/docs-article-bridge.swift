import Constructors
import Primitives

public extension DocsArticle {
    func sectionsForDocsCategory(
        visibility: Set<BuildEnvironment> = DocsVisibility.live
    ) -> [DocsSection] {
        sections.map { section in
            section.docsSection(
                visibility: visibility
            )
        }
    }

    func category(
        identifier: String,
        label: String,
        subtitle: String? = nil,
        description: String,
        href: String,
        reading: DocsReadingConfiguration = .article,
        visibility: Set<BuildEnvironment> = DocsVisibility.live
    ) -> DocsCategory {
        DocsCategory(
            id: identifier,
            label: label,
            subtitle: subtitle,
            description: description,
            href: href,
            sections: sectionsForDocsCategory(
                visibility: visibility
            ),
            reading: reading,
            visibility: visibility
        )
    }
}

public extension DocsArticleSection {
    func docsSection(
        visibility: Set<BuildEnvironment> = DocsVisibility.live
    ) -> DocsSection {
        let presentation: DocsSectionPresentation

        switch nav {
        case .hidden:
            presentation = .structural

        case .item:
            presentation = .chapter

        case .group:
            presentation = .group
        }

        return DocsSection(
            id: identifier,
            title: title,
            summary: summary,
            items: parts.map(\.docsItem),
            presentation: presentation,
            visibility: visibility
        )
    }
}

public extension DocsArticlePart {
    var docsItem: DocsItem {
        DocsItem.article(
            id: identifier,
            title: title,
            summary: summary,
            href: href,
            header: header.isVisible,
            visibility: visibility,
            body: body
        )
    }
}
