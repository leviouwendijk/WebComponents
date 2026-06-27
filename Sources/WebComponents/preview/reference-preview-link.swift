import Constructors
import CSS
import HTML
import JS
import References

public struct ReferencePreviewLink: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-reference-preview"
        static let trigger = "wc-reference-preview__trigger"
        static let card = "wc-reference-preview__card"
        static let eyebrow = "wc-reference-preview__eyebrow"
        static let title = "wc-reference-preview__title"
        static let meta = "wc-reference-preview__meta"
        static let metaItem = "wc-reference-preview__meta-item"
        static let comments = "wc-reference-preview__comments"
        static let comment = "wc-reference-preview__comment"
        static let commentPointer = "wc-reference-preview__comment-pointer"
        static let footer = "wc-reference-preview__footer"
        static let anchorLink = "wc-reference-preview__anchor-link"
    }

    public let reference: any Referencable
    public let number: Int
    public let comments: [Reference.Comment]
    public let anchorHref: String?
    public let includeStyles: Bool

    public init(
        reference: any Referencable,
        number: Int,
        comments: [Reference.Comment] = [],
        anchorHref: String? = nil,
        includeStyles: Bool = true
    ) {
        self.reference = reference
        self.number = number
        self.comments = comments
        self.anchorHref = anchorHref
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        let cardID = "reference-preview-\(number)"

        return .body(
            [
                HTML.sup(
                    [
                        "class": "\(ClassName.root) cite",
                        "data-cite": "\(number)",
                        "id": "cite-\(number)"
                    ]
                ) {
                    HTML.button(
                        [
                            "class": ClassName.trigger,
                            "type": "button",
                            "aria-label": "Toon bron \(number)",
                            "aria-describedby": cardID
                        ]
                    ) {
                        HTML.text("[\(number)]")
                    }

                    HTML.span(
                        [
                            "class": ClassName.card,
                            "id": cardID,
                            "role": "note"
                        ]
                    ) {
                        HTML.span([ "class": ClassName.eyebrow ]) {
                            HTML.text("Bron \(number)")
                        }

                        titleNode()

                        metaNodes()

                        commentNodes()

                        if let anchorHref, !anchorHref.isEmpty {
                            HTML.span([ "class": ClassName.footer ]) {
                                HTML.a(
                                    anchorHref,
                                    [ "class": ClassName.anchorLink ]
                                ) {
                                    HTML.text("Naar referentieblok")
                                }
                            }
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    private func titleNode() -> any HTMLNode {
        if reference.url.isEmpty {
            return HTML.span([ "class": ClassName.title ]) {
                HTML.text(reference.title)
            }
        }

        return HTML.a(
            reference.url,
            [
                "class": ClassName.title,
                "target": "_blank",
                "rel": "noopener noreferrer"
            ]
        ) {
            HTML.text(reference.title)
        }
    }

    private func metaNodes() -> any HTMLNode {
        HTML.span([ "class": ClassName.meta ]) {
            if let author = reference.authorLine, !author.isEmpty {
                HTML.span([ "class": ClassName.metaItem ]) {
                    HTML.text(author)
                }
            }

            if let date = reference.dateISO8601, !date.isEmpty {
                HTML.el(
                    "time",
                    [
                        "class": ClassName.metaItem,
                        "datetime": date
                    ]
                ) {
                    HTML.text(date)
                }
            }

            if let doi = reference.doi, !doi.isEmpty {
                HTML.span([ "class": ClassName.metaItem ]) {
                    HTML.text("DOI: \(doi)")
                }
            }
        }
    }

    private func commentNodes() -> any HTMLNode {
        HTML.span([ "class": ClassName.comments ]) {
            for comment in comments where !comment.text.isEmpty || !comment.locators.isEmpty {
                commentNode(comment)
            }
        }
    }

    private func commentNode(
        _ comment: Reference.Comment
    ) -> any HTMLNode {
        HTML.span([ "class": ClassName.comment ]) {
            if !comment.pointers.isEmpty {
                HTML.span([ "class": ClassName.commentPointer ]) {
                    HTML.text("[\(comment.pointers.map(String.init).joined(separator: ", "))]")
                }
            }

            if !comment.locators.isEmpty {
                HTML.span([ "class": ClassName.commentPointer ]) {
                    HTML.text(comment.locators.map(\.rendered).joined(separator: ", "))
                }
            }

            if !comment.text.isEmpty {
                HTML.text(comment.text)
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: CitationCluster.rules() + [
                CSS.rule(
                    ".wc-reference-preview, .wc-inline-preview, .cite, .footnote",
                    CSS.decl(
                        "scroll-margin-top", "calc(var(--wc-docs-sticky-offset, 112px) + 24px)")
                ),

                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "inline-block"),
                    CSS.decl("vertical-align", "super"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("text-indent", "0"),
                    CSS.decl("--wc-reference-preview-surface", "var(--surface-color, #fff)"),
                    CSS.decl("--wc-reference-preview-soft", "var(--surface-soft-color, #f1f5f9)"),
                    CSS.decl("--wc-reference-preview-border", "var(--border-color, rgba(15, 23, 42, .12))"),
                    CSS.decl("--wc-reference-preview-ink", "var(--text-color, #202124)"),
                    CSS.decl("--wc-reference-preview-muted", "var(--muted-text-color, rgba(32, 33, 36, .66))"),
                    CSS.decl("--wc-reference-preview-accent", "var(--link-color, #2563eb)")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.root)",
                    CSS.decl("--wc-reference-preview-surface", "var(--surface-color, #1b1c1f)"),
                    CSS.decl("--wc-reference-preview-soft", "var(--surface-soft-color, #232429)"),
                    CSS.decl("--wc-reference-preview-border", "var(--border-color, rgba(255, 255, 255, .13))"),
                    CSS.decl("--wc-reference-preview-ink", "var(--text-color, #f4f4f5)"),
                    CSS.decl("--wc-reference-preview-muted", "var(--muted-text-color, rgba(244, 244, 245, .68))")
                ),

                CSS.rule(
                    ".\(CitationCluster.className) .\(ClassName.root)",
                    CSS.decl("vertical-align", "baseline"),
                    CSS.decl("text-indent", "0")
                ),

                CSS.rule(
                    ".\(CitationCluster.className) .\(ClassName.card)",
                    CSS.decl("text-align", "left"),
                    CSS.decl("text-indent", "0"),
                    CSS.decl("white-space", "normal"),
                    CSS.decl("overflow-wrap", "normal")
                ),

                CSS.rule(
                    ".\(CitationCluster.className) + .\(ClassName.root), .\(CitationCluster.className) + .wc-inline-preview",
                    CSS.decl("margin-inline-start", ".35em")
                ),

                CSS.rule(
                    ".\(ClassName.trigger)",
                    CSS.decl("-webkit-appearance", "none"),
                    CSS.decl("appearance", "none"),
                    CSS.decl("border", "0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("margin", "0"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", ".72em"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("color", "var(--wc-reference-preview-accent)"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(ClassName.trigger):hover, .\(ClassName.trigger):focus-visible",
                    CSS.decl("text-decoration", "underline"),
                    CSS.decl("text-decoration-thickness", ".08em"),
                    CSS.decl("text-underline-offset", ".16em")
                ),

                CSS.rule(
                    ".\(ClassName.card)",
                    CSS.decl("position", "fixed"),
                    CSS.decl("left", "var(--wc-preview-left, 50vw)"),
                    CSS.decl("top", "var(--wc-preview-top, 20vh)"),
                    CSS.decl("bottom", "auto"),
                    CSS.decl("z-index", "var(--z-overlay, 10000)"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "7px"),
                    CSS.decl("width", "min(420px, calc(100vw - 32px))"),
                    CSS.decl("min-width", "300px"),
                    CSS.decl("max-width", "calc(100vw - 28px)"),
                    CSS.decl("max-height", "min(62vh, 460px)"),
                    CSS.decl("overflow", "auto"),
                    CSS.decl("-webkit-overflow-scrolling", "touch"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("border", "1px solid var(--wc-reference-preview-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-reference-preview-surface) 96%, var(--wc-reference-preview-ink) 4%)"),
                    CSS.decl("box-shadow", "0 20px 52px rgba(15, 23, 42, .18)"),
                    CSS.decl("color", "var(--wc-reference-preview-ink)"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "400"),
                    CSS.decl("line-height", "1.35"),
                    CSS.decl("text-align", "left"),
                    CSS.decl("text-indent", "0"),
                    CSS.decl("white-space", "normal"),
                    CSS.decl("overflow-wrap", "normal"),
                    CSS.decl("opacity", "0"),
                    CSS.decl("visibility", "hidden"),
                    CSS.decl("pointer-events", "none"),
                    CSS.decl("transform", "translateX(-50%) translateY(8px) scale(.985)"),
                    CSS.decl("transform-origin", "center bottom"),
                    CSS.decl("transition", "opacity .16s ease, transform .16s ease, visibility 0s linear .16s")
                ),

                CSS.rule(
                    ".\(ClassName.root)[data-preview-placement=\"below\"] .\(ClassName.card)",
                    CSS.decl("transform", "translateX(-50%) translateY(-8px) scale(.985)"),
                    CSS.decl("transform-origin", "center top")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.card)",
                    CSS.decl("box-shadow", "0 20px 48px rgba(0, 0, 0, .34)")
                ),

                CSS.rule(
                    ".\(ClassName.root):hover .\(ClassName.card), .\(ClassName.root):focus-within .\(ClassName.card)",
                    CSS.decl("opacity", "1"),
                    CSS.decl("visibility", "visible"),
                    CSS.decl("pointer-events", "auto"),
                    CSS.decl("transform", "translateX(-50%) translateY(0) scale(1)"),
                    CSS.decl("transition-delay", "0s")
                ),

                CSS.rule(
                    ".\(ClassName.card)::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "var(--wc-preview-arrow-left, 50%)"),
                    CSS.decl("bottom", "-7px"),
                    CSS.decl("width", "14px"),
                    CSS.decl("height", "14px"),
                    CSS.decl("border-right", "1px solid var(--wc-reference-preview-border)"),
                    CSS.decl("border-bottom", "1px solid var(--wc-reference-preview-border)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-reference-preview-surface) 96%, var(--wc-reference-preview-ink) 4%)"),
                    CSS.decl("transform", "translateX(-50%) rotate(45deg)")
                ),

                CSS.rule(
                    ".\(ClassName.root)[data-preview-placement=\"below\"] .\(ClassName.card)::after",
                    CSS.decl("top", "-7px"),
                    CSS.decl("bottom", "auto"),
                    CSS.decl("border-right", "0"),
                    CSS.decl("border-bottom", "0"),
                    CSS.decl("border-left", "1px solid var(--wc-reference-preview-border)"),
                    CSS.decl("border-top", "1px solid var(--wc-reference-preview-border)")
                ),

                CSS.rule(
                    ".\(ClassName.eyebrow)",
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--wc-reference-preview-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.title)",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "auto"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("font-size", ".98rem"),
                    CSS.decl("font-weight", "820"),
                    CSS.decl("letter-spacing", "-.01em"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("color", "var(--wc-reference-preview-ink)"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("white-space", "normal"),
                    CSS.decl("overflow-wrap", "anywhere"),
                    CSS.decl("word-break", "normal")
                ),

                CSS.rule(
                    "a.\(ClassName.title):hover, a.\(ClassName.title):focus-visible",
                    CSS.decl("color", "var(--wc-reference-preview-accent)"),
                    CSS.decl("text-decoration", "underline"),
                    CSS.decl("text-decoration-thickness", ".08em"),
                    CSS.decl("text-underline-offset", ".18em")
                ),

                CSS.rule(
                    ".\(ClassName.meta)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("white-space", "normal")
                ),

                CSS.rule(
                    ".\(ClassName.metaItem)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("display", "inline-block"),
                    CSS.decl("width", "fit-content"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("padding", "3px 7px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("white-space", "normal"),
                    CSS.decl("overflow-wrap", "anywhere"),
                    CSS.decl("word-break", "normal"),
                    CSS.decl("color", "var(--wc-reference-preview-accent)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-reference-preview-accent) 10%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.comments)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("margin-top", "2px")
                ),

                CSS.rule(
                    ".\(ClassName.comment)",
                    CSS.decl("display", "block"),
                    CSS.decl("padding", "8px 10px"),
                    CSS.decl("border", "1px solid var(--wc-reference-preview-border)"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-reference-preview-soft) 60%, transparent)"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("line-height", "1.4"),
                    CSS.decl("color", "var(--wc-reference-preview-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.commentPointer)",
                    CSS.decl("margin-right", "5px"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("color", "var(--wc-reference-preview-accent)")
                ),

                CSS.rule(
                    ".\(ClassName.footer)",
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "flex-start"),
                    CSS.decl("padding-top", "2px")
                ),

                CSS.rule(
                    ".\(ClassName.anchorLink)",
                    CSS.decl("font-size", ".74rem"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("line-height", "1.2"),
                    CSS.decl("color", "var(--wc-reference-preview-accent)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".\(ClassName.anchorLink):hover, .\(ClassName.anchorLink):focus-visible",
                    CSS.decl("text-decoration", "underline"),
                    CSS.decl("text-decoration-thickness", ".08em"),
                    CSS.decl("text-underline-offset", ".18em")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".\(ClassName.card)",
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
                        ".\(ClassName.root):hover .\(ClassName.card), .\(ClassName.root):focus-within .\(ClassName.card)",
                        CSS.decl("transform", "translateY(0) scale(1)")
                    ),

                    CSS.rule(
                        ".\(ClassName.card)::after",
                        CSS.decl("display", "none")
                    )
                )
            ]
        )
    }
}

public struct ReferencePreviewLinkScript: ReusableComponent {
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
        if (window.wcReferencePreviewLink?.initialized) return;

        const rootSelector = '.wc-reference-preview';
        const triggerSelector = '.wc-reference-preview__trigger';
        const cardSelector = '.wc-reference-preview__card';
        const sheetQuery = '(max-width: 640px)';
        const margin = 14;
        const gap = 12;

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

            const trigger = root.querySelector(triggerSelector) || root;
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

        window.wcReferencePreviewLink = {
            initialized: true,
            init,
            position,
            updateActive
        };
    })();
    """#
}
