import Constructors
import CSS
import HTML

public struct LayeredCardOverview: ReusableComponent, Sendable {
    public struct Meta: Sendable {
        public let label: String

        public init(
            label: String
        ) {
            self.label = label
        }
    }

    public struct Card: Sendable {
        public let id: String
        public let eyebrow: String?
        public let title: String
        public let summary: String
        public let definition: String?
        public let function: String?
        public let chips: [String]
        public let meta: [Meta]

        public init(
            id: String,
            eyebrow: String? = nil,
            title: String,
            summary: String,
            definition: String? = nil,
            function: String? = nil,
            chips: [String] = [],
            meta: [Meta] = []
        ) {
            self.id = id
            self.eyebrow = eyebrow
            self.title = title
            self.summary = summary
            self.definition = definition
            self.function = function
            self.chips = chips
            self.meta = meta
        }
    }

    public struct Group: Sendable {
        public let id: String
        public let eyebrow: String?
        public let title: String
        public let summary: String
        public let cards: [Card]

        public init(
            id: String,
            eyebrow: String? = nil,
            title: String,
            summary: String,
            cards: [Card]
        ) {
            self.id = id
            self.eyebrow = eyebrow
            self.title = title
            self.summary = summary
            self.cards = cards
        }
    }

    private enum ClassName {
        static let root = "wc-layered-card-overview"
        static let stage = "wc-layered-card-overview__stage"

        static let header = "wc-layered-card-overview__header"
        static let eyebrow = "wc-layered-card-overview__eyebrow"
        static let title = "wc-layered-card-overview__title"
        static let lead = "wc-layered-card-overview__lead"

        static let groups = "wc-layered-card-overview__groups"
        static let group = "wc-layered-card-overview__group"
        static let groupHeader = "wc-layered-card-overview__group-header"
        static let groupIndex = "wc-layered-card-overview__group-index"
        static let groupCopy = "wc-layered-card-overview__group-copy"
        static let groupEyebrow = "wc-layered-card-overview__group-eyebrow"
        static let groupTitle = "wc-layered-card-overview__group-title"
        static let groupSummary = "wc-layered-card-overview__group-summary"

        static let cards = "wc-layered-card-overview__cards"
        static let card = "wc-layered-card-overview__card"
        static let cardHeader = "wc-layered-card-overview__card-header"
        static let cardEyebrow = "wc-layered-card-overview__card-eyebrow"
        static let cardTitle = "wc-layered-card-overview__card-title"
        static let cardSummary = "wc-layered-card-overview__card-summary"

        static let details = "wc-layered-card-overview__details"
        static let detail = "wc-layered-card-overview__detail"
        static let detailLabel = "wc-layered-card-overview__detail-label"
        static let detailText = "wc-layered-card-overview__detail-text"

        static let meta = "wc-layered-card-overview__meta"
        static let metaItem = "wc-layered-card-overview__meta-item"

        static let chips = "wc-layered-card-overview__chips"
        static let chip = "wc-layered-card-overview__chip"
    }

    public let id: String
    public let eyebrow: String?
    public let title: String?
    public let lead: String?
    public let groups: [Group]
    public let includeStyles: Bool

    public init(
        id: String = "layered-card-overview",
        eyebrow: String? = nil,
        title: String? = nil,
        lead: String? = nil,
        groups: [Group],
        includeStyles: Bool = true
    ) {
        self.id = id
        self.eyebrow = eyebrow
        self.title = title
        self.lead = lead
        self.groups = groups
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.section(
                    [
                        "id": id,
                        "class": ClassName.root
                    ]
                ) {
                    [
                        HTML.div(stage_attributes) {
                            header_nodes()
                            + [
                                HTML.div([ "class": ClassName.groups ]) {
                                    groups.enumerated().map { index, group in
                                        group_node(
                                            group,
                                            index: index
                                        )
                                    }
                                }
                            ]
                        }
                    ]
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    private var stage_attributes: HTMLAttribute {
        guard let title = non_empty(title) else {
            return [
                "class": ClassName.stage
            ]
        }

        return [
            "class": ClassName.stage,
            "role": "group",
            "aria-label": title
        ]
    }

    private func header_nodes() -> HTMLFragment {
        let header = optional_text_node(
            tag: "p",
            className: ClassName.eyebrow,
            text: eyebrow
        )
        + optional_text_node(
            tag: "h2",
            className: ClassName.title,
            text: title
        )
        + optional_text_node(
            tag: "p",
            className: ClassName.lead,
            text: lead
        )

        guard !header.isEmpty else {
            return []
        }

        return [
            HTML.header([ "class": ClassName.header ]) {
                header
            }
        ]
    }

    private func group_node(
        _ group: Group,
        index: Int
    ) -> any HTMLNode {
        HTML.section(
            [
                "id": "\(id)-\(group.id)",
                "class": ClassName.group,
                "data-layered-overview-group": group.id
            ]
        ) {
            [
                HTML.div([ "class": ClassName.groupHeader ]) {
                    [
                        HTML.div([ "class": ClassName.groupIndex ]) {
                            HTML.text(two_digit(index + 1))
                        },

                        HTML.div([ "class": ClassName.groupCopy ]) {
                            optional_text_node(
                                tag: "p",
                                className: ClassName.groupEyebrow,
                                text: group.eyebrow
                            )
                            + [
                                HTML.el("h3", [ "class": ClassName.groupTitle ]) {
                                    HTML.text(group.title)
                                },

                                HTML.p([ "class": ClassName.groupSummary ]) {
                                    HTML.text(group.summary)
                                }
                            ]
                        }
                    ]
                },

                HTML.div([ "class": ClassName.cards ]) {
                    group.cards.map { card in
                        card_node(card)
                    }
                }
            ]
        }
    }

    private func card_node(
        _ card: Card
    ) -> any HTMLNode {
        HTML.article(
            [
                "id": "\(id)-\(card.id)",
                "class": ClassName.card,
                "data-layered-overview-card": card.id
            ]
        ) {
            [
                HTML.header([ "class": ClassName.cardHeader ]) {
                    optional_text_node(
                        tag: "p",
                        className: ClassName.cardEyebrow,
                        text: card.eyebrow
                    )
                    + [
                        HTML.el("h4", [ "class": ClassName.cardTitle ]) {
                            HTML.text(card.title)
                        },

                        HTML.p([ "class": ClassName.cardSummary ]) {
                            HTML.text(card.summary)
                        }
                    ]
                }
            ]
            + detail_nodes(card)
            + meta_nodes(card.meta)
            + chip_nodes(card.chips)
        }
    }

    private func detail_nodes(
        _ card: Card
    ) -> HTMLFragment {
        var details: HTMLFragment = []

        if let definition = non_empty(card.definition) {
            details.append(
                detail_node(
                    label: "Definitie",
                    text: definition
                )
            )
        }

        if let function = non_empty(card.function) {
            details.append(
                detail_node(
                    label: "Functie",
                    text: function
                )
            )
        }

        guard !details.isEmpty else {
            return []
        }

        return [
            HTML.div([ "class": ClassName.details ]) {
                details
            }
        ]
    }

    private func detail_node(
        label: String,
        text: String
    ) -> any HTMLNode {
        HTML.div([ "class": ClassName.detail ]) {
            [
                HTML.span([ "class": ClassName.detailLabel ]) {
                    HTML.text(label)
                },

                HTML.p([ "class": ClassName.detailText ]) {
                    HTML.text(text)
                }
            ]
        }
    }

    private func meta_nodes(
        _ meta: [Meta]
    ) -> HTMLFragment {
        guard !meta.isEmpty else {
            return []
        }

        return [
            HTML.div([ "class": ClassName.meta ]) {
                meta.map { item in
                    HTML.span([ "class": ClassName.metaItem ]) {
                        HTML.text(item.label)
                    }
                }
            }
        ]
    }

    private func chip_nodes(
        _ chips: [String]
    ) -> HTMLFragment {
        let visible = chips.compactMap(non_empty)

        guard !visible.isEmpty else {
            return []
        }

        return [
            HTML.div([ "class": ClassName.chips ]) {
                visible.map { chip in
                    HTML.span([ "class": ClassName.chip ]) {
                        HTML.text(chip)
                    }
                }
            }
        ]
    }

    private func optional_text_node(
        tag: String,
        className: String,
        text: String?
    ) -> HTMLFragment {
        guard let text = non_empty(text) else {
            return []
        }

        return [
            HTML.el(tag, [ "class": className ]) {
                HTML.text(text)
            }
        ]
    }

    private func non_empty(
        _ text: String?
    ) -> String? {
        guard let text else {
            return nil
        }

        let trimmed = text.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        return trimmed.isEmpty ? nil : trimmed
    }

    private func two_digit(
        _ value: Int
    ) -> String {
        value < 10 ? "0\(value)" : "\(value)"
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("width", "min(900px, 100%)"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("margin", "1.25rem 0 2rem"),
                    CSS.decl("color", "var(--text-color, #17202a)"),
                    CSS.decl("--wc-layered-overview-ink", "var(--text-color, #17202a)"),
                    CSS.decl("--wc-layered-overview-muted", "var(--muted-text-color, rgba(32, 33, 36, .68))"),
                    CSS.decl("--wc-layered-overview-border", "var(--border-color, rgba(15, 23, 42, .13))"),
                    CSS.decl("--wc-layered-overview-border-strong", "color-mix(in srgb, var(--wc-layered-overview-ink) 18%, var(--wc-layered-overview-border))"),
                    CSS.decl("--wc-layered-overview-surface", "var(--surface-color, #fff)"),
                    CSS.decl("--wc-layered-overview-soft", "color-mix(in srgb, var(--wc-layered-overview-ink) 3%, transparent)")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.root)",
                    CSS.decl("--wc-layered-overview-ink", "var(--text-color, #f4f4f5)"),
                    CSS.decl("--wc-layered-overview-muted", "var(--muted-text-color, rgba(244, 244, 245, .70))"),
                    CSS.decl("--wc-layered-overview-border", "var(--border-color, rgba(255, 255, 255, .13))"),
                    CSS.decl("--wc-layered-overview-border-strong", "color-mix(in srgb, var(--wc-layered-overview-ink) 22%, var(--wc-layered-overview-border))"),
                    CSS.decl("--wc-layered-overview-surface", "var(--surface-color, #1b1c1f)"),
                    CSS.decl("--wc-layered-overview-soft", "color-mix(in srgb, var(--wc-layered-overview-ink) 6%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.root), .\(ClassName.root) *",
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("padding", "0"),
                    CSS.decl("border", "0"),
                    CSS.decl("border-radius", "0"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("box-shadow", "none"),
                    CSS.decl("overflow", "visible")
                ),

                CSS.rule(
                    ".\(ClassName.header)",
                    CSS.decl("max-width", "760px"),
                    CSS.decl("padding", "0")
                ),

                CSS.rule(
                    ".\(ClassName.eyebrow)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--wc-layered-overview-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.title)",
                    CSS.decl("margin", ".25rem 0 0"),
                    CSS.decl("font-size", "clamp(1.2rem, 2.2vw, 1.55rem)"),
                    CSS.decl("line-height", "1.12"),
                    CSS.decl("color", "var(--wc-layered-overview-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.lead)",
                    CSS.decl("max-width", "66ch"),
                    CSS.decl("margin", ".6rem 0 0"),
                    CSS.decl("font-size", ".96rem"),
                    CSS.decl("line-height", "1.52"),
                    CSS.decl("color", "var(--wc-layered-overview-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.groups)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "18px")
                ),

                CSS.rule(
                    ".\(ClassName.group)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("padding", "0"),
                    CSS.decl("border", "0"),
                    CSS.decl(
                        "border-top",
                        "1px solid color-mix(in srgb, var(--wc-layered-overview-border) 62%, transparent)"
                    ),
                    CSS.decl("border-radius", "0"),
                    CSS.decl("background", "transparent")
                ),

                CSS.rule(
                    ".\(ClassName.group):first-child",
                    CSS.decl("border-top", "0")
                ),

                CSS.rule(
                    ".\(ClassName.groupHeader)",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "baseline"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("padding", "12px 0 2px")
                ),

                CSS.rule(
                    ".\(ClassName.group):first-child .\(ClassName.groupHeader)",
                    CSS.decl("padding-top", "0")
                ),

                CSS.rule(
                    ".\(ClassName.groupIndex)",
                    CSS.decl("display", "inline-block"),
                    CSS.decl("min-width", "1.8ch"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".58rem"),
                    CSS.decl("font-weight", "600"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("color", "var(--wc-layered-overview-muted)"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("box-shadow", "none"),
                    CSS.decl("opacity", ".42")
                ),

                CSS.rule(
                    ".\(ClassName.groupCopy)",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "baseline"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(ClassName.groupEyebrow)",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(ClassName.groupTitle)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "620"),
                    CSS.decl("letter-spacing", "0"),
                    CSS.decl("line-height", "1.2"),
                    CSS.decl("text-transform", "none"),
                    CSS.decl("color", "var(--wc-layered-overview-muted)"),
                    CSS.decl("opacity", ".82")
                ),

                CSS.rule(
                    ".\(ClassName.groupSummary)",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(ClassName.cards)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "1fr"),
                    CSS.decl("gap", "9px")
                ),

                CSS.rule(
                    ".\(ClassName.card)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(170px, 230px) minmax(0, 1fr)"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("padding", "13px 16px"),
                    CSS.decl("border", "1px solid var(--wc-layered-overview-border-strong)"),
                    CSS.decl("border-radius", "15px"),
                    CSS.decl("background", "var(--wc-layered-overview-surface)"),
                    CSS.decl("box-shadow", "none"),
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".\(ClassName.card)::before",
                    CSS.decl("content", "none")
                ),

                CSS.rule(
                    ".\(ClassName.cardHeader)",
                    CSS.decl("display", "contents")
                ),

                CSS.rule(
                    ".\(ClassName.cardEyebrow)",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(ClassName.cardTitle)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.04rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("line-height", "1.22"),
                    CSS.decl("color", "var(--wc-layered-overview-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.cardSummary)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--wc-layered-overview-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.details), .\(ClassName.meta)",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(ClassName.chips)",
                    CSS.decl("grid-column", "2"),
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "7px"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("margin", "2px 0 0")
                ),

                CSS.rule(
                    ".\(ClassName.chip)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("width", "fit-content"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("padding", "6px 10px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("font-weight", "820"),
                    CSS.decl("line-height", "1.05"),
                    CSS.decl("letter-spacing", "-.01em"),
                    CSS.decl("color", "var(--wc-layered-overview-ink)"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color, var(--wc-layered-overview-ink)) 10%, var(--wc-layered-overview-surface))"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--link-color, var(--wc-layered-overview-ink)) 22%, var(--wc-layered-overview-border))")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(ClassName.root)",
                        CSS.decl("margin", "1.15rem 0 1.75rem")
                    ),

                    CSS.rule(
                        ".\(ClassName.groups)",
                        CSS.decl("gap", "16px")
                    ),

                    CSS.rule(
                        ".\(ClassName.groupHeader)",
                        CSS.decl("padding-top", "10px")
                    ),

                    CSS.rule(
                        ".\(ClassName.card)",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "5px"),
                        CSS.decl("padding", "13px 14px")
                    ),

                    CSS.rule(
                        ".\(ClassName.chips)",
                        CSS.decl("grid-column", "1"),
                        CSS.decl("margin-top", "4px")
                    ),

                    CSS.rule(
                        ".\(ClassName.cardTitle)",
                        CSS.decl("font-size", "1rem")
                    ),

                    CSS.rule(
                        ".\(ClassName.cardSummary)",
                        CSS.decl("font-size", ".9rem")
                    )
                )
            ]
        )
    }
}
