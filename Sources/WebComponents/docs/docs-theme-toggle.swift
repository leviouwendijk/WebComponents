import Constructors
import CSS
import HTML
import JS

public struct DocsThemeToggle: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-theme-toggle"

    public let id: String
    public let lexicon: DocsLexicon
    public let labelStyle: DocsThemeToggleLabelStyle
    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        id: String = "dark-mode-toggle",
        lexicon: DocsLexicon = .english,
        labelStyle: DocsThemeToggleLabelStyle? = nil,
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
        self.id = id
        self.lexicon = lexicon
        self.labelStyle = labelStyle ?? lexicon.themeToggleLabelStyle
        self.includeStyles = includeStyles
        self.includeScript = includeScript
    }

    public var nodes: ReusableComponentNodes {
        let lightDisplayLabel = lexicon.lightModeDisplayLabel(
            style: labelStyle
        )

        let darkDisplayLabel = lexicon.darkModeDisplayLabel(
            style: labelStyle
        )

        return .body(
            [
                HTML.button(
                    [
                        "id": id,
                        "class": Self.block,
                        "type": "button",
                        "aria-label": lexicon.darkModeLabel,
                        "aria-pressed": "false",
                        "title": lexicon.darkModeLabel,
                        "data-docs-theme-toggle": "",
                        "data-docs-theme-label-style": labelStyle.rawValue,
                        "data-docs-theme-light-label": lexicon.lightModeLabel,
                        "data-docs-theme-dark-label": lexicon.darkModeLabel,
                        "data-docs-theme-light-display": lightDisplayLabel,
                        "data-docs-theme-dark-display": darkDisplayLabel
                    ]
                ) {
                    HTML.text(darkDisplayLabel)
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : [],
            scripts: includeScript ? DocsThemeScript().nodes.scripts : []
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("appearance", "none"),
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("min-width", "2.25rem"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("padding", ".42rem .72rem"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("font-variant-emoji", "text"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(block)[data-docs-theme-label-style=\"words\"]",
                    CSS.decl("font-size", ".82rem")
                ),

                CSS.rule(
                    ".\(block):hover",
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 8%, transparent)")
                )
            ]
        )
    }
}

public struct DocsThemeScript: ReusableComponent {
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
        if (window.docsTheme?.initialized) return;

        const storageKey = 'theme';

        function buttons() {
            return Array.from(
                document.querySelectorAll('#dark-mode-toggle, [data-docs-theme-toggle]')
            );
        }

        function labelsFor(button) {
            const lightLabel = button.dataset.docsThemeLightLabel || 'Light';
            const darkLabel = button.dataset.docsThemeDarkLabel || 'Dark';

            return {
                lightDisplay: button.dataset.docsThemeLightDisplay || lightLabel,
                darkDisplay: button.dataset.docsThemeDarkDisplay || darkLabel,
                lightLabel,
                darkLabel
            };
        }

        function setButtonLabels(isDark) {
            buttons().forEach((button) => {
                const labels = labelsFor(button);
                const displayLabel = isDark ? labels.lightDisplay : labels.darkDisplay;
                const accessibilityLabel = isDark ? labels.lightLabel : labels.darkLabel;

                button.textContent = displayLabel;
                button.setAttribute('aria-label', accessibilityLabel);
                button.setAttribute('title', accessibilityLabel);
                button.setAttribute('aria-pressed', isDark ? 'true' : 'false');
                button.dataset.docsThemeCurrent = isDark ? 'dark' : 'light';
            });
        }

        function apply(theme) {
            const isDark = theme === 'dark';

            document.documentElement.classList.toggle('dark-mode', isDark);
            localStorage.setItem(storageKey, isDark ? 'dark' : 'light');
            setButtonLabels(isDark);
        }

        function current() {
            return document.documentElement.classList.contains('dark-mode') ? 'dark' : 'light';
        }

        function toggle() {
            apply(current() === 'dark' ? 'light' : 'dark');
        }

        function init() {
            const saved = localStorage.getItem(storageKey);

            if (saved === 'dark') {
                apply('dark');
            } else {
                apply('light');
            }

            document.addEventListener('click', (event) => {
                const button = event.target.closest?.('#dark-mode-toggle, [data-docs-theme-toggle]');
                if (!button) return;

                event.preventDefault();
                toggle();
            }, true);
        }

        window.docsTheme = {
            initialized: true,
            init,
            apply,
            toggle,
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
