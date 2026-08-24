import Constructors
import CSS
import TestFlows
import WebComponents

enum QuizComponentCompositionFlowSuite:
    TestFlowRegistry
{
    static let title =
        "Quiz semantic component flows"

    static let flows: [TestFlow] = [
        TestFlow(
            "quiz.semantic-component-cluster",
            title:
                "Quiz list composes card content and resolves repeated CSS identity",
            tags: [
                "component",
                "composition",
                "css",
                "quiz",
                "semantic",
                "webcomponents",
            ]
        ) {
            Step(
                "quiz card owns semantic content and CSS identity"
            ) {
                let card =
                    QuizCard(
                        item:
                            fixtures()[0],
                        index:
                            1
                    )

                let output =
                    proveQuizSemanticComponent(
                        card
                    )

                try Expect.equal(
                    output.content.body.count,
                    1,
                    "quiz.card.body-count"
                )

                try Expect.equal(
                    output
                        .dependencies
                        .styles
                        .contributions
                        .map {
                            $0.identifier.rawValue
                        },
                    [
                        "webcomponents.quiz.card.styles",
                    ],
                    "quiz.card.style-identities"
                )

                try Expect.equal(
                    output
                        .dependencies
                        .scripts
                        .contributions
                        .count,
                    0,
                    "quiz.card.script-count"
                )

                let legacy =
                    card.nodes

                try Expect.equal(
                    legacy
                        .body
                        .snippet(),
                    output
                        .content
                        .body
                        .snippet(),
                    "quiz.card.compatibility-body"
                )

                try Expect.equal(
                    legacy.stylesheets.count,
                    1,
                    "quiz.card.compatibility-style-count"
                )

                try Expect.equal(
                    legacy.stylesheets[0],
                    QuizCard.stylesheet(),
                    "quiz.card.compatibility-style"
                )
            }

            Step(
                "quiz list structurally places all card bodies"
            ) {
                let items =
                    fixtures()

                let output =
                    QuizCardList(
                        items:
                            items
                    )
                    .output

                let rendered =
                    output
                        .content
                        .body
                        .snippet()

                try Expect.equal(
                    output.content.body.count,
                    1,
                    "quiz.list.body-count"
                )

                for item in items {
                    try Expect.true(
                        rendered.contains(
                            item.title
                        ),
                        "quiz.list.contains-\(item.id)"
                    )
                }

                let firstOffset =
                    offset(
                        of:
                            items[0].title,
                        in:
                            rendered
                    )

                let secondOffset =
                    offset(
                        of:
                            items[1].title,
                        in:
                            rendered
                    )

                let thirdOffset =
                    offset(
                        of:
                            items[2].title,
                        in:
                            rendered
                    )

                try Expect.true(
                    firstOffset >= 0
                        && secondOffset > firstOffset
                        && thirdOffset > secondOffset,
                    "quiz.list.card-order"
                )
            }

            Step(
                "repeated child CSS remains unresolved until CSS resolution"
            ) {
                let output =
                    QuizCardList(
                        items:
                            fixtures()
                    )
                    .output

                try Expect.equal(
                    output
                        .dependencies
                        .styles
                        .contributions
                        .map {
                            $0.identifier.rawValue
                        },
                    [
                        "webcomponents.quiz.card-list.styles",
                        "webcomponents.quiz.card.styles",
                        "webcomponents.quiz.card.styles",
                        "webcomponents.quiz.card.styles",
                    ],
                    "quiz.list.unresolved-style-identities"
                )

                let resolved =
                    try output
                        .dependencies
                        .styles
                        .resolve()

                try Expect.equal(
                    resolved
                        .identifiers
                        .map(
                            \.rawValue
                        ),
                    [
                        "webcomponents.quiz.card-list.styles",
                        "webcomponents.quiz.card.styles",
                    ],
                    "quiz.list.resolved-style-identities"
                )

                try Expect.equal(
                    resolved
                        .contributions
                        .count,
                    2,
                    "quiz.list.resolved-style-count"
                )
            }

            Step(
                "legacy list view derives resolved semantic styles"
            ) {
                let component =
                    QuizCardList(
                        items:
                            fixtures()
                    )

                let output =
                    component.output

                let resolved =
                    try output
                        .dependencies
                        .styles
                        .resolve()

                let legacy =
                    component.nodes

                try Expect.equal(
                    legacy
                        .body
                        .snippet(),
                    output
                        .content
                        .body
                        .snippet(),
                    "quiz.list.compatibility-body"
                )

                try Expect.equal(
                    legacy.stylesheets.count,
                    2,
                    "quiz.list.compatibility-style-count"
                )

                try Expect.equal(
                    legacy.stylesheets[0],
                    resolved
                        .contributions[0]
                        .content
                        .sheet,
                    "quiz.list.compatibility-parent-style"
                )

                try Expect.equal(
                    legacy.stylesheets[1],
                    resolved
                        .contributions[1]
                        .content
                        .sheet,
                    "quiz.list.compatibility-card-style"
                )

                try Expect.equal(
                    legacy.stylesheets[0],
                    QuizCardList.stylesheet(),
                    "quiz.list.public-parent-style"
                )
            }
        }
    ]

    private static func fixtures()
        -> [QuizItem]
    {
        [
            fixture(
                id:
                    "one",
                title:
                    "First semantic card"
            ),
            fixture(
                id:
                    "two",
                title:
                    "Second semantic card"
            ),
            fixture(
                id:
                    "three",
                title:
                    "Third semantic card"
            ),
        ]
    }

    private static func fixture(
        id:
            String,
        title:
            String
    ) -> QuizItem {
        QuizItem(
            id:
                id,
            slug:
                "semantic-\(id)",
            title:
                title,
            prompt:
                "Choose the correct answer.",
            group:
                "Semantic",
            level:
                .beginner,
            choices: [
                QuizChoice(
                    "a",
                    "A"
                ),
                QuizChoice(
                    "b",
                    "B"
                ),
            ],
            rule:
                .one("a"),
            explanation:
                "Semantic fixture.",
            href:
                "/quiz/semantic-\(id)/"
        )
    }

    private static func offset(
        of needle:
            String,
        in haystack:
            String
    ) -> Int {
        guard let range =
            haystack.range(
                of:
                    needle
            )
        else {
            return -1
        }

        return haystack.distance(
            from:
                haystack.startIndex,
            to:
                range.lowerBound
        )
    }
}

private func proveQuizSemanticComponent<
    Component
>(
    _ component:
        Component
) -> ComponentOutput
where
    Component:
        ComponentOutputProviding
{
    component.output
}
