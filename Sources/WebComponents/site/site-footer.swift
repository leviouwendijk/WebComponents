import DSL
import Constructors
import CSS
import HTML

public struct SiteFooter: SelectableComponent, Sendable {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-site-footer"

    public struct Selectors: Sendable {
        private let api = BlockSelectorAPI<Namespace>(
            block: SiteFooter.block
        )

        public init() {}

        public var root: HTMLClass<Namespace> {
            api.root
        }

        public var container: HTMLClass<Namespace> {
            api.element("container")
        }

        public var links: HTMLClass<Namespace> {
            api.element("links")
        }

        public var link: HTMLClass<Namespace> {
            api.element("link")
        }

        public var cookieButton: HTMLClass<Namespace> {
            api.element("cookie-button")
        }

        public var address: HTMLClass<Namespace> {
            api.element("address")
        }

        public var addressLabel: HTMLClass<Namespace> {
            api.element("address-label")
        }

        public var copyright: HTMLClass<Namespace> {
            api.element("copyright")
        }
    }

    public struct Vars: Sendable {
        private let api = BlockSelectorAPI<Namespace>(
            block: SiteFooter.block
        )

        public init() {}

        public var surface: CSSVariable<Namespace> {
            api.variable("surface")
        }

        public var text: CSSVariable<Namespace> {
            api.variable("text")
        }

        public var textMuted: CSSVariable<Namespace> {
            api.variable("text-muted")
        }

        public var border: CSSVariable<Namespace> {
            api.variable("border")
        }

        public var link: CSSVariable<Namespace> {
            api.variable("link")
        }

        public var linkHover: CSSVariable<Namespace> {
            api.variable("link-hover")
        }

        public var buttonBackground: CSSVariable<Namespace> {
            api.variable("button-background")
        }

        public var buttonText: CSSVariable<Namespace> {
            api.variable("button-text")
        }

        public var buttonHoverBackground: CSSVariable<Namespace> {
            api.variable("button-hover-background")
        }
    }

    public static let selectors = Selectors()
    public static let vars = Vars()

    public struct Model: Sendable {
        public struct Link: Sendable {
            public let href: String
            public let title: String
            public let opensInNewTab: Bool
            public let rel: String?

            public init(
                href: String,
                title: String,
                opensInNewTab: Bool = false,
                rel: String? = nil
            ) {
                self.href = href
                self.title = title
                self.opensInNewTab = opensInNewTab
                self.rel = rel
            }
        }

        public let links: [Link]
        public let cookieButtonTitle: String?
        public let cookieButtonID: String?
        public let addressLabel: String?
        public let addressLines: [String]
        public let copyrightText: String?
        public let attrs: HTMLAttribute

        public init(
            links: [Link] = [],
            cookieButtonTitle: String? = nil,
            cookieButtonID: String? = nil,
            addressLabel: String? = nil,
            addressLines: [String] = [],
            copyrightText: String? = nil,
            attrs: HTMLAttribute = HTMLAttribute()
        ) {
            self.links = links
            self.cookieButtonTitle = cookieButtonTitle
            self.cookieButtonID = cookieButtonID
            self.addressLabel = addressLabel
            self.addressLines = addressLines
            self.copyrightText = copyrightText
            self.attrs = attrs
        }
    }

    public let model: Model

    public init(
        _ model: Model
    ) {
        self.model = model
    }

    public var nodes: ReusableComponentNodes {
        let s = Self.selectors

        var rootAttrs = HTMLAttribute.class(s.root)
        rootAttrs.merge(model.attrs)

        return .body(
            [
                HTML.footer(rootAttrs) {
                    HTML.div(.class(s.container)) {
                        if !model.links.isEmpty || model.cookieButtonTitle != nil {
                            HTML.div(.class(s.links)) {
                                for link in model.links {
                                    let linkAttrs: HTMLAttribute = {
                                        var out = HTMLAttribute.class(s.link)

                                        if link.opensInNewTab {
                                            out.merge(["target": "_blank"])
                                            out.merge(["rel": link.rel ?? "noopener noreferrer"])
                                        } else if let rel = link.rel {
                                            out.merge(["rel": rel])
                                        }

                                        return out
                                    }()

                                    HTML.a(link.href, linkAttrs) {
                                        HTML.text(link.title)
                                    }
                                }

                                if let cookieButtonTitle = model.cookieButtonTitle,
                                   !cookieButtonTitle.isEmpty {
                                    let buttonAttrs: HTMLAttribute = {
                                        var out = HTMLAttribute.class(s.cookieButton)

                                        if let cookieButtonID = model.cookieButtonID,
                                           !cookieButtonID.isEmpty {
                                            out.merge(["id": cookieButtonID])
                                        }

                                        return out
                                    }()

                                    HTML.button(buttonAttrs) {
                                        HTML.text(cookieButtonTitle)
                                    }
                                }
                            }
                        }

                        if !model.addressLines.isEmpty {
                            HTML.div(.class(s.address)) {
                                HTML.p {
                                    if let addressLabel = model.addressLabel,
                                       !addressLabel.isEmpty {
                                        HTML.span(.class(s.addressLabel)) {
                                            HTML.text(addressLabel)
                                        }
                                        HTML.br()
                                    }

                                    for (index, line) in model.addressLines.enumerated() {
                                        HTML.text(line)

                                        if index < model.addressLines.count - 1 {
                                            HTML.br()
                                        }
                                    }
                                }
                            }
                        }
                    }

                    HTML.div(.class(s.copyright)) {
                        if let copyrightText = model.copyrightText,
                           !copyrightText.isEmpty {
                            HTML.text(copyrightText)
                        }
                    }
                }
            ],
            stylesheets: [Self.css()]
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public func sheet() -> CSSStyleSheet {
        nodes.stylesheets[0]
    }
}

public extension SiteFooter {
    static func css() -> CSSStyleSheet {
        let s = Self.selectors
        let v = Self.vars

        let addressParagraphs = s.address.descendant(
            CSSSelector.element("p")
        )

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    s.root,
                    decl(v.surface, cssvar("--surface-soft", fallback: cssvar("--surface", fallback: "#f4f4f4"))),
                    decl(v.text, cssvar("--text", fallback: "#666")),
                    decl(v.textMuted, cssvar("--text-muted", fallback: "#999")),
                    decl(v.border, cssvar("--border-subtle", fallback: "var(--base-color-border, #d7e2ec)")),
                    decl(v.link, cssvar("--link-color", fallback: cssvar("--accent", fallback: "var(--base-color-primary, #0081F8)"))),
                    decl(v.linkHover, cssvar("--brand-ink", fallback: "var(--base-color-primary, #0081F8)")),
                    decl(v.buttonBackground, cssvar("--surface-elevated", fallback: "#e3e3e3")),
                    decl(v.buttonText, cssvar(v.text, fallback: "#666")),
                    decl(v.buttonHoverBackground, cssvar("--accent", fallback: "var(--base-color-secondary, #0F4C81)")),

                    CSS.decl("background-color", cssvar(v.surface, fallback: "#f4f4f4")),
                    CSS.decl("color", cssvar(v.text, fallback: "#666")),
                    CSS.decl("font-size", "0.875rem"),
                    CSS.decl("padding", "20px 0"),
                    CSS.decl("text-align", "center"),
                    CSS.decl("border-top", "1px solid \(cssvar(v.border, fallback: "#d7e2ec"))")
                ),

                CSS.rule(
                    s.container,
                    CSS.decl("max-width", "1128px"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "16px")
                ),

                CSS.rule(
                    s.links,
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("align-items", "center")
                ),

                CSS.rule(
                    s.link,
                    CSS.decl("color", cssvar(v.link, fallback: "#666")),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("transition", "color 0.3s ease")
                ),

                CSS.rule(
                    s.link.pseudoClass("hover"),
                    CSS.decl("color", cssvar(v.linkHover, fallback: "#0081F8"))
                ),

                CSS.rule(
                    s.cookieButton,
                    CSS.decl("color", cssvar(v.buttonText, fallback: "#666")),
                    CSS.decl("background-color", cssvar(v.buttonBackground, fallback: "#e3e3e3")),
                    CSS.decl("border", "none"),
                    CSS.decl("border-radius", "6px"),
                    CSS.decl("padding", "8px 16px"),
                    CSS.decl("font-size", "0.875rem"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl(
                        "transition",
                        "color 0.3s ease, background-color 0.3s ease, transform 0.2s ease"
                    ),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    s.cookieButton.pseudoClass("hover"),
                    CSS.decl("background-color", cssvar(v.buttonHoverBackground, fallback: "#0F4C81")),
                    CSS.decl("color", "#fff"),
                    CSS.decl("transform", "translateY(-2px)")
                ),

                CSS.rule(
                    s.cookieButton.pseudoClass("active"),
                    CSS.decl("transform", "translateY(0)")
                ),

                CSS.rule(
                    s.address,
                    CSS.decl("margin-top", "24px"),
                    CSS.decl("text-align", "center"),
                    CSS.decl("color", cssvar(v.text, fallback: "#666")),
                    CSS.decl("line-height", "1.4")
                ),

                CSS.rule(
                    addressParagraphs,
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    s.addressLabel,
                    CSS.decl("font-style", "italic")
                ),

                CSS.rule(
                    s.copyright,
                    CSS.decl("margin-top", "16px"),
                    CSS.decl("color", cssvar(v.textMuted, fallback: "#999")),
                    CSS.decl("text-align", "center"),
                    CSS.decl("font-size", "0.75rem"),
                    CSS.decl("padding-top", "16px")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 768px)",
                    CSS.rule(
                        s.root,
                        CSS.decl("padding", "20px 16px")
                    ),
                    CSS.rule(
                        s.links,
                        CSS.decl("justify-content", "center")
                    )
                )
            ]
        )
    }
}

// public extension SiteFooter {
//     static func css() -> CSSStyleSheet {
//         let s = Self.selectors

//         let addressParagraphs = s.address.descendant(
//             CSSSelector.element("p")
//         )

//         return CSSStyleSheet(
//             rules: [
//                 CSS.rule(
//                     s.root,
//                     CSS.decl("background-color", "#f4f4f4"),
//                     CSS.decl("color", "#666"),
//                     CSS.decl("font-size", "0.875rem"),
//                     CSS.decl("padding", "20px 0"),
//                     CSS.decl("text-align", "center"),
//                     CSS.decl("border-top", "1px solid var(--base-color-border)")
//                 ),

//                 CSS.rule(
//                     s.container,
//                     CSS.decl("max-width", "1128px"),
//                     CSS.decl("margin", "0 auto"),
//                     CSS.decl("display", "flex"),
//                     CSS.decl("flex-direction", "column"),
//                     CSS.decl("align-items", "center"),
//                     CSS.decl("gap", "16px")
//                 ),

//                 CSS.rule(
//                     s.links,
//                     CSS.decl("display", "flex"),
//                     CSS.decl("flex-wrap", "wrap"),
//                     CSS.decl("gap", "16px"),
//                     CSS.decl("justify-content", "center"),
//                     CSS.decl("align-items", "center")
//                 ),

//                 CSS.rule(
//                     s.link,
//                     CSS.decl("color", "#666"),
//                     CSS.decl("text-decoration", "none"),
//                     CSS.decl("transition", "color 0.3s ease")
//                 ),

//                 CSS.rule(
//                     s.link.pseudoClass("hover"),
//                     CSS.decl("color", "var(--base-color-primary)")
//                 ),

//                 CSS.rule(
//                     s.cookieButton,
//                     CSS.decl("color", "#666"),
//                     CSS.decl("background-color", "#e3e3e3"),
//                     CSS.decl("border", "none"),
//                     CSS.decl("border-radius", "6px"),
//                     CSS.decl("padding", "8px 16px"),
//                     CSS.decl("font-size", "0.875rem"),
//                     CSS.decl("cursor", "pointer"),
//                     CSS.decl(
//                         "transition",
//                         "color 0.3s ease, background-color 0.3s ease, transform 0.2s ease"
//                     ),
//                     CSS.decl("text-decoration", "none")
//                 ),

//                 CSS.rule(
//                     s.cookieButton.pseudoClass("hover"),
//                     CSS.decl("background-color", "var(--base-color-secondary)"),
//                     CSS.decl("color", "#fff"),
//                     CSS.decl("transform", "translateY(-2px)")
//                 ),

//                 CSS.rule(
//                     s.cookieButton.pseudoClass("active"),
//                     CSS.decl("transform", "translateY(0)")
//                 ),

//                 CSS.rule(
//                     s.address,
//                     CSS.decl("margin-top", "24px"),
//                     CSS.decl("text-align", "center"),
//                     CSS.decl("color", "#666"),
//                     CSS.decl("line-height", "1.4")
//                 ),

//                 CSS.rule(
//                     addressParagraphs,
//                     CSS.decl("margin", "0")
//                 ),

//                 CSS.rule(
//                     s.addressLabel,
//                     CSS.decl("font-style", "italic")
//                 ),

//                 CSS.rule(
//                     s.copyright,
//                     CSS.decl("margin-top", "16px"),
//                     CSS.decl("color", "#999"),
//                     CSS.decl("text-align", "center"),
//                     CSS.decl("font-size", "0.75rem"),
//                     CSS.decl("padding-top", "16px")
//                 )
//             ],
//             media: [
//                 CSS.media(
//                     "(max-width: 768px)",
//                     CSS.rule(
//                         s.root,
//                         CSS.decl("padding", "20px 16px")
//                     ),
//                     CSS.rule(
//                         s.links,
//                         CSS.decl("justify-content", "center")
//                     )
//                 )
//             ]
//         )
//     }
// }
