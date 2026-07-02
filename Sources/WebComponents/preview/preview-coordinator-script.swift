import Constructors
import JS

public struct PreviewCoordinatorScript: ReusableComponent {
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
        if (window.wcPreviewCoordinator?.initialized) {
            window.wcReferencePreviewLink = window.wcPreviewCoordinator;
            window.wcHoverPreviewLink = window.wcPreviewCoordinator;
            window.wcHoverPreviewLinkScope = window.wcPreviewCoordinator;
            return;
        }

        const sheetQuery = '(max-width: 640px)';
        const margin = 14;
        const gap = 12;
        const closeDelay = 260;
        const stateClearDelay = 460;

        const adapters = [
            {
                name: 'reference',
                rootSelector: '.wc-reference-preview',
                triggerSelector: '.wc-reference-preview__trigger',
                cardSelector: '.wc-reference-preview__card',
                sync: null
            },
            {
                name: 'hover',
                rootSelector: '[data-hover-preview]',
                triggerSelector: '.wc-hover-preview__link',
                cardSelector: '.wc-hover-preview__card',
                sync: syncHoverRoot
            }
        ];

        const rootSelector = adapters
            .map(adapter => adapter.rootSelector)
            .join(', ');

        let activeRoot = null;
        let activeAdapter = null;
        let closeTimer = null;
        let openFrame = null;

        function normalizedPath(path) {
            const next = String(path || '/').replace(/\/+$/, '');
            return next || '/';
        }

        function scopeFor(rawHref) {
            const raw = String(rawHref || '').trim();

            if (!raw || raw.startsWith('#') || raw.startsWith('?')) {
                return 'same-page';
            }

            let url;

            try {
                url = new URL(raw, window.location.href);
            } catch {
                return 'same-site';
            }

            const protocol = url.protocol.toLowerCase();

            if (
                protocol === 'mailto:' ||
                protocol === 'tel:' ||
                (protocol !== 'http:' && protocol !== 'https:')
            ) {
                return 'external';
            }

            if (url.origin !== window.location.origin) {
                return 'external';
            }

            return normalizedPath(url.pathname) === normalizedPath(window.location.pathname)
                ? 'same-page'
                : 'same-site';
        }

        function syncHoverRoot(root) {
            if (!root) return;

            const link = root.querySelector('.wc-hover-preview__link');

            if (!link) return;

            root.setAttribute(
                'data-hover-preview-scope',
                scopeFor(link.getAttribute('href'))
            );
        }

        function clamp(value, min, max) {
            if (max < min) return min;
            return Math.min(Math.max(value, min), max);
        }

        function viewportBox() {
            const visual = window.visualViewport;

            if (visual) {
                return {
                    left: visual.offsetLeft,
                    top: visual.offsetTop,
                    width: visual.width,
                    height: visual.height
                };
            }

            return {
                left: 0,
                top: 0,
                width: document.documentElement.clientWidth || window.innerWidth,
                height: window.innerHeight
            };
        }

        function isSheetMode() {
            return window.matchMedia?.(sheetQuery).matches ?? false;
        }

        function adapterForRoot(root) {
            if (!root) return null;

            return adapters.find(adapter => {
                return root.matches?.(adapter.rootSelector);
            }) || null;
        }

        function rootFromEvent(event) {
            return event.target?.closest?.(rootSelector) || null;
        }

        function triggerFor(root, adapter) {
            return root?.querySelector?.(adapter.triggerSelector) || root;
        }

        function cardFor(root, adapter) {
            return root?.querySelector?.(adapter.cardSelector) || null;
        }

        function syncRoot(root, adapter) {
            if (!root || !adapter?.sync) return;
            adapter.sync(root);
        }

        function setExpanded(root, expanded) {
            const adapter = adapterForRoot(root);
            if (!adapter) return;

            const trigger = triggerFor(root, adapter);
            if (!trigger) return;

            trigger.setAttribute('aria-expanded', expanded ? 'true' : 'false');
        }

        function position(root) {
            const adapter = adapterForRoot(root);

            if (!root || !adapter) return;

            syncRoot(root, adapter);

            const trigger = triggerFor(root, adapter);
            const card = cardFor(root, adapter);

            if (!trigger || !card) return;

            if (isSheetMode()) {
                root.setAttribute('data-preview-placement', 'sheet');
                return;
            }

            const triggerRect = trigger.getBoundingClientRect();
            const cardRect = card.getBoundingClientRect();
            const viewport = viewportBox();

            const cardWidth = Math.min(
                Math.max(cardRect.width || 1, 1),
                Math.max(viewport.width - margin * 2, 1)
            );

            const cardHeight = Math.min(
                Math.max(cardRect.height || 1, 1),
                Math.max(viewport.height - margin * 2, 1)
            );

            const idealCenterX = triggerRect.left + triggerRect.width / 2;
            const minCenterX = viewport.left + margin + cardWidth / 2;
            const maxCenterX = viewport.left + viewport.width - margin - cardWidth / 2;
            const centerX = clamp(idealCenterX, minCenterX, maxCenterX);

            const topLimit = viewport.top + margin;
            const bottomLimit = viewport.top + viewport.height - margin;
            const spaceAbove = triggerRect.top - topLimit - gap;
            const spaceBelow = bottomLimit - triggerRect.bottom - gap;

            const placement = spaceAbove < cardHeight && spaceBelow > spaceAbove
                ? 'below'
                : 'above';

            const rawTop = placement === 'above'
                ? triggerRect.top - gap - cardHeight
                : triggerRect.bottom + gap;

            const top = clamp(rawTop, topLimit, bottomLimit - cardHeight);
            const cardLeft = centerX - cardWidth / 2;
            const arrowLeft = clamp(idealCenterX - cardLeft, 18, cardWidth - 18);

            root.style.setProperty('--wc-preview-left', `${centerX}px`);
            root.style.setProperty('--wc-preview-top', `${top}px`);
            root.style.setProperty('--wc-preview-arrow-left', `${arrowLeft}px`);
            root.setAttribute('data-preview-placement', placement);
        }

        function cancelClose() {
            if (!closeTimer) return;

            window.clearTimeout(closeTimer);
            closeTimer = null;
        }

        function cancelOpenFrame() {
            if (!openFrame) return;

            window.cancelAnimationFrame(openFrame);
            openFrame = null;
        }

        function markOpen(root) {
            if (!root) return;

            root.setAttribute('data-wc-preview-open', 'true');
            root.setAttribute('data-preview-state', 'open');
            setExpanded(root, true);
        }

        function clearStateLater(root) {
            window.setTimeout(() => {
                if (
                    root &&
                    !root.hasAttribute('data-wc-preview-open') &&
                    root.getAttribute('data-preview-state') === 'closing'
                ) {
                    root.removeAttribute('data-preview-state');
                    root.removeAttribute('data-preview-close-reason');
                }
            }, stateClearDelay);
        }

        function close(
            root = activeRoot,
            options = {}
        ) {
            if (!root) return;

            const reason = options.reason || 'leave';

            cancelClose();

            if (root === activeRoot) {
                activeRoot = null;
                activeAdapter = null;
            }

            root.setAttribute('data-preview-state', 'closing');
            root.setAttribute('data-preview-close-reason', reason);
            root.removeAttribute('data-wc-preview-open');

            setExpanded(root, false);
            clearStateLater(root);
        }

        function closeActive(
            options = {}
        ) {
            close(
                activeRoot,
                options
            );
        }

        function closeOthers(nextRoot) {
            if (activeRoot && activeRoot !== nextRoot) {
                close(
                    activeRoot,
                    {
                        reason: 'superseded'
                    }
                );
            }

            document.querySelectorAll('[data-wc-preview-open="true"]').forEach(root => {
                if (root !== nextRoot) {
                    close(
                        root,
                        {
                            reason: 'superseded'
                        }
                    );
                }
            });
        }

        function open(root) {
            const adapter = adapterForRoot(root);

            if (!root || !adapter) return;

            cancelClose();
            closeOthers(root);

            activeRoot = root;
            activeAdapter = adapter;

            position(root);

            root.removeAttribute('data-preview-close-reason');
            root.setAttribute('data-preview-state', 'opening');

            cancelOpenFrame();

            openFrame = window.requestAnimationFrame(() => {
                if (activeRoot === root) {
                    markOpen(root);
                }
            });
        }

        function shouldRemainOpen(root) {
            if (!root) return false;

            return root.matches(':hover') || root.contains(document.activeElement);
        }

        function scheduleClose(root) {
            if (!root) return;

            cancelClose();

            closeTimer = window.setTimeout(() => {
                if (!shouldRemainOpen(root)) {
                    close(
                        root,
                        {
                            reason: 'leave'
                        }
                    );
                }
            }, closeDelay);
        }

        function updateActive() {
            if (!activeRoot) return;

            if (!document.documentElement.contains(activeRoot)) {
                closeActive(
                    {
                        reason: 'detached'
                    }
                );

                return;
            }

            position(activeRoot);
        }

        function init(scope = document) {
            const roots = scope.matches?.(rootSelector)
                ? [scope]
                : Array.from(scope.querySelectorAll?.(rootSelector) || []);

            roots.forEach(root => {
                const adapter = adapterForRoot(root);

                if (!adapter) return;

                syncRoot(root, adapter);
                setExpanded(root, false);

                if (!root.hasAttribute('data-wc-preview-open')) {
                    root.removeAttribute('data-preview-state');
                    root.removeAttribute('data-preview-close-reason');
                }
            });
        }

        document.addEventListener(
            'mouseover',
            event => {
                const root = rootFromEvent(event);

                if (!root) return;

                const related = event.relatedTarget;

                if (related && root.contains(related)) {
                    return;
                }

                open(root);
            },
            true
        );

        document.addEventListener(
            'mouseout',
            event => {
                const root = rootFromEvent(event);

                if (!root) return;

                const related = event.relatedTarget;

                if (related && root.contains(related)) {
                    return;
                }

                scheduleClose(root);
            },
            true
        );

        document.addEventListener(
            'focusin',
            event => {
                const root = rootFromEvent(event);

                if (root) {
                    open(root);
                }
            },
            true
        );

        document.addEventListener(
            'focusout',
            event => {
                const root = rootFromEvent(event);

                if (!root) return;

                window.requestAnimationFrame(() => {
                    if (!root.contains(document.activeElement)) {
                        scheduleClose(root);
                    }
                });
            },
            true
        );

        document.addEventListener(
            'touchstart',
            event => {
                const root = rootFromEvent(event);

                if (root) {
                    open(root);
                } else if (activeRoot) {
                    closeActive(
                        {
                            reason: 'outside'
                        }
                    );
                }
            },
            {
                capture: true,
                passive: true
            }
        );

        document.addEventListener(
            'pointerdown',
            event => {
                if (!activeRoot) return;

                if (!activeRoot.contains(event.target)) {
                    closeActive(
                        {
                            reason: 'outside'
                        }
                    );
                }
            },
            true
        );

        document.addEventListener(
            'keydown',
            event => {
                if (event.key === 'Escape' && activeRoot) {
                    const root = activeRoot;
                    const adapter = activeAdapter || adapterForRoot(root);
                    const trigger = root && adapter
                        ? triggerFor(root, adapter)
                        : null;

                    close(
                        root,
                        {
                            reason: 'escape'
                        }
                    );

                    if (trigger && typeof trigger.focus === 'function') {
                        trigger.focus(
                            {
                                preventScroll: true
                            }
                        );
                    }
                }
            },
            true
        );

        window.addEventListener('resize', updateActive, { passive: true });
        window.addEventListener('scroll', updateActive, true);

        if (window.visualViewport) {
            window.visualViewport.addEventListener('resize', updateActive, { passive: true });
            window.visualViewport.addEventListener('scroll', updateActive, { passive: true });
        }

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => init());
        } else {
            init();
        }

        window.addEventListener('popstate', () => init());

        const api = {
            initialized: true,
            init,
            position,
            open,
            close,
            closeActive,
            updateActive
        };

        window.wcPreviewCoordinator = api;
        window.wcReferencePreviewLink = api;
        window.wcHoverPreviewLink = api;
        window.wcHoverPreviewLinkScope = api;
    })();
    """#
}
