import Constructors
import HTML
import Path

public extension SiteObject where Page: ArticleItemIdentifying {
    static func hover_link(
        to page: Page,
        linkStyle: SiteReferenceStyle = .automatic,
        assetStyle: SiteReferenceStyle = .local(.root),
        label: () -> HTMLFragment
    ) -> any HTMLNode {
        let href = Self.refer(
            page: page,
            style: linkStyle
        )

        let item = page.article_item

        let thumb_src: String? = item.thumbnail_src.map { thumb in
            Self.refer(
                path: thumb,
                style: assetStyle
            )
        }

        return ArticleHoverCard(
            href: href,
            label: label(),
            title: item.title,
            definition: item.definition,
            thumbnail_src: thumb_src
        ).nodes.body[0]
    }

    static func hover_link(
        to page: Page,
        linkStyle: SiteReferenceStyle = .automatic,
        assetStyle: SiteReferenceStyle = .local(.root)
    ) -> any HTMLNode {
        let href = Self.refer(
            page: page,
            style: linkStyle
        )

        let item = page.article_item

        let thumb_src: String? = item.thumbnail_src.map { thumb in
            Self.refer(
                path: thumb,
                style: assetStyle
            )
        }

        return ArticleHoverCard(
            href: href,
            label: [HTML.text(item.title)],
            title: item.title,
            definition: item.definition,
            thumbnail_src: thumb_src
        ).nodes.body[0]
    }
}

public extension SiteObject {
    static func hover_link<Destination: SiteObject>(
        to page: Destination.Page,
        on destination: Destination.Type,
        linkStyle: SiteReferenceStyle = .automatic,
        assetStyle: SiteReferenceStyle = .local(.root),
        label: () -> HTMLFragment
    ) -> any HTMLNode
    where Destination.Page: ArticleItemIdentifying {
        let href = Self.refer(
            to: page,
            on: destination,
            style: linkStyle
        )

        let item = page.article_item

        let thumb_src: String? = item.thumbnail_src.map { thumb in
            Self.refer(
                path: thumb,
                on: destination,
                style: assetStyle
            )
        }

        return ArticleHoverCard(
            href: href,
            label: label(),
            title: item.title,
            definition: item.definition,
            thumbnail_src: thumb_src
        ).nodes.body[0]
    }

    static func hover_link<Destination: SiteObject>(
        to page: Destination.Page,
        on destination: Destination.Type,
        linkStyle: SiteReferenceStyle = .automatic,
        assetStyle: SiteReferenceStyle = .local(.root)
    ) -> any HTMLNode
    where Destination.Page: ArticleItemIdentifying {
        let href = Self.refer(
            to: page,
            on: destination,
            style: linkStyle
        )

        let item = page.article_item

        let thumb_src: String? = item.thumbnail_src.map { thumb in
            Self.refer(
                path: thumb,
                on: destination,
                style: assetStyle
            )
        }

        return ArticleHoverCard(
            href: href,
            label: [HTML.text(item.title)],
            title: item.title,
            definition: item.definition,
            thumbnail_src: thumb_src
        ).nodes.body[0]
    }
}

// public extension SiteObject where Page: ArticleItemIdentifying {
//     static func hover_link(
//         to page: Page,
//         absolute: Bool = false,
//         asRootPath: Bool = true,
//         label: () -> HTMLFragment
//     ) -> any HTMLNode {
//         let relativity: PathRelativity = asRootPath ? .root : .relative

//         let href = Self.refer(
//             page: page,
//             absolute: absolute,
//             relativity: relativity
//         )

//         let item = page.article_item

//         let thumb_src: String? = item.thumbnail_src.map { thumb in
//             Self.refer(
//                 path: thumb,
//                 absolute: absolute,
//                 relativity: .root
//             )
//         }

//         return ArticleHoverCard(
//             href: href,
//             label: label(),
//             title: item.title,
//             definition: item.definition,
//             thumbnail_src: thumb_src
//         ).nodes.body[0]
//     }

//     static func hover_link(
//         to page: Page,
//         absolute: Bool = false,
//         asRootPath: Bool = true
//     ) -> any HTMLNode {
//         let relativity: PathRelativity = asRootPath ? .root : .relative

//         let href = Self.refer(
//             page: page,
//             absolute: absolute,
//             relativity: relativity
//         )

//         let item = page.article_item

//         let thumb_src: String? = item.thumbnail_src.map { thumb in
//             Self.refer(
//                 path: thumb,
//                 absolute: absolute,
//                 relativity: .root
//             )
//         }

//         return ArticleHoverCard(
//             href: href,
//             label: [HTML.text(item.title)],
//             title: item.title,
//             definition: item.definition,
//             thumbnail_src: thumb_src
//         ).nodes.body[0]
//     }
// }

// public extension SiteObject where Page: ArticleItemIdentifying {
//     static func hover_link(
//         to page: Page,
//         absolute: Bool = false,
//         asRootPath: Bool = true,
//         label: () -> HTMLFragment
//     ) -> any HTMLNode {
//         let href = Self.refer(
//             page: page,
//             absolute: absolute,
//             asRootPath: asRootPath
//         )

//         // guard let item = page.article_item else {
//         //     return HTML.a(href) { label() }
//         // }
//         let item = page.article_item

//         let thumb_src: String? = item.thumbnail_src.map { thumb in
//             Self.refer(
//                 path: thumb,
//                 absolute: absolute,
//                 asRootPath: true
//             )
//         }

//         return ArticleItemElement.HoverCard.html(
//             href: href,
//             label: label(),
//             title: item.title,
//             definition: item.definition,
//             thumbnail_src: thumb_src
//         )
//     }

//     static func hover_link(
//         to page: Page,
//         absolute: Bool = false,
//         asRootPath: Bool = true
//     ) -> any HTMLNode {
//         let href = Self.refer(
//             page: page,
//             absolute: absolute,
//             asRootPath: asRootPath
//         )

//         // guard let item = page.article_item else {
//         //     return HTML.a(href) { [HTML.text(href)] }
//         // }
//         let item = page.article_item

//         let thumb_src: String? = item.thumbnail_src.map { thumb in
//             Self.refer(
//                 path: thumb,
//                 absolute: absolute,
//                 asRootPath: true
//             )
//         }

//         return ArticleItemElement.HoverCard.html(
//             href: href,
//             label: [HTML.text(item.title)],
//             title: item.title,
//             definition: item.definition,
//             thumbnail_src: thumb_src
//         )
//     }
// }
