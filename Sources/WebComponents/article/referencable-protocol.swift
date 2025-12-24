public struct ReferenceData {
    let title: String
    let url: String
    let authorLine: String?
    let dateISO8601: String?
    let doi: String?
}

public protocol Referencable: Sendable, RawRepresentable where RawValue == String {
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
