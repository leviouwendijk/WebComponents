import CSS

public enum QuizCSS {
    public static func sheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".wc-quiz",
                    CSS.decl("width", "min(980px, calc(100% - 48px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "60px 0 96px"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".wc-quiz__hero",
                    CSS.decl("margin", "0 0 34px")
                ),

                CSS.rule(
                    ".wc-quiz__eyebrow",
                    CSS.decl("margin", "0 0 10px"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz__hero h1",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(2.1rem, 5vw, 4.4rem)"),
                    CSS.decl("line-height", ".98"),
                    CSS.decl("letter-spacing", "-.055em")
                ),

                CSS.rule(
                    ".wc-quiz__lead",
                    CSS.decl("max-width", "740px"),
                    CSS.decl("font-size", "1.05rem"),
                    CSS.decl("line-height", "1.62"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-list",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "1fr"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".wc-quiz-card, .wc-quiz-item",
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("box-shadow", "0 18px 44px rgba(15, 23, 42, .06)")
                ),

                CSS.rule(
                    ".wc-quiz-card",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "58px minmax(0, 1fr)"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("transition", "transform 140ms ease, box-shadow 140ms ease, border-color 140ms ease, background-color 140ms ease")
                ),

                CSS.rule(
                    ".wc-quiz-card:hover",
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("transform", "translateY(-1px)"),
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 38%, var(--border-color))"),
                    CSS.decl("box-shadow", "0 22px 52px rgba(15, 23, 42, .10)")
                ),

                CSS.rule(
                    ".wc-quiz-card:focus-visible",
                    CSS.decl("outline", "2px solid var(--link-color)"),
                    CSS.decl("outline-offset", "3px")
                ),

                CSS.rule(
                    ".wc-quiz-card__index",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("width", "42px"),
                    CSS.decl("height", "42px"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 7%, transparent)"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "620"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-card__body",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".wc-quiz-card__line",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "baseline"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "16px")
                ),

                CSS.rule(
                    ".wc-quiz-card h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.08rem"),
                    CSS.decl("line-height", "1.18"),
                    CSS.decl("letter-spacing", "-.018em")
                ),

                CSS.rule(
                    ".wc-quiz-card p",
                    CSS.decl("margin", "0"),
                    CSS.decl("line-height", "1.48"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-card__meta",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".wc-quiz-card__meta span",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("height", "24px"),
                    CSS.decl("padding", "0 8px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 7%, transparent)"),
                    CSS.decl("font-size", ".74rem"),
                    CSS.decl("font-weight", "680"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-card__action",
                    CSS.decl("flex", "0 0 auto"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("color", "var(--link-color)")
                ),

                CSS.rule(
                    ".wc-quiz-shell[hidden]",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".wc-quiz-shell",
                    CSS.decl("position", "fixed"),
                    CSS.decl("inset", "0"),
                    CSS.decl("z-index", "4000"),
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("padding", "24px"),
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".wc-quiz-backdrop",
                    CSS.decl("position", "absolute"),
                    CSS.decl("inset", "0"),
                    CSS.decl("border", "0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("background", "rgba(15, 23, 42, .54)"),
                    CSS.decl("backdrop-filter", "blur(10px)"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".wc-quiz-panel",
                    CSS.decl("position", "relative"),
                    CSS.decl("z-index", "1"),
                    CSS.decl("width", "min(860px, 100%)"),
                    CSS.decl("max-height", "min(820px, calc(100vh - 48px))"),
                    CSS.decl("overflow", "auto"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("padding", "24px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "28px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("box-shadow", "0 32px 90px rgba(15, 23, 42, .28)")
                ),

                CSS.rule(
                    ".wc-quiz-panel:focus",
                    CSS.decl("outline", "none")
                ),

                CSS.rule(
                    ".wc-quiz-panel:focus-visible",
                    CSS.decl("box-shadow", "0 32px 90px rgba(15, 23, 42, .28), inset 0 0 0 2px color-mix(in srgb, var(--link-color) 42%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-is-open",
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".wc-quiz__back",
                    CSS.decl("appearance", "none"),
                    CSS.decl("border", "0"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("height", "30px"),
                    CSS.decl("padding", "0 12px"),
                    CSS.decl("margin", "0 0 22px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 8%, transparent)"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".wc-quiz__back:hover",
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 12%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-item",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "24px"),
                    CSS.decl("padding", "28px 30px")
                ),

                CSS.rule(
                    ".wc-quiz-panel .wc-quiz-item",
                    CSS.decl("box-shadow", "none")
                ),

                CSS.rule(
                    ".wc-quiz-item__head",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".wc-quiz-item__kicker",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "12px")
                ),

                CSS.rule(
                    ".wc-quiz-item__eyebrow",
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-timer-controls",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "flex-end"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("flex", "0 0 auto"),
                    CSS.decl("margin-left", "auto")
                ),

                CSS.rule(
                    ".wc-quiz-timer",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "7px"),
                    CSS.decl("height", "30px"),
                    CSS.decl("padding", "0 10px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 8%, transparent)"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("white-space", "nowrap")
                ),

                CSS.rule(
                    ".wc-quiz-timer strong",
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-timer[data-quiz-timer-state=\"danger\"]",
                    CSS.decl("background", "color-mix(in srgb, var(--danger, #D64545) 14%, transparent)"),
                    CSS.decl("color", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".wc-quiz-timer[data-quiz-timer-state=\"danger\"] strong",
                    CSS.decl("color", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".wc-quiz-timer[data-quiz-timer-state=\"off\"]",
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 6%, transparent)"),
                    CSS.decl("color", "color-mix(in srgb, var(--muted-text-color) 72%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-timer[data-quiz-timer-state=\"off\"] strong",
                    CSS.decl("color", "color-mix(in srgb, var(--text-color) 54%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-timer-toggle",
                    CSS.decl("appearance", "none"),
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("height", "30px"),
                    CSS.decl("padding", "0 4px 0 10px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--text-color) 10%, transparent)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 5%, transparent)"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "740"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("white-space", "nowrap"),
                    CSS.decl("transition", "background-color 140ms ease, border-color 140ms ease, color 140ms ease")
                ),

                CSS.rule(
                    ".wc-quiz-timer-toggle:hover",
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 8%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-timer-toggle:focus-visible",
                    CSS.decl("outline", "2px solid var(--link-color)"),
                    CSS.decl("outline-offset", "2px")
                ),

                CSS.rule(
                    ".wc-quiz-timer-toggle[aria-checked=\"true\"]",
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 30%, transparent)"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 7%, transparent)"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-timer-toggle__label",
                    CSS.decl("line-height", "1")
                ),

                CSS.rule(
                    ".wc-quiz-timer-toggle__track",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "inline-block"),
                    CSS.decl("width", "38px"),
                    CSS.decl("height", "22px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 16%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--text-color) 8%, transparent)"),
                    CSS.decl("transition", "background-color 140ms ease, box-shadow 140ms ease")
                ),

                CSS.rule(
                    ".wc-quiz-timer-toggle__thumb",
                    CSS.decl("position", "absolute"),
                    CSS.decl("top", "2px"),
                    CSS.decl("left", "2px"),
                    CSS.decl("width", "18px"),
                    CSS.decl("height", "18px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("box-shadow", "0 2px 6px rgba(15, 23, 42, .22)"),
                    CSS.decl("transition", "transform 140ms ease")
                ),

                CSS.rule(
                    ".wc-quiz-timer-toggle[aria-checked=\"true\"] .wc-quiz-timer-toggle__track",
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 76%, var(--text-color) 10%)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--link-color) 28%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-timer-toggle[aria-checked=\"true\"] .wc-quiz-timer-toggle__thumb",
                    CSS.decl("transform", "translateX(16px)")
                ),

                CSS.rule(
                    ".wc-quiz-topic",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("line-height", "1.25"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-item__head h1",
                    CSS.decl("max-width", "780px"),
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(1.65rem, 3.25vw, 2.55rem)"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("letter-spacing", "-.038em")
                ),

                CSS.rule(
                    ".wc-quiz-form",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "20px")
                ),

                CSS.rule(
                    ".wc-quiz-options",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("border", "0")
                ),

                CSS.rule(
                    ".wc-quiz-options__legend",
                    CSS.decl("margin", "0 0 8px"),
                    CSS.decl("padding", "0"),
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-option",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "22px minmax(0, 1fr)"),
                    CSS.decl("gap", "11px"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("padding", "14px 16px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "17px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("transition", "border-color 140ms ease, background-color 140ms ease, box-shadow 140ms ease")
                ),

                CSS.rule(
                    ".wc-quiz-option:hover",
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 34%, var(--border-color))"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--link-color) 6%)")
                ),

                CSS.rule(
                    ".wc-quiz-option input",
                    CSS.decl("width", "18px"),
                    CSS.decl("height", "18px"),
                    CSS.decl("margin", "3px 0 0"),
                    CSS.decl("accent-color", "var(--link-color)")
                ),

                CSS.rule(
                    ".wc-quiz-option__text",
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("line-height", "1.45")
                ),

                CSS.rule(
                    ".wc-quiz-option__note",
                    CSS.decl("grid-column", "2"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("line-height", "1.42"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-option[data-quiz-option-state=\"right\"]",
                    CSS.decl("border-color", "color-mix(in srgb, var(--success, #2E8B57) 44%, var(--border-color))"),
                    CSS.decl("background", "color-mix(in srgb, var(--success, #2E8B57) 10%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-option[data-quiz-option-state=\"wrong\"]",
                    CSS.decl("border-color", "color-mix(in srgb, var(--danger, #D64545) 48%, var(--border-color))"),
                    CSS.decl("background", "color-mix(in srgb, var(--danger, #D64545) 10%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-option input:disabled",
                    CSS.decl("cursor", "not-allowed")
                ),

                CSS.rule(
                    ".wc-quiz-item[data-quiz-locked] .wc-quiz-option",
                    CSS.decl("cursor", "default")
                ),

                CSS.rule(
                    ".wc-quiz-text",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".wc-quiz-text span",
                    CSS.decl("font-weight", "760")
                ),

                CSS.rule(
                    ".wc-quiz-text input",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "48px"),
                    CSS.decl("padding", "0 14px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("font", "inherit")
                ),

                CSS.rule(
                    ".wc-quiz-text input:focus-visible",
                    CSS.decl("outline", "2px solid var(--link-color)"),
                    CSS.decl("outline-offset", "2px")
                ),

                CSS.rule(
                    ".wc-quiz-form__actions",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "12px")
                ),

                CSS.rule(
                    ".wc-quiz-btn",
                    CSS.decl("appearance", "none"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("min-height", "46px"),
                    CSS.decl("padding", "0 20px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".wc-quiz-btn:hover",
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 34%, var(--border-color))")
                ),

                CSS.rule(
                    ".wc-quiz-btn:focus-visible",
                    CSS.decl("outline", "2px solid var(--link-color)"),
                    CSS.decl("outline-offset", "2px")
                ),

                CSS.rule(
                    ".wc-quiz-btn--main",
                    CSS.decl("border-color", "var(--link-color)"),
                    CSS.decl("background", "var(--link-color)"),
                    CSS.decl("color", "white")
                ),

                CSS.rule(
                    ".wc-quiz-btn--reset",
                    CSS.decl("border-color", "transparent"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 6%, transparent)"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-btn--reset:hover",
                    CSS.decl("border-color", "color-mix(in srgb, var(--text-color) 12%, transparent)"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 9%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-feedback",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("border-radius", "18px")
                ),

                CSS.rule(
                    ".wc-quiz-feedback[hidden]",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".wc-quiz-feedback h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.05rem"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".wc-quiz-feedback p",
                    CSS.decl("margin", "0"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-feedback--right",
                    CSS.decl("background", "color-mix(in srgb, var(--success, #2E8B57) 12%, transparent)"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--success, #2E8B57) 28%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-feedback--right h2",
                    CSS.decl("color", "var(--success, #2E8B57)")
                ),

                CSS.rule(
                    ".wc-quiz-feedback--wrong",
                    CSS.decl("background", "color-mix(in srgb, var(--danger, #D64545) 12%, transparent)"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--danger, #D64545) 32%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-feedback--wrong h2",
                    CSS.decl("color", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".wc-quiz-feedback--timeout",
                    CSS.decl("background", "color-mix(in srgb, var(--danger, #D64545) 10%, transparent)"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--danger, #D64545) 28%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-feedback--timeout h2",
                    CSS.decl("color", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".wc-quiz-nav",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(2, minmax(0, 1fr))"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("margin-top", "18px")
                ),

                CSS.rule(
                    ".wc-quiz-nav__link, .wc-quiz-nav__empty",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-nav__link",
                    CSS.decl("font", "inherit"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("text-align", "left")
                ),

                CSS.rule(
                    ".wc-quiz-nav__link:hover",
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 34%, var(--border-color))")
                ),

                CSS.rule(
                    ".wc-quiz-nav__link--next",
                    CSS.decl("text-align", "right")
                ),

                CSS.rule(
                    ".wc-quiz-nav__link span, .wc-quiz-nav__empty",
                    CSS.decl("font-size", ".8rem"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-nav__link strong",
                    CSS.decl("font-size", ".96rem"),
                    CSS.decl("line-height", "1.25")
                ),

                CSS.rule(
                    ".wc-quiz-nav__empty",
                    CSS.decl("opacity", ".64"),
                    CSS.decl("box-shadow", "none"),
                    CSS.decl("background", "transparent")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 760px)",
                    CSS.rule(
                        ".wc-quiz",
                        CSS.decl("width", "calc(100% - 32px)"),
                        CSS.decl("padding", "42px 0 78px")
                    ),

                    CSS.rule(
                        ".wc-quiz-card",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "12px")
                    ),

                    CSS.rule(
                        ".wc-quiz-card__line",
                        CSS.decl("align-items", "flex-start"),
                        CSS.decl("flex-direction", "column"),
                        CSS.decl("gap", "6px")
                    ),

                    CSS.rule(
                        ".wc-quiz-nav",
                        CSS.decl("grid-template-columns", "1fr")
                    ),

                    CSS.rule(
                        ".wc-quiz-nav__link--next",
                        CSS.decl("text-align", "left")
                    ),

                    CSS.rule(
                        ".wc-quiz-shell",
                        CSS.decl("padding", "14px")
                    ),

                    CSS.rule(
                        ".wc-quiz-panel",
                        CSS.decl("max-height", "calc(100vh - 28px)"),
                        CSS.decl("padding", "16px"),
                        CSS.decl("border-radius", "22px")
                    ),

                    CSS.rule(
                        ".wc-quiz-item",
                        CSS.decl("padding", "22px 18px")
                    ),

                    CSS.rule(
                        ".wc-quiz-item__kicker",
                        CSS.decl("align-items", "flex-start"),
                        CSS.decl("flex-direction", "column")
                    ),

                    CSS.rule(
                        ".wc-quiz-timer-controls",
                        CSS.decl("width", "100%"),
                        CSS.decl("justify-content", "space-between"),
                        CSS.decl("margin-left", "0")
                    )
                )
            ]
        )
    }
}
