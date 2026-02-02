import Constructors
import HTML
import CSS

public enum ArrowDirection: Sendable {
    case right
    case left
    case both
}

public struct Arrow: WebComponent, Sendable {
    public let classes: [String]
    public let attrs: HTMLAttribute
    public let label: String?
    public let direction: ArrowDirection

    public init(
        classes: [String] = [],
        attrs: HTMLAttribute = HTMLAttribute(),
        label: String? = nil,
        direction: ArrowDirection = .right
    ) {
        self.classes = classes
        self.attrs = attrs
        self.label = label
        self.direction = direction
    }

    public func html() -> HTMLFragment {
        var finalAttrs = HTMLAttribute()
        finalAttrs.merge(.aria("hidden", "true"))
        finalAttrs.merge(attrs)

        let directionClass: [String] = {
            switch direction {
            case .right:
                return [] // keep legacy behavior
            case .left:
                return ["wc-flow__arrow--left"]
            case .both:
                return ["wc-flow__arrow--both"]
            }
        }()

        let a = Self.makeAttrs(
            baseClasses: ["wc-flow__arrow"] + directionClass + classes,
            attrs: finalAttrs
        )

        return [
            HTML.div(.class(["wc-flow__arrow-wrap"])) {
                HTML.span(a) {}

                if let label, !label.isEmpty {
                    HTML.span(.class(["wc-flow__arrow-label"])) {
                        HTML.text(label)
                    }
                }
            }
        ]
    }

    public func styles() -> [CSSStyleSheet] {
        [Self.css()]
    }
}

extension Arrow {
    private static func makeAttrs(
        baseClasses: [String],
        attrs: HTMLAttribute
    ) -> HTMLAttribute {
        var out = HTMLAttribute()
        out.merge(.class(Self.normalizeClasses(baseClasses)))
        out.merge(attrs)
        return out
    }

    private static func normalizeClasses(_ parts: [String]) -> [String] {
        parts
            .flatMap { $0.split(separator: " ").map(String.init) }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    public static func css() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-flow__arrow-wrap",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("min-width", "48px")
                ),

                CSS.rule(
                    ".wc-flow__arrow",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "inline-block"),
                    CSS.decl("width", "54px"),
                    CSS.decl("height", "2px"),
                    CSS.decl("color", "var(--flow-arrow-color, var(--text-color, #0f172a))"),
                    CSS.decl("background", "currentColor"),
                    CSS.decl("border-radius", "999px")
                ),

                // Legacy: default right-pointing head (kept, so existing arrows do not change)
                CSS.rule(
                    ".wc-flow__arrow::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("right", "-1px"),
                    CSS.decl("top", "50%"),
                    CSS.decl("transform", "translateY(-50%)"),
                    CSS.decl("width", "0"),
                    CSS.decl("height", "0"),
                    CSS.decl("border-top", "7px solid transparent"),
                    CSS.decl("border-bottom", "7px solid transparent"),
                    CSS.decl("border-left", "10px solid currentColor")
                ),

                // Left: override the existing ::after triangle
                CSS.rule(
                    ".wc-flow__arrow--left::after",
                    CSS.decl("right", "auto"),
                    CSS.decl("left", "-1px"),
                    CSS.decl("border-left", "0"),
                    CSS.decl("border-right", "10px solid currentColor")
                ),

                // Both: keep default ::after (right) and add ::before (left)
                CSS.rule(
                    ".wc-flow__arrow--both::before",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "-1px"),
                    CSS.decl("top", "50%"),
                    CSS.decl("transform", "translateY(-50%)"),
                    CSS.decl("width", "0"),
                    CSS.decl("height", "0"),
                    CSS.decl("border-top", "7px solid transparent"),
                    CSS.decl("border-bottom", "7px solid transparent"),
                    CSS.decl("border-right", "10px solid currentColor")
                ),

                CSS.rule(
                    ".wc-flow__arrow-label",
                    CSS.decl("font-size", "0.9rem"),
                    CSS.decl(
                        "color",
                        "var(--flow-label-color, var(--ref-meta-text-color, var(--text-color, #0f172a)))"
                    ),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("text-align", "center"),
                    CSS.decl("max-width", "180px")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 900px)",
                    CSS.rule(
                        ".wc-flow__arrow",
                        CSS.decl("width", "48px")
                    )
                ),
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".wc-flow__arrow-wrap",
                        CSS.decl("min-width", "30px")
                    ),
                    CSS.rule(
                        ".wc-flow__arrow",
                        CSS.decl("width", "32px")
                    ),
                    CSS.rule(
                        ".wc-flow__arrow-label",
                        CSS.decl("font-size", "0.95rem")
                    )
                )
            ]
        )
    }
}
