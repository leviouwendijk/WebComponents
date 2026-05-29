import Constructors
import CSS
import HTML

public struct OperantConditioningDiagram: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-operant-conditioning-diagram"
        static let stage = "wc-operant-conditioning-diagram__stage"
        static let caption = "wc-operant-conditioning-diagram__caption"
    }

    public let id: String
    public let caption: String?
    public let includeStyles: Bool

    public init(
        id: String = "operant-conditioning-diagram",
        caption: String? = "Operante conditionering betrekt een keuze: de uitkomst verandert de waarschijnlijkheid van toekomstig gedrag.",
        includeStyles: Bool = true
    ) {
        self.id = id
        self.caption = caption
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.figure(
                    [
                        "id": id,
                        "class": ClassName.root
                    ]
                ) {
                    HTML.div(
                        [
                            "class": ClassName.stage,
                            "role": "img",
                            "aria-label": "Prikkel leidt tot keuze, keuze leidt tot uitkomst."
                        ]
                    ) {
                        FlowDiagram(
                            axis: .row,
                            items: [
                                .box(.init {
                                    [
                                        HTML.b { HTML.text("Prikkel") },
                                        HTML.span { HTML.text("Situatie / context") }
                                    ]
                                }),
                                .arrow(.init()),
                                .box(.init {
                                    [
                                        HTML.b { HTML.text("Keuze") },
                                        HTML.span { HTML.text("Gedrag") }
                                    ]
                                }),
                                .arrow(.init()),
                                .box(.init {
                                    [
                                        HTML.b { HTML.text("Uitkomst") },
                                        HTML.span { HTML.text("Gevolg") }
                                    ]
                                })
                            ]
                        ).nodes.body
                    }

                    if let caption, !caption.isEmpty {
                        HTML.figcaption(["class": ClassName.caption]) {
                            HTML.text(caption)
                        }
                    }
                }
            ],
            stylesheets: includeStyles
                ? [
                    FlowDiagram.stylesheet(),
                    Self.stylesheet()
                ]
                : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("width", "min(760px, 100%)"),
                    CSS.decl("margin", "24px 0 28px")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)")
                ),

                CSS.rule(
                    ".\(ClassName.stage) .wc-flow",
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    ".\(ClassName.caption)",
                    CSS.decl("margin", "10px 0 0"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.48"),
                    CSS.decl("color", "var(--muted-text-color)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".\(ClassName.stage)",
                        CSS.decl("padding", "14px")
                    )
                )
            ]
        )
    }
}
