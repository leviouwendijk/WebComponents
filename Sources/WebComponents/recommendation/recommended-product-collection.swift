public struct RecommendedProductCollection:
    Sendable
{
    public struct Entry:
        Sendable
    {
        public let product: RecommendedProduct
        public let note: String?
        public let priority: Int
        public let categoryID: String?

        public init(
            product: RecommendedProduct,
            note: String? = nil,
            priority: Int = 0,
            categoryID: String? = nil
        ) {
            self.product = product
            self.note = note
            self.priority = priority
            self.categoryID = categoryID
        }
    }

    public let id: String
    public let title: String
    public let summary: String?
    public let entries: [Entry]

    public init(
        id: String,
        title: String,
        summary: String? = nil,
        entries: [Entry]
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.entries = entries
    }

    public var sortedEntries: [Entry] {
        entries.sorted {
            if $0.priority == $1.priority {
                return $0.product.name
                    .localizedCaseInsensitiveCompare(
                        $1.product.name
                    ) == .orderedAscending
            }

            return $0.priority > $1.priority
        }
    }
}
