import Foundation
import Constructors
import CSS
import HTML

public struct DocsSectionIndex: ReusableComponent {
    public static let block = "wc-docs-section-index"

    public struct Item: Sendable {
        public let id: String
        public let label: String
        public let eyebrow: String?
        public let meta: String?
        public let href: String?

        public init(
            id: String,
            label: String,
            eyebrow: String? = nil,
            meta: String? = nil,
            href: String? = nil
        ) {
            self.id = id
            self.label = label
            self.eyebrow = eyebrow
            self.meta = meta
            self.href = href
        }

        var resolvedHref: String {
            href ?? "#\(id)"
        }
    }

    public let items: [Item]
    public let eyebrow: String?
    public let title: String
    public let ariaLabel: String
    public let includeStyles: Bool

    public init(
        items: [Item],
        eyebrow: String? = "Inhoud",
        title: String = "Secties",
        ariaLabel: String = "Sectie-index",
        includeStyles: Bool = true
    ) {
        self.items = items
        self.eyebrow = eyebrow
        self.title = title
        self.ariaLabel = ariaLabel
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        guard !items.isEmpty else {
            return .init()
        }

        return .body(
            [
                HTML.nav(
                    [
                        "class": Self.block,
                        "aria-label": ariaLabel
                    ]
                ) {
                    HTML.div(["class": "\(Self.block)__card"]) {
                        if let eyebrow, !eyebrow.isEmpty {
                            HTML.p(["class": "\(Self.block)__eyebrow"]) {
                                HTML.text(eyebrow)
                            }
                        }

                        HTML.h2(["class": "\(Self.block)__title"]) {
                            HTML.text(title)
                        }

                        HTML.ol(["class": "\(Self.block)__list"]) {
                            for item in items {
                                itemNode(item)
                            }
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    private func itemNode(
        _ item: Item
    ) -> any HTMLNode {
        HTML.li(["class": "\(Self.block)__item"]) {
            HTML.a(
                item.resolvedHref,
                ["class": "\(Self.block)__link"]
            ) {
                HTML.span(["class": "\(Self.block)__link-text"]) {
                    if let eyebrow = item.eyebrow, !eyebrow.isEmpty {
                        HTML.span(["class": "\(Self.block)__link-eyebrow"]) {
                            HTML.text(eyebrow)
                        }
                    }

                    HTML.span(["class": "\(Self.block)__link-label"]) {
                        HTML.text(item.label)
                    }
                }

                if let meta = item.meta, !meta.isEmpty {
                    HTML.span(["class": "\(Self.block)__meta"]) {
                        HTML.text(meta)
                    }
                }
            }
        }
    }

    public static func anchorID(
        prefix: String,
        value: String
    ) -> String {
        let cleaned = value
            .lowercased()
            .map { character -> Character in
                if character.isLetter || character.isNumber {
                    return character
                }

                return "-"
            }
            .reduce(into: "") { partial, character in
                if character == "-", partial.last == "-" {
                    return
                }

                partial.append(character)
            }
            .trimmingCharacters(in: CharacterSet(charactersIn: "-"))

        if cleaned.isEmpty {
            return prefix
        }

        return "\(prefix)-\(cleaned)"
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block)__card",
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "20px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)")
                ),

                CSS.rule(
                    ".dark-mode .\(block)__card",
                    CSS.decl("box-shadow", "0 18px 40px rgba(0, 0, 0, .24)")
                ),

                CSS.rule(
                    ".\(block)__eyebrow",
                    CSS.decl("margin", "0 0 6px"),
                    CSS.decl("font-size", ".74rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__title",
                    CSS.decl("margin", "0 0 14px"),
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("line-height", "1.2"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block)__list",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("list-style", "none")
                ),

                CSS.rule(
                    ".\(block)__link",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("padding", "9px 10px"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("transition", "background-color .14s ease, color .14s ease, transform .14s ease")
                ),

                CSS.rule(
                    ".\(block)__link:hover",
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 10%, transparent)"),
                    CSS.decl("color", "var(--link-color)"),
                    CSS.decl("transform", "translateX(2px)")
                ),

                CSS.rule(
                    ".\(block)__link:focus-visible",
                    CSS.decl("outline", "2px solid var(--link-color)"),
                    CSS.decl("outline-offset", "2px")
                ),

                CSS.rule(
                    ".\(block)__link-text",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "2px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__link-eyebrow",
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".04em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__link-label",
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "680"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".\(block)__meta",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("min-width", "28px"),
                    CSS.decl("height", "24px"),
                    CSS.decl("padding", "0 8px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "640"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 8%, transparent)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 1180px)",
                    CSS.rule(
                        ".\(block)__list",
                        CSS.decl("grid-template-columns", "repeat(2, minmax(0, 1fr))")
                    )
                ),

                CSS.media(
                    "(max-width: 700px)",
                    CSS.rule(
                        ".\(block)__card",
                        CSS.decl("padding", "14px"),
                        CSS.decl("border-radius", "16px")
                    ),

                    CSS.rule(
                        ".\(block)__list",
                        CSS.decl("grid-template-columns", "1fr")
                    ),

                    CSS.rule(
                        ".\(block)__link",
                        CSS.decl("padding", "9px")
                    )
                )
            ]
        )
    }
}
