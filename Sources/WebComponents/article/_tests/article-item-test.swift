import Path
import HTML

public enum _ArticleTest {
    public static let primary: ArticleItem = ArticleItem(
        // path: StandardPath(
        //     [
        //         "toepassing",
        //         "primer.html"
        //     ]
        // ),
        title: "Klassiek Conditionering",
        // conditionerings-effect == een (leer-)effect in een organisme tegenover zijn omgeving -- scheppende verwachting, ofwel voorspellende werking over de omgeving, dan wel de uitkomst van eigen acties in de toekomst
        definition: "Klassieke conditionering, (ook: Pavlov-effect), is een conditionerings-effect waarbij een (neutrale) prikkel een verbintenis krijgt met een specifiek gevolg.",
        thumbnail_src: .init(
            "assets", "images", "test-img",
            filetype: .photo(.jpeg)
        ),
        content: {
            return [
                HTML.p {
                    HTML.text("Om duidelijker te begrijpen hoe gedrag totstandkomt, gebruiken we de principes van klassieke en operante conditionering. Naar deze concepten zal herhaaldelijk worden gerefereerd.")
                },


                HTML.h3 {
                    HTML.text("Associatie-principe")
                },

                HTML.p {
                    HTML.text("Klassieke conditionering is de associatie van een prikkel met een gevolg. Dit betrekt nog geen handeling. Aldus kan klassieke conditionering uitgedrukt worden in het associatie-principe: ")
                },

                HTML.img(
                    src: "/assets/images/prikkel-gevolg.png",
                    alt: "Description of Image"
                ),

                HTML.p {
                    HTML.text("Denk hierbij aan: ")
                },

                HTML.pre {
                    HTML.code {
                        HTML.text("Voedselgeur -> Eten (m)")
                    }
                },

                HTML.p {
                    HTML.text("Er bestaat een sterke koppeling tussen voedselgeur als prikkel, die de activiteit van eten aankondigt als gevolg. ")
                },

                HTML.h1 {
                    HTML.text("Koppelings-principe: ")
                },

                HTML.p {
                    HTML.text("Hoe dichter bij de 100% van de verschijningen van een ")
                    HTML.code { HTML.text("prikkel") }
                    HTML.text(", deze opgevolgd wordt door ")
                    HTML.code { HTML.text("gevolg") }
                    HTML.text(" hoe beter het associatie-principe de verwachting / anticipatie schept. ")
                },

                HTML.p {
                    HTML.text("Neem, bijvoorbeeld, uitgaande van 100% consequente uitvoering: ")
                },

                HTML.pre {
                    HTML.code {
                        HTML.text("Vingersnip -> Correctie")
                    }
                },

                HTML.p {
                    HTML.text("Indien de correctie die toegediend wordt altijd beschouwd wordt als een ")
                    HTML.code { HTML.text("demotivator") }
                    HTML.text(", zal de ")
                    HTML.code { HTML.text("vingersnip") }
                    HTML.text(" een ")
                    HTML.code { HTML.text("geconditioneerde demotivator") }
                    HTML.text(" worden. Door vervolgens correcties vooraf aan te kondigen met de ")
                    HTML.code { HTML.text("vingersnip") }
                    HTML.text(", geeft dit zeggenschap aan de hond om een de toediening van de demotivator te voorkomen, door een ongewenste gedraging op te geven. ")
                },

                HTML.h3 {
                    HTML.text("Gedragsformule")
                },

                HTML.p {
                    HTML.text("Operante conditionering voegt hier een stap aan toe: het betrekt een handeling. De uitkomst is een gevolg die afhankelijk is van welk soort keuze gemaakt wordt, in reactie op de prikkeling. ")
                },

                HTML.img(
                    src: "/assets/images/prikkel-keuze-gevolg.png",
                    alt: "Description of Image"
                ),

                HTML.p {
                    HTML.text("Eenzelfde soort voorbeeld zou zijn: ")
                },

                HTML.pre {
                    HTML.code {
                        HTML.text("Voedselgeur -> Bedelen -> Eten (m)")
                    }
                },

                HTML.div(["class": "content-div"]) { [] },

                HTML.h1 {
                    HTML.text("Test2")
                },

                HTML.img(
                    src: "/assets/images/operant-c-quadrants.png",
                    alt: "Description of Image"
                ),

                HTML.img(
                    src: "/assets/images/operant-c-positive-negative.png",
                    alt: "Description of Image"
                ),

                HTML.img(
                    src: "/assets/images/operant-c-full.png",
                    alt: "Description of Image"
                ),

                HTML.pre {
                    HTML.code {
                        HTML.text("Voedselgeur -> Bedelen -> Eten (m)\n\n-- later: (R+ : bedelen) ")
                    }
                },

                HTML.pre {
                    HTML.code {
                        HTML.text("Voedselgeur -> Nadering -> Tegen-nadering (d)\n(R- : afstand-behoud) ")
                    }
                },

                HTML.img(
                    src: "/assets/images/gedrag-drijfveer.png",
                    alt: "Description of Image"
                ),

                HTML.p {
                    HTML.text("Demotivatoren zijn afstotend, motivatoren zijn aantrekkend. ")
                },
                HTML.h3 {
                    HTML.text("Definitie")
                },

                HTML.p {
                    HTML.text("In essentie is al gedrag een handeling die ondernomen wordt om toegang tot een motivator te verkrijgen en contact met een weerzinwekker te vermijden. ")
                },

                HTML.img(
                    src: "/assets/images/1-1.jpg",
                    alt: "Description of Image"
                ),

                HTML.h3 {
                    HTML.text("TestContainerWidth")
                },

                HTML.p {
                    HTML.text("In essentie is al gedrag een handeling die ondernomen wordt om toegang tot een motivator te verkrijgen en contact met een weerzinwekker te vermijden. In essentie is al gedrag een handeling die ondernomen wordt om toegang tot een motivator te verkrijgen en contact met een weerzinwekker te vermijden. In essentie is al gedrag een handeling die ondernomen wordt om toegang tot een motivator te verkrijgen en contact met een weerzinwekker te vermijden. In essentie is al gedrag een handeling die ondernomen wordt om toegang tot een motivator te verkrijgen en contact met een weerzinwekker te vermijden. ")
                },

                // TESTS
                HTML.p {
                    HTML.text("Er bestaat een sterke koppeling tussen voedselgeur als prikkel, die de activiteit van eten aankondigt als gevolg. ")
                    HTML.cite(
                        _TestRefs.some_ref_example
                    )
                },

                HTML.p {
                    HTML.text("Hier verwijs ik er nog een keer naar, maar nu mét comment. ")
                    Citation(
                        _TestRefs.some_ref_example,
                        comment: "Used here to justify the expectancy/anticipation claim."
                    )
                },

                HTML.p {
                    HTML.text("Nogmaals dezelfde ref met een tweede comment om merge te testen. ")
                    Citation(
                        _TestRefs.some_ref_example,
                        comment: "Second mention: contrast with operant formulation."
                    )
                },

                HTML.p {
                    HTML.text("Hier nog is een citation. ")
                    Citation(
                        _TestRefs.beyond_cortisol,
                        // comment: "Second mention: contrast with operant formulation."
                    )
                },
            ]
        },
    )
}
