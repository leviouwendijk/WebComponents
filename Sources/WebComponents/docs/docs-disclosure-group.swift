import Constructors
import CSS
import HTML
import JS

public struct DocsDisclosurePurposeCard: Sendable {
    public enum Tone: String, Sendable {
        case positive
        case neutral
        case caution
    }

    public let title: String
    public let text: String?
    public let tone: Tone
    public let marker: String

    public init(
        _ title: String,
        text: String? = nil,
        tone: Tone = .positive,
        marker: String = "+"
    ) {
        self.title = title
        self.text = text
        self.tone = tone
        self.marker = marker
    }

    func node(
        block: String
    ) -> any HTMLNode {
        HTML.div(["class": "\(block)__purpose-card \(block)__purpose-card--\(tone.rawValue)"]) {
            HTML.span(["class": "\(block)__purpose-marker", "aria-hidden": "true"]) {
                HTML.text(marker)
            }

            HTML.div(["class": "\(block)__purpose-copy"]) {
                HTML.el("h4", ["class": "\(block)__purpose-title"]) {
                    HTML.text(title)
                }

                if let text, !text.isEmpty {
                    HTML.p(["class": "\(block)__purpose-text"]) {
                        HTML.text(text)
                    }
                }
            }
        }
    }
}

public struct DocsDisclosurePurposeGrid: ReusableComponent, Sendable {
    private static let block = "wc-docs-disclosure-group"

    public let label: String?
    public let cards: [DocsDisclosurePurposeCard]

    public init(
        label: String? = "Doel",
        cards: [DocsDisclosurePurposeCard]
    ) {
        self.label = label
        self.cards = cards
    }

    public var nodes: ReusableComponentNodes {
        .body([node()])
    }

    public func node() -> any HTMLNode {
        HTML.div(["class": "\(Self.block)__purpose"]) {
            if let label, !label.isEmpty {
                HTML.p(["class": "\(Self.block)__purpose-label"]) {
                    HTML.text(label)
                }
            }

            HTML.div(["class": "\(Self.block)__purpose-grid"]) {
                for card in cards {
                    card.node(block: Self.block)
                }
            }
        }
    }
}

public struct DocsDisclosureSection: Sendable {
    public let id: String
    public let eyebrow: String?
    public let title: String
    public let summary: String
    public let defaultOpen: Bool
    public let body: @Sendable () -> HTMLFragment

    public init(
        id: String,
        eyebrow: String? = nil,
        title: String,
        summary: String,
        defaultOpen: Bool = false,
        body: @escaping @Sendable () -> HTMLFragment
    ) {
        self.id = id
        self.eyebrow = eyebrow
        self.title = title
        self.summary = summary
        self.defaultOpen = defaultOpen
        self.body = body
    }

    func node(
        block: String
    ) -> any HTMLNode {
        let attrs: HTMLAttribute = {
            var attrs: HTMLAttribute = [
                "id": id,
                "class": "\(block)__section",
                "data-docs-disclosure-section": id
            ]

            attrs.merge(HTMLAttribute.bool("open", defaultOpen))

            return attrs
        }()

        return HTML.details(attrs) {
            HTML.summary(["class": "\(block)__summary"]) {
                HTML.div(["class": "\(block)__summary-main"]) {
                    if let eyebrow, !eyebrow.isEmpty {
                        HTML.span(["class": "\(block)__eyebrow"]) {
                            HTML.text(eyebrow)
                        }
                    }

                    HTML.span(["class": "\(block)__title"]) {
                        HTML.text(title)
                    }

                    HTML.span(["class": "\(block)__definition"]) {
                        HTML.span(["class": "\(block)__definition-label"]) {
                            HTML.text("Definitie")
                        }

                        HTML.span(["class": "\(block)__definition-text"]) {
                            HTML.text(summary)
                        }
                    }
                }

                HTML.span(["class": "\(block)__indicator", "aria-hidden": "true"]) {
                    HTML.text("+")
                }
            }

            HTML.div(["class": "\(block)__content-clip", "data-docs-disclosure-content": ""]) {
                HTML.div(["class": "\(block)__content"]) {
                    body()
                }
            }
        }
    }
}

public struct DocsDisclosureGroup: ReusableComponent, Sendable {
    public static let block = "wc-docs-disclosure-group"

    public let eyebrow: String?
    public let title: String?
    public let lead: String?
    public let sections: [DocsDisclosureSection]
    public let includeStyles: Bool

    public init(
        eyebrow: String? = nil,
        title: String? = nil,
        lead: String? = nil,
        sections: [DocsDisclosureSection],
        includeStyles: Bool = true
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.lead = lead
        self.sections = sections
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.section(["class": "docs-disclosure-group \(Self.block)"]) {
                    if hasHeader {
                        HTML.div(["class": "\(Self.block)__header"]) {
                            if let eyebrow, !eyebrow.isEmpty {
                                HTML.p(["class": "\(Self.block)__header-eyebrow"]) {
                                    HTML.text(eyebrow)
                                }
                            }

                            if let title, !title.isEmpty {
                                HTML.h2 {
                                    HTML.text(title)
                                }
                            }

                            if let lead, !lead.isEmpty {
                                HTML.p(["class": "\(Self.block)__lead"]) {
                                    HTML.text(lead)
                                }
                            }
                        }
                    }

                    HTML.div(["class": "\(Self.block)__sections"]) {
                        for section in sections {
                            section.node(block: Self.block)
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    private var hasHeader: Bool {
        !(eyebrow?.isEmpty ?? true)
        || !(title?.isEmpty ?? true)
        || !(lead?.isEmpty ?? true)
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("--docs-disclosure-surface", "color-mix(in srgb, var(--background-color) 94%, var(--text-color) 6%)"),
                    CSS.decl("--docs-disclosure-surface-open", "color-mix(in srgb, var(--background-color) 88%, var(--text-color) 12%)"),
                    CSS.decl("--docs-disclosure-border", "color-mix(in srgb, var(--text-color) 16%, transparent)"),
                    CSS.decl("--docs-disclosure-muted", "color-mix(in srgb, var(--text-color) 62%, transparent)"),
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "28px 0 0")
                ),

                CSS.rule(
                    ".dark-mode .\(block)",
                    CSS.decl("--docs-disclosure-surface", "color-mix(in srgb, var(--background-color) 86%, var(--text-color) 8%)"),
                    CSS.decl("--docs-disclosure-surface-open", "color-mix(in srgb, var(--background-color) 78%, var(--text-color) 10%)")
                ),

                CSS.rule(
                    ".\(block)__header",
                    CSS.decl("margin", "0 0 14px"),
                    CSS.decl("padding", "0 0 16px"),
                    CSS.decl("border-bottom", "1px solid var(--docs-disclosure-border)")
                ),

                CSS.rule(
                    ".\(block)__header-eyebrow",
                    CSS.decl("margin", "0 0 8px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--docs-disclosure-muted)")
                ),

                CSS.rule(
                    ".\(block)__header h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.35rem"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("letter-spacing", "-.025em")
                ),

                CSS.rule(
                    ".\(block)__lead",
                    CSS.decl("max-width", "720px"),
                    CSS.decl("margin", "10px 0 0"),
                    CSS.decl("line-height", "1.62"),
                    CSS.decl("color", "var(--docs-disclosure-muted)")
                ),

                CSS.rule(
                    ".\(block)__sections",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "12px")
                ),

                CSS.rule(
                    ".\(block)__section",
                    CSS.decl("scroll-margin-top", "calc(var(--wc-docs-sticky-offset, 112px) + 24px)"),
                    CSS.decl("border", "1px solid var(--docs-disclosure-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "var(--docs-disclosure-surface)"),
                    CSS.decl("overflow", "clip")
                ),

                CSS.rule(
                    ".\(block)__section[open]",
                    CSS.decl("background", "var(--docs-disclosure-surface-open)")
                ),

                CSS.rule(
                    ".\(block)__summary",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) auto"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("padding", "18px 20px"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("list-style", "none")
                ),

                CSS.rule(
                    ".\(block)__summary::-webkit-details-marker",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(block)__summary-main",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__eyebrow",
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--docs-disclosure-muted)")
                ),

                CSS.rule(
                    ".\(block)__title",
                    CSS.decl("font-size", "1.05rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".\(block)__summary-text",
                    CSS.decl("max-width", "720px"),
                    CSS.decl("font-size", ".94rem"),
                    CSS.decl("line-height", "1.5"),
                    CSS.decl("color", "var(--docs-disclosure-muted)")
                ),

                CSS.rule(
                    ".\(block)__indicator",
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "28px"),
                    CSS.decl("height", "28px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("border", "1px solid var(--docs-disclosure-border)"),
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("transition", "transform .18s ease")
                ),

                CSS.rule(
                    ".\(block)__section[open] .\(block)__indicator",
                    CSS.decl("transform", "rotate(45deg)")
                ),

                CSS.rule(
                    ".\(block)__content",
                    CSS.decl("padding", "0 20px 20px"),
                    CSS.decl("border-top", "1px solid var(--docs-disclosure-border)")
                ),

                CSS.rule(
                    ".\(block)__content > :first-child",
                    CSS.decl("margin-top", "16px")
                ),

                CSS.rule(
                    ".\(block)__content > :last-child",
                    CSS.decl("margin-bottom", "0")
                ),

                CSS.rule(
                    ".\(block)__definition",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("max-width", "760px"),
                    CSS.decl("margin-top", "4px"),
                    CSS.decl("padding", "10px 12px"),
                    CSS.decl("border-left", "3px solid color-mix(in srgb, var(--text-color) 24%, var(--docs-disclosure-border))"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("background", "color-mix(in srgb, var(--background-color) 86%, var(--text-color) 7%)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--text-color) 7%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__definition-label",
                    CSS.decl("font-size", ".66rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color) 56%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__definition-text",
                    CSS.decl("font-size", ".96rem"),
                    CSS.decl("font-weight", "590"),
                    CSS.decl("line-height", "1.48"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color) 86%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__content",
                    CSS.decl("border-top", "0")
                ),

                CSS.rule(
                    ".\(block)__content-clip",
                    CSS.decl("max-height", "0"),
                    CSS.decl("opacity", "0"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("border-top", "1px solid var(--docs-disclosure-border)"),
                    CSS.decl("transition", "max-height .34s cubic-bezier(.22, 1, .36, 1), opacity .22s ease")
                ),

                CSS.rule(
                    ".\(block)__section[open] .\(block)__content-clip",
                    CSS.decl("max-height", "2400px"),
                    CSS.decl("opacity", "1")
                ),

                CSS.rule(
                    ".\(block)__purpose",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("margin", "18px 0")
                ),

                CSS.rule(
                    ".\(block)__purpose-label",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--docs-disclosure-muted)")
                ),

                CSS.rule(
                    ".\(block)__purpose-grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(auto-fit, minmax(220px, 1fr))"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".\(block)__purpose-card",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "28px minmax(0, 1fr)"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("padding", "13px"),
                    CSS.decl("border", "1px solid var(--docs-disclosure-border)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "color-mix(in srgb, var(--background-color) 88%, var(--text-color) 6%)")
                ),

                CSS.rule(
                    ".\(block)__purpose-card--positive",
                    CSS.decl("border-color", "color-mix(in srgb, var(--success, #2E8B57) 42%, var(--docs-disclosure-border))"),
                    CSS.decl("background", "color-mix(in srgb, var(--success, #2E8B57) 8%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__purpose-card--caution",
                    CSS.decl("border-color", "color-mix(in srgb, var(--warning, #E7A94E) 45%, var(--docs-disclosure-border))"),
                    CSS.decl("background", "color-mix(in srgb, var(--warning, #E7A94E) 9%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__purpose-marker",
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "26px"),
                    CSS.decl("height", "26px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-weight", "820"),
                    CSS.decl("background", "color-mix(in srgb, var(--success, #2E8B57) 15%, transparent)"),
                    CSS.decl("color", "color-mix(in srgb, var(--success, #2E8B57) 78%, var(--text-color))")
                ),

                CSS.rule(
                    ".\(block)__purpose-title",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".93rem"),
                    CSS.decl("line-height", "1.25"),
                    CSS.decl("font-weight", "760")
                ),

                CSS.rule(
                    ".\(block)__purpose-text",
                    CSS.decl("margin", "5px 0 0"),
                    CSS.decl("font-size", ".86rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--docs-disclosure-muted)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(block)",
                        CSS.decl("margin-top", "22px")
                    ),
                    CSS.rule(
                        ".\(block)__summary",
                        CSS.decl("padding", "16px")
                    ),
                    CSS.rule(
                        ".\(block)__content",
                        CSS.decl("padding", "0 16px 16px")
                    )
                )
            ]
        )
    }
}

public struct DocsDisclosureGroupScript: ReusableComponent {
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
        if (window.wcDocsDisclosureGroup?.initialized) return;

        const sectionSelector = '[data-docs-disclosure-section]';
        const contentSelector = '[data-docs-disclosure-content]';

        function contentFor(section) {
            return section.querySelector(contentSelector);
        }

        function setHeight(section) {
            const content = contentFor(section);
            if (!content) return;

            if (section.open) {
                content.style.maxHeight = 'none';
                content.style.opacity = '1';
            } else {
                content.style.maxHeight = '0px';
                content.style.opacity = '0';
            }
        }

        function afterMaxHeightTransition(content, callback) {
            const finish = event => {
                if (event.propertyName !== 'max-height') return;

                content.removeEventListener('transitionend', finish);
                callback();
            };

            content.addEventListener('transitionend', finish);
        }

        function openSection(section) {
            const content = contentFor(section);
            if (!content) return;

            section.open = true;
            content.style.maxHeight = '0px';
            content.style.opacity = '0';

            requestAnimationFrame(() => {
                content.style.maxHeight = `${content.scrollHeight}px`;
                content.style.opacity = '1';

                afterMaxHeightTransition(content, () => {
                    if (section.open) {
                        content.style.maxHeight = 'none';
                    }
                });
            });
        }

        function closeSection(section) {
            const content = contentFor(section);
            if (!content) return;

            content.style.maxHeight = `${content.scrollHeight}px`;
            content.style.opacity = '1';

            requestAnimationFrame(() => {
                content.style.maxHeight = '0px';
                content.style.opacity = '0';
            });

            afterMaxHeightTransition(content, () => {
                if (!section.open) return;

                section.open = false;
            });
        }

        function toggle(section) {
            if (section.open) {
                closeSection(section);
            } else {
                openSection(section);
            }
        }

        function init(scope = document) {
            const sections = scope.matches?.(sectionSelector)
                ? [scope]
                : Array.from(scope.querySelectorAll?.(sectionSelector) || []);

            sections.forEach(section => {
                section.setAttribute('data-docs-disclosure-animated', '');
                setHeight(section);
            });
        }

        document.addEventListener('click', event => {
            const summary = event.target?.closest?.('summary');
            if (!summary) return;

            const section = summary.closest(sectionSelector);
            if (!section) return;

            event.preventDefault();
            toggle(section);
        });

        window.addEventListener('resize', () => {
            document.querySelectorAll(sectionSelector).forEach(setHeight);
        });

        if (document.fonts?.ready) {
            document.fonts.ready.then(() => {
                document.querySelectorAll(sectionSelector).forEach(setHeight);
            });
        }

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => init());
        } else {
            init();
        }

        window.wcDocsDisclosureGroup = {
            initialized: true,
            init
        };
    })();
    """#
}
