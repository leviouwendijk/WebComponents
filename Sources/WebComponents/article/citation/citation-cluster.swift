import CSS
import HTML
import References

public enum CitationCluster {
    public static let className = "wc-citation-cluster"
    public static let paddedClassName = "wc-citation-cluster--padded"

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: rules()
        )
    }

    public static func rules() -> [CSSRule] {
        [
            CSS.rule(
                ".\(className)",
                CSS.decl("display", "inline-flex"),
                CSS.decl("align-items", "baseline"),
                CSS.decl("gap", ".35em"),
                CSS.decl("white-space", "nowrap"),
                CSS.decl("vertical-align", "super"),
                CSS.decl("line-height", "1"),
                CSS.decl("text-align", "left"),
                CSS.decl("text-indent", "0")
            ),

            CSS.rule(
                ".\(paddedClassName)",
                CSS.decl("margin-inline-start", ".35em")
            )
        ]
    }
}

public extension HTML {
    static func cites(
        _ references: any Referencable...,
        comment: String? = nil
    ) -> any HTMLNode {
        cites(
            references,
            comment: comment
        )
    }

    static func cites(
        _ references: [any Referencable],
        comment: String? = nil
    ) -> any HTMLNode {
        citation_cluster(
            references,
            comment: comment,
            padded: false
        )
    }

    static func cites(
        _ group: ReferenceGroup,
        comment: String? = nil
    ) -> any HTMLNode {
        cites(
            group.references,
            comment: comment
        )
    }

    static func citepad(
        _ references: any Referencable...,
        comment: String? = nil
    ) -> any HTMLNode {
        citepad(
            references,
            comment: comment
        )
    }

    static func citepad(
        _ references: [any Referencable],
        comment: String? = nil
    ) -> any HTMLNode {
        citation_cluster(
            references,
            comment: comment,
            padded: true
        )
    }

    static func citepad(
        _ group: ReferenceGroup,
        comment: String? = nil
    ) -> any HTMLNode {
        citepad(
            group.references,
            comment: comment
        )
    }

    private static func citation_cluster(
        _ references: [any Referencable],
        comment: String?,
        padded: Bool
    ) -> any HTMLNode {
        HTMLElement(
            "span",
            attrs: [
                "class": padded
                    ? "\(CitationCluster.className) \(CitationCluster.paddedClassName)"
                    : CitationCluster.className
            ],
            children: references.map { reference -> any HTMLNode in
                Citation(
                    reference,
                    comment: comment
                )
            }
        )
    }
}

public extension ReferenceGroup {
    func cites(
        comment: String? = nil
    ) -> any HTMLNode {
        HTML.cites(
            self,
            comment: comment
        )
    }

    func citepad(
        comment: String? = nil
    ) -> any HTMLNode {
        HTML.citepad(
            self,
            comment: comment
        )
    }
}
