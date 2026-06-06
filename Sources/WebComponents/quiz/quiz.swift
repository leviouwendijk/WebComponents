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
                        "class": "wc-quiz wc-quiz--list"
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
                }
            ],
            stylesheets: styles ? [QuizCSS.sheet()] : [],
            scripts: script ? QuizScript().nodes.scripts : []
        )
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
                    item.href,
                    [
                        "class": "wc-quiz-card",
                        "data-quiz-card": "",
                        "data-quiz-group": item.group,
                        "data-quiz-level": item.level.rawValue
                    ]
                ) {
                    meta(item)

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

public struct QuizView: ReusableComponent, Sendable {
    public let set: QuizSet
    public let item: String
    public let home: String
    public let styles: Bool
    public let script: Bool

    public init(
        set: QuizSet,
        item: String,
        home: String,
        styles: Bool = true,
        script: Bool = true
    ) {
        self.set = set
        self.item = item
        self.home = home
        self.styles = styles
        self.script = script
    }

    public var nodes: ReusableComponentNodes {
        guard let item = set.item(item) else {
            return missing()
        }

        return .body(
            [
                HTML.el(
                    "main",
                    [
                        "id": "content-area",
                        "class": "wc-quiz wc-quiz--view"
                    ]
                ) {
                    HTML.a(home, ["class": "wc-quiz__back"]) {
                        HTML.text("Alle vragen")
                    }

                    HTML.el(
                        "article",
                        [
                            "class": "wc-quiz-item",
                            "data-quiz-item": "",
                            "data-quiz-mode": item.rule.mode,
                            "data-quiz-ids": item.rule.ids.sorted().joined(separator: ","),
                            "data-quiz-text": item.rule.accepted.joined(separator: "|")
                        ]
                    ) {
                        HTML.el("header", ["class": "wc-quiz-item__head"]) {
                            meta(item)

                            HTML.h1 {
                                HTML.text(item.title)
                            }

                            HTML.p {
                                HTML.text(item.prompt)
                            }
                        }

                        form(item)

                        feedback(
                            state: "right",
                            title: "Goed",
                            text: item.explanation
                        )

                        feedback(
                            state: "wrong",
                            title: "Nog niet",
                            text: item.explanation
                        )
                    }

                    nav(item)
                }
            ],
            stylesheets: styles ? [QuizCSS.sheet()] : [],
            scripts: script ? QuizScript().nodes.scripts : []
        )
    }

    private func missing() -> ReusableComponentNodes {
        .body(
            [
                HTML.el(
                    "main",
                    [
                        "id": "content-area",
                        "class": "wc-quiz wc-quiz--missing"
                    ]
                ) {
                    HTML.h1 {
                        HTML.text("Vraag niet gevonden")
                    }

                    HTML.a(home, ["class": "wc-quiz__back"]) {
                        HTML.text("Terug naar alle vragen")
                    }
                }
            ],
            stylesheets: styles ? [QuizCSS.sheet()] : []
        )
    }

    private func form(
        _ item: QuizItem
    ) -> any HTMLNode {
        HTML.el("form", ["class": "wc-quiz-form", "data-quiz-form": ""]) {
            switch item.rule {
            case .one:
                choices(item, type: "radio")

            case .many:
                choices(item, type: "checkbox")

            case .text:
                HTML.el("label", ["class": "wc-quiz-text"]) {
                    HTML.span {
                        HTML.text("Jouw antwoord")
                    }

                    HTML.el(
                        "input",
                        [
                            "type": "text",
                            "autocomplete": "off",
                            "data-quiz-input": ""
                        ]
                    )
                }
            }

            HTML.div(["class": "wc-quiz-form__actions"]) {
                HTML.el(
                    "button",
                    [
                        "type": "submit",
                        "class": "wc-quiz-btn wc-quiz-btn--main"
                    ]
                ) {
                    HTML.text("Controleer")
                }

                HTML.el(
                    "button",
                    [
                        "type": "button",
                        "class": "wc-quiz-btn",
                        "data-quiz-reset": ""
                    ]
                ) {
                    HTML.text("Opnieuw")
                }
            }
        }
    }

    private func choices(
        _ item: QuizItem,
        type: String
    ) -> any HTMLNode {
        HTML.el("fieldset", ["class": "wc-quiz-options"]) {
            HTML.el("legend", ["class": "wc-quiz-options__legend"]) {
                HTML.text("Kies je antwoord")
            }

            for choice in item.choices {
                let input = "\(item.id)-\(choice.id)"

                HTML.el(
                    "label",
                    [
                        "class": "wc-quiz-option",
                        "for": input,
                        "data-quiz-option": choice.id
                    ]
                ) {
                    HTML.el(
                        "input",
                        [
                            "id": input,
                            "type": type,
                            "name": "quiz-\(item.id)",
                            "value": choice.id
                        ]
                    )

                    HTML.span(["class": "wc-quiz-option__text"]) {
                        HTML.text(choice.text)
                    }

                    if let note = choice.note {
                        HTML.span(["class": "wc-quiz-option__note"]) {
                            HTML.text(note)
                        }
                    }
                }
            }
        }
    }

    private func feedback(
        state: String,
        title: String,
        text: String
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "wc-quiz-feedback wc-quiz-feedback--\(state)",
                "data-quiz-feedback": state,
                "hidden": ""
            ]
        ) {
            HTML.h2 {
                HTML.text(title)
            }

            HTML.p {
                HTML.text(text)
            }
        }
    }

    private func nav(
        _ item: QuizItem
    ) -> any HTMLNode {
        HTML.el("nav", ["class": "wc-quiz-nav", "aria-label": "Vraag-navigatie"]) {
            if let prev = set.prev(item.id) {
                navLink(prev, label: "Vorige")
            } else {
                HTML.span(["class": "wc-quiz-nav__empty"]) {
                    HTML.text("Geen vorige vraag")
                }
            }

            if let next = set.next(item.id) {
                navLink(next, label: "Volgende", next: true)
            } else {
                HTML.a(home, ["class": "wc-quiz-nav__link wc-quiz-nav__link--next"]) {
                    HTML.span {
                        HTML.text("Klaar")
                    }

                    HTML.strong {
                        HTML.text("Alle vragen")
                    }
                }
            }
        }
    }

    private func navLink(
        _ item: QuizItem,
        label: String,
        next: Bool = false
    ) -> any HTMLNode {
        HTML.a(
            item.href,
            [
                "class": next
                    ? "wc-quiz-nav__link wc-quiz-nav__link--next"
                    : "wc-quiz-nav__link"
            ]
        ) {
            HTML.span {
                HTML.text(label)
            }

            HTML.strong {
                HTML.text(item.title)
            }
        }
    }
}

private func meta(
    _ item: QuizItem
) -> any HTMLNode {
    HTML.div(["class": "wc-quiz-meta"]) {
        HTML.span {
            HTML.text(item.group)
        }

        HTML.span {
            HTML.text(item.level.label)
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

        const rootSelector = '[data-quiz-item]';

        function norm(value) {
            return String(value || '')
                .toLowerCase()
                .normalize('NFD')
                .replace(/[\u0300-\u036f]/g, '')
                .replace(/[^\p{Letter}\p{Number}\s-]/gu, '')
                .replace(/\s+/g, ' ')
                .trim();
        }

        function picked(root) {
            return Array
                .from(root.querySelectorAll('input[type="radio"]:checked, input[type="checkbox"]:checked'))
                .map((input) => input.value)
                .sort();
        }

        function wanted(root) {
            return String(root.getAttribute('data-quiz-ids') || '')
                .split(',')
                .map((value) => value.trim())
                .filter(Boolean)
                .sort();
        }

        function same(left, right) {
            if (left.length !== right.length) return false;
            return left.every((value, index) => value === right[index]);
        }

        function textOk(root) {
            const input = root.querySelector('[data-quiz-input]');
            const answer = norm(input?.value || '');

            const accepted = String(root.getAttribute('data-quiz-text') || '')
                .split('|')
                .map(norm)
                .filter(Boolean);

            return accepted.includes(answer);
        }

        function clear(root) {
            root.removeAttribute('data-quiz-state');

            root
                .querySelectorAll('[data-quiz-option]')
                .forEach((option) => {
                    option.removeAttribute('data-quiz-option-state');
                });

            root
                .querySelectorAll('[data-quiz-feedback]')
                .forEach((node) => {
                    node.hidden = true;
                });
        }

        function mark(root) {
            const ids = new Set(wanted(root));

            root
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

        function check(root) {
            const mode = root.getAttribute('data-quiz-mode');

            const ok = mode === 'text'
                ? textOk(root)
                : same(picked(root), wanted(root));

            clear(root);

            const state = ok ? 'right' : 'wrong';
            root.setAttribute('data-quiz-state', state);

            if (mode !== 'text') {
                mark(root);
            }

            const feedback = root.querySelector(`[data-quiz-feedback="${state}"]`);
            if (feedback) {
                feedback.hidden = false;
            }
        }

        document.addEventListener('submit', (event) => {
            const form = event.target?.closest?.('[data-quiz-form]');
            if (!form) return;

            const root = form.closest(rootSelector);
            if (!root) return;

            event.preventDefault();
            check(root);
        });

        document.addEventListener('click', (event) => {
            const reset = event.target?.closest?.('[data-quiz-reset]');
            if (!reset) return;

            const root = reset.closest(rootSelector);
            if (!root) return;

            root.querySelectorAll('input').forEach((input) => {
                if (input.type === 'radio' || input.type === 'checkbox') {
                    input.checked = false;
                } else {
                    input.value = '';
                }
            });

            clear(root);
        });

        window.wcQuiz = {
            ready: true,
            check,
            clear
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
