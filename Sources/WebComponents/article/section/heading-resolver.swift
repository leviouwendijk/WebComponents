import HTML

public enum HeadingResolver {
    public struct Entry: Sendable {
        public let id: String
        public let label: String
        public let level: Int
    }

    public struct Resolved: Sendable {
        public let body: HTMLFragment
        public let entries: [Entry]
    }

    public static func resolve(from nodes: HTMLFragment) -> Resolved {
        var entries: [Entry] = []

        func walk(_ node: any HTMLNode) {
            if let h = node as? ArticleHeading {
                let text = h.label
                    .map { ($0 as? HTMLText)?.text ?? "" }
                    .joined()
                entries.append(Entry(id: h.id, label: text, level: h.level))
                return
            }
            if let el = node as? HTMLElement {
                el.children.forEach(walk)
            }
            if let g = node as? HTMLInlineGroup {
                g.children.forEach(walk)
            }
            if let g = node as? HTMLGate {
                g.children.forEach(walk)
            }
        }

        nodes.forEach(walk)
        return Resolved(body: nodes, entries: entries)
    }
}
