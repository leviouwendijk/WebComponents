import Constructors
import CSS
import HTML
import TestFlows
import WebComponents

enum ShapeParentSemanticFlowSuite:
    TestFlowRegistry
{
    static let title =
        "Shape parent semantic flows"

    static let flows: [TestFlow] = [
        TestFlow(
            "shapes.semantic-flow-box-parents",
            title:
                "Shape parents structurally compose FlowBox output and propagate child dependencies",
            tags: [
                "component",
                "composition",
                "css",
                "nested",
                "semantic",
                "shapes",
                "webcomponents",
            ]
        ) {
            Step(
                "box-and-content propagates its actual FlowBox child dependency"
            ) {
                let component =
                    BoxAndContent(
                        box:
                            fixtureBox(
                                "box-and-content-child"
                            )
                    ) {
                        [
                            HTML.text(
                                "box-and-content-content"
                            )
                        ]
                    }

                let output =
                    proveShapeParent(
                        component
                    )

                try Expect.equal(
                    styleIdentifiers(
                        output
                    ),
                    [
                        "webcomponents.shapes.flow-box.styles",
                        "webcomponents.shapes.box-and-content.styles",
                    ],
                    "shapes.box-and-content.unresolved-identities"
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
                        "webcomponents.shapes.flow-box.styles",
                        "webcomponents.shapes.box-and-content.styles",
                    ],
                    "shapes.box-and-content.resolved-identities"
                )

                let rendered =
                    output
                        .content
                        .body
                        .snippet()

                try Expect.true(
                    rendered.contains(
                        "box-and-content-child"
                    ),
                    "shapes.box-and-content.child-content"
                )

                try Expect.true(
                    rendered.contains(
                        "box-and-content-content"
                    ),
                    "shapes.box-and-content.parent-content"
                )

                try Expect.equal(
                    BoxAndContent.css(),
                    resolved
                        .contributions[
                            1
                        ]
                        .content
                        .sheet,
                    "shapes.box-and-content.compatibility-sheet"
                )

                try proveCompatibility(
                    component,
                    label:
                        "box-and-content"
                )
            }

            Step(
                "timeline dependency multiplicity follows actual step count"
            ) {
                let component =
                    BoxContentTimeline(
                        steps: [
                            .init(
                                box:
                                    fixtureBox(
                                        "timeline-one"
                                    )
                            ) {
                                [
                                    HTML.text(
                                        "timeline-content-one"
                                    )
                                ]
                            },
                            .init(
                                box:
                                    fixtureBox(
                                        "timeline-two"
                                    )
                            ) {
                                [
                                    HTML.text(
                                        "timeline-content-two"
                                    )
                                ]
                            },
                            .init(
                                box:
                                    fixtureBox(
                                        "timeline-three"
                                    )
                            ) {
                                [
                                    HTML.text(
                                        "timeline-content-three"
                                    )
                                ]
                            },
                        ]
                    )

                let output =
                    proveShapeParent(
                        component
                    )

                try Expect.equal(
                    styleIdentifiers(
                        output
                    ),
                    [
                        "webcomponents.shapes.flow-box.styles",
                        "webcomponents.shapes.flow-box.styles",
                        "webcomponents.shapes.flow-box.styles",
                        "webcomponents.shapes.box-content-timeline.styles",
                    ],
                    "shapes.timeline.unresolved-identities"
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
                        "webcomponents.shapes.flow-box.styles",
                        "webcomponents.shapes.box-content-timeline.styles",
                    ],
                    "shapes.timeline.resolved-identities"
                )

                let empty =
                    BoxContentTimeline(
                        steps:
                            []
                    )
                    .output

                try Expect.equal(
                    styleIdentifiers(
                        empty
                    ),
                    [
                        "webcomponents.shapes.box-content-timeline.styles",
                    ],
                    "shapes.timeline.empty-identities"
                )

                try Expect.equal(
                    BoxContentTimeline.css(),
                    resolved
                        .contributions[
                            1
                        ]
                        .content
                        .sheet,
                    "shapes.timeline.compatibility-sheet"
                )

                let rendered =
                    output
                        .content
                        .body
                        .snippet()

                try Expect.true(
                    rendered.contains(
                        "timeline-one"
                    )
                    && rendered.contains(
                        "timeline-two"
                    )
                    && rendered.contains(
                        "timeline-three"
                    ),
                    "shapes.timeline.child-content"
                )

                try proveCompatibility(
                    component,
                    label:
                        "timeline"
                )
            }

            Step(
                "matrix propagates every actually rendered FlowBox child"
            ) {
                let component =
                    fixtureMatrix()

                let output =
                    proveShapeParent(
                        component
                    )

                let identifiers =
                    styleIdentifiers(
                        output
                    )

                try Expect.equal(
                    identifiers.count,
                    7,
                    "shapes.matrix.unresolved-count"
                )

                try Expect.equal(
                    Array(
                        identifiers.prefix(
                            6
                        )
                    ),
                    Array(
                        repeating:
                            "webcomponents.shapes.flow-box.styles",
                        count:
                            6
                    ),
                    "shapes.matrix.child-identities"
                )

                try Expect.equal(
                    identifiers[
                        6
                    ],
                    "webcomponents.shapes.matrix-diagram.styles",
                    "shapes.matrix.parent-identity"
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
                        "webcomponents.shapes.flow-box.styles",
                        "webcomponents.shapes.matrix-diagram.styles",
                    ],
                    "shapes.matrix.resolved-identities"
                )

                let empty =
                    MatrixDiagram(
                        columns:
                            0,
                        rows:
                            0,
                        cells:
                            []
                    )
                    .output

                try Expect.equal(
                    styleIdentifiers(
                        empty
                    ),
                    [
                        "webcomponents.shapes.matrix-diagram.styles",
                    ],
                    "shapes.matrix.empty-identities"
                )

                try Expect.equal(
                    MatrixDiagram.css(),
                    resolved
                        .contributions[
                            1
                        ]
                        .content
                        .sheet,
                    "shapes.matrix.compatibility-sheet"
                )

                let rendered =
                    output
                        .content
                        .body
                        .snippet()

                try Expect.true(
                    rendered.contains(
                        "matrix-cell-one"
                    )
                    && rendered.contains(
                        "matrix-cell-two"
                    )
                    && rendered.contains(
                        "matrix-cell-three"
                    )
                    && rendered.contains(
                        "matrix-column-header"
                    )
                    && rendered.contains(
                        "matrix-row-header"
                    )
                    && rendered.contains(
                        "matrix-corner-header"
                    ),
                    "shapes.matrix.child-content"
                )

                try proveCompatibility(
                    component,
                    label:
                        "matrix"
                )
            }
        }
    ]

    private static func fixtureBox(
        _ label:
            String
    ) -> Box {
        Box {
            [
                HTML.text(
                    label
                )
            ]
        }
    }

    private static func fixtureMatrix()
        -> MatrixDiagram
    {
        MatrixDiagram(
            columns:
                2,
            rows:
                2,
            cells: [
                [
                    .box(
                        fixtureBox(
                            "matrix-cell-one"
                        )
                    ),
                    .empty,
                ],
                [
                    .box(
                        fixtureBox(
                            "matrix-cell-two"
                        )
                    ),
                    .box(
                        fixtureBox(
                            "matrix-cell-three"
                        )
                    ),
                ],
            ],
            columnHeaders: [
                .box(
                    fixtureBox(
                        "matrix-column-header"
                    )
                ),
                .empty,
            ],
            rowHeaders: [
                .box(
                    fixtureBox(
                        "matrix-row-header"
                    )
                ),
                .empty,
            ],
            cornerHeader:
                .box(
                    fixtureBox(
                        "matrix-corner-header"
                    )
                ),
            showsCrosshair:
                true
        )
    }
}

private func proveShapeParent<
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

private func styleIdentifiers(
    _ output:
        ComponentOutput
) -> [String] {
    output
        .dependencies
        .styles
        .contributions
        .map {
            $0.identifier.rawValue
        }
}

private func proveCompatibility<
    Component
>(
    _ component:
        Component,
    label:
        String
) throws
where
    Component: ComponentOutputProviding,
    Component: ReusableComponent
{
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
        "shapes.\(label).compatibility-body"
    )

    try Expect.equal(
        legacy.stylesheets,
        resolved
            .contributions
            .map {
                $0.content.sheet
            },
        "shapes.\(label).compatibility-styles"
    )

    try Expect.equal(
        legacy.scripts.count,
        0,
        "shapes.\(label).compatibility-script-count"
    )
}
