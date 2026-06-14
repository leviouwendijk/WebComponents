import HTML

public struct HoverPreview: Sendable {
    public enum Media: Sendable {
        case none
        case image(src: String, alt: String)
        case glyph(String)
        case custom(@Sendable () -> HTMLFragment)
    }

    public enum Variant: String, Sendable {
        case concept
        case process
        case problem
        case article
        case definition
    }

    public let eyebrow: String?
    public let title: String
    public let summary: @Sendable () -> HTMLFragment
    public let media: Media
    public let tags: [String]
    public let variant: Variant

    public init(
        eyebrow: String? = nil,
        title: String,
        summary: @escaping @Sendable () -> HTMLFragment,
        media: Media = .none,
        tags: [String] = [],
        variant: Variant = .concept
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.summary = summary
        self.media = media
        self.tags = tags
        self.variant = variant
    }
}

public protocol HoverPreviewProviding {
    var hoverable_preview: HoverPreview { get }
}
