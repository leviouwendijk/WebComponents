import Foundation
import Constructors
import CSS
import HTML
import JS

public enum QuizLevel: String, Sendable, Hashable {
    case intro
    case middle
    case deep

    public var label: String {
        switch self {
        case .intro:
            return "Introductie"
        case .middle:
            return "Verdieping"
        case .deep:
            return "Gevorderd"
        }
    }
}

public enum QuizRule: Sendable, Hashable {
    case one(String)
    case many(Set<String>)
    case text([String])

    public var mode: String {
        switch self {
        case .one:
            return "one"
        case .many:
            return "many"
        case .text:
            return "text"
        }
    }

    public var ids: Set<String> {
        switch self {
        case .one(let id):
            return [id]
        case .many(let ids):
            return ids
        case .text:
            return []
        }
    }

    public var accepted: [String] {
        switch self {
        case .text(let values):
            return values
        case .one,
             .many:
            return []
        }
    }
}

public struct QuizChoice: Sendable, Hashable {
    public let id: String
    public let text: String
    public let note: String?

    public init(
        _ id: String,
        _ text: String,
        note: String? = nil
    ) {
        self.id = id
        self.text = text
        self.note = note
    }
}

public struct QuizItem: Sendable, Hashable {
    public let id: String
    public let slug: String
    public let title: String
    public let prompt: String
    public let group: String
    public let level: QuizLevel
    public let choices: [QuizChoice]
    public let rule: QuizRule
    public let explanation: String
    public let href: String

    public init(
        id: String,
        slug: String,
        title: String,
        prompt: String,
        group: String,
        level: QuizLevel = .intro,
        choices: [QuizChoice] = [],
        rule: QuizRule,
        explanation: String,
        href: String
    ) {
        self.id = id
        self.slug = slug
        self.title = title
        self.prompt = prompt
        self.group = group
        self.level = level
        self.choices = choices
        self.rule = rule
        self.explanation = explanation
        self.href = href
    }
}

public struct QuizSet: Sendable, Hashable {
    public let id: String
    public let title: String
    public let lead: String
    public let items: [QuizItem]

    public init(
        id: String,
        title: String,
        lead: String,
        items: [QuizItem]
    ) {
        self.id = id
        self.title = title
        self.lead = lead
        self.items = items
    }

    public func item(
        _ id: String
    ) -> QuizItem? {
        items.first { $0.id == id }
    }

    public func prev(
        _ id: String
    ) -> QuizItem? {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            return nil
        }

        guard index > 0 else {
            return nil
        }

        return items[index - 1]
    }

    public func next(
        _ id: String
    ) -> QuizItem? {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            return nil
        }

        let nextIndex = index + 1

        guard items.indices.contains(nextIndex) else {
            return nil
        }

        return items[nextIndex]
    }
}

public struct QuizList: ReusableComponent, Sendable {
    public let set: QuizSet
    public let eyebrow: String
    public let styles: Bool
    public let script: Bool

    public init(
        set: QuizSet,
        eyebrow: String = "Oefenen",
        styles: Bool = true,
        script: Bool = true
    ) {
        self.set = set
        self.eyebrow = eyebrow
        self.styles = styles
        self.script = script
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.el(
                    "main",
                    [
                        "id": "content-area",
                        "class": "wc-quiz wc-quiz--list",
                        "data-quiz-root": ""
                    ]
                ) {
                    HTML.el("section", ["class": "wc-quiz__hero"]) {
                        HTML.p(["class": "wc-quiz__eyebrow"]) {
                            HTML.text(eyebrow)
                        }

                        HTML.h1 {
                            HTML.text(set.title)
                        }

                        HTML.p(["class": "wc-quiz__lead"]) {
                            HTML.text(set.lead)
                        }
                    }

                    HTML.el("section", ["class": "wc-quiz-list", "aria-label": "Vragen"]) {
                        for item in set.items {
                            QuizCard(item: item).nodes.body
                        }
                    }

                    HTML.el(
                        "script",
                        [
                            "type": "application/json",
                            "data-quiz-data": ""
                        ]
                    ) {
                        HTML.raw(json())
                    }

                    HTML.div(
                        [
                            "class": "wc-quiz-shell",
                            "data-quiz-shell": "",
                            "hidden": ""
                        ]
                    ) {
                        HTML.button(
                            [
                                "class": "wc-quiz-backdrop",
                                "type": "button",
                                "aria-label": "Sluit vraag",
                                "data-quiz-close": ""
                            ]
                        ) {}

                        HTML.div(
                            [
                                "class": "wc-quiz-panel",
                                "data-quiz-panel": "",
                                "role": "dialog",
                                "aria-modal": "true",
                                "aria-labelledby": "wc-quiz-panel-title",
                                "tabindex": "-1"
                            ]
                        ) {}
                    }
                }
            ],
            stylesheets: styles ? [QuizCSS.sheet()] : [],
            scripts: script ? QuizScript().nodes.scripts : []
        )
    }

    private func json() -> String {
        let payload = QuizData(set)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [
            .sortedKeys
        ]

        guard let data = try? encoder.encode(payload) else {
            return "{}"
        }

        let raw = String(
            decoding: data,
            as: UTF8.self
        )

        return raw
            .replacingOccurrences(of: "&", with: "\\u0026")
            .replacingOccurrences(of: "<", with: "\\u003C")
            .replacingOccurrences(of: ">", with: "\\u003E")
    }
}

public struct QuizCard: ReusableComponent, Sendable {
    public let item: QuizItem

    public init(
        item: QuizItem
    ) {
        self.item = item
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.a(
                    "#\(item.slug)",
                    [
                        "class": "wc-quiz-card",
                        "data-quiz-card": "",
                        "data-quiz-open": item.id,
                        "data-quiz-group": item.group,
                        "data-quiz-level": item.level.rawValue
                    ]
                ) {
                    HTML.div(["class": "wc-quiz-meta"]) {
                        HTML.span {
                            HTML.text(item.group)
                        }

                        HTML.span {
                            HTML.text(item.level.label)
                        }
                    }

                    HTML.h2 {
                        HTML.text(item.title)
                    }

                    HTML.p {
                        HTML.text(item.prompt)
                    }

                    HTML.span(["class": "wc-quiz-card__action"]) {
                        HTML.text("Open vraag")
                    }
                }
            ]
        )
    }
}

private struct QuizData: Encodable {
    let id: String
    let title: String
    let lead: String
    let items: [Item]

    init(
        _ set: QuizSet
    ) {
        self.id = set.id
        self.title = set.title
        self.lead = set.lead
        self.items = set.items.map(Item.init)
    }

    struct Item: Encodable {
        let id: String
        let slug: String
        let title: String
        let prompt: String
        let group: String
        let level: String
        let levelLabel: String
        let choices: [Choice]
        let rule: Rule
        let explanation: String

        init(
            _ item: QuizItem
        ) {
            self.id = item.id
            self.slug = item.slug
            self.title = item.title
            self.prompt = item.prompt
            self.group = item.group
            self.level = item.level.rawValue
            self.levelLabel = item.level.label
            self.choices = item.choices.map(Choice.init)
            self.rule = Rule(item.rule)
            self.explanation = item.explanation
        }
    }

    struct Choice: Encodable {
        let id: String
        let text: String
        let note: String?

        init(
            _ choice: QuizChoice
        ) {
            self.id = choice.id
            self.text = choice.text
            self.note = choice.note
        }
    }

    struct Rule: Encodable {
        let mode: String
        let ids: [String]
        let accepted: [String]

        init(
            _ rule: QuizRule
        ) {
            self.mode = rule.mode
            self.ids = rule.ids.sorted()
            self.accepted = rule.accepted
        }
    }
}

public struct QuizScript: ReusableComponent {
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
        if (window.wcQuiz?.ready) return;

        const rootSelector = '[data-quiz-root]';
        const stateByRoot = new WeakMap();

        function esc(value) {
            return String(value ?? '')
                .replaceAll('&', '&amp;')
                .replaceAll('<', '&lt;')
                .replaceAll('>', '&gt;')
                .replaceAll('"', '&quot;')
                .replaceAll("'", '&#039;');
        }

        function norm(value) {
            return String(value || '')
                .toLowerCase()
                .normalize('NFD')
                .replace(/[\u0300-\u036f]/g, '')
                .replace(/[^\p{Letter}\p{Number}\s-]/gu, '')
                .replace(/\s+/g, ' ')
                .trim();
        }

        function same(left, right) {
            if (left.length !== right.length) return false;

            return left.every((value, index) => value === right[index]);
        }

        function parse(root) {
            const data = root.querySelector('[data-quiz-data]');
            const parsed = JSON.parse(data?.textContent || '{}');
            const items = Array.isArray(parsed.items) ? parsed.items : [];
            const byID = new Map(items.map((item) => [item.id, item]));
            const bySlug = new Map(items.map((item) => [item.slug, item]));

            return {
                set: parsed,
                items,
                byID,
                bySlug,
                active: null
            };
        }

        function state(root) {
            if (!stateByRoot.has(root)) {
                stateByRoot.set(root, parse(root));
            }

            return stateByRoot.get(root);
        }

        function picked(panel) {
            return Array
                .from(panel.querySelectorAll('input[type="radio"]:checked, input[type="checkbox"]:checked'))
                .map((input) => input.value)
                .sort();
        }

        function textOk(panel, item) {
            const input = panel.querySelector('[data-quiz-input]');
            const answer = norm(input?.value || '');

            return item.rule.accepted
                .map(norm)
                .includes(answer);
        }

        function selectedOk(panel, item) {
            return same(
                picked(panel),
                [...item.rule.ids].sort()
            );
        }

        function clear(panel) {
            panel.removeAttribute('data-quiz-state');

            panel
                .querySelectorAll('[data-quiz-option]')
                .forEach((option) => {
                    option.removeAttribute('data-quiz-option-state');
                });

            panel
                .querySelectorAll('[data-quiz-feedback]')
                .forEach((node) => {
                    node.hidden = true;
                });
        }

        function mark(panel, item) {
            const ids = new Set(item.rule.ids);

            panel
                .querySelectorAll('[data-quiz-option]')
                .forEach((option) => {
                    const id = option.getAttribute('data-quiz-option');
                    const input = option.querySelector('input');
                    const selected = Boolean(input?.checked);
                    const correct = ids.has(id);

                    if (correct) {
                        option.setAttribute('data-quiz-option-state', 'right');
                    } else if (selected) {
                        option.setAttribute('data-quiz-option-state', 'wrong');
                    }
                });
        }

        function check(panel, item) {
            const ok = item.rule.mode === 'text'
                ? textOk(panel, item)
                : selectedOk(panel, item);

            clear(panel);

            const result = ok ? 'right' : 'wrong';
            panel.setAttribute('data-quiz-state', result);

            if (item.rule.mode !== 'text') {
                mark(panel, item);
            }

            const feedback = panel.querySelector(`[data-quiz-feedback="${result}"]`);

            if (feedback) {
                feedback.hidden = false;
            }
        }

        function optionHTML(item) {
            if (item.rule.mode === 'text') {
                return `
                    <label class="wc-quiz-text">
                        <span>Jouw antwoord</span>
                        <input type="text" autocomplete="off" data-quiz-input>
                    </label>
                `;
            }

            const type = item.rule.mode === 'many'
                ? 'checkbox'
                : 'radio';

            const choices = item.choices.map((choice) => {
                const input = `${item.id}-${choice.id}`;

                return `
                    <label class="wc-quiz-option" for="${esc(input)}" data-quiz-option="${esc(choice.id)}">
                        <input id="${esc(input)}" type="${type}" name="quiz-${esc(item.id)}" value="${esc(choice.id)}">
                        <span class="wc-quiz-option__text">${esc(choice.text)}</span>
                        ${choice.note ? `<span class="wc-quiz-option__note">${esc(choice.note)}</span>` : ''}
                    </label>
                `;
            }).join('');

            return `
                <fieldset class="wc-quiz-options">
                    <legend class="wc-quiz-options__legend">Kies je antwoord</legend>
                    ${choices}
                </fieldset>
            `;
        }

        function navHTML(data, item) {
            const index = data.items.findIndex((candidate) => candidate.id === item.id);
            const previous = index > 0 ? data.items[index - 1] : null;
            const next = index >= 0 && index + 1 < data.items.length
                ? data.items[index + 1]
                : null;

            const prevHTML = previous
                ? `
                    <button class="wc-quiz-nav__link" type="button" data-quiz-goto="${esc(previous.id)}">
                        <span>Vorige</span>
                        <strong>${esc(previous.title)}</strong>
                    </button>
                `
                : `
                    <span class="wc-quiz-nav__empty">Geen vorige vraag</span>
                `;

            const nextHTML = next
                ? `
                    <button class="wc-quiz-nav__link wc-quiz-nav__link--next" type="button" data-quiz-goto="${esc(next.id)}">
                        <span>Volgende</span>
                        <strong>${esc(next.title)}</strong>
                    </button>
                `
                : `
                    <button class="wc-quiz-nav__link wc-quiz-nav__link--next" type="button" data-quiz-close>
                        <span>Klaar</span>
                        <strong>Alle vragen</strong>
                    </button>
                `;

            return `
                <nav class="wc-quiz-nav" aria-label="Vraag-navigatie">
                    ${prevHTML}
                    ${nextHTML}
                </nav>
            `;
        }

        function render(data, item) {
            return `
                <button class="wc-quiz__back" type="button" data-quiz-close>
                    Alle vragen
                </button>

                <article class="wc-quiz-item" data-quiz-item>
                    <header class="wc-quiz-item__head">
                        <div class="wc-quiz-meta">
                            <span>${esc(item.group)}</span>
                            <span>${esc(item.levelLabel)}</span>
                        </div>

                        <h1 id="wc-quiz-panel-title">${esc(item.title)}</h1>

                        <p>${esc(item.prompt)}</p>
                    </header>

                    <form class="wc-quiz-form" data-quiz-form>
                        ${optionHTML(item)}

                        <div class="wc-quiz-form__actions">
                            <button class="wc-quiz-btn wc-quiz-btn--main" type="submit">
                                Controleer
                            </button>

                            <button class="wc-quiz-btn" type="button" data-quiz-reset>
                                Opnieuw
                            </button>
                        </div>
                    </form>

                    <div class="wc-quiz-feedback wc-quiz-feedback--right" data-quiz-feedback="right" hidden>
                        <h2>Goed</h2>
                        <p>${esc(item.explanation)}</p>
                    </div>

                    <div class="wc-quiz-feedback wc-quiz-feedback--wrong" data-quiz-feedback="wrong" hidden>
                        <h2>Nog niet</h2>
                        <p>${esc(item.explanation)}</p>
                    </div>
                </article>

                ${navHTML(data, item)}
            `;
        }

        function setHash(item) {
            const next = `${window.location.pathname}${window.location.search}#${encodeURIComponent(item.slug)}`;
            history.pushState({}, '', next);
        }

        function clearHash() {
            const next = `${window.location.pathname}${window.location.search}`;
            history.pushState({}, '', next);
        }

        function open(root, item, updateHash = true) {
            const data = state(root);
            const shell = root.querySelector('[data-quiz-shell]');
            const panel = root.querySelector('[data-quiz-panel]');

            if (!shell || !panel) return;

            data.active = item;
            panel.innerHTML = render(data, item);
            shell.hidden = false;
            document.documentElement.classList.add('wc-quiz-is-open');

            if (updateHash) {
                setHash(item);
            }

            panel.focus();
        }

        function close(root, updateHash = true) {
            const shell = root.querySelector('[data-quiz-shell]');
            const panel = root.querySelector('[data-quiz-panel]');

            if (shell) {
                shell.hidden = true;
            }

            if (panel) {
                panel.innerHTML = '';
            }

            state(root).active = null;
            document.documentElement.classList.remove('wc-quiz-is-open');

            if (updateHash) {
                clearHash();
            }
        }

        function openFromHash(root) {
            const slug = decodeURIComponent(window.location.hash.replace(/^#/, ''));

            if (!slug) {
                close(root, false);
                return;
            }

            const data = state(root);
            const item = data.bySlug.get(slug);

            if (item) {
                open(root, item, false);
            }
        }

        function init(scope = document) {
            const roots = scope.matches?.(rootSelector)
                ? [scope]
                : Array.from(scope.querySelectorAll?.(rootSelector) || []);

            roots.forEach((root) => {
                state(root);
                openFromHash(root);
            });
        }

        document.addEventListener('click', (event) => {
            const opener = event.target?.closest?.('[data-quiz-open]');

            if (opener) {
                const root = opener.closest(rootSelector);
                if (!root) return;

                const item = state(root).byID.get(opener.getAttribute('data-quiz-open'));
                if (!item) return;

                event.preventDefault();
                open(root, item);
                return;
            }

            const closeButton = event.target?.closest?.('[data-quiz-close]');

            if (closeButton) {
                const root = closeButton.closest(rootSelector);
                if (!root) return;

                event.preventDefault();
                close(root);
                return;
            }

            const gotoButton = event.target?.closest?.('[data-quiz-goto]');

            if (gotoButton) {
                const root = gotoButton.closest(rootSelector);
                if (!root) return;

                const item = state(root).byID.get(gotoButton.getAttribute('data-quiz-goto'));
                if (!item) return;

                event.preventDefault();
                open(root, item);
            }
        });

        document.addEventListener('submit', (event) => {
            const form = event.target?.closest?.('[data-quiz-form]');
            if (!form) return;

            const root = form.closest(rootSelector);
            const panel = form.closest('[data-quiz-panel]');
            if (!root || !panel) return;

            const item = state(root).active;
            if (!item) return;

            event.preventDefault();
            check(panel, item);
        });

        document.addEventListener('click', (event) => {
            const reset = event.target?.closest?.('[data-quiz-reset]');
            if (!reset) return;

            const panel = reset.closest('[data-quiz-panel]');
            if (!panel) return;

            panel.querySelectorAll('input').forEach((input) => {
                if (input.type === 'radio' || input.type === 'checkbox') {
                    input.checked = false;
                } else {
                    input.value = '';
                }
            });

            clear(panel);
        });

        document.addEventListener('keydown', (event) => {
            if (event.key !== 'Escape') return;

            const shell = document.querySelector('[data-quiz-shell]:not([hidden])');
            if (!shell) return;

            const root = shell.closest(rootSelector);
            if (!root) return;

            close(root);
        });

        window.addEventListener('hashchange', () => {
            document
                .querySelectorAll(rootSelector)
                .forEach(openFromHash);
        });

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => init());
        } else {
            init();
        }

        window.wcQuiz = {
            ready: true,
            init,
            open,
            close
        };
    })();
    """#
}

public enum QuizCSS {
    public static func sheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-quiz",
                    CSS.decl("width", "min(980px, calc(100% - 48px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "60px 0 96px"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".wc-quiz__hero",
                    CSS.decl("margin", "0 0 38px")
                ),

                CSS.rule(
                    ".wc-quiz__eyebrow",
                    CSS.decl("margin", "0 0 10px"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz__hero h1, .wc-quiz-item__head h1",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(2.1rem, 5vw, 4.4rem)"),
                    CSS.decl("line-height", ".98"),
                    CSS.decl("letter-spacing", "-.055em")
                ),

                CSS.rule(
                    ".wc-quiz__lead, .wc-quiz-item__head p",
                    CSS.decl("max-width", "740px"),
                    CSS.decl("font-size", "1.05rem"),
                    CSS.decl("line-height", "1.62"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-list",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(2, minmax(0, 1fr))"),
                    CSS.decl("gap", "16px")
                ),

                CSS.rule(
                    ".wc-quiz-card, .wc-quiz-item",
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("box-shadow", "0 18px 44px rgba(15, 23, 42, .06)")
                ),

                CSS.rule(
                    ".wc-quiz-card",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("min-height", "210px"),
                    CSS.decl("padding", "20px"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".wc-quiz-card:hover",
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("transform", "translateY(-1px)"),
                    CSS.decl("box-shadow", "0 22px 52px rgba(15, 23, 42, .10)")
                ),

                CSS.rule(
                    ".wc-quiz-meta",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("margin", "0 0 16px")
                ),

                CSS.rule(
                    ".wc-quiz-meta span",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("height", "26px"),
                    CSS.decl("padding", "0 9px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 8%, transparent)"),
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("font-weight", "680"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-card h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.38rem"),
                    CSS.decl("line-height", "1.08"),
                    CSS.decl("letter-spacing", "-.025em")
                ),

                CSS.rule(
                    ".wc-quiz-card p",
                    CSS.decl("margin", "14px 0 0"),
                    CSS.decl("line-height", "1.52"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-card__action",
                    CSS.decl("margin-top", "auto"),
                    CSS.decl("padding-top", "22px"),
                    CSS.decl("font-weight", "720")
                ),

                CSS.rule(
                    ".wc-quiz__back",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("margin", "0 0 28px"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("font-weight", "680"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".wc-quiz-shell[hidden]",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".wc-quiz-shell",
                    CSS.decl("position", "fixed"),
                    CSS.decl("inset", "0"),
                    CSS.decl("z-index", "4000"),
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("padding", "24px"),
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".wc-quiz-backdrop",
                    CSS.decl("position", "absolute"),
                    CSS.decl("inset", "0"),
                    CSS.decl("border", "0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("background", "rgba(15, 23, 42, .54)"),
                    CSS.decl("backdrop-filter", "blur(10px)"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".wc-quiz-panel",
                    CSS.decl("position", "relative"),
                    CSS.decl("z-index", "1"),
                    CSS.decl("width", "min(860px, 100%)"),
                    CSS.decl("max-height", "min(820px, calc(100vh - 48px))"),
                    CSS.decl("overflow", "auto"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("padding", "24px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "28px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("box-shadow", "0 32px 90px rgba(15, 23, 42, .28)")
                ),

                CSS.rule(
                    ".wc-quiz-is-open",
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".wc-quiz-panel .wc-quiz-item",
                    CSS.decl("box-shadow", "none")
                ),

                CSS.rule(
                    ".wc-quiz-nav__link",
                    CSS.decl("font", "inherit"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("text-align", "left")
                ),

                CSS.rule(
                    ".wc-quiz-item",
                    CSS.decl("padding", "24px")
                ),

                CSS.rule(
                    ".wc-quiz-form",
                    CSS.decl("margin-top", "28px")
                ),

                CSS.rule(
                    ".wc-quiz-options",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("border", "0")
                ),

                CSS.rule(
                    ".wc-quiz-options__legend",
                    CSS.decl("margin", "0 0 12px"),
                    CSS.decl("font-weight", "760")
                ),

                CSS.rule(
                    ".wc-quiz-option",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "auto minmax(0, 1fr)"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".wc-quiz-option__note",
                    CSS.decl("grid-column", "2"),
                    CSS.decl("display", "none"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-item[data-quiz-state] .wc-quiz-option__note",
                    CSS.decl("display", "block")
                ),

                CSS.rule(
                    ".wc-quiz-option[data-quiz-option-state=\"right\"]",
                    CSS.decl("border-color", "var(--success, #2E8B57)"),
                    CSS.decl("background", "color-mix(in srgb, var(--success, #2E8B57) 11%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-option[data-quiz-option-state=\"wrong\"]",
                    CSS.decl("border-color", "var(--danger, #D64545)"),
                    CSS.decl("background", "color-mix(in srgb, var(--danger, #D64545) 10%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-text",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("font-weight", "720")
                ),

                CSS.rule(
                    ".wc-quiz-text input",
                    CSS.decl("width", "100%"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("padding", "13px 14px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "var(--background-color)"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("font", "inherit")
                ),

                CSS.rule(
                    ".wc-quiz-form__actions",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("margin-top", "18px")
                ),

                CSS.rule(
                    ".wc-quiz-btn",
                    CSS.decl("appearance", "none"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("padding", "11px 15px"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-btn--main",
                    CSS.decl("background", "var(--link-color)"),
                    CSS.decl("border-color", "var(--link-color)"),
                    CSS.decl("color", "#ffffff")
                ),

                CSS.rule(
                    ".wc-quiz-feedback",
                    CSS.decl("margin-top", "20px"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("line-height", "1.55")
                ),

                CSS.rule(
                    ".wc-quiz-feedback h2",
                    CSS.decl("margin", "0 0 6px"),
                    CSS.decl("font-size", "1.1rem")
                ),

                CSS.rule(
                    ".wc-quiz-feedback p",
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    ".wc-quiz-feedback--right",
                    CSS.decl("background", "color-mix(in srgb, var(--success, #2E8B57) 12%, transparent)"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--success, #2E8B57) 28%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-feedback--wrong",
                    CSS.decl("background", "color-mix(in srgb, var(--warning, #E7A94E) 14%, transparent)"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--warning, #E7A94E) 30%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-nav",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(2, minmax(0, 1fr))"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("margin-top", "18px")
                ),

                CSS.rule(
                    ".wc-quiz-nav__link, .wc-quiz-nav__empty",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-nav__link--next",
                    CSS.decl("text-align", "right")
                ),

                CSS.rule(
                    ".wc-quiz-nav__link span, .wc-quiz-nav__empty",
                    CSS.decl("font-size", ".8rem"),
                    CSS.decl("color", "var(--muted-text-color)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 760px)",
                    CSS.rule(
                        ".wc-quiz",
                        CSS.decl("width", "calc(100% - 32px)"),
                        CSS.decl("padding", "42px 0 78px")
                    ),

                    CSS.rule(
                        ".wc-quiz-list, .wc-quiz-nav",
                        CSS.decl("grid-template-columns", "1fr")
                    ),

                    CSS.rule(
                        ".wc-quiz-nav__link--next",
                        CSS.decl("text-align", "left")
                    )
                )
            ]
        )
    }
}
