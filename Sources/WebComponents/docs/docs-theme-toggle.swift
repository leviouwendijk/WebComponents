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
    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        id: String = "dark-mode-toggle",
        lexicon: DocsLexicon = .english,
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
        self.id = id
        self.lexicon = lexicon
        self.includeStyles = includeStyles
        self.includeScript = includeScript
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.button(
                    [
                        "id": id,
                        "class": Self.block,
                        "type": "button",
                        "data-docs-theme-toggle": "",
                        "data-docs-theme-light-label": lexicon.lightModeLabel,
                        "data-docs-theme-dark-label": lexicon.darkModeLabel
                    ]
                ) {
                    HTML.text(lexicon.darkModeLabel)
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
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("padding", ".42rem .72rem"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("cursor", "pointer")
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
            return {
                light: button.dataset.docsThemeLightLabel || 'Light',
                dark: button.dataset.docsThemeDarkLabel || 'Dark'
            };
        }

        function setButtonLabels(isDark) {
            buttons().forEach((button) => {
                const labels = labelsFor(button);

                button.textContent = isDark ? labels.light : labels.dark;
                button.setAttribute('aria-pressed', isDark ? 'true' : 'false');
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
