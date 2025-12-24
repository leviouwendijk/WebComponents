public enum _ResilienceRefs: String, Referencable {
    // Stress inoculation (control & recovery)
    case cotella_adolescent_stress_pfc
    case parker_hpa_axis_cognitive_control_stress_inoculated_monkeys
    case bardi_behavioral_training_coping_long_evans

    // Environmental enrichment & exercise
    case lambert_natural_enriched_environments_neurobiological_resilience
    case benaroya_milshtein_enrichment_decreases_anxiety_nk_activity
    case caratti_naturalistic_housing_resilience_to_stress

    // Social affiliation & social buffering
    case el_rawas_social_interaction_reward_resilience

    // Individual differences & coping styles
    case cooper_experience_dependent_resistance_to_social_stress

    // Unresolved from provided list (kept as “search URLs” so you still have a working link)
    case cirulli_early_life_social_experiences_mice
    case inagaki_social_involvement_novelty_related_stress

    public var data: ReferenceData {
        switch self {

        // =========================
        // Stress inoculation
        // =========================

        case .cotella_adolescent_stress_pfc:
            return .init(
                title: "Adolescent Stress Confers Resilience to Traumatic Stress Later in Life: Role of the Prefrontal Cortex",
                url: "https://doi.org/10.1016/j.bpsgos.2022.02.009",
                authorLine: "E M Cotella et al.",
                dateISO8601: "2022-03-08",
                doi: "10.1016/j.bpsgos.2022.02.009"
            )

        case .parker_hpa_axis_cognitive_control_stress_inoculated_monkeys:
            return .init(
                title: "Hypothalamic-pituitary-adrenal axis physiology and cognitive control of behavior in stress-inoculated monkeys",
                url: "https://pubmed.ncbi.nlm.nih.gov/24353360/",
                authorLine: "K J Parker et al.",
                dateISO8601: nil,
                doi: nil
            )

        case .bardi_behavioral_training_coping_long_evans:
            return .init(
                title: "Behavioral training and predisposed coping strategies interact to influence resilience in male Long-Evans rats: implications for depression",
                url: "https://doi.org/10.3109/10253890.2011.623739",
                authorLine: "M Bardi et al.",
                dateISO8601: "2012-01-18",
                doi: "10.3109/10253890.2011.623739"
            )

        // =========================
        // Environmental enrichment
        // =========================

        case .lambert_natural_enriched_environments_neurobiological_resilience:
            return .init(
                title: "Natural-enriched environments lead to enhanced environmental engagement and altered neurobiological resilience",
                url: "https://doi.org/10.1016/j.neuroscience.2016.05.037",
                authorLine: "K Lambert et al.",
                dateISO8601: "2016-05-26",
                doi: "10.1016/j.neuroscience.2016.05.037"
            )

        case .benaroya_milshtein_enrichment_decreases_anxiety_nk_activity:
            return .init(
                title: "Environmental enrichment in mice decreases anxiety, attenuates stress responses and enhances natural killer cell activity",
                url: "https://doi.org/10.1111/j.1460-9568.2004.03587.x",
                authorLine: "N Benaroya-Milshtein et al.",
                dateISO8601: "2004-09-01",
                doi: "10.1111/j.1460-9568.2004.03587.x"
            )

        case .caratti_naturalistic_housing_resilience_to_stress:
            return .init(
                title: "Naturalistic housing condition promotes behavioral flexibility and increases resilience to stress in rats",
                url: "https://doi.org/10.1037/bne0000597",
                authorLine: "N Caratti et al.",
                dateISO8601: "2024-04-18",
                doi: "10.1037/bne0000597"
            )

        // =========================
        // Social affiliation / buffering
        // =========================

        case .el_rawas_social_interaction_reward_resilience:
            return .init(
                title: "Social interaction reward: A resilience approach to overcome vulnerability to drugs of abuse",
                url: "https://doi.org/10.1016/j.euroneuro.2020.06.008",
                authorLine: "R El Rawas, I M Amaral, A Hofer",
                dateISO8601: nil,
                doi: "10.1016/j.euroneuro.2020.06.008"
            )

        // =========================
        // Individual differences / coping styles
        // =========================

        case .cooper_experience_dependent_resistance_to_social_stress:
            return .init(
                title: "Neurobiological mechanisms supporting experience-dependent resistance to social stress",
                url: "https://doi.org/10.1016/j.neuroscience.2015.01.072",
                authorLine: "M A Cooper, C T Clinard, K E Morrison",
                dateISO8601: "2015-02-09",
                doi: "10.1016/j.neuroscience.2015.01.072"
            )

        // =========================
        // Unresolved from provided list
        // (kept as PubMed search URLs so they’re still usable)
        // =========================

        case .cirulli_early_life_social_experiences_mice:
            return .init(
                title: "Early-life social experiences in mice affect emotionality and stress responsiveness",
                url: "https://pubmed.ncbi.nlm.nih.gov/?term=Cirulli%20Early-life%20social%20experiences%20in%20mice%20affect%20emotionality%20and%20stress%20responsiveness",
                authorLine: "F Cirulli et al.",
                dateISO8601: nil,
                doi: nil
            )

        case .inagaki_social_involvement_novelty_related_stress:
            return .init(
                title: "Social involvement modulates the response to novelty-related stress",
                url: "https://pubmed.ncbi.nlm.nih.gov/?term=%22Social%20involvement%20modulates%20the%20response%20to%20novelty-related%20stress%22",
                authorLine: "H Inagaki et al.",
                dateISO8601: nil,
                doi: nil
            )
        }
    }
}
