import HTML
import References

public enum CitationResolver {
    public static func resolve(
        from nodes: HTMLFragment
    ) -> ArticleItem.ReferenceResolved {
        var occurrence: Int = 0

        var order: [String] = []
        var seen: Set<String> = []

        var refByID: [String: any Referencable] = [:]
        var pointersByID: [String: [Int]] = [:]

        var noteOrderByID: [String: [String]] = [:]
        var noteByID: [String: [String: Reference.Comment]] = [:]

        var footnotes: [FootnoteReference] = []

        @inline(__always)
        func record(
            _ cite: Citation
        ) {
            let id = cite.reference.public_name_or_id
            guard !id.isEmpty else { return }

            occurrence += 1
            let n = occurrence

            if seen.insert(id).inserted {
                order.append(id)
                refByID[id] = cite.reference
            }

            pointersByID[id, default: []].append(n)

            let text = cite.comment ?? ""

            guard !text.isEmpty || !cite.locators.isEmpty else {
                return
            }

            let locatorKey = cite.locators
                .map(\.stableKey)
                .joined(separator: "|")

            let key = locatorKey + "\u{001F}" + text

            if noteByID[id]?[key] == nil {
                noteOrderByID[id, default: []].append(key)
            }

            var map = noteByID[id, default: [:]]

            let old = map[key] ?? Reference.Comment(
                pointers: [],
                locators: cite.locators,
                text: text
            )

            var ptrs = old.pointers

            if ptrs.last != n {
                ptrs.append(n)
            }

            map[key] = Reference.Comment(
                pointers: ptrs,
                locators: old.locators,
                text: old.text
            )

            noteByID[id] = map
        }

        @inline(__always)
        func record(
            _ footnote: Footnote
        ) {
            occurrence += 1

            footnotes.append(
                FootnoteReference(
                    number: occurrence,
                    content: footnote.content
                )
            )
        }

        func walk(
            _ node: any HTMLNode
        ) {
            if let cite = node as? Citation {
                record(cite)
                return
            }

            if let footnote = node as? Footnote {
                record(footnote)
                return
            }

            if let el = node as? HTMLElement {
                el.children.forEach(walk)
                return
            }

            if let inline = node as? HTMLInlineGroup {
                inline.children.forEach(walk)
                return
            }

            if let gate = node as? HTMLGate {
                gate.children.forEach(walk)
                return
            }
        }

        nodes.forEach(walk)

        var commentsByID: [String: [Reference.Comment]] = [:]

        for id in order {
            let noteOrder = noteOrderByID[id] ?? []
            let noteMap = noteByID[id] ?? [:]

            commentsByID[id] = noteOrder.compactMap { key in
                noteMap[key]
            }
        }

        var renderOccurrence: Int = 0

        func resolvedCitationNode(
            number: Int,
            cite: Citation
        ) -> any HTMLNode {
            let id = cite.reference.public_name_or_id

            return ReferencePreviewLink(
                reference: cite.reference,
                number: number,
                comments: commentsByID[id] ?? [],
                anchorHref: "#ref-\(id)",
                includeStyles: false
            ).node()
        }

        func resolvedFootnoteNode(
            number: Int,
            footnote: Footnote
        ) -> any HTMLNode {
            FootnotePreviewLink(
                number: number,
                content: footnote.content,
                anchorHref: "#footnote-\(number)",
                includeStyles: false
            ).node()
        }

        func transform(
            _ node: any HTMLNode
        ) -> any HTMLNode {
            if let cite = node as? Citation {
                let id = cite.reference.public_name_or_id
                guard !id.isEmpty else { return node }

                renderOccurrence += 1

                return resolvedCitationNode(
                    number: renderOccurrence,
                    cite: cite
                )
            }

            if let footnote = node as? Footnote {
                renderOccurrence += 1

                return resolvedFootnoteNode(
                    number: renderOccurrence,
                    footnote: footnote
                )
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

            references.append(
                Reference(
                    ref,
                    pointers: pointersByID[id] ?? [],
                    comments: commentsByID[id] ?? []
                )
            )
        }

        return .init(
            body: body,
            references: references,
            footnotes: footnotes
        )
    }
}
