import CSS

extension DocsProjectPreview {
    public static func stylesheet() -> CSSStyleSheet {
        let root = ".wc-docs-project-preview"

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    root,
                    CSS.decl(
                        "--wc-docs-preview-viewport-height",
                        "480px"
                    ),
                    CSS.decl(
                        "--wc-docs-sticky-offset",
                        "0px"
                    ),
                    CSS.decl("width", "100%"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl(
                        "border",
                        "1px solid var(--border-color)"
                    ),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl(
                        "background",
                        "var(--background-color)"
                    ),
                    CSS.decl(
                        "color",
                        "var(--text-color)"
                    ),
                    CSS.decl(
                        "box-shadow",
                        "0 20px 56px rgba(15, 23, 42, .10)"
                    )
                ),

                CSS.rule(
                    "\(root), \(root) *",
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    "\(root) [hidden]",
                    CSS.decl(
                        "display",
                        "none !important"
                    )
                ),

                CSS.rule(
                    "\(root) .wc-docs-project-context-nav",
                    CSS.decl("position", "relative"),
                    CSS.decl("top", "auto"),
                    CSS.decl("z-index", "4"),
                    CSS.decl("flex", "0 0 auto")
                ),

                CSS.rule(
                    "\(root) .wc-docs-category-nav",
                    CSS.decl("position", "relative"),
                    CSS.decl("top", "auto"),
                    CSS.decl("z-index", "3"),
                    CSS.decl("flex", "0 0 auto")
                ),

                CSS.rule(
                    "\(root)__viewport",
                    CSS.decl("position", "relative"),
                    CSS.decl(
                        "height",
                        "var(--wc-docs-preview-viewport-height)"
                    ),
                    CSS.decl("min-height", "0"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl(
                        "background",
                        "var(--background-color)"
                    )
                ),

                CSS.rule(
                    "\(root)__panel",
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "100%"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("min-height", "0"),
                    CSS.decl("overflow", "auto"),
                    CSS.decl(
                        "overscroll-behavior",
                        "contain"
                    ),
                    CSS.decl(
                        "scrollbar-gutter",
                        "stable"
                    ),
                    CSS.decl(
                        "scrollbar-width",
                        "thin"
                    )
                ),

                CSS.rule(
                    "\(root)__panel > .wc-docs-category-pane",
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "auto"),
                    CSS.decl("min-height", "100%"),
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    "\(root)__panel .wc-docs-category-pane--embedded .wc-docs-toc",
                    CSS.decl("position", "sticky"),
                    CSS.decl("top", "0"),
                    CSS.decl(
                        "height",
                        "var(--wc-docs-preview-viewport-height)"
                    ),
                    CSS.decl(
                        "max-height",
                        "var(--wc-docs-preview-viewport-height)"
                    ),
                    CSS.decl("align-self", "start"),
                    CSS.decl("overflow-y", "auto"),
                    CSS.decl("overscroll-behavior", "contain")
                ),

                CSS.rule(
                    "\(root)__footer",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl(
                        "justify-content",
                        "space-between"
                    ),
                    CSS.decl("gap", "20px"),
                    CSS.decl("min-height", "58px"),
                    CSS.decl("padding", "12px 22px"),
                    CSS.decl(
                        "border-top",
                        "1px solid var(--border-color)"
                    ),
                    CSS.decl(
                        "background",
                        "var(--surface-soft-color)"
                    )
                ),

                CSS.rule(
                    "\(root)__current",
                    CSS.decl("min-width", "0"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl(
                        "color",
                        "var(--muted-text-color)"
                    ),
                    CSS.decl("font-size", ".8rem"),
                    CSS.decl(
                        "text-overflow",
                        "ellipsis"
                    ),
                    CSS.decl("white-space", "nowrap")
                ),

                CSS.rule(
                    "\(root)__destination",
                    CSS.decl("flex", "0 0 auto"),
                    CSS.decl(
                        "color",
                        "var(--link-color)"
                    ),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    "\(root)__destination:hover",
                    CSS.decl("text-decoration", "underline")
                ),

                CSS.rule(
                    "\(root)__destination:focus-visible",
                    CSS.decl(
                        "outline",
                        "2px solid var(--link-color)"
                    ),
                    CSS.decl("outline-offset", "3px")
                )
            ],

            media: [
                CSS.media(
                    "(max-width: 900px)",

                    CSS.rule(
                        root,
                        CSS.decl(
                            "--wc-docs-preview-viewport-height",
                            "460px"
                        )
                    )
                ),

                CSS.media(
                    "(max-width: 760px)",

                    CSS.rule(
                        root,
                        CSS.decl(
                            "--wc-docs-preview-viewport-height",
                            "440px"
                        )
                    ),

                    CSS.rule(
                        "\(root)__panel .wc-docs-category-pane--embedded .wc-docs-toc",
                        CSS.decl("display", "none")
                    )
                ),

                CSS.media(
                    "(max-width: 560px)",

                    CSS.rule(
                        root,
                        CSS.decl(
                            "--wc-docs-preview-viewport-height",
                            "410px"
                        ),
                        CSS.decl("border-radius", "14px")
                    ),

                    CSS.rule(
                        "\(root)__footer",
                        CSS.decl("padding", "11px 15px")
                    )
                )
            ]
        )
    }
}
