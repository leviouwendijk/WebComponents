import CSS

public enum PressureDiagrams {
    internal static func commonRules(
        root: String,
        switchRoot: String,
        controls: String,
        button: String,
        stage: String,
        live: String,
        caption: String
    ) -> [CSSRule] {
        [
            CSS.rule(
                ".\(root)",
                CSS.decl("width", "min(920px, 100%)"),
                CSS.decl("margin", "24px 0 30px")
            ),

            CSS.rule(
                ".\(switchRoot)",
                CSS.decl("position", "relative"),
                CSS.decl("display", "grid"),
                CSS.decl("gap", "10px")
            ),

            CSS.rule(
                ".\(controls)",
                CSS.decl("display", "inline-flex"),
                CSS.decl("width", "fit-content"),
                CSS.decl("justify-self", "end"),
                CSS.decl("margin-left", "auto"),
                CSS.decl("align-items", "center"),
                CSS.decl("gap", "4px"),
                CSS.decl("padding", "3px"),
                CSS.decl("border", "1px solid var(--border-color, rgba(0,0,0,0.12))"),
                CSS.decl("border-radius", "999px"),
                CSS.decl("background", "color-mix(in srgb, var(--background-color, #fff) 94%, var(--text-color, #0f172a) 6%)"),
                CSS.decl("box-shadow", "inset 0 1px 0 rgba(255,255,255,.55)"),
                CSS.decl("flex", "0 0 auto")
            ),

            CSS.rule(
                ".\(button)",
                CSS.decl("appearance", "none"),
                CSS.decl("border", "0"),
                CSS.decl("border-radius", "999px"),
                CSS.decl("height", "30px"),
                CSS.decl("padding", "0 12px"),
                CSS.decl("background", "transparent"),
                CSS.decl("color", "color-mix(in srgb, var(--text-color, #0f172a) 62%, transparent)"),
                CSS.decl("font", "inherit"),
                CSS.decl("font-size", ".82rem"),
                CSS.decl("font-weight", "740"),
                CSS.decl("line-height", "30px"),
                CSS.decl("cursor", "pointer"),
                CSS.decl("transition", "background 140ms ease, color 140ms ease, box-shadow 140ms ease")
            ),

            CSS.rule(
                ".\(button):hover",
                CSS.decl("color", "var(--text-color, #0f172a)")
            ),

            CSS.rule(
                ".\(button)[aria-pressed=\"true\"]",
                CSS.decl("background", "var(--text-color, #0f172a)"),
                CSS.decl("color", "var(--background-color, #fff)"),
                CSS.decl("box-shadow", "0 1px 2px rgba(15, 23, 42, .16)")
            ),

            CSS.rule(
                ".\(button):focus-visible",
                CSS.decl("outline", "2px solid color-mix(in srgb, var(--link-color) 70%, transparent)"),
                CSS.decl("outline-offset", "2px")
            ),

            CSS.rule(
                ".\(stage)",
                CSS.decl("box-sizing", "border-box"),
                CSS.decl("max-width", "100%"),
                CSS.decl("padding", "12px"),
                CSS.decl("border", "1px solid var(--border-color)"),
                CSS.decl("border-radius", "18px"),
                CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)"),
                CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)"),
                CSS.decl("overflow", "hidden")
            ),

            CSS.rule(
                ".\(live)",
                CSS.decl("position", "absolute"),
                CSS.decl("width", "1px"),
                CSS.decl("height", "1px"),
                CSS.decl("padding", "0"),
                CSS.decl("margin", "-1px"),
                CSS.decl("overflow", "hidden"),
                CSS.decl("clip", "rect(0, 0, 0, 0)"),
                CSS.decl("white-space", "nowrap"),
                CSS.decl("border", "0")
            ),

            CSS.rule(
                ".\(caption)",
                CSS.decl("margin", "10px 0 0"),
                CSS.decl("font-size", ".9rem"),
                CSS.decl("line-height", "1.48"),
                CSS.decl("color", "var(--muted-text-color)")
            )
        ]
    }
}
