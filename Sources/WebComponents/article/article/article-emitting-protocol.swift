import Path
import HTML

public protocol ArticleEmitting: FacadeEmitting {
    // var path: StandardPath { get }
    var title: String { get }
    var definition: String { get }
    var content: @Sendable () -> HTMLFragment { get }

    func lead_and_content() -> HTMLFragment
    func article() -> HTMLFragment
    func article_data() -> ArticleItem.ReferenceResolved
}

// public protocol ArticleDefining: ArticleEmitting {
//     var article_item: ArticleItem
// }


// public enum _Test_MovationArticles: ArticleEmitting {
//     case article_one

//     var article_item:

//     var title: String { self.}
// }
