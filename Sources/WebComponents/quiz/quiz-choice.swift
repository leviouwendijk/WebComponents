public struct QuizChoice: Sendable, Hashable {
    public let id: String
    public let text: String
    public let note: String?

    public init(
        _ id: String,
        _ text: String,
        note: String? = nil
    ) {
        self.id = id
        self.text = text
        self.note = note
    }
}

