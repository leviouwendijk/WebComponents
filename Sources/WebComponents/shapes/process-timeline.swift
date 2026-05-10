import Foundation
import Constructors
import HTML
import CSS

public struct ProcessTimeline: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-process-timeline"
        static let step = "wc-process-timeline__step"
        static let rail = "wc-process-timeline__rail"
        static let index = "wc-process-timeline__index"

        static let card = "wc-process-timeline__card"
        static let header = "wc-process-timeline__header"
        static let eyebrow = "wc-process-timeline__eyebrow"
        static let title = "wc-process-timeline__title"
        static let definition = "wc-process-timeline__definition"

        static let sections = "wc-process-timeline__sections"
        static let section = "wc-process-timeline__section"
        static let sectionLabel = "wc-process-timeline__section-label"

        static let items = "wc-process-timeline__items"
        static let item = "wc-process-timeline__item"
        static let itemMark = "wc-process-timeline__item-mark"
        static let itemBody = "wc-process-timeline__item-body"
        static let itemTitle = "wc-process-timeline__item-title"
        static let itemText = "wc-process-timeline__item-text"
    }

    public struct Item: Sendable {
        public let title: String?
        public let body: @Sendable () -> HTMLFragment

        public init(
            title: String? = nil,
            body: @escaping @Sendable () -> HTMLFragment
        ) {
            self.title = title
            self.body = body
        }

        public init(
            _ text: String
        ) {
            self.title = nil
            self.body = {
                [
                    HTML.text(text)
                ]
            }
        }
    }

    public struct Section: Sendable {
        public let label: String?
        public let items: [Item]

        public init(
            label: String? = nil,
            items: [Item]
        ) {
            self.label = label
            self.items = items
        }
    }

    public struct Step: Sendable {
        public let eyebrow: String?
        public let title: String
        public let definition: @Sendable () -> HTMLFragment
        public let sections: [Section]

        public init(
            eyebrow: String? = nil,
            title: String,
            definition: @escaping @Sendable () -> HTMLFragment = { [] },
            sections: [Section] = []
        ) {
            self.eyebrow = eyebrow
            self.title = title
            self.definition = definition
            self.sections = sections
        }
    }

    public let classes: [String]
    public let attrs: HTMLAttribute
    public let startIndex: Int
    public let indexWidth: Int
    public let steps: [Step]

    public init(
        classes: [String] = [],
        attrs: HTMLAttribute = HTMLAttribute(),
        startIndex: Int = 0,
        indexWidth: Int = 2,
        steps: [Step]
    ) {
        self.classes = classes
        self.attrs = attrs
        self.startIndex = startIndex
        self.indexWidth = indexWidth
        self.steps = steps
    }

    public var nodes: ReusableComponentNodes {
        var rootAttrs = HTMLAttribute.class([ClassName.root] + classes)
        rootAttrs.merge(attrs)

        return .body(
            [
                HTML.div(rootAttrs) {
                    for offset in steps.indices {
                        let step = steps[offset]
                        let indexText = Self.indexText(
                            startIndex + offset,
                            width: indexWidth
                        )

                        HTML.el("article", HTMLAttribute.class(ClassName.step)) {
                            HTML.div(
                                [
                                    "class": ClassName.rail,
                                    "aria-hidden": "true"
                                ]
                            ) {
                                HTML.span(HTMLAttribute.class(ClassName.index)) {
                                    HTML.text(indexText)
                                }
                            }

                            HTML.div(HTMLAttribute.class(ClassName.card)) {
                                HTML.header(HTMLAttribute.class(ClassName.header)) {
                                    if let eyebrow = step.eyebrow, !eyebrow.isEmpty {
                                        HTML.div(HTMLAttribute.class(ClassName.eyebrow)) {
                                            HTML.text(eyebrow)
                                        }
                                    }

                                    HTML.h3(HTMLAttribute.class(ClassName.title)) {
                                        HTML.text(step.title)
                                    }

                                    let definition = step.definition()

                                    if !definition.isEmpty {
                                        HTML.div(HTMLAttribute.class(ClassName.definition)) {
                                            definition
                                        }
                                    }
                                }

                                if !step.sections.isEmpty {
                                    HTML.div(HTMLAttribute.class(ClassName.sections)) {
                                        for section in step.sections {
                                            HTML.div(HTMLAttribute.class(ClassName.section)) {
                                                if let label = section.label, !label.isEmpty {
                                                    HTML.div(HTMLAttribute.class(ClassName.sectionLabel)) {
                                                        HTML.text(label)
                                                    }
                                                }

                                                HTML.div(HTMLAttribute.class(ClassName.items)) {
                                                    for item in section.items {
                                                        HTML.div(HTMLAttribute.class(ClassName.item)) {
                                                            HTML.span(HTMLAttribute.class(ClassName.itemMark)) {}

                                                            HTML.div(HTMLAttribute.class(ClassName.itemBody)) {
                                                                if let title = item.title, !title.isEmpty {
                                                                    HTML.strong(HTMLAttribute.class(ClassName.itemTitle)) {
                                                                        HTML.text(title)
                                                                    }
                                                                }

                                                                HTML.div(HTMLAttribute.class(ClassName.itemText)) {
                                                                    item.body()
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            ],
            stylesheets: [
                Self.css()
            ]
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    private static func indexText(
        _ value: Int,
        width: Int
    ) -> String {
        let safeWidth = max(1, width)
        return String(format: "%0\(safeWidth)d", value)
    }

    public static func css() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("--wc-process-timeline-card-bg", "var(--surface-strong, var(--background-color, #ffffff))"),
                    CSS.decl("--wc-process-timeline-card-soft-bg", "var(--surface-soft, rgba(15, 23, 42, 0.035))"),
                    CSS.decl("--wc-process-timeline-border", "var(--border-color, rgba(15, 23, 42, 0.12))"),
                    CSS.decl("--wc-process-timeline-text", "var(--text-color, #0f172a)"),
                    CSS.decl("--wc-process-timeline-muted", "var(--ref-meta-text-color, rgba(15, 23, 42, 0.62))"),
                    CSS.decl("--wc-process-timeline-accent", "var(--link-color, var(--accent, #2563eb))"),
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "1fr"),
                    CSS.decl("gap", "28px"),
                    CSS.decl("margin", "22px 0 30px"),
                    CSS.decl("color", "var(--wc-process-timeline-text)")
                ),

                CSS.rule(
                    ".\(ClassName.step)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "74px minmax(0, 1fr)"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("align-items", "start")
                ),

                CSS.rule(
                    ".\(ClassName.rail)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("align-items", "flex-start"),
                    CSS.decl("min-height", "100%"),
                    CSS.decl("padding-top", "20px")
                ),

                CSS.rule(
                    ".\(ClassName.step):not(:last-child) .\(ClassName.rail)::before",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "50%"),
                    CSS.decl("top", "70px"),
                    CSS.decl("bottom", "-30px"),
                    CSS.decl("width", "2px"),
                    CSS.decl("transform", "translateX(-50%)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "linear-gradient(to bottom, var(--wc-process-timeline-accent), color-mix(in srgb, var(--wc-process-timeline-accent) 18%, transparent))")
                ),

                CSS.rule(
                    ".\(ClassName.step):not(:last-child) .\(ClassName.rail)::after",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "50%"),
                    CSS.decl("bottom", "-32px"),
                    CSS.decl("width", "0"),
                    CSS.decl("height", "0"),
                    CSS.decl("transform", "translateX(-50%)"),
                    CSS.decl("border-left", "6px solid transparent"),
                    CSS.decl("border-right", "6px solid transparent"),
                    CSS.decl("border-top", "9px solid var(--wc-process-timeline-accent)")
                ),

                CSS.rule(
                    ".\(ClassName.index)",
                    CSS.decl("position", "relative"),
                    CSS.decl("z-index", "2"),
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("width", "48px"),
                    CSS.decl("height", "48px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--wc-process-timeline-card-bg)"),
                    CSS.decl("border", "2px solid var(--wc-process-timeline-accent)"),
                    CSS.decl("box-shadow", "0 10px 26px rgba(15, 23, 42, 0.10)"),
                    CSS.decl("color", "var(--wc-process-timeline-accent)"),
                    CSS.decl("font-size", "0.86rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("letter-spacing", "0.03em"),
                    CSS.decl("font-variant-numeric", "tabular-nums")
                ),

                CSS.rule(
                    ".\(ClassName.card)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "16px"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("padding", "18px 20px 20px"),
                    CSS.decl("border", "1px solid var(--wc-process-timeline-border)"),
                    CSS.decl("border-radius", "20px"),
                    CSS.decl("background", "linear-gradient(180deg, color-mix(in srgb, var(--wc-process-timeline-card-bg) 96%, var(--wc-process-timeline-accent)), var(--wc-process-timeline-card-bg))"),
                    CSS.decl("box-shadow", "0 16px 38px rgba(15, 23, 42, 0.08)"),
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".\(ClassName.card)::before",
                    CSS.decl("content", "\"\""),
                    CSS.decl("position", "absolute"),
                    CSS.decl("inset", "0 auto 0 0"),
                    CSS.decl("width", "4px"),
                    CSS.decl("background", "linear-gradient(to bottom, var(--wc-process-timeline-accent), transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.header)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(ClassName.eyebrow)",
                    CSS.decl("margin", "0"),
                    CSS.decl("color", "var(--wc-process-timeline-accent)"),
                    CSS.decl("font-size", "0.74rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("letter-spacing", "0.08em"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("text-transform", "uppercase")
                ),

                CSS.rule(
                    ".\(ClassName.title)",
                    CSS.decl("margin", "0"),
                    CSS.decl("color", "var(--wc-process-timeline-text)"),
                    CSS.decl("font-size", "clamp(1.16rem, 2.2vw, 1.55rem)"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("letter-spacing", "-0.02em")
                ),

                CSS.rule(
                    ".\(ClassName.definition)",
                    CSS.decl("max-width", "68ch"),
                    CSS.decl("color", "var(--wc-process-timeline-muted)"),
                    CSS.decl("font-size", "0.98rem"),
                    CSS.decl("line-height", "1.55")
                ),

                CSS.rule(
                    ".\(ClassName.definition) p",
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    ".\(ClassName.sections)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "12px")
                ),

                CSS.rule(
                    ".\(ClassName.section)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "9px")
                ),

                CSS.rule(
                    ".\(ClassName.sectionLabel)",
                    CSS.decl("width", "fit-content"),
                    CSS.decl("padding", "0.25rem 0.55rem"),
                    CSS.decl("border", "1px solid var(--wc-process-timeline-border)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--wc-process-timeline-card-soft-bg)"),
                    CSS.decl("color", "var(--wc-process-timeline-muted)"),
                    CSS.decl("font-size", "0.76rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("letter-spacing", "0.04em"),
                    CSS.decl("text-transform", "uppercase")
                ),

                CSS.rule(
                    ".\(ClassName.items)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".\(ClassName.item)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "18px minmax(0, 1fr)"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("padding", "10px 12px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--wc-process-timeline-border) 72%, transparent)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-process-timeline-card-soft-bg) 68%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.itemMark)",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "8px"),
                    CSS.decl("height", "8px"),
                    CSS.decl("margin-top", "0.48em"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--wc-process-timeline-accent)"),
                    CSS.decl("box-shadow", "0 0 0 4px color-mix(in srgb, var(--wc-process-timeline-accent) 14%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.itemBody)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "3px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(ClassName.itemTitle)",
                    CSS.decl("display", "block"),
                    CSS.decl("font-size", "0.92rem"),
                    CSS.decl("line-height", "1.25"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("color", "var(--wc-process-timeline-text)")
                ),

                CSS.rule(
                    ".\(ClassName.itemText)",
                    CSS.decl("color", "var(--wc-process-timeline-text)"),
                    CSS.decl("font-size", "0.96rem"),
                    CSS.decl("line-height", "1.48")
                ),

                CSS.rule(
                    ".\(ClassName.itemText) p",
                    CSS.decl("margin", "0")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(ClassName.root)",
                        CSS.decl("gap", "24px"),
                        CSS.decl("margin", "18px 0 24px")
                    ),
                    CSS.rule(
                        ".\(ClassName.step)",
                        CSS.decl("grid-template-columns", "58px minmax(0, 1fr)"),
                        CSS.decl("gap", "12px")
                    ),
                    CSS.rule(
                        ".\(ClassName.rail)",
                        CSS.decl("padding-top", "18px")
                    ),
                    CSS.rule(
                        ".\(ClassName.index)",
                        CSS.decl("width", "42px"),
                        CSS.decl("height", "42px"),
                        CSS.decl("font-size", "0.78rem")
                    ),
                    CSS.rule(
                        ".\(ClassName.step):not(:last-child) .\(ClassName.rail)::before",
                        CSS.decl("top", "62px"),
                        CSS.decl("bottom", "-26px")
                    ),
                    CSS.rule(
                        ".\(ClassName.step):not(:last-child) .\(ClassName.rail)::after",
                        CSS.decl("bottom", "-28px")
                    ),
                    CSS.rule(
                        ".\(ClassName.card)",
                        CSS.decl("padding", "16px 15px 17px"),
                        CSS.decl("border-radius", "17px")
                    ),
                    CSS.rule(
                        ".\(ClassName.item)",
                        CSS.decl("padding", "9px 10px")
                    )
                )
            ]
        )
    }
}
