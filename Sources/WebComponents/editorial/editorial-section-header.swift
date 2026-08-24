import DSL
import Constructors
import CSS
import HTML

public struct EditorialSectionHeader:
    ComponentOutputProviding,
    SelectableComponent,
    Sendable
{
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-editorial-section-header"

    private static let styleIdentifier: CSSContributionIdentifier =
        "webcomponents.editorial.section-header.styles"

    public struct Selectors: Sendable {
        private let api = BlockSelectorAPI<Namespace>(
            block: EditorialSectionHeader.block
        )

        public init() {}

        public var root: HTMLClass<Namespace> {
            api.root
        }

        public var eyebrow: HTMLClass<Namespace> {
            api.element("eyebrow")
        }

        public var title: HTMLClass<Namespace> {
            api.element("title")
        }

        public var subtitle: HTMLClass<Namespace> {
            api.element("subtitle")
        }

        public var note: HTMLClass<Namespace> {
            api.element("note")
        }

        public var compact: HTMLClass<Namespace> {
            api.modifier("compact")
        }
    }

    public static let selectors = Selectors()

    public struct Model: Sendable {
        public let eyebrow: String?
        public let title: String
        public let subtitle: HTMLFragment?
        public let note: HTMLFragment?
        public let isCompact: Bool

        public init(
            eyebrow: String? = nil,
            title: String,
            subtitle: HTMLFragment? = nil,
            note: HTMLFragment? = nil,
            isCompact: Bool = false
        ) {
            self.eyebrow = eyebrow
            self.title = title
            self.subtitle = subtitle
            self.note = note
            self.isCompact = isCompact
        }
    }

    public let model: Model

    public init(
        _ model: Model
    ) {
        self.model = model
    }

    public var output: ComponentOutput {
        let s = Self.selectors
        var attrs = HTMLAttribute.class(s.root)

        if model.isCompact {
            attrs.merge(.class(s.compact))
        }

        return ComponentOutput(
            content: ComponentContent(
                body: [
                    HTML.header(attrs) {
                        if let eyebrow = model.eyebrow, !eyebrow.isEmpty {
                            HTML.p(.class(s.eyebrow)) {
                                HTML.text(eyebrow)
                            }
                        }

                        HTML.h2(.class(s.title)) {
                            HTML.text(model.title)
                        }

                        if let subtitle = model.subtitle, !subtitle.isEmpty {
                            HTML.div(.class(s.subtitle)) {
                                subtitle
                            }
                        }

                        if let note = model.note, !note.isEmpty {
                            HTML.div(.class(s.note)) {
                                note
                            }
                        }
                    }
                ]
            ),
            dependencies: ComponentDependencies(
                styles: CSSContributions([
                    Self.styleContribution()
                ])
            )
        )
    }

    public var nodes: ReusableComponentNodes {
        let semantic = output

        return .body(
            semantic.content.body,
            stylesheets: semantic.dependencies.styles.contributions.map {
                $0.content.sheet
            },
            scripts: semantic.dependencies.scripts.contributions.map(\.script)
        )
    }

    public func node() -> any HTMLNode {
        output.content.body[0]
    }

    public func sheet() -> CSSStyleSheet {
        Self.css()
    }

}

public extension EditorialSectionHeader {
    private static func authoredStylesheet() -> CSSStyleSheet {
        let s = Self.selectors

        let subtitleParagraphs = s.subtitle
            .descendant(CSSSelector.element("p"))

        let noteParagraphs = s.note
            .descendant(CSSSelector.element("p"))

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    s.root,
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("margin", "0 0 16px 0")
                ),

                CSS.rule(
                    s.compact,
                    CSS.decl("gap", "6px"),
                    CSS.decl("margin", "0 0 12px 0")
                ),

                CSS.rule(
                    s.eyebrow,
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "0.78rem"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("letter-spacing", "0.06em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))"),
                    CSS.decl("opacity", "0.78")
                ),

                CSS.rule(
                    s.title,
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.35rem"),
                    CSS.decl("line-height", "1.2"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("color", "var(--text-color, #0f172a)")
                ),

                CSS.rule(
                    s.subtitle,
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("color", "var(--text-color, #0f172a)")
                ),

                CSS.rule(
                    subtitleParagraphs,
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    s.note,
                    CSS.decl("font-size", "0.95rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))")
                ),

                CSS.rule(
                    noteParagraphs,
                    CSS.decl("margin", "0")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        s.title,
                        CSS.decl("font-size", "1.18rem")
                    )
                )
            ]
        )
    }

    private static func styleContribution() -> CSSContribution {
        let sheet = authoredStylesheet()
        let units =
            sheet.rules.map { CSSContributionUnit.block(.rule($0)) }
            + sheet.media.map { CSSContributionUnit.block(.media($0)) }
            + sheet.keyframes.map { CSSContributionUnit.block(.keyframes($0)) }

        return CSS.contribution(
            styleIdentifier,
            content: CSSContributionSet(units: units)
        )
    }

    static func css() -> CSSStyleSheet {
        styleContribution().content.sheet
    }
}
