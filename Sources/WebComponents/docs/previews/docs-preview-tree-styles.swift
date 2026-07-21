import CSS

extension DocsPreviewTree {
    public static func stylesheet() -> CSSStyleSheet {
        let root = ".wc-docs-preview-tree"

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    root,
                    CSS.decl("--background-color", "#ffffff"),
                    CSS.decl("--surface-color", "#ffffff"),
                    CSS.decl("--surface-soft-color", "#f5f7f9"),
                    CSS.decl("--text-color", "#172536"),
                    CSS.decl("--muted-text-color", "#687786"),
                    CSS.decl("--border-color", "#dbe4eb"),
                    CSS.decl("--link-color", "#1769aa"),
                    CSS.decl("--header-bg-color", "#f8fafc"),
                    CSS.decl("width", "100%"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--background-color)"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl(
                        "box-shadow",
                        "0 20px 56px rgba(15, 23, 42, .10)"
                    ),
                    CSS.decl(
                        "font-family",
                        "\"Instrument Sans\", system-ui, sans-serif"
                    )
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
                    "\(root) .wc-docs-project-context-nav",
                    CSS.decl("position", "relative"),
                    CSS.decl("top", "auto"),
                    CSS.decl("z-index", "3")
                ),

                CSS.rule(
                    "\(root) .wc-docs-project-context-nav__inner",
                    CSS.decl("width", "calc(100% - 32px)")
                ),

                CSS.rule(
                    "\(root)__viewport",
                    CSS.decl("display", "grid"),
                    CSS.decl(
                        "grid-template-columns",
                        "minmax(300px, 42%) minmax(0, 1fr)"
                    ),
                    CSS.decl("height", "460px"),
                    CSS.decl("min-height", "0")
                ),

                CSS.rule(
                    "\(root)__navigation",
                    CSS.decl("min-width", "0"),
                    CSS.decl("overflow", "auto"),
                    CSS.decl("padding", "18px 12px 26px"),
                    CSS.decl(
                        "border-right",
                        "1px solid var(--border-color)"
                    ),
                    CSS.decl(
                        "background",
                        "var(--surface-soft-color)"
                    ),
                    CSS.decl("overscroll-behavior", "contain"),
                    CSS.decl("scrollbar-width", "thin")
                ),

                CSS.rule(
                    "\(root)__tree, \(root)__branch",
                    CSS.decl("padding", "0"),
                    CSS.decl("margin", "0"),
                    CSS.decl("list-style", "none")
                ),

                CSS.rule(
                    "\(root)__node-row",
                    CSS.decl("display", "grid"),
                    CSS.decl(
                        "grid-template-columns",
                        "24px minmax(0, 1fr) 30px"
                    ),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "4px"),
                    CSS.decl(
                        "padding-left",
                        "calc(var(--wc-docs-preview-tree-depth) * 15px)"
                    ),
                    CSS.decl("border-radius", "10px")
                ),

                CSS.rule(
                    "\(root)__tree-item[aria-selected=\"true\"] > \(root)__node-row",
                    CSS.decl(
                        "background",
                        "color-mix(in srgb, var(--link-color) 10%, transparent)"
                    ),
                    CSS.decl(
                        "box-shadow",
                        "inset 3px 0 0 var(--link-color)"
                    )
                ),

                CSS.rule(
                    "\(root)__toggle, \(root)__toggle-placeholder",
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "24px"),
                    CSS.decl("height", "32px")
                ),

                CSS.rule(
                    "\(root)__toggle",
                    CSS.decl("padding", "0"),
                    CSS.decl("border", "0"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    "\(root)__toggle span",
                    CSS.decl("transition", "transform .16s ease")
                ),

                CSS.rule(
                    "\(root)__toggle[aria-expanded=\"true\"] span",
                    CSS.decl("transform", "rotate(90deg)")
                ),

                CSS.rule(
                    "\(root)__select",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "2px"),
                    CSS.decl("width", "100%"),
                    CSS.decl("padding", "9px 7px"),
                    CSS.decl("border", "0"),
                    CSS.decl("border-radius", "8px"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("color", "inherit"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("text-align", "left"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    "\(root)__node-kind",
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("font-size", ".63rem"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase")
                ),

                CSS.rule(
                    "\(root)__node-title",
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "690"),
                    CSS.decl("line-height", "1.25"),
                    CSS.decl("text-overflow", "ellipsis"),
                    CSS.decl("white-space", "nowrap")
                ),

                CSS.rule(
                    "\(root)__node-open",
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "28px"),
                    CSS.decl("height", "28px"),
                    CSS.decl("border-radius", "8px"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    "\(root)__node-open:hover",
                    CSS.decl("background", "var(--surface-color)"),
                    CSS.decl("color", "var(--link-color)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    "\(root)__toggle:focus-visible, \(root)__select:focus-visible, \(root)__node-open:focus-visible",
                    CSS.decl("outline", "2px solid var(--link-color)"),
                    CSS.decl("outline-offset", "1px")
                ),

                CSS.rule(
                    "\(root)__inspector",
                    CSS.decl("min-width", "0"),
                    CSS.decl("overflow", "auto"),
                    CSS.decl("padding", "clamp(26px, 4vw, 46px)"),
                    CSS.decl("background", "var(--surface-color)"),
                    CSS.decl("overscroll-behavior", "contain"),
                    CSS.decl("scrollbar-width", "thin")
                ),

                CSS.rule(
                    "\(root)__panel-kind",
                    CSS.decl("margin", "0 0 8px"),
                    CSS.decl("color", "var(--link-color)"),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".1em"),
                    CSS.decl("text-transform", "uppercase")
                ),

                CSS.rule(
                    "\(root)__panel-title",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(1.65rem, 3vw, 2.4rem)"),
                    CSS.decl("line-height", "1.08"),
                    CSS.decl("letter-spacing", "-.035em")
                ),

                CSS.rule(
                    "\(root)__path",
                    CSS.decl("margin", "12px 0 0"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("line-height", "1.45")
                ),

                CSS.rule(
                    "\(root)__summary",
                    CSS.decl("max-width", "62ch"),
                    CSS.decl("margin", "24px 0 0"),
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("line-height", "1.65")
                ),

                CSS.rule(
                    "\(root)__metrics",
                    CSS.decl("display", "grid"),
                    CSS.decl(
                        "grid-template-columns",
                        "repeat(2, minmax(0, 1fr))"
                    ),
                    CSS.decl("gap", "12px"),
                    CSS.decl("margin-top", "28px")
                ),

                CSS.rule(
                    "\(root)__metric",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("padding", "15px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl(
                        "background",
                        "var(--surface-soft-color)"
                    )
                ),

                CSS.rule(
                    "\(root)__metric-value",
                    CSS.decl("font-size", "1.35rem"),
                    CSS.decl("font-weight", "760")
                ),

                CSS.rule(
                    "\(root)__metric-label",
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("font-size", ".72rem")
                ),

                CSS.rule(
                    "\(root)__children",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("margin-top", "24px")
                ),

                CSS.rule(
                    "\(root)__child",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("width", "100%"),
                    CSS.decl("padding", "11px 13px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "10px"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("text-align", "left"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    "\(root)__child:hover",
                    CSS.decl(
                        "background",
                        "var(--surface-soft-color)"
                    ),
                    CSS.decl("border-color", "var(--link-color)")
                ),

                CSS.rule(
                    "\(root)__unavailable",
                    CSS.decl("margin", "22px 0 0"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("font-size", ".78rem")
                ),

                CSS.rule(
                    "\(root)__footer",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("min-height", "58px"),
                    CSS.decl("padding", "12px 20px"),
                    CSS.decl("border-top", "1px solid var(--border-color)"),
                    CSS.decl(
                        "background",
                        "var(--surface-soft-color)"
                    )
                ),

                CSS.rule(
                    "\(root)__current",
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("font-size", ".8rem"),
                    CSS.decl("text-overflow", "ellipsis"),
                    CSS.decl("white-space", "nowrap")
                ),

                CSS.rule(
                    "\(root)__destination",
                    CSS.decl("flex", "0 0 auto"),
                    CSS.decl("color", "var(--link-color)"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    "\(root)__destination:hover",
                    CSS.decl("text-decoration", "underline")
                ),

                CSS.rule(
                    "\(root)__visually-hidden",
                    CSS.decl("position", "absolute"),
                    CSS.decl("width", "1px"),
                    CSS.decl("height", "1px"),
                    CSS.decl("padding", "0"),
                    CSS.decl("margin", "-1px"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("clip", "rect(0, 0, 0, 0)"),
                    CSS.decl("white-space", "nowrap"),
                    CSS.decl("border", "0")
                )
            ],

            media: [
                CSS.media(
                    "(max-width: 760px)",

                    CSS.rule(
                        "\(root)__viewport",
                        CSS.decl(
                            "grid-template-columns",
                            "minmax(0, 1fr)"
                        ),
                        CSS.decl(
                            "grid-template-rows",
                            "auto auto"
                        ),
                        CSS.decl("height", "auto")
                    ),

                    CSS.rule(
                        "\(root)__navigation",
                        CSS.decl("overflow", "visible"),
                        CSS.decl(
                            "overscroll-behavior",
                            "auto"
                        ),
                        CSS.decl("border-right", "0"),
                        CSS.decl(
                            "border-bottom",
                            "1px solid var(--border-color)"
                        )
                    ),

                    CSS.rule(
                        "\(root)__inspector",
                        CSS.decl("overflow", "visible"),
                        CSS.decl(
                            "overscroll-behavior",
                            "auto"
                        ),
                        CSS.decl("padding", "24px 20px")
                    )
                ),

                CSS.media(
                    "(max-width: 520px)",

                    CSS.rule(
                        root,
                        CSS.decl("border-radius", "14px")
                    ),

                    CSS.rule(
                        "\(root)__metrics",
                        CSS.decl(
                            "grid-template-columns",
                            "minmax(0, 1fr)"
                        )
                    ),

                    CSS.rule(
                        "\(root)__footer",
                        CSS.decl("padding", "11px 15px")
                    )
                ),

                CSS.media(
                    "(prefers-reduced-motion: reduce)",

                    CSS.rule(
                        "\(root)__toggle span",
                        CSS.decl("transition", "none")
                    )
                )
            ]
        )
    }
}
