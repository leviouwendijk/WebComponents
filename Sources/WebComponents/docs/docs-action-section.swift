import Constructors
import CSS
import HTML

public struct DocsActionCard: ReusableComponent, Sendable {
    public enum Icon: String, Sendable, Hashable {
        case document
        case quiz
        case resource
        case bibliography
    }

    public static let block = "wc-docs-action-card"

    public let href: String
    public let eyebrow: String
    public let title: String
    public let summary: String
    public let meta: String?
    public let icon: Icon?
    public let searchText: String
    public let includeStyles: Bool

    public init(
        href: String,
        eyebrow: String,
        title: String,
        summary: String,
        meta: String? = nil,
        icon: Icon? = nil,
        searchText: String? = nil,
        includeStyles: Bool = true
    ) {
        self.href = href
        self.eyebrow = eyebrow
        self.title = title
        self.summary = summary
        self.meta = meta
        self.icon = icon
        self.searchText = searchText ?? "\(eyebrow) \(title) \(summary) \(meta ?? "")"
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.a(
                    href,
                    [
                        "class": "docs-action-card \(Self.block)",
                        "data-docs-search-item": "",
                        "data-docs-search-text": searchText
                    ]
                ) {
                    HTML.span(["class": "\(Self.block)__eyebrow"]) {
                        HTML.text(eyebrow)
                    }

                    HTML.div(["class": "\(Self.block)__title-row"]) {
                        if let icon {
                            icon_node(icon)
                        }

                        HTML.h3 {
                            HTML.text(title)
                        }
                    }

                    HTML.p {
                        HTML.text(summary)
                    }

                    if let meta, !meta.isEmpty {
                        HTML.span(["class": "\(Self.block)__meta"]) {
                            HTML.text(meta)
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    private func icon_node(
        _ icon: Icon
    ) -> any HTMLNode {
        HTML.span(
            [
                "class": "\(Self.block)__icon \(Self.block)__icon--\(icon.rawValue)",
                "aria-hidden": "true"
            ]
        ) {
            HTML.el(
                "svg",
                [
                    "viewBox": "0 0 24 24",
                    "focusable": "false"
                ]
            ) {
                icon_shape(icon)
            }
        }
    }

    private func icon_shape(
        _ icon: Icon
    ) -> HTMLFragment {
        switch icon {
        case .document:
            return [
                HTML.el(
                    "path",
                    [
                        "d": "M7 3.75h7.25L18 7.5v12.75H7z"
                    ]
                ) {},
                HTML.el(
                    "path",
                    [
                        "d": "M14.25 3.75V7.5H18"
                    ]
                ) {},
                HTML.el(
                    "path",
                    [
                        "d": "M9.25 11.25h5.5M9.25 14.25h5.5M9.25 17.25h3.75"
                    ]
                ) {}
            ]

        case .quiz:
            return [
                HTML.el(
                    "circle",
                    [
                        "cx": "12",
                        "cy": "12",
                        "r": "7.35"
                    ]
                ) {},
                HTML.el(
                    "path",
                    [
                        "d": "M9.75 9.8c.28-1.28 1.34-2.05 2.72-2.05 1.58 0 2.8.98 2.8 2.44 0 1.02-.56 1.63-1.42 2.2-.82.54-1.23.95-1.23 1.86"
                    ]
                ) {},
                HTML.el(
                    "path",
                    [
                        "d": "M12.62 16.8h.01"
                    ]
                ) {}
            ]

        case .resource:
            return [
                HTML.el(
                    "path",
                    [
                        "d": "M5 7h14M5 12h14M5 17h14"
                    ]
                ) {},
                HTML.el(
                    "circle",
                    [
                        "cx": "9",
                        "cy": "7",
                        "r": "1.45"
                    ]
                ) {},
                HTML.el(
                    "circle",
                    [
                        "cx": "15",
                        "cy": "12",
                        "r": "1.45"
                    ]
                ) {},
                HTML.el(
                    "circle",
                    [
                        "cx": "11",
                        "cy": "17",
                        "r": "1.45"
                    ]
                ) {}
            ]

        case .bibliography:
            return [
                HTML.el(
                    "path",
                    [
                        "d": "M5.25 19.25h13.5"
                    ]
                ) {},
                HTML.el(
                    "path",
                    [
                        "d": "M6.25 5.25h3.15v14H6.25z"
                    ]
                ) {},
                HTML.el(
                    "path",
                    [
                        "d": "M10.45 4.75h3.15v14.5h-3.15z"
                    ]
                ) {},
                HTML.el(
                    "path",
                    [
                        "d": "M15.15 6.05l2.55-.42 2.08 12.95-2.55.42z"
                    ]
                ) {},
                HTML.el(
                    "path",
                    [
                        "d": "M7.15 8.25h1.35M7.15 15.9h1.35M11.35 8.25h1.35M11.35 15.9h1.35M16.15 9.1l1.15-.2M17.15 15.35l1.15-.2"
                    ]
                ) {}
            ]
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("display", "block"),
                    CSS.decl("padding", "22px"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("border", "1px solid var(--project-hub-border, var(--border-color, rgba(0, 0, 0, .12)))"),
                    CSS.decl("background", "var(--project-hub-surface, var(--surface-color, #ffffff))"),
                    CSS.decl("color", "var(--project-hub-text, var(--text-color, #222222))"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("min-height", "172px")
                ),

                CSS.rule(
                    ".\(block):hover",
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("background", "var(--project-hub-soft, var(--surface-soft-color, #eeeeee))")
                ),

                CSS.rule(
                    ".\(block)__eyebrow",
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "0 0 12px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".1em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--project-hub-muted, var(--muted-text-color, rgba(0, 0, 0, .62)))")
                ),

                CSS.rule(
                    ".\(block)__title-row",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__icon",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("width", "34px"),
                    CSS.decl("height", "34px"),
                    CSS.decl("flex", "0 0 34px"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--link-color, currentColor) 28%, transparent)"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color, currentColor) 10%, transparent)"),
                    CSS.decl("color", "var(--link-color, currentColor)")
                ),

                CSS.rule(
                    ".\(block)__icon--document",
                    CSS.decl("border-radius", "12px")
                ),

                CSS.rule(
                    ".\(block)__icon--quiz",
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color, currentColor) 16%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__icon--resource",
                    CSS.decl("border-radius", "10px"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color, currentColor) 8%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__icon--bibliography",
                    CSS.decl("border-radius", "9px"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color, currentColor) 54%, var(--link-color, currentColor) 46%)"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color, currentColor) 7%, transparent)"),
                    CSS.decl("border-color", "color-mix(in srgb, var(--text-color, currentColor) 12%, var(--link-color, currentColor) 18%)")
                ),

                CSS.rule(
                    ".\(block)__icon svg",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "19px"),
                    CSS.decl("height", "19px"),
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "currentColor"),
                    CSS.decl("stroke-width", "1.65"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round")
                ),

                CSS.rule(
                    ".\(block)__icon--quiz svg",
                    CSS.decl("width", "21px"),
                    CSS.decl("height", "21px"),
                    CSS.decl("stroke-width", "1.8")
                ),

                CSS.rule(
                    ".\(block)__icon--bibliography svg",
                    CSS.decl("width", "21px"),
                    CSS.decl("height", "21px"),
                    CSS.decl("stroke-width", "1.55")
                ),

                CSS.rule(
                    ".\(block) h3",
                    CSS.decl("min-width", "0"),
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.32rem"),
                    CSS.decl("line-height", "1.12"),
                    CSS.decl("letter-spacing", "-.02em")
                ),

                CSS.rule(
                    ".\(block) p",
                    CSS.decl("margin", "12px 0 0"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("color", "var(--project-hub-muted, var(--muted-text-color, rgba(0, 0, 0, .62)))")
                ),

                CSS.rule(
                    ".\(block)__meta",
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "18px 0 0"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("color", "var(--project-hub-muted, var(--muted-text-color, rgba(0, 0, 0, .62)))")
                )
            ]
        )
    }
}

public struct DocsActionSection: ReusableComponent, Sendable {
    public static let block = "wc-docs-action-section"

    public let title: String
    public let titleHref: String?
    public let lead: String?
    public let cards: [DocsActionCard]
    public let includeStyles: Bool

    public init(
        title: String,
        titleHref: String? = nil,
        lead: String? = nil,
        cards: [DocsActionCard],
        includeStyles: Bool = true
    ) {
        self.title = title
        self.titleHref = titleHref
        self.lead = lead
        self.cards = cards
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.section(["class": "docs-action-section \(Self.block)"]) {
                    HTML.div(["class": "\(Self.block)__header"]) {
                        HTML.h2 {
                            if let titleHref, !titleHref.isEmpty {
                                HTML.a(titleHref) {
                                    HTML.text(title)
                                }
                            } else {
                                HTML.text(title)
                            }
                        }

                        if let lead, !lead.isEmpty {
                            HTML.p {
                                HTML.text(lead)
                            }
                        }
                    }

                    HTML.div(["class": "\(Self.block)__grid"]) {
                        for card in cards {
                            card.nodes.body
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [
                Self.stylesheet(),
                DocsActionCard.stylesheet()
            ] : []
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("margin", "26px 0 0"),
                    CSS.decl("padding", "24px"),
                    CSS.decl("border-radius", "24px"),
                    CSS.decl("border", "1px solid var(--project-hub-border, var(--border-color, rgba(0, 0, 0, .12)))"),
                    CSS.decl("background", "color-mix(in srgb, var(--project-hub-surface, #ffffff) 82%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__header",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(3, minmax(0, 1fr))"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("column-gap", "14px"),
                    CSS.decl("row-gap", "8px"),
                    CSS.decl("margin", "0 0 18px")
                ),

                CSS.rule(
                    ".\(block)__header h2",
                    CSS.decl("grid-column", "1"),
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase")
                ),

                CSS.rule(
                    ".\(block)__header h2 a",
                    CSS.decl("color", "inherit"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".\(block)__header h2 a:hover",
                    CSS.decl("text-decoration", "underline"),
                    CSS.decl("text-underline-offset", "4px")
                ),

                CSS.rule(
                    ".\(block)__header p",
                    CSS.decl("grid-column", "2 / -1"),
                    CSS.decl("max-width", "none"),
                    CSS.decl("margin", "0"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("color", "var(--project-hub-muted, var(--muted-text-color, rgba(0, 0, 0, .62)))")
                ),

                CSS.rule(
                    ".\(block)__grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(3, minmax(0, 1fr))"),
                    CSS.decl("gap", "14px")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 900px)",
                    CSS.rule(
                        ".\(block)__grid",
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        ".\(block)__header",
                        CSS.decl("display", "block")
                    ),
                    CSS.rule(
                        ".\(block)__header p",
                        CSS.decl("margin", "8px 0 0")
                    )
                )
            ]
        )
    }
}
