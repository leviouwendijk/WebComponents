import Constructors
import CSS
import JS

public struct DocsFuzzySearchScript: ReusableComponent {
    public init() {}

    public var nodes: ReusableComponentNodes {
        .init(
            scripts: [
                JSSource(Self.source).as_inline_script()
            ]
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    "[data-docs-search-item][hidden], .docs-hub-card[hidden], .docs-project-card[hidden]",
                    CSS.decl("display", "none")
                )
            ]
        )
    }

    private static let source = #"""
    (() => {
        if (window.wcDocsFuzzySearch?.initialized) return;

        function normalize(value) {
            return String(value || '')
                .toLowerCase()
                .normalize('NFD')
                .replace(/[\u0300-\u036f]/g, '')
                .replace(/[^a-z0-9]+/g, ' ')
                .trim();
        }

        function compact(value) {
            return normalize(value).replace(/\s+/g, '');
        }

        function scoreNeedleAgainstHaystack(needle, haystack) {
            if (!needle) return 1;

            const n = normalize(needle);
            const h = normalize(haystack);
            const cn = compact(needle);
            const ch = compact(haystack);

            if (!n || !h) return 0;

            if (h === n) return 100;
            if (h.startsWith(n)) return 92;
            if (h.includes(n)) return 82;
            if (ch.includes(cn)) return 76;

            const tokens = n.split(/\s+/).filter(Boolean);
            if (!tokens.length) return 0;

            let tokenHits = 0;
            let tokenScore = 0;

            for (const token of tokens) {
                if (h.includes(token)) {
                    tokenHits += 1;
                    tokenScore += token.length <= 2 ? 8 : 16;
                }
            }

            let sequenceScore = 0;
            let cursor = 0;

            for (const char of cn) {
                const index = ch.indexOf(char, cursor);

                if (index < 0) {
                    sequenceScore -= 2;
                    continue;
                }

                sequenceScore += index === cursor ? 3 : 1;
                cursor = index + 1;
            }

            const coverage = tokenHits / tokens.length;
            return Math.max(0, Math.round((coverage * 44) + tokenScore + sequenceScore));
        }

        function collectGroups(root) {
            const explicit = Array.from(root.querySelectorAll('[data-docs-search]'));

            if (explicit.length) {
                return explicit;
            }

            const fallback = [];

            const projectInput = root.querySelector('.docs-project-hub__search input');
            if (projectInput) {
                fallback.push(projectInput.closest('main') || root);
            }

            const hubInput = root.querySelector('.docs-hub-search input');
            if (hubInput) {
                fallback.push(hubInput.closest('main') || root);
            }

            return Array.from(new Set(fallback));
        }

        function findInput(group) {
            return group.querySelector('[data-docs-search-input], .docs-project-hub__search input, .docs-hub-search input');
        }

        function collectItems(group) {
            return Array.from(
                group.querySelectorAll('[data-docs-search-item], .docs-project-card, .docs-hub-card')
            );
        }

        function itemText(item) {
            return item.getAttribute('data-docs-search-text') || item.textContent || '';
        }

        function applySearch(group, query) {
            const items = collectItems(group);
            const hasQuery = normalize(query).length > 0;
            let visibleCount = 0;

            items.forEach((item) => {
                const score = hasQuery ? scoreNeedleAgainstHaystack(query, itemText(item)) : 1;
                const visible = !hasQuery || score > 18;

                item.hidden = !visible;
                item.setAttribute('data-docs-search-score', String(score));

                if (visible) {
                    visibleCount += 1;
                }
            });

            group.setAttribute('data-docs-search-empty', visibleCount === 0 ? 'true' : 'false');
        }

        function bindGroup(group) {
            if (group.dataset.docsSearchBound === 'true') return;

            const input = findInput(group);
            if (!input) return;

            group.dataset.docsSearchBound = 'true';

            input.addEventListener('input', () => {
                applySearch(group, input.value);
            });

            applySearch(group, input.value || '');
        }

        function init(root = document) {
            collectGroups(root).forEach(bindGroup);
        }

        window.wcDocsFuzzySearch = {
            initialized: true,
            init,
            score: scoreNeedleAgainstHaystack
        };

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => init());
        } else {
            init();
        }
    })();
    """#
}
