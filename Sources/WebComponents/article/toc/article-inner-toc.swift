import Constructors
import HTML
import CSS

public struct ArticleInnerTOC: ReusableComponent {
    public let entries: [HeadingResolver.Entry]
    public let title: String

    public init(
        entries: [HeadingResolver.Entry],
        title: String = "In dit artikel"
    ) {
        self.entries = entries
        self.title = title
    }

    public var nodes: ReusableComponentNodes {
        guard !entries.isEmpty else {
            return .init()
        }

        return .body(
            [
                HTML.nav(["class": "in-article-toc"]) {
                    HTML.span(["class": "in-article-toc__title"]) {
                        HTML.text(title)
                    }

                    HTML.ol(["class": "in-article-toc__list"]) {
                        entries.map { entry in
                            HTML.li(["class": "in-article-toc__item in-article-toc__item--h\(entry.level)"]) {
                                HTML.a("#\(entry.id)") {
                                    HTML.text(entry.label)
                                }
                            }
                        }
                    }
                }
            ]
        )
    }
}
