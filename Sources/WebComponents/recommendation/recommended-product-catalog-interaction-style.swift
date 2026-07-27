import CSS

extension RecommendedProductCatalog {
    static func interactionStylesheet()
        -> CSSStyleSheet
    {
        let root =
            ".\(block)"

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    "\(root)__media-inner",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "place-items",
                        "center"
                    ),
                    CSS.decl(
                        "width",
                        "100%"
                    ),
                    CSS.decl(
                        "height",
                        "100%"
                    )
                ),

                CSS.rule(
                    "\(root)__product-trigger",
                    CSS.decl(
                        "width",
                        "100%"
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
                        "font",
                        "inherit"
                    ),
                    CSS.decl(
                        "color",
                        "inherit"
                    ),
                    CSS.decl(
                        "background",
                        "transparent"
                    ),
                    CSS.decl(
                        "cursor",
                        "pointer"
                    )
                ),

                CSS.rule(
                    "\(root)__product-trigger:hover \(root)__image, \(root)__product-trigger:hover \(root)__image-fallback",
                    CSS.decl(
                        "transform",
                        "scale(1.025)"
                    )
                ),

                CSS.rule(
                    "\(root)__image, \(root)__image-fallback",
                    CSS.decl(
                        "transition",
                        "transform .18s ease"
                    )
                ),

                CSS.rule(
                    "\(root)__product-trigger:focus-visible",
                    CSS.decl(
                        "outline",
                        "3px solid var(--focus-ring, var(--accent, #0081f8))"
                    ),
                    CSS.decl(
                        "outline-offset",
                        "-3px"
                    )
                ),

                CSS.rule(
                    "\(root)__card-heading",
                    CSS.decl(
                        "min-width",
                        "0"
                    )
                ),

                CSS.rule(
                    "\(root)__title-trigger",
                    CSS.decl(
                        "padding",
                        "0"
                    ),
                    CSS.decl(
                        "border",
                        "0"
                    ),
                    CSS.decl(
                        "font",
                        "inherit"
                    ),
                    CSS.decl(
                        "font-weight",
                        "inherit"
                    ),
                    CSS.decl(
                        "line-height",
                        "inherit"
                    ),
                    CSS.decl(
                        "letter-spacing",
                        "inherit"
                    ),
                    CSS.decl(
                        "text-align",
                        "left"
                    ),
                    CSS.decl(
                        "color",
                        "inherit"
                    ),
                    CSS.decl(
                        "background",
                        "transparent"
                    ),
                    CSS.decl(
                        "cursor",
                        "pointer"
                    )
                ),

                CSS.rule(
                    "\(root)__title-trigger:hover",
                    CSS.decl(
                        "text-decoration",
                        "underline"
                    ),
                    CSS.decl(
                        "text-decoration-thickness",
                        ".08em"
                    ),
                    CSS.decl(
                        "text-underline-offset",
                        ".14em"
                    )
                ),

                CSS.rule(
                    "\(root)__title-trigger:focus-visible",
                    CSS.decl(
                        "outline",
                        "2px solid var(--focus-ring, var(--accent, #0081f8))"
                    ),
                    CSS.decl(
                        "outline-offset",
                        "3px"
                    ),
                    CSS.decl(
                        "border-radius",
                        ".2rem"
                    )
                ),

                CSS.rule(
                    "\(root)__card-badges",
                    CSS.decl(
                        "display",
                        "flex"
                    ),
                    CSS.decl(
                        "flex-wrap",
                        "wrap"
                    ),
                    CSS.decl(
                        "align-items",
                        "center"
                    ),
                    CSS.decl(
                        "justify-content",
                        "flex-end"
                    ),
                    CSS.decl(
                        "gap",
                        ".4rem"
                    )
                ),

                CSS.rule(
                    "\(root)__rating",
                    CSS.decl(
                        "display",
                        "inline-flex"
                    ),
                    CSS.decl(
                        "align-items",
                        "center"
                    ),
                    CSS.decl(
                        "justify-content",
                        "center"
                    ),
                    CSS.decl(
                        "min-height",
                        "1.75rem"
                    ),
                    CSS.decl(
                        "padding",
                        ".25rem .55rem"
                    ),
                    CSS.decl(
                        "border",
                        "1px solid var(--border-subtle, rgba(15, 23, 42, .14))"
                    ),
                    CSS.decl(
                        "border-radius",
                        "999px"
                    ),
                    CSS.decl(
                        "font-size",
                        ".76rem"
                    ),
                    CSS.decl(
                        "font-weight",
                        "750"
                    ),
                    CSS.decl(
                        "line-height",
                        "1"
                    ),
                    CSS.decl(
                        "white-space",
                        "nowrap"
                    ),
                    CSS.decl(
                        "background",
                        "var(--surface-soft, rgba(15, 23, 42, .05))"
                    )
                ),

                CSS.rule(
                    "\(root)__share",
                    CSS.decl(
                        "display",
                        "inline-flex"
                    ),
                    CSS.decl(
                        "align-items",
                        "center"
                    ),
                    CSS.decl(
                        "justify-content",
                        "center"
                    ),
                    CSS.decl(
                        "gap",
                        ".4rem"
                    ),
                    CSS.decl(
                        "min-height",
                        "2.65rem"
                    ),
                    CSS.decl(
                        "padding",
                        ".6rem .8rem"
                    ),
                    CSS.decl(
                        "border",
                        "1px solid var(--border-subtle, rgba(15, 23, 42, .16))"
                    ),
                    CSS.decl(
                        "border-radius",
                        ".7rem"
                    ),
                    CSS.decl(
                        "font",
                        "inherit"
                    ),
                    CSS.decl(
                        "font-size",
                        ".82rem"
                    ),
                    CSS.decl(
                        "font-weight",
                        "700"
                    ),
                    CSS.decl(
                        "color",
                        "inherit"
                    ),
                    CSS.decl(
                        "background",
                        "transparent"
                    ),
                    CSS.decl(
                        "cursor",
                        "pointer"
                    )
                ),

                CSS.rule(
                    "\(root)__share:hover",
                    CSS.decl(
                        "border-color",
                        "var(--accent, #0081f8)"
                    ),
                    CSS.decl(
                        "color",
                        "var(--accent, #0081f8)"
                    )
                ),

                CSS.rule(
                    "\(root)__share:focus-visible",
                    CSS.decl(
                        "outline",
                        "2px solid var(--focus-ring, var(--accent, #0081f8))"
                    ),
                    CSS.decl(
                        "outline-offset",
                        "2px"
                    )
                ),

                CSS.rule(
                    "\(root)__interaction-host",
                    CSS.decl(
                        "display",
                        "contents"
                    )
                ),

                CSS.rule(
                    "\(root)__dialog",
                    CSS.decl(
                        "width",
                        "min(1120px, calc(100% - 2rem))"
                    ),
                    CSS.decl(
                        "max-width",
                        "1120px"
                    ),
                    CSS.decl(
                        "max-height",
                        "calc(100dvh - 2rem)"
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
                        "1.25rem"
                    ),
                    CSS.decl(
                        "overflow",
                        "hidden"
                    ),
                    CSS.decl(
                        "color",
                        "var(--text, #0f1720)"
                    ),
                    CSS.decl(
                        "background",
                        "var(--surface-strong, #fff)"
                    ),
                    CSS.decl(
                        "box-shadow",
                        "0 28px 90px rgba(0, 0, 0, .28)"
                    )
                ),

                CSS.rule(
                    "\(root)__dialog::backdrop",
                    CSS.decl(
                        "background",
                        "rgba(7, 12, 20, .64)"
                    ),
                    CSS.decl(
                        "backdrop-filter",
                        "blur(4px)"
                    )
                ),

                CSS.rule(
                    "\(root)__dialog-shell",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "grid-template-rows",
                        "auto minmax(0, 1fr)"
                    ),
                    CSS.decl(
                        "max-height",
                        "calc(100dvh - 2rem)"
                    )
                ),

                CSS.rule(
                    "\(root)__dialog-toolbar",
                    CSS.decl(
                        "position",
                        "sticky"
                    ),
                    CSS.decl(
                        "top",
                        "0"
                    ),
                    CSS.decl(
                        "z-index",
                        "2"
                    ),
                    CSS.decl(
                        "display",
                        "flex"
                    ),
                    CSS.decl(
                        "justify-content",
                        "flex-end"
                    ),
                    CSS.decl(
                        "padding",
                        ".75rem"
                    ),
                    CSS.decl(
                        "border-bottom",
                        "1px solid var(--border-subtle, rgba(15, 23, 42, .12))"
                    ),
                    CSS.decl(
                        "background",
                        "var(--surface-strong, #fff)"
                    )
                ),

                CSS.rule(
                    "\(root)__dialog-close",
                    CSS.decl(
                        "display",
                        "inline-flex"
                    ),
                    CSS.decl(
                        "align-items",
                        "center"
                    ),
                    CSS.decl(
                        "gap",
                        ".4rem"
                    ),
                    CSS.decl(
                        "padding",
                        ".5rem .7rem"
                    ),
                    CSS.decl(
                        "border",
                        "1px solid var(--border-subtle, rgba(15, 23, 42, .16))"
                    ),
                    CSS.decl(
                        "border-radius",
                        "999px"
                    ),
                    CSS.decl(
                        "font",
                        "inherit"
                    ),
                    CSS.decl(
                        "font-size",
                        ".82rem"
                    ),
                    CSS.decl(
                        "font-weight",
                        "700"
                    ),
                    CSS.decl(
                        "color",
                        "inherit"
                    ),
                    CSS.decl(
                        "background",
                        "transparent"
                    ),
                    CSS.decl(
                        "cursor",
                        "pointer"
                    )
                ),

                CSS.rule(
                    "\(root)__dialog-content",
                    CSS.decl(
                        "overflow-y",
                        "auto"
                    ),
                    CSS.decl(
                        "overscroll-behavior",
                        "contain"
                    )
                ),

                CSS.rule(
                    "\(root)__dialog-product[hidden]",
                    CSS.decl(
                        "display",
                        "none"
                    )
                ),

                CSS.rule(
                    "\(root)__share-status",
                    CSS.decl(
                        "position",
                        "fixed"
                    ),
                    CSS.decl(
                        "right",
                        "1rem"
                    ),
                    CSS.decl(
                        "bottom",
                        "1rem"
                    ),
                    CSS.decl(
                        "z-index",
                        "10000"
                    ),
                    CSS.decl(
                        "max-width",
                        "min(24rem, calc(100% - 2rem))"
                    ),
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "padding",
                        ".7rem .9rem"
                    ),
                    CSS.decl(
                        "border-radius",
                        ".75rem"
                    ),
                    CSS.decl(
                        "font-size",
                        ".86rem"
                    ),
                    CSS.decl(
                        "background",
                        "var(--text, #0f1720)"
                    ),
                    CSS.decl(
                        "color",
                        "var(--surface-strong, #fff)"
                    )
                ),

                CSS.rule(
                    "\(root)__share-status:empty",
                    CSS.decl(
                        "display",
                        "none"
                    )
                ),

                CSS.rule(
                    "html.wc-product-dialog-open",
                    CSS.decl(
                        "overflow",
                        "hidden"
                    )
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        "\(root)__dialog",
                        CSS.decl(
                            "width",
                            "calc(100% - 1rem)"
                        ),
                        CSS.decl(
                            "max-height",
                            "calc(100dvh - 1rem)"
                        ),
                        CSS.decl(
                            "border-radius",
                            "1rem"
                        )
                    ),

                    CSS.rule(
                        "\(root)__dialog-shell",
                        CSS.decl(
                            "max-height",
                            "calc(100dvh - 1rem)"
                        )
                    ),

                    CSS.rule(
                        "\(root)__card-badges",
                        CSS.decl(
                            "justify-content",
                            "flex-start"
                        )
                    )
                )
            ]
        )
    }
}
