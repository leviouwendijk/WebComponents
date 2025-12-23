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


