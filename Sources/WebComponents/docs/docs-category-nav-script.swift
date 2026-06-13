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
        const trackSelector = '.wc-docs-category-nav__track, .docs-category-nav__track';
        const activeSelector = '.wc-docs-category-nav__link[aria-current="page"], .docs-category-nav__link[aria-current="page"]';
        const linkSelector = '.wc-docs-category-nav__link, .docs-category-nav__link';

        function clamp(value, min, max) {
            return Math.max(min, Math.min(max, value));
        }

        function scrollerFor(root) {
            return root?.querySelector?.(scrollerSelector) || null;
        }

        function activeFor(root) {
            return root?.querySelector?.(activeSelector) || null;
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

        function centerError(scroller, item) {
            const scrollerRect = scroller.getBoundingClientRect();
            const itemRect = item.getBoundingClientRect();

            const scrollerCenter = scrollerRect.left + (scrollerRect.width / 2);
            const itemCenter = itemRect.left + (itemRect.width / 2);

            return itemCenter - scrollerCenter;
        }

        function centerItem(root, item, behavior = 'auto') {
            if (!root || !item) return false;

            const scroller = scrollerFor(root);
            if (!scroller) return false;

            const max = maxScrollLeft(scroller);
            if (max <= 0) return false;

            scroller.scrollTo({
                left: targetScrollLeft(scroller, item),
                behavior
            });

            return true;
        }

        function centerActive(root, behavior = 'auto') {
            const active = activeFor(root);
            return centerItem(root, active, behavior);
        }

        function centerAll(behavior = 'auto') {
            document.querySelectorAll(rootSelector).forEach((root) => {
                centerActive(root, behavior);
            });
        }

        function settleRoot(root, attempts = 10) {
            let count = 0;

            const tick = () => {
                const scroller = scrollerFor(root);
                const active = activeFor(root);

                if (!scroller || !active) return;

                centerItem(root, active, 'auto');

                count += 1;

                const max = maxScrollLeft(scroller);
                const atStart = scroller.scrollLeft <= 1;
                const atEnd = scroller.scrollLeft >= max - 1;
                const cannotCenter = atStart || atEnd;
                const stillOff = Math.abs(centerError(scroller, active)) > 8;

                if (count < attempts && stillOff && !cannotCenter) {
                    window.requestAnimationFrame(tick);
                }
            };

            window.requestAnimationFrame(tick);
        }

        function settleAll() {
            document.querySelectorAll(rootSelector).forEach((root) => {
                settleRoot(root);
            });
        }

        function schedule(delay = 0) {
            const run = () => {
                window.requestAnimationFrame(settleAll);
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

            const recenter = () => {
                window.clearTimeout(resizeTimer);
                resizeTimer = window.setTimeout(() => {
                    schedule();
                }, 80);
            };

            window.addEventListener('resize', recenter, { passive: true });
            window.visualViewport?.addEventListener?.('resize', recenter, { passive: true });
            window.visualViewport?.addEventListener?.('scroll', recenter, { passive: true });
        }

        function bindLayoutObservers() {
            if (!('ResizeObserver' in window)) return;

            const observer = new ResizeObserver(() => {
                schedule();
            });

            document.querySelectorAll(rootSelector).forEach((root) => {
                const scroller = scrollerFor(root);
                const track = root.querySelector(trackSelector);

                if (scroller) observer.observe(scroller);
                if (track) observer.observe(track);
            });
        }

        function init() {
            bindFocusCentering();
            bindResizeCentering();
            bindLayoutObservers();

            schedule();
            schedule(80);
            schedule(180);
            schedule(360);
            schedule(700);

            if (document.readyState !== 'complete') {
                window.addEventListener(
                    'load',
                    () => schedule(),
                    { once: true }
                );
            }

            window.addEventListener('pageshow', () => {
                schedule();
                schedule(120);
                schedule(420);
            });

            document.fonts?.ready
                ?.then(() => schedule())
                ?.catch(() => {});
        }

        window.wcDocsCategoryNav = {
            initialized: true,
            init,
            center: centerAll,
            settle: settleAll
        };

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init, { once: true });
        } else {
            init();
        }
    })();
    """#
}
