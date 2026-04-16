import DSL
import Constructors
import HTML
import CSS

public struct NavigationReturnLink: SelectableComponent, Sendable {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-navigation-return-link"

    public enum Direction: Sendable {
        case back
        case forward

        var icon: String {
            switch self {
            case .back:
                return "←"
            case .forward:
                return "→"
            }
        }

        var modifierName: String {
            switch self {
            case .back:
                return "back"
            case .forward:
                return "forward"
            }
        }
    }

    public enum Placement: Sendable {
        case leading
        case trailing

        var modifierName: String {
            switch self {
            case .leading:
                return "leading"
            case .trailing:
                return "trailing"
            }
        }
    }

    public let href: String
    public let direction: Direction
    public let placement: Placement
    public let ariaLabel: String?
    public let analyticsID: String?
    public let classes: [HTMLClassToken]
    public let attrs: HTMLAttribute
    public let label: @Sendable () -> HTMLFragment

    public init(
        href: String,
        direction: Direction = .back,
        placement: Placement = .leading,
        ariaLabel: String? = nil,
        analyticsID: String? = nil,
        classes: [HTMLClassToken] = [],
        attrs: HTMLAttribute = HTMLAttribute(),
        label: @escaping @Sendable () -> HTMLFragment
    ) {
        self.href = href
        self.direction = direction
        self.placement = placement
        self.ariaLabel = ariaLabel
        self.analyticsID = analyticsID
        self.classes = classes
        self.attrs = attrs
        self.label = label
    }

    public var nodes: ReusableComponentNodes {
        let s = selectors

        let rootAttrs = makeRootAttrs()
        let linkAttrs = makeLinkAttrs()

        return .body(
            [
                HTML.nav(rootAttrs) {
                    HTML.a(href, linkAttrs) {
                        if direction == .back {
                            iconNode()
                        }

                        HTML.span(HTMLAttribute.class(s.element("label"))) {
                            label()
                        }

                        if direction == .forward {
                            iconNode()
                        }
                    }
                }
            ],
            stylesheets: [
                Self.css()
            ]
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public func sheet() -> CSSStyleSheet {
        nodes.stylesheets[0]
    }

    private func iconNode() -> any HTMLNode {
        let s = selectors

        return HTML.span(
            [
                "class": s.element("icon").rawValue,
                "aria-hidden": "true"
            ]
        ) {
            HTML.text(direction.icon)
        }
    }

    private func makeRootAttrs() -> HTMLAttribute {
        let s = selectors

        var out = HTMLAttribute.classes(
            base: [
                s.root.erased,
                s.modifier(direction.modifierName).erased,
                s.modifier(placement.modifierName).erased
            ],
            appending: classes
        )

        out.merge(attrs)
        return out
    }

    private func makeLinkAttrs() -> HTMLAttribute {
        let s = selectors

        var out = HTMLAttribute.class(s.element("link"))

        if let ariaLabel {
            out.merge(.aria("label", ariaLabel))
        }

        if let analyticsID {
            out.merge(.data("analytics-id", analyticsID))
        }

        return out
    }

    public static func css() -> CSSStyleSheet {
        let s = Self.selectors

        let root = s.root.rawValue
        let trailing = s.modifier("trailing").rawValue
        let link = s.element("link").rawValue
        let icon = s.element("icon").rawValue
        let label = s.element("label").rawValue

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(root)",
                    CSS.decl("display", "flex"),
                    CSS.decl("margin", "0 0 1.25rem")
                ),

                CSS.rule(
                    ".\(trailing)",
                    CSS.decl("justify-content", "flex-end")
                ),

                CSS.rule(
                    ".\(link)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", ".45rem"),
                    CSS.decl("width", "fit-content"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("padding", ".45rem .8rem"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--surface-soft, rgba(0, 0, 0, .045))"),
                    CSS.decl("color", "var(--text-muted, var(--muted-text, #4b5563))"),
                    CSS.decl("border", "1px solid var(--border-subtle, rgba(15, 23, 42, .08))"),
                    CSS.decl("box-shadow", "0 8px 22px rgba(15, 23, 42, .06)"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("transition", "background 140ms ease, transform 140ms ease, box-shadow 140ms ease")
                ),

                CSS.rule(
                    ".\(link):hover",
                    CSS.decl("background", "var(--surface-strong, rgba(0, 0, 0, .07))"),
                    CSS.decl("transform", "translateY(-1px)"),
                    CSS.decl("box-shadow", "0 12px 28px rgba(15, 23, 42, .09)")
                ),

                CSS.rule(
                    ".\(link):focus-visible",
                    CSS.decl("outline", "2px solid var(--focus-ring, var(--accent, #2563eb))"),
                    CSS.decl("outline-offset", "3px")
                ),

                CSS.rule(
                    ".\(icon)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("transform", "translateY(-.02em)")
                ),

                CSS.rule(
                    ".\(label)",
                    CSS.decl("min-width", "0"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("text-overflow", "ellipsis"),
                    CSS.decl("white-space", "nowrap")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".\(root)",
                        CSS.decl("margin-bottom", "1rem")
                    ),
                    CSS.rule(
                        ".\(link)",
                        CSS.decl("font-size", ".86rem"),
                        CSS.decl("padding", ".42rem .72rem")
                    )
                )
            ]
        )
    }
}
