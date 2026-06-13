import Constructors
import CSS
import HTML

// maybe add a note about:
// vermijding can take place in fight, flight, avoidance

public enum DriveObstacleTarget: String, Sendable, CaseIterable {
    case afstoter
    case aantrekker

    public var title: String {
        switch self {
        case .afstoter:
            return "Afstoter"

        case .aantrekker:
            return "Aantrekker"
        }
    }

    public var statusText: String {
        switch self {
        case .afstoter:
            return "Afstoter geselecteerd: vermijding brengt de hond richting afstand nemen, ook wanneer daar een obstakel tussen ligt."

        case .aantrekker:
            return "Aantrekker geselecteerd: toenadering brengt de hond richting de aantrekker, ook wanneer daar een obstakel tussen ligt."
        }
    }
}

public struct DriveObstacleDiagram: ReusableComponent, Sendable {
    public typealias Target = DriveObstacleTarget

    private enum ClassName {
        static let root = "wc-drive-obstacle-diagram"
        static let stage = "wc-drive-obstacle-diagram__stage"
        static let caption = "wc-drive-obstacle-diagram__caption"

        static let switchRoot = "wc-drive-obstacle-diagram__switch-root"
        static let switchControls = "wc-drive-obstacle-diagram__switch-controls"
        static let switchButton = "wc-drive-obstacle-diagram__switch-button"
        static let switchLive = "wc-drive-obstacle-diagram__switch-live"

        static let svg = "wc-drive-obstacle-diagram__svg"
        static let field = "wc-drive-obstacle-diagram__field"
        static let card = "wc-drive-obstacle-diagram__card"
        static let cardTitle = "wc-drive-obstacle-diagram__card-title"
        static let cardSubtitle = "wc-drive-obstacle-diagram__card-subtitle"

        static let subject = "wc-drive-obstacle-diagram__subject"
        static let subjectDot = "wc-drive-obstacle-diagram__subject-dot"
        static let subjectLabel = "wc-drive-obstacle-diagram__subject-label"

        static let obstacle = "wc-drive-obstacle-diagram__obstacle"
        static let obstacleLabel = "wc-drive-obstacle-diagram__obstacle-label"
        static let obstacleRidge = "wc-drive-obstacle-diagram__obstacle-ridge"

        static let path = "wc-drive-obstacle-diagram__path"
        static let pathActive = "wc-drive-obstacle-diagram__path--active"
        static let markerHead = "wc-drive-obstacle-diagram__marker-head"

        static let routePill = "wc-drive-obstacle-diagram__route-pill"
        static let routePillText = "wc-drive-obstacle-diagram__route-pill-text"
    }

    public let id: String
    public let caption: String?
    public let initial: DriveObstacleTarget
    public let includeStyles: Bool

    public init(
        id: String = "drive-obstacle-diagram",
        caption: String? = "Een hond kan moeite doen om afstand te vergroten tot een afstoter, of om dichterbij een aantrekker te komen.",
        initial: DriveObstacleTarget = .aantrekker,
        includeStyles: Bool = true
    ) {
        self.id = id
        self.caption = caption
        self.initial = initial
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.figure(
                    [
                        "id": id,
                        "class": ClassName.root
                    ]
                ) {
                    HTML.div(
                        [
                            "class": ClassName.switchRoot,
                            "data-drive-obstacle-switch": "true",
                            "data-state": initial.rawValue
                        ]
                    ) {
                        HTML.div(
                            [
                                "class": ClassName.switchControls,
                                "role": "group",
                                "aria-label": "Kies welke drijfveer actief wordt getoond."
                            ]
                        ) {
                            Self.switch_button(
                                .afstoter,
                                active: initial == .afstoter
                            )

                            Self.switch_button(
                                .aantrekker,
                                active: initial == .aantrekker
                            )
                        }

                        HTML.div(
                            [
                                "class": ClassName.stage,
                                "role": "img",
                                "aria-label": "Drijfveren met obstakel: bij een afstoter toont de route vermijding; bij een aantrekker toont de route toenadering."
                            ]
                        ) {
                            Self.svg(
                                markerID: "\(id)-arrowhead"
                            )
                        }

                        HTML.span(
                            [
                                "class": ClassName.switchLive,
                                "data-drive-obstacle-switch-live": "true",
                                "aria-live": "polite"
                            ]
                        ) {
                            HTML.text(initial.statusText)
                        }
                    }

                    HTML.el("script") {
                        HTML.raw(Self.switchScript)
                    }

                    if let caption, !caption.isEmpty {
                        HTML.figcaption(["class": ClassName.caption]) {
                            HTML.text(caption)
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    public func node() -> any HTMLNode {
        nodes.body[0]
    }

    public static func svg(
        markerID: String = "drive-obstacle-arrowhead"
    ) -> any HTMLNode {
        HTML.el(
            "svg",
            [
                "class": ClassName.svg,
                "viewBox": "0 0 760 320",
                "preserveAspectRatio": "xMidYMid meet",
                "role": "img",
                "aria-label": "Afstoter links, aantrekker rechts, hond en obstakel in het midden, met een actieve route voor vermijding of toenadering."
            ]
        ) {
            HTML.el("defs") {
                HTML.el(
                    "marker",
                    [
                        "id": markerID,
                        "viewBox": "0 0 10 10",
                        "refX": "9",
                        "refY": "5",
                        "markerWidth": "7",
                        "markerHeight": "7",
                        "orient": "auto"
                    ]
                ) {
                    HTML.el(
                        "path",
                        [
                            "class": ClassName.markerHead,
                            "d": "M 0 0 L 10 5 L 0 10 z"
                        ]
                    ) {}
                }
            }

            HTML.el(
                "rect",
                [
                    "class": ClassName.field,
                    "x": "18",
                    "y": "18",
                    "width": "724",
                    "height": "284",
                    "rx": "28",
                    "ry": "28"
                ]
            ) {}

            card(
                x: 52,
                y: 52,
                width: 220,
                height: 70,
                title: "Afstoter",
                subtitle: "aversieve prikkel",
                track: .afstoter
            )

            card(
                x: 488,
                y: 52,
                width: 220,
                height: 70,
                title: "Aantrekker",
                subtitle: "appetetieve prikkel",
                track: .aantrekker
            )

            HTML.el(
                "path",
                [
                    "class": "\(ClassName.path) \(ClassName.pathActive)",
                    "data-drive-obstacle-track": DriveObstacleTarget.afstoter.rawValue,
                    "d": "M 272 87 C 308 112, 314 148, 286 176 C 344 224, 434 238, 536 214 C 590 202, 636 184, 678 160",
                    "marker-end": "url(#\(markerID))"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": "\(ClassName.path) \(ClassName.pathActive)",
                    "data-drive-obstacle-track": DriveObstacleTarget.aantrekker.rawValue,
                    "d": "M 286 176 C 334 132, 390 118, 448 104 C 462 100, 474 94, 488 87",
                    "marker-end": "url(#\(markerID))"
                ]
            ) {}

            subject(
                x: 286,
                y: 176
            )

            obstacle(
                x: 372,
                y: 130
            )

            route_pill(
                x: 282,
                y: 118,
                width: 126,
                text: "vermijding",
                track: .afstoter
            )

            route_pill(
                x: 442,
                y: 138,
                width: 132,
                text: "toenadering",
                track: .aantrekker
            )
        }
    }

    private static func card(
        x: Int,
        y: Int,
        width: Int,
        height: Int,
        title: String,
        subtitle: String,
        track: DriveObstacleTarget
    ) -> any HTMLNode {
        HTML.el(
            "g",
            [
                "class": ClassName.card,
                "data-drive-obstacle-track": track.rawValue,
                "transform": "translate(\(x) \(y))"
            ]
        ) {
            HTML.el(
                "rect",
                [
                    "x": "0",
                    "y": "0",
                    "width": "\(width)",
                    "height": "\(height)",
                    "rx": "14",
                    "ry": "14"
                ]
            ) {}

            HTML.el(
                "text",
                [
                    "class": ClassName.cardTitle,
                    "x": "\(width / 2)",
                    "y": "31",
                    "text-anchor": "middle"
                ]
            ) {
                HTML.text(title)
            }

            HTML.el(
                "text",
                [
                    "class": ClassName.cardSubtitle,
                    "x": "\(width / 2)",
                    "y": "52",
                    "text-anchor": "middle"
                ]
            ) {
                HTML.text(subtitle)
            }
        }
    }

    private static func route_pill(
        x: Int,
        y: Int,
        width: Int,
        text: String,
        track: DriveObstacleTarget
    ) -> any HTMLNode {
        HTML.el(
            "g",
            [
                "class": ClassName.routePill,
                "data-drive-obstacle-track": track.rawValue,
                "transform": "translate(\(x) \(y))"
            ]
        ) {
            HTML.el(
                "rect",
                [
                    "x": "0",
                    "y": "0",
                    "width": "\(width)",
                    "height": "34",
                    "rx": "17",
                    "ry": "17"
                ]
            ) {}

            HTML.el(
                "text",
                [
                    "class": ClassName.routePillText,
                    "x": "\(width / 2)",
                    "y": "22",
                    "text-anchor": "middle"
                ]
            ) {
                HTML.text(text)
            }
        }
    }

    private static func subject(
        x: Int,
        y: Int
    ) -> any HTMLNode {
        HTML.el(
            "g",
            [
                "class": ClassName.subject,
                "transform": "translate(\(x) \(y))"
            ]
        ) {
            HTML.el(
                "circle",
                [
                    "class": ClassName.subjectDot,
                    "cx": "0",
                    "cy": "0",
                    "r": "12"
                ]
            ) {}

            HTML.el(
                "text",
                [
                    "class": ClassName.subjectLabel,
                    "x": "0",
                    "y": "32",
                    "text-anchor": "middle"
                ]
            ) {
                HTML.text("hond")
            }
        }
    }

    private static func obstacle(
        x: Int,
        y: Int
    ) -> any HTMLNode {
        HTML.el(
            "g",
            [
                "class": ClassName.obstacle,
                "transform": "translate(\(x) \(y))"
            ]
        ) {
            HTML.el(
                "rect",
                [
                    "x": "0",
                    "y": "0",
                    "width": "58",
                    "height": "92",
                    "rx": "14",
                    "ry": "14"
                ]
            ) {}

            HTML.el(
                "path",
                [
                    "class": ClassName.obstacleRidge,
                    "d": "M 16 18 V 74 M 30 14 V 78 M 44 18 V 74"
                ]
            ) {}

            HTML.el(
                "text",
                [
                    "class": ClassName.obstacleLabel,
                    "x": "29",
                    "y": "112",
                    "text-anchor": "middle"
                ]
            ) {
                HTML.text("obstakel")
            }
        }
    }

    private static func switch_button(
        _ target: DriveObstacleTarget,
        active: Bool
    ) -> any HTMLNode {
        HTML.el(
            "button",
            [
                "type": "button",
                "class": ClassName.switchButton,
                "data-drive-obstacle-option": "true",
                "data-track": target.rawValue,
                "aria-pressed": active ? "true" : "false"
            ]
        ) {
            HTML.text(target.title)
        }
    }

    private static let switchScript = #"""
    (() => {
        if (window.wcDriveObstacleSwitch?.initialized) return;

        const afstoterTrack = 'afstoter';
        const aantrekkerTrack = 'aantrekker';

        function statusText(track) {
            if (track === afstoterTrack) {
                return 'Afstoter geselecteerd: vermijding brengt de hond richting afstand nemen, ook wanneer daar een obstakel tussen ligt.';
            }

            return 'Aantrekker geselecteerd: toenadering brengt de hond richting de aantrekker, ook wanneer daar een obstakel tussen ligt.';
        }

        function setState(root, track) {
            if (!root) return;
            if (track !== afstoterTrack && track !== aantrekkerTrack) return;

            root.setAttribute('data-state', track);

            root.querySelectorAll('[data-drive-obstacle-option]').forEach((option) => {
                const active = option.getAttribute('data-track') === track;
                option.setAttribute('aria-pressed', active ? 'true' : 'false');
            });

            const live = root.querySelector('[data-drive-obstacle-switch-live]');

            if (live) {
                live.textContent = statusText(track);
            }
        }

        function activate(option) {
            const root = option.closest('[data-drive-obstacle-switch]');
            const track = option.getAttribute('data-track');

            setState(root, track);
        }

        document.addEventListener('click', (event) => {
            const option = event.target.closest('[data-drive-obstacle-option]');

            if (!option) return;

            event.preventDefault();
            activate(option);
        });

        document.addEventListener('keydown', (event) => {
            if (event.key !== 'Enter' && event.key !== ' ') return;

            const option = event.target.closest('[data-drive-obstacle-option]');

            if (!option) return;

            event.preventDefault();
            activate(option);
        });

        function init(root = document) {
            root.querySelectorAll('[data-drive-obstacle-switch]').forEach((switchRoot) => {
                setState(
                    switchRoot,
                    switchRoot.getAttribute('data-state') || aantrekkerTrack
                );
            });
        }

        window.wcDriveObstacleSwitch = {
            initialized: true,
            init,
            setState
        };

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => init());
        } else {
            init();
        }
    })();
    """#

    public static func css() -> CSSStyleSheet {
        stylesheet()
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("width", "min(820px, 100%)"),
                    CSS.decl("margin", "24px 0 30px")
                ),

                CSS.rule(
                    ".\(ClassName.switchRoot)",
                    CSS.decl("position", "relative"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".\(ClassName.switchControls)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("width", "fit-content"),
                    CSS.decl("justify-self", "end"),
                    CSS.decl("margin-left", "auto"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("padding", "3px"),
                    CSS.decl("border", "1px solid var(--border-color, rgba(0,0,0,0.12))"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--background-color, #fff) 94%, var(--text-color, #0f172a) 6%)"),
                    CSS.decl("box-shadow", "inset 0 1px 0 rgba(255,255,255,.55)"),
                    CSS.decl("flex", "0 0 auto")
                ),

                CSS.rule(
                    ".\(ClassName.switchButton)",
                    CSS.decl("appearance", "none"),
                    CSS.decl("border", "0"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("height", "30px"),
                    CSS.decl("padding", "0 12px"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("color", "color-mix(in srgb, var(--text-color, #0f172a) 62%, transparent)"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "740"),
                    CSS.decl("line-height", "30px"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("transition", "background 140ms ease, color 140ms ease, box-shadow 140ms ease")
                ),

                CSS.rule(
                    ".\(ClassName.switchButton):hover",
                    CSS.decl("color", "var(--text-color, #0f172a)")
                ),

                CSS.rule(
                    ".\(ClassName.switchButton)[aria-pressed=\"true\"]",
                    CSS.decl("background", "var(--text-color, #0f172a)"),
                    CSS.decl("color", "var(--background-color, #fff)"),
                    CSS.decl("box-shadow", "0 1px 2px rgba(15, 23, 42, .16)")
                ),

                CSS.rule(
                    ".\(ClassName.switchButton):focus-visible",
                    CSS.decl("outline", "2px solid color-mix(in srgb, var(--link-color) 70%, transparent)"),
                    CSS.decl("outline-offset", "2px")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("padding", "12px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, var(--background-color)) 94%, var(--text-color) 6%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(15, 23, 42, .06)"),
                    CSS.decl("overflow", "hidden")
                ),

                CSS.rule(
                    ".\(ClassName.svg)",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "auto"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("color", "var(--text-color, #0f172a)"),
                    CSS.decl("overflow", "visible")
                ),

                CSS.rule(
                    ".\(ClassName.field)",
                    CSS.decl("fill", "color-mix(in srgb, var(--surface-color, var(--background-color)) 88%, var(--text-color) 12%)"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--border-color) 82%, var(--text-color) 18%)"),
                    CSS.decl("stroke-width", "1")
                ),

                CSS.rule(
                    ".\(ClassName.card)",
                    CSS.decl("opacity", ".18"),
                    CSS.decl("transition", "opacity 140ms ease, filter 140ms ease")
                ),

                CSS.rule(
                    ".\(ClassName.switchRoot)[data-state=\"\(DriveObstacleTarget.afstoter.rawValue)\"] .\(ClassName.card)[data-drive-obstacle-track=\"\(DriveObstacleTarget.afstoter.rawValue)\"], .\(ClassName.switchRoot)[data-state=\"\(DriveObstacleTarget.aantrekker.rawValue)\"] .\(ClassName.card)[data-drive-obstacle-track=\"\(DriveObstacleTarget.aantrekker.rawValue)\"]",
                    CSS.decl("opacity", "1")
                ),

                CSS.rule(
                    ".\(ClassName.card) rect",
                    CSS.decl("fill", "var(--background-color, #fff)"),
                    CSS.decl("stroke", "var(--border-color, rgba(0,0,0,0.12))"),
                    CSS.decl("stroke-width", "1.2"),
                    CSS.decl("filter", "drop-shadow(0 10px 18px rgba(15, 23, 42, .06))")
                ),

                CSS.rule(
                    ".\(ClassName.cardTitle)",
                    CSS.decl("font-size", "21px"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("letter-spacing", ".01em"),
                    CSS.decl("fill", "var(--text-color, #0f172a)")
                ),

                CSS.rule(
                    ".\(ClassName.cardSubtitle)",
                    CSS.decl("font-size", "13px"),
                    CSS.decl("font-weight", "520"),
                    CSS.decl("fill", "color-mix(in srgb, var(--text-color, #0f172a) 68%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.subjectDot)",
                    CSS.decl("fill", "var(--text-color, #0f172a)"),
                    CSS.decl("filter", "drop-shadow(0 8px 14px rgba(15, 23, 42, .16))")
                ),

                CSS.rule(
                    ".\(ClassName.subjectLabel)",
                    CSS.decl("font-size", "12px"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".04em"),
                    CSS.decl("fill", "color-mix(in srgb, var(--text-color, #0f172a) 64%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.obstacle) rect",
                    CSS.decl("fill", "color-mix(in srgb, var(--background-color, #fff) 78%, var(--text-color) 22%)"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 28%, var(--border-color))"),
                    CSS.decl("stroke-width", "1.2"),
                    CSS.decl("filter", "drop-shadow(0 9px 16px rgba(15, 23, 42, .08))")
                ),

                CSS.rule(
                    ".\(ClassName.obstacleRidge)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "color-mix(in srgb, var(--text-color) 34%, transparent)"),
                    CSS.decl("stroke-width", "2"),
                    CSS.decl("stroke-linecap", "round")
                ),

                CSS.rule(
                    ".\(ClassName.obstacleLabel)",
                    CSS.decl("font-size", "11px"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".03em"),
                    CSS.decl("fill", "color-mix(in srgb, var(--text-color, #0f172a) 66%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.path)",
                    CSS.decl("fill", "none"),
                    CSS.decl("stroke", "var(--flow-arrow-color, var(--text-color, #0f172a))"),
                    CSS.decl("stroke-linecap", "round"),
                    CSS.decl("stroke-linejoin", "round")
                ),

                CSS.rule(
                    ".\(ClassName.pathActive)",
                    CSS.decl("display", "none"),
                    CSS.decl("stroke-width", "3"),
                    CSS.decl("stroke-dasharray", "10 8"),
                    CSS.decl("stroke-dashoffset", "0"),
                    CSS.decl("opacity", ".92")
                ),

                CSS.rule(
                    ".\(ClassName.markerHead)",
                    CSS.decl("fill", "var(--flow-arrow-color, var(--text-color, #0f172a))")
                ),

                CSS.rule(
                    ".\(ClassName.routePill)",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(ClassName.routePill) rect",
                    CSS.decl("fill", "color-mix(in srgb, var(--background-color, #fff) 86%, var(--text-color) 14%)"),
                    CSS.decl("stroke", "var(--border-color, rgba(0,0,0,0.12))"),
                    CSS.decl("stroke-width", "1"),
                    CSS.decl("filter", "drop-shadow(0 8px 16px rgba(15, 23, 42, .07))")
                ),

                CSS.rule(
                    ".\(ClassName.routePillText)",
                    CSS.decl("font-size", "12px"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("fill", "var(--text-color, #0f172a)")
                ),

                CSS.rule(
                    ".\(ClassName.switchRoot)[data-state=\"\(DriveObstacleTarget.afstoter.rawValue)\"] .\(ClassName.pathActive)[data-drive-obstacle-track=\"\(DriveObstacleTarget.afstoter.rawValue)\"], .\(ClassName.switchRoot)[data-state=\"\(DriveObstacleTarget.aantrekker.rawValue)\"] .\(ClassName.pathActive)[data-drive-obstacle-track=\"\(DriveObstacleTarget.aantrekker.rawValue)\"]",
                    CSS.decl("display", "inline"),
                    CSS.decl("animation", "wc-drive-obstacle-flow 900ms linear infinite")
                ),

                CSS.rule(
                    ".\(ClassName.switchRoot)[data-state=\"\(DriveObstacleTarget.afstoter.rawValue)\"] .\(ClassName.routePill)[data-drive-obstacle-track=\"\(DriveObstacleTarget.afstoter.rawValue)\"], .\(ClassName.switchRoot)[data-state=\"\(DriveObstacleTarget.aantrekker.rawValue)\"] .\(ClassName.routePill)[data-drive-obstacle-track=\"\(DriveObstacleTarget.aantrekker.rawValue)\"]",
                    CSS.decl("display", "inline")
                ),

                CSS.rule(
                    ".\(ClassName.switchLive)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("width", "1px"),
                    CSS.decl("height", "1px"),
                    CSS.decl("padding", "0"),
                    CSS.decl("margin", "-1px"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("clip", "rect(0, 0, 0, 0)"),
                    CSS.decl("white-space", "nowrap"),
                    CSS.decl("border", "0")
                ),

                CSS.rule(
                    ".\(ClassName.caption)",
                    CSS.decl("margin", "10px 0 0"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.48"),
                    CSS.decl("color", "var(--muted-text-color)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(ClassName.stage)",
                        CSS.decl("padding", "8px"),
                        CSS.decl("border-radius", "14px"),
                        CSS.decl("overflow-x", "auto"),
                        CSS.decl("overflow-y", "hidden"),
                        CSS.decl("scrollbar-width", "thin"),
                        CSS.decl("-webkit-overflow-scrolling", "touch"),
                        CSS.decl("overscroll-behavior-x", "contain")
                    ),

                    CSS.rule(
                        ".\(ClassName.svg)",
                        CSS.decl("width", "760px"),
                        CSS.decl("min-width", "760px"),
                        CSS.decl("max-width", "none"),
                        CSS.decl("height", "auto")
                    ),

                    CSS.rule(
                        ".\(ClassName.switchControls)",
                        CSS.decl("gap", "6px")
                    ),

                    CSS.rule(
                        ".\(ClassName.switchButton)",
                        CSS.decl("height", "28px"),
                        CSS.decl("padding", "0 10px"),
                        CSS.decl("font-size", ".8rem"),
                        CSS.decl("line-height", "28px")
                    )
                ),

                CSS.media(
                    "(prefers-reduced-motion: reduce)",
                    CSS.rule(
                        ".\(ClassName.pathActive)",
                        CSS.decl("animation", "none")
                    )
                )
            ],
            keyframes: [
                CSS.keyframes("wc-drive-obstacle-flow") {
                    CSS.to {
                        CSS.decl("stroke-dashoffset", "-18")
                    }
                }
            ]
        )
    }
}
