// import HTML

// public enum ReferenceCollector {
//     public static func collect(
//         from nodes: HTMLFragment
//     ) -> [Reference] {
//         var seen = Set<String>()
//         var ordered: [Reference] = []
//         var indexByID: [String: Int] = [:]

//         func record(_ cite: Citation) {
//             let id = cite.reference.public_name_or_id
//             guard !id.isEmpty else { return }

//             if seen.insert(id).inserted {
//                 indexByID[id] = ordered.count
//                 ordered.append(cite.reference_node())
//                 return
//             }

//             // Merge comments for duplicates.
//             guard let idx = indexByID[id] else { return }
//             guard let c = cite.comment, !c.isEmpty else { return }

//             let existing = ordered[idx]
//             if existing.comments.contains(c) { return }

//             var merged = existing.comments
//             merged.append(c)

//             ordered[idx] = Reference(existing.reference, comments: merged)
//         }

//         func citation(_ node: any HTMLNode) {
//             if let cite = node as? Citation {
//                 record(cite)
//             }
//         }

//         func walk(_ node: any HTMLNode) {
//             citation(node)

//             if let el = node as? HTMLElement {
//                 for child in el.children {
//                     walk(child)
//                 }
//                 return
//             }

//             if let inline = node as? HTMLInlineGroup {
//                 for child in inline.children {
//                     walk(child)
//                 }
//                 return
//             }

//             if let gate = node as? HTMLGate {
//                 for child in gate.children {
//                     walk(child)
//                 }
//                 return
//             }
//         }

//         for n in nodes {
//             walk(n)
//         }

//         return ordered
//     }
// }
