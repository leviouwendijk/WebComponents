import Constructors
import CSS
import HTML

public struct DocsAIContentNotice:
    ReusableComponent,
    Sendable
{
    private enum ClassName {
        static let root = "wc-docs-ai-content-notice"
        static let icon = "wc-docs-ai-content-notice__icon"
        static let content = "wc-docs-ai-content-notice__content"
        static let title = "wc-docs-ai-content-notice__title"
        static let message = "wc-docs-ai-content-notice__message"
    }

    public let title: String
    public let message: String
    public let iconLabel: String
    public let includeStyles: Bool

    public init(
        title: String,
        message: String,
        iconLabel: String = "AI",
        includeStyles: Bool = true
    ) {
        self.title = title
        self.message = message
        self.iconLabel = iconLabel
        self.includeStyles = includeStyles
    }

    public init(
        lexicon: DocsLexicon,
        iconLabel: String = "AI",
        includeStyles: Bool = true
    ) {
        self.init(
            title: lexicon.aiContentNoticeTitle,
            message: lexicon.aiContentNoticeMessage,
            iconLabel: iconLabel,
            includeStyles: includeStyles
        )
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                node()
            ],
            stylesheets: includeStyles
                ? [
                    Self.stylesheet()
                ]
                : []
        )
    }

    public func node() -> any HTMLNode {
        HTML.aside(
            [
                "class": ClassName.root,
                "role": "note",
                "aria-label": title
            ]
        ) {
            HTML.span(
                [
                    "class": ClassName.icon,
                    "aria-hidden": "true"
                ]
            ) {
                HTML.text(iconLabel)
            }

            HTML.div(
                [
                    "class": ClassName.content
                ]
            ) {
                HTML.p(
                    [
                        "class": ClassName.title
                    ]
                ) {
                    HTML.text(title)
                }

                HTML.p(
                    [
                        "class": ClassName.message
                    ]
                ) {
                    HTML.text(message)
                }
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("display", "grid"),
                    CSS.decl(
                        "grid-template-columns",
                        "34px minmax(0, 1fr)"
                    ),
                    CSS.decl("align-items", "start"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("width", "100%"),
                    CSS.decl("margin", "0 0 28px"),
                    CSS.decl("padding", "14px 16px"),
                    CSS.decl(
                        "border",
                        "1px solid color-mix(in srgb, var(--text-color) 12%, transparent)"
                    ),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl(
                        "background",
                        "color-mix(in srgb, var(--surface-color, var(--background-color)) 95%, var(--text-color) 5%)"
                    ),
                    CSS.decl(
                        "color",
                        "var(--text-color)"
                    )
                ),

                CSS.rule(
                    ".\(ClassName.icon)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("width", "34px"),
                    CSS.decl("height", "34px"),
                    CSS.decl("border-radius", "10px"),
                    CSS.decl(
                        "border",
                        "1px solid color-mix(in srgb, var(--link-color) 24%, transparent)"
                    ),
                    CSS.decl(
                        "background",
                        "color-mix(in srgb, var(--link-color) 9%, transparent)"
                    ),
                    CSS.decl(
                        "color",
                        "color-mix(in srgb, var(--link-color) 74%, var(--text-color))"
                    ),
                    CSS.decl(
                        "font-family",
                        "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"
                    ),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("letter-spacing", ".04em"),
                    CSS.decl("line-height", "1")
                ),

                CSS.rule(
                    ".\(ClassName.content)",
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(ClassName.title)",
                    CSS.decl("margin", "1px 0 4px"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("line-height", "1.25")
                ),

                CSS.rule(
                    ".\(ClassName.message)",
                    CSS.decl("margin", "0"),
                    CSS.decl("max-width", "76ch"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("line-height", "1.5"),
                    CSS.decl(
                        "color",
                        "var(--muted-text-color, color-mix(in srgb, var(--text-color) 68%, transparent))"
                    )
                )
            ],

            media: [
                CSS.media(
                    "(max-width: 560px)",

                    CSS.rule(
                        ".\(ClassName.root)",
                        CSS.decl(
                            "grid-template-columns",
                            "30px minmax(0, 1fr)"
                        ),
                        CSS.decl("gap", "10px"),
                        CSS.decl("padding", "12px")
                    ),

                    CSS.rule(
                        ".\(ClassName.icon)",
                        CSS.decl("width", "30px"),
                        CSS.decl("height", "30px"),
                        CSS.decl("border-radius", "9px"),
                        CSS.decl("font-size", ".62rem")
                    )
                )
            ]
        )
    }
}
