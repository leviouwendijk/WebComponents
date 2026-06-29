import Assets

public enum HondenmeestersPortableDocumentFormat {}

public extension HondenmeestersPortableDocumentFormat {
    static let logo = PortableDocumentFormatImage.rgb8(
        HondenmeestersAssets.h_logomark,
        width: 192,
        height: 192
        // width: 64,
        // height: 64
    )

    static let layout = PortableDocumentFormatLayout(
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
    )

    static let style = PortableDocumentFormatStyle(
        cornerRadius: 8,
        borderGray: 0.82,
        ruleGray: 0.84,
        softGray: 0.975,
        calloutGray: 0.955,
        textGray: 0,
        mutedGray: 0.42,
        footerGray: 0.55
    )

    static var chrome: PortableDocumentFormatChrome {
        .init(
            logo: logo,
            headerText: "Hondenmeesters",
            footerItems: [
                "hondenmeesters.nl",
                "docs.hondenmeesters.nl"
            ]
        )
    }

    static func payload(
        template: PortableDocumentFormatTemplate = .worksheet_a4,
        title: String,
        subtitle: String? = nil,
        blocks: [PortableDocumentFormatBlock],
        sheet: PortableDocumentFormatSheet? = nil,
        layout: PortableDocumentFormatLayout? = Self.layout,
        style: PortableDocumentFormatStyle? = Self.style,
        chrome: PortableDocumentFormatChrome? = Self.chrome
    ) -> PortableDocumentFormatPayload {
        .document(
            template: template,
            theme: .hondenmeesters,
            title: title,
            subtitle: subtitle,
            blocks: blocks,
            sheet: sheet,
            layout: layout,
            style: style,
            chrome: chrome
        )
    }
}
