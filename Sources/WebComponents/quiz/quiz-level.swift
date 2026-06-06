public enum QuizLevel: String, Sendable, Hashable {
    case intro
    case middle
    case deep

    public var label: String {
        switch self {
        case .intro:
            return "Introductie"
        case .middle:
            return "Verdieping"
        case .deep:
            return "Gevorderd"
        }
    }
}
