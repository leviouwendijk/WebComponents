import Constructors
import CSS
import HTML
import TestFlows
import WebComponents

enum EditorialComponentCompositionFlowSuite:
    TestFlowRegistry
{
    static let title =
        "Editorial component composition flows"

    static let flows: [TestFlow] = [
        TestFlow(
            "editorial.semantic-nested-component",
            title:
                "Example code block composes editorial header content and dependencies semantically",
            tags: [
                "component",
                "composition",
                "css",
                "editorial",
                "nested",
                "semantic",
                "webcomponents",
            ]
        ) {
            Step(
                "child owns semantic content and identified CSS"
            ) {
                let component =
                    headerFixture()

                let output =
                    proveEditorialSemanticComponent(
                        component
                    )

                try Expect.equal(
                    output.content.body.count,
                    1,
                    "editorial.header.body-count"
                )

                try Expect.equal(
                    output
                        .dependencies
                        .styles
                        .contributions
                        .count,
                    1,
                    "editorial.header.style-count"
                )

                try Expect.equal(
                    output
                        .dependencies
                        .styles
                        .contributions[0]
                        .identifier
                        .rawValue,
                    "webcomponents.editorial.section-header.styles",
                    "editorial.header.style-identity"
                )

                try Expect.equal(
                    output
                        .dependencies
                        .scripts
                        .contributions
                        .count,
                    0,
                    "editorial.header.script-count"
                )

                try Expect.equal(
                    component
                        .nodes
                        .body
                        .snippet(),
                    output
                        .content
                        .body
                        .snippet(),
                    "editorial.header.compatibility-body"
                )

                try Expect.equal(
                    component.sheet(),
                    output
                        .dependencies
                        .styles
                        .contributions[0]
                        .content
                        .sheet,
                    "editorial.header.compatibility-sheet"
                )

                try Expect.equal(
                    EditorialSectionHeader.css(),
                    component.sheet(),
                    "editorial.header.public-css"
                )
            }

            Step(
                "parent places child content and propagates child dependencies"
            ) {
                let component =
                    exampleFixture(
                        withHeader:
                            true
                    )

                let output =
                    proveEditorialSemanticComponent(
                        component
                    )

                try Expect.equal(
                    output.content.body.count,
                    1,
                    "editorial.example.body-count"
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
                        "webcomponents.editorial.section-header.styles",
                        "webcomponents.editorial.example-code.styles",
                    ],
                    "editorial.example.nested-style-identities"
                )

                try Expect.equal(
                    output
                        .dependencies
                        .scripts
                        .contributions
                        .count,
                    0,
                    "editorial.example.script-count"
                )

                let rendered =
                    output
                        .content
                        .body
                        .snippet()

                let headerOffset =
                    rendered
                        .range(
                            of:
                                "Nested child"
                        )
                        .map {
                            rendered.distance(
                                from:
                                    rendered.startIndex,
                                to:
                                    $0.lowerBound
                            )
                        }
                    ?? -1

                let codeOffset =
                    rendered
                        .range(
                            of:
                                "let nested = true"
                        )
                        .map {
                            rendered.distance(
                                from:
                                    rendered.startIndex,
                                to:
                                    $0.lowerBound
                            )
                        }
                    ?? -1

                try Expect.true(
                    headerOffset >= 0,
                    "editorial.example.child-marker-present"
                )

                try Expect.true(
                    codeOffset > headerOffset,
                    "editorial.example.child-before-code"
                )

                let nodes =
                    component.nodes

                try Expect.equal(
                    nodes
                        .body
                        .snippet(),
                    rendered,
                    "editorial.example.compatibility-body"
                )

                try Expect.equal(
                    nodes.stylesheets.count,
                    2,
                    "editorial.example.compatibility-style-count"
                )

                try Expect.equal(
                    nodes.stylesheets[0],
                    output
                        .dependencies
                        .styles
                        .contributions[0]
                        .content
                        .sheet,
                    "editorial.example.compatibility-child-style"
                )

                try Expect.equal(
                    nodes.stylesheets[1],
                    output
                        .dependencies
                        .styles
                        .contributions[1]
                        .content
                        .sheet,
                    "editorial.example.compatibility-own-style"
                )

                try Expect.equal(
                    component.sheet(),
                    ExampleCodeBlock.css(),
                    "editorial.example.public-own-sheet"
                )
            }

            Step(
                "dependency presence follows actual nested content"
            ) {
                let output =
                    exampleFixture(
                        withHeader:
                            false
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
                        "webcomponents.editorial.example-code.styles",
                    ],
                    "editorial.example.no-header-style-identities"
                )

                try Expect.equal(
                    output
                        .content
                        .body
                        .snippet()
                        .contains(
                            "Nested child"
                        ),
                    false,
                    "editorial.example.no-header-content"
                )
            }

            Step(
                "repeated nested outputs retain duplicates then resolve once"
            ) {
                let first =
                    exampleFixture(
                        withHeader:
                            true
                    )
                    .output

                let second =
                    exampleFixture(
                        withHeader:
                            true
                    )
                    .output

                let unresolved =
                    first.merging(
                        second
                    )

                try Expect.equal(
                    unresolved
                        .dependencies
                        .styles
                        .contributions
                        .count,
                    4,
                    "editorial.repeated.unresolved-style-count"
                )

                let resolved =
                    try unresolved
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
                        "webcomponents.editorial.section-header.styles",
                        "webcomponents.editorial.example-code.styles",
                    ],
                    "editorial.repeated.resolved-style-identities"
                )

                try Expect.equal(
                    resolved
                        .contributions
                        .count,
                    2,
                    "editorial.repeated.resolved-style-count"
                )
            }
        }
    ]

    private static func headerFixture()
        -> EditorialSectionHeader
    {
        EditorialSectionHeader(
            .init(
                eyebrow:
                    "Semantic composition",
                title:
                    "Nested child",
                subtitle: [
                    HTML.p {
                        HTML.text(
                            "Child content remains structural."
                        )
                    }
                ]
            )
        )
    }

    private static func exampleFixture(
        withHeader:
            Bool
    ) -> ExampleCodeBlock {
        ExampleCodeBlock(
            .init(
                header:
                    withHeader
                    ? headerFixture().model
                    : nil,
                intro: [
                    HTML.p {
                        HTML.text(
                            "Parent intro"
                        )
                    }
                ],
                code:
                    "let nested = true",
                language:
                    "swift",
                caption: [
                    HTML.p {
                        HTML.text(
                            "Parent caption"
                        )
                    }
                ]
            )
        )
    }
}

private func proveEditorialSemanticComponent<
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
