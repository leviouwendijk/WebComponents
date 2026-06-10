import Constructors
import CSS
import HTML
import JS

public struct ConditioningMapTool: ReusableComponent, Sendable {
    public enum Kind: String, Sendable {
        case classical
        case operant

        var title: String {
            switch self {
            case .classical:
                return "Klassieke conditionering kaart"
            case .operant:
                return "Operante uitkomsten kaart"
            }
        }

        var eyebrow: String {
            switch self {
            case .classical:
                return "Hulpmiddel · prikkel → gevolg"
            case .operant:
                return "Hulpmiddel · prikkel → keuze → uitkomst"
            }
        }

        var lead: String {
            switch self {
            case .classical:
                return "Teken uit welke prikkel voor je hond voorspellend wordt voor welk gevolg. De kern is de koppeling: prikkel → gevolg."
            case .operant:
                return "Teken uit welke prikkel een keuze uitlokt en welke uitkomst daarop volgt. De kern is de keten: prikkel → keuze → uitkomst."
            }
        }

        var primaryLabel: String {
            "Prikkel"
        }

        var secondaryLabel: String {
            switch self {
            case .classical:
                return "Gevolg"
            case .operant:
                return "Keuze"
            }
        }

        var tertiaryLabel: String {
            switch self {
            case .classical:
                return "Zichtbare reactie / effect"
            case .operant:
                return "Uitkomst"
            }
        }

        var primaryPlaceholder: String {
            switch self {
            case .classical:
                return "Naderende hond"
            case .operant:
                return "Andere hond komt dichterbij"
            }
        }

        var secondaryPlaceholder: String {
            switch self {
            case .classical:
                return "Verlies van afstand / mogelijke confrontatie"
            case .operant:
                return "Blaffen en naar voren trekken"
            }
        }

        var tertiaryPlaceholder: String {
            switch self {
            case .classical:
                return "Fixeren, blaffen, uitvallen"
            case .operant:
                return "Afstand wordt groter"
            }
        }

        var notePlaceholder: String {
            switch self {
            case .classical:
                return "Wat maakt deze prikkel voorspellend? Denk aan afstand, herhaling, intensiteit en eerdere ervaringen."
            case .operant:
                return "Wat levert deze keuze op? Denk aan afstand, aandacht, toegang, controle of opluchting."
            }
        }
    }

    public struct Example: Sendable {
        public let title: String
        public let primary: String
        public let secondary: String
        public let tertiary: String
        public let effect: String
        public let notes: String

        public init(
            title: String,
            primary: String,
            secondary: String,
            tertiary: String,
            effect: String = "",
            notes: String = ""
        ) {
            self.title = title
            self.primary = primary
            self.secondary = secondary
            self.tertiary = tertiary
            self.effect = effect
            self.notes = notes
        }
    }

    public static let block = "wc-conditioning-map-tool"

    public let id: String
    public let kind: Kind
    public let examples: [Example]
    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        id: String? = nil,
        kind: Kind,
        examples: [Example]? = nil,
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
        self.id = id ?? "conditioning-map-tool-\(kind.rawValue)"
        self.kind = kind
        self.examples = examples ?? Self.defaultExamples(for: kind)
        self.includeStyles = includeStyles
        self.includeScript = includeScript
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.main(
                    [
                        "id": "content-area",
                        "class": "\(Self.block) \(Self.block)--\(kind.rawValue)",
                        "data-conditioning-map-tool": kind.rawValue
                    ]
                ) {
                    hero()
                    diagramSurface()
                    lowerPanel()
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : [],
            scripts: includeScript ? ConditioningMapToolScript().nodes.scripts : []
        )
    }

    private func hero() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__hero"]) {
            HTML.p(["class": "\(Self.block)__eyebrow"]) {
                HTML.text(kind.eyebrow)
            }

            HTML.h1 {
                HTML.text(kind.title)
            }

            HTML.p(["class": "\(Self.block)__lead"]) {
                HTML.text(kind.lead)
            }
        }
    }

    private func diagramSurface() -> any HTMLNode {
        HTML.section(
            [
                "class": "\(Self.block)__surface",
                "aria-label": kind == .classical
                    ? "Klassieke conditionering kaart: prikkel naar gevolg."
                    : "Operante uitkomsten kaart: prikkel naar keuze naar uitkomst."
            ]
        ) {
            HTML.div(["class": "\(Self.block)__surface-header"]) {
                HTML.label(["class": "\(Self.block)__title-field", "for": "\(id)-title"]) {
                    HTML.span {
                        HTML.text("Situatie")
                    }

                    HTML.input([
                        "id": "\(id)-title",
                        "type": "text",
                        "placeholder": kind == .classical ? "Bijvoorbeeld: hond aan de overkant" : "Bijvoorbeeld: blaffen aan de lijn",
                        "data-conditioning-field": "title"
                    ])
                }

                HTML.div(["class": "\(Self.block)__model-kicker"]) {
                    HTML.text(kind == .classical ? "Model: prikkel → gevolg" : "Model: prikkel → keuze → uitkomst")
                }
            }

            HTML.div(["class": "\(Self.block)__drawing"]) {
                HTML.div(["class": "\(Self.block)__flow"]) {
                    editableNode(
                        label: kind.primaryLabel,
                        field: "primary",
                        placeholder: kind.primaryPlaceholder
                    )

                    arrow()

                    editableNode(
                        label: kind.secondaryLabel,
                        field: "secondary",
                        placeholder: kind.secondaryPlaceholder
                    )

                    if kind == .operant {
                        arrow()

                        editableNode(
                            label: kind.tertiaryLabel,
                            field: "tertiary",
                            placeholder: kind.tertiaryPlaceholder
                        )
                    }
                }

                HTML.div(["class": "\(Self.block)__secondary-row"]) {
                    if kind == .classical {
                        observationField()
                    }

                    if kind == .operant {
                        effectField()
                    }

                    notesField()
                }
            }
        }
    }

    private func editableNode(
        label: String,
        field: String,
        placeholder: String
    ) -> any HTMLNode {
        let inputID = "\(id)-\(field)"

        return HTML.label(["class": "\(Self.block)__node", "for": inputID]) {
            HTML.span(["class": "\(Self.block)__node-label"]) {
                HTML.text(label)
            }

            HTML.textarea([
                "id": inputID,
                "rows": "3",
                "placeholder": placeholder,
                "data-conditioning-field": field
            ]) {
                HTML.text("")
            }
        }
    }

    private func arrow() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__arrow", "aria-hidden": "true"]) {
            HTML.span {
                HTML.text("→")
            }
        }
    }

    private func observationField() -> any HTMLNode {
        HTML.label(["class": "\(Self.block)__detail \(Self.block)__detail--observation", "for": "\(id)-tertiary"]) {
            HTML.span(["class": "\(Self.block)__detail-label"]) {
                HTML.text(kind.tertiaryLabel)
            }

            HTML.textarea([
                "id": "\(id)-tertiary",
                "rows": "3",
                "placeholder": kind.tertiaryPlaceholder,
                "data-conditioning-field": "tertiary"
            ]) {
                HTML.text("")
            }
        }
    }

    private func effectField() -> any HTMLNode {
        HTML.label(["class": "\(Self.block)__detail \(Self.block)__detail--effect", "for": "\(id)-effect"]) {
            HTML.span(["class": "\(Self.block)__detail-label"]) {
                HTML.text("Effect op gedrag")
            }

            HTML.select([
                "id": "\(id)-effect",
                "data-conditioning-field": "effect"
            ]) {
                HTML.option(["value": "neemt toe"]) {
                    HTML.text("Keuze wordt waarschijnlijker")
                }

                HTML.option(["value": "neemt af"]) {
                    HTML.text("Keuze wordt minder waarschijnlijk")
                }

                HTML.option(["value": "blijft gelijk"]) {
                    HTML.text("Effect is nog onduidelijk")
                }
            }
        }
    }

    private func notesField() -> any HTMLNode {
        HTML.label(["class": "\(Self.block)__detail \(Self.block)__detail--notes", "for": "\(id)-notes"]) {
            HTML.span(["class": "\(Self.block)__detail-label"]) {
                HTML.text("Notities")
            }

            HTML.textarea([
                "id": "\(id)-notes",
                "placeholder": kind.notePlaceholder,
                "data-conditioning-field": "notes"
            ]) {
                HTML.text("")
            }
        }
    }

    private func lowerPanel() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__workbench"]) {
            HTML.div(["class": "\(Self.block)__toolbox"]) {
                HTML.h2 {
                    HTML.text("Acties")
                }

                HTML.div(["class": "\(Self.block)__controls"]) {
                    HTML.button(
                        [
                            "type": "button",
                            "class": "\(Self.block)__button \(Self.block)__button--secondary",
                            "data-conditioning-new": ""
                        ]
                    ) {
                        HTML.text("Nieuwe kaart")
                    }

                    HTML.button(
                        [
                            "type": "button",
                            "class": "\(Self.block)__button",
                            "data-conditioning-save": ""
                        ]
                    ) {
                        HTML.text("Koppeling bewaren")
                    }

                    HTML.button(
                        [
                            "type": "button",
                            "class": "\(Self.block)__button \(Self.block)__button--print",
                            "data-conditioning-print": ""
                        ]
                    ) {
                        HTML.text("Print / bewaar als PDF")
                    }
                }
            }

            if !examples.isEmpty {
                HTML.div(["class": "\(Self.block)__examples"]) {
                    HTML.h2 {
                        HTML.text("Voorbeelden")
                    }

                    HTML.div(["class": "\(Self.block)__example-grid"]) {
                        for example in examples {
                            exampleButton(example)
                        }
                    }
                }
            }

            HTML.div(["class": "\(Self.block)__saved"]) {
                HTML.h2 {
                    HTML.text("Bewaarde koppelingen")
                }

                HTML.p(["class": "\(Self.block)__saved-note"]) {
                    HTML.text("Tijdelijke lijst voor deze sessie. Kies een koppeling om hem opnieuw te laden.")
                }

                HTML.div(["class": "\(Self.block)__saved-list", "data-conditioning-list": ""]) {
                    HTML.p(["class": "\(Self.block)__empty"]) {
                        HTML.text("Nog geen koppelingen bewaard.")
                    }
                }
            }
        }
    }

    private func exampleButton(
        _ example: Example
    ) -> any HTMLNode {
        HTML.button(
            [
                "type": "button",
                "class": "\(Self.block)__example",
                "data-conditioning-example": "",
                "data-title": example.title,
                "data-primary": example.primary,
                "data-secondary": example.secondary,
                "data-tertiary": example.tertiary,
                "data-effect": example.effect,
                "data-notes": example.notes
            ]
        ) {
            HTML.span(["class": "\(Self.block)__example-title"]) {
                HTML.text(example.title)
            }

            HTML.span(["class": "\(Self.block)__example-map"]) {
                HTML.text(kind == .classical
                    ? "\(example.primary) → \(example.secondary)"
                    : "\(example.primary) → \(example.secondary) → \(example.tertiary)"
                )
            }
        }
    }

    private static func defaultExamples(
        for kind: Kind
    ) -> [Example] {
        switch kind {
        case .classical:
            return [
                Example(
                    title: "Reactiviteit aan de lijn",
                    primary: "Naderende hond",
                    secondary: "Verlies van afstand / mogelijke confrontatie",
                    tertiary: "Fixeren, blaffen, naar voren schieten",
                    notes: "De naderende hond wordt voorspellend voor spanning of verlies van afstand. Let op afstand, lijnspanning en eerdere ervaringen."
                ),
                Example(
                    title: "Deurbel",
                    primary: "Geluid van de deurbel",
                    secondary: "Bezoek / opwinding / verstoring",
                    tertiary: "Blaffen, naar de deur rennen",
                    notes: "De bel is niet alleen een geluid, maar voorspelt wat daarna gebeurt."
                )
            ]

        case .operant:
            return [
                Example(
                    title: "Blaffen vergroot afstand",
                    primary: "Andere hond nadert",
                    secondary: "Blaffen en naar voren trekken",
                    tertiary: "Afstand wordt groter",
                    effect: "neemt toe",
                    notes: "Afstandstoename kan de keuze om te blaffen en te trekken bekrachtigen."
                ),
                Example(
                    title: "Opspringen levert contact op",
                    primary: "Mens komt binnen",
                    secondary: "Opspringen",
                    tertiary: "Aandacht, aanraking of praten",
                    effect: "neemt toe",
                    notes: "Ook wegduwen of praten kan als contact werken."
                )
            ]
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("--tool-surface", "var(--surface-color, #ffffff)"),
                    CSS.decl("--tool-soft", "var(--surface-soft-color, #f3f4f6)"),
                    CSS.decl("--tool-border", "var(--border-color, rgba(0, 0, 0, .12))"),
                    CSS.decl("--tool-text", "var(--text-color, #222222)"),
                    CSS.decl("--tool-muted", "var(--muted-text-color, rgba(0, 0, 0, .62))"),
                    CSS.decl("width", "min(1180px, calc(100% - 48px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "58px 0 92px"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("color", "var(--tool-text)")
                ),

                CSS.rule(
                    ".\(block)__hero",
                    CSS.decl("max-width", "900px"),
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
                    CSS.decl("line-height", "1"),
                    CSS.decl("letter-spacing", "-.05em")
                ),

                CSS.rule(
                    ".\(block)__lead",
                    CSS.decl("max-width", "760px"),
                    CSS.decl("margin", "18px 0 0"),
                    CSS.decl("font-size", "1.04rem"),
                    CSS.decl("line-height", "1.68"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__surface",
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "28px"),
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("padding", "24px"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("box-shadow", "0 18px 48px rgba(15, 23, 42, .06)")
                ),

                CSS.rule(
                    ".\(block)__surface-header",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) auto"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("margin", "0 0 22px")
                ),

                CSS.rule(
                    ".\(block)__title-field",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".\(block)__title-field span, .\(block)__detail-label",
                    CSS.decl("font-size", ".74rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("letter-spacing", ".1em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__title-field input",
                    CSS.decl("width", "100%"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("border", "0"),
                    CSS.decl("border-bottom", "1px solid var(--tool-border)"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("color", "var(--tool-text)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", "1.45rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("letter-spacing", "-.03em"),
                    CSS.decl("padding", "2px 0 8px")
                ),

                CSS.rule(
                    ".\(block)__model-kicker",
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("padding", "8px 12px"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("color", "var(--tool-muted)"),
                    CSS.decl("white-space", "nowrap")
                ),

                CSS.rule(
                    ".\(block)__drawing",
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "24px"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-soft) 76%, transparent)"),
                    CSS.decl("padding", "20px"),
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(block)__flow",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) 76px minmax(0, 1fr)"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("align-items", "stretch")
                ),

                CSS.rule(
                    ".\(block)--operant .\(block)__flow",
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) 58px minmax(0, 1fr) 58px minmax(0, 1fr)")
                ),

                CSS.rule(
                    ".\(block)__node",
                    CSS.decl("display", "grid"),
                    CSS.decl("align-content", "start"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("min-height", "168px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(block)__node textarea",
                    CSS.decl("width", "100%"),
                    CSS.decl("min-height", "96px"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("border", "1px dashed color-mix(in srgb, var(--tool-text) 22%, transparent)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-soft) 74%, transparent)"),
                    CSS.decl("color", "var(--tool-text)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", "1.08rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("line-height", "1.32"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("resize", "vertical"),
                    CSS.decl("overflow-wrap", "anywhere")
                ),

                CSS.rule(
                    ".\(block)__node-label",
                    CSS.decl("display", "block"),
                    CSS.decl("font-size", ".74rem"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__node input",
                    CSS.decl("width", "100%"),
                    CSS.decl("min-height", "86px"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("border", "1px dashed color-mix(in srgb, var(--tool-text) 22%, transparent)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--tool-soft) 74%, transparent)"),
                    CSS.decl("color", "var(--tool-text)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", "1.15rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("line-height", "1.25"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("text-wrap", "balance")
                ),

                CSS.rule(
                    ".\(block)__arrow",
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__arrow span",
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "44px"),
                    CSS.decl("height", "44px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("font-size", "1.45rem"),
                    CSS.decl("font-weight", "850")
                ),

                CSS.rule(
                    ".\(block)__secondary-row",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, .8fr) minmax(0, 1.2fr)"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("margin", "14px 0 0")
                ),

                CSS.rule(
                    ".\(block)--operant .\(block)__secondary-row",
                    CSS.decl("grid-template-columns", "minmax(240px, .55fr) minmax(0, 1fr)")
                ),

                CSS.rule(
                    ".\(block)__detail",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-rows", "auto 1fr"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("min-height", "142px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(block)__detail input, .\(block)__detail textarea, .\(block)__detail select",
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "100%"),
                    CSS.decl("min-height", "86px"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("border", "0"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("background", "var(--tool-soft)"),
                    CSS.decl("color", "var(--tool-text)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("line-height", "1.42"),
                    CSS.decl("padding", "10px 11px")
                ),

                CSS.rule(
                    ".\(block)__detail textarea",
                    CSS.decl("resize", "vertical"),
                    CSS.decl("overflow-wrap", "anywhere")
                ),

                CSS.rule(
                    ".\(block)__detail select",
                    CSS.decl("align-self", "stretch")
                ),

                CSS.rule(
                    ".\(block)__workbench",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(220px, .72fr) minmax(0, 1.1fr) minmax(260px, .8fr)"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("margin", "16px 0 0"),
                    CSS.decl("align-items", "start")
                ),

                CSS.rule(
                    ".\(block)__toolbox, .\(block)__examples, .\(block)__saved",
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(block)__toolbox h2, .\(block)__examples h2, .\(block)__saved h2",
                    CSS.decl("margin", "0 0 12px"),
                    CSS.decl("font-size", ".88rem"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("letter-spacing", ".1em"),
                    CSS.decl("text-transform", "uppercase")
                ),

                CSS.rule(
                    ".\(block)__controls",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "9px")
                ),

                CSS.rule(
                    ".\(block)__button",
                    CSS.decl("border", "1px solid var(--tool-text)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--tool-text)"),
                    CSS.decl("color", "var(--background-color, #ffffff)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("padding", "9px 13px"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(block)__button--secondary, .\(block)__button--print",
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("color", "var(--tool-text)")
                ),

                CSS.rule(
                    ".\(block)__example-grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(2, minmax(0, 1fr))"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".\(block)__example",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("text-align", "left"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "var(--tool-soft)"),
                    CSS.decl("color", "var(--tool-text)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("padding", "11px 12px"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(block)__example-title",
                    CSS.decl("font-weight", "800")
                ),

                CSS.rule(
                    ".\(block)__example-map",
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("line-height", "1.4"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__saved-note",
                    CSS.decl("margin", "0 0 14px"),
                    CSS.decl("line-height", "1.5"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__saved-list",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".\(block)__saved-row",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "1fr auto"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("align-items", "center")
                ),

                CSS.rule(
                    ".\(block)__saved-row button",
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("background", "var(--tool-soft)"),
                    CSS.decl("color", "var(--tool-text)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("padding", "9px 10px"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(block)__saved-row button:first-child",
                    CSS.decl("text-align", "left"),
                    CSS.decl("font-weight", "740")
                ),

                CSS.rule(
                    ".\(block)__empty",
                    CSS.decl("margin", "0"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block) input:focus-visible, .\(block) textarea:focus-visible, .\(block) select:focus-visible, .\(block) button:focus-visible",
                    CSS.decl("outline", "2px solid var(--link-color)"),
                    CSS.decl("outline-offset", "3px")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 1080px)",
                    CSS.rule(
                        ".\(block)__workbench",
                        CSS.decl("grid-template-columns", "1fr")
                    )
                ),

                CSS.media(
                    "(max-width: 860px)",
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("width", "calc(100% - 32px)"),
                        CSS.decl("padding", "44px 0 78px")
                    ),
                    CSS.rule(
                        ".\(block)__surface",
                        CSS.decl("padding", "18px")
                    ),
                    CSS.rule(
                        ".\(block)__surface-header",
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        ".\(block)__model-kicker",
                        CSS.decl("justify-self", "start")
                    ),
                    CSS.rule(
                        ".\(block)__flow, .\(block)--operant .\(block)__flow",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "10px")
                    ),
                    CSS.rule(
                        ".\(block)__arrow span",
                        CSS.decl("transform", "rotate(90deg)")
                    ),
                    CSS.rule(
                        ".\(block)__secondary-row, .\(block)--operant .\(block)__secondary-row",
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        ".\(block)__example-grid",
                        CSS.decl("grid-template-columns", "1fr")
                    )
                ),

                CSS.media(
                    "print",
                    CSS.rule(
                        ".hm-docs-app--tool header, .hm-docs-app--tool nav, .hm-docs-app--tool .wc-docs-project-context-nav, .hm-docs-app--tool .wc-docs-mobile-navigation-drawer, .\(block)__workbench",
                        CSS.decl("display", "none !important")
                    ),
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("width", "100%"),
                        CSS.decl("padding", "0"),
                        CSS.decl("margin", "0"),
                        CSS.decl("color", "#111")
                    ),
                    CSS.rule(
                        ".\(block)__hero",
                        CSS.decl("margin", "0 0 18px")
                    ),
                    CSS.rule(
                        ".\(block)__lead",
                        CSS.decl("max-width", "100%"),
                        CSS.decl("color", "#333")
                    ),
                    CSS.rule(
                        ".\(block)__surface, .\(block)__drawing, .\(block)__node, .\(block)__detail",
                        CSS.decl("box-shadow", "none"),
                        CSS.decl("border-color", "#999"),
                        CSS.decl("break-inside", "avoid")
                    ),
                    CSS.rule(
                        ".\(block) input, .\(block) textarea, .\(block) select",
                        CSS.decl("color", "#111"),
                        CSS.decl("-webkit-print-color-adjust", "exact"),
                        CSS.decl("print-color-adjust", "exact")
                    )
                )
            ]
        )
    }
}

public struct ConditioningMapToolScript: ReusableComponent {
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
        if (window.wcConditioningMapTool?.initialized) return;

        function fieldMap(root) {
            const result = {};
            root.querySelectorAll('[data-conditioning-field]').forEach((field) => {
                result[field.dataset.conditioningField] = field;
            });
            return result;
        }

        function fieldValue(field) {
            if (!field) return '';
            return field.value.trim();
        }

        function writeField(field, value) {
            if (!field) return;
            field.value = value || '';
            field.dispatchEvent(new Event('input', { bubbles: true }));
        }

        function read(root) {
            const fields = fieldMap(root);

            return {
                id: root.dataset.activeConditioningId || '',
                title: fieldValue(fields.title),
                primary: fieldValue(fields.primary),
                secondary: fieldValue(fields.secondary),
                tertiary: fieldValue(fields.tertiary),
                effect: fieldValue(fields.effect),
                notes: fieldValue(fields.notes)
            };
        }

        function write(root, data) {
            const fields = fieldMap(root);

            Object.entries(data).forEach(([key, value]) => {
                if (key === 'id') return;
                writeField(fields[key], value);
            });

            root.dataset.activeConditioningId = data.id || '';
            updateMeta(root);
        }

        function clear(root) {
            write(root, {
                id: '',
                title: '',
                primary: '',
                secondary: '',
                tertiary: '',
                effect: 'neemt toe',
                notes: ''
            });
        }

        function labelFor(item, index = 0) {
            if (item.title) return item.title;

            const pieces = [item.primary, item.secondary, item.tertiary]
                .filter((piece) => String(piece || '').trim().length);

            if (pieces.length) return pieces.join(' → ');

            return `Koppeling ${index + 1}`;
        }

        function updateMeta(root) {
            const data = read(root);
            const label = labelFor(data, 0);

            root.setAttribute(
                'aria-label',
                `${root.dataset.conditioningMapTool || 'conditionering'} kaart: ${label}`
            );
        }

        function state(root) {
            if (!root._conditioningState) {
                root._conditioningState = {
                    links: []
                };
            }

            return root._conditioningState;
        }

        function save(root) {
            const current = read(root);
            const store = state(root);

            const id = current.id || `conditioning-${Date.now()}-${Math.random().toString(16).slice(2)}`;
            const next = {
                ...current,
                id
            };

            const existingIndex = store.links.findIndex((item) => item.id === id);

            if (existingIndex >= 0) {
                store.links[existingIndex] = next;
            } else {
                store.links.push(next);
            }

            root.dataset.activeConditioningId = id;
            renderList(root);
            updateMeta(root);
        }

        function renderList(root) {
            const list = root.querySelector('[data-conditioning-list]');
            if (!list) return;

            const store = state(root);
            list.replaceChildren();

            if (!store.links.length) {
                const empty = document.createElement('p');
                empty.className = 'wc-conditioning-map-tool__empty';
                empty.textContent = 'Nog geen koppelingen bewaard.';
                list.appendChild(empty);
                return;
            }

            store.links.forEach((item, index) => {
                const row = document.createElement('div');
                row.className = 'wc-conditioning-map-tool__saved-row';

                const load = document.createElement('button');
                load.type = 'button';
                load.textContent = labelFor(item, index);
                load.addEventListener('click', () => write(root, item));

                const remove = document.createElement('button');
                remove.type = 'button';
                remove.textContent = 'Verwijder';
                remove.addEventListener('click', () => {
                    store.links = store.links.filter((candidate) => candidate.id !== item.id);

                    if (root.dataset.activeConditioningId === item.id) {
                        clear(root);
                    }

                    renderList(root);
                });

                row.append(load, remove);
                list.appendChild(row);
            });
        }

        function applyExample(root, button) {
            write(root, {
                id: '',
                title: button.dataset.title || '',
                primary: button.dataset.primary || '',
                secondary: button.dataset.secondary || '',
                tertiary: button.dataset.tertiary || '',
                effect: button.dataset.effect || 'neemt toe',
                notes: button.dataset.notes || ''
            });
        }

        function init(root) {
            if (root.dataset.conditioningInitialized === 'true') return;
            root.dataset.conditioningInitialized = 'true';

            root.addEventListener('input', (event) => {
                if (event.target.closest('[data-conditioning-field]')) {
                    root.dataset.activeConditioningId = root.dataset.activeConditioningId || '';
                    updateMeta(root);
                }
            });

            root.addEventListener('change', (event) => {
                if (event.target.closest('[data-conditioning-field]')) {
                    updateMeta(root);
                }
            });

            root.querySelector('[data-conditioning-save]')?.addEventListener('click', () => save(root));
            root.querySelector('[data-conditioning-new]')?.addEventListener('click', () => clear(root));
            root.querySelector('[data-conditioning-print]')?.addEventListener('click', () => window.print());

            root.querySelectorAll('[data-conditioning-example]').forEach((button) => {
                button.addEventListener('click', () => applyExample(root, button));
            });

            updateMeta(root);
            renderList(root);
        }

        function initAll() {
            document.querySelectorAll('[data-conditioning-map-tool]').forEach(init);
        }

        document.addEventListener('DOMContentLoaded', initAll);
        initAll();

        window.wcConditioningMapTool = {
            initialized: true,
            initAll
        };
    })();
    """#
}
