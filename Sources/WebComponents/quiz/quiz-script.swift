import Constructors
import JS

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
                        <div class="wc-quiz-item__eyebrow">
                            ${esc(item.group)} · ${esc(item.levelLabel)}
                        </div>

                        <p class="wc-quiz-topic">${esc(item.title)}</p>

                        <h1 id="wc-quiz-panel-title">${esc(item.prompt)}</h1>
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
                        <h2>Correct</h2>
                        <p>${esc(item.explanation)}</p>
                    </div>

                    <div class="wc-quiz-feedback wc-quiz-feedback--wrong" data-quiz-feedback="wrong" hidden>
                        <h2>Incorrect</h2>
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
