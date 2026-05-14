import Constructors
import JS

public struct DocsScrollSpyScript: ReusableComponent {
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
        if (window.wcDocsScrollSpy?.initialized) return;

        function hashFromHref(href) {
            if (!href) return null;
            const idx = href.indexOf('#');
            if (idx < 0) return null;
            const hash = href.slice(idx + 1);
            return hash ? decodeURIComponent(hash) : null;
        }

        function setActive(id) {
            if (!id) return;

            document
                .querySelectorAll('#toc a[data-docs-spy-link], #toc a[href^="#"]')
                .forEach((link) => {
                    const linkID = hashFromHref(link.getAttribute('href'));

                    if (linkID === id) {
                        link.classList.add('selected-item');
                        link.setAttribute('aria-current', 'location');
                    } else {
                        link.classList.remove('selected-item');
                        link.removeAttribute('aria-current');
                    }
                });
        }

        function scrollToID(id, updateHash) {
            const target = document.getElementById(id);
            if (!target) return false;

            target.scrollIntoView({
                block: 'start',
                behavior: 'smooth'
            });

            setActive(id);

            if (updateHash) {
                history.replaceState(null, '', '#' + encodeURIComponent(id));
            }

            return true;
        }

        function bindClicks() {
            document.addEventListener('click', (event) => {
                const link = event.target.closest('#toc a[href*="#"], a[data-docs-scroll-link]');
                if (!link) return;

                const id = hashFromHref(link.getAttribute('href'));
                if (!id) return;

                const target = document.getElementById(id);
                if (!target) return;

                event.preventDefault();
                scrollToID(id, true);
            }, true);
        }

        function observe() {
            const content = document.getElementById('content-area');
            const sections = Array.from(
                document.querySelectorAll('[data-docs-section][id]')
            );

            if (!sections.length) return;

            if (!('IntersectionObserver' in window)) {
                const current = hashFromHref(window.location.hash) || sections[0].id;
                setActive(current);
                return;
            }

            const observer = new IntersectionObserver((entries) => {
                const visible = entries
                    .filter((entry) => entry.isIntersecting)
                    .sort((a, b) => {
                        return a.boundingClientRect.top - b.boundingClientRect.top;
                    });

                if (!visible.length) return;

                const id = visible[0].target.id;
                setActive(id);
            }, {
                root: content || null,
                threshold: [0.01, 0.15, 0.35],
                rootMargin: '-12% 0px -70% 0px'
            });

            sections.forEach((section) => observer.observe(section));

            const initialID = hashFromHref(window.location.hash);
            if (initialID) {
                requestAnimationFrame(() => {
                    scrollToID(initialID, false);
                });
            } else {
                setActive(sections[0].id);
            }
        }

        function init() {
            bindClicks();
            observe();
        }

        window.wcDocsScrollSpy = {
            initialized: true,
            init,
            setActive,
            scrollToID
        };

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init);
        } else {
            init();
        }
    })();
    """#
}
