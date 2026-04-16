import DSL
import Constructors
import CSS
import HTML

public struct SectionDivider: SelectableComponent, Sendable {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-section-divider"

    public struct Selectors: Sendable {
        private let api = BlockSelectorAPI<Namespace>(
            block: SectionDivider.block
        )

        public init() {}

        public var root: HTMLClass<Namespace> {
            api.root
        }

        public var line: HTMLClass<Namespace> {
            api.element("line")
        }

        public var label: HTMLClass<Namespace> {
            api.element("label")
        }

        public var subtle: HTMLClass<Namespace> {
            api.modifier("subtle")
        }

        public var strong: HTMLClass<Namespace> {
            api.modifier("strong")
        }

        public var labeled: HTMLClass<Namespace> {
            api.modifier("labeled")
        }
    }

    public static let selectors = Selectors()

    public struct Model: Sendable {
        public enum Variant: Sendable {
            case standard
            case subtle
            case strong
        }

        public let label: String?
        public let variant: Variant

        public init(
            label: String? = nil,
            variant: Variant = .standard
        ) {
            self.label = label
            self.variant = variant
        }
    }

    public let model: Model

    public init(
        _ model: Model = .init()
    ) {
        self.model = model
    }

    public var nodes: ReusableComponentNodes {
        let s = Self.selectors

        var attrs = HTMLAttribute.class(s.root)

        switch model.variant {
        case .standard:
            break
        case .subtle:
            attrs.merge(.class(s.subtle))
        case .strong:
            attrs.merge(.class(s.strong))
        }

        if let label = model.label, !label.isEmpty {
            attrs.merge(.class(s.labeled))

            return .body(
                [
                    HTML.div(attrs) {
                        HTML.span(.class(s.line)) {}
                        HTML.span(.class(s.label)) {
                            HTML.text(label)
                        }
                        HTML.span(.class(s.line)) {}
                    }
                ],
                stylesheets: [Self.css()]
            )
        }

        return .body(
            [
                HTML.div(attrs) {
                    HTML.span(.class(s.line)) {}
                }
            ],
            stylesheets: [Self.css()]
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public func sheet() -> CSSStyleSheet {
        nodes.stylesheets[0]
    }
}

public extension SectionDivider {
    static func css() -> CSSStyleSheet {
        let s = Self.selectors

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    s.root,
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("margin", "24px 0")
                ),

                CSS.rule(
                    s.line,
                    CSS.decl("display", "block"),
                    CSS.decl("flex", "1 1 auto"),
                    CSS.decl("height", "1px"),
                    CSS.decl("background", "var(--border-color, rgba(15, 23, 42, 0.14))")
                ),

                CSS.rule(
                    s.label,
                    CSS.decl("display", "inline-block"),
                    CSS.decl("flex", "0 0 auto"),
                    CSS.decl("font-size", "0.82rem"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("letter-spacing", "0.05em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))"),
                    CSS.decl("opacity", "0.8")
                ),

                CSS.rule(
                    s.subtle
                        .descendant(s.line),
                    CSS.decl("opacity", "0.55")
                ),

                CSS.rule(
                    s.strong
                        .descendant(s.line),
                    CSS.decl("height", "2px"),
                    CSS.decl("opacity", "0.95")
                )
            ]
        )
    }
}
