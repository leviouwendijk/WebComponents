public struct QuizItem: Sendable, Hashable {
    public let id: String
    public let slug: String
    public let title: String
    public let prompt: String
    public let group: String
    public let level: QuizLevel
    public let choices: [QuizChoice]
    public let rule: QuizRule
    public let explanation: String
    public let href: String

    public init(
        id: String,
        slug: String,
        title: String,
        prompt: String,
        group: String,
        level: QuizLevel = .intro,
        choices: [QuizChoice] = [],
        rule: QuizRule,
        explanation: String,
        href: String
    ) {
        self.id = id
        self.slug = slug
        self.title = title
        self.prompt = prompt
        self.group = group
        self.level = level
        self.choices = choices
        self.rule = rule
        self.explanation = explanation
        self.href = href
    }
}
