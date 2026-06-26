import HTML
import References

public extension HTML {
    static func cite(
        _ ref: any Referencable,
        locators: [ReferenceLocator] = [],
        comment: String? = nil
    ) -> any HTMLNode {
        Citation(
            ref,
            locators: locators,
            comment: comment
        )
    }

    static func cite(
        _ ref: any Referencable,
        at locator: ReferenceLocator,
        comment: String? = nil
    ) -> any HTMLNode {
        Citation(
            ref,
            at: locator,
            comment: comment
        )
    }
}

public extension Referencable {
    func cite(
        locators: [ReferenceLocator] = [],
        comment: String? = nil
    ) -> any HTMLNode {
        HTML.cite(
            self,
            locators: locators,
            comment: comment
        )
    }

    func cite(
        at locator: ReferenceLocator,
        comment: String? = nil
    ) -> any HTMLNode {
        HTML.cite(
            self,
            at: locator,
            comment: comment
        )
    }
}
