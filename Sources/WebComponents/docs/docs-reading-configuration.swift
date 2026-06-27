public enum DocsParagraphMode: String, Sendable {
    case spaced
    case book
}

public enum DocsDropCapMode: String, Sendable {
    case none
    case first
}

public enum DocsReadingControlsMode: Sendable {
    case disabled
    case enabled
}

public enum DocsTextScale: String, Sendable {
    case small
    case normal
    case large
}

public struct DocsReadingConfiguration: Sendable {
    public let textScale: DocsTextScale
    public let paragraph: DocsParagraphMode
    public let dropCap: DocsDropCapMode
    public let controls: DocsReadingControlsMode

    public var enabled: Bool {
        switch controls {
        case .enabled:
            return true

        case .disabled:
            return paragraph == .book || dropCap != .none || textScale != .normal
        }
    }

    public init(
        textScale: DocsTextScale = .normal,
        paragraph: DocsParagraphMode = .spaced,
        dropCap: DocsDropCapMode = .none,
        controls: DocsReadingControlsMode = .disabled
    ) {
        self.textScale = textScale
        self.paragraph = paragraph
        self.dropCap = dropCap
        self.controls = controls
    }

    public static let disabled = DocsReadingConfiguration()

    public static let article = DocsReadingConfiguration(
        textScale: .normal,
        paragraph: .spaced,
        dropCap: .first,
        controls: .enabled
    )
}
