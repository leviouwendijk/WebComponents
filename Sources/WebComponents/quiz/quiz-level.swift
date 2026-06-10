public enum QuizLevel: String, Sendable, Hashable {
    case beginner
    case regular
    case intermediate
    case advanced

    public var learnerLabel: String {
        switch self {
        case .beginner:
            return "Beginner"
        case .regular:
            return "Gemiddeld"
        case .intermediate:
            return "Gevorderd"
        case .advanced:
            return "Expert"
        }
    }

    public var difficultyLabel: String {
        switch self {
        case .beginner:
            return "Makkelijk"
        case .regular:
            return "Normaal"
        case .intermediate:
            return "Moeilijk"
        case .advanced:
            return "Topniveau"
        }
    }

    public var label: String {
        "\(learnerLabel) & \(difficultyLabel)"
    }

    public var compactLabel: String {
        "\(learnerLabel) · \(difficultyLabel)"
    }

    public var rank: Int {
        switch self {
        case .beginner:
            return 0
        case .regular:
            return 1
        case .intermediate:
            return 2
        case .advanced:
            return 3
        }
    }

    // Compatibility with existing authored quiz items.
    public static let intro: QuizLevel = .beginner
    public static let middle: QuizLevel = .regular
    public static let deep: QuizLevel = .intermediate
}
