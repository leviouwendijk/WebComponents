import Foundation
import HTML
import Constructors
import Path

public struct DocItem: Sendable {
    public var path: StandardPath

    public var title: String // document title, api title
    public var summary: String // document intro, api description
    public var thumbnail_src: StandardPath? // api thumnail

    // -------------------------------------
    // --------   **Classical conditioning**
    // |      |   
    // |      |   Classical conditioning is ..
    // |      |   this that and the other..
    // --------
    // -------------------------------------

    // public var content: @Sendable () -> HTMLFragment 
    public var content: @Sendable () -> [ArticleContentElement] 
    // should probably build reusable subcomponents that contain the classes
    // doc paragraph, codeblock, etc.
    // so that styles and classes can be updated in one place, not everywhere if we want to make a change

    public var references: [any Referencable]
    // another problem:
    // how to create some kind of linking refs
    // between references and content?
    // perhaps with id?

    public init(
        path: StandardPath,
        title: String,
        summary: String,
        thumbnail_src: StandardPath? = nil,
        // content: @escaping @Sendable () -> HTMLFragment,
        content: @escaping @Sendable () -> [ArticleContentElement],
        references: [any Referencable] = []
    ) {
        self.path = path
        self.title = title
        self.summary = summary
        self.thumbnail_src = thumbnail_src
        self.content = content
        self.references = references
    }

}

public extension DocItem {
    /// Standardized header block for every doc item:
    /// - Renders `title` + `summary` once (no drift).
    /// - Optional thumbnail rendered "wiki style" (to the right of the summary).
    ///
    /// Usage:
    ///     let nodes = item.headerNodes()
    ///     let body  = nodes + item.content()
    func lead() -> HTMLFragment {
        var nodes: HTMLFragment = []

        nodes.append(
            HTML.h1(["class": "doc-title"]) {
                HTML.text(self.title)
            }
        )

        // -------------------------------------
        // --------   **Classical conditioning**
        // |      |   
        // |      |   Classical conditioning is ..
        // |      |   this that and the other..
        // --------
        // -------------------------------------

        if let thumb = self.thumbnail_src {
            nodes.append(
                HTML.div(["class": "doc-lead doc-lead--with-thumb"]) {
                    HTML.div(["class": "doc-lead__summary"]) {
                        HTML.p(["class": "doc-summary"]) {
                            HTML.text(self.summary)
                        }
                    }

                    HTML.div(["class": "doc-lead__thumb"]) {
                        HTML.img(
                            src: thumb.rendered(asRootPath: true),
                            alt: self.title
                        )
                    }
                }
            )
        } else {
            nodes.append(
                HTML.p(["class": "doc-summary"]) {
                    HTML.text(self.summary)
                }
            )
        }

        return nodes
    }

    func article() -> HTMLFragment {
        return lead() + content()
    }
}

// public struct DocItemReference: Referencable {
public struct DocItemReference: Sendable {
    public var id: String
    public var title: String
    public var url: String
    public var authorLine: String?
    public var dateISO8601: String?
    public var doi: String?
    public var comment: String?

    public init(
        id: String,
        title: String,
        url: String,
        authorLine: String? = nil,
        dateISO8601: String? = nil,
        doi: String? = nil,
        comment: String? = nil
    ) {
        self.id = id
        self.title = title
        self.url = url
        self.authorLine = authorLine
        self.dateISO8601 = dateISO8601
        self.doi = doi
        self.comment = comment
    }
}


public enum DocsMockItems {
    public static let primary: DocItem = DocItem(
        path: StandardPath(
            [
                "toepassing",
                "primer.html"
            ]
        ),
        title: "Primer Gedrag",
        summary: "Om duidelijker te begrijpen hoe gedrag totstandkomt, gebruiken we de principes van klassieke en operante conditionering. Naar deze concepten zal herhaaldelijk worden gerefereerd.",
        thumbnail_src: nil,
        content: {
            return [
                .html(
                    [
                        HTML.h3 {
                            HTML.text("Associatie-principe")
                        },

                        HTML.p {
                            HTML.text("Klassieke conditionering is de associatie van een prikkel met een gevolg. Dit betrekt nog geen handeling. Aldus kan klassieke conditionering uitgedrukt worden in het associatie-principe: ")
                        },

                        HTML.img(
                            src: "/assets/images/prikkel-gevolg.png",
                            alt: "Description of Image"
                        ),

                        HTML.p {
                            HTML.text("Denk hierbij aan: ")
                        },

                        HTML.pre {
                            HTML.code {
                                HTML.text("Voedselgeur -> Eten (m)")
                            }
                        },

                        HTML.p {
                            HTML.text("Er bestaat een sterke koppeling tussen voedselgeur als prikkel, die de activiteit van eten aankondigt als gevolg. ")
                        },

                        HTML.h1 {
                            HTML.text("Koppelings-principe: ")
                        },

                        HTML.p {
                            HTML.text("Hoe dichter bij de 100% van de verschijningen van een ")
                            HTML.code { HTML.text("prikkel") }
                            HTML.text(", deze opgevolgd wordt door ")
                            HTML.code { HTML.text("gevolg") }
                            HTML.text(" hoe beter het associatie-principe de verwachting / anticipatie schept. ")
                        },

                        HTML.p {
                            HTML.text("Neem, bijvoorbeeld, uitgaande van 100% consequente uitvoering: ")
                        },

                        HTML.pre {
                            HTML.code {
                                HTML.text("Vingersnip -> Correctie")
                            }
                        },

                        HTML.p {
                            HTML.text("Indien de correctie die toegediend wordt altijd beschouwd wordt als een ")
                            HTML.code { HTML.text("demotivator") }
                            HTML.text(", zal de ")
                            HTML.code { HTML.text("vingersnip") }
                            HTML.text(" een ")
                            HTML.code { HTML.text("geconditioneerde demotivator") }
                            HTML.text(" worden. Door vervolgens correcties vooraf aan te kondigen met de ")
                            HTML.code { HTML.text("vingersnip") }
                            HTML.text(", geeft dit zeggenschap aan de hond om een de toediening van de demotivator te voorkomen, door een ongewenste gedraging op te geven. ")
                        },

                        HTML.h3 {
                            HTML.text("Gedragsformule")
                        },

                        HTML.p {
                            HTML.text("Operante conditionering voegt hier een stap aan toe: het betrekt een handeling. De uitkomst is een gevolg die afhankelijk is van welk soort keuze gemaakt wordt, in reactie op de prikkeling. ")
                        },

                        HTML.img(
                            src: "/assets/images/prikkel-keuze-gevolg.png",
                            alt: "Description of Image"
                        ),

                        HTML.p {
                            HTML.text("Eenzelfde soort voorbeeld zou zijn: ")
                        },

                        HTML.pre {
                            HTML.code {
                                HTML.text("Voedselgeur -> Bedelen -> Eten (m)")
                            }
                        },

                        HTML.div(["class": "content-div"]) { [] },

                        HTML.h1 {
                            HTML.text("Test2")
                        },

                        HTML.img(
                            src: "/assets/images/operant-c-quadrants.png",
                            alt: "Description of Image"
                        ),

                        HTML.img(
                            src: "/assets/images/operant-c-positive-negative.png",
                            alt: "Description of Image"
                        ),

                        HTML.img(
                            src: "/assets/images/operant-c-full.png",
                            alt: "Description of Image"
                        ),

                        HTML.pre {
                            HTML.code {
                                HTML.text("Voedselgeur -> Bedelen -> Eten (m)\n\n-- later: (R+ : bedelen) ")
                            }
                        },

                        HTML.pre {
                            HTML.code {
                                HTML.text("Voedselgeur -> Nadering -> Tegen-nadering (d)\n(R- : afstand-behoud) ")
                            }
                        },

                        HTML.img(
                            src: "/assets/images/gedrag-drijfveer.png",
                            alt: "Description of Image"
                        ),

                        HTML.p {
                            HTML.text("Demotivatoren zijn afstotend, motivatoren zijn aantrekkend. ")
                        },
                    ],
                ),

                .reference([SomeLocallyDefinedRefs.some_ref_example]),

                .html(
                    [
                        HTML.h3 {
                            HTML.text("Definitie")
                        },

                        HTML.p {
                            HTML.text("In essentie is al gedrag een handeling die ondernomen wordt om toegang tot een motivator te verkrijgen en contact met een weerzinwekker te vermijden. ")
                        },

                        HTML.img(
                            src: "/assets/images/1-1.jpg",
                            alt: "Description of Image"
                        ),

                        HTML.h3 {
                            HTML.text("TestContainerWidth")
                        },

                        HTML.p {
                            HTML.text("In essentie is al gedrag een handeling die ondernomen wordt om toegang tot een motivator te verkrijgen en contact met een weerzinwekker te vermijden. In essentie is al gedrag een handeling die ondernomen wordt om toegang tot een motivator te verkrijgen en contact met een weerzinwekker te vermijden. In essentie is al gedrag een handeling die ondernomen wordt om toegang tot een motivator te verkrijgen en contact met een weerzinwekker te vermijden. In essentie is al gedrag een handeling die ondernomen wordt om toegang tot een motivator te verkrijgen en contact met een weerzinwekker te vermijden. ")
                        }
                    ]
                )
            ]
        },
        references: [
            SomeLocallyDefinedRefs.some_ref_example
        ]
    )
}

public enum SomeLocallyDefinedRefs: String, Referencable {
    case some_ref_example

    public var id: String {
        return self.rawValue
    }

    public var title: String {
        return self.rawValue
    }

    public var url: String {
        return self.rawValue
    }

    // // maybe a more dynamic way to render the comment locally?
    // public func inline() -> any HTMLNode {
    //     return HTML.br()
    // }

    // public func reference() -> any HTMLNode {
    //     return HTML.br()
    // }
}

// public struct CommentedReference: Referencable {
//     public let reference: any Referencable
//     public let _comment: String?

//     public init(
//         reference: any Referencable,
//         comment: String? = nil
//     ) {
//         self.reference = reference
//         self._comment = comment
//     }

//     public var id: String { reference.id }
//     public var title: String { reference.title }
//     public var url: String { reference.url }

//     public var authorLine: String? { reference.authorLine }
//     public var dateISO8601: String? { reference.dateISO8601 }
//     public var doi: String? { reference.doi }
    
//     public var comment: String? {
//         return _comment
//     }

//     public var rawValue: String {
//         return id
//     }

//     public init?(rawValue: String) {
//     }

//     public func inline() -> any HTMLNode {
//         return reference.inline()
//     }
// }

// // using some form of tokenizing:
// public enum ArticleContentElement: Sendable {
//     case html([any HTMLNode])
//     case reference([any Referencable])
// }


// of just HTML.cite()
// and a big enum 
// and a filter of references


// extension Referencable {
//     public func inline() -> any HTMLNode {
//         return HTML.sup(["class": "referencable-cite"]) {
//             HTML.a("#referencable-ref-\(id)", ["data-referencable-ref": id]) {
//                 HTML.text("[\(id)]")
//             }
//         }
//     }
// }



// --------------------------------------------------------------
// we want:

// -- type-safe enum-based references for citing
// -- dynamic referencing of that citation inline in the article text
// -- that reslves to dynamically rendered htmlnodes emitted for any mentioned reference from the greater available references in caseiterable type

import HTML

public protocol Referencable: Sendable, RawRepresentable where RawValue == String {
    // separate public name "(michael et al. 2019)" or numeric "[1]"
    // from the self.rawValue, which refers to our case name
    // case name is internal: beyond_cortisol may not be a nice reference to use publically
    var public_name_or_id: String { get }           // stable; used in anchors + JSON

    var title: String { get }
    var url: String { get }

    var authorLine: String? { get }
    var dateISO8601: String? { get }

    var doi: String? { get }
    // var comment: String? { get }
    // func inline() -> any HTMLNode
    // func node() -> HTMLNode
}

extension Referencable {
    public var public_name_or_id: String { self.rawValue }

    public var authorLine: String? { nil }
    public var dateISO8601: String? { nil }
    public var doi: String? { nil }
    // public var comment: String? { nil }
    // public func node(comment: String? = nil) -> any HTMLNode {


    // }
}


public struct Reference: HTMLNode {
    public let reference: any Referencable
    public let comments: [String]

    public init(
        _ reference: any Referencable,
        comments: [String] = []
    ) {
        self.reference = reference
        self.comments = comments
    }

    public func render(options: HTMLRenderOptions, indent: Int) -> String {
        let ref = reference

        var children: [any HTMLNode] = []

        children.append(
            HTMLElement(
                "span",
                attrs: ["class": "ref-title"],
                children: [
                    HTMLElement(
                        "a",
                        attrs: ["href": ref.url],
                        children: [
                            HTMLText(ref.title)
                        ]
                    )
                ]
            )
        )

        if let author = ref.authorLine, !author.isEmpty {
            children.append(
                HTMLElement(
                    "span",
                    attrs: ["class": "ref-author"],
                    children: [
                        HTMLText(" — \(author)")
                    ]
                )
            )
        }

        if let date = ref.dateISO8601, !date.isEmpty {
            children.append(
                HTMLElement(
                    "span",
                    attrs: ["class": "ref-date"],
                    children: [
                        HTMLText(" (\(date))")
                    ]
                )
            )
        }

        if let doi = ref.doi, !doi.isEmpty {
            children.append(
                HTMLElement(
                    "span",
                    attrs: ["class": "ref-doi"],
                    children: [
                        HTMLText(" DOI: \(doi)")
                    ]
                )
            )
        }

        for c in comments where !c.isEmpty {
            children.append(
                HTMLElement(
                    "div",
                    attrs: ["class": "ref-comment"],
                    children: [
                        HTMLText(c)
                    ]
                )
            )
        }

        return HTMLElement(
            "li",
            attrs: [
                "class": "ref-item",
                "id": "ref-\(ref.public_name_or_id)"
            ],
            children: children
        ).render(options: options, indent: indent)
    }
}

public struct Citation: HTMLNode {
    public let reference: any Referencable
    public let comment: String?

    public init(
        _ reference: any Referencable,
        comment: String? = nil
    ) {
        self.reference = reference
        self.comment = comment
    }

    public func render(options: HTMLRenderOptions, indent: Int) -> String {
        let id = reference.public_name_or_id

        return HTMLElement(
            "sup",
            attrs: ["class": "cite"],
            children: [
                HTMLElement(
                    "a",
                    attrs: [
                        "href": "#ref-\(id)",
                        "data-ref": id,
                        "aria-label": "Citation: Reference \(id)"
                    ],
                    children: []
                )
            ]
        ).render(options: options, indent: indent)
    }

    public func reference_node() -> Reference {
        var comments: [String] = []
        if let c = comment { comments.append(c) }
        return Reference(reference, comments: comments)
    }
}

public extension HTML {
    static func cite(_ ref: any Referencable) -> any HTMLNode {
        Citation(ref)
    }
}

public extension Referencable {
    func cite() -> any HTMLNode {
        HTML.cite(self)
    }
}

public enum ReferenceCollector {
    public static func collect(
        from nodes: HTMLFragment
    ) -> [Reference] {
        var seen = Set<String>()
        var ordered: [Reference] = []
        var indexByID: [String: Int] = [:]

        func record(_ cite: Citation) {
            let id = cite.reference.public_name_or_id
            guard !id.isEmpty else { return }

            if seen.insert(id).inserted {
                indexByID[id] = ordered.count
                ordered.append(cite.reference_node())
                return
            }

            // Merge comments for duplicates.
            guard let idx = indexByID[id] else { return }
            guard let c = cite.comment, !c.isEmpty else { return }

            let existing = ordered[idx]
            if existing.comments.contains(c) { return }

            var merged = existing.comments
            merged.append(c)

            ordered[idx] = Reference(existing.reference, comments: merged)
        }

        func citation(_ node: any HTMLNode) {
            if let cite = node as? Citation {
                record(cite)
            }
        }

        func walk(_ node: any HTMLNode) {
            citation(node)

            if let el = node as? HTMLElement {
                for child in el.children {
                    walk(child)
                }
                return
            }

            if let inline = node as? HTMLInlineGroup {
                for child in inline.children {
                    walk(child)
                }
                return
            }

            if let gate = node as? HTMLGate {
                for child in gate.children {
                    walk(child)
                }
                return
            }
        }

        for n in nodes {
            walk(n)
        }

        return ordered
    }
}


// // so this takes the nodes array
// // and checks for DocCite -> wrapper around `any Reference`
// // returns all the found refernces, passed by type
// // then we can further flexibly render them from type
// public enum DocCiteCollector {
//     public static func collect(
//         from nodes: HTMLFragment
//     ) -> [any Referencable] {
//         var seen = Set<String>()
//         var ordered: [any Referencable] = []

//         func record(_ ref: any Referencable) {
//             let id = ref.id
//             guard !id.isEmpty else { return }
//             if seen.insert(id).inserted {
//                 ordered.append(ref)
//             }
//         }

//         func walk(_ node: any HTMLNode) {
//             if let cite = node as? DocCite {
//                 record(cite.reference)
//                 return
//             }

//             if let el = node as? HTMLElement {
//                 for child in el.children { walk(child) }
//                 return
//             }

//             if let inline = node as? HTMLInlineGroup {
//                 for child in inline.children { walk(child) }
//                 return
//             }

//             if let gate = node as? HTMLGate {
//                 for child in gate.children { walk(child) }
//                 return
//             }
//         }

//         for n in nodes { walk(n) }
//         return ordered
//     }
// }


// public enum References {
//     /// Renders the full references block (heading + list).
//     /// Uses the same anchor contract as `HTML.cite(...)`: `href="#ref-<id>"` => `<li id="ref-<id>">`.
//     public static func build(
//         _ references: [any Referencable],
//         heading: String = "Referenties"
//     ) -> [any HTMLNode] {
//         guard !references.isEmpty else { return [] }

//         return [
//             HTML.comment("created by webs"),
//             HTML.h2 {
//                 HTML.text(heading)
//             },
//             HTML.ul(["class": "refs-list"]) {
//                 for ref in references {
//                     Reference.build(ref)
//                 }
//             }
//         ]
//     }
// }

// public enum Reference {
//     /// Renders a single reference list item.
//     /// Classes match your existing HTML: ref-item / ref-title / ref-author / ref-comment
//     /// Adds: ref-date + ref-doi for the extra model fields.
//     public static func build(
//         _ ref: any Referencable
//     ) -> any HTMLNode {
//         HTML.li(["class": "ref-item", "id": "ref-\(ref.id)"]) {
//             HTML.span(["class": "ref-title"]) {
//                 HTML.a(ref.url) {
//                     HTML.text(ref.title)
//                 }
//             }

//             if let author = ref.authorLine, !author.isEmpty {
//                 HTML.span(["class": "ref-author"]) {
//                     HTML.text(" — \(author)")
//                 }
//             }

//             if let date = ref.dateISO8601, !date.isEmpty {
//                 HTML.span(["class": "ref-date"]) {
//                     HTML.text(" (\(date))")
//                 }
//             }

//             if let doi = ref.doi, !doi.isEmpty {
//                 HTML.span(["class": "ref-doi"]) {
//                     HTML.text(" DOI: \(doi)")
//                 }
//             }

//             if let comment = ref.comment, !comment.isEmpty {
//                 HTML.div(["class": "ref-comment"]) {
//                     HTML.text(comment)
//                 }
//             }
//         }
//     }
// }


