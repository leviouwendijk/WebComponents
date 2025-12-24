import HTML

public enum CitationResolver {
    public struct Output: Sendable {
        public let body: HTMLFragment
        public let references: [Reference]

        public init(
            body: HTMLFragment,
            references: [Reference]
        ) {
            self.body = body
            self.references = references
        }
    }

    public static func resolve(
        from nodes: HTMLFragment
    ) -> Output {
        // Every Citation occurrence gets a new number (1,2,3,...)
        var occurrence: Int = 0

        // Unique references, in first-seen order
        var order: [String] = []
        var seen: Set<String> = []

        // Reference storage
        var refByID: [String: any Referencable] = [:]

        // All occurrence numbers that point to a given reference id
        var pointersByID: [String: [Int]] = [:]

        // Merged comment list per reference id
        var commentsByID: [String: [String]] = [:]

        @inline(__always)
        func record(_ cite: Citation) -> (n: Int, id: String)? {
            let id = cite.reference.public_name_or_id
            guard !id.isEmpty else { return nil }

            occurrence += 1
            let n = occurrence

            if seen.insert(id).inserted {
                order.append(id)
                refByID[id] = cite.reference
            }

            pointersByID[id, default: []].append(n)

            if let c = cite.comment, !c.isEmpty {
                var list = commentsByID[id, default: []]
                if !list.contains(c) {
                    list.append(c)
                    commentsByID[id] = list
                }
            }

            return (n, id)
        }

        @inline(__always)
        func resolvedCitationNode(
            number: Int,
            id: String
        ) -> any HTMLNode {
            // Anchor for backlinks: #cite-<n>
            return HTMLElement(
                "sup",
                attrs: [
                    "class": "cite",
                    "data-cite": "\(number)",
                    "id": "cite-\(number)"
                ],
                children: [
                    HTMLElement(
                        "a",
                        attrs: [
                            "href": "#ref-\(id)",
                            "data-ref": id,
                            "aria-label": "Citation \(number)"
                        ],
                        children: [
                            HTMLText("[\(number)]")
                        ]
                    )
                ]
            )
        }

        func transform(_ node: any HTMLNode) -> any HTMLNode {
            if let cite = node as? Citation {
                guard let (n, id) = record(cite) else { return node }
                return resolvedCitationNode(number: n, id: id)
            }

            if let el = node as? HTMLElement {
                return HTMLElement(
                    el.tag,
                    attrs: el.attrs,
                    children: el.children.map(transform),
                    selfClosing: el.selfClosing
                )
            }

            if let inline = node as? HTMLInlineGroup {
                return HTMLInlineGroup(
                    inline.children.map(transform)
                )
            }

            if let gate = node as? HTMLGate {
                return HTMLGate(
                    id: gate.id,
                    allow: gate.allowed,
                    children: gate.children.map(transform)
                )
            }

            return node
        }

        let body: HTMLFragment = nodes.map(transform)

        var references: [Reference] = []
        references.reserveCapacity(order.count)

        for id in order {
            guard let ref = refByID[id] else { continue }
            let pointers = pointersByID[id] ?? []
            let index = pointers.first ?? 0
            let comments = commentsByID[id] ?? []

            references.append(
                Reference(
                    ref,
                    index: index,
                    pointers: pointers,
                    comments: comments
                )
            )
        }

        return Output(body: body, references: references)
    }
}
