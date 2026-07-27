import Constructors
import HTML

extension RecommendedProductCatalog {
    var allProducts:
        [RecommendedProduct]
    {
        categories.flatMap(
            \.products
        )
    }

    func interactionHost()
        -> any HTMLNode
    {
        HTML.div(
            [
                "class":
                    "\(Self.block)__interaction-host"
            ]
        ) {
            if productInteraction
                .detailSheetEnabled
            {
                HTML.el(
                    "dialog",
                    [
                        "id":
                            "\(id)-product-dialog",
                        "class":
                            "\(Self.block)__dialog",
                        "data-product-dialog":
                            id,
                        "aria-label":
                            "Productdetails"
                    ]
                ) {
                    HTML.div(
                        [
                            "class":
                                "\(Self.block)__dialog-shell",
                            "data-product-dialog-shell":
                                "true"
                        ]
                    ) {
                        HTML.div(
                            [
                                "class":
                                    "\(Self.block)__dialog-toolbar"
                            ]
                        ) {
                            HTML.button(
                                [
                                    "type":
                                        "button",
                                    "class":
                                        "\(Self.block)__dialog-close",
                                    "data-product-close":
                                        "true",
                                    "aria-label":
                                        "Sluit productdetails"
                                ]
                            ) {
                                HTML.span(
                                    [
                                        "aria-hidden":
                                            "true"
                                    ]
                                ) {
                                    HTML.text("×")
                                }

                                HTML.span {
                                    HTML.text("Sluiten")
                                }
                            }
                        }

                        HTML.div(
                            [
                                "class":
                                    "\(Self.block)__dialog-content"
                            ]
                        ) {
                            for product in
                                allProducts
                            {
                                HTML.div(
                                    [
                                        "class":
                                            "\(Self.block)__dialog-product",
                                        "data-product-panel":
                                            product.id,
                                        "hidden":
                                            "hidden"
                                    ]
                                ) {
                                    RecommendedProductDetail(
                                        product:
                                            product,
                                        context:
                                            .sheet,
                                        includeStyles:
                                            false
                                    )
                                    .node()
                                }
                            }
                        }
                    }
                }
            }

            HTML.p(
                [
                    "class":
                        "\(Self.block)__share-status",
                    "data-product-share-status":
                        id,
                    "role":
                        "status",
                    "aria-live":
                        "polite"
                ]
            ) {}
        }
    }
}
