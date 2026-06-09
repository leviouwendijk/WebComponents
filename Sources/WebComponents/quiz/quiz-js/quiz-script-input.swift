extension QuizScript.Source {
    static let input = #"""
        function radioInputFromEvent(event) {
            const input = event.target?.closest?.('[data-quiz-option] input[type="radio"]');

            if (input) {
                return input;
            }

            const option = event.target?.closest?.('[data-quiz-option]');

            return option?.querySelector?.('input[type="radio"]') || null;
        }

        function rememberRadioState(event) {
            const input = radioInputFromEvent(event);

            if (!input || input.disabled) {
                return;
            }

            input.setAttribute(
                'data-quiz-was-checked',
                input.checked ? 'true' : 'false'
            );
        }

        function toggleSelectedRadio(event) {
            const input = radioInputFromEvent(event);

            if (!input || input.disabled) {
                return false;
            }

            const wasChecked = input.getAttribute('data-quiz-was-checked') === 'true';
            input.removeAttribute('data-quiz-was-checked');

            if (!wasChecked) {
                return false;
            }

            event.preventDefault();
            event.stopPropagation();

            input.checked = false;
            input.focus();

            input.dispatchEvent(
                new Event(
                    'change',
                    {
                        bubbles: true
                    }
                )
            );

            return true;
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

        function focusFirstControl(panel) {
            panel.focus(
                {
                    preventScroll: true
                }
            );
        }

        function lock(panel, locked) {
            panel.toggleAttribute('data-quiz-locked', locked);

            panel
                .querySelectorAll('input, button[type="submit"]')
                .forEach((control) => {
                    control.disabled = locked;
                });
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
    """#
}
