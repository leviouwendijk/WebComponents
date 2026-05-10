import Constructors
import HTML
import CSS

public struct BoxContentTimeline: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-box-content-timeline"
        static let step = "wc-box-content-timeline__step"
        static let boxCell = "wc-box-content-timeline__box-cell"
        static let contentCell = "wc-box-content-timeline__content-cell"
        static let connector = "wc-box-content-timeline__connector"
        static let connectorBoxCell = "wc-box-content-timeline__connector-box-cell"
        static let connectorContentCell = "wc-box-content-timeline__connector-content-cell"
        static let arrow = "wc-box-content-timeline__arrow"
    }

    public struct Step: Sendable {
        public let box: Box
        public let content: @Sendable () -> HTMLFragment

        public init(
            box: Box,
            content: @escaping @Sendable () -> HTMLFragment
        ) {
            self.box = box
            self.content = content
        }
    }

    public let classes: [String]
    public let attrs: HTMLAttribute
    public let steps: [Step]

    public init(
        classes: [String] = [],
        attrs: HTMLAttribute = HTMLAttribute(),
        steps: [Step]
    ) {
        self.classes = classes
        self.attrs = attrs
        self.steps = steps
    }

    public var nodes: ReusableComponentNodes {
        var rootAttrs = HTMLAttribute.class([ClassName.root] + classes)
        rootAttrs.merge(attrs)

        return .body(
            [
                HTML.div(rootAttrs) {
                    for index in steps.indices {
                        let step = steps[index]

                        HTML.div(HTMLAttribute.class(ClassName.step)) {
                            HTML.div(HTMLAttribute.class(ClassName.boxCell)) {
                                FlowBox(step.box).node()
                            }

                            HTML.div(HTMLAttribute.class(ClassName.contentCell)) {
                                step.content()
                            }
                        }

                        if index < steps.index(before: steps.endIndex) {
                            HTML.div(HTMLAttribute.class(ClassName.connector)) {
                                HTML.div(HTMLAttribute.class(ClassName.connectorBoxCell)) {
                                    HTML.span(HTMLAttribute.class(ClassName.arrow)) {}
                                }

                                HTML.div(HTMLAttribute.class(ClassName.connectorContentCell)) {}
                            }
                        }
                    }
                }
            ],
            stylesheets: [
                FlowBox.css(),
                Self.css()
            ]
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
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "1fr"),
                    CSS.decl("gap", "0"),
                    CSS.decl("margin", "18px 0")
                ),

                CSS.rule(
                    ".\(ClassName.step)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(240px, 0.9fr) minmax(320px, 1.2fr)"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("align-items", "center")
                ),

                CSS.rule(
                    ".\(ClassName.boxCell)",
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("align-items", "center")
                ),

                CSS.rule(
                    ".\(ClassName.contentCell)",
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(ClassName.connector)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(240px, 0.9fr) minmax(320px, 1.2fr)"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("min-height", "58px"),
                    CSS.decl("align-items", "center")
                ),

                CSS.rule(
                    ".\(ClassName.connectorBoxCell)",
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("align-items", "center")
                ),

                CSS.rule(
                    ".\(ClassName.arrow)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "inline-block"),
                    CSS.decl("width", "2px"),
                    CSS.decl("height", "44px"),
                    CSS.decl("background", "var(--flow-arrow-color, var(--text-color, #0f172a))"),
                    CSS.decl("border-radius", "999px")
                ),

                CSS.rule(
                    ".\(ClassName.arrow)::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "50%"),
                    CSS.decl("bottom", "-1px"),
                    CSS.decl("transform", "translateX(-50%)"),
                    CSS.decl("width", "0"),
                    CSS.decl("height", "0"),
                    CSS.decl("border-left", "7px solid transparent"),
                    CSS.decl("border-right", "7px solid transparent"),
                    CSS.decl("border-top", "10px solid var(--flow-arrow-color, var(--text-color, #0f172a))")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 900px)",
                    CSS.rule(
                        ".\(ClassName.step)",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "14px")
                    ),
                    CSS.rule(
                        ".\(ClassName.connector)",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("min-height", "48px")
                    ),
                    CSS.rule(
                        ".\(ClassName.connectorContentCell)",
                        CSS.decl("display", "none")
                    ),
                    CSS.rule(
                        ".\(ClassName.arrow)",
                        CSS.decl("height", "34px")
                    )
                )
            ]
        )
    }
}
