import Constructors
import JS

public struct DocsPreviewTreeScript: ReusableComponent {
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
        if (window.wcDocsPreviewTree?.initialized) return;

        const rootSelector = '[data-docs-preview-tree]';
        const itemSelector = '[data-docs-preview-tree-item]';
        const selectSelector = '[data-docs-preview-tree-select]';
        const toggleSelector = '[data-docs-preview-tree-toggle]';
        const branchSelector = '[data-docs-preview-tree-branch]';
        const panelSelector = '[data-docs-preview-tree-panel]';
        const currentSelector = '[data-docs-preview-tree-current]';
        const destinationSelector =
            '[data-docs-preview-tree-destination]';

        function roots(scope = document) {
            if (scope?.matches?.(rootSelector)) {
                return [scope];
            }

            return Array.from(
                scope?.querySelectorAll?.(rootSelector) || []
            );
        }

        function elements(root, selector) {
            return Array.from(
                root?.querySelectorAll?.(selector) || []
            );
        }

        function keyed(
            root,
            selector,
            attribute,
            key
        ) {
            return elements(root, selector).find((element) => {
                return element.getAttribute(attribute) === key;
            }) || null;
        }

        function itemFor(root, key) {
            return keyed(
                root,
                itemSelector,
                'data-docs-preview-tree-item',
                key
            );
        }

        function panelFor(root, key) {
            return keyed(
                root,
                panelSelector,
                'data-docs-preview-tree-panel',
                key
            );
        }

        function branchFor(root, key) {
            return keyed(
                root,
                branchSelector,
                'data-docs-preview-tree-branch',
                key
            );
        }

        function toggleFor(root, key) {
            return keyed(
                root,
                toggleSelector,
                'data-docs-preview-tree-toggle',
                key
            );
        }

        function destinationHref(root, rawHref) {
            if (!rawHref) return '';

            if (
                rawHref.startsWith('#')
                || rawHref.startsWith('//')
                || /^[a-zA-Z][a-zA-Z\d+.-]*:/.test(rawHref)
            ) {
                return rawHref;
            }

            const origin = root.getAttribute(
                'data-docs-preview-tree-origin'
            ) || '';

            if (!origin) return rawHref;

            try {
                const base = origin.endsWith('/')
                    ? origin
                    : `${origin}/`;

                return new URL(rawHref, base).href;
            } catch {
                return rawHref;
            }
        }

        function applyLinkPolicy(root) {
            const newTab = root.getAttribute(
                'data-docs-preview-tree-new-tab'
            ) === 'true';

            root.querySelectorAll('a[href]').forEach((anchor) => {
                const rawHref = anchor.getAttribute('href') || '';
                const href = destinationHref(root, rawHref);

                if (href) {
                    anchor.setAttribute('href', href);
                }

                if (
                    newTab
                    && href
                    && !href.startsWith('#')
                ) {
                    anchor.setAttribute('target', '_blank');
                    anchor.setAttribute(
                        'rel',
                        'noopener noreferrer'
                    );
                }
            });
        }

        function setExpanded(
            root,
            key,
            expanded
        ) {
            const branch = branchFor(root, key);
            const toggle = toggleFor(root, key);

            if (!branch || !toggle) return false;

            branch.hidden = !expanded;

            toggle.setAttribute(
                'aria-expanded',
                expanded ? 'true' : 'false'
            );

            return true;
        }

        function revealAncestors(root, item) {
            let current = item;

            while (current) {
                const parent = current
                    .parentElement
                    ?.closest?.(itemSelector);

                if (!parent || !root.contains(parent)) {
                    break;
                }

                const key = parent.getAttribute(
                    'data-docs-preview-tree-item'
                );

                if (key) {
                    setExpanded(root, key, true);
                }

                current = parent;
            }
        }

        function nodeTitle(item) {
            return item
                ?.querySelector(
                    '.wc-docs-preview-tree__node-title'
                )
                ?.textContent
                ?.trim() || '';
        }

        function updateFooter(
            root,
            item,
            panel
        ) {
            const current = root.querySelector(
                currentSelector
            );

            if (current) {
                current.textContent = nodeTitle(item);
            }

            const destination = root.querySelector(
                destinationSelector
            );

            if (!destination) return;

            const rawTarget = panel?.getAttribute(
                'data-docs-preview-tree-target'
            ) || '';

            const target = destinationHref(
                root,
                rawTarget
            );

            if (target) {
                destination.hidden = false;
                destination.setAttribute('href', target);
            } else {
                destination.hidden = true;
                destination.removeAttribute('href');
            }
        }

        function select(
            root,
            key,
            options = {}
        ) {
            const item = itemFor(root, key);
            const panel = panelFor(root, key);

            if (!item || !panel) {
                return false;
            }

            revealAncestors(root, item);

            elements(root, itemSelector).forEach((candidate) => {
                const selected = candidate === item;

                candidate.setAttribute(
                    'aria-selected',
                    selected ? 'true' : 'false'
                );

                candidate
                    .querySelectorAll(selectSelector)
                    .forEach((control) => {
                        control.setAttribute(
                            'aria-pressed',
                            selected ? 'true' : 'false'
                        );
                    });
            });

            elements(root, panelSelector).forEach((candidate) => {
                candidate.hidden = candidate !== panel;
            });

            root.setAttribute(
                'data-docs-preview-tree-active',
                key
            );

            updateFooter(root, item, panel);

            if (options.focus === true) {
                item
                    .querySelector(selectSelector)
                    ?.focus();
            }

            item.scrollIntoView({
                block: 'nearest',
                inline: 'nearest'
            });

            root.dispatchEvent(
                new CustomEvent(
                    'wc:docs-preview-tree:change',
                    {
                        bubbles: true,
                        detail: {
                            key,
                            item,
                            panel
                        }
                    }
                )
            );

            return true;
        }

        function toggle(root, key) {
            const control = toggleFor(root, key);

            if (!control) return false;

            const expanded = control.getAttribute(
                'aria-expanded'
            ) === 'true';

            return setExpanded(
                root,
                key,
                !expanded
            );
        }

        function visibleItems(root) {
            return elements(root, itemSelector).filter((item) => {
                return item.closest('[hidden]') == null;
            });
        }

        function focusItem(item) {
            item
                ?.querySelector(selectSelector)
                ?.focus();
        }

        function parentItem(root, item) {
            const parent = item
                ?.parentElement
                ?.closest?.(itemSelector);

            return parent && root.contains(parent)
                ? parent
                : null;
        }

        function firstChildItem(root, item) {
            const key = item?.getAttribute(
                'data-docs-preview-tree-item'
            );

            if (!key) return null;

            const branch = branchFor(root, key);

            return Array.from(branch?.children || []).find(
                (child) => child.matches?.(itemSelector)
            ) || null;
        }

        function bindClicks() {
            document.addEventListener(
                'click',
                (event) => {
                    const toggleControl =
                        event.target?.closest?.(toggleSelector);

                    if (toggleControl) {
                        const root = toggleControl.closest(
                            rootSelector
                        );

                        if (!root) return;

                        event.preventDefault();

                        toggle(
                            root,
                            toggleControl.getAttribute(
                                'data-docs-preview-tree-toggle'
                            )
                        );

                        return;
                    }

                    const selectControl =
                        event.target?.closest?.(selectSelector);

                    if (!selectControl) return;

                    const root = selectControl.closest(
                        rootSelector
                    );

                    if (!root) return;

                    event.preventDefault();

                    select(
                        root,
                        selectControl.getAttribute(
                            'data-docs-preview-tree-select'
                        )
                    );
                },
                true
            );
        }

        function bindKeyboard() {
            document.addEventListener(
                'keydown',
                (event) => {
                    const item = event.target?.closest?.(
                        itemSelector
                    );

                    if (!item) return;

                    const root = item.closest(rootSelector);

                    if (!root) return;

                    const items = visibleItems(root);
                    const index = items.indexOf(item);
                    const key = item.getAttribute(
                        'data-docs-preview-tree-item'
                    );

                    let target = null;

                    switch (event.key) {
                    case 'ArrowDown':
                        target = items[
                            Math.min(index + 1, items.length - 1)
                        ];
                        break;

                    case 'ArrowUp':
                        target = items[
                            Math.max(index - 1, 0)
                        ];
                        break;

                    case 'Home':
                        target = items[0];
                        break;

                    case 'End':
                        target = items[items.length - 1];
                        break;

                    case 'ArrowRight': {
                        const control = toggleFor(root, key);
                        const expanded =
                            control?.getAttribute(
                                'aria-expanded'
                            ) === 'true';

                        if (control && !expanded) {
                            setExpanded(root, key, true);
                        } else {
                            target = firstChildItem(root, item);
                        }

                        break;
                    }

                    case 'ArrowLeft': {
                        const control = toggleFor(root, key);
                        const expanded =
                            control?.getAttribute(
                                'aria-expanded'
                            ) === 'true';

                        if (control && expanded) {
                            setExpanded(root, key, false);
                        } else {
                            target = parentItem(root, item);
                        }

                        break;
                    }

                    default:
                        return;
                    }

                    event.preventDefault();

                    if (target) {
                        focusItem(target);
                    }
                },
                true
            );
        }

        function initializeRoot(root) {
            applyLinkPolicy(root);

            const requested = root.getAttribute(
                'data-docs-preview-tree-active'
            );

            const first = elements(
                root,
                itemSelector
            )[0];

            const key = requested
                || first?.getAttribute(
                    'data-docs-preview-tree-item'
                );

            if (key) {
                select(root, key);
            }
        }

        function init(scope = document) {
            roots(scope).forEach(initializeRoot);
        }

        function boot() {
            bindClicks();
            bindKeyboard();
            init();
        }

        window.wcDocsPreviewTree = {
            initialized: true,
            init,
            select,
            toggle
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

        window.addEventListener(
            'pageshow',
            () => init()
        );
    })();
    """#
}
