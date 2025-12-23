import Path
import HTML

public protocol ArticleEmitting: FacadeEmitting {
    var path: StandardPath { get }

    var title: String { get }
    var definition: String { get }

    var content: @Sendable () -> HTMLFragment { get }
}
