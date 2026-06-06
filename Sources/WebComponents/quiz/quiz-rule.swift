public enum QuizRule: Sendable, Hashable {
    case one(String)
    case many(Set<String>)
    case text([String])

    public var mode: String {
        switch self {
        case .one:
            return "one"
        case .many:
            return "many"
        case .text:
            return "text"
        }
    }

    public var ids: Set<String> {
        switch self {
        case .one(let id):
            return [id]
        case .many(let ids):
            return ids
        case .text:
            return []
        }
    }

    public var accepted: [String] {
        switch self {
        case .text(let values):
            return values
        case .one,
             .many:
            return []
        }
    }
}
