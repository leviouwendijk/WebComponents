import Constructors
import JS

public struct QuizScript: ReusableComponent {
    public init() {}

    public var nodes: ReusableComponentNodes {
        .init(
            scripts: [
                JSSource(Self.Source.source).as_inline_script()
            ]
        )
    }
}

extension QuizScript {
    enum Source {
        static let source = [
            shell,
            state,
            progress,
            input,
            timer,
            checking,
            rendering,
            navigation,
            dashboard,
            events,
            boot
        ].joined(separator: "\n\n")
    }
}
