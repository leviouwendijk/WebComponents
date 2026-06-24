import HTML
import References

public extension HTML {
    static func cite(
        _ ref: any Referencable
    ) -> any HTMLNode {
        Citation(ref)
    }

    static func cite(
        _ ref: any Referencable,
        comment: String?
    ) -> any HTMLNode {
        Citation(
            ref,
            comment: comment
        )
    }
}

public extension Referencable {
    func cite() -> any HTMLNode {
        HTML.cite(self)
    }

    func cite(
        comment: String?
    ) -> any HTMLNode {
        HTML.cite(
            self,
            comment: comment
        )
    }
}
