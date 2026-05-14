import Constructors
import CSS
import HTML

public struct DocsCategoryNav: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-category-nav"

    public let categories: [DocsCategory]
    public let activeID: String?
    public let ariaLabel: String
    public let includeStyles: Bool

    public init(
        categories: [DocsCategory],
        activeID: String? = nil,
        ariaLabel: String = "Kennisbank onderdelen",
        includeStyles: Bool = true
    ) {
        self.categories = categories
        self.activeID = activeID
        self.ariaLabel = ariaLabel
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.comment("Docs Category Navigation"),
                HTML.nav(
                    [
                        "class": "docs-category-nav \(Self.block)",
                        "aria-label": ariaLabel
                    ]
                ) {
                    HTML.div(["class": "docs-category-nav__inner \(Self.block)__inner"]) {
                        HTML.div(["class": "docs-category-nav__track \(Self.block)__track"]) {
                            for category in categories {
                                link(category)
                            }
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    private func link(
        _ category: DocsCategory
    ) -> any HTMLNode {
        let attrs: HTMLAttribute = {
            if activeID == category.id {
                return [
                    "class": "docs-category-nav__link \(Self.block)__link",
                    "aria-current": "page"
                ]
            }

            return [
                "class": "docs-category-nav__link \(Self.block)__link"
            ]
        }()

        return HTML.a(category.href, attrs) {
            HTML.span(["class": "docs-category-nav__label \(Self.block)__label"]) {
                HTML.text(category.label)
            }

            HTML.span(["class": "docs-category-nav__description \(Self.block)__description"]) {
                HTML.text(category.description)
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".docs-category-nav",
                    CSS.decl("position", "sticky"),
                    CSS.decl("top", "60px"),
                    CSS.decl("z-index", "999"),
                    CSS.decl("width", "100%"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl(
                        "background",
                        "color-mix(in srgb, var(--header-bg-color, var(--background-color)) 92%, var(--background-color) 8%)"
                    ),
                    CSS.decl("border-left", "1px solid var(--border-color)"),
                    CSS.decl("border-right", "1px solid var(--border-color)"),
                    CSS.decl("border-bottom", "1px solid var(--border-color)")
                ),

                CSS.rule(
                    ".docs-category-nav__inner",
                    CSS.decl("width", "100%"),
                    CSS.decl("max-width", "1180px"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "8px 24px"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("overflow-x", "auto"),
                    CSS.decl("overflow-y", "hidden"),
                    CSS.decl("scrollbar-width", "none"),
                    CSS.decl("-webkit-overflow-scrolling", "touch")
                ),

                CSS.rule(
                    ".docs-category-nav__inner::-webkit-scrollbar",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".docs-category-nav__track",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "stretch"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("width", "max-content"),
                    CSS.decl("margin", "0 auto")
                ),

                CSS.rule(
                    ".docs-category-nav__link",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("gap", "2px"),
                    CSS.decl("min-width", "148px"),
                    CSS.decl("max-width", "210px"),
                    CSS.decl("padding", "8px 12px"),
                    CSS.decl("border-radius", "10px"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("border", "1px solid transparent"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("transition", "background 140ms ease, border-color 140ms ease, transform 140ms ease")
                ),

                CSS.rule(
                    ".docs-category-nav__link:hover",
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 6%, transparent)"),
                    CSS.decl("border-color", "color-mix(in srgb, var(--border-color) 72%, transparent)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".docs-category-nav__link[aria-current=\"page\"]",
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 8%, transparent)"),
                    CSS.decl("border-color", "var(--border-color)")
                ),

                CSS.rule(
                    ".docs-category-nav__label",
                    CSS.decl("font-size", ".86rem"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("line-height", "1.12"),
                    CSS.decl("white-space", "nowrap")
                ),

                CSS.rule(
                    ".docs-category-nav__description",
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("line-height", "1.22"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color) 58%, transparent)"),
                    CSS.decl("white-space", "nowrap"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("text-overflow", "ellipsis")
                ),

                CSS.rule(
                    ".dark-mode .docs-category-nav",
                    CSS.decl(
                        "background",
                        "color-mix(in srgb, var(--header-bg-color, var(--background-color)) 86%, var(--text-color) 6%)"
                    )
                ),

                CSS.rule(
                    ".dark-mode .docs-category-nav__link:hover",
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 10%, transparent)")
                ),

                CSS.rule(
                    ".dark-mode .docs-category-nav__link[aria-current=\"page\"]",
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 14%, transparent)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".docs-category-nav__inner",
                        CSS.decl("padding", "7px 14px")
                    ),
                    CSS.rule(
                        ".docs-category-nav__track",
                        CSS.decl("margin", "0")
                    ),
                    CSS.rule(
                        ".docs-category-nav__link",
                        CSS.decl("min-width", "132px"),
                        CSS.decl("padding", "7px 10px")
                    ),
                    CSS.rule(
                        ".docs-category-nav__description",
                        CSS.decl("display", "none")
                    )
                )
            ]
        )
    }
}
