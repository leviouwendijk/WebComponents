import Constructors
import HTML

public extension HondenmeestersPortableDocumentFormat {
    struct Worksheet: ReusableComponent, Sendable {
        public let id: String
        public let label: String
        public let filename: String
        public let title: String
        public let subtitle: String?
        public let blocks: [PortableDocumentFormatBlock]
        public let includeStyles: Bool
        public let includeScript: Bool

        public init(
            id: String,
            label: String = "Download werkblad",
            filename: String,
            title: String,
            subtitle: String? = nil,
            blocks: [PortableDocumentFormatBlock],
            includeStyles: Bool = true,
            includeScript: Bool = true
        ) {
            self.id = id
            self.label = label
            self.filename = filename
            self.title = title
            self.subtitle = subtitle
            self.blocks = blocks
            self.includeStyles = includeStyles
            self.includeScript = includeScript
        }

        public var nodes: ReusableComponentNodes {
            PortableDocumentFormatExport(
                id: id,
                label: label,
                filename: filename,
                payload: payload,
                includeStyles: includeStyles,
                includeScript: includeScript
            ).nodes
        }

        public func node() -> any HTMLNode {
            nodes.body[0]
        }

        private var payload: PortableDocumentFormatPayload {
            HondenmeestersPortableDocumentFormat.payload(
                template: .worksheet_a4,
                title: title,
                subtitle: subtitle,
                blocks: blocks
            )
        }
    }
}
