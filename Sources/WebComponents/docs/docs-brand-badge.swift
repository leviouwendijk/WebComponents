import Constructors
import CSS
import HTML

public struct DocsBrandBadge: SelectableComponent, Sendable {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-brand-badge"

    public let markURL: String
    public let accessibilityLabel: String?
    public let includeStyles: Bool

    public init(
        markURL: String,
        accessibilityLabel: String? = nil,
        includeStyles: Bool = true
    ) {
        self.markURL = markURL
        self.accessibilityLabel = accessibilityLabel
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        let attrs: HTMLAttribute = {
            if let accessibilityLabel {
                return [
                    "class": Self.block,
                    "role": "img",
                    "aria-label": accessibilityLabel
                ]
            } else {
                return [
                    "class": Self.block,
                    "aria-hidden": "true"
                ]
            }
        }()

        return .body(
            [
                HTML.span(attrs) {
                    HTML.span(
                        [
                            "class": "\(Self.block)__glyph",
                            "style": "--wc-docs-brand-mark-url: url('\(markURL)');"
                        ]
                    ) {}
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("width", "32px"),
                    CSS.decl("height", "32px"),
                    CSS.decl("flex", "0 0 32px"),
                    CSS.decl("border-radius", "10px"),
                    CSS.decl(
                        "background",
                        "var(--wc-docs-brand-badge-bg, color-mix(in srgb, var(--text-color) 10%, transparent))"
                    ),
                    CSS.decl(
                        "box-shadow",
                        "inset 0 0 0 1px color-mix(in srgb, var(--text-color) 8%, transparent)"
                    ),
                    CSS.decl("color", "var(--wc-docs-brand-glyph-color, var(--text-color))"),
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".\(block)__glyph",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "22px"),
                    CSS.decl("height", "22px"),
                    CSS.decl("background", "currentColor"),

                    CSS.decl("-webkit-mask-image", "var(--wc-docs-brand-mark-url)"),
                    CSS.decl("-webkit-mask-repeat", "no-repeat"),
                    CSS.decl("-webkit-mask-position", "center"),
                    CSS.decl("-webkit-mask-size", "contain"),

                    CSS.decl("mask-image", "var(--wc-docs-brand-mark-url)"),
                    CSS.decl("mask-repeat", "no-repeat"),
                    CSS.decl("mask-position", "center"),
                    CSS.decl("mask-size", "contain")
                ),

                CSS.rule(
                    ".dark-mode .\(block)",
                    CSS.decl(
                        "--wc-docs-brand-badge-bg",
                        "color-mix(in srgb, var(--text-color) 14%, transparent)"
                    )
                )
            ]
        )
    }
}
