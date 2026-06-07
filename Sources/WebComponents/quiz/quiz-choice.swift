public struct QuizChoice: Sendable, Hashable {
    public let id: String
    public let text: String
    public let feedback: String?

    public init(
        _ id: String,
        _ text: String,
        feedback: String? = nil
    ) {
        self.id = id
        self.text = text
        self.feedback = feedback
    }
}
