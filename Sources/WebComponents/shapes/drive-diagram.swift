import Constructors
import HTML
import CSS

public struct DriveDiagram: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-drive-diagram"
        static let visual = "wc-drive-diagram__visual"
        static let card = "wc-drive-diagram__card"
        static let demotivator = "wc-drive-diagram__card--demotivator"
        static let motivator = "wc-drive-diagram__card--motivator"
        static let subject = "wc-drive-diagram__subject"
        static let vector = "wc-drive-diagram__vector"
        static let awayA = "wc-drive-diagram__vector--away-a"
        static let awayB = "wc-drive-diagram__vector--away-b"
        static let towardA = "wc-drive-diagram__vector--toward-a"
        static let towardB = "wc-drive-diagram__vector--toward-b"
        static let arc = "wc-drive-diagram__arc"
        static let caption = "wc-drive-diagram__caption"
    }

    public let caption: String?

    public init(
        caption: String? = nil
    ) {
        self.caption = caption
    }

    public var nodes: ReusableComponentNodes {
        return .body(
            [
                HTML.figure(HTMLAttribute.class(ClassName.root)) {
                    HTML.div(
                        [
                            "class": ClassName.visual,
                            "role": "img",
                            "aria-label": "Drijfveren: demotivatoren stoten gedrag af, motivatoren trekken gedrag aan."
                        ]
                    ) {
                        HTML.div(HTMLAttribute.class([ClassName.card, ClassName.demotivator])) {
                            HTML.text("Demotivator")
                        }

                        HTML.div(HTMLAttribute.class([ClassName.card, ClassName.motivator])) {
                            HTML.text("Motivator")
                        }

                        HTML.span(HTMLAttribute.class([ClassName.vector, ClassName.awayA])) {}
                        HTML.span(HTMLAttribute.class([ClassName.vector, ClassName.awayB])) {}
                        HTML.span(HTMLAttribute.class([ClassName.vector, ClassName.towardA])) {}
                        HTML.span(HTMLAttribute.class([ClassName.vector, ClassName.towardB])) {}
                        HTML.span(HTMLAttribute.class(ClassName.arc)) {}

                        HTML.div(HTMLAttribute.class(ClassName.subject)) {}
                    }

                    if let caption, !caption.isEmpty {
                        HTML.figcaption(HTMLAttribute.class(ClassName.caption)) {
                            HTML.text(caption)
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

    public static func css() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("margin", "22px 0 28px"),
                    CSS.decl("padding", "0")
                ),

                CSS.rule(
                    ".\(ClassName.visual)",
                    CSS.decl("position", "relative"),
                    CSS.decl("min-height", "360px"),
                    CSS.decl("border-bottom", "1px solid var(--border-color, rgba(255,255,255,0.75))"),
                    CSS.decl("color", "var(--text-color, #f4f4f4)")
                ),

                CSS.rule(
                    ".\(ClassName.card)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("top", "48px"),
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "min(30%, 292px)"),
                    CSS.decl("min-height", "76px"),
                    CSS.decl("padding", "12px 18px"),
                    CSS.decl("border", "2px solid currentColor"),
                    CSS.decl("border-radius", "6px"),
                    CSS.decl("font", "700 clamp(1.45rem, 3vw, 2.15rem)/1.1 ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("letter-spacing", "0.03em"),
                    CSS.decl("background", "var(--background-color, #171717)")
                ),

                CSS.rule(
                    ".\(ClassName.demotivator)",
                    CSS.decl("left", "10%")
                ),

                CSS.rule(
                    ".\(ClassName.motivator)",
                    CSS.decl("right", "10%")
                ),

                CSS.rule(
                    ".\(ClassName.subject)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "50%"),
                    CSS.decl("bottom", "78px"),
                    CSS.decl("width", "58px"),
                    CSS.decl("height", "58px"),
                    CSS.decl("transform", "translateX(-50%)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "currentColor")
                ),

                CSS.rule(
                    ".\(ClassName.vector)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("display", "block"),
                    CSS.decl("height", "2px"),
                    CSS.decl("background", "currentColor"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("transform-origin", "50% 50%")
                ),

                CSS.rule(
                    ".\(ClassName.vector)::after",
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

                CSS.rule(
                    ".\(ClassName.awayA)",
                    CSS.decl("left", "35%"),
                    CSS.decl("top", "205px"),
                    CSS.decl("width", "76px"),
                    CSS.decl("transform", "rotate(32deg)")
                ),

                CSS.rule(
                    ".\(ClassName.awayB)",
                    CSS.decl("left", "40%"),
                    CSS.decl("top", "235px"),
                    CSS.decl("width", "66px"),
                    CSS.decl("transform", "rotate(48deg)")
                ),

                CSS.rule(
                    ".\(ClassName.towardA)",
                    CSS.decl("right", "36%"),
                    CSS.decl("top", "215px"),
                    CSS.decl("width", "96px"),
                    CSS.decl("transform", "rotate(-42deg)")
                ),

                CSS.rule(
                    ".\(ClassName.towardB)",
                    CSS.decl("right", "34%"),
                    CSS.decl("top", "245px"),
                    CSS.decl("width", "114px"),
                    CSS.decl("transform", "rotate(-42deg)")
                ),

                CSS.rule(
                    ".\(ClassName.arc)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "25%"),
                    CSS.decl("top", "92px"),
                    CSS.decl("width", "220px"),
                    CSS.decl("height", "150px"),
                    CSS.decl("border-right", "2px solid currentColor"),
                    CSS.decl("border-bottom", "2px solid currentColor"),
                    CSS.decl("border-radius", "0 0 120px 0"),
                    CSS.decl("transform", "rotate(10deg)"),
                    CSS.decl("opacity", "0.9")
                ),

                CSS.rule(
                    ".\(ClassName.caption)",
                    CSS.decl("margin-top", "10px"),
                    CSS.decl("font-size", "0.95rem"),
                    CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(ClassName.visual)",
                        CSS.decl("min-height", "310px")
                    ),
                    CSS.rule(
                        ".\(ClassName.card)",
                        CSS.decl("top", "32px"),
                        CSS.decl("width", "38%"),
                        CSS.decl("min-height", "58px"),
                        CSS.decl("font-size", "clamp(1rem, 4vw, 1.35rem)")
                    ),
                    CSS.rule(
                        ".\(ClassName.demotivator)",
                        CSS.decl("left", "2%")
                    ),
                    CSS.rule(
                        ".\(ClassName.motivator)",
                        CSS.decl("right", "2%")
                    ),
                    CSS.rule(
                        ".\(ClassName.subject)",
                        CSS.decl("bottom", "58px"),
                        CSS.decl("width", "48px"),
                        CSS.decl("height", "48px")
                    ),
                    CSS.rule(
                        ".\(ClassName.arc)",
                        CSS.decl("display", "none")
                    )
                )
            ]
        )
    }
}
