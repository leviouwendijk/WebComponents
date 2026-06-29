import Constructors
import HTML

public extension HondenmeestersPortableDocumentFormat {
    struct Hulpmiddel: ReusableComponent, Sendable {
        public enum Kind: String, Sendable {
            case classical_conditioning
            case operant_conditioning
            case premack_hierarchy
            case premack_contingency
            case drijfverenkaart
            case reactivity_profile

            var id: String {
                switch self {
                case .classical_conditioning:
                    return "pdf-classical-conditioning"

                case .operant_conditioning:
                    return "pdf-operant-conditioning"

                case .premack_hierarchy:
                    return "pdf-premack-hierarchy"

                case .premack_contingency:
                    return "pdf-premack-contingency"

                case .drijfverenkaart:
                    return "pdf-drijfverenkaart"

                case .reactivity_profile:
                    return "pdf-reactivity-profile"
                }
            }

            var filename: String {
                switch self {
                case .classical_conditioning:
                    return "klassieke-conditionering-kaart.pdf"

                case .operant_conditioning:
                    return "operante-uitkomsten-kaart.pdf"

                case .premack_hierarchy:
                    return "premack-responshierarchie.pdf"

                case .premack_contingency:
                    return "premack-contingentiekaart.pdf"

                case .drijfverenkaart:
                    return "drijfverenkaart.pdf"

                case .reactivity_profile:
                    return "reactiviteitsprofiel.pdf"
                }
            }

            var title: String {
                switch self {
                case .classical_conditioning:
                    return "Klassieke conditionering kaart"

                case .operant_conditioning:
                    return "Operante uitkomsten kaart"

                case .premack_hierarchy:
                    return "Premack respons-hiërarchie"

                case .premack_contingency:
                    return "Premack contingentiekaart"

                case .drijfverenkaart:
                    return "Drijfverenkaart"

                case .reactivity_profile:
                    return "Reactiviteitsprofiel"
                }
            }

            var subtitle: String {
                switch self {
                case .classical_conditioning:
                    return "Prikkel → gevolg"

                case .operant_conditioning:
                    return "Prikkel → keuze → uitkomst"

                case .premack_hierarchy:
                    return "Responsen ordenen naar waarschijnlijkheid"

                case .premack_contingency:
                    return "Als-dan relatie tussen lage en hoge waarschijnlijkheid"

                case .drijfverenkaart:
                    return "Responsen, opbrengsten, kosten en activatie"

                case .reactivity_profile:
                    return "Prikkel, afstand, spanning, herstel en strategie"
                }
            }

            var lead: String {
                switch self {
                case .classical_conditioning:
                    return "Teken uit welke prikkel voor de hond voorspellend wordt voor welk gevolg."

                case .operant_conditioning:
                    return "Teken uit welke prikkel een keuze uitlokt en welke uitkomst daarop volgt."

                case .premack_hierarchy:
                    return "Orden responsen naar waarschijnlijkheid en zoek welke toegang als bekrachtiger kan dienen."

                case .premack_contingency:
                    return "Formuleer een duidelijke als-dan relatie tussen de gewenste respons en de toegang daarna."

                case .drijfverenkaart:
                    return "Breng in kaart welke responsen latent aanwezig zijn en waarom één reactie naar voren komt."

                case .reactivity_profile:
                    return "Breng prikkel, afstand, spanning, herstel en strategie samen in één profiel."
                }
            }

            var sheet: PortableDocumentFormatSheet {
                .init(
                    kicker: "Hulpmiddel",
                    lead: lead,
                    fields: fields
                )
            }

            var fields: [PortableDocumentFormatField] {
                switch self {
                case .classical_conditioning:
                    return [
                        .init(title: "Situatie", lines: 3),
                        .init(title: "Prikkel", lines: 3),
                        .init(title: "Voorspeld gevolg", lines: 3),
                        .init(title: "Verwachting / emotionele richting", lines: 3),
                        .init(title: "Volgende trainingskeuze", lines: 4)
                    ]

                case .operant_conditioning:
                    return [
                        .init(title: "Prikkel / context", lines: 3),
                        .init(title: "Keuze / respons", lines: 3),
                        .init(title: "Opbrengst", lines: 3),
                        .init(title: "Verlichting / vermijden", lines: 3),
                        .init(title: "Kost / risico", lines: 3),
                        .init(title: "Alternatieve respons", lines: 4)
                    ]

                case .premack_hierarchy:
                    return [
                        .init(title: "Situatie", lines: 3),
                        .init(title: "Meest waarschijnlijke responsen", lines: 5),
                        .init(title: "Gewenste minder waarschijnlijke respons", lines: 3),
                        .init(title: "Mogelijke bekrachtiger / toegang", lines: 4),
                        .init(title: "Eerste haalbare stap", lines: 4)
                    ]

                case .premack_contingency:
                    return [
                        .init(title: "Als de hond eerst...", lines: 4),
                        .init(title: "Dan krijgt de hond toegang tot...", lines: 4),
                        .init(title: "Criteria voor succes", lines: 4),
                        .init(title: "Te vermijden valkuilen", lines: 4),
                        .init(title: "Volgende herhaling", lines: 3)
                    ]

                case .drijfverenkaart:
                    return [
                        .init(title: "Situatie / prikkel", lines: 3),
                        .init(title: "Reacties die latent aanwezig zijn", lines: 5),
                        .init(title: "Wat trekt aan?", lines: 3),
                        .init(title: "Wat duwt weg?", lines: 3),
                        .init(title: "Wat levert de gekozen respons op?", lines: 4),
                        .init(title: "Beter alternatief met dezelfde functie", lines: 4)
                    ]

                case .reactivity_profile:
                    return [
                        .init(title: "Prikkel", lines: 3),
                        .init(title: "Startafstand spanning", lines: 2),
                        .init(title: "Vroege signalen", lines: 4),
                        .init(title: "Escalatiesignalen", lines: 4),
                        .init(title: "Herstel helpt door", lines: 4),
                        .init(title: "Management / trainingskeuze", lines: 5)
                    ]
                }
            }

            var blocks: [PortableDocumentFormatBlock] {
                switch self {
                case .classical_conditioning:
                    return [
                        .heading("Kernvraag"),
                        .callout(
                            title: "Kernvraag",
                            text: "Wat leert de hond dat deze prikkel voorspelt?"
                        )
                    ]

                case .operant_conditioning:
                    return [
                        .heading("Kernvraag"),
                        .callout(
                            title: "Kernvraag",
                            text: "Waarom wordt deze reactie in deze situatie waarschijnlijker?"
                        )
                    ]

                case .premack_hierarchy:
                    return [
                        .heading("Kernvraag"),
                        .callout(
                            title: "Kernvraag",
                            text: "Welke respons kan een minder waarschijnlijke respons bekrachtigen?"
                        )
                    ]

                case .premack_contingency:
                    return [
                        .heading("Kernvraag"),
                        .callout(
                            title: "Kernvraag",
                            text: "Is de toegang waardevol genoeg om de eerste respons waarschijnlijker te maken?"
                        )
                    ]

                case .drijfverenkaart:
                    return [
                        .heading("Kernvraag"),
                        .callout(
                            title: "Kernvraag",
                            text: "Welke opbrengst of verlichting maakt deze reactie logisch voor de hond?"
                        )
                    ]

                case .reactivity_profile:
                    return [
                        .heading("Kernvraag"),
                        .callout(
                            title: "Kernvraag",
                            text: "Waar ligt de grens tussen nog leerbaar en te hoog geactiveerd?"
                        )
                    ]
                }
            }
        }

        public let kind: Kind
        public let id: String
        public let label: String
        public let filename: String
        public let includeStyles: Bool
        public let includeScript: Bool

        public init(
            kind: Kind,
            id: String? = nil,
            label: String = "Download PDF",
            filename: String? = nil,
            includeStyles: Bool = true,
            includeScript: Bool = true
        ) {
            self.kind = kind
            self.id = id ?? kind.id
            self.label = label
            self.filename = filename ?? kind.filename
            self.includeStyles = includeStyles
            self.includeScript = includeScript
        }

        public var nodes: ReusableComponentNodes {
            PortableDocumentFormatExport(
                id: id,
                label: label,
                filename: filename,
                payload: payload,
                includeStyles: includeStyles,
                includeScript: includeScript
            ).nodes
        }

        public func node() -> any HTMLNode {
            nodes.body[0]
        }

        private var payload: PortableDocumentFormatPayload {
            HondenmeestersPortableDocumentFormat.payload(
                template: .field_sheet_a4,
                title: kind.title,
                subtitle: kind.subtitle,
                blocks: kind.blocks,
                sheet: kind.sheet
            )
        }
    }
}
