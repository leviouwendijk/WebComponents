import Constructors
import CSS
import HTML
import JS

public enum DrijfverenResponseMapPole: String, Sendable, CaseIterable {
    case voordeel
    case nadeel

    var title: String {
        switch self {
        case .voordeel:
            return "Voordelen"

        case .nadeel:
            return "Nadelen"
        }
    }

    var emptyLabel: String {
        switch self {
        case .voordeel:
            return "Nog geen voordelen ingevuld."

        case .nadeel:
            return "Nog geen nadelen ingevuld."
        }
    }
}

public enum DrijfverenResponseMapKind: String, Sendable, CaseIterable {
    case accessAppetitive = "access-appetitive"
    case barrierAppetitive = "barrier-appetitive"
    case reliefAversive = "relief-aversive"
    case activationAversive = "activation-aversive"

    var pole: DrijfverenResponseMapPole {
        switch self {
        case .accessAppetitive,
             .reliefAversive:
            return .voordeel

        case .barrierAppetitive,
             .activationAversive:
            return .nadeel
        }
    }

    var selectLabel: String {
        switch self {
        case .accessAppetitive:
            return "Toegang tot appetitief"

        case .barrierAppetitive:
            return "Barrière / verlies appetitief"

        case .reliefAversive:
            return "Verlichting van aversief"

        case .activationAversive:
            return "Activatie van aversief"
        }
    }

    var visualLabel: String {
        switch self {
        case .accessAppetitive:
            return "toegang"

        case .barrierAppetitive:
            return "barrière"

        case .reliefAversive:
            return "verlichting"

        case .activationAversive:
            return "activatie"
        }
    }

    var placeholder: String {
        switch self {
        case .accessAppetitive:
            return "Bijvoorbeeld: ruimte, controle, aandacht, succeservaring"

        case .barrierAppetitive:
            return "Bijvoorbeeld: verlies van contact, vrijheid, spel of training"

        case .reliefAversive:
            return "Bijvoorbeeld: dreiging stopt, afstand neemt toe, spanning zakt"

        case .activationAversive:
            return "Bijvoorbeeld: conflict, lijnspanning, correctie, frustratie"
        }
    }
}

public struct DrijfverenResponseMapTool: ReusableComponent, Sendable {
    public static let block = "wc-drijfveren-response-map-tool"

    public let id: String
    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        id: String = "drijfveren-response-map-tool",
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
        self.id = id
        self.includeStyles = includeStyles
        self.includeScript = includeScript
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.main(
                    [
                        "id": "content-area",
                        "class": Self.block,
                        "data-drijfveren-response-map-tool": ""
                    ]
                ) {
                    hero()
                    toolSurface()
                    actions()
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : [],
            scripts: includeScript ? DrijfverenResponseMapToolScript().nodes.scripts : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    private func hero() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__hero"]) {
            HTML.p(["class": "\(Self.block)__eyebrow"]) {
                HTML.text("Hulpmiddel · drijfveren")
            }

            HTML.h1 {
                HTML.text("Drijfverenkaart")
            }

            HTML.p(["class": "\(Self.block)__lead"]) {
                HTML.text("Breng één concrete keuze in kaart: welke voordelen trekken de hond naar deze reactie toe, en welke nadelen of kosten hangen eraan vast?")
            }
        }
    }

    private func toolSurface() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__surface"]) {
            visualMap()
            inputPanel()
        }
    }

    private func visualMap() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__visual"]) {
            HTML.div(["class": "\(Self.block)__visual-header"]) {
                HTML.p(["class": "\(Self.block)__eyebrow"]) {
                    HTML.text("situatie")
                }

                HTML.h2(["data-visual-circumstance": ""]) {
                    HTML.text("Aangelijnd, smal pad, hond komt recht op ons af")
                }

                HTML.p(["data-visual-state": ""]) {
                    HTML.text("Gespannen, al hoog in opwinding, weinig afstand")
                }
            }

            HTML.div(
                [
                    "class": "\(Self.block)__graphic",
                    "aria-label": "Drijfverenkaart met voordelen, nadelen, hond en gekozen reactie"
                ]
            ) {
                visualCard(.voordeel)
                visualCard(.nadeel)
                dogNode()
                choiceNode()
                arrows()
            }
        }
    }

    private func visualCard(
        _ pole: DrijfverenResponseMapPole
    ) -> any HTMLNode {
        HTML.article(
            [
                "class": "\(Self.block)__visual-card \(Self.block)__visual-card--\(pole.rawValue)",
                "data-visual-card": pole.rawValue
            ]
        ) {
            HTML.div(["class": "\(Self.block)__visual-card-head"]) {
                HTML.h3 {
                    HTML.text(pole.title)
                }

                HTML.span(["data-pole-total": pole.rawValue]) {
                    HTML.text("0")
                }
            }

            HTML.el(
                "ul",
                [
                    "class": "\(Self.block)__visual-list",
                    "data-visual-list": pole.rawValue,
                    "data-empty-label": pole.emptyLabel
                ]
            ) {
                HTML.el("li", ["class": "\(Self.block)__visual-empty"]) {
                    HTML.text(pole.emptyLabel)
                }
            }
        }
    }

    private func dogNode() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__dog-node"]) {
            HTML.span {
                HTML.text("hond")
            }
        }
    }

    private func choiceNode() -> any HTMLNode {
        HTML.article(["class": "\(Self.block)__choice-node"]) {
            HTML.p(["class": "\(Self.block)__eyebrow"]) {
                HTML.text("keuze")
            }

            HTML.h3(["data-visual-response": ""]) {
                HTML.text("Uitvallen / blaffen")
            }

            HTML.p {
                HTML.text("De reactie die we verklaren")
            }
        }
    }

    private func arrows() -> any HTMLNode {
        HTML.el(
            "svg",
            [
                "class": "\(Self.block)__arrows",
                "viewBox": "0 0 100 70",
                "aria-hidden": "true",
                "focusable": "false"
            ]
        ) {
            HTML.el("defs") {
                HTML.el(
                    "marker",
                    [
                        "id": "drijfveren-response-map-arrow-head",
                        "viewBox": "0 0 10 10",
                        "refX": "8",
                        "refY": "5",
                        "markerWidth": "6",
                        "markerHeight": "6",
                        "orient": "auto-start-reverse"
                    ]
                ) {
                    HTML.el(
                        "path",
                        [
                            "d": "M 0 0 L 10 5 L 0 10 z",
                            "class": "\(Self.block)__arrow-head"
                        ]
                    ) {}
                }
            }

            HTML.el(
                "path",
                [
                    "class": "\(Self.block)__arrow \(Self.block)__arrow--toward",
                    "d": "M 50 44 C 43 36, 33 25, 22 18",
                    "marker-end": "url(#drijfveren-response-map-arrow-head)"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": "\(Self.block)__arrow \(Self.block)__arrow--away",
                    "d": "M 67 20 C 58 24, 54 33, 54 42",
                    "marker-end": "url(#drijfveren-response-map-arrow-head)"
                ]
            ) {}

            HTML.el(
                "text",
                [
                    "class": "\(Self.block)__arrow-label \(Self.block)__arrow-label--toward",
                    "x": "29",
                    "y": "31"
                ]
            ) {
                HTML.text("naar toe")
            }

            HTML.el(
                "text",
                [
                    "class": "\(Self.block)__arrow-label \(Self.block)__arrow-label--away",
                    "x": "57",
                    "y": "29"
                ]
            ) {
                HTML.text("weg van")
            }
        }
    }

    private func inputPanel() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__inputs"]) {
            HTML.div(["class": "\(Self.block)__inputs-head"]) {
                HTML.p(["class": "\(Self.block)__eyebrow"]) {
                    HTML.text("inputs / controls")
                }

                HTML.h2 {
                    HTML.text("Vul de situatie, keuze en gevolgen in")
                }

                HTML.p {
                    HTML.text("Kies per gevolg of het gaat om toegang of barrière tot iets appetitiefs, of om activatie of verlichting van iets aversiefs. De kaart sorteert dit automatisch als voordeel of nadeel.")
                }
            }

            contextFields()
            responseField()
            entryList()
            summary()
        }
    }

    private func contextFields() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__context-grid"]) {
            field(
                id: "\(id)-circumstance",
                label: "Omstandigheid",
                field: "circumstance",
                value: "Aangelijnd, smal pad, hond komt recht op ons af",
                placeholder: "Bijvoorbeeld: aangelijnd, smal pad, hond komt recht op ons af"
            )

            field(
                id: "\(id)-state",
                label: "Toestand hond",
                field: "state",
                value: "Gespannen, al hoog in opwinding, weinig afstand",
                placeholder: "Bijvoorbeeld: gespannen, al hoog in opwinding, weinig afstand"
            )
        }
    }

    private func field(
        id: String,
        label: String,
        field: String,
        value: String,
        placeholder: String
    ) -> any HTMLNode {
        HTML.label(
            [
                "class": "\(Self.block)__field",
                "for": id
            ]
        ) {
            HTML.span {
                HTML.text(label)
            }

            HTML.input([
                "id": id,
                "type": "text",
                "value": value,
                "placeholder": placeholder,
                "data-drijfveren-field": field
            ])
        }
    }

    private func responseField() -> any HTMLNode {
        HTML.label(
            [
                "class": "\(Self.block)__field \(Self.block)__field--response",
                "for": "\(id)-response"
            ]
        ) {
            HTML.span {
                HTML.text("Keuze / respons")
            }

            HTML.input([
                "id": "\(id)-response",
                "type": "text",
                "value": "Uitvallen / blaffen",
                "placeholder": "Bijvoorbeeld: uitvallen, wegkijken, inchecken, snuffelen",
                "data-drijfveren-field": "response"
            ])
        }
    }

    private func entryList() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__entry-panel"]) {
            HTML.div(["class": "\(Self.block)__entry-head"]) {
                HTML.h3 {
                    HTML.text("Gevolgen")
                }

                HTML.button(
                    [
                        "type": "button",
                        "class": "\(Self.block)__button \(Self.block)__button--secondary",
                        "data-entry-add": ""
                    ]
                ) {
                    HTML.text("Gevolg toevoegen")
                }
            }

            HTML.div(["class": "\(Self.block)__entry-list", "data-entry-list": ""]) {
                entryRow(
                    text: "Afstand neemt toe; de dreiging stopt",
                    kind: .reliefAversive,
                    strength: 4
                )

                entryRow(
                    text: "Ontlading of controle als herhaalde uitkomst",
                    kind: .accessAppetitive,
                    strength: 3
                )

                entryRow(
                    text: "Meer spanning of conflict aan de lijn",
                    kind: .activationAversive,
                    strength: 2
                )
            }
        }
    }

    private func entryRow(
        text: String,
        kind selectedKind: DrijfverenResponseMapKind,
        strength: Int
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "\(Self.block)__entry-row",
                "data-entry-row": ""
            ]
        ) {
            HTML.input([
                "type": "text",
                "value": text,
                "placeholder": selectedKind.placeholder,
                "data-entry-text": "",
                "aria-label": "Gevolg"
            ])

            HTML.el(
                "select",
                [
                    "class": "\(Self.block)__kind-select",
                    "data-entry-kind": "",
                    "aria-label": "Type gevolg"
                ]
            ) {
                for kind in DrijfverenResponseMapKind.allCases {
                    option(
                        kind,
                        selected: kind == selectedKind
                    )
                }
            }

            HTML.label(["class": "\(Self.block)__strength"]) {
                HTML.span {
                    HTML.text("sterkte")
                }

                HTML.input([
                    "type": "range",
                    "min": "0",
                    "max": "5",
                    "value": "\(strength)",
                    "data-entry-strength": "",
                    "aria-label": "Belang of sterkte"
                ])

                HTML.strong(["data-entry-strength-value": ""]) {
                    HTML.text("\(strength)")
                }
            }

            HTML.button(
                [
                    "type": "button",
                    "class": "\(Self.block)__remove",
                    "data-entry-remove": "",
                    "aria-label": "Verwijder gevolg"
                ]
            ) {
                HTML.text("×")
            }
        }
    }

    private func option(
        _ kind: DrijfverenResponseMapKind,
        selected: Bool
    ) -> any HTMLNode {
        var attributes: [String: String] = [
            "value": kind.rawValue
        ]

        if selected {
            attributes["selected"] = "selected"
        }

        return HTML.el(
            "option",
            attributes
        ) {
            HTML.text(kind.selectLabel)
        }
    }

    private func summary() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__summary"]) {
            HTML.div {
                HTML.p(["class": "\(Self.block)__summary-eyebrow"]) {
                    HTML.text("interpretatie")
                }

                HTML.h3(["data-summary-title": ""]) {
                    HTML.text("De voordelen maken deze reactie logisch")
                }

                HTML.p(["data-summary-text": ""]) {
                    HTML.text("De respons wordt begrijpelijk omdat hij iets oplevert of iets onaangenaams laat stoppen.")
                }
            }

            HTML.div(["class": "\(Self.block)__totals"]) {
                totalPill(.voordeel)
                totalPill(.nadeel)
            }
        }
    }

    private func totalPill(
        _ pole: DrijfverenResponseMapPole
    ) -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__total \(Self.block)__total--\(pole.rawValue)"]) {
            HTML.span {
                HTML.text(pole.title)
            }

            HTML.strong(["data-pole-total": pole.rawValue]) {
                HTML.text("0")
            }
        }
    }

    private func actions() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__actions"]) {
            HTML.button(
                [
                    "type": "button",
                    "class": "\(Self.block)__button \(Self.block)__button--secondary",
                    "data-map-clear": ""
                ]
            ) {
                HTML.text("Nieuwe kaart")
            }

            HTML.button(
                [
                    "type": "button",
                    "class": "\(Self.block)__button",
                    "data-map-print": ""
                ]
            ) {
                HTML.text("Print / bewaar als PDF")
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        let block = Self.block

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("--tool-surface", "var(--surface-color, #fff)"),
                    CSS.decl("--tool-soft", "var(--surface-soft-color, #f4f6f8)"),
                    CSS.decl("--tool-border", "var(--border-color, rgba(15, 23, 42, .14))"),
                    CSS.decl("--tool-text", "var(--text-color, #17202a)"),
                    CSS.decl("--tool-muted", "var(--muted-text-color, rgba(23, 32, 42, .65))"),
                    CSS.decl("--tool-voordeel", "var(--success, #2E8B57)"),
                    CSS.decl("--tool-nadeel", "var(--danger, #D64545)"),
                    CSS.decl("width", "min(1120px, calc(100% - 48px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "58px 0 92px"),
                    CSS.decl("color", "var(--tool-text)")
                ),

                CSS.rule(
                    ".\(block), .\(block) *",
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(block)__hero",
                    CSS.decl("max-width", "860px"),
                    CSS.decl("margin", "0 0 32px")
                ),

                CSS.rule(
                    ".\(block)__eyebrow, .\(block)__summary-eyebrow",
                    CSS.decl("margin", "0 0 8px"),
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".11em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__hero h1",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(2.2rem, 5vw, 4.4rem)"),
                    CSS.decl("line-height", ".95"),
                    CSS.decl("letter-spacing", "-.055em")
                ),

                CSS.rule(
                    ".\(block)__lead",
                    CSS.decl("max-width", "800px"),
                    CSS.decl("margin", "18px 0 0"),
                    CSS.decl("font-size", "1.08rem"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__surface",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("padding", "clamp(16px, 3vw, 24px)"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "26px"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-surface) 96%, var(--tool-text) 4%)"),
                    CSS.decl("box-shadow", "0 18px 48px rgba(15, 23, 42, .08)")
                ),

                CSS.rule(
                    ".\(block)__visual, .\(block)__inputs, .\(block)__actions",
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "var(--tool-surface)")
                ),

                CSS.rule(
                    ".\(block)__visual",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("padding", "18px")
                ),

                CSS.rule(
                    ".\(block)__visual-header",
                    CSS.decl("max-width", "760px")
                ),

                CSS.rule(
                    ".\(block)__visual-header h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.24rem"),
                    CSS.decl("line-height", "1.18")
                ),

                CSS.rule(
                    ".\(block)__visual-header p:not(.\(block)__eyebrow)",
                    CSS.decl("margin", "6px 0 0"),
                    CSS.decl("font-size", ".94rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__graphic",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(220px, 1fr) minmax(150px, 210px) minmax(220px, 1fr)"),
                    CSS.decl("grid-template-rows", "auto 78px auto"),
                    CSS.decl("gap", "18px 28px"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("min-height", "460px"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "20px"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-soft) 62%, var(--tool-surface))"),
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".\(block)__visual-card",
                    CSS.decl("position", "relative"),
                    CSS.decl("z-index", "2"),
                    CSS.decl("display", "grid"),
                    CSS.decl("align-content", "start"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("min-height", "235px"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "20px"),
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("box-shadow", "0 14px 34px rgba(15, 23, 42, .06)")
                ),

                CSS.rule(
                    ".\(block)__visual-card--voordeel",
                    CSS.decl("grid-column", "1"),
                    CSS.decl("grid-row", "1 / span 2"),
                    CSS.decl("box-shadow", "inset 6px 0 0 color-mix(in srgb, var(--tool-voordeel) 72%, transparent), 0 14px 34px rgba(15, 23, 42, .06)")
                ),

                CSS.rule(
                    ".\(block)__visual-card--nadeel",
                    CSS.decl("grid-column", "3"),
                    CSS.decl("grid-row", "1 / span 2"),
                    CSS.decl("box-shadow", "inset 6px 0 0 color-mix(in srgb, var(--tool-nadeel) 72%, transparent), 0 14px 34px rgba(15, 23, 42, .06)")
                ),

                CSS.rule(
                    ".\(block)__visual-card-head",
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("padding-bottom", "10px"),
                    CSS.decl("border-bottom", "1px solid var(--tool-border)")
                ),

                CSS.rule(
                    ".\(block)__visual-card-head h3",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.28rem"),
                    CSS.decl("letter-spacing", "-.02em")
                ),

                CSS.rule(
                    ".\(block)__visual-card-head span",
                    CSS.decl("display", "inline-grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("min-width", "30px"),
                    CSS.decl("height", "30px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".8rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("background", "var(--tool-soft)")
                ),

                CSS.rule(
                    ".\(block)__visual-card--voordeel .\(block)__visual-card-head span",
                    CSS.decl("color", "var(--tool-voordeel)")
                ),

                CSS.rule(
                    ".\(block)__visual-card--nadeel .\(block)__visual-card-head span",
                    CSS.decl("color", "var(--tool-nadeel)")
                ),

                CSS.rule(
                    ".\(block)__visual-list",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("padding", "0"),
                    CSS.decl("margin", "0"),
                    CSS.decl("list-style", "none")
                ),

                CSS.rule(
                    ".\(block)__visual-list li",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "3px"),
                    CSS.decl("padding", "9px 10px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-soft) 60%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__visual-list li span",
                    CSS.decl("font-size", ".66rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".06em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__visual-list li strong",
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.25")
                ),

                CSS.rule(
                    ".\(block)__visual-empty",
                    CSS.decl("color", "var(--tool-muted)"),
                    CSS.decl("font-size", ".9rem")
                ),

                CSS.rule(
                    ".\(block)__dog-node",
                    CSS.decl("position", "relative"),
                    CSS.decl("z-index", "3"),
                    CSS.decl("grid-column", "2"),
                    CSS.decl("grid-row", "2"),
                    CSS.decl("justify-self", "center"),
                    CSS.decl("align-self", "center"),
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "68px"),
                    CSS.decl("height", "68px"),
                    CSS.decl("border", "2px solid color-mix(in srgb, var(--link-color) 42%, var(--tool-border))"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("box-shadow", "0 12px 30px rgba(15, 23, 42, .1)")
                ),

                CSS.rule(
                    ".\(block)__dog-node span",
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "820"),
                    CSS.decl("letter-spacing", ".09em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__choice-node",
                    CSS.decl("position", "relative"),
                    CSS.decl("z-index", "2"),
                    CSS.decl("grid-column", "2"),
                    CSS.decl("grid-row", "3"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("min-width", "min(340px, 100%)"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--link-color) 38%, var(--tool-border))"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 8%, var(--tool-surface))"),
                    CSS.decl("text-align", "center")
                ),

                CSS.rule(
                    ".\(block)__choice-node h3",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.12rem"),
                    CSS.decl("line-height", "1.15")
                ),

                CSS.rule(
                    ".\(block)__choice-node p:not(.\(block)__eyebrow)",
                    CSS.decl("margin", "2px 0 0"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__arrows",
                    CSS.decl("position", "absolute"),
                    CSS.decl("inset", "0"),
                    CSS.decl("z-index", "1"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "100%"),
                    CSS.decl("pointer-events", "none")
                ),

                CSS.rule(
                    ".\(block)__arrow",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--tool-text) 42%, transparent)"),
                    CSS.decl("stroke-width", "1.2"),
                    CSS.decl("stroke-linecap", "round")
                ),

                CSS.rule(
                    ".\(block)__arrow--away",
                    CSS.decl("stroke-dasharray", "3 3")
                ),

                CSS.rule(
                    ".\(block)__arrow-head",
                    CSS.decl("fill", "color-mix(in srgb, var(--tool-text) 42%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__arrow-label",
                    CSS.decl("font-size", "3px"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".04em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("fill", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__inputs",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("padding", "18px")
                ),

                CSS.rule(
                    ".\(block)__inputs-head",
                    CSS.decl("max-width", "820px")
                ),

                CSS.rule(
                    ".\(block)__inputs-head h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.28rem"),
                    CSS.decl("line-height", "1.15")
                ),

                CSS.rule(
                    ".\(block)__inputs-head p:not(.\(block)__eyebrow)",
                    CSS.decl("margin", "8px 0 0"),
                    CSS.decl("font-size", ".94rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__context-grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(2, minmax(0, 1fr))"),
                    CSS.decl("gap", "12px")
                ),

                CSS.rule(
                    ".\(block)__field",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--tool-surface)")
                ),

                CSS.rule(
                    ".\(block)__field--response",
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 7%, var(--tool-surface))"),
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 34%, var(--tool-border))")
                ),

                CSS.rule(
                    ".\(block)__field span",
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".09em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block) input[type=\"text\"], .\(block)__kind-select",
                    CSS.decl("width", "100%"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("padding", "10px 12px"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("color", "var(--tool-text)"),
                    CSS.decl("background", "var(--tool-surface)")
                ),

                CSS.rule(
                    ".\(block)__entry-panel",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".\(block)__entry-head",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "12px")
                ),

                CSS.rule(
                    ".\(block)__entry-head h3",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.05rem")
                ),

                CSS.rule(
                    ".\(block)__entry-list",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".\(block)__entry-row",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1.3fr) minmax(210px, .7fr) minmax(130px, .42fr) 34px"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("padding", "10px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-soft) 58%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__strength",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "auto minmax(0, 1fr) 20px"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("align-items", "center")
                ),

                CSS.rule(
                    ".\(block)__strength span",
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".06em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__strength strong",
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block) input[type=\"range\"]",
                    CSS.decl("width", "100%"),
                    CSS.decl("accent-color", "var(--link-color)")
                ),

                CSS.rule(
                    ".\(block)__summary",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) auto"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--tool-soft)")
                ),

                CSS.rule(
                    ".\(block)__summary h3",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1rem")
                ),

                CSS.rule(
                    ".\(block)__summary p:not(.\(block)__summary-eyebrow)",
                    CSS.decl("margin", "6px 0 0"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__totals",
                    CSS.decl("display", "flex"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("justify-content", "flex-end")
                ),

                CSS.rule(
                    ".\(block)__total",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "2px"),
                    CSS.decl("min-width", "92px"),
                    CSS.decl("padding", "8px 10px"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "var(--tool-surface)")
                ),

                CSS.rule(
                    ".\(block)__total span",
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".06em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__total strong",
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", "1rem")
                ),

                CSS.rule(
                    ".\(block)__total--voordeel strong",
                    CSS.decl("color", "var(--tool-voordeel)")
                ),

                CSS.rule(
                    ".\(block)__total--nadeel strong",
                    CSS.decl("color", "var(--tool-nadeel)")
                ),

                CSS.rule(
                    ".\(block)__actions",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("margin-top", "18px"),
                    CSS.decl("padding", "18px")
                ),

                CSS.rule(
                    ".\(block)__button, .\(block)__remove",
                    CSS.decl("appearance", "none"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(block)__button",
                    CSS.decl("padding", "9px 13px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("border-color", "var(--tool-text)"),
                    CSS.decl("background", "var(--tool-text)"),
                    CSS.decl("color", "var(--background-color, #fff)")
                ),

                CSS.rule(
                    ".\(block)__button--secondary",
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("color", "var(--tool-text)")
                ),

                CSS.rule(
                    ".\(block)__remove",
                    CSS.decl("display", "inline-grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "34px"),
                    CSS.decl("height", "34px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("color", "var(--tool-text)")
                ),

                CSS.rule(
                    ".\(block) input:focus-visible, .\(block) select:focus-visible, .\(block) button:focus-visible",
                    CSS.decl("outline", "2px solid var(--link-color)"),
                    CSS.decl("outline-offset", "3px")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 980px)",
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("width", "calc(100% - 32px)"),
                        CSS.decl("padding", "44px 0 78px")
                    ),
                    CSS.rule(
                        ".\(block)__graphic",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("grid-template-rows", "auto"),
                        CSS.decl("min-height", "0")
                    ),
                    CSS.rule(
                        ".\(block)__visual-card--voordeel, .\(block)__visual-card--nadeel, .\(block)__dog-node, .\(block)__choice-node",
                        CSS.decl("grid-column", "1"),
                        CSS.decl("grid-row", "auto")
                    ),
                    CSS.rule(
                        ".\(block)__dog-node",
                        CSS.decl("margin", "4px auto")
                    ),
                    CSS.rule(
                        ".\(block)__arrows",
                        CSS.decl("display", "none")
                    ),
                    CSS.rule(
                        ".\(block)__context-grid, .\(block)__summary",
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        ".\(block)__totals",
                        CSS.decl("justify-content", "flex-start")
                    ),
                    CSS.rule(
                        ".\(block)__entry-row",
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        ".\(block)__remove",
                        CSS.decl("justify-self", "start")
                    )
                ),

                CSS.media(
                    "print",
                    CSS.rule(
                        "html, body, .hm-docs-app--tool",
                        CSS.decl("background", "#fff !important"),
                        CSS.decl("color", "#111827 !important")
                    ),
                    CSS.rule(
                        ".hm-docs-app--tool header, .hm-docs-app--tool nav, .hm-docs-app--tool .wc-docs-project-context-nav, .hm-docs-app--tool .wc-docs-mobile-navigation-drawer, .\(block)__actions",
                        CSS.decl("display", "none !important")
                    ),
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("--tool-surface", "#ffffff"),
                        CSS.decl("--tool-soft", "#f8fafc"),
                        CSS.decl("--tool-border", "#cbd5e1"),
                        CSS.decl("--tool-text", "#111827"),
                        CSS.decl("--tool-muted", "#475569"),
                        CSS.decl("width", "100%"),
                        CSS.decl("padding", "0"),
                        CSS.decl("margin", "0"),
                        CSS.decl("color-scheme", "light")
                    ),
                    CSS.rule(
                        ".\(block), .\(block) *",
                        CSS.decl("-webkit-print-color-adjust", "exact"),
                        CSS.decl("print-color-adjust", "exact")
                    ),
                    CSS.rule(
                        ".\(block)__surface, .\(block)__visual, .\(block)__inputs, .\(block)__visual-card, .\(block)__choice-node, .\(block)__summary",
                        CSS.decl("box-shadow", "none"),
                        CSS.decl("break-inside", "avoid")
                    )
                )
            ]
        )
    }
}

public struct DrijfverenResponseMapToolScript: ReusableComponent {
    public init() {}

    public var nodes: ReusableComponentNodes {
        .init(
            scripts: [
                JSSource(Self.source).as_inline_script()
            ]
        )
    }

    private static let source = #"""
    (() => {
        if (window.wcDrijfverenResponseMapTool?.initialized) return;

        const rootSelector = '[data-drijfveren-response-map-tool]';

        const kinds = {
            'access-appetitive': {
                pole: 'voordeel',
                label: 'toegang',
                selectLabel: 'Toegang tot appetitief',
                placeholder: 'Bijvoorbeeld: ruimte, controle, aandacht, succeservaring'
            },
            'barrier-appetitive': {
                pole: 'nadeel',
                label: 'barrière',
                selectLabel: 'Barrière / verlies appetitief',
                placeholder: 'Bijvoorbeeld: verlies van contact, vrijheid, spel of training'
            },
            'relief-aversive': {
                pole: 'voordeel',
                label: 'verlichting',
                selectLabel: 'Verlichting van aversief',
                placeholder: 'Bijvoorbeeld: dreiging stopt, afstand neemt toe, spanning zakt'
            },
            'activation-aversive': {
                pole: 'nadeel',
                label: 'activatie',
                selectLabel: 'Activatie van aversief',
                placeholder: 'Bijvoorbeeld: conflict, lijnspanning, correctie, frustratie'
            }
        };

        function text(value) {
            return String(value || '').trim();
        }

        function numeric(value, fallback = 0) {
            const next = Number(value);
            return Number.isFinite(next) ? next : fallback;
        }

        function fieldValue(root, field, fallback) {
            const input = root.querySelector(`[data-drijfveren-field="${field}"]`);
            return text(input?.value) || fallback;
        }

        function rows(root) {
            return Array.from(root.querySelectorAll('[data-entry-row]'));
        }

        function clearList(list) {
            while (list.firstChild) {
                list.removeChild(list.firstChild);
            }
        }

        function emptyItem(label) {
            const item = document.createElement('li');
            item.className = 'wc-drijfveren-response-map-tool__visual-empty';
            item.textContent = label;
            return item;
        }

        function visualItem(entry) {
            const item = document.createElement('li');

            const label = document.createElement('span');
            label.textContent = `${entry.kindLabel} · ${entry.strength}`;

            const body = document.createElement('strong');
            body.textContent = entry.text;

            item.append(label, body);

            return item;
        }

        function entryData(row) {
            const textInput = row.querySelector('[data-entry-text]');
            const kindInput = row.querySelector('[data-entry-kind]');
            const strengthInput = row.querySelector('[data-entry-strength]');
            const strengthValue = row.querySelector('[data-entry-strength-value]');
            const kind = kinds[kindInput?.value] || kinds['access-appetitive'];
            const strength = numeric(strengthInput?.value, 0);

            if (strengthValue) {
                strengthValue.textContent = String(strength);
            }

            if (textInput && kind.placeholder) {
                textInput.setAttribute('placeholder', kind.placeholder);
            }

            return {
                text: text(textInput?.value),
                pole: kind.pole,
                kindLabel: kind.label,
                strength
            };
        }

        function collect(root) {
            const result = {
                voordeel: [],
                nadeel: [],
                totals: {
                    voordeel: 0,
                    nadeel: 0
                }
            };

            rows(root).forEach((row) => {
                const entry = entryData(row);

                if (!entry.text) return;

                result[entry.pole].push(entry);
                result.totals[entry.pole] += entry.strength;
            });

            return result;
        }

        function summaryFor(totals) {
            if (totals.voordeel === 0 && totals.nadeel === 0) {
                return {
                    title: 'Vul de concrete voordelen en nadelen in',
                    text: 'De kaart wordt duidelijk zodra je per gevolg kiest of het toegang, barrière, verlichting of activatie is.'
                };
            }

            if (totals.voordeel > totals.nadeel) {
                return {
                    title: 'De voordelen maken deze reactie logisch',
                    text: 'De respons wordt begrijpelijk omdat hij iets oplevert of iets onaangenaams laat stoppen. Bij reactiviteit kan dat bijvoorbeeld afstand, opluchting, controle of ontlading zijn.'
                };
            }

            if (totals.nadeel > totals.voordeel) {
                return {
                    title: 'De nadelen kunnen deze reactie remmen',
                    text: 'De respons heeft wel functie, maar brengt ook kosten mee. Alternatief gedrag wordt kansrijker wanneer het dezelfde voordelen geeft met minder nadeel.'
                };
            }

            return {
                title: 'Voordelen en nadelen zijn ongeveer in balans',
                text: 'Dan kunnen kleine contextfactoren bepalen wat de hond uiteindelijk doet: afstand, spanning, eerdere herhaling, begeleidergedrag of beschikbaar alternatief gedrag.'
            };
        }

        function updateVisualLists(root, data) {
            ['voordeel', 'nadeel'].forEach((pole) => {
                const list = root.querySelector(`[data-visual-list="${pole}"]`);
                if (!list) return;

                clearList(list);

                if (!data[pole].length) {
                    list.appendChild(emptyItem(list.getAttribute('data-empty-label') || 'Nog niets ingevuld.'));
                    return;
                }

                data[pole].forEach((entry) => {
                    list.appendChild(visualItem(entry));
                });
            });
        }

        function update(root) {
            if (!root) return;

            const circumstance = fieldValue(
                root,
                'circumstance',
                'Situatie nog niet ingevuld'
            );

            const state = fieldValue(
                root,
                'state',
                'Toestand hond nog niet ingevuld'
            );

            const response = fieldValue(
                root,
                'response',
                'Keuze nog niet ingevuld'
            );

            root.querySelectorAll('[data-visual-circumstance]').forEach((node) => {
                node.textContent = circumstance;
            });

            root.querySelectorAll('[data-visual-state]').forEach((node) => {
                node.textContent = state;
            });

            root.querySelectorAll('[data-visual-response]').forEach((node) => {
                node.textContent = response;
            });

            const data = collect(root);
            updateVisualLists(root, data);

            Object.entries(data.totals).forEach(([pole, value]) => {
                root.querySelectorAll(`[data-pole-total="${pole}"]`).forEach((node) => {
                    node.textContent = String(value);
                });
            });

            const summary = summaryFor(data.totals);
            const titleNode = root.querySelector('[data-summary-title]');
            const textNode = root.querySelector('[data-summary-text]');

            if (titleNode) {
                titleNode.textContent = summary.title;
            }

            if (textNode) {
                textNode.textContent = summary.text;
            }
        }

        function option(value, selected) {
            const node = document.createElement('option');
            node.value = value;
            node.textContent = kinds[value]?.selectLabel || value;

            if (selected) {
                node.selected = true;
            }

            return node;
        }

        function makeEntryRow(kind = 'access-appetitive') {
            const row = document.createElement('div');
            row.className = 'wc-drijfveren-response-map-tool__entry-row';
            row.setAttribute('data-entry-row', '');
            row.setAttribute('data-extra-row', 'true');

            const input = document.createElement('input');
            input.type = 'text';
            input.placeholder = kinds[kind]?.placeholder || '';
            input.setAttribute('data-entry-text', '');
            input.setAttribute('aria-label', 'Gevolg');

            const select = document.createElement('select');
            select.className = 'wc-drijfveren-response-map-tool__kind-select';
            select.setAttribute('data-entry-kind', '');
            select.setAttribute('aria-label', 'Type gevolg');

            Object.keys(kinds).forEach((key) => {
                select.appendChild(option(key, key === kind));
            });

            const strength = document.createElement('label');
            strength.className = 'wc-drijfveren-response-map-tool__strength';

            const strengthLabel = document.createElement('span');
            strengthLabel.textContent = 'sterkte';

            const range = document.createElement('input');
            range.type = 'range';
            range.min = '0';
            range.max = '5';
            range.value = '3';
            range.setAttribute('data-entry-strength', '');
            range.setAttribute('aria-label', 'Belang of sterkte');

            const value = document.createElement('strong');
            value.setAttribute('data-entry-strength-value', '');
            value.textContent = '3';

            strength.append(strengthLabel, range, value);

            const remove = document.createElement('button');
            remove.type = 'button';
            remove.className = 'wc-drijfveren-response-map-tool__remove';
            remove.setAttribute('data-entry-remove', '');
            remove.setAttribute('aria-label', 'Verwijder gevolg');
            remove.textContent = '×';

            row.append(input, select, strength, remove);

            return row;
        }

        function clearMap(root) {
            root.querySelectorAll('[data-drijfveren-field]').forEach((input) => {
                input.value = '';
            });

            root.querySelectorAll('[data-entry-text]').forEach((input) => {
                input.value = '';
            });

            root.querySelectorAll('[data-entry-kind]').forEach((input) => {
                input.value = 'access-appetitive';
            });

            root.querySelectorAll('[data-entry-strength]').forEach((input) => {
                input.value = '3';
            });

            root.querySelectorAll('[data-extra-row="true"]').forEach((row) => {
                row.remove();
            });

            update(root);
        }

        function init(root) {
            if (root.dataset.drijfverenResponseInitialized === 'true') return;
            root.dataset.drijfverenResponseInitialized = 'true';

            root.addEventListener('input', () => update(root));
            root.addEventListener('change', () => update(root));

            root.addEventListener('click', (event) => {
                if (event.target.closest('[data-entry-add]')) {
                    const list = root.querySelector('[data-entry-list]');
                    const row = makeEntryRow();

                    list?.appendChild(row);
                    row.querySelector('[data-entry-text]')?.focus();
                    update(root);
                    return;
                }

                const remove = event.target.closest('[data-entry-remove]');
                if (remove) {
                    const row = remove.closest('[data-entry-row]');
                    const list = row?.parentElement;

                    if (list && list.querySelectorAll('[data-entry-row]').length > 1) {
                        row.remove();
                    } else if (row) {
                        row.querySelector('[data-entry-text]').value = '';
                        row.querySelector('[data-entry-kind]').value = 'access-appetitive';
                        row.querySelector('[data-entry-strength]').value = '3';
                    }

                    update(root);
                    return;
                }

                if (event.target.closest('[data-map-clear]')) {
                    clearMap(root);
                    return;
                }

                if (event.target.closest('[data-map-print]')) {
                    window.print();
                }
            });

            update(root);
        }

        function initAll() {
            document.querySelectorAll(rootSelector).forEach(init);
        }

        document.addEventListener('DOMContentLoaded', initAll);
        initAll();

        window.wcDrijfverenResponseMapTool = {
            initialized: true,
            initAll,
            update
        };
    })();
    """#
}
