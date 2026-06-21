import Constructors
import CSS
import HTML
import JS

public struct ReactivityProfileTool: ReusableComponent, Sendable {
    public static let block = "wc-reactivity-profile-tool"

    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
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
                        "data-reactivity-profile-tool": ""
                    ]
                ) {
                    hero()

                    HTML.section(["class": "\(Self.block)__surface"]) {
                        HTML.div(["class": "\(Self.block)__mount", "data-reactivity-mount": ""]) {}
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : [],
            scripts: includeScript ? ReactivityProfileToolScript().nodes.scripts : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    private func hero() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__hero"]) {
            HTML.p(["class": "\(Self.block)__eyebrow"]) {
                HTML.text("Hulpmiddel · reactiviteit")
            }

            HTML.h1 {
                HTML.text("Reactiviteitsprofiel")
            }

            HTML.p(["class": "\(Self.block)__lead"]) {
                HTML.text("Schat welk reactiepatroon het meest lijkt op het gedrag van de hond, en welke behandelmodifiers extra aandacht vragen.")
            }

            HTML.div(["class": "\(Self.block)__note"]) {
                HTML.strong {
                    HTML.text("Geen diagnose.")
                }

                HTML.span {
                    HTML.text(" Dit hulpmiddel gebruikt de gedragsassen uit het DRD-onderzoek als rekenlaag, maar vertaalt de uitkomst naar een Hondenmeesters-profiel voor risico, frustratiedruk en trainingsprioriteit.")
                }
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("width", "min(1120px, calc(100% - 32px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "clamp(28px, 5vw, 56px) 0"),
                    CSS.decl("color", "var(--text-color, #202124)")
                ),

                CSS.rule(".\(block), .\(block) *", CSS.decl("box-sizing", "border-box")),

                CSS.rule(
                    ".\(block)__hero",
                    CSS.decl("max-width", "860px"),
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
                    CSS.decl("font-size", "clamp(2.2rem, 6vw, 5rem)"),
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
                    ".\(block)__note",
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "18px 0 0"),
                    CSS.decl("padding", "14px 16px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 7%, transparent)"),
                    CSS.decl("font-size", ".94rem"),
                    CSS.decl("line-height", "1.5")
                ),

                CSS.rule(
                    ".\(block)__surface",
                    CSS.decl("padding", "clamp(16px, 3vw, 24px)"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "26px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #fff) 96%, var(--text-color) 4%)"),
                    CSS.decl("box-shadow", "0 18px 48px rgba(15, 23, 42, .08)")
                ),

                CSS.rule(
                    ".\(block)__grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) minmax(320px, .78fr)"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("align-items", "start")
                ),

                CSS.rule(
                    ".\(block)__panel",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "20px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #fff) 90%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__panel h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.05rem"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".\(block)__hint",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__fields",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".\(block)__field",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(160px, 1fr) minmax(140px, 210px)"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("padding", "12px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #fff) 88%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__field span",
                    CSS.decl("font-size", ".95rem"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("line-height", "1.3")
                ),

                CSS.rule(
                    ".\(block)__field small",
                    CSS.decl("display", "block"),
                    CSS.decl("margin-top", "4px"),
                    CSS.decl("font-size", ".8rem"),
                    CSS.decl("font-weight", "450"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block) select",
                    CSS.decl("width", "100%"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("padding", "9px 12px"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("background", "var(--surface-color, #fff)")
                ),

                CSS.rule(
                    ".\(block)__result-head",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 10%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__result-head strong",
                    CSS.decl("font-size", "1.35rem"),
                    CSS.decl("line-height", "1.1")
                ),

                CSS.rule(
                    ".\(block)__result-head span",
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__stack",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".\(block)__metric",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "6px")
                ),

                CSS.rule(
                    ".\(block)__metric-top",
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "720")
                ),

                CSS.rule(
                    ".\(block)__bar",
                    CSS.decl("height", "10px"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 10%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__bar > span",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "var(--value, 0%)"),
                    CSS.decl("height", "100%"),
                    CSS.decl("border-radius", "inherit"),
                    CSS.decl("background", "var(--link-color)")
                ),

                CSS.rule(
                    ".\(block)__priority-list",
                    CSS.decl("margin", "0"),
                    CSS.decl("padding-left", "20px"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--muted-text-color)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 860px)",
                    CSS.rule(".\(block)__grid", CSS.decl("grid-template-columns", "1fr")),
                    CSS.rule(".\(block)__field", CSS.decl("grid-template-columns", "1fr"))
                )
            ]
        )
    }
}

public struct ReactivityProfileToolScript: ReusableComponent {
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
        if (window.wcReactivityProfileTool?.initialized) return;

        const rootSelector = '[data-reactivity-profile-tool]';
        const tau = 1.1;

        const behaviours = [
            ['nipping', 'Happen / nippen', 'korte contactpoging met tanden'],
            ['biting', 'Bijten', 'contact met beet of schade-risico'],
            ['snapping', 'Snappen', 'lucht-hap of snelle dreigbeet'],
            ['barking', 'Blaffen', 'herhaald of intens blaffen naar honden'],
            ['lunging', 'Uitvallen', 'naar voren schieten of in de lijn hangen'],
            ['whining', 'Piepen / janken', 'vocale spanning of frustratie'],
            ['growling', 'Grommen', 'laag dreigend geluid'],
            ['snarling', 'Lip optrekken', 'tanden tonen / snauwen'],
            ['stiff_posture', 'Stijf fixeren', 'stijve houding, hackles, intense stare']
        ];

        const modifiers = [
            ['restraint', 'Lijn / barrière-effect', 'Wordt het duidelijk erger aan lijn, hek, raam, deur of auto?'],
            ['recovery', 'Herstel na prikkel', 'Hoe lang blijft de hond hoog na een ontmoeting?'],
            ['distance', 'Afstandsgevoeligheid', 'Hoeveel afstand is nodig om nog bereikbaar te blijven?'],
            ['disengage', 'Loskomen van prikkel', 'Kan de hond wegkijken, snuffelen, eten of terugkoppelen?'],
            ['contact', 'Contactgeschiedenis', 'Is er eerder fysiek contact of schade geweest?'],
            ['redirect', 'Redirectie-risico', 'Richt spanning zich soms op lijn, handler of huisgenoot?'],
            ['handling', 'Controleerbaarheid', 'Kan de handler veilig afstand maken en de hond houden?']
        ];

        const frequencyOptions = [
            [0, 'Nooit'],
            [1, 'Soms'],
            [2, 'Vaak / altijd']
        ];

        const modifierOptions = [
            [0, 'Laag / niet herkenbaar'],
            [1, 'Soms herkenbaar'],
            [2, 'Duidelijk herkenbaar'],
            [3, 'Sterk bepalend']
        ];

        const clusters = {
            1: ['Lage-risico signaleerder', 'veel communicatie, weinig orale escalatie'],
            2: ['Frustratie-escalator', 'hoge frustratie, vooral bij blokkade of beperking'],
            3: ['Impulsieve escalator', 'meer posturing en contactrisico, ook zonder extreme frustratie'],
            4: ['Snelle risico-escalator', 'hoog over alle assen; veiligheidsmarge eerst vergroten']
        };

        const loadings = {
            pc1: { nipping: .873, biting: .855, snapping: .629, barking: -.128, lunging: .108, whining: .096, growling: -.038, snarling: .225, stiff_posture: .041 },
            pc2: { nipping: .046, biting: .029, snapping: -.038, barking: .766, lunging: .738, whining: .641, growling: .060, snarling: -.161, stiff_posture: .144 },
            pc3: { nipping: -.027, biting: -.043, snapping: .324, barking: .245, lunging: .150, whining: -.292, growling: .822, snarling: .722, stiff_posture: .580 }
        };

        const means = {
            1: [.3472, 1.8517, 1.1995],
            2: [.7747, 3.6694, 2.0571],
            3: [1.7016, 1.9332, 2.6665],
            4: [3.2282, 3.5188, 4.1659]
        };

        const clamp = (value, min = 0, max = 1) => Math.min(max, Math.max(min, value));
        const pct = value => Math.round(clamp(value) * 100);

        function optionsHTML(options) {
            return options.map(([value, label]) => `<option value="${value}">${label}</option>`).join('');
        }

        function metricHTML(label, value, detail = '') {
            return `
                <div class="wc-reactivity-profile-tool__metric">
                    <div class="wc-reactivity-profile-tool__metric-top">
                        <span>${label}</span>
                        <span>${value}%</span>
                    </div>
                    <div class="wc-reactivity-profile-tool__bar" aria-hidden="true">
                        <span style="--value: ${value}%"></span>
                    </div>
                    ${detail ? `<p class="wc-reactivity-profile-tool__hint">${detail}</p>` : ''}
                </div>
            `;
        }

        function fieldHTML(kind, item) {
            const [key, label, help] = item;
            const attr = kind === 'behaviour' ? 'data-reactivity-behaviour' : 'data-reactivity-modifier';
            const options = kind === 'behaviour' ? frequencyOptions : modifierOptions;

            return `
                <label class="wc-reactivity-profile-tool__field">
                    <span>${label}<small>${help}</small></span>
                    <select ${attr}="${key}">${optionsHTML(options)}</select>
                </label>
            `;
        }

        function render(root) {
            const mount = root.querySelector('[data-reactivity-mount]');
            if (!mount || mount.dataset.ready) return;

            mount.dataset.ready = 'true';
            mount.innerHTML = `
                <div class="wc-reactivity-profile-tool__grid">
                    <div class="wc-reactivity-profile-tool__panel">
                        <h2>Gedragingen bij andere honden</h2>
                        <p class="wc-reactivity-profile-tool__hint">Deze negen gedragingen vormen de paper-derived rekenlaag. Vul in hoe vaak ze optreden tijdens reactiviteit naar honden.</p>
                        <div class="wc-reactivity-profile-tool__fields">${behaviours.map(item => fieldHTML('behaviour', item)).join('')}</div>

                        <h2>Behandelmodifiers</h2>
                        <p class="wc-reactivity-profile-tool__hint">Deze velden veranderen de cluster niet. Ze helpen bepalen hoeveel veiligheidsmarge, herstel en arousal-outlet het plan nodig heeft.</p>
                        <div class="wc-reactivity-profile-tool__fields">${modifiers.map(item => fieldHTML('modifier', item)).join('')}</div>
                    </div>

                    <aside class="wc-reactivity-profile-tool__panel" aria-live="polite">
                        <div class="wc-reactivity-profile-tool__result-head">
                            <strong data-reactivity-primary>—</strong>
                            <span data-reactivity-summary>Vul de observaties in om het profiel te berekenen.</span>
                        </div>

                        <h2>Cluster-overeenkomst</h2>
                        <div class="wc-reactivity-profile-tool__stack" data-reactivity-matches></div>

                        <h2>Gedragsassen</h2>
                        <div class="wc-reactivity-profile-tool__stack" data-reactivity-axes></div>

                        <h2>Behandelmodifiers</h2>
                        <div class="wc-reactivity-profile-tool__stack" data-reactivity-modifiers></div>

                        <h2>Trainingsprioriteit</h2>
                        <ol class="wc-reactivity-profile-tool__priority-list" data-reactivity-priorities></ol>
                    </aside>
                </div>
            `;
        }

        function values(root, selector) {
            const out = {};
            root.querySelectorAll(selector).forEach(input => {
                const key = input.getAttribute(selector.includes('behaviour') ? 'data-reactivity-behaviour' : 'data-reactivity-modifier');
                out[key] = Number(input.value || 0);
            });
            return out;
        }

        function componentScore(input, key) {
            return Object.keys(loadings[key]).reduce((sum, behaviour) => {
                return sum + ((input[behaviour] || 0) * loadings[key][behaviour]);
            }, 0);
        }

        function calculate(input) {
            const pc1 = componentScore(input, 'pc1');
            const pc2 = componentScore(input, 'pc2');
            const pc3 = componentScore(input, 'pc3');

            const rows = [1, 2, 3, 4].map(id => {
                const mean = means[id];
                const distance = Math.sqrt(
                    Math.pow(pc1 - mean[0], 2) +
                    Math.pow(pc2 - mean[1], 2) +
                    Math.pow(pc3 - mean[2], 2)
                );

                return {
                    id,
                    distance,
                    raw: Math.exp(-(distance * distance) / (2 * tau * tau))
                };
            });

            const total = rows.reduce((sum, row) => sum + row.raw, 0) || 1;

            return {
                pc1,
                pc2,
                pc3,
                matches: rows
                    .map(row => ({ ...row, match: (row.raw / total) * 100 }))
                    .sort((a, b) => b.match - a.match)
            };
        }

        function axisLabel(value, cuts) {
            if (value < cuts[0]) return 'laag';
            if (value < cuts[1]) return 'middel';
            if (value < cuts[2]) return 'hoog';
            return 'zeer hoog';
        }

        function update(root) {
            if (!root) return;

            render(root);

            const input = values(root, '[data-reactivity-behaviour]');
            const mod = values(root, '[data-reactivity-modifier]');
            const result = calculate(input);
            const primary = result.matches[0];
            const second = result.matches[1];
            const cluster = clusters[primary.id];
            const ambiguous = primary.match - second.match < 15;

            root.querySelector('[data-reactivity-primary]').textContent = `${cluster[0]} · ${Math.round(primary.match)}% match`;
            root.querySelector('[data-reactivity-summary]').textContent = ambiguous
                ? `Grensprofiel: ook ${clusters[second.id][0]} past duidelijk. Interpreteer dit als mengbeeld, niet als harde categorie.`
                : cluster[1];

            root.querySelector('[data-reactivity-matches]').innerHTML = result.matches.map(row => {
                return metricHTML(`${clusters[row.id][0]}`, Math.round(row.match), clusters[row.id][1]);
            }).join('');

            const axes = [
                ['Orale aanval', result.pc1, 3.8, axisLabel(result.pc1, [.75, 1.7, 3.0])],
                ['Frustratie', result.pc2, 4.2, axisLabel(result.pc2, [1.4, 2.4, 3.4])],
                ['Posturing', result.pc3, 4.6, axisLabel(result.pc3, [1.2, 2.1, 3.2])]
            ];

            root.querySelector('[data-reactivity-axes]').innerHTML = axes.map(([label, score, max, band]) => {
                return metricHTML(`${label}: ${band}`, pct(score / max), `ruwe componentscore: ${score.toFixed(2)}`);
            }).join('');

            const frustration = pct(
                .48 * clamp(result.pc2 / 3.7) +
                .18 * clamp((mod.restraint || 0) / 3) +
                .18 * clamp((mod.recovery || 0) / 3) +
                .16 * clamp((mod.disengage || 0) / 3)
            );

            const risk = pct(
                .46 * clamp(result.pc1 / 3.3) +
                .22 * clamp((mod.contact || 0) / 3) +
                .18 * clamp((mod.redirect || 0) / 3) +
                .14 * clamp(result.pc3 / 4.1)
            );

            const management = pct(
                .40 * clamp(risk / 100) +
                .24 * clamp((mod.distance || 0) / 3) +
                .20 * clamp((mod.recovery || 0) / 3) +
                .16 * clamp((mod.handling || 0) / 3)
            );

            root.querySelector('[data-reactivity-modifiers]').innerHTML = [
                metricHTML('Frustratiedruk', frustration, 'hoeveel herstel, ontlading en autonomie eerst nodig zijn'),
                metricHTML('Escalatierisico', risk, 'hoe klein de veiligheidsmarge is bij onverwachte nabijheid'),
                metricHTML('Managementbehoefte', management, 'hoe strak afstand, routes, materiaal en handler-plan moeten zijn')
            ].join('');

            const priorities = [];

            if (risk >= 70) {
                priorities.push('Begin met veiligheidsmarge: afstand, voorspelbare routes, materiaalcontrole en geen geplande hond-hond confrontaties.');
            } else if (risk >= 45) {
                priorities.push('Houd management actief terwijl je alternatief gedrag opbouwt; test niet te snel dichterbij.');
            } else {
                priorities.push('Werk vooral aan tijdig signaleren, afstand nemen en rustig disengagen voordat spanning oploopt.');
            }

            if (frustration >= 70) {
                priorities.push('Plan arousal-outlet en herstelmomenten expliciet in; blootstelling zonder ontlading zal waarschijnlijk vastlopen.');
            } else if (frustration >= 45) {
                priorities.push('Bouw frustratietolerantie op via voorspelbare keuze, afstand en beloonbare alternatieven.');
            }

            if (primary.id === 3 || primary.id === 4 || risk >= 65) {
                priorities.push('Behandel contactrisico als apart thema: niet alleen minder blaffen, maar vooral meer remming, herstel en veilige beslissingen.');
            }

            if (ambiguous) {
                priorities.push('Omdat het profiel gemengd is: baseer de eerste trainingsstap op de hoogste modifier, niet alleen op de clustertitel.');
            }

            root.querySelector('[data-reactivity-priorities]').innerHTML = priorities
                .map(item => `<li>${item}</li>`)
                .join('');
        }

        document.addEventListener('input', event => {
            update(event.target?.closest?.(rootSelector));
        }, true);

        document.addEventListener('change', event => {
            update(event.target?.closest?.(rootSelector));
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

        window.wcReactivityProfileTool = {
            initialized: true,
            init,
            update
        };
    })();
    """#
}
