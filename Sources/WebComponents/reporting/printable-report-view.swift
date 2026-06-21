import Constructors
import CSS
import HTML

public struct PrintableReportView: ReusableComponent, Sendable {
    public struct Bind: Sendable {
        public let source: String?
        public let collector: String?

        public init(
            source: String? = nil,
            collector: String? = nil
        ) {
            self.source = source
            self.collector = collector
        }

        public static let none = Self()

        public static func client(
            source: String? = nil,
            collector: String? = nil
        ) -> Self {
            Self(
                source: source,
                collector: collector
            )
        }
    }

    private enum ClassName {
        static let action = "wc-print-report-action"
        static let root = "wc-print-report"
        static let paper = "wc-print-report__paper"
        static let header = "wc-print-report__header"
        static let title = "wc-print-report__title"
        static let subtitle = "wc-print-report__subtitle"
        static let meta = "wc-print-report__meta"
        static let metaItem = "wc-print-report__meta-item"
        static let metaLabel = "wc-print-report__meta-label"
        static let metaValue = "wc-print-report__meta-value"
        static let section = "wc-print-report__section"
        static let sectionTitle = "wc-print-report__section-title"
        static let summary = "wc-print-report__summary"
        static let fields = "wc-print-report__fields"
        static let field = "wc-print-report__field"
        static let fieldLabel = "wc-print-report__field-label"
        static let fieldValue = "wc-print-report__field-value"
        static let fieldNote = "wc-print-report__field-note"
        static let metrics = "wc-print-report__metrics"
        static let metric = "wc-print-report__metric"
        static let metricLabel = "wc-print-report__metric-label"
        static let metricValue = "wc-print-report__metric-value"
        static let metricNote = "wc-print-report__metric-note"
        static let notice = "wc-print-report__notice"
        static let noticeTitle = "wc-print-report__notice-title"
        static let noticeText = "wc-print-report__notice-text"
        static let notes = "wc-print-report__notes"
        static let notesBox = "wc-print-report__notes-box"
        static let custom = "wc-print-report__custom"
    }

    public let report: PrintableReport
    public let bind: Bind

    public init(
        report: PrintableReport,
        bind: Bind = .none
    ) {
        self.report = report
        self.bind = bind
    }

    public var nodes: ReusableComponentNodes {
        .init(
            body: body,
            stylesheets: report.options.styles ? [Self.stylesheet()] : [],
            scripts: report.options.script ? PrintableReportScript().nodes.scripts : []
        )
    }

    public func node() -> any HTMLNode {
        reportNode()
    }

    private var body: HTMLFragment {
        var nodes: HTMLFragment = []

        if let printLabel = report.actions.printLabel, !printLabel.isEmpty {
            nodes.append(
                actionNode(label: printLabel)
            )
        }

        nodes.append(
            reportNode()
        )

        return nodes
    }

    private func actionNode(
        label: String
    ) -> any HTMLNode {
        HTML.el(
            "button",
            [
                "type": "button",
                "class": ClassName.action,
                "data-print-report-action": "print",
                "data-print-report-id": report.id
            ]
        ) {
            HTML.text(label)
        }
    }

    private func reportNode() -> any HTMLNode {
        var attrs: HTMLAttribute = [
            "id": "\(report.id)-print-report",
            "class": ClassName.root,
            "aria-hidden": "true",
            "data-print-report-root": report.id
        ]

        if let source = bind.source, !source.isEmpty {
            attrs.merge(
                [
                    "data-print-report-source": source
                ]
            )
        }

        if let collector = bind.collector, !collector.isEmpty {
            attrs.merge(
                [
                    "data-print-report-collector": collector
                ]
            )
        }

        return HTML.el(
            "section",
            attrs
        ) {
            HTML.div(
                [
                    "class": ClassName.paper
                ]
            ) {
                headerNode()

                for section in report.sections {
                    sectionNode(section)
                }
            }
        }
    }

    private func headerNode() -> any HTMLNode {
        HTML.header(
            [
                "class": ClassName.header
            ]
        ) {
            HTML.h1(
                [
                    "class": ClassName.title
                ]
            ) {
                HTML.text(report.title)
            }

            if let subtitle = report.subtitle, !subtitle.isEmpty {
                HTML.p(
                    [
                        "class": ClassName.subtitle
                    ]
                ) {
                    HTML.text(subtitle)
                }
            }

            if !report.meta.isEmpty {
                HTML.dl(
                    [
                        "class": ClassName.meta
                    ]
                ) {
                    for item in report.meta {
                        HTML.div(
                            [
                                "class": ClassName.metaItem
                            ]
                        ) {
                            HTML.dt(
                                [
                                    "class": ClassName.metaLabel
                                ]
                            ) {
                                HTML.text(item.label)
                            }

                            HTML.dd(
                                [
                                    "class": ClassName.metaValue
                                ]
                            ) {
                                valueNode(item.value)
                            }
                        }
                    }
                }
            }
        }
    }

    private func sectionNode(
        _ section: PrintableReportSection
    ) -> any HTMLNode {
        switch section {
        case .summary(let title, let text):
            return HTML.section(
                [
                    "class": "\(ClassName.section) \(ClassName.summary)"
                ]
            ) {
                titleNode(title)

                HTML.p {
                    HTML.text(text)
                }
            }

        case .fields(let title, let fields):
            return HTML.section(
                [
                    "class": "\(ClassName.section) \(ClassName.fields)"
                ]
            ) {
                titleNode(title)

                HTML.dl {
                    for field in fields {
                        fieldNode(field)
                    }
                }
            }

        case .metrics(let title, let metrics):
            return HTML.section(
                [
                    "class": "\(ClassName.section) \(ClassName.metrics)"
                ]
            ) {
                titleNode(title)

                HTML.div(
                    [
                        "class": ClassName.metrics
                    ]
                ) {
                    for metric in metrics {
                        metricNode(metric)
                    }
                }
            }

        case .notice(let notice):
            return HTML.section(
                [
                    "class": "\(ClassName.section) \(ClassName.notice) \(ClassName.notice)--\(notice.tone.rawValue)",
                    "data-print-report-notice": notice.tone.rawValue
                ]
            ) {
                HTML.h2(
                    [
                        "class": ClassName.noticeTitle
                    ]
                ) {
                    HTML.text(notice.title)
                }

                HTML.p(
                    [
                        "class": ClassName.noticeText
                    ]
                ) {
                    HTML.text(notice.text)
                }
            }

        case .notes(let title, let placeholder):
            return HTML.section(
                [
                    "class": "\(ClassName.section) \(ClassName.notes)"
                ]
            ) {
                titleNode(title)

                HTML.div(
                    [
                        "class": ClassName.notesBox
                    ]
                ) {
                    if let placeholder, !placeholder.isEmpty {
                        HTML.text(placeholder)
                    }
                }
            }

        case .html(let fragment):
            return HTML.section(
                [
                    "class": "\(ClassName.section) \(ClassName.custom)"
                ]
            ) {
                fragment
            }
        }
    }

    private func titleNode(
        _ title: String?
    ) -> any HTMLNode {
        guard let title, !title.isEmpty else {
            return HTML.blank()
        }

        return HTML.h2(
            [
                "class": ClassName.sectionTitle
            ]
        ) {
            HTML.text(title)
        }
    }

    private func fieldNode(
        _ field: PrintableReportField
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": ClassName.field
            ]
        ) {
            HTML.dt(
                [
                    "class": ClassName.fieldLabel
                ]
            ) {
                HTML.text(field.label)
            }

            HTML.dd(
                [
                    "class": ClassName.fieldValue
                ]
            ) {
                valueNode(field.value)

                if let note = field.note, !note.isEmpty {
                    HTML.div(
                        [
                            "class": ClassName.fieldNote
                        ]
                    ) {
                        HTML.text(note)
                    }
                }
            }
        }
    }

    private func metricNode(
        _ metric: PrintableReportMetric
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": ClassName.metric
            ]
        ) {
            HTML.div(
                [
                    "class": ClassName.metricLabel
                ]
            ) {
                HTML.text(metric.label)
            }

            HTML.div(
                [
                    "class": ClassName.metricValue
                ]
            ) {
                valueNode(metric.value)
            }

            if let note = metric.note, !note.isEmpty {
                HTML.div(
                    [
                        "class": ClassName.metricNote
                    ]
                ) {
                    HTML.text(note)
                }
            }
        }
    }

    private func valueNode(
        _ value: PrintableReportValue
    ) -> any HTMLNode {
        switch value {
        case .text(let text):
            return HTML.span {
                HTML.text(text)
            }

        case .slot(let key, let fallback):
            var attrs: HTMLAttribute = [
                "data-print-report-slot": key.rawValue
            ]

            if let fallback, !fallback.isEmpty {
                attrs.merge(
                    [
                        "data-print-report-fallback": fallback
                    ]
                )
            }

            return HTML.span(attrs) {
                if let fallback, !fallback.isEmpty {
                    HTML.text(fallback)
                }
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(ClassName.root)",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(ClassName.action)",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "center"),
                    CSS.decl("gap", ".45rem"),
                    CSS.decl("border", "1px solid var(--border-color, rgba(15, 23, 42, .14))"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("padding", ".65rem .95rem"),
                    CSS.decl("font", "inherit"),
                    CSS.decl("font-weight", "720"),
                    CSS.decl("line-height", "1"),
                    CSS.decl("color", "var(--text-color, #0f172a)"),
                    CSS.decl("background", "var(--surface-color, #fff)"),
                    CSS.decl("box-shadow", "0 8px 20px rgba(15, 23, 42, .08)"),
                    CSS.decl("cursor", "pointer")
                ),

                CSS.rule(
                    ".\(ClassName.action):hover",
                    CSS.decl("background", "color-mix(in srgb, var(--surface-color, #fff) 88%, var(--link-color, #2563eb) 12%)")
                ),

                CSS.rule(
                    ".\(ClassName.paper)",
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("width", "100%"),
                    CSS.decl("max-width", "780px"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("padding", "32px"),
                    CSS.decl("color", "#111827"),
                    CSS.decl("background", "#fff"),
                    CSS.decl("font-family", #""Instrument Sans", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif"#),
                    CSS.decl("line-height", "1.45")
                ),

                CSS.rule(
                    ".\(ClassName.header)",
                    CSS.decl("border-bottom", "1px solid #d1d5db"),
                    CSS.decl("padding-bottom", "18px"),
                    CSS.decl("margin-bottom", "22px")
                ),

                CSS.rule(
                    ".\(ClassName.title)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-size", "1.8rem"),
                    CSS.decl("line-height", "1.12"),
                    CSS.decl("letter-spacing", "-.02em")
                ),

                CSS.rule(
                    ".\(ClassName.subtitle)",
                    CSS.decl("margin", ".55rem 0 0"),
                    CSS.decl("max-width", "68ch"),
                    CSS.decl("color", "#4b5563")
                ),

                CSS.rule(
                    ".\(ClassName.meta)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(2, minmax(0, 1fr))"),
                    CSS.decl("gap", "8px 18px"),
                    CSS.decl("margin", "18px 0 0")
                ),

                CSS.rule(
                    ".\(ClassName.metaItem)",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "2px")
                ),

                CSS.rule(
                    ".\(ClassName.metaLabel), .\(ClassName.fieldLabel), .\(ClassName.metricLabel)",
                    CSS.decl("font-size", ".76rem"),
                    CSS.decl("font-weight", "760"),
                    CSS.decl("letter-spacing", ".04em"),
                    CSS.decl("text-transform", "uppercase"),
                    CSS.decl("color", "#6b7280")
                ),

                CSS.rule(
                    ".\(ClassName.metaValue), .\(ClassName.fieldValue), .\(ClassName.metricValue)",
                    CSS.decl("margin", "0"),
                    CSS.decl("font-weight", "680"),
                    CSS.decl("color", "#111827")
                ),

                CSS.rule(
                    ".\(ClassName.section)",
                    CSS.decl("break-inside", "avoid"),
                    CSS.decl("margin", "0 0 20px")
                ),

                CSS.rule(
                    ".\(ClassName.sectionTitle)",
                    CSS.decl("margin", "0 0 10px"),
                    CSS.decl("font-size", "1.05rem"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".\(ClassName.summary) p",
                    CSS.decl("margin", "0"),
                    CSS.decl("color", "#374151")
                ),

                CSS.rule(
                    ".\(ClassName.fields) dl",
                    CSS.decl("display", "grid"),
                    CSS.decl("gap", "10px"),
                    CSS.decl("margin", "0")
                ),

                CSS.rule(
                    ".\(ClassName.field)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "minmax(120px, .38fr) minmax(0, 1fr)"),
                    CSS.decl("gap", "12px"),
                    CSS.decl("padding", "10px 0"),
                    CSS.decl("border-bottom", "1px solid #e5e7eb")
                ),

                CSS.rule(
                    ".\(ClassName.fieldNote), .\(ClassName.metricNote)",
                    CSS.decl("margin-top", "3px"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "440"),
                    CSS.decl("color", "#6b7280")
                ),

                CSS.rule(
                    ".\(ClassName.metrics)",
                    CSS.decl("display", "grid"),
                    CSS.decl("grid-template-columns", "repeat(3, minmax(0, 1fr))"),
                    CSS.decl("gap", "10px")
                ),

                CSS.rule(
                    ".\(ClassName.metric)",
                    CSS.decl("display", "grid"),
                    CSS.decl("align-content", "start"),
                    CSS.decl("gap", "4px"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("border", "1px solid #d1d5db"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "#f9fafb")
                ),

                CSS.rule(
                    ".\(ClassName.metricValue)",
                    CSS.decl("font-size", "1.45rem"),
                    CSS.decl("line-height", "1.1")
                ),

                CSS.rule(
                    ".\(ClassName.notice)",
                    CSS.decl("padding", "14px 16px"),
                    CSS.decl("border", "1px solid #d1d5db"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("background", "#f9fafb")
                ),

                CSS.rule(
                    ".\(ClassName.notice)--warning",
                    CSS.decl("border-color", "#f2c66d"),
                    CSS.decl("background", "#fff8e1")
                ),

                CSS.rule(
                    ".\(ClassName.notice)--danger",
                    CSS.decl("border-color", "#fca5a5"),
                    CSS.decl("background", "#fef2f2")
                ),

                CSS.rule(
                    ".\(ClassName.noticeTitle)",
                    CSS.decl("margin", "0 0 4px"),
                    CSS.decl("font-size", ".96rem")
                ),

                CSS.rule(
                    ".\(ClassName.noticeText)",
                    CSS.decl("margin", "0"),
                    CSS.decl("color", "#374151")
                ),

                CSS.rule(
                    ".\(ClassName.notesBox)",
                    CSS.decl("min-height", "84px"),
                    CSS.decl("border", "1px dashed #9ca3af"),
                    CSS.decl("border-radius", "14px"),
                    CSS.decl("padding", "14px"),
                    CSS.decl("color", "#9ca3af")
                )
            ],
            media: [
                CSS.media(
                    "print",
                    CSS.rule(
                        "body.wc-print-reporting *",
                        CSS.decl("visibility", "hidden !important")
                    ),

                    CSS.rule(
                        "body.wc-print-reporting .\(ClassName.root), body.wc-print-reporting .\(ClassName.root) *",
                        CSS.decl("visibility", "visible !important")
                    ),

                    CSS.rule(
                        "body.wc-print-reporting .\(ClassName.root)",
                        CSS.decl("display", "block !important"),
                        CSS.decl("position", "absolute"),
                        CSS.decl("inset", "0 auto auto 0"),
                        CSS.decl("width", "100%"),
                        CSS.decl("background", "#fff")
                    ),

                    CSS.rule(
                        "body.wc-print-reporting .\(ClassName.action)",
                        CSS.decl("display", "none !important")
                    ),

                    CSS.rule(
                        ".\(ClassName.paper)",
                        CSS.decl("max-width", "none"),
                        CSS.decl("padding", "0"),
                        CSS.decl("-webkit-print-color-adjust", "exact"),
                        CSS.decl("print-color-adjust", "exact")
                    ),

                    CSS.rule(
                        ".\(ClassName.metrics)",
                        CSS.decl("grid-template-columns", "repeat(3, minmax(0, 1fr))")
                    )
                ),

                CSS.media(
                    "(max-width: 640px)",
                    CSS.rule(
                        ".\(ClassName.meta), .\(ClassName.metrics)",
                        CSS.decl("grid-template-columns", "1fr")
                    ),

                    CSS.rule(
                        ".\(ClassName.field)",
                        CSS.decl("grid-template-columns", "1fr"),
                        CSS.decl("gap", "4px")
                    )
                )
            ]
        )
    }
}
