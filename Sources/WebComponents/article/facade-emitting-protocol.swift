import Path

public protocol FacadeEmitting: Sendable {
    var title: String { get }
    var definition: String { get }
    var thumbnail_src: StandardPath? { get }
}
