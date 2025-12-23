import Foundation
import HTML
import Constructors
import Path

public struct ArticleItem: Sendable {
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

    public var content: @Sendable () -> HTMLFragment 
    // public var references: [any Referencable]

    public init(
        path: StandardPath,
        title: String,
        summary: String,
        thumbnail_src: StandardPath? = nil,
        content: @escaping @Sendable () -> HTMLFragment,
        // references: [any Referencable] = []
    ) {
        self.path = path
        self.title = title
        self.summary = summary
        self.thumbnail_src = thumbnail_src
        self.content = content
        // self.references = references
    }
}

public extension ArticleItem {
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



public enum _ArticleTest {
    public static let primary: ArticleItem = ArticleItem(
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
                },

                // TESTS
                HTML.p {
                    HTML.text("Er bestaat een sterke koppeling tussen voedselgeur als prikkel, die de activiteit van eten aankondigt als gevolg. ")
                    HTML.cite(SomeLocallyDefinedRefs.some_ref_example)
                },

                HTML.p {
                    HTML.text("Hier verwijs ik er nog een keer naar, maar nu mét comment. ")
                    Citation(
                        SomeLocallyDefinedRefs.some_ref_example,
                        comment: "Used here to justify the expectancy/anticipation claim."
                    )
                },

                HTML.p {
                    HTML.text("Nogmaals dezelfde ref met een tweede comment om merge te testen. ")
                    Citation(
                        SomeLocallyDefinedRefs.some_ref_example,
                        comment: "Second mention: contrast with operant formulation."
                    )
                },
            ]
        },
    )
}

public enum SomeLocallyDefinedRefs: String, Referencable {
    case some_ref_example

    public var title: String {
        return "Some ref example"
    }

    public var url: String {
        return "https://example.com"
    }
}

public protocol Referencable: Sendable, RawRepresentable where RawValue == String {
    // separate public name "(michael et al. 2019)" or numeric "[1]"
    // from the self.rawValue, which refers to our case name
    // case name is internal: beyond_cortisol may not be a nice reference to use publically
    var public_name_or_id: String { get }           // stable; used in anchors + JSON
    // unfinished...
    // perhaps -> 'name' for public cite view fallback?
    // key -> id -> self.rawvalue, since not for public view anyway, but for data?

    var title: String { get }
    var url: String { get }

    var authorLine: String? { get }
    var dateISO8601: String? { get }

    var doi: String? { get }
}

extension Referencable {
    public var public_name_or_id: String { self.rawValue }

    public var authorLine: String? { nil }
    public var dateISO8601: String? { nil }
    public var doi: String? { nil }
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
