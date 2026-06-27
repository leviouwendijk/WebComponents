import Constructors
import CSS
import HTML
import JS

public struct DocsReadingControls: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-reading-controls"

    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
        self.includeStyles = includeStyles
        self.includeScript = includeScript
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.div(
                    [
                        "class": Self.block,
                        "data-docs-reading-controls": "",
                        "aria-label": "Leesvoorkeuren"
                    ]
                ) {
                    HTML.div(
                        [
                            "class": "\(Self.block)__group",
                            "role": "group",
                            "aria-label": "Tekstgrootte"
                        ]
                    ) {
                        controlButton(
                            label: "−",
                            attrs: [
                                "data-docs-reading-scale": "small",
                                "aria-label": "Tekst kleiner"
                            ]
                        )

                        controlButton(
                            label: "Aa",
                            attrs: [
                                "data-docs-reading-scale": "normal",
                                "aria-label": "Normale tekstgrootte"
                            ]
                        )

                        controlButton(
                            label: "+",
                            attrs: [
                                "data-docs-reading-scale": "large",
                                "aria-label": "Tekst groter"
                            ]
                        )
                    }

                    HTML.div(
                        [
                            "class": "\(Self.block)__group",
                            "role": "group",
                            "aria-label": "Tekstweergave"
                        ]
                    ) {
                        controlButton(
                            label: "Modern",
                            attrs: [
                                "data-docs-reading-paragraph": "spaced",
                                "aria-label": "Ruime tekstweergave"
                            ]
                        )

                        controlButton(
                            label: "Klassiek",
                            attrs: [
                                "data-docs-reading-paragraph": "book",
                                "aria-label": "Boekzetting"
                            ]
                        )
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : [],
            scripts: includeScript ? DocsReadingPreferencesScript().nodes.scripts : []
        )
    }

    private func controlButton(
        label: String,
        attrs: HTMLAttribute
    ) -> any HTMLNode {
        var next = attrs

        next.merge([
            "class": "\(Self.block)__button",
            "type": "button"
        ])

        return HTML.button(next) {
            HTML.text(label)
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("margin", "0 0 28px"),
                    CSS.decl("padding", "10px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)")
                ),

                CSS.rule(
                    ".\(block)__group",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "6px")
                ),

                CSS.rule(
                    ".\(block)__button",
                    CSS.decl("appearance", "none"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("padding", ".42rem .68rem"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(block)__button:hover",
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 8%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__button[aria-pressed=\"true\"]",
                    CSS.decl("background", "var(--text-color)"),
                    CSS.decl("border-color", "var(--text-color)"),
                    CSS.decl("color", "var(--background-color)")
                )
            ]
        )
    }
}

public struct DocsReadingPreferencesScript: ReusableComponent {
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
        if (window.docsReading?.initialized) return;

        const storageKey = 'docs_reading_preferences_v1';
        const rootSelector = '[data-wc-docs-scroll-document][data-docs-reading="enabled"]';

        function roots() {
            return Array.from(document.querySelectorAll(rootSelector));
        }

        function controls() {
            return Array.from(document.querySelectorAll('[data-docs-reading-controls]'));
        }

        function readSaved() {
            try {
                const raw = localStorage.getItem(storageKey);
                if (!raw) return null;

                return JSON.parse(raw);
            } catch {
                return null;
            }
        }

        function defaults() {
            const root = roots()[0];

            return {
                scale: root?.getAttribute('data-docs-default-text-scale') || 'normal',
                paragraph: root?.getAttribute('data-docs-default-paragraph-mode') || 'spaced'
            };
        }

        function normalized(input) {
            const fallback = defaults();

            return {
                scale: ['small', 'normal', 'large'].includes(input?.scale)
                    ? input.scale
                    : fallback.scale,
                paragraph: ['spaced', 'book'].includes(input?.paragraph)
                    ? input.paragraph
                    : fallback.paragraph
            };
        }

        function setButtons(preferences) {
            controls().forEach((control) => {
                control.querySelectorAll('[data-docs-reading-scale]').forEach((button) => {
                    const active = button.getAttribute('data-docs-reading-scale') === preferences.scale;
                    button.setAttribute('aria-pressed', active ? 'true' : 'false');
                });

                control.querySelectorAll('[data-docs-reading-paragraph]').forEach((button) => {
                    const active = button.getAttribute('data-docs-reading-paragraph') === preferences.paragraph;
                    button.setAttribute('aria-pressed', active ? 'true' : 'false');
                });
            });
        }

        function apply(input, persist = false) {
            const preferences = normalized(input);

            roots().forEach((root) => {
                root.setAttribute('data-docs-text-scale', preferences.scale);
                root.setAttribute('data-docs-paragraph-mode', preferences.paragraph);
            });

            setButtons(preferences);

            if (persist) {
                localStorage.setItem(storageKey, JSON.stringify(preferences));
            }

            return preferences;
        }

        function current() {
            const root = roots()[0];

            return normalized({
                scale: root?.getAttribute('data-docs-text-scale'),
                paragraph: root?.getAttribute('data-docs-paragraph-mode')
            });
        }

        function init() {
            apply(readSaved() || defaults());

            document.addEventListener('click', (event) => {
                const scaleButton = event.target.closest?.('[data-docs-reading-scale]');
                if (scaleButton) {
                    event.preventDefault();

                    apply(
                        {
                            ...current(),
                            scale: scaleButton.getAttribute('data-docs-reading-scale')
                        },
                        true
                    );

                    return;
                }

                const paragraphButton = event.target.closest?.('[data-docs-reading-paragraph]');
                if (paragraphButton) {
                    event.preventDefault();

                    apply(
                        {
                            ...current(),
                            paragraph: paragraphButton.getAttribute('data-docs-reading-paragraph')
                        },
                        true
                    );
                }
            }, true);
        }

        window.docsReading = {
            initialized: true,
            init,
            apply,
            current
        };

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init);
        } else {
            init();
        }
    })();
    """#
}
