import HTML

public struct Arrow: Sendable {
    public let classes: [String]
    public let attrs: HTMLAttribute
    public let label: String?

    public init(
        classes: [String] = [],
        attrs: HTMLAttribute = HTMLAttribute(),
        label: String? = nil
    ) {
        self.classes = classes
        self.attrs = attrs
        self.label = label
    }
}
