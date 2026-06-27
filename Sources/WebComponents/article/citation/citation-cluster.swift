import HTML
import References

public enum CitationCluster {
    public static let className = "wc-citation-cluster"
}

public extension HTML {
    static func cites(
        _ references: any Referencable...
    ) -> any HTMLNode {
        HTMLElement(
            "span",
            attrs: [
                "class": CitationCluster.className
            ],
            children: references.map { reference in
                reference.cite()
            }
        )
    }
}
