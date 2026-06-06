public struct QuizSet: Sendable, Hashable {
    public let id: String
    public let title: String
    public let lead: String
    public let items: [QuizItem]

    public init(
        id: String,
        title: String,
        lead: String,
        items: [QuizItem]
    ) {
        self.id = id
        self.title = title
        self.lead = lead
        self.items = items
    }

    public func item(
        _ id: String
    ) -> QuizItem? {
        items.first { $0.id == id }
    }

    public func prev(
        _ id: String
    ) -> QuizItem? {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            return nil
        }

        guard index > 0 else {
            return nil
        }

        return items[index - 1]
    }

    public func next(
        _ id: String
    ) -> QuizItem? {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            return nil
        }

        let nextIndex = index + 1

        guard items.indices.contains(nextIndex) else {
            return nil
        }

        return items[nextIndex]
    }
}
