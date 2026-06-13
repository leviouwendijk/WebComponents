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

        const rootSelector = '.docs-category-nav, .wc-docs-category-nav';
        const scrollerSelector = '.docs-category-nav__inner, .wc-docs-category-nav__inner';
        const activeSelector = '.docs-category-nav__link[aria-current="page"], .wc-docs-category-nav__link[aria-current="page"]';
        const linkSelector = '.docs-category-nav__link, .wc-docs-category-nav__link';

        function clamp(value, min, max) {
            return Math.max(min, Math.min(max, value));
        }

        function maxScrollLeft(scroller) {
            return Math.max(0, scroller.scrollWidth - scroller.clientWidth);
        }

        function targetScrollLeft(scroller, item) {
            const scrollerRect = scroller.getBoundingClientRect();
            const itemRect = item.getBoundingClientRect();

            const itemLeft = itemRect.left - scrollerRect.left + scroller.scrollLeft;
            const centered = itemLeft - ((scroller.clientWidth - itemRect.width) / 2);

            return clamp(
                centered,
                0,
                maxScrollLeft(scroller)
            );
        }

        function centerItem(item, behavior = 'auto') {
            if (!item) return false;

            const root = item.closest(rootSelector);
            const scroller = root?.querySelector?.(scrollerSelector);

            if (!root || !scroller) return false;
            if (maxScrollLeft(scroller) <= 0) return false;

            scroller.scrollTo({
                left: targetScrollLeft(scroller, item),
                behavior
            });

            return true;
        }

        function centerActive(behavior = 'auto') {
            document.querySelectorAll(rootSelector).forEach((root) => {
                centerItem(root.querySelector(activeSelector), behavior);
            });
        }

        function settleActive() {
            let count = 0;

            const tick = () => {
                centerActive('auto');
                count += 1;

                if (count < 14) {
                    window.setTimeout(() => {
                        window.requestAnimationFrame(tick);
                    }, count < 4 ? 32 : 90);
                }
            };

            window.requestAnimationFrame(tick);
        }

        function bindClicks() {
            document.addEventListener(
                'click',
                (event) => {
                    const link = event.target?.closest?.(linkSelector);
                    if (!link) return;

                    centerItem(link, 'smooth');
                },
                true
            );
        }

        function bindFocus() {
            document.addEventListener(
                'focusin',
                (event) => {
                    const link = event.target?.closest?.(linkSelector);
                    if (!link) return;

                    centerItem(link, 'smooth');
                },
                true
            );
        }

        function bindViewportChanges() {
            let timer = 0;

            const schedule = () => {
                window.clearTimeout(timer);
                timer = window.setTimeout(settleActive, 80);
            };

            window.addEventListener('resize', schedule, { passive: true });
            window.visualViewport?.addEventListener?.('resize', schedule, { passive: true });
            window.visualViewport?.addEventListener?.('scroll', schedule, { passive: true });
        }

        function init() {
            bindClicks();
            bindFocus();
            bindViewportChanges();

            settleActive();

            window.addEventListener('load', settleActive, { once: true });
            window.addEventListener('pageshow', settleActive);

            document.fonts?.ready
                ?.then(settleActive)
                ?.catch(() => {});
        }

        window.wcDocsCategoryNav = {
            initialized: true,
            init,
            center: centerActive,
            settle: settleActive
        };

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init, { once: true });
        } else {
            init();
        }
    })();
    """#
}
