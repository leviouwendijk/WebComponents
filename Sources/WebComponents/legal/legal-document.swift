import Foundation
import Constructors
import CSS
import HTML
import Primitives
import Version

public struct LegalDocument:
    SelectableComponent,
    Sendable
{
    public enum Namespace {}

    public typealias SelectorNamespace =
        Namespace

    public static let block =
        "wc-legal-document"

    public struct ID:
        RawRepresentable,
        Hashable,
        Sendable,
        ExpressibleByStringLiteral
    {
        public let rawValue: String

        public init(
            rawValue: String
        ) {
            self.rawValue =
                rawValue
        }

        public init(
            _ rawValue: String
        ) {
            self.rawValue =
                rawValue
        }

        public init(
            stringLiteral value: String
        ) {
            self.rawValue =
                value
        }
    }

    public struct Revision:
        Sendable
    {
        public enum Error:
            Swift.Error,
            LocalizedError,
            Sendable
        {
            case incompleteDate

            public var errorDescription:
                String?
            {
                switch self {
                case .incompleteDate:
                    return """
                    A legal document revision requires \
                    a complete day-level date.
                    """
                }
            }
        }

        public let version:
            ObjectVersion

        public let date:
            PartialDate

        public let dateValue:
            String

        public var versionLabel:
            String
        {
            version.string(
                prefixStyle: .short,
                prefixSpace: false
            )
        }

        public init(
            version: ObjectVersion,
            date: PartialDate
        ) throws {
            let parts: (
                year: Int,
                month: Int,
                day: Int
            )

            do {
                parts =
                    try date.requireComplete()
            } catch {
                throw Error.incompleteDate
            }

            self.version =
                version

            self.date =
                date

            self.dateValue =
                Self.dateValue(
                    year: parts.year,
                    month: parts.month,
                    day: parts.day
                )
        }

        public init(
            major: Int,
            minor: Int,
            patch: Int,
            year: Int,
            month: Int,
            day: Int
        ) throws {
            try self.init(
                version: ObjectVersion(
                    major: major,
                    minor: minor,
                    patch: patch
                ),
                date: try PartialDate(
                    year: year,
                    month: month,
                    day: day
                )
            )
        }

        private static func dateValue(
            year: Int,
            month: Int,
            day: Int
        ) -> String {
            """
            \(year)-\(twoDigit(month))-\(twoDigit(day))
            """
        }

        private static func twoDigit(
            _ value: Int
        ) -> String {
            value < 10
                ? "0\(value)"
                : "\(value)"
        }
    }

    public struct Labels:
        Sendable,
        Equatable
    {
        public let contents:
            String

        public let version:
            String

        public let revisionDate:
            String

        public let unresolvedSection:
            String

        public let unresolvedDefinition:
            String

        public init(
            contents: String,
            version: String,
            revisionDate: String,
            unresolvedSection: String,
            unresolvedDefinition: String
        ) {
            self.contents =
                contents

            self.version =
                version

            self.revisionDate =
                revisionDate

            self.unresolvedSection =
                unresolvedSection

            self.unresolvedDefinition =
                unresolvedDefinition
        }

        public static let english =
            Self(
                contents: "Contents",
                version: "Version",
                revisionDate: "Revision date",
                unresolvedSection:
                    "Unresolved section",
                unresolvedDefinition:
                    "Unresolved definition"
            )

        public static let dutch =
            Self(
                contents: "Inhoud",
                version: "Versie",
                revisionDate: "Revisiedatum",
                unresolvedSection:
                    "Onbekende sectie",
                unresolvedDefinition:
                    "Onbekende definitie"
            )
    }

    public struct Numbering:
        Sendable,
        Equatable
    {
        public let headingPrefix:
            String

        public let headingSeparator:
            String

        public let referencePrefix:
            String

        public let referenceSuffix:
            String

        public init(
            headingPrefix: String = "",
            headingSeparator: String = ". ",
            referencePrefix: String = "§ ",
            referenceSuffix: String = ""
        ) {
            self.headingPrefix =
                headingPrefix

            self.headingSeparator =
                headingSeparator

            self.referencePrefix =
                referencePrefix

            self.referenceSuffix =
                referenceSuffix
        }

        public static let sections =
            Self()

        public static let articles =
            Self(
                headingPrefix: "Artikel ",
                headingSeparator: " — ",
                referencePrefix: "Artikel "
            )

        public func headingNumber(
            _ number: Int
        ) -> String {
            "\(headingPrefix)\(number)"
        }

        public func headingLabel(
            number: Int,
            title: String
        ) -> String {
            """
            \(headingNumber(number))\
            \(headingSeparator)\
            \(title)
            """
        }

        public func referenceLabel(
            _ number: Int
        ) -> String {
            """
            \(referencePrefix)\
            \(number)\
            \(referenceSuffix)
            """
        }
    }

    public struct Definition:
        Sendable
    {
        public struct ID:
            RawRepresentable,
            Hashable,
            Sendable,
            ExpressibleByStringLiteral
        {
            public let rawValue:
                String

            public init(
                rawValue: String
            ) {
                self.rawValue =
                    rawValue
            }

            public init(
                _ rawValue: String
            ) {
                self.rawValue =
                    rawValue
            }

            public init(
                stringLiteral value: String
            ) {
                self.rawValue =
                    value
            }
        }

        public let id:
            ID

        public let term:
            String

        public let meaning:
            String

        public let details:
            @Sendable () -> HTMLFragment

        public init(
            id: ID,
            term: String,
            meaning: String
        ) {
            self.id =
                id

            self.term =
                term

            self.meaning =
                meaning

            self.details = {
                []
            }
        }

        public init(
            id: ID,
            term: String,
            meaning: String,
            @HTMLBuilder
            details:
                @escaping
                @Sendable () -> HTMLFragment
        ) {
            self.id =
                id

            self.term =
                term

            self.meaning =
                meaning

            self.details =
                details
        }
    }

    public struct Section:
        Sendable
    {
        public struct ID:
            RawRepresentable,
            Hashable,
            Sendable,
            ExpressibleByStringLiteral
        {
            public let rawValue:
                String

            public init(
                rawValue: String
            ) {
                self.rawValue =
                    rawValue
            }

            public init(
                _ rawValue: String
            ) {
                self.rawValue =
                    rawValue
            }

            public init(
                stringLiteral value: String
            ) {
                self.rawValue =
                    value
            }
        }

        public let id:
            ID

        public let title:
            String

        public let body:
            @Sendable (
                ReferenceContext
            ) -> HTMLFragment

        public init(
            id: ID,
            title: String,
            @HTMLBuilder
            body:
                @escaping
                @Sendable (
                    ReferenceContext
                ) -> HTMLFragment
        ) {
            self.id =
                id

            self.title =
                title

            self.body =
                body
        }
    }

    public struct ResolvedSection:
        Sendable,
        Equatable
    {
        public let id:
            Section.ID

        public let number:
            Int

        public let title:
            String

        public let anchorID:
            String

        public let headingNumberLabel:
            String

        public let headingSeparator:
            String

        public let headingLabel:
            String

        public let referenceLabel:
            String
    }

    public enum SectionReferenceStyle:
        Sendable,
        Equatable
    {
        case document

        case number

        case custom(
            prefix: String,
            suffix: String = ""
        )
    }

    public struct ReferenceContext:
        Sendable
    {
        private let documentID:
            LegalDocument.ID

        private let sections:
            [
                Section.ID:
                    ResolvedSection
            ]

        private let definitions:
            [Definition]

        private let definitionsByID:
            [
                Definition.ID:
                    Definition
            ]

        private let labels:
            Labels

        fileprivate init(
            documentID: LegalDocument.ID,
            sections:
                [
                    Section.ID:
                        ResolvedSection
                ],
            definitions: [Definition],
            labels: Labels
        ) {
            self.documentID =
                documentID

            self.sections =
                sections

            self.definitions =
                definitions

            self.definitionsByID =
                Dictionary(
                    uniqueKeysWithValues:
                        definitions.map {
                            (
                                $0.id,
                                $0
                            )
                        }
                )

            self.labels =
                labels
        }

        public func section(
            _ id: Section.ID,
            style:
                SectionReferenceStyle =
                    .document
        ) -> any HTMLNode {
            guard
                let section =
                    sections[
                        id
                    ]
            else {
                return unresolvedReference(
                    label:
                        labels
                            .unresolvedSection,
                    id: id.rawValue,
                    kind: "section"
                )
            }

            let label:
                String

            switch style {
            case .document:
                label =
                    section
                        .referenceLabel

            case .number:
                label =
                    "\(section.number)"

            case .custom(
                let prefix,
                let suffix
            ):
                label =
                    """
                    \(prefix)\
                    \(section.number)\
                    \(suffix)
                    """
            }

            return HTML.a(
                "#\(section.anchorID)",
                [
                    "class":
                        "\(LegalDocument.block)__section-ref",
                    "data-legal-section-ref":
                        id.rawValue,
                    "title":
                        section.title,
                ]
            ) {
                HTML.text(
                    label
                )
            }
        }

        public func definition(
            _ id: Definition.ID,
            label customLabel:
                String? = nil
        ) -> any HTMLNode {
            guard
                let definition =
                    definitionsByID[
                        id
                    ]
            else {
                return unresolvedReference(
                    label:
                        labels
                            .unresolvedDefinition,
                    id: id.rawValue,
                    kind: "definition"
                )
            }

            let anchor =
                LegalDocument
                    .definitionAnchor(
                        documentID:
                            documentID,
                        definitionID:
                            definition.id
                    )

            return HTML.span(
                [
                    "class":
                        "\(LegalDocument.block)__definition-ref-wrap"
                ]
            ) {
                HTML.a(
                    "#\(anchor)",
                    [
                        "class":
                            "\(LegalDocument.block)__definition-ref",
                        "data-legal-definition-ref":
                            definition
                                .id
                                .rawValue,
                    ]
                ) {
                    HTML.text(
                        customLabel
                            ?? definition.term
                    )
                }

                HTML.span(
                    [
                        "class":
                            "\(LegalDocument.block)__definition-preview",
                        "role":
                            "note",
                    ]
                ) {
                    HTML.strong(
                        [
                            "class":
                                "\(LegalDocument.block)__definition-preview-term"
                        ]
                    ) {
                        HTML.text(
                            definition.term
                        )
                    }

                    HTML.span(
                        [
                            "class":
                                "\(LegalDocument.block)__definition-preview-meaning"
                        ]
                    ) {
                        HTML.text(
                            definition.meaning
                        )
                    }
                }
            }
        }

        public func definitionList()
            -> any HTMLNode
        {
            HTML.el(
                "dl",
                [
                    "class":
                        "\(LegalDocument.block)__definitions"
                ]
            ) {
                for definition
                    in definitions
                {
                    let anchor =
                        LegalDocument
                            .definitionAnchor(
                                documentID:
                                    documentID,
                                definitionID:
                                    definition.id
                            )

                    HTML.div(
                        [
                            "id":
                                anchor,
                            "class":
                                "\(LegalDocument.block)__definition",
                            "data-legal-definition":
                                definition
                                    .id
                                    .rawValue,
                        ]
                    ) {
                        HTML.el(
                            "dt",
                            [
                                "class":
                                    "\(LegalDocument.block)__definition-term"
                            ]
                        ) {
                            HTML.el(
                                "dfn"
                            ) {
                                HTML.text(
                                    definition.term
                                )
                            }
                        }

                        HTML.el(
                            "dd",
                            [
                                "class":
                                    "\(LegalDocument.block)__definition-body"
                            ]
                        ) {
                            HTML.p(
                                [
                                    "class":
                                        "\(LegalDocument.block)__definition-meaning"
                                ]
                            ) {
                                HTML.text(
                                    definition
                                        .meaning
                                )
                            }

                            definition
                                .details()
                        }
                    }
                }
            }
        }

        private func unresolvedReference(
            label: String,
            id: String,
            kind: String
        ) -> any HTMLNode {
            HTML.span(
                [
                    "class":
                        "\(LegalDocument.block)__unresolved-ref",
                    "data-legal-unresolved-ref":
                        id,
                    "data-legal-unresolved-kind":
                        kind,
                ]
            ) {
                HTML.text(
                    "\(label): \(id)"
                )
            }
        }
    }

    public enum ModelError:
        Swift.Error,
        LocalizedError,
        Sendable
    {
        case emptySections

        case duplicateSectionID(
            String
        )

        case duplicateDefinitionID(
            String
        )

        public var errorDescription:
            String?
        {
            switch self {
            case .emptySections:
                return """
                A legal document requires \
                at least one section.
                """

            case .duplicateSectionID(
                let id
            ):
                return """
                Duplicate legal document \
                section id: \(id)
                """

            case .duplicateDefinitionID(
                let id
            ):
                return """
                Duplicate legal document \
                definition id: \(id)
                """
            }
        }
    }

    public let id:
        ID

    public let title:
        String

    public let lead:
        String?

    public let revision:
        Revision

    public let numbering:
        Numbering

    public let labels:
        Labels

    public let showsContents:
        Bool

    public let definitions:
        [Definition]

    public let sections:
        [Section]

    public let includeStyles:
        Bool

    public init(
        id: ID,
        title: String,
        lead: String? = nil,
        revision: Revision,
        numbering:
            Numbering = .sections,
        labels:
            Labels = .english,
        showsContents:
            Bool = true,
        definitions:
            [Definition] = [],
        sections:
            [Section],
        includeStyles:
            Bool = true
    ) throws {
        guard
            !sections.isEmpty
        else {
            throw ModelError
                .emptySections
        }

        var sectionIDs:
            Set<Section.ID> = []

        for section
            in sections
        {
            guard
                sectionIDs
                    .insert(
                        section.id
                    )
                    .inserted
            else {
                throw ModelError
                    .duplicateSectionID(
                        section
                            .id
                            .rawValue
                    )
            }
        }

        var definitionIDs:
            Set<Definition.ID> = []

        for definition
            in definitions
        {
            guard
                definitionIDs
                    .insert(
                        definition.id
                    )
                    .inserted
            else {
                throw ModelError
                    .duplicateDefinitionID(
                        definition
                            .id
                            .rawValue
                    )
            }
        }

        self.id =
            id

        self.title =
            title

        self.lead =
            lead

        self.revision =
            revision

        self.numbering =
            numbering

        self.labels =
            labels

        self.showsContents =
            showsContents

        self.definitions =
            definitions

        self.sections =
            sections

        self.includeStyles =
            includeStyles
    }

    public var resolvedSections:
        [ResolvedSection]
    {
        sections
            .enumerated()
            .map {
                offset,
                section in

                let number =
                    offset + 1

                return ResolvedSection(
                    id:
                        section.id,
                    number:
                        number,
                    title:
                        section.title,
                    anchorID:
                        Self.sectionAnchor(
                            documentID:
                                id,
                            sectionID:
                                section.id
                        ),
                    headingNumberLabel:
                        numbering
                            .headingNumber(
                                number
                            ),
                    headingSeparator:
                        numbering
                            .headingSeparator,
                    headingLabel:
                        numbering
                            .headingLabel(
                                number:
                                    number,
                                title:
                                    section.title
                            ),
                    referenceLabel:
                        numbering
                            .referenceLabel(
                                number
                            )
                )
            }
    }

    public var nodes:
        ReusableComponentNodes
    {
        let resolved =
            resolvedSections

        let context =
            ReferenceContext(
                documentID:
                    id,
                sections:
                    Dictionary(
                        uniqueKeysWithValues:
                            resolved.map {
                                (
                                    $0.id,
                                    $0
                                )
                            }
                    ),
                definitions:
                    definitions,
                labels:
                    labels
            )

        return .body(
            [
                documentNode(
                    resolved:
                        resolved,
                    context:
                        context
                )
            ],
            stylesheets:
                includeStyles
                    ? [
                        Self
                            .stylesheet()
                    ]
                    : []
        )
    }

    public static func css()
        -> CSSStyleSheet
    {
        stylesheet()
    }

    private func documentNode(
        resolved:
            [ResolvedSection],
        context:
            ReferenceContext
    ) -> any HTMLNode {
        HTML.el(
            "article",
            [
                "class":
                    Self.block,
                "data-legal-document":
                    id.rawValue,
            ]
        ) {
            headerNode()

            if showsContents {
                contentsNode(
                    resolved
                )
            }

            for (
                section,
                resolvedSection
            ) in zip(
                sections,
                resolved
            ) {
                sectionNode(
                    section,
                    resolved:
                        resolvedSection,
                    context:
                        context
                )
            }
        }
    }

    private func headerNode()
        -> any HTMLNode
    {
        HTML.header(
            [
                "class":
                    "\(Self.block)__header"
            ]
        ) {
            HTML.h1(
                [
                    "class":
                        "\(Self.block)__title"
                ]
            ) {
                HTML.text(
                    title
                )
            }

            if let lead {
                HTML.p(
                    [
                        "class":
                            "\(Self.block)__lead"
                    ]
                ) {
                    HTML.text(
                        lead
                    )
                }
            }

            HTML.el(
                "dl",
                [
                    "class":
                        "\(Self.block)__revision"
                ]
            ) {
                HTML.div(
                    [
                        "class":
                            "\(Self.block)__revision-field"
                    ]
                ) {
                    HTML.el(
                        "dt"
                    ) {
                        HTML.text(
                            labels.version
                        )
                    }

                    HTML.el(
                        "dd"
                    ) {
                        HTML.text(
                            revision
                                .versionLabel
                        )
                    }
                }

                HTML.div(
                    [
                        "class":
                            "\(Self.block)__revision-field"
                    ]
                ) {
                    HTML.el(
                        "dt"
                    ) {
                        HTML.text(
                            labels
                                .revisionDate
                        )
                    }

                    HTML.el(
                        "dd"
                    ) {
                        HTML.el(
                            "time",
                            [
                                "datetime":
                                    revision
                                        .dateValue
                            ]
                        ) {
                            HTML.text(
                                revision
                                    .dateValue
                            )
                        }
                    }
                }
            }
        }
    }

    private func contentsNode(
        _ resolved:
            [ResolvedSection]
    ) -> any HTMLNode {
        HTML.el(
            "nav",
            [
                "class":
                    "\(Self.block)__contents",
                "aria-label":
                    labels.contents,
            ]
        ) {
            HTML.h2(
                [
                    "class":
                        "\(Self.block)__contents-title"
                ]
            ) {
                HTML.text(
                    labels.contents
                )
            }

            HTML.ol(
                [
                    "class":
                        "\(Self.block)__contents-list"
                ]
            ) {
                for section
                    in resolved
                {
                    HTML.li {
                        HTML.a(
                            "#\(section.anchorID)"
                        ) {
                            HTML.text(
                                section
                                    .headingLabel
                            )
                        }
                    }
                }
            }
        }
    }

    private func sectionNode(
        _ section: Section,
        resolved:
            ResolvedSection,
        context:
            ReferenceContext
    ) -> any HTMLNode {
        HTML.section(
            [
                "id":
                    resolved.anchorID,
                "class":
                    "\(Self.block)__section",
                "data-legal-section":
                    section
                        .id
                        .rawValue,
                "data-legal-section-number":
                    "\(resolved.number)",
            ]
        ) {
            HTML.h2(
                [
                    "class":
                        "\(Self.block)__section-heading"
                ]
            ) {
                HTML.span(
                    [
                        "class":
                            "\(Self.block)__section-number"
                    ]
                ) {
                    HTML.text(
                        resolved
                            .headingNumberLabel
                    )
                }

                HTML.span(
                    [
                        "class":
                            "\(Self.block)__section-separator",
                        "aria-hidden":
                            "true",
                    ]
                ) {
                    HTML.text(
                        resolved
                            .headingSeparator
                    )
                }

                HTML.span(
                    [
                        "class":
                            "\(Self.block)__section-title"
                    ]
                ) {
                    HTML.text(
                        resolved.title
                    )
                }
            }

            HTML.div(
                [
                    "class":
                        "\(Self.block)__section-body"
                ]
            ) {
                section.body(
                    context
                )
            }
        }
    }

    private static func sectionAnchor(
        documentID: ID,
        sectionID: Section.ID
    ) -> String {
        """
        legal-\(documentID.rawValue)-section-\(sectionID.rawValue)
        """
    }

    private static func definitionAnchor(
        documentID: ID,
        definitionID:
            Definition.ID
    ) -> String {
        """
        legal-\(documentID.rawValue)-definition-\(definitionID.rawValue)
        """
    }
}
