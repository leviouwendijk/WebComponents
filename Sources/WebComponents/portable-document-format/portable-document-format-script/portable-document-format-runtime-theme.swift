enum PortableDocumentFormatRuntimeTheme {
    static let source = #"""
        const A4 = {
            width: 595.28,
            height: 841.89
        };

        const themes = {
            standard: {
                page: A4,
                margin: 54,
                headerHeight: 0,
                footerHeight: 34,
                logoSize: 24,
                titleSize: 21,
                subtitleSize: 11,
                headingSize: 13.5,
                bodySize: 10.5,
                smallSize: 8.5,
                lineHeight: 13.5,
                gap: 6
            },
            hondenmeesters: {
                page: A4,
                margin: 52,
                headerHeight: 46,
                footerHeight: 34,
                logoSize: 24,
                titleSize: 20,
                subtitleSize: 11,
                headingSize: 13,
                bodySize: 10.5,
                smallSize: 8.5,
                lineHeight: 13.5,
                gap: 6
            }
        };

        const styles = {
            standard: {
                cornerRadius: 8,
                borderGray: 0.82,
                ruleGray: 0.84,
                softGray: 0.975,
                calloutGray: 0.955,
                textGray: 0,
                mutedGray: 0.42,
                footerGray: 0.55
            },
            hondenmeesters: {
                cornerRadius: 8,
                borderGray: 0.82,
                ruleGray: 0.84,
                softGray: 0.975,
                calloutGray: 0.955,
                textGray: 0,
                mutedGray: 0.42,
                footerGray: 0.55
            }
        };
    """#
}
