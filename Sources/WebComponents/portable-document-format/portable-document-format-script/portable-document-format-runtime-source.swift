enum PortableDocumentFormatRuntimeSource {
    static let source = [
        PortableDocumentFormatRuntimeShell.open,
        PortableDocumentFormatRuntimeTheme.source,
        PortableDocumentFormatRuntimeCore.source,
        PortableDocumentFormatRuntimeDocument.source,
        PortableDocumentFormatRuntimePage.source,
        PortableDocumentFormatRuntimeTypography.source,
        PortableDocumentFormatRuntimeLayout.source,
        PortableDocumentFormatRuntimeLayoutGrayscale.source,
        PortableDocumentFormatRuntimeAPI.source,
        PortableDocumentFormatRuntimeShell.close
    ].joined(separator: "\n\n")
}
