// import HTML
// import References

// public struct Citation: HTMLNode {
//     public let reference: any Referencable
//     public let locators: [ReferenceLocator]
//     public let comment: String?

//     public init(
//         _ reference: any Referencable,
//         locators: [ReferenceLocator] = [],
//         comment: String? = nil
//     ) {
//         self.reference = reference
//         self.locators = locators
//         self.comment = comment
//     }

//     public init(
//         _ reference: any Referencable,
//         at locator: ReferenceLocator,
//         comment: String? = nil
//     ) {
//         self.init(
//             reference,
//             locators: [locator],
//             comment: comment
//         )
//     }

//     public func render(options: HTMLRenderOptions, indent: Int) -> String {
//         let id = reference.public_name_or_id
//         let locatorText = locators.map(\.rendered).joined(separator: ", ")

//         var anchorAttrs: HTMLAttribute = [
//             "href": "#ref-\(id)",
//             "data-ref": id,
//             "aria-label": locatorText.isEmpty
//                 ? "Citation: Reference \(id)"
//                 : "Citation: Reference \(id), \(locatorText)"
//         ]

//         if !locatorText.isEmpty {
//             anchorAttrs.merge([
//                 "data-ref-locators": locatorText
//             ])
//         }

//         return HTMLElement(
//             "sup",
//             attrs: ["class": "cite"],
//             children: [
//                 HTMLElement(
//                     "a",
//                     attrs: anchorAttrs,
//                     children: []
//                 )
//             ]
//         ).render(options: options, indent: indent)
//     }

//     @available(
//         *, deprecated,
//         message:
//             "Use CitationResolver.resolve(from:) to build references (needs occurrence pointers + comment pointers)."
//     )
//     public func reference_node(
//         pointers: [Int]
//     ) -> Reference {
//         var items: [Reference.Comment] = []
//         let text = comment ?? ""

//         if !text.isEmpty || !locators.isEmpty {
//             items.append(
//                 Reference.Comment(
//                     pointers: pointers,
//                     locators: locators,
//                     text: text
//                 )
//             )
//         }

//         return Reference(
//             reference,
//             pointers: pointers,
//             comments: items
//         )
//     }
// }
