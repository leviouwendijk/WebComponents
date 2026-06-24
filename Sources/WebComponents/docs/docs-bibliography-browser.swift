import Constructors
import CSS
import HTML
import JS
import References

public struct DocsBibliographyBrowser: ReusableComponent {
    public static let block = "wc-docs-bibliography-browser"

    public let references: [any ReferenceProviding]
    public let sections: [ReferenceTagSection]
    public let title: String
    public let lead: String?
    public let searchPlaceholder: String
    public let includeStyles: Bool
    public let includeScript: Bool

    public init(
        references: [any ReferenceProviding],
        sections: [ReferenceTagSection] = [],
        title: String = "Bibliografie",
        lead: String? = nil,
        searchPlaceholder: String = "Zoek op titel, auteur, DOI, tag of bron...",
        includeStyles: Bool = true,
        includeScript: Bool = true
    ) {
        self.references = references
        self.sections = sections
        self.title = title
        self.lead = lead
        self.searchPlaceholder = searchPlaceholder
        self.includeStyles = includeStyles
        self.includeScript = includeScript
    }

    private var uniqueReferences: [any ReferenceProviding] {
        var seen: Set<String> = []

        return references.filter { reference in
            seen.insert(reference.public_name_or_id).inserted
        }
    }

    private var allTags: [ReferenceTag] {
        var seen: Set<String> = []
        var tags: [ReferenceTag] = []

        for reference in uniqueReferences {
            for tag in reference.tags.values {
                if seen.insert(tag.id).inserted {
                    tags.append(tag)
                }
            }
        }

        return tags.sorted {
            $0.label.localizedCaseInsensitiveCompare($1.label) == .orderedAscending
        }
    }

    private var tagCounts: [String: Int] {
        var counts: [String: Int] = [:]

        for reference in uniqueReferences {
            for tag in reference.tags.values {
                counts[tag.id, default: 0] += 1
            }
        }

        return counts
    }

    public var nodes: ReusableComponentNodes {
        let items = uniqueReferences
        let tags = allTags
        let counts = tagCounts

        guard !items.isEmpty else {
            return .init()
        }

        return .body(
            [
                HTML.section(
                    [
                        "class": Self.block,
                        "data-docs-bibliography-browser": "",
                        "data-reference-match-default": "any"
                    ]
                ) {
                    header(
                        count: items.count
                    )

                    controls(
                        tags: tags,
                        counts: counts
                    )

                    if !sections.isEmpty {
                        presets()
                    }

                    HTML.ol(["class": "refs-list \(Self.block)__list"]) {
                        for pair in Array(items.enumerated()) {
                            Reference(
                                pair.element,
                                pointers: [pair.offset + 1]
                            )
                        }
                    }

                    HTML.p(
                        [
                            "class": "\(Self.block)__empty",
                            "data-reference-empty": "",
                            "hidden": ""
                        ]
                    ) {
                        HTML.text("Geen bronnen gevonden voor deze zoekopdracht of tagselectie.")
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : [],
            scripts: includeScript ? DocsBibliographyBrowserScript().nodes.scripts : []
        )
    }

    private func header(
        count: Int
    ) -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__header"]) {
            HTML.div(["class": "\(Self.block)__title-group"]) {
                HTML.h2(["class": "\(Self.block)__title"]) {
                    HTML.text(title)
                }

                if let lead, !lead.isEmpty {
                    HTML.p(["class": "\(Self.block)__lead"]) {
                        HTML.text(lead)
                    }
                }
            }

            HTML.div(["class": "\(Self.block)__count"]) {
                HTML.span(["data-reference-visible-count": ""]) {
                    HTML.text("\(count)")
                }

                HTML.text(" / ")

                HTML.span(["data-reference-total-count": "\(count)"]) {
                    HTML.text("\(count)")
                }

                HTML.text(" bronnen")
            }
        }
    }

    private func controls(
        tags: [ReferenceTag],
        counts: [String: Int]
    ) -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__controls"]) {
            HTML.div(["class": "\(Self.block)__search-wrap"]) {
                HTML.label(
                    [
                        "class": "\(Self.block)__label",
                        "for": "bibliography-search"
                    ]
                ) {
                    HTML.text("Zoeken")
                }

                HTML.input(
                    [
                        "id": "bibliography-search",
                        "class": "\(Self.block)__search",
                        "type": "search",
                        "placeholder": searchPlaceholder,
                        "autocomplete": "off",
                        "data-reference-search-input": ""
                    ]
                )
            }

            HTML.div(["class": "\(Self.block)__toolbar"]) {
                HTML.button(
                    [
                        "type": "button",
                        "class": "\(Self.block)__button",
                        "data-reference-action": "select-all"
                    ]
                ) {
                    HTML.text("Selecteer alle tags")
                }

                HTML.button(
                    [
                        "type": "button",
                        "class": "\(Self.block)__button",
                        "data-reference-action": "deselect-all"
                    ]
                ) {
                    HTML.text("Deselecteer alle tags")
                }

                HTML.button(
                    [
                        "type": "button",
                        "class": "\(Self.block)__button",
                        "data-reference-action": "reset"
                    ]
                ) {
                    HTML.text("Reset")
                }
            }

            HTML.fieldset(["class": "\(Self.block)__match"]) {
                HTML.legend(["class": "\(Self.block)__label"]) {
                    HTML.text("Tagselectie")
                }

                HTML.label(["class": "\(Self.block)__radio"]) {
                    HTML.input(
                        [
                            "type": "radio",
                            "name": "bibliography-match-mode",
                            "value": "any",
                            "checked": "",
                            "data-reference-match-mode": ""
                        ]
                    )

                    HTML.span {
                        HTML.text("Minstens één tag")
                    }
                }

                HTML.label(["class": "\(Self.block)__radio"]) {
                    HTML.input(
                        [
                            "type": "radio",
                            "name": "bibliography-match-mode",
                            "value": "all",
                            "data-reference-match-mode": ""
                        ]
                    )

                    HTML.span {
                        HTML.text("Alle geselecteerde tags")
                    }
                }
            }

            HTML.div(["class": "\(Self.block)__tags"]) {
                for tag in tags {
                    tagButton(
                        tag: tag,
                        count: counts[tag.id] ?? 0
                    )
                }
            }
        }
    }

    private func tagButton(
        tag: ReferenceTag,
        count: Int
    ) -> any HTMLNode {
        HTML.button(
            [
                "type": "button",
                "class": "\(Self.block)__tag",
                "aria-pressed": "false",
                "data-reference-filter-tag": tag.id
            ]
        ) {
            HTML.span(["class": "\(Self.block)__tag-label"]) {
                HTML.text(tag.label)
            }

            HTML.span(["class": "\(Self.block)__tag-count"]) {
                HTML.text("\(count)")
            }
        }
    }

    private func presets() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__presets"]) {
            HTML.div(["class": "\(Self.block)__presets-title"]) {
                HTML.text("Snelle selecties")
            }

            HTML.div(["class": "\(Self.block)__preset-list"]) {
                for section in sections {
                    presetButton(section)
                }
            }
        }
    }

    private func presetButton(
        _ section: ReferenceTagSection
    ) -> any HTMLNode {
        HTML.button(
            [
                "type": "button",
                "class": "\(Self.block)__preset",
                "data-reference-preset-tags": section.include.values.map(\.id).joined(separator: " "),
                "data-reference-preset-match": section.match.rawValue
            ]
        ) {
            if let eyebrow = section.eyebrow, !eyebrow.isEmpty {
                HTML.span(["class": "\(Self.block)__preset-eyebrow"]) {
                    HTML.text(eyebrow)
                }
            }

            HTML.span(["class": "\(Self.block)__preset-title"]) {
                HTML.text(section.title)
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "24px"),
                    CSS.decl("margin-top", "24px")
                ),

                CSS.rule(
                    ".\(block)__header",
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("align-items", "end"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("flex-wrap", "wrap")
                ),

                CSS.rule(
                    ".\(block)__title",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.35rem"),
                    CSS.decl("letter-spacing", "-.02em")
                ),

                CSS.rule(
                    ".\(block)__lead",
                    CSS.decl("margin", "8px 0 0"),
                    CSS.decl("max-width", "760px"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("line-height", "1.55")
                ),

                CSS.rule(
                    ".\(block)__count",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("min-height", "34px"),
                    CSS.decl("padding", "0 12px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__controls",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)")
                ),

                CSS.rule(
                    ".\(block)__label",
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "0 0 6px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".06em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__search",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("width", "100%"),
                    CSS.decl("min-height", "42px"),
                    CSS.decl("padding", "0 12px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("font", "inherit")
                ),

                CSS.rule(
                    ".\(block)__toolbar, .\(block)__tags, .\(block)__preset-list",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".\(block)__button, .\(block)__tag, .\(block)__preset",
                    CSS.decl("appearance", "none"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("font", "inherit")
                ),

                CSS.rule(
                    ".\(block)__button",
                    CSS.decl("padding", "7px 11px"),
                    CSS.decl("font-size", ".82rem")
                ),

                CSS.rule(
                    ".\(block)__tag",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "7px"),
                    CSS.decl("padding", "6px 9px"),
                    CSS.decl("font-size", ".78rem")
                ),

                CSS.rule(
                    ".\(block)__tag[aria-pressed=\"true\"]",
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 58%, var(--border-color))"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 14%, var(--surface-color, var(--background-color)))"),
                    CSS.decl("color", "var(--link-color)")
                ),

                CSS.rule(
                    ".\(block)__tag-count",
                    CSS.decl("display", "inline-grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("min-width", "22px"),
                    CSS.decl("height", "20px"),
                    CSS.decl("padding", "0 5px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, currentColor 10%, transparent)"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".68rem")
                ),

                CSS.rule(
                    ".\(block)__match",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "0"),
                    CSS.decl("border", "0")
                ),

                CSS.rule(
                    ".\(block)__radio",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__presets",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".\(block)__presets-title",
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__preset",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "1px"),
                    CSS.decl("padding", "8px 12px"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("text-align", "left")
                ),

                CSS.rule(
                    ".\(block)__preset-eyebrow",
                    CSS.decl("font-size", ".62rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".06em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__preset-title",
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("font-weight", "680")
                ),

                CSS.rule(
                    ".\(block)__list",
                    CSS.decl("list-style", "none"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "0")
                ),

                CSS.rule(
                    ".\(block) .ref-item",
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "12px 14px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))")
                ),

                CSS.rule(
                    ".\(block) .ref-title",
                    CSS.decl("font-weight", "700"),
                    CSS.decl("line-height", "1.3")
                ),

                CSS.rule(
                    ".\(block) .ref-title a",
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".\(block) .ref-title a:hover",
                    CSS.decl("color", "var(--link-color)")
                ),

                CSS.rule(
                    ".\(block) .ref-meta",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "3px"),
                    CSS.decl("margin-top", "8px"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("font-size", ".88rem"),
                    CSS.decl("line-height", "1.35")
                ),

                CSS.rule(
                    ".\(block)__empty",
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border", "1px dashed var(--border-color)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("color", "var(--muted-text-color)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(block)__header",
                        CSS.decl("align-items", "start")
                    )
                )
            ]
        )
    }
}

public struct DocsBibliographyBrowserScript: ReusableComponent {
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
        if (window.wcDocsBibliographyBrowser?.initialized) return;

        const rootSelector = '[data-docs-bibliography-browser]';
        const itemSelector = '[data-reference-item]';
        const tagSelector = '[data-reference-filter-tag]';

        function split(value) {
            return String(value || '')
                .split(/\s+/)
                .map((item) => item.trim())
                .filter(Boolean);
        }

        function selectedTags(root) {
            return Array.from(root.querySelectorAll(tagSelector))
                .filter((button) => button.getAttribute('aria-pressed') === 'true')
                .map((button) => button.getAttribute('data-reference-filter-tag'))
                .filter(Boolean);
        }

        function matchMode(root) {
            const checked = root.querySelector('[data-reference-match-mode]:checked');
            return checked?.value === 'all' ? 'all' : 'any';
        }

        function itemMatchesTags(item, selected, mode) {
            if (!selected.length) return true;

            const tags = split(item.getAttribute('data-reference-tags'));

            if (mode === 'all') {
                return selected.every((tag) => tags.includes(tag));
            }

            return selected.some((tag) => tags.includes(tag));
        }

        function itemMatchesSearch(item, query) {
            if (!query) return true;

            const haystack = String(item.getAttribute('data-reference-search') || '').toLowerCase();
            return haystack.includes(query);
        }

        function update(root) {
            const query = String(
                root.querySelector('[data-reference-search-input]')?.value || ''
            )
                .trim()
                .toLowerCase();

            const selected = selectedTags(root);
            const mode = matchMode(root);

            let visible = 0;

            root.querySelectorAll(itemSelector).forEach((item) => {
                const isVisible = itemMatchesSearch(item, query)
                    && itemMatchesTags(item, selected, mode);

                item.hidden = !isVisible;

                if (isVisible) {
                    visible += 1;
                }
            });

            const visibleNode = root.querySelector('[data-reference-visible-count]');
            if (visibleNode) {
                visibleNode.textContent = String(visible);
            }

            const empty = root.querySelector('[data-reference-empty]');
            if (empty) {
                empty.hidden = visible !== 0;
            }
        }

        function setAll(root, value) {
            root.querySelectorAll(tagSelector).forEach((button) => {
                button.setAttribute('aria-pressed', value ? 'true' : 'false');
            });
        }

        function setMatch(root, value) {
            root.querySelectorAll('[data-reference-match-mode]').forEach((input) => {
                input.checked = input.value === value;
            });
        }

        function setPreset(root, button) {
            const tags = split(button.getAttribute('data-reference-preset-tags'));
            const selected = new Set(tags);

            root.querySelectorAll(tagSelector).forEach((tagButton) => {
                const id = tagButton.getAttribute('data-reference-filter-tag');
                tagButton.setAttribute(
                    'aria-pressed',
                    selected.has(id) ? 'true' : 'false'
                );
            });

            setMatch(
                root,
                button.getAttribute('data-reference-preset-match') === 'all'
                    ? 'all'
                    : 'any'
            );
        }

        function reset(root) {
            const input = root.querySelector('[data-reference-search-input]');
            if (input) {
                input.value = '';
            }

            setAll(root, false);
            setMatch(root, 'any');
            update(root);
        }

        function init(root) {
            if (!root || root.dataset.referenceBrowserReady === 'true') return;

            root.dataset.referenceBrowserReady = 'true';

            root.addEventListener('input', (event) => {
                if (event.target?.closest?.('[data-reference-search-input]')) {
                    update(root);
                }

                if (event.target?.closest?.('[data-reference-match-mode]')) {
                    update(root);
                }
            });

            root.addEventListener('change', (event) => {
                if (event.target?.closest?.('[data-reference-match-mode]')) {
                    update(root);
                }
            });

            root.addEventListener('click', (event) => {
                const tag = event.target?.closest?.(tagSelector);
                if (tag) {
                    const pressed = tag.getAttribute('aria-pressed') === 'true';
                    tag.setAttribute('aria-pressed', pressed ? 'false' : 'true');
                    update(root);
                    return;
                }

                const preset = event.target?.closest?.('[data-reference-preset-tags]');
                if (preset) {
                    setPreset(root, preset);
                    update(root);
                    return;
                }

                const action = event.target
                    ?.closest?.('[data-reference-action]')
                    ?.getAttribute('data-reference-action');

                if (action === 'select-all') {
                    setAll(root, true);
                    update(root);
                    return;
                }

                if (action === 'deselect-all') {
                    setAll(root, false);
                    update(root);
                    return;
                }

                if (action === 'reset') {
                    reset(root);
                }
            });

            update(root);
        }

        function initAll(scope = document) {
            const roots = scope.matches?.(rootSelector)
                ? [scope]
                : Array.from(scope.querySelectorAll?.(rootSelector) || []);

            roots.forEach(init);
        }

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => initAll());
        } else {
            initAll();
        }

        window.wcDocsBibliographyBrowser = {
            initialized: true,
            init,
            initAll,
            update,
            reset
        };
    })();
    """#
}
