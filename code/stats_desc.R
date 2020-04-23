# options(download.file.method = "wget"); # For Ubuntu 14.04
package <- function(p) { 
  if (!is.element(p, installed.packages()[,1])) {
    install.packages(p); 
  }
  library(p, character.only = TRUE)
} # loads packages with automatical install if needed

package('haven')
package('plyr')
package('memisc')
package('Hmisc')
package('stringr')
package('ISOweek')
package('foreign')

Label <- function(var) {
  if (length(annotation(var))==1) { annotation(var)[1] }
  else { label(var)  }
}

decrit <- function(variable, miss = FALSE, weights = NULL) { 
  if (length(annotation(variable))>0) {
    if (!miss) {
      if (is.element("Oui", levels(as.factor(variable))) | grepl("(char)", annotation(variable)) | is.element("quotient", levels(as.factor(variable)))  | is.element("Pour", levels(as.factor(variable)))) { describe(as.factor(variable[variable!="" & !is.na(variable)]), weights = weights[variable!="" & !is.na(variable)]) }
      else { describe(as.numeric(as.vector(variable[variable!="" & !is.na(variable)])), weights = weights[variable!="" & !is.na(variable)]) }
    }
    else describe(as.factor(include.missings(variable[variable!="" & !is.na(variable)])), weights = weights[variable!="" & !is.na(variable)]) }
  else {  describe(variable[variable!=""], weights = weights[variable!=""])  }
}

relabel_and_rename_a <- function(data, original_names = FALSE, clean_vars = TRUE) {
  question_numbers <- names(data)
  
  names(data)[1] <- "id"
  label(data[[1]]) <- "id: identifiant"
  names(data)[2] <- "numero_participant_2e"
  label(data[[2]]) <- "numero_participant_2e"
  names(data)[3] <- "groupe_2e"
  label(data[[3]]) <- "groupe_2e: Groupe thématique (Se loger; Produire/travailler; Consommer; Se déplacer; Se nourrir)"
  names(data)[4] <- "date_2e"
  label(data[[4]]) <- "date_2e: Date de complétion du questionnaire"
#   names(data)[5] <- "ecole_2e"
#   label(data[[5]]) <- "ecole_2e: En pensant à l’école, avec laquelle de ces deux opinions êtes-vous le plus
# d’accord ? (L’école devrait donner avant tout le sens de la discipline et de l’effort; L’école devrait former avant tout des gens à l’esprit éveillé et critique
# ; Ne sais pas ou ne souhaite pas répondre)"
  names(data)[6] <- "ecole_2e"
  label(data[[6]]) <- "ecole_2e: En pensant à l’école, avec laquelle de ces deux opinions êtes-vous le plus d’accord ? (L’école devrait donner avant tout le sens de la discipline et de l’effort; L’école devrait former avant tout des gens à l’esprit éveillé et critique; Ne sais pas ou ne souhaite pas répondre)"
  # names(data)[7] <- "proche_de_2e"
  # label(data[[7]]) <- "proche_de_2e: Vous sentez vous particulièrement proche de... ? (même génération; genre; quartier/village; origines; convictions politiques; religion; situation économique; NSP"
  names(data)[8] <- "proche_de_2e"
  label(data[[8]]) <- "proche_de_2e: Vous sentez vous particulièrement proche de... ? (même génération; genre; quartier/village; origines; convictions politiques; religion; situation économique; NSP"
#   names(data)[9] <- "appartenance_2e"
#   label(data[[9]]) <- "appartenance_2e: Auquel de ces lieux avez-vous personnellement le sentiment d’appartenir avant
# tout ? (France; autre pays; Europe; monde; commune/quartier; département; régon; NSP)"
  names(data)[10] <- "appartenance_2e"
  label(data[[10]]) <- "appartenance_2e: Auquel de ces lieux avez-vous personnellement le sentiment d’appartenir avant tout ? (France; autre pays; Europe; monde; commune/quartier; département; régon; NSP)"
  names(data)[11] <- "mieux_informe_2e"
  label(data[[11]]) <- "mieux_informe_2e: Estimez-vous être mieux informé.e sur la vie sociale et politique que la plupart des autres personnes (0-10)"
  names(data)[12] <- "futur_perso_meilleur_2e"
  label(data[[12]]) <- "futur_perso_meilleur_2e: Pensez-vous que votre situation économique et sociale va se dégrader (0) ou s’améliorer dans les prochaines années (10) ? (0-10)"
  # names(data)[13] <- ""
  # label(data[[13]]) <- ""
  # names(data)[14] <- ""
  # label(data[[14]]) <- ""
  # names(data)[15] <- ""
  # label(data[[15]]) <- ""
  # names(data)[16] <- ""
  # label(data[[16]]) <- ""
  # names(data)[17] <- ""
  # label(data[[17]]) <- ""
  # names(data)[18] <- ""
  # label(data[[18]]) <- ""
  # names(data)[19] <- ""
  # label(data[[19]]) <- ""
  # names(data)[20] <- ""
  # label(data[[20]]) <- ""
  # names(data)[21] <- ""
  # label(data[[21]]) <- ""
  names(data)[22] <- "inegalite_repandue_2e"
  label(data[[22]]) <- "inegalite_repandue_2e: Parmi ces inégalités dans la société française, laquelle est la plus répandue ? (héritage; études; chômage; logement; genre; type d'emploi; dues aux origine; accès aux soins; revenus)"
  names(data)[23] <- "inegalite_inacceptable_2e"
  label(data[[23]]) <- "inegalite_inacceptable_2e: Parmi ces inégalités dans la société française, laquelle est la moins acceptable ? (héritage; études; chômage; logement; genre; type d'emploi; dues aux origine; accès aux soins; revenus)"
  # names(data)[24] <- ""
  # label(data[[24]]) <- ""
  names(data)[25] <- "revenu_percu_meme_2e"
  label(data[[25]]) <- "revenu_percu_meme_2e: Quelle est la rémunération nette des gens qui ont la même profession que vous ? (€/mois)"
  # names(data)[26] <- ""
  # label(data[[26]]) <- ""
  names(data)[27] <- "revenu_voulu_meme_2e"
  label(data[[27]]) <- "revenu_voulu_meme_2e: Quelle devrait être la rémunération nette moyenne des gens qui ont la même profession que vous ? (€/mois)"
  names(data)[28] <- "revenu_percu_ouvrier_2e"
  label(data[[28]]) <- "revenu_percu_ouvrier_2e: Quelle est la rémunération nette moyenne des ouvriers non qualifiés en usine ? (€/mois)"
  names(data)[29] <- "revenu_voulu_ouvrier_2e"
  label(data[[29]]) <- "revenu_voulu_ouvrier_2e: Quelle devrait être la rémunération nette moyenne des ouvriers non qualifiés en usine ? (€/mois)"
  names(data)[30] <- "revenu_percu_instituteur_2e"
  label(data[[30]]) <- "revenu_percu_instituteur_2e: Quelle est la rémunération nette moyenne des enseignants en école primaire ? (€/mois)"
  names(data)[31] <- "revenu_voulu_instituteur_2e"
  label(data[[31]]) <- "revenu_voulu_instituteur_2e: Quelle devrait être la rémunération nette moyenne des enseignants en école primaire ? (€/mois)"
  names(data)[32] <- "revenu_percu_medecin_2e"
  label(data[[32]]) <- "revenu_percu_medecin_2e: Quelle est la rémunération nette moyenne moyenne des médecins ? (€/mois)"
  names(data)[33] <- "revenu_voulu_medecin_2e"
  label(data[[33]]) <- "revenu_voulu_medecin_2e: Quelle devrait être la rémunération nette moyenne des médecins ? (€/mois)"
  names(data)[34] <- "revenu_percu_pdg_2e"
  label(data[[34]]) <- "revenu_percu_pdg_2e: Quelle est la rémunération nette moyenne des PDG de grande entreprise française ? (€/mois)"
  names(data)[35] <- "revenu_voulu_pdg_2e"
  label(data[[35]]) <- "revenu_voulu_pdg_2e: Quelle devrait être la rémunération nette moyenne des PDG de grande entreprise française ? (€/mois)"
  names(data)[36] <- "agis_monde_meilleur_2e"
  label(data[[36]]) <- "agis_monde_meilleur_2e: J’agis concrètement dans le but d’assurer un monde meilleur aux générations futures (Oui, souvent; Quelquefois; Rarement; Presque jamais)"
  names(data)[37] <- "renonce_confort_2e"
  label(data[[37]]) <- "renonce_confort_2e: Il m’arrive de renoncer à certains élémentsde confort personnel afin de faciliter la viedes générations futures (Oui, souvent; Quelquefois; Rarement; Presque jamais)"
  names(data)[38] <- "responsabilite_futur_2e"
  label(data[[38]]) <- "responsabilite_futur_2e: J’ai une responsabilité personnelle par rapport au bien-être des générations futures (Oui, souvent; Quelquefois; Rarement; Presque jamais)"
  names(data)[39] <- "responsabilite_environnement_2e"
  label(data[[39]]) <- "responsabilite_environnement_2e: J’ai une responsabilité personnelle pouraméliorer l’environnement dans lequel je vis (Oui, souvent; Quelquefois; Rarement; Presque jamais)"
  names(data)[40] <- "apres_mort_2e"
  label(data[[40]]) <- "apres_mort_2e: Je me force à faire certaines choses qui resteront après ma mort (Oui, souvent; Quelquefois; Rarement; Presque jamais)"
  names(data)[41] <- "aider_autres_2e"
  label(data[[41]]) <- "aider_autres_2e:  Il m’arrive d’aider les autres à s’améliorer (Oui, souvent; Quelquefois; Rarement; Presque jamais)"
  names(data)[42] <- "aime_enfants_2e"
  label(data[[42]]) <- "aime_enfants_2e: D’une manière générale, aimez-vous les enfants ? (Oui, j'adore ça; Oui, normalement; Pas tellement; Non)"
  # names(data)[43] <- ""
  # label(data[[43]]) <- ""
  names(data)[44] <- "pense_grands_parents_2e"
  label(data[[44]]) <- "pense_grands_parents_connus_2e: Vous arrive-t-il de penser à vos grands-parents (si vous les connaissez) ? (Oui, tous les jours; Quelquefois; Rarement; Presque jamais)"
  names(data)[45] <- "pense_grands_parents_inconnus_2e"
  label(data[[45]]) <- "pense_grands_parents_inconnus_2e: Si vous ne connaissez pas vos grands parents, vous arrive-t-il d’y penser ? (Oui, tous les jours; Quelquefois; Rarement; Presque jamais)"
  names(data)[46] <- "parents_double_vot_2ee"
  label(data[[46]]) <- "parents_double_vote_2e: Êtes-vous d’accord avec l’idée suivante : Quand on vote, les parents d’enfants qui n’ont pas encore le droit de voter par eux-mêmes devraient disposer, en plus de leur vote, d’un vote pour leurs enfants. (0-10)"
  # names(data)[47] <- ""
  # label(data[[47]]) <- ""
  names(data)[48] <- "volontaire_sacrifice_2e"
  label(data[[48]]) <- "volontaire_sacrifice_2e: Imaginez le petit scénario de science-fiction suivant : En l’an 2050, vous avez 65 ans, vous avez des petits-enfants jeunes, et vous êtes pilote d’avion. Les scientifiques annoncent qu’une météorite se dirige vers la terre. Si rien n’est fait, il y a une forte probabilité (environ une chance sur deux) pour que la terre soit heurtée dans les six mois, et donc anéantie. La solution existe : Envoyer immédiatement à la rencontre de cette météorite un énorme vaisseau spatial chargé d’explosifs qui cassera la météorite et la détournera. On demande des volontaires. On tirera au sort parmi les personnes volontaires celles qui embarqueront. Ces personnes ne reviendront pas Pouvez-vous envisager de vous porter volontaire ? (Oui, car j’ai la compétence technique et il vaut mieux sacrifier quelqu’un de mon âge; Oui, car toute personne qui a la compétence devrait dire oui; Oui, je le ferai pour mes petits-enfants; Non, car je veux voir grandir mes petits-enfants; Non, d’autres le feront et je ne veux pas me sacrifier)"
  # names(data)[49] <- ""
  # label(data[[49]]) <- ""
  # names(data)[50] <- ""
  # label(data[[50]]) <- ""
  # names(data)[51] <- ""
  # label(data[[51]]) <- ""
  # names(data)[52] <- ""
  # label(data[[52]]) <- ""
  # names(data)[53] <- ""
  # label(data[[53]]) <- ""
  # names(data)[54] <- ""
  # label(data[[54]]) <- ""
  names(data)[55] <- "inquietant_CC_premier_2e"
  label(data[[55]]) <- "inquietant_CC_premier_2e: en premier - Quels sont les aspects du changement climatique qui vous inquiètent le plus ? (L’augmentation des catastrophes naturelles (tempêtes, inondations, effondrement des côtes); Les conflits entre États; Les conflits politiques et sociaux dues aux crises alimentaires et économiques; Le développement de nouvelles maladies dans des zones auparavant épargnées; Le réchauffement des températures notamment en été; Aucun (pas de seconde réponse))"
  names(data)[56] <- "inquietant_CC_second_2e"
  label(data[[56]]) <- "inquietant_CC_second_2e: en second - Quels sont les aspects du changement climatique qui vous inquiètent le plus ? (L’augmentation des catastrophes naturelles (tempêtes, inondations, effondrement des côtes); Les conflits entre États; Les conflits politiques et sociaux dues aux crises alimentaires et économiques; Le développement de nouvelles maladies dans des zones auparavant épargnées; Le réchauffement des températures notamment en été; Aucun (pas de seconde réponse))"
  names(data)[57] <- "change_si_moderes_2e" # TODO: clean
  label(data[[57]]) <- "change_si_moderes_2e: Qu’ils restent dans des proportions modérées, je ne suis pas prêt à accepter des changements radicaux dans mon mode de vie - Conditions pour accepter changements importants dans mode de vie (proportions modérées; compensations; juste partage; décidés collectivement; acceptation inconditionnelle)"
  names(data)[58] <- "change_si_compenses_2e"
  label(data[[58]]) <- "change_si_compenses_2e: Que les inconvénients soient compensés par d’autres avantages (plus de temps libre, plus de solidarité, etc.) - Conditions pour accepter changements importants dans mode de vie (proportions modérées; compensations; juste partage; décidés collectivement; acceptation inconditionnelle)"
  names(data)[59] <- "change_si_partages_2e"
  label(data[[59]]) <- "change_si_partages_2e: Qu’ils soient partagés de façon juste entre tous les membres de notre société - Conditions pour accepter changements importants dans mode de vie (proportions modérées; compensations; juste partage; décidés collectivement; acceptation inconditionnelle)"
  names(data)[60] <- "change_si_democratie_2e"
  label(data[[60]]) <- "change_si_democratie_2e: Qu’ils soient décidés collectivement, je veux avoir mon mot à dire - Conditions pour accepter changements importants dans mode de vie (proportions modérées; compensations; juste partage; décidés collectivement; acceptation inconditionnelle)"
  names(data)[61] <- "change_sans_condition_2e"
  label(data[[61]]) <- "change_sans_condition_2e: Je les accepterais dans tous les cas - Conditions pour accepter changements importants dans mode de vie (proportions modérées; compensations; juste partage; décidés collectivement; acceptation inconditionnelle)"
  names(data)[62] <- "pour_taxe_dividende_cible_2e"
  label(data[[62]]) <- "pour_taxe_dividende_cible_2e: Un versement pour les 50% de Français les plus modestes (ceux gagnant moins de 1670€/mois) - Acceptation d'une augmentation de la taxe carbone si les recettes étaient utilisées pour financer ... (0-10)"
  names(data)[63] <- "pour_taxe_dividende_tous_2e"
  label(data[[63]]) <- "pour_taxe_dividende_tous_2e: Un versement à tous les Français - Acceptation d'une augmentation de la taxe carbone si les recettes étaient utilisées pour financer ... (0-10)"
  names(data)[64] <- "pour_taxe_compensation_2e"
  label(data[[64]]) <- "pour_taxe_compensation_2e: Une compensation pour les ménages contraints dans leur consommation d’énergie (carburant, gaz, fioul) - Acceptation d'une augmentation de la taxe carbone si les recettes étaient utilisées pour financer ... (0-10)"
  names(data)[65] <- "pour_taxe_baisse_cotsoc_2e"
  label(data[[65]]) <- "pour_taxe_baisse_cotsoc_2e: Une baisse des cotisations sociales - Acceptation d'une augmentation de la taxe carbone si les recettes étaient utilisées pour financer ... (0-10)"
  names(data)[66] <- "pour_taxe_baisse_tva_2e"
  label(data[[66]]) <- "pour_taxe_baisse_tva_2e: Une baisse de la TVA - Acceptation d'une augmentation de la taxe carbone si les recettes étaient utilisées pour financer ... (0-10)"
  names(data)[67] <- "pour_taxe_baisse_deficit_2e"
  label(data[[67]]) <- "pour_taxe_baisse_deficit_2e: Une baisse du déficit public - Acceptation d'une augmentation de la taxe carbone si les recettes étaient utilisées pour financer ... (0-10)"
  names(data)[68] <- "pour_taxe_renovation_2e"
  label(data[[68]]) <- "pour_taxe_renovation_2e: La rénovation thermique des bâtiments - Acceptation d'une augmentation de la taxe carbone si les recettes étaient utilisées pour financer ... (0-10)"
  names(data)[69] <- "pour_taxe_renouvelables_2e"
  label(data[[69]]) <- "pour_taxe_renouvelables_2e: Des énergies renouvelables (éoliennes, solaire, etc.) - Acceptation d'une augmentation de la taxe carbone si les recettes étaient utilisées pour financer ... (0-10)"
  names(data)[70] <- "pour_taxe_transports_2e"
  label(data[[70]]) <- "pour_taxe_transports_2e: Des transports non polluants - Acceptation d'une augmentation de la taxe carbone si les recettes étaient utilisées pour financer ... (0-10)"
  names(data)[71] <- "taxe_affecte_personne_2e"
  label(data[[71]]) <- "taxe_affecte_personne_2e: Personne - Est-ce que les catégories suivantes perdrait ou gagnerait en pouvoir d'achat suite à une carbone avec dividende ?"
  # names(data)[72] <- "taxe_affecte__2e"
  # label(data[[72]]) <- "taxe_affecte__2e"
  names(data)[73] <- "taxe_affecte_pauvres_2e"
  label(data[[73]]) <- "taxe_affecte_pauvres_2e: Les plus pauvres - Est-ce que les catégories suivantes perdrait ou gagnerait en pouvoir d'achat suite à une carbone avec dividende ?"
  names(data)[74] <- "taxe_affecte_moyennes_2e"
  label(data[[74]]) <- "taxe_affecte_moyennes_2e: Les classes moyennes - Est-ce que les catégories suivantes perdrait ou gagnerait en pouvoir d'achat suite à une carbone avec dividende ?"
  names(data)[75] <- "taxe_affecte_riches_2e"
  label(data[[75]]) <- "taxe_affecte_riches_2e: Les plus riches - Est-ce que les catégories suivantes perdrait ou gagnerait en pouvoir d'achat suite à une carbone avec dividende ?"
  names(data)[76] <- "taxe_affecte_tous_2e"
  label(data[[76]]) <- "taxe_affecte_tous_2e: Tous les Français - Est-ce que les catégories suivantes perdrait ou gagnerait en pouvoir d'achat suite à une carbone avec dividende ?"
  names(data)[77] <- "taxe_affecte_ruraux_2e"
  label(data[[77]]) <- "taxe_affecte_ruraux_2e: Les ruraux ou péri-urbains - Est-ce que les catégories suivantes perdrait ou gagnerait en pouvoir d'achat suite à une carbone avec dividende ?"
  names(data)[78] <- "taxe_affecte_certains_2e"
  label(data[[78]]) <- "taxe_affecte_certains_2e: Certains Français mais pas une catégorie de revenus particulière - Est-ce que les catégories suivantes perdrait ou gagnerait en pouvoir d'achat suite à une carbone avec dividende ?"
  # names(data)[79] <- ""
  # label(data[[79]]) <- ""
  names(data)[80] <- "taxe_affecte_nsp_2e"
  label(data[[80]]) <- "taxe_affecte_nsp_2e: Ne sais pas, ne se prononce pas - Est-ce que les catégories suivantes perdrait ou gagnerait en pouvoir d'achat suite à une carbone avec dividende ?"
  names(data)[81] <- "lutte_CC_affecte_perso_2e"
  label(data[[81]]) <- "lutte_CC_affecte_perso_2e: Pensez-vous que les futures politiques climatiques vous demanderont de faire plus d’efforts qu’à la moyenne des Français ? (Oui, beaucoup; un peu plus; Autant; Non, un peu; beaucoup moins; NSP)"
  # names(data)[82] <- ""
  # label(data[[82]]) <- ""
  names(data)[83] <- "CC_affecte_perso_2e"
  label(data[[83]]) <- "CC_affecte_perso_2e: Pensez-vous que vous serez personnellement plus impacté par le changement climatique que la moyenne des français de votre génération ? (Oui, beaucoup; un peu plus; Autant; Non, un peu; beaucoup moins; NSP)"
  names(data)[84] <- "commentaires_2e"
  label(data[[84]]) <- "commentaires_2e: Notes inscrites sur le questionnaire"
  names(data)[85] <- "numero_participant_1e"
  label(data[[85]]) <- "numero_participant_1e"
  names(data)[86] <- "date_1e"
  label(data[[86]]) <- "date_1e: Date de complétion du questionnaire"
  # names(data)[87] <- ""
  # label(data[[87]]) <- ""
  names(data)[88] <- "taille_agglo_1e"
  label(data[[88]]) <- "taille_agglo_1e: Vous habitez (à la campagne; dans une grande; petite ville; dans la banlieue d'une grande ville)"
  names(data)[89] <- "statut_logement_1e"
  label(data[[89]]) <- "statut_logement_1e: Dans votre commune, êtes-vous ? (Locataire; Propriétaire de votre logement; Hébergé·e par votre famille ou des amis; Autre situation)"
  names(data)[90] <- "situation_revenus_1e"
  label(data[[90]]) <- "situation_revenus_1e: Comment vous en sortez-vous avec les revenus de votre ménage ? (Très; Plutôt difficilement; Plutôt; Très facilement)"
  names(data)[91] <- "confiance_gens_1e"
  label(data[[91]]) <- "confiance_gens_1e: D’une manière générale, diriez-vous que... ? (On peut faire confiance à la plupart des gens; On n’est jamais assez prudent quand on a affaire aux autres)"
  names(data)[92] <- "nb_enfants_1e"
  label(data[[92]]) <- "nb_enfants_1e: Avez-vous des enfants ? Si oui, combien (Non, 1-9)"
  # names(data)[93] <- ""
  # label(data[[93]]) <- ""
  names(data)[94] <- "nb_petits_enfants_1e"
  label(data[[94]]) <- "nb_enfants_1e: Avez-vous des petits-enfants ? Si oui, combien (Non, 1-9)"
  names(data)[95] <- "tirage_sort_1e"
  label(data[[95]]) <- "tirage_sort_1e: Au moment de commencer cette Convention citoyenne, quel est votre niveau de confiance dans la capacité de citoyens tirés au sort à délibérer de manière productive sur des questions politiques complexes ? (Pas du tout; Plutôt; Plutôt pas; Tout à fait confiance)"
  names(data)[96] <- "satisfaction_vie_1e"
  label(data[[96]]) <- "satisfaction_vie_1e: Dans quelle mesure êtes-vous satisfait·e de la vie que vous menez ? (0-10)"
  names(data)[97] <- "qualite_enfant_1e"
  label(data[[97]]) <- "qualite_enfant_1e: Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  names(data)[98] <- "qualite_enfant_independance_1e"
  label(data[[98]]) <- "qualite_enfant_independance_1e: l'indépendance - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  names(data)[99] <- "qualite_enfant_tolerance_1e"
  label(data[[99]]) <- "qualite_enfant_tolerance_1e: la tolérance et le respect des autres - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  names(data)[100] <- "qualite_enfant_generosite_1e"
  label(data[[100]]) <- "qualite_enfant_generosite_1e: la générosité - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  names(data)[101] <- "qualite_enfant_travail_1e"
  label(data[[101]]) <- "qualite_enfant_travail_1e: l'assiduité au travail - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  names(data)[102] <- "qualite_enfant_epargne_1e"
  label(data[[102]]) <- "qualite_enfant_epargne_1e: le sens de l'épargne - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  names(data)[103] <- "qualite_enfant_obeissance_1e"
  label(data[[103]]) <- "qualite_enfant_obeissance_1e: l'obéissance - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  names(data)[104] <- "qualite_enfant_responsabilite_1e"
  label(data[[104]]) <- "qualite_enfant_responsabilite_1e: la responsabilité - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  names(data)[105] <- "qualite_enfant_determination_1e"
  label(data[[105]]) <- "qualite_enfant_determination_1e: la détermination et la persévérance - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  names(data)[106] <- "qualite_enfant_expression_1e"
  label(data[[106]]) <- "qualite_enfant_expression_1e: l'expression personnelle - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  names(data)[107] <- "qualite_enfant_imagination_1e"
  label(data[[107]]) <- "qualite_enfant_imagination_1e: l'imagination - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  names(data)[108] <- "qualite_enfant_foi_1e"
  label(data[[108]]) <- "qualite_enfant_foi_1e: la foi religieuse - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  names(data)[109] <- "redistribution_1e" 
  label(data[[109]]) <- "redistribution_1e: Que pensez-vous de l’affirmation suivante : « Pour établir la justice sociale, il faudrait prendre aux riches pour donner aux pauvres » ? (0-10)"
  # names(data)[110] <- ""
  # label(data[[110]]) <- ""
  names(data)[111] <- "problemes_invisibilises_1e"
  label(data[[111]]) <- "problemes_invisibilises_1e: Avez-vous le sentiment d’être confronté·e personnellement à des difficultés importantes que les pouvoirs publics ou les médias ne voient pas vraiment ? (Très; Assez; Peu souvent; Jamais)"
  # names(data)[112] <- ""
  # label(data[[112]]) <- ""
  names(data)[113] <- "cause_pauvrete_1e"
  label(data[[113]]) <- "cause_pauvrete_1e: Entre les deux raisons suivantes, quelle est celle qui, selon vous, explique le mieux que certaines personnes vivent dans la pauvreté ? (C'est plutôt parce qu'elles n'ont pas eu de chance; C'est plutôt parce qu'elles n'ont pas fait d'effort pour s'en sortir; NSP)"
  names(data)[114] <- "importance_environnement_1e"
  label(data[[114]]) <- "importance_environnement_1e: La protection de l'environnement - À quel point est-ce important pour vous ? (0-10)"
  names(data)[115] <- "importance_associatif_1e"
  label(data[[115]]) <- "importance_associatif_1e:  L’action sociale et associative - À quel point est-ce important pour vous ? (0-10)"
  names(data)[116] <- "importance_confort_1e"
  label(data[[116]]) <- "importance_confort_1e: L’amélioration de mon niveau de vie et de confort - À quel point est-ce important pour vous ? (0-10)"
  # names(data)[117] <- ""
  # label(data[[117]]) <- ""
  names(data)[118] <- "cause_CC_1e"
  label(data[[118]]) <- "cause_CC_1e: Pensez-vous que le changement climatique est dû à (Uniquement à des processus naturels; Uniquement à l'activité humaine; Principalement à des processus naturels; Principalement à l'activité humaine; Autant à des processus naturels qu'à l'activité humaine; Je ne pense pas qu'il y ait un changement climatique; NSP)"
  names(data)[119] <- "quand_preoccupation_CC_1e"
  label(data[[119]]) <- "quand_preoccupation_CC_1e: À quelle date approximative, vous êtes-vous senti·e· préoccupé·e par le problème du changement climatique ? (Je ne suis pas préoccupé·e par le problème du changement climatique; Je suis préoccupé·e par le problème du changement climatique depuis toujours; Je suis préoccupé·e par le problème du changement climatique depuis ... )"
  names(data)[120] <- "date_preoccupation_CC_1e"
  label(data[[120]]) <- "date_preoccupation_CC_1e: année - À quelle date approximative, vous êtes-vous senti·e· préoccupé·e par le problème du changement climatique ? (Je ne suis pas préoccupé·e par le problème du changement climatique; Je suis préoccupé·e par le problème du changement climatique depuis toujours; Je suis préoccupé·e par le problème du changement climatique depuis ... )"
  # names(data)[121] <- ""
  # label(data[[121]]) <- ""
  names(data)[122] <- "cause_catastrophes_1e"
  label(data[[122]]) <- "cause_catastrophes_1e: De ces trois opinions, laquelle se rapproche le plus de la vôtre ? (Les désordres du climat et leurs conséquences sont causés par le changement climatique; sont des phénomènes naturels comme il y en a toujours eu; Aujourd'hui, personne ne peut dire avec certitude les vraies raisons des désordres du climat)"
  # names(data)[123] <- ""
  # label(data[[123]]) <- ""
  names(data)[124] <- "solution_CC_1e"
  label(data[[124]]) <- "solution_CC_1e: De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable)"
  # names(data)[125] <- ""
  # label(data[[125]]) <- ""
  names(data)[126] <- "effets_CC_1e"
  label(data[[126]]) <- "effets_CC_1e: Si le changement climatique continue, à votre avis, quelles seront les conséquences en France d'ici une cinquantaine d'années ? (Les conditions de vie deviendront extrêmement pénibles à cause des dérèglements climatiques; Il y aura des modifications de climat mais on s'y adaptera sans trop de mal; Le changement climatique aura des effets positifs pour l'agriculture et les loisirs)"
  names(data)[127] <- "issue_CC_1e"
  label(data[[127]]) <- "issue_CC_1e: Pensez-vous que le changement climatique sera limité à des niveaux acceptables d’ici la fin du siècle  (Oui, certainement; probablement; Non, probablement; certainement pas)"
  names(data)[128] <- "agis_CC_tri_1e"
  label(data[[128]]) <- "agis_CC_tri_1e: Trier les déchets - Action de réduction des émissions de GES accomplie (Vous le faites déjà; Vous pourriez le faire assez facilement; Vous pourriez le faire mais difficilement; Vous ne pouvez pas le faire)"
  names(data)[129] <- "agis_CC_eteindre_1e"
  label(data[[129]]) <- "agis_CC_eteindre_1e: Éteindre les appareils électriques qui restent en veille - Action de réduction des émissions de GES accomplie (Vous le faites déjà; Vous pourriez le faire assez facilement; Vous pourriez le faire mais difficilement; Vous ne pouvez pas le faire)"
  names(data)[130] <- "agis_CC_transports_1e"
  label(data[[130]]) <- "agis_CC_transports_1e: Utiliser les transports en commun plutôt que la voiture - Action de réduction des émissions de GES accomplie (Vous le faites déjà; Vous pourriez le faire assez facilement; Vous pourriez le faire mais difficilement; Vous ne pouvez pas le faire)"
  # names(data)[131] <- ""
  # label(data[[131]]) <- ""
  names(data)[132] <- "agis_CC_temperature_1e"
  label(data[[132]]) <- "agis_CC_temperature_1e: Baisser la température de son logement de 2 ou 3 degrés l’hiver - Action de réduction des émissions de GES accomplie (Vous le faites déjà; Vous pourriez le faire assez facilement; Vous pourriez le faire mais difficilement; Vous ne pouvez pas le faire)"
  names(data)[133] <- "agis_CC_de_saison_1e"
  label(data[[133]]) <- "agis_CC_de_saison_1e: Veiller à acheter des légumes de saison - Action de réduction des émissions de GES accomplie (Vous le faites déjà; Vous pourriez le faire assez facilement; Vous pourriez le faire mais difficilement; Vous ne pouvez pas le faire)"
  # names(data)[134] <- ""
  # label(data[[134]]) <- ""
  names(data)[135] <- "agis_CC_viande_1e"
  label(data[[135]]) <- "agis_CC_viande_1e: Limiter la consommation de viande de son foyer - Action de réduction des émissions de GES accomplie (Vous le faites déjà; Vous pourriez le faire assez facilement; Vous pourriez le faire mais difficilement; Vous ne pouvez pas le faire)"
  names(data)[136] <- "agis_CC_pied_velo_1e"
  label(data[[136]]) <- "agis_CC_pied_velo_1e: Se déplacer en vélo ou à pied plutôt qu’en voiture - Action de réduction des émissions de GES accomplie (Vous le faites déjà; Vous pourriez le faire assez facilement; Vous pourriez le faire mais difficilement; Vous ne pouvez pas le faire)"
  names(data)[137] <- "agis_CC_covoiturage_1e"
  label(data[[137]]) <- "agis_CC_covoiturage_1e: Faire du co-voiturage ou de l’auto-partage - Action de réduction des émissions de GES accomplie (Vous le faites déjà; Vous pourriez le faire assez facilement; Vous pourriez le faire mais difficilement; Vous ne pouvez pas le faire)"
  # names(data)[138] <- ""
  # label(data[[138]]) <- ""
  names(data)[139] <- "agis_CC_emballage_1e"
  label(data[[139]]) <- "agis_CC_emballage_1e: Choisir des produits avec peu d’emballage - Action de réduction des émissions de GES accomplie (Vous le faites déjà; Vous pourriez le faire assez facilement; Vous pourriez le faire mais difficilement; Vous ne pouvez pas le faire)"
  names(data)[140] <- "agis_CC_conso_mieux_1e"
  label(data[[140]]) <- "agis_CC_conso_mieux_1e: Choisir des produits ayant moins d’impact sur l’environnement - Action de réduction des émissions de GES accomplie (Vous le faites déjà; Vous pourriez le faire assez facilement; Vous pourriez le faire mais difficilement; Vous ne pouvez pas le faire)"
  names(data)[141] <- "agis_CC_conso_moins_1e"
  label(data[[141]]) <- "agis_CC_conso_moins_1e: Consommer moins - Action de réduction des émissions de GES accomplie (Vous le faites déjà; Vous pourriez le faire assez facilement; Vous pourriez le faire mais difficilement; Vous ne pouvez pas le faire)"
  names(data)[142] <- "agis_CC_chauffage_1e"
  label(data[[142]]) <- "agis_CC_chauffage_1e: Couper son chauffage et son chauffe-eau en cas d’absence prolongé - Action de réduction des émissions de GES accomplie (Vous le faites déjà; Vous pourriez le faire assez facilement; Vous pourriez le faire mais difficilement; Vous ne pouvez pas le faire)"
  # names(data)[143] <- ""
  # label(data[[143]]) <- ""
  names(data)[144] <- "agis_CC_avion_1e"
  label(data[[144]]) <- "agis_CC_avion_1e: Ne plus prendre l’avion pour ses loisirs - Action de réduction des émissions de GES accomplie (Vous le faites déjà; Vous pourriez le faire assez facilement; Vous pourriez le faire mais difficilement; Vous ne pouvez pas le faire)"
  # names(data)[145] <- ""
  # label(data[[145]]) <- ""
  names(data)[146] <- "echelle_politique_CC_1e"
  label(data[[146]]) <- "echelle_politique_CC_1e: Pensez-vous que le changement climatique exige d’être pris en charge par des politiques publiques ... (Nationales; Mondiales; Européennes; Locales; À toutes les échelles)"
  names(data)[147] <- "pour_vitesse_110_1e"
  label(data[[147]]) <- "pour_vitesse_110_1e: Abaisser la vitesse limite sur autoroute à 110 km/heure - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  names(data)[148] <- "pour_taxe_avions_1e"
  label(data[[148]]) <- "pour_taxe_avions_1e: Taxer le transport aérien pour favoriser le transport par train - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  names(data)[149] <- "pour_obligation_renovation_1e"
  label(data[[149]]) <- "pour_obligation_renovation_1e: Obliger les propriétaires à rénover et à isoler les logements lors d’une vente ou d’une location - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  names(data)[150] <- "pour_compteurs_intelligents_1e"
  label(data[[150]]) <- "pour_compteurs_intelligents_1e:  Installer dans les foyers des compteurs électriques qui analysent les consommations pour permettre aux gens des faire des économies d’énergie - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  # names(data)[151] <- ""
  # label(data[[151]]) <- ""
  names(data)[152] <- "pour_taxe_distance_1e"
  label(data[[152]]) <- "pour_taxe_distance_1e: Augmenter le prix des produits de consommation qui sont acheminés par des modes de transport polluants - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  # names(data)[153] <- ""
  # label(data[[153]]) <- ""
  names(data)[154] <- "pour_taxe_carbone_1e"
  label(data[[154]]) <- "pour_taxe_carbone_1e: Augmenter la taxe carbone - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  names(data)[155] <- "pour_renouvelables_1e"
  label(data[[155]]) <- "pour_renouvelables_1e: Développer les énergies renouvelables même si, dans certains cas, les coûts de production sont plus élevés, pour le moment - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  names(data)[156] <- "pour_densification_1e"
  label(data[[156]]) <- "pour_densification_1e: Densifier les villes en limitant l’habitat pavillonnaire au profit d’immeubles collectifs - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  names(data)[157] <- "pour_taxe_vehicules_1e"
  label(data[[157]]) <- "pour_taxe_vehicules_1e: Taxer les véhicules les plus émetteurs de gaz à effet de serre - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  # names(data)[158] <- ""
  # label(data[[158]]) <- ""
  names(data)[159] <- "pour_voies_reservees_1e"
  label(data[[159]]) <- "pour_voies_reservees_1e: Favoriser l’usage (voies de circulation, place de stationnement réservées) des véhicules peu polluants ou partagés (covoiturage) - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  names(data)[160] <- "pour_cantines_vertes_1e"
  label(data[[160]]) <- "pour_cantines_vertes_1e: Obliger la restauration collective publique à proposer une offre de menu végétarien, biologique et/ou de saiso - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  names(data)[161] <- "pour_fin_gaspillage_1e"
  label(data[[161]]) <- "pour_fin_gaspillage_1e: Réduire le gaspillage alimentaire de moitié - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  names(data)[162] <- "France_CC_1e"
  label(data[[162]]) <- "France_CC_1e: Pensez-vous que la France doit prendre de l’avance sur d’autres pays dans la lutte contre le changement climatique ? (Oui; Non; NSP)"
  names(data)[163] <- "obstacles_lobbies_1e"
  label(data[[163]]) <- "obstacles_lobbies_1e: Les lobbies - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  names(data)[164] <- "obstacles_manque_volonte_1e"
  label(data[[164]]) <- "obstacles_manque_volonte_1e: Le manque de volonté politique - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  names(data)[165] <- "obstacles_manque_cooperation_1e"
  label(data[[165]]) <- "obstacles_manque_cooperation_1e: Le manque de coopération entre pays - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  names(data)[166] <- "obstacles_inegalites_1e"
  label(data[[166]]) <- "obstacles_inegalites_1e: Les inégalités - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  names(data)[167] <- "obstacles_incertitudes_1e"
  label(data[[167]]) <- "obstacles_incertitudes_1e: Les incertitudes de la communauté scientifique - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  names(data)[168] <- "obstacles_demographie_1e" 
  label(data[[168]]) <- "obstacles_demographie_1e: La démographie - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  names(data)[169] <- "obstacles_technologies_1e"
  label(data[[169]]) <- "obstacles_technologies_1e: Le manque de technologies alternatives - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  names(data)[170] <- "obstacles_rien_1e"
  label(data[[170]]) <- "obstacles_rien_1e: Rien de tout cela - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  names(data)[171] <- "numero_participant_1s"
  label(data[[171]]) <- "numero_participant_1s"
  names(data)[172] <- "date_1s"
  label(data[[172]]) <- "date_1s: Date de complétion du questionnaire"
  names(data)[173] <- "role_deliberation_1s"
  label(data[[173]]) <- "role_deliberation_1s: Laquelle des propositions suivantes décrit le mieux votre rôle dans les délibérations ? (Je parlais en mon nom propre; Je parlais en mon nom propre et au nom des gens qui me ressemblent; Je parlais au nom d’autres groupes et intérêts particulier; Je parlais au nom de causes particulières qui me sont chères; Je parlais au nom du public dans son ensemble)"
  names(data)[174] <- "pourquoi_nom_propre_1s"
  label(data[[174]]) <- "pourquoi_nom_propre_1s: Si vous parliez seulement en votre nom propre, pourquoi le faisiez-vous ? (Je n’étais pas assez informé·e pour; Je ne pensais pas que c’était mon rôle de; Je ne me sentais pas autorisé·e à parler au nom d’autres gens; Autre raison (merci de préciser))"
  names(data)[175] <- "pourquoi_nom_propre_autre_1s"
  label(data[[175]]) <- "pourquoi_nom_propre_autre_1s: Autre raison (champ libre) - Si vous parliez seulement en votre nom propre, pourquoi le faisiez-vous ? (Je n’étais pas assez informé·e pour; Je ne pensais pas que c’était mon rôle de; Je ne me sentais pas autorisé·e à parler au nom d’autres gens; Autre raison (merci de préciser))"
  names(data)[176] <- "pourquoi_pour_autres_1s"
  label(data[[176]]) <- "pourquoi_pour_autres_1s: Si vous parliez au nom d’autres gens, pouvez-vous préciser de qui il s’agissait"
  names(data)[177] <- "pourquoi_cause_1s"
  label(data[[177]]) <- "pourquoi_cause_1s: Si vous parliez au nom de causes particulières (environnement, générations futures, etc.), pouvez-vous préciser de quelles causes il s’agissait"
  names(data)[178] <- "role_autres_1s"
  label(data[[178]]) <- "role_autres_1s: En ce qui concerne les autres participants, quelle proposition décrit le mieux la nature de leur participation ? (La majorité des autres participants parlaient juste en leur nom propre; en leur nom propre et au nom de gens qui leur ressemblent; au nom d’autres groupes et intérêts particuliers; au nom de causes particulières;  au nom du public dans son ensemble)"
  names(data)[179] <- "expression_libre_1s"
  label(data[[179]]) <- "expression_libre_1s: Ce que chacun·e ressentait autour de la table pouvait être exprimé librement, sans que l’on ait peur d'être jugé·e (0-10)"
  names(data)[180] <- "atmosphere_1s"
  label(data[[180]]) <- "atmosphere_1s: Dans l’ensemble, l’atmosphère autour de la table était (Très; Plutôt négative; Plutôt; Très positive)"
  names(data)[181] <- "emotions_influence_1s"
  label(data[[181]]) <- "emotions_influence_1s: Les émotions exprimées ont affecté le contenu des délibérations autour de la table (En mal; Plutôt en mal; Plutôt; en bien; NSP)"
  names(data)[182] <- "ai_respecte_1s"
  label(data[[182]]) <- "ai_respecte_1s: J’ai écouté les autres participants avec respect et civilité, même quand je n’étais pas d’accord avec leurs points de vue (0-10)"
  names(data)[183] <- "ete_respecte_1s"
  label(data[[183]]) <- "ete_respecte_1s:  J’ai été écouté·e avec respect et civilité pendant les délibérations, même par ceux qui n’étaient pas d’accord avec moi (0-10)"
  names(data)[184] <- "appris_1s"
  label(data[[184]]) <- "appris_1s: J’ai appris quelque chose sur les sujets traités (0-10)"
  names(data)[185] <- "appris_quoi_1s"
  label(data[[185]]) <- "appris_quoi_1s: Si oui, sur quels points précis avez-vous appris quelque chose ?"
  names(data)[186] <- "appris_pourquoi_pas_1s"
  label(data[[186]]) <- "appris_pourquoi_pas_1s: Si non, à votre avis pourquoi n’avez-vous rien appris ?"
  names(data)[187] <- "comprehension_1s"
  label(data[[187]]) <- "comprehension_1s: J’ai une meilleure compréhension des opinions opposées aux miennes sur les sujets traités (0-10)"
  names(data)[188] <- "comprehension_quoi_1s"
  label(data[[188]]) <- "comprehension_quoi_1s: Si vous êtes d’accord (plutôt ou tout à fait), sur quels points précis avez-vous acquis une meilleure compréhension des opinions opposées aux vôtres ? "
  names(data)[189] <- "comprehension_pourquoi_pas_1s"
  label(data[[189]]) <- "comprehension_pourquoi_pas_1s: Si vous n’êtes pas d’accord (plutôt pas ou pas du tout), pourquoi pensez-vous ne pas avoir acquis une meilleure compréhension des opinons opposées aux vôtres ?"
  names(data)[190] <- "change_avis_1s"
  label(data[[190]]) <- "change_avis_1s: J’ai changé d’avis au cours des délibérations (0-10)"
  names(data)[191] <- "change_avis_quoi_1s"
  label(data[[191]]) <- "change_avis_quoi_1s: Si vous avez changé d’avis, dites-nous sur quels points précis ?"
  names(data)[192] <- "change_avis_pourquoi_1s"
  label(data[[192]]) <- "change_avis_pourquoi_1s: Est-ce à cause [que vous avez changé d'avis lors des délibérations] ? (de faits nouveaux; d'histoires personnelles convaincantes; d'arguments convaincants; autre(s) raison(s)"
  names(data)[193] <- "change_avis_pourquoi_autre_1s"
  label(data[[193]]) <- "change_avis_pourquoi_autre_1s: autre(s) raison(s) (champ libre) - Est-ce à cause [que vous avez changé d'avis lors des délibérations] ? (de faits nouveaux; d'histoires personnelles convaincantes; d'arguments convaincants; autre(s) raison(s)"
  names(data)[194] <- "change_avis_pourquoi_pas_1s"
  label(data[[194]]) <- "change_avis_pourquoi_pas_1s: Si vous n’avez pas changé d’avis, dîtes-nous pourquoi ?"
  names(data)[195] <- "fait_changer_avis_1s"
  label(data[[195]]) <- "fait_changer_avis_1s: Avez-vous fait changer d’avis au moins un autre participant ? (Oui; Non; NSP)"
  names(data)[196] <- "fait_changer_avis_quoi_1s"
  label(data[[196]]) <- "fait_changer_avis_quoi_1s: Si vous pensez avoir fait changer quelqu’un d’avis, dites-nous sur quels points précis"
  names(data)[197] <- "fait_changer_avis_pourquoi_1s"
  label(data[[197]]) <- "fait_changer_avis_pourquoi_1s: Est-ce à cause [que vous avez fait changer d'avis quelqu'un lors des délibérations] ? (de faits nouveaux; d'histoires personnelles convaincantes; d'arguments convaincants; autre(s) raison(s)"
  names(data)[198] <- "fait_changer_avis_pourquoi_autre_1s"
  label(data[[198]]) <- "fait_changer_avis_pourquoi_autre_1s: autre(s) raison(s) (champ libre) - Est-ce à cause [que vous avez fait changer d'avis quelqu'un lors des délibérations] ? (de faits nouveaux; d'histoires personnelles convaincantes; d'arguments convaincants; autre(s) raison(s)"
  names(data)[199] <- "sources_infos_1s"
  label(data[[199]]) <- "sources_infos_1s: Quelles sources d’information ont été utilisées lors de cette session de la Convention citoyenne (par vous-mêmes, les autres participants ou les facilitateurs) (Anecdotes personnelles; Des sources gouvernementales; Des rapports d'experts; Journaux et émissions de TV, Les réseaux sociaux; Les documents de votre dossier de participant; Autres, lesquelles ?)"
  names(data)[200] <- "sources_infos_autres_1s"
  label(data[[200]]) <- "sources_infos_autres_1s: Autres, lesquelles ? - Quelles sources d’information ont été utilisées lors de cette session de la Convention citoyenne (par vous-mêmes, les autres participants ou les facilitateurs) (Anecdotes personnelles; Des sources gouvernementales; Des rapports d'experts; Journaux et émissions de TV, Les réseaux sociaux; Les documents de votre dossier de participant; Autres, lesquelles ?)"
  names(data)[201] <- "confiance_anecdotes_1s"
  label(data[[201]]) <- "confiance_anecdotes_1s: Anecdotes personnelles - Quel est votre degré de confiance en ces différentes sources d’information ?"
  names(data)[202] <- "confiance_medias_1s"
  label(data[[202]]) <- "confiance_medias_1s: Journaux et émissions de TV - Quel est votre degré de confiance en ces différentes sources d’information ?"
  names(data)[203] <- "confiance_reseaux_1s"
  label(data[[203]]) <- "confiance_reseaux_1s: Réseaux sociaux - Quel est votre degré de confiance en ces différentes sources d’information ?"
  names(data)[204] <- "confiance_gouvernement_1s"
  label(data[[204]]) <- "confiance_gouvernement_1s: Des sources gouvernementales - Quel est votre degré de confiance en ces différentes sources d’information ?"
  names(data)[205] <- "confiance_dossier_1s"
  label(data[[205]]) <- "confiance_dossier_1s: Les documents de votre dossier de participant - Quel est votre degré de confiance en ces différentes sources d’information ?"
  names(data)[206] <- "confiance_experts_1s"
  label(data[[206]]) <- "confiance_experts_1s: Des rapports d’experts - Quel est votre degré de confiance en ces différentes sources d’information ?"
  names(data)[207] <- "responsable_lutte_CC_1s"
  label(data[[207]]) <- "responsable_lutte_CC_1s: À votre avis, qui devrait être essentiellement responsable pour la lutte contre le réchauffement climatique ? (Il s'agit essentiellement d'une responsabilité  mondiale (à travers un accord international ou un traité sur le climat); des citoyens et des initiatives de la part de la société civile; des gouvernements nationaux;é des autorités locales; des entreprises et du secteur privé; NSP)"
  names(data)[208] <- "annee_naissance_1s"
  label(data[[208]]) <- "annee_naissance_1s: Quel est votre année de naissance"
  names(data)[209] <- "statut_emploi_1s"
  label(data[[209]]) <- "statut_emploi_1s: Actuellement, exercez-vous une activité professionnelle ? (Oui; Non, je suis au chômage; Non, je suis retraité·e; Non, je suis étudiant·e, lycéen·ne ou en formation; Non, autre situation)"
  names(data)[210] <- "profession_1s"
  label(data[[210]]) <- "profession_1s: Quelle est votre profession ou ancienne profession ? (champ libre)"
  names(data)[211] <- "nb_voitures_1s"
  label(data[[211]]) <- "nb_voitures_1s: Dans votre ménage, disposez-vous d’une voiture ? (Non; Oui, une seule; deux; plus de deux)"
  names(data)[212] <- "distance_travail_1s"
  label(data[[212]]) <- "distance_travail_1s: Chaque jour, quelle distance devez-vous parcourir pour aller au travail ou pour vos déplacements personnels ? (0; 0-10; 10-20; 20-50; >75 km)"
  names(data)[213] <- "moyen_transport_1s"
  label(data[[213]]) <- "moyen_transport_1s: Faites-vous ces déplacements principalement en voiture ? (Oui, comme conducteur; passager; Non, en transport collectif; en 'mode doux' (marche, vélo...); Cela dépend)"
  
  for (i in 1:length(data)) label(data[[i]]) <- paste(label(data[[i]]), sub('_', '', substr(gsub('_clean', '', question_numbers[i]), 2, 1000)), sep = ' - ')
  if (original_names) names(data) <- question_numbers

  if (clean_vars) {
    data <- data[,-c(2, 5, 7, 9, 13:21, 24, 26, 43, 47, 49:55, 72, 79, 82, 87, 93, 110, 112, 117, 121, 123, 125, 131, 134, 138, 143, 145, 151, 153, 158)]
    data <- data[,c(58:170,1:57)]  
  } else data <- data[,c(85:213,1:84)]  
  return(data)
}
relabel_and_rename_b <- function(data, original_names = FALSE, clean_vars = TRUE) {
  question_numbers <- names(data)
  
  names(data)[1] <- "id"
  label(data[[1]]) <- "id: identifiant"
  names(data)[2] <- "numero_participant_4s"
  label(data[[2]]) <- "numero_participant_4s: "
  names(data)[3] <- "date_4s"
  label(data[[3]]) <- "date_4s: Date de complétion du questionnaire"
  names(data)[4] <- "groupe_4s"
  label(data[[4]]) <- "groupe_4s: Groupe thématique (Se loger; Produire/travailler; Consommer; Se déplacer; Se nourrir)"
  names(data)[5] <- "quand_travail_sessions_4s"
  label(data[[5]]) <- "quand_travail_sessions_4s: Lors des sessions à la Convention pendant les séances de travail  - A quels moments avez-vous le sentiment que l'essentiel de votre travail d'élaboration de propositions se fait ? Classer les trois moments suivants selon leur importance (1= le moment principal ; 3= le moins important) (Lors des sessions à la Convention pendant les séances de travail; Pendant les week-ends de la Convention, mais en dehors des séances de travail; Entre les sessions)"
  names(data)[6] <- "quand_travail_informel_4s"
  label(data[[6]]) <- "quand_travail_informel_4s: Pendant les week- ends de la Convention, mais en dehors des séances de travail : dans les échanges informels, sur Whatsapp, pendant les soirées, etc  - A quels moments avez-vous le sentiment que l'essentiel de votre travail d'élaboration de propositions se fait ? Classer les trois moments suivants selon leur importance (1= le moment principal ; 3= le moins important) (Lors des sessions à la Convention pendant les séances de travail; Pendant les week-ends de la Convention, mais en dehors des séances de travail; Entre les sessions)"
  names(data)[7] <- "quand_travail_hors_convention_4s"
  label(data[[7]]) <- "quand_travail_hors_convention_4s: Entre les sessions (sur Whatsapp, par les webinaires, les rendez-vous 'hors les murs', etc.)   - A quels moments avez-vous le sentiment que l'essentiel de votre travail d'élaboration de propositions se fait ? Classer les trois moments suivants selon leur importance (1= le moment principal ; 3= le moins important) (Lors des sessions à la Convention pendant les séances de travail; Pendant les week-ends de la Convention, mais en dehors des séances de travail; Entre les sessions)"
  names(data)[8] <- "desaccord_evolution_4s"
  label(data[[8]]) <- "desaccord_evolution_4s: À ce stade de la Convention avez-vous le sentiment que (Il n’y a pas de désaccord majeur entre les participants; Il y a plus; moins de désaccord qu’au début)" #
  # "greve_nuisible_4s: Les suites données aux propositions de la Convention risquent de pâtir de ces mouvements sociaux - Comment voyez-vous personnellement la situation de la Convention par rapport à ces mouvements sociaux ?"
  names(data)[9] <- "desaccord_permis_pleniere_4s"
  label(data[[9]]) <- "desaccord_permis_pleniere_4s: Permet d’exprimer nos désaccords pleinement - Pensez-vous que l’organisation du travail de la Convention (Oui, en séance plénière; Oui, pendant le travail en groupe; Non)"
  names(data)[10] <- "desaccord_permis_groupe_4s"
  label(data[[10]]) <- "desaccord_permis_groupe_4s: Cherche à produire du consensus - Pensez-vous que l’organisation du travail de la Convention (Oui, en séance plénière; Oui, pendant le travail en groupe; Non)"
  names(data)[11] <- "desaccord_permis_idees_4s"
  label(data[[11]]) <- "desaccord_permis_idees_4s: Si vous avez répondu au moins une fois 'Non' à une des questions desaccord_permis, qu'en pensez-vous et quels changements éventuels proposeriez-vous ?"
  names(data)[12] <- "avis_nouvelle_session_4s"
  label(data[[12]]) <- "avis_nouvelle_session_4s: Quelles possibilités ouvrent, selon vous, l’ajout d’une session supplémentaire de la Convention citoyenne ?"
  names(data)[13] <- "avis_echange_president_4s"
  label(data[[13]]) <- "avis_echange_president_4s: Que retenez-vous de l’échange avec le président de la République vendredi ?"
  names(data)[14] <- "avis_democratie_deliberative_4s"
  label(data[[14]]) <- "avis_democratie_deliberative_4s: Que signifie pour vous la démocratie délibérative dont le président de la république a dit (vendredi 10 janvier) que vous étiez en train de l'inventer ?"
  names(data)[15] <- "relation_membres_4s"
  label(data[[15]]) <- "relation_membres_4s: Comment décririez-vous vos relations avec les 150 citoyens à ce stade de la Convention ? (Je parle  surtout avec ceux de mon groupe thématique; Je parle avec celles et ceux dont je me sens proche; Je me suis fait des amis; Je parle avec tout le monde (ou presque); Je me suis fait des ennemis)" #"role_propositions_4s: Comment voyez-vous votre rôle par rapport à celui des députés et sénateurs dont c’est habituellement la tâche ?"
  names(data)[16] <- "relation_exemples_4s"
  label(data[[16]]) <- "relation_exemples_4s: Merci de donner des exemples pour illustrer votre (vos) réponse(s)"  #"reaction_parlementaires_4s: Comment anticipez-vous leurs réactions vis-à-vis de vos propositions ?"
  names(data)[17] <- "greve_rapport_4s"
  label(data[[17]]) <- "greve_rapport_4s: Le travail de la Convention n’a aucun rapport avec ces mouvements sociaux - Comment voyez-vous personnellement la situation de la Convention par rapport à ces mouvements sociaux ? (Ça n'a aucun rapport; Nous sommes dans un rapport de complémentarité; Nous sommes dans un rapport de compétition; Nous sommes dans d'autres rapports)"
  names(data)[18] <- "greve_rapport_autre_4s"
  label(data[[18]]) <- "greve_rapport_autre_4s: Si vous avez répondu 'Nous sommes dans d'autres rapports', précisez"
  names(data)[19] <- "legitimite_convention_4s"
  label(data[[19]]) <- "legitimite_convention_4s: Selon vous, la Convention fera ses propositions (En son nom propre, celui des 150 citoyens tirés au sort; Au nom du public que représentent (au moins statistiquement) les 150 citoyens tirés au sort; Au nom du peuple français; Au nom de l'impératif de lutte contre le réchauffement climatique; Au nom des générations présentes et futures)"
  # names(data)[20] <- 
  # label(data[[20]]) <- 
  names(data)[21] <- "relation_institutions_4s"
  label(data[[21]]) <- "relation_institutions_4s:  Selon vous, une assemblée tirée au sort comme la vôtre a vocation à entrer dans quel type de relations avec les instances démocratiques élues (Dans des relations de complémentarité; Dans des relations de compétition; Nous sommes dans d'autres relations)"
  names(data)[22] <- "relation_institutions_autre_4s"
  label(data[[22]]) <- "relation_institutions_autre_4s: Si vous avez répondu 'Nous sommes dans d'autres relations' à relation_institutions_4s, précisez"
  names(data)[23] <- "reaction_population_4s"
  label(data[[23]]) <- "reaction_population_4s:  Certaines des propositions auxquelles vous réfléchissez sont contraignantes (même si elles s'accompagnent d'aides). Comment anticipez-vous que la population dans son ensemble réagira à ce type de proposition ?"
  names(data)[24] <- "confiance_tirage_sort_4s"
  label(data[[24]]) <- "confiance_tirage_sort_4s: A ce moment de la Convention citoyenne sur le climat, quel est votre niveau de confiance dans la capacité de citoyens tirés au sort à délibérer de manière productive sur des questions politiques complexes? (Pas du tout; Plutôt pas; Plutôt; Tout à fait confiance)"
  # names(data)[25] <- ""
  # label(data[[25]]) <- "_4s: " 
  names(data)[26] <- "pour_vitesse_110_4s"
  label(data[[26]]) <- "pour_vitesse_110_4s: Abaisser la vitesse limite sur autoroute à 110 km/heure - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  # names(data)[27] <- ""
  # label(data[[27]]) <- "_4s: "
  names(data)[28] <- "pour_taxe_avions_4s"
  label(data[[28]]) <- "pour_taxe_avions_4s: Taxer le transport aérien pour favoriser le transport par train - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  names(data)[29] <- "pour_obligation_renovation_4s"
  label(data[[29]]) <- "pour_obligation_renovation_4s: Obliger les propriétaires à rénover et à isoler les logements lors d’une vente ou d’une location - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  # names(data)[30] <- ""
  # label(data[[30]]) <- "_4s: "
  names(data)[31] <- "pour_compteurs_intelligents_4s"
  label(data[[31]]) <- "pour_compteurs_intelligents_4s:  Installer dans les foyers des compteurs électriques qui analysent les consommations pour permettre aux gens des faire des économies d’énergie - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  # names(data)[32] <- ""
  # label(data[[32]]) <- "_4s: "
  names(data)[33] <- "pour_taxe_distance_4s"
  label(data[[33]]) <- "pour_taxe_distance_4s: Augmenter le prix des produits de consommation qui sont acheminés par des modes de transport polluants - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  # names(data)[34] <- ""
  # label(data[[34]]) <- "_4s: "
  names(data)[35] <- "pour_taxe_carbone_4s"
  label(data[[35]]) <- "pour_taxe_carbone_4s: Augmenter la taxe carbone - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  # names(data)[36] <- ""
  # label(data[[36]]) <- "_4s: "
  names(data)[37] <- "pour_renouvelables_4s"
  label(data[[37]]) <- "pour_renouvelables_4s: Développer les énergies renouvelables même si, dans certains cas, les coûts de production sont plus élevés, pour le moment - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  # names(data)[38] <- ""prendre
  # label(data[[38]]) <- "_4s: "
  names(data)[39] <- "pour_densification_4s"
  label(data[[39]]) <- "pour_densification_4s: Densifier les villes en limitant l’habitat pavillonnaire au profit d’immeubles collectifs - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  # names(data)[40] <- ""
  # label(data[[40]]) <- "_4s: "
  names(data)[41] <- "pour_taxe_vehicules_4s"
  label(data[[41]]) <- "pour_taxe_vehicules_4s: Taxer les véhicules les plus émetteurs de gaz à effet de serre - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  # names(data)[42] <- ""
  # label(data[[42]]) <- ""
  names(data)[43] <- "pour_voies_reservees_4s"
  label(data[[43]]) <- "pour_voies_reservees_4s: Favoriser l’usage (voies de circulation, place de stationnement réservées) des véhicules peu polluants ou partagés (covoiturage) - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  # names(data)[44] <- ""
  # label(data[[44]]) <- "_4s: "
  names(data)[45] <- "pour_cantines_vertes_4s"
  label(data[[45]]) <- "pour_cantines_vertes_4s: Obliger la restauration collective publique à proposer une offre de menu végétarien, biologique et/ou de saiso - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  names(data)[46] <- "pour_fin_gaspillage_4s"
  label(data[[46]]) <- "pour_fin_gaspillage_4s: Réduire le gaspillage alimentaire de moitié - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  names(data)[47] <- "France_CC_4s"
  label(data[[47]]) <- "France_CC_4s: Pensez-vous que la France doit prendre de l’avance sur d’autres pays dans la lutte contre le changement climatique ? (Oui; Non; NSP)"
  names(data)[48] <- "obstacles_lobbies_4s"
  label(data[[48]]) <- "obstacles_lobbies_4s: Les lobbies - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  names(data)[49] <- "obstacles_manque_volonte_4s"
  label(data[[49]]) <- "obstacles_manque_volonte_4s: Le manque de volonté politique - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  names(data)[50] <- "obstacles_manque_cooperation_4s"
  label(data[[50]]) <- "obstacles_manque_cooperation_4s: Le manque de coopération entre pays - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  names(data)[51] <- "obstacles_inegalites_4s"
  label(data[[51]]) <- "obstacles_inegalites_4s: Les inégalités - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  names(data)[52] <- "obstacles_incertitudes_4s"
  label(data[[52]]) <- "obstacles_incertitudes_4s: Les incertitudes de la communauté scientifique - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  names(data)[53] <- "obstacles_demographie_4s" 
  label(data[[53]]) <- "obstacles_demographie_4s: La démographie - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  names(data)[54] <- "obstacles_technologies_4s"
  label(data[[54]]) <- "obstacles_technologies_4s: Le manque de technologies alternatives - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  names(data)[55] <- "obstacles_rien_4s"
  label(data[[55]]) <- "obstacles_rien_4s: Rien de tout cela - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)" # TODO: question posée différemment que dans 1e
  names(data)[56] <- "commentaires_4s"
  label(data[[56]]) <- "commentaires_4s: Notes inscrites sur le questionnaire (Champ libre)"
  names(data)[57] <- "numero_participant_2s"
  label(data[[57]]) <- "numero_participant_2s"
  names(data)[58] <- "groupe_2s"
  label(data[[58]]) <- "groupe_2s: Groupe thématique (Se loger; Produire/travailler; Consommer; Se déplacer; Se nourrir)"
  names(data)[59] <- "date_2s"
  label(data[[59]]) <- "date_2s: Date de complétion du questionnaire"
  names(data)[60] <- "annee_naissance_2s"
  label(data[[60]]) <- "annee_naissance_2s: Quel est votre année de naissance"
  names(data)[61] <- "statut_emploi_2s"
  label(data[[61]]) <- "statut_emploi_2s: Actuellement, exercez-vous une activité professionnelle ? (Oui; Non, je suis au chômage; Non, je suis retraité·e; Non, je suis étudiant·e, lycéen·ne ou en formation; Non, autre situation)"
  names(data)[62] <- "profession_2s"
  label(data[[62]]) <- "profession_2s: Quelle est votre profession ou ancienne profession ? (champ libre)"
  names(data)[63] <- "nb_voitures_2s"
  label(data[[63]]) <- "nb_voitures_2s: Dans votre ménage, disposez-vous d’une voiture ? (Non; Oui, une seule; deux; plus de deux)"
  # names(data)[64] <- ""
  # label(data[[64]]) <- "_2s: "
  names(data)[65] <- "distance_travail_2s"
  label(data[[65]]) <- "distance_travail_2s: Chaque jour, quelle distance devez-vous parcourir pour aller au travail ou pour vos déplacements personnels ? (0; 0-10; 10-20; 20-50; >75 km)"
  names(data)[66] <- "distance_travail_flag_2s"
  label(data[[66]]) <- "distance_travail_2s: Flag - Chaque jour, quelle distance devez-vous parcourir pour aller au travail ou pour vos déplacements personnels ? (0; 0-10; 10-20; 20-50; >75 km)"
  # names(data)[67] <- ""
  # label(data[[67]]) <- "_2s: "
  names(data)[68] <- "moyen_transport_2s"
  label(data[[68]]) <- "moyen_transport_2s: Faites-vous ces déplacements principalement en voiture ? (Oui, comme conducteur; passager; Non, en transport collectif; en 'mode doux' (marche, vélo...); Cela dépend)"
  names(data)[69] <- "pourquoi_voiture_2s"
  label(data[[69]]) <- "pourquoi_voiture_2s: Si vous faites ces déplacements en voiture (conducteur ou passager), est-ce parce que (Vous n’avez pas d’autres solutions; C’est plus commode pour vos trajets; C’est moins cher; C’est moins fatiguant; Non concerné·e, je ne prends pas la voiture)"
  names(data)[70] <- "pu_exprime_2s"
  label(data[[70]]) <- "pu_exprime_2s:  J’ai eu suffisamment d’opportunités d’exprimer mes opinions lors de cette deuxième session de la Convention citoyenne (0-10)"
  names(data)[71] <- "pas_ose_2s"
  label(data[[71]]) <- "pas_ose_2s: Je n’ai pas toujours osé dire ce que je pense, de peur d’être mal vu·e par les autres ou de peur d’avoir l’air ridicule. (0-10)"
  names(data)[72] <- "ai_influence_2s"
  label(data[[72]]) <- "ai_influence_2s: Je pense avoir joué un rôle important dans les discussions (0-10)"
  names(data)[73] <- "ecoutent_pas_2s"
  label(data[[73]]) <- "ecoutent_pas_2s: Les participant·e·s n’avaient pas envie de prêter attention à ce que les autres disaient. Ils venaient juste exprimer leur point de vue (0-10)"
  names(data)[74] <- "interet_prime_2s"
  label(data[[74]]) <- "interet_prime_2s: Chacun·e se souciait plus de son intérêt personnel que de l’intérêt général (0-10)"
  names(data)[75] <- "membres_sinceres_2s"
  label(data[[75]]) <- "membres_sinceres_2s: Les participant·e·s ont été sincères dans leurs prises de parole. Ils n’ont pas cacher pas ce qu’ils pensaient vraiment. (0-10)"
  names(data)[76] <- "opinions_diverses_2s"
  label(data[[76]]) <- "opinions_diverses_2s: Quel était le degré de diversité dans les opinions émises durant les discussions de cette deuxième session de la Convention citoyenne ? (0-10)"
  names(data)[77] <- "hais_desaccord_2s"
  label(data[[77]]) <- "hais_desaccord_2s:  Je n’aime pas me trouver dans des situations où il y a beaucoup de désaccords exprimés (0-10)"
  names(data)[78] <- "accord_difficile_2s"
  label(data[[78]]) <- "accord_difficile_2s: Il a été très difficile, voire impossible, d’arriver à des propositions sur lesquelles tout le monde était d’accord (0-10)"
  names(data)[79] <- "changent_pas_2s"
  label(data[[79]]) <- "changent_pas_2s: Les différent·e·s participant·e·s ne voulaient pas changer d’avis, mêmes si de bons arguments étaient mis en avant par d’autres pendant les discussions (0-10)"
  names(data)[80] <- "respectueux_2s"
  label(data[[80]]) <- "respectueux_2s: La plupart des participant·e·s ont été soucieux·ses du respect à apporter à chacun (0-10)"
  names(data)[81] <- "fuis_desaccord_2s"
  label(data[[81]]) <- "fuis_desaccord_2s: Je préfère changer de sujets quand les personnes avec qui je parle ne sont pas d’accord avec ce que je dis (0-10)"
  names(data)[82] <- "amusant_desaccord_2s"
  label(data[[82]]) <- "amusant_desaccord_2s: C’est plus amusant de participer à des discussions où il y a beaucoup de désaccords exprimés (0-10)"
  names(data)[83] <- "apprecie_debat_2s"
  label(data[[83]]) <- "apprecie_debat_2s: J’apprécie discuter avec des personnes qui n’ont pas les mêmes opinions que moi (0-10)"
  names(data)[84] <- "prefere_consensus_2s"
  label(data[[84]]) <- "prefere_consensus_2s: Je préfère être dans des groupes où les gens ont les mêmes opinions que moi (0-10)"
  names(data)[85] <- "apprecie_desaccord_2s"
  label(data[[85]]) <- "apprecie_desaccord_2s: J’apprécie ne pas être d’accord avec les autres (0-10)"
  names(data)[86] <- "desaccord_stimulsnt_2s"
  label(data[[86]]) <- "desaccord_stimulsnt_2s: Les désaccords stimulent les discussions et poussent à communiquer plus entre participants (0-10)"
  names(data)[87] <- "argumentent_2s"
  label(data[[87]]) <- "argumentent_2s: Quand les gens exprimaient leurs opinions lors des discussions, à quelle fréquence donnaient-ils les raisons pour lesquelles ils ou elles avaient cette opinion ? (Presque toujours; La plupart; La moitié du temps; Rarement; Presque jamais)"
  names(data)[88] <- "affectes_representes_2s"
  label(data[[88]]) <- "affectes_representes_2s: Les personnes les plus affectées par le changement climatique sont-elles bien représentées dans la Convention citoyenne pour le climat (Ces personnes sont bien; sont peu; ne sont pas bien représentées)"
  names(data)[89] <- "complexite_justice_general_2s"
  label(data[[89]]) <- "complexite_justice_general_2s: De manière générale - Les critères de justice sociale - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[90] <- "complexite_justice_alimentation_2s"
  label(data[[90]]) <- "complexite_justice_alimentation_2s: Dans le domaine de l'alimentation - Les critères de justice sociale - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[91] <- "complexite_justice_logement_2s"
  label(data[[91]]) <- "complexite_justice_logement_2s: Dans le domaine du logement - Les critères de justice sociale - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[92] <- "complexite_justice_mobilite_2s"
  label(data[[92]]) <- "complexite_justice_mobilite_2s: Dans le domaine de la mobilité et des transports - Les critères de justice sociale - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[93] <- "complexite_justice_travail_2s"
  label(data[[93]]) <-"complexite_justice_travail_2s: Dans le domaine du travail et de la production - Les critères de justice sociale - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[94] <- "complexite_justice_consommation_2s"
  label(data[[94]]) <- "complexite_justice_consommation_2s: Dans le domaine de la consommation - Les critères de justice sociale - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[95] <- "complexite_objectifs_general_2s"
  label(data[[95]]) <- "complexite_objectifs_general_2s: De manière générale - Les objectifs  de la lutte contre le changement climatique - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[96] <- "complexite_objectifs_alimentation_2s"
  label(data[[96]]) <- "complexite_objectifs_alimentation_2s: Dans le domaine de l'alimentation - Les objectifs  de la lutte contre le changement climatique - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[97] <- "complexite_objectifs_logement_2s"
  label(data[[97]]) <- "complexite_objectifs_logement_2s: Dans le domaine du logement - Les objectifs  de la lutte contre le changement climatique - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[98] <- "complexite_objectifs_mobilite_2s"
  label(data[[98]]) <- "complexite_objectifs_mobilite_2s: Dans le domaine de la mobilité et des transports - Les objectifs  de la lutte contre le changement climatique - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[99] <- "complexite_objectifs_travail_2s"
  label(data[[99]]) <- "complexite_objectifs_travail_2s: Dans le domaine du travail et de la production - Les objectifs  de la lutte contre le changement climatique - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[100] <- "complexite_objectifs_consommation_2s"
  label(data[[100]]) <- "complexite_objectifs_consommation_2s: Dans le domaine de la consommation - Les objectifs  de la lutte contre le changement climatique - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[101] <- "complexite_outils_general_2s"
  label(data[[101]]) <- "complexite_outils_general_2s: De manière générale - Les outils  de la lutte contre le changement climatique - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[102] <- "complexite_outils_alimentation_2s"
  label(data[[102]]) <- "complexite_outils_alimentation_2s: Dans le domaine de l'alimentation - Les outils  de la lutte contre le changement climatique - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[103] <- "complexite_outils_logement_2s"
  label(data[[103]]) <- "complexite_outils_logement_2s: Dans le domaine du logement - Les outils  de la lutte contre le changement climatique - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[104] <- "complexite_outils_mobilite_2s"
  label(data[[104]]) <- "complexite_outils_mobilite_2s: Dans le domaine de la mobilité et des transports - Les outils  de la lutte contre le changement climatique - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[105] <- "complexite_outils_travail_2s"
  label(data[[105]]) <- "complexite_outils_travail_2s: Dans le domaine du travail et de la production - Les outils  de la lutte contre le changement climatique - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[106] <- "complexite_outils_consommation_2s"
  label(data[[106]]) <- "complexite_outils_consommation_2s: Dans le domaine de la consommation - Les outils  de la lutte contre le changement climatique - Comment jugez-vous la complexité des thèmes abordés ? (0-10)"
  names(data)[107] <- "commentaires_2s"
  label(data[[107]]) <- "commentaires_2s: Notes inscrites sur le questionnaire"
  names(data)[108] <- "numero_particpant_3s"
  label(data[[108]]) <- "numero_particpant_3s"
  names(data)[109] <- "groupe_3s" 
  label(data[[109]]) <- "groupe_3s: Groupe thématique (Se loger; Produire/travailler; Consommer; Se déplacer; Se nourrir)"
  names(data)[110] <- "date_3s"
  label(data[[110]]) <- "date_3s: Date de complétion du questionnaire"
  names(data)[111] <- "etat_democratie_3s"
  label(data[[111]]) <- "etat_democratie_3s: Diriez-vous qu’en France la démocratie fonctionne (Très; Assez; Pas très bien; Pas bien du tout; NSP)"
  # names(data)[112] <- 
  # label(data[[112]]) <- 
  names(data)[113] <- "politiques_ecoutent_3s"
  label(data[[113]]) <- "politiques_ecoutent_3s: À votre avis, est-ce que les responsables politiques, en général, se préoccupent de ce que pensent les gens comme vous ? (Beaucoup; Assez; Peu; Pas du tout; NSP)"
  names(data)[114] <- "confiance_maire_3s"
  label(data[[114]]) <- "confiance_maire_3s: Le maire de votre commune - Quelle confiance accordez-vous aux personnalités politiques occupant les fonctions suivantes ? (Plutôt pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  # names(data)[115] <- 
  # label(data[[115]]) <- 
  names(data)[116] <- "confiance_departement_3s"
  label(data[[116]]) <- "confiance_departement_3s: Vos conseillers départementaux (conseillers généraux) - Quelle confiance accordez-vous aux personnalités politiques occupant les fonctions suivantes ? (Plutôt pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  # names(data)[117] <- 
  # label(data[[117]]) <- 
  names(data)[118] <- "confiance_region_3s"
  label(data[[118]]) <- "confiance_region_3s: Vos conseillers régionaux - Quelle confiance accordez-vous aux personnalités politiques occupant les fonctions suivantes ? (Plutôt pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  names(data)[119] <- "confiance_depute_3s"
  label(data[[119]]) <- "confiance_depute_3s: Votre député - Quelle confiance accordez-vous aux personnalités politiques occupant les fonctions suivantes ? (Plutôt pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  names(data)[120] <- "confiance_premier_ministre_3s"
  label(data[[120]]) <- "confiance_premier_ministre_3s: Le Premier ministre actuel - Quelle confiance accordez-vous aux personnalités politiques occupant les fonctions suivantes ? (Plutôt pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  names(data)[121] <- "confiance_president_3s"
  label(data[[121]]) <- "confiance_president_3s: Le Président de la République actuel - Quelle confiance accordez-vous aux personnalités politiques occupant les fonctions suivantes ? (Plutôt pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  names(data)[122] <- "confiance_deputes_europeens_3s"
  label(data[[122]]) <- "confiance_deputes_europeens_3s: Vos députés européens - Quelle confiance accordez-vous aux personnalités politiques occupant les fonctions suivantes ? (Plutôt pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  names(data)[123] <- "confiance_gouvernement_3s"
  label(data[[123]]) <- "confiance_gouvernement_3s: En général, faites-vous confiance au gouvernement pour prendre de bonnes décisions (Toujours; La plupart; La moitié du temps; Parfois; Jamais; NSP)"
  names(data)[124] <- "etat_sert_3s"
  label(data[[124]]) <- "etat_sert_3s: D’une manière générale, avez-vous le sentiment que l’État est conduit ? (Dans  l'intérêt de quelques-uns (ou quelques privilégiés); Dans l’intérêt du plus grand nombre; NSP)"
  names(data)[125] <- "confiance_etat_3s"
  label(data[[125]]) <- "confiance_etat_3s: D’une manière générale, faites-vous confiance en l’État pour résoudre les problèmes que connaît notre pays ? (Oui, tout à fait; plutôt; Non, plutôt pas; pas du tout; NSP)"
  names(data)[126] <- "changer_institutions_3s"
  label(data[[126]]) <- "changer_institutions_3s: Faut-il conserver nos institutions actuelles (0),... (10) changer en profondeur nos institutions ?"
  names(data)[127] <- "confiance_hopitaux_3s"
  label(data[[127]]) <- "confiance_hopitaux_3s: Les hôpitaux - Quelle confiance accordez-vous à chacune des organisations suivantes... ? (Pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  names(data)[128] <- "confiance_pme_3s"
  label(data[[128]]) <- "confiance_pme_3s: Les petites et moyennes entreprises - Quelle confiance accordez-vous à chacune des organisations suivantes... ? (Pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  names(data)[129] <- "confiance_armee_3s"
  label(data[[129]]) <- "confiance_armee_3s: L'armée - Quelle confiance accordez-vous à chacune des organisations suivantes... ? (Pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  names(data)[130] <- "confiance_police_3s"
  label(data[[130]]) <- "confiance_police_3s: La police - Quelle confiance accordez-vous à chacune des organisations suivantes... ? (Pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  # names(data)[131] <- ""
  # label(data[[131]]) <- "_3s: "
  names(data)[132] <- "confiance_ecole_3s"
  label(data[[132]]) <- "confiance_ecole_3s: L'école - Quelle confiance accordez-vous à chacune des organisations suivantes... ? (Pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  names(data)[133] <- "confiance_secu_3s"
  label(data[[133]]) <- "confiance_secu_3s: La sécurité sociale - Quelle confiance accordez-vous à chacune des organisations suivantes... ? (Pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  names(data)[134] <- "confiance_associations_3s"
  label(data[[134]]) <- "confiance_associations_3s: Les associations - Quelle confiance accordez-vous à chacune des organisations suivantes... ? (Pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  # names(data)[135] <- ""
  # label(data[[135]]) <- "_3s: "
  names(data)[136] <- "confiance_justice_3s"
  label(data[[136]]) <- "confiance_justice_3s: La justice - Quelle confiance accordez-vous à chacune des organisations suivantes... ? (Pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  # names(data)[137] <- ""
  # label(data[[137]]) <- "_3s: "
  names(data)[138] <- "confiance_eglise_3s"
  label(data[[138]]) <- "confiance_eglise_3s: L'église catholique - Quelle confiance accordez-vous à chacune des organisations suivantes... ? (Pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  # names(data)[139] <- ""
  # label(data[[139]]) <- "_3s: "
  names(data)[140] <- "confiance_grandes_entreprises_3s"
  label(data[[140]]) <- "confiance_grandes_entreprises_3s: Les grandes entreprises privées - Quelle confiance accordez-vous à chacune des organisations suivantes... ? (Pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  # names(data)[141] <- ""
  # label(data[[141]]) <- "_3s: "
  names(data)[142] <- "confiance_syndicats_3s"
  label(data[[142]]) <- "confiance_syndicats_3s: Les syndicats - Quelle confiance accordez-vous à chacune des organisations suivantes... ? (Pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  # names(data)[143] <- ""
  # label(data[[143]]) <- "_3s: "
  names(data)[144] <- "confiance_banques_3s"
  label(data[[144]]) <- "confiance_banques_3s: Les banques - Quelle confiance accordez-vous à chacune des organisations suivantes... ? (Pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  # names(data)[145] <- ""
  # label(data[[145]]) <- "_3s: "
  names(data)[146] <- "confiance_medias_3s"
  label(data[[146]]) <- "confiance_medias_3s: Les médias - Quelle confiance accordez-vous à chacune des organisations suivantes... ? (Pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  names(data)[147] <- "confiance_reseaux_sociaux_3s"
  label(data[[147]]) <- "confiance_reseaux_sociaux_3s: Les réseaux sociaux (Facebook, Twitter, etc.) - Quelle confiance accordez-vous à chacune des organisations suivantes... ? (Pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  names(data)[148] <- "confiance_partis_3s"
  label(data[[148]]) <- "confiance_partis_3s: Les partis politiques - Quelle confiance accordez-vous à chacune des organisations suivantes... ? (Pas du tout; Plutôt pas; Plutôt; Totalement confiance)"
  names(data)[149] <- "influence_vote_3s"
  label(data[[149]]) <- "influence_vote_3s: Voter aux élections - Selon vous, qu’est-ce qui permet aux citoyens d’exercer le plus d’influence sur les décisions prises en France ? (D'accord; Pas d'accord)"
  names(data)[150] <- "influence_manif_3s"
  label(data[[150]]) <- "influence_manif_3s: Manifester dans la rue - Selon vous, qu’est-ce qui permet aux citoyens d’exercer le plus d’influence sur les décisions prises en France ? (D'accord; Pas d'accord)"
  names(data)[151] <- "influence_boycott_3s"
  label(data[[151]]) <- "influence_boycott_3s: Boycotter des entreprises ou des produits - Selon vous, qu’est-ce qui permet aux citoyens d’exercer le plus d’influence sur les décisions prises en France ? (D'accord; Pas d'accord)"
  names(data)[152] <- "influence_greve_3s"
  label(data[[152]]) <- "influence_greve_3s: Faire grève - Selon vous, qu’est-ce qui permet aux citoyens d’exercer le plus d’influence sur les décisions prises en France ? (D'accord; Pas d'accord)"
  names(data)[153] <- "influence_militer_3s"
  label(data[[153]]) <- "influence_militer_3s: Militer dans un parti politique - Selon vous, qu’est-ce qui permet aux citoyens d’exercer le plus d’influence sur les décisions prises en France ? (D'accord; Pas d'accord)"
  names(data)[154] <- "influence_assemblees_citoyennes_3s"
  label(data[[154]]) <- "influence_assemblees_citoyennes_3s: S’organiser en assemblées délibératives - Selon vous, qu’est-ce qui permet aux citoyens d’exercer le plus d’influence sur les décisions prises en France ? (D'accord; Pas d'accord)"
  names(data)[155] <- "influence_discuter_3s"
  label(data[[155]]) <- "influence_discuter_3s: Discuter sur internet, sur un blog ou un forum - Selon vous, qu’est-ce qui permet aux citoyens d’exercer le plus d’influence sur les décisions prises en France ? (D'accord; Pas d'accord)"
  names(data)[156] <- "influence_rien_3s"
  label(data[[156]]) <- "influence_rien_3s: Rien de tout cela - Selon vous, qu’est-ce qui permet aux citoyens d’exercer le plus d’influence sur les décisions prises en France ? (D'accord; Pas d'accord)"
  # names(data)[157] <- ""
  # label(data[[157]]) <- "_3s: "
  names(data)[158] <- "influence_nsp_3s"
  label(data[[158]]) <- "influence_nsp_3s: Je ne sais pas - Selon vous, qu’est-ce qui permet aux citoyens d’exercer le plus d’influence sur les décisions prises en France ? (D'accord; Pas d'accord)"
  names(data)[159] <- "j_influence_3s"
  label(data[[159]]) <- "j_influence_3s: Un.e citoyen·ne comme moi a une vraie influence sur la politique et sur l’action des autorités (0-10)"
  names(data)[160] <- "autorites_ecoutent_3s"
  label(data[[160]]) <- "autorites_ecoutent_3s: D’une manière générale, les autorités politiques sont soucieuses de prendre en compte les demandes des citoyen.ne.s comme mo (0-10)"
  names(data)[161] <- "pour_pluralisme_3s"
  label(data[[161]]) <- "pour_pluralisme_3s: Il est important en démocratie que les différents partis proposent des alternatives politiques claires (0-10)"
  names(data)[162] <- "politiques_pour_riches_3s"
  label(data[[162]]) <- "politiques_pour_riches_3s: La plupart des responsables politiques ne se soucient que des riches et des puissants (0-10)"
  names(data)[163] <- "pour_democratie_directe_3s"
  label(data[[163]]) <- "pour_democratie_directe_3s: C'est le peuple, et pas les responsables politiques, qui devrait prendre les décisions politiques les plus importantes (0-10)"
  names(data)[164] <- "pour_tirage_sort_deputes_3s"
  label(data[[164]]) <- "pour_tirage_sort_deputes_3s: La démocratie fonctionnerait mieux en France si les députés étaient en fait des citoyens tirés au sort (0-10)"
  names(data)[165] <- "pour_reguler_marche_3s"
  label(data[[165]]) <- "pour_reguler_marche_3s: Il faut laisser le marché fonctionner librement (0),... (10) l'État / la puissance publique doit réguler l'économie ?"
  names(data)[166] <- "pour_inegalites_3s"
  label(data[[166]]) <- "pour_inegalites_3s: Les revenus devraient être plus égaux (0)... (10) Il faut des revenus inégaux pour stimuler l’effort personnel ?"
  names(data)[167] <- "pour_propriete_publique_3s"
  label(data[[167]]) <- "pour_propriete_publique_3s: Il faut augmenter la propriété privée (0),... (10) Il faut augmenter la propriété publique"
  # names(data)[168] <- "" 
  # label(data[[168]]) <- "_3s: "
  names(data)[169] <- "contre_assistanat_3s"
  label(data[[169]]) <- "contre_assistanat_3s: Les gouvernements devraient s’occuper plus des gens (0),... (10) Les gens devraient être responsables d’eux-mêmes"
  names(data)[170] <- "competition_mauvaise_3s"
  label(data[[170]]) <- "competition_mauvaise_3s: La compétition est bonne car elle stimule le travail et l’innovation (0),...(10) La compétition est mauvaise, elle développe ce qu’il y a de mauvais en l’homme"
  names(data)[171] <- "reussite_chance_3s"
  label(data[[171]]) <- "reussite_chance_3s: À la fin, travailler dur permet une bonne vie (0)... (10) La réussite est due à la chance et à la situation sociale, plus qu’au travail"
  names(data)[172] <- "richesse_fixe_3s"
  label(data[[172]]) <- "richesse_fixe_3s: Les gens ne deviennent riches qu’au détriment des autres (0)... (10) Tout le monde peut être riche simultanément"
  names(data)[173] <- "reformer_capitalisme_3s"
  label(data[[173]]) <- "reformer_capitalisme_3s: Personnellement, souhaitez-vous que le système capitaliste soit... ? (...réformé en profondeur; sur quelques points; ne soit pas réformé; NSP)"
  names(data)[174] <- "ouverture_monde_3s"
  label(data[[174]]) <- "ouverture_monde_3s: Selon vous la France doit-elle... ? (...S’ouvrir davantage au monde d’aujourd’hui; Se protéger davantage du monde d’aujourd’hui;  Ni l’un, ni l’autre; NSP)"
  names(data)[175] <- "protectionnisme_pour_3s"
  label(data[[175]]) <- "protectionnisme_pour_3s: Pour favoriser l’activité des entreprises françaises, que faut-il faire selon vous ? (Aller vers plus de protectionnisme pour protéger les entreprises françaises de la concurrence des pays étrangers; Aller vers plus de libre-échange pour permettre aux entreprises françaises de conquérir de nouveaux marchés dans les pays étrangers)"
  # names(data)[176] <- ""
  # label(data[[176]]) <- "_3s: "
  names(data)[177] <- "protectionnisme_chomage_3s"
  label(data[[177]]) <- "protectionnisme_chomage_3s: Selon vous, le fait d’aller vers plus de protectionnisme économique contribuerait à ... (Réduire le chômage; Augmenter le chômage en France; NSP)"
  names(data)[178] <- "commentaires_3s"
  label(data[[178]]) <- "commentaires_3s: Notes inscrites sur le questionnaire"
  
  for (i in 1:length(data)) label(data[[i]]) <- paste(label(data[[i]]), sub('_', '', substr(gsub('_clean', '', question_numbers[i]), 2, 1000)), sep = ' - ')
  if (original_names) names(data) <- question_numbers
  
  if (clean_vars) { 
    data <- data[,-c(20, 25, 27, 30, 32, 34, 36, 38, 40, 42, 44, 64, 67, 112, 115, 117, 131, 137, 139, 141, 143, 145, 157, 168, 176)]
    data <- data[,c(46:153,1:45)] 
  } else data <- data[,c(57:178,1:56)] 
  return(data)
}
relabel_and_rename_c <- function(data, original_names = FALSE, clean_vars = TRUE) {
  question_numbers <- names(data)
  
  label(data[[1]]) <- "id: identifiant"
  label(data[[2]]) <- "numero_participant_4e:"
  label(data[[3]]) <- "date_4e: Date de complétion du questionnaire"
  label(data[[4]]) <- "groupe_4e: Groupe thématique (Se loger; Produire/travailler; Consommer; Se déplacer; Se nourrir)"
  label(data[[5]]) <- "preoccupe_convention_4e: Quelle place a eu la Convention citoyenne pour le climat dans vos préoccupations des huit dernières semaines ? (Je ne m'en suis pas préoccupé.e, j'ai pensé à autre chose; J'y ai pensé, mais sans que cela m'occuppe vraiment; Cela m'a un peu occupé.e; Cela m'a beaucoup occupé.e)"
  label(data[[6]]) <- "discute_convention_proches_4e: Avez-vous discuté de la Convention citoyenne pour le climat dans votre famille ou avec vos amis? (Non, jamais; Oui, quelquefois mais pas souvent (moins d'une fois par semaine); Oui, régulièrement; Oui, tous les jours ou presque)"
  label(data[[7]]) <- "discute_convention_collegues_4e: Avez-vous discuté de la Convention citoyenne pour le climat avec vos relations au travail ou dans votre entourage? (Non, jamais; Oui, quelquefois mais pas souvent (moins d'une fois par semaine); Oui, régulièrement; Oui, tous les jours ou presque)"
  label(data[[8]]) <- "discute_convention_inconnus_4e: Avez-vous discuté de la Convention citoyenne pour le climat avec des gens que vous ne connaissiez pas? (Non, jamais; Oui, quelquefois mais pas souvent (moins d'une fois par semaine); Oui, régulièrement; Oui, tous les jours ou presque)" 
  label(data[[9]]) <- "discute_convention_inconnus_quand_4e: Si oui à discute_convention_inconnus_4e, à quelles occasions?"
#   # label(data[[10]]) <- "_4e: "
  label(data[[11]]) <- "contact_autres_4e: Etes-vous resté en contact avec d'autres participants.e.s de la Convention citoyenne ? (Non; Oui, mais à titre de relations personnelles; Oui, pour échanger avec eux et me tenir informé.e; Oui, j'ai participé avec eux à diverses activités en lien avec la Convention)"
  label(data[[12]]) <- "contact_autres_activites_4e: Si oui à contact_autres_4e, quelles activités?"
  label(data[[13]]) <- "visite_jenparle_4e: Etes-vous allé sur la plate-forme Jenparle ? (Non; Oui, quelques fois mais pas souvent (moins d'une fois par semaine); Oui, régulièrement; Oui, tous les jours ou presque)"
  label(data[[14]]) <- "s_informe_4e: Vous êtes-vous informé.e? (Non; Oui, j'ai lu quelques articles/regardé des vidéos sur la Convention; Oui, j'ai lu quelques articles/regardé des vidéos sur des thèmes abordés lors de la Convention; Oui, j'ai fait des recherches sur des thèmes abordés lors de la Convention)"
  label(data[[15]]) <- "s_informe_themes_4e: Si oui à s_informe_4e, sur quels thèmes plus particulièrement"
  label(data[[16]]) <- "participe_webinaires_4e: Avez-vous participé aux webinaires? (Non; Oui, aux webinaires de mon groupe thématique; Oui, au webinaire de mon groupe avec les experts du groupe d'appui; Oui, au webinaire avec les co-présidents du Comité de gouvernance)"
  label(data[[17]]) <- "pour_liberte_habitat_4e: Il faut éviter toute intervention publique et laisser chacun libre de choisir son habitat (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[18]]) <- "pour_dispersion_habitat_4e: Le gouvernement doit définir une orientation générale en faveur d'une moins grande densité des villes et d'une dispersion de l'habitat (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[19]]) <- "pour_densification_generale_4e: Le gouvernement doit définir et appliquer une orientation générale en faveur d'une plus grande densité de l'habitat qui s'oppose à l'étalement urbain (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[20]]) <- "pour_densification_mesures_4e: Le gouvernement doit inciter à une plus grande densité de l'habitat et dissuader l'étalement urbain par des mesures législatives, fiscales et d'accompagnement (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[21]]) <- "accepte_demenager_4e: Je peux envisager de déménager vers un lieu plus dense (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[22]]) <- "accepte_demenager_si_accompagnement_4e: Je peux envisager de déménager vers un lieu plus dense, à condition que des mesures d'accompagnement soient mises en place (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[23]]) <- "accepte_pas_demenager_4e: Je n'envisage pas de déménager vers un lieu plus dense (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[24]]) <- "habite_deja_dense_4e: J'habite déjà dans un lieu dense dense (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[25]]) <- "droit_logement_4e: Le droit au logement, c'est plutôt... (Avoir accès à un logement de qualité, quel que soit le statut d'occupation; Etre propriétaire de son logement; NSP)"
  label(data[[26]]) <- "voiture_liberte_4e: La voiture individuelle garantit le mieux la liberté d'aller et de venir (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[27]]) <- "voiture_seule_solution_4e: La voiture individuelle est la seule solution pour habiter à distance des centres des grandes villes (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
#   # label(data[[28]]) <- "_4e: "
  label(data[[29]]) <- "voiture_confort_4e: La voiture individuelle permet d'échapper à l'inconfort et aux désagréments des transports en commun (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[30]]) <- "transports_commun_rapide_4e: La mobilité publique (modes doux et transports publics) est la plus rapide et la plus agéable en zone dense (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[31]]) <- "transports_commun_qualite_vie_4e: La mobilité publique (modes doux et transports publics) est la plus efficace pour protéger et développer la qualité de vie urbaine (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[32]]) <- "transports_commun_environnement_4e: La mobilité publique (modes doux et transports publics) est la meilleure réponse à l'objectif de protéger les environnements naturels (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[33]]) <- "transports_doux_environnement_4e: Les mobilités douces (vélo et marche à pied) sont la meilleure réponse à l'objectif de protéger les environnements naturels (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[34]]) <- "transports_liberte_4e: Il faut éviter toute intervention publique et laisser chacun libre de décider (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[35]]) <- "pour_autoroutes_4e: Le gouvernement doit favoriser la fluidité de la circulation en soutenant la construction d'autoroutes et de voies rapides urbaines (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[36]]) <- "transports_commun_generale_4e: Le gouvernement doit définir une orientation générale en faveur des transports publics, mais sans intervention fiscale ou législative forte (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[37]]) <- "pour_investissements_transports_4e: Le gouvernement doit clairement privilégier l'investissement public dans les transports publics urbains et interurbains et instaurer une fiscalité incitative défavorable aux transports motorisés privés (personnes et marchandises) (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[38]]) <- "voiture_seulement_campagne_4e: Il faut renforcer les transports publics dans les villes et accepter la voiture individuelle dans les campagnes  (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[39]]) <- "transports_commun_campagne_4e: Il faut prioritairement renforcer les transports publics dans les campagnes là où ils sont le moins présents (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[40]]) <- "transports_commun_partout_4e: Il faut renforcer les transports publics partout, en recherchant les solutions adaptées à chaque situation (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[41]]) <- "liberte_mode_vie_4e: Chaque personne doit pouvoir appliquer librement ses préférences en matière d'habitat et de mode de vie (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[42]]) <- "collectivite_decide_amenagement_4e: Chaque collectivité territoriale doit pouvoir décider librement de ses stratégies en matère de développement territorial (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
  label(data[[43]]) <- "amenagement_coherent_4e: Il faut mettre en cohérence les stratégies de développement territorial à tous les échelons (local, régional, national et européen) (Tout à fait; Plutôt; Plutôt pas; Pas du tout d'accord)"
#   # label(data[[44]]) <- "_4e: "
  label(data[[45]]) <- "temps_ok_ecole_4e: Ecole primaire - Pour vous, qu'est-ce qu'un temps de déplacement raisonnable pour assurer l'accessibilité aux services suivants? (Entre 5 et 10; 10 et 15; 15 et 30 min; 1/2h et 1h; 1h et 1h 1/2; 1h 1/2 et 2 heures)"
#   # label(data[[46]]) <- "_4e: "
  label(data[[47]]) <- "temps_ok_lycee_4e: Lycée - Pour vous, qu'est-ce qu'un temps de déplacement raisonnable pour assurer l'accessibilité aux services suivants? (Entre 5 et 10; 10 et 15; 15 et 30 min; 1/2h et 1h; 1h et 1h 1/2; 1h 1/2 et 2 heures)"
#   # label(data[[48]]) <- "_4e: "
  label(data[[49]]) <- "temps_ok_universite_4e: Université - Pour vous, qu'est-ce qu'un temps de déplacement raisonnable pour assurer l'accessibilité aux services suivants? (Entre 5 et 10; 10 et 15; 15 et 30 min; 1/2h et 1h; 1h et 1h 1/2; 1h 1/2 et 2 heures)"
#   # label(data[[50]]) <- "_4e: "
  label(data[[51]]) <- "temps_ok_urgences_4e: Service hospitalier d'urgence - Pour vous, qu'est-ce qu'un temps de déplacement raisonnable pour assurer l'accessibilité aux services suivants? (Entre 5 et 10; 10 et 15; 15 et 30 min; 1/2h et 1h; 1h et 1h 1/2; 1h 1/2 et 2 heures)"
#   # label(data[[52]]) <- "_4e: "
  label(data[[53]]) <- "temps_ok_maternite_4e: Maternité - Pour vous, qu'est-ce qu'un temps de déplacement raisonnable pour assurer l'accessibilité aux services suivants? (Entre 5 et 10; 10 et 15; 15 et 30 min; 1/2h et 1h; 1h et 1h 1/2; 1h 1/2 et 2 heures)"
#   # label(data[[54]]) <- "_4e: "
  label(data[[55]]) <- "temps_ok_services_publics_4e: Maison des services publics - Pour vous, qu'est-ce qu'un temps de déplacement raisonnable pour assurer l'accessibilité aux services suivants? (Entre 5 et 10; 10 et 15; 15 et 30 min; 1/2h et 1h; 1h et 1h 1/2; 1h 1/2 et 2 heures)"
#   # label(data[[56]]) <- "_4e: "
  label(data[[57]]) <- "temps_ok_gare_4e: Gare - Pour vous, qu'est-ce qu'un temps de déplacement raisonnable pour assurer l'accessibilité aux services suivants? (Entre 5 et 10; 10 et 15; 15 et 30 min; 1/2h et 1h; 1h et 1h 1/2; 1h 1/2 et 2 heures)"
#   # label(data[[58]]) <- "_4e: "
  label(data[[59]]) <- "temps_ok_coworking_4e: Espace de coworking - Pour vous, qu'est-ce qu'un temps de déplacement raisonnable pour assurer l'accessibilité aux services suivants? (Entre 5 et 10; 10 et 15; 15 et 30 min; 1/2h et 1h; 1h et 1h 1/2; 1h 1/2 et 2 heures)"
  label(data[[60]]) <- "commentaires_4e: Notes inscrites sur le questionnaire (champ libre)"

  for (i in 1:length(data)) {
    label(data[[i]]) <- paste(label(data[[i]]), sub('_', '', substr(gsub('_clean', '', question_numbers[i]), 2, 1000)), sep = ' - ')
    names(data)[i] <- sub(":.*", "", label(data[[i]]))  }
  if (original_names) names(data) <- question_numbers
  
  if (clean_vars) data <- data[,-c(10, 20, 28, 44, 46, 48, 50, 52, 54, 56, 58)]
  return(data)
}

find_var <- function(string, data = Q) which(sapply(colnames(Q), function(q) grep('annee', q))>0)

## a. Prepare data 3 first sessions
# load datasets
Q1e <- read_dta("../données/1e.dta")
Q1s <- read_dta("../données/1s.dta", encoding = 'utf8')
Q2e <- read_dta("../données/2e.dta")

# merge datasets
Q1e$identifiant[is.na(Q1e$identifiant)] <- paste('NA_1e', seq(1:length(which(is.na(Q1e$identifiant)))), sep='_') # 7 NAs
Q1s$identifiant[is.na(Q1s$identifiant)] <- paste('NA_1s', seq(1:length(which(is.na(Q1s$identifiant)))), sep='_') # 13
Q2e$identifiant[is.na(Q2e$identifiant)] <- paste('NA_2e', seq(1:length(which(is.na(Q2e$identifiant)))), sep='_') # 5
Q1e <- Q1e[!duplicated(Q1e$identifiant),] # same answers for duplicate id=74 except for s1_e_q49_technologies
Qa <- merge(Q2e, merge(Q1e, Q1s, all = TRUE), all = TRUE)

# clean data
# Qa$s1_e_timestamp <- date2ISOweek(Qa$s1_e_timestamp)
# Qa$s1_s_timestamp <- date2ISOweek(Qa$s1_s_timestamp)
# Qa$s2_e_timestamp <- date2ISOweek(Qa$s2_e_timestamp)
Qa$s1_e_timestamp <- as.character(Qa$s1_e_timestamp)
Qa$s1_s_timestamp <- as.character(Qa$s1_s_timestamp)
Qa$s2_e_timestamp <- as.character(Qa$s2_e_timestamp)

QA <- relabel_and_rename_a(Qa)
CA <- relabel_and_rename_a(Qa, original_names = TRUE, clean_vars = FALSE)

## b. Prepare data 2s, 3s, 4s
# load datasets
Q2s <- read_dta("../données/2s.dta", encoding = 'utf8')
Q3s <- read_dta("../données/3s.dta", encoding = 'utf8')
Q4s <- read_dta("../données/4s.dta", encoding = 'utf8')

# merge datasets
Q2s$identifiant[is.na(Q2s$identifiant)] <- paste('NA_2s', seq(1:length(which(is.na(Q2s$identifiant)))), sep='_') # 2
Q3s$identifiant[is.na(Q3s$identifiant)] <- paste('NA_3s', seq(1:length(which(is.na(Q3s$identifiant)))), sep='_') # 5
Q4s$identifiant[is.na(Q4s$identifiant)] <- paste('NA_4s', seq(1:length(which(is.na(Q4s$identifiant)))), sep='_') # 3
Qb <- merge(Q4s, merge(Q2s, Q3s, all = TRUE), all = TRUE)

# clean data
# Qb$s4_s_timestamp <- date2ISOweek(Qb$s4_s_timestamp)
# Qb$s2_s_timestamp <- date2ISOweek(Qb$s2_s_timestamp)
# Qb$s3_s_timestamp <- date2ISOweek(Qb$s3_s_timestamp)
Qb$s4_s_timestamp <- as.character(Qb$s4_s_timestamp)
Qb$s2_s_timestamp <- as.character(Qb$s2_s_timestamp)
Qb$s3_s_timestamp <- as.character(Qb$s3_s_timestamp)

QB <- relabel_and_rename_b(Qb)
CB <- relabel_and_rename_b(Qb, original_names = TRUE, clean_vars = FALSE)
Q <- merge(QA, QB, all = TRUE)
C <- merge(CA, CB, all = TRUE)

Q4e <- read_dta("../données/4e.dta", encoding = 'utf8')
Q4e$s4_e_timestamp <- as.character(Q4e$s4_e_timestamp)
Q4e$identifiant[is.na(Q4e$identifiant)] <- paste('NA_4e', seq(1:length(which(is.na(Q4e$identifiant)))), sep='_') # 4
Q4E <- relabel_and_rename_c(Q4e)
C4E <- relabel_and_rename_c(Q4e, original_names = TRUE, clean_vars = FALSE)
Q <- merge(Q, Q4E, all = TRUE)[,c(1:278, 323:370, 279:322)]
C <- merge(C, C4E, all = TRUE)[,c(1:335, 391:449, 336:390)]

remove(Q1e, Q1s, Q2e, Q2s, Q3s, Q4s, Qa, Qb, Q4e, QA, QB, CA, CB, Q4E, C4E)

export_stats_desc <- function(data, file, miss = TRUE, sorted_by_n = FALSE, return = FALSE, fill_extern = FALSE) {
  original_width <- getOption("width")
  options(width = 10000)
  des <- des_miss <- nb_miss <- labels <- n <- c()
  for (i in 1:length(data)) {
    decrit_i <- capture.output(print(decrit(data[[i]], miss=TRUE)))
    n <- c(n, as.numeric(sub('[[:blank:]]*([[:digit:]]*).*', '\\1', decrit_i[3])))
    des_i <- gsub(".*<br>        n","        n",gsub(".*<br>       n","       n",gsub(".*<br>      n","      n",gsub("<br><br>lowest.*","",paste(capture.output(print(decrit(data[[i]]))), collapse='<br>')))))
    if (str_count(des_i, fixed("),"))>1) { des_i <- gsub("),",")<br>",des_i) }
    des_miss_i <-  gsub(".*<br>        n","        n",gsub(".*<br>       n","       n",gsub(".*<br>      n","      n",gsub("<br><br>lowest.*","",paste(decrit_i, collapse='<br>')))))
    if (str_count(des_miss_i, fixed("),"))>1) { des_miss_i <- gsub("),",")<br>",des_miss_i) }
    nb_miss_i <- gsub(".*<br>        n","        n",gsub(".*<br>       n","       n",gsub(".*<br>      n","      n",gsub("<br><br>lowest.*","",paste(decrit_i[1:3], collapse='<br>')))))
    des <- c(des, des_i)
    des_miss <- c(des_miss, des_miss_i)
    nb_miss <- c(nb_miss, nb_miss_i)
    if (Label(data[[i]])=='') label_i <- colnames(data)[i]
    else label_i <- Label(data[[i]])
    labels <- c(labels, label_i)
  }
  
  if (miss=='both') output <- matrix(c(names(data), labels, des, des_miss), ncol=4)
  if (miss=='nb') output <- matrix(c(names(data), labels, nb_miss), ncol=3)
  else if (sorted_by_n) output <- matrix(c(names(data), labels, des_miss), ncol=3)[order(-n),]
  else if (miss) output <- matrix(c(names(data), labels, des_miss), ncol=3)
  else output <- matrix(c(names(data), labels, des), ncol=3)
  write.table(output, file=file, sep=";;;", row.names=FALSE, col.names=FALSE, quote=FALSE)
  options(width = original_width)
  if (fill_extern) {
    nb_reponses <<- n
    nb_manquants <<- des_miss     }
  if (return) return(output)
}

C <- C[,-which(grepl("numero_participant", colnames(C)))]
C$identifiant_inconnu <- FALSE
C$identifiant_inconnu[grepl("NA", C$identifiant)] <- TRUE
C <- C[,-1]

Q <- Q[,-which(grepl("numero_participant", colnames(Q)))]
Q$identifiant_inconnu <- FALSE
Q$identifiant_inconnu[grepl("NA", Q$id)] <- TRUE
Q <- Q[,-1]

write.csv(Q, '../données/responses.csv', row.names = FALSE)
write.csv(C, '../données/responses_raw.csv', row.names = FALSE) # pour qui ?
# write_dta(Q, '../données/responses.dta', version = 11) # variable names too long for Stata 11
C[38, 213] <- substr(C[38, 213], 1, 208) # string already truncated in raw data (at 244 characters), bug when not truncated a bit more
write_dta(C, '../données/responses_raw.dta', version = 11)

nb_reponses <- c()
nb_manquants <- c()
export_stats_desc(Q, paste(getwd(), 'stats_desc.csv', sep='/'), fill_extern = TRUE)
export_stats_desc(Q, paste(getwd(), 'stats_desc_sorted.csv', sep='/'), sorted_by_n = TRUE)
export_stats_desc(C, paste(getwd(), 'stats_desc_raw.csv', sep='/'))
names(nb_reponses) <- colnames(Q)
names(nb_manquants) <- colnames(Q)

# TODO: Recoder questions comme s2_e_q8

# Q <- read.csv('responses.csv')
# TODO moi: regarder la représentativité (Bernard Reber, Jean-Michel Fourniau, Bénédicte Apouey (confiance, satisfaction))
# todo autres: identifier les 50 qui répondent tout le temps, sont-ils représentatifs des 150; récupérer les gens dont id=NA; voir si sur chaque question de recherche on est capable de répondre (lister questions)
sessions <- c('1e', '1s', '2e', '2s', '3s', '4e', '4s')
stats <- data.frame(id = sessions)
for (s in sessions) {
  stats$mean_n[stats$id==s] <- mean(nb_reponses[grepl(s, colnames(Q))], na.rm = T)
  stats$sd_n[stats$id==s] <- sd(nb_reponses[grepl(s, colnames(Q))], na.rm = T)
  stats$min_n[stats$id==s] <- min(nb_reponses[grepl(s, colnames(Q))], na.rm = T)
  stats$max_n[stats$id==s] <- max(nb_reponses[grepl(s, colnames(Q))], na.rm = T)
  stats$q1_n[stats$id==s] <- quantile(nb_reponses[grepl(s, colnames(Q))], 0.25, na.rm = T)
  stats$median_n[stats$id==s] <- median(nb_reponses[grepl(s, colnames(Q))], na.rm = T)
  stats$q3_n[stats$id==s] <- quantile(nb_reponses[grepl(s, colnames(Q))], 0.75, na.rm = T)
}
View(stats)

##### Représentativité #####
# changement climatique: CCC 20-30% plus préoccupés et pessimistes concernant le CC. ADEME: juillet 2019 => trouver données solange.martin@ademe.fr
decrit(Q$cause_catastrophes_1e) # *** ADEME (2019: 43) changement: 58% (88%) / personne: 20% (9%) / naturels: 20% (3%) / NSP: 2%
decrit(Q$effets_CC_1e) # ** ADEME (2019: 54) pénibles: 65% (85%) / s'adaptera: 32% (15%) / positif: 2% / NSP: 1%
decrit(Q$issue_CC_1e) # ~ ADEME (2019: 69) -2: 13% (6%) / -1: 50% (52%) / 1: 31% (39%) / 2: 5% (3%)
decrit(Q$solution_CC_1e) # ** modifier: 52% (75%) / états: 19% (15%) / inévitable: 17% (4%) / progrès: 11% (5%)
decrit(Q$ag) # ADEME (2019: 115)
decrit(Q$importance_environnement_1e) # ADEME (2019: 174) 
decrit(Q$pour_) # 102
decrit(Q$obstacles_) # 

decrit(Q$situation_revenus_1e) # Ipsos (2017) mais résultats non donnés
decrit(Q$redistribution_1e) # Ipsos (2019) 66% d'accord 
decrit(Q$problemes_invisibilises_1e) # Très: 18% (12%) / Assez souvent: 33% (45%) / Rarement: 17% (peu souvent: 41%) / jamais: 31% (3%) / NSP: 2%.  CREDOC, Enquête « Conditions de vie et Aspirations », 2015 
