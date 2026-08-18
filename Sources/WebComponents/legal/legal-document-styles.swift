import CSS

public extension LegalDocument {
    static func stylesheet()
        -> CSSStyleSheet
    {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl(
                        "box-sizing",
                        "border-box"
                    ),
                    CSS.decl(
                        "width",
                        "min(880px, 100%)"
                    ),
                    CSS.decl(
                        "margin",
                        "0 auto"
                    ),
                    CSS.decl(
                        "padding",
                        "clamp(24px, 5vw, 56px) clamp(18px, 5vw, 52px)"
                    ),
                    CSS.decl(
                        "color",
                        "var(--wc-legal-ink, var(--text-color, var(--text, #20252b)))"
                    ),
                    CSS.decl(
                        "background",
                        "var(--wc-legal-surface, var(--surface-color, var(--background-color, #ffffff)))"
                    ),
                    CSS.decl(
                        "font-family",
                        "var(--wc-legal-body-font, inherit)"
                    ),
                    CSS.decl(
                        "font-size",
                        "1rem"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.7"
                    ),
                    CSS.decl(
                        "--wc-legal-muted",
                        "var(--muted-text-color, var(--text-muted, #667085))"
                    ),
                    CSS.decl(
                        "--wc-legal-border",
                        "var(--border-color, var(--border, #d9dee7))"
                    ),
                    CSS.decl(
                        "--wc-legal-link",
                        "var(--link-color, var(--accent, #315f7d))"
                    ),
                    CSS.decl(
                        "--wc-legal-soft",
                        "var(--surface-soft-color, color-mix(in srgb, currentColor 4%, transparent))"
                    )
                ),

                CSS.rule(
                    ".\(block) *",
                    CSS.decl(
                        "box-sizing",
                        "border-box"
                    )
                ),

                CSS.rule(
                    ".\(block)__header",
                    CSS.decl(
                        "padding-bottom",
                        "28px"
                    ),
                    CSS.decl(
                        "border-bottom",
                        "1px solid var(--wc-legal-border)"
                    )
                ),

                CSS.rule(
                    ".\(block)__title",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "max-width",
                        "18ch"
                    ),
                    CSS.decl(
                        "font-family",
                        "var(--wc-legal-heading-font, ui-serif, Georgia, Cambria, \"Times New Roman\", serif)"
                    ),
                    CSS.decl(
                        "font-size",
                        "clamp(2.15rem, 6vw, 3.4rem)"
                    ),
                    CSS.decl(
                        "font-weight",
                        "650"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.02"
                    ),
                    CSS.decl(
                        "letter-spacing",
                        "-.035em"
                    ),
                    CSS.decl(
                        "text-wrap",
                        "balance"
                    )
                ),

                CSS.rule(
                    ".\(block)__lead",
                    CSS.decl(
                        "max-width",
                        "68ch"
                    ),
                    CSS.decl(
                        "margin",
                        "16px 0 0"
                    ),
                    CSS.decl(
                        "font-size",
                        "1.06rem"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.65"
                    ),
                    CSS.decl(
                        "color",
                        "var(--wc-legal-muted)"
                    )
                ),

                CSS.rule(
                    ".\(block)__revision",
                    CSS.decl(
                        "display",
                        "flex"
                    ),
                    CSS.decl(
                        "flex-wrap",
                        "wrap"
                    ),
                    CSS.decl(
                        "gap",
                        "8px 26px"
                    ),
                    CSS.decl(
                        "margin",
                        "26px 0 0"
                    ),
                    CSS.decl(
                        "padding",
                        "0"
                    ),
                    CSS.decl(
                        "font-variant-numeric",
                        "tabular-nums"
                    )
                ),

                CSS.rule(
                    ".\(block)__revision-field",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "grid-template-columns",
                        "auto auto"
                    ),
                    CSS.decl(
                        "gap",
                        "8px"
                    ),
                    CSS.decl(
                        "align-items",
                        "baseline"
                    )
                ),

                CSS.rule(
                    ".\(block)__revision dt",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "font-size",
                        ".72rem"
                    ),
                    CSS.decl(
                        "font-weight",
                        "750"
                    ),
                    CSS.decl(
                        "letter-spacing",
                        ".08em"
                    ),
                    CSS.decl(
                        "text-transform",
                        "uppercase"
                    ),
                    CSS.decl(
                        "color",
                        "var(--wc-legal-muted)"
                    )
                ),

                CSS.rule(
                    ".\(block)__revision dd",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "font-size",
                        ".88rem"
                    ),
                    CSS.decl(
                        "font-weight",
                        "600"
                    )
                ),

                CSS.rule(
                    ".\(block)__contents",
                    CSS.decl(
                        "margin",
                        "34px 0 42px"
                    ),
                    CSS.decl(
                        "padding",
                        "22px 0 24px"
                    ),
                    CSS.decl(
                        "border-top",
                        "1px solid var(--wc-legal-border)"
                    ),
                    CSS.decl(
                        "border-bottom",
                        "1px solid var(--wc-legal-border)"
                    )
                ),

                CSS.rule(
                    ".\(block)__contents-title",
                    CSS.decl(
                        "margin",
                        "0 0 12px"
                    ),
                    CSS.decl(
                        "font-size",
                        ".72rem"
                    ),
                    CSS.decl(
                        "font-weight",
                        "800"
                    ),
                    CSS.decl(
                        "letter-spacing",
                        ".09em"
                    ),
                    CSS.decl(
                        "text-transform",
                        "uppercase"
                    ),
                    CSS.decl(
                        "color",
                        "var(--wc-legal-muted)"
                    )
                ),

                CSS.rule(
                    ".\(block)__contents-list",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "grid-template-columns",
                        "repeat(2, minmax(0, 1fr))"
                    ),
                    CSS.decl(
                        "gap",
                        "7px 26px"
                    ),
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "padding-left",
                        "0"
                    ),
                    CSS.decl(
                        "list-style",
                        "none"
                    )
                ),

                CSS.rule(
                    ".\(block)__contents-list li",
                    CSS.decl(
                        "padding-left",
                        "0"
                    ),
                    CSS.decl(
                        "color",
                        "var(--wc-legal-muted)"
                    )
                ),

                CSS.rule(
                    ".\(block)__contents-list a",
                    CSS.decl(
                        "color",
                        "var(--wc-legal-link)"
                    ),
                    CSS.decl(
                        "text-decoration",
                        "none"
                    )
                ),

                CSS.rule(
                    """
                    .\(block)__contents-list a:hover, \
                    .\(block)__contents-list a:focus-visible
                    """,
                    CSS.decl(
                        "text-decoration",
                        "underline"
                    ),
                    CSS.decl(
                        "text-underline-offset",
                        "3px"
                    )
                ),

                CSS.rule(
                    ".\(block)__section",
                    CSS.decl(
                        "padding",
                        "34px 0 38px"
                    ),
                    CSS.decl(
                        "scroll-margin-top",
                        "88px"
                    )
                ),

                CSS.rule(
                    """
                    .\(block)__section + \
                    .\(block)__section
                    """,
                    CSS.decl(
                        "border-top",
                        "1px solid var(--wc-legal-border)"
                    )
                ),

                CSS.rule(
                    ".\(block)__section-heading",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "grid-template-columns",
                        "auto minmax(0, 1fr)"
                    ),
                    CSS.decl(
                        "column-gap",
                        "18px"
                    ),
                    CSS.decl(
                        "align-items",
                        "baseline"
                    ),
                    CSS.decl(
                        "margin",
                        "0 0 19px"
                    ),
                    CSS.decl(
                        "font-family",
                        "var(--wc-legal-heading-font, ui-serif, Georgia, Cambria, \"Times New Roman\", serif)"
                    ),
                    CSS.decl(
                        "font-size",
                        "clamp(1.28rem, 3vw, 1.62rem)"
                    ),
                    CSS.decl(
                        "font-weight",
                        "650"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.22"
                    ),
                    CSS.decl(
                        "letter-spacing",
                        "-.018em"
                    ),
                    CSS.decl(
                        "text-wrap",
                        "balance"
                    )
                ),

                CSS.rule(
                    ".\(block)__section-number",
                    CSS.decl(
                        "font-variant-numeric",
                        "tabular-nums"
                    ),
                    CSS.decl(
                        "white-space",
                        "nowrap"
                    ),
                    CSS.decl(
                        "color",
                        "var(--wc-legal-muted)"
                    )
                ),

                CSS.rule(
                    ".\(block)__section-body",
                    CSS.decl(
                        "max-width",
                        "76ch"
                    )
                ),

                CSS.rule(
                    """
                    .\(block)__section-body \
                    > :first-child
                    """,
                    CSS.decl(
                        "margin-top",
                        "0"
                    )
                ),

                CSS.rule(
                    """
                    .\(block)__section-body \
                    > :last-child
                    """,
                    CSS.decl(
                        "margin-bottom",
                        "0"
                    )
                ),

                CSS.rule(
                    ".\(block)__section-body p",
                    CSS.decl(
                        "margin",
                        "0 0 1rem"
                    )
                ),

                CSS.rule(
                    """
                    .\(block)__section-body ul, \
                    .\(block)__section-body ol
                    """,
                    CSS.decl(
                        "margin",
                        ".7rem 0 1.15rem"
                    ),
                    CSS.decl(
                        "padding-left",
                        "1.35rem"
                    )
                ),

                CSS.rule(
                    """
                    .\(block)__section-body \
                    li + li
                    """,
                    CSS.decl(
                        "margin-top",
                        ".45rem"
                    )
                ),

                CSS.rule(
                    """
                    .\(block)__section-ref, \
                    .\(block)__definition-ref
                    """,
                    CSS.decl(
                        "color",
                        "var(--wc-legal-link)"
                    ),
                    CSS.decl(
                        "text-decoration",
                        "underline"
                    ),
                    CSS.decl(
                        "text-decoration-thickness",
                        "1px"
                    ),
                    CSS.decl(
                        "text-underline-offset",
                        "3px"
                    )
                ),

                CSS.rule(
                    ".\(block)__definition-ref",
                    CSS.decl(
                        "text-decoration-style",
                        "dotted"
                    )
                ),

                CSS.rule(
                    ".\(block)__definition-ref-wrap",
                    CSS.decl(
                        "position",
                        "relative"
                    ),
                    CSS.decl(
                        "display",
                        "inline"
                    )
                ),

                CSS.rule(
                    ".\(block)__definition-preview",
                    CSS.decl(
                        "position",
                        "absolute"
                    ),
                    CSS.decl(
                        "left",
                        "0"
                    ),
                    CSS.decl(
                        "bottom",
                        "calc(100% + 10px)"
                    ),
                    CSS.decl(
                        "z-index",
                        "50"
                    ),
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "gap",
                        "4px"
                    ),
                    CSS.decl(
                        "width",
                        "min(360px, 82vw)"
                    ),
                    CSS.decl(
                        "padding",
                        "12px 14px"
                    ),
                    CSS.decl(
                        "border",
                        "1px solid var(--wc-legal-border)"
                    ),
                    CSS.decl(
                        "border-radius",
                        "10px"
                    ),
                    CSS.decl(
                        "background",
                        "var(--wc-legal-surface)"
                    ),
                    CSS.decl(
                        "box-shadow",
                        "0 16px 42px rgba(15, 23, 42, .14)"
                    ),
                    CSS.decl(
                        "color",
                        "var(--wc-legal-ink)"
                    ),
                    CSS.decl(
                        "opacity",
                        "0"
                    ),
                    CSS.decl(
                        "visibility",
                        "hidden"
                    ),
                    CSS.decl(
                        "pointer-events",
                        "none"
                    ),
                    CSS.decl(
                        "transform",
                        "translateY(5px)"
                    ),
                    CSS.decl(
                        "transition",
                        """
                        opacity 120ms ease, \
                        transform 120ms ease, \
                        visibility 0s linear 120ms
                        """
                    )
                ),

                CSS.rule(
                    """
                    .\(block)__definition-ref-wrap:hover \
                    .\(block)__definition-preview, \
                    .\(block)__definition-ref-wrap:focus-within \
                    .\(block)__definition-preview
                    """,
                    CSS.decl(
                        "opacity",
                        "1"
                    ),
                    CSS.decl(
                        "visibility",
                        "visible"
                    ),
                    CSS.decl(
                        "transform",
                        "translateY(0)"
                    ),
                    CSS.decl(
                        "transition",
                        """
                        opacity 120ms ease, \
                        transform 120ms ease, \
                        visibility 0s
                        """
                    )
                ),

                CSS.rule(
                    ".\(block)__definition-preview-term",
                    CSS.decl(
                        "font-size",
                        ".9rem"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.25"
                    )
                ),

                CSS.rule(
                    ".\(block)__definition-preview-meaning",
                    CSS.decl(
                        "font-size",
                        ".82rem"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.45"
                    ),
                    CSS.decl(
                        "color",
                        "var(--wc-legal-muted)"
                    )
                ),

                CSS.rule(
                    ".\(block)__definitions",
                    CSS.decl(
                        "margin",
                        "1.15rem 0 0"
                    ),
                    CSS.decl(
                        "padding",
                        "0"
                    )
                ),

                CSS.rule(
                    ".\(block)__definition",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "grid-template-columns",
                        "minmax(130px, .34fr) minmax(0, 1fr)"
                    ),
                    CSS.decl(
                        "gap",
                        "18px 28px"
                    ),
                    CSS.decl(
                        "padding",
                        "17px 0"
                    ),
                    CSS.decl(
                        "border-top",
                        "1px solid var(--wc-legal-border)"
                    ),
                    CSS.decl(
                        "scroll-margin-top",
                        "88px"
                    )
                ),

                CSS.rule(
                    ".\(block)__definition-term",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "font-family",
                        "var(--wc-legal-heading-font, ui-serif, Georgia, Cambria, \"Times New Roman\", serif)"
                    ),
                    CSS.decl(
                        "font-weight",
                        "650"
                    )
                ),

                CSS.rule(
                    ".\(block)__definition-term dfn",
                    CSS.decl(
                        "font-style",
                        "normal"
                    )
                ),

                CSS.rule(
                    ".\(block)__definition-body",
                    CSS.decl(
                        "margin",
                        "0"
                    )
                ),

                CSS.rule(
                    ".\(block)__definition-meaning",
                    CSS.decl(
                        "margin",
                        "0"
                    )
                ),

                CSS.rule(
                    """
                    .\(block)__definition-body \
                    > :first-child
                    """,
                    CSS.decl(
                        "margin-top",
                        "0"
                    )
                ),

                CSS.rule(
                    """
                    .\(block)__definition-body \
                    > :last-child
                    """,
                    CSS.decl(
                        "margin-bottom",
                        "0"
                    )
                ),

                CSS.rule(
                    ".\(block)__unresolved-ref",
                    CSS.decl(
                        "padding",
                        "0 .2em"
                    ),
                    CSS.decl(
                        "border-radius",
                        "4px"
                    ),
                    CSS.decl(
                        "background",
                        "color-mix(in srgb, #b42318 10%, transparent)"
                    ),
                    CSS.decl(
                        "color",
                        "#b42318"
                    ),
                    CSS.decl(
                        "font-family",
                        "ui-monospace, SFMono-Regular, Menlo, monospace"
                    ),
                    CSS.decl(
                        "font-size",
                        ".9em"
                    )
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 700px)",
                    CSS.rule(
                        ".\(block)__contents-list",
                        CSS.decl(
                            "grid-template-columns",
                            "1fr"
                        )
                    ),
                    CSS.rule(
                        ".\(block)__definition",
                        CSS.decl(
                            "grid-template-columns",
                            "1fr"
                        ),
                        CSS.decl(
                            "gap",
                            "6px"
                        )
                    )
                )
            ]
        )
    }
}
