import HTML

public struct PrintableReport: Sendable {
    public struct Options: Sendable {
        public let styles: Bool
        public let script: Bool

        public init(
            styles: Bool = true,
            script: Bool = true
        ) {
            self.styles = styles
            self.script = script
        }

        public static let `default` = Self()
    }

    public let id: String
    public let title: String
    public let subtitle: String?
    public let meta: [PrintableReportMeta]
    public let sections: [PrintableReportSection]
    public let actions: PrintableReportActions
    public let options: Options

    public init(
        id: String,
        title: String,
        subtitle: String? = nil,
        meta: [PrintableReportMeta] = [],
        actions: PrintableReportActions = .pdf,
        options: Options = .default,
        @PrintableReportBuilder sections: () -> [PrintableReportSection]
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.meta = meta
        self.sections = sections()
        self.actions = actions
        self.options = options
    }

    public init(
        id: String,
        title: String,
        subtitle: String? = nil,
        meta: [PrintableReportMeta] = [],
        sections: [PrintableReportSection],
        actions: PrintableReportActions = .pdf,
        options: Options = .default
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.meta = meta
        self.sections = sections
        self.actions = actions
        self.options = options
    }
}

public struct PrintableReportActions: Sendable {
    public let printLabel: String?

    public init(
        printLabel: String? = "PDF maken"
    ) {
        self.printLabel = printLabel
    }

    public static let none = Self(
        printLabel: nil
    )

    public static let pdf = Self()
}

public struct PrintableReportSlot: Sendable, Hashable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(
        _ rawValue: String
    ) {
        self.rawValue = rawValue
    }

    public init(
        stringLiteral value: String
    ) {
        self.rawValue = value
    }
}

public enum PrintableReportValue: Sendable {
    case text(String)
    case slot(PrintableReportSlot, fallback: String?)
}

public struct PrintableReportMeta: Sendable {
    public let label: String
    public let value: PrintableReportValue

    public init(
        _ label: String,
        _ value: PrintableReportValue
    ) {
        self.label = label
        self.value = value
    }

    public init(
        _ label: String,
        _ value: String
    ) {
        self.label = label
        self.value = .text(value)
    }
}

public struct PrintableReportField: Sendable {
    public let label: String
    public let value: PrintableReportValue
    public let note: String?

    public init(
        _ label: String,
        _ value: PrintableReportValue,
        note: String? = nil
    ) {
        self.label = label
        self.value = value
        self.note = note
    }

    public init(
        _ label: String,
        _ value: String,
        note: String? = nil
    ) {
        self.label = label
        self.value = .text(value)
        self.note = note
    }
}

public struct PrintableReportMetric: Sendable {
    public let label: String
    public let value: PrintableReportValue
    public let note: String?

    public init(
        _ label: String,
        _ value: PrintableReportValue,
        note: String? = nil
    ) {
        self.label = label
        self.value = value
        self.note = note
    }

    public init(
        _ label: String,
        _ value: String,
        note: String? = nil
    ) {
        self.label = label
        self.value = .text(value)
        self.note = note
    }
}

public struct PrintableReportNotice: Sendable {
    public enum Tone: String, Sendable {
        case info
        case warning
        case danger
    }

    public let title: String
    public let text: String
    public let tone: Tone

    public init(
        title: String,
        text: String,
        tone: Tone = .info
    ) {
        self.title = title
        self.text = text
        self.tone = tone
    }
}

public enum PrintableReportSection: Sendable {
    case summary(title: String?, text: String)
    case fields(title: String?, [PrintableReportField])
    case metrics(title: String?, [PrintableReportMetric])
    case notice(PrintableReportNotice)
    case notes(title: String, placeholder: String?)
    case html(HTMLFragment)
}

@resultBuilder
public enum PrintableReportBuilder {
    public static func buildBlock(
        _ parts: [PrintableReportSection]...
    ) -> [PrintableReportSection] {
        parts.flatMap { $0 }
    }

    public static func buildExpression(
        _ section: PrintableReportSection
    ) -> [PrintableReportSection] {
        [section]
    }

    public static func buildExpression(
        _ sections: [PrintableReportSection]
    ) -> [PrintableReportSection] {
        sections
    }

    public static func buildOptional(
        _ part: [PrintableReportSection]?
    ) -> [PrintableReportSection] {
        part ?? []
    }

    public static func buildEither(
        first: [PrintableReportSection]
    ) -> [PrintableReportSection] {
        first
    }

    public static func buildEither(
        second: [PrintableReportSection]
    ) -> [PrintableReportSection] {
        second
    }

    public static func buildArray(
        _ parts: [[PrintableReportSection]]
    ) -> [PrintableReportSection] {
        parts.flatMap { $0 }
    }
}

@resultBuilder
public enum PrintableReportFieldBuilder {
    public static func buildBlock(
        _ parts: [PrintableReportField]...
    ) -> [PrintableReportField] {
        parts.flatMap { $0 }
    }

    public static func buildExpression(
        _ field: PrintableReportField
    ) -> [PrintableReportField] {
        [field]
    }

    public static func buildExpression(
        _ fields: [PrintableReportField]
    ) -> [PrintableReportField] {
        fields
    }

    public static func buildOptional(
        _ part: [PrintableReportField]?
    ) -> [PrintableReportField] {
        part ?? []
    }

    public static func buildEither(
        first: [PrintableReportField]
    ) -> [PrintableReportField] {
        first
    }

    public static func buildEither(
        second: [PrintableReportField]
    ) -> [PrintableReportField] {
        second
    }

    public static func buildArray(
        _ parts: [[PrintableReportField]]
    ) -> [PrintableReportField] {
        parts.flatMap { $0 }
    }
}

@resultBuilder
public enum PrintableReportMetricBuilder {
    public static func buildBlock(
        _ parts: [PrintableReportMetric]...
    ) -> [PrintableReportMetric] {
        parts.flatMap { $0 }
    }

    public static func buildExpression(
        _ metric: PrintableReportMetric
    ) -> [PrintableReportMetric] {
        [metric]
    }

    public static func buildExpression(
        _ metrics: [PrintableReportMetric]
    ) -> [PrintableReportMetric] {
        metrics
    }

    public static func buildOptional(
        _ part: [PrintableReportMetric]?
    ) -> [PrintableReportMetric] {
        part ?? []
    }

    public static func buildEither(
        first: [PrintableReportMetric]
    ) -> [PrintableReportMetric] {
        first
    }

    public static func buildEither(
        second: [PrintableReportMetric]
    ) -> [PrintableReportMetric] {
        second
    }

    public static func buildArray(
        _ parts: [[PrintableReportMetric]]
    ) -> [PrintableReportMetric] {
        parts.flatMap { $0 }
    }
}

public func report(
    id: String,
    title: String,
    subtitle: String? = nil,
    meta: [PrintableReportMeta] = [],
    actions: PrintableReportActions = .pdf,
    options: PrintableReport.Options = .default,
    @PrintableReportBuilder sections: () -> [PrintableReportSection]
) -> PrintableReport {
    PrintableReport(
        id: id,
        title: title,
        subtitle: subtitle,
        meta: meta,
        actions: actions,
        options: options,
        sections: sections
    )
}

public func meta(
    _ label: String,
    _ value: String
) -> PrintableReportMeta {
    PrintableReportMeta(
        label,
        value
    )
}

public func meta(
    _ label: String,
    _ value: PrintableReportValue
) -> PrintableReportMeta {
    PrintableReportMeta(
        label,
        value
    )
}

public func value(
    _ text: String
) -> PrintableReportValue {
    .text(text)
}

public func slot(
    _ key: PrintableReportSlot,
    fallback: String? = nil
) -> PrintableReportValue {
    .slot(
        key,
        fallback: fallback
    )
}

public func summary(
    _ text: String,
    title: String? = nil
) -> PrintableReportSection {
    .summary(
        title: title,
        text: text
    )
}

public func fields(
    _ title: String? = nil,
    @PrintableReportFieldBuilder _ fields: () -> [PrintableReportField]
) -> PrintableReportSection {
    .fields(
        title: title,
        fields()
    )
}

public func field(
    _ label: String,
    _ value: String,
    note: String? = nil
) -> PrintableReportField {
    PrintableReportField(
        label,
        value,
        note: note
    )
}

public func field(
    _ label: String,
    _ value: PrintableReportValue,
    note: String? = nil
) -> PrintableReportField {
    PrintableReportField(
        label,
        value,
        note: note
    )
}

public func metrics(
    _ title: String? = nil,
    @PrintableReportMetricBuilder _ metrics: () -> [PrintableReportMetric]
) -> PrintableReportSection {
    .metrics(
        title: title,
        metrics()
    )
}

public func metric(
    _ label: String,
    _ value: String,
    note: String? = nil
) -> PrintableReportMetric {
    PrintableReportMetric(
        label,
        value,
        note: note
    )
}

public func metric(
    _ label: String,
    _ value: PrintableReportValue,
    note: String? = nil
) -> PrintableReportMetric {
    PrintableReportMetric(
        label,
        value,
        note: note
    )
}

public func notice(
    _ title: String,
    _ text: String,
    tone: PrintableReportNotice.Tone = .info
) -> PrintableReportSection {
    .notice(
        PrintableReportNotice(
            title: title,
            text: text,
            tone: tone
        )
    )
}

public func notes(
    _ title: String = "Notities",
    placeholder: String? = nil
) -> PrintableReportSection {
    .notes(
        title: title,
        placeholder: placeholder
    )
}

public func html(
    @HTMLBuilder _ nodes: () -> HTMLFragment
) -> PrintableReportSection {
    .html(
        nodes()
    )
}
