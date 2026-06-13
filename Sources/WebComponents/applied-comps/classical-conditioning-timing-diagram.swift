import Constructors
import CSS
import HTML

public enum ClassicalConditioningTimingArrangement: String, Sendable, CaseIterable {
    case delay
    case trace
    case simultaneous
    case backward

    public static let defaultOrder: [Self] = [
        .delay,
        .trace,
        .simultaneous,
        .backward
    ]

    var title: String {
        switch self {
        case .delay:
            return "Delay"
        case .trace:
            return "Trace"
        case .simultaneous:
            return "Simultaneous"
        case .backward:
            return "Backward"
        }
    }

    var dutchLabel: String {
        switch self {
        case .delay:
            return "vertraagde koppeling"
        case .trace:
            return "spoor-koppeling"
        case .simultaneous:
            return "gelijktijdig"
        case .backward:
            return "achterwaarts"
        }
    }

    var effectiveness: String {
        switch self {
        case .delay:
            return "sterk"
        case .trace:
            return "sterk"
        case .simultaneous:
            return "zwak"
        case .backward:
            return "minst effectief"
        }
    }

    var predictivePower: ClassicalConditioningPredictivePower {
        switch self {
        case .delay, .trace:
            return .strong
        case .simultaneous:
            return .weak
        case .backward:
            return .ineffective
        }
    }

    var note: String {
        switch self {
        case .delay:
            return "Prikkel start eerst; gevolg valt binnen de prikkel."
        case .trace:
            return "Prikkel eindigt kort voordat het gevolg begint."
        case .simultaneous:
            return "Prikkel en gevolg vallen samen; overschaduwing (overstemming) wordt waarschijnlijk."
        case .backward:
            return "Gevolg komt vóór de prikkel; de prikkel verliest diens voorspellende rol (informatief vermogen)."
        }
    }

    var stimulusInterval: ClassicalConditioningTimingDiagram.TimelineInterval {
        switch self {
        case .delay:
            return .init(start: 12, end: 64)
        case .trace:
            return .init(start: 14, end: 34)
        case .simultaneous:
            return .init(start: 42, end: 62)
        case .backward:
            return .init(start: 68, end: 86)
        }
    }

    var consequenceInterval: ClassicalConditioningTimingDiagram.TimelineInterval {
        switch self {
        case .delay:
            return .init(start: 42, end: 64)
        case .trace:
            return .init(start: 46, end: 68)
        case .simultaneous:
            return .init(start: 42, end: 62)
        case .backward:
            return .init(start: 42, end: 64)
        }
    }
}

public enum ClassicalConditioningPredictivePower: String, Sendable {
    case strong
    case weak
    case ineffective

    var percentage: Int {
        switch self {
        case .strong:
            return 100
        case .weak:
            return 30
        case .ineffective:
            return 10
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .strong:
            return "sterk voorspellend vermogen"
        case .weak:
            return "zwak voorspellend vermogen"
        case .ineffective:
            return "nauwelijks voorspellend vermogen"
        }
    }
}

public struct ClassicalConditioningTimingDiagram: ReusableComponent, Sendable {
    public struct TimelineInterval: Sendable {
        public let start: Int
        public let end: Int

        public init(
            start: Int,
            end: Int
        ) {
            self.start = max(0, min(100, start))
            self.end = max(0, min(100, end))
        }
    }

    private enum SignalKind: String, Sendable {
        case stimulus
        case consequence

        var laneLabel: String {
            switch self {
            case .stimulus:
                return "Prikkel"
            case .consequence:
                return "Gevolg"
            }
        }

        var sourceLabel: String {
            switch self {
            case .stimulus:
                return "CS"
            case .consequence:
                return "US"
            }
        }
    }

    private enum ClassName {
        static let root = "wc-classical-timing"
        static let stage = "wc-classical-timing__stage"
        static let controlInput = "wc-classical-timing__control-input"
        static let control = "wc-classical-timing__control"
        static let controlIcon = "wc-classical-timing__control-icon"
        static let playIcon = "wc-classical-timing__control-icon--play"
        static let stopIcon = "wc-classical-timing__control-icon--stop"
        static let header = "wc-classical-timing__header"
        static let eyebrow = "wc-classical-timing__eyebrow"
        static let title = "wc-classical-timing__title"
        static let lead = "wc-classical-timing__lead"
        static let viewport = "wc-classical-timing__viewport"
        static let chart = "wc-classical-timing__chart"
        static let rows = "wc-classical-timing__rows"
        static let arrangement = "wc-classical-timing__arrangement"
        static let meta = "wc-classical-timing__meta"
        static let arrangementTitle = "wc-classical-timing__arrangement-title"
        static let arrangementSubtitle = "wc-classical-timing__arrangement-subtitle"
        static let effectiveness = "wc-classical-timing__effectiveness"
        static let plot = "wc-classical-timing__plot"
        static let lane = "wc-classical-timing__lane"
        static let laneLabel = "wc-classical-timing__lane-label"
        static let laneSource = "wc-classical-timing__lane-source"
        static let rail = "wc-classical-timing__rail"
        static let block = "wc-classical-timing__block"
        static let blockText = "wc-classical-timing__block-text"
        static let predictive = "wc-classical-timing__predictive"
        static let predictiveMeter = "wc-classical-timing__predictive-meter"
        static let predictiveFill = "wc-classical-timing__predictive-fill"
        static let markerLayer = "wc-classical-timing__marker-layer"
        static let marker = "wc-classical-timing__marker"
        static let timeline = "wc-classical-timing__timeline"
        static let timelineLabel = "wc-classical-timing__timeline-label"
        static let timelineTrack = "wc-classical-timing__timeline-track"
        static let timelineDot = "wc-classical-timing__timeline-dot"
        static let notes = "wc-classical-timing__notes"
        static let note = "wc-classical-timing__note"
        static let noteLabel = "wc-classical-timing__note-label"
        static let noteBody = "wc-classical-timing__note-body"
        static let caption = "wc-classical-timing__caption"
    }

    public let id: String
    public let included: Set<ClassicalConditioningTimingArrangement>
    public let caption: String?
    public let includeStyles: Bool

    public init(
        id: String = "classical-conditioning-timing-diagram",
        included: Set<ClassicalConditioningTimingArrangement> = Set(ClassicalConditioningTimingArrangement.defaultOrder),
        caption: String? = "De timing tussen prikkel (CS) en gevolg (US) bepaalt hoe makkelijk de prikkel voorspellende betekenis krijgt.",
        includeStyles: Bool = true
    ) {
        self.id = id
        self.included = included
        self.caption = caption
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                Self.figure_node(
                    id: id,
                    included: included,
                    caption: caption
                )
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    public static func figure_node(
        id: String = "classical-conditioning-timing-diagram",
        included: Set<ClassicalConditioningTimingArrangement> = Set(ClassicalConditioningTimingArrangement.defaultOrder),
        caption: String? = nil
    ) -> any HTMLNode {
        let arrangements = orderedArrangements(from: included)

        return HTML.figure(
            [
                "id": id,
                "class": ClassName.root
            ]
        ) {
            HTML.div(
                [
                    "class": ClassName.stage,
                    "role": "group",
                    "aria-label": "Tijdlijn voor klassieke conditionering: delay en trace zijn het sterkst, simultaneous is zwakker door overschaduwing, backward is het minst effectief."
                ]
            ) {
                motionToggleInput(id: id)
                motionToggleControl(id: id)
                header()

                HTML.div([ "class": ClassName.viewport ]) {
                    HTML.div([ "class": ClassName.chart ]) {
                        HTML.div([ "class": ClassName.rows ]) {
                            for arrangement in arrangements {
                                arrangementRow(arrangement)
                            }
                        }

                        HTML.div([ "class": ClassName.markerLayer, "aria-hidden": "true" ]) {
                            HTML.div([ "class": ClassName.marker ]) {}
                        }
                    }

                    timeline()
                }

                notes(arrangements)
            }

            if let caption, !caption.isEmpty {
                HTML.figcaption([ "class": ClassName.caption ]) {
                    HTML.text(caption)
                }
            }
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
                    CSS.decl("width", "min(940px, 100%)"),
                    CSS.decl("margin", "2rem auto"),
                    CSS.decl("--wc-classical-timing-meta-col", "clamp(112px, 19vw, 158px)"),
                    CSS.decl("--wc-classical-timing-lane-col", "clamp(76px, 13vw, 104px)"),
                    CSS.decl("--wc-classical-timing-predictive-col", "34px"),
                    CSS.decl("--wc-classical-timing-gap", "12px"),
                    CSS.decl("--wc-classical-timing-duration", "3.8s"),
                    CSS.decl("--wc-classical-timing-ink", "var(--text-color, #17202a)"),
                    CSS.decl("--wc-classical-timing-muted", "var(--text-muted, #5f6b76)"),
                    CSS.decl("--wc-classical-timing-border", "var(--border-color, rgba(23, 32, 42, .16))"),
                    CSS.decl("--wc-classical-timing-surface", "var(--card-bg, rgba(255, 255, 255, .76))")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.root)",
                    CSS.decl("--wc-classical-timing-ink", "var(--text-color, #f4f4f5)"),
                    CSS.decl("--wc-classical-timing-muted", "var(--muted-text-color, rgba(244, 244, 245, .68))"),
                    CSS.decl("--wc-classical-timing-border", "var(--border-color, rgba(255, 255, 255, .13))"),
                    CSS.decl("--wc-classical-timing-surface", "var(--surface-color, #1b1c1f)")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.stage)",
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #1b1c1f) 96%, var(--text-color, #f4f4f5) 4%)"),
                    CSS.decl("box-shadow", "0 18px 40px rgba(0, 0, 0, .28)")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.rail)::before",
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-timing-ink) 18%, transparent)")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.timelineTrack)::before",
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-timing-ink) 13%, transparent)")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.block)",
                    CSS.decl("border-color", "color-mix(in srgb, var(--wc-classical-timing-ink) 22%, transparent)"),
                    CSS.decl("box-shadow", "0 4px 14px rgba(0, 0, 0, .18)")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.block)--stimulus",
                    CSS.decl("background", "repeating-linear-gradient(135deg, color-mix(in srgb, var(--wc-classical-timing-ink) 16%, transparent), color-mix(in srgb, var(--wc-classical-timing-ink) 16%, transparent) 2px, color-mix(in srgb, var(--surface-color, #1b1c1f) 90%, var(--wc-classical-timing-ink) 10%) 2px, color-mix(in srgb, var(--surface-color, #1b1c1f) 90%, var(--wc-classical-timing-ink) 10%) 6px)")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.block)--consequence",
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #1b1c1f) 72%, var(--wc-classical-timing-ink) 28%)")
                ),

                CSS.rule(
                    ".dark-mode .\(ClassName.predictiveMeter)",
                    CSS.decl("border-color", "color-mix(in srgb, var(--wc-classical-timing-ink) 18%, transparent)"),
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #1b1c1f) 86%, var(--wc-classical-timing-ink) 8%)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px rgba(255, 255, 255, .04)")
                ),

                CSS.rule(
                    ".\(ClassName.stage)",
                    CSS.decl("position", "relative"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("padding", "clamp(16px, 3vw, 24px)"),
                    CSS.decl("border", "1px solid var(--wc-classical-timing-border)"),
                    CSS.decl("border-radius", "22px"),
                    CSS.decl("background", "linear-gradient(180deg, var(--wc-classical-timing-surface), color-mix(in srgb, var(--wc-classical-timing-surface) 76%, transparent))"),
                    CSS.decl("box-shadow", "0 18px 48px rgba(15, 23, 42, .08)")
                ),

                CSS.rule(
                    ".\(ClassName.controlInput)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("width", "1px"),
                    CSS.decl("height", "1px"),
                    CSS.decl("margin", "-1px"),
                    CSS.decl("padding", "0"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("clip", "rect(0 0 0 0)"),
                    CSS.decl("white-space", "nowrap"),
                    CSS.decl("border", "0")
                ),

                CSS.rule(
                    ".\(ClassName.control)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("top", "clamp(16px, 3vw, 24px)"),
                    CSS.decl("right", "clamp(16px, 3vw, 24px)"),
                    CSS.decl("z-index", "4"),
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "32px"),
                    CSS.decl("height", "32px"),
                    CSS.decl("padding", "0"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--wc-classical-timing-muted) 30%, transparent)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-timing-muted) 6%, transparent)"),
                    CSS.decl("color", "color-mix(in srgb, var(--wc-classical-timing-muted) 82%, var(--wc-classical-timing-ink) 18%)"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("opacity", ".78"),
                    CSS.decl("transition", "opacity .14s ease, color .14s ease, transform .14s ease, border-color .14s ease, background-color .14s ease")
                ),

                CSS.rule(
                    ".\(ClassName.control):hover",
                    CSS.decl("opacity", "1"),
                    CSS.decl("color", "var(--wc-classical-timing-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.control):active",
                    CSS.decl("transform", "scale(.94)")
                ),

                CSS.rule(
                    ".\(ClassName.controlInput):focus-visible + .\(ClassName.control)",
                    CSS.decl("outline", "2px solid color-mix(in srgb, var(--accent, #0081F8) 72%, transparent)"),
                    CSS.decl("outline-offset", "4px"),
                    CSS.decl("border-radius", "8px")
                ),

                CSS.rule(
                    ".\(ClassName.controlIcon)",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "18px"),
                    CSS.decl("height", "18px"),
                    CSS.decl("line-height", "0")
                ),

                CSS.rule(
                    ".\(ClassName.controlIcon) svg",
                    CSS.decl("display", "block"),
                    CSS.decl("width", "100%"),
                    CSS.decl("height", "100%"),
                    CSS.decl("fill", "currentColor")
                ),

                CSS.rule(
                    ".\(ClassName.playIcon)",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(ClassName.controlInput):checked + .\(ClassName.control) .\(ClassName.playIcon)",
                    CSS.decl("display", "block")
                ),

                CSS.rule(
                    ".\(ClassName.controlInput):checked + .\(ClassName.control) .\(ClassName.stopIcon)",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(ClassName.controlInput):checked ~ .\(ClassName.viewport) .\(ClassName.marker), .\(ClassName.controlInput):checked ~ .\(ClassName.viewport) .\(ClassName.timelineDot)",
                    CSS.decl("animation-play-state", "paused")
                ),

                CSS.rule(
                    ".\(ClassName.header)",
                    CSS.decl("max-width", "720px"),
                    CSS.decl("padding-right", "44px"),
                    CSS.decl("margin-bottom", "18px")
                ),

                CSS.rule(
                    ".\(ClassName.eyebrow)",
                    CSS.decl("margin", "0 0 6px"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("letter-spacing", ".08em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--wc-classical-timing-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.title)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "clamp(1.15rem, 2.2vw, 1.45rem)"),
                    CSS.decl("line-height", "1.15"),
                    CSS.decl("color", "var(--wc-classical-timing-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.lead)",
                    CSS.decl("margin", "8px 0 0"),
                    CSS.decl("color", "var(--wc-classical-timing-muted)"),
                    CSS.decl("font-size", ".95rem"),
                    CSS.decl("line-height", "1.5")
                ),

                CSS.rule(
                    ".\(ClassName.viewport)",
                    CSS.decl("position", "relative"),
                    CSS.decl("width", "100%"),
                    CSS.decl("max-width", "100%"),
                    CSS.decl("overflow-x", "auto"),
                    CSS.decl("overflow-y", "hidden"),
                    CSS.decl("-webkit-overflow-scrolling", "touch"),
                    CSS.decl("scrollbar-width", "thin"),
                    CSS.decl("padding-bottom", "4px")
                ),

                CSS.rule(
                    ".\(ClassName.viewport) > .\(ClassName.chart), .\(ClassName.viewport) > .\(ClassName.timeline)",
                    CSS.decl("min-width", "660px")
                ),

                CSS.rule(
                    ".\(ClassName.chart)",
                    CSS.decl("position", "relative")
                ),

                CSS.rule(
                    ".\(ClassName.rows)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "14px")
                ),

                CSS.rule(
                    ".\(ClassName.arrangement)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "var(--wc-classical-timing-meta-col) minmax(0, 1fr) var(--wc-classical-timing-predictive-col)"),
                    CSS.decl("column-gap", "var(--wc-classical-timing-gap)"),
                    CSS.decl("align-items", "stretch")
                ),

                CSS.rule(
                    ".\(ClassName.meta)",
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-direction", "column"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(ClassName.arrangementTitle)",
                    CSS.decl("font-weight", "800"),
                    CSS.decl("color", "var(--wc-classical-timing-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.arrangementSubtitle)",
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("color", "var(--wc-classical-timing-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.effectiveness)",
                    CSS.decl("width", "fit-content"),
                    CSS.decl("margin-top", "4px"),
                    CSS.decl("padding", "3px 8px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--wc-classical-timing-border) 72%, transparent)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("color", "var(--wc-classical-timing-muted)"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-timing-surface) 82%, var(--wc-classical-timing-ink) 4%)")
                ),

                CSS.rule(
                    ".\(ClassName.plot)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("padding", "10px 0")
                ),

                CSS.rule(
                    ".\(ClassName.lane)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "var(--wc-classical-timing-lane-col) minmax(0, 1fr)"),
                    CSS.decl("column-gap", "var(--wc-classical-timing-gap)"),
                    CSS.decl("align-items", "center")
                ),

                CSS.rule(
                    ".\(ClassName.laneLabel)",
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("color", "var(--wc-classical-timing-ink)")
                ),

                CSS.rule(
                    ".\(ClassName.laneSource)",
                    CSS.decl("margin-left", "4px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("color", "var(--wc-classical-timing-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.rail)",
                    CSS.decl("position", "relative"),
                    CSS.decl("height", "28px")
                ),

                CSS.rule(
                    ".\(ClassName.rail)::before",
                    CSS.decl("content", "''"),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "0"),
                    CSS.decl("right", "0"),
                    CSS.decl("top", "50%"),
                    CSS.decl("height", "2px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-timing-ink) 38%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.block)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "var(--event-start)"),
                    CSS.decl("top", "50%"),
                    CSS.decl("width", "calc(var(--event-end) - var(--event-start))"),
                    CSS.decl("height", "18px"),
                    CSS.decl("transform", "translateY(-50%)"),
                    CSS.decl("border-radius", "5px"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--wc-classical-timing-ink) 34%, transparent)"),
                    CSS.decl("box-shadow", "0 4px 14px rgba(15, 23, 42, .10)")
                ),

                CSS.rule(
                    ".\(ClassName.block)--stimulus",
                    CSS.decl("background", "repeating-linear-gradient(135deg, color-mix(in srgb, var(--wc-classical-timing-ink) 13%, transparent), color-mix(in srgb, var(--wc-classical-timing-ink) 13%, transparent) 2px, color-mix(in srgb, var(--wc-classical-timing-surface) 92%, var(--wc-classical-timing-ink) 7%) 2px, color-mix(in srgb, var(--wc-classical-timing-surface) 92%, var(--wc-classical-timing-ink) 7%) 6px)")
                ),

                CSS.rule(
                    ".\(ClassName.block)--consequence",
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-timing-ink) 86%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.blockText)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("inset", "0"),
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("padding", "0 4px"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("white-space", "nowrap"),
                    CSS.decl("text-overflow", "ellipsis"),
                    CSS.decl("font-size", ".58rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("letter-spacing", ".02em"),
                    CSS.decl("color", "rgba(255,255,255,.88)")
                ),

                CSS.rule(
                    ".\(ClassName.block)--stimulus .\(ClassName.blockText)",
                    CSS.decl("color", "color-mix(in srgb, var(--wc-classical-timing-ink) 80%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.predictive)",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("min-width", "var(--wc-classical-timing-predictive-col)"),
                    CSS.decl("padding", "10px 0")
                ),

                CSS.rule(
                    ".\(ClassName.predictiveMeter)",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "flex-end"),
                    CSS.decl("justify-content", "stretch"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("width", "14px"),
                    CSS.decl("height", "58px"),
                    CSS.decl("padding", "3px"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("border", "1px solid color-mix(in srgb, var(--wc-classical-timing-ink) 18%, transparent)"),
                    CSS.decl("border-radius", "7px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-timing-ink) 7%, transparent)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px color-mix(in srgb, var(--wc-classical-timing-surface) 70%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.predictiveFill)",
                    CSS.decl("width", "100%"),
                    CSS.decl("min-height", "7px"),
                    CSS.decl("height", "var(--predictive-power)"),
                    CSS.decl("border-radius", "4px"),
                    CSS.decl("background", "color-mix(in srgb, var(--success, #2E8B57) 58%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.predictive)--weak .\(ClassName.predictiveFill)",
                    CSS.decl("background", "color-mix(in srgb, var(--warning, #E7A94E) 72%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.predictive)--ineffective .\(ClassName.predictiveFill)",
                    CSS.decl("background", "color-mix(in srgb, var(--danger, #D64545) 72%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.markerLayer)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("top", "0"),
                    CSS.decl("bottom", "0"),
                    CSS.decl("left", "calc(var(--wc-classical-timing-meta-col) + var(--wc-classical-timing-gap) + var(--wc-classical-timing-lane-col) + var(--wc-classical-timing-gap))"),
                    CSS.decl("right", "calc(var(--wc-classical-timing-predictive-col) + var(--wc-classical-timing-gap))"),
                    CSS.decl("pointer-events", "none")
                ),

                CSS.rule(
                    ".\(ClassName.marker)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("top", "0"),
                    CSS.decl("bottom", "0"),
                    CSS.decl("left", "0"),
                    CSS.decl("width", "2px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--accent, #0081F8) 70%, var(--wc-classical-timing-ink) 20%)"),
                    CSS.decl("opacity", ".82"),
                    CSS.decl("animation", "wc-classical-timing-sweep var(--wc-classical-timing-duration) linear infinite")
                ),

                CSS.rule(
                    ".\(ClassName.timeline)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "var(--wc-classical-timing-meta-col) var(--wc-classical-timing-lane-col) minmax(0, 1fr) var(--wc-classical-timing-predictive-col)"),
                    CSS.decl("column-gap", "var(--wc-classical-timing-gap)"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("margin-top", "18px")
                ),

                CSS.rule(
                    ".\(ClassName.timelineLabel)",
                    CSS.decl("grid-column", "1 / span 2"),
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("letter-spacing", ".07em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "var(--wc-classical-timing-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.timelineTrack)",
                    CSS.decl("position", "relative"),
                    CSS.decl("height", "34px")
                ),

                CSS.rule(
                    ".\(ClassName.timelineTrack)::before",
                    CSS.decl("content", "''"),
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "0"),
                    CSS.decl("right", "0"),
                    CSS.decl("top", "50%"),
                    CSS.decl("height", "3px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "color-mix(in srgb, var(--wc-classical-timing-ink) 16%, transparent)")
                ),

                CSS.rule(
                    ".\(ClassName.timelineDot)",
                    CSS.decl("position", "absolute"),
                    CSS.decl("left", "0"),
                    CSS.decl("top", "50%"),
                    CSS.decl("width", "15px"),
                    CSS.decl("height", "15px"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("transform", "translate(-50%, -50%)"),
                    CSS.decl("background", "var(--accent, #0081F8)"),
                    CSS.decl("box-shadow", "0 0 0 5px color-mix(in srgb, var(--accent, #0081F8) 18%, transparent)"),
                    CSS.decl("animation", "wc-classical-timing-sweep var(--wc-classical-timing-duration) linear infinite")
                ),

                CSS.rule(
                    ".\(ClassName.notes)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("margin-top", "16px")
                ),

                CSS.rule(
                    ".\(ClassName.note)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "clamp(112px, 16vw, 170px) minmax(0, 1fr)"),
                    CSS.decl("column-gap", "10px"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("line-height", "1.42"),
                    CSS.decl("color", "var(--wc-classical-timing-muted)")
                ),

                CSS.rule(
                    ".\(ClassName.noteLabel)",
                    CSS.decl("display", "block"),
                    CSS.decl("font-weight", "700"),
                    CSS.decl("color", "var(--wc-classical-timing-ink)"),
                    CSS.decl("white-space", "nowrap")
                ),

                CSS.rule(
                    ".\(ClassName.noteBody)",
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    ".\(ClassName.caption)",
                    CSS.decl("margin-top", "10px"),
                    CSS.decl("font-size", ".86rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "var(--wc-classical-timing-muted)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 680px)",
                    CSS.rule(
                        ".\(ClassName.root)",
                        CSS.decl("--wc-classical-timing-meta-col", "132px"),
                        CSS.decl("--wc-classical-timing-lane-col", "72px"),
                        CSS.decl("--wc-classical-timing-predictive-col", "32px"),
                        CSS.decl("--wc-classical-timing-gap", "12px")
                    ),
                    CSS.rule(
                        ".\(ClassName.viewport) > .\(ClassName.chart), .\(ClassName.viewport) > .\(ClassName.timeline)",
                        CSS.decl("min-width", "760px")
                    ),
                    CSS.rule(
                        ".\(ClassName.effectiveness)",
                        CSS.decl("font-size", ".66rem"),
                        CSS.decl("padding", "2px 6px")
                    )
                ),

                CSS.media(
                    "(prefers-reduced-motion: reduce)",
                    CSS.rule(
                        ".\(ClassName.marker), .\(ClassName.timelineDot)",
                        CSS.decl("animation", "none"),
                        CSS.decl("left", "52%")
                    )
                )
            ],
            keyframes: [
                CSS.keyframes("wc-classical-timing-sweep") {
                    CSS.step("0%") {
                        CSS.decl("left", "0")
                    }

                    CSS.step("100%") {
                        CSS.decl("left", "100%")
                    }
                }
            ]
        )
    }

    private static func orderedArrangements(
        from included: Set<ClassicalConditioningTimingArrangement>
    ) -> [ClassicalConditioningTimingArrangement] {
        let ordered = ClassicalConditioningTimingArrangement.defaultOrder.filter {
            included.contains($0)
        }

        return ordered.isEmpty ? ClassicalConditioningTimingArrangement.defaultOrder : ordered
    }

    private static func header() -> any HTMLNode {
        HTML.div([ "class": ClassName.header ]) {
            HTML.p([ "class": ClassName.eyebrow ]) {
                HTML.text("Klassieke conditionering · timing")
            }

            HTML.el("h3", [ "class": ClassName.title ]) {
                HTML.text("Effectiviteit van koppelings-patroon")
            }

            HTML.p([ "class": ClassName.lead ]) {
                HTML.text("Hier zie je de effectiviteit van binding tussen Prikkel (CS) en Gevolg (US) aan de hand van het volgorde-patroon waarin deze verschijnen.")
            }
        }
    }

    private static func motionToggleInput(
        id: String
    ) -> any HTMLNode {
        HTML.input(
            [
                "id": "\(id)-motion-toggle",
                "class": ClassName.controlInput,
                "type": "checkbox",
                "aria-label": "Animatie pauzeren of afspelen"
            ]
        )
    }

    private static func motionToggleControl(
        id: String
    ) -> any HTMLNode {
        HTML.label(
            [
                "class": ClassName.control,
                "for": "\(id)-motion-toggle",
                "title": "Animatie pauzeren of afspelen"
            ]
        ) {
            HTML.span(
                [
                    "class": "\(ClassName.controlIcon) \(ClassName.stopIcon) stop",
                    "aria-hidden": "true"
                ]
            ) {
                HTML.el(
                    "svg",
                    [
                        "viewBox": "0 0 24 24",
                        "focusable": "false"
                    ]
                ) {
                    HTML.el(
                        "rect",
                        [
                            "x": "7",
                            "y": "7",
                            "width": "10",
                            "height": "10",
                            "rx": "1.5"
                        ]
                    ) {}
                }
            }

            HTML.span(
                [
                    "class": "\(ClassName.controlIcon) \(ClassName.playIcon) play",
                    "aria-hidden": "true"
                ]
            ) {
                HTML.el(
                    "svg",
                    [
                        "viewBox": "0 0 24 24",
                        "focusable": "false"
                    ]
                ) {
                    HTML.el(
                        "polygon",
                        [
                            "points": "8,5 19,12 8,19"
                        ]
                    ) {}
                }
            }
        }
    }

    private static func arrangementRow(
        _ arrangement: ClassicalConditioningTimingArrangement
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "\(ClassName.arrangement) \(ClassName.arrangement)--\(arrangement.rawValue)"
            ]
        ) {
            HTML.div([ "class": ClassName.meta ]) {
                HTML.div([ "class": ClassName.arrangementTitle ]) {
                    HTML.text(arrangement.title)
                }

                HTML.div([ "class": ClassName.arrangementSubtitle ]) {
                    HTML.text(arrangement.dutchLabel)
                }

                HTML.div([ "class": ClassName.effectiveness ]) {
                    HTML.text(arrangement.effectiveness)
                }
            }

            HTML.div([ "class": ClassName.plot ]) {
                lane(
                    kind: .stimulus,
                    interval: arrangement.stimulusInterval
                )

                lane(
                    kind: .consequence,
                    interval: arrangement.consequenceInterval
                )
            }

            predictivePowerNode(arrangement.predictivePower)
        }
    }

    private static func predictivePowerNode(
        _ power: ClassicalConditioningPredictivePower
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "\(ClassName.predictive) \(ClassName.predictive)--\(power.rawValue)",
                "style": "--predictive-power: \(power.percentage)%;",
                "role": "img",
                "aria-label": "Voorspellend vermogen: \(power.accessibilityLabel)"
            ]
        ) {
            HTML.div([ "class": ClassName.predictiveMeter, "aria-hidden": "true" ]) {
                HTML.div([ "class": ClassName.predictiveFill ]) {}
            }
        }
    }

    private static func lane(
        kind: SignalKind,
        interval: TimelineInterval
    ) -> any HTMLNode {
        HTML.div([ "class": "\(ClassName.lane) \(ClassName.lane)--\(kind.rawValue)" ]) {
            HTML.div([ "class": ClassName.laneLabel ]) {
                HTML.text(kind.laneLabel)

                HTML.span([ "class": ClassName.laneSource ]) {
                    HTML.text("(\(kind.sourceLabel))")
                }
            }

            HTML.div([ "class": ClassName.rail ]) {
                HTML.div(
                    [
                        "class": "\(ClassName.block) \(ClassName.block)--\(kind.rawValue)",
                        "style": "--event-start: \(interval.start)%; --event-end: \(interval.end)%;"
                    ]
                ) {
                    HTML.span([ "class": ClassName.blockText ]) {
                        HTML.text(kind.laneLabel)
                    }
                }
            }
        }
    }

    private static func timeline() -> any HTMLNode {
        HTML.div([ "class": ClassName.timeline, "aria-hidden": "true" ]) {
            HTML.div([ "class": ClassName.timelineLabel ]) {
                HTML.text("tijd")
            }

            HTML.div([ "class": ClassName.timelineTrack ]) {
                HTML.div([ "class": ClassName.timelineDot ]) {}
            }
        }
    }

    private static func notes(
        _ arrangements: [ClassicalConditioningTimingArrangement]
    ) -> any HTMLNode {
        HTML.div([ "class": ClassName.notes ]) {
            for arrangement in arrangements {
                HTML.div([ "class": ClassName.note ]) {
                    HTML.strong([ "class": ClassName.noteLabel ]) {
                        HTML.text("\(arrangement.title):")
                    }

                    HTML.span([ "class": ClassName.noteBody ]) {
                        HTML.text(arrangement.note)
                    }
                }
            }
        }
    }
}
