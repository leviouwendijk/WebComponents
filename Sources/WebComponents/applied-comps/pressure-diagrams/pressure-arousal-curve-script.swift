internal extension PressureArousalCurveDiagram {
    static let switchScript = #"""
    (() => {
        if (window.wcPressureSwitch?.initialized) return;

        function setState(root, state) {
            if (!root || !state) return;

            root.setAttribute('data-state', state);

            let status = '';

            root.querySelectorAll('[data-pressure-option]').forEach((option) => {
                const active = option.getAttribute('data-state') === state;
                option.setAttribute('aria-pressed', active ? 'true' : 'false');

                if (active) {
                    status = option.getAttribute('data-status') || option.textContent || '';
                }
            });

            const live = root.querySelector('[data-pressure-switch-live]');

            if (live && status) {
                live.textContent = status;
            }
        }

        function activate(option) {
            const root = option.closest('[data-pressure-switch]');
            const state = option.getAttribute('data-state');

            setState(root, state);
        }

        document.addEventListener('click', (event) => {
            const option = event.target.closest('[data-pressure-option]');

            if (!option) return;

            event.preventDefault();
            activate(option);
        });

        document.addEventListener('keydown', (event) => {
            if (event.key !== 'Enter' && event.key !== ' ') return;

            const option = event.target.closest('[data-pressure-option]');

            if (!option) return;

            event.preventDefault();
            activate(option);
        });

        function init(root = document) {
            root.querySelectorAll('[data-pressure-switch]').forEach((switchRoot) => {
                const current = switchRoot.getAttribute('data-state');
                const first = switchRoot.querySelector('[data-pressure-option]')?.getAttribute('data-state');

                setState(switchRoot, current || first);
            });
        }

        window.wcPressureSwitch = {
            initialized: true,
            init,
            setState
        };

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => init());
        } else {
            init();
        }
    })();
    """#
}
