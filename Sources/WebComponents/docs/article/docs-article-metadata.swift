import Primitives

public struct DocsArticleMeta: Sendable, Hashable {
    public let kind: DocsArticleKind
    public let subjects: [DocsArticleSubject]
    public let history: [DocsArticleHistoryEvent]
    public let relations: [DocsArticleRelation]

    public init(
        kind: DocsArticleKind = .article,
        subjects: [DocsArticleSubject] = [],
        history: [DocsArticleHistoryEvent] = [],
        relations: [DocsArticleRelation] = []
    ) {
        self.kind = kind
        self.subjects = subjects
        self.history = history
        self.relations = relations
    }

    public var publishedEvent: DocsArticleHistoryEvent? {
        history.first { event in
            event.kind == .published
        }
    }

    public var latestEvent: DocsArticleHistoryEvent? {
        history.last
    }
}

public struct DocsArticleSubjectIdentifier: StringIdentifier {
    public let rawValue: String

    public init(
        rawValue: String
    ) {
        self.rawValue = rawValue
    }
}

public struct DocsArticleSubject: Sendable, Hashable {
    public let id: DocsArticleSubjectIdentifier
    public let label: String

    public init(
        id: DocsArticleSubjectIdentifier,
        label: String
    ) {
        self.id = id
        self.label = label
    }
}

public enum DocsArticleHistoryKind: String, Sendable, Hashable, CaseIterable {
    case published
    case revised
    case updated
    case corrected
    case expanded
    case commentary
}

public struct DocsArticleHistoryEvent: Sendable, Hashable {
    public let kind: DocsArticleHistoryKind
    public let date: PartialDate
    public let note: String?

    public init(
        _ kind: DocsArticleHistoryKind,
        date: PartialDate,
        note: String? = nil
    ) {
        self.kind = kind
        self.date = date
        self.note = note
    }
}

public extension DocsArticleHistoryEvent {
    static func published(
        date: PartialDate,
        note: String? = nil
    ) -> DocsArticleHistoryEvent {
        DocsArticleHistoryEvent(
            .published,
            date: date,
            note: note
        )
    }

    static func revised(
        date: PartialDate,
        note: String? = nil
    ) -> DocsArticleHistoryEvent {
        DocsArticleHistoryEvent(
            .revised,
            date: date,
            note: note
        )
    }

    static func updated(
        date: PartialDate,
        note: String? = nil
    ) -> DocsArticleHistoryEvent {
        DocsArticleHistoryEvent(
            .updated,
            date: date,
            note: note
        )
    }

    static func corrected(
        date: PartialDate,
        note: String? = nil
    ) -> DocsArticleHistoryEvent {
        DocsArticleHistoryEvent(
            .corrected,
            date: date,
            note: note
        )
    }

    static func expanded(
        date: PartialDate,
        note: String? = nil
    ) -> DocsArticleHistoryEvent {
        DocsArticleHistoryEvent(
            .expanded,
            date: date,
            note: note
        )
    }
}

public enum DocsArticleRelationKind: String, Sendable, Hashable, CaseIterable {
    case references
    case referencedBy
    case respondsTo
    case responseFrom
    case corrects
    case correctedBy
    case expands
    case expandedBy
    case supersedes
    case supersededBy
}

public struct DocsArticleRelation: Sendable, Hashable {
    public let kind: DocsArticleRelationKind
    public let target: DocsPageReference
    public let note: String?

    public init(
        _ kind: DocsArticleRelationKind,
        target: DocsPageReference,
        note: String? = nil
    ) {
        self.kind = kind
        self.target = target
        self.note = note
    }

    public init<Target: DocsPageIdentifying>(
        _ kind: DocsArticleRelationKind,
        target: Target,
        note: String? = nil
    ) {
        self.init(
            kind,
            target: DocsPageReference(target),
            note: note
        )
    }
}

public extension DocsArticleRelation {
    static func references<Target: DocsPageIdentifying>(
        _ target: Target,
        note: String? = nil
    ) -> DocsArticleRelation {
        DocsArticleRelation(
            .references,
            target: target,
            note: note
        )
    }

    static func respondsTo<Target: DocsPageIdentifying>(
        _ target: Target,
        note: String? = nil
    ) -> DocsArticleRelation {
        DocsArticleRelation(
            .respondsTo,
            target: target,
            note: note
        )
    }

    static func corrects<Target: DocsPageIdentifying>(
        _ target: Target,
        note: String? = nil
    ) -> DocsArticleRelation {
        DocsArticleRelation(
            .corrects,
            target: target,
            note: note
        )
    }

    static func expands<Target: DocsPageIdentifying>(
        _ target: Target,
        note: String? = nil
    ) -> DocsArticleRelation {
        DocsArticleRelation(
            .expands,
            target: target,
            note: note
        )
    }

    static func supersedes<Target: DocsPageIdentifying>(
        _ target: Target,
        note: String? = nil
    ) -> DocsArticleRelation {
        DocsArticleRelation(
            .supersedes,
            target: target,
            note: note
        )
    }
}
