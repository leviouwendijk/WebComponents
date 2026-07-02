import Foundation
import Constructors
import CSS
import HTML

public struct ArticleAuthorSection: ReusableComponent, Sendable {
    public struct Author: Sendable, Hashable {
        public struct Avatar: Sendable, Hashable {
            public let src: String?
            public let alt: String?
            public let fallback: String?

            public init(
                src: String? = nil,
                alt: String? = nil,
                fallback: String? = nil
            ) {
                self.src = src
                self.alt = alt
                self.fallback = fallback
            }

            public static func image(
                src: String,
                alt: String? = nil,
                fallback: String? = nil
            ) -> Avatar {
                Avatar(
                    src: src,
                    alt: alt,
                    fallback: fallback
                )
            }

            public static func initials(
                _ value: String? = nil
            ) -> Avatar {
                Avatar(
                    fallback: value
                )
            }
        }

        public struct Link: Sendable, Hashable {
            public let label: String
            public let href: String
            public let rel: String?
            public let target: String?

            public init(
                label: String,
                href: String,
                rel: String? = nil,
                target: String? = nil
            ) {
                self.label = label
                self.href = href
                self.rel = rel
                self.target = target
            }
        }

        public struct Fact: Sendable, Hashable {
            public let label: String
            public let value: String

            public init(
                _ label: String,
                _ value: String
            ) {
                self.label = label
                self.value = value
            }
        }

        public let id: String
        public let name: String
        public let role: String?
        public let organization: String?
        public let summary: String?
        public let avatar: Avatar?
        public let links: [Link]
        public let facts: [Fact]

        public init(
            id: String,
            name: String,
            role: String? = nil,
            organization: String? = nil,
            summary: String? = nil,
            avatar: Avatar? = nil,
            links: [Link] = [],
            facts: [Fact] = []
        ) {
            self.id = id
            self.name = name
            self.role = role
            self.organization = organization
            self.summary = summary
            self.avatar = avatar
            self.links = links
            self.facts = facts
        }
    }

    public enum Presentation: String, Sendable, Hashable {
        case bar
        case rows
        case cards
    }

    public enum Disclosure: String, Sendable, Hashable {
        case none
        case collapsed
        case expanded
    }

    private enum ClassName {
        static let root = "wc-article-authors"
        static let head = "wc-article-authors__head"
        static let title = "wc-article-authors__title"
        static let subtitle = "wc-article-authors__subtitle"
        static let summary = "wc-article-authors__summary"
        static let summaryMarker = "wc-article-authors__summary-marker"
        static let list = "wc-article-authors__list"
        static let item = "wc-article-authors__item"
        static let avatar = "wc-article-authors__avatar"
        static let avatarImage = "wc-article-authors__avatar-image"
        static let avatarFallback = "wc-article-authors__avatar-fallback"
        static let body = "wc-article-authors__body"
        static let name = "wc-article-authors__name"
        static let role = "wc-article-authors__role"
        static let bio = "wc-article-authors__bio"
        static let links = "wc-article-authors__links"
        static let link = "wc-article-authors__link"
        static let facts = "wc-article-authors__facts"
        static let factLabel = "wc-article-authors__fact-label"
        static let factValue = "wc-article-authors__fact-value"
    }

    public let id: String?
    public let title: String
    public let subtitle: String?
    public let authors: [Author]
    public let presentation: Presentation
    public let disclosure: Disclosure
    public let includeStyles: Bool

    public init(
        id: String? = nil,
        title: String? = nil,
        subtitle: String? = nil,
        authors: [Author],
        presentation: Presentation = .bar,
        disclosure: Disclosure = .none,
        includeStyles: Bool = true
    ) {
        self.id = id
        self.title = title ?? (authors.count == 1 ? "Auteur" : "Auteurs")
        self.subtitle = subtitle
        self.authors = authors
        self.presentation = presentation
        self.disclosure = disclosure
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        guard !authors.isEmpty else {
            return .init()
        }

        return .body(
            [
                rootNode()
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    public func node() -> any HTMLNode {
        rootNode()
    }

    private func rootNode() -> any HTMLNode {
        switch disclosure {
        case .none:
            return HTML.el(
                "section",
                rootAttributes()
            ) {
                headingNode()
                listNode()
            }

        case .collapsed, .expanded:
            return HTML.el(
                "details",
                detailsAttributes()
            ) {
                HTML.el("summary", ["class": ClassName.summary]) {
                    headingNode()
                    HTML.span(
                        [
                            "class": ClassName.summaryMarker,
                            "aria-hidden": "true"
                        ]
                    ) {
                        HTML.text("›")
                    }
                }

                listNode()
            }
        }
    }

    private func rootAttributes() -> HTMLAttribute {
        var attrs: HTMLAttribute = [
            "class": rootClass,
            "data-article-authors": "",
            "data-article-authors-presentation": presentation.rawValue,
            "aria-label": title
        ]

        if let id, !id.isEmpty {
            attrs.merge(["id": id])
        }

        return attrs
    }

    private func detailsAttributes() -> HTMLAttribute {
        var attrs = rootAttributes()
        attrs.merge([
            "data-article-authors-disclosure": disclosure.rawValue
        ])

        if disclosure == .expanded {
            attrs.merge(["open": ""])
        }

        return attrs
    }

    private var rootClass: String {
        [
            ClassName.root,
            "\(ClassName.root)--\(presentation.rawValue)",
            disclosure == .none ? nil : "\(ClassName.root)--disclosure"
        ]
        .compactMap { $0 }
        .joined(separator: " ")
    }

    private func headingNode() -> any HTMLNode {
        HTML.div(["class": ClassName.head]) {
            HTML.h2(["class": ClassName.title]) {
                HTML.text(title)
            }

            if let subtitle, !subtitle.isEmpty {
                HTML.p(["class": ClassName.subtitle]) {
                    HTML.text(subtitle)
                }
            }
        }
    }

    private func listNode() -> any HTMLNode {
        HTML.div(["class": ClassName.list]) {
            for author in authors {
                authorNode(author)
            }
        }
    }

    private func authorNode(
        _ author: Author
    ) -> any HTMLNode {
        HTML.article(
            [
                "class": ClassName.item,
                "data-article-author": author.id
            ]
        ) {
            avatarNode(author)

            HTML.div(["class": ClassName.body]) {
                HTML.h3(["class": ClassName.name]) {
                    HTML.text(author.name)
                }

                if let line = roleLine(author), !line.isEmpty {
                    HTML.p(["class": ClassName.role]) {
                        HTML.text(line)
                    }
                }

                if let summary = author.summary, !summary.isEmpty {
                    HTML.p(["class": ClassName.bio]) {
                        HTML.text(summary)
                    }
                }

                if !author.links.isEmpty {
                    linksNode(author)
                }

                if !author.facts.isEmpty {
                    factsNode(author)
                }
            }
        }
    }

    private func avatarNode(
        _ author: Author
    ) -> any HTMLNode {
        let avatar = author.avatar

        return HTML.div(["class": ClassName.avatar]) {
            if let src = avatar?.src, !src.isEmpty {
                HTML.img(
                    src: src,
                    alt: avatar?.alt ?? author.name,
                    [
                        "class": ClassName.avatarImage,
                        "loading": "lazy",
                        "decoding": "async"
                    ]
                )
            } else {
                HTML.div(
                    [
                        "class": ClassName.avatarFallback,
                        "aria-hidden": "true"
                    ]
                ) {
                    HTML.text(
                        avatar?.fallback ?? initials(from: author.name)
                    )
                }
            }
        }
    }

    private func linksNode(
        _ author: Author
    ) -> any HTMLNode {
        HTML.el(
            "nav",
            [
                "class": ClassName.links,
                "aria-label": "Links van \(author.name)"
            ]
        ) {
            for link in author.links {
                HTML.a(
                    link.href,
                    linkAttributes(link)
                ) {
                    HTML.text(link.label)
                }
            }
        }
    }

    private func linkAttributes(
        _ link: Author.Link
    ) -> HTMLAttribute {
        var attrs: HTMLAttribute = [
            "class": ClassName.link
        ]

        if let rel = link.rel, !rel.isEmpty {
            attrs.merge(["rel": rel])
        }

        if let target = link.target, !target.isEmpty {
            attrs.merge(["target": target])
        }

        return attrs
    }

    private func factsNode(
        _ author: Author
    ) -> any HTMLNode {
        HTML.el("dl", ["class": ClassName.facts]) {
            for fact in author.facts {
                HTML.el("dt", ["class": ClassName.factLabel]) {
                    HTML.text(fact.label)
                }

                HTML.el("dd", ["class": ClassName.factValue]) {
                    HTML.text(fact.value)
                }
            }
        }
    }

    private func roleLine(
        _ author: Author
    ) -> String? {
        let parts = [
            author.role,
            author.organization
        ]
        .compactMap { value -> String? in
            guard let value else { return nil }

            let trimmed = value.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            return trimmed.isEmpty ? nil : trimmed
        }

        guard !parts.isEmpty else {
            return nil
        }

        return parts.joined(separator: " · ")
    }

    private func initials(
        from name: String
    ) -> String {
        let parts = name
            .split(whereSeparator: { character in
                character.isWhitespace || character == "-"
            })
            .compactMap { part -> Character? in
                part.first
            }
            .prefix(2)

        let value = String(parts)

        return value.isEmpty ? "A" : value.uppercased()
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("margin", "18px 0 34px"),
                    CSS.decl("font-family", #"var(--docs-ui-font, "Instrument Sans", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif)"#),
                    CSS.decl("color", "var(--text-color, #262626)")
                ),

                CSS.rule(
                    ".\(ClassName.root) *",
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(ClassName.head)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(ClassName.title)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "0.76rem"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", "0.09em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color, #737373)")
                ),

                CSS.rule(
                    ".\(ClassName.subtitle)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "0.92rem"),
                    CSS.decl("line-height", "1.35"),
                    CSS.decl("color", "var(--muted-text-color, #737373)")
                ),

                CSS.rule(
                    ".\(ClassName.list)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".\(ClassName.root):not(.\(ClassName.root)--disclosure) > .\(ClassName.head)",
                    CSS.decl("margin-bottom", "10px")
                ),

                CSS.rule(
                    ".\(ClassName.root)--bar",
                    CSS.decl("padding", "12px"),
                    CSS.decl("border", "1px solid var(--border-color, rgba(0, 0, 0, 0.12))"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--submenu-bg-color, rgba(0, 0, 0, 0.035))")
                ),

                CSS.rule(
                    ".\(ClassName.root)--bar .\(ClassName.item)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "auto minmax(0, 1fr)"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("padding", "10px"),
                    CSS.decl("border", "1px solid var(--border-color, rgba(0, 0, 0, 0.10))"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "var(--background-color, #fff)")
                ),

                CSS.rule(
                    ".\(ClassName.root)--rows .\(ClassName.item)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "auto minmax(0, 1fr)"),
                    CSS.decl("gap", "13px"),
                    CSS.decl("padding", "13px 0"),
                    CSS.decl("border-top", "1px solid var(--border-color, rgba(0, 0, 0, 0.12))")
                ),

                CSS.rule(
                    ".\(ClassName.root)--rows .\(ClassName.item):first-child",
                    CSS.decl("border-top", "0"),
                    CSS.decl("padding-top", "0")
                ),

                CSS.rule(
                    ".\(ClassName.root)--cards .\(ClassName.list)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(auto-fit, minmax(240px, 1fr))"),
                    CSS.decl("gap", "12px")
                ),

                CSS.rule(
                    ".\(ClassName.root)--cards .\(ClassName.item)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "auto minmax(0, 1fr)"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("gap", "13px"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("border", "1px solid var(--border-color, rgba(0, 0, 0, 0.12))"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--background-color, #fff)")
                ),

                CSS.rule(
                    ".\(ClassName.avatar)",
                    CSS.decl("width", "54px"),
                    CSS.decl("height", "54px"),
                    CSS.decl("flex", "0 0 auto")
                ),

                CSS.rule(
                    ".\(ClassName.avatarImage),\n.\(ClassName.avatarFallback)",
                    CSS.decl("width", "54px"),
                    CSS.decl("height", "54px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("border", "1px solid var(--border-color, rgba(0, 0, 0, 0.12))"),
                    CSS.decl("background", "var(--background-color, #fff)")
                ),

                CSS.rule(
                    ".\(ClassName.avatarImage)",
                    CSS.decl("display", "block"),
                    CSS.decl("object-fit", "cover"),
                    CSS.decl("object-position", "center"),
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    ".\(ClassName.avatarFallback)",
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("font-size", "0.9rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("letter-spacing", "0.04em"),
                    CSS.decl("color", "var(--link-color, #0b66c3)")
                ),

                CSS.rule(
                    ".\(ClassName.body)",
                    CSS.decl("min-width", "0"),
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("gap", "4px")
                ),

                CSS.rule(
                    ".\(ClassName.name)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("line-height", "1.18"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", "-0.01em"),
                    CSS.decl("color", "var(--text-color, #262626)")
                ),

                CSS.rule(
                    ".\(ClassName.role)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "0.9rem"),
                    CSS.decl("line-height", "1.35"),
                    CSS.decl("font-weight", "600"),
                    CSS.decl("color", "var(--muted-text-color, #737373)")
                ),

                CSS.rule(
                    ".\(ClassName.bio)",
                    CSS.decl("margin", "4px 0 0"),
                    CSS.decl("font-size", "0.92rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("font-weight", "430"),
                    CSS.decl("color", "var(--text-color, #262626)")
                ),

                CSS.rule(
                    ".\(ClassName.links)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("margin-top", "7px")
                ),

                CSS.rule(
                    ".\(ClassName.link)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("min-height", "28px"),
                    CSS.decl("padding", "4px 9px"),
                    CSS.decl("border", "1px solid var(--border-color, rgba(0, 0, 0, 0.12))"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--submenu-bg-color, rgba(0, 0, 0, 0.035))"),
                    CSS.decl("color", "var(--link-color, #0b66c3)"),
                    CSS.decl("font-size", "0.84rem"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".\(ClassName.link):hover",
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("border-color", "var(--link-color, #0b66c3)")
                ),

                CSS.rule(
                    ".\(ClassName.facts)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "auto minmax(0, 1fr)"),
                    CSS.decl("gap", "3px 8px"),
                    CSS.decl("margin", "9px 0 0"),
                    CSS.decl("font-size", "0.86rem"),
                    CSS.decl("line-height", "1.35")
                ),

                CSS.rule(
                    ".\(ClassName.factLabel)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("color", "var(--muted-text-color, #737373)")
                ),

                CSS.rule(
                    ".\(ClassName.factValue)",
                    CSS.decl("margin", "0"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("color", "var(--text-color, #262626)")
                ),

                CSS.rule(
                    ".\(ClassName.summary)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) auto"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("list-style", "none")
                ),

                CSS.rule(
                    ".\(ClassName.summary)::-webkit-details-marker",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(ClassName.root)--disclosure",
                    CSS.decl("padding", "12px"),
                    CSS.decl("border", "1px solid var(--border-color, rgba(0, 0, 0, 0.12))"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--submenu-bg-color, rgba(0, 0, 0, 0.035))")
                ),

                CSS.rule(
                    ".\(ClassName.root)--disclosure .\(ClassName.list)",
                    CSS.decl("margin-top", "12px")
                ),

                CSS.rule(
                    ".\(ClassName.summaryMarker)",
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "28px"),
                    CSS.decl("height", "28px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("border", "1px solid var(--border-color, rgba(0, 0, 0, 0.12))"),
                    CSS.decl("background", "var(--background-color, #fff)"),
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("transition", "transform 160ms ease")
                ),

                CSS.rule(
                    ".\(ClassName.root)[open] .\(ClassName.summaryMarker)",
                    CSS.decl("transform", "rotate(45deg)")
                ),

                CSS.rule(
                    ".\(ClassName.root)--bar",
                    CSS.decl("width", "min(100%, 960px)"),
                    CSS.decl("margin", "14px 0 18px"),
                    CSS.decl("padding", "8px"),
                    CSS.decl("border", "1px solid var(--border-color, rgba(0, 0, 0, 0.12))"),
                    CSS.decl("border-radius", "24px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 92%, var(--text-color) 8%)"),
                    CSS.decl("box-shadow", "0 1px 0 rgba(0, 0, 0, 0.025)")
                ),

                CSS.rule(
                    ".\(ClassName.root)--bar:not(.\(ClassName.root)--disclosure) > .\(ClassName.head)",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(ClassName.root)--bar .\(ClassName.list)",
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".\(ClassName.root)--bar .\(ClassName.item)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "44px minmax(0, 1fr)"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "11px"),
                    CSS.decl("padding", "4px 6px"),
                    CSS.decl("border", "0"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "transparent")
                ),

                CSS.rule(
                    ".\(ClassName.avatar),\n.\(ClassName.avatarImage),\n.\(ClassName.avatarFallback)",
                    CSS.decl("width", "44px"),
                    CSS.decl("height", "44px")
                ),

                CSS.rule(
                    ".\(ClassName.avatar)",
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("border-radius", "999px")
                ),

                CSS.rule(
                    ".\(ClassName.avatarImage)",
                    CSS.decl("max-width", "44px"),
                    CSS.decl("max-height", "44px"),
                    CSS.decl("aspect-ratio", "1 / 1")
                ),

                CSS.rule(
                    ".\(ClassName.name)",
                    CSS.decl("font-size", "0.95rem"),
                    CSS.decl("line-height", "1.1")
                ),

                CSS.rule(
                    ".\(ClassName.role)",
                    CSS.decl("font-size", "0.82rem"),
                    CSS.decl("line-height", "1.25")
                ),

                CSS.rule(
                    ".\(ClassName.bio)",
                    CSS.decl("margin", "2px 0 0"),
                    CSS.decl("font-size", "0.84rem"),
                    CSS.decl("line-height", "1.3")
                ),

                CSS.rule(
                    ".\(ClassName.links)",
                    CSS.decl("margin-top", "5px")
                ),

                CSS.rule(
                    ".\(ClassName.link)",
                    CSS.decl("min-height", "24px"),
                    CSS.decl("padding", "3px 8px"),
                    CSS.decl("font-size", "0.78rem")
                ),

                CSS.rule(
                    ".\(ClassName.root)--disclosure .\(ClassName.summary)",
                    CSS.decl("min-height", "44px"),
                    CSS.decl("padding", "4px 6px 4px 12px"),
                    CSS.decl("border-radius", "18px")
                ),

                CSS.rule(
                    ".\(ClassName.root)--disclosure .\(ClassName.title)",
                    CSS.decl("font-size", "0.88rem"),
                    CSS.decl("letter-spacing", "0"),
                    CSS.decl("text-transform", "none"),
                    CSS.decl("color", "var(--text-color, #262626)")
                ),

                CSS.rule(
                    ".\(ClassName.summaryMarker)",
                    CSS.decl("width", "32px"),
                    CSS.decl("height", "32px"),
                    CSS.decl("font-size", "1.4rem"),
                    CSS.decl("font-weight", "520"),
                    CSS.decl("transform", "rotate(0deg)")
                ),

                CSS.rule(
                    ".\(ClassName.root)[open] .\(ClassName.summaryMarker)",
                    CSS.decl("transform", "rotate(90deg)")
                ),

                CSS.rule(
                    ".\(ClassName.root)--disclosure .\(ClassName.list)",
                    CSS.decl("margin-top", "8px"),
                    CSS.decl("padding-top", "8px"),
                    CSS.decl("border-top", "1px solid var(--border-color, rgba(0, 0, 0, 0.12))")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".\(ClassName.root)",
                        CSS.decl("margin", "14px 0 28px")
                    ),

                    CSS.rule(
                        ".\(ClassName.root)--bar,\n.\(ClassName.root)--disclosure",
                        CSS.decl("padding", "10px"),
                        CSS.decl("border-radius", "16px")
                    ),

                    CSS.rule(
                        ".\(ClassName.root)--bar .\(ClassName.item),\n.\(ClassName.root)--cards .\(ClassName.item),\n.\(ClassName.root)--rows .\(ClassName.item)",
                        CSS.decl("grid-template-columns", "auto minmax(0, 1fr)"),
                        CSS.decl("gap", "10px")
                    ),

                    CSS.rule(
                        ".\(ClassName.avatar),\n.\(ClassName.avatarImage),\n.\(ClassName.avatarFallback)",
                        CSS.decl("width", "46px"),
                        CSS.decl("height", "46px")
                    )
                )
            ]
        )
    }
}
