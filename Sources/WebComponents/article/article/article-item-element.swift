import HTML
// import Path

public enum ArticleItemElement {
    public enum HoverCard {
        public static func build(
            href: String,
            label: HTMLFragment,
            item: ArticleItem
        ) -> any HTMLNode {
            HTML.span(["class": "hoverref"]) {
                HTML.a(href, ["class": "hoverref__link"]) {
                    label
                }

                HTML.span(["class": "hoverref__card"]) {
                    if let thumb = item.thumbnail_src {
                        HTML.img(
                            src: thumb.rendered(asRootPath: true),
                            alt: item.title,
                            ["class": "hoverref__thumb"]
                        )
                    }

                    HTML.span(["class": "hoverref__meta"]) {
                        HTML.span(["class": "hoverref__title"]) { HTML.text(item.title) }
                        HTML.span(["class": "hoverref__def"]) { item.definition() }
                    }
                }
            }
        }
    }
}
