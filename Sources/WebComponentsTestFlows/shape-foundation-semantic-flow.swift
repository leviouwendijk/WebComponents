import Constructors
import CSS
import TestFlows
import WebComponents

enum ShapeFoundationSemanticFlowSuite:
    TestFlowRegistry
{
    static let title =
        "Shape foundation semantic flows"

    static let flows: [TestFlow] = [
        TestFlow(
            "shapes.semantic-foundation",
            title:
                "Foundation shape components own stable semantic CSS dependencies",
            tags: [
                "component",
                "css",
                "semantic",
                "shapes",
                "webcomponents",
            ]
        ) {
            Step(
                "four foundation shapes own one identified stylesheet each"
            ) {
                let arrow =
                    fixtureArrow()

                let flowBox =
                    fixtureFlowBox()

                let flowDiagram =
                    fixtureFlowDiagram()

                let processTimeline =
                    fixtureProcessTimeline()

                let outputs = [
                    proveShapeComponent(
                        arrow
                    ),
                    proveShapeComponent(
                        flowBox
                    ),
                    proveShapeComponent(
                        flowDiagram
                    ),
                    proveShapeComponent(
                        processTimeline
                    ),
                ]

                try Expect.equal(
                    outputs
                        .flatMap {
                            $0
                                .dependencies
                                .styles
                                .contributions
                                .map {
                                    $0.identifier.rawValue
                                }
                        },
                    [
                        "webcomponents.shapes.arrow.styles",
                        "webcomponents.shapes.flow-box.styles",
                        "webcomponents.shapes.flow-diagram.styles",
                        "webcomponents.shapes.process-timeline.styles",
                    ],
                    "shapes.foundation.style-identities"
                )

                try Expect.equal(
                    outputs
                        .reduce(0) {
                            $0
                            + $1
                                .dependencies
                                .scripts
                                .contributions
                                .count
                        },
                    0,
                    "shapes.foundation.script-count"
                )

                try Expect.true(
                    outputs.allSatisfy {
                        $0.content.body.count == 1
                    },
                    "shapes.foundation.body-count"
                )
            }

            Step(
                "legacy views are derived from semantic output"
            ) {
                try proveShapeCompatibility(
                    fixtureArrow(),
                    sheet:
                        Arrow.css(),
                    label:
                        "arrow"
                )

                try proveShapeCompatibility(
                    fixtureFlowBox(),
                    sheet:
                        FlowBox.css(),
                    label:
                        "flow-box"
                )

                try proveShapeCompatibility(
                    fixtureFlowDiagram(),
                    sheet:
                        FlowDiagram.css(),
                    label:
                        "flow-diagram"
                )

                try proveShapeCompatibility(
                    fixtureProcessTimeline(),
                    sheet:
                        ProcessTimeline.css(),
                    label:
                        "process-timeline"
                )

                try Expect.equal(
                    FlowDiagram.css(),
                    FlowDiagram.stylesheet(),
                    "shapes.flow-diagram.css-alias"
                )
            }

            Step(
                "repeated foundation outputs remain unresolved then deduplicate by identity"
            ) {
                let arrow =
                    fixtureArrow()

                let flowBox =
                    fixtureFlowBox()

                let flowDiagram =
                    fixtureFlowDiagram()

                let processTimeline =
                    fixtureProcessTimeline()

                let outputs = [
                    arrow.output,
                    arrow.output,
                    flowBox.output,
                    flowBox.output,
                    flowDiagram.output,
                    flowDiagram.output,
                    processTimeline.output,
                    processTimeline.output,
                ]

                let merged =
                    outputs.reduce(
                        ComponentOutput.empty
                    ) {
                        partial,
                        next in

                        partial.merging(
                            next
                        )
                    }

                try Expect.equal(
                    merged
                        .dependencies
                        .styles
                        .contributions
                        .count,
                    8,
                    "shapes.foundation.unresolved-count"
                )

                let resolved =
                    try merged
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
                        "webcomponents.shapes.arrow.styles",
                        "webcomponents.shapes.flow-box.styles",
                        "webcomponents.shapes.flow-diagram.styles",
                        "webcomponents.shapes.process-timeline.styles",
                    ],
                    "shapes.foundation.resolved-identities"
                )

                try Expect.equal(
                    resolved
                        .contributions
                        .count,
                    4,
                    "shapes.foundation.resolved-count"
                )
            }
        }
    ]

    private static func fixtureArrow()
        -> Arrow
    {
        Arrow(
            label:
                "Semantic arrow"
        )
    }

    private static func fixtureFlowBox()
        -> FlowBox
    {
        FlowBox(
            Box(
                content: {
                    []
                }
            )
        )
    }

    private static func fixtureFlowDiagram()
        -> FlowDiagram
    {
        FlowDiagram(
            items: [
                .box(
                    Box(
                        content: {
                            []
                        }
                    )
                ),
                .arrow(
                    Arrow(
                        label:
                            "Semantic flow"
                    )
                ),
                .box(
                    Box(
                        content: {
                            []
                        }
                    )
                ),
            ]
        )
    }

    private static func fixtureProcessTimeline()
        -> ProcessTimeline
    {
        ProcessTimeline(
            steps: [
                ProcessTimeline.Step(
                    title:
                        "Semantic step"
                )
            ]
        )
    }
}

private func proveShapeComponent<
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

private func proveShapeCompatibility<
    Component
>(
    _ component:
        Component,
    sheet:
        CSSStyleSheet,
    label:
        String
) throws
where
    Component: ComponentOutputProviding,
    Component: ReusableComponent
{
    let output =
        component.output

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
        "shapes.\(label).compatibility-body"
    )

    try Expect.equal(
        legacy.stylesheets.count,
        1,
        "shapes.\(label).compatibility-style-count"
    )

    try Expect.equal(
        legacy.stylesheets[0],
        sheet,
        "shapes.\(label).compatibility-style"
    )
}
