import DSL
import Constructors
import CSS
import HTML

public enum ClassicalFlowBox: String, Sendable, CaseIterable {
    case stimulus
    case consequence
}

public struct ClassicalConditioningDiagram: ReusableComponent, Sendable {
    public typealias FlowBox = ClassicalFlowBox

    private enum ClassName {
        static let root = "wc-classical-conditioning-diagram"
        static let stage = "wc-classical-conditioning-diagram__stage"
        static let flow = "wc-classical-conditioning-diagram__flow"
        static let flowFigure = "wc-classical-conditioning-diagram__flow-figure"
        static let caption = "wc-classical-conditioning-diagram__caption"

        static let flowBox = "wc-classical-conditioning-diagram__flow-box"
        static let flowBoxStimulus = "wc-classical-conditioning-diagram__flow-box--stimulus"
        static let flowBoxConsequence = "wc-classical-conditioning-diagram__flow-box--consequence"
        static let highlighted = "wc-classical-conditioning-diagram__flow-box--highlighted"
    }

    public let id: String
    public let caption: String?
    public let highlighted: ClassicalFlowBox?
    public let includeStyles: Bool

    public init(
        id: String = "classical-conditioning-diagram",
        caption: String? = "Klassieke conditionering: een prikkel krijgt betekenis door het gevolg dat deze voorspelt.",
        highlighted: ClassicalFlowBox? = nil,
        includeStyles: Bool = true
    ) {
        self.id = id
        self.caption = caption
        self.highlighted = highlighted
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                Self.flow_node(
                    id: id,
                    caption: caption,
                    highlighted: highlighted
                )
            ],
            stylesheets: includeStyles
                ? [
                    FlowDiagram.css(),
                    Self.stylesheet()
                ]
                : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public static func flow(
        highlighted: ClassicalFlowBox? = nil
    ) -> FlowDiagram {
        FlowDiagram(
            axis: .row,
            classes: [
                .raw(ClassName.flow)
            ],
            items: [
                .box(
                    flow_box(
                        kind: .stimulus,
                        highlighted: highlighted
                    ) {
                        [
                            HTML.b { HTML.text("Prikkel") },
                            HTML.span { HTML.text("situatie / signaal") }
                        ]
                    }
                ),

                .arrow(
                    .init(
                        label: "voorspelt"
                    )
                ),

                .box(
                    flow_box(
                        kind: .consequence,
                        highlighted: highlighted
                    ) {
                        [
                            HTML.b { HTML.text("Gevolg") },
                            HTML.span { HTML.text("wat erop volgt") }
                        ]
                    }
                )
            ]
        )
    }

    public static func flow_node(
        id: String = "classical-conditioning-flow",
        caption: String? = nil,
        highlighted: ClassicalFlowBox? = nil
    ) -> any HTMLNode {
        figure(
            id: id,
            className: "\(ClassName.root) \(ClassName.flowFigure)",
            roleLabel: "Klassieke conditionering: prikkel voorspelt gevolg.",
            caption: caption
        ) {
            [
                flow(
                    highlighted: highlighted
                ).nodes.body[0]
            ]
        }
    }

    public static func css() -> CSSStyleSheet {
        stylesheet()
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("width", "min(760px, 100%)"),
                    CSS.decl("margin", "24px 0 30px")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("padding", "18px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)"),
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".\(ClassName.root), .\(ClassName.stage)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("max-width", "100%")
                ),

                CSS.rule(
                    ".\(ClassName.flow).wc-flow, .\(ClassName.flow) .wc-flow",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("margin", "0"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("width", "100%")
                ),

                CSS.rule(
                    ".\(ClassName.flow).wc-flow--row, .\(ClassName.flow) .wc-flow--row",
                    CSS.decl("flex-wrap", "nowrap"),
                    CSS.decl("align-items", "stretch")
                ),

                CSS.rule(
                    ".\(ClassName.flow).wc-flow .wc-flow__box, .\(ClassName.flow) .wc-flow__box",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("flex", "1 1 0")
                ),

                CSS.rule(
                    ".\(ClassName.flow).wc-flow .wc-flow__box-inner, .\(ClassName.flow) .wc-flow__box-inner",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("max-width", "100%")
                ),

                CSS.rule(
                    ".\(ClassName.flow).wc-flow .wc-flow__arrow-wrap, .\(ClassName.flow) .wc-flow__arrow-wrap",
                    CSS.decl("flex", "0 0 64px")
                ),

                CSS.rule(
                    ".\(ClassName.flowBox)",
                    CSS.decl("position", "relative")
                ),

                CSS.rule(
                    ".\(ClassName.flowBoxStimulus)",
                    CSS.decl("border-color", "color-mix(in srgb, var(--text-color) 22%, var(--border-color))")
                ),

                CSS.rule(
                    ".\(ClassName.flowBoxConsequence)",
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 34%, var(--border-color))")
                ),

                CSS.rule(
                    ".\(ClassName.highlighted)",
                    CSS.decl("background", "color-mix(in srgb, var(--link-color) 10%, var(--surface-color, #fff))"),
                    CSS.decl("border-color", "color-mix(in srgb, var(--link-color) 38%, var(--border-color))"),
                    CSS.decl("box-shadow", "0 18px 44px color-mix(in srgb, var(--link-color) 15%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.caption)",
                    CSS.decl("margin-top", "10px"),
                    CSS.decl("font-size", "0.95rem"),
                    CSS.decl("color", "var(--ref-meta-text-color, var(--text-color, #0f172a))")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".\(ClassName.stage)",
                        CSS.decl("padding", "14px")
                    ),
                    CSS.rule(
                        ".\(ClassName.flow).wc-flow .wc-flow__arrow-wrap, .\(ClassName.flow) .wc-flow__arrow-wrap",
                        CSS.decl("flex-basis", "40px")
                    )
                )
            ]
        )
    }

    private static func flow_box(
        kind: ClassicalFlowBox,
        highlighted: ClassicalFlowBox?,
        content: @escaping @Sendable () -> HTMLFragment
    ) -> Box {
        var classes: [HTMLClassToken] = [
            .raw(ClassName.flowBox),
            .raw(flow_box_class(kind))
        ]

        if highlighted == kind {
            classes.append(
                .raw(ClassName.highlighted)
            )
        }

        return Box(
            classes: classes,
            content: content
        )
    }

    private static func flow_box_class(
        _ kind: ClassicalFlowBox
    ) -> String {
        switch kind {
        case .stimulus:
            return ClassName.flowBoxStimulus

        case .consequence:
            return ClassName.flowBoxConsequence
        }
    }

    private static func figure(
        id: String,
        className: String,
        roleLabel: String,
        caption: String?,
        body: @escaping @Sendable () -> HTMLFragment
    ) -> any HTMLNode {
        HTML.figure(
            [
                "id": id,
                "class": className
            ]
        ) {
            HTML.div(
                [
                    "class": ClassName.stage,
                    "role": "img",
                    "aria-label": roleLabel
                ]
            ) {
                body()
            }

            if let caption, !caption.isEmpty {
                HTML.figcaption(["class": ClassName.caption]) {
                    HTML.text(caption)
                }
            }
        }
    }
}
