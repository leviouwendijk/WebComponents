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
}

public enum DrijfverenResponseMapKind: String, Sendable, CaseIterable {
    case appetitiveGain = "appetitive-gain"
    case aversiveRelief = "aversive-relief"
    case appetitiveLoss = "appetitive-loss"
    case aversiveActivation = "aversive-activation"

    var pole: DrijfverenResponseMapPole {
        switch self {
        case .appetitiveGain,
             .aversiveRelief:
            return .voordeel

        case .appetitiveLoss,
             .aversiveActivation:
            return .nadeel
        }
    }

    var title: String {
        switch self {
        case .appetitiveGain:
            return "Toegang tot aantrekker"

        case .aversiveRelief:
            return "Verlichting van afstoter"

        case .appetitiveLoss:
            return "Verlies van aantrekker"

        case .aversiveActivation:
            return "Activatie van afstoter"
        }
    }

    var eyebrow: String {
        switch self {
        case .appetitiveGain:
            return "positieve bekrachtiging"

        case .aversiveRelief:
            return "negatieve bekrachtiging"

        case .appetitiveLoss:
            return "negatieve straf / kost"

        case .aversiveActivation:
            return "positieve straf / druk"
        }
    }

    var placeholder: String {
        switch self {
        case .appetitiveGain:
            return "Bijvoorbeeld: ruimte, controle, aandacht, succeservaring"

        case .aversiveRelief:
            return "Bijvoorbeeld: dreiging stopt, afstand neemt toe, spanning zakt"

        case .appetitiveLoss:
            return "Bijvoorbeeld: minder contact, minder vrijheid, training stopt"

        case .aversiveActivation:
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
                        "data-drijfveren-response-map-tool": "",
                        "data-active-response": "response-1"
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
                HTML.text("Breng één concrete reactie in kaart: wat trekt de hond naar deze reactie toe, en welke nadelen of kosten hangen eraan vast?")
            }
        }
    }

    private func toolSurface() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__surface"]) {
            contextFields()

            HTML.div(["class": "\(Self.block)__map"]) {
                focusCard()
                motivationGrid()
                summary()
            }
        }
    }

    private func contextFields() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__context-grid"]) {
            field(
                id: "\(id)-circumstance",
                label: "Omstandigheid",
                field: "circumstance",
                placeholder: "Bijvoorbeeld: aangelijnd, smal pad, hond komt recht op ons af"
            )

            field(
                id: "\(id)-state",
                label: "Toestand hond",
                field: "state",
                placeholder: "Bijvoorbeeld: gespannen, al hoog in opwinding, weinig afstand"
            )

            field(
                id: "\(id)-question",
                label: "Vraag",
                field: "question",
                placeholder: "Waarom wordt juist deze reactie waarschijnlijk?"
            )
        }
    }

    private func field(
        id: String,
        label: String,
        field: String,
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
                "placeholder": placeholder,
                "data-drijfveren-field": field
            ])
        }
    }

    private func focusCard() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__focus-card"]) {
            HTML.div(["class": "\(Self.block)__focus-copy"]) {
                HTML.p(["class": "\(Self.block)__eyebrow"]) {
                    HTML.text("gekozen respons")
                }

                HTML.h2 {
                    HTML.text("Welke reactie komt naar voren?")
                }

                HTML.p {
                    HTML.text("Vul één concrete reactie in. Gebruik daarna de voordelen en nadelen om te verklaren waarom deze respons in deze situatie prominent kan worden.")
                }
            }

            HTML.label(
                [
                    "class": "\(Self.block)__response-field",
                    "for": "\(id)-active-response"
                ]
            ) {
                HTML.span {
                    HTML.text("Respons")
                }

                HTML.input([
                    "id": "\(id)-active-response",
                    "type": "text",
                    "value": "Uitvallen / blaffen",
                    "data-response-label": "response-1",
                    "aria-label": "Gekozen respons"
                ])
            }
        }
    }

    private func motivationGrid() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__motivation-grid"]) {
            motivationLane(
                pole: .voordeel,
                tone: "voordelen",
                eyebrow: "trekkend",
                subtitle: "Wat levert deze reactie op, of wat stopt ermee?",
                kinds: [
                    .aversiveRelief,
                    .appetitiveGain
                ]
            )

            motivationLane(
                pole: .nadeel,
                tone: "nadelen",
                eyebrow: "remmend",
                subtitle: "Wat kost deze reactie, of wat wordt er juist actief?",
                kinds: [
                    .appetitiveLoss,
                    .aversiveActivation
                ]
            )
        }
    }

    private func motivationLane(
        pole: DrijfverenResponseMapPole,
        tone: String,
        eyebrow: String,
        subtitle: String,
        kinds: [DrijfverenResponseMapKind]
    ) -> any HTMLNode {
        HTML.section(
            [
                "class": "\(Self.block)__motivation-lane \(Self.block)__motivation-lane--\(tone)",
                "data-pole": pole.rawValue
            ]
        ) {
            HTML.div(["class": "\(Self.block)__motivation-lane-head"]) {
                HTML.p {
                    HTML.text(eyebrow)
                }

                HTML.h3 {
                    HTML.text(pole.title)
                }

                HTML.span {
                    HTML.text(subtitle)
                }
            }

            HTML.div(["class": "\(Self.block)__bucket-stack"]) {
                for kind in kinds {
                    bucket(kind)
                }
            }
        }
    }

    private func bucket(
        _ kind: DrijfverenResponseMapKind
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "\(Self.block)__bucket \(Self.block)__bucket--\(kind.pole.rawValue)",
                "data-kind": kind.rawValue
            ]
        ) {
            HTML.div(["class": "\(Self.block)__bucket-head"]) {
                HTML.div {
                    HTML.p {
                        HTML.text(kind.eyebrow)
                    }

                    HTML.h4 {
                        HTML.text(kind.title)
                    }
                }

                HTML.button(
                    [
                        "type": "button",
                        "class": "\(Self.block)__small-button",
                        "data-kind-add": kind.rawValue,
                        "aria-label": "Item toevoegen"
                    ]
                ) {
                    HTML.text("+")
                }
            }

            HTML.div(["class": "\(Self.block)__bucket-list", "data-kind-list": kind.rawValue]) {
                itemRow(kind)
            }
        }
    }

    private func itemRow(
        _ kind: DrijfverenResponseMapKind
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "\(Self.block)__item-row",
                "data-kind-row": kind.rawValue
            ]
        ) {
            HTML.input([
                "type": "text",
                "placeholder": kind.placeholder,
                "data-kind-input": kind.rawValue,
                "aria-label": kind.title
            ])

            HTML.div(["class": "\(Self.block)__strength"]) {
                HTML.input([
                    "type": "range",
                    "min": "0",
                    "max": "5",
                    "value": "3",
                    "data-kind-strength": kind.rawValue,
                    "aria-label": "Belang of sterkte"
                ])

                HTML.span(["data-kind-strength-value": ""]) {
                    HTML.text("3")
                }
            }

            HTML.button(
                [
                    "type": "button",
                    "class": "\(Self.block)__remove",
                    "data-kind-remove": "",
                    "aria-label": "Verwijder item"
                ]
            ) {
                HTML.text("×")
            }
        }
    }

    private func summary() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__summary"]) {
            HTML.div(["class": "\(Self.block)__summary-head"]) {
                HTML.p(["class": "\(Self.block)__summary-eyebrow"]) {
                    HTML.text("interpretatie")
                }

                HTML.h3(["data-summary-title": ""]) {
                    HTML.text("Vul de concrete voordelen en nadelen in")
                }

                HTML.p(["data-summary-text": ""]) {
                    HTML.text("De kaart wordt duidelijk zodra je per respons ziet wat deze oplevert, wat ermee stopt, en welke kosten eraan hangen.")
                }
            }

            HTML.div(["class": "\(Self.block)__totals"]) {
                totalPill(
                    pole: .voordeel,
                    label: "Voordeel"
                )

                totalPill(
                    pole: .nadeel,
                    label: "Nadeel"
                )
            }
        }
    }

    private func totalPill(
        pole: DrijfverenResponseMapPole,
        label: String
    ) -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__total \(Self.block)__total--\(pole.rawValue)"]) {
            HTML.span {
                HTML.text(label)
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
                    ".\(block)__context-grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(3, minmax(0, 1fr))"),
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
                    ".\(block)__field span, .\(block)__response-field span",
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".09em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block) input[type=\"text\"]",
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
                    ".\(block)__map",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "16px")
                ),

                CSS.rule(
                    ".\(block)__focus-card",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, .58fr) minmax(280px, .42fr)"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("align-items", "stretch"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--link-color) 38%, var(--tool-border))"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 8%, var(--tool-surface))")
                ),

                CSS.rule(
                    ".\(block)__focus-copy h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.35rem"),
                    CSS.decl("line-height", "1.15")
                ),

                CSS.rule(
                    ".\(block)__focus-copy p:not(.\(block)__eyebrow)",
                    CSS.decl("margin", "8px 0 0"),
                    CSS.decl("font-size", ".94rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__response-field",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("align-content", "center"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--tool-surface)")
                ),

                CSS.rule(
                    ".\(block)__response-field input",
                    CSS.decl("font-weight", "760")
                ),

                CSS.rule(
                    ".\(block)__motivation-grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(2, minmax(0, 1fr))"),
                    CSS.decl("gap", "16px")
                ),

                CSS.rule(
                    ".\(block)__motivation-lane",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("align-content", "start"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "var(--tool-surface)")
                ),

                CSS.rule(
                    ".\(block)__motivation-lane--voordelen",
                    CSS.decl("box-shadow", "inset 6px 0 0 color-mix(in srgb, var(--tool-voordeel) 72%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__motivation-lane--nadelen",
                    CSS.decl("box-shadow", "inset 6px 0 0 color-mix(in srgb, var(--tool-nadeel) 72%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__motivation-lane-head",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("padding", "0 0 12px"),
                    CSS.decl("border-bottom", "1px solid var(--tool-border)")
                ),

                CSS.rule(
                    ".\(block)__motivation-lane-head p",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".09em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__motivation-lane-head h3",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.2rem"),
                    CSS.decl("line-height", "1.12")
                ),

                CSS.rule(
                    ".\(block)__motivation-lane-head span",
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.4"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__bucket-stack",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "12px")
                ),

                CSS.rule(
                    ".\(block)__bucket",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("padding", "12px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-soft) 62%, var(--tool-surface))")
                ),

                CSS.rule(
                    ".\(block)__bucket-head",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "flex-start"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".\(block)__bucket-head p",
                    CSS.decl("margin", "0 0 3px"),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".07em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__bucket-head h4",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".96rem"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".\(block)__bucket-list",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".\(block)__item-row",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) minmax(94px, 126px) 32px"),
                    CSS.decl("gap", "7px"),
                    CSS.decl("align-items", "center")
                ),

                CSS.rule(
                    ".\(block)__strength",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) 20px"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("align-items", "center")
                ),

                CSS.rule(
                    ".\(block)__strength span",
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("color", "var(--tool-muted)")
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
                    CSS.decl("min-width", "86px"),
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
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "var(--tool-surface)")
                ),

                CSS.rule(
                    ".\(block)__button, .\(block)__small-button, .\(block)__remove",
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
                    ".\(block)__small-button, .\(block)__remove",
                    CSS.decl("display", "inline-grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "32px"),
                    CSS.decl("height", "32px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("color", "var(--tool-text)")
                ),

                CSS.rule(
                    ".\(block) input[type=\"range\"]",
                    CSS.decl("width", "100%"),
                    CSS.decl("accent-color", "var(--link-color)")
                ),

                CSS.rule(
                    ".\(block) input:focus-visible, .\(block) button:focus-visible",
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
                        ".\(block)__context-grid, .\(block)__focus-card, .\(block)__motivation-grid, .\(block)__summary",
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        ".\(block)__totals",
                        CSS.decl("justify-content", "flex-start")
                    )
                ),

                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".\(block)__item-row",
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
                        ".\(block)__surface, .\(block)__focus-card, .\(block)__motivation-lane, .\(block)__bucket, .\(block)__summary",
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
            'appetitive-gain': 'voordeel',
            'aversive-relief': 'voordeel',
            'appetitive-loss': 'nadeel',
            'aversive-activation': 'nadeel'
        };

        function text(value) {
            return String(value || '').trim();
        }

        function numeric(value, fallback = 0) {
            const next = Number(value);
            return Number.isFinite(next) ? next : fallback;
        }

        function rowScore(row) {
            const input = row.querySelector('[data-kind-input]');
            const strength = row.querySelector('[data-kind-strength]');
            const valueLabel = row.querySelector('[data-kind-strength-value]');
            const value = numeric(strength?.value, 0);

            if (valueLabel) {
                valueLabel.textContent = String(value);
            }

            return text(input?.value) ? value : 0;
        }

        function totals(root) {
            const result = {
                voordeel: 0,
                nadeel: 0
            };

            root.querySelectorAll('[data-kind-row]').forEach((row) => {
                const kind = row.getAttribute('data-kind-row');
                const pole = kinds[kind];

                if (!pole) return;

                result[pole] += rowScore(row);
            });

            return result;
        }

        function summaryFor(total) {
            if (total.voordeel === 0 && total.nadeel === 0) {
                return {
                    title: 'Vul de concrete voordelen en nadelen in',
                    text: 'De kaart wordt duidelijk zodra je per respons ziet wat deze oplevert, wat ermee stopt, en welke kosten eraan hangen.'
                };
            }

            if (total.voordeel > total.nadeel) {
                return {
                    title: 'De voordelen maken deze reactie logisch',
                    text: 'De respons wordt begrijpelijk omdat hij iets oplevert of iets onaangenaams laat stoppen. Denk bij reactiviteit bijvoorbeeld aan afstand, opluchting, controle of ontlading.'
                };
            }

            if (total.nadeel > total.voordeel) {
                return {
                    title: 'De nadelen kunnen deze reactie remmen',
                    text: 'De respons heeft wel functie, maar brengt ook kosten mee. Daardoor kan alternatief gedrag kansrijker worden wanneer dat dezelfde voordelen geeft met minder nadeel.'
                };
            }

            return {
                title: 'Voordelen en nadelen zijn ongeveer even sterk',
                text: 'Dan kunnen kleine contextfactoren bepalen wat de hond uiteindelijk doet: afstand, spanning, eerdere herhaling, begeleidergedrag of beschikbaar alternatief gedrag.'
            };
        }

        function update(root) {
            if (!root) return;

            const total = totals(root);
            const summary = summaryFor(total);

            Object.entries(total).forEach(([pole, value]) => {
                const node = root.querySelector(`[data-pole-total="${pole}"]`);

                if (node) {
                    node.textContent = String(value);
                }
            });

            const titleNode = root.querySelector('[data-summary-title]');
            const textNode = root.querySelector('[data-summary-text]');

            if (titleNode) {
                titleNode.textContent = summary.title;
            }

            if (textNode) {
                textNode.textContent = summary.text;
            }
        }

        function makeItemRow(kind) {
            const row = document.createElement('div');
            row.className = 'wc-drijfveren-response-map-tool__item-row';
            row.setAttribute('data-kind-row', kind);
            row.setAttribute('data-extra-row', 'true');

            const input = document.createElement('input');
            input.type = 'text';
            input.setAttribute('data-kind-input', kind);

            const strengthWrap = document.createElement('div');
            strengthWrap.className = 'wc-drijfveren-response-map-tool__strength';

            const strength = document.createElement('input');
            strength.type = 'range';
            strength.min = '0';
            strength.max = '5';
            strength.value = '3';
            strength.setAttribute('data-kind-strength', kind);
            strength.setAttribute('aria-label', 'Belang of sterkte');

            const value = document.createElement('span');
            value.setAttribute('data-kind-strength-value', '');
            value.textContent = '3';

            strengthWrap.append(strength, value);

            const remove = document.createElement('button');
            remove.type = 'button';
            remove.className = 'wc-drijfveren-response-map-tool__remove';
            remove.setAttribute('data-kind-remove', '');
            remove.setAttribute('aria-label', 'Verwijder item');
            remove.textContent = '×';

            row.append(input, strengthWrap, remove);

            return row;
        }

        function clearMap(root) {
            root.querySelectorAll('[data-drijfveren-field], [data-kind-input]').forEach((input) => {
                input.value = '';
            });

            root.querySelectorAll('[data-kind-strength]').forEach((input) => {
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
                const addKind = event.target.closest('[data-kind-add]');

                if (addKind) {
                    const kind = addKind.getAttribute('data-kind-add');
                    const list = root.querySelector(`[data-kind-list="${kind}"]`);
                    const row = makeItemRow(kind);

                    list?.appendChild(row);
                    row.querySelector('[data-kind-input]')?.focus();
                    update(root);
                    return;
                }

                const remove = event.target.closest('[data-kind-remove]');

                if (remove) {
                    const row = remove.closest('[data-kind-row]');
                    const list = row?.parentElement;

                    if (list && list.querySelectorAll('[data-kind-row]').length > 1) {
                        row.remove();
                    } else if (row) {
                        row.querySelector('[data-kind-input]').value = '';
                        row.querySelector('[data-kind-strength]').value = '3';
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
            initAll
        };
    })();
    """#
}
