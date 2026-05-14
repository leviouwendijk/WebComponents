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

        function getEls() {
            return {
                toc: document.getElementById('toc'),
                menuBtn: document.getElementById('menu-btn')
            };
        }

        function setOpen(isOpen) {
            const { toc, menuBtn } = getEls();
            if (!toc) return;

            toc.classList.toggle('open', isOpen);

            if (menuBtn) {
                menuBtn.classList.toggle('open', isOpen && isMobile());
                menuBtn.setAttribute('aria-expanded', isOpen && isMobile() ? 'true' : 'false');
            }
        }

        function sync() {
            setOpen(!isMobile());
        }

        function close() {
            setOpen(false);
        }

        function toggle() {
            const { toc } = getEls();
            if (!toc) return;

            setOpen(!toc.classList.contains('open'));
        }

        function bind() {
            document.addEventListener('click', (event) => {
                const menuButton = event.target.closest?.('#menu-btn');
                if (menuButton) {
                    event.preventDefault();
                    toggle();
                    return;
                }

                const tocLink = event.target.closest?.('#toc a');
                if (tocLink && isMobile()) {
                    close();
                }
            }, true);

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
            close,
            toggle
        };

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init);
        } else {
            init();
        }
    })();
    """#
}
