public enum _TestRefs: String, Referencable {
    case some_ref_example
    case beyond_cortisol

    public var data: ReferenceData {
        switch self {
        case .some_ref_example:
            return .init(
                title: "Some ref example",
                url: "https://example.com",
                authorLine: "John Doe et al.",
                dateISO8601: "2025-10-25",
                doi: "DOI.10/213023"
            )

        case .beyond_cortisol:
            return .init(
                title: "Beyond Cortisol! Physiological Indicators of Welfare for Dogs: Deficits, Misunderstandings and Opportunities",
                url: "https://arxiv.org/abs/2502.11384",
                authorLine: "ML Cobb, AG Jimenez, NA Dreschel",
                dateISO8601: "2025-02-17",
                doi: "10.48550/arXiv.2502.11384"
            )
        }
    }
}
