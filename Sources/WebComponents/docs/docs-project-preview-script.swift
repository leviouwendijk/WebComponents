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

        const rootSelector =
            '[data-docs-project-preview]';

        const categoryLinkSelector =
            '[data-wc-docs-category-nav] [data-docs-category-id]';

        const panelSelector =
            '[data-docs-project-preview-panel]';

        const currentSelector =
            '[data-docs-project-preview-current]';

        const destinationSelector =
            '[data-docs-project-preview-destination]';

        function roots(scope = document) {
            if (scope?.matches?.(rootSelector)) {
                return [scope];
            }

            return Array.from(
                scope?.querySelectorAll?.(rootSelector) || []
            );
        }

        function categoryLinks(root) {
            return Array.from(
                root?.querySelectorAll?.(
                    categoryLinkSelector
                ) || []
            );
        }

        function panels(root) {
            return Array.from(
                root?.querySelectorAll?.(
                    panelSelector
                ) || []
            );
        }

        function categoryIDForLink(link) {
            return link?.getAttribute(
                'data-docs-category-id'
            ) || '';
        }

        function categoryIDForPanel(panel) {
            return panel?.getAttribute(
                'data-docs-project-preview-panel'
            ) || '';
        }

        function destinationHref(
            root,
            rawHref
        ) {
            if (!rawHref) return rawHref;

            if (
                rawHref.startsWith('#')
                || rawHref.startsWith('//')
                || /^[a-zA-Z][a-zA-Z\d+.-]*:/.test(
                    rawHref
                )
            ) {
                return rawHref;
            }

            const origin = root.getAttribute(
                'data-docs-project-preview-origin'
            ) || '';

            if (!origin) return rawHref;

            try {
                const base = origin.endsWith('/')
                    ? origin
                    : `${origin}/`;

                return new URL(
                    rawHref,
                    base
                ).href;
            } catch {
                return rawHref;
            }
        }

        function applyLinkPolicy(root) {
            const openInNewTab =
                root.getAttribute(
                    'data-docs-project-preview-new-tab'
                ) === 'true';

            root.querySelectorAll(
                'a[href]'
            ).forEach((anchor) => {
                const rawHref = anchor.getAttribute(
                    'href'
                );

                const resolvedHref = destinationHref(
                    root,
                    rawHref
                );

                if (resolvedHref) {
                    anchor.setAttribute(
                        'href',
                        resolvedHref
                    );
                }

                if (
                    openInNewTab
                    && resolvedHref
                    && !resolvedHref.startsWith('#')
                ) {
                    anchor.setAttribute(
                        'target',
                        '_blank'
                    );

                    anchor.setAttribute(
                        'rel',
                        'noopener noreferrer'
                    );
                }
            });
        }

        function activate(
            root,
            categoryID,
            options = {}
        ) {
            if (!root || !categoryID) {
                return false;
            }

            const links = categoryLinks(root);
            const availablePanels = panels(root);

            const nextLink = links.find((link) => {
                return categoryIDForLink(link)
                    === categoryID;
            });

            const nextPanel = availablePanels.find(
                (panel) => {
                    return categoryIDForPanel(panel)
                        === categoryID;
                }
            );

            if (!nextLink || !nextPanel) {
                return false;
            }

            links.forEach((link) => {
                if (link === nextLink) {
                    link.setAttribute(
                        'aria-current',
                        'page'
                    );
                } else {
                    link.removeAttribute(
                        'aria-current'
                    );
                }
            });

            availablePanels.forEach((panel) => {
                panel.hidden = panel !== nextPanel;
            });

            nextPanel.scrollTop = 0;
            nextPanel.scrollLeft = 0;

            root.setAttribute(
                'data-docs-project-preview-active',
                categoryID
            );

            const label =
                nextLink
                    .querySelector(
                        '.docs-category-nav__label'
                    )
                    ?.textContent
                    ?.trim()
                || nextLink.textContent?.trim()
                || '';

            const rawHref =
                nextLink.getAttribute(
                    'data-docs-category-href'
                )
                || nextLink.getAttribute('href')
                || '';

            const resolvedHref = destinationHref(
                root,
                rawHref
            );

            const current = root.querySelector(
                currentSelector
            );

            if (current) {
                current.textContent = label;
            }

            const destination = root.querySelector(
                destinationSelector
            );

            if (destination && resolvedHref) {
                destination.setAttribute(
                    'href',
                    resolvedHref
                );
            }

            if (options.focus === true) {
                nextLink.focus();
            }

            window.requestAnimationFrame(() => {
                window
                    .wcDocsCategoryNav
                    ?.settle
                    ?.();
            });

            root.dispatchEvent(
                new CustomEvent(
                    'wc:docs-project-preview:change',
                    {
                        bubbles: true,
                        detail: {
                            categoryID,
                            label,
                            href: resolvedHref,
                            panel: nextPanel
                        }
                    }
                )
            );

            return true;
        }

        function initializeRoot(root) {
            if (!root) return;

            applyLinkPolicy(root);

            const requested = root.getAttribute(
                'data-docs-project-preview-active'
            );

            const selected = categoryLinks(root).find(
                (link) => {
                    return link.getAttribute(
                        'aria-current'
                    ) === 'page';
                }
            );

            const first = categoryLinks(root)[0];

            const categoryID =
                requested
                || categoryIDForLink(selected)
                || categoryIDForLink(first);

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
                    const link =
                        event.target?.closest?.(
                            categoryLinkSelector
                        );

                    if (!link) return;

                    const root = link.closest(
                        rootSelector
                    );

                    if (!root) return;

                    if (
                        event.button !== 0
                        || event.metaKey
                        || event.ctrlKey
                        || event.shiftKey
                        || event.altKey
                    ) {
                        return;
                    }

                    event.preventDefault();

                    activate(
                        root,
                        categoryIDForLink(link),
                        {
                            focus: false
                        }
                    );
                },
                true
            );
        }

        function init(scope = document) {
            roots(scope).forEach(
                initializeRoot
            );
        }

        function boot() {
            bindClicks();
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

        window.addEventListener(
            'pageshow',
            () => {
                init();
            }
        );
    })();
    """#
}
