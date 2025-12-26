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

        return ArticleItemElement.HoverCard.html(
            href: href,
            label: label(),
            item: item
        )
    }

    /// Convenience: default label = article title if present, else href.
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

        return ArticleItemElement.HoverCard.html(
            href: href,
            label: [HTML.text(item.title)],
            item: item
        )
    }
}
