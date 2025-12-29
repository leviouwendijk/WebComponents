import Constructors
import HTML

public extension SiteObject where Page: ArticleItemIdentifying {
    static func hover_link(
        to page: Page,
        absolute: Bool = false,
        asRootPath: Bool = true,
        label: () -> HTMLFragment
    ) -> any HTMLNode {
        let href = Self.refer(
            page: page,
            absolute: absolute,
            asRootPath: asRootPath
        )

        guard let item = page.article_item else {
            return HTML.a(href) { label() }
        }

        let thumb_src: String? = item.thumbnail_src.map { thumb in
            Self.refer(
                path: thumb,
                absolute: absolute,
                asRootPath: true
            )
        }

        return ArticleItemElement.HoverCard.html(
            href: href,
            label: label(),
            title: item.title,
            definition: item.definition,
            thumbnail_src: thumb_src
        )
    }

    static func hover_link(
        to page: Page,
        absolute: Bool = false,
        asRootPath: Bool = true
    ) -> any HTMLNode {
        let href = Self.refer(
            page: page,
            absolute: absolute,
            asRootPath: asRootPath
        )

        guard let item = page.article_item else {
            return HTML.a(href) { [HTML.text(href)] }
        }

        let thumb_src: String? = item.thumbnail_src.map { thumb in
            Self.refer(
                path: thumb,
                absolute: absolute,
                asRootPath: true
            )
        }

        return ArticleItemElement.HoverCard.html(
            href: href,
            label: [HTML.text(item.title)],
            title: item.title,
            definition: item.definition,
            thumbnail_src: thumb_src
        )
    }
}
