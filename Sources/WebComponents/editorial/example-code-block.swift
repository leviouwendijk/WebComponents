import DSL
import Constructors
import CSS
import HTML

public struct ExampleCodeBlock:
    ComponentOutputProviding,
    SelectableComponent,
    Sendable
{
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-example-code"

    private static let styleIdentifier: CSSContributionIdentifier =
        "webcomponents.editorial.example-code.styles"

    public struct Selectors: Sendable {
        private let api = BlockSelectorAPI<Namespace>(
            block: ExampleCodeBlock.block
        )

        public init() {}

        public var root: HTMLClass<Namespace> {
            api.root
        }

        public var intro: HTMLClass<Namespace> {
            api.element("intro")
        }

        public var pre: HTMLClass<Namespace> {
            api.element("pre")
        }

        public var code: HTMLClass<Namespace> {
            api.element("code")
        }

        public var caption: HTMLClass<Namespace> {
            api.element("caption")
        }

        public var compact: HTMLClass<Namespace> {
            api.modifier("compact")
        }
    }

    public struct Vars: Sendable {
        private let api = BlockSelectorAPI<Namespace>(
            block: ExampleCodeBlock.block
        )

        public init() {}

        public var introText: CSSVariable<Namespace> {
            api.variable("intro-text")
        }

        public var codeBackground: CSSVariable<Namespace> {
            api.variable("code-background")
        }

        public var codeBorder: CSSVariable<Namespace> {
            api.variable("code-border")
        }

        public var codeText: CSSVariable<Namespace> {
            api.variable("code-text")
        }

        public var captionText: CSSVariable<Namespace> {
            api.variable("caption-text")
        }
    }

    public static let selectors = Selectors()
    public static let vars = Vars()

    public struct Model: Sendable {
        public let header: EditorialSectionHeader.Model?
        public let intro: HTMLFragment?
        public let code: String
        public let language: String?
        public let caption: HTMLFragment?
        // public let isCompact: Bool

        public init(
            header: EditorialSectionHeader.Model? = nil,
            intro: HTMLFragment? = nil,
            code: String,
            language: String? = nil,
            caption: HTMLFragment? = nil,
            // isCompact: Bool = false
        ) {
            self.header = header
            self.intro = intro
            self.code = code
            self.language = language
            self.caption = caption
            // self.isCompact = isCompact
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
        let attrs = HTMLAttribute.class(s.root)
        var codeAttrs = HTMLAttribute.class(s.code)

        if let language = model.language, !language.isEmpty {
            codeAttrs.merge(.data("language", language))
        }

        let headerOutput = model.header.map {
            EditorialSectionHeader($0).output
        }

        let content = ComponentContent(
            body: [
                HTML.section(attrs) {
                    if let headerOutput {
                        headerOutput.content.body
                    }

                    if let intro = model.intro, !intro.isEmpty {
                        HTML.div(.class(s.intro)) {
                            intro
                        }
                    }

                    HTML.pre(.class(s.pre)) {
                        HTML.code(codeAttrs) {
                            HTML.text(model.code)
                        }
                    }

                    if let caption = model.caption, !caption.isEmpty {
                        HTML.div(.class(s.caption)) {
                            caption
                        }
                    }
                }
            ]
        )

        let ownDependencies = ComponentDependencies(
            styles: CSSContributions([
                Self.styleContribution()
            ])
        )

        let dependencies = headerOutput?.dependencies.merging(ownDependencies)
            ?? ownDependencies

        return ComponentOutput(
            content: content,
            dependencies: dependencies
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

public extension ExampleCodeBlock {
    private static func authoredStylesheet() -> CSSStyleSheet {
        let s = Self.selectors
        let v = Self.vars

        let introParagraphs = s.intro
            .descendant(CSSSelector.element("p"))

        let captionParagraphs = s.caption
            .descendant(CSSSelector.element("p"))

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    s.root,
                    decl(v.introText, "var(--text-color, #0f172a)"),
                    decl(v.codeBackground, "var(--code-bg-color, rgba(15, 23, 42, 0.06))"),
                    decl(v.codeBorder, "var(--border-color, rgba(15, 23, 42, 0.10))"),
                    decl(v.codeText, "var(--text-color, #0f172a)"),
                    decl(v.captionText, "var(--ref-meta-text-color, var(--text-color, #0f172a))"),

                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("margin", "16px 0 24px 0")
                ),

                CSS.rule(
                    s.compact,
                    CSS.decl("gap", "8px"),
                    CSS.decl("margin", "12px 0 18px 0")
                ),

                CSS.rule(
                    s.intro,
                    CSS.decl("font-size", "1rem"),
                    CSS.decl("line-height", "1.55"),
                    CSS.decl("color", cssvar(v.introText, fallback: "#0f172a"))
                ),

                CSS.rule(
                    introParagraphs,
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    s.pre,
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "14px 16px"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("overflow-x", "auto"),
                    CSS.decl("background", cssvar(v.codeBackground, fallback: "rgba(15, 23, 42, 0.06)")),
                    CSS.decl("border", "1px solid \(cssvar(v.codeBorder, fallback: "rgba(15, 23, 42, 0.10)"))")
                ),

                CSS.rule(
                    s.code,
                    CSS.decl("display", "block"),
                    CSS.decl(
                        "font-family",
                        "ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, \"Liberation Mono\", monospace"
                    ),
                    CSS.decl("font-size", "0.95rem"),
                    CSS.decl("line-height", "1.6"),
                    CSS.decl("white-space", "pre-wrap"),
                    CSS.decl("word-break", "break-word"),
                    CSS.decl("color", cssvar(v.codeText, fallback: "#0f172a"))
                ),

                CSS.rule(
                    s.caption,
                    CSS.decl("font-size", "0.92rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", cssvar(v.captionText, fallback: "#0f172a"))
                ),

                CSS.rule(
                    captionParagraphs,
                    CSS.decl("margin", "0")
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

    public static func css() -> CSSStyleSheet {
        styleContribution().content.sheet
    }

}

// public extension ExampleCodeBlock {
//     static func css() -> CSSStyleSheet {
//         let s = Self.selectors

//         let introParagraphs = s.intro
//             .descendant(CSSSelector.element("p"))

//         let captionParagraphs = s.caption
//             .descendant(CSSSelector.element("p"))

//         return CSSStyleSheet(
//             rules: [
//                 CSS.rule(
//                     s.root,
//                     CSS.decl("display", "flex"),
//                     CSS.decl("flex-direction", "column"),
//                     CSS.decl("gap", "12px"),
//                     CSS.decl("margin", "16px 0 24px 0")
//                 ),

//                 CSS.rule(
//                     s.compact,
//                     CSS.decl("gap", "8px"),
//                     CSS.decl("margin", "12px 0 18px 0")
//                 ),

//                 CSS.rule(
//                     s.intro,
//                     CSS.decl("font-size", "1rem"),
//                     CSS.decl("line-height", "1.55"),
//                     CSS.decl("color", "var(--text-color, #0f172a)")
//                 ),

//                 CSS.rule(
//                     introParagraphs,
//                     CSS.decl("margin", "0")
//                 ),

//                 CSS.rule(
//                     s.pre,
//                     CSS.decl("margin", "0"),
//                     CSS.decl("padding", "14px 16px"),
//                     CSS.decl("border-radius", "12px"),
//                     CSS.decl("overflow-x", "auto"),
//                     CSS.decl("background", "var(--code-bg-color, rgba(15, 23, 42, 0.06))"),
//                     CSS.decl("border", "1px solid var(--border-color, rgba(15, 23, 42, 0.10))")
//                 ),

//                 CSS.rule(
//                     s.code,
//                     CSS.decl("display", "block"),
//                     CSS.decl("font-family", "ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, \"Liberation Mono\", monospace"),
//                     CSS.decl("font-size", "0.95rem"),
//                     CSS.decl("line-height", "1.6"),
//                     CSS.decl("white-space", "pre-wrap"),
//                     CSS.decl("word-break", "break-word"),
//                     CSS.decl("color", "var(--text-color, #0f172a)")
//                 ),

//                 CSS.rule(
//                     s.caption,
//                     CSS.decl("font-size", "0.92rem"),
//                     CSS.decl("line-height", "1.45"),
//                     CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))")
//                 ),

//                 CSS.rule(
//                     captionParagraphs,
//                     CSS.decl("margin", "0")
//                 )
//             ]
//         )
//     }
// }
