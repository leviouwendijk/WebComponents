import Constructors
import CSS
import HTML

public struct DocsSidebarLayout: ReusableComponent {
    public static let block = "wc-docs-sidebar-layout"

    public enum SidebarPosition: Sendable {
        case leading
        case trailing
    }

    public let sidebar: HTMLFragment
    public let content: HTMLFragment
    public let sidebarPosition: SidebarPosition
    public let sidebarWidth: String
    public let maxWidth: String
    public let gap: String
    public let includeStyles: Bool

    public init(
        sidebar: HTMLFragment,
        content: HTMLFragment,
        sidebarPosition: SidebarPosition = .leading,
        sidebarWidth: String = "280px",
        maxWidth: String = "1180px",
        gap: String = "clamp(24px, 4vw, 44px)",
        includeStyles: Bool = true
    ) {
        self.sidebar = sidebar
        self.content = content
        self.sidebarPosition = sidebarPosition
        self.sidebarWidth = sidebarWidth
        self.maxWidth = maxWidth
        self.gap = gap
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.div(
                    [
                        "class": rootClass,
                        "style": inlineVariables
                    ]
                ) {
                    if sidebarPosition == .leading {
                        sidebarNode()
                        contentNode()
                    } else {
                        contentNode()
                        sidebarNode()
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    private var rootClass: String {
        switch sidebarPosition {
        case .leading:
            return Self.block

        case .trailing:
            return "\(Self.block) \(Self.block)--trailing"
        }
    }

    private var inlineVariables: String {
        [
            "--wc-docs-sidebar-layout-sidebar-width: \(sidebarWidth)",
            "--wc-docs-sidebar-layout-max-width: \(maxWidth)",
            "--wc-docs-sidebar-layout-gap: \(gap)"
        ].joined(separator: "; ")
    }

    private func sidebarNode() -> any HTMLNode {
        HTML.aside(["class": "\(Self.block)__sidebar"]) {
            sidebar
        }
    }

    private func contentNode() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__content"]) {
            content
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "var(--wc-docs-sidebar-layout-sidebar-width) minmax(0, 1fr)"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("gap", "var(--wc-docs-sidebar-layout-gap)"),
                    CSS.decl("width", "min(var(--wc-docs-sidebar-layout-max-width), 100%)"),
                    CSS.decl("margin", "0 auto")
                ),

                CSS.rule(
                    ".\(block)--trailing",
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) var(--wc-docs-sidebar-layout-sidebar-width)")
                ),

                CSS.rule(
                    ".\(block)__sidebar",
                    CSS.decl("position", "sticky"),
                    CSS.decl("top", "104px"),
                    CSS.decl("align-self", "start"),
                    CSS.decl("max-height", "calc(100vh - 128px)"),
                    CSS.decl("overflow", "auto"),
                    CSS.decl("scrollbar-width", "thin")
                ),

                CSS.rule(
                    ".\(block)__content",
                    CSS.decl("min-width", "0")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 1180px)",
                    CSS.rule(
                        ".\(block), .\(block)--trailing",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("width", "min(860px, 100%)")
                    ),

                    CSS.rule(
                        ".\(block)__sidebar",
                        CSS.decl("position", "relative"),
                        CSS.decl("top", "auto"),
                        CSS.decl("max-height", "none"),
                        CSS.decl("overflow", "visible")
                    )
                )
            ]
        )
    }
}
