import Constructors
import CSS
import HTML
import JS

public struct BenefitCostBar: ReusableComponent, Sendable {
    public struct Segment: Sendable {
        public let label: String
        public let value: Int

        public init(
            label: String,
            value: Int
        ) {
            self.label = label
            self.value = value
        }
    }

    private enum ExpectationState: String, Sendable {
        case negative
        case neutral
        case positive
    }

    private enum ClassName {
        static let root = "wc-benefit-cost-bar"
        static let stage = "wc-benefit-cost-bar__stage"
        static let row = "wc-benefit-cost-bar__row"
        static let rowLabel = "wc-benefit-cost-bar__row-label"
        static let sliderWrap = "wc-benefit-cost-bar__slider-wrap"
        static let track = "wc-benefit-cost-bar__track"
        static let fill = "wc-benefit-cost-bar__fill"
        static let benefit = "wc-benefit-cost-bar__fill--benefit"
        static let cost = "wc-benefit-cost-bar__fill--cost"
        static let input = "wc-benefit-cost-bar__input"
        static let benefitInput = "wc-benefit-cost-bar__input--benefit"
        static let costInput = "wc-benefit-cost-bar__input--cost"
        static let value = "wc-benefit-cost-bar__value"
        static let equation = "wc-benefit-cost-bar__equation"
        static let expectation = "wc-benefit-cost-bar__expectation"
        static let expectationKicker = "wc-benefit-cost-bar__expectation-kicker"
        static let expectationState = "wc-benefit-cost-bar__expectation-state"
        static let result = "wc-benefit-cost-bar__result"
        static let caption = "wc-benefit-cost-bar__caption"
    }

    public let id: String
    public let benefit: Segment
    public let cost: Segment
    public let caption: String?
    public let minValue: Int
    public let maxValue: Int
    public let step: Int
    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        id: String = "benefit-cost-bar",
        benefit: Segment = Segment(
            label: "Opbrengst",
            value: 72
        ),
        cost: Segment = Segment(
            label: "Kost / risico",
            value: 38
        ),
        caption: String? = nil,
        minValue: Int = 0,
        maxValue: Int = 100,
        step: Int = 1,
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
        self.id = id
        self.benefit = benefit
        self.cost = cost
        self.caption = caption
        self.minValue = minValue
        self.maxValue = maxValue
        self.step = step
        self.includeStyles = includeStyles
        self.includeScript = includeScript
    }

    private var normalizedMin: Int {
        min(minValue, maxValue)
    }

    private var normalizedMax: Int {
        max(minValue, maxValue)
    }

    private var normalizedStep: Int {
        max(step, 1)
    }

    private var benefitValue: Int {
        clampedValue(benefit.value)
    }

    private var costValue: Int {
        clampedValue(cost.value)
    }

    private var result: Int {
        benefitValue - costValue
    }

    private var expectationState: ExpectationState {
        if result < 0 {
            return .negative
        }

        if result == 0 {
            return .neutral
        }

        return .positive
    }

    private var expectationText: String {
        switch expectationState {
        case .negative:
            return "pessimistisch: remmende werking"
        case .neutral:
            return "neutraal: afbuiging naar individuele voorkeur"
        case .positive:
            return "optimistisch: aansporende werking"
        }
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.figure(
                    [
                        "id": id,
                        "class": ClassName.root,
                        "data-benefit-cost-bar": "",
                        "data-benefit-cost-state": expectationState.rawValue
                    ]
                ) {
                    HTML.div(
                        [
                            "class": ClassName.stage,
                            "role": "group",
                            "aria-label": "Gedragseconomie: gedrag wordt waarschijnlijker wanneer verwachte opbrengst groter is dan verwachte kost."
                        ]
                    ) {
                        row(
                            segment: benefit,
                            kind: "benefit",
                            value: benefitValue,
                            fillClass: ClassName.benefit,
                            inputClass: ClassName.benefitInput
                        )

                        row(
                            segment: cost,
                            kind: "cost",
                            value: costValue,
                            fillClass: ClassName.cost,
                            inputClass: ClassName.costInput
                        )

                        HTML.div(["class": ClassName.equation]) {
                            HTML.div(["class": ClassName.expectation]) {
                                HTML.span(["class": ClassName.expectationKicker]) {
                                    HTML.text("Verwachting:")
                                }

                                HTML.span(
                                    [
                                        "class": ClassName.expectationState,
                                        "data-benefit-cost-expectation": ""
                                    ]
                                ) {
                                    HTML.text(expectationText)
                                }
                            }

                            HTML.span(
                                [
                                    "class": ClassName.result,
                                    "data-benefit-cost-result": ""
                                ]
                            ) {
                                HTML.text(resultText)
                            }
                        }
                    }

                    if let caption, !caption.isEmpty {
                        HTML.figcaption(["class": ClassName.caption]) {
                            HTML.text(caption)
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : [],
            scripts: includeScript ? BenefitCostBarScript().nodes.scripts : []
        )
    }

    private var resultText: String {
        result > 0 ? "+\(result)" : "\(result)"
    }

    private func row(
        segment: Segment,
        kind: String,
        value: Int,
        fillClass: String,
        inputClass: String
    ) -> any HTMLNode {
        let inputID = "\(id)-\(kind)-slider"

        return HTML.div(
            [
                "class": ClassName.row,
                "data-benefit-cost-row": kind
            ]
        ) {
            HTML.label(
                [
                    "class": ClassName.rowLabel,
                    "for": inputID
                ]
            ) {
                HTML.text(segment.label)
            }

            HTML.div(
                [
                    "class": ClassName.sliderWrap,
                    "style": "--wc-benefit-cost-width: \(percentage(value));",
                    "data-benefit-cost-slider-wrap": kind
                ]
            ) {
                HTML.div(["class": ClassName.track]) {
                    HTML.div(
                        [
                            "class": "\(ClassName.fill) \(fillClass)",
                            "data-benefit-cost-fill": kind
                        ]
                    ) {}
                }

                HTML.input(
                    [
                        "id": inputID,
                        "class": "\(ClassName.input) \(inputClass)",
                        "type": "range",
                        "min": "\(normalizedMin)",
                        "max": "\(normalizedMax)",
                        "step": "\(normalizedStep)",
                        "value": "\(value)",
                        "aria-label": segment.label,
                        "data-benefit-cost-slider": kind
                    ]
                )
            }

            HTML.div(
                [
                    "class": ClassName.value,
                    "data-benefit-cost-value": kind
                ]
            ) {
                HTML.text("\(value)")
            }
        }
    }

    private func clampedValue(
        _ value: Int
    ) -> Int {
        min(
            max(value, normalizedMin),
            normalizedMax
        )
    }

    private func percentage(
        _ value: Int
    ) -> String {
        let range = max(normalizedMax - normalizedMin, 1)
        let clamped = clampedValue(value)
        let percent = (clamped - normalizedMin) * 100 / range

        return "\(percent)%"
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
                    CSS.decl("margin", "28px 0"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)")
                ),

                CSS.rule(
                    ".\(ClassName.row)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(96px, 140px) minmax(0, 1fr) minmax(42px, auto)"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "12px")
                ),

                CSS.rule(
                    ".\(ClassName.rowLabel)",
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("line-height", "1.1")
                ),

                CSS.rule(
                    ".\(ClassName.sliderWrap)",
                    CSS.decl("position", "relative"),
                    CSS.decl("height", "30px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(ClassName.track)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "0"),
                    CSS.decl("right", "0"),
                    CSS.decl("top", "50%"),
                    CSS.decl("height", "16px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("transform", "translateY(-50%)"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 8%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--text-color) 8%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.fill)",
                    CSS.decl("height", "100%"),
                    CSS.decl("width", "var(--wc-benefit-cost-width)"),
                    CSS.decl("border-radius", "inherit"),
                    CSS.decl("transition", "width .16s ease, background-color .16s ease")
                ),

                CSS.rule(
                    ".\(ClassName.benefit)",
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 72%, var(--text-color) 12%)")
                ),

                CSS.rule(
                    ".\(ClassName.cost)",
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 48%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.input)",
                    CSS.decl("-webkit-appearance", "none"),
                    CSS.decl("appearance", "none"),
                    CSS.decl("position", "absolute"),
                    CSS.decl("inset", "0"),
                    CSS.decl("z-index", "2"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "30px"),
                    CSS.decl("margin", "0"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(ClassName.input)::-webkit-slider-runnable-track",
                    CSS.decl("height", "30px"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("border", "0")
                ),

                CSS.rule(
                    ".\(ClassName.input)::-webkit-slider-thumb",
                    CSS.decl("-webkit-appearance", "none"),
                    CSS.decl("appearance", "none"),
                    CSS.decl("width", "24px"),
                    CSS.decl("height", "24px"),
                    CSS.decl("margin-top", "3px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("border", "3px solid var(--text-color)"),
                    CSS.decl("box-shadow", "0 2px 8px rgba(15, 23, 42, .20)")
                ),

                CSS.rule(
                    ".\(ClassName.input)::-moz-range-track",
                    CSS.decl("height", "30px"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("border", "0")
                ),

                CSS.rule(
                    ".\(ClassName.input)::-moz-range-thumb",
                    CSS.decl("width", "20px"),
                    CSS.decl("height", "20px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("border", "3px solid var(--text-color)"),
                    CSS.decl("box-shadow", "0 2px 8px rgba(15, 23, 42, .20)")
                ),

                CSS.rule(
                    ".\(ClassName.benefitInput)::-webkit-slider-thumb",
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 76%, var(--text-color) 10%)")
                ),

                CSS.rule(
                    ".\(ClassName.benefitInput)::-moz-range-thumb",
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 76%, var(--text-color) 10%)")
                ),

                CSS.rule(
                    ".\(ClassName.costInput)::-webkit-slider-thumb",
                    CSS.decl("border-color", "color-mix(in srgb, var(--text-color) 50%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.costInput)::-moz-range-thumb",
                    CSS.decl("border-color", "color-mix(in srgb, var(--text-color) 50%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.input):focus-visible",
                    CSS.decl("outline", "none")
                ),

                CSS.rule(
                    ".\(ClassName.input):focus-visible::-webkit-slider-thumb",
                    CSS.decl("outline", "2px solid var(--link-color)"),
                    CSS.decl("outline-offset", "3px")
                ),

                CSS.rule(
                    ".\(ClassName.input):focus-visible::-moz-range-thumb",
                    CSS.decl("outline", "2px solid var(--link-color)"),
                    CSS.decl("outline-offset", "3px")
                ),

                CSS.rule(
                    ".\(ClassName.value)",
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("text-align", "right")
                ),

                CSS.rule(
                    ".\(ClassName.equation)",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("padding-top", "12px"),
                    CSS.decl("border-top", "1px solid var(--border-color)"),
                    CSS.decl("font-size", ".88rem"),
                    CSS.decl("font-weight", "680")
                ),

                CSS.rule(
                    ".\(ClassName.expectation)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("align-items", "baseline"),
                    CSS.decl("gap", "7px")
                ),

                CSS.rule(
                    ".\(ClassName.expectationKicker)",
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(ClassName.expectationState)",
                    CSS.decl("transition", "color .16s ease")
                ),

                CSS.rule(
                    ".\(ClassName.result)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("min-width", "52px"),
                    CSS.decl("height", "30px"),
                    CSS.decl("padding", "0 10px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 9%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--text-color) 10%, transparent)"),
                    CSS.decl("transition", "color .16s ease, background-color .16s ease, box-shadow .16s ease")
                ),

                CSS.rule(
                    ".\(ClassName.root)[data-benefit-cost-state=\"negative\"] .\(ClassName.expectationState)",
                    CSS.decl("color", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".\(ClassName.root)[data-benefit-cost-state=\"neutral\"] .\(ClassName.expectationState)",
                    CSS.decl("color", "var(--warning, #E7A94E)")
                ),

                CSS.rule(
                    ".\(ClassName.root)[data-benefit-cost-state=\"positive\"] .\(ClassName.expectationState)",
                    CSS.decl("color", "var(--success, #2E8B57)")
                ),

                CSS.rule(
                    ".\(ClassName.root)[data-benefit-cost-state=\"negative\"] .\(ClassName.result)",
                    CSS.decl("color", "var(--danger, #D64545)"),
                    CSS.decl("background", "color-mix(in srgb, var(--danger, #D64545) 13%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--danger, #D64545) 25%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.root)[data-benefit-cost-state=\"neutral\"] .\(ClassName.result)",
                    CSS.decl("color", "var(--warning, #E7A94E)"),
                    CSS.decl("background", "color-mix(in srgb, var(--warning, #E7A94E) 14%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--warning, #E7A94E) 27%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.root)[data-benefit-cost-state=\"positive\"] .\(ClassName.result)",
                    CSS.decl("color", "var(--success, #2E8B57)"),
                    CSS.decl("background", "color-mix(in srgb, var(--success, #2E8B57) 13%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--success, #2E8B57) 25%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.caption)",
                    CSS.decl("margin", "10px 0 0"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--muted-text-color)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".\(ClassName.stage)",
                        CSS.decl("padding", "14px")
                    ),

                    CSS.rule(
                        ".\(ClassName.row)",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "7px")
                    ),

                    CSS.rule(
                        ".\(ClassName.value)",
                        CSS.decl("text-align", "left")
                    ),

                    CSS.rule(
                        ".\(ClassName.equation)",
                        CSS.decl("align-items", "flex-start"),
                        CSS.decl("flex-direction", "column")
                    )
                )
            ]
        )
    }
}

public struct BenefitCostBarScript: ReusableComponent {
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
        if (window.wcBenefitCostBar?.initialized) return;

        const rootSelector = '[data-benefit-cost-bar]';
        const sliderSelector = '[data-benefit-cost-slider]';

        const expectationText = {
            negative: 'pessimistisch: remmende werking',
            neutral: 'neutraal: afbuiging naar individuele voorkeur',
            positive: 'optimistisch: aansporende werking'
        };

        function numeric(value, fallback = 0) {
            const next = Number(value);
            return Number.isFinite(next) ? next : fallback;
        }

        function display(value) {
            if (Number.isInteger(value)) return String(value);

            return value
                .toFixed(1)
                .replace(/\.0$/, '');
        }

        function signed(value) {
            return value > 0 ? `+${display(value)}` : display(value);
        }

        function stateFor(result) {
            if (result < 0) return 'negative';
            if (result === 0) return 'neutral';
            return 'positive';
        }

        function percentFor(input) {
            const min = numeric(input.min, 0);
            const max = numeric(input.max, 100);
            const value = numeric(input.value, min);
            const span = Math.max(max - min, 1);
            const raw = ((value - min) / span) * 100;

            return Math.max(0, Math.min(100, raw));
        }

        function updateSlider(input) {
            const kind = input.getAttribute('data-benefit-cost-slider');
            const root = input.closest(rootSelector);
            if (!root || !kind) return;

            const value = numeric(input.value);

            const valueNode = root.querySelector(`[data-benefit-cost-value="${kind}"]`);
            if (valueNode) {
                valueNode.textContent = display(value);
            }

            const wrap = input.closest('[data-benefit-cost-slider-wrap]');
            if (wrap) {
                wrap.style.setProperty(
                    '--wc-benefit-cost-width',
                    `${percentFor(input)}%`
                );
            }
        }

        function update(root) {
            if (!root) return;

            const benefit = root.querySelector('[data-benefit-cost-slider="benefit"]');
            const cost = root.querySelector('[data-benefit-cost-slider="cost"]');

            if (!benefit || !cost) return;

            updateSlider(benefit);
            updateSlider(cost);

            const result = numeric(benefit.value) - numeric(cost.value);
            const state = stateFor(result);
            const label = expectationText[state];

            root.setAttribute('data-benefit-cost-state', state);
            root.setAttribute(
                'aria-label',
                `Gedragseconomie. Verwachting: ${label}. Opbrengst min kost is ${signed(result)}.`
            );

            const resultNode = root.querySelector('[data-benefit-cost-result]');
            if (resultNode) {
                resultNode.textContent = signed(result);
            }

            const expectationNode = root.querySelector('[data-benefit-cost-expectation]');
            if (expectationNode) {
                expectationNode.textContent = label;
            }
        }

        function init(scope = document) {
            const roots = scope.matches?.(rootSelector)
                ? [scope]
                : Array.from(scope.querySelectorAll?.(rootSelector) || []);

            roots.forEach(update);
        }

        document.addEventListener(
            'input',
            (event) => {
                const input = event.target?.closest?.(sliderSelector);
                if (!input) return;

                const root = input.closest(rootSelector);
                update(root);
            },
            true
        );

        document.addEventListener(
            'change',
            (event) => {
                const input = event.target?.closest?.(sliderSelector);
                if (!input) return;

                const root = input.closest(rootSelector);
                update(root);
            },
            true
        );

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => init());
        } else {
            init();
        }

        window.wcBenefitCostBar = {
            initialized: true,
            init,
            update
        };
    })();
    """#
}
