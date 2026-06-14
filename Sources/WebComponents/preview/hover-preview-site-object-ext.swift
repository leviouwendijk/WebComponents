import Constructors
import HTML

public extension SiteObject where Page: HoverPreviewProviding {
    static func preview_link(
        to page: Page,
        linkStyle: SiteReferenceStyle = .automatic,
        label: () -> HTMLFragment
    ) -> any HTMLNode {
        let href = Self.refer(
            page: page,
            style: linkStyle
        )

        return HoverPreviewLink(
            href: href,
            label: label(),
            preview: page.hoverable_preview
        ).nodes.body[0]
    }

    static func preview_link(
        to page: Page,
        linkStyle: SiteReferenceStyle = .automatic
    ) -> any HTMLNode {
        preview_link(
            to: page,
            linkStyle: linkStyle
        ) {
            [
                HTML.text(page.hoverable_preview.title)
            ]
        }
    }
}

public extension SiteObject {
    static func preview_link<Destination: SiteObject>(
        to page: Destination.Page,
        on destination: Destination.Type,
        linkStyle: SiteReferenceStyle = .automatic,
        label: () -> HTMLFragment
    ) -> any HTMLNode
    where Destination.Page: HoverPreviewProviding {
        let href = Self.refer(
            to: page,
            on: destination,
            style: linkStyle
        )

        return HoverPreviewLink(
            href: href,
            label: label(),
            preview: page.hoverable_preview
        ).nodes.body[0]
    }
}
