import Foundation
import Constructors
import CSS
import HTML

public struct RecommendedProductCatalog:
    ReusableComponent,
    Sendable
{
    public enum Disclosure: Sendable {
        case fixed
        case collapsed
        case expanded
    }

    public struct Category: Sendable {
        public let id: String
        public let title: String
        public let summary: String?
        public let products: [RecommendedProduct]
        public let disclosure: Disclosure

        public init(
            id: String,
            title: String,
            summary: String? = nil,
            products: [RecommendedProduct],
            disclosure: Disclosure = .collapsed
        ) {
            self.id = id
            self.title = title
            self.summary = summary
            self.products = products
            self.disclosure = disclosure
        }
    }

    public static let block = "wc-product-catalog"

    public let id: String
    public let title: String
    public let intro: String?
    public let categories: [Category]
    public let specificationLimit: Int?
    public let includeNavigation: Bool
    public let includeStyles: Bool

    public init(
        id: String = "recommended-products",
        title: String = "Aanbevolen materieel",
        intro: String? = nil,
        categories: [Category],
        specificationLimit: Int? = 6,
        includeNavigation: Bool = true,
        includeStyles: Bool = true
    ) {
        self.id = id
        self.title = title
        self.intro = intro
        self.categories = categories
        self.specificationLimit = specificationLimit
        self.includeNavigation = includeNavigation
        self.includeStyles = includeStyles
    }

    public var nodes: ReusableComponentNodes {
        guard categories.contains(
            where: {
                !$0.products.isEmpty
            }
        ) else {
            return .init()
        }

        return .body(
            [
                node()
            ],
            stylesheets: includeStyles
                ? [
                    Self.stylesheet()
                ]
                : []
        )
    }

    public func node() -> any HTMLNode {
        HTML.section(
            [
                "id": id,
                "class": Self.block
            ]
        ) {
            HTML.header(
                [
                    "class": "\(Self.block)__header"
                ]
            ) {
                HTML.h2(
                    [
                        "class": "\(Self.block)__title"
                    ]
                ) {
                    HTML.text(title)
                }

                if let intro, !intro.isEmpty {
                    HTML.p(
                        [
                            "class": "\(Self.block)__intro"
                        ]
                    ) {
                        HTML.text(intro)
                    }
                }
            }

            if includeNavigation {
                navigationNode()
            }

            HTML.div(
                [
                    "class": "\(Self.block)__categories"
                ]
            ) {
                for category in categories
                where !category.products.isEmpty
                {
                    categoryNode(category)
                }
            }
        }
    }

    private func navigationNode() -> any HTMLNode {
        HTML.nav(
            [
                "class": "\(Self.block)__nav",
                "aria-label": "Categorieën materieel"
            ]
        ) {
            for category in categories
            where !category.products.isEmpty
            {
                HTML.a(
                    "#\(category.id)",
                    [
                        "class": "\(Self.block)__nav-link",
                        "aria-controls": category.id,
                        "onclick": """
                        (() => {
                            const category = document.getElementById('\(category.id)');
                            if (category?.tagName === 'DETAILS') {
                                category.open = true;
                            }
                        })();
                        """
                    ]
                ) {
                    HTML.text(category.title)

                    HTML.span {
                        HTML.text(
                            "\(category.products.count)"
                        )
                    }
                }
            }
        }
    }

    private func categoryNode(
        _ category: Category
    ) -> any HTMLNode {
        switch category.disclosure {
        case .fixed:
            return HTML.section(
                [
                    "id": category.id,
                    "class": "\(Self.block)__category"
                ]
            ) {
                categoryHeading(category)
                productGrid(category.products)
            }

        case .collapsed, .expanded:
            var attrs: HTMLAttribute = [
                "id": category.id,
                "class": [
                    "\(Self.block)__category",
                    "\(Self.block)__category--details"
                ].joined(separator: " ")
            ]

            if category.disclosure == .expanded {
                attrs.merge(
                    .bool(
                        "open",
                        true
                    )
                )
            }

            return HTML.details(attrs) {
                HTML.summary(
                    [
                        "class": "\(Self.block)__category-summary"
                    ]
                ) {
                    categoryHeading(category)

                    HTML.span(
                        [
                            "class": "\(Self.block)__marker",
                            "aria-hidden": "true"
                        ]
                    ) {}
                }

                productGrid(category.products)
            }
        }
    }

    private func categoryHeading(
        _ category: Category
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "\(Self.block)__category-heading"
            ]
        ) {
            HTML.div {
                HTML.h3(
                    [
                        "class": "\(Self.block)__category-title"
                    ]
                ) {
                    HTML.text(category.title)
                }

                if let summary = category.summary,
                   !summary.isEmpty
                {
                    HTML.p(
                        [
                            "class": "\(Self.block)__category-description"
                        ]
                    ) {
                        HTML.text(summary)
                    }
                }
            }

            HTML.span(
                [
                    "class": "\(Self.block)__category-count"
                ]
            ) {
                HTML.text(
                    category.products.count == 1
                        ? "1 product"
                        : "\(category.products.count) producten"
                )
            }
        }
    }

    private func productGrid(
        _ products: [RecommendedProduct]
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "\(Self.block)__grid"
            ]
        ) {
            for product in products {
                productCard(product)
            }
        }
    }

    private func productCard(
        _ product: RecommendedProduct
    ) -> any HTMLNode {
        let rows = specificationLimit.map {
            Array(
                product
                    .specification
                    .rows
                    .prefix(
                        max(0, $0)
                    )
            )
        } ?? product.specification.rows

        return HTML.article(
            [
                "id": product.id,
                "class": "\(Self.block)__card",
                "data-recommendation": product.recommendation.rawValue
            ]
        ) {
            HTML.div(
                [
                    "class": "\(Self.block)__media"
                ]
            ) {
                if let image = product.image {
                    HTML.img(
                        src: image.url.absoluteString,
                        alt: image.alt,
                        [
                            "class": "\(Self.block)__image",
                            "loading": "lazy",
                            "decoding": "async"
                        ]
                    )
                } else {
                    HTML.div(
                        [
                            "class": "\(Self.block)__image-fallback",
                            "aria-hidden": "true"
                        ]
                    ) {
                        HTML.text(
                            initials(product)
                        )
                    }
                }
            }

            HTML.div(
                [
                    "class": "\(Self.block)__card-body"
                ]
            ) {
                HTML.header(
                    [
                        "class": "\(Self.block)__card-header"
                    ]
                ) {
                    HTML.div {
                        if let brand = product.brand,
                           !brand.isEmpty
                        {
                            HTML.p(
                                [
                                    "class": "\(Self.block)__brand"
                                ]
                            ) {
                                HTML.text(brand)
                            }
                        }

                        HTML.h3(
                            [
                                "class": "\(Self.block)__card-title"
                            ]
                        ) {
                            HTML.text(product.name)
                        }
                    }

                    HTML.span(
                        [
                            "class": "\(Self.block)__badge",
                            "data-recommendation":
                                product.recommendation.rawValue
                        ]
                    ) {
                        HTML.text(
                            product.recommendation.label
                        )
                    }
                }

                HTML.p(
                    [
                        "class": "\(Self.block)__product-summary"
                    ]
                ) {
                    HTML.text(product.summary)
                }

                HTML.div(
                    [
                        "class": "\(Self.block)__spec-head"
                    ]
                ) {
                    HTML.h4 {
                        HTML.text(
                            product.specification.label
                        )
                    }

                    HTML.span {
                        HTML.text(
                            product.experience.label
                        )
                    }
                }

                HTML.el(
                    "dl",
                    [
                        "class": "\(Self.block)__facts"
                    ]
                ) {
                    for row in rows {
                        HTML.div(
                            [
                                "class": "\(Self.block)__fact"
                            ]
                        ) {
                            HTML.el("dt") {
                                HTML.text(row.label)
                            }

                            HTML.el("dd") {
                                HTML.text(row.value)

                                if let note = row.note,
                                   !note.isEmpty
                                {
                                    HTML.span(
                                        [
                                            "class":
                                                "\(Self.block)__fact-note"
                                        ]
                                    ) {
                                        HTML.text(note)
                                    }
                                }
                            }
                        }
                    }
                }

                list(
                    "Geschikt voor",
                    product.suitableFor
                )

                list(
                    "Minder geschikt voor",
                    product.unsuitableFor
                )

                list(
                    "Opmerkingen",
                    product.notes
                )

                for disclosure in Array(
                    Set(
                        product
                            .links
                            .compactMap(
                                \.referral?.disclosure
                            )
                    )
                ).sorted() {
                    HTML.p(
                        [
                            "class":
                                "\(Self.block)__disclosure"
                        ]
                    ) {
                        HTML.text(disclosure)
                    }
                }

                HTML.footer(
                    [
                        "class": "\(Self.block)__links",
                        "aria-label": "Productlinks"
                    ]
                ) {
                    for link in product.links {
                        HTML.a(
                            link.url.absoluteString,
                            [
                                "class": [
                                    "\(Self.block)__link",
                                    "\(Self.block)__link--\(link.kind.isPrimary ? "primary" : "secondary")"
                                ].joined(separator: " "),
                                "target": "_blank",
                                "rel": link.referral == nil
                                    ? "noopener noreferrer"
                                    : "noopener noreferrer sponsored",
                                "data-link-kind": link.kind.rawValue
                            ]
                        ) {
                            HTML.span(
                                [
                                    "class": "\(Self.block)__link-role"
                                ]
                            ) {
                                HTML.text(link.kind.roleLabel)
                            }

                            HTML.span(
                                [
                                    "class": "\(Self.block)__link-label"
                                ]
                            ) {
                                HTML.text(link.label)
                            }
                        }
                    }
                }
            }
        }
    }

    private func list(
        _ title: String,
        _ items: [String]
    ) -> any HTMLNode {
        HTML.div(
            [
                "class": "\(Self.block)__list-block"
            ]
        ) {
            if !items.isEmpty {
                HTML.h4 {
                    HTML.text(title)
                }

                HTML.ul {
                    for item in items {
                        HTML.li {
                            HTML.text(item)
                        }
                    }
                }
            }
        }
    }

    private func initials(
        _ product: RecommendedProduct
    ) -> String {
        (product.brand ?? product.name)
            .split(separator: " ")
            .prefix(2)
            .compactMap(\.first)
            .map(String.init)
            .joined()
            .uppercased()
    }

    public static func stylesheet() -> CSSStyleSheet {
        let root = ".\(block)"

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    root,
                    CSS.decl(
                        "width",
                        "min(1128px, calc(100% - 2rem))"
                    ),
                    CSS.decl(
                        "margin",
                        "0 auto"
                    ),
                    CSS.decl(
                        "padding",
                        "clamp(2rem, 5vw, 4rem) 0"
                    ),
                    CSS.decl(
                        "color",
                        "var(--text, #0f1720)"
                    )
                ),

                CSS.rule(
                    "\(root)__header",
                    CSS.decl(
                        "max-width",
                        "760px"
                    ),
                    CSS.decl(
                        "margin-bottom",
                        "1.25rem"
                    )
                ),

                CSS.rule(
                    "\(root)__title",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "font-size",
                        "clamp(2rem, 5vw, 3.5rem)"
                    )
                ),

                CSS.rule(
                    "\(root)__intro",
                    CSS.decl(
                        "line-height",
                        "1.7"
                    ),
                    CSS.decl(
                        "color",
                        "var(--text-muted, #4b5563)"
                    )
                ),

                CSS.rule(
                    "\(root)__nav",
                    CSS.decl(
                        "display",
                        "flex"
                    ),
                    CSS.decl(
                        "flex-wrap",
                        "wrap"
                    ),
                    CSS.decl(
                        "gap",
                        ".45rem"
                    ),
                    CSS.decl(
                        "margin-bottom",
                        "1rem"
                    ),
                    CSS.decl(
                        "padding",
                        ".65rem"
                    ),
                    CSS.decl(
                        "border",
                        "1px solid var(--border-subtle, #d7e2ec)"
                    ),
                    CSS.decl(
                        "border-radius",
                        "14px"
                    ),
                    CSS.decl(
                        "background",
                        "var(--surface-strong, #fff)"
                    )
                ),

                CSS.rule(
                    "\(root)__nav-link",
                    CSS.decl(
                        "display",
                        "inline-flex"
                    ),
                    CSS.decl(
                        "align-items",
                        "center"
                    ),
                    CSS.decl(
                        "flex",
                        "0 0 auto"
                    ),
                    CSS.decl(
                        "gap",
                        ".4rem"
                    ),
                    CSS.decl(
                        "padding",
                        ".45rem .7rem"
                    ),
                    CSS.decl(
                        "border-radius",
                        "999px"
                    ),
                    CSS.decl(
                        "background",
                        "var(--surface-soft, #e4edf4)"
                    ),
                    CSS.decl(
                        "color",
                        "inherit"
                    ),
                    CSS.decl(
                        "font-weight",
                        "700"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.15"
                    ),
                    CSS.decl(
                        "white-space",
                        "nowrap"
                    ),
                    CSS.decl(
                        "text-decoration",
                        "none"
                    )
                ),

                CSS.rule(
                    "\(root)__categories",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "gap",
                        "1rem"
                    )
                ),

                CSS.rule(
                    "\(root)__category",
                    CSS.decl(
                        "scroll-margin-top",
                        "150px"
                    ),
                    CSS.decl(
                        "overflow",
                        "clip"
                    ),
                    CSS.decl(
                        "border",
                        "1px solid var(--border-subtle, #d7e2ec)"
                    ),
                    CSS.decl(
                        "border-radius",
                        "16px"
                    ),
                    CSS.decl(
                        "background",
                        "var(--surface-strong, #fff)"
                    )
                ),

                CSS.rule(
                    "\(root)__category-summary",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "grid-template-columns",
                        "1fr auto"
                    ),
                    CSS.decl(
                        "align-items",
                        "center"
                    ),
                    CSS.decl(
                        "gap",
                        "1rem"
                    ),
                    CSS.decl(
                        "padding",
                        "1.1rem 1.2rem"
                    ),
                    CSS.decl(
                        "cursor",
                        "pointer"
                    ),
                    CSS.decl(
                        "list-style",
                        "none"
                    )
                ),

                CSS.rule(
                    "\(root)__category-summary::-webkit-details-marker",
                    CSS.decl(
                        "display",
                        "none"
                    )
                ),

                CSS.rule(
                    "\(root)__category-heading",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "grid-template-columns",
                        "minmax(0, 1fr) max-content"
                    ),
                    CSS.decl(
                        "align-items",
                        "start"
                    ),
                    CSS.decl(
                        "gap",
                        "1rem"
                    ),
                    CSS.decl(
                        "min-width",
                        "0"
                    )
                ),

                CSS.rule(
                    "\(root)__category-heading > div",
                    CSS.decl(
                        "min-width",
                        "0"
                    )
                ),

                CSS.rule(
                    "\(root)__category:not(.\(block)__category--details) > \(root)__category-heading",
                    CSS.decl(
                        "padding",
                        "1.1rem 1.2rem"
                    )
                ),

                CSS.rule(
                    "\(root)__category-title",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "font-size",
                        "1.35rem"
                    )
                ),

                CSS.rule(
                    "\(root)__category-description",
                    CSS.decl(
                        "margin",
                        ".25rem 0 0"
                    ),
                    CSS.decl(
                        "color",
                        "var(--text-muted, #4b5563)"
                    )
                ),

                CSS.rule(
                    "\(root)__category-count",
                    CSS.decl(
                        "display",
                        "block"
                    ),
                    CSS.decl(
                        "font-size",
                        ".78rem"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.25"
                    ),
                    CSS.decl(
                        "white-space",
                        "nowrap"
                    ),
                    CSS.decl(
                        "color",
                        "var(--caption-ink, #6b7280)"
                    )
                ),

                CSS.rule(
                    "\(root)__marker",
                    CSS.decl(
                        "width",
                        ".7rem"
                    ),
                    CSS.decl(
                        "height",
                        ".7rem"
                    ),
                    CSS.decl(
                        "border-right",
                        "2px solid currentColor"
                    ),
                    CSS.decl(
                        "border-bottom",
                        "2px solid currentColor"
                    ),
                    CSS.decl(
                        "transform",
                        "rotate(45deg)"
                    )
                ),

                CSS.rule(
                    "\(root)__category[open] > \(root)__category-summary \(root)__marker",
                    CSS.decl(
                        "transform",
                        "rotate(225deg)"
                    )
                ),

                CSS.rule(
                    "\(root)__grid",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "grid-template-columns",
                        "repeat(auto-fit, minmax(min(100%, 300px), 1fr))"
                    ),
                    CSS.decl(
                        "gap",
                        "1rem"
                    ),
                    CSS.decl(
                        "padding",
                        "1rem"
                    )
                ),

                CSS.rule(
                    "\(root)__card",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "grid-template-rows",
                        "auto 1fr"
                    ),
                    CSS.decl(
                        "overflow",
                        "hidden"
                    ),
                    CSS.decl(
                        "border",
                        "1px solid var(--border-subtle, #d7e2ec)"
                    ),
                    CSS.decl(
                        "border-radius",
                        "14px"
                    ),
                    CSS.decl(
                        "background",
                        "var(--surface-strong, #fff)"
                    ),
                    CSS.decl(
                        "box-shadow",
                        "0 10px 24px rgba(15,23,42,.08)"
                    )
                ),

                CSS.rule(
                    "\(root)__media",
                    CSS.decl(
                        "aspect-ratio",
                        "16 / 9"
                    ),
                    CSS.decl(
                        "overflow",
                        "hidden"
                    ),
                    CSS.decl(
                        "background",
                        "var(--surface-soft, #e4edf4)"
                    )
                ),

                CSS.rule(
                    "\(root)__image",
                    CSS.decl(
                        "display",
                        "block"
                    ),
                    CSS.decl(
                        "width",
                        "100%"
                    ),
                    CSS.decl(
                        "height",
                        "100%"
                    ),
                    CSS.decl(
                        "object-fit",
                        "contain"
                    ),
                    CSS.decl(
                        "background",
                        "#fff"
                    )
                ),

                CSS.rule(
                    "\(root)__image-fallback",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "place-items",
                        "center"
                    ),
                    CSS.decl(
                        "height",
                        "100%"
                    ),
                    CSS.decl(
                        "font-size",
                        "3rem"
                    ),
                    CSS.decl(
                        "font-weight",
                        "800"
                    ),
                    CSS.decl(
                        "color",
                        "var(--brand-ink, #0f4c81)"
                    )
                ),

                CSS.rule(
                    "\(root)__card-body",
                    CSS.decl(
                        "display",
                        "flex"
                    ),
                    CSS.decl(
                        "flex-direction",
                        "column"
                    ),
                    CSS.decl(
                        "gap",
                        ".9rem"
                    ),
                    CSS.decl(
                        "padding",
                        "1.1rem"
                    )
                ),

                CSS.rule(
                    "\(root)__card-header",
                    CSS.decl(
                        "display",
                        "flex"
                    ),
                    CSS.decl(
                        "justify-content",
                        "space-between"
                    ),
                    CSS.decl(
                        "gap",
                        ".8rem"
                    )
                ),

                CSS.rule(
                    "\(root)__brand",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "font-size",
                        ".75rem"
                    ),
                    CSS.decl(
                        "font-weight",
                        "800"
                    ),
                    CSS.decl(
                        "text-transform",
                        "uppercase"
                    ),
                    CSS.decl(
                        "color",
                        "var(--caption-ink, #6b7280)"
                    )
                ),

                CSS.rule(
                    "\(root)__card-title",
                    CSS.decl(
                        "margin",
                        ".15rem 0 0"
                    ),
                    CSS.decl(
                        "font-size",
                        "1.15rem"
                    )
                ),

                CSS.rule(
                    "\(root)__badge",
                    CSS.decl(
                        "height",
                        "fit-content"
                    ),
                    CSS.decl(
                        "padding",
                        ".25rem .55rem"
                    ),
                    CSS.decl(
                        "border-radius",
                        "999px"
                    ),
                    CSS.decl(
                        "font-size",
                        ".74rem"
                    ),
                    CSS.decl(
                        "font-weight",
                        "700"
                    ),
                    CSS.decl(
                        "background",
                        "var(--surface-soft, #e4edf4)"
                    )
                ),

                CSS.rule(
                    "\(root)__product-summary",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.6"
                    ),
                    CSS.decl(
                        "color",
                        "var(--text-muted, #4b5563)"
                    )
                ),

                CSS.rule(
                    "\(root)__spec-head",
                    CSS.decl(
                        "display",
                        "flex"
                    ),
                    CSS.decl(
                        "justify-content",
                        "space-between"
                    ),
                    CSS.decl(
                        "gap",
                        ".6rem"
                    )
                ),

                CSS.rule(
                    "\(root)__spec-head h4, \(root)__list-block h4",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "font-size",
                        ".84rem"
                    )
                ),

                CSS.rule(
                    "\(root)__spec-head span",
                    CSS.decl(
                        "font-size",
                        ".74rem"
                    ),
                    CSS.decl(
                        "color",
                        "var(--caption-ink, #6b7280)"
                    )
                ),

                CSS.rule(
                    "\(root)__facts",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "border",
                        "1px solid var(--border-subtle, #d7e2ec)"
                    ),
                    CSS.decl(
                        "border-radius",
                        "9px"
                    ),
                    CSS.decl(
                        "overflow",
                        "hidden"
                    )
                ),

                CSS.rule(
                    "\(root)__fact",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "grid-template-columns",
                        "minmax(100px,.8fr) 1.2fr"
                    ),
                    CSS.decl(
                        "gap",
                        ".6rem"
                    ),
                    CSS.decl(
                        "padding",
                        ".5rem .65rem"
                    ),
                    CSS.decl(
                        "border-top",
                        "1px solid var(--border-subtle, #d7e2ec)"
                    )
                ),

                CSS.rule(
                    "\(root)__fact:first-child",
                    CSS.decl(
                        "border-top",
                        "0"
                    )
                ),

                CSS.rule(
                    "\(root)__fact dt, \(root)__fact dd",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "font-size",
                        ".82rem"
                    )
                ),

                CSS.rule(
                    "\(root)__fact dt",
                    CSS.decl(
                        "font-weight",
                        "700"
                    ),
                    CSS.decl(
                        "color",
                        "var(--text-muted, #4b5563)"
                    )
                ),

                CSS.rule(
                    "\(root)__fact-note",
                    CSS.decl(
                        "display",
                        "block"
                    ),
                    CSS.decl(
                        "font-size",
                        ".74rem"
                    ),
                    CSS.decl(
                        "color",
                        "var(--caption-ink, #6b7280)"
                    )
                ),

                CSS.rule(
                    "\(root)__list-block:empty",
                    CSS.decl(
                        "display",
                        "none"
                    )
                ),

                CSS.rule(
                    "\(root)__list-block ul",
                    CSS.decl(
                        "margin",
                        ".35rem 0 0"
                    ),
                    CSS.decl(
                        "padding-left",
                        "1.1rem"
                    ),
                    CSS.decl(
                        "font-size",
                        ".82rem"
                    ),
                    CSS.decl(
                        "color",
                        "var(--text-muted, #4b5563)"
                    )
                ),

                CSS.rule(
                    "\(root)__disclosure",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "padding",
                        ".6rem .7rem"
                    ),
                    CSS.decl(
                        "border-radius",
                        "8px"
                    ),
                    CSS.decl(
                        "background",
                        "rgba(231,169,78,.12)"
                    ),
                    CSS.decl(
                        "font-size",
                        ".76rem"
                    )
                ),

                CSS.rule(
                    "\(root)__links",
                    CSS.decl(
                        "display",
                        "flex"
                    ),
                    CSS.decl(
                        "flex-wrap",
                        "wrap"
                    ),
                    CSS.decl(
                        "gap",
                        ".55rem"
                    ),
                    CSS.decl(
                        "margin-top",
                        "auto"
                    )
                ),

                CSS.rule(
                    "\(root)__link",
                    CSS.decl(
                        "padding",
                        ".6rem .85rem"
                    ),
                    CSS.decl(
                        "border-radius",
                        "999px"
                    ),
                    CSS.decl(
                        "font-size",
                        ".84rem"
                    ),
                    CSS.decl(
                        "font-weight",
                        "700"
                    ),
                    CSS.decl(
                        "text-decoration",
                        "none"
                    )
                ),

                CSS.rule(
                    "\(root)__link",
                    CSS.decl(
                        "display",
                        "inline-grid"
                    ),
                    CSS.decl(
                        "gap",
                        ".1rem"
                    )
                ),

                CSS.rule(
                    "\(root)__link-role",
                    CSS.decl(
                        "font-size",
                        ".68rem"
                    ),
                    CSS.decl(
                        "font-weight",
                        "700"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.1"
                    ),
                    CSS.decl(
                        "opacity",
                        ".72"
                    )
                ),

                CSS.rule(
                    "\(root)__link-label",
                    CSS.decl(
                        "font-size",
                        ".84rem"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.2"
                    )
                ),

                CSS.rule(
                    "\(root)__link--primary",
                    CSS.decl(
                        "background",
                        "var(--accent, #0081f8)"
                    ),
                    CSS.decl(
                        "color",
                        "#fff"
                    )
                ),

                CSS.rule(
                    "\(root)__link--secondary",
                    CSS.decl(
                        "border",
                        "1px solid var(--border-subtle, #d7e2ec)"
                    ),
                    CSS.decl(
                        "color",
                        "inherit"
                    )
                )
            ],
            media: [
                CSS.media(
                    "(max-width: 720px)",
                    CSS.rule(
                        root,
                        CSS.decl(
                            "width",
                            "min(100% - 1rem, 1128px)"
                        )
                    ),
                    CSS.rule(
                        "\(root)__nav",
                        CSS.decl(
                            "flex-wrap",
                            "nowrap"
                        ),
                        CSS.decl(
                            "overflow-x",
                            "auto"
                        ),
                        CSS.decl(
                            "overscroll-behavior-x",
                            "contain"
                        ),
                        CSS.decl(
                            "scrollbar-width",
                            "thin"
                        )
                    ),
                    CSS.rule(
                        "\(root)__grid",
                        CSS.decl(
                            "grid-template-columns",
                            "1fr"
                        ),
                        CSS.decl(
                            "padding",
                            ".75rem"
                        )
                    )
                ),

                CSS.media(
                    "(max-width: 520px)",
                    CSS.rule(
                        "\(root)__card-header",
                        CSS.decl(
                            "flex-direction",
                            "column"
                        )
                    ),
                    CSS.rule(
                        "\(root)__fact",
                        CSS.decl(
                            "grid-template-columns",
                            "1fr"
                        )
                    )
                )
            ]
        )
    }
}
