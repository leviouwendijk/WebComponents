import HTML
import References

public enum CitationCluster {
    public static let className = "wc-citation-cluster"
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
        HTMLElement(
            "span",
            attrs: [
                "class": CitationCluster.className
            ],
            children: references.map { reference in
                Citation(
                    reference,
                    comment: comment
                )
            }
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
}
