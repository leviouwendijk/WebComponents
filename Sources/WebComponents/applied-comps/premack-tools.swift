import Constructors
import CSS
import HTML
import JS

public struct PremackTool: ReusableComponent, Sendable {
    public enum Kind: String, Sendable {
        case hierarchy
        case contingency

        var title: String {
            switch self {
            case .hierarchy: return "Premack respons-hiërarchie"
            case .contingency: return "Premack contingentiekaart"
            }
        }

        var eyebrow: String {
            switch self {
            case .hierarchy: return "Hulpmiddel · waarschijnlijkheid"
            case .contingency: return "Hulpmiddel · als-dan relatie"
            }
        }

        var lead: String {
            switch self {
            case .hierarchy:
                return "Brainstorm welke reacties in een specifieke situatie het meest waarschijnlijk zijn."
            case .contingency:
                return "Koppel een lage-kans en hoge-kans respons. Gebruik de hoge-kans respons als bekrachtiger, of poort de hoge-kans respons via een lage-kans respons."
            }
        }
    }

    public static let block = "wc-premack-tool"

    public let id: String
    public let kind: Kind
    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        id: String? = nil,
        kind: Kind,
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
        self.id = id ?? "premack-tool-\(kind.rawValue)"
        self.kind = kind
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
                        "data-premack-tool": kind.rawValue
                    ]
                ) {
                    hero()

                    switch kind {
                    case .hierarchy:
                        hierarchyTool()
                    case .contingency:
                        contingencyTool()
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : [],
            scripts: includeScript ? PremackToolScript().nodes.scripts : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
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

    private func hierarchyTool() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__surface"]) {
            HTML.div(["class": "\(Self.block)__field"]) {
                HTML.label(["for": "\(id)-situation"]) {
                    HTML.text("Situatie")
                }

                HTML.textarea([
                    "id": "\(id)-situation",
                    "data-premack-situation": "",
                    "placeholder": "Bijvoorbeeld: loslopen in het park, bezoek komt binnen, starten met trainen..."
                ]) {}
            }

            HTML.div(["class": "\(Self.block)__split"]) {
                HTML.div(["class": "\(Self.block)__panel"]) {
                    HTML.div(["class": "\(Self.block)__panel-head"]) {
                        HTML.h2 { HTML.text("Mogelijke reacties") }

                        HTML.button([
                            "type": "button",
                            "class": "\(Self.block)__button",
                            "data-premack-add-response": ""
                        ]) {
                            HTML.text("+ reactie")
                        }
                    }

                    HTML.div([
                        "class": "\(Self.block)__response-list",
                        "data-premack-response-list": ""
                    ]) {
                        responseRow("snuffelen", 90)
                        responseRow("naar andere hond kijken", 72)
                        responseRow("komen wanneer geroepen", 38)
                        responseRow("rustig naast je blijven", 22)
                    }
                }

                HTML.div(["class": "\(Self.block)__panel \(Self.block)__panel--preview"]) {
                    HTML.h2 { HTML.text("Hiërarchie") }

                    HTML.p(["class": "\(Self.block)__hint"]) {
                        HTML.text("Hoogste waarschijnlijkheid bovenaan. Gebruik dit om te bepalen wat als bekrachtiger kan werken, of om te analyseren wat jouw doelgedrag momenteel aan het verhinderen kan zijn.")
                    }

                    HTML.ol([
                        "class": "\(Self.block)__preview-list",
                        "data-premack-preview-list": ""
                    ]) {}
                }
            }
        }
    }

    private func responseRow(
        _ label: String,
        _ value: Int
    ) -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__response-row", "data-premack-response-row": ""]) {
            HTML.input([
                "type": "text",
                "value": label,
                "aria-label": "Reactie",
                "data-premack-response-name": ""
            ])

            HTML.input([
                "type": "range",
                "min": "0",
                "max": "100",
                "value": "\(value)",
                "aria-label": "Waarschijnlijkheid",
                "data-premack-response-value": ""
            ])

            HTML.span(["class": "\(Self.block)__score", "data-premack-response-score": ""]) {
                HTML.text("\(value)")
            }

            HTML.button([
                "type": "button",
                "class": "\(Self.block)__remove",
                "aria-label": "Verwijder reactie",
                "data-premack-remove-response": ""
            ]) {
                HTML.text("×")
            }
        }
    }

    private func contingencyTool() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__surface"]) {
            HTML.div(["class": "\(Self.block)__mode-grid"]) {
                modeOption(
                    value: "reinforce",
                    title: "Lage-kans respons bekrachtigen",
                    text: "Eerst de minder waarschijnlijke respons, daarna toegang tot de waarschijnlijkere respons.",
                    checked: true
                )

                modeOption(
                    value: "gate",
                    title: "Hoge-kans respons poorten",
                    text: "De waarschijnlijkere respons wordt niet direct beschikbaar, maar loopt via een minder waarschijnlijke respons.",
                    checked: false
                )
            }

            HTML.div(["class": "\(Self.block)__form-grid"]) {
                field("Antecedent", key: "antecedent", placeholder: "Als de riem losgaat...")
                field("Lage-kans respons", key: "low", placeholder: "rustig inchecken")
                field("Hoge-kans respons", key: "high", placeholder: "vrij snuffelen")
                field("Consequent / toegang", key: "consequent", placeholder: "toegang tot snuffelen / lopen / spel")
            }

            HTML.div(["class": "\(Self.block)__diagram", "aria-live": "polite"]) {
                diagramBox("Antecedent", key: "antecedent")
                arrow()
                diagramBox("Respons-gate", key: "gate")
                arrow()
                diagramBox("Consequent", key: "consequent")
            }

            HTML.p(["class": "\(Self.block)__summary", "data-premack-summary": ""]) {}
        }
    }

    private func modeOption(
        value: String,
        title: String,
        text: String,
        checked: Bool
    ) -> any HTMLNode {
        var inputAttrs: HTMLAttribute = [
            "type": "radio",
            "name": "\(id)-mode",
            "value": value,
            "data-premack-mode": ""
        ]

        if checked {
            inputAttrs.merge(.bool("checked", true))
        }

        return HTML.label(["class": "\(Self.block)__mode"]) {
            HTML.input(inputAttrs)

            HTML.span(["class": "\(Self.block)__mode-copy"]) {
                HTML.b { HTML.text(title) }
                HTML.span { HTML.text(text) }
            }
        }
    }

    private func field(
        _ label: String,
        key: String,
        placeholder: String
    ) -> any HTMLNode {
        HTML.label(["class": "\(Self.block)__field"]) {
            HTML.span { HTML.text(label) }

            HTML.textarea([
                "data-premack-field": key,
                "placeholder": placeholder
            ]) {}
        }
    }

    private func diagramBox(
        _ label: String,
        key: String
    ) -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__diagram-box"]) {
            HTML.span(["class": "\(Self.block)__diagram-label"]) {
                HTML.text(label)
            }

            HTML.strong(["data-premack-output": key]) {
                HTML.text("—")
            }
        }
    }

    private func arrow() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__arrow", "aria-hidden": "true"]) {
            HTML.text("→")
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("width", "min(1040px, calc(100% - 32px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "clamp(28px, 5vw, 56px) 0"),
                    CSS.decl("color", "var(--text-color, #202124)")
                ),

                CSS.rule(".\(block), .\(block) *", CSS.decl("box-sizing", "border-box")),

                CSS.rule(
                    ".\(block)__hero",
                    CSS.decl("max-width", "820px"),
                    CSS.decl("margin", "0 0 28px")
                ),

                CSS.rule(
                    ".\(block)__eyebrow",
                    CSS.decl("margin", "0 0 8px"),
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__hero h1",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(2.1rem, 6vw, 4.8rem)"),
                    CSS.decl("line-height", ".95"),
                    CSS.decl("letter-spacing", "-.055em")
                ),

                CSS.rule(
                    ".\(block)__lead",
                    CSS.decl("margin", "18px 0 0"),
                    CSS.decl("font-size", "1.08rem"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__surface",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("padding", "clamp(16px, 3vw, 24px)"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "24px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #fff) 96%, var(--text-color) 4%)"),
                    CSS.decl("box-shadow", "0 18px 48px rgba(15, 23, 42, .08)")
                ),

                CSS.rule(
                    ".\(block)__split",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1.2fr) minmax(280px, .8fr)"),
                    CSS.decl("gap", "16px")
                ),

                CSS.rule(
                    ".\(block)__panel, .\(block)__field, .\(block)__mode, .\(block)__diagram-box",
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #fff) 88%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__panel",
                    CSS.decl("padding", "16px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__panel-head",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("margin-bottom", "12px")
                ),

                CSS.rule(
                    ".\(block)__panel h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.05rem"),
                    CSS.decl("line-height", "1.15")
                ),

                CSS.rule(
                    ".\(block)__field",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("padding", "14px")
                ),

                CSS.rule(
                    ".\(block)__field label, .\(block)__field > span",
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".04em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block) input[type=\"text\"], .\(block) textarea",
                    CSS.decl("width", "100%"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("padding", "10px 12px"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("background", "var(--surface-color, #fff)")
                ),

                CSS.rule(
                    ".\(block) textarea",
                    CSS.decl("min-height", "84px"),
                    CSS.decl("resize", "vertical")
                ),

                CSS.rule(
                    ".\(block)__response-list",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".\(block)__response-row",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(160px, 1fr) minmax(120px, 190px) 42px 34px"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".\(block)__score",
                    CSS.decl("text-align", "right"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__button, .\(block)__remove",
                    CSS.decl("appearance", "none"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 9%, transparent)"),
                    CSS.decl("color", "var(--link-color)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(block)__button",
                    CSS.decl("padding", "8px 12px")
                ),

                CSS.rule(
                    ".\(block)__remove",
                    CSS.decl("width", "34px"),
                    CSS.decl("height", "34px")
                ),

                CSS.rule(
                    ".\(block)__hint, .\(block)__summary",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__preview-list",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("margin", "14px 0 0"),
                    CSS.decl("padding-left", "22px")
                ),

                CSS.rule(
                    ".\(block)__preview-list li",
                    CSS.decl("padding", "10px 12px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 7%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__mode-grid, .\(block)__form-grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(2, minmax(0, 1fr))"),
                    CSS.decl("gap", "14px")
                ),

                CSS.rule(
                    ".\(block)__mode",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "auto minmax(0, 1fr)"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(block)__mode-copy",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px")
                ),

                CSS.rule(
                    ".\(block)__mode-copy span",
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.4"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__diagram",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) auto minmax(0, 1fr) auto minmax(0, 1fr)"),
                    CSS.decl("align-items", "stretch"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".\(block)__diagram-box",
                    CSS.decl("display", "grid"),
                    CSS.decl("align-content", "start"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("min-height", "112px")
                ),

                CSS.rule(
                    ".\(block)__diagram-label",
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".06em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__diagram-box strong",
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("line-height", "1.25")
                ),

                CSS.rule(
                    ".\(block)__arrow",
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("font-size", "1.5rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("color", "var(--muted-text-color)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 820px)",
                    CSS.rule(".\(block)__split", CSS.decl("grid-template-columns", "1fr")),
                    CSS.rule(".\(block)__mode-grid, .\(block)__form-grid", CSS.decl("grid-template-columns", "1fr")),
                    CSS.rule(".\(block)__diagram", CSS.decl("grid-template-columns", "1fr")),
                    CSS.rule(".\(block)__arrow", CSS.decl("transform", "rotate(90deg)")),
                    CSS.rule(".\(block)__response-row", CSS.decl("grid-template-columns", "1fr"))
                )
            ]
        )
    }
}

public struct PremackToolScript: ReusableComponent {
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
        if (window.wcPremackTool?.initialized) return;

        const rootSelector = '[data-premack-tool]';

        function text(root, selector, fallback = '') {
            return root.querySelector(selector)?.value?.trim() || fallback;
        }

        function updateHierarchy(root) {
            const rows = Array.from(root.querySelectorAll('[data-premack-response-row]'));
            const preview = root.querySelector('[data-premack-preview-list]');

            rows.forEach(row => {
                const score = row.querySelector('[data-premack-response-score]');
                const value = row.querySelector('[data-premack-response-value]');
                if (score && value) score.textContent = value.value;
            });

            if (!preview) return;

            const items = rows
                .map(row => ({
                    label: row.querySelector('[data-premack-response-name]')?.value?.trim(),
                    value: Number(row.querySelector('[data-premack-response-value]')?.value || 0)
                }))
                .filter(item => item.label)
                .sort((a, b) => b.value - a.value);

            preview.replaceChildren();

            items.forEach(item => {
                const li = document.createElement('li');
                li.textContent = `${item.label} · ${item.value}`;
                preview.appendChild(li);
            });
        }

        function addResponse(root) {
            const list = root.querySelector('[data-premack-response-list]');
            if (!list) return;

            const row = document.createElement('div');
            row.className = 'wc-premack-tool__response-row';
            row.setAttribute('data-premack-response-row', '');
            row.innerHTML = `
                <input type="text" aria-label="Reactie" data-premack-response-name="" placeholder="nieuwe reactie">
                <input type="range" min="0" max="100" value="50" aria-label="Waarschijnlijkheid" data-premack-response-value="">
                <span class="wc-premack-tool__score" data-premack-response-score="">50</span>
                <button type="button" class="wc-premack-tool__remove" aria-label="Verwijder reactie" data-premack-remove-response="">×</button>
            `;

            list.appendChild(row);
            updateHierarchy(root);
        }

        function updateContingency(root) {
            const mode = root.querySelector('[data-premack-mode]:checked')?.value || 'reinforce';
            const antecedent = text(root, '[data-premack-field="antecedent"]', 'Antecedent');
            const low = text(root, '[data-premack-field="low"]', 'lage-kans respons');
            const high = text(root, '[data-premack-field="high"]', 'hoge-kans respons');
            const consequent = text(root, '[data-premack-field="consequent"]', high);

            const out = key => root.querySelector(`[data-premack-output="${key}"]`);

            if (out('antecedent')) out('antecedent').textContent = antecedent;
            if (out('consequent')) out('consequent').textContent = consequent;

            const gateText = mode === 'reinforce'
                ? `${low} → toegang tot ${high}`
                : `${high} wordt gepoort via ${low}`;

            if (out('gate')) out('gate').textContent = gateText;

            const summary = root.querySelector('[data-premack-summary]');
            if (summary) {
                summary.textContent = mode === 'reinforce'
                    ? `Als ${antecedent}, dan eerst ${low}; daarna wordt ${high} beschikbaar.`
                    : `Als ${antecedent}, dan wordt ${high} niet direct vrijgegeven; toegang loopt via ${low}.`;
            }
        }

        function update(root) {
            if (!root) return;

            const kind = root.getAttribute('data-premack-tool');

            if (kind === 'hierarchy') updateHierarchy(root);
            if (kind === 'contingency') updateContingency(root);
        }

        document.addEventListener('input', event => {
            const root = event.target?.closest?.(rootSelector);
            update(root);
        }, true);

        document.addEventListener('change', event => {
            const root = event.target?.closest?.(rootSelector);
            update(root);
        }, true);

        document.addEventListener('click', event => {
            const add = event.target?.closest?.('[data-premack-add-response]');
            const remove = event.target?.closest?.('[data-premack-remove-response]');

            if (add) {
                const root = add.closest(rootSelector);
                addResponse(root);
            }

            if (remove) {
                const root = remove.closest(rootSelector);
                const rows = root?.querySelectorAll?.('[data-premack-response-row]') || [];
                if (rows.length > 1) remove.closest('[data-premack-response-row]')?.remove();
                update(root);
            }
        }, true);

        function init(scope = document) {
            const roots = scope.matches?.(rootSelector)
                ? [scope]
                : Array.from(scope.querySelectorAll?.(rootSelector) || []);

            roots.forEach(update);
        }

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => init());
        } else {
            init();
        }

        window.wcPremackTool = {
            initialized: true,
            init,
            update
        };
    })();
    """#
}
