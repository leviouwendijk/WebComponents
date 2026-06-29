import Foundation

public enum PortableDocumentFormatTemplate: String, Sendable, Codable {
    case plain_a4
    case worksheet_a4
    case field_sheet_a4
}

public enum PortableDocumentFormatTheme: String, Sendable, Codable {
    case standard
    case hondenmeesters
}

public enum PortableDocumentFormatBlockKind: String, Sendable, Codable {
    case heading
    case paragraph
    case checklist
    case callout
    case rule
    case spacer
}

public struct PortableDocumentFormatPayload: Sendable, Codable {
    public let template: PortableDocumentFormatTemplate
    public let theme: PortableDocumentFormatTheme
    public let title: String
    public let subtitle: String?
    public let blocks: [PortableDocumentFormatBlock]
    public let sheet: PortableDocumentFormatSheet?

    public init(
        template: PortableDocumentFormatTemplate = .plain_a4,
        theme: PortableDocumentFormatTheme = .standard,
        title: String,
        subtitle: String? = nil,
        blocks: [PortableDocumentFormatBlock],
        sheet: PortableDocumentFormatSheet? = nil
    ) {
        self.template = template
        self.theme = theme
        self.title = title
        self.subtitle = subtitle
        self.blocks = blocks
        self.sheet = sheet
    }
}

public struct PortableDocumentFormatSheet: Sendable, Codable {
    public let kicker: String?
    public let lead: String?
    public let fields: [PortableDocumentFormatField]

    public init(
        kicker: String? = nil,
        lead: String? = nil,
        fields: [PortableDocumentFormatField]
    ) {
        self.kicker = kicker
        self.lead = lead
        self.fields = fields
    }
}

public struct PortableDocumentFormatField: Sendable, Codable {
    public let title: String
    public let lines: Int

    public init(
        title: String,
        lines: Int = 3
    ) {
        self.title = title
        self.lines = max(lines, 1)
    }
}

public struct PortableDocumentFormatBlock: Sendable, Codable {
    public let kind: PortableDocumentFormatBlockKind
    public let text: String?
    public let title: String?
    public let level: Int?
    public let items: [String]?
    public let amount: Double?

    public init(
        kind: PortableDocumentFormatBlockKind,
        text: String? = nil,
        title: String? = nil,
        level: Int? = nil,
        items: [String]? = nil,
        amount: Double? = nil
    ) {
        self.kind = kind
        self.text = text
        self.title = title
        self.level = level
        self.items = items
        self.amount = amount
    }

    public static func heading(
        _ text: String,
        level: Int = 1
    ) -> Self {
        .init(
            kind: .heading,
            text: text,
            level: level
        )
    }

    public static func paragraph(
        _ text: String
    ) -> Self {
        .init(
            kind: .paragraph,
            text: text
        )
    }

    public static func checklist(
        _ items: [String]
    ) -> Self {
        .init(
            kind: .checklist,
            items: items
        )
    }

    public static func callout(
        title: String? = nil,
        text: String
    ) -> Self {
        .init(
            kind: .callout,
            text: text,
            title: title
        )
    }

    public static func rule() -> Self {
        .init(kind: .rule)
    }

    public static func spacer(
        _ amount: Double = 12
    ) -> Self {
        .init(
            kind: .spacer,
            amount: amount
        )
    }
}

public extension PortableDocumentFormatPayload {
    static func document(
        template: PortableDocumentFormatTemplate = .plain_a4,
        theme: PortableDocumentFormatTheme = .standard,
        title: String,
        subtitle: String? = nil,
        blocks: [PortableDocumentFormatBlock],
        sheet: PortableDocumentFormatSheet? = nil
    ) -> Self {
        .init(
            template: template,
            theme: theme,
            title: title,
            subtitle: subtitle,
            blocks: blocks,
            sheet: sheet
        )
    }
}
