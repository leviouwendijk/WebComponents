import Foundation

extension RecommendedProductCatalog {
    public struct ProductInteraction:
        Sendable
    {
        public let detailSheetEnabled: Bool
        public let sharingEnabled: Bool
        public let queryParameter: String

        public init(
            detailSheetEnabled: Bool,
            sharingEnabled: Bool,
            queryParameter: String = "product"
        ) {
            let trimmed =
                queryParameter
                    .trimmingCharacters(
                        in: .whitespacesAndNewlines
                    )

            self.detailSheetEnabled =
                detailSheetEnabled

            self.sharingEnabled =
                sharingEnabled

            self.queryParameter =
                trimmed.isEmpty
                    ? "product"
                    : trimmed
        }

        public static let none =
            Self(
                detailSheetEnabled: false,
                sharingEnabled: false
            )

        public static func shareable(
            queryParameter: String = "product"
        ) -> Self {
            Self(
                detailSheetEnabled: false,
                sharingEnabled: true,
                queryParameter: queryParameter
            )
        }

        public static func detailSheet(
            queryParameter: String = "product",
            sharingEnabled: Bool = true
        ) -> Self {
            Self(
                detailSheetEnabled: true,
                sharingEnabled: sharingEnabled,
                queryParameter: queryParameter
            )
        }

        var isEnabled: Bool {
            detailSheetEnabled
                || sharingEnabled
        }
    }
}
