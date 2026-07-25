import Foundation
import Constructors
import CSS
import HTML

public struct RecommendedProduct: Sendable {
    public struct Link: Sendable {
        public enum Kind: String, Sendable {
            case recommendedReseller
            case affiliateReseller
            case alternativeReseller
            case manufacturer
            case category
            case information

            public var roleLabel: String {
                switch self {
                case .recommendedReseller:
                    return "Aanbevolen verkooppunt"

                case .affiliateReseller:
                    return "Aanbevolen affiliate"

                case .alternativeReseller:
                    return "Alternatief verkooppunt"

                case .manufacturer:
                    return "Fabrikant"

                case .category:
                    return "Productgroep"

                case .information:
                    return "Meer informatie"
                }
            }

            public var isPrimary: Bool {
                switch self {
                case .recommendedReseller,
                     .affiliateReseller:
                    return true

                case .alternativeReseller,
                     .manufacturer,
                     .category,
                     .information:
                    return false
                }
            }
        }

        public struct Referral: Sendable {
            public enum Relationship: String, Sendable {
                case affiliate
                case referral
                case discount
                case sponsored
            }

            public let relationship: Relationship
            public let disclosure: String

            public init(
                relationship: Relationship,
                disclosure: String
            ) {
                self.relationship = relationship
                self.disclosure = disclosure
            }
        }

        public let label: String
        public let url: URL
        public let kind: Kind
        public let referral: Referral?

        public init(
            label: String,
            url: URL,
            kind: Kind = .recommendedReseller,
            referral: Referral? = nil
        ) {
            self.label = label
            self.url = url
            self.kind = kind
            self.referral = referral
        }
    }

    public struct Image: Sendable {
        public let url: URL
        public let alt: String

        public init(
            url: URL,
            alt: String
        ) {
            self.url = url
            self.alt = alt
        }
    }

    public struct Fact: Sendable {
        public let label: String
        public let value: String
        public let note: String?

        public init(
            _ label: String,
            _ value: String,
            note: String? = nil
        ) {
            self.label = label
            self.value = value
            self.note = note
        }
    }

    public struct Food: Sendable {
        public let ingredients: [String]
        public let analytical: [Fact]
        public let additives: [String]
        public let facts: [Fact]

        public init(
            ingredients: [String] = [],
            analytical: [Fact] = [],
            additives: [String] = [],
            facts: [Fact] = []
        ) {
            self.ingredients = ingredients
            self.analytical = analytical
            self.additives = additives
            self.facts = facts
        }

        public var rows: [Fact] {
            facts
                + list(
                    "Ingrediënten",
                    ingredients
                )
                + analytical
                + list(
                    "Toevoegingsmiddelen",
                    additives
                )
        }

        private func list(
            _ label: String,
            _ values: [String]
        ) -> [Fact] {
            values.isEmpty
                ? []
                : [
                    Fact(
                        label,
                        values.joined(separator: ", ")
                    )
                ]
        }
    }

    public struct Snack: Sendable {
        public let ingredients: [String]
        public let analytical: [Fact]
        public let facts: [Fact]

        public init(
            ingredients: [String] = [],
            analytical: [Fact] = [],
            facts: [Fact] = []
        ) {
            self.ingredients = ingredients
            self.analytical = analytical
            self.facts = facts
        }

        public var rows: [Fact] {
            facts
                + (
                    ingredients.isEmpty
                        ? []
                        : [
                            Fact(
                                "Ingrediënten",
                                ingredients.joined(separator: ", ")
                            )
                        ]
                )
                + analytical
        }
    }

    public enum Specification: Sendable {
        case generic([Fact])
        case collar([Fact])
        case harness([Fact])
        case line([Fact])
        case bag([Fact])
        case tug([Fact])
        case food(Food)
        case snack(Snack)

        public var label: String {
            switch self {
            case .generic:
                return "Specificaties"

            case .collar:
                return "Halsband"

            case .harness:
                return "Tuig"

            case .line:
                return "Lijn"

            case .bag:
                return "Tas"

            case .tug:
                return "Trek- en bijtmateriaal"

            case .food:
                return "Voer"

            case .snack:
                return "Snack"
            }
        }

        public var rows: [Fact] {
            switch self {
            case .generic(let rows),
                 .collar(let rows),
                 .harness(let rows),
                 .line(let rows),
                 .bag(let rows),
                 .tug(let rows):
                return rows

            case .food(let value):
                return value.rows

            case .snack(let value):
                return value.rows
            }
        }
    }

    public enum Recommendation: String, Sendable {
        case preferred
        case recommended
        case conditional
        case acceptable
        case notRecommended

        public var label: String {
            switch self {
            case .preferred:
                return "Voorkeur"

            case .recommended:
                return "Aanbevolen"

            case .conditional:
                return "Voorwaardelijk aanbevolen"

            case .acceptable:
                return "Bruikbaar"

            case .notRecommended:
                return "Niet aanbevolen"
            }
        }
    }

    public enum Experience: String, Sendable {
        case extensivelyUsed
        case used
        case clientUse
        case brieflyTested
        case inspected
        case notAssessed

        public var label: String {
            switch self {
            case .extensivelyUsed:
                return "Langdurig gebruikt"

            case .used:
                return "Zelf gebruikt"

            case .clientUse:
                return "Bij cliënten gebruikt"

            case .brieflyTested:
                return "Kort getest"

            case .inspected:
                return "Beoordeeld"

            case .notAssessed:
                return "Nog niet beoordeeld"
            }
        }
    }

    public let id: String
    public let name: String
    public let brand: String?
    public let summary: String
    public let recommendation: Recommendation
    public let experience: Experience
    public let image: Image?
    public let links: [Link]
    public let specification: Specification
    public let suitableFor: [String]
    public let unsuitableFor: [String]
    public let notes: [String]

    public init(
        id: String,
        name: String,
        brand: String? = nil,
        summary: String,
        recommendation: Recommendation = .recommended,
        experience: Experience = .notAssessed,
        image: Image? = nil,
        links: [Link],
        specification: Specification,
        suitableFor: [String] = [],
        unsuitableFor: [String] = [],
        notes: [String] = []
    ) {
        self.id = id
        self.name = name
        self.brand = brand
        self.summary = summary
        self.recommendation = recommendation
        self.experience = experience
        self.image = image
        self.links = links
        self.specification = specification
        self.suitableFor = suitableFor
        self.unsuitableFor = unsuitableFor
        self.notes = notes
    }
}
