import Constructors
import CSS
import HTML

public struct DocsDisclosureSection: Sendable {
    public let id: String
    public let eyebrow: String?
    public let title: String
    public let summary: String
    public let defaultOpen: Bool
    public let body: @Sendable () -> HTMLFragment

    public init(
        id: String,
        eyebrow: String? = nil,
        title: String,
        summary: String,
        defaultOpen: Bool = false,
        body: @escaping @Sendable () -> HTMLFragment
    ) {
        self.id = id
        self.eyebrow = eyebrow
        self.title = title
        self.summary = summary
        self.defaultOpen = defaultOpen
        self.body = body
    }

    func node(
        block: String
    ) -> any HTMLNode {
        let attrs: HTMLAttribute = {
            var attrs: HTMLAttribute = [
                "id": id,
                "class": "\(block)__section",
                "data-docs-disclosure-section": id
            ]

            attrs.merge(HTMLAttribute.bool("open", defaultOpen))

            return attrs
        }()

        return HTML.details(attrs) {
            HTML.summary(["class": "\(block)__summary"]) {
                HTML.div(["class": "\(block)__summary-main"]) {
                    if let eyebrow, !eyebrow.isEmpty {
                        HTML.span(["class": "\(block)__eyebrow"]) {
                            HTML.text(eyebrow)
                        }
                    }

                    HTML.span(["class": "\(block)__title"]) {
                        HTML.text(title)
                    }

                    HTML.span(["class": "\(block)__summary-text"]) {
                        HTML.text(summary)
                    }
                }

                HTML.span(["class": "\(block)__indicator", "aria-hidden": "true"]) {
                    HTML.text("+")
                }
            }

            HTML.div(["class": "\(block)__content"]) {
                body()
            }
        }
    }
}

public struct DocsDisclosureGroup: ReusableComponent, Sendable {
    public static let block = "wc-docs-disclosure-group"

    public let eyebrow: String?
    public let title: String?
    public let lead: String?
    public let sections: [DocsDisclosureSection]
    public let includeStyles: Bool

    public init(
        eyebrow: String? = nil,
        title: String? = nil,
        lead: String? = nil,
        sections: [DocsDisclosureSection],
        includeStyles: Bool = true
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.lead = lead
        self.sections = sections
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.section(["class": "docs-disclosure-group \(Self.block)"]) {
                    if hasHeader {
                        HTML.div(["class": "\(Self.block)__header"]) {
                            if let eyebrow, !eyebrow.isEmpty {
                                HTML.p(["class": "\(Self.block)__header-eyebrow"]) {
                                    HTML.text(eyebrow)
                                }
                            }

                            if let title, !title.isEmpty {
                                HTML.h2 {
                                    HTML.text(title)
                                }
                            }

                            if let lead, !lead.isEmpty {
                                HTML.p(["class": "\(Self.block)__lead"]) {
                                    HTML.text(lead)
                                }
                            }
                        }
                    }

                    HTML.div(["class": "\(Self.block)__sections"]) {
                        for section in sections {
                            section.node(block: Self.block)
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    private var hasHeader: Bool {
        !(eyebrow?.isEmpty ?? true)
        || !(title?.isEmpty ?? true)
        || !(lead?.isEmpty ?? true)
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("--docs-disclosure-surface", "color-mix(in srgb, var(--background-color) 94%, var(--text-color) 6%)"),
                    CSS.decl("--docs-disclosure-surface-open", "color-mix(in srgb, var(--background-color) 88%, var(--text-color) 12%)"),
                    CSS.decl("--docs-disclosure-border", "color-mix(in srgb, var(--text-color) 16%, transparent)"),
                    CSS.decl("--docs-disclosure-muted", "color-mix(in srgb, var(--text-color) 62%, transparent)"),
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "28px 0 0")
                ),

                CSS.rule(
                    ".dark-mode .\(block)",
                    CSS.decl("--docs-disclosure-surface", "color-mix(in srgb, var(--background-color) 86%, var(--text-color) 8%)"),
                    CSS.decl("--docs-disclosure-surface-open", "color-mix(in srgb, var(--background-color) 78%, var(--text-color) 10%)")
                ),

                CSS.rule(
                    ".\(block)__header",
                    CSS.decl("margin", "0 0 14px"),
                    CSS.decl("padding", "0 0 16px"),
                    CSS.decl("border-bottom", "1px solid var(--docs-disclosure-border)")
                ),

                CSS.rule(
                    ".\(block)__header-eyebrow",
                    CSS.decl("margin", "0 0 8px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--docs-disclosure-muted)")
                ),

                CSS.rule(
                    ".\(block)__header h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.35rem"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("letter-spacing", "-.025em")
                ),

                CSS.rule(
                    ".\(block)__lead",
                    CSS.decl("max-width", "720px"),
                    CSS.decl("margin", "10px 0 0"),
                    CSS.decl("line-height", "1.62"),
                    CSS.decl("color", "var(--docs-disclosure-muted)")
                ),

                CSS.rule(
                    ".\(block)__sections",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "12px")
                ),

                CSS.rule(
                    ".\(block)__section",
                    CSS.decl("scroll-margin-top", "calc(var(--wc-docs-sticky-offset, 112px) + 24px)"),
                    CSS.decl("border", "1px solid var(--docs-disclosure-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--docs-disclosure-surface)"),
                    CSS.decl("overflow", "clip")
                ),

                CSS.rule(
                    ".\(block)__section[open]",
                    CSS.decl("background", "var(--docs-disclosure-surface-open)")
                ),

                CSS.rule(
                    ".\(block)__summary",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) auto"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("padding", "18px 20px"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("list-style", "none")
                ),

                CSS.rule(
                    ".\(block)__summary::-webkit-details-marker",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(block)__summary-main",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__eyebrow",
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--docs-disclosure-muted)")
                ),

                CSS.rule(
                    ".\(block)__title",
                    CSS.decl("font-size", "1.05rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".\(block)__summary-text",
                    CSS.decl("max-width", "720px"),
                    CSS.decl("font-size", ".94rem"),
                    CSS.decl("line-height", "1.5"),
                    CSS.decl("color", "var(--docs-disclosure-muted)")
                ),

                CSS.rule(
                    ".\(block)__indicator",
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "28px"),
                    CSS.decl("height", "28px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("border", "1px solid var(--docs-disclosure-border)"),
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("transition", "transform .18s ease")
                ),

                CSS.rule(
                    ".\(block)__section[open] .\(block)__indicator",
                    CSS.decl("transform", "rotate(45deg)")
                ),

                CSS.rule(
                    ".\(block)__content",
                    CSS.decl("padding", "0 20px 20px"),
                    CSS.decl("border-top", "1px solid var(--docs-disclosure-border)")
                ),

                CSS.rule(
                    ".\(block)__content > :first-child",
                    CSS.decl("margin-top", "16px")
                ),

                CSS.rule(
                    ".\(block)__content > :last-child",
                    CSS.decl("margin-bottom", "0")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("margin-top", "22px")
                    ),
                    CSS.rule(
                        ".\(block)__summary",
                        CSS.decl("padding", "16px")
                    ),
                    CSS.rule(
                        ".\(block)__content",
                        CSS.decl("padding", "0 16px 16px")
                    )
                )
            ]
        )
    }
}
