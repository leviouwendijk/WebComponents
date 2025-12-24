import Path
import HTML

public enum _ArticleResiliencePillarRefsTest {
    public static let primary: ArticleItem = ArticleItem(
        path: StandardPath(
            [
                "toepassing",
                "resilience-pillar-refs-test.html"
            ]
        ),
        title: "Resilience Pillars — Reference Mentions (Pipeline Test)",
        definition: "Testartikel: noemt alle ResiliencePillarRefs cases exact één keer, om de render + citation pipeline te valideren.",
        thumbnail_src: .init(
            "assets", "images", "test-img",
            filetype: .photo(.jpeg)
        ),
        content: {
            var nodes: [any HTMLNode] = []

            nodes.append(
                HTML.p {
                    HTML.text("Dit is een minimale testpagina om alle wetenschappelijke referenties te noemen en zo de citation/TOC/render-pipeline te testen.")
                }
            )

            nodes.append(
                HTML.h2 {
                    HTML.text("Alle referenties")
                }
            )

            // Mention every case once (stable + deterministic if your allCases order is deterministic).
            for ref in ResiliencePillarRefs.allCases {
                nodes.append(
                    HTML.p {
                        HTML.text("Cite: ")
                        HTML.cite(ref)
                    }
                )
            }

            nodes.append(
                HTML.h2 {
                    HTML.text("Alle referenties (met comment, merge-test)")
                }
            )

            // Optional: second pass with a comment to test comment aggregation/merging.
            for ref in ResiliencePillarRefs.allCases {
                nodes.append(
                    HTML.p {
                        HTML.text("Cite w/ comment: ")
                        Citation(
                            ref,
                            comment: "Mentioned in the pipeline test article."
                        )
                    }
                )
            }

            return nodes
        }
    )
}
