extension QuizScript.Source {
    static let checking = #"""
        function check(root, panel, item) {
            const ok = item.rule.mode === 'text'
                ? textOk(panel, item)
                : selectedOk(panel, item);
            const selected = selectedForStore(panel, item);

            stopTimer(root);
            clear(panel);

            const result = ok ? 'right' : 'wrong';
            panel.setAttribute('data-quiz-state', result);

            if (item.rule.mode !== 'text') {
                mark(panel, item);
            }

            lock(panel, true);
            recordAttempt(root, item, result, selected);
            updatePrior(root, panel, item);

            const feedback = panel.querySelector(`[data-quiz-feedback="${result}"]`);
            const copy = feedback?.querySelector?.('[data-quiz-feedback-copy]');

            if (feedback && copy) {
                const selectedIDs = new Set(selected);
                const correctIDs = new Set(item.rule.ids || []);
                const rows = [];

                if (item.rule.mode !== 'text') {
                    (item.choices || []).forEach((choice) => {
                        const choiceFeedback = choice.feedback || '';

                        if (!choiceFeedback) {
                            return;
                        }

                        if (selectedIDs.has(choice.id)) {
                            rows.push({
                                label: 'Gekozen',
                                text: choice.text,
                                feedback: choiceFeedback
                            });

                            return;
                        }

                        if (result === 'wrong' && correctIDs.has(choice.id)) {
                            rows.push({
                                label: 'Juiste optie',
                                text: choice.text,
                                feedback: choiceFeedback
                            });
                        }
                    });
                }

                const details = rows.length
                    ? `
                        <div class="wc-quiz-feedback__details">
                            <h3>Keuzefeedback</h3>
                            <ul>
                                ${rows.map((row) => `
                                    <li>
                                        <strong>${esc(row.label)}: ${esc(row.text)}</strong>
                                        <span>${esc(row.feedback)}</span>
                                    </li>
                                `).join('')}
                            </ul>
                        </div>
                    `
                    : '';

                copy.innerHTML = `
                    <p>${esc(item.explanation)}</p>
                    ${details}
                `;

                feedback.hidden = false;
            }
        }
    """#
}
