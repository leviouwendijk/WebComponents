import Constructors
import JS

public struct DocsProjectPreviewScript: ReusableComponent {
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
        if (window.wcDocsProjectPreview?.initialized) return;

        const rootSelector = '[data-docs-project-preview]';
        const tabSelector = '[data-docs-project-preview-tab]';
        const panelSelector = '[data-docs-project-preview-panel]';
        const currentSelector = '[data-docs-project-preview-current]';
        const destinationSelector = '[data-docs-project-preview-destination]';

        function previewRoots(scope = document) {
            if (scope?.matches?.(rootSelector)) {
                return [scope];
            }

            return Array.from(
                scope?.querySelectorAll?.(rootSelector) || []
            );
        }

        function previewTabs(root) {
            return Array.from(
                root?.querySelectorAll?.(tabSelector) || []
            );
        }

        function previewPanels(root) {
            return Array.from(
                root?.querySelectorAll?.(panelSelector) || []
            );
        }

        function categoryIDForTab(tab) {
            return tab?.getAttribute(
                'data-docs-project-preview-tab'
            ) || '';
        }

        function categoryIDForPanel(panel) {
            return panel?.getAttribute(
                'data-docs-project-preview-panel'
            ) || '';
        }

        function activeTab(root) {
            return previewTabs(root).find((tab) => {
                return tab.getAttribute('aria-selected') === 'true';
            }) || null;
        }

        function activate(
            root,
            categoryID,
            options = {}
        ) {
            if (!root || !categoryID) return false;

            const tabs = previewTabs(root);
            const panels = previewPanels(root);

            const nextTab = tabs.find((tab) => {
                return categoryIDForTab(tab) === categoryID;
            });

            const nextPanel = panels.find((panel) => {
                return categoryIDForPanel(panel) === categoryID;
            });

            if (!nextTab || !nextPanel) {
                return false;
            }

            tabs.forEach((tab) => {
                const selected = tab === nextTab;

                tab.setAttribute(
                    'aria-selected',
                    selected ? 'true' : 'false'
                );

                tab.tabIndex = selected ? 0 : -1;
            });

            panels.forEach((panel) => {
                panel.hidden = panel !== nextPanel;
            });

            const scroller = root.querySelector(
                '.wc-docs-project-preview__panels'
            );

            if (scroller) {
                scroller.scrollTop = 0;
                scroller.scrollLeft = 0;
            }

            root.setAttribute(
                'data-docs-project-preview-active',
                categoryID
            );

            const label = nextTab.getAttribute(
                'data-docs-project-preview-label'
            ) || nextTab.textContent?.trim() || '';

            const href = nextTab.getAttribute(
                'data-docs-project-preview-href'
            ) || '';

            const current = root.querySelector(
                currentSelector
            );

            if (current) {
                current.textContent = label;
            }

            const destination = root.querySelector(
                destinationSelector
            );

            if (destination && href) {
                destination.setAttribute(
                    'href',
                    href
                );
            }

            if (options.focus === true) {
                nextTab.focus();
            }

            root.dispatchEvent(
                new CustomEvent(
                    'wc:docs-project-preview:change',
                    {
                        bubbles: true,
                        detail: {
                            categoryID,
                            label,
                            href,
                            panel: nextPanel
                        }
                    }
                )
            );

            return true;
        }

        function initializeRoot(root) {
            if (!root) return;

            const requested = root.getAttribute(
                'data-docs-project-preview-active'
            );

            const selected = activeTab(root);
            const first = previewTabs(root)[0];

            const categoryID = requested
                || categoryIDForTab(selected)
                || categoryIDForTab(first);

            if (!categoryID) return;

            activate(
                root,
                categoryID
            );
        }

        function bindClicks() {
            document.addEventListener(
                'click',
                (event) => {
                    const tab = event.target?.closest?.(
                        tabSelector
                    );

                    if (!tab) return;

                    const root = tab.closest(
                        rootSelector
                    );

                    if (!root) return;

                    activate(
                        root,
                        categoryIDForTab(tab)
                    );
                },
                true
            );
        }

        function bindKeyboard() {
            document.addEventListener(
                'keydown',
                (event) => {
                    const tab = event.target?.closest?.(
                        tabSelector
                    );

                    if (!tab) return;

                    const root = tab.closest(
                        rootSelector
                    );

                    if (!root) return;

                    const tabs = previewTabs(root);
                    const index = tabs.indexOf(tab);

                    if (index < 0 || tabs.length === 0) {
                        return;
                    }

                    let nextIndex;

                    switch (event.key) {
                    case 'ArrowRight':
                    case 'ArrowDown':
                        nextIndex = (
                            index + 1
                        ) % tabs.length;
                        break;

                    case 'ArrowLeft':
                    case 'ArrowUp':
                        nextIndex = (
                            index - 1 + tabs.length
                        ) % tabs.length;
                        break;

                    case 'Home':
                        nextIndex = 0;
                        break;

                    case 'End':
                        nextIndex = tabs.length - 1;
                        break;

                    default:
                        return;
                    }

                    event.preventDefault();

                    const nextTab = tabs[nextIndex];

                    activate(
                        root,
                        categoryIDForTab(nextTab),
                        {
                            focus: true
                        }
                    );
                },
                true
            );
        }

        function init(scope = document) {
            previewRoots(scope).forEach(
                initializeRoot
            );
        }

        function boot() {
            bindClicks();
            bindKeyboard();
            init();
        }

        window.wcDocsProjectPreview = {
            initialized: true,
            init,
            activate
        };

        if (document.readyState === 'loading') {
            document.addEventListener(
                'DOMContentLoaded',
                boot,
                {
                    once: true
                }
            );
        } else {
            boot();
        }
    })();
    """#
}
