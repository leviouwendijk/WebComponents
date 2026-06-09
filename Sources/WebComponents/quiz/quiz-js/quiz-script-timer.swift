extension QuizScript.Source {
    static let timer = #"""
        function formatTime(seconds) {
            const safe = Math.max(0, Number(seconds) || 0);
            const minutes = Math.floor(safe / 60);
            const rest = safe % 60;

            if (minutes <= 0) {
                return `${rest}s`;
            }

            return `${minutes}:${String(rest).padStart(2, '0')}`;
        }

        function hasTimer(data) {
            return Number.isFinite(data.timerSeconds) && data.timerSeconds > 0;
        }

        function stopTimer(root) {
            const data = state(root);

            if (data.timerID) {
                window.clearInterval(data.timerID);
                data.timerID = null;
            }
        }

        function updateTimerToggle(panel, data) {
            const toggle = panel.querySelector('[data-quiz-timer-toggle]');

            if (!toggle) {
                return;
            }

            toggle.setAttribute(
                'aria-checked',
                data.timerEnabled ? 'true' : 'false'
            );

            toggle.setAttribute(
                'data-quiz-timer-toggle-state',
                data.timerEnabled ? 'on' : 'off'
            );
        }

        function updateTimer(root, panel, remaining) {
            const data = state(root);
            const value = panel.querySelector('[data-quiz-timer-value]');
            const timer = panel.querySelector('[data-quiz-timer]');

            if (value) {
                value.textContent = data.timerEnabled
                    ? formatTime(remaining)
                    : 'uit';
            }

            if (timer) {
                timer.setAttribute(
                    'data-quiz-timer-state',
                    !data.timerEnabled
                        ? 'off'
                        : remaining <= 5
                            ? 'danger'
                            : 'active'
                );
            }

            updateTimerToggle(panel, data);
        }

        function setTimerEnabled(root, panel, enabled) {
            const data = state(root);

            if (!hasTimer(data)) {
                return;
            }

            data.timerEnabled = Boolean(enabled);
            data.progress.settings.timerEnabled = data.timerEnabled;
            saveProgress(data);
            stopTimer(root);

            if (!data.timerEnabled) {
                updateTimer(root, panel, data.remaining);
                return;
            }

            if (panel.hasAttribute('data-quiz-state')) {
                updateTimer(root, panel, data.timerSeconds);
                return;
            }

            startTimer(root, panel);
        }

        function timeout(root, panel) {
            const data = state(root);
            const item = data.active;

            clear(panel);
            lock(panel, true);
            panel.setAttribute('data-quiz-state', 'timeout');

            if (item) {
                recordAttempt(root, item, 'timeout', []);
                updatePrior(root, panel, item);
            }

            const feedback = panel.querySelector('[data-quiz-feedback="timeout"]');

            if (feedback) {
                feedback.hidden = false;
            }

            panel.querySelector('[data-quiz-reset]')?.focus();
        }

        function startTimer(root, panel) {
            const data = state(root);
            stopTimer(root);

            if (!hasTimer(data) || !data.timerEnabled) {
                updateTimer(root, panel, data.remaining);
                return;
            }

            data.remaining = data.timerSeconds;
            updateTimer(root, panel, data.remaining);

            data.timerID = window.setInterval(() => {
                const current = root.querySelector('[data-quiz-panel]');

                if (!current || current !== panel || !data.active) {
                    stopTimer(root);
                    return;
                }

                if (!data.timerEnabled) {
                    stopTimer(root);
                    updateTimer(root, panel, data.remaining);
                    return;
                }

                if (panel.hasAttribute('data-quiz-state')) {
                    stopTimer(root);
                    return;
                }

                data.remaining -= 1;
                updateTimer(root, panel, data.remaining);

                if (data.remaining <= 0) {
                    stopTimer(root);
                    timeout(root, panel);
                }
            }, 1000);
        }
    """#
}
