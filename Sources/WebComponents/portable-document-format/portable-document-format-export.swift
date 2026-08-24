import Constructors
import CSS
import HTML
import Foundation

public struct PortableDocumentFormatExport:
    ComponentOutputProviding,
    ReusableComponent,
    Sendable
{
    public static let block =
        "wc-portable-document-format-export"

    private static let styleIdentifier:
        CSSContributionIdentifier =
            "webcomponents.portable-document-format.export.styles"

    public let id: String
    public let label: String
    public let filename: String
    public let payload:
        PortableDocumentFormatPayload

    public init(
        id: String,
        label: String = "Download PDF",
        filename: String,
        payload:
            PortableDocumentFormatPayload
    ) {
        self.id =
            id

        self.label =
            label

        self.filename =
            filename

        self.payload =
            payload
    }

    public var output:
        ComponentOutput
    {
        let runtime =
            PortableDocumentFormatRuntimeScript()
                .output

        return
            ComponentOutput(
                content:
                    ComponentContent(
                        body: [
                            root()
                        ]
                    ),
                dependencies:
                    ComponentDependencies(
                        styles:
                            CSSContributions(
                                [
                                    Self
                                        .styleContribution()
                                ]
                            ),
                        scripts:
                            runtime
                                .dependencies
                                .scripts
                    )
            )
    }

    public var nodes:
        ReusableComponentNodes
    {
        let semantic =
            output

        return
            .body(
                semantic
                    .content
                    .body,
                stylesheets:
                    semantic
                        .dependencies
                        .styles
                        .contributions
                        .map {
                            $0
                                .content
                                .sheet
                        },
                scripts:
                    semantic
                        .dependencies
                        .scripts
                        .contributions
                        .map(
                            \.script
                        )
            )
    }

    public func node()
        -> any HTMLNode
    {
        output
            .content
            .body[
                0
            ]
    }
}

extension PortableDocumentFormatExport {
    private func root()
        -> any HTMLNode
    {
        HTML.div(
            [
                "class":
                    Self.block,
                "data-portable-document-format":
                    id
            ]
        ) {
            HTML.button(
                [
                    "type":
                        "button",
                    "class":
                        "\(Self.block)__button",
                    "data-portable-document-format-export":
                        id,
                    "data-portable-document-format-filename":
                        filename
                ]
            ) {
                HTML.text(
                    label
                )
            }

            HTML.el(
                "script",
                [
                    "type":
                        "application/json",
                    "data-portable-document-format-payload":
                        id
                ]
            ) {
                HTML.raw(
                    Self.json(
                        payload
                    )
                )
            }
        }
    }

    private static func json(
        _ payload:
            PortableDocumentFormatPayload
    ) -> String {
        let encoder =
            JSONEncoder()

        encoder.outputFormatting =
            [
                .sortedKeys
            ]

        let data =
            try! encoder.encode(
                payload
            )

        return
            String(
                data:
                    data,
                encoding:
                    .utf8
            )!
    }

    private static func styleContribution()
        -> CSSContribution
    {
        CSS.contribution(
            styleIdentifier
        ) {
            CSS.rule(
                ".\(block)",
                CSS.decl(
                    "display",
                    "inline-flex"
                ),
                CSS.decl(
                    "align-items",
                    "center"
                ),
                CSS.decl(
                    "gap",
                    "0.5rem"
                )
            )

            CSS.rule(
                ".\(block)__button",
                CSS.decl(
                    "appearance",
                    "none"
                ),
                CSS.decl(
                    "border",
                    "1px solid var(--border-subtle, #d7e2ec)"
                ),
                CSS.decl(
                    "border-radius",
                    "0.65rem"
                ),
                CSS.decl(
                    "background",
                    "var(--surface-strong, #ffffff)"
                ),
                CSS.decl(
                    "color",
                    "var(--text, #0f1720)"
                ),
                CSS.decl(
                    "font",
                    "inherit"
                ),
                CSS.decl(
                    "font-weight",
                    "600"
                ),
                CSS.decl(
                    "line-height",
                    "1.1"
                ),
                CSS.decl(
                    "padding",
                    "0.75rem 1rem"
                ),
                CSS.decl(
                    "cursor",
                    "pointer"
                ),
                CSS.decl(
                    "box-shadow",
                    "0 1px 0 rgba(0,0,0,.04), 0 2px 6px rgba(0,0,0,.06)"
                )
            )

            CSS.rule(
                ".\(block)__button:hover",
                CSS.decl(
                    "background",
                    "var(--surface-soft, #e4edf4)"
                )
            )

            CSS.rule(
                ".\(block)__button:disabled",
                CSS.decl(
                    "opacity",
                    "0.6"
                ),
                CSS.decl(
                    "cursor",
                    "not-allowed"
                )
            )
        }
    }

    public static func stylesheet()
        -> CSSStyleSheet
    {
        styleContribution()
            .content
            .sheet
    }
}
