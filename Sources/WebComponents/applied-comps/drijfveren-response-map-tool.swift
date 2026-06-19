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

    var directionLabel: String {
        switch self {
        case .voordeel:
            return "naar toe"

        case .nadeel:
            return "weg van"
        }
    }

    var summaryLabel: String {
        switch self {
        case .voordeel:
            return "Totaal voordeel"

        case .nadeel:
            return "Totaal nadeel"
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

    var shortTitle: String {
        switch self {
        case .appetitiveGain:
            return "+ aantrekker"

        case .aversiveRelief:
            return "- afstoter"

        case .appetitiveLoss:
            return "- aantrekker"

        case .aversiveActivation:
            return "+ afstoter"
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
            return "Bijvoorbeeld: hond weg, ruimte, controle, opluchting als succeservaring"

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
                HTML.text("Breng in kaart welke reacties latent beschikbaar zijn, en waarom één reactie in deze situatie naar voren komt: weg van nadelen, of juist naar voordelen toe.")
            }
        }
    }

    private func toolSurface() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__surface"]) {
            contextFields()

            HTML.div(["class": "\(Self.block)__workspace"]) {
                responsePanel()
                graphPanel()
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

    private func responsePanel() -> any HTMLNode {
        HTML.aside(["class": "\(Self.block)__responses"]) {
            HTML.div(["class": "\(Self.block)__panel-head"]) {
                HTML.p(["class": "\(Self.block)__panel-eyebrow"]) {
                    HTML.text("latent")
                }

                HTML.h2 {
                    HTML.text("Mogelijke reacties")
                }

                HTML.p {
                    HTML.text("Meerdere reacties kunnen beschikbaar zijn. Selecteer de reactie waarvoor je de voordelen en nadelen wilt tekenen.")
                }
            }

            HTML.div(["class": "\(Self.block)__response-list", "data-response-list": ""]) {
                responseRow(
                    id: "response-1",
                    label: "Uitvallen / blaffen",
                    active: true
                )

                responseRow(
                    id: "response-2",
                    label: "Wegkijken / afstand nemen",
                    active: false
                )

                responseRow(
                    id: "response-3",
                    label: "Inchecken bij begeleider",
                    active: false
                )
            }

            HTML.button(
                [
                    "type": "button",
                    "class": "\(Self.block)__button \(Self.block)__button--secondary",
                    "data-response-add": ""
                ]
            ) {
                HTML.text("Reactie toevoegen")
            }
        }
    }

    private func responseRow(
        id: String,
        label: String,
        active: Bool
    ) -> any HTMLNode {
        var className = "\(Self.block)__response-row"

        if active {
            className += " \(Self.block)__response-row--active"
        }

        return HTML.div(
            [
                "class": className,
                "data-response-row": id
            ]
        ) {
            HTML.button(
                [
                    "type": "button",
                    "class": "\(Self.block)__response-select",
                    "data-response-select": id,
                    "aria-label": "Selecteer reactie"
                ]
            ) {
                HTML.text("Kies")
            }

            HTML.input([
                "type": "text",
                "value": label,
                "data-response-label": id,
                "aria-label": "Respons"
            ])

            HTML.label(["class": "\(Self.block)__response-salience"]) {
                HTML.span {
                    HTML.text("salientie")
                }

                HTML.input([
                    "type": "range",
                    "min": "0",
                    "max": "5",
                    "value": active ? "4" : "2",
                    "data-response-salience": id
                ])
            }
        }
    }

    private func graphPanel() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__graph-panel"]) {
            HTML.div(["class": "\(Self.block)__graph-head"]) {
                HTML.div {
                    HTML.p(["class": "\(Self.block)__panel-eyebrow"]) {
                        HTML.text("gekozen respons")
                    }

                    HTML.h2 {
                        HTML.span(["data-active-response-label": ""]) {
                            HTML.text("Uitvallen / blaffen")
                        }
                    }
                }

                HTML.div(["class": "\(Self.block)__score-strip"]) {
                    scorePill(.voordeel)
                    scorePill(.nadeel)
                }
            }

            HTML.div(["class": "\(Self.block)__graph"]) {
                poleColumn(.nadeel)
                centerNode()
                poleColumn(.voordeel)
            }

            summary()
        }
    }

    private func scorePill(
        _ pole: DrijfverenResponseMapPole
    ) -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__score \(Self.block)__score--\(pole.rawValue)"]) {
            HTML.span {
                HTML.text(pole.summaryLabel)
            }

            HTML.strong(["data-pole-total": pole.rawValue]) {
                HTML.text("0")
            }
        }
    }

    private func poleColumn(
        _ pole: DrijfverenResponseMapPole
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "\(Self.block)__pole \(Self.block)__pole--\(pole.rawValue)",
                "data-pole": pole.rawValue
            ]
        ) {
            HTML.div(["class": "\(Self.block)__pole-head"]) {
                HTML.p {
                    HTML.text(pole.directionLabel)
                }

                HTML.h3 {
                    HTML.text(pole.title)
                }
            }

            for kind in DrijfverenResponseMapKind.allCases where kind.pole == pole {
                bucket(kind)
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
                        "data-kind-add": kind.rawValue
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

    private func centerNode() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__center"]) {
            HTML.div(["class": "\(Self.block)__arrow \(Self.block)__arrow--away"]) {
                HTML.span {
                    HTML.text("weg van")
                }
            }

            HTML.div(["class": "\(Self.block)__dog-node"]) {
                HTML.p {
                    HTML.text("hond")
                }

                HTML.strong(["data-center-response-label": ""]) {
                    HTML.text("Uitvallen / blaffen")
                }

                HTML.span(["data-center-context-label": ""]) {
                    HTML.text("in deze omstandigheid")
                }
            }

            HTML.div(["class": "\(Self.block)__arrow \(Self.block)__arrow--toward"]) {
                HTML.span {
                    HTML.text("naar toe")
                }
            }
        }
    }

    private func summary() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__summary"]) {
            HTML.div(["class": "\(Self.block)__balance"]) {
                HTML.div(["class": "\(Self.block)__balance-fill"]) {}
            }

            HTML.div {
                HTML.p(["class": "\(Self.block)__summary-eyebrow"]) {
                    HTML.text("interpretatie")
                }

                HTML.h3(["data-summary-title": ""]) {
                    HTML.text("Vul de concrete voordelen en nadelen in")
                }

                HTML.p(["data-summary-text": ""]) {
                    HTML.text("De gekozen reactie wordt begrijpelijker wanneer zichtbaar wordt wat deze oplevert, voorkomt, verliest of activeert.")
                }
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
                    CSS.decl("--tool-balance", "50%"),
                    CSS.decl("width", "min(1180px, calc(100% - 48px))"),
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
                    CSS.decl("max-width", "920px"),
                    CSS.decl("margin", "0 0 32px")
                ),

                CSS.rule(
                    ".\(block)__eyebrow, .\(block)__panel-eyebrow",
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
                    CSS.decl("max-width", "820px"),
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
                    ".\(block)__field span",
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
                    ".\(block)__workspace",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(260px, .34fr) minmax(0, .66fr)"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("align-items", "start")
                ),

                CSS.rule(
                    ".\(block)__responses, .\(block)__graph-panel, .\(block)__actions",
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "var(--tool-surface)")
                ),

                CSS.rule(
                    ".\(block)__responses, .\(block)__graph-panel",
                    CSS.decl("padding", "18px")
                ),

                CSS.rule(
                    ".\(block)__panel-head h2, .\(block)__graph-head h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.25rem"),
                    CSS.decl("line-height", "1.15")
                ),

                CSS.rule(
                    ".\(block)__panel-head p:not(.\(block)__panel-eyebrow)",
                    CSS.decl("margin", "8px 0 0"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__response-list",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("margin", "16px 0")
                ),

                CSS.rule(
                    ".\(block)__response-row",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "auto minmax(0, 1fr)"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("padding", "10px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-soft) 65%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__response-row--active",
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 48%, var(--tool-border))"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 10%, var(--tool-surface))")
                ),

                CSS.rule(
                    ".\(block)__response-select",
                    CSS.decl("grid-row", "span 2"),
                    CSS.decl("align-self", "stretch"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("color", "var(--tool-text)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(block)__response-salience",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "auto minmax(0, 1fr)"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("align-items", "center")
                ),

                CSS.rule(
                    ".\(block)__response-salience span",
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__graph-head",
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("align-items", "flex-start"),
                    CSS.decl("margin-bottom", "16px")
                ),

                CSS.rule(
                    ".\(block)__score-strip",
                    CSS.decl("display", "flex"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("justify-content", "flex-end")
                ),

                CSS.rule(
                    ".\(block)__score",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "2px"),
                    CSS.decl("min-width", "94px"),
                    CSS.decl("padding", "8px 10px"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "var(--tool-soft)")
                ),

                CSS.rule(
                    ".\(block)__score span",
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".06em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__score strong",
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", "1rem")
                ),

                CSS.rule(
                    ".\(block)__score--voordeel strong",
                    CSS.decl("color", "var(--tool-voordeel)")
                ),

                CSS.rule(
                    ".\(block)__score--nadeel strong",
                    CSS.decl("color", "var(--tool-nadeel)")
                ),

                CSS.rule(
                    ".\(block)__graph",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) minmax(180px, 220px) minmax(0, 1fr)"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("align-items", "stretch")
                ),

                CSS.rule(
                    ".\(block)__pole",
                    CSS.decl("display", "grid"),
                    CSS.decl("align-content", "start"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__pole-head",
                    CSS.decl("padding", "14px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--tool-soft)")
                ),

                CSS.rule(
                    ".\(block)__pole-head p",
                    CSS.decl("margin", "0 0 4px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".09em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__pole-head h3",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.05rem")
                ),

                CSS.rule(
                    ".\(block)__pole--voordeel .\(block)__pole-head",
                    CSS.decl("box-shadow", "inset 5px 0 0 color-mix(in srgb, var(--tool-voordeel) 72%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__pole--nadeel .\(block)__pole-head",
                    CSS.decl("box-shadow", "inset 5px 0 0 color-mix(in srgb, var(--tool-nadeel) 72%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__bucket",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("padding", "12px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--tool-surface)")
                ),

                CSS.rule(
                    ".\(block)__bucket-head",
                    CSS.decl("display", "flex"),
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
                    CSS.decl("font-size", ".92rem"),
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
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) minmax(92px, 124px) 32px"),
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
                    ".\(block)__center",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-rows", "1fr auto 1fr"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-items", "center"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("min-height", "420px")
                ),

                CSS.rule(
                    ".\(block)__dog-node",
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("width", "100%"),
                    CSS.decl("min-height", "166px"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--link-color) 40%, var(--tool-border))"),
                    CSS.decl("border-radius", "28px"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 10%, var(--tool-surface))"),
                    CSS.decl("text-align", "center")
                ),

                CSS.rule(
                    ".\(block)__dog-node p",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".1em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__dog-node strong",
                    CSS.decl("font-size", "1.08rem"),
                    CSS.decl("line-height", "1.16")
                ),

                CSS.rule(
                    ".\(block)__dog-node span",
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("line-height", "1.35"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__arrow",
                    CSS.decl("position", "relative"),
                    CSS.decl("width", "100%"),
                    CSS.decl("min-height", "74px"),
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center")
                ),

                CSS.rule(
                    ".\(block)__arrow::before",
                    CSS.decl("content", "''"),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "16px"),
                    CSS.decl("right", "16px"),
                    CSS.decl("top", "50%"),
                    CSS.decl("height", "2px"),
                    CSS.decl("background", "var(--tool-border)")
                ),

                CSS.rule(
                    ".\(block)__arrow::after",
                    CSS.decl("content", "''"),
                    CSS.decl("position", "absolute"),
                    CSS.decl("top", "calc(50% - 5px)"),
                    CSS.decl("width", "10px"),
                    CSS.decl("height", "10px"),
                    CSS.decl("border-top", "2px solid var(--tool-border)"),
                    CSS.decl("border-right", "2px solid var(--tool-border)")
                ),

                CSS.rule(
                    ".\(block)__arrow--toward::after",
                    CSS.decl("right", "14px"),
                    CSS.decl("transform", "rotate(45deg)")
                ),

                CSS.rule(
                    ".\(block)__arrow--away::after",
                    CSS.decl("left", "14px"),
                    CSS.decl("transform", "rotate(225deg)")
                ),

                CSS.rule(
                    ".\(block)__arrow span",
                    CSS.decl("position", "relative"),
                    CSS.decl("z-index", "1"),
                    CSS.decl("padding", "4px 8px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__summary",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("margin-top", "16px"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--tool-soft)")
                ),

                CSS.rule(
                    ".\(block)__balance",
                    CSS.decl("height", "16px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-nadeel) 70%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__balance-fill",
                    CSS.decl("width", "var(--tool-balance)"),
                    CSS.decl("height", "100%"),
                    CSS.decl("border-radius", "inherit"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-voordeel) 72%, transparent)"),
                    CSS.decl("transition", "width .16s ease")
                ),

                CSS.rule(
                    ".\(block)__summary-eyebrow",
                    CSS.decl("margin", "0 0 4px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".09em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
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
                    ".\(block)__actions",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("margin-top", "18px"),
                    CSS.decl("padding", "18px")
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
                        ".\(block)__context-grid, .\(block)__workspace, .\(block)__graph",
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        ".\(block)__center",
                        CSS.decl("grid-template-rows", "auto auto auto"),
                        CSS.decl("min-height", "0")
                    ),
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
                        ".\(block)__surface, .\(block)__responses, .\(block)__graph-panel, .\(block)__field, .\(block)__bucket, .\(block)__dog-node, .\(block)__summary",
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

        function activeID(root) {
            return root.getAttribute('data-active-response') || 'response-1';
        }

        function activeLabel(root) {
            const id = activeID(root);
            const input = root.querySelector(`[data-response-label="${id}"]`);

            return text(input?.value) || 'Geselecteerde reactie';
        }

        function circumstanceLabel(root) {
            const input = root.querySelector('[data-drijfveren-field="circumstance"]');
            return text(input?.value) || 'in deze omstandigheid';
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
                    text: 'De gekozen reactie wordt begrijpelijker wanneer zichtbaar wordt wat deze oplevert, voorkomt, verliest of activeert.'
                };
            }

            if (total.voordeel > total.nadeel) {
                return {
                    title: 'Deze reactie wordt naar voren getrokken door voordeel',
                    text: 'De ingevulde voordelen zijn sterker dan de nadelen. De respons beweegt vooral naar toegang, controle, opluchting of een ander belangrijk gevolg toe.'
                };
            }

            if (total.nadeel > total.voordeel) {
                return {
                    title: 'Deze reactie wordt geremd door nadeel',
                    text: 'De ingevulde nadelen zijn sterker dan de voordelen. De respons kan verdwijnen, afzwakken of plaatsmaken voor een andere latente reactie.'
                };
            }

            return {
                title: 'Voordelen en nadelen houden elkaar in balans',
                text: 'Kleine verschillen in context, afstand, behoefte, eerdere ervaring of alternatief gedrag kunnen bepalen welke reactie uiteindelijk prominent wordt.'
            };
        }

        function updateResponseRows(root) {
            const id = activeID(root);

            root.querySelectorAll('[data-response-row]').forEach((row) => {
                row.classList.toggle(
                    'wc-drijfveren-response-map-tool__response-row--active',
                    row.getAttribute('data-response-row') === id
                );
            });
        }

        function update(root) {
            if (!root) return;

            updateResponseRows(root);

            const label = activeLabel(root);
            const context = circumstanceLabel(root);
            const total = totals(root);
            const all = total.voordeel + total.nadeel;
            const share = all > 0
                ? Math.round((total.voordeel / all) * 100)
                : 50;
            const summary = summaryFor(total);

            root.style.setProperty('--tool-balance', `${share}%`);

            root.querySelectorAll('[data-active-response-label], [data-center-response-label]').forEach((node) => {
                node.textContent = label;
            });

            root.querySelectorAll('[data-center-context-label]').forEach((node) => {
                node.textContent = context;
            });

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

        function makeResponseRow(root) {
            const count = root.querySelectorAll('[data-response-row]').length + 1;
            const id = `response-${Date.now()}-${count}`;

            const row = document.createElement('div');
            row.className = 'wc-drijfveren-response-map-tool__response-row';
            row.setAttribute('data-response-row', id);

            const select = document.createElement('button');
            select.type = 'button';
            select.className = 'wc-drijfveren-response-map-tool__response-select';
            select.setAttribute('data-response-select', id);
            select.setAttribute('aria-label', 'Selecteer reactie');
            select.textContent = 'Kies';

            const label = document.createElement('input');
            label.type = 'text';
            label.value = `Reactie ${count}`;
            label.setAttribute('data-response-label', id);
            label.setAttribute('aria-label', 'Respons');

            const salience = document.createElement('label');
            salience.className = 'wc-drijfveren-response-map-tool__response-salience';

            const salienceText = document.createElement('span');
            salienceText.textContent = 'salientie';

            const salienceInput = document.createElement('input');
            salienceInput.type = 'range';
            salienceInput.min = '0';
            salienceInput.max = '5';
            salienceInput.value = '2';
            salienceInput.setAttribute('data-response-salience', id);

            salience.append(salienceText, salienceInput);
            row.append(select, label, salience);

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
                const select = event.target.closest('[data-response-select]');
                if (select) {
                    root.setAttribute('data-active-response', select.getAttribute('data-response-select'));
                    update(root);
                    return;
                }

                const addResponse = event.target.closest('[data-response-add]');
                if (addResponse) {
                    const list = root.querySelector('[data-response-list]');
                    const row = makeResponseRow(root);

                    list?.appendChild(row);
                    root.setAttribute('data-active-response', row.getAttribute('data-response-row'));
                    row.querySelector('[data-response-label]')?.focus();
                    update(root);
                    return;
                }

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
