import Path

public protocol FacadeRendering: Sendable, Codable {
    var title: String { get }
    var definition: String { get }
    var thumbnail_src: StandardPath? { get }
}
