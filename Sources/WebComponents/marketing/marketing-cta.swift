import DSL
import Constructors
import HTML
import CSS

public struct MarketingCTA: SelectableComponent, Sendable {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-marketing-cta"

    public struct Link: Sendable {
        public let href: String
        public let label: String
        public let analyticsID: String?
        public let styleClass: String

        public init(
            href: String,
            label: String,
            analyticsID: String? = nil,
            styleClass: String = "cta"
        ) {
            self.href = href
            self.label = label
            self.analyticsID = analyticsID
            self.styleClass = styleClass
        }
    }

    public let eyebrow: String?
    public let title: String
    public let body: @Sendable () -> HTMLFragment
    public let links: [Link]
    public let classes: [HTMLClassToken]
    public let attrs: HTMLAttribute

    public init(
        eyebrow: String? = nil,
        title: String,
        body: @escaping @Sendable () -> HTMLFragment,
        links: [Link],
        classes: [HTMLClassToken] = [],
        attrs: HTMLAttribute = HTMLAttribute()
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.body = body
        self.links = links
        self.classes = classes
        self.attrs = attrs
    }

    public var nodes: ReusableComponentNodes {
        let s = Self.selectors

        var rootAttrs = HTMLAttribute.classes(
            base: [
                s.root.erased
            ],
            appending: classes
        )
        rootAttrs.merge(attrs)

        return .body(
            [
                HTML.section(rootAttrs) {
                    HTML.div(HTMLAttribute.class(s.element("content"))) {
                        if let eyebrow, !eyebrow.isEmpty {
                            HTML.p(HTMLAttribute.class(s.element("eyebrow"))) {
                                HTML.text(eyebrow)
                            }
                        }

                        HTML.h2(HTMLAttribute.class(s.element("title"))) {
                            HTML.text(title)
                        }

                        HTML.div(HTMLAttribute.class(s.element("body"))) {
                            body()
                        }

                        if !links.isEmpty {
                            HTML.div(HTMLAttribute.class(s.element("actions"))) {
                                for link in links {
                                    let linkAttrs: HTMLAttribute = {
                                        var attrs = HTMLAttribute.class(link.styleClass)

                                        if let analyticsID = link.analyticsID {
                                            attrs.merge(.data("analytics-id", analyticsID))
                                        }

                                        return attrs
                                    }()

                                    HTML.a(link.href, linkAttrs) {
                                        HTML.text(link.label)
                                    }
                                }
                            }
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

    public static func css() -> CSSStyleSheet {
        let s = Self.selectors

        let root = s.root.rawValue
        let content = s.element("content").rawValue
        let eyebrow = s.element("eyebrow").rawValue
        let title = s.element("title").rawValue
        let body = s.element("body").rawValue
        let actions = s.element("actions").rawValue

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(root)",
                    CSS.decl("--wc-marketing-cta-surface", "var(--surface-soft, var(--soft-background, rgba(0, 0, 0, 0.035)))"),
                    CSS.decl("--wc-marketing-cta-text", "var(--text, var(--text-color, #111827))"),
                    CSS.decl("--wc-marketing-cta-muted", "var(--text-muted, var(--muted-text, #6b7280))"),
                    CSS.decl("max-width", "960px"),
                    CSS.decl("margin", "3rem auto"),
                    CSS.decl("padding", "clamp(2rem, 6vw, 4rem)"),
                    CSS.decl("border-radius", "28px"),
                    CSS.decl("background", "var(--wc-marketing-cta-surface)"),
                    CSS.decl("text-align", "center"),
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(content)",
                    CSS.decl("max-width", "720px"),
                    CSS.decl("margin", "0 auto")
                ),

                CSS.rule(
                    ".\(eyebrow)",
                    CSS.decl("margin", "0 0 .75rem"),
                    CSS.decl("font-size", ".8rem"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--wc-marketing-cta-muted)")
                ),

                CSS.rule(
                    ".\(title)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(1.75rem, 4vw, 2.75rem)"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("letter-spacing", "-.045em"),
                    CSS.decl("color", "var(--wc-marketing-cta-text)")
                ),

                CSS.rule(
                    ".\(body)",
                    CSS.decl("max-width", "620px"),
                    CSS.decl("margin", "1rem auto 1.5rem"),
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("line-height", "1.7"),
                    CSS.decl("color", "var(--wc-marketing-cta-muted)")
                ),

                CSS.rule(
                    ".\(body) p",
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    ".\(actions)",
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", ".75rem")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 760px)",
                    CSS.rule(
                        ".\(root)",
                        CSS.decl("margin", "2rem auto"),
                        CSS.decl("padding", "2rem 1.25rem"),
                        CSS.decl("border-radius", "22px")
                    )
                )
            ]
        )
    }
}
