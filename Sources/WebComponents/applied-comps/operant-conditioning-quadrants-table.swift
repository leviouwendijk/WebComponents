import Constructors
import CSS
import HTML

public struct OperantConditioningQuadrantsTable: ReusableComponent, Sendable {
    private enum OutcomeDomain: String, Sendable {
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
    }

    private enum ClassName {
        static let root = "wc-operant-quadrants"
        static let stage = "wc-operant-quadrants__stage"
        static let header = "wc-operant-quadrants__header"
        static let eyebrow = "wc-operant-quadrants__eyebrow"
        static let title = "wc-operant-quadrants__title"
        static let lead = "wc-operant-quadrants__lead"
        static let viewport = "wc-operant-quadrants__viewport"
        static let matrix = "wc-operant-quadrants__matrix"
        static let corner = "wc-operant-quadrants__corner"
        static let axis = "wc-operant-quadrants__axis"
        static let axisTitle = "wc-operant-quadrants__axis-title"
        static let axisNote = "wc-operant-quadrants__axis-note"
        static let rowHead = "wc-operant-quadrants__row-head"
        static let sign = "wc-operant-quadrants__sign"
        static let rowTitle = "wc-operant-quadrants__row-title"
        static let rowNote = "wc-operant-quadrants__row-note"
        static let cell = "wc-operant-quadrants__cell"
        static let badges = "wc-operant-quadrants__badges"
        static let code = "wc-operant-quadrants__code"
        static let badge = "wc-operant-quadrants__badge"
        static let cellTitle = "wc-operant-quadrants__cell-title"
        static let cellText = "wc-operant-quadrants__cell-text"
        static let cellMeta = "wc-operant-quadrants__cell-meta"
        static let caption = "wc-operant-quadrants__caption"
    }

    public let id: String
    public let caption: String?
    public let includeStyles: Bool

    public init(
        id: String = "operant-conditioning-quadrants",
        caption: String? = "Positief en negatief gaan over toevoegen of wegnemen van een aantrekker of een afstoter; versterking en ontkrachting gaan over het effect de uitkomst heeft op de keuze/reactie.",
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
        id: String = "operant-conditioning-quadrants",
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
                    "aria-label": "Tabel van operante kwadranten: positieve en negatieve bekrachtiging versterken gedrag; positieve en negatieve bestraffing verzwakken gedrag."
                ]
            ) {
                header()

                HTML.div([ "class": ClassName.viewport ]) {
                    matrix()
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
                    CSS.decl("margin", "2rem 0"),
                    CSS.decl("--wc-operant-quadrants-ink", "var(--text-color, #17202a)"),
                    CSS.decl("--wc-operant-quadrants-muted", "var(--muted-text-color, rgba(32, 33, 36, .66))"),
                    CSS.decl("--wc-operant-quadrants-border", "var(--border-color, rgba(15, 23, 42, .12))"),
                    CSS.decl("--wc-operant-quadrants-surface", "var(--surface-color, #fff)"),
                    CSS.decl("--wc-operant-quadrants-soft", "var(--surface-soft-color, #f1f5f9)"),
                    CSS.decl("--wc-operant-quadrants-good", "var(--success, #2E8B57)"),
                    CSS.decl("--wc-operant-quadrants-bad", "var(--danger, #D64545)"),
                    CSS.decl("--wc-operant-quadrants-appetitive", "var(--success, #2E8B57)"),
                    CSS.decl("--wc-operant-quadrants-aversive", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("padding", "clamp(16px, 3vw, 24px)"),
                    CSS.decl("border", "1px solid var(--wc-operant-quadrants-border)"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-operant-quadrants-surface) 94%, var(--wc-operant-quadrants-ink) 6%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)")
                ),

                CSS.rule(
                    ".\(ClassName.header)",
                    CSS.decl("max-width", "720px"),
                    CSS.decl("margin-bottom", "18px")
                ),

                CSS.rule(
                    ".\(ClassName.eyebrow)",
                    CSS.decl("margin", "0 0 6px"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--wc-operant-quadrants-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.title)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(1.15rem, 2.2vw, 1.45rem)"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("color", "var(--wc-operant-quadrants-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.lead)",
                    CSS.decl("margin", "8px 0 0"),
                    CSS.decl("font-size", ".95rem"),
                    CSS.decl("line-height", "1.5"),
                    CSS.decl("color", "var(--wc-operant-quadrants-muted)")
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
                    CSS.decl("grid-template-columns", "150px repeat(2, minmax(240px, 1fr))"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("min-width", "720px")
                ),

                CSS.rule(
                    ".\(ClassName.axis), .\(ClassName.rowHead), .\(ClassName.cell)",
                    CSS.decl("border", "1px solid var(--wc-operant-quadrants-border)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-operant-quadrants-surface) 92%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.corner)",
                    CSS.decl("min-height", "0")
                ),

                CSS.rule(
                    ".\(ClassName.axis)",
                    CSS.decl("padding", "14px 16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-operant-quadrants-soft) 78%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.axisTitle), .\(ClassName.rowTitle)",
                    CSS.decl("font-weight", "850"),
                    CSS.decl("color", "var(--wc-operant-quadrants-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.axisNote), .\(ClassName.rowNote), .\(ClassName.cellText), .\(ClassName.cellMeta)",
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("line-height", "1.35"),
                    CSS.decl("color", "var(--wc-operant-quadrants-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.rowHead)",
                    CSS.decl("display", "grid"),
                    CSS.decl("align-content", "center"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("padding", "14px 16px")
                ),

                CSS.rule(
                    ".\(ClassName.sign)",
                    CSS.decl("display", "inline-grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "28px"),
                    CSS.decl("height", "28px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-operant-quadrants-ink) 9%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--wc-operant-quadrants-ink) 10%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.cell)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("min-height", "132px"),
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
                    CSS.decl("background", "var(--wc-operant-quadrants-good)")
                ),

                CSS.rule(
                    ".\(ClassName.cell)--punishment::before",
                    CSS.decl("background", "var(--wc-operant-quadrants-bad)")
                ),

                CSS.rule(
                    ".\(ClassName.badges)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", "6px")
                ),

                CSS.rule(
                    ".\(ClassName.code), .\(ClassName.badge)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("width", "fit-content"),
                    CSS.decl("padding", "4px 8px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-size", ".74rem"),
                    CSS.decl("font-weight", "820"),
                    CSS.decl("letter-spacing", ".02em"),
                    CSS.decl("color", "var(--wc-operant-quadrants-ink)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-operant-quadrants-ink) 8%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.code)",
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("font-size", ".8rem")
                ),

                CSS.rule(
                    ".\(ClassName.badge)--appetitive",
                    CSS.decl("color", "var(--wc-operant-quadrants-appetitive)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-operant-quadrants-appetitive) 12%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.badge)--aversive",
                    CSS.decl("color", "var(--wc-operant-quadrants-aversive)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-operant-quadrants-aversive) 10%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.cellTitle)",
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("color", "var(--wc-operant-quadrants-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.caption)",
                    CSS.decl("margin-top", "10px"),
                    CSS.decl("font-size", ".86rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--wc-operant-quadrants-muted)")
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
                        CSS.decl("grid-template-columns", "132px repeat(2, 246px)"),
                        CSS.decl("min-width", "650px")
                    )
                )
            ]
        )
    }

    private static func header() -> any HTMLNode {
        HTML.div([ "class": ClassName.header ]) {
            HTML.p([ "class": ClassName.eyebrow ]) {
                HTML.text("Operante conditionering · kwadranten")
            }

            HTML.el("h3", [ "class": ClassName.title ]) {
                HTML.text("Vier manieren waarop uitkomsten gedrag vormen")
            }

            HTML.p([ "class": ClassName.lead ]) {
                HTML.text("Positief en negatief zeggen of een uitkomst wordt geactiveerd of opgeheven. Versterking en ontkrachting zeggen of de keuze daarna toe- of afneemt. Appetitief en aversief zeggen of die uitkomst om een aantrekker of afstoter draait.")
            }
        }
    }

    private static func matrix() -> any HTMLNode {
        HTML.div(
            [
                "class": ClassName.matrix,
                "aria-label": "Operante kwadranten",
            ]
        ) {
            HTML.div(["class": ClassName.corner, "aria-hidden": "true"]) {}

            axis(
                title: "Versterkt keuze",
                note: "gedrag neemt toe in frequentie"
            )

            axis(
                title: "Verzwakt keuze",
                note: "gedrag neemt af in frequentie"
            )

            rowHead(
                sign: "+",
                title: "Activatie",
                note: "toevoeging"
            )

            quadrantCell(.positive_reinforcement)
            quadrantCell(.positive_punishment)

            rowHead(
                sign: "-",
                title: "Deactivatie",
                note: "opheffing"
            )

            quadrantCell(.negative_reinforcement)
            quadrantCell(.negative_punishment)
        }
    }

    private static func axis(
        title: String,
        note: String
    ) -> any HTMLNode {
        HTML.div([ "class": ClassName.axis ]) {
            HTML.div([ "class": ClassName.axisTitle ]) {
                HTML.text(title)
            }

            HTML.div([ "class": ClassName.axisNote ]) {
                HTML.text(note)
            }
        }
    }

    private static func rowHead(
        sign: String,
        title: String,
        note: String
    ) -> any HTMLNode {
        HTML.div([ "class": ClassName.rowHead ]) {
            HTML.span([ "class": ClassName.sign ]) {
                HTML.text(sign)
            }

            HTML.div([ "class": ClassName.rowTitle ]) {
                HTML.text(title)
            }

            HTML.div([ "class": ClassName.rowNote ]) {
                HTML.text(note)
            }
        }
    }

    private static func quadrantCell(
        _ quadrant: OperantQuadrant
    ) -> any HTMLNode {
        let domain = outcomeDomain(quadrant)

        return HTML.div(
            [
                "class": "\(ClassName.cell) \(ClassName.cell)--\(familyClass(quadrant)) \(ClassName.cell)--\(domain.rawValue)",
                "aria-label": "\(quadrant.code), \(domain.title): \(title(quadrant))"
            ]
        ) {
            HTML.div([ "class": ClassName.badges ]) {
                HTML.span([ "class": ClassName.code ]) {
                    HTML.text(quadrant.code)
                }

                HTML.span([ "class": "\(ClassName.badge) \(ClassName.badge)--\(domain.rawValue)" ]) {
                    HTML.text(domain.title)
                }
            }

            HTML.div([ "class": ClassName.cellTitle ]) {
                HTML.text(title(quadrant))
            }

            HTML.div([ "class": ClassName.cellText ]) {
                HTML.text(mechanism(quadrant))
            }

            HTML.div([ "class": ClassName.cellMeta ]) {
                HTML.text(effect(quadrant))
            }
        }
    }

    private static func outcomeDomain(
        _ quadrant: OperantQuadrant
    ) -> OutcomeDomain {
        switch quadrant {
        case .positive_reinforcement, .negative_punishment:
            return .appetitive
        case .positive_punishment, .negative_reinforcement:
            return .aversive
        }
    }

    private static func familyClass(
        _ quadrant: OperantQuadrant
    ) -> String {
        switch quadrant {
        case .positive_reinforcement, .negative_reinforcement:
            return "reinforcement"
        case .positive_punishment, .negative_punishment:
            return "punishment"
        }
    }

    private static func title(
        _ quadrant: OperantQuadrant
    ) -> String {
        switch quadrant {
        case .positive_reinforcement:
            return "Beloning"
        case .negative_reinforcement:
            return "Verlichting"
        case .positive_punishment:
            return "Correctie"
        case .negative_punishment:
            return "Verlies"
        }
    }

    private static func mechanism(
        _ quadrant: OperantQuadrant
    ) -> String {
        switch quadrant {
        case .positive_reinforcement:
            return "Toegang tot een motivator wordt verkregen als gevolg van de keuze."
        case .negative_reinforcement:
            return "Een demotivator, druk of ongemak wordt weggenomen (ontsnapping) als gevolg van de keuze."
        case .positive_punishment:
            return "Een demotivator, druk of ongemak wordt geactiveerd (vermijdbaar, niet-ontsnapbaar) als gevolg van de keuze."
        case .negative_punishment:
            return "Toegang tot een motivator wordt verloren als gevolg van de keuze."
        }
    }

    private static func effect(
        _ quadrant: OperantQuadrant
    ) -> String {
        switch quadrant {
        case .positive_reinforcement, .negative_reinforcement:
            return "De keuze wordt na deze ervaring waarschijnlijker."
        case .positive_punishment, .negative_punishment:
            return "De keuze wordt na deze ervaring minder waarschijnlijk."
        }
    }
}
