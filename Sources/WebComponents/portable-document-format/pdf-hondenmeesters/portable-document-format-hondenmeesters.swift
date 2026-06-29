public enum HondenmeestersPortableDocumentFormat {}

public extension HondenmeestersPortableDocumentFormat {
    static func payload(
        template: PortableDocumentFormatTemplate = .worksheet_a4,
        title: String,
        subtitle: String? = nil,
        blocks: [PortableDocumentFormatBlock],
        sheet: PortableDocumentFormatSheet? = nil
    ) -> PortableDocumentFormatPayload {
        .document(
            template: template,
            theme: .hondenmeesters,
            title: title,
            subtitle: subtitle,
            blocks: blocks,
            sheet: sheet
        )
    }
}
