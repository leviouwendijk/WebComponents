import Constructors
import CSS
import HTML

struct RecommendedProductGallery:
    Sendable
{
    static let block =
        "wc-product-gallery"

    let id: String
    let label: String
    let images: [RecommendedProduct.Image]
    let imageClass: String

    private var hasMultipleImages: Bool {
        images.count > 1
    }

    func node() -> any HTMLNode {
        HTML.div(
            [
                "id": id,
                "class": Self.block,
                "data-product-gallery":
                    hasMultipleImages
                        ? "true"
                        : "false",
                "data-product-gallery-index":
                    "0",
                "aria-label":
                    label,
                "aria-roledescription":
                    "carrousel"
            ]
        ) {
            HTML.div(
                [
                    "class":
                        "\(Self.block)__viewport",
                    "data-product-gallery-viewport":
                        "true",
                    "tabindex":
                        hasMultipleImages
                            ? "0"
                            : "-1"
                ]
            ) {
                for (
                    index,
                    image
                ) in images.enumerated() {
                    HTML.div(
                        [
                            "id":
                                "\(id)-slide-\(index)",
                            "class":
                                "\(Self.block)__slide",
                            "data-product-gallery-slide":
                                "\(index)",
                            "role":
                                "group",
                            "aria-roledescription":
                                "afbeelding",
                            "aria-label":
                                "\(index + 1) van \(images.count)"
                        ]
                    ) {
                        HTML.img(
                            src:
                                image
                                    .url
                                    .absoluteString,
                            alt:
                                image.alt,
                            [
                                "class":
                                    "\(Self.block)__image \(imageClass)",
                                "loading":
                                    "lazy",
                                "decoding":
                                    "async",
                                "draggable":
                                    "false"
                            ]
                        )
                    }
                }
            }

            if hasMultipleImages {
                HTML.div(
                    [
                        "class":
                            "\(Self.block)__dots",
                        "aria-label":
                            "Productafbeeldingen"
                    ]
                ) {
                    for index in images.indices {
                        HTML.button(
                            [
                                "type":
                                    "button",
                                "class":
                                    "\(Self.block)__dot",
                                "data-product-gallery-dot":
                                    "\(index)",
                                "aria-controls":
                                    "\(id)-slide-\(index)",
                                "aria-label":
                                    "Toon afbeelding \(index + 1)",
                                "aria-current":
                                    index == 0
                                        ? "true"
                                        : "false"
                            ]
                        ) {}
                    }
                }
            }

            if hasMultipleImages {
                scriptNode()
            }
        }
    }

    private func scriptNode() -> any HTMLNode {
        HTML.scriptInline(
            """
            (() => {
                if (!window.__wcProductGallery) {
                    const parts = root => ({
                        viewport: root.querySelector(
                            '[data-product-gallery-viewport]'
                        ),
                        slides: Array.from(
                            root.querySelectorAll(
                                '[data-product-gallery-slide]'
                            )
                        ),
                        dots: Array.from(
                            root.querySelectorAll(
                                '[data-product-gallery-dot]'
                            )
                        )
                    });

                    const clamp = (value, minimum, maximum) => {
                        return Math.max(
                            minimum,
                            Math.min(
                                maximum,
                                value
                            )
                        );
                    };

                    const setIndex = (root, requestedIndex) => {
                        const gallery = parts(root);

                        if (!gallery.slides.length) {
                            return;
                        }

                        const index = clamp(
                            requestedIndex,
                            0,
                            gallery.slides.length - 1
                        );

                        root.dataset.productGalleryIndex =
                            String(index);

                        gallery.dots.forEach(
                            (dot, dotIndex) => {
                                dot.setAttribute(
                                    'aria-current',
                                    dotIndex === index
                                        ? 'true'
                                        : 'false'
                                );
                            }
                        );
                    };

                    const currentIndex = root => {
                        const gallery = parts(root);

                        if (
                            !gallery.viewport
                            || gallery.viewport.clientWidth <= 0
                        ) {
                            return 0;
                        }

                        return clamp(
                            Math.round(
                                gallery.viewport.scrollLeft
                                / gallery.viewport.clientWidth
                            ),
                            0,
                            gallery.slides.length - 1
                        );
                    };

                    const moveTo = (root, requestedIndex) => {
                        const gallery = parts(root);

                        if (
                            !gallery.viewport
                            || !gallery.slides.length
                        ) {
                            return;
                        }

                        const index = clamp(
                            requestedIndex,
                            0,
                            gallery.slides.length - 1
                        );

                        gallery.viewport.scrollTo({
                            left:
                                gallery.slides[index]
                                    .offsetLeft,
                            behavior:
                                window.matchMedia(
                                    '(prefers-reduced-motion: reduce)'
                                ).matches
                                    ? 'auto'
                                    : 'smooth'
                        });

                        setIndex(
                            root,
                            index
                        );
                    };

                    const initialise = root => {
                        if (
                            root.dataset.productGalleryReady
                            === 'true'
                        ) {
                            return;
                        }

                        const gallery = parts(root);

                        if (!gallery.viewport) {
                            return;
                        }

                        root.dataset.productGalleryReady =
                            'true';

                        let animationFrame = 0;

                        gallery.viewport.addEventListener(
                            'scroll',
                            () => {
                                window.cancelAnimationFrame(
                                    animationFrame
                                );

                                animationFrame =
                                    window.requestAnimationFrame(
                                        () => {
                                            setIndex(
                                                root,
                                                currentIndex(root)
                                            );
                                        }
                                    );
                            },
                            {
                                passive: true
                            }
                        );

                        setIndex(
                            root,
                            0
                        );
                    };

                    document.addEventListener(
                        'click',
                        event => {
                            const dot =
                                event
                                    .target
                                    .closest(
                                        '[data-product-gallery-dot]'
                                    );

                            if (!dot) {
                                return;
                            }

                            const root =
                                dot.closest(
                                    '[data-product-gallery="true"]'
                                );

                            if (!root) {
                                return;
                            }

                            event.preventDefault();
                            event.stopPropagation();

                            moveTo(
                                root,
                                Number(
                                    dot.dataset
                                        .productGalleryDot
                                )
                            );
                        }
                    );

                    document.addEventListener(
                        'keydown',
                        event => {
                            if (
                                event.key !== 'ArrowLeft'
                                && event.key !== 'ArrowRight'
                            ) {
                                return;
                            }

                            const viewport =
                                event
                                    .target
                                    .closest(
                                        '[data-product-gallery-viewport]'
                                    );

                            if (!viewport) {
                                return;
                            }

                            const root =
                                viewport.closest(
                                    '[data-product-gallery="true"]'
                                );

                            if (!root) {
                                return;
                            }

                            event.preventDefault();

                            const direction =
                                event.key === 'ArrowRight'
                                    ? 1
                                    : -1;

                            moveTo(
                                root,
                                currentIndex(root)
                                    + direction
                            );
                        }
                    );

                    window.__wcProductGallery = {
                        initialise
                    };
                }

                document
                    .querySelectorAll(
                        '[data-product-gallery="true"]'
                    )
                    .forEach(
                        window
                            .__wcProductGallery
                            .initialise
                    );
            })();
            """
        )
    }

    static func stylesheet() -> CSSStyleSheet {
        let root =
            ".\(block)"

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    root,
                    CSS.decl(
                        "position",
                        "relative"
                    ),
                    CSS.decl(
                        "width",
                        "100%"
                    ),
                    CSS.decl(
                        "height",
                        "100%"
                    ),
                    CSS.decl(
                        "min-width",
                        "0"
                    ),
                    CSS.decl(
                        "overflow",
                        "hidden"
                    ),
                    CSS.decl(
                        "background",
                        "#fff"
                    )
                ),

                CSS.rule(
                    "\(root)__viewport",
                    CSS.decl(
                        "display",
                        "flex"
                    ),
                    CSS.decl(
                        "width",
                        "100%"
                    ),
                    CSS.decl(
                        "height",
                        "100%"
                    ),
                    CSS.decl(
                        "overflow-x",
                        "auto"
                    ),
                    CSS.decl(
                        "overflow-y",
                        "hidden"
                    ),
                    CSS.decl(
                        "scroll-snap-type",
                        "x mandatory"
                    ),
                    CSS.decl(
                        "overscroll-behavior-x",
                        "contain"
                    ),
                    CSS.decl(
                        "scrollbar-width",
                        "none"
                    ),
                    CSS.decl(
                        "-ms-overflow-style",
                        "none"
                    ),
                    CSS.decl(
                        "touch-action",
                        "pan-x pan-y"
                    )
                ),

                CSS.rule(
                    "\(root)__viewport::-webkit-scrollbar",
                    CSS.decl(
                        "display",
                        "none"
                    )
                ),

                CSS.rule(
                    "\(root)__slide",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "place-items",
                        "center"
                    ),
                    CSS.decl(
                        "flex",
                        "0 0 100%"
                    ),
                    CSS.decl(
                        "width",
                        "100%"
                    ),
                    CSS.decl(
                        "height",
                        "100%"
                    ),
                    CSS.decl(
                        "min-width",
                        "100%"
                    ),
                    CSS.decl(
                        "scroll-snap-align",
                        "start"
                    ),
                    CSS.decl(
                        "scroll-snap-stop",
                        "always"
                    )
                ),

                CSS.rule(
                    "\(root)__image",
                    CSS.decl(
                        "user-select",
                        "none"
                    ),
                    CSS.decl(
                        "-webkit-user-drag",
                        "none"
                    )
                ),

                CSS.rule(
                    "\(root)__dots",
                    CSS.decl(
                        "position",
                        "absolute"
                    ),
                    CSS.decl(
                        "left",
                        "50%"
                    ),
                    CSS.decl(
                        "bottom",
                        ".55rem"
                    ),
                    CSS.decl(
                        "z-index",
                        "3"
                    ),
                    CSS.decl(
                        "display",
                        "flex"
                    ),
                    CSS.decl(
                        "gap",
                        ".35rem"
                    ),
                    CSS.decl(
                        "padding",
                        ".35rem .45rem"
                    ),
                    CSS.decl(
                        "border-radius",
                        "999px"
                    ),
                    CSS.decl(
                        "background",
                        "rgba(255,255,255,.88)"
                    ),
                    CSS.decl(
                        "box-shadow",
                        "0 2px 10px rgba(15,23,42,.14)"
                    ),
                    CSS.decl(
                        "transform",
                        "translateX(-50%)"
                    )
                ),

                CSS.rule(
                    "\(root)__dot",
                    CSS.decl(
                        "width",
                        ".48rem"
                    ),
                    CSS.decl(
                        "height",
                        ".48rem"
                    ),
                    CSS.decl(
                        "padding",
                        "0"
                    ),
                    CSS.decl(
                        "border",
                        "0"
                    ),
                    CSS.decl(
                        "border-radius",
                        "999px"
                    ),
                    CSS.decl(
                        "background",
                        "rgba(15,23,42,.28)"
                    ),
                    CSS.decl(
                        "cursor",
                        "pointer"
                    )
                ),

                CSS.rule(
                    "\(root)__dot[aria-current=\"true\"]",
                    CSS.decl(
                        "width",
                        "1.15rem"
                    ),
                    CSS.decl(
                        "background",
                        "var(--accent, #0081f8)"
                    )
                ),

                CSS.rule(
                    "\(root)__dot:focus-visible",
                    CSS.decl(
                        "outline",
                        "3px solid var(--focus-ring, var(--accent, #0081f8))"
                    ),
                    CSS.decl(
                        "outline-offset",
                        "2px"
                    )
                )
            ]
        )
    }
}
