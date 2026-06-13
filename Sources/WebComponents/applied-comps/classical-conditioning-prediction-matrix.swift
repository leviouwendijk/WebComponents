import Constructors
import CSS
import HTML

public enum ClassicalConditioningPredictionDirection: String, Sendable, CaseIterable {
    case excitatory
    case inhibitory

    var code: String {
        switch self {
        case .excitatory:
            return "CS+"
        case .inhibitory:
            return "CS−"
        }
    }

    var title: String {
        switch self {
        case .excitatory:
            return "Excitatoir"
        case .inhibitory:
            return "Inhibitoir"
        }
    }

    var note: String {
        switch self {
        case .excitatory:
            return "verwachting neemt toe"
        case .inhibitory:
            return "verwachting neemt af"
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .excitatory:
            return "CS-plus, excitatoire prikkel"
        case .inhibitory:
            return "CS-min, inhibitoire prikkel"
        }
    }
}

public enum ClassicalConditioningOutcomeDomain: String, Sendable, CaseIterable {
    case appetitive
    case aversive

    var title: String {
        switch self {
        case .appetitive:
            return "Appetitief"
        case .aversive:
            return "Aversief"
        }
    }

    var note: String {
        switch self {
        case .appetitive:
            return "beloning, toegang, opbrengst"
        case .aversive:
            return "druk, dreiging, ongemak"
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .appetitive:
            return "appetitieve verwachting"
        case .aversive:
            return "aversieve verwachting"
        }
    }
}

public struct ClassicalConditioningPredictionMatrix: ReusableComponent, Sendable {
    private enum ClassName {
        static let root = "wc-classical-prediction"
        static let stage = "wc-classical-prediction__stage"
        static let header = "wc-classical-prediction__header"
        static let eyebrow = "wc-classical-prediction__eyebrow"
        static let title = "wc-classical-prediction__title"
        static let lead = "wc-classical-prediction__lead"
        static let viewport = "wc-classical-prediction__viewport"
        static let matrix = "wc-classical-prediction__matrix"
        static let corner = "wc-classical-prediction__corner"
        static let axis = "wc-classical-prediction__axis"
        static let axisTitle = "wc-classical-prediction__axis-title"
        static let axisNote = "wc-classical-prediction__axis-note"
        static let rowHead = "wc-classical-prediction__row-head"
        static let directionCode = "wc-classical-prediction__direction-code"
        static let rowTitle = "wc-classical-prediction__row-title"
        static let rowNote = "wc-classical-prediction__row-note"
        static let cell = "wc-classical-prediction__cell"
        static let badges = "wc-classical-prediction__badges"
        static let badge = "wc-classical-prediction__badge"
        static let cellTitle = "wc-classical-prediction__cell-title"
        static let cellText = "wc-classical-prediction__cell-text"
        static let cellMeta = "wc-classical-prediction__cell-meta"
        static let status = "wc-classical-prediction__status"
        static let statusHeader = "wc-classical-prediction__status-header"
        static let statusTitle = "wc-classical-prediction__status-title"
        static let statusText = "wc-classical-prediction__status-text"
        static let statusGrid = "wc-classical-prediction__status-grid"
        static let statusCard = "wc-classical-prediction__status-card"
        static let statusKicker = "wc-classical-prediction__status-kicker"
        static let caption = "wc-classical-prediction__caption"
    }

    public let id: String
    public let caption: String?
    public let includeStyles: Bool

    public init(
        id: String = "classical-conditioning-prediction-matrix",
        caption: String? = "CS+ verhoogt de verwachting van een gevolg; CS− remt of verlaagt die verwachting. Appetitief en aversief zeggen welk soort gevolg wordt verwacht.",
        includeStyles: Bool = true
    ) {
        self.id = id
        self.caption = caption
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                Self.figure_node(
                    id: id,
                    caption: caption
                )
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public static func figure_node(
        id: String = "classical-conditioning-prediction-matrix",
        caption: String? = nil
    ) -> any HTMLNode {
        HTML.figure(
            [
                "id": id,
                "class": ClassName.root
            ]
        ) {
            HTML.div(
                [
                    "class": ClassName.stage,
                    "role": "group",
                    "aria-label": "Matrix voor klassieke conditionering: CS-plus verhoogt verwachting, CS-min verlaagt verwachting; appetitief en aversief beschrijven het soort gevolg."
                ]
            ) {
                header()

                HTML.div([ "class": ClassName.viewport ]) {
                    matrix()
                    learningStatus()
                }
            }

            if let caption, !caption.isEmpty {
                HTML.figcaption([ "class": ClassName.caption ]) {
                    HTML.text(caption)
                }
            }
        }
    }

    public static func css() -> CSSStyleSheet {
        stylesheet()
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("width", "min(940px, 100%)"),
                    CSS.decl("margin", "2rem auto"),
                    CSS.decl("--wc-classical-prediction-ink", "var(--text-color, #17202a)"),
                    CSS.decl("--wc-classical-prediction-muted", "var(--muted-text-color, rgba(32, 33, 36, .66))"),
                    CSS.decl("--wc-classical-prediction-border", "var(--border-color, rgba(15, 23, 42, .12))"),
                    CSS.decl("--wc-classical-prediction-surface", "var(--surface-color, #fff)"),
                    CSS.decl("--wc-classical-prediction-soft", "var(--surface-soft-color, #f1f5f9)"),
                    CSS.decl("--wc-classical-prediction-excitatory", "var(--link-color, #2563eb)"),
                    CSS.decl("--wc-classical-prediction-inhibitory", "var(--warning, #E7A94E)"),
                    CSS.decl("--wc-classical-prediction-appetitive", "var(--success, #2E8B57)"),
                    CSS.decl("--wc-classical-prediction-aversive", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.root)",
                    CSS.decl("--wc-classical-prediction-ink", "var(--text-color, #f4f4f5)"),
                    CSS.decl("--wc-classical-prediction-muted", "var(--muted-text-color, rgba(244, 244, 245, .68))"),
                    CSS.decl("--wc-classical-prediction-border", "var(--border-color, rgba(255, 255, 255, .13))"),
                    CSS.decl("--wc-classical-prediction-surface", "var(--surface-color, #1b1c1f)"),
                    CSS.decl("--wc-classical-prediction-soft", "var(--surface-soft-color, #232429)")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("padding", "clamp(16px, 3vw, 24px)"),
                    CSS.decl("border", "1px solid var(--wc-classical-prediction-border)"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-prediction-surface) 96%, var(--wc-classical-prediction-ink) 4%)"),
                    CSS.decl("box-shadow", "0 18px 48px rgba(15, 23, 42, .08)")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.stage)",
                    CSS.decl("box-shadow", "0 18px 40px rgba(0, 0, 0, .28)")
                ),

                CSS.rule(
                    ".\(ClassName.header)",
                    CSS.decl("max-width", "760px"),
                    CSS.decl("margin-bottom", "18px")
                ),

                CSS.rule(
                    ".\(ClassName.eyebrow)",
                    CSS.decl("margin", "0 0 6px"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--wc-classical-prediction-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.title)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(1.15rem, 2.2vw, 1.45rem)"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("color", "var(--wc-classical-prediction-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.lead)",
                    CSS.decl("margin", "8px 0 0"),
                    CSS.decl("font-size", ".95rem"),
                    CSS.decl("line-height", "1.5"),
                    CSS.decl("color", "var(--wc-classical-prediction-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.viewport)",
                    CSS.decl("overflow-x", "auto"),
                    CSS.decl("overflow-y", "hidden"),
                    CSS.decl("-webkit-overflow-scrolling", "touch"),
                    CSS.decl("scrollbar-width", "thin"),
                    CSS.decl("padding-bottom", "4px")
                ),

                CSS.rule(
                    ".\(ClassName.matrix)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "150px repeat(2, minmax(250px, 1fr))"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("min-width", "760px")
                ),

                CSS.rule(
                    ".\(ClassName.axis), .\(ClassName.rowHead), .\(ClassName.cell)",
                    CSS.decl("border", "1px solid var(--wc-classical-prediction-border)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-prediction-surface) 92%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.corner)",
                    CSS.decl("min-height", "0")
                ),

                CSS.rule(
                    ".\(ClassName.axis)",
                    CSS.decl("padding", "14px 16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-prediction-soft) 78%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.axisTitle), .\(ClassName.rowTitle)",
                    CSS.decl("font-weight", "850"),
                    CSS.decl("color", "var(--wc-classical-prediction-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.axisNote), .\(ClassName.rowNote), .\(ClassName.cellText), .\(ClassName.cellMeta)",
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("line-height", "1.35"),
                    CSS.decl("color", "var(--wc-classical-prediction-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.rowHead)",
                    CSS.decl("display", "grid"),
                    CSS.decl("align-content", "center"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("padding", "14px 16px")
                ),

                CSS.rule(
                    ".\(ClassName.directionCode)",
                    CSS.decl("display", "inline-grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "42px"),
                    CSS.decl("height", "28px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-prediction-ink) 9%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--wc-classical-prediction-ink) 10%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.rowHead)--excitatory .\(ClassName.directionCode)",
                    CSS.decl("color", "var(--wc-classical-prediction-excitatory)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-prediction-excitatory) 12%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--wc-classical-prediction-excitatory) 24%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.rowHead)--inhibitory .\(ClassName.directionCode)",
                    CSS.decl("color", "var(--wc-classical-prediction-inhibitory)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-prediction-inhibitory) 14%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--wc-classical-prediction-inhibitory) 28%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.cell)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("min-height", "142px"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".\(ClassName.cell)::before",
                    CSS.decl("content", "''"),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "0"),
                    CSS.decl("top", "0"),
                    CSS.decl("bottom", "0"),
                    CSS.decl("width", "5px"),
                    CSS.decl("background", "var(--wc-classical-prediction-excitatory)")
                ),

                CSS.rule(
                    ".\(ClassName.cell)--inhibitory::before",
                    CSS.decl("background", "var(--wc-classical-prediction-inhibitory)")
                ),

                CSS.rule(
                    ".\(ClassName.badges)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "6px")
                ),

                CSS.rule(
                    ".\(ClassName.badge)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("width", "fit-content"),
                    CSS.decl("padding", "4px 8px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "820"),
                    CSS.decl("letter-spacing", ".02em"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-prediction-ink) 8%, transparent)"),
                    CSS.decl("color", "var(--wc-classical-prediction-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.badge)--excitatory",
                    CSS.decl("color", "var(--wc-classical-prediction-excitatory)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-prediction-excitatory) 12%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.badge)--inhibitory",
                    CSS.decl("color", "var(--wc-classical-prediction-inhibitory)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-prediction-inhibitory) 14%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.badge)--appetitive",
                    CSS.decl("color", "var(--wc-classical-prediction-appetitive)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-prediction-appetitive) 12%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.badge)--aversive",
                    CSS.decl("color", "var(--wc-classical-prediction-aversive)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-prediction-aversive) 10%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.cellTitle)",
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("color", "var(--wc-classical-prediction-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.cellMeta)",
                    CSS.decl("padding-top", "4px"),
                    CSS.decl("border-top", "1px solid color-mix(in srgb, var(--wc-classical-prediction-ink) 9%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.status)",
                    CSS.decl("min-width", "760px"),
                    CSS.decl("margin-top", "14px"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("border", "1px solid var(--wc-classical-prediction-border)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-prediction-soft) 60%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.statusHeader)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "3px"),
                    CSS.decl("margin-bottom", "10px")
                ),

                CSS.rule(
                    ".\(ClassName.statusTitle)",
                    CSS.decl("font-weight", "850"),
                    CSS.decl("color", "var(--wc-classical-prediction-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.statusText)",
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("line-height", "1.4"),
                    CSS.decl("color", "var(--wc-classical-prediction-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.statusGrid)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(4, minmax(150px, 1fr))"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".\(ClassName.statusCard)",
                    CSS.decl("display", "grid"),
                    CSS.decl("align-content", "start"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("min-height", "96px"),
                    CSS.decl("padding", "12px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--wc-classical-prediction-ink) 10%, transparent)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-prediction-surface) 88%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.statusKicker)",
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".06em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--wc-classical-prediction-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.caption)",
                    CSS.decl("margin-top", "10px"),
                    CSS.decl("font-size", ".86rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--wc-classical-prediction-muted)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 680px)",
                    CSS.rule(
                        ".\(ClassName.stage)",
                        CSS.decl("padding", "16px")
                    ),
                    CSS.rule(
                        ".\(ClassName.matrix)",
                        CSS.decl("grid-template-columns", "132px repeat(2, 248px)"),
                        CSS.decl("min-width", "650px")
                    ),
                    CSS.rule(
                        ".\(ClassName.status)",
                        CSS.decl("min-width", "650px")
                    ),
                    CSS.rule(
                        ".\(ClassName.statusGrid)",
                        CSS.decl("grid-template-columns", "repeat(4, 150px)")
                    )
                )
            ]
        )
    }

    private static func header() -> any HTMLNode {
        HTML.div([ "class": ClassName.header ]) {
            HTML.p([ "class": ClassName.eyebrow ]) {
                HTML.text("Klassieke conditionering · voorspelling")
            }

            HTML.el("h3", [ "class": ClassName.title ]) {
                HTML.text("CS+ en CS−: welke verwachting krijgt de prikkel?")
            }

            HTML.p([ "class": ClassName.lead ]) {
                HTML.text("Excitatoir en inhibitoir zeggen of een prikkel de verwachting van een gevolg verhoogt of verlaagt. Appetitief en aversief zeggen welk soort gevolg wordt verwacht.")
            }
        }
    }

    private static func matrix() -> any HTMLNode {
        HTML.div(
            [
                "class": ClassName.matrix,
                "aria-label": "Matrix van CS-plus en CS-min bij appetitieve en aversieve gevolgen"
            ]
        ) {
            HTML.div([ "class": ClassName.corner, "aria-hidden": "true" ]) {}

            axis(.appetitive)
            axis(.aversive)

            rowHead(.excitatory)

            cell(
                direction: .excitatory,
                domain: .appetitive,
                title: "Beloning of toegang verwacht",
                text: "De prikkel kondigt voer, spel, aandacht, vrijheid of toegang aan.",
                meta: "Typische richting: anticipatie, benadering of verwachting van opbrengst."
            )

            cell(
                direction: .excitatory,
                domain: .aversive,
                title: "Druk of dreiging verwacht",
                text: "De prikkel kondigt spanning, druk, ongemak, confrontatie of verlies van veiligheid aan.",
                meta: "Typische richting: spanning, voorbereiding, afstand zoeken of vermijden."
            )

            rowHead(.inhibitory)

            cell(
                direction: .inhibitory,
                domain: .appetitive,
                title: "Beloning of toegang blijft uit",
                text: "De prikkel remt de verwachting dat voer, spel, aandacht, vrijheid of toegang beschikbaar wordt.",
                meta: "Typische richting: no-access, frustratie of afname van benadering."
            )

            cell(
                direction: .inhibitory,
                domain: .aversive,
                title: "Druk blijft uit of stopt",
                text: "De prikkel remt de verwachting van druk, dreiging of ongemak, of kondigt veiligheid aan.",
                meta: "Typische richting: veiligheid, opluchting of afname van spanning."
            )
        }
    }

    private static func axis(
        _ domain: ClassicalConditioningOutcomeDomain
    ) -> any HTMLNode {
        HTML.div([ "class": "\(ClassName.axis) \(ClassName.axis)--\(domain.rawValue)" ]) {
            HTML.div([ "class": ClassName.axisTitle ]) {
                HTML.text(domain.title)
            }

            HTML.div([ "class": ClassName.axisNote ]) {
                HTML.text(domain.note)
            }
        }
    }

    private static func rowHead(
        _ direction: ClassicalConditioningPredictionDirection
    ) -> any HTMLNode {
        HTML.div([ "class": "\(ClassName.rowHead) \(ClassName.rowHead)--\(direction.rawValue)" ]) {
            HTML.span([ "class": ClassName.directionCode ]) {
                HTML.text(direction.code)
            }

            HTML.div([ "class": ClassName.rowTitle ]) {
                HTML.text(direction.title)
            }

            HTML.div([ "class": ClassName.rowNote ]) {
                HTML.text(direction.note)
            }
        }
    }

    private static func cell(
        direction: ClassicalConditioningPredictionDirection,
        domain: ClassicalConditioningOutcomeDomain,
        title: String,
        text: String,
        meta: String
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "\(ClassName.cell) \(ClassName.cell)--\(direction.rawValue) \(ClassName.cell)--\(domain.rawValue)",
                "aria-label": "\(direction.accessibilityLabel), \(domain.accessibilityLabel): \(title)"
            ]
        ) {
            HTML.div([ "class": ClassName.badges ]) {
                HTML.span([ "class": "\(ClassName.badge) \(ClassName.badge)--\(direction.rawValue)" ]) {
                    HTML.text(direction.code)
                }

                HTML.span([ "class": "\(ClassName.badge) \(ClassName.badge)--\(domain.rawValue)" ]) {
                    HTML.text(domain.title)
                }
            }

            HTML.div([ "class": ClassName.cellTitle ]) {
                HTML.text(title)
            }

            HTML.div([ "class": ClassName.cellText ]) {
                HTML.text(text)
            }

            HTML.div([ "class": ClassName.cellMeta ]) {
                HTML.text(meta)
            }
        }
    }

    private static func learningStatus() -> any HTMLNode {
        HTML.div([ "class": ClassName.status ]) {
            HTML.div([ "class": ClassName.statusHeader ]) {
                HTML.div([ "class": ClassName.statusTitle ]) {
                    HTML.text("Leerstatus: verwachting in beweging")
                }

                HTML.div([ "class": ClassName.statusText ]) {
                    HTML.text("Acquisitie, asymptoot en extinctie beschrijven niet het soort verwachting, maar de fase waarin die verwachting wordt opgebouwd, stabiel wordt of weer daalt.")
                }
            }

            HTML.div([ "class": ClassName.statusGrid ]) {
                statusCard(
                    kicker: "prediction error",
                    title: "Verwachting klopt nog niet",
                    text: "Er is verschil tussen wat de hond verwacht en wat er gebeurt."
                )

                statusCard(
                    kicker: "acquisitie",
                    title: "Verwachting wordt geleerd",
                    text: "De prikkel krijgt steeds meer voorspellende betekenis."
                )

                statusCard(
                    kicker: "asymptoot",
                    title: "Verwachting past bij patroon",
                    text: "De voorspelling is stabiel omdat de uitkomst betrouwbaar volgt."
                )

                statusCard(
                    kicker: "extinctie",
                    title: "CS+ zonder US",
                    text: "Een eerder geleerde verwachting daalt wanneer het gevolg uitblijft."
                )
            }
        }
    }

    private static func statusCard(
        kicker: String,
        title: String,
        text: String
    ) -> any HTMLNode {
        HTML.div([ "class": ClassName.statusCard ]) {
            HTML.div([ "class": ClassName.statusKicker ]) {
                HTML.text(kicker)
            }

            HTML.div([ "class": ClassName.statusTitle ]) {
                HTML.text(title)
            }

            HTML.div([ "class": ClassName.statusText ]) {
                HTML.text(text)
            }
        }
    }
}
