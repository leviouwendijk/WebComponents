import Constructors
import CSS
import HTML
import JS

public struct HoverPreviewLink: SelectableComponent {
    public enum DestinationScope: String, Sendable {
        case samePage = "same-page"
        case sameSite = "same-site"
        case external
    }
    
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-hover-preview"

    public let href: String
    public let label: HTMLFragment
    public let preview: HoverPreview
    public let destinationScope: DestinationScope
    public let zIndex: Int

    public init(
        href: String,
        label: HTMLFragment,
        preview: HoverPreview,
        destinationScope: DestinationScope? = nil,
        zIndex: Int = 1000
    ) {
        self.href = href
        self.label = label
        self.preview = preview
        self.destinationScope = destinationScope ?? Self.inferredDestinationScope(
            for: href
        )
        self.zIndex = zIndex
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.span([
                    "class": Self.block,
                    "data-hover-preview": "",
                    "data-hover-preview-variant": preview.variant.rawValue,
                    "data-hover-preview-scope": destinationScope.rawValue
                ]) {
                    HTML.a(href, ["class": "\(Self.block)__link"]) {
                        label
                    }

                    HTML.span(["class": "\(Self.block)__card"]) {
                        media_nodes()

                        HTML.span(["class": "\(Self.block)__meta"]) {
                            if let eyebrow = preview.eyebrow {
                                HTML.span(["class": "\(Self.block)__eyebrow"]) {
                                    HTML.text(eyebrow)
                                }
                            }

                            HTML.a(
                                href,
                                [
                                    "class": "\(Self.block)__title",
                                    "target": "_blank",
                                    "rel": "noopener noreferrer"
                                ]
                            ) {
                                HTML.text(preview.title)
                            }

                            HTML.span(["class": "\(Self.block)__summary"]) {
                                preview.summary()
                            }

                            if !preview.tags.isEmpty {
                                HTML.span(["class": "\(Self.block)__tags"]) {
                                    for tag in preview.tags {
                                        HTML.span(["class": "\(Self.block)__tag"]) {
                                            HTML.text(tag)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            ],
            stylesheets: [Self.stylesheet(zIndex: zIndex)]
        )
    }

    private func media_nodes() -> HTMLFragment {
        switch preview.media {
        case .none:
            return []

        case let .image(src, alt):
            return [
                HTML.img(
                    src: src,
                    alt: alt,
                    ["class": "\(Self.block)__media \(Self.block)__media--image"]
                )
            ]

        case let .glyph(value):
            return [
                HTML.span(["class": "\(Self.block)__media \(Self.block)__media--glyph"]) {
                    HTML.text(value)
                }
            ]

        case let .custom(nodes):
            return [
                HTML.span(["class": "\(Self.block)__media \(Self.block)__media--custom"]) {
                    nodes()
                }
            ]
        }
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    private static func inferredDestinationScope(
        for href: String
    ) -> DestinationScope {
        let trimmed = href.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmed.isEmpty else {
            return .samePage
        }

        if trimmed.hasPrefix("#") || trimmed.hasPrefix("?") {
            return .samePage
        }

        if trimmed.hasPrefix("/") && !trimmed.hasPrefix("//") {
            return .sameSite
        }

        let lowercased = trimmed.lowercased()

        if lowercased.hasPrefix("//")
            || lowercased.hasPrefix("http://")
            || lowercased.hasPrefix("https://")
            || lowercased.hasPrefix("mailto:")
            || lowercased.hasPrefix("tel:")
            || lowercased.contains("://") {
            return .external
        }

        return .sameSite
    }

    public static func css() -> CSSStyleSheet {
        stylesheet()
    }

    public static func stylesheet(
        zIndex: Int = 1000
    ) -> CSSStyleSheet {
        let root = ".\(Self.block)"
        let link = ".\(Self.block)__link"
        let card = ".\(Self.block)__card"
        let media = ".\(Self.block)__media"
        let image = ".\(Self.block)__media--image"
        let glyph = ".\(Self.block)__media--glyph"
        let custom = ".\(Self.block)__media--custom"
        let meta = ".\(Self.block)__meta"
        let eyebrow = ".\(Self.block)__eyebrow"
        let title = ".\(Self.block)__title"
        let summary = ".\(Self.block)__summary"
        let tags = ".\(Self.block)__tags"
        let tag = ".\(Self.block)__tag"

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    root,
                    CSS.decl("position", "relative"),
                    CSS.decl("z-index", "0"),
                    CSS.decl("display", "inline"),
                    CSS.decl("vertical-align", "baseline"),
                    CSS.decl("isolation", "isolate"),
                    CSS.decl("--wc-hover-preview-z", "\(zIndex)"),
                    CSS.decl("--wc-hover-preview-surface", "var(--surface-color, #fff)"),
                    CSS.decl("--wc-hover-preview-soft", "var(--surface-soft-color, #f1f5f9)"),
                    CSS.decl("--wc-hover-preview-border", "var(--border-color, rgba(15, 23, 42, .12))"),
                    CSS.decl("--wc-hover-preview-ink", "var(--text-color, #202124)"),
                    // CSS.decl("--wc-hover-preview-muted", "var(--muted-text-color, rgba(32, 33, 36, .66))"),
                    // CSS.decl("--wc-hover-preview-accent", "var(--link-color, #2563eb)")
                    CSS.decl("--wc-hover-preview-muted", "var(--muted-text-color, rgba(32, 33, 36, .66))"),
                    CSS.decl("--wc-hover-preview-accent-same-page", "var(--success, #2E8B57)"),
                    CSS.decl("--wc-hover-preview-accent-same-site", "var(--link-color, #2563eb)"),
                    CSS.decl("--wc-hover-preview-accent-external", "var(--external-link-color, var(--link-color, #2563eb))"),
                    CSS.decl("--wc-hover-preview-accent", "var(--wc-hover-preview-accent-same-site)")
                ),
                // CSS.rule(
                //     root,
                //     CSS.decl("position", "relative"),
                //     CSS.decl("z-index", "0"),
                //     CSS.decl("display", "inline-flex"),
                //     CSS.decl("align-items", "baseline"),
                //     CSS.decl("isolation", "isolate"),
                //     CSS.decl("--wc-hover-preview-z", "\(zIndex)"),
                //     CSS.decl("--wc-hover-preview-surface", "var(--surface-color, #fff)"),
                //     CSS.decl("--wc-hover-preview-soft", "var(--surface-soft-color, #f1f5f9)"),
                //     CSS.decl("--wc-hover-preview-border", "var(--border-color, rgba(15, 23, 42, .12))"),
                //     CSS.decl("--wc-hover-preview-ink", "var(--text-color, #202124)"),
                //     CSS.decl("--wc-hover-preview-muted", "var(--muted-text-color, rgba(32, 33, 36, .66))"),
                //     CSS.decl("--wc-hover-preview-accent", "var(--link-color, #2563eb)")
                // ),

                CSS.rule(
                    "\(root):hover, \(root):focus-within",
                    CSS.decl("z-index", "var(--wc-hover-preview-z)")
                ),

                CSS.rule(
                    ".dark-mode \(root)",
                    CSS.decl("--wc-hover-preview-surface", "var(--surface-color, #1b1c1f)"),
                    CSS.decl("--wc-hover-preview-soft", "var(--surface-soft-color, #232429)"),
                    CSS.decl("--wc-hover-preview-border", "var(--border-color, rgba(255, 255, 255, .13))"),
                    CSS.decl("--wc-hover-preview-ink", "var(--text-color, #f4f4f5)"),
                    CSS.decl("--wc-hover-preview-muted", "var(--muted-text-color, rgba(244, 244, 245, .68))")
                ),

                CSS.rule(
                    link,
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "inline"),
                    CSS.decl("color", "var(--wc-hover-preview-accent)"),
                    CSS.decl("text-decoration", "underline"),
                    CSS.decl("text-decoration-thickness", ".08em"),
                    CSS.decl("text-underline-offset", ".18em"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    "\(link)::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "0"),
                    CSS.decl("right", "0"),
                    CSS.decl("bottom", "-.18em"),
                    CSS.decl("height", ".12em"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "currentColor"),
                    CSS.decl("opacity", ".16"),
                    CSS.decl("transform", "scaleX(.92)"),
                    CSS.decl("transform-origin", "left center"),
                    CSS.decl("transition", "opacity .16s ease, transform .16s ease")
                ),

                CSS.rule(
                    "\(root):hover \(link)::after, \(root):focus-within \(link)::after",
                    CSS.decl("opacity", ".34"),
                    CSS.decl("transform", "scaleX(1)")
                ),

                CSS.rule(
                    card,
                    CSS.decl("position", "fixed"),
                    CSS.decl("left", "var(--wc-preview-left, 50vw)"),
                    CSS.decl("top", "var(--wc-preview-top, 20vh)"),
                    CSS.decl("bottom", "auto"),
                    CSS.decl("z-index", "var(--wc-hover-preview-z)"),
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "auto minmax(0, 1fr)"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("width", "min(360px, calc(100vw - 32px))"),
                    CSS.decl("min-width", "280px"),
                    CSS.decl("max-width", "calc(100vw - 28px)"),
                    CSS.decl("max-height", "min(62vh, 420px)"),
                    CSS.decl("overflow", "auto"),
                    CSS.decl("-webkit-overflow-scrolling", "touch"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("border", "1px solid var(--wc-hover-preview-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-hover-preview-surface) 96%, var(--wc-hover-preview-ink) 4%)"),
                    CSS.decl("box-shadow", "0 20px 52px rgba(15, 23, 42, .18)"),
                    CSS.decl("color", "var(--wc-hover-preview-ink)"),
                    CSS.decl("text-align", "left"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("opacity", "0"),
                    CSS.decl("visibility", "hidden"),
                    CSS.decl("pointer-events", "none"),
                    CSS.decl("transform", "translateX(-50%) translateY(8px) scale(.985)"),
                    CSS.decl("transform-origin", "center bottom"),
                    CSS.decl("transition", "opacity .16s ease, transform .16s ease, visibility 0s linear .16s")
                ),

                CSS.rule(
                    "\(root)[data-preview-placement=\"below\"] \(card)",
                    CSS.decl("transform", "translateX(-50%) translateY(-8px) scale(.985)"),
                    CSS.decl("transform-origin", "center top")
                ),

                CSS.rule(
                    ".dark-mode \(card)",
                    CSS.decl("box-shadow", "0 20px 48px rgba(0, 0, 0, .34)")
                ),

                CSS.rule(
                    "\(root):hover \(card), \(root):focus-within \(card)",
                    CSS.decl("opacity", "1"),
                    CSS.decl("visibility", "visible"),
                    CSS.decl("pointer-events", "auto"),
                    CSS.decl("transform", "translateX(-50%) translateY(0) scale(1)"),
                    CSS.decl("transition-delay", "0s")
                ),

                CSS.rule(
                    "\(card)::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "var(--wc-preview-arrow-left, 50%)"),
                    CSS.decl("bottom", "-7px"),
                    CSS.decl("width", "14px"),
                    CSS.decl("height", "14px"),
                    CSS.decl("border-right", "1px solid var(--wc-hover-preview-border)"),
                    CSS.decl("border-bottom", "1px solid var(--wc-hover-preview-border)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-hover-preview-surface) 96%, var(--wc-hover-preview-ink) 4%)"),
                    CSS.decl("transform", "translateX(-50%) rotate(45deg)")
                ),

                CSS.rule(
                    "\(root)[data-preview-placement=\"below\"] \(card)::after",
                    CSS.decl("top", "-7px"),
                    CSS.decl("bottom", "auto"),
                    CSS.decl("border-right", "0"),
                    CSS.decl("border-bottom", "0"),
                    CSS.decl("border-left", "1px solid var(--wc-hover-preview-border)"),
                    CSS.decl("border-top", "1px solid var(--wc-hover-preview-border)")
                ),

                CSS.rule(
                    media,
                    CSS.decl("display", "inline-grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "54px"),
                    CSS.decl("height", "54px"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-hover-preview-accent) 10%, var(--wc-hover-preview-soft))"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--wc-hover-preview-accent) 18%, transparent)")
                ),

                CSS.rule(
                    image,
                    CSS.decl("object-fit", "cover")
                ),

                CSS.rule(
                    glyph,
                    CSS.decl("font-size", "1.35rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("color", "var(--wc-hover-preview-accent)")
                ),

                CSS.rule(
                    custom,
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("color", "var(--wc-hover-preview-accent)")
                ),

                CSS.rule(
                    meta,
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    eyebrow,
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--wc-hover-preview-muted)")
                ),

                CSS.rule(
                    title,
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("width", "fit-content"),
                    CSS.decl("font-size", ".98rem"),
                    CSS.decl("font-weight", "820"),
                    CSS.decl("letter-spacing", "-.01em"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("color", "var(--wc-hover-preview-ink)"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    "\(title):hover, \(title):focus-visible",
                    CSS.decl("color", "var(--wc-hover-preview-accent)"),
                    CSS.decl("text-decoration", "underline"),
                    CSS.decl("text-decoration-thickness", ".08em"),
                    CSS.decl("text-underline-offset", ".18em")
                ),

                CSS.rule(
                    summary,
                    CSS.decl("display", "block"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("line-height", "1.38"),
                    CSS.decl("color", "var(--wc-hover-preview-muted)")
                ),

                CSS.rule(
                    "\(summary) p",
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    tags,
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("padding-top", "3px")
                ),

                CSS.rule(
                    tag,
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("width", "fit-content"),
                    CSS.decl("padding", "3px 7px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("color", "var(--wc-hover-preview-accent)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-hover-preview-accent) 10%, transparent)")
                ),

                CSS.rule(
                    "\(root)[data-hover-preview-variant=\"problem\"]",
                    CSS.decl("--wc-hover-preview-accent", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    "\(root)[data-hover-preview-variant=\"process\"]",
                    CSS.decl("--wc-hover-preview-accent", "var(--success, #2E8B57)")
                ),

                CSS.rule(
                    "\(root)[data-hover-preview-variant=\"article\"]",
                    CSS.decl("--wc-hover-preview-accent", "var(--warning, #E7A94E)")
                ),

                CSS.rule(
                    "\(root)[data-hover-preview-variant=\"definition\"]",
                    CSS.decl("--wc-hover-preview-accent", "var(--link-color, #2563eb)")
                ),

                CSS.rule(
                    "\(root)[data-hover-preview-scope=\"same-page\"]",
                    CSS.decl("--wc-hover-preview-accent", "var(--wc-hover-preview-accent-same-page)")
                ),

                CSS.rule(
                    "\(root)[data-hover-preview-scope=\"same-site\"]",
                    CSS.decl("--wc-hover-preview-accent", "var(--wc-hover-preview-accent-same-site)")
                ),

                CSS.rule(
                    "\(root)[data-hover-preview-scope=\"external\"]",
                    CSS.decl("--wc-hover-preview-accent", "var(--wc-hover-preview-accent-external)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        card,
                        CSS.decl("left", "max(14px, env(safe-area-inset-left))"),
                        CSS.decl("right", "max(14px, env(safe-area-inset-right))"),
                        CSS.decl("top", "auto"),
                        CSS.decl("bottom", "calc(88px + env(safe-area-inset-bottom))"),
                        CSS.decl("width", "auto"),
                        CSS.decl("min-width", "0"),
                        CSS.decl("max-width", "none"),
                        CSS.decl("max-height", "min(52vh, 420px)"),
                        CSS.decl("overflow", "auto"),
                        CSS.decl("transform", "translateY(8px) scale(.985)"),
                        CSS.decl("transform-origin", "center bottom")
                    ),
                    CSS.rule(
                        "\(root):hover \(card), \(root):focus-within \(card)",
                        CSS.decl("transform", "translateY(0) scale(1)")
                    ),
                    CSS.rule(
                        "\(card)::after",
                        CSS.decl("display", "none")
                    )
                )
            ]
        )
    }
}

public struct HoverPreviewLinkScript: ReusableComponent {
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
        if (window.wcHoverPreviewLink?.initialized) return;

        const rootSelector = '[data-hover-preview]';
        const linkSelector = '.wc-hover-preview__link';
        const cardSelector = '.wc-hover-preview__card';
        const sheetQuery = '(max-width: 640px)';
        const margin = 14;
        const gap = 12;

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

        function sync(root) {
            if (!root) return;

            const link = root.querySelector(linkSelector);

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

        function position(root) {
            if (!root) return;

            sync(root);

            const trigger = root.querySelector(linkSelector) || root;
            const card = root.querySelector(cardSelector);

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

        function rootFromEvent(event) {
            return event.target?.closest?.(rootSelector) || null;
        }

        function activeRoots() {
            return Array.from(document.querySelectorAll(rootSelector)).filter(root => {
                return root.matches(':hover') || root.contains(document.activeElement);
            });
        }

        function updateActive() {
            activeRoots().forEach(position);
        }

        function init(scope = document) {
            const roots = scope.matches?.(rootSelector)
                ? [scope]
                : Array.from(scope.querySelectorAll?.(rootSelector) || []);

            roots.forEach(root => {
                sync(root);

                if (root.matches(':hover') || root.contains(document.activeElement)) {
                    position(root);
                }
            });
        }

        document.addEventListener(
            'mouseover',
            event => {
                const root = rootFromEvent(event);
                if (root) position(root);
            },
            true
        );

        document.addEventListener(
            'focusin',
            event => {
                const root = rootFromEvent(event);
                if (root) position(root);
            },
            true
        );

        document.addEventListener(
            'touchstart',
            event => {
                const root = rootFromEvent(event);
                if (root) position(root);
            },
            { capture: true, passive: true }
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
            updateActive
        };

        window.wcHoverPreviewLink = api;
        window.wcHoverPreviewLinkScope = api;
    })();
    """#
}
