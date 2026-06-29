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

public enum PortableDocumentFormatImageEncoding: String, Sendable, Codable {
    case rgb8
}

public struct PortableDocumentFormatPayload: Sendable, Codable {
    public let template: PortableDocumentFormatTemplate
    public let theme: PortableDocumentFormatTheme
    public let title: String
    public let subtitle: String?
    public let blocks: [PortableDocumentFormatBlock]
    public let sheet: PortableDocumentFormatSheet?
    public let layout: PortableDocumentFormatLayout?
    public let style: PortableDocumentFormatStyle?
    public let chrome: PortableDocumentFormatChrome?

    public init(
        template: PortableDocumentFormatTemplate = .plain_a4,
        theme: PortableDocumentFormatTheme = .standard,
        title: String,
        subtitle: String? = nil,
        blocks: [PortableDocumentFormatBlock],
        sheet: PortableDocumentFormatSheet? = nil,
        layout: PortableDocumentFormatLayout? = nil,
        style: PortableDocumentFormatStyle? = nil,
        chrome: PortableDocumentFormatChrome? = nil
    ) {
        self.template = template
        self.theme = theme
        self.title = title
        self.subtitle = subtitle
        self.blocks = blocks
        self.sheet = sheet
        self.layout = layout
        self.style = style
        self.chrome = chrome
    }
}

public struct PortableDocumentFormatLayout: Sendable, Codable {
    public let margin: Double?
    public let headerHeight: Double?
    public let footerHeight: Double?
    public let logoSize: Double?
    public let titleSize: Double?
    public let subtitleSize: Double?
    public let headingSize: Double?
    public let bodySize: Double?
    public let smallSize: Double?
    public let lineHeight: Double?
    public let gap: Double?

    public init(
        margin: Double? = nil,
        headerHeight: Double? = nil,
        footerHeight: Double? = nil,
        logoSize: Double? = nil,
        titleSize: Double? = nil,
        subtitleSize: Double? = nil,
        headingSize: Double? = nil,
        bodySize: Double? = nil,
        smallSize: Double? = nil,
        lineHeight: Double? = nil,
        gap: Double? = nil
    ) {
        self.margin = margin
        self.headerHeight = headerHeight
        self.footerHeight = footerHeight
        self.logoSize = logoSize
        self.titleSize = titleSize
        self.subtitleSize = subtitleSize
        self.headingSize = headingSize
        self.bodySize = bodySize
        self.smallSize = smallSize
        self.lineHeight = lineHeight
        self.gap = gap
    }
}

public struct PortableDocumentFormatStyle: Sendable, Codable {
    public let cornerRadius: Double?
    public let borderGray: Double?
    public let ruleGray: Double?
    public let softGray: Double?
    public let calloutGray: Double?
    public let textGray: Double?
    public let mutedGray: Double?
    public let footerGray: Double?

    public init(
        cornerRadius: Double? = nil,
        borderGray: Double? = nil,
        ruleGray: Double? = nil,
        softGray: Double? = nil,
        calloutGray: Double? = nil,
        textGray: Double? = nil,
        mutedGray: Double? = nil,
        footerGray: Double? = nil
    ) {
        self.cornerRadius = cornerRadius
        self.borderGray = borderGray
        self.ruleGray = ruleGray
        self.softGray = softGray
        self.calloutGray = calloutGray
        self.textGray = textGray
        self.mutedGray = mutedGray
        self.footerGray = footerGray
    }
}

public struct PortableDocumentFormatChrome: Sendable, Codable {
    public let logo: PortableDocumentFormatImage?
    public let headerText: String?
    public let footerItems: [String]

    public init(
        logo: PortableDocumentFormatImage? = nil,
        headerText: String? = nil,
        footerItems: [String] = []
    ) {
        self.logo = logo
        self.headerText = headerText
        self.footerItems = footerItems
    }
}

public struct PortableDocumentFormatImage: Sendable, Codable {
    public let encoding: PortableDocumentFormatImageEncoding
    public let width: Int
    public let height: Int
    public let base64: String

    public init(
        encoding: PortableDocumentFormatImageEncoding,
        width: Int,
        height: Int,
        base64: String
    ) {
        self.encoding = encoding
        self.width = max(width, 1)
        self.height = max(height, 1)
        self.base64 = base64
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
        sheet: PortableDocumentFormatSheet? = nil,
        layout: PortableDocumentFormatLayout? = nil,
        style: PortableDocumentFormatStyle? = nil,
        chrome: PortableDocumentFormatChrome? = nil
    ) -> Self {
        .init(
            template: template,
            theme: theme,
            title: title,
            subtitle: subtitle,
            blocks: blocks,
            sheet: sheet,
            layout: layout,
            style: style,
            chrome: chrome
        )
    }
}
