import CSS

enum QuizRuntimePanelStyles {
    static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
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
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("box-shadow", "0 18px 44px rgba(15, 23, 42, .06)")
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
                    ".wc-quiz-prior",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("width", "fit-content"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("padding", "8px 10px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 6%, transparent)"),
                    CSS.decl("font-size", ".86rem"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-prior[hidden]",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".wc-quiz-prior[data-quiz-prior-state=\"right\"]",
                    CSS.decl("border-color", "color-mix(in srgb, var(--success, #2E8B57) 30%, var(--border-color))"),
                    CSS.decl("background", "color-mix(in srgb, var(--success, #2E8B57) 10%, transparent)"),
                    CSS.decl("color", "var(--success, #2E8B57)")
                ),

                CSS.rule(
                    ".wc-quiz-prior[data-quiz-prior-state=\"wrong\"]",
                    CSS.decl("border-color", "color-mix(in srgb, var(--danger, #D64545) 30%, var(--border-color))"),
                    CSS.decl("background", "color-mix(in srgb, var(--danger, #D64545) 9%, transparent)"),
                    CSS.decl("color", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".wc-quiz-prior[data-quiz-prior-state=\"timeout\"]",
                    CSS.decl("border-color", "color-mix(in srgb, var(--danger, #D64545) 24%, var(--border-color))"),
                    CSS.decl("background", "color-mix(in srgb, var(--danger, #D64545) 8%, transparent)"),
                    CSS.decl("color", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".wc-quiz-hints",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("justify-items", "start")
                ),

                CSS.rule(
                    ".wc-quiz-hints__button",
                    CSS.decl("appearance", "none"),
                    CSS.decl("height", "34px"),
                    CSS.decl("padding", "0 13px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--link-color) 26%, var(--border-color))"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 7%, transparent)"),
                    CSS.decl("color", "var(--link-color)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".wc-quiz-hints__button:hover",
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 11%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-hints__button:disabled",
                    CSS.decl("opacity", ".52"),
                    CSS.decl("cursor", "default")
                ),

                CSS.rule(
                    ".wc-quiz-hints__list",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("max-width", "720px"),
                    CSS.decl("padding", "12px 14px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--link-color) 22%, var(--border-color))"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 6%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-hints__list[hidden]",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".wc-quiz-hints__list p",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.5"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".wc-quiz-hints__list strong",
                    CSS.decl("font-size", ".86rem")
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
                    ".wc-quiz-btn:disabled",
                    CSS.decl("opacity", ".48"),
                    CSS.decl("cursor", "not-allowed")
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
                    ".wc-quiz-btn--clear",
                    CSS.decl("border-color", "color-mix(in srgb, var(--danger, #D64545) 20%, var(--border-color))"),
                    CSS.decl("background", "color-mix(in srgb, var(--danger, #D64545) 6%, transparent)"),
                    CSS.decl("color", "var(--danger, #D64545)")
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
                    ".wc-quiz-feedback__details",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("margin-top", "8px"),
                    CSS.decl("padding-top", "10px"),
                    CSS.decl("border-top", "1px solid color-mix(in srgb, var(--text-color) 10%, transparent)")
                ),

                CSS.rule(
                    ".wc-quiz-feedback__details h3",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".wc-quiz-feedback__details ul",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("list-style", "none")
                ),

                CSS.rule(
                    ".wc-quiz-feedback__details li",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "3px")
                ),

                CSS.rule(
                    ".wc-quiz-feedback__details strong",
                    CSS.decl("font-size", ".88rem"),
                    CSS.decl("line-height", "1.3")
                ),

                CSS.rule(
                    ".wc-quiz-feedback__details span",
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.45"),
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
                        ".wc-quiz-nav",
                        CSS.decl("grid-template-columns", "1fr")
                    ),

                    CSS.rule(
                        ".wc-quiz-nav__link--next",
                        CSS.decl("text-align", "left")
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
