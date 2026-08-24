import Constructors
import JS

public struct PortableDocumentFormatRuntimeScript:
    ComponentOutputProviding,
    ReusableComponent
{
    private static let contributionIdentifier:
        JSContributionIdentifier =
            "webcomponents.portable-document-format.runtime"

    public init() {}

    public var output:
        ComponentOutput
    {
        ComponentOutput(
            dependencies:
                ComponentDependencies(
                    scripts:
                        JSContributions(
                            [
                                Self
                                    .scriptContribution()
                            ]
                        )
                )
        )
    }

    public var nodes:
        ReusableComponentNodes
    {
        ReusableComponentNodes(
            scripts:
                output
                    .dependencies
                    .scripts
                    .contributions
                    .map(
                        \.script
                    )
        )
    }

    private static func scriptContribution()
        -> JSContribution
    {
        JS.contribution(
            contributionIdentifier,
            script:
                JSSource(
                    PortableDocumentFormatRuntimeSource
                        .source
                )
                .as_inline_script()
        )
    }
}
