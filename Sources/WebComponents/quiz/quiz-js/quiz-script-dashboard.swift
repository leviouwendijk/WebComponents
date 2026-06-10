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

            renderReport(root);
        }

        function secondsLabel(ms) {
            const seconds = Math.max(0, Math.round((Number(ms) || 0) / 1000));

            if (seconds < 60) {
                return `${seconds}s`;
            }

            const minutes = Math.floor(seconds / 60);
            const rest = seconds % 60;

            return `${minutes}:${String(rest).padStart(2, '0')}`;
        }

        function percentLabel(part, whole) {
            if (!whole) {
                return '0%';
            }

            return `${Math.round((part / whole) * 100)}%`;
        }

        function reportStats(data) {
            const rows = data.items.map((item) => {
                const entry = itemProgress(data, item.id);
                const result = entry?.lastResult || 'unanswered';

                return {
                    item,
                    entry,
                    result,
                    answered: Boolean(entry && isResult(result)),
                    right: result === 'right',
                    weak: result === 'wrong'
                        || result === 'timeout'
                        || (entry?.attempts || 0) > 1
                        || (entry?.hintsUsed || 0) > 0
                };
            });

            const answeredRows = rows.filter((row) => row.answered);
            const rightRows = rows.filter((row) => row.right);
            const attempts = answeredRows.reduce((total, row) => total + (row.entry?.attempts || 0), 0);
            const hints = rows.reduce((total, row) => total + (row.entry?.hintsUsed || 0), 0);
            const totalMs = rows.reduce((total, row) => total + (row.entry?.totalMs || 0), 0);

            return {
                rows,
                answeredRows,
                rightRows,
                attempts,
                hints,
                totalMs
            };
        }

        function renderFocus(stats) {
            const focus = new Map();

            stats.rows
                .filter((row) => row.weak)
                .forEach((row) => {
                    const key = row.item.group || 'Algemeen';
                    const current = focus.get(key) || {
                        group: key,
                        count: 0,
                        reasons: new Set()
                    };

                    current.count += 1;

                    if (row.result === 'wrong') current.reasons.add('incorrect');
                    if (row.result === 'timeout') current.reasons.add('tijd verstreken');
                    if ((row.entry?.attempts || 0) > 1) current.reasons.add('meerdere pogingen');
                    if ((row.entry?.hintsUsed || 0) > 0) current.reasons.add('hints gebruikt');

                    focus.set(key, current);
                });

            const items = Array.from(focus.values())
                .sort((left, right) => right.count - left.count);

            if (!items.length) {
                return '<p class="wc-quiz-report__empty">Geen opvallende focusgebieden. Ga zo door.</p>';
            }

            return `
                <ul class="wc-quiz-report__focus-list">
                    ${items.map((item) => `
                        <li>
                            <strong>${esc(item.group)}</strong>
                            <span>${item.count} aandachtspunt(en): ${esc(Array.from(item.reasons).join(', '))}</span>
                        </li>
                    `).join('')}
                </ul>
            `;
        }

        function renderRows(stats) {
            const answered = stats.rows.filter((row) => row.answered);

            if (!answered.length) {
                return '<p class="wc-quiz-report__empty">Nog geen vragen beantwoord.</p>';
            }

            return `
                <ul class="wc-quiz-report__row-list">
                    ${answered.map((row) => `
                        <li class="wc-quiz-report__row" data-quiz-report-result="${esc(row.result)}">
                            <div class="wc-quiz-report__row-head">
                                <strong>${esc(row.item.title)}</strong>
                                <span>${esc(labelForResult(row.result))}</span>
                            </div>
                            <div class="wc-quiz-report__row-meta">
                                ${esc(row.item.group)} · ${attemptLabel(row.entry?.attempts || 0)} · ${row.entry?.hintsUsed || 0} hint(s) · ${secondsLabel(row.entry?.totalMs || 0)}
                            </div>
                        </li>
                    `).join('')}
                </ul>
            `;
        }

        function renderReport(root) {
            const report = root.querySelector('[data-quiz-report]');
            if (!report) return;

            const data = state(root);
            const stats = reportStats(data);
            const total = data.items.length;
            const answered = stats.answeredRows.length;
            const right = stats.rightRows.length;
            const score = answered > 0 ? percentLabel(right, answered) : 'Nog geen score';

            const lead = report.querySelector('[data-quiz-report-lead]');
            const scoreNode = report.querySelector('[data-quiz-report-score]');
            const answeredNode = report.querySelector('[data-quiz-report-answered]');
            const timeNode = report.querySelector('[data-quiz-report-time]');
            const attemptsNode = report.querySelector('[data-quiz-report-attempts]');
            const hintsNode = report.querySelector('[data-quiz-report-hints]');
            const focusNode = report.querySelector('[data-quiz-report-focus]');
            const rowsNode = report.querySelector('[data-quiz-report-rows]');

            if (lead) {
                lead.textContent = answered === total && total > 0
                    ? `Afgerond: ${right} van ${total} vragen correct.`
                    : `${answered} van ${total} vragen beantwoord. Het rapport werkt live mee.`;
            }

            if (scoreNode) scoreNode.textContent = score;
            if (answeredNode) answeredNode.textContent = `${answered} van ${total}`;
            if (timeNode) timeNode.textContent = secondsLabel(stats.totalMs);
            if (attemptsNode) attemptsNode.textContent = stats.attempts ? `${stats.attempts}` : '0';
            if (hintsNode) hintsNode.textContent = `${stats.hints} gebruikt`;
            if (focusNode) focusNode.innerHTML = renderFocus(stats);
            if (rowsNode) rowsNode.innerHTML = renderRows(stats);
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
