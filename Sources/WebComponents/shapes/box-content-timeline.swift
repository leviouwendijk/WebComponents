import Constructors
import HTML
import CSS

public struct BoxContentTimeline:
    ComponentOutputProviding,
    ReusableComponent,
    Sendable
{
    private enum Contribution:
        String,
        CSSContributionIdentifying
    {
        case styles =
            "webcomponents.shapes.box-content-timeline.styles"
    }

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

    public var output: ComponentOutput {
        var rootAttrs =
            HTMLAttribute.class(
                [ClassName.root]
                    + classes
            )

        rootAttrs.merge(
            attrs
        )

        let childOutputs =
            steps.map {
                FlowBox(
                    $0.box
                )
                .output
            }

        let childDependencies =
            childOutputs.reduce(
                ComponentDependencies.empty
            ) {
                partial,
                child in

                partial.merging(
                    child.dependencies
                )
            }

        let ownDependencies =
            ComponentDependencies(
                styles:
                    CSSContributions([
                        Self.styleContribution()
                    ])
            )

        return ComponentOutput(
            content:
                ComponentContent(
                    body: [
                        HTML.div(rootAttrs) {
                            for index in steps.indices {
                                let step =
                                    steps[
                                        index
                                    ]

                                let child =
                                    childOutputs[
                                        index
                                    ]

                                HTML.div(
                                    HTMLAttribute.class(
                                        ClassName.step
                                    )
                                ) {
                                    HTML.div(
                                        HTMLAttribute.class(
                                            ClassName.boxCell
                                        )
                                    ) {
                                        child.content.body
                                    }

                                    HTML.div(
                                        HTMLAttribute.class(
                                            ClassName.contentCell
                                        )
                                    ) {
                                        step.content()
                                    }
                                }

                                if index
                                    < steps.index(
                                        before:
                                            steps.endIndex
                                    )
                                {
                                    HTML.div(
                                        HTMLAttribute.class(
                                            ClassName.connector
                                        )
                                    ) {
                                        HTML.div(
                                            HTMLAttribute.class(
                                                ClassName.connectorBoxCell
                                            )
                                        ) {
                                            HTML.span(
                                                HTMLAttribute.class(
                                                    ClassName.arrow
                                                )
                                            ) {}
                                        }

                                        HTML.div(
                                            HTMLAttribute.class(
                                                ClassName.connectorContentCell
                                            )
                                        ) {}
                                    }
                                }
                            }
                        }
                    ]
                ),
            dependencies:
                childDependencies
                    .merging(
                        ownDependencies
                    )
        )
    }

    public var nodes: ReusableComponentNodes {
        let semantic =
            output

        let resolvedStyles:
            ResolvedCSSContributions

        do {
            resolvedStyles =
                try semantic
                    .dependencies
                    .styles
                    .resolve()
        } catch {
            preconditionFailure(
                "BoxContentTimeline semantic CSS conflict: \(error)"
            )
        }

        return .body(
            semantic.content.body,
            stylesheets:
                resolvedStyles
                    .contributions
                    .map {
                        $0.content.sheet
                    },
            scripts:
                semantic
                    .dependencies
                    .scripts
                    .contributions
                    .map(\.script)
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    private static func authoredStylesheet() -> CSSStyleSheet {
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
                    ".\(ClassName.boxCell) .\(FlowBox.selectors.box.rawValue)",
                    CSS.decl("width", "min(100%, var(--wc-box-content-timeline-box-width, 320px))"),
                    CSS.decl("min-width", "min(100%, var(--wc-box-content-timeline-box-min-width, 260px))"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(ClassName.boxCell) .\(FlowBox.selectors.boxInner.rawValue)",
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("text-align", "center")
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
    private static func styleContribution() -> CSSContribution {
        let sheet = authoredStylesheet()

        let units =
            sheet.rules.map {
                CSSContributionUnit.block(
                    .rule($0)
                )
            }
            + sheet.media.map {
                CSSContributionUnit.block(
                    .media($0)
                )
            }
            + sheet.keyframes.map {
                CSSContributionUnit.block(
                    .keyframes($0)
                )
            }

        return CSS.contribution(
            Contribution.styles
        ) {
            units
        }
    }

    public static func css() -> CSSStyleSheet {
        styleContribution().content.sheet
    }

}
