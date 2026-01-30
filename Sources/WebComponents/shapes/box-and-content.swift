import Constructors
import HTML
import CSS

public struct BoxAndContent: WebComponent {
    public enum Layout: Sendable {
        case boxLeft
        case boxRight
    }

    public let layout: Layout
    public let classes: [String]
    public let attrs: HTMLAttribute

    public let box: Box
    public let content: @Sendable () -> HTMLFragment

    public init(
        layout: Layout = .boxLeft,
        classes: [String] = [],
        attrs: HTMLAttribute = HTMLAttribute(),
        box: Box,
        content: @escaping @Sendable () -> HTMLFragment
    ) {
        self.layout = layout
        self.classes = classes
        self.attrs = attrs
        self.box = box
        self.content = content
    }

    public func html() -> HTMLFragment {
        let layoutClass: String = (layout == .boxLeft) ? "wc-box-and-content--box-left" : "wc-box-and-content--box-right"

        let a = makeAttrs(
            baseClasses: ["wc-box-and-content", layoutClass] + classes,
            attrs: attrs
        )

        return [
            HTML.div(a) {
                HTML.div(.class(["wc-box-and-content__box"])) {
                    // Emit the SAME box markup/classes as FlowDiagram, reusing existing styles.
                    boxHTML(box)
                }

                HTML.div(.class(["wc-box-and-content__content"])) {
                    content()
                }
            }
        ]
    }

    public func styles() -> [CSSStyleSheet] {
        [Self.css()]
    }
}

extension BoxAndContent {
    private func boxHTML(_ b: Box) -> any HTMLNode {
        let alignClass: String = {
            switch b.align {
            case .center: return "wc-flow__box--center"
            case .start:  return "wc-flow__box--start"
            }
        }()

        let a = makeAttrs(
            baseClasses: ["wc-flow__box", alignClass] + b.classes,
            attrs: b.attrs
        )

        return HTML.div(a) {
            HTML.div(.class(["wc-flow__box-inner"])) {
                b.content()
            }
        }
    }

    private func makeAttrs(
        baseClasses: [String],
        attrs: HTMLAttribute
    ) -> HTMLAttribute {
        var out = HTMLAttribute()
        out.merge(.class(normalizeClasses(baseClasses)))
        out.merge(attrs)
        return out
    }

    private func normalizeClasses(_ parts: [String]) -> [String] {
        parts
            .flatMap { $0.split(separator: " ").map(String.init) }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    public static func css() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-box-and-content",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(240px, 0.9fr) minmax(320px, 1.2fr)"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("margin", "18px 0")
                ),

                CSS.rule(
                    ".wc-box-and-content--box-right",
                    CSS.decl("grid-template-columns", "minmax(320px, 1.2fr) minmax(240px, 0.9fr)")
                ),

                CSS.rule(
                    ".wc-box-and-content--box-right .wc-box-and-content__box",
                    CSS.decl("grid-column", "2")
                ),

                CSS.rule(
                    ".wc-box-and-content--box-right .wc-box-and-content__content",
                    CSS.decl("grid-column", "1")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 900px)",
                    CSS.rule(
                        ".wc-box-and-content",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "14px")
                    ),
                    CSS.rule(
                        ".wc-box-and-content--box-right .wc-box-and-content__box",
                        CSS.decl("grid-column", "auto")
                    ),
                    CSS.rule(
                        ".wc-box-and-content--box-right .wc-box-and-content__content",
                        CSS.decl("grid-column", "auto")
                    )
                )
            ]
        )
    }
}
