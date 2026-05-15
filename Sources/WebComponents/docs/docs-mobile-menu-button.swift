import Constructors
import CSS
import HTML

public struct DocsMobileMenuButton: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-mobile-menu-button"

    public let id: String
    public let targetID: String
    public let ariaLabel: String
    public let className: String
    public let includeStyles: Bool

    public init(
        id: String = "menu-btn",
        targetID: String,
        ariaLabel: String = "Open navigation",
        className: String = "",
        includeStyles: Bool = true
    ) {
        self.id = id
        self.targetID = targetID
        self.ariaLabel = ariaLabel
        self.className = className
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.button(
                    [
                        "id": id,
                        "class": "\(Self.block) \(className)",
                        "type": "button",
                        "aria-controls": targetID,
                        "aria-expanded": "false",
                        "aria-label": ariaLabel,
                        "data-docs-mobile-menu-button": ""
                    ]
                ) {
                    HTML.span(["class": "\(Self.block)__line"]) {}
                    HTML.span(["class": "\(Self.block)__line"]) {}
                    HTML.span(["class": "\(Self.block)__line"]) {}
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "inline-grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "38px"),
                    CSS.decl("height", "34px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("padding", "0"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(block)__line",
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "10px"),
                    CSS.decl("right", "10px"),
                    CSS.decl("height", "1.5px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "currentColor"),
                    CSS.decl("transform-origin", "center"),
                    CSS.decl("transition", "transform 160ms ease, opacity 120ms ease")
                ),

                CSS.rule(
                    ".\(block)__line:nth-child(1)",
                    CSS.decl("transform", "translateY(-6px)")
                ),

                CSS.rule(
                    ".\(block)__line:nth-child(2)",
                    CSS.decl("transform", "translateY(0)")
                ),

                CSS.rule(
                    ".\(block)__line:nth-child(3)",
                    CSS.decl("transform", "translateY(6px)")
                ),

                CSS.rule(
                    ".\(block).open .\(block)__line:nth-child(1), .\(block)[aria-expanded=\"true\"] .\(block)__line:nth-child(1)",
                    CSS.decl("transform", "translateY(0) rotate(45deg)")
                ),

                CSS.rule(
                    ".\(block).open .\(block)__line:nth-child(2), .\(block)[aria-expanded=\"true\"] .\(block)__line:nth-child(2)",
                    CSS.decl("opacity", "0")
                ),

                CSS.rule(
                    ".\(block).open .\(block)__line:nth-child(3), .\(block)[aria-expanded=\"true\"] .\(block)__line:nth-child(3)",
                    CSS.decl("transform", "translateY(0) rotate(-45deg)")
                )
            ]
        )
    }
}
