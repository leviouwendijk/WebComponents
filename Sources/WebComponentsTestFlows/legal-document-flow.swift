import TestFlows
import WebComponents

enum LegalDocumentFlowSuite:
    TestFlowRegistry
{
    static let title =
        "Legal document flows"

    static let flows:
        [TestFlow] =
    [
        TestFlow(
            "legal-document-resolution",
            title:
                "Legal document resolves numbering and revision metadata",
            tags: [
                "legal",
                "document",
                "references",
                "version",
            ]
        ) {
            let revision =
                try LegalDocument
                    .Revision(
                        major: 1,
                        minor: 2,
                        patch: 3,
                        year: 2026,
                        month: 8,
                        day: 18
                    )

            let document =
                try LegalDocument(
                    id: "terms",
                    title:
                        "Algemene voorwaarden",
                    revision:
                        revision,
                    numbering:
                        .articles,
                    labels:
                        .dutch,
                    definitions: [
                        .init(
                            id:
                                "consumer",
                            term:
                                "consument",
                            meaning:
                                """
                                De natuurlijke persoon \
                                die niet handelt in de \
                                uitoefening van een \
                                beroep of bedrijf.
                                """
                        )
                    ],
                    sections: [
                        .init(
                            id:
                                "definitions",
                            title:
                                "Definities"
                        ) {
                            references in

                            references
                                .definitionList()
                        },

                        .init(
                            id:
                                "scope",
                            title:
                                "Toepasselijkheid"
                        ) {
                            references in

                            references.section(
                                "definitions"
                            )

                            references.definition(
                                "consumer"
                            )
                        },
                    ]
                )

            let sections =
                document
                    .resolvedSections

            try Expect.equal(
                revision.versionLabel,
                "v1.2.3",
                "version label"
            )

            try Expect.equal(
                revision.dateValue,
                "2026-08-18",
                "revision date"
            )

            try Expect.equal(
                sections.count,
                2,
                "section count"
            )

            try Expect.equal(
                sections[
                    0
                ]
                .headingLabel,
                "Artikel 1 — Definities",
                "first heading"
            )

            try Expect.equal(
                sections[
                    1
                ]
                .referenceLabel,
                "Artikel 2",
                "section reference"
            )

            try Expect.equal(
                document
                    .nodes
                    .stylesheets
                    .count,
                1,
                "component stylesheet contribution"
            )

            return [
                .field(
                    "version",
                    revision
                        .versionLabel
                ),
                .field(
                    "date",
                    revision
                        .dateValue
                ),
                .field(
                    "first",
                    sections[
                        0
                    ]
                    .headingLabel
                ),
                .field(
                    "second-reference",
                    sections[
                        1
                    ]
                    .referenceLabel
                ),
            ]
        }
    ]
}
