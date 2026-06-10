extension QuizScript.Source {
    static let navigation = #"""
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

        function restoreStoredSelection(root, panel, item) {
            const data = state(root);
            const entry = itemProgress(data, item.id);

            if (!entry || item.rule.mode === 'text') {
                return;
            }

            const selected = new Set(entry.selected || []);

            panel
                .querySelectorAll('input[type="radio"], input[type="checkbox"]')
                .forEach((input) => {
                    input.checked = selected.has(input.value);
                });
        }

        function updatePrior(root, panel, item) {
            const data = state(root);
            const entry = itemProgress(data, item.id);
            const prior = panel.querySelector('[data-quiz-prior]');
            const text = panel.querySelector('[data-quiz-prior-text]');
            const reset = panel.querySelector('[data-quiz-reset-item]');

            if (!prior || !text) {
                return;
            }

            if (!entry) {
                prior.hidden = true;
                prior.removeAttribute('data-quiz-prior-state');
                text.textContent = '';

                if (reset) {
                    reset.disabled = true;
                }

                return;
            }

            prior.hidden = false;
            prior.setAttribute('data-quiz-prior-state', entry.lastResult);
            text.textContent = priorText(entry);

            if (reset) {
                reset.disabled = false;
            }
        }

        function resetPanelAttempt(panel) {
            lock(panel, false);

            panel.querySelectorAll('input').forEach((input) => {
                if (input.type === 'radio' || input.type === 'checkbox') {
                    input.checked = false;
                } else {
                    input.value = '';
                }
            });

            clear(panel);
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

            stopTimer(root);
            data.active = item;
            data.activeOpenedAt = now();
            panel.innerHTML = render(data, item);
            shell.hidden = false;
            document.documentElement.classList.add('wc-quiz-is-open');
            restoreStoredSelection(root, panel, item);
            startTimer(root, panel);

            if (updateHash) {
                setHash(item);
            }

            focusFirstControl(panel);
        }

        function close(root, updateHash = true) {
            const shell = root.querySelector('[data-quiz-shell]');
            const panel = root.querySelector('[data-quiz-panel]');

            stopTimer(root);

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
    """#
}
