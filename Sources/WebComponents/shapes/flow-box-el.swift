import DSL
import Constructors
import HTML
import CSS

public struct FlowBox:
    ComponentOutputProviding,
    SelectableComponent,
    Sendable
{
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-flow"

    private static let styleIdentifier: CSSContributionIdentifier =
        "webcomponents.shapes.flow-box.styles"

    public struct Selectors: Sendable {
        private let api = BlockSelectorAPI<Namespace>(
            block: FlowBox.block
        )

        public init() {}

        public var box: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)__box")
        }

        public var boxInner: HTMLClass<Namespace> {
            HTMLClass("\(api.root.rawValue)__box-inner")
        }

        public var boxCenter: HTMLClass<Namespace> {
            HTMLClass("\(box.rawValue)--center")
        }

        public var boxStart: HTMLClass<Namespace> {
            HTMLClass("\(box.rawValue)--start")
        }
    }

    public static let selectors = Selectors()

    public let box: Box

    public init(
        _ box: Box
    ) {
        self.box = box
    }

    private var semanticBody: HTMLFragment {
        let s = Self.selectors

        let alignClass: AnyHTMLClass = {
            switch box.align {
            case .center:
                return s.boxCenter.erased
            case .start:
                return s.boxStart.erased
            }
        }()

        var a = HTMLAttribute.classes(
            base: [
                s.box.erased,
                alignClass
            ],
            appending: box.classes
        )
        a.merge(box.attrs)

        return [
                HTML.div(a) {
                    HTML.div(.class(s.boxInner)) {
                        box.content()
                    }
                }
        ]
    }

    public var output: ComponentOutput {
        ComponentOutput(
            content: ComponentContent(
                body: semanticBody
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
            stylesheets:
                semantic
                    .dependencies
                    .styles
                    .contributions
                    .map {
                        $0.content.sheet
                    },
            scripts:
                semantic
                    .dependencies
                    .scripts
                    .contributions
                    .map(\.script)
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public func sheet() -> CSSStyleSheet {
        nodes.stylesheets[0]
    }
}

public extension FlowBox {
    private static func authoredStylesheet() -> CSSStyleSheet {
        let s = Self.selectors

        let darkModeBox = CSSSelector
            .class("dark-mode")
            .descendant(s.box.cssSelector)

        let emphasized = CSSSelector.group(
            s.boxInner
                .descendant(CSSSelector.element("b")),
            s.boxInner
                .descendant(CSSSelector.element("strong"))
        )

        let inlineText = CSSSelector.group(
            s.boxInner
                .descendant(CSSSelector.element("span")),
            s.boxInner
                .descendant(CSSSelector.element("p"))
        )

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    s.box,
                    CSS.decl("background", "var(--background-color, #fff)"),
                    CSS.decl("color", "var(--text-color, #0f172a)"),
                    CSS.decl("border", "1px solid var(--border-color, rgba(0,0,0,0.12))"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("box-shadow", "var(--shadow-soft, 0 12px 28px rgba(0,0,0,0.08))"),
                    CSS.decl("padding", "14px 16px"),
                    CSS.decl("min-width", "160px"),
                    CSS.decl("max-width", "320px")
                ),

                CSS.rule(
                    darkModeBox,
                    CSS.decl(
                        "background",
                        "var(--submenu-bg-color, var(--background-color, #1e1e1e))"
                    )
                ),

                CSS.rule(
                    s.boxInner,
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("gap", "6px"),
                    CSS.decl("min-height", "56px")
                ),

                CSS.rule(
                    emphasized,
                    CSS.decl("color", "var(--text-color, #0f172a)"),
                    CSS.decl("font-weight", "700")
                ),

                CSS.rule(
                    inlineText,
                    CSS.decl(
                        "color",
                        "var(--ref-meta-text-color, var(--text-color, #0f172a))"
                    )
                ),

                CSS.rule(
                    s.boxCenter
                        .descendant(s.boxInner),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("text-align", "center")
                ),

                CSS.rule(
                    s.boxStart
                        .descendant(s.boxInner),
                    CSS.decl("align-items", "flex-start"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("text-align", "left")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 900px)",
                    CSS.rule(
                        s.box,
                        CSS.decl("min-width", "148px"),
                        CSS.decl("max-width", "280px")
                    )
                ),

                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        s.box,
                        CSS.decl("min-width", "132px"),
                        CSS.decl("max-width", "240px"),
                        CSS.decl("padding", "12px 12px")
                    ),
                    CSS.rule(
                        s.boxInner,
                        CSS.decl("min-height", "48px"),
                        CSS.decl("gap", "5px"),
                        CSS.decl("font-size", "0.95rem")
                    )
                )
            ]
        )
    }
}

private extension FlowBox {
    static func styleContribution() -> CSSContribution {
        let sheet = authoredStylesheet()

        let units =
            sheet.rules.map {
                CSSContributionUnit.block(
                    .rule($0)
                )
            }
            + sheet.media.map {
                CSSContributionUnit.block(
                    .media($0)
                )
            }
            + sheet.keyframes.map {
                CSSContributionUnit.block(
                    .keyframes($0)
                )
            }

        return CSS.contribution(
            styleIdentifier,
            content:
                CSSContributionSet(
                    units:
                        units
                )
        )
    }
}

public extension FlowBox {
    static func css() -> CSSStyleSheet {
        styleContribution().content.sheet
    }
}
