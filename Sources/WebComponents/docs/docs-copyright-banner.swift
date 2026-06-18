import Foundation
import Constructors
import CSS
import HTML

public struct DocsCopyrightBanner: ReusableComponent, Sendable {
    public struct Link: Sendable, Hashable {
        public let href: String
        public let label: String
        public let opensInNewTab: Bool

        public init(
            href: String,
            label: String,
            opensInNewTab: Bool = false
        ) {
            self.href = href
            self.label = label
            self.opensInNewTab = opensInNewTab
        }
    }

    public static let block = "wc-docs-copyright-banner"

    public let owner: String
    public let year: Int
    public let notice: String?
    public let links: [Link]
    public let includeStyles: Bool

    public init(
        owner: String,
        year: Int = Calendar.current.component(.year, from: Date()),
        notice: String? = "Alle rechten voorbehouden. Overname alleen met toestemming.",
        links: [Link] = [],
        includeStyles: Bool = true
    ) {
        self.owner = owner
        self.year = year
        self.notice = notice
        self.links = links
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.el(
                    "footer",
                    [
                        "class": Self.block,
                        "aria-label": "Copyright"
                    ]
                ) {
                    HTML.div([ "class": "\(Self.block)__inner" ]) {
                        HTML.el("small", [ "class": "\(Self.block)__notice" ]) {
                            HTML.span([ "class": "\(Self.block)__copyright" ]) {
                                HTML.text("© \(year) \(owner).")
                            }

                            if let notice, !notice.isEmpty {
                                HTML.span([ "class": "\(Self.block)__text" ]) {
                                    HTML.text(notice)
                                }
                            }
                        }

                        if !links.isEmpty {
                            HTML.el(
                                "nav",
                                [
                                    "class": "\(Self.block)__links",
                                    "aria-label": "Footerlinks"
                                ]
                            ) {
                                for link in links {
                                    link_node(link)
                                }
                            }
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    private func link_node(
        _ link: Link
    ) -> any HTMLNode {
        var attrs: HTMLAttribute = [
            "class": "\(Self.block)__link"
        ]

        if link.opensInNewTab {
            attrs.merge([
                "target": "_blank",
                "rel": "noopener noreferrer"
            ])
        }

        return HTML.a(
            link.href,
            attrs
        ) {
            HTML.text(link.label)
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("width", "min(1120px, calc(100% - 32px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "18px 0 26px"),
                    CSS.decl("border-top", "1px solid var(--border-color, rgba(15, 23, 42, .12))"),
                    CSS.decl("color", "var(--muted-text-color, rgba(32, 33, 36, .66))")
                ),

                CSS.rule(
                    ".hm-docs-app--with-footer",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("min-height", "100vh"),
                    CSS.decl("min-height", "100svh")
                ),

                CSS.rule(
                    ".hm-docs-app--with-footer > .\(block)",
                    CSS.decl("margin-top", "auto")
                ),

                // CSS.rule(
                //     ".\(block)",
                //     CSS.decl("box-sizing", "border-box"),
                //     CSS.decl("width", "min(1120px, calc(100% - 32px))"),
                //     CSS.decl("margin", "clamp(44px, 7vw, 72px) auto 0"),
                //     CSS.decl("padding", "18px 0 26px"),
                //     CSS.decl("border-top", "1px solid var(--border-color, rgba(15, 23, 42, .12))"),
                //     CSS.decl("color", "var(--muted-text-color, rgba(32, 33, 36, .66))")
                // ),

                CSS.rule(
                    ".\(block), .\(block) *",
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(block)__inner",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__notice",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("align-items", "baseline"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("font-weight", "520")
                ),

                CSS.rule(
                    ".\(block)__copyright",
                    CSS.decl("color", "var(--text-color, #202124)"),
                    CSS.decl("font-weight", "720")
                ),

                CSS.rule(
                    ".\(block)__text",
                    CSS.decl("color", "inherit")
                ),

                CSS.rule(
                    ".\(block)__links",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "flex-end"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__link",
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("line-height", "1.35"),
                    CSS.decl("font-weight", "680"),
                    CSS.decl("color", "var(--link-color, #2563eb)"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("text-underline-offset", ".18em")
                ),

                CSS.rule(
                    ".\(block)__link:hover, .\(block)__link:focus-visible",
                    CSS.decl("text-decoration", "underline"),
                    CSS.decl("text-decoration-thickness", ".08em")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    // CSS.rule(
                    //     ".\(block)",
                    //     CSS.decl("width", "calc(100% - 28px)"),
                    //     CSS.decl("margin-top", "40px"),
                    //     CSS.decl("padding-bottom", "22px")
                    // ),
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("width", "calc(100% - 28px)"),
                        CSS.decl("padding-bottom", "22px")
                    ),

                    CSS.rule(
                        ".\(block)__inner",
                        CSS.decl("display", "grid"),
                        CSS.decl("justify-items", "start"),
                        CSS.decl("gap", "10px")
                    ),

                    CSS.rule(
                        ".\(block)__links",
                        CSS.decl("justify-content", "flex-start")
                    )
                )
            ]
        )
    }
}
