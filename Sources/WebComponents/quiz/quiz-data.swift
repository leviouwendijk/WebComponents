internal struct QuizData: Encodable {
    let id: String
    let title: String
    let lead: String
    let items: [Item]

    init(
        _ set: QuizSet
    ) {
        self.id = set.id
        self.title = set.title
        self.lead = set.lead
        self.items = set.items.map(Item.init)
    }

    struct Item: Encodable {
        let id: String
        let slug: String
        let title: String
        let prompt: String
        let group: String
        let level: String
        let levelLabel: String
        let choices: [Choice]
        let rule: Rule
        let explanation: String

        init(
            _ item: QuizItem
        ) {
            self.id = item.id
            self.slug = item.slug
            self.title = item.title
            self.prompt = item.prompt
            self.group = item.group
            self.level = item.level.rawValue
            self.levelLabel = item.level.label
            self.choices = item.choices.map(Choice.init)
            self.rule = Rule(item.rule)
            self.explanation = item.explanation
        }
    }

    struct Choice: Encodable {
        let id: String
        let text: String
        let note: String?

        init(
            _ choice: QuizChoice
        ) {
            self.id = choice.id
            self.text = choice.text
            self.note = choice.note
        }
    }

    struct Rule: Encodable {
        let mode: String
        let ids: [String]
        let accepted: [String]

        init(
            _ rule: QuizRule
        ) {
            self.mode = rule.mode
            self.ids = rule.ids.sorted()
            self.accepted = rule.accepted
        }
    }
}
