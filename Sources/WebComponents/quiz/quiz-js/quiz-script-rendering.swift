extension QuizScript.Source {
    static let rendering = #"""
        function timerHTML(data) {
            if (!hasTimer(data)) return '';

            const checked = data.timerEnabled ? 'true' : 'false';
            const state = data.timerEnabled ? 'on' : 'off';

            return `
                <div class="wc-quiz-timer-controls" data-quiz-timer-controls>
                    <div class="wc-quiz-timer" data-quiz-timer data-quiz-timer-state="${data.timerEnabled ? 'active' : 'off'}" aria-live="polite">
                        <span>Tijd</span>
                        <strong data-quiz-timer-value>${data.timerEnabled ? esc(formatTime(data.timerSeconds)) : 'uit'}</strong>
                    </div>

                    <button class="wc-quiz-timer-toggle" type="button" role="switch" aria-label="Timer in- of uitschakelen" aria-checked="${checked}" data-quiz-timer-toggle data-quiz-timer-toggle-state="${state}">
                        <span class="wc-quiz-timer-toggle__label">Timer</span>
                        <span class="wc-quiz-timer-toggle__track" aria-hidden="true">
                            <span class="wc-quiz-timer-toggle__thumb"></span>
                        </span>
                    </button>
                </div>
            `;
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
                    <span data-quiz-prior-text>${priorText(entry)}</span>
                </div>
            `;
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

        function render(data, item) {
            const entry = itemProgress(data, item.id);
            const resetDisabled = entry ? '' : 'disabled';

            return `
                <button class="wc-quiz__back" type="button" data-quiz-close>
                    Alle vragen
                </button>

                <article class="wc-quiz-item" data-quiz-item>
                    <header class="wc-quiz-item__head">
                        <div class="wc-quiz-item__kicker">
                            <div class="wc-quiz-item__eyebrow">
                                ${esc(item.group)} · ${esc(item.levelLabel)}
                            </div>
                            ${timerHTML(data)}
                        </div>

                        <p class="wc-quiz-topic">${esc(item.title)}</p>

                        <h1 id="wc-quiz-panel-title">${esc(item.prompt)}</h1>

                        ${progressHTML(data, item)}
                    </header>

                    <form class="wc-quiz-form" data-quiz-form>
                        ${optionHTML(item)}

                        <div class="wc-quiz-form__actions">
                            <button class="wc-quiz-btn wc-quiz-btn--main" type="submit">
                                Controleer
                            </button>

                            <button class="wc-quiz-btn wc-quiz-btn--reset" type="button" data-quiz-reset>
                                Opnieuw
                            </button>

                            <button class="wc-quiz-btn wc-quiz-btn--clear" type="button" data-quiz-reset-item ${resetDisabled}>
                                Reset dit antwoord
                            </button>
                        </div>
                    </form>

                    <div class="wc-quiz-feedback wc-quiz-feedback--right" data-quiz-feedback="right" hidden>
                        <h2>Correct</h2>
                        <div data-quiz-feedback-copy></div>
                    </div>

                    <div class="wc-quiz-feedback wc-quiz-feedback--wrong" data-quiz-feedback="wrong" hidden>
                        <h2>Incorrect</h2>
                        <div data-quiz-feedback-copy></div>
                    </div>

                    <div class="wc-quiz-feedback wc-quiz-feedback--timeout" data-quiz-feedback="timeout" hidden>
                        <h2>Tijd verstreken</h2>
                        <p>Je hebt niet op tijd geantwoord. Probeer opnieuw om dezelfde vraag nog eens te beantwoorden.</p>
                    </div>
                </article>

                ${navHTML(data, item)}
            `;
        }
    """#
}
