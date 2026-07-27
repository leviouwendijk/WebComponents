import Constructors
import CSS
import HTML

public struct RecommendedProductDetail:
    ReusableComponent,
    Sendable
{
    public enum Context:
        String,
        Sendable
    {
        case page
        case sheet
    }

    public static let block =
        "wc-product-detail"

    public let product:
        RecommendedProduct

    public let context:
        Context

    public let includeStyles:
        Bool

    public init(
        product: RecommendedProduct,
        context: Context = .page,
        includeStyles: Bool = true
    ) {
        self.product = product
        self.context = context
        self.includeStyles = includeStyles
    }

    public var nodes:
        ReusableComponentNodes
    {
        .body(
            [
                node()
            ],
            stylesheets:
                includeStyles
                    ? [
                        Self.stylesheet()
                    ]
                    : []
        )
    }

    public func node()
        -> any HTMLNode
    {
        HTML.article(
            [
                "class": [
                    Self.block,
                    "\(Self.block)--\(context.rawValue)"
                ]
                .joined(
                    separator: " "
                ),
                "data-product-detail-content":
                    product.id
            ]
        ) {
            mediaNode()

            HTML.div(
                [
                    "class":
                        "\(Self.block)__body"
                ]
            ) {
                headerNode()

                HTML.p(
                    [
                        "class":
                            "\(Self.block)__summary"
                    ]
                ) {
                    HTML.text(
                        product.summary
                    )
                }

                if let rating =
                    product.rating
                {
                    ratingNode(
                        rating
                    )
                }

                experienceNode()

                specificationNode()

                listNode(
                    title:
                        "Geschikt voor",
                    items:
                        product.suitableFor
                )

                listNode(
                    title:
                        "Minder geschikt voor",
                    items:
                        product.unsuitableFor
                )

                listNode(
                    title:
                        "Opmerkingen",
                    items:
                        product.notes
                )

                disclosuresNode()

                linksNode()
            }
        }
    }

    private func mediaNode()
        -> any HTMLNode
    {
        HTML.div(
            [
                "class":
                    "\(Self.block)__media"
            ]
        ) {
            if let image =
                product.image
            {
                HTML.img(
                    src:
                        image
                            .url
                            .absoluteString,
                    alt:
                        image.alt,
                    [
                        "class":
                            "\(Self.block)__image",
                        "loading":
                            "lazy",
                        "decoding":
                            "async"
                    ]
                )
            } else {
                HTML.div(
                    [
                        "class":
                            "\(Self.block)__image-fallback",
                        "aria-hidden":
                            "true"
                    ]
                ) {
                    HTML.text(
                        initials
                    )
                }
            }
        }
    }

    private func headerNode()
        -> any HTMLNode
    {
        HTML.header(
            [
                "class":
                    "\(Self.block)__header"
            ]
        ) {
            HTML.div(
                [
                    "class":
                        "\(Self.block)__heading"
                ]
            ) {
                if let brand =
                    product.brand,
                   !brand.isEmpty
                {
                    HTML.p(
                        [
                            "class":
                                "\(Self.block)__brand"
                        ]
                    ) {
                        HTML.text(
                            brand
                        )
                    }
                }

                HTML.h2(
                    [
                        "class":
                            "\(Self.block)__title"
                    ]
                ) {
                    HTML.text(
                        product.name
                    )
                }
            }

            HTML.span(
                [
                    "class":
                        "\(Self.block)__recommendation",
                    "data-recommendation":
                        product
                            .recommendation
                            .rawValue
                ]
            ) {
                HTML.text(
                    product
                        .recommendation
                        .label
                )
            }
        }
    }

    private func ratingNode(
        _ rating:
            RecommendedProduct.Rating
    ) -> any HTMLNode {
        HTML.section(
            [
                "class":
                    "\(Self.block)__rating",
                "aria-label":
                    rating
                        .accessibilityLabel
            ]
        ) {
            HTML.div(
                [
                    "class":
                        "\(Self.block)__rating-head"
                ]
            ) {
                HTML.span {
                    HTML.text(
                        rating.label
                    )
                }

                HTML.strong {
                    HTML.text(
                        rating.displayValue
                    )
                }
            }

            HTML.div(
                [
                    "class":
                        "\(Self.block)__rating-track",
                    "aria-hidden":
                        "true"
                ]
            ) {
                HTML.span(
                    [
                        "style":
                            "width: \(rating.percentage)%"
                    ]
                ) {}
            }

            if let rationale =
                rating.rationale,
               !rationale.isEmpty
            {
                HTML.p {
                    HTML.text(
                        rationale
                    )
                }
            }
        }
    }

    private func experienceNode()
        -> any HTMLNode
    {
        HTML.div(
            [
                "class":
                    "\(Self.block)__experience"
            ]
        ) {
            HTML.span {
                HTML.text(
                    "Ervaring"
                )
            }

            HTML.strong {
                HTML.text(
                    product
                        .experience
                        .label
                )
            }
        }
    }

    private func specificationNode()
        -> any HTMLNode
    {
        HTML.section(
            [
                "class":
                    "\(Self.block)__section"
            ]
        ) {
            HTML.h3 {
                HTML.text(
                    product
                        .specification
                        .label
                )
            }

            HTML.el(
                "dl",
                [
                    "class":
                        "\(Self.block)__facts"
                ]
            ) {
                for fact in
                    product
                        .specification
                        .rows
                {
                    HTML.div(
                        [
                            "class":
                                "\(Self.block)__fact"
                        ]
                    ) {
                        HTML.el(
                            "dt"
                        ) {
                            HTML.text(
                                fact.label
                            )
                        }

                        HTML.el(
                            "dd"
                        ) {
                            HTML.text(
                                fact.value
                            )

                            if let note =
                                fact.note,
                               !note.isEmpty
                            {
                                HTML.span(
                                    [
                                        "class":
                                            "\(Self.block)__fact-note"
                                    ]
                                ) {
                                    HTML.text(
                                        note
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func listNode(
        title: String,
        items: [String]
    ) -> any HTMLNode {
        HTML.section(
            [
                "class":
                    "\(Self.block)__section"
            ]
        ) {
            if !items.isEmpty {
                HTML.h3 {
                    HTML.text(
                        title
                    )
                }

                HTML.ul(
                    [
                        "class":
                            "\(Self.block)__list"
                    ]
                ) {
                    for item in items {
                        HTML.li {
                            HTML.text(
                                item
                            )
                        }
                    }
                }
            }
        }
    }

    private func disclosuresNode()
        -> any HTMLNode
    {
        HTML.div(
            [
                "class":
                    "\(Self.block)__disclosures"
            ]
        ) {
            for disclosure in
                disclosures
            {
                HTML.p {
                    HTML.text(
                        disclosure
                    )
                }
            }
        }
    }

    private func linksNode()
        -> any HTMLNode
    {
        HTML.footer(
            [
                "class":
                    "\(Self.block)__links",
                "aria-label":
                    "Productlinks"
            ]
        ) {
            for link in
                product.links
            {
                HTML.a(
                    link
                        .url
                        .absoluteString,
                    [
                        "class": [
                            "\(Self.block)__link",
                            "\(Self.block)__link--\(link.kind.isPrimary ? "primary" : "secondary")"
                        ]
                        .joined(
                            separator: " "
                        ),
                        "target":
                            "_blank",
                        "rel":
                            link.referral == nil
                                ? "noopener noreferrer"
                                : "noopener noreferrer sponsored",
                        "data-link-kind":
                            link
                                .kind
                                .rawValue
                    ]
                ) {
                    HTML.span(
                        [
                            "class":
                                "\(Self.block)__link-role"
                        ]
                    ) {
                        HTML.text(
                            link
                                .kind
                                .roleLabel
                        )
                    }

                    HTML.span {
                        HTML.text(
                            link.label
                        )
                    }
                }
            }
        }
    }

    private var disclosures:
        [String]
    {
        Array(
            Set(
                product
                    .links
                    .compactMap {
                        $0
                            .referral?
                            .disclosure
                    }
            )
        )
        .sorted()
    }

    private var initials:
        String
    {
        (
            product.brand
                ?? product.name
        )
        .split(
            separator: " "
        )
        .prefix(2)
        .compactMap {
            $0.first
        }
        .map(
            String.init
        )
        .joined()
        .uppercased()
    }

    public static func stylesheet()
        -> CSSStyleSheet
    {
        let root =
            ".\(block)"

        return CSSStyleSheet(
            rules: [
                CSS.rule(
                    root,
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "grid-template-columns",
                        "minmax(260px, .8fr) minmax(0, 1.2fr)"
                    ),
                    CSS.decl(
                        "width",
                        "100%"
                    ),
                    CSS.decl(
                        "max-width",
                        "1040px"
                    ),
                    CSS.decl(
                        "margin",
                        "0 auto"
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
                        "1.25rem"
                    ),
                    CSS.decl(
                        "background",
                        "var(--surface-strong, #fff)"
                    ),
                    CSS.decl(
                        "color",
                        "var(--text, #0f1720)"
                    )
                ),

                CSS.rule(
                    "\(root)__media",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "place-items",
                        "center"
                    ),
                    CSS.decl(
                        "min-height",
                        "360px"
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
                        "max-height",
                        "560px"
                    ),
                    CSS.decl(
                        "padding",
                        "1.5rem"
                    ),
                    CSS.decl(
                        "box-sizing",
                        "border-box"
                    ),
                    CSS.decl(
                        "object-fit",
                        "contain"
                    )
                ),

                CSS.rule(
                    "\(root)__image-fallback",
                    CSS.decl(
                        "font-size",
                        "clamp(2.5rem, 7vw, 5rem)"
                    ),
                    CSS.decl(
                        "font-weight",
                        "800"
                    ),
                    CSS.decl(
                        "color",
                        "var(--brand-ink, #07518c)"
                    )
                ),

                CSS.rule(
                    "\(root)__body",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "align-content",
                        "start"
                    ),
                    CSS.decl(
                        "gap",
                        "1.15rem"
                    ),
                    CSS.decl(
                        "padding",
                        "clamp(1.25rem, 4vw, 2.25rem)"
                    )
                ),

                CSS.rule(
                    "\(root)__header",
                    CSS.decl(
                        "display",
                        "flex"
                    ),
                    CSS.decl(
                        "align-items",
                        "flex-start"
                    ),
                    CSS.decl(
                        "justify-content",
                        "space-between"
                    ),
                    CSS.decl(
                        "gap",
                        "1rem"
                    )
                ),

                CSS.rule(
                    "\(root)__heading",
                    CSS.decl(
                        "min-width",
                        "0"
                    )
                ),

                CSS.rule(
                    "\(root)__brand",
                    CSS.decl(
                        "margin",
                        "0 0 .35rem"
                    ),
                    CSS.decl(
                        "font-size",
                        ".78rem"
                    ),
                    CSS.decl(
                        "font-weight",
                        "750"
                    ),
                    CSS.decl(
                        "letter-spacing",
                        ".06em"
                    ),
                    CSS.decl(
                        "text-transform",
                        "uppercase"
                    ),
                    CSS.decl(
                        "color",
                        "var(--caption-ink, #64748b)"
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
                        "clamp(1.7rem, 4vw, 2.6rem)"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.05"
                    ),
                    CSS.decl(
                        "letter-spacing",
                        "-.03em"
                    )
                ),

                CSS.rule(
                    "\(root)__recommendation",
                    CSS.decl(
                        "flex",
                        "0 0 auto"
                    ),
                    CSS.decl(
                        "padding",
                        ".45rem .65rem"
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
                        "font-size",
                        ".78rem"
                    ),
                    CSS.decl(
                        "font-weight",
                        "750"
                    )
                ),

                CSS.rule(
                    "\(root)__summary",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "font-size",
                        "1.02rem"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.65"
                    ),
                    CSS.decl(
                        "color",
                        "var(--text-muted, #475569)"
                    )
                ),

                CSS.rule(
                    "\(root)__rating",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "gap",
                        ".55rem"
                    ),
                    CSS.decl(
                        "padding",
                        "1rem"
                    ),
                    CSS.decl(
                        "border",
                        "1px solid var(--border-subtle, #d7e2ec)"
                    ),
                    CSS.decl(
                        "border-radius",
                        ".9rem"
                    ),
                    CSS.decl(
                        "background",
                        "var(--surface-soft, #eef4f8)"
                    )
                ),

                CSS.rule(
                    "\(root)__rating-head",
                    CSS.decl(
                        "display",
                        "flex"
                    ),
                    CSS.decl(
                        "align-items",
                        "baseline"
                    ),
                    CSS.decl(
                        "justify-content",
                        "space-between"
                    ),
                    CSS.decl(
                        "gap",
                        "1rem"
                    )
                ),

                CSS.rule(
                    "\(root)__rating-head span",
                    CSS.decl(
                        "font-size",
                        ".8rem"
                    ),
                    CSS.decl(
                        "font-weight",
                        "750"
                    ),
                    CSS.decl(
                        "text-transform",
                        "uppercase"
                    ),
                    CSS.decl(
                        "letter-spacing",
                        ".05em"
                    )
                ),

                CSS.rule(
                    "\(root)__rating-head strong",
                    CSS.decl(
                        "font-size",
                        "1.2rem"
                    )
                ),

                CSS.rule(
                    "\(root)__rating-track",
                    CSS.decl(
                        "height",
                        "6px"
                    ),
                    CSS.decl(
                        "overflow",
                        "hidden"
                    ),
                    CSS.decl(
                        "border-radius",
                        "999px"
                    ),
                    CSS.decl(
                        "background",
                        "color-mix(in srgb, var(--text, #0f1720) 12%, transparent)"
                    )
                ),

                CSS.rule(
                    "\(root)__rating-track span",
                    CSS.decl(
                        "display",
                        "block"
                    ),
                    CSS.decl(
                        "height",
                        "100%"
                    ),
                    CSS.decl(
                        "border-radius",
                        "inherit"
                    ),
                    CSS.decl(
                        "background",
                        "var(--accent, #0081f8)"
                    )
                ),

                CSS.rule(
                    "\(root)__rating p",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "font-size",
                        ".9rem"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.5"
                    )
                ),

                CSS.rule(
                    "\(root)__experience",
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
                        "1rem"
                    ),
                    CSS.decl(
                        "padding",
                        ".8rem 0"
                    ),
                    CSS.decl(
                        "border-top",
                        "1px solid var(--border-subtle, #d7e2ec)"
                    ),
                    CSS.decl(
                        "border-bottom",
                        "1px solid var(--border-subtle, #d7e2ec)"
                    )
                ),

                CSS.rule(
                    "\(root)__section",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "gap",
                        ".65rem"
                    )
                ),

                CSS.rule(
                    "\(root)__section:empty",
                    CSS.decl(
                        "display",
                        "none"
                    )
                ),

                CSS.rule(
                    "\(root)__section h3",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "font-size",
                        "1rem"
                    )
                ),

                CSS.rule(
                    "\(root)__facts",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "gap",
                        ".35rem"
                    ),
                    CSS.decl(
                        "margin",
                        "0"
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
                        "minmax(110px, .65fr) minmax(0, 1.35fr)"
                    ),
                    CSS.decl(
                        "gap",
                        ".75rem"
                    ),
                    CSS.decl(
                        "padding",
                        ".65rem 0"
                    ),
                    CSS.decl(
                        "border-bottom",
                        "1px solid var(--border-subtle, #d7e2ec)"
                    )
                ),

                CSS.rule(
                    "\(root)__fact dt",
                    CSS.decl(
                        "font-weight",
                        "750"
                    )
                ),

                CSS.rule(
                    "\(root)__fact dd",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.5"
                    )
                ),

                CSS.rule(
                    "\(root)__fact-note",
                    CSS.decl(
                        "display",
                        "block"
                    ),
                    CSS.decl(
                        "margin-top",
                        ".25rem"
                    ),
                    CSS.decl(
                        "font-size",
                        ".88rem"
                    ),
                    CSS.decl(
                        "color",
                        "var(--text-muted, #475569)"
                    )
                ),

                CSS.rule(
                    "\(root)__list",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "gap",
                        ".4rem"
                    ),
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "padding-left",
                        "1.2rem"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.55"
                    )
                ),

                CSS.rule(
                    "\(root)__disclosures",
                    CSS.decl(
                        "display",
                        "grid"
                    ),
                    CSS.decl(
                        "gap",
                        ".4rem"
                    )
                ),

                CSS.rule(
                    "\(root)__disclosures:empty",
                    CSS.decl(
                        "display",
                        "none"
                    )
                ),

                CSS.rule(
                    "\(root)__disclosures p",
                    CSS.decl(
                        "margin",
                        "0"
                    ),
                    CSS.decl(
                        "font-size",
                        ".82rem"
                    ),
                    CSS.decl(
                        "line-height",
                        "1.45"
                    ),
                    CSS.decl(
                        "color",
                        "var(--text-muted, #475569)"
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
                        ".65rem"
                    ),
                    CSS.decl(
                        "padding-top",
                        ".35rem"
                    )
                ),

                CSS.rule(
                    "\(root)__link",
                    CSS.decl(
                        "display",
                        "inline-flex"
                    ),
                    CSS.decl(
                        "flex-direction",
                        "column"
                    ),
                    CSS.decl(
                        "gap",
                        ".1rem"
                    ),
                    CSS.decl(
                        "padding",
                        ".65rem .85rem"
                    ),
                    CSS.decl(
                        "border",
                        "1px solid var(--border-subtle, #d7e2ec)"
                    ),
                    CSS.decl(
                        "border-radius",
                        ".7rem"
                    ),
                    CSS.decl(
                        "color",
                        "inherit"
                    ),
                    CSS.decl(
                        "text-decoration",
                        "none"
                    ),
                    CSS.decl(
                        "font-weight",
                        "700"
                    )
                ),

                CSS.rule(
                    "\(root)__link--primary",
                    CSS.decl(
                        "border-color",
                        "var(--accent, #0081f8)"
                    ),
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
                    "\(root)__link-role",
                    CSS.decl(
                        "font-size",
                        ".68rem"
                    ),
                    CSS.decl(
                        "font-weight",
                        "650"
                    ),
                    CSS.decl(
                        "opacity",
                        ".72"
                    )
                ),
            ],
            media: [
                CSS.media(
                    "(max-width: 760px)",
                    CSS.rule(
                        root,
                        CSS.decl(
                            "grid-template-columns",
                            "1fr"
                        )
                    ),
                    CSS.rule(
                        "\(root)__media",
                        CSS.decl(
                            "min-height",
                            "clamp(180px, 48vw, 260px)"
                        )
                    ),
                    CSS.rule(
                        "\(root)__header",
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
                        ),
                        CSS.decl(
                            "gap",
                            ".2rem"
                        )
                    )
                )
            ]
        )
    }
}
