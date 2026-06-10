extension QuizScript.Source {
    static let progress = #"""
        function isResult(value) {
            return value === 'right' || value === 'wrong' || value === 'timeout';
        }

        function labelForResult(value) {
            switch (value) {
            case 'right':
                return 'Correct';
            case 'wrong':
                return 'Incorrect';
            case 'timeout':
                return 'Tijd verstreken';
            default:
                return 'Onbeantwoord';
            }
        }

        function attemptLabel(attempts) {
            const count = Math.max(0, Number(attempts) || 0);

            if (count === 1) {
                return '1 poging';
            }

            return `${count} pogingen`;
        }

        function itemProgress(data, itemID) {
            return data.progress.items[itemID] || null;
        }

        function selectedForStore(panel, item) {
            if (item.rule.mode === 'text') {
                return [];
            }

            return picked(panel);
        }

        function recordAttempt(root, item, result, selected = []) {
            const data = state(root);
            const previous = itemProgress(data, item.id);
            const history = previous?.history ? [...previous.history] : [];

            history.push(result);

            data.progress.items[item.id] = {
                attempts: (previous?.attempts || 0) + 1,
                lastResult: result,
                status: result,
                selected: item.rule.mode === 'text' ? [] : selected,
                history: history.slice(-20),
                updatedAt: now()
            };

            saveProgress(data);
            renderProgress(root);
        }

        function resetItemProgress(root, itemID) {
            const data = state(root);

            delete data.progress.items[itemID];
            saveProgress(data);
            renderProgress(root);
        }

        function resetAllProgress(root) {
            const data = state(root);

            data.progress.items = {};
            saveProgress(data);
            renderProgress(root);
        }

        function priorText(entry) {
            const label = labelForResult(entry.lastResult);
            const attempts = attemptLabel(entry.attempts);

            if (entry.lastResult === 'timeout') {
                return `Eerder afgebroken: ${label.toLowerCase()} · ${attempts}`;
            }

            return `Eerder beantwoord: ${label} · ${attempts}`;
        }

        function progressHTML(data, item) {
            const entry = itemProgress(data, item.id);

            if (!entry) {
                return `
                    <div class="wc-quiz-prior" data-quiz-prior hidden>
                        <span data-quiz-prior-text></span>
                    </div>
                `;
            }

            return `
                <div class="wc-quiz-prior" data-quiz-prior data-quiz-prior-state="${esc(entry.lastResult)}">
                    <span data-quiz-prior-text>${esc(priorText(entry))}</span>
                </div>
            `;
        }
    """#
}
