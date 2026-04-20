import DSL
import Constructors
import CSS
import HTML
import JS

public struct SiteNotifier: SelectableComponent, Sendable {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-site-notifier"

    public struct Selectors: Sendable {
        private let api = BlockSelectorAPI<Namespace>(
            block: SiteNotifier.block
        )

        public init() {}

        public var root: HTMLClass<Namespace> {
            api.root
        }

        public var region: HTMLClass<Namespace> {
            api.element("region")
        }

        public var notice: HTMLClass<Namespace> {
            api.element("notice")
        }

        public var icon: HTMLClass<Namespace> {
            api.element("icon")
        }

        public var body: HTMLClass<Namespace> {
            api.element("body")
        }

        public var title: HTMLClass<Namespace> {
            api.element("title")
        }

        public var message: HTMLClass<Namespace> {
            api.element("message")
        }

        public var reportHint: HTMLClass<Namespace> {
            api.element("report-hint")
        }

        public var actions: HTMLClass<Namespace> {
            api.element("actions")
        }

        public var button: HTMLClass<Namespace> {
            api.element("button")
        }

        public var ghostButton: HTMLClass<Namespace> {
            HTMLClass("\(button.rawValue)--ghost")
        }

        public var progress: HTMLClass<Namespace> {
            api.element("progress")
        }

        public var progressBar: HTMLClass<Namespace> {
            api.element("progress-bar")
        }

        public var historyToggle: HTMLClass<Namespace> {
            api.element("history-toggle")
        }

        public var historyToggleCount: HTMLClass<Namespace> {
            api.element("history-toggle-count")
        }

        public var historyBackdrop: HTMLClass<Namespace> {
            api.element("history-backdrop")
        }

        public var historyPanel: HTMLClass<Namespace> {
            api.element("history-panel")
        }

        public var historyPanelHeader: HTMLClass<Namespace> {
            api.element("history-panel-header")
        }

        public var historyPanelEyebrow: HTMLClass<Namespace> {
            api.element("history-panel-eyebrow")
        }

        public var historyPanelTitle: HTMLClass<Namespace> {
            api.element("history-panel-title")
        }

        public var historyPanelClose: HTMLClass<Namespace> {
            api.element("history-panel-close")
        }

        public var historyPanelReportBlock: HTMLClass<Namespace> {
            api.element("history-panel-report-block")
        }

        public var historyPanelReportCopy: HTMLClass<Namespace> {
            api.element("history-panel-report-copy")
        }

        public var historyPanelActions: HTMLClass<Namespace> {
            api.element("history-panel-actions")
        }

        public var historyPanelReport: HTMLClass<Namespace> {
            api.element("history-panel-report")
        }

        public var historyPanelClear: HTMLClass<Namespace> {
            api.element("history-panel-clear")
        }

        public var historyPanelList: HTMLClass<Namespace> {
            api.element("history-panel-list")
        }

        public var historyJSON: HTMLClass<Namespace> {
            api.element("history-json")
        }

        public var historyEmpty: HTMLClass<Namespace> {
            api.element("history-empty")
        }

        public var historyItem: HTMLClass<Namespace> {
            api.element("history-item")
        }

        public var historyItemIcon: HTMLClass<Namespace> {
            api.element("history-item-icon")
        }

        public var historyItemBody: HTMLClass<Namespace> {
            api.element("history-item-body")
        }

        public var historyItemHead: HTMLClass<Namespace> {
            api.element("history-item-head")
        }

        public var historyItemTitle: HTMLClass<Namespace> {
            api.element("history-item-title")
        }

        public var historyItemTime: HTMLClass<Namespace> {
            api.element("history-item-time")
        }

        public var historyItemMessage: HTMLClass<Namespace> {
            api.element("history-item-message")
        }

        public var historyItemMeta: HTMLClass<Namespace> {
            api.element("history-item-meta")
        }

        public var historyItemPill: HTMLClass<Namespace> {
            api.element("history-item-pill")
        }

        public var historyItemReport: HTMLClass<Namespace> {
            api.element("history-item-report")
        }
    }

    public static let selectors = Selectors()

    public struct Copy: Sendable {
        public let titlesInfo: String
        public let titlesSuccess: String
        public let titlesWarning: String
        public let titlesError: String
        public let titlesLoading: String

        public let closeText: String
        public let closeLabel: String
        public let historyCloseLabel: String

        public let reportText: String
        public let reportHint: String
        public let historyReportCopy: String
        public let reportIntro: String
        public let reportContext: String
        public let reportSectionNotice: String
        public let reportSectionHistory: String
        public let reportSectionPage: String
        public let reportSectionDetails: String
        public let reportFallbackTitle: String
        public let reportFallbackMessage: String
        public let reportFallbackDetails: String

        public let historyEyebrow: String
        public let historyTitle: String
        public let historyEmpty: String
        public let historyReportText: String
        public let historyClearText: String
        public let historyItemReportText: String
        public let historyJSONSummary: String

        public init(
            titlesInfo: String = "Notification",
            titlesSuccess: String = "Done",
            titlesWarning: String = "Attention",
            titlesError: String = "Something went wrong",
            titlesLoading: String = "Working",
            closeText: String = "Close",
            closeLabel: String = "Close notification",
            historyCloseLabel: String = "Close notifications",
            reportText: String = "Report issue",
            reportHint: String = "Reporting this helps us solve it.",
            historyReportCopy: String = "If you experience problems on the website, report your notification history so we can resolve it as quickly as possible.",
            reportIntro: String = "Hi, I experienced the following issue.",
            reportContext: String = "Issue report from the website.",
            reportSectionNotice: String = "Notification:",
            reportSectionHistory: String = "Notification history:",
            reportSectionPage: String = "Page:",
            reportSectionDetails: String = "Technical details:",
            reportFallbackTitle: String = "No title",
            reportFallbackMessage: String = "No message",
            reportFallbackDetails: String = "No details supplied.",
            historyEyebrow: String = "Status",
            historyTitle: String = "Notifications",
            historyEmpty: String = "No notifications yet.",
            historyReportText: String = "Report notification history",
            historyClearText: String = "Clear",
            historyItemReportText: String = "Report this notification",
            historyJSONSummary: String = "JSON log"
        ) {
            self.titlesInfo = titlesInfo
            self.titlesSuccess = titlesSuccess
            self.titlesWarning = titlesWarning
            self.titlesError = titlesError
            self.titlesLoading = titlesLoading
            self.closeText = closeText
            self.closeLabel = closeLabel
            self.historyCloseLabel = historyCloseLabel
            self.reportText = reportText
            self.reportHint = reportHint
            self.historyReportCopy = historyReportCopy
            self.reportIntro = reportIntro
            self.reportContext = reportContext
            self.reportSectionNotice = reportSectionNotice
            self.reportSectionHistory = reportSectionHistory
            self.reportSectionPage = reportSectionPage
            self.reportSectionDetails = reportSectionDetails
            self.reportFallbackTitle = reportFallbackTitle
            self.reportFallbackMessage = reportFallbackMessage
            self.reportFallbackDetails = reportFallbackDetails
            self.historyEyebrow = historyEyebrow
            self.historyTitle = historyTitle
            self.historyEmpty = historyEmpty
            self.historyReportText = historyReportText
            self.historyClearText = historyClearText
            self.historyItemReportText = historyItemReportText
            self.historyJSONSummary = historyJSONSummary
        }

        public static let dutch = Self(
            titlesInfo: "Melding",
            titlesSuccess: "Gelukt",
            titlesWarning: "Let op",
            titlesError: "Er ging iets mis",
            titlesLoading: "Bezig",
            closeText: "Sluit",
            closeLabel: "Sluit melding",
            historyCloseLabel: "Sluit meldingen",
            reportText: "Probleem melden",
            reportHint: "Door dit te melden help je ons het op te lossen.",
            historyReportCopy: "Als je problemen ervaart op de website, rapporteer dan jouw melding-geschiedenis. Daarmee kunnen wij het zo snel mogelijk oplossen.",
            reportIntro: "Hi, ik ervaarde het volgende probleem.",
            reportContext: "Probleemmelding vanaf de website.",
            reportSectionNotice: "Melding:",
            reportSectionHistory: "Melding-geschiedenis:",
            reportSectionPage: "Pagina:",
            reportSectionDetails: "Technische details:",
            reportFallbackTitle: "Geen titel",
            reportFallbackMessage: "Geen bericht",
            reportFallbackDetails: "Geen details meegegeven.",
            historyEyebrow: "Status",
            historyTitle: "Meldingen",
            historyEmpty: "Nog geen meldingen.",
            historyReportText: "Rapporteer melding-geschiedenis",
            historyClearText: "Wis",
            historyItemReportText: "Rapporteer deze melding",
            historyJSONSummary: "JSON-log"
        )
    }

    public struct Report: Sendable {
        public let to: String
        public let subject: String

        public init(
            to: String,
            subject: String
        ) {
            self.to = to
            self.subject = subject
        }
    }

    public struct Model: Sendable {
        public let copy: Copy
        public let report: Report
        public let storageKey: String
        public let rootID: String
        public let historyToggleID: String
        public let historyBackdropID: String
        public let historyPanelID: String
        public let historyTitleID: String
        public let keyboardOffsetProperty: String
        public let progressProperty: String
        public let stackHeightProperty: String
        public let globalName: String
        public let compatibilityAliases: [String]

        public init(
            copy: Copy = .init(),
            report: Report,
            storageKey: String = "wc_site_notifier_history_v1",
            rootID: String = "wc-site-notifier-region",
            historyToggleID: String = "wc-site-notifier-history-toggle",
            historyBackdropID: String = "wc-site-notifier-history-backdrop",
            historyPanelID: String = "wc-site-notifier-history-panel",
            historyTitleID: String = "wc-site-notifier-history-title",
            keyboardOffsetProperty: String = "--wc-site-notifier-keyboard-offset",
            progressProperty: String = "--wc-site-notifier-progress",
            stackHeightProperty: String = "--wc-site-notifier-stack-height",
            globalName: String = "Notifier",
            compatibilityAliases: [String] = []
        ) {
            self.copy = copy
            self.report = report
            self.storageKey = storageKey
            self.rootID = rootID
            self.historyToggleID = historyToggleID
            self.historyBackdropID = historyBackdropID
            self.historyPanelID = historyPanelID
            self.historyTitleID = historyTitleID
            self.keyboardOffsetProperty = keyboardOffsetProperty
            self.progressProperty = progressProperty
            self.stackHeightProperty = stackHeightProperty
            self.globalName = globalName
            self.compatibilityAliases = compatibilityAliases
        }
    }

    public let model: Model

    public init(
        _ model: Model
    ) {
        self.model = model
    }

    public var nodes: ReusableComponentNodes {
        let s = Self.selectors

        return .init(
            body: [
                HTML.div([
                    "class": s.root.rawValue,
                    "data-notifier-system": ""
                ]) {
                    HTML.div([
                        "id": model.rootID,
                        "class": s.region.rawValue,
                        "aria-live": "polite",
                        "aria-atomic": "false",
                        "data-notifier-host": "",
                        "data-notification-host": ""
                    ]) {}

                    HTML.button([
                        "id": model.historyToggleID,
                        "class": s.historyToggle.rawValue,
                        "type": "button",
                        "aria-expanded": "false",
                        "aria-controls": model.historyPanelID,
                        "data-notifier-history-toggle": ""
                    ]) {
                        HTML.span([
                            "class": s.historyToggleCount.rawValue,
                            "data-notifier-history-count": ""
                        ]) {
                            HTML.text("0")
                        }
                    }

                    HTML.div([
                        "id": model.historyBackdropID,
                        "class": s.historyBackdrop.rawValue,
                        "data-notifier-history-backdrop": "",
                        "hidden": ""
                    ]) {
                        HTML.aside([
                            "id": model.historyPanelID,
                            "class": s.historyPanel.rawValue,
                            "role": "dialog",
                            "aria-modal": "false",
                            "aria-labelledby": model.historyTitleID,
                            "data-notifier-history-panel": ""
                        ]) {
                            HTML.header(.class(s.historyPanelHeader)) {
                                HTML.div {
                                    HTML.p(.class(s.historyPanelEyebrow)) {
                                        HTML.text(model.copy.historyEyebrow)
                                    }

                                    HTML.h2([
                                        "id": model.historyTitleID,
                                        "class": s.historyPanelTitle.rawValue
                                    ]) {
                                        HTML.text(model.copy.historyTitle)
                                    }
                                }

                                HTML.button([
                                    "class": s.historyPanelClose.rawValue,
                                    "type": "button",
                                    "aria-label": model.copy.historyCloseLabel,
                                    "data-notifier-history-close": ""
                                ]) {
                                    HTML.text(model.copy.closeText)
                                }
                            }

                            HTML.div(.class(s.historyPanelReportBlock)) {
                                HTML.p(.class(s.historyPanelReportCopy)) {
                                    HTML.text(model.copy.historyReportCopy)
                                }

                                HTML.div(.class(s.historyPanelActions)) {
                                    HTML.a([
                                        "class": s.historyPanelReport.rawValue,
                                        "href": "mailto:\\(model.report.to)",
                                        "data-notifier-history-report": ""
                                    ]) {
                                        HTML.text(model.copy.historyReportText)
                                    }

                                    HTML.button([
                                        "class": s.historyPanelClear.rawValue,
                                        "type": "button",
                                        "data-notifier-history-clear": ""
                                    ]) {
                                        HTML.text(model.copy.historyClearText)
                                    }
                                }
                            }

                            HTML.div([
                                "class": s.historyPanelList.rawValue,
                                "data-notifier-history-list": ""
                            ]) {}

                            HTML.details(.class(s.historyJSON)) {
                                HTML.summary {
                                    HTML.text(model.copy.historyJSONSummary)
                                }

                                HTML.pre(["data-notifier-history-json": ""]) {
                                    HTML.text("{}")
                                }
                            }
                        }
                    }
                }
            ],
            stylesheets: [
                Self.css(model: model)
            ],
            scripts: [
                Self.script(model: model)
            ]
        )
    }
}

public extension SiteNotifier {
    static func css(
        model: Model
    ) -> CSSStyleSheet {
        let s = Self.selectors

        let historyToggleHoverCount = CSSSelector.group(
            s.historyToggle
                .pseudoClass("hover")
                .descendant(CSSSelector.class(s.historyToggleCount.rawValue)),
            s.historyToggle
                .pseudoClass("focus-visible")
                .descendant(CSSSelector.class(s.historyToggleCount.rawValue))
        )

        let historyBackdropOpen = CSSSelector.class("\(s.historyBackdrop.rawValue).is-open")
        let historyPanelOpen = CSSSelector.raw(".\(s.historyBackdrop.rawValue).is-open .\(s.historyPanel.rawValue)")
        let historyJSONOpenPre = CSSSelector.raw(".\(s.historyJSON.rawValue)[open] pre")
        let historyJSONClosingPre = CSSSelector.raw(".\(s.historyJSON.rawValue).is-closing pre")
        let historyJSONOpenSummaryAfter = CSSSelector.raw(".\(s.historyJSON.rawValue)[open] summary::after")

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    s.root,
                    CSS.decl("pointer-events", "none")
                ),

                CSS.rule(
                    s.region,
                    CSS.decl("position", "fixed"),
                    CSS.decl("right", "0"),
                    CSS.decl("left", "0"),
                    CSS.decl(
                        "bottom",
                        "calc(var(\(model.keyboardOffsetProperty), 0px) + max(1rem, env(safe-area-inset-bottom)))"
                    ),
                    CSS.decl("z-index", "2147483000"),
                    CSS.decl("display", "grid"),
                    CSS.decl("justify-items", "center"),
                    CSS.decl("gap", ".65rem"),
                    CSS.decl("padding", "0 1rem"),
                    CSS.decl("pointer-events", "none")
                ),

                CSS.rule(
                    s.notice,
                    CSS.decl("width", "min(100%, 640px)"),
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "auto minmax(0, 1fr) auto"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("gap", ".8rem"),
                    CSS.decl("padding", "1rem"),
                    CSS.decl("border", "1px solid rgba(255,255,255,.16)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "rgba(20, 12, 10, .92)"),
                    CSS.decl("color", "#fff"),
                    CSS.decl("box-shadow", "0 18px 48px rgba(0,0,0,.22)"),
                    CSS.decl("backdrop-filter", "blur(10px) saturate(135%)"),
                    CSS.decl("-webkit-backdrop-filter", "blur(10px) saturate(135%)"),
                    CSS.decl("opacity", "0"),
                    CSS.decl("transform", "translateY(1rem) scale(.985)"),
                    CSS.decl("transition", "opacity 180ms ease, transform 220ms cubic-bezier(.2, .9, .22, 1)"),
                    CSS.decl("pointer-events", "auto")
                ),

                CSS.rule(
                    CSSSelector.class("\(s.notice.rawValue).is-open"),
                    CSS.decl("opacity", "1"),
                    CSS.decl("transform", "translateY(0) scale(1)")
                ),

                CSS.rule(
                    CSSSelector.class("\(s.notice.rawValue).is-leaving"),
                    CSS.decl("opacity", "0"),
                    CSS.decl("transform", "translateY(.65rem) scale(.985)")
                ),

                CSS.rule(
                    s.icon,
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "2rem"),
                    CSS.decl("height", "2rem"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "rgba(255,255,255,.12)"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("line-height", "1")
                ),

                CSS.rule(
                    s.body,
                    CSS.decl("min-width", "0")
                ),

                CSS.rule(
                    s.title,
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".96rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("letter-spacing", ".01em")
                ),

                CSS.rule(
                    s.message,
                    CSS.decl("margin", ".22rem 0 0"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "rgba(255,255,255,.84)")
                ),

                CSS.rule(
                    s.reportHint,
                    CSS.decl("margin", ".5rem 0 0"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("line-height", "1.4"),
                    CSS.decl("color", "rgba(255,255,255,.68)")
                ),

                CSS.rule(
                    s.actions,
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", ".45rem"),
                    CSS.decl("margin-top", ".65rem")
                ),

                CSS.rule(
                    s.button,
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("min-height", "2rem"),
                    CSS.decl("padding", ".42rem .72rem"),
                    CSS.decl("border", "1px solid rgba(255,255,255,.2)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "rgba(255,255,255,.12)"),
                    CSS.decl("color", "#fff"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    s.button.pseudoClass("hover"),
                    CSS.decl("background", "rgba(255,255,255,.18)")
                ),

                CSS.rule(
                    s.ghostButton,
                    CSS.decl("padding", ".35rem .55rem"),
                    CSS.decl("border-color", "transparent"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("color", "rgba(255,255,255,.7)")
                ),

                CSS.rule(
                    s.ghostButton.pseudoClass("hover"),
                    CSS.decl("background", "rgba(255,255,255,.1)"),
                    CSS.decl("color", "#fff")
                ),

                CSS.rule(
                    s.progress,
                    CSS.decl("position", "relative"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("height", "3px"),
                    CSS.decl("margin-top", ".55rem"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "rgba(255,255,255,.16)")
                ),

                CSS.rule(
                    s.progressBar,
                    CSS.decl("display", "block"),
                    CSS.decl("width", "var(\(model.progressProperty), 0%)"),
                    CSS.decl("height", "100%"),
                    CSS.decl("border-radius", "inherit"),
                    CSS.decl("background", "rgba(255,255,255,.72)"),
                    CSS.decl("transition", "width .16s ease")
                ),

                CSS.rule(
                    s.historyToggle,
                    CSS.decl("position", "fixed"),
                    CSS.decl("left", "max(1rem, env(safe-area-inset-left))"),
                    CSS.decl(
                        "bottom",
                        "calc(var(\(model.keyboardOffsetProperty), 0px) + max(1rem, env(safe-area-inset-bottom)) + var(\(model.stackHeightProperty), 0px) + .75rem)"
                    ),
                    CSS.decl("z-index", "2147482999"),
                    CSS.decl("display", "inline-grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "2.55rem"),
                    CSS.decl("height", "2.55rem"),
                    CSS.decl("padding", ".28rem"),
                    CSS.decl("border", "0"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "linear-gradient(135deg, rgba(255,255,255,.12), rgba(9, 3, 2, .18))"),
                    CSS.decl("color", "rgba(255,255,255,.82)"),
                    CSS.decl(
                        "box-shadow",
                        "inset 0 0 0 1px rgba(255,255,255,.18), inset 0 1px 0 rgba(255,255,255,.16), 0 10px 24px rgba(0,0,0,.08)"
                    ),
                    CSS.decl("backdrop-filter", "blur(7px) saturate(135%)"),
                    CSS.decl("-webkit-backdrop-filter", "blur(7px) saturate(135%)"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl(
                        "transition",
                        "bottom 360ms cubic-bezier(.2, .9, .22, 1), background 180ms ease, color 180ms ease, box-shadow 180ms ease, transform 180ms ease"
                    ),
                    CSS.decl("pointer-events", "auto")
                ),

                CSS.rule(
                    s.historyToggle.pseudoClass("hover"),
                    CSS.decl("background", "linear-gradient(135deg, rgba(255,255,255,.18), rgba(9, 3, 2, .34))"),
                    CSS.decl("color", "#fff"),
                    CSS.decl(
                        "box-shadow",
                        "inset 0 0 0 1px rgba(255,255,255,.28), inset 0 1px 0 rgba(255,255,255,.22), 0 14px 30px rgba(0,0,0,.14)"
                    )
                ),

                CSS.rule(
                    s.historyToggle.pseudoClass("focus-visible"),
                    CSS.decl("outline", "none")
                ),

                CSS.rule(
                    s.historyToggleCount,
                    CSS.decl("display", "inline-grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("min-width", "1.55rem"),
                    CSS.decl("height", "1.55rem"),
                    CSS.decl("padding", "0 .28rem"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "rgba(255,255,255,.08)"),
                    CSS.decl("box-shadow", "inset 0 0 0 1px rgba(255,255,255,.14), inset 0 1px 0 rgba(255,255,255,.12)"),
                    CSS.decl("color", "rgba(255,255,255,.84)"),
                    CSS.decl("font-size", ".74rem"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("transition", "transform 180ms ease, background 180ms ease")
                ),

                CSS.rule(
                    historyToggleHoverCount,
                    CSS.decl("background", "rgba(255,255,255,.18)"),
                    CSS.decl(
                        "box-shadow",
                        "inset 0 0 0 1px rgba(255,255,255,.26), inset 0 1px 0 rgba(255,255,255,.2), 0 4px 12px rgba(0,0,0,.12)"
                    ),
                    CSS.decl("color", "#fff"),
                    CSS.decl("transform", "scale(1.06)")
                ),

                CSS.rule(
                    s.historyBackdrop,
                    CSS.decl("position", "fixed"),
                    CSS.decl("inset", "0"),
                    CSS.decl("z-index", "2147483001"),
                    CSS.decl("display", "grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("padding", "clamp(1rem, 4vw, 2rem)"),
                    CSS.decl("background", "rgba(13, 8, 6, 0)"),
                    CSS.decl("backdrop-filter", "blur(0px)"),
                    CSS.decl("opacity", "0"),
                    CSS.decl("pointer-events", "none"),
                    CSS.decl("transition", "opacity 260ms ease, background 260ms ease, backdrop-filter 260ms ease")
                ),

                CSS.rule(
                    historyBackdropOpen,
                    CSS.decl("background", "rgba(13, 8, 6, .42)"),
                    CSS.decl("backdrop-filter", "blur(7px)"),
                    CSS.decl("opacity", "1"),
                    CSS.decl("pointer-events", "auto")
                ),

                CSS.rule(
                    CSSSelector.raw(".\(s.historyBackdrop.rawValue)[hidden]"),
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    s.historyPanel,
                    CSS.decl("width", "min(100%, 760px)"),
                    CSS.decl("max-height", "min(760px, calc(100vh - 2rem))"),
                    CSS.decl("max-height", "min(760px, calc(100dvh - 2rem))"),
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-rows", "auto auto minmax(0, 1fr) auto"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("border", "1px solid rgba(255,255,255,.18)"),
                    CSS.decl("border-radius", "24px"),
                    CSS.decl("background", "rgba(20, 12, 10, .94)"),
                    CSS.decl("color", "#fff"),
                    CSS.decl("box-shadow", "0 28px 80px rgba(0,0,0,.38)"),
                    CSS.decl("opacity", "0"),
                    CSS.decl("transform", "translateY(1.1rem) scale(.965)"),
                    CSS.decl("transform-origin", "center bottom"),
                    CSS.decl("transition", "opacity 260ms ease, transform 340ms cubic-bezier(.2, .9, .22, 1)")
                ),

                CSS.rule(
                    historyPanelOpen,
                    CSS.decl("opacity", "1"),
                    CSS.decl("transform", "translateY(0) scale(1)")
                ),

                CSS.rule(
                    s.historyPanelHeader,
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("align-items", "start"),
                    CSS.decl("gap", "1rem"),
                    CSS.decl("padding", "1.1rem 1.15rem .8rem"),
                    CSS.decl("border-bottom", "1px solid rgba(255,255,255,.1)")
                ),

                CSS.rule(
                    s.historyPanelEyebrow,
                    CSS.decl("margin", "0 0 .25rem"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("letter-spacing", ".12em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "rgba(255,255,255,.58)")
                ),

                CSS.rule(
                    s.historyPanelTitle,
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.2rem"),
                    CSS.decl("font-weight", "900")
                ),

                CSS.rule(
                    s.historyPanelClose,
                    CSS.decl("border", "1px solid rgba(255,255,255,.16)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "rgba(255,255,255,.08)"),
                    CSS.decl("color", "#fff"),
                    CSS.decl("padding", ".45rem .72rem"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    s.historyPanelReportBlock,
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", ".7rem"),
                    CSS.decl("padding", ".95rem 1.15rem"),
                    CSS.decl("border-bottom", "1px solid rgba(255,255,255,.08)")
                ),

                CSS.rule(
                    s.historyPanelReportCopy,
                    CSS.decl("max-width", "58ch"),
                    CSS.decl("margin", "0"),
                    CSS.decl("color", "rgba(255,255,255,.68)"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("line-height", "1.45")
                ),

                CSS.rule(
                    s.historyPanelActions,
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", ".75rem"),
                    CSS.decl("padding", ".8rem 1.15rem")
                ),

                CSS.rule(
                    CSSSelector.group(
                        s.historyPanelReport,
                        s.historyPanelClear
                    ),
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("min-height", "2rem"),
                    CSS.decl("padding", ".45rem .7rem"),
                    CSS.decl("border", "1px solid rgba(255,255,255,.16)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "rgba(255,255,255,.08)"),
                    CSS.decl("color", "#fff"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    s.historyPanelClear,
                    CSS.decl("background", "transparent"),
                    CSS.decl("color", "rgba(255,255,255,.76)")
                ),

                CSS.rule(
                    s.historyPanelList,
                    CSS.decl("overflow", "auto"),
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", ".65rem"),
                    CSS.decl("padding", "1rem 1.15rem")
                ),

                CSS.rule(
                    s.historyEmpty,
                    CSS.decl("padding", "1.2rem"),
                    CSS.decl("border", "1px dashed rgba(255,255,255,.18)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("color", "rgba(255,255,255,.68)"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("text-align", "center")
                ),

                CSS.rule(
                    s.historyItem,
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "auto minmax(0, 1fr)"),
                    CSS.decl("gap", ".7rem"),
                    CSS.decl("padding", ".85rem"),
                    CSS.decl("border", "1px solid rgba(255,255,255,.12)"),
                    CSS.decl("border-radius", "18px"),
                    CSS.decl("background", "rgba(255,255,255,.055)")
                ),

                CSS.rule(
                    s.historyItemIcon,
                    CSS.decl("display", "inline-grid"),
                    CSS.decl("place-items", "center"),
                    CSS.decl("width", "1.35rem"),
                    CSS.decl("height", "1.35rem"),
                    CSS.decl("margin-top", ".02rem"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "rgba(255,255,255,.72)"),
                    CSS.decl("color", "#090302"),
                    CSS.decl("font-size", ".86rem"),
                    CSS.decl("font-weight", "850"),
                    CSS.decl("line-height", "1")
                ),

                CSS.rule(
                    CSSSelector.raw(".\\(s.historyItem.rawValue)--success .\\(s.historyItemIcon.rawValue)"),
                    CSS.decl("background", "#58d68d"),
                    CSS.decl("color", "#052915")
                ),

                CSS.rule(
                    CSSSelector.raw(".\\(s.historyItem.rawValue)--warning .\\(s.historyItemIcon.rawValue)"),
                    CSS.decl("width", "1.45rem"),
                    CSS.decl("height", "1.32rem"),
                    CSS.decl("padding-top", ".16rem"),
                    CSS.decl("border-radius", "0"),
                    CSS.decl("clip-path", "polygon(50% 4%, 96% 92%, 4% 92%)"),
                    CSS.decl("background", "#ffc74d"),
                    CSS.decl("color", "#2d1d00"),
                    CSS.decl("font-size", ".76rem")
                ),

                CSS.rule(
                    CSSSelector.raw(".\\(s.historyItem.rawValue)--error .\\(s.historyItemIcon.rawValue)"),
                    CSS.decl("background", "#ff7070"),
                    CSS.decl("color", "#330707"),
                    CSS.decl("font-size", "1rem")
                ),

                CSS.rule(
                    CSSSelector.raw(".\\(s.historyItem.rawValue)--loading .\\(s.historyItemIcon.rawValue)"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("background", "transparent"),
                    CSS.decl("border", "2px solid rgba(255,255,255,.32)"),
                    CSS.decl("border-top-color", "rgba(255,255,255,.9)"),
                    CSS.decl("animation", "hm-notification-spin .8s linear infinite")
                ),

                CSS.rule(
                    s.historyItemHead,
                    CSS.decl("display", "flex"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", ".75rem"),
                    CSS.decl("align-items", "baseline")
                ),

                CSS.rule(
                    s.historyItemTitle,
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", ".9rem"),
                    CSS.decl("font-weight", "850")
                ),

                CSS.rule(
                    s.historyItemTime,
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("color", "rgba(255,255,255,.54)"),
                    CSS.decl("white-space", "nowrap")
                ),

                CSS.rule(
                    s.historyItemMessage,
                    CSS.decl("margin", ".2rem 0 0"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("color", "rgba(255,255,255,.74)")
                ),

                CSS.rule(
                    s.historyItemMeta,
                    CSS.decl("display", "flex"),
                    CSS.decl("flex-wrap", "wrap"),
                    CSS.decl("gap", ".35rem"),
                    CSS.decl("margin-top", ".55rem")
                ),

                CSS.rule(
                    s.historyItemPill,
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("min-height", "1.45rem"),
                    CSS.decl("padding", ".2rem .45rem"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("background", "rgba(255,255,255,.08)"),
                    CSS.decl("color", "rgba(255,255,255,.72)"),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "750")
                ),

                CSS.rule(
                    s.historyItemReport,
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("min-height", "1.45rem"),
                    CSS.decl("padding", ".2rem .45rem"),
                    CSS.decl("border", "1px solid rgba(255,255,255,.14)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("color", "#fff"),
                    CSS.decl("font-size", ".68rem"),
                    CSS.decl("font-weight", "800"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    s.historyJSON,
                    CSS.decl("border-top", "1px solid rgba(255,255,255,.1)"),
                    CSS.decl("padding", ".8rem 1rem 1rem")
                ),

                CSS.rule(
                    historyJSONOpenSummaryAfter,
                    CSS.decl("content", "\"−\""),
                    CSS.decl("transform", "rotate(180deg)")
                ),

                CSS.rule(
                    CSSSelector.raw(".\(s.historyJSON.rawValue) pre"),
                    CSS.decl("max-height", "0"),
                    CSS.decl("overflow", "auto"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding", "0 .8rem"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "rgba(0,0,0,.28)"),
                    CSS.decl("color", "rgba(255,255,255,.78)"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("line-height", "1.45"),
                    CSS.decl("white-space", "pre-wrap"),
                    CSS.decl("opacity", "0"),
                    CSS.decl("transform", "translateY(-.35rem)"),
                    CSS.decl(
                        "transition",
                        "max-height 280ms cubic-bezier(.2, .9, .22, 1), opacity 220ms ease, transform 280ms cubic-bezier(.2, .9, .22, 1), margin 280ms cubic-bezier(.2, .9, .22, 1), padding 280ms cubic-bezier(.2, .9, .22, 1)"
                    )
                ),

                CSS.rule(
                    historyJSONOpenPre,
                    CSS.decl("max-height", "220px"),
                    CSS.decl("margin", ".7rem 0 0"),
                    CSS.decl("padding", ".8rem"),
                    CSS.decl("opacity", "1"),
                    CSS.decl("transform", "translateY(0)")
                ),

                CSS.rule(
                    historyJSONClosingPre,
                    CSS.decl("max-height", "0"),
                    CSS.decl("margin", "0"),
                    CSS.decl("padding-top", "0"),
                    CSS.decl("padding-bottom", "0"),
                    CSS.decl("opacity", "0"),
                    CSS.decl("transform", "translateY(-.35rem)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 900px)",
                    CSS.rule(
                        s.historyToggle,
                        CSS.decl(
                            "bottom",
                            "calc(var(\(model.keyboardOffsetProperty), 0px) + max(1rem, env(safe-area-inset-bottom)) + var(\(model.stackHeightProperty), 0px) + .75rem)"
                        )
                    )
                ),
                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        s.region,
                        CSS.decl(
                            "bottom",
                            "calc(var(\(model.keyboardOffsetProperty), 0px) + max(.75rem, env(safe-area-inset-bottom)))"
                        )
                    ),
                    CSS.rule(
                        s.notice,
                        CSS.decl("border-radius", "16px"),
                        CSS.decl("padding", ".9rem"),
                        CSS.decl("gap", ".7rem")
                    ),
                    CSS.rule(
                        s.historyToggle,
                        CSS.decl("left", "max(.75rem, env(safe-area-inset-left))"),
                        CSS.decl(
                            "bottom",
                            "calc(var(\(model.keyboardOffsetProperty), 0px) + max(.75rem, env(safe-area-inset-bottom)) + var(\(model.stackHeightProperty), 0px) + .65rem)"
                        )
                    ),
                    CSS.rule(
                        s.historyBackdrop,
                        CSS.decl("align-items", "end"),
                        CSS.decl("padding", ".75rem")
                    ),
                    CSS.rule(
                        s.historyPanel,
                        CSS.decl("max-height", "min(760px, calc(100vh - 1.5rem))"),
                        CSS.decl("max-height", "min(760px, calc(100dvh - 1.5rem))"),
                        CSS.decl("border-radius", "20px")
                    ),
                    CSS.rule(
                        s.historyItemHead,
                        CSS.decl("display", "grid")
                    )
                )
            ]
        )
    }

    static func script(
        model: Model
    ) -> JSScript {
        let copy = model.copy
        let aliasesAssignment = model.compatibilityAliases
            .map { "window.\($0) = api;" }
            .joined(separator: "\n        ")

        let code = """
        (function () {
            "use strict";

            const notices = new Map();
            const records = [];
            const recordIndex = new Map();

            const historyStorage = {
                key: "\(model.storageKey)",
                maxRecords: 100,
                ttlMs: 4 * 60 * 60 * 1000
            };

            let counter = 0;
            let historyIsOpen = false;
            let initializedHistoryControls = false;
            let historyAnimationTimer = null;
            let stackHeightAnimationFrame = null;

            const settings = {
                rootId: "\(model.rootID)",
                hostSelector: "[data-notifier-host], [data-notification-host]",
                historySelector: "[data-notifier-history-panel]",
                historyBackdropSelector: "[data-notifier-history-backdrop]",
                historyToggleSelector: "[data-notifier-history-toggle]",
                historyCloseSelector: "[data-notifier-history-close]",
                historyClearSelector: "[data-notifier-history-clear]",
                historyListSelector: "[data-notifier-history-list]",
                historyJsonSelector: "[data-notifier-history-json]",
                historyReportSelector: "[data-notifier-history-report]",
                historyCountSelector: "[data-notifier-history-count]",
                keyboardOffsetProperty: "\(model.keyboardOffsetProperty)",
                progressProperty: "\(model.progressProperty)",
                stackHeightProperty: "\(model.stackHeightProperty)",

                classes: {
                    region: "\(Self.selectors.region.rawValue)",
                    notice: "\(Self.selectors.notice.rawValue)",
                    open: "is-open",
                    leaving: "is-leaving",
                    icon: "\(Self.selectors.icon.rawValue)",
                    body: "\(Self.selectors.body.rawValue)",
                    title: "\(Self.selectors.title.rawValue)",
                    message: "\(Self.selectors.message.rawValue)",
                    reportHint: "\(Self.selectors.reportHint.rawValue)",
                    actions: "\(Self.selectors.actions.rawValue)",
                    button: "\(Self.selectors.button.rawValue)",
                    ghostButton: "\(Self.selectors.ghostButton.rawValue)",
                    progress: "\(Self.selectors.progress.rawValue)",
                    progressBar: "\(Self.selectors.progressBar.rawValue)",

                    historyEmpty: "\(Self.selectors.historyEmpty.rawValue)",
                    historyItem: "\(Self.selectors.historyItem.rawValue)",
                    historyItemIcon: "\(Self.selectors.historyItemIcon.rawValue)",
                    historyItemBody: "\(Self.selectors.historyItemBody.rawValue)",
                    historyItemHead: "\(Self.selectors.historyItemHead.rawValue)",
                    historyItemTitle: "\(Self.selectors.historyItemTitle.rawValue)",
                    historyItemTime: "\(Self.selectors.historyItemTime.rawValue)",
                    historyItemMessage: "\(Self.selectors.historyItemMessage.rawValue)",
                    historyItemMeta: "\(Self.selectors.historyItemMeta.rawValue)",
                    historyItemPill: "\(Self.selectors.historyItemPill.rawValue)",
                    historyItemReport: "\(Self.selectors.historyItemReport.rawValue)"
                },

                data: {
                    host: "data-notifier-host",
                    icon: "data-notifier-icon",
                    title: "data-notifier-title",
                    message: "data-notifier-message",
                    reportHint: "data-notifier-report-hint",
                    actions: "data-notifier-actions",
                    close: "data-notifier-close",
                    progress: "data-notifier-progress"
                },

                copy: {
                    titles: {
                        info: "\(copy.titlesInfo)",
                        success: "\(copy.titlesSuccess)",
                        warning: "\(copy.titlesWarning)",
                        error: "\(copy.titlesError)",
                        loading: "\(copy.titlesLoading)"
                    },
                    symbols: {
                        info: "i",
                        success: "✓",
                        warning: "!",
                        error: "×",
                        loading: ""
                    },
                    closeText: "\(copy.closeText)",
                    closeLabel: "\(copy.closeLabel)",
                    reportText: "\(copy.reportText)",
                    reportHint: "\(copy.reportHint)",
                    reportIntro: "\(copy.reportIntro)",
                    reportContext: "\(copy.reportContext)",
                    reportSectionNotice: "\(copy.reportSectionNotice)",
                    reportSectionHistory: "\(copy.reportSectionHistory)",
                    reportSectionPage: "\(copy.reportSectionPage)",
                    reportSectionDetails: "\(copy.reportSectionDetails)",
                    reportFallbackTitle: "\(copy.reportFallbackTitle)",
                    reportFallbackMessage: "\(copy.reportFallbackMessage)",
                    reportFallbackDetails: "\(copy.reportFallbackDetails)",
                    historyEmpty: "\(copy.historyEmpty)",
                    historyReportText: "\(copy.historyReportText)",
                    historyClearText: "\(copy.historyClearText)",
                    historyItemReportText: "\(copy.historyItemReportText)"
                },

                report: {
                    to: "\(model.report.to)",
                    subject: "\(model.report.subject)"
                },

                durations: {
                    info: 5000,
                    success: 5500,
                    warning: 7000,
                    error: 0,
                    loading: 0
                },

                history: {
                    max: 50,
                    includeLoading: false,
                    includeDismissedState: true
                }
            };

            function isPlainObject(value) {
                return value !== null
                    && typeof value === "object"
                    && !Array.isArray(value);
            }

            function mergeDeep(target, source) {
                if (!isPlainObject(source)) {
                    return target;
                }

                Object.keys(source).forEach(function (key) {
                    const sourceValue = source[key];
                    const targetValue = target[key];

                    if (isPlainObject(sourceValue) && isPlainObject(targetValue)) {
                        mergeDeep(targetValue, sourceValue);
                        return;
                    }

                    target[key] = sourceValue;
                });

                return target;
            }

            function configure(options = {}) {
                mergeDeep(settings, options);
                renderHistory();
                return api;
            }

            function nextId() {
                counter += 1;
                return "notifier-" + counter;
            }

            function dataSelector(name) {
                return "[" + settings.data[name] + "]";
            }

            function root() {
                let node = null;

                if (settings.rootId) {
                    node = document.getElementById(settings.rootId);
                }

                if (!node && settings.hostSelector) {
                    node = document.querySelector(settings.hostSelector);
                }

                if (node) {
                    return node;
                }

                node = document.createElement("div");

                if (settings.rootId) {
                    node.id = settings.rootId;
                }

                node.className = settings.classes.region;
                node.setAttribute("aria-live", "polite");
                node.setAttribute("aria-atomic", "false");
                node.setAttribute(settings.data.host, "");

                document.body.append(node);

                return node;
            }

            function historyPanel() {
                return document.querySelector(settings.historySelector);
            }

            function historyBackdrop() {
                return document.querySelector(settings.historyBackdropSelector);
            }

            function historyToggle() {
                return document.querySelector(settings.historyToggleSelector);
            }

            function historyList() {
                return document.querySelector(settings.historyListSelector);
            }

            function historyJsonNode() {
                return document.querySelector(settings.historyJsonSelector);
            }

            function historyReportNode() {
                return document.querySelector(settings.historyReportSelector);
            }

            function historyCountNodes() {
                return Array.from(document.querySelectorAll(settings.historyCountSelector));
            }

            function notificationRootNode() {
                let node = null;

                if (settings.rootId) {
                    node = document.getElementById(settings.rootId);
                }

                if (!node && settings.hostSelector) {
                    node = document.querySelector(settings.hostSelector);
                }

                return node;
            }

            function updateNotificationStackHeight() {
                const node = notificationRootNode();
                const height = node ? Math.ceil(node.getBoundingClientRect().height) : 0;

                document.documentElement.style.setProperty(
                    settings.stackHeightProperty,
                    height + "px"
                );
            }

            function scheduleNotificationStackHeightUpdate() {
                if (stackHeightAnimationFrame !== null) {
                    window.cancelAnimationFrame(stackHeightAnimationFrame);
                }

                stackHeightAnimationFrame = window.requestAnimationFrame(function () {
                    stackHeightAnimationFrame = null;
                    updateNotificationStackHeight();
                });
            }

            function setupViewportKeyboardOffset() {
                const viewport = window.visualViewport;
                let pending = false;

                function update() {
                    pending = false;

                    const layoutHeight = window.innerHeight || document.documentElement.clientHeight || 0;
                    const viewportBottom = viewport
                        ? viewport.height + viewport.offsetTop
                        : layoutHeight;
                    const offset = Math.max(0, layoutHeight - viewportBottom);

                    document.documentElement.style.setProperty(
                        settings.keyboardOffsetProperty,
                        `${Math.round(offset)}px`
                    );
                }

                function schedule() {
                    if (pending) return;

                    pending = true;
                    window.requestAnimationFrame(update);
                }

                schedule();

                if (viewport) {
                    viewport.addEventListener("resize", schedule);
                    viewport.addEventListener("scroll", schedule);
                }

                window.addEventListener("resize", schedule);
                window.addEventListener("orientationchange", schedule);

                document.addEventListener("focusin", function () {
                    window.setTimeout(schedule, 80);
                });

                document.addEventListener("focusout", function () {
                    window.setTimeout(schedule, 160);
                });
            }

            function cleanString(value) {
                if (typeof value !== "string") return null;

                const trimmed = value.trim();
                return trimmed === "" ? null : trimmed;
            }

            function normalizeType(type) {
                if (["success", "warning", "error", "loading", "info"].includes(type)) {
                    return type;
                }

                if (type === "warn") {
                    return "warning";
                }

                return "info";
            }

            function defaultDuration(type) {
                const value = settings.durations[type];

                if (Number.isFinite(value)) {
                    return Math.max(0, value);
                }

                return 0;
            }

            function defaultTitle(type) {
                return settings.copy.titles[type] || settings.copy.titles.info || "Notification";
            }

            function notificationSymbol(type) {
                return settings.copy.symbols[type] || settings.copy.symbols.info || "";
            }

            function stringifyDetails(details) {
                if (!details) return "";

                if (typeof details === "string") {
                    return details;
                }

                try {
                    return JSON.stringify(details, null, 4);
                } catch {
                    return String(details);
                }
            }

            function cloneRecord(record) {
                return {
                    id: record.id,
                    type: record.type,
                    title: record.title,
                    message: record.message,
                    source: record.source || null,
                    state: record.state,
                    createdAt: record.createdAt,
                    createdAtISO: new Date(record.createdAt).toISOString(),
                    updatedAt: record.updatedAt,
                    updatedAtISO: new Date(record.updatedAt).toISOString(),
                    page: record.page,
                    report: record.report || null,
                    details: record.details || null
                };
            }

            function rebuildRecordIndex() {
                recordIndex.clear();

                records.forEach(function (record, index) {
                    recordIndex.set(record.id, record);
                });
            }

            function pruneHistoryRecords(input) {
                const now = Date.now();
                const source = Array.isArray(input) ? input : [];

                return source
                    .filter(function (record) {
                        if (!record || typeof record !== "object") return false;
                        if (typeof record.id !== "string" || record.id.trim() === "") return false;
                        if (record.type === "loading") return false;

                        const updatedAt = Number(record.updatedAt || record.createdAt || 0);
                        if (!Number.isFinite(updatedAt) || updatedAt <= 0) return false;

                        return now - updatedAt <= historyStorage.ttlMs;
                    })
                    .sort(function (a, b) {
                        return Number(a.createdAt || 0) - Number(b.createdAt || 0);
                    })
                    .slice(-historyStorage.maxRecords);
            }

            function persistHistory() {
                try {
                    const nextRecords = pruneHistoryRecords(records);

                    if (nextRecords.length === 0) {
                        sessionStorage.removeItem(historyStorage.key);
                        return;
                    }

                    sessionStorage.setItem(historyStorage.key, JSON.stringify({
                        storedAt: Date.now(),
                        ttlMs: historyStorage.ttlMs,
                        records: nextRecords.map(cloneRecord)
                    }));
                } catch (_) {}
            }

            function loadPersistedHistory() {
                try {
                    const raw = sessionStorage.getItem(historyStorage.key);
                    if (!raw) return;

                    const parsed = JSON.parse(raw);
                    const nextRecords = pruneHistoryRecords(parsed && parsed.records);

                    records.splice(0, records.length, ...nextRecords);
                    rebuildRecordIndex();

                    if (nextRecords.length === 0) {
                        sessionStorage.removeItem(historyStorage.key);
                    }
                } catch (_) {
                    try {
                        sessionStorage.removeItem(historyStorage.key);
                    } catch (_) {}
                }
            }

            function historyObject() {
                return {
                    generatedAt: Date.now(),
                    generatedAtISO: new Date().toISOString(),
                    page: window.location.href,
                    count: records.length,
                    notifications: records.map(cloneRecord)
                };
            }

            function historyJSON() {
                return JSON.stringify(historyObject(), null, 4);
            }

            function reportHref(report, notice, options = {}) {
                const mergedReport = isPlainObject(report) ? report : {};
                const to = cleanString(mergedReport.to) || settings.report.to;
                const subject = cleanString(mergedReport.subject) || settings.report.subject;

                let body = cleanString(mergedReport.body);

                if (!body) {
                    const details = stringifyDetails(mergedReport.details || notice.details);

                    const lines = [
                        settings.copy.reportIntro,
                        "",
                        settings.copy.reportContext,
                        "",
                        settings.copy.reportSectionNotice,
                        notice.title || settings.copy.reportFallbackTitle,
                        notice.message || settings.copy.reportFallbackMessage,
                        "",
                        settings.copy.reportSectionPage,
                        window.location.href,
                        "",
                        settings.copy.reportSectionDetails,
                        details || settings.copy.reportFallbackDetails
                    ];

                    if (options.includeHistory) {
                        lines.push(
                            "",
                            settings.copy.reportSectionHistory,
                            historyJSON()
                        );
                    }

                    body = lines.join("\\n");
                } else if (options.includeHistory) {
                    body = [
                        body,
                        "",
                        settings.copy.reportSectionHistory,
                        historyJSON()
                    ].join("\\n");
                }

                return "mailto:" + encodeURIComponent(to)
                    + "?subject=" + encodeURIComponent(subject)
                    + "&body=" + encodeURIComponent(body);
            }

            function historyReportHref() {
                const lines = [
                    settings.copy.reportIntro,
                    "",
                    settings.copy.reportContext,
                    "",
                    settings.copy.reportSectionPage,
                    window.location.href,
                    "",
                    settings.copy.reportSectionHistory,
                    historyJSON()
                ];

                return "mailto:" + encodeURIComponent(settings.report.to)
                    + "?subject=" + encodeURIComponent(settings.report.subject)
                    + "&body=" + encodeURIComponent(lines.join("\\n"));
            }

            function clampProgress(value) {
                return Math.max(0, Math.min(100, value));
            }

            function normalizeOptions(options) {
                const type = normalizeType(options.type || "info");
                const persistent = options.persistent === true || type === "error" || type === "loading";
                const duration = Number.isFinite(options.duration)
                    ? Math.max(0, options.duration)
                    : defaultDuration(type);

                return {
                    id: cleanString(options.id) || nextId(),
                    type,
                    title: cleanString(options.title) || defaultTitle(type),
                    message: cleanString(options.message) || "",
                    source: cleanString(options.source) || null,
                    details: options.details || null,
                    silent: options.silent === true || options.historyOnly === true,
                    persistent,
                    duration,
                    dismissable: options.dismissable !== false && type !== "loading",
                    report: options.report || null,
                    progress: Number.isFinite(options.progress) ? clampProgress(options.progress) : null
                };
            }

            function normalizeNotifyArguments(args, forcedType) {
                let options = {};

                const first = args[0];
                const second = args[1];

                if (isPlainObject(first)) {
                    options = Object.assign({}, first);
                } else if (typeof first === "string" && isPlainObject(second)) {
                    options = Object.assign({}, second, {
                        message: first
                    });
                } else if (typeof first === "string" && typeof second === "string") {
                    options = {
                        title: first,
                        message: second
                    };
                } else if (typeof first === "string") {
                    options = {
                        message: first
                    };
                } else if (first !== undefined) {
                    options = {
                        message: String(first)
                    };
                }

                if (forcedType) {
                    options.type = forcedType;
                }

                return options;
            }

            function serializableNotice(notice) {
                return {
                    id: notice.id,
                    type: notice.type,
                    title: notice.title,
                    message: notice.message,
                    source: notice.source,
                    details: notice.details,
                    silent: notice.silent,
                    persistent: notice.persistent,
                    duration: notice.duration,
                    dismissable: notice.dismissable,
                    progress: notice.progress,
                    report: notice.report
                };
            }

            function shouldKeepRecord(notice) {
                if (notice.type === "loading" && !settings.history.includeLoading) {
                    return false;
                }

                return true;
            }

            function upsertRecord(notice, state = "active") {
                if (!shouldKeepRecord(notice)) {
                    return null;
                }

                const now = Date.now();
                let record = recordIndex.get(notice.id);

                if (!record) {
                    record = Object.assign(serializableNotice(notice), {
                        createdAt: now,
                        updatedAt: now,
                        state,
                        page: window.location.href
                    });

                    records.push(record);
                    recordIndex.set(record.id, record);

                    while (records.length > settings.history.max) {
                        const removed = records.shift();
                        if (removed) {
                            recordIndex.delete(removed.id);
                        }
                    }
                } else {
                    Object.assign(record, serializableNotice(notice), {
                        updatedAt: now,
                        state
                    });
                }

                renderHistory();
                return record;
            }

            function setRecordState(id, state) {
                const record = recordIndex.get(id);
                if (!record) return;

                record.state = state;
                record.updatedAt = Date.now();
                renderHistory();
            }

            function clearTimer(record) {
                if (record && record.timer) {
                    window.clearTimeout(record.timer);
                    record.timer = null;
                }
            }

            function schedule(record) {
                clearTimer(record);

                if (record.notice.persistent || record.notice.duration === 0) {
                    return;
                }

                record.timer = window.setTimeout(function () {
                    dismiss(record.notice.id);
                }, record.notice.duration);
            }

            function setText(node, value) {
                if (node) {
                    node.textContent = value || "";
                }
            }

            function classListForNotice(notice, node) {
                return [
                    settings.classes.notice,
                    settings.classes.notice + "--" + notice.type,
                    node.classList.contains(settings.classes.open) ? settings.classes.open : "",
                    node.classList.contains(settings.classes.leaving) ? settings.classes.leaving : ""
                ].filter(Boolean).join(" ");
            }

            function render(record) {
                const notice = record.notice;
                const node = record.node;

                const icon = node.querySelector(dataSelector("icon"));
                const title = node.querySelector(dataSelector("title"));
                const message = node.querySelector(dataSelector("message"));
                const reportHint = node.querySelector(dataSelector("reportHint"));
                const actions = node.querySelector(dataSelector("actions"));
                const close = node.querySelector(dataSelector("close"));
                const progress = node.querySelector(dataSelector("progress"));

                node.className = classListForNotice(notice, node);

                if (icon) {
                    icon.className = [
                        settings.classes.icon,
                        settings.classes.icon + "--" + notice.type
                    ].join(" ");
                    icon.textContent = notificationSymbol(notice.type);
                }

                node.setAttribute("role", notice.type === "error" ? "alert" : "status");

                setText(title, notice.title);
                setText(message, notice.message);

                if (message) {
                    message.hidden = notice.message === "";
                }

                if (actions) {
                    actions.replaceChildren();
                }

                const href = notice.report ? reportHref(notice.report, notice, { includeHistory: true }) : null;

                if (reportHint) {
                    reportHint.hidden = !href;
                    reportHint.textContent = settings.copy.reportHint;
                }

                if (href && actions) {
                    const report = document.createElement("a");
                    report.className = settings.classes.button;
                    report.href = href;
                    report.textContent = settings.copy.reportText;
                    actions.append(report);
                }

                if (actions) {
                    actions.hidden = actions.children.length === 0;
                }

                if (close) {
                    close.hidden = !notice.dismissable;
                }

                if (progress) {
                    if (notice.progress === null) {
                        progress.hidden = true;
                        progress.style.setProperty(settings.progressProperty, "0%");
                    } else {
                        progress.hidden = false;
                        progress.style.setProperty(settings.progressProperty, notice.progress + "%");
                    }
                }
            }

            function createNode(id) {
                const node = document.createElement("section");
                node.id = id;
                node.className = settings.classes.notice;

                const icon = document.createElement("span");
                icon.className = settings.classes.icon;
                icon.setAttribute(settings.data.icon, "");
                icon.setAttribute("aria-hidden", "true");

                const body = document.createElement("div");
                body.className = settings.classes.body;

                const title = document.createElement("p");
                title.className = settings.classes.title;
                title.setAttribute(settings.data.title, "");

                const message = document.createElement("p");
                message.className = settings.classes.message;
                message.setAttribute(settings.data.message, "");

                const reportHint = document.createElement("p");
                reportHint.className = settings.classes.reportHint;
                reportHint.setAttribute(settings.data.reportHint, "");
                reportHint.hidden = true;
                reportHint.textContent = settings.copy.reportHint;

                const actions = document.createElement("div");
                actions.className = settings.classes.actions;
                actions.setAttribute(settings.data.actions, "");

                const progress = document.createElement("div");
                progress.className = settings.classes.progress;
                progress.setAttribute(settings.data.progress, "");
                progress.hidden = true;

                const bar = document.createElement("span");
                bar.className = settings.classes.progressBar;
                progress.append(bar);

                const close = document.createElement("button");
                close.type = "button";
                close.className = [
                    settings.classes.button,
                    settings.classes.ghostButton
                ].join(" ");
                close.setAttribute(settings.data.close, "");
                close.setAttribute("aria-label", settings.copy.closeLabel);
                close.textContent = settings.copy.closeText;
                close.addEventListener("click", function () {
                    dismiss(id);
                });

                body.append(title, message, reportHint, actions, progress);
                node.append(icon, body, close);

                return node;
            }

            function formatTime(timestamp) {
                try {
                    return new Intl.DateTimeFormat(undefined, {
                        hour: "2-digit",
                        minute: "2-digit",
                        second: "2-digit"
                    }).format(new Date(timestamp));
                } catch {
                    return new Date(timestamp).toLocaleTimeString();
                }
            }

            function createHistoryItem(record) {
                const item = document.createElement("article");
                item.className = [
                    settings.classes.historyItem,
                    settings.classes.historyItem + "--" + record.type
                ].join(" ");

                const icon = document.createElement("span");
                icon.className = settings.classes.historyItemIcon;
                icon.textContent = notificationSymbol(record.type);
                icon.setAttribute("aria-hidden", "true");

                const body = document.createElement("div");
                body.className = settings.classes.historyItemBody;

                const head = document.createElement("div");
                head.className = settings.classes.historyItemHead;

                const title = document.createElement("p");
                title.className = settings.classes.historyItemTitle;
                title.textContent = record.title || settings.copy.reportFallbackTitle;

                const time = document.createElement("span");
                time.className = settings.classes.historyItemTime;
                time.textContent = formatTime(record.updatedAt || record.createdAt);

                head.append(title, time);

                const message = document.createElement("p");
                message.className = settings.classes.historyItemMessage;
                message.textContent = record.message || settings.copy.reportFallbackMessage;

                const meta = document.createElement("div");
                meta.className = settings.classes.historyItemMeta;

                const type = document.createElement("span");
                type.className = settings.classes.historyItemPill;
                type.textContent = record.type;

                const state = document.createElement("span");
                state.className = settings.classes.historyItemPill;
                state.textContent = record.state;

                meta.append(type, state);

                if (record.source) {
                    const source = document.createElement("span");
                    source.className = settings.classes.historyItemPill;
                    source.textContent = record.source;
                    meta.append(source);
                }

                const report = document.createElement("a");
                report.className = settings.classes.historyItemReport;
                report.href = reportHref(record.report || {}, record, { includeHistory: true });
                report.textContent = settings.copy.historyItemReportText;
                meta.append(report);

                body.append(head, message, meta);
                item.append(icon, body);

                return item;
            }

            function renderHistory() {
                const list = historyList();
                const json = historyJsonNode();
                const report = historyReportNode();
                const countNodes = historyCountNodes();

                countNodes.forEach(function (node) {
                    node.textContent = String(records.length);
                });

                if (json) {
                    json.textContent = historyJSON();
                }

                if (report) {
                    report.href = historyReportHref();
                    report.textContent = settings.copy.historyReportText;
                }

                if (!list) {
                    return;
                }

                list.replaceChildren();

                if (records.length === 0) {
                    const empty = document.createElement("div");
                    empty.className = settings.classes.historyEmpty;
                    empty.textContent = settings.copy.historyEmpty;
                    list.append(empty);
                    return;
                }

                records.slice().reverse().forEach(function (record) {
                    list.append(createHistoryItem(record));
                });
            }

            function setHistoryOpen(open) {
                historyIsOpen = open;

                const backdrop = historyBackdrop();
                const toggle = historyToggle();

                if (toggle) {
                    toggle.setAttribute("aria-expanded", String(open));
                }

                if (!backdrop) {
                    return;
                }

                window.clearTimeout(historyAnimationTimer);

                if (open) {
                    backdrop.hidden = false;
                    renderHistory();

                    window.requestAnimationFrame(function () {
                        backdrop.classList.add(settings.classes.open);
                    });

                    return;
                }

                backdrop.classList.remove(settings.classes.open);

                historyAnimationTimer = window.setTimeout(function () {
                    if (!historyIsOpen) {
                        backdrop.hidden = true;
                    }
                }, 340);
            }

            function openHistory() {
                setHistoryOpen(true);
            }

            function closeHistory() {
                setHistoryOpen(false);
            }

            function toggleHistory() {
                setHistoryOpen(!historyIsOpen);
            }

            function setupHistoryControls() {
                if (initializedHistoryControls) {
                    return;
                }

                initializedHistoryControls = true;
                loadPersistedHistory();

                const toggle = historyToggle();
                const close = document.querySelector(settings.historyCloseSelector);
                const clear = document.querySelector(settings.historyClearSelector);
                const backdrop = historyBackdrop();
                const panel = historyPanel();
                const jsonLog = document.querySelector(".\(Self.selectors.historyJSON.rawValue)");

                if (toggle) {
                    toggle.addEventListener("click", function () {
                        toggleHistory();
                    });
                }

                if (close) {
                    close.addEventListener("click", function () {
                        closeHistory();
                    });
                }

                if (clear) {
                    clear.textContent = settings.copy.historyClearText;
                    clear.addEventListener("click", function () {
                        clearHistory();
                    });
                }

                if (backdrop && panel) {
                    backdrop.addEventListener("click", function (event) {
                        if (event.target === backdrop) {
                            closeHistory();
                        }
                    });
                }

                if (jsonLog) {
                    const summary = jsonLog.querySelector("summary");
                    let jsonLogAnimationTimer = null;

                    if (summary) {
                        summary.addEventListener("click", function (event) {
                            if (!jsonLog.open || jsonLog.classList.contains("is-closing")) {
                                return;
                            }

                            event.preventDefault();
                            window.clearTimeout(jsonLogAnimationTimer);

                            jsonLog.classList.add("is-closing");

                            jsonLogAnimationTimer = window.setTimeout(function () {
                                jsonLog.open = false;
                                jsonLog.classList.remove("is-closing");
                            }, 280);
                        });
                    }
                }

                document.addEventListener("keydown", function (event) {
                    if (event.key === "Escape" && historyIsOpen) {
                        closeHistory();
                    }
                });

                renderHistory();
            }

            function show(options = {}) {
                const notice = normalizeOptions(options);

                if (notice.silent) {
                    upsertRecord(notice, "silent");
                    persistHistory();
                    return notice.id;
                }

                if (notices.has(notice.id)) {
                    return update(notice.id, notice);
                }

                upsertRecord(notice, "active");
                persistHistory();

                const node = createNode(notice.id);
                const record = {
                    node,
                    notice,
                    timer: null
                };

                notices.set(notice.id, record);
                render(record);
                root().append(node);
                scheduleNotificationStackHeightUpdate();

                window.requestAnimationFrame(function () {
                    node.classList.add(settings.classes.open);
                    scheduleNotificationStackHeightUpdate();
                });

                schedule(record);
                return notice.id;
            }

            function notify() {
                return show(normalizeNotifyArguments(Array.from(arguments), null));
            }

            function typedNotify(type, args) {
                return show(normalizeNotifyArguments(Array.from(args), type));
            }

            function update(id, options = {}) {
                const record = notices.get(id);

                if (!record) {
                    return show(Object.assign({}, options, { id }));
                }

                record.notice = normalizeOptions(Object.assign({}, record.notice, options, { id }));
                upsertRecord(record.notice, "active");
                persistHistory();

                render(record);
                schedule(record);

                return id;
            }

            function dismiss(id) {
                const record = notices.get(id);
                if (!record) return;

                clearTimer(record);
                setRecordState(id, "dismissed");
                persistHistory();

                record.node.classList.add(settings.classes.leaving);
                record.node.classList.remove(settings.classes.open);

                window.setTimeout(function () {
                    record.node.remove();
                    notices.delete(id);
                    scheduleNotificationStackHeightUpdate();
                }, 200);
            }

            function dismissAll() {
                Array.from(notices.keys()).forEach(dismiss);
            }

            function history() {
                return records.map(cloneRecord);
            }

            function clearHistory() {
                records.splice(0, records.length);
                recordIndex.clear();
                persistHistory();
                renderHistory();
            }

            setupViewportKeyboardOffset();

            if (document.readyState === "loading") {
                document.addEventListener("DOMContentLoaded", setupHistoryControls);
            } else {
                setupHistoryControls();
            }

            const api = {
                configure,

                notify,
                show,

                update,
                dismiss,
                dismissAll,

                history,
                historyJSON,
                clearHistory,

                openHistory,
                closeHistory,
                toggleHistory,

                record: function (options) {
                    return show(Object.assign({}, options || {}, { silent: true }));
                },

                silent: function (options) {
                    return show(Object.assign({}, options || {}, { silent: true }));
                },

                info: function () {
                    return typedNotify("info", arguments);
                },

                success: function () {
                    return typedNotify("success", arguments);
                },

                warn: function () {
                    return typedNotify("warning", arguments);
                },

                warning: function () {
                    return typedNotify("warning", arguments);
                },

                error: function () {
                    return typedNotify("error", arguments);
                },

                loading: function () {
                    return typedNotify("loading", arguments);
                }
            };

            window.\(model.globalName) = api;
            \(aliasesAssignment)
        }());
        """

        return JS.source(code).as_inline_script(
            .init(
                defer_loading: true
            )
        )
    }
}
