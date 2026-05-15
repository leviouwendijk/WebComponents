import Constructors
import JS

public struct DocsMobileTOCMenuScript: ReusableComponent {
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
        if (window.docsMobileTOC?.initialized) return;

        const mobileQuery = '(max-width: 1200px)';
        const storagePrefix = 'docs-mobile-menu:v1:';

        function isMobile() {
            return window.matchMedia(mobileQuery).matches;
        }

        function buttons() {
            return Array.from(
                document.querySelectorAll('[data-docs-mobile-menu-button], #menu-btn')
            );
        }

        function targetFor(button) {
            const id = button?.getAttribute('aria-controls');

            if (id) {
                const explicit = document.getElementById(id);

                if (explicit) {
                    return explicit;
                }
            }

            return document.getElementById('toc');
        }

        function buttonForTarget(target) {
            if (!target?.id) return null;

            return document.querySelector(
                `[data-docs-mobile-menu-button][aria-controls="${target.id}"], #menu-btn[aria-controls="${target.id}"]`
            );
        }

        function targets() {
            const explicit = Array.from(
                document.querySelectorAll('[data-docs-mobile-menu-target]')
            );

            const toc = document.getElementById('toc');

            if (toc && !explicit.includes(toc)) {
                explicit.push(toc);
            }

            return explicit;
        }

        function stateKey(target) {
            const id = target?.id || 'drawer';
            const path = window.location.pathname || '/';

            return `${storagePrefix}${path}#${id}`;
        }

        function readStoredState(target) {
            try {
                const value = localStorage.getItem(stateKey(target));

                if (value === 'open') return true;
                if (value === 'closed') return false;
            } catch (_) {}

            return null;
        }

        function writeStoredState(target, isOpen) {
            if (!target || !isMobile()) return;

            try {
                localStorage.setItem(
                    stateKey(target),
                    isOpen ? 'open' : 'closed'
                );
            } catch (_) {}
        }

        function shouldOpenOnDesktop(target) {
            if (!target) return false;

            if (target.dataset.docsMobileMenuDesktopOpen === 'true') {
                return true;
            }

            return target.id === 'toc';
        }

        function defaultMobileOpen(target) {
            if (!target) return false;

            return target.dataset.docsMobileMenuMobileDefaultOpen === 'true';
        }

        function preferredMobileOpen(target) {
            const stored = readStoredState(target);

            if (stored !== null) {
                return stored;
            }

            return defaultMobileOpen(target);
        }

        function setOpen(target, isOpen, options = {}) {
            if (!target) return;

            const open = Boolean(isOpen);

            target.classList.toggle('open', open);
            target.classList.toggle('is-open', open);
            target.setAttribute('aria-hidden', open ? 'false' : 'true');

            const button = buttonForTarget(target);

            if (button) {
                button.classList.toggle('open', open && isMobile());
                button.setAttribute('aria-expanded', open && isMobile() ? 'true' : 'false');
            }

            if (options.persist !== false) {
                writeStoredState(target, open);
            }
        }

        function closeTarget(target) {
            setOpen(target, false);
        }

        function closeAll() {
            for (const target of targets()) {
                if (!isMobile() && shouldOpenOnDesktop(target)) {
                    setOpen(target, true, { persist: false });
                } else {
                    setOpen(target, false);
                }
            }
        }

        function syncButtons() {
            for (const button of buttons()) {
                const target = targetFor(button);
                const hasTarget = Boolean(target);
                const shouldShow = hasTarget && isMobile();

                button.toggleAttribute('hidden', !shouldShow);
                button.setAttribute('aria-hidden', shouldShow ? 'false' : 'true');

                if (!shouldShow) {
                    button.classList.remove('open');
                    button.setAttribute('aria-expanded', 'false');
                }
            }
        }

        function sync() {
            syncButtons();

            for (const target of targets()) {
                if (isMobile()) {
                    setOpen(
                        target,
                        preferredMobileOpen(target),
                        { persist: false }
                    );
                } else if (shouldOpenOnDesktop(target)) {
                    setOpen(target, true, { persist: false });
                } else {
                    setOpen(target, false, { persist: false });
                }
            }
        }

        function toggleFromButton(button) {
            const target = targetFor(button);

            if (!target) return;

            setOpen(
                target,
                !target.classList.contains('open')
            );
        }

        function bind() {
            document.addEventListener('click', (event) => {
                const button = event.target.closest?.('[data-docs-mobile-menu-button], #menu-btn');

                if (button) {
                    event.preventDefault();
                    toggleFromButton(button);
                    return;
                }

                const targetLink = event.target.closest?.('[data-docs-mobile-menu-target] a, #toc a');

                if (targetLink && isMobile()) {
                    const target = targetLink.closest?.('[data-docs-mobile-menu-target], #toc');
                    closeTarget(target);
                }
            }, true);

            document.addEventListener('keydown', (event) => {
                if (event.key === 'Escape') {
                    closeAll();
                }
            });

            window.addEventListener('resize', sync);
        }

        function init() {
            bind();
            sync();
        }

        window.docsMobileTOC = {
            initialized: true,
            init,
            sync,
            close: closeAll,
            toggle() {
                const first = buttons()[0];

                if (first) {
                    toggleFromButton(first);
                }
            }
        };

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init);
        } else {
            init();
        }
    })();
    """#
}
