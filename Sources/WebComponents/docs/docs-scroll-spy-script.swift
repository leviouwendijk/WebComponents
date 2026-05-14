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

        function idFromHref(value) {
            if (!value) return null;

            const raw = String(value);
            const idx = raw.indexOf('#');

            if (idx < 0) return null;

            const id = raw.slice(idx + 1);

            if (!id) return null;

            try {
                return decodeURIComponent(id);
            } catch {
                return id;
            }
        }

        function collectLinkMap() {
            const map = new Map();

            document
                .querySelectorAll('#toc a[href*="#"], #toc a[data-docs-spy-link]')
                .forEach((link) => {
                    const candidates = [
                        link.getAttribute('href'),
                        link.getAttribute('data-docs-spy-link')
                    ];

                    for (const candidate of candidates) {
                        const id = idFromHref(candidate);

                        if (!id) continue;

                        if (!map.has(id)) {
                            map.set(id, []);
                        }

                        map.get(id).push(link);
                    }
                });

            return map;
        }

        function collectTargets(linkMap) {
            return Array
                .from(linkMap.keys())
                .map((id) => document.getElementById(id))
                .filter(Boolean);
        }

        function setActive(id) {
            if (!id) return;

            const linkMap = collectLinkMap();

            document
                .querySelectorAll('#toc a[href*="#"], #toc a[data-docs-spy-link]')
                .forEach((link) => {
                    link.classList.remove('selected-item');
                    link.removeAttribute('aria-current');
                });

            const links = linkMap.get(id) || [];

            links.forEach((link) => {
                link.classList.add('selected-item');
                link.setAttribute('aria-current', 'location');

                const parent = link.closest('li');
                if (parent) {
                    parent.classList.add('expanded');
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
                const link = event.target.closest?.('#toc a[href*="#"], a[data-docs-scroll-link]');

                if (!link) return;

                const id = idFromHref(link.getAttribute('href'));

                if (!id) return;

                const target = document.getElementById(id);

                if (!target) return;

                event.preventDefault();
                scrollToID(id, true);
            }, true);
        }

        function observe() {
            const linkMap = collectLinkMap();
            const targets = collectTargets(linkMap);

            if (!targets.length) return;

            const initialID = idFromHref(window.location.hash);

            if (initialID && linkMap.has(initialID)) {
                requestAnimationFrame(() => {
                    scrollToID(initialID, false);
                });
            } else {
                setActive(targets[0].id);
            }

            if (!('IntersectionObserver' in window)) {
                return;
            }

            let latestID = null;

            const observer = new IntersectionObserver((entries) => {
                const visible = entries
                    .filter((entry) => entry.isIntersecting)
                    .sort((a, b) => {
                        return Math.abs(a.boundingClientRect.top) - Math.abs(b.boundingClientRect.top);
                    });

                if (!visible.length) return;

                const id = visible[0].target.id;

                if (!id || id === latestID) return;

                latestID = id;
                setActive(id);
            }, {
                root: null,
                threshold: [0.01, 0.12, 0.28, 0.5],
                rootMargin: '-18% 0px -68% 0px'
            });

            targets.forEach((target) => {
                observer.observe(target);
            });
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
