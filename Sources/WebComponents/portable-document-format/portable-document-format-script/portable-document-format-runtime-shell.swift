enum PortableDocumentFormatRuntimeShell {
    static let open = #"""
    (() => {
        if (window.PortableDocumentFormatRuntime?.initialized) return;
    """#

    static let close = #"""
    })();
    """#
}
