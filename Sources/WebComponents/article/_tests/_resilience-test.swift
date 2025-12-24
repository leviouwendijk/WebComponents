// UNVALIDATED CITATIONS
public enum ResiliencePillarRefs: String, Referencable {

    // Cotella et al. — corrected target (BPS Global Open Science)
    case cotella_adolescent_stress_traumatic_adult

    // Parker et al. — corrected target (Int J Behav Dev; online 2011, issue 2012)
    case parker_hpa_axis_cognitive_control_stress_inoculated_monkeys

    // “Wood 2010 … Physiology & Behavior …” — corrected to closest exact-title match (Bardi et al., Stress 2012)
    case bardi_behavioral_training_coping_styles_long_evans

    // “Simpson 2016 … BBR …” — corrected to Lambert et al. (Neuroscience 2016)
    case lambert_natural_enriched_environments_resilience

    // “Peña 2004 … BBR …” — corrected to Benaroya-Milshtein et al. (Eur J Neurosci 2004)
    case benaroya_milshtein_environmental_enrichment_decreases_anxiety

    // “Zhang 2024 … Frontiers …” — corrected to closest verified match (Caratti et al., Behav Neurosci; DOI via Semantic Scholar)
    case caratti_naturalistic_housing_resilience_rats

    // “Cirulli 2003 … BBR …” — UNRESOLVED original; closest verified substitute (Ros-Simó & Valverde 2012)
    case ros_simo_early_life_social_experiences_hpa_axis

    // “Inagaki 2010 … Physiol & Behav …” — corrected to Colnaghi et al. (PLOS ONE 2016)
    case colnaghi_social_involvement_modulates_novel_events

    // “Ribeiro 2018 … NBR …” — corrected to El Rawas et al. (Eur Neuropsychopharmacol 2020)
    case el_rawas_social_interaction_reward_resilience

    // “Jasnow 2004 … Neuroscience …” — corrected to Cooper et al. (Neuroscience 2015)
    case cooper_experience_dependent_resistance_social_stress

    public var data: ReferenceData {
        switch self {

        case .cotella_adolescent_stress_traumatic_adult:
            return .init(
                title: "Adolescent stress prevented the behavioral and neuroplastic effects of traumatic stress in adulthood",
                url: "https://doi.org/10.1016/j.bpsgos.2022.02.009",
                authorLine: "E. M. Cotella et al.",
                dateISO8601: "2022-03-08",
                doi: "10.1016/j.bpsgos.2022.02.009"
            )

        case .parker_hpa_axis_cognitive_control_stress_inoculated_monkeys:
            return .init(
                title: "Hypothalamic-pituitary-adrenal axis physiology and cognitive control of behavior in stress inoculated monkeys",
                url: "https://doi.org/10.1177/0165025411406864",
                authorLine: "K. J. Parker et al.",
                dateISO8601: "2012-01-01",
                doi: "10.1177/0165025411406864"
            )

        case .bardi_behavioral_training_coping_styles_long_evans:
            return .init(
                title: "Behavioral training and predisposed coping strategies interact to influence resilience in male Long-Evans rats: implications for depression",
                url: "https://doi.org/10.3109/10253890.2011.623739",
                authorLine: "M. Bardi et al.",
                dateISO8601: "2012-01-18", // Epub date from PubMed record
                doi: "10.3109/10253890.2011.623739"
            )

        case .lambert_natural_enriched_environments_resilience:
            return .init(
                title: "Natural-enriched environments lead to enhanced environmental engagement and altered neurobiological resilience",
                url: "https://doi.org/10.1016/j.neuroscience.2016.05.037",
                authorLine: "K. Lambert et al.",
                dateISO8601: "2016-08-25",
                doi: "10.1016/j.neuroscience.2016.05.037"
            )

        case .benaroya_milshtein_environmental_enrichment_decreases_anxiety:
            return .init(
                title: "Environmental enrichment in mice decreases anxiety, attenuates stress responses and enhances natural killer cell activity",
                url: "https://doi.org/10.1111/j.1460-9568.2004.03587.x",
                authorLine: "N. Benaroya-Milshtein et al.",
                dateISO8601: nil,
                doi: "10.1111/j.1460-9568.2004.03587.x"
            )

        case .caratti_naturalistic_housing_resilience_rats:
            return .init(
                title: "Naturalistic housing condition promotes behavioral flexibility and increases resilience to stress in rats",
                url: "https://doi.org/10.1037/bne0000597",
                authorLine: "N. Caratti et al.",
                dateISO8601: nil,
                doi: "10.1037/bne0000597"
            )

        case .ros_simo_early_life_social_experiences_hpa_axis:
            return .init(
                title: "Early-life social experiences in mice affect emotional behaviour and hypothalamic-pituitary-adrenal axis function",
                url: "https://pubmed.ncbi.nlm.nih.gov/22691868/",
                authorLine: "C. Ros-Simó, O. Valverde",
                dateISO8601: nil,
                doi: nil
            )

        case .colnaghi_social_involvement_modulates_novel_events:
            return .init(
                title: "Social involvement modulates the response to novel and adverse life events in mice",
                url: "https://doi.org/10.1371/journal.pone.0163077",
                authorLine: "V. Colnaghi et al.",
                dateISO8601: "2016-09-21",
                doi: "10.1371/journal.pone.0163077"
            )

        case .el_rawas_social_interaction_reward_resilience:
            return .init(
                title: "Social interaction reward: A resilience approach to overcome vulnerability to drugs of abuse",
                url: "https://doi.org/10.1016/j.euroneuro.2020.06.008",
                authorLine: "R. El Rawas et al.",
                dateISO8601: "2020-07-02",
                doi: "10.1016/j.euroneuro.2020.06.008"
            )

        case .cooper_experience_dependent_resistance_social_stress:
            return .init(
                title: "Neurobiological mechanisms supporting experience-dependent resistance to social stress",
                url: "https://doi.org/10.1016/j.neuroscience.2015.01.072",
                authorLine: "M. A. Cooper et al.",
                dateISO8601: "2015-02-09",
                doi: "10.1016/j.neuroscience.2015.01.072"
            )
        }
    }
}
