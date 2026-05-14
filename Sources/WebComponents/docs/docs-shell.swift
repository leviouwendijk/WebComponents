import Constructors
import CSS
import HTML

public struct DocsShell: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-shell"

    public struct Slots: Sendable {
        public let header: @Sendable () -> HTMLFragment
        public let categoryNav: @Sendable () -> HTMLFragment
        public let toc: @Sendable () -> HTMLFragment
        public let content: @Sendable () -> HTMLFragment

        public init(
            header: @escaping @Sendable () -> HTMLFragment,
            categoryNav: @escaping @Sendable () -> HTMLFragment = { [] },
            toc: @escaping @Sendable () -> HTMLFragment,
            content: @escaping @Sendable () -> HTMLFragment
        ) {
            self.header = header
            self.categoryNav = categoryNav
            self.toc = toc
            self.content = content
        }
    }

    public let slots: Slots
    public let includeStyles: Bool

    public init(
        slots: Slots,
        includeStyles: Bool = true
    ) {
        self.slots = slots
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        let body: HTMLFragment = [
            HTML.div(
                [
                    "class": "layout \(Self.block)",
                    "data-wc-docs-shell": ""
                ]
            ) {
                slots.header()
                slots.categoryNav()

                HTML.div(["class": "container \(Self.block)__container"]) {
                    slots.toc()
                    slots.content()
                }
            }
        ]

        return .body(
            body,
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("--wc-docs-header-height", "60px"),
                    CSS.decl("--wc-docs-category-nav-height", "52px"),
                    CSS.decl(
                        "--wc-docs-sticky-offset",
                        "calc(var(--wc-docs-header-height) + var(--wc-docs-category-nav-height))"
                    ),
                    CSS.decl("background", "var(--background-color)"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".dark-mode .\(block)",
                    CSS.decl("background", "var(--background-color)"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block) .container",
                    CSS.decl("min-height", "0")
                ),

                CSS.rule(
                    ".\(block) .docs-category-nav",
                    CSS.decl("top", "var(--wc-docs-header-height)"),
                    CSS.decl("z-index", "999")
                ),

                CSS.rule(
                    ".\(block) nav#toc",
                    CSS.decl("top", "var(--wc-docs-sticky-offset)"),
                    CSS.decl("height", "calc(100dvh - var(--wc-docs-sticky-offset))")
                ),

                CSS.rule(
                    ".\(block) nav#toc h2",
                    CSS.decl("margin-top", "0")
                ),

                CSS.rule(
                    ".\(block) [data-docs-section]",
                    CSS.decl("scroll-margin-top", "calc(var(--wc-docs-sticky-offset) + 24px)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 1200px)",
                    CSS.rule(
                        ".\(block) nav#toc",
                        CSS.decl("top", "var(--wc-docs-sticky-offset)"),
                        CSS.decl("height", "calc(100dvh - var(--wc-docs-sticky-offset))")
                    )
                ),

                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("--wc-docs-category-nav-height", "58px")
                    )
                )
            ]
        )
    }
}
