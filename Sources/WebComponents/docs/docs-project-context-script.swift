import Constructors
import JS

public struct DocsProjectContextNavScript: ReusableComponent {
    public init() {}

    public var nodes: ReusableComponentNodes {
        .init(
            scripts: [
                JSSource(Self.source).as_inline_script()
            ]
        )
    }

    private static let source = #"""
    (() => {
        if (window.wcDocsProjectContextNav?.initialized) return;

        const rootSelector = '.wc-docs-project-context-nav';
        const detailsSelector = '.wc-docs-project-context-nav__details';

        function allDetails() {
            return Array.from(
                document.querySelectorAll(detailsSelector)
            );
        }

        function closeDetails(details) {
            if (!details) return;

            details.removeAttribute('open');
        }

        function closeAllExcept(except = null) {
            for (const details of allDetails()) {
                if (details !== except) {
                    closeDetails(details);
                }
            }
        }

        function bindDocumentClick() {
            document.addEventListener('click', (event) => {
                const activeDetails = event.target.closest?.(detailsSelector);

                if (activeDetails) {
                    closeAllExcept(activeDetails);
                    return;
                }

                closeAllExcept();
            }, true);
        }

        function bindEscape() {
            document.addEventListener('keydown', (event) => {
                if (event.key !== 'Escape') return;

                closeAllExcept();

                const active = document.activeElement;
                const contextRoot = active?.closest?.(rootSelector);

                if (!contextRoot) return;

                const summary = contextRoot.querySelector('summary');

                if (summary instanceof HTMLElement) {
                    summary.focus();
                }
            });
        }

        function init() {
            bindDocumentClick();
            bindEscape();
        }

        window.wcDocsProjectContextNav = {
            initialized: true,
            init,
            close: closeAllExcept
        };

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init);
        } else {
            init();
        }
    })();
    """#
}
