import CSS

extension DocsProjectPreview {
    public static func stylesheet() -> CSSStyleSheet {
        let root = ".wc-docs-project-preview"

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    root,
                    CSS.decl("width", "100%"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("border", "1px solid var(--wc-docs-preview-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--wc-docs-preview-surface)"),
                    CSS.decl("color", "var(--wc-docs-preview-ink)"),
                    CSS.decl("box-shadow", "0 20px 56px rgba(15, 76, 129, .11)"),
                    CSS.decl("font-family", "\"Instrument Sans\", system-ui, sans-serif"),
                    CSS.decl("--wc-docs-preview-ink", "#172536"),
                    CSS.decl("--wc-docs-preview-muted", "#687786"),
                    CSS.decl("--wc-docs-preview-border", "#dbe4eb"),
                    CSS.decl("--wc-docs-preview-surface", "#ffffff"),
                    CSS.decl("--wc-docs-preview-soft", "#f4f7f9"),
                    CSS.decl("--wc-docs-preview-toolbar", "#102638"),
                    CSS.decl("--wc-docs-preview-accent", "var(--link-color, #0081F8)"),
                    CSS.decl("--background-color", "#ffffff"),
                    CSS.decl("--surface-color", "#ffffff"),
                    CSS.decl("--surface-soft-color", "#f4f7f9"),
                    CSS.decl("--text-color", "#172536"),
                    CSS.decl("--muted-text-color", "#687786"),
                    CSS.decl("--border-color", "#dbe4eb"),
                    CSS.decl("--link-color", "var(--wc-docs-preview-accent)")
                ),

                CSS.rule(
                    "\(root), \(root) *",
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    "\(root) [hidden]",
                    CSS.decl("display", "none !important")
                ),

                CSS.rule(
                    "\(root)__toolbar",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("min-height", "58px"),
                    CSS.decl("padding", "0 20px"),
                    CSS.decl("background", "var(--wc-docs-preview-toolbar)"),
                    CSS.decl("color", "#f8fbfd")
                ),

                CSS.rule(
                    "\(root)__brand",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "9px"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("color", "inherit"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    "\(root)__brand:hover",
                    CSS.decl("color", "inherit"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    "\(root)__brand-mark",
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "30px"),
                    CSS.decl("height", "30px"),
                    CSS.decl("flex", "0 0 30px"),
                    CSS.decl("border", "1px solid rgba(255, 255, 255, .26)"),
                    CSS.decl("border-radius", "8px"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "800")
                ),

                CSS.rule(
                    "\(root)__brand-title",
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("text-overflow", "ellipsis"),
                    CSS.decl("white-space", "nowrap")
                ),

                CSS.rule(
                    "\(root)__brand-product",
                    CSS.decl("color", "rgba(255, 255, 255, .62)"),
                    CSS.decl("font-size", ".9rem")
                ),

                CSS.rule(
                    "\(root)__body",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "260px minmax(0, 1fr)"),
                    CSS.decl("min-height", "470px")
                ),

                CSS.rule(
                    "\(root)__navigation",
                    CSS.decl("padding", "24px 17px"),
                    CSS.decl("background", "var(--wc-docs-preview-soft)"),
                    CSS.decl("border-right", "1px solid var(--wc-docs-preview-border)")
                ),

                CSS.rule(
                    "\(root)__navigation-label",
                    CSS.decl("margin", "0 0 13px 11px"),
                    CSS.decl("color", "var(--wc-docs-preview-muted)"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, monospace"),
                    CSS.decl("font-size", ".7rem"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("letter-spacing", ".1em"),
                    CSS.decl("text-transform", "uppercase")
                ),

                CSS.rule(
                    "\(root)__tabs",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "7px")
                ),

                CSS.rule(
                    "\(root)__tab",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("width", "100%"),
                    CSS.decl("padding", "12px 13px"),
                    CSS.decl("appearance", "none"),
                    CSS.decl("border", "0"),
                    CSS.decl("border-left", "3px solid transparent"),
                    CSS.decl("border-radius", "9px"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("color", "var(--wc-docs-preview-ink)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("text-align", "left"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("transition", "background-color .16s ease, border-color .16s ease")
                ),

                CSS.rule(
                    "\(root)__tab:hover",
                    CSS.decl("background", "rgba(15, 76, 129, .055)")
                ),

                CSS.rule(
                    "\(root)__tab[aria-selected=\"true\"]",
                    CSS.decl("border-left-color", "var(--wc-docs-preview-accent)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-docs-preview-accent) 10%, white)"),
                    CSS.decl("color", "#0F4C81")
                ),

                CSS.rule(
                    "\(root)__tab:focus-visible",
                    CSS.decl("outline", "2px solid var(--wc-docs-preview-accent)"),
                    CSS.decl("outline-offset", "2px")
                ),

                CSS.rule(
                    "\(root)__tab-title",
                    CSS.decl("font-size", ".95rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("line-height", "1.25")
                ),

                CSS.rule(
                    "\(root)__tab-summary",
                    CSS.decl("color", "var(--wc-docs-preview-muted)"),
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("line-height", "1.4")
                ),

                CSS.rule(
                    "\(root)__content",
                    CSS.decl("display", "flex"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("background", "var(--wc-docs-preview-surface)")
                ),

                CSS.rule(
                    "\(root)__panels",
                    CSS.decl("min-width", "0"),
                    CSS.decl("height", "410px"),
                    CSS.decl("overflow", "auto"),
                    CSS.decl("overscroll-behavior", "contain"),
                    CSS.decl("scrollbar-width", "thin")
                ),

                CSS.rule(
                    "\(root)__panel",
                    CSS.decl("min-height", "100%")
                ),

                CSS.rule(
                    "\(root)__footer",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "20px"),
                    CSS.decl("min-height", "60px"),
                    CSS.decl("padding", "12px 22px"),
                    CSS.decl("border-top", "1px solid var(--wc-docs-preview-border)"),
                    CSS.decl("background", "var(--wc-docs-preview-soft)")
                ),

                CSS.rule(
                    "\(root)__current",
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("color", "var(--wc-docs-preview-muted)"),
                    CSS.decl("font-size", ".8rem"),
                    CSS.decl("text-overflow", "ellipsis"),
                    CSS.decl("white-space", "nowrap")
                ),

                CSS.rule(
                    "\(root)__destination",
                    CSS.decl("flex", "0 0 auto"),
                    CSS.decl("color", "#0F4C81"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    "\(root)__destination:hover",
                    CSS.decl("color", "var(--wc-docs-preview-accent)"),
                    CSS.decl("text-decoration", "underline")
                ),

                CSS.rule(
                    "\(root)__destination:focus-visible, \(root)__brand:focus-visible",
                    CSS.decl("outline", "2px solid var(--wc-docs-preview-accent)"),
                    CSS.decl("outline-offset", "3px")
                ),

                CSS.rule(
                    "\(root) .wc-docs-scroll-document--embedded",
                    CSS.decl("width", "100%"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "32px 36px 44px"),
                    CSS.decl("color", "var(--wc-docs-preview-ink)")
                ),

                CSS.rule(
                    "\(root) .wc-docs-scroll-document--embedded .wc-docs-scroll-document__hero",
                    CSS.decl("margin-bottom", "30px")
                ),

                CSS.rule(
                    "\(root) .wc-docs-scroll-document--embedded .wc-docs-scroll-document__hero h1",
                    CSS.decl("font-size", "clamp(1.8rem, 4vw, 2.65rem)"),
                    CSS.decl("line-height", "1.02"),
                    CSS.decl("letter-spacing", "-.04em")
                ),

                CSS.rule(
                    "\(root) .wc-docs-scroll-document--embedded .wc-docs-scroll-document__lead",
                    CSS.decl("margin-top", "13px"),
                    CSS.decl("font-size", ".96rem")
                ),

                CSS.rule(
                    "\(root) .wc-docs-scroll-document--embedded .wc-docs-scroll-document__section",
                    CSS.decl("margin-bottom", "34px")
                ),

                CSS.rule(
                    "\(root) .wc-docs-scroll-document--embedded .wc-docs-scroll-document__section-header",
                    CSS.decl("margin-bottom", "20px")
                ),

                CSS.rule(
                    "\(root) .wc-docs-scroll-document--embedded .wc-docs-scroll-document__item",
                    CSS.decl("margin-bottom", "30px")
                ),

                CSS.rule(
                    "\(root) .wc-docs-scroll-document--embedded figure",
                    CSS.decl("max-width", "100%")
                )
            ],

            media: [
                CSS.media(
                    "(max-width: 820px)",

                    CSS.rule(
                        "\(root)__body",
                        CSS.decl("grid-template-columns", "1fr")
                    ),

                    CSS.rule(
                        "\(root)__navigation",
                        CSS.decl("padding", "16px"),
                        CSS.decl("border-right", "0"),
                        CSS.decl("border-bottom", "1px solid var(--wc-docs-preview-border)")
                    ),

                    CSS.rule(
                        "\(root)__tabs",
                        CSS.decl("grid-template-columns", "repeat(3, minmax(0, 1fr))")
                    ),

                    CSS.rule(
                        "\(root)__tab-summary",
                        CSS.decl("display", "none")
                    )
                ),

                CSS.media(
                    "(max-width: 560px)",

                    CSS.rule(
                        root,
                        CSS.decl("border-radius", "14px")
                    ),

                    CSS.rule(
                        "\(root)__toolbar",
                        CSS.decl("padding", "0 15px")
                    ),

                    CSS.rule(
                        "\(root)__brand-product",
                        CSS.decl("display", "none")
                    ),

                    CSS.rule(
                        "\(root)__tabs",
                        CSS.decl("display", "flex"),
                        CSS.decl("overflow-x", "auto"),
                        CSS.decl("scrollbar-width", "thin")
                    ),

                    CSS.rule(
                        "\(root)__tab",
                        CSS.decl("flex", "0 0 168px")
                    ),

                    CSS.rule(
                        "\(root)__panels",
                        CSS.decl("height", "390px")
                    ),

                    CSS.rule(
                        "\(root)__footer",
                        CSS.decl("padding", "12px 16px")
                    ),

                    CSS.rule(
                        "\(root) .wc-docs-scroll-document--embedded",
                        CSS.decl("padding", "25px 18px 36px")
                    )
                ),

                CSS.media(
                    "(prefers-reduced-motion: reduce)",

                    CSS.rule(
                        "\(root)__tab",
                        CSS.decl("transition", "none")
                    )
                )
            ]
        )
    }
}
