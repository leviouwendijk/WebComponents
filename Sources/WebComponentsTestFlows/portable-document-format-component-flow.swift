import Constructors
import CSS
import JS
import TestFlows
import WebComponents

enum PortableDocumentFormatComponentFlowSuite:
    TestFlowRegistry
{
    static let title =
        "Portable document format component flows"

    static let flows:
        [TestFlow] =
    [
        TestFlow(
            "portable-document-format.semantic-component",
            title:
                "Portable PDF export owns identified CSS and runtime JS dependencies",
            tags: [
                "component",
                "css",
                "js",
                "pdf",
                "semantic",
                "webcomponents",
            ]
        ) {
            Step(
                "semantic output always owns HTML, CSS, and runtime JS"
            ) {
                let component =
                    firstFixture()

                let output =
                    proveSemanticComponent(
                        component
                    )

                try Expect.equal(
                    output
                        .content
                        .head
                        .count,
                    0,
                    "pdf.output.head-count"
                )

                try Expect.equal(
                    output
                        .content
                        .body
                        .count,
                    1,
                    "pdf.output.body-count"
                )

                try Expect.equal(
                    output
                        .dependencies
                        .styles
                        .contributions
                        .count,
                    1,
                    "pdf.output.style-count"
                )

                try Expect.equal(
                    output
                        .dependencies
                        .styles
                        .contributions[
                            0
                        ]
                        .identifier
                        .rawValue,
                    "webcomponents.portable-document-format.export.styles",
                    "pdf.output.style-identity"
                )

                try Expect.equal(
                    output
                        .dependencies
                        .scripts
                        .contributions
                        .count,
                    1,
                    "pdf.output.script-count"
                )

                try Expect.equal(
                    output
                        .dependencies
                        .scripts
                        .contributions[
                            0
                        ]
                        .identifier
                        .rawValue,
                    "webcomponents.portable-document-format.runtime",
                    "pdf.output.script-identity"
                )

                let runtime =
                    proveSemanticComponent(
                        PortableDocumentFormatRuntimeScript()
                    )

                try Expect.equal(
                    runtime
                        .dependencies
                        .scripts
                        .contributions[
                            0
                        ]
                        .identifier
                        .rawValue,
                    "webcomponents.portable-document-format.runtime",
                    "pdf.runtime.shared-script-identity"
                )
            }

            Step(
                "repeated instances request the same dependencies and resolve once"
            ) {
                let first =
                    firstFixture()
                        .output

                let second =
                    secondFixture()
                        .output

                let unresolved =
                    first
                        .merging(
                            second
                        )

                try Expect.equal(
                    unresolved
                        .dependencies
                        .styles
                        .contributions
                        .count,
                    2,
                    "pdf.repeated.unresolved-style-count"
                )

                try Expect.equal(
                    unresolved
                        .dependencies
                        .scripts
                        .contributions
                        .count,
                    2,
                    "pdf.repeated.unresolved-script-count"
                )

                let styles =
                    try unresolved
                        .dependencies
                        .styles
                        .resolve()

                let scripts =
                    try unresolved
                        .dependencies
                        .scripts
                        .resolve()

                try Expect.equal(
                    styles
                        .contributions
                        .count,
                    1,
                    "pdf.repeated.resolved-style-count"
                )

                try Expect.equal(
                    scripts
                        .contributions
                        .count,
                    1,
                    "pdf.repeated.resolved-script-count"
                )

                try Expect.equal(
                    styles
                        .identifiers[
                            0
                        ]
                        .rawValue,
                    "webcomponents.portable-document-format.export.styles",
                    "pdf.repeated.resolved-style-identity"
                )

                try Expect.equal(
                    scripts
                        .identifiers[
                            0
                        ]
                        .rawValue,
                    "webcomponents.portable-document-format.runtime",
                    "pdf.repeated.resolved-script-identity"
                )
            }

            Step(
                "legacy ReusableComponent view is derived from semantic output"
            ) {
                let component =
                    firstFixture()

                proveLegacyComponent(
                    component
                )

                let output =
                    component.output

                let nodes =
                    component.nodes

                try Expect.equal(
                    nodes
                        .body
                        .count,
                    output
                        .content
                        .body
                        .count,
                    "pdf.compatibility.body-count"
                )

                try Expect.equal(
                    nodes
                        .stylesheets
                        .count,
                    output
                        .dependencies
                        .styles
                        .contributions
                        .count,
                    "pdf.compatibility.stylesheet-count"
                )

                try Expect.equal(
                    nodes
                        .scripts
                        .count,
                    output
                        .dependencies
                        .scripts
                        .contributions
                        .count,
                    "pdf.compatibility.script-count"
                )

                try Expect.equal(
                    nodes
                        .stylesheets[
                            0
                        ],
                    output
                        .dependencies
                        .styles
                        .contributions[
                            0
                        ]
                        .content
                        .sheet,
                    "pdf.compatibility.stylesheet-content"
                )

                try Expect.equal(
                    nodes
                        .scripts[
                            0
                        ],
                    output
                        .dependencies
                        .scripts
                        .contributions[
                            0
                        ]
                        .script,
                    "pdf.compatibility.script-content"
                )

                try Expect.equal(
                    PortableDocumentFormatExport
                        .stylesheet(),
                    output
                        .dependencies
                        .styles
                        .contributions[
                            0
                        ]
                        .content
                        .sheet,
                    "pdf.compatibility.public-stylesheet"
                )
            }
        }
    ]

    private static func firstFixture()
        -> PortableDocumentFormatExport
    {
        PortableDocumentFormatExport(
            id:
                "pdf-semantic-one",
            filename:
                "semantic-one.pdf",
            payload:
                .document(
                    title:
                        "Semantic PDF one",
                    blocks: [
                        .paragraph(
                            "First payload"
                        )
                    ]
                )
        )
    }

    private static func secondFixture()
        -> PortableDocumentFormatExport
    {
        PortableDocumentFormatExport(
            id:
                "pdf-semantic-two",
            label:
                "Download second PDF",
            filename:
                "semantic-two.pdf",
            payload:
                .document(
                    title:
                        "Semantic PDF two",
                    blocks: [
                        .paragraph(
                            "Second payload"
                        )
                    ]
                )
        )
    }
}

private func proveSemanticComponent<Component>(
    _ component:
        Component
) -> ComponentOutput
where
    Component:
        ComponentOutputProviding
{
    component.output
}

private func proveLegacyComponent<Component>(
    _ component:
        Component
)
where
    Component:
        ReusableComponent
{
    _ =
        component.nodes
}
