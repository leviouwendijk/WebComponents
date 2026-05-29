import Constructors
import CSS
import HTML

public struct OperantConditioningDiagram: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-operant-conditioning-diagram"
        static let stage = "wc-operant-conditioning-diagram__stage"
        static let flow = "wc-operant-conditioning-diagram__flow"
        static let matrix = "wc-operant-conditioning-diagram__matrix"
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
                            "aria-label": "Operante conditionering: prikkel, keuze, uitkomst en de vier operante kwadranten."
                        ]
                    ) {
                        HTML.div(["class": ClassName.flow]) {
                            flow().nodes.body
                        }

                        HTML.div(["class": ClassName.matrix]) {
                            matrix().nodes.body
                        }
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
                    FlowDiagram.css(),
                    MatrixDiagram.css(),
                    Self.stylesheet()
                ]
                : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    private func flow() -> FlowDiagram {
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
                        HTML.span { HTML.text("Gevolg (versterkt | verzwakt)") }
                    ]
                })
            ]
        )
    }

    private func matrix() -> MatrixDiagram {
        MatrixDiagram(
            columns: 2,
            rows: 2,
            cells: [
                [
                    quadrant(
                        code: "R+",
                        family: "\"reinforcement\"",
                        object: "motivator",
                        direction: "positive (+)"
                    ),
                    quadrant(
                        code: "P+",
                        family: "\"punishment\"",
                        object: "demotivator",
                        direction: "positive (+)"
                    )
                ],
                [
                    quadrant(
                        code: "R-",
                        family: "\"reinforcement\"",
                        object: "demotivator",
                        direction: "negative (-)"
                    ),
                    quadrant(
                        code: "P-",
                        family: "\"punishment\"",
                        object: "motivator",
                        direction: "negative (-)"
                    )
                ]
            ],
            columnHeaders: [
                .box(.init(classes: ["wc-matrix__label"], align: .center) {
                    [
                        HTML.span { HTML.text("Aansporing (Versterking)") },
                        HTML.span(["style": "font-size:1.2rem;line-height:1;"]) {
                            HTML.text("↓")
                        }
                    ]
                }),
                .box(.init(classes: ["wc-matrix__label"], align: .center) {
                    [
                        HTML.span { HTML.text("Ontmoediging (Ontkrachting)") },
                        HTML.span(["style": "font-size:1.2rem;line-height:1;"]) {
                            HTML.text("↓")
                        }
                    ]
                })
            ],
            rowHeaders: [
                .box(.init(classes: ["wc-matrix__label"], align: .center) {
                    [
                        HTML.div(["style": "display:flex;align-items:center;gap:10px;"]) {
                            HTML.span { HTML.text("Toevoeging") }
                            HTML.span(["style": "font-size:1.2rem;line-height:1;"]) {
                                HTML.text("→")
                            }
                        }
                    ]
                }),
                .box(.init(classes: ["wc-matrix__label"], align: .center) {
                    [
                        HTML.div(["style": "display:flex;align-items:center;gap:10px;"]) {
                            HTML.span { HTML.text("Opheffing") }
                            HTML.span(["style": "font-size:1.2rem;line-height:1;"]) {
                                HTML.text("→")
                            }
                        }
                    ]
                })
            ]
        )
    }

    private func quadrant(
        code: String,
        family: String,
        object: String,
        direction: String
    ) -> MatrixDiagram.Cell {
        .box(.init(align: .start) {
            [
                HTML.div(["style": "display:flex;justify-content:space-between;gap:12px;align-items:baseline;"]) {
                    HTML.b { HTML.text(code) }
                    HTML.span(["style": "font-style:italic;"]) {
                        HTML.text(family)
                    }
                },
                HTML.hr(["style": "border:0;border-top:1px solid var(--border-color, rgba(0,0,0,0.12));margin:10px 0;"]),
                HTML.div(["style": "display:flex;justify-content:space-between;gap:12px;align-items:baseline;"]) {
                    HTML.span(["style": "font-style:italic;"]) {
                        HTML.text(object)
                    }
                    HTML.span(["style": "font-size:0.9rem;"]) {
                        HTML.text(direction)
                    }
                }
            ]
        })
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("width", "min(860px, 100%)"),
                    CSS.decl("margin", "24px 0 30px")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "20px"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)")
                ),

                CSS.rule(
                    ".\(ClassName.flow) .wc-flow",
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    ".\(ClassName.matrix) .wc-matrix-wrap",
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
                        CSS.decl("padding", "14px"),
                        CSS.decl("gap", "16px")
                    )
                )
            ]
        )
    }
}
