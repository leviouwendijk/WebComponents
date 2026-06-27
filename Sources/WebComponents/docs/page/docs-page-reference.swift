public protocol DocsPageIdentifying: Sendable {
    var docsPageIdentifier: DocsPageIdentifier { get }
}

public struct DocsPageReference: Sendable, Hashable {
    public let identifier: DocsPageIdentifier

    public init(
        identifier: DocsPageIdentifier
    ) {
        self.identifier = identifier
    }

    public init(
        page: DocsPage
    ) {
        self.identifier = page.identifier
    }

    public init<Source: DocsPageIdentifying>(
        _ source: Source
    ) {
        self.identifier = source.docsPageIdentifier
    }
}

extension DocsPageReference: DocsPageIdentifying {
    public var docsPageIdentifier: DocsPageIdentifier {
        identifier
    }
}

extension DocsPageIdentifier: DocsPageIdentifying {
    public var docsPageIdentifier: DocsPageIdentifier {
        self
    }
}

extension DocsPage: DocsPageIdentifying {
    public var docsPageIdentifier: DocsPageIdentifier {
        identifier
    }
}
