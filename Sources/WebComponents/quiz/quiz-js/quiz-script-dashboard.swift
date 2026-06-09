extension QuizScript.Source {
    static let dashboard = #"""
        function statusForCard(entry) {
            if (!entry) {
                return 'unanswered';
            }

            return entry.lastResult || 'unanswered';
        }

        function renderHistory(entry) {
            if (!entry?.history?.length) {
                return '';
            }

            return entry.history
                .slice(-5)
                .map((result) => `<span class="wc-quiz-card__history-dot" data-quiz-history-result="${esc(result)}"></span>`)
                .join('');
        }

        function renderProgress(root) {
            const data = state(root);
            let answered = 0;
            let right = 0;
            let wrong = 0;
            let timeoutCount = 0;

            root.querySelectorAll('[data-quiz-card]').forEach((card) => {
                const id = card.getAttribute('data-quiz-open');
                const entry = itemProgress(data, id);
                const status = statusForCard(entry);
                const attempts = entry?.attempts || 0;

                if (entry) {
                    answered += 1;

                    if (entry.lastResult === 'right') {
                        right += 1;
                    } else if (entry.lastResult === 'wrong') {
                        wrong += 1;
                    } else if (entry.lastResult === 'timeout') {
                        timeoutCount += 1;
                    }
                }

                card.setAttribute('data-quiz-card-state', status);
                card.setAttribute('data-quiz-card-attempts', String(attempts));

                const statusNode = card.querySelector('[data-quiz-card-status]');
                const attemptsNode = card.querySelector('[data-quiz-card-attempts-label]');
                const historyNode = card.querySelector('[data-quiz-card-history]');

                if (statusNode) {
                    statusNode.textContent = labelForResult(status);
                }

                if (attemptsNode) {
                    attemptsNode.textContent = attemptLabel(attempts);
                }

                if (historyNode) {
                    historyNode.innerHTML = renderHistory(entry);
                }
            });

            const count = root.querySelector('[data-quiz-progress-count]');
            const detail = root.querySelector('[data-quiz-progress-detail]');
            const reset = root.querySelector('[data-quiz-reset-all]');

            if (count) {
                count.textContent = `${answered} van ${data.items.length} beantwoord`;
            }

            if (detail) {
                detail.textContent = answered > 0
                    ? `${right} correct · ${wrong} incorrect · ${timeoutCount} tijd verstreken`
                    : 'Nog geen antwoorden';
            }

            if (reset) {
                reset.disabled = answered === 0;
            }
        }

        function init(scope = document) {
            const roots = scope.matches?.(rootSelector)
                ? [scope]
                : Array.from(scope.querySelectorAll?.(rootSelector) || []);

            roots.forEach((root) => {
                state(root);
                renderProgress(root);
                openFromHash(root);
            });
        }
    """#
}
