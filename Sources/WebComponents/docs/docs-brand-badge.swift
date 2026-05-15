import Constructors
import CSS
import HTML

public struct DocsBrandBadge: SelectableComponent, Sendable {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-brand-badge"

    public let markURL: String?
    public let fallbackText: String
    public let accessibilityLabel: String?
    public let includeStyles: Bool

    public init(
        markURL: String? = nil,
        fallbackText: String,
        accessibilityLabel: String? = nil,
        includeStyles: Bool = true
    ) {
        self.markURL = markURL
        self.fallbackText = fallbackText
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
            }

            return [
                "class": Self.block,
                "aria-hidden": "true"
            ]
        }()

        return .body(
            [
                HTML.span(attrs) {
                    HTML.span(["class": "\(Self.block)__fallback"]) {
                        HTML.text(fallbackText)
                    }

                    if let markURL {
                        HTML.span(
                            [
                                "class": "\(Self.block)__glyph",
                                "style": "--wc-docs-brand-mark-url: url('\(markURL)');"
                            ]
                        ) {}

                        HTML.img(
                            src: markURL,
                            alt: "",
                            [
                                "class": "\(Self.block)__probe",
                                "aria-hidden": "true",
                                "onload": "this.parentElement.classList.add('wc-docs-brand-badge--image-loaded')",
                                "onerror": "this.parentElement.classList.remove('wc-docs-brand-badge--image-loaded')"
                            ]
                        )
                    }
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
                        "var(--wc-docs-brand-badge-bg, color-mix(in srgb, var(--text-color) 9%, transparent))"
                    ),
                    CSS.decl(
                        "box-shadow",
                        "inset 0 0 0 1px color-mix(in srgb, var(--text-color) 8%, transparent)"
                    ),
                    CSS.decl("color", "var(--wc-docs-brand-glyph-color, var(--text-color))"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("position", "relative")
                ),

                CSS.rule(
                    ".\(block)__fallback",
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("letter-spacing", "-.06em"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("color", "currentColor")
                ),

                CSS.rule(
                    ".\(block)__glyph",
                    CSS.decl("display", "none"),
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
                    ".\(block)--image-loaded .\(block)__fallback",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(block)--image-loaded .\(block)__glyph",
                    CSS.decl("display", "block")
                ),

                CSS.rule(
                    ".\(block)__probe",
                    CSS.decl("position", "absolute"),
                    CSS.decl("width", "1px"),
                    CSS.decl("height", "1px"),
                    CSS.decl("opacity", "0"),
                    CSS.decl("pointer-events", "none"),
                    CSS.decl("user-select", "none")
                ),

                CSS.rule(
                    ".dark-mode .\(block)",
                    CSS.decl(
                        "--wc-docs-brand-badge-bg",
                        "color-mix(in srgb, var(--text-color) 13%, transparent)"
                    )
                )
            ]
        )
    }
}
