import Constructors
import CSS
import HTML
import JS

public struct ReactivityProfileTool: ReusableComponent, Sendable {
    public static let block = "wc-reactivity-profile-tool"

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
        let report = report_nodes()

        return .body(
            [
                HTML.main(
                    [
                        "id": "content-area",
                        "class": Self.block,
                        "data-reactivity-profile-tool": "",
                        "data-reactivity-submit-endpoint": "/connector/v2/reactivity-profile"
                    ]
                ) {
                    hero()

                    HTML.section(["class": "\(Self.block)__surface"]) {
                        HTML.div(["class": "\(Self.block)__mount", "data-reactivity-mount": ""]) {}
                    }

                    report.body
                }
            ],
            stylesheets: (includeStyles ? [Self.stylesheet()] : []) + report.stylesheets,
            scripts: (includeScript ? ReactivityProfileToolScript().nodes.scripts : []) + report.scripts
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    private func report_nodes() -> ReusableComponentNodes {
        PrintableReportView(
            report: report(
                id: "reactivity-profile-report",
                title: "Reactiviteitsprofiel",
                subtitle: "Samenvatting van cluster, gedragsassen, behandelmodifiers en trainingsprioriteit.",
                meta: [
                    meta("Hulpmiddel", "Reactiviteitsprofiel"),
                    meta("Hond", slot("dogName", fallback: "—")),
                    meta("Datum", slot("date")),
                    meta("Status", slot("status", fallback: "Nog niet berekend"))
                ],
                options: .init(
                    styles: includeStyles,
                    script: includeScript
                )
            ) {
                summary(
                    "Deze uitdraai vat de huidige inschatting van het reactiviteitsprofiel samen. Gebruik dit als werkdocument voor analyse en trainingsplanning."
                )

                fields("Profiel") {
                    field("Hoofdcluster", slot("primary", fallback: "Nog niet compleet"))
                    field("Ernst", slot("severity", fallback: "Open"))
                    field("Clusterduiding", slot("summary", fallback: "Vul eerst alle gedragingen in."))
                    field("Ingevulde gedragingen", slot("completeness", fallback: "0/9"))
                    field("Ingevulde modifiers", slot("modifierCompleteness", fallback: "0/0"))
                }

                metrics("Gedragsassen") {
                    metric("Orale aanval", slot("oralAttack", fallback: "—"))
                    metric("Frustratie", slot("frustrationAxis", fallback: "—"))
                    metric("Posturing", slot("posturing", fallback: "—"))
                }

                metrics("Behandelmodifiers") {
                    metric("Frustratiedruk", slot("frustrationPressure", fallback: "—"))
                    metric("Escalatierisico", slot("escalationRisk", fallback: "—"))
                    metric("Managementbehoefte", slot("managementNeed", fallback: "—"))
                }

                fields("Training") {
                    field("Prioriteit", slot("priorities", fallback: "Nog geen prioriteit berekend."))
                    field("Cluster-overeenkomst", slot("matches", fallback: "Nog geen matches berekend."))
                }

                notice(
                    "Gebruik",
                    "Dit profiel is een hulpmiddel voor analyse en planning. Het vervangt geen professionele beoordeling van veiligheid, context en leerhistorie.",
                    tone: .info
                )

                notes(
                    "Aantekeningen",
                    placeholder: "Ruimte voor context, observaties, veiligheidsmarge en vervolgstappen."
                )
            },
            bind: .client(
                source: "#content-area",
                collector: "wcReactivityProfileTool.collectReport"
            )
        ).nodes
    }

    private func hero() -> any HTMLNode {
        HTML.section(["class": "\(Self.block)__hero"]) {
            HTML.p(["class": "\(Self.block)__eyebrow"]) {
                HTML.text("Hulpmiddel · reactiviteit")
            }

            HTML.h1 {
                HTML.text("Reactiviteitsprofiel")
            }

            HTML.p(["class": "\(Self.block)__lead"]) {
                HTML.text("Schat welk reactiepatroon het meest lijkt op het gedrag van de hond, en welke behandelmodifiers extra aandacht vragen.")
            }

            HTML.div(["class": "\(Self.block)__note"]) {
                HTML.strong {
                    HTML.text("Geen diagnose.")
                }

                HTML.span {
                    HTML.text(" Dit hulpmiddel gebruikt de gedragsassen uit het DRD-onderzoek als rekenlaag, maar vertaalt de uitkomst naar een Hondenmeesters-profiel voor risico, frustratiedruk en trainingsprioriteit.")
                }
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("width", "min(1120px, calc(100% - 32px))"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "clamp(28px, 5vw, 56px) 0"),
                    CSS.decl("color", "var(--text-color, #202124)")
                ),

                CSS.rule(
                    ".\(block), .\(block) *",
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(block)__hero",
                    CSS.decl("max-width", "860px"),
                    CSS.decl("margin", "0 0 28px")
                ),

                CSS.rule(
                    ".\(block)__eyebrow",
                    CSS.decl("margin", "0 0 8px"),
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("font-weight", "780"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__hero h1",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(2.2rem, 6vw, 5rem)"),
                    CSS.decl("line-height", ".95"),
                    CSS.decl("letter-spacing", "-.055em")
                ),

                CSS.rule(
                    ".\(block)__lead",
                    CSS.decl("margin", "18px 0 0"),
                    CSS.decl("font-size", "1.08rem"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__note",
                    CSS.decl("display", "block"),
                    CSS.decl("margin", "18px 0 0"),
                    CSS.decl("padding", "14px 16px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 7%, transparent)"),
                    CSS.decl("font-size", ".94rem"),
                    CSS.decl("line-height", "1.5")
                ),

                CSS.rule(
                    ".\(block)__surface",
                    CSS.decl("padding", "clamp(16px, 3vw, 24px)"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "26px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #fff) 96%, var(--text-color) 4%)"),
                    CSS.decl("box-shadow", "0 18px 48px rgba(15, 23, 42, .08)")
                ),

                CSS.rule(
                    ".\(block)__grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(0, 1fr) minmax(320px, .78fr)"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("align-items", "start")
                ),

                CSS.rule(
                    ".\(block)__panel",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "14px"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "20px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #fff) 90%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__panel h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.05rem"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".\(block)__hint",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".92rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__fields",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".\(block)__field",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(170px, 1fr) minmax(260px, .95fr)"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("padding", "12px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #fff) 88%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__field span",
                    CSS.decl("font-size", ".95rem"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("line-height", "1.3")
                ),

                CSS.rule(
                    ".\(block)__field small",
                    CSS.decl("display", "block"),
                    CSS.decl("margin-top", "4px"),
                    CSS.decl("font-size", ".8rem"),
                    CSS.decl("font-weight", "450"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__choice-group",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-auto-flow", "column"),
                    CSS.decl("grid-auto-columns", "minmax(0, 1fr)"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("align-items", "stretch")
                ),

                CSS.rule(
                    ".\(block)__choice",
                    CSS.decl("appearance", "none"),
                    CSS.decl("-webkit-appearance", "none"),
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("min-height", "34px"),
                    CSS.decl("padding", "7px 9px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", ".8rem"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("background", "var(--surface-color, #fff)"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("transition", "background-color .14s ease, border-color .14s ease, color .14s ease, box-shadow .14s ease, transform .14s ease")
                ),

                CSS.rule(
                    ".\(block)__choice:hover",
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 35%, var(--border-color))"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block)__choice:active",
                    CSS.decl("transform", "scale(.98)")
                ),

                CSS.rule(
                    ".\(block)__choice:focus-visible",
                    CSS.decl("outline", "2px solid var(--link-color)"),
                    CSS.decl("outline-offset", "2px")
                ),

                CSS.rule(
                    ".\(block)__choice--selected",
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 48%, var(--border-color))"),
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 14%, var(--surface-color, #fff))"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--link-color) 12%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__result-head",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("padding", "16px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--severity-color, var(--link-color)) 22%, var(--border-color))"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "linear-gradient(135deg, color-mix(in srgb, var(--severity-color, var(--link-color)) 13%, transparent), color-mix(in srgb, var(--surface-color, #fff) 92%, transparent))")
                ),

                CSS.rule(
                    ".\(block)__result-topline",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "flex-start"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "12px")
                ),

                CSS.rule(
                    ".\(block)__result-title",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(block)__result-head strong",
                    CSS.decl("font-size", "1.28rem"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("letter-spacing", "-.025em")
                ),

                CSS.rule(
                    ".\(block)__result-head span",
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.42"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__severity-pill",
                    CSS.decl("flex", "0 0 auto"),
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("height", "28px"),
                    CSS.decl("padding", "0 10px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-size", ".74rem"),
                    CSS.decl("font-weight", "820"),
                    CSS.decl("letter-spacing", ".02em"),
                    CSS.decl("white-space", "nowrap"),
                    CSS.decl("color", "color-mix(in srgb, var(--severity-color, var(--link-color)) 74%, var(--text-color))"),
                    CSS.decl("background", "color-mix(in srgb, var(--severity-color, var(--link-color)) 13%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--severity-color, var(--link-color)) 24%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__severity-rail",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(4, minmax(0, 1fr))"),
                    CSS.decl("gap", "5px"),
                    CSS.decl("align-items", "center")
                ),

                CSS.rule(
                    ".\(block)__severity-step",
                    CSS.decl("height", "6px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 11%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__severity-step--active",
                    CSS.decl("background", "var(--severity-color, var(--link-color))")
                ),

                CSS.rule(
                    ".\(block)__section-title",
                    CSS.decl("margin", "2px 0 -2px"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("letter-spacing", ".055em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color) 74%, var(--muted-text-color))")
                ),

                CSS.rule(
                    ".\(block)__stack",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "9px")
                ),

                CSS.rule(
                    ".\(block)__cluster-metric",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("padding", "9px 0"),
                    CSS.decl("border-top", "1px solid color-mix(in srgb, var(--text-color) 8%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__cluster-metric:not(.\(block)__cluster-metric--primary):first-child",
                    CSS.decl("border-top", "0"),
                    CSS.decl("padding-top", "0")
                ),

                CSS.rule(
                    ".\(block)__cluster-metric--primary",
                    CSS.decl("padding", "10px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--severity-color, var(--link-color)) 20%, var(--border-color))"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "color-mix(in srgb, var(--severity-color, var(--link-color)) 7%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__cluster-top",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "1fr auto"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("align-items", "baseline")
                ),

                CSS.rule(
                    ".\(block)__cluster-title",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "7px"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "800")
                ),

                CSS.rule(
                    ".\(block)__severity-dot",
                    CSS.decl("display", "inline-block"),
                    CSS.decl("flex", "0 0 auto"),
                    CSS.decl("width", "8px"),
                    CSS.decl("height", "8px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "var(--severity-color, var(--link-color))"),
                    CSS.decl("box-shadow", "0 0 0 3px color-mix(in srgb, var(--severity-color, var(--link-color)) 14%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__cluster-percent",
                    CSS.decl("font-size", ".85rem"),
                    CSS.decl("font-weight", "820")
                ),

                CSS.rule(
                    ".\(block)__cluster-meta",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("line-height", "1.35"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__metric",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "6px")
                ),

                CSS.rule(
                    ".\(block)__metric--secondary",
                    CSS.decl("opacity", ".82")
                ),

                CSS.rule(
                    ".\(block)__metric-top",
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("font-size", ".88rem"),
                    CSS.decl("font-weight", "760")
                ),

                CSS.rule(
                    ".\(block)__axes-grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(3, minmax(0, 1fr))"),
                    CSS.decl("gap", "8px")
                ),

                CSS.rule(
                    ".\(block)__axis-card",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("padding", "10px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #fff) 86%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__axis-label",
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("font-weight", "820"),
                    CSS.decl("letter-spacing", ".045em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__axis-band",
                    CSS.decl("font-size", ".96rem"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("line-height", "1.05")
                ),

                CSS.rule(
                    ".\(block)__axis-score",
                    CSS.decl("font-size", ".74rem"),
                    CSS.decl("font-family", "\"DM Mono\", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__bar",
                    CSS.decl("height", "8px"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 10%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__bar > span",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "var(--value, 0%)"),
                    CSS.decl("height", "100%"),
                    CSS.decl("border-radius", "inherit"),
                    CSS.decl("background", "var(--severity-color, var(--link-color))")
                ),

                CSS.rule(
                    ".\(block)__priority-list",
                    CSS.decl("margin", "0"),
                    CSS.decl("padding-left", "20px"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__identity-card",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", ".75rem"),
                    CSS.decl("padding", "1rem"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--border-color) 76%, transparent)"),
                    CSS.decl("border-radius", "1rem"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #fff) 92%, var(--link-color) 5%)")
                ),

                CSS.rule(
                    ".\(block)__identity-card h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1rem")
                ),

                CSS.rule(
                    ".\(block)__input-grid",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(2, minmax(0, 1fr))"),
                    CSS.decl("gap", ".75rem")
                ),

                CSS.rule(
                    ".\(block)__label",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", ".35rem"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color) 78%, var(--muted-text-color))")
                ),

                CSS.rule(
                    ".\(block)__input",
                    CSS.decl("width", "100%"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", ".85rem"),
                    CSS.decl("padding", ".72rem .82rem"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("background", "var(--surface-color, #fff)"),
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block)__input:focus",
                    CSS.decl("outline", "2px solid color-mix(in srgb, var(--link-color) 42%, transparent)"),
                    CSS.decl("outline-offset", "2px")
                ),

                CSS.rule(
                    ".\(block)__submit-card",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", ".85rem"),
                    CSS.decl("margin-top", "1rem"),
                    CSS.decl("padding", "1rem"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--border-color) 76%, transparent)"),
                    CSS.decl("border-radius", "1rem"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #fff) 94%, var(--link-color) 4%)")
                ),

                CSS.rule(
                    ".\(block)__submit-card h2",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1rem")
                ),

                CSS.rule(
                    ".\(block)__inline-actions",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", ".65rem"),
                    CSS.decl("align-items", "stretch")
                ),

                CSS.rule(
                    ".\(block)__submit-card .\(block)__inline-actions",
                    CSS.decl("width", "100%")
                ),

                CSS.rule(
                    ".\(block)__action",
                    CSS.decl("-webkit-appearance", "none"),
                    CSS.decl("appearance", "none"),
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", ".35rem"),
                    CSS.decl("width", "100%"),
                    CSS.decl("min-height", "44px"),
                    CSS.decl("padding", ".82rem 1.05rem"),
                    CSS.decl("border-radius", ".75rem"),
                    CSS.decl("border", "1px solid var(--cta-border, transparent)"),
                    CSS.decl("background", "var(--gray-800, #1f2937)"),
                    CSS.decl("color", "var(--cta-fg, #fff)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", ".95rem"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("line-height", "1.1"),
                    CSS.decl("text-align", "center"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("box-shadow", "none"),
                    CSS.decl("transition", "transform .06s ease, background .12s ease, border-color .12s ease, opacity .12s ease")
                ),

                CSS.rule(
                    ".\(block)__action:hover",
                    CSS.decl("background", "var(--gray-700, #374151)"),
                    CSS.decl("border-color", "var(--cta-hover-bg, var(--gray-700, #374151))"),
                    CSS.decl("transform", "translateY(-1px)")
                ),

                CSS.rule(
                    ".\(block)__action:focus-visible",
                    CSS.decl("outline", "2px solid color-mix(in srgb, var(--link-color) 48%, transparent)"),
                    CSS.decl("outline-offset", "3px")
                ),

                CSS.rule(
                    ".\(block)__action:disabled",
                    CSS.decl("background", "var(--gray-700, #374151)"),
                    CSS.decl("opacity", ".55"),
                    CSS.decl("cursor", "default"),
                    CSS.decl("transform", "none")
                ),

                CSS.rule(
                    ".\(block)__action[data-reactivity-submit-open]",
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #fff) 88%, var(--text-color) 12%)"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("border-color", "color-mix(in srgb, var(--border-color) 82%, var(--text-color) 12%)")
                ),

                CSS.rule(
                    ".\(block)__action[data-reactivity-submit-open]:hover",
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #fff) 80%, var(--text-color) 20%)")
                ),

                CSS.rule(
                    ".\(block)__action[data-reactivity-submit-open][aria-expanded=\"true\"]",
                    CSS.decl("background", "var(--gray-800, #1f2937)"),
                    CSS.decl("color", "var(--cta-fg, #fff)"),
                    CSS.decl("border-color", "var(--gray-800, #1f2937)")
                ),

                CSS.rule(
                    ".\(block)__submit-consent input",
                    CSS.decl("accent-color", "var(--gray-800, #1f2937)"),
                    CSS.decl("width", "1rem"),
                    CSS.decl("height", "1rem"),
                    CSS.decl("margin-top", ".15rem"),
                    CSS.decl("flex", "0 0 auto")
                ),

                CSS.rule(
                    ".\(block)__submit-panel",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", ".75rem")
                ),

                CSS.rule(
                    ".\(block)__submit-panel[hidden]",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(block)__submit-consent",
                    CSS.decl("display", "flex"),
                    CSS.decl("gap", ".55rem"),
                    CSS.decl("align-items", "flex-start"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__submit-status",
                    CSS.decl("min-height", "1.2rem"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("font-weight", "750")
                ),

                CSS.rule(
                    ".\(block)__submit-status[data-state=\"loading\"]",
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__submit-status[data-state=\"error\"]",
                    CSS.decl("color", "var(--danger, #D64545)")
                ),

                CSS.rule(
                    ".\(block)__submit-status[data-state=\"success\"]",
                    CSS.decl("color", "var(--success, #2E8B57)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 860px)",
                    CSS.rule(
                        ".\(block)__grid",
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        ".\(block)__field",
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        ".\(block)__choice-group",
                        CSS.decl("grid-auto-flow", "row"),
                        CSS.decl("grid-auto-columns", "auto")
                    ),
                    CSS.rule(
                        ".\(block)__field[data-reactivity-behaviour] .\(block)__choice-group",
                        CSS.decl("grid-template-columns", "repeat(3, minmax(0, 1fr))")
                    ),
                    CSS.rule(
                        ".\(block)__field[data-reactivity-modifier] .\(block)__choice-group",
                        CSS.decl("grid-template-columns", "repeat(2, minmax(0, 1fr))")
                    ),
                    CSS.rule(
                        ".\(block)__input-grid",
                        CSS.decl("grid-template-columns", "1fr")
                    )
                ),

                CSS.media(
                    "(max-width: 520px)",
                    CSS.rule(
                        ".\(block)__axes-grid",
                        CSS.decl("grid-template-columns", "1fr")
                    ),
                    CSS.rule(
                        ".\(block)__result-topline",
                        CSS.decl("display", "grid")
                    ),
                    CSS.rule(
                        ".\(block)__severity-pill",
                        CSS.decl("width", "fit-content")
                    )
                )
            ]
        )
    }
}

public struct ReactivityProfileToolScript: ReusableComponent {
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
        if (window.wcReactivityProfileTool?.initialized) return;

        const rootSelector = '[data-reactivity-profile-tool]';
        const tau = 1.1;

        const behaviours = [
            ['nipping', 'Happen / nippen', 'korte contactpoging met tanden'],
            ['biting', 'Bijten', 'contact met beet of schade-risico'],
            ['snapping', 'Snappen', 'lucht-hap of snelle dreigbeet'],
            ['barking', 'Blaffen', 'herhaald of intens blaffen naar honden'],
            ['lunging', 'Uitvallen', 'naar voren schieten of in de lijn hangen'],
            ['whining', 'Piepen / janken', 'vocale spanning of frustratie'],
            ['growling', 'Grommen', 'laag dreigend geluid'],
            ['snarling', 'Lip optrekken', 'tanden tonen / snauwen'],
            ['stiff_posture', 'Stijf fixeren', 'stijve houding, hackles, intense stare']
        ];

        const modifiers = [
            ['restraint', 'Lijn- / barrière-effect', 'Wordt het duidelijk erger aan lijn, hek, raam, deur of auto?'],
            ['recovery', 'Lang herstel na prikkel', 'Blijft de hond lang hoog na een ontmoeting?'],
            ['distance', 'Hoge afstandsbehoefte', 'Is er veel afstand nodig om bereikbaar of veilig hanteerbaar te blijven?'],
            ['disengage', 'Moeite met loskomen', 'Blijft de hond vastzitten op de prikkel en is wegkijken, snuffelen, eten of terugkoppelen moeilijk?'],
            ['contact', 'Contactgeschiedenis', 'Is er eerder fysiek contact of schade geweest?'],
            ['redirect', 'Herleidings-risico', 'Richt spanning zich soms op lijn, geleider of huisgenoot (misplaatst bijten)?'],
            ['handling', 'Beperkte controleerbaarheid', 'Is het moeilijk om veilig afstand te maken, de hond te houden of de situatie hanteerbaar te houden?']
        ];

        const frequencyOptions = [
            [0, 'Nooit'],
            [1, 'Soms'],
            [2, 'Vaak']
        ];

        const modifierOptions = [
            [0, 'Niet'],
            [1, 'Soms'],
            [2, 'Duidelijk'],
            [3, 'Sterk']
        ];

        const clusters = {
            1: {
                name: 'Lage-risico signaleerder',
                tag: 'Cluster 1',
                severity: 1,
                severityLabel: 'mild',
                tone: 'var(--success, #2E8B57)',
                summary: 'veel communicatie, weinig orale escalatie'
            },
            2: {
                name: 'Frustratie-escalator',
                tag: 'Cluster 2',
                severity: 2,
                severityLabel: 'matig',
                tone: 'var(--warning, #E7A94E)',
                summary: 'hoge frustratie, vooral bij blokkade of beperking'
            },
            3: {
                name: 'Impulsieve escalator',
                tag: 'Cluster 3',
                severity: 3,
                severityLabel: 'hoog',
                tone: 'color-mix(in srgb, var(--warning, #E7A94E) 52%, var(--danger, #D64545))',
                summary: 'meer posturale spanning en contactrisico, ook zonder extreme frustratie'
            },
            4: {
                name: 'Snelle risico-escalator',
                tag: 'Cluster 4',
                severity: 4,
                severityLabel: 'zeer hoog',
                tone: 'var(--danger, #D64545)',
                summary: 'hoog over alle assen; veiligheidsmarge eerst vergroten'
            }
        };

        const loadings = {
            pc1: { nipping: .873, biting: .855, snapping: .629, barking: -.128, lunging: .108, whining: .096, growling: -.038, snarling: .225, stiff_posture: .041 },
            pc2: { nipping: .046, biting: .029, snapping: -.038, barking: .766, lunging: .738, whining: .641, growling: .060, snarling: -.161, stiff_posture: .144 },
            pc3: { nipping: -.027, biting: -.043, snapping: .324, barking: .245, lunging: .150, whining: -.292, growling: .822, snarling: .722, stiff_posture: .580 }
        };

        const means = {
            1: [.3472, 1.8517, 1.1995],
            2: [.7747, 3.6694, 2.0571],
            3: [1.7016, 1.9332, 2.6665],
            4: [3.2282, 3.5188, 4.1659]
        };

        const clamp = (value, min = 0, max = 1) => Math.min(max, Math.max(min, value));
        const pct = value => Math.round(clamp(value) * 100);

        function choicesHTML(options, currentValue = '') {
            return options.map(([value, label]) => {
                const selected = currentValue !== '' && String(value) === String(currentValue);

                return `
                    <button
                        class="wc-reactivity-profile-tool__choice${selected ? ' wc-reactivity-profile-tool__choice--selected' : ''}"
                        type="button"
                        data-reactivity-choice
                        data-reactivity-value="${value}"
                        aria-pressed="${selected ? 'true' : 'false'}"
                    >${label}</button>
                `;
            }).join('');
        }

        function severityRailHTML(severity) {
            return `
                <div class="wc-reactivity-profile-tool__severity-rail" aria-hidden="true">
                    ${[1, 2, 3, 4].map(step => `
                        <span class="wc-reactivity-profile-tool__severity-step${step <= severity ? ' wc-reactivity-profile-tool__severity-step--active' : ''}"></span>
                    `).join('')}
                </div>
            `;
        }

        function metricHTML(label, value, detail = '', variant = '') {
            return `
                <div class="wc-reactivity-profile-tool__metric${variant ? ` wc-reactivity-profile-tool__metric--${variant}` : ''}">
                    <div class="wc-reactivity-profile-tool__metric-top">
                        <span>${label}</span>
                        <span>${value}%</span>
                    </div>

                    <div class="wc-reactivity-profile-tool__bar" aria-hidden="true">
                        <span style="--value: ${value}%"></span>
                    </div>

                    ${detail ? `<p class="wc-reactivity-profile-tool__hint">${detail}</p>` : ''}
                </div>
            `;
        }

        function clusterMatchHTML(row, isPrimary = false) {
            const cluster = clusters[row.id];
            const value = Math.round(row.match);

            return `
                <div
                    class="wc-reactivity-profile-tool__cluster-metric${isPrimary ? ' wc-reactivity-profile-tool__cluster-metric--primary' : ''}"
                    style="--severity-color: ${cluster.tone}"
                >
                    <div class="wc-reactivity-profile-tool__cluster-top">
                        <div class="wc-reactivity-profile-tool__cluster-title">
                            <span class="wc-reactivity-profile-tool__severity-dot" aria-hidden="true"></span>
                            <span>${cluster.name}</span>
                        </div>

                        <div class="wc-reactivity-profile-tool__cluster-percent">${value}%</div>
                    </div>

                    <div class="wc-reactivity-profile-tool__bar" aria-hidden="true">
                        <span style="--value: ${value}%"></span>
                    </div>

                    <p class="wc-reactivity-profile-tool__cluster-meta">
                        ${cluster.tag} · ernst: ${cluster.severityLabel} · ${cluster.summary}
                    </p>
                </div>
            `;
        }

        function axisCardHTML(label, value, score, band) {
            return `
                <div class="wc-reactivity-profile-tool__axis-card">
                    <div class="wc-reactivity-profile-tool__axis-label">${label}</div>
                    <div class="wc-reactivity-profile-tool__axis-band">${band}</div>

                    <div class="wc-reactivity-profile-tool__bar" aria-hidden="true">
                        <span style="--value: ${value}%"></span>
                    </div>

                    <div class="wc-reactivity-profile-tool__axis-score">${score.toFixed(2)}</div>
                </div>
            `;
        }

        function fieldHTML(kind, item) {
            const [key, label, help] = item;
            const attr = kind === 'behaviour' ? 'data-reactivity-behaviour' : 'data-reactivity-modifier';
            const options = kind === 'behaviour' ? frequencyOptions : modifierOptions;

            return `
                <div class="wc-reactivity-profile-tool__field" ${attr}="${key}" data-reactivity-field data-value="">
                    <div class="wc-reactivity-profile-tool__field-copy">
                        <span>${label}<small>${help}</small></span>
                    </div>

                    <div class="wc-reactivity-profile-tool__choice-group" role="group" aria-label="${label}">
                        ${choicesHTML(options, '')}
                    </div>
                </div>
            `;
        }

        function render(root) {
            const mount = root.querySelector('[data-reactivity-mount]');
            if (!mount || mount.dataset.ready) return;

            mount.dataset.ready = 'true';
            mount.innerHTML = `
                <div class="wc-reactivity-profile-tool__grid">
                    <div class="wc-reactivity-profile-tool__panel">
                        <div class="wc-reactivity-profile-tool__identity-card">
                            <h2>Rapportgegevens</h2>
                            <p class="wc-reactivity-profile-tool__hint">Optioneel voor lokaal gebruik. De naam komt mee in het printbare rapport.</p>

                            <label class="wc-reactivity-profile-tool__label">
                                Naam hond
                                <input
                                    class="wc-reactivity-profile-tool__input"
                                    type="text"
                                    autocomplete="off"
                                    data-reactivity-dog-name
                                    placeholder="Bijvoorbeeld: Nala"
                                >
                            </label>
                        </div>

                        <h2>Gedragingen bij andere honden</h2>
                        <p class="wc-reactivity-profile-tool__hint">Deze negen gedragingen vormen de paper-derived rekenlaag. Vul in hoe vaak ze optreden tijdens reactiviteit naar honden.</p>
                        <div class="wc-reactivity-profile-tool__fields">${behaviours.map(item => fieldHTML('behaviour', item)).join('')}</div>

                        <h2>Behandelmodifiers</h2>
                        <p class="wc-reactivity-profile-tool__hint">Deze risicofactoren veranderen de paper-cluster niet. Ze sturen alleen veiligheidsmarge, herstel, afstand, controleerbaarheid en arousal-outlet.</p>
                        <div class="wc-reactivity-profile-tool__fields">${modifiers.map(item => fieldHTML('modifier', item)).join('')}</div>
                    </div>

                    <aside class="wc-reactivity-profile-tool__panel" aria-live="polite">
                        <div class="wc-reactivity-profile-tool__result-head" data-reactivity-result-head>
                            <div class="wc-reactivity-profile-tool__result-topline">
                                <div class="wc-reactivity-profile-tool__result-title">
                                    <strong data-reactivity-primary>—</strong>
                                    <span data-reactivity-summary>Vul de observaties in om het profiel te berekenen.</span>
                                </div>

                                <div class="wc-reactivity-profile-tool__severity-pill" data-reactivity-severity>—</div>
                            </div>

                            <div data-reactivity-severity-rail></div>
                        </div>

                        <h2 class="wc-reactivity-profile-tool__section-title">Cluster-overeenkomst</h2>
                        <div class="wc-reactivity-profile-tool__stack" data-reactivity-matches></div>

                        <h2 class="wc-reactivity-profile-tool__section-title">Gedragsassen</h2>
                        <div class="wc-reactivity-profile-tool__axes-grid" data-reactivity-axes></div>

                        <h2 class="wc-reactivity-profile-tool__section-title">Behandelmodifiers</h2>
                        <div class="wc-reactivity-profile-tool__stack" data-reactivity-modifiers></div>

                        <h2 class="wc-reactivity-profile-tool__section-title">Trainingsprioriteit</h2>
                        <ol class="wc-reactivity-profile-tool__priority-list" data-reactivity-priorities></ol>

                        <div class="wc-reactivity-profile-tool__submit-card">
                            <h2>Profiel delen</h2>
                            <p class="wc-reactivity-profile-tool__hint">Stuur het ingevulde profiel veilig naar Hondenmeesters. Hiervoor zijn hondnaam, jouw naam, contact en beveiligingscontrole verplicht.</p>

                            <div class="wc-reactivity-profile-tool__inline-actions">
                                <button class="wc-reactivity-profile-tool__action" type="button" data-reactivity-submit-open aria-expanded="false">
                                    Stuur naar Hondenmeesters
                                </button>
                            </div>

                            <form class="wc-reactivity-profile-tool__submit-panel" data-reactivity-submit-form hidden>
                                <div class="wc-reactivity-profile-tool__input-grid">
                                    <label class="wc-reactivity-profile-tool__label">
                                        Naam hond
                                        <input class="wc-reactivity-profile-tool__input" type="text" autocomplete="off" data-reactivity-submit-dog-name required>
                                    </label>

                                    <label class="wc-reactivity-profile-tool__label">
                                        Jouw naam
                                        <input class="wc-reactivity-profile-tool__input" type="text" autocomplete="name" data-reactivity-submit-owner-name required>
                                    </label>

                                    <label class="wc-reactivity-profile-tool__label">
                                        E-mailadres
                                        <input class="wc-reactivity-profile-tool__input" type="email" autocomplete="email" data-reactivity-submit-email>
                                    </label>

                                    <label class="wc-reactivity-profile-tool__label">
                                        Telefoonnummer
                                        <input class="wc-reactivity-profile-tool__input" type="tel" autocomplete="tel" data-reactivity-submit-phone>
                                    </label>
                                </div>

                                <label class="wc-reactivity-profile-tool__submit-consent">
                                    <input type="checkbox" data-reactivity-submit-consent required>
                                    <span>Ik geef toestemming om dit profiel en mijn contactgegevens naar Hondenmeesters te versturen voor opvolging.</span>
                                </label>

                                <input type="text" tabindex="-1" autocomplete="off" data-reactivity-submit-honeypot hidden>

                                <div class="wc-reactivity-profile-tool__inline-actions">
                                    <button class="wc-reactivity-profile-tool__action" type="submit" data-reactivity-submit-button>
                                        Verzenden
                                    </button>
                                </div>

                                <p class="wc-reactivity-profile-tool__submit-status" data-reactivity-submit-status></p>
                            </form>
                        </div>
                    </aside>
                </div>
            `;
        }

        function values(root, selector) {
            const out = {};
            let answered = 0;
            let total = 0;

            root.querySelectorAll(selector).forEach(field => {
                total += 1;

                const key = field.getAttribute(
                    selector.includes('behaviour')
                        ? 'data-reactivity-behaviour'
                        : 'data-reactivity-modifier'
                );

                const raw = field.dataset.value ?? '';

                if (raw === '') {
                    out[key] = null;
                    return;
                }

                answered += 1;
                out[key] = Number(raw);
            });

            return {
                values: out,
                answered,
                total,
                complete: answered === total
            };
        }

        function componentScore(input, key) {
            return Object.keys(loadings[key]).reduce((sum, behaviour) => {
                const value = input[behaviour];

                if (value === null || value === undefined) {
                    return sum;
                }

                return sum + (value * loadings[key][behaviour]);
            }, 0);
        }

        function calculate(input) {
            const pc1 = componentScore(input, 'pc1');
            const pc2 = componentScore(input, 'pc2');
            const pc3 = componentScore(input, 'pc3');

            const rows = [1, 2, 3, 4].map(id => {
                const mean = means[id];
                const distance = Math.sqrt(
                    Math.pow(pc1 - mean[0], 2) +
                    Math.pow(pc2 - mean[1], 2) +
                    Math.pow(pc3 - mean[2], 2)
                );

                return {
                    id,
                    distance,
                    raw: Math.exp(-(distance * distance) / (2 * tau * tau))
                };
            });

            const total = rows.reduce((sum, row) => sum + row.raw, 0) || 1;

            return {
                pc1,
                pc2,
                pc3,
                matches: rows
                    .map(row => ({ ...row, match: (row.raw / total) * 100 }))
                    .sort((a, b) => b.match - a.match)
            };
        }

        function axisLabel(value, cuts) {
            if (value < cuts[0]) return 'laag';
            if (value < cuts[1]) return 'middel';
            if (value < cuts[2]) return 'hoog';

            return 'zeer hoog';
        }

        function axesFor(result) {
            return [
                ['Orale aanval', pct(result.pc1 / 3.8), result.pc1, axisLabel(result.pc1, [.75, 1.7, 3.0])],
                ['Frustratie', pct(result.pc2 / 4.2), result.pc2, axisLabel(result.pc2, [1.4, 2.4, 3.4])],
                ['Postuur', pct(result.pc3 / 4.6), result.pc3, axisLabel(result.pc3, [1.2, 2.1, 3.2])]
            ];
        }

        function headlineFor(result) {
            const primary = result.matches[0];
            const second = result.matches[1];
            const cluster = clusters[primary.id];
            const secondCluster = clusters[second.id];
            const primaryMatch = Math.round(primary.match);
            const secondMatch = Math.round(second.match);
            const ambiguous = primary.match - second.match < 15;

            if (!ambiguous) {
                return {
                    primary,
                    second,
                    cluster,
                    secondCluster,
                    ambiguous,
                    title: `${cluster.name} · ${primaryMatch}% match`,
                    summary: cluster.summary,
                    severityText: `${cluster.tag} · ${cluster.severityLabel}`,
                    railSeverity: cluster.severity,
                    tone: cluster.tone
                };
            }

            return {
                primary,
                second,
                cluster,
                secondCluster,
                ambiguous,
                title: `Grensprofiel · ${primaryMatch}/${secondMatch}`,
                summary: `Dichtstbijzijnde clusters: ${cluster.name} (${primaryMatch}%) en ${secondCluster.name} (${secondMatch}%). Lees dit als mengbeeld; de gedragsassen zijn leidend.`,
                severityText: `mengbeeld · hoogste marge ${Math.max(cluster.severity, secondCluster.severity)}/4`,
                railSeverity: Math.max(cluster.severity, secondCluster.severity),
                tone: cluster.tone
            };
        }

        function modifierNoticeHTML(modifierState) {
            return `
                <div class="wc-reactivity-profile-tool__cluster-metric">
                    <p class="wc-reactivity-profile-tool__hint">
                        Vul alle behandelmodifiers in voordat de behandelbelasting wordt berekend.
                        Ingevuld: ${modifierState.answered}/${modifierState.total}.
                    </p>
                </div>
            `;
        }

        function modifierValue(modifiers, key) {
            const value = modifiers[key];

            return value === null || value === undefined ? 0 : value;
        }

        function treatmentScores(result, modifierState) {
            if (!modifierState.complete) return null;

            const mod = modifierState.values;
            const modifier = key => modifierValue(mod, key);

            const frustration = pct(
                .48 * clamp(result.pc2 / 3.7) +
                .18 * clamp(modifier('restraint') / 3) +
                .18 * clamp(modifier('recovery') / 3) +
                .16 * clamp(modifier('disengage') / 3)
            );

            const risk = pct(
                .46 * clamp(result.pc1 / 3.3) +
                .22 * clamp(modifier('contact') / 3) +
                .18 * clamp(modifier('redirect') / 3) +
                .14 * clamp(result.pc3 / 4.1)
            );

            const management = pct(
                .40 * clamp(risk / 100) +
                .24 * clamp(modifier('distance') / 3) +
                .20 * clamp(modifier('recovery') / 3) +
                .16 * clamp(modifier('handling') / 3)
            );

            return {
                frustration,
                risk,
                management
            };
        }

        function treatmentMetricsHTML(scores, modifierState) {
            if (!scores) {
                return modifierNoticeHTML(modifierState);
            }

            return [
                metricHTML('Frustratiedruk', scores.frustration, 'herstel, ontlading en keuzeruimte eerst nodig', 'secondary'),
                metricHTML('Escalatierisico', scores.risk, 'veiligheidsmarge bij onverwachte nabijheid', 'secondary'),
                metricHTML('Managementbehoefte', scores.management, 'afstand, routes, materiaal en geleider-plan', 'secondary')
            ].join('');
        }

        function prioritiesFor(headline, scores, modifierState) {
            if (!scores) {
                return [
                    `Vul de behandelmodifiers in voor trainingsprioriteit. Nu ingevuld: ${modifierState.answered}/${modifierState.total}.`
                ];
            }

            const priorities = [];

            if (scores.risk >= 70) {
                priorities.push('Begin met veiligheidsmarge: afstand, voorspelbare routes, materiaalcontrole en geen geplande hond-hond confrontaties.');
            } else if (scores.risk >= 45) {
                priorities.push('Houd management actief terwijl je alternatief gedrag opbouwt; test niet te snel dichterbij.');
            } else {
                priorities.push('Werk vooral aan tijdig signaleren, afstand nemen en rustig disengagen voordat spanning oploopt.');
            }

            if (scores.frustration >= 70) {
                priorities.push('Plan arousal-outlet en herstelmomenten expliciet in; blootstelling zonder ontlading zal waarschijnlijk vastlopen.');
            } else if (scores.frustration >= 45) {
                priorities.push('Bouw frustratietolerantie op via voorspelbare keuze, afstand en beloonbare alternatieven.');
            }

            if (headline.primary.id === 3 || headline.primary.id === 4 || scores.risk >= 65) {
                priorities.push('Behandel contactrisico als apart thema: niet alleen minder blaffen, maar vooral meer remming, herstel en veilige beslissingen.');
            }

            if (headline.ambiguous) {
                priorities.push('Omdat het profiel gemengd is: baseer de eerste trainingsstap op de assen en behandelmodifiers, niet alleen op de dichtstbijzijnde clustertitel.');
            }

            return priorities;
        }

        function matchesText(result) {
            return result.matches
                .map(row => {
                    const cluster = clusters[row.id];

                    return `${cluster.name}: ${Math.round(row.match)}%`;
                })
                .join(', ');
        }

        function update(root) {
            if (!root) return;

            render(root);

            const behaviourState = values(root, '[data-reactivity-behaviour]');
            const modifierState = values(root, '[data-reactivity-modifier]');

            const resultHeadNode = root.querySelector('[data-reactivity-result-head]');
            const primaryNode = root.querySelector('[data-reactivity-primary]');
            const summaryNode = root.querySelector('[data-reactivity-summary]');
            const severityNode = root.querySelector('[data-reactivity-severity]');
            const severityRailNode = root.querySelector('[data-reactivity-severity-rail]');
            const matchesNode = root.querySelector('[data-reactivity-matches]');
            const axesNode = root.querySelector('[data-reactivity-axes]');
            const modifiersNode = root.querySelector('[data-reactivity-modifiers]');
            const prioritiesNode = root.querySelector('[data-reactivity-priorities]');

            if (!resultHeadNode || !primaryNode || !summaryNode || !severityNode || !severityRailNode || !matchesNode || !axesNode || !modifiersNode || !prioritiesNode) {
                return;
            }

            if (!behaviourState.complete) {
                resultHeadNode.style.removeProperty('--severity-color');
                primaryNode.textContent = 'Nog niet compleet';
                summaryNode.textContent = `Beantwoord eerst alle negen gedragingen. Ingevuld: ${behaviourState.answered}/${behaviourState.total}.`;
                severityNode.textContent = 'open';
                severityRailNode.innerHTML = severityRailHTML(0);

                matchesNode.innerHTML = '';
                axesNode.innerHTML = '';
                modifiersNode.innerHTML = '';
                prioritiesNode.innerHTML = '';

                return;
            }

            const result = calculate(behaviourState.values);
            const headline = headlineFor(result);
            const axes = axesFor(result);
            const scores = treatmentScores(result, modifierState);
            const priorities = prioritiesFor(headline, scores, modifierState);

            resultHeadNode.style.setProperty('--severity-color', headline.tone);
            primaryNode.textContent = headline.title;
            summaryNode.textContent = headline.summary;
            severityNode.textContent = headline.severityText;
            severityRailNode.innerHTML = severityRailHTML(headline.railSeverity);

            matchesNode.innerHTML = result.matches.map((row, index) => {
                return clusterMatchHTML(row, index === 0);
            }).join('');

            axesNode.innerHTML = axes.map(([label, value, score, band]) => {
                return axisCardHTML(label, value, score, band);
            }).join('');

            modifiersNode.innerHTML = treatmentMetricsHTML(scores, modifierState);

            prioritiesNode.innerHTML = priorities
                .map(item => `<li>${item}</li>`)
                .join('');
        }

        function textInputValue(root, selector) {
            return (root.querySelector(selector)?.value || '').trim();
        }

        function dogName(root) {
            return textInputValue(root, '[data-reactivity-dog-name]');
        }

        function setSubmitStatus(root, state, message) {
            const node = root.querySelector('[data-reactivity-submit-status]');
            if (!node) return;

            node.dataset.state = state || '';
            node.textContent = message || '';
        }

        function setSubmitPending(root, pending) {
            const button = root.querySelector('[data-reactivity-submit-button]');
            if (!button) return;

            button.disabled = pending;
            button.textContent = pending ? 'Verzenden…' : 'Verzenden';
        }

        function notifySubmit(root, state, message) {
            setSubmitStatus(root, state, message);

            if (state === 'loading') return;

            const notifier = window.Notifier
                || window.HondenmeestersNotify
                || window.hondenmeestersNotifier
                || window.notifier;

            const notice = {
                type: state === 'success' ? 'success' : 'error',
                title: state === 'success' ? 'Profiel verzonden' : 'Niet verzonden',
                message
            };

            if (notifier?.show) {
                notifier.show(notice);
                return;
            }

            if (notifier?.notify) {
                notifier.notify(notice);
                return;
            }

            if (notifier?.push) {
                notifier.push(notice);
            }
        }

        function submissionContact(root) {
            return {
                dogName: textInputValue(root, '[data-reactivity-submit-dog-name]') || dogName(root),
                ownerName: textInputValue(root, '[data-reactivity-submit-owner-name]'),
                email: textInputValue(root, '[data-reactivity-submit-email]'),
                phone: textInputValue(root, '[data-reactivity-submit-phone]'),
                consent: !!root.querySelector('[data-reactivity-submit-consent]')?.checked,
                honeypot: textInputValue(root, '[data-reactivity-submit-honeypot]')
            };
        }

        async function captchaPayload() {
            const api = window.captcha || window.captcher || window.hondenmeestersCaptcha;

            if (!api) {
                throw new Error('captcha_missing');
            }

            const initResult = typeof api.initCaptcha === 'function'
                ? await api.initCaptcha()
                : null;

            if (typeof api.execute === 'function') {
                await api.execute();
            }

            const metrics = typeof api.getMetrics === 'function'
                ? api.getMetrics()
                : {};

            let token = (
                metrics?.token ||
                metrics?.securityToken ||
                initResult?.token ||
                initResult?.securityToken ||
                api.token ||
                ''
            ).trim();

            if (!token && typeof api.getToken === 'function') {
                token = String(await api.getToken()).trim();
            }

            if (!token) {
                throw new Error('captcha_missing');
            }

            return {
                ...metrics,
                token,
                securityToken: metrics?.securityToken || token
            };
        }

        function validateSubmission(contact, report) {
            if (!report || report.status !== 'Berekend') {
                return 'Vul eerst alle negen gedragingen in.';
            }

            if (!contact.dogName) {
                return 'Vul de naam van de hond in.';
            }

            if (!contact.ownerName) {
                return 'Vul je eigen naam in.';
            }

            if (!contact.email && !contact.phone) {
                return 'Vul een e-mailadres of telefoonnummer in.';
            }

            if (!contact.consent) {
                return 'Geef toestemming om het profiel te versturen.';
            }

            if (contact.honeypot) {
                return 'Verzenden is geblokkeerd.';
            }

            return '';
        }

        function submissionPayload(root, contact, report, captcha) {
            return {
                schema_version: 1,
                form_id: 'docs_reactivity_profile',
                dog_name: contact.dogName,
                owner_name: contact.ownerName,
                email: contact.email || null,
                phone: contact.phone || null,
                consent: contact.consent,
                my_custom_field: contact.honeypot || '',
                page_url: window.location.href,
                page_title: document.title,
                report,
                behaviours: report.behaviours || {},
                modifiers: report.modifiers || {},
                captcha
            };
        }

        async function submitProfile(root) {
            const contact = submissionContact(root);
            const report = collectReport(root);
            const validationError = validateSubmission(contact, report);

            if (validationError) {
                notifySubmit(root, 'error', validationError);
                return;
            }

            setSubmitPending(root, true);
            notifySubmit(root, 'loading', 'Beveiligingscontrole uitvoeren…');

            try {
                const captcha = await captchaPayload();
                const endpoint = root.dataset.reactivitySubmitEndpoint || '/connector/v2/reactivity-profile';
                const payload = submissionPayload(root, contact, report, captcha);

                notifySubmit(root, 'loading', 'Profiel verzenden…');

                const response = await fetch(endpoint, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    credentials: 'same-origin',
                    body: JSON.stringify(payload)
                });

                const data = await response.json().catch(() => ({}));

                if (!response.ok || data.status === 'error' || data.status === 'validation_error') {
                    throw new Error(data.message || 'submit_failed');
                }

                notifySubmit(root, 'success', 'Profiel verzonden. Dank je.');
            } catch (error) {
                const message = error?.message === 'captcha_missing'
                    ? 'Beveiligingscontrole is nog niet geladen of verlopen. Probeer opnieuw of herlaad de pagina.'
                    : 'Verzenden is niet gelukt. Probeer het later opnieuw.';

                notifySubmit(root, 'error', message);
            } finally {
                setSubmitPending(root, false);
            }
        }

        document.addEventListener('click', event => {
            const open = event.target?.closest?.('[data-reactivity-submit-open]');
            if (!open) return;

            const root = open.closest(rootSelector);
            const panel = root?.querySelector('[data-reactivity-submit-form]');

            if (!root || !panel) return;

            const nextHidden = !panel.hidden;
            panel.hidden = nextHidden;
            open.setAttribute('aria-expanded', nextHidden ? 'false' : 'true');

            const submitDogName = root.querySelector('[data-reactivity-submit-dog-name]');
            if (submitDogName && !submitDogName.value.trim()) {
                submitDogName.value = dogName(root);
            }
        }, true);

        document.addEventListener('submit', event => {
            const form = event.target?.closest?.('[data-reactivity-submit-form]');
            if (!form) return;

            const root = form.closest(rootSelector);
            if (!root) return;

            event.preventDefault();
            submitProfile(root);
        }, true);

        document.addEventListener('input', event => {
            const input = event.target?.closest?.('[data-reactivity-dog-name]');
            if (!input) return;

            const root = input.closest(rootSelector);
            if (!root) return;

            const submitDogName = root.querySelector('[data-reactivity-submit-dog-name]');
            if (submitDogName && !submitDogName.matches(':focus')) {
                submitDogName.value = input.value;
            }

            update(root);
        }, true);

        document.addEventListener('click', event => {
            const choice = event.target?.closest?.('[data-reactivity-choice]');
            if (!choice) return;

            const field = choice.closest('[data-reactivity-field]');
            const root = choice.closest(rootSelector);

            if (!field || !root) return;

            const current = field.dataset.value ?? '';
            const next = choice.dataset.reactivityValue ?? '';

            field.dataset.value = current === next ? '' : next;

            field.querySelectorAll('[data-reactivity-choice]').forEach(button => {
                const value = button.dataset.reactivityValue ?? '';
                const selected = field.dataset.value !== '' && value === field.dataset.value;

                button.classList.toggle('wc-reactivity-profile-tool__choice--selected', selected);
                button.setAttribute('aria-pressed', selected ? 'true' : 'false');
            });

            update(root);
        }, true);

        function init(scope = document) {
            const roots = scope.matches?.(rootSelector)
                ? [scope]
                : Array.from(scope.querySelectorAll?.(rootSelector) || []);

            roots.forEach(update);
        }

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => init());
        } else {
            init();
        }

        function collectReport(root) {
            if (!root) return {};

            render(root);
            update(root);

            const date = new Date().toLocaleDateString(
                'nl-NL',
                {
                    day: 'numeric',
                    month: 'long',
                    year: 'numeric'
                }
            );

            const behaviourState = values(root, '[data-reactivity-behaviour]');
            const modifierState = values(root, '[data-reactivity-modifier]');

            const reportDogName = dogName(root);

            const baseSlots = {
                dogName: reportDogName || '—',
                date,
                completeness: `${behaviourState.answered}/${behaviourState.total}`,
                modifierCompleteness: `${modifierState.answered}/${modifierState.total}`
            };

            if (!behaviourState.complete) {
                return {
                    status: 'Nog niet compleet',
                    slots: {
                        ...baseSlots,
                        status: 'Nog niet compleet',
                        primary: 'Nog niet compleet',
                        severity: 'Open',
                        summary: `Beantwoord eerst alle negen gedragingen. Ingevuld: ${behaviourState.answered}/${behaviourState.total}.`,
                        oralAttack: '—',
                        frustrationAxis: '—',
                        posturing: '—',
                        frustrationPressure: '—',
                        escalationRisk: '—',
                        managementNeed: '—',
                        priorities: 'Nog geen prioriteit berekend.',
                        matches: 'Nog geen matches berekend.'
                    }
                };
            }

            const result = calculate(behaviourState.values);
            const headline = headlineFor(result);
            const axes = axesFor(result);
            const scores = treatmentScores(result, modifierState);
            const priorities = prioritiesFor(headline, scores, modifierState);
            const matches = matchesText(result);
            const modifierMissing = `Nog niet compleet (${modifierState.answered}/${modifierState.total})`;

            const slots = {
                ...baseSlots,
                status: 'Berekend',
                primary: headline.title,
                severity: headline.severityText,
                summary: headline.summary,
                oralAttack: `${axes[0][3]} · ${axes[0][2].toFixed(2)} · ${axes[0][1]}%`,
                frustrationAxis: `${axes[1][3]} · ${axes[1][2].toFixed(2)} · ${axes[1][1]}%`,
                posturing: `${axes[2][3]} · ${axes[2][2].toFixed(2)} · ${axes[2][1]}%`,
                frustrationPressure: scores ? `${scores.frustration}%` : modifierMissing,
                escalationRisk: scores ? `${scores.risk}%` : modifierMissing,
                managementNeed: scores ? `${scores.management}%` : modifierMissing,
                priorities,
                matches
            };

            return {
                status: 'Berekend',
                dogName: reportDogName || '',
                cluster: headline.cluster.name,
                primaryMatch: Math.round(headline.primary.match),
                severity: headline.severityText,
                ambiguous: headline.ambiguous,
                axes,
                frustration: scores?.frustration ?? null,
                risk: scores?.risk ?? null,
                management: scores?.management ?? null,
                priorities,
                matches,
                matchRows: result.matches.map(row => ({
                    cluster: clusters[row.id].name,
                    tag: clusters[row.id].tag,
                    match: Math.round(row.match),
                    distance: Number(row.distance.toFixed(3))
                })),
                behaviours: behaviourState.values,
                modifiers: modifierState.values,
                slots
            };
        }

        window.wcReactivityProfileTool = {
            initialized: true,
            init,
            update,
            collectReport
        };
    })();
    """#
}
