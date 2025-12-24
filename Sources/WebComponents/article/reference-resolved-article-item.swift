import HTML

extension ArticleItem {
    public struct ReferenceResolved: Sendable {
        public let body: HTMLFragment
        public let references: [Reference]

        public init(
            body: HTMLFragment,
            references: [Reference]
        ) {
            self.body = body
            self.references = references
        }
    }
}
