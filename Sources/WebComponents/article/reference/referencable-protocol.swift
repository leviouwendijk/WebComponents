public struct ReferenceData: Sendable, Codable {
    public let title: String
    public let url: String
    public let authorLine: String?
    public let dateISO8601: String?
    public let doi: String?

    public init(
        title: String,
        url: String,
        authorLine: String? = nil,
        dateISO8601: String? = nil,
        doi: String? = nil
    ) {
        self.title = title
        self.url = url
        self.authorLine = authorLine
        self.dateISO8601 = dateISO8601
        self.doi = doi
    }
}

public protocol Referencable: 
    Sendable,
    Codable,
    CaseIterable,
    RawRepresentable where RawValue == String {
    // separate public name "(michael et al. 2019)" or numeric "[1]"
    // from the self.rawValue, which refers to our case name
    // case name is internal: beyond_cortisol may not be a nice reference to use publically
    var public_name_or_id: String { get }           // stable; used in anchors + JSON
    // unfinished...
    // perhaps -> 'name' for public cite view fallback?
    // key -> id -> self.rawvalue, since not for public view anyway, but for data?

    var data: ReferenceData { get }

    var title: String { get }
    var url: String { get }
    var authorLine: String? { get }
    var dateISO8601: String? { get }
    var doi: String? { get }
}

extension Referencable {
    public var public_name_or_id: String { self.rawValue }

    public var title: String { data.title }
    public var url: String { data.url }
    public var authorLine: String? { data.authorLine }
    public var dateISO8601: String? { data.dateISO8601 }
    public var doi: String? { data.doi }
}
