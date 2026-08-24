import Constructors
import CSS
import HTML

public struct QuizCardList:
    ComponentOutputProviding,
    ReusableComponent,
    Sendable
{
    public let items: [QuizItem]

    private static let styleIdentifier: CSSContributionIdentifier =
        "webcomponents.quiz.card-list.styles"

    public init(
        items: [QuizItem]
    ) {
        self.items = items
    }

    public var output: ComponentOutput {
        let cardOutputs =
            items
                .enumerated()
                .map {
                    offset,
                    item in

                    QuizCard(
                        item:
                            item,
                        index:
                            offset + 1
                    )
                    .output
                }

        let ownDependencies =
            ComponentDependencies(
                styles:
                    CSSContributions([
                        Self.styleContribution()
                    ])
            )

        let childDependencies =
            cardOutputs.reduce(
                ComponentDependencies.empty
            ) {
                dependencies,
                output in

                dependencies.merging(
                    output.dependencies
                )
            }

        return ComponentOutput(
            content:
                ComponentContent(
                    body: [
                        HTML.el(
                            "section",
                            [
                                "class": "wc-quiz-list",
                                "aria-label": "Vragen",
                                "data-quiz-list": ""
                            ]
                        ) {
                            for cardOutput in cardOutputs {
                                cardOutput.content.body
                            }
                        }
                    ]
                ),
            dependencies:
                ownDependencies.merging(
                    childDependencies
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
                "QuizCardList semantic CSS conflict: \(error)"
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

    private static func authoredStylesheet()
        -> CSSStyleSheet
    {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-quiz-list",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "grid-template-columns",
                        "1fr"
                    ),
                    CSS.decl(
                        "gap",
                        "10px"
                    )
                )
            ]
        )
    }

    private static func styleContribution()
        -> CSSContribution
    {
        let sheet =
            authoredStylesheet()

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
            styleIdentifier,
            content:
                CSSContributionSet(
                    units:
                        units
                )
        )
    }

    public static func stylesheet()
        -> CSSStyleSheet
    {
        styleContribution().content.sheet
    }
}
