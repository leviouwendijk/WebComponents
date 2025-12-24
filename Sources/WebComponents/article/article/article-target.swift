// import Constructors
// import HTML
// import Path
// import Primitives

// public struct ArticleTarget: Targetable, MetadataTargetable {
//     public let article_item: ArticleItem

//     // Derived render function
//     public let html: @Sendable () -> HTMLDocument

//     public let output: StandardPath
//     public let visibility: Set<BuildEnvironment>
//     public let navigation: NavigationSetting

//     public let metadata: TargetMetadata

//     public init(
//         article_item: ArticleItem,
//         article_html_provider: @Sendable @escaping (ArticleItem) -> HTMLDocument,
//         output: StandardPath,
//         visibility: Set<BuildEnvironment> = [.local, .test, .public],
//         navigation: NavigationSetting = .none,
//         metadata: TargetMetadata? = nil
//     ) {
//         self.article_item = article_item
//         self.html = { article_html_provider(article_item) }
//         self.output = output
//         self.visibility = visibility
//         self.navigation = navigation
//         self.metadata =
//             metadata.exists_or_inits(visibility: visibility)
//     }

//     public func document() -> HTMLDocument {
//         html()
//     }
// }
