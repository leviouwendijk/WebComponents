public enum DocsReviewTarget: String, Sendable, Hashable, CaseIterable {
    case book
    case course
    case program
    case service
    case product
    case tool
    case method
    case video
    case channel
    case series
    case platform
}

public enum DocsArticleKind: Sendable, Hashable {
    case article
    case essay
    case opinion
    case position
    case explainer
    case guide
    case research
    case research_note
    case literature_review
    case study_review
    case review(DocsReviewTarget)
    case case_note
    case commentary
    case correction
    case background
    case note

    public var isPlainArticle: Bool {
        switch self {
        case .article:
            return true

        case .essay,
             .opinion,
             .position,
             .explainer,
             .guide,
             .research,
             .research_note,
             .literature_review,
             .study_review,
             .review,
             .case_note,
             .commentary,
             .correction,
             .background,
             .note:
            return false
        }
    }

    public var key: String {
        switch self {
        case .article:
            return "article"

        case .essay:
            return "essay"

        case .opinion:
            return "opinion"

        case .position:
            return "position"

        case .explainer:
            return "explainer"

        case .guide:
            return "guide"

        case .research:
            return "research"

        case .research_note:
            return "research_note"

        case .literature_review:
            return "literature_review"

        case .study_review:
            return "study_review"

        case .review(let target):
            return "review.\(target.rawValue)"

        case .case_note:
            return "case_note"

        case .commentary:
            return "commentary"

        case .correction:
            return "correction"

        case .background:
            return "background"

        case .note:
            return "note"
        }
    }
}
