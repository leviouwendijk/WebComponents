import HTML

extension ArticleItem {
    public struct ReferenceResolved: Sendable {
        public let body: HTMLFragment
        public let references: [Reference]
        public let footnotes: [FootnoteReference]

        public var hasBackmatter: Bool {
            !references.isEmpty || !footnotes.isEmpty
        }

        public init(
            body: HTMLFragment,
            references: [Reference],
            footnotes: [FootnoteReference] = []
        ) {
            self.body = body
            self.references = references
            self.footnotes = footnotes
        }
    }
}
