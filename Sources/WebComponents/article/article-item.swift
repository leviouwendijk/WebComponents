import Foundation
import HTML
import Constructors
import Path

// next up:
// do we want to use article item path
// as the method of identifiers?
// do we want to create PageTargets manually
// so as to syntehsize our TOC?
// or do we direclty synthesize
// the TOC NavigationStructure from 
// the ArticleItem

public struct ArticleItem: ArticleEmitting {
    public var path: StandardPath

    public var title: String // document title, api title
    public var definition: String // document intro, api description

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
    // are now dynamically computed

    public init(
        path: StandardPath,
        title: String,
        definition: String,
        thumbnail_src: StandardPath? = nil,
        content: @escaping @Sendable () -> HTMLFragment,
        // references: [any Referencable] = []
    ) {
        self.path = path
        self.title = title
        self.definition = definition
        self.thumbnail_src = thumbnail_src
        self.content = content
        // self.references = references
    }
}

public extension ArticleItem {
    /// Standardized header block for every doc item:
    /// - Renders `title` + `definition` once (no drift).
    /// - Optional thumbnail rendered "wiki style" (to the right of the definition).
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
                    HTML.div(["class": "doc-lead__definition"]) {
                        HTML.p(["class": "doc-definition"]) {
                            HTML.text(self.definition)
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
                HTML.div(["class": "doc-lead doc-lead--with-thumb"]) {
                    HTML.div(["class": "doc-lead__definition"]) {
                        HTML.p(["class": "doc-definition"]) {
                            HTML.text(self.definition)
                        }
                    }
                }
            )
        }

        return nodes
    }

    // possible convenience
    func lead_and_content() -> HTMLFragment {
        return lead() + content()
    }
}

public extension ArticleItem {
    // rendering full article with rich references
    func article() -> HTMLFragment {
        let input_state = lead_and_content()

        let resolved = CitationResolver.resolve(from: input_state)
        // let refs = ReferenceCollector.collect(from: base)
        let refs = resolved.references

        guard !refs.isEmpty else { 
            return input_state
        }

        // return base + [
        return resolved.body + [
            // this can be further made flexibly rendered:
            // since we may not always want this exact rendering style
            // for now, ok
            HTML.h2 { 
                HTML.text("Referenties")
            },
            HTML.ul(["class": "refs-list"]) {
                for ref in refs {
                    ref
                }
            }
        ]
    }

    func article_data() -> Self.ReferenceResolved {
        let input_state = lead_and_content()
        return CitationResolver.resolve(from: input_state)
    }
}
