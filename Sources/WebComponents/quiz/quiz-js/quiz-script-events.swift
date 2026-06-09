extension QuizScript.Source {
    static let events = #"""
        document.addEventListener(
            'pointerdown',
            rememberRadioState,
            true
        );

        document.addEventListener(
            'click',
            (event) => {
                toggleSelectedRadio(event);
            },
            true
        );

        document.addEventListener('click', (event) => {
            const timerToggle = event.target?.closest?.('[data-quiz-timer-toggle]');

            if (timerToggle) {
                const root = timerToggle.closest(rootSelector);
                const panel = timerToggle.closest('[data-quiz-panel]');

                if (!root || !panel) return;

                event.preventDefault();

                setTimerEnabled(
                    root,
                    panel,
                    timerToggle.getAttribute('aria-checked') !== 'true'
                );

                return;
            }

            const resetAll = event.target?.closest?.('[data-quiz-reset-all]');

            if (resetAll) {
                const root = resetAll.closest(rootSelector);
                if (!root) return;

                event.preventDefault();
                resetAllProgress(root);
                return;
            }

            const resetItem = event.target?.closest?.('[data-quiz-reset-item]');

            if (resetItem) {
                const root = resetItem.closest(rootSelector);
                const panel = resetItem.closest('[data-quiz-panel]');

                if (!root || !panel) return;

                const item = state(root).active;
                if (!item) return;

                event.preventDefault();
                stopTimer(root);
                resetItemProgress(root, item.id);
                resetPanelAttempt(panel);
                updatePrior(root, panel, item);
                startTimer(root, panel);
                focusFirstControl(panel);
                return;
            }

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
            check(root, panel, item);
        });

        document.addEventListener('click', (event) => {
            const reset = event.target?.closest?.('[data-quiz-reset]');
            if (!reset) return;

            const root = reset.closest(rootSelector);
            const panel = reset.closest('[data-quiz-panel]');
            if (!root || !panel) return;

            stopTimer(root);
            resetPanelAttempt(panel);
            startTimer(root, panel);
            focusFirstControl(panel);
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
    """#
}
