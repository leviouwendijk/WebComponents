extension QuizScript.Source {
    static let hints = #"""
        function itemHints(item) {
            return Array.isArray(item.hints)
                ? item.hints.filter((hint) => String(hint || '').trim().length > 0)
                : [];
        }

        function hintsHTML(item) {
            const hints = itemHints(item);

            if (!hints.length) {
                return '';
            }

            return `
                <div class="wc-quiz-hints" data-quiz-hints>
                    <button class="wc-quiz-hints__button" type="button" data-quiz-hint>
                        Toon hint
                    </button>

                    <div class="wc-quiz-hints__list" data-quiz-hints-list hidden></div>
                </div>
            `;
        }

        function resetHints(panel) {
            panel.removeAttribute('data-quiz-hint-index');

            const list = panel.querySelector('[data-quiz-hints-list]');
            const button = panel.querySelector('[data-quiz-hint]');

            if (list) {
                list.hidden = true;
                list.innerHTML = '';
            }

            if (button) {
                button.disabled = false;
                button.textContent = 'Toon hint';
            }
        }

        function revealHint(root, panel) {
            const data = state(root);
            const item = data.active;

            if (!item) {
                return;
            }

            const hints = itemHints(item);
            const list = panel.querySelector('[data-quiz-hints-list]');
            const button = panel.querySelector('[data-quiz-hint]');
            const current = Number(panel.getAttribute('data-quiz-hint-index') || '0');

            if (!hints.length || !list || !button || current >= hints.length) {
                return;
            }

            list.hidden = false;
            list.insertAdjacentHTML(
                'beforeend',
                `<p><strong>Hint ${current + 1}:</strong> ${esc(hints[current])}</p>`
            );

            const next = current + 1;
            panel.setAttribute('data-quiz-hint-index', String(next));

            if (next >= hints.length) {
                button.disabled = true;
                button.textContent = 'Geen hints meer';
            } else {
                button.textContent = 'Nog een hint';
            }
        }
    """#
}
