import Foundation

public struct RecommendedProductCollection:
    Sendable
{
    public struct Category:
        Sendable
    {
        public let id: String
        public let title: String
        public let summary: String?
        public let disclosure:
            RecommendedProductCatalog.Disclosure

        public init(
            id: String,
            title: String,
            summary: String? = nil,
            disclosure:
                RecommendedProductCatalog.Disclosure = .expanded
        ) {
            self.id = id
            self.title = title
            self.summary = summary
            self.disclosure = disclosure
        }
    }

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

        fileprivate var resolvedProduct:
            RecommendedProduct
        {
            guard let note,
                  !note.isEmpty
            else {
                return product
            }

            return RecommendedProduct(
                id: product.id,
                name: product.name,
                brand: product.brand,
                summary: product.summary,
                recommendation:
                    product.recommendation,
                experience:
                    product.experience,
                rating:
                    product.rating,
                images:
                    product.images,
                links: product.links,
                specification:
                    product.specification,
                suitableFor:
                    product.suitableFor,
                unsuitableFor:
                    product.unsuitableFor,
                notes:
                    product.notes + [note]
            )
        }
    }

    public let id: String
    public let title: String
    public let summary: String?
    public let categories: [Category]
    public let entries: [Entry]

    public init(
        id: String,
        title: String,
        summary: String? = nil,
        categories: [Category] = [],
        entries: [Entry]
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.categories = categories
        self.entries = entries
    }

    public var sortedEntries: [Entry] {
        entries.sorted {
            if $0.priority == $1.priority {
                return $0
                    .product
                    .name
                    .localizedCaseInsensitiveCompare(
                        $1.product.name
                    ) == .orderedAscending
            }

            return $0.priority > $1.priority
        }
    }

    public func catalog(
        id catalogID: String? = nil,
        specificationLimit: Int? = nil,
        presentation:
            RecommendedProductCatalog.Presentation =
                .switchable(
                    default: .compact
                ),
        productInteraction:
            RecommendedProductCatalog.ProductInteraction =
                .none,
        includeNavigation: Bool = true,
        includeStyles: Bool = true
    ) -> RecommendedProductCatalog {
        let resolvedCategories: [Category]

        if categories.isEmpty {
            resolvedCategories = [
                Category(
                    id: "\(id)-selectie",
                    title: title,
                    summary: summary
                )
            ]
        } else {
            resolvedCategories = categories
        }

        let defaultCategoryID =
            resolvedCategories.first?.id

        let catalogCategories =
            resolvedCategories.compactMap {
                category
                    -> RecommendedProductCatalog.Category?
                in

                let products = sortedEntries
                    .filter {
                        (
                            $0.categoryID
                                ?? defaultCategoryID
                        ) == category.id
                    }
                    .map(
                        \.resolvedProduct
                    )

                guard !products.isEmpty else {
                    return nil
                }

                return RecommendedProductCatalog.Category(
                    id: category.id,
                    title: category.title,
                    summary: category.summary,
                    products: products,
                    disclosure:
                        category.disclosure
                )
            }

        return RecommendedProductCatalog(
            id: catalogID ?? id,
            title: title,
            intro: summary,
            categories: catalogCategories,
            specificationLimit:
                specificationLimit,
            presentation: presentation,
            productInteraction:
                productInteraction,
            includeNavigation:
                includeNavigation,
            includeStyles:
                includeStyles
        )
    }
}
