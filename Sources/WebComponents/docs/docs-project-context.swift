import Constructors
import CSS
import HTML

public struct DocsProjectContextNav: SelectableComponent {
    public enum Namespace {}
    public typealias SelectorNamespace = Namespace

    public static let block = "wc-docs-project-context-nav"

    public let site: DocsSite
    public let context: DocsNavigationContext
    public let lexicon: DocsLexicon
    public let includeStyles: Bool

    public init(
        site: DocsSite,
        context: DocsNavigationContext,
        lexicon: DocsLexicon = .english,
        includeStyles: Bool = true
    ) {
        self.site = site
        self.context = context
        self.lexicon = lexicon
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        .body(
            [
                HTML.nav(
                    [
                        "class": "docs-project-context-nav \(Self.block)",
                        "aria-label": lexicon.docsContextAriaLabel
                    ]
                ) {
                    HTML.div(["class": "\(Self.block)__inner"]) {
                        breadcrumbs()

                        if site.projects.count > 1 {
                            switcher()
                        } else if let project = context.activeProject(in: site) {
                            HTML.a(
                                project.href,
                                ["class": "\(Self.block)__project-home"]
                            ) {
                                HTML.text(lexicon.projectHome)
                            }
                        }
                    }
                }
            ],
            stylesheets: includeStyles ? [Self.stylesheet()] : []
        )
    }

    private func breadcrumbs() -> any HTMLNode {
        let project = context.activeProject(in: site)
        let category = context.activeCategory(in: site)

        return HTML.div(["class": "\(Self.block)__breadcrumbs"]) {
            HTML.a(
                site.homeHref,
                ["class": "\(Self.block)__crumb"]
            ) {
                HTML.text(lexicon.allDocs)
            }

            if let project {
                separator()

                HTML.a(
                    project.href,
                    ["class": "\(Self.block)__crumb"]
                ) {
                    HTML.text(project.label)
                }
            }

            if let category {
                separator()

                HTML.a(
                    category.href,
                    [
                        "class": "\(Self.block)__crumb \(Self.block)__crumb--active",
                        "aria-current": "page"
                    ]
                ) {
                    HTML.text(category.label)
                }
            }
        }
    }

    private func separator() -> any HTMLNode {
        HTML.span(["class": "\(Self.block)__separator", "aria-hidden": "true"]) {
            HTML.text("/")
        }
    }

    private func switcher() -> any HTMLNode {
        let activeProject = context.activeProject(in: site)

        return HTML.div(["class": "\(Self.block)__switcher"]) {
            HTML.details(["class": "\(Self.block)__details"]) {
                HTML.summary(["class": "\(Self.block)__summary"]) {
                    HTML.span(["class": "\(Self.block)__summary-label"]) {
                        HTML.text(activeProject?.label ?? lexicon.projects)
                    }
                }

                HTML.div(["class": "\(Self.block)__menu"]) {
                    for project in site.projects {
                        projectLink(
                            project: project,
                            activeProjectID: activeProject?.id
                        )
                    }
                }
            }
        }
    }

    private func projectLink(
        project: DocsProject,
        activeProjectID: String?
    ) -> any HTMLNode {
        let attrs: HTMLAttribute = {
            if project.id == activeProjectID {
                return [
                    "class": "\(Self.block)__project-link \(Self.block)__project-link--active",
                    "aria-current": "page"
                ]
            }

            return [
                "class": "\(Self.block)__project-link"
            ]
        }()

        return HTML.a(
            project.href,
            attrs
        ) {
            HTML.span(["class": "\(Self.block)__project-label"]) {
                HTML.text(project.label)
            }

            HTML.span(["class": "\(Self.block)__project-description"]) {
                HTML.text(project.description)
            }
        }
    }

    public static func stylesheet() -> CSSStyleSheet {
        CSSStyleSheet(
            rules: [
                CSS.rule(
                    ".\(block)",
                    CSS.decl("position", "sticky"),
                    CSS.decl("top", "var(--wc-docs-header-height, 60px)"),
                    CSS.decl("z-index", "999"),
                    CSS.decl("height", "44px"),
                    CSS.decl("box-sizing", "border-box"),
                    CSS.decl("border-bottom", "1px solid var(--border-color)"),
                    CSS.decl("background", "var(--header-bg-color, var(--background-color))"),
                    CSS.decl("backdrop-filter", "blur(16px)")
                ),

                CSS.rule(
                    ".\(block)__inner",
                    CSS.decl("width", "min(1180px, calc(100% - 32px))"),
                    CSS.decl("height", "44px"),
                    CSS.decl("margin", "0 auto"),
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("justify-content", "space-between"),
                    CSS.decl("gap", "18px"),
                    CSS.decl("box-sizing", "border-box")
                ),

                CSS.rule(
                    ".\(block)__breadcrumbs",
                    CSS.decl("display", "flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("gap", "8px"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("font-size", ".84rem"),
                    CSS.decl("font-weight", "650")
                ),

                CSS.rule(
                    ".\(block)__crumb",
                    CSS.decl("display", "block"),
                    CSS.decl("min-width", "0"),
                    CSS.decl("max-width", "220px"),
                    CSS.decl("overflow", "hidden"),
                    CSS.decl("text-overflow", "ellipsis"),
                    CSS.decl("white-space", "nowrap"),
                    CSS.decl("color", "var(--muted-text-color)"),
                    CSS.decl("text-decoration", "none")
                ),

                // CSS.rule(
                //     ".\(block)__crumb",
                //     CSS.decl("display", "inline-flex"),
                //     CSS.decl("align-items", "center"),
                //     CSS.decl("min-width", "0"),
                //     CSS.decl("max-width", "220px"),
                //     CSS.decl("overflow", "hidden"),
                //     CSS.decl("text-overflow", "ellipsis"),
                //     CSS.decl("white-space", "nowrap"),
                //     CSS.decl("color", "var(--muted-text-color)"),
                //     CSS.decl("text-decoration", "none")
                // ),

                CSS.rule(
                    ".\(block)__crumb:hover",
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".\(block)__crumb--active",
                    CSS.decl("color", "var(--text-color)")
                ),

                CSS.rule(
                    ".\(block)__separator",
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__project-home",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("height", "30px"),
                    CSS.decl("padding", "0 10px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("text-decoration", "none"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "650")
                ),

                CSS.rule(
                    ".\(block)__project-home:hover",
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 7%, transparent)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".\(block)__switcher",
                    CSS.decl("position", "relative"),
                    CSS.decl("flex", "0 0 auto")
                ),

                CSS.rule(
                    ".\(block)__details",
                    CSS.decl("position", "relative")
                ),

                CSS.rule(
                    ".\(block)__summary",
                    CSS.decl("display", "inline-flex"),
                    CSS.decl("align-items", "center"),
                    CSS.decl("height", "30px"),
                    CSS.decl("padding", "0 10px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "999px"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("cursor", "pointer"),
                    CSS.decl("font-size", ".82rem"),
                    CSS.decl("font-weight", "650"),
                    CSS.decl("list-style", "none")
                ),

                CSS.rule(
                    ".\(block)__summary::-webkit-details-marker",
                    CSS.decl("display", "none")
                ),

                CSS.rule(
                    ".\(block)__summary::after",
                    CSS.decl("content", "\"⌄\""),
                    CSS.decl("margin-left", "8px"),
                    CSS.decl("font-size", ".72rem"),
                    CSS.decl("color", "var(--muted-text-color)")
                ),

                CSS.rule(
                    ".\(block)__menu",
                    CSS.decl("position", "absolute"),
                    CSS.decl("top", "calc(100% + 8px)"),
                    CSS.decl("right", "0"),
                    CSS.decl("z-index", "1002"),
                    CSS.decl("width", "min(360px, calc(100vw - 32px))"),
                    CSS.decl("padding", "8px"),
                    CSS.decl("border", "1px solid var(--border-color)"),
                    CSS.decl("border-radius", "16px"),
                    CSS.decl("background", "var(--surface-color, var(--background-color))"),
                    CSS.decl("box-shadow", "0 18px 44px rgba(0, 0, 0, .16)")
                ),

                CSS.rule(
                    ".\(block)__project-link",
                    CSS.decl("display", "block"),
                    CSS.decl("padding", "12px"),
                    CSS.decl("border-radius", "12px"),
                    CSS.decl("color", "var(--text-color)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".\(block)__project-link:hover",
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 7%, transparent)"),
                    CSS.decl("text-decoration", "none")
                ),

                CSS.rule(
                    ".\(block)__project-link--active",
                    CSS.decl("background", "color-mix(in srgb, var(--text-color) 9%, transparent)")
                ),

                CSS.rule(
                    ".\(block)__project-label",
                    CSS.decl("display", "block"),
                    CSS.decl("font-weight", "750"),
                    CSS.decl("line-height", "1.2")
                ),

                CSS.rule(
                    ".\(block)__project-description",
                    CSS.decl("display", "block"),
                    CSS.decl("margin-top", "4px"),
                    CSS.decl("font-size", ".78rem"),
                    CSS.decl("line-height", "1.35"),
                    CSS.decl("color", "var(--muted-text-color)")
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        ".\(block)__inner",
                        CSS.decl("width", "calc(100% - 20px)")
                    ),
                    CSS.rule(
                        ".\(block)__project-home",
                        CSS.decl("display", "none")
                    ),
                    CSS.rule(
                        ".\(block)__crumb",
                        CSS.decl("max-width", "142px")
                    )
                )
            ]
        )
    }
}
