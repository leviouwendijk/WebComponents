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

        function shouldOpenOnDesktop(target) {
            if (!target) return false;

            if (target.dataset.docsMobileMenuDesktopOpen === 'true') {
                return true;
            }

            return target.id === 'toc';
        }

        function setOpen(target, isOpen) {
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
        }

        function closeTarget(target) {
            setOpen(target, false);
        }

        function closeAll() {
            for (const target of targets()) {
                if (!isMobile() && shouldOpenOnDesktop(target)) {
                    setOpen(target, true);
                } else {
                    setOpen(target, false);
                }
            }
        }

        function syncButtons() {
            for (const button of buttons()) {
                const target = targetFor(button);
                const hasTarget = Boolean(target);

                button.toggleAttribute('hidden', !hasTarget);
                button.setAttribute('aria-hidden', hasTarget ? 'false' : 'true');

                if (!hasTarget) {
                    button.classList.remove('open');
                    button.setAttribute('aria-expanded', 'false');
                }
            }
        }

        function sync() {
            syncButtons();

            for (const target of targets()) {
                if (!isMobile() && shouldOpenOnDesktop(target)) {
                    setOpen(target, true);
                } else if (!isMobile()) {
                    setOpen(target, false);
                } else if (!target.classList.contains('open')) {
                    setOpen(target, false);
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
