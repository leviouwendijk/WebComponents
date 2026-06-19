import Constructors
import CSS
import HTML
import JS

public enum DrijfverenOutcomeSide: String, Sendable, CaseIterable {
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

    var subtitle: String {
        switch self {
        case .voordeel:
            return "Wat maakt deze keuze waarschijnlijker?"

        case .nadeel:
            return "Wat maakt deze keuze minder waarschijnlijk?"
        }
    }

    var scoreLabel: String {
        switch self {
        case .voordeel:
            return "Totaal voordeel"

        case .nadeel:
            return "Totaal nadeel"
        }
    }
}

public enum DrijfverenItemKind: String, Sendable, CaseIterable {
    case appetitiveGain = "appetitive-gain"
    case aversiveRelief = "aversive-relief"
    case appetitiveLoss = "appetitive-loss"
    case aversiveActivation = "aversive-activation"

    var side: DrijfverenOutcomeSide {
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
            return "Aantrekker erbij"

        case .aversiveRelief:
            return "Afstoter weg"

        case .appetitiveLoss:
            return "Aantrekker weg"

        case .aversiveActivation:
            return "Afstoter erbij"
        }
    }

    var eyebrow: String {
        switch self {
        case .appetitiveGain:
            return "toegang / winst"

        case .aversiveRelief:
            return "vermijding / verlichting"

        case .appetitiveLoss:
            return "verlies / blokkade"

        case .aversiveActivation:
            return "druk / ongemak"
        }
    }

    var placeholder: String {
        switch self {
        case .appetitiveGain:
            return "Bijvoorbeeld: snuffelen, voer, spel, sociale toegang"

        case .aversiveRelief:
            return "Bijvoorbeeld: afstand, rust, minder druk, ontsnapping"

        case .appetitiveLoss:
            return "Bijvoorbeeld: minder vrijheid, geen toegang, spel stopt"

        case .aversiveActivation:
            return "Bijvoorbeeld: spanning, correctie, frustratie, confrontatie"
        }
    }

    var printLabel: String {
        switch self {
        case .appetitiveGain:
            return "Voordeel: toegang tot aantrekker"

        case .aversiveRelief:
            return "Voordeel: verlichting van afstoter"

        case .appetitiveLoss:
            return "Nadeel: verlies van aantrekker"

        case .aversiveActivation:
            return "Nadeel: activatie van afstoter"
        }
    }
}

public struct DrijfverenMapTool: ReusableComponent, Sendable {
    public static let block = "wc-drijfveren-map-tool"

    public let id: String
    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        id: String = "drijfveren-map-tool",
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
                        "data-drijfveren-map-tool": "",
                        "data-drijfveren-state": "balanced"
                    ]
                ) {
                    hero()
                    mapSurface()
                    workbench()
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : [],
            scripts: includeScript ? DrijfverenMapToolScript().nodes.scripts : []
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
                HTML.text("Teken een concrete omstandigheid uit aan de hand van voordelen en nadelen: toegang tot aantrekkers, verlichting van afstoters, verlies van aantrekkers en activatie van afstoters.")
            }
        }
    }

    private func mapSurface() -> any HTMLNode {
        HTML.section(
            [
                "class": "\(Self.block)__surface",
                "aria-label": "Drijfverenkaart: omstandigheden, keuze, voordelen en nadelen."
            ]
        ) {
            HTML.div(["class": "\(Self.block)__context-grid"]) {
                textField(
                    label: "Omstandigheid",
                    field: "circumstance",
                    placeholder: "Bijvoorbeeld: andere hond komt dichterbij"
                )

                textField(
                    label: "Keuze / gedrag",
                    field: "choice",
                    placeholder: "Bijvoorbeeld: blaffen, uitvallen, inchecken, wegkijken"
                )

                textField(
                    label: "Toestand",
                    field: "state",
                    placeholder: "Bijvoorbeeld: hongerig, gespannen, moe, hoog in opwinding"
                )
            }

            HTML.div(["class": "\(Self.block)__drawing"]) {
                HTML.div(["class": "\(Self.block)__center-card"]) {
                    HTML.p(["class": "\(Self.block)__center-eyebrow"]) {
                        HTML.text("situatie")
                    }

                    HTML.div(["class": "\(Self.block)__center-title", "data-drijfveren-live-title": ""]) {
                        HTML.text("Welke uitkomst verwacht de hond?")
                    }

                    HTML.p(["class": "\(Self.block)__center-text", "data-drijfveren-live-choice": ""]) {
                        HTML.text("Vul de omstandigheid en keuze in; voeg daarna concrete voordelen en nadelen toe.")
                    }
                }

                HTML.div(["class": "\(Self.block)__columns"]) {
                    outcomeColumn(.voordeel)
                    outcomeColumn(.nadeel)
                }

                summaryPanel()
            }
        }
    }

    private func textField(
        label: String,
        field: String,
        placeholder: String
    ) -> any HTMLNode {
        let inputID = "\(id)-\(field)"

        return HTML.label(
            [
                "class": "\(Self.block)__context-field",
                "for": inputID
            ]
        ) {
            HTML.span {
                HTML.text(label)
            }

            HTML.input([
                "id": inputID,
                "type": "text",
                "placeholder": placeholder,
                "data-drijfveren-field": field
            ])
        }
    }

    private func outcomeColumn(
        _ side: DrijfverenOutcomeSide
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "\(Self.block)__column \(Self.block)__column--\(side.rawValue)",
                "data-drijfveren-side": side.rawValue
            ]
        ) {
            HTML.div(["class": "\(Self.block)__column-head"]) {
                HTML.div {
                    HTML.h2 {
                        HTML.text(side.title)
                    }

                    HTML.p {
                        HTML.text(side.subtitle)
                    }
                }

                HTML.span(["class": "\(Self.block)__score-pill"]) {
                    HTML.span(["data-drijfveren-total": side.rawValue]) {
                        HTML.text("0")
                    }
                }
            }

            for kind in DrijfverenItemKind.allCases where kind.side == side {
                itemCard(kind)
            }
        }
    }

    private func itemCard(
        _ kind: DrijfverenItemKind
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "\(Self.block)__item-card \(Self.block)__item-card--\(kind.side.rawValue)",
                "data-drijfveren-kind": kind.rawValue
            ]
        ) {
            HTML.div(["class": "\(Self.block)__item-head"]) {
                HTML.div {
                    HTML.p(["class": "\(Self.block)__item-eyebrow"]) {
                        HTML.text(kind.eyebrow)
                    }

                    HTML.h3 {
                        HTML.text(kind.title)
                    }
                }

                HTML.button(
                    [
                        "type": "button",
                        "class": "\(Self.block)__small-button",
                        "data-drijfveren-add": kind.rawValue
                    ]
                ) {
                    HTML.text("Toevoegen")
                }
            }

            HTML.div(["class": "\(Self.block)__item-list", "data-drijfveren-list": kind.rawValue]) {
                itemRow(kind)
            }
        }
    }

    private func itemRow(
        _ kind: DrijfverenItemKind
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "\(Self.block)__item-row",
                "data-drijfveren-row": kind.rawValue
            ]
        ) {
            HTML.input([
                "type": "text",
                "placeholder": kind.placeholder,
                "aria-label": kind.printLabel,
                "data-drijfveren-input": kind.rawValue
            ])

            HTML.div(["class": "\(Self.block)__strength"]) {
                HTML.input([
                    "type": "range",
                    "min": "0",
                    "max": "5",
                    "value": "3",
                    "aria-label": "Sterkte",
                    "data-drijfveren-strength": kind.rawValue
                ])

                HTML.span(["data-drijfveren-strength-value": ""]) {
                    HTML.text("3")
                }
            }

            HTML.button(
                [
                    "type": "button",
                    "class": "\(Self.block)__remove",
                    "aria-label": "Verwijder regel",
                    "data-drijfveren-remove": ""
                ]
            ) {
                HTML.text("×")
            }
        }
    }

    private func summaryPanel() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__summary"]) {
            HTML.div(["class": "\(Self.block)__balance-bar", "aria-hidden": "true"]) {
                HTML.div(["class": "\(Self.block)__balance-fill"]) {}
            }

            HTML.div(["class": "\(Self.block)__summary-copy"]) {
                HTML.p(["class": "\(Self.block)__summary-label"]) {
                    HTML.text("Balans")
                }

                HTML.p(["class": "\(Self.block)__summary-title", "data-drijfveren-balance-title": ""]) {
                    HTML.text("Nog geen concrete drijfveren ingevuld")
                }

                HTML.p(["class": "\(Self.block)__summary-text", "data-drijfveren-balance-text": ""]) {
                    HTML.text("Voeg per subtype toe wat de hond verkrijgt, vermijdt, verliest of juist erbij krijgt.")
                }
            }
        }
    }

    private func workbench() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__workbench"]) {
            HTML.div(["class": "\(Self.block)__actions"]) {
                HTML.button(
                    [
                        "type": "button",
                        "class": "\(Self.block)__button \(Self.block)__button--secondary",
                        "data-drijfveren-clear": ""
                    ]
                ) {
                    HTML.text("Nieuwe kaart")
                }

                HTML.button(
                    [
                        "type": "button",
                        "class": "\(Self.block)__button",
                        "data-drijfveren-print": ""
                    ]
                ) {
                    HTML.text("Print / bewaar als PDF")
                }
            }

            HTML.div(["class": "\(Self.block)__legend"]) {
                legendItem("Voordeel", "toegang tot aantrekker of verlichting van afstoter")
                legendItem("Nadeel", "verlies van aantrekker of activatie van afstoter")
                legendItem("Sterkte", "0 tot 5, alleen meegeteld wanneer de regel tekst bevat")
            }
        }
    }

    private func legendItem(
        _ title: String,
        _ text: String
    ) -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__legend-item"]) {
            HTML.strong {
                HTML.text(title)
            }

            HTML.span {
                HTML.text(text)
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        let block = Self.block

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("--tool-surface", "var(--surface-color, #ffffff)"),
                    CSS.decl("--tool-soft", "var(--surface-soft-color, #f3f4f6)"),
                    CSS.decl("--tool-border", "var(--border-color, rgba(0, 0, 0, .12))"),
                    CSS.decl("--tool-text", "var(--text-color, #222222)"),
                    CSS.decl("--tool-muted", "var(--muted-text-color, rgba(0, 0, 0, .62))"),
                    CSS.decl("--tool-voordeel", "var(--success, #2E8B57)"),
                    CSS.decl("--tool-nadeel", "var(--danger, #D64545)"),
                    CSS.decl("--drijfveren-voordeel-share", "50%"),
                    CSS.decl("width", "min(1180px, calc(100% - 48px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "58px 0 92px"),
                    CSS.decl("box-sizing", "border-box"),
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
                    ".\(block)__eyebrow",
                    CSS.decl("margin", "0 0 10px"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".12em"),
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
                    ".\(block)__context-field",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--tool-surface)")
                ),

                CSS.rule(
                    ".\(block)__context-field span",
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
                    ".\(block)__drawing",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "var(--tool-soft)")
                ),

                CSS.rule(
                    ".\(block)__center-card",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "20px"),
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("text-align", "center")
                ),

                CSS.rule(
                    ".\(block)__center-eyebrow",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".09em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__center-title",
                    CSS.decl("font-size", "1.22rem"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("line-height", "1.15")
                ),

                CSS.rule(
                    ".\(block)__center-text",
                    CSS.decl("max-width", "720px"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("font-size", ".95rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__columns",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(2, minmax(0, 1fr))"),
                    CSS.decl("gap", "14px")
                ),

                CSS.rule(
                    ".\(block)__column",
                    CSS.decl("display", "grid"),
                    CSS.decl("align-content", "start"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__column-head",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "flex-start"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--tool-surface)")
                ),

                CSS.rule(
                    ".\(block)__column-head h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.15rem"),
                    CSS.decl("line-height", "1.15")
                ),

                CSS.rule(
                    ".\(block)__column-head p",
                    CSS.decl("margin", "5px 0 0"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.35"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__score-pill",
                    CSS.decl("display", "inline-grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("min-width", "42px"),
                    CSS.decl("height", "32px"),
                    CSS.decl("padding", "0 10px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-text) 8%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__column--voordeel .\(block)__score-pill",
                    CSS.decl("color", "var(--tool-voordeel)"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-voordeel) 12%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__column--nadeel .\(block)__score-pill",
                    CSS.decl("color", "var(--tool-nadeel)"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-nadeel) 12%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__item-card",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--tool-surface)")
                ),

                CSS.rule(
                    ".\(block)__item-card--voordeel",
                    CSS.decl("box-shadow", "inset 5px 0 0 color-mix(in srgb, var(--tool-voordeel) 72%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__item-card--nadeel",
                    CSS.decl("box-shadow", "inset 5px 0 0 color-mix(in srgb, var(--tool-nadeel) 72%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__item-head",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "flex-start"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "12px")
                ),

                CSS.rule(
                    ".\(block)__item-eyebrow",
                    CSS.decl("margin", "0 0 4px"),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__item-head h3",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".98rem"),
                    CSS.decl("line-height", "1.15")
                ),

                CSS.rule(
                    ".\(block)__item-list",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "9px")
                ),

                CSS.rule(
                    ".\(block)__item-row",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) minmax(116px, 160px) 34px"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".\(block)__strength",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) 22px"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "7px")
                ),

                CSS.rule(
                    ".\(block)__strength input",
                    CSS.decl("width", "100%"),
                    CSS.decl("accent-color", "var(--link-color)")
                ),

                CSS.rule(
                    ".\(block)__strength span",
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("color", "var(--tool-muted)"),
                    CSS.decl("text-align", "right")
                ),

                CSS.rule(
                    ".\(block)__small-button, .\(block)__button, .\(block)__remove",
                    CSS.decl("appearance", "none"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(block)__small-button",
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("padding", "7px 10px"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 9%, transparent)"),
                    CSS.decl("color", "var(--link-color)")
                ),

                CSS.rule(
                    ".\(block)__remove",
                    CSS.decl("width", "34px"),
                    CSS.decl("height", "34px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__summary",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--tool-surface)")
                ),

                CSS.rule(
                    ".\(block)__balance-bar",
                    CSS.decl("height", "16px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-nadeel) 72%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__balance-fill",
                    CSS.decl("width", "var(--drijfveren-voordeel-share)"),
                    CSS.decl("height", "100%"),
                    CSS.decl("border-radius", "inherit"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-voordeel) 72%, transparent)"),
                    CSS.decl("transition", "width .16s ease")
                ),

                CSS.rule(
                    ".\(block)__summary-copy",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px")
                ),

                CSS.rule(
                    ".\(block)__summary-label",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".09em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__summary-title",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-weight", "850")
                ),

                CSS.rule(
                    ".\(block)__summary-text",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__workbench",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, .42fr) minmax(0, .58fr)"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("margin-top", "18px")
                ),

                CSS.rule(
                    ".\(block)__actions, .\(block)__legend",
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "20px"),
                    CSS.decl("background", "var(--tool-surface)")
                ),

                CSS.rule(
                    ".\(block)__actions",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "9px")
                ),

                CSS.rule(
                    ".\(block)__button",
                    CSS.decl("border-color", "var(--tool-text)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--tool-text)"),
                    CSS.decl("color", "var(--background-color, #ffffff)"),
                    CSS.decl("padding", "9px 13px")
                ),

                CSS.rule(
                    ".\(block)__button--secondary",
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("color", "var(--tool-text)")
                ),

                CSS.rule(
                    ".\(block)__legend",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".\(block)__legend-item",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "2px")
                ),

                CSS.rule(
                    ".\(block)__legend-item strong",
                    CSS.decl("font-size", ".86rem")
                ),

                CSS.rule(
                    ".\(block)__legend-item span",
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.4"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block) input:focus-visible, .\(block) button:focus-visible",
                    CSS.decl("outline", "2px solid var(--link-color)"),
                    CSS.decl("outline-offset", "3px")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 920px)",
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("width", "calc(100% - 32px)"),
                        CSS.decl("padding", "44px 0 78px")
                    ),
                    CSS.rule(
                        ".\(block)__context-grid, .\(block)__columns, .\(block)__workbench",
                        CSS.decl("grid-template-columns", "1fr")
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
                        CSS.decl("background", "#ffffff !important"),
                        CSS.decl("color", "#111827 !important")
                    ),
                    CSS.rule(
                        ".hm-docs-app--tool header, .hm-docs-app--tool nav, .hm-docs-app--tool .wc-docs-project-context-nav, .hm-docs-app--tool .wc-docs-mobile-navigation-drawer, .\(block)__workbench",
                        CSS.decl("display", "none !important")
                    ),
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("--tool-surface", "#ffffff"),
                        CSS.decl("--tool-soft", "#f8fafc"),
                        CSS.decl("--tool-border", "#cbd5e1"),
                        CSS.decl("--tool-text", "#111827"),
                        CSS.decl("--tool-muted", "#475569"),
                        CSS.decl("--tool-voordeel", "#2E8B57"),
                        CSS.decl("--tool-nadeel", "#D64545"),
                        CSS.decl("color-scheme", "light"),
                        CSS.decl("width", "100%"),
                        CSS.decl("padding", "0"),
                        CSS.decl("margin", "0"),
                        CSS.decl("background", "#ffffff"),
                        CSS.decl("color", "#111827")
                    ),
                    CSS.rule(
                        ".\(block), .\(block) *",
                        CSS.decl("-webkit-print-color-adjust", "exact"),
                        CSS.decl("print-color-adjust", "exact")
                    ),
                    CSS.rule(
                        ".\(block)__hero",
                        CSS.decl("margin", "0 0 18px")
                    ),
                    CSS.rule(
                        ".\(block)__lead, .\(block)__eyebrow, .\(block)__context-field span, .\(block)__item-eyebrow, .\(block)__summary-label",
                        CSS.decl("color", "#475569")
                    ),
                    CSS.rule(
                        ".\(block)__surface, .\(block)__drawing, .\(block)__context-field, .\(block)__center-card, .\(block)__column-head, .\(block)__item-card, .\(block)__summary",
                        CSS.decl("background", "#ffffff"),
                        CSS.decl("border-color", "#cbd5e1"),
                        CSS.decl("box-shadow", "none"),
                        CSS.decl("break-inside", "avoid")
                    ),
                    CSS.rule(
                        ".\(block)__drawing",
                        CSS.decl("background", "#f8fafc")
                    ),
                    CSS.rule(
                        ".\(block)__context-grid, .\(block)__columns",
                        CSS.decl("break-inside", "avoid")
                    ),
                    CSS.rule(
                        ".\(block) input[type=\"text\"]",
                        CSS.decl("background", "#ffffff"),
                        CSS.decl("color", "#111827"),
                        CSS.decl("border-color", "#cbd5e1")
                    )
                )
            ]
        )
    }
}

public struct DrijfverenMapToolScript: ReusableComponent {
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
        if (window.wcDrijfverenMapTool?.initialized) return;

        const rootSelector = '[data-drijfveren-map-tool]';

        const meta = {
            'appetitive-gain': {
                side: 'voordeel',
                placeholder: 'Bijvoorbeeld: snuffelen, voer, spel, sociale toegang'
            },
            'aversive-relief': {
                side: 'voordeel',
                placeholder: 'Bijvoorbeeld: afstand, rust, minder druk, ontsnapping'
            },
            'appetitive-loss': {
                side: 'nadeel',
                placeholder: 'Bijvoorbeeld: minder vrijheid, geen toegang, spel stopt'
            },
            'aversive-activation': {
                side: 'nadeel',
                placeholder: 'Bijvoorbeeld: spanning, correctie, frustratie, confrontatie'
            }
        };

        function text(value) {
            return String(value || '').trim();
        }

        function numeric(value, fallback = 0) {
            const next = Number(value);
            return Number.isFinite(next) ? next : fallback;
        }

        function field(root, name) {
            return root.querySelector(`[data-drijfveren-field="${name}"]`);
        }

        function fieldValue(root, name) {
            return text(field(root, name)?.value);
        }

        function rowValue(row) {
            const input = row.querySelector('[data-drijfveren-input]');
            const strength = row.querySelector('[data-drijfveren-strength]');
            const label = row.querySelector('[data-drijfveren-strength-value]');

            const value = numeric(strength?.value, 0);

            if (label) {
                label.textContent = String(value);
            }

            return text(input?.value) ? value : 0;
        }

        function totals(root) {
            const result = {
                voordeel: 0,
                nadeel: 0
            };

            root.querySelectorAll('[data-drijfveren-row]').forEach((row) => {
                const kind = row.getAttribute('data-drijfveren-row');
                const side = meta[kind]?.side;

                if (!side) return;

                result[side] += rowValue(row);
            });

            return result;
        }

        function balanceText(voordeel, nadeel) {
            if (voordeel === 0 && nadeel === 0) {
                return {
                    state: 'balanced',
                    title: 'Nog geen concrete drijfveren ingevuld',
                    text: 'Voeg per subtype toe wat de hond verkrijgt, vermijdt, verliest of juist erbij krijgt.'
                };
            }

            if (voordeel > nadeel) {
                return {
                    state: 'voordeel',
                    title: 'Voordeel overheerst in deze kaart',
                    text: 'De ingevulde uitkomsten maken deze keuze in deze omstandigheid waarschijnlijker.'
                };
            }

            if (nadeel > voordeel) {
                return {
                    state: 'nadeel',
                    title: 'Nadeel overheerst in deze kaart',
                    text: 'De ingevulde uitkomsten maken deze keuze in deze omstandigheid minder aantrekkelijk of minder waarschijnlijk.'
                };
            }

            return {
                state: 'balanced',
                title: 'Voordeel en nadeel zijn in balans',
                text: 'De uitkomst kan kantelen door context, intensiteit, timing, behoefte, eerdere ervaring of beschikbare alternatieven.'
            };
        }

        function updateLiveContext(root) {
            const circumstance = fieldValue(root, 'circumstance');
            const choice = fieldValue(root, 'choice');
            const state = fieldValue(root, 'state');

            const title = root.querySelector('[data-drijfveren-live-title]');
            const choiceNode = root.querySelector('[data-drijfveren-live-choice]');

            if (title) {
                title.textContent = circumstance || 'Welke uitkomst verwacht de hond?';
            }

            if (choiceNode) {
                const parts = [];

                if (choice) {
                    parts.push(`Keuze: ${choice}`);
                }

                if (state) {
                    parts.push(`Toestand: ${state}`);
                }

                choiceNode.textContent = parts.length
                    ? parts.join(' · ')
                    : 'Vul de omstandigheid en keuze in; voeg daarna concrete voordelen en nadelen toe.';
            }
        }

        function update(root) {
            if (!root) return;

            updateLiveContext(root);

            const total = totals(root);
            const all = total.voordeel + total.nadeel;
            const share = all > 0
                ? Math.round((total.voordeel / all) * 100)
                : 50;

            root.style.setProperty('--drijfveren-voordeel-share', `${share}%`);

            Object.entries(total).forEach(([side, value]) => {
                const node = root.querySelector(`[data-drijfveren-total="${side}"]`);

                if (node) {
                    node.textContent = String(value);
                }
            });

            const balance = balanceText(total.voordeel, total.nadeel);

            root.setAttribute('data-drijfveren-state', balance.state);

            const title = root.querySelector('[data-drijfveren-balance-title]');
            const textNode = root.querySelector('[data-drijfveren-balance-text]');

            if (title) {
                title.textContent = balance.title;
            }

            if (textNode) {
                textNode.textContent = balance.text;
            }
        }

        function makeRow(kind) {
            const info = meta[kind] || {};

            const row = document.createElement('div');
            row.className = 'wc-drijfveren-map-tool__item-row';
            row.setAttribute('data-drijfveren-row', kind);
            row.setAttribute('data-drijfveren-extra', 'true');

            const input = document.createElement('input');
            input.type = 'text';
            input.placeholder = info.placeholder || '';
            input.setAttribute('data-drijfveren-input', kind);

            const strengthWrap = document.createElement('div');
            strengthWrap.className = 'wc-drijfveren-map-tool__strength';

            const strength = document.createElement('input');
            strength.type = 'range';
            strength.min = '0';
            strength.max = '5';
            strength.value = '3';
            strength.setAttribute('aria-label', 'Sterkte');
            strength.setAttribute('data-drijfveren-strength', kind);

            const strengthValue = document.createElement('span');
            strengthValue.setAttribute('data-drijfveren-strength-value', '');
            strengthValue.textContent = '3';

            strengthWrap.append(strength, strengthValue);

            const remove = document.createElement('button');
            remove.type = 'button';
            remove.className = 'wc-drijfveren-map-tool__remove';
            remove.setAttribute('aria-label', 'Verwijder regel');
            remove.setAttribute('data-drijfveren-remove', '');
            remove.textContent = '×';

            row.append(input, strengthWrap, remove);

            return row;
        }

        function addRow(root, kind) {
            const list = root.querySelector(`[data-drijfveren-list="${kind}"]`);

            if (!list) return;

            const row = makeRow(kind);
            list.appendChild(row);
            row.querySelector('[data-drijfveren-input]')?.focus();
            update(root);
        }

        function clear(root) {
            root.querySelectorAll('[data-drijfveren-field], [data-drijfveren-input]').forEach((input) => {
                input.value = '';
            });

            root.querySelectorAll('[data-drijfveren-strength]').forEach((input) => {
                input.value = '3';
            });

            root.querySelectorAll('[data-drijfveren-extra="true"]').forEach((row) => {
                row.remove();
            });

            update(root);
        }

        function init(root) {
            if (root.dataset.drijfverenInitialized === 'true') return;
            root.dataset.drijfverenInitialized = 'true';

            root.addEventListener('input', () => update(root));
            root.addEventListener('change', () => update(root));

            root.addEventListener('click', (event) => {
                const addButton = event.target.closest('[data-drijfveren-add]');
                if (addButton) {
                    addRow(root, addButton.getAttribute('data-drijfveren-add'));
                    return;
                }

                const removeButton = event.target.closest('[data-drijfveren-remove]');
                if (removeButton) {
                    const row = removeButton.closest('[data-drijfveren-row]');
                    const list = row?.parentElement;

                    if (list && list.querySelectorAll('[data-drijfveren-row]').length > 1) {
                        row.remove();
                    } else if (row) {
                        row.querySelector('[data-drijfveren-input]').value = '';
                        row.querySelector('[data-drijfveren-strength]').value = '3';
                    }

                    update(root);
                    return;
                }

                if (event.target.closest('[data-drijfveren-clear]')) {
                    clear(root);
                    return;
                }

                if (event.target.closest('[data-drijfveren-print]')) {
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

        window.wcDrijfverenMapTool = {
            initialized: true,
            initAll
        };
    })();
    """#
}
