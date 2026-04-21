import Foundation
import Constructors
import HTML

public struct GoogleTagManager: ReusableComponent {
    public let id: String
    public let dataLayerName: String
    public let includeConsentDefaults: Bool
    public let headComment: String?
    public let bodyComment: String?

    public init(
        id: String,
        dataLayerName: String = "dataLayer",
        includeConsentDefaults: Bool = true,
        headComment: String? = "Analytics / Consent / Tagging",
        bodyComment: String? = "Google Tag Manager (noscript)"
    ) {
        self.id = id
        self.dataLayerName = dataLayerName
        self.includeConsentDefaults = includeConsentDefaults
        self.headComment = headComment
        self.bodyComment = bodyComment
    }

    public var nodes: ReusableComponentNodes {
        let trimmedID = id.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLayer = dataLayerName.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedID.isEmpty else {
            return .init()
        }

        let layer = trimmedLayer.isEmpty ? "dataLayer" : trimmedLayer
        let escapedLayer = layer.replacingOccurrences(of: "'", with: "\\'")
        let escapedID = trimmedID.replacingOccurrences(of: "'", with: "\\'")

        var head: HTMLFragment = []

        if let headComment, !headComment.isEmpty {
            head.append(
                HTML.comment(headComment)
            )
        }

        if includeConsentDefaults {
            head.append(
                HTML.scriptInline(#"""
                window.dataLayer = window.dataLayer || [];
                function gtag(){ dataLayer.push(arguments); }

                gtag(
                    'consent',
                    'default',
                    {
                        ad_storage: 'denied',
                        analytics_storage: 'denied',
                        ad_user_data: 'denied',
                        ad_personalization: 'denied'
                    }
                );

                gtag(
                    'event',
                    'consent_default_set',
                    {
                        ad_storage: 'denied',
                        analytics_storage: 'denied'
                    }
                );
                """#)
            )
        } else {
            head.append(
                HTML.scriptInline(
                    "window.\(layer) = window.\(layer) || [];"
                )
            )
        }

        head.append(
            HTML.scriptInline("""
            (function(w, d, s, l, i) {
                w[l] = w[l] || [];
                w[l].push({
                    'gtm.start': new Date().getTime(),
                    'event': 'gtm.js'
                });
                var f = d.getElementsByTagName(s)[0];
                var j = d.createElement(s);
                var dl = l != 'dataLayer' ? '&l=' + l : '';
                j.async = true;
                j.src = 'https://www.googletagmanager.com/gtm.js?id=' + i + dl;
                f.parentNode.insertBefore(j, f);
            })(window, document, 'script', '\(escapedLayer)', '\(escapedID)');
            """)
        )

        let body = GoogleTagManagerNoScript(
            id: trimmedID,
            comment: bodyComment
        ).nodes.body

        return .init(
            head: head,
            body: body
        )
    }
}
