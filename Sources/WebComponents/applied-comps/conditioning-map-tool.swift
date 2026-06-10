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
                return "Hulpmiddel · gedrag → uitkomst"
            }
        }

        var lead: String {
            switch self {
            case .classical:
                return "Breng in kaart welke prikkel voor je hond voorspellend wordt voor welk gevolg. Gebruik dit om triggers, verwachting en zichtbare reactie van elkaar te scheiden."
            case .operant:
                return "Breng in kaart welk gedrag in welke situatie tot welke uitkomst leidt. Gebruik dit om te zien waarom gedrag waarschijnlijker of minder waarschijnlijk wordt."
            }
        }

        var primaryLabel: String {
            switch self {
            case .classical:
                return "Prikkel"
            case .operant:
                return "Aanleiding"
            }
        }

        var secondaryLabel: String {
            switch self {
            case .classical:
                return "Voorspelt gevolg"
            case .operant:
                return "Gedrag"
            }
        }

        var tertiaryLabel: String {
            switch self {
            case .classical:
                return "Zichtbare reactie"
            case .operant:
                return "Uitkomst"
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
                    layout()
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
    }

    private func layout() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__layout"]) {
            HTML.section(["class": "\(Self.block)__panel \(Self.block)__panel--form"]) {
                HTML.h2 {
                    HTML.text("Invullen")
                }

                field(
                    label: "Situatie-label",
                    name: "title",
                    placeholder: kind == .classical ? "Bijvoorbeeld: hond aan de overkant" : "Bijvoorbeeld: blaffen aan de lijn"
                )

                field(
                    label: kind.primaryLabel,
                    name: "primary",
                    placeholder: kind == .classical ? "Naderende hond" : "Andere hond komt dichterbij"
                )

                field(
                    label: kind.secondaryLabel,
                    name: "secondary",
                    placeholder: kind == .classical ? "Dreiging / verlies van afstand / spanning" : "Blaffen en naar voren trekken"
                )

                field(
                    label: kind.tertiaryLabel,
                    name: "tertiary",
                    placeholder: kind == .classical ? "Fixeren, blaffen, uitvallen" : "De andere hond verdwijnt of afstand wordt groter"
                )

                if kind == .operant {
                    effectField()
                }

                notesField()

                if !examples.isEmpty {
                    HTML.div(["class": "\(Self.block)__examples"]) {
                        HTML.h3 {
                            HTML.text("Voorbeelden")
                        }

                        for example in examples {
                            exampleButton(example)
                        }
                    }
                }
            }

            HTML.section(["class": "\(Self.block)__panel \(Self.block)__panel--map"]) {
                HTML.h2 {
                    HTML.text("Kaart")
                }

                mapPreview()
            }

            HTML.aside(["class": "\(Self.block)__panel \(Self.block)__panel--sidebar"]) {
                HTML.h2 {
                    HTML.text("Koppelingen")
                }

                HTML.p(["class": "\(Self.block)__sidebar-note"]) {
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

    private func field(
        label: String,
        name: String,
        placeholder: String
    ) -> any HTMLNode {
        let inputID = "\(id)-\(name)"

        return HTML.label(["class": "\(Self.block)__field", "for": inputID]) {
            HTML.span {
                HTML.text(label)
            }

            HTML.input([
                "id": inputID,
                "type": "text",
                "placeholder": placeholder,
                "data-conditioning-field": name
            ])
        }
    }

    private func effectField() -> any HTMLNode {
        HTML.label(["class": "\(Self.block)__field", "for": "\(id)-effect"]) {
            HTML.span {
                HTML.text("Effect")
            }

            HTML.select([
                "id": "\(id)-effect",
                "data-conditioning-field": "effect"
            ]) {
                HTML.option(["value": "neemt toe"]) {
                    HTML.text("Gedrag wordt waarschijnlijker")
                }

                HTML.option(["value": "neemt af"]) {
                    HTML.text("Gedrag wordt minder waarschijnlijk")
                }

                HTML.option(["value": "blijft gelijk"]) {
                    HTML.text("Effect is nog onduidelijk")
                }
            }
        }
    }

    private func notesField() -> any HTMLNode {
        HTML.label(["class": "\(Self.block)__field", "for": "\(id)-notes"]) {
            HTML.span {
                HTML.text("Notities")
            }

            HTML.textarea([
                "id": "\(id)-notes",
                "placeholder": "Wat valt op? Welke afstand, context, intensiteit of herhaling speelt mee?",
                "data-conditioning-field": "notes"
            ]) {
                HTML.text("")
            }
        }
    }

    private func mapPreview() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__map", "data-conditioning-preview": ""]) {
            HTML.div(["class": "\(Self.block)__map-title"]) {
                HTML.span(["data-conditioning-preview-field": "title"]) {
                    HTML.text("Nieuwe koppeling")
                }
            }

            HTML.div(["class": "\(Self.block)__flow"]) {
                mapNode(label: kind.primaryLabel, field: "primary")
                HTML.span(["class": "\(Self.block)__arrow"]) {
                    HTML.text("→")
                }
                mapNode(label: kind.secondaryLabel, field: "secondary")
                HTML.span(["class": "\(Self.block)__arrow"]) {
                    HTML.text("→")
                }
                mapNode(label: kind.tertiaryLabel, field: "tertiary")
            }

            if kind == .operant {
                HTML.div(["class": "\(Self.block)__effect"]) {
                    HTML.span {
                        HTML.text("Effect: ")
                    }

                    HTML.strong(["data-conditioning-preview-field": "effect"]) {
                        HTML.text("Gedrag wordt waarschijnlijker")
                    }
                }
            }

            HTML.div(["class": "\(Self.block)__notes-preview"]) {
                HTML.span {
                    HTML.text("Notities: ")
                }

                HTML.span(["data-conditioning-preview-field": "notes"]) {
                    HTML.text("Nog geen notities.")
                }
            }
        }
    }

    private func mapNode(
        label: String,
        field: String
    ) -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__node"]) {
            HTML.span(["class": "\(Self.block)__node-label"]) {
                HTML.text(label)
            }

            HTML.strong(["data-conditioning-preview-field": field]) {
                HTML.text("Nog invullen")
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
            HTML.span {
                HTML.text(example.title)
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
                    notes: "Let op afstand, lijnspanning en eerdere ervaringen."
                ),
                Example(
                    title: "Deurbel",
                    primary: "Geluid van de deurbel",
                    secondary: "Bezoek / opwinding / verstoring",
                    tertiary: "Blaffen, naar de deur rennen",
                    notes: "De bel is niet alleen geluid, maar voorspelt wat daarna gebeurt."
                )
            ]

        case .operant:
            return [
                Example(
                    title: "Blaffen vergroot afstand",
                    primary: "Andere hond nadert",
                    secondary: "Blaffen en trekken",
                    tertiary: "Afstand wordt groter",
                    effect: "neemt toe",
                    notes: "Afstandstoename kan het blaffen negatief bekrachtigen."
                ),
                Example(
                    title: "Opspringen levert contact op",
                    primary: "Mens komt binnen",
                    secondary: "Opspringen",
                    tertiary: "Aandacht, aanraking of praten",
                    effect: "neemt toe",
                    notes: "Ook wegduwen of praten kan contact opleveren."
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
                    ".\(block)__controls",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("margin", "26px 0 0")
                ),

                CSS.rule(
                    ".\(block)__button",
                    CSS.decl("border", "1px solid var(--tool-text)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--tool-text)"),
                    CSS.decl("color", "var(--background-color, #ffffff)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("padding", "10px 15px"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(block)__button--secondary, .\(block)__button--print",
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("color", "var(--tool-text)")
                ),

                CSS.rule(
                    ".\(block)__layout",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, .95fr) minmax(0, 1.25fr) minmax(260px, .7fr)"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("align-items", "start")
                ),

                CSS.rule(
                    ".\(block)__panel",
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("padding", "22px"),
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(block)__panel h2",
                    CSS.decl("margin", "0 0 16px"),
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase")
                ),

                CSS.rule(
                    ".\(block)__field",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("margin", "0 0 14px")
                ),

                CSS.rule(
                    ".\(block)__field span",
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__field input, .\(block)__field textarea, .\(block)__field select",
                    CSS.decl("width", "100%"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "var(--tool-soft)"),
                    CSS.decl("color", "var(--tool-text)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("padding", "11px 12px")
                ),

                CSS.rule(
                    ".\(block)__field textarea",
                    CSS.decl("min-height", "100px"),
                    CSS.decl("resize", "vertical")
                ),

                CSS.rule(
                    ".\(block)__examples",
                    CSS.decl("margin", "22px 0 0"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".\(block)__examples h3",
                    CSS.decl("margin", "0 0 4px"),
                    CSS.decl("font-size", ".88rem")
                ),

                CSS.rule(
                    ".\(block)__example",
                    CSS.decl("text-align", "left"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "var(--tool-surface)"),
                    CSS.decl("color", "var(--tool-text)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("padding", "10px 12px"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(block)__map",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "18px")
                ),

                CSS.rule(
                    ".\(block)__map-title",
                    CSS.decl("font-size", "1.25rem"),
                    CSS.decl("font-weight", "800")
                ),

                CSS.rule(
                    ".\(block)__flow",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "1fr auto 1fr auto 1fr"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("align-items", "center")
                ),

                CSS.rule(
                    ".\(block)__node",
                    CSS.decl("min-height", "128px"),
                    CSS.decl("border", "1px solid var(--tool-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--tool-soft)"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(block)__node-label",
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "0 0 10px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("letter-spacing", ".1em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__node strong",
                    CSS.decl("display", "block"),
                    CSS.decl("line-height", "1.35")
                ),

                CSS.rule(
                    ".\(block)__arrow",
                    CSS.decl("font-size", "1.4rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__effect, .\(block)__notes-preview",
                    CSS.decl("border-top", "1px solid var(--tool-border)"),
                    CSS.decl("padding-top", "14px"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("color", "var(--tool-muted)")
                ),

                CSS.rule(
                    ".\(block)__effect strong",
                    CSS.decl("color", "var(--tool-text)")
                ),

                CSS.rule(
                    ".\(block)__sidebar-note",
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
                    CSS.decl("text-align", "left")
                ),

                CSS.rule(
                    ".\(block)__empty",
                    CSS.decl("margin", "0"),
                    CSS.decl("color", "var(--tool-muted)")
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
                        ".\(block)__layout",
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        ".\(block)__flow",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "8px")
                    ),
                    CSS.rule(
                        ".\(block)__arrow",
                        CSS.decl("transform", "rotate(90deg)"),
                        CSS.decl("justify-self", "center")
                    )
                ),

                CSS.media(
                    "print",
                    CSS.rule(
                        ".hm-docs-app--tool header, .hm-docs-app--tool nav, .hm-docs-app--tool .wc-docs-project-context-nav, .hm-docs-app--tool .wc-docs-mobile-navigation-drawer, .\(block)__controls, .\(block)__examples, .\(block)__sidebar",
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
                        ".\(block)__layout",
                        CSS.decl("display", "block")
                    ),
                    CSS.rule(
                        ".\(block)__panel",
                        CSS.decl("break-inside", "avoid"),
                        CSS.decl("box-shadow", "none"),
                        CSS.decl("margin", "0 0 14px"),
                        CSS.decl("border-color", "#999")
                    ),
                    CSS.rule(
                        ".\(block)__panel--form",
                        CSS.decl("display", "none")
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

        function display(value, fallback) {
            const trimmed = String(value || '').trim();
            return trimmed.length ? trimmed : fallback;
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

            Object.keys(fields).forEach((key) => {
                if (data[key] !== undefined) {
                    fields[key].value = data[key] || '';
                }
            });

            root.dataset.activeConditioningId = data.id || '';
            updatePreview(root);
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

        function updatePreview(root) {
            const data = read(root);

            const preview = {
                title: display(data.title, 'Nieuwe koppeling'),
                primary: display(data.primary, 'Nog invullen'),
                secondary: display(data.secondary, 'Nog invullen'),
                tertiary: display(data.tertiary, 'Nog invullen'),
                effect: display(data.effect, 'Gedrag wordt waarschijnlijker'),
                notes: display(data.notes, 'Nog geen notities.')
            };

            Object.entries(preview).forEach(([key, value]) => {
                root.querySelectorAll(`[data-conditioning-preview-field="${key}"]`).forEach((target) => {
                    target.textContent = value;
                });
            });
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
            updatePreview(root);
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
                load.textContent = item.title || `Koppeling ${index + 1}`;
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
                    updatePreview(root);
                }
            });

            root.addEventListener('change', (event) => {
                if (event.target.closest('[data-conditioning-field]')) {
                    updatePreview(root);
                }
            });

            root.querySelector('[data-conditioning-save]')?.addEventListener('click', () => save(root));
            root.querySelector('[data-conditioning-new]')?.addEventListener('click', () => clear(root));
            root.querySelector('[data-conditioning-print]')?.addEventListener('click', () => window.print());

            root.querySelectorAll('[data-conditioning-example]').forEach((button) => {
                button.addEventListener('click', () => applyExample(root, button));
            });

            updatePreview(root);
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
