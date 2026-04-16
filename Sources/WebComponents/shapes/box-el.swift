import DSL
import HTML

public struct Box: Sendable {
    public let classes: [HTMLClassToken]
    public let attrs: HTMLAttribute
    public let align: BoxAlign
    public let content: @Sendable () -> HTMLFragment

    public init(
        classes: [HTMLClassToken] = [],
        attrs: HTMLAttribute = HTMLAttribute(),
        align: BoxAlign = .center,
        content: @escaping @Sendable () -> HTMLFragment
    ) {
        self.classes = classes
        self.attrs = attrs
        self.align = align
        self.content = content
    }
}

// public struct Box: Sendable {
//     public let classes: [String]
//     public let attrs: HTMLAttribute
//     public let align: BoxAlign
//     public let content: @Sendable () -> HTMLFragment

//     public init(
//         classes: [String] = [],
//         attrs: HTMLAttribute = HTMLAttribute(),
//         align: BoxAlign = .center,
//         content: @escaping @Sendable () -> HTMLFragment
//     ) {
//         self.classes = classes
//         self.attrs = attrs
//         self.align = align
//         self.content = content
//     }
// }

public enum BoxAlign: Sendable { 
    case center
    case start
}
