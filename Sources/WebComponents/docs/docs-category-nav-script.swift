import Constructors
import JS

public struct DocsCategoryNavScript: ReusableComponent {
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
        if (window.wcDocsCategoryNav?.initialized) return;

        const rootSelector = '.wc-docs-category-nav, .docs-category-nav';
        const scrollerSelector = '.wc-docs-category-nav__inner, .docs-category-nav__inner';
        const activeSelector = '.wc-docs-category-nav__link[aria-current="page"], .docs-category-nav__link[aria-current="page"]';
        const linkSelector = '.wc-docs-category-nav__link, .docs-category-nav__link';

        function clamp(value, min, max) {
            return Math.max(min, Math.min(max, value));
        }

        function targetScrollLeft(scroller, item) {
            const scrollerRect = scroller.getBoundingClientRect();
            const itemRect = item.getBoundingClientRect();

            const itemLeft = itemRect.left - scrollerRect.left + scroller.scrollLeft;
            const centered = itemLeft - ((scroller.clientWidth - itemRect.width) / 2);

            return clamp(
                centered,
                0,
                Math.max(0, scroller.scrollWidth - scroller.clientWidth)
            );
        }

        function centerItem(root, item, behavior = 'auto') {
            if (!root || !item) return;

            const scroller = root.querySelector(scrollerSelector);
            if (!scroller) return;

            if (scroller.scrollWidth <= scroller.clientWidth) return;

            scroller.scrollTo({
                left: targetScrollLeft(scroller, item),
                behavior
            });
        }

        function centerActive(root, behavior = 'auto') {
            if (!root) return;

            const active = root.querySelector(activeSelector);
            centerItem(root, active, behavior);
        }

        function centerAll(behavior = 'auto') {
            document.querySelectorAll(rootSelector).forEach((root) => {
                centerActive(root, behavior);
            });
        }

        function schedule(behavior = 'auto', delay = 0) {
            const run = () => {
                window.requestAnimationFrame(() => {
                    centerAll(behavior);
                });
            };

            if (delay > 0) {
                window.setTimeout(run, delay);
            } else {
                run();
            }
        }

        function bindFocusCentering() {
            document.addEventListener(
                'focusin',
                (event) => {
                    const link = event.target?.closest?.(linkSelector);
                    if (!link) return;

                    const root = link.closest(rootSelector);
                    centerItem(root, link, 'smooth');
                },
                true
            );
        }

        function bindResizeCentering() {
            let resizeTimer = 0;

            window.addEventListener(
                'resize',
                () => {
                    window.clearTimeout(resizeTimer);
                    resizeTimer = window.setTimeout(() => {
                        schedule('auto');
                    }, 90);
                },
                { passive: true }
            );
        }

        function init() {
            bindFocusCentering();
            bindResizeCentering();

            schedule('auto');
            schedule('auto', 120);

            if (document.readyState !== 'complete') {
                window.addEventListener(
                    'load',
                    () => schedule('auto'),
                    { once: true }
                );
            }

            window.addEventListener('pageshow', () => {
                schedule('auto');
            });

            document.fonts?.ready
                ?.then(() => schedule('auto'))
                ?.catch(() => {});
        }

        window.wcDocsCategoryNav = {
            initialized: true,
            init,
            center: centerAll
        };

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init, { once: true });
        } else {
            init();
        }
    })();
    """#
}
