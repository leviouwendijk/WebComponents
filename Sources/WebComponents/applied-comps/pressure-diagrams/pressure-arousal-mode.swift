public enum PressureArousalMode: String, Sendable, CaseIterable {
    case negativePunishment = "negative-punishment"
    case negativeReinforcement = "negative-reinforcement"
    case positivePunishment = "positive-punishment"

    public var code: String {
        switch self {
        case .negativePunishment:
            return "−P"

        case .negativeReinforcement:
            return "−R"

        case .positivePunishment:
            return "+P"
        }
    }

    public var title: String {
        switch self {
        case .negativePunishment:
            return "Restrictie / blokkade"

        case .negativeReinforcement:
            return "Milde constante druk"

        case .positivePunishment:
            return "Hoge piekdruk"
        }
    }

    public var shortLabel: String {
        "\(code) · \(title)"
    }

    public var body: String {
        switch self {
        case .negativePunishment:
            return "Toegang wordt begrensd of tijdelijk onbereikbaar. De druk zit vooral in frustratie, blokkade of gemis."

        case .negativeReinforcement:
            return "Druk blijft mild aanwezig en verdwijnt zodra de hond de gewenste richting kiest. De opluchting bekrachtigt."

        case .positivePunishment:
            return "Een hoge drukpiek wordt toegevoegd om gedrag te onderbreken of te verminderen. Dit vraagt extra voorzichtigheid."
        }
    }

    public var statusText: String {
        "\(shortLabel): \(body)"
    }
}

