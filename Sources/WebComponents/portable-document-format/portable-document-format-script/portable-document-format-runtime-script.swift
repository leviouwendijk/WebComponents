import Constructors
import JS

public struct PortableDocumentFormatRuntimeScript: ReusableComponent {
    public init() {}

    public var nodes: ReusableComponentNodes {
        .init(
            scripts: [
                JSSource(PortableDocumentFormatRuntimeSource.source).as_inline_script()
            ]
        )
    }
}
