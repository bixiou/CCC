# setwd("/var/www/beliefs_climate_policies/code")

source(".Rprofile")

##### Correspondance zipcode - region #####
# communes_agglo <- read.xls("table-appartenance-geo-communes-18_V2.xls", pattern="CODGEO") # 2018
# communes_PLM <- read.xls("table-appartenance-geo-communes-18_V2.xls", sheet=2, pattern="CODGEO") # Paris Lyon Marseille
# communes_data <- read.csv("correspondance-code-insee-code-postal.csv", sep=";") # 2013
# communes_agglo <- communes_agglo[,c('CODGEO', 'TUU2015')]
# communes_PLM <- communes_PLM[,c('CODGEO', 'TUU2015')]
# colnames(communes_agglo) <- c('Code.INSEE', 'taille_agglo')
# colnames(communes_PLM) <- c('Code.INSEE', 'taille_agglo')
# communes_agglo$Code.INSEE <- as.character(communes_agglo$Code.INSEE)
# communes_PLM$Code.INSEE <- as.character(communes_PLM$Code.INSEE)
# communes_data <- communes_data[,c('Code.INSEE', "Code.Postal", 'Population')]
# communes <- merge(merge(communes_agglo, communes_PLM, all=T), communes_data, all=T)
# sum(communee$Population[is.na(communee$taille_agglo)], na.rm=T) # 750k missing because of Code.INSEE renaming
# taille_agglo <- aggregate(1000*Population ~ taille_agglo, communes, sum)
# colnames(taille_agglo) <- c('taille_agglo', 'pop')
# taille_agglo$share <- taille_agglo$pop / sum(taille_agglo$pop)
# taille_agglo # total: 63.76 M
# taille_agglo$share[taille_agglo$taille_agglo==0] # rural
# sum(taille_agglo$share[taille_agglo$taille_agglo<=3 & taille_agglo$taille_agglo>0]) # <20k
# sum(taille_agglo$share[taille_agglo$taille_agglo<=5 & taille_agglo$taille_agglo>3]) # <100k
# sum(taille_agglo$share[taille_agglo$taille_agglo<8 & taille_agglo$taille_agglo>5]) # >100k
# taille_agglo$share[taille_agglo$taille_agglo==8] # Paris


##### Quantiles de revenus ERFS 2014 #####
# quantiles <- function(data, weights = NULL)  {
#   if (is.null(weights)) return(function(q) { pmax(0,quantile(data, probs = q, na.rm = TRUE, names = FALSE) / 12)} )
#   else return(function(q) { pmax(0, wtd.quantile(data, probs = q, na.rm = TRUE, weights = weights) / 12)} )
# }
# seuils_all <- function(q) {
#   e <- vector("numeric", length=5)
#   for (i in 1:9) e[i] <- q(i/10)
#   # e[1] <- q(0.1, weights = weights)
#   # e[2] <- q(0.2, weights = weights)
#   # e[3] <- q(0.3, weights = weights)
#   # e[4] <- q(0.4, weights = weights)
#   # e[5] <- q(0.5, weights = weights)
#   # e[6] <- q(0.6, weights = weights)
#   # e[7] <- q(0.7, weights = weights)
#   # e[8] <- q(0.8, weights = weights)
#   # e[9] <- q(0.9, weights = weights)
#   return(round(e,0))
# }
# wd <- getwd()
# setwd("U:/Données/ERFS_2014")
# setwd("/mnt/dd/adrien/DD/Économie/Données/ERFS_2014/Stata")
# indiv <- read.dta13("fpr_indiv_2014.dta")
# irft4 <- read.dta13("fpr_irf14e14t4.dta")
# menage <- read.dta13("fpr_menage_2014.dta")
# menage$presta_sociales <- menage$prest_fam_petite_enfance + menage$prest_fam_autres + menage$prest_precarite_rsa + menage$m_rsa_actm + menage$prest_precarite_hand + menage$prest_precarite_vieil + menage$prest_logement + menage$ppe
# irft4 <- irft4[,which(is.element(colnames(irft4),c("noindiv", "noiprm", "nbinde", "nbenfa18", "ag", "mchoe", "ancinatm")))]
# menage <- menage[,which(is.element(colnames(menage),c("ident14", "revdispm","impots" ,"revdecm", "nivviem", "presta_sociales", "revenu_ajuste", "rev_cat_net", "wpri")))]
# # Prestas aux parents, i.e. aux deux adultes les plus âgés du ménage
# temp <- merge(indiv, irft4, by="noindiv")
# db <- merge(temp, menage, by="ident14")
# names(db)[1] <- "group"
# names(db)[29] <- "age"
# db$age <- as.numeric(db$age)
# temp <- aggregate(age ~ group, db, function(vec) {
#   if (length(vec) >= 2) return(max(vec[-which.max(vec)]))
#   else return(-1)})
# names(temp)[2] <- "age_second"
# db$order <- seq(len=nrow(db))
# db <- merge(db, temp, all=TRUE, by="group")
# temp <- aggregate((age >= pmax(age_second, 18)) ~ group, db, sum)
# names(temp)[2] <- "adult_above_second"
# db$order <- seq(len=nrow(db))
# db <- merge(db, temp, all=TRUE, by="group")
# temp <- aggregate((age > 17) ~ group, db, sum)
# names(temp)[2] <- "nb_adultes"
# db$order <- seq(len=nrow(db))
# db <- merge(db, temp, all=TRUE, by="group")
# db$revenu_imputable_i <- db$salaires_i + db$chomage_i + db$retraites_i + db$rag_i + db$rnc_i + db$ric_i + db$pens_alim_recue_i # Ce dernier, dont l'ajout est discutable, ne représente que  5 milliards
# temp <- aggregate(revenu_imputable_i ~ group, db, sum)
# names(temp)[2] <- "revenu_imputable_m"
# db <- merge(temp, db, all=TRUE,by="group")
# db <- db[sort.list(db$order),]
# # On exclut les revenus négatifs
# db$proportion_imputee[db$revenu_imputable_m > 0] <- db$revenu_imputable_i[db$revenu_imputable_m > 0] / db$revenu_imputable_m[db$revenu_imputable_m > 0]
# db$proportion_imputee[db$revenu_imputable_m == 0 & db$age > 17 & db$nb_adultes>0] <- 1 / db$nb_adultes[db$revenu_imputable_m == 0 & db$age > 17 & db$nb_adultes>0]
# db$proportion_imputee[db$revenu_imputable_m == 0 & db$age < 18] <- 0
# 
# db$revtot_i_par <- db$revdecm * db$proportion_imputee + db$presta_sociales * (db$age >= pmax(db$age_second, 18)) /  pmax(1, db$adult_above_second)
# sum(db$revtot_i_par, na.rm=T)/sum(menage$presta_sociales + menage$revdecm, na.rm=T) # 1.000032
# 
# # Déciles de revenus inflatés : (croissance PIB 2014-2018	1.06075007	https://www.insee.fr/fr/statistiques/2830613#tableau-Tableau1 ) MàJ 2020: should be 1.0633
# deciles_erfs_inflates <- 1.06075007*seuils_all(quantiles(db$revtot_i_par[!is.na(db$revtot_i_par) & db$age > 17]))
# # This is the one used:
# round(deciles_erfs_inflates) # 229 779 1142 1429 1671 1922 2222 2641 3436
# deciles_erfs_inflates_weighted <- 1.06075007*seuils_all(quantiles(db$revtot_i_par[!is.na(db$revtot_i_par) & db$age > 17], weights = db$wprm[!is.na(db$revtot_i_par) & db$age > 17]))
# round(deciles_erfs_inflates_weighted) # 237 789 1151 1436 1677 1927 2231 2657 3462
# deciles_menage_erfs_inflates_weighted <- 1.06075007*seuils_all(quantiles(db$revdecm + db$presta_sociales, weights = db$wprm))
# 
# rev_i_erfs2014.csv <- db$revtot_i_par[!is.na(db$revtot_i_par) & db$age > 17]
# write.csv(rev_i_erfs2014.csv, "rev_i_erfs2014.csv")
# rev_i_erfs2014 <- read.csv("rev_i_erfs2014.csv")
# percentiles_revenu <- ecdf(rev_i_erfs2014$x)
# distribution_revenu_erfs <- wtd.Ecdf(db$revtot_i_par[!is.na(db$revtot_i_par) & db$age > 17 & !is.na(db$age)])
# distribution_revenu_erfs_weighted <- wtd.Ecdf(db$revtot_i_par[!is.na(db$revtot_i_par) & db$age > 17 & !is.na(db$age)], weights = db$wprm[!is.na(db$revtot_i_par) & db$age > 17 & !is.na(db$age)])
# # plot(distribution_revenu_erfe$x, distribution_revenu_erfe$ecdf, type='l', xlim=c(0,60000), col="blue")
# distribution_rev_tot_erfs <- wtd.Ecdf(db$revdecm + db$presta_sociales)
# distribution_rev_tot_erfs_weighted <- wtd.Ecdf(db$revdecm + db$presta_sociales, weights = db$wprm)
# 
# # Distribution of adults > 70th. income percentile in function of their spouse income
# db$revenu_conjoint <- db$revdecm + db$presta_sociales - db$revtot_i_par # selon la définition du sondage où il n'y a que deux parents
# db$revenu_conjoint[db$nb_adultes < 2] <- 9999*12
# share__20 <- length(which((db$revtot_i_par < 734*12 | (db$revenu_conjoint < 734*12 & db$revtot_i_par > 2095*12)) & !is.na(db$revtot_i_par) & db$age > 17))/length(which(!is.na(db$revtot_i_par) & db$age > 17))
# share_20_30 <- length(which(((db$revtot_i_par < 1077*12 & db$revtot_i_par >= 734*12) | (db$revenu_conjoint < 1077*12 & db$revenu_conjoint >= 734*12 & db$revtot_i_par > 2095*12)) & !is.na(db$revtot_i_par) & db$age > 17))/length(which(!is.na(db$revtot_i_par) & db$age > 17))
# share_30_40 <- length(which(((db$revtot_i_par < 1347*12 & db$revtot_i_par >= 1077*12) | (db$revenu_conjoint < 1347*12 & db$revenu_conjoint >= 1077*12 & db$revtot_i_par > 2095*12)) & !is.na(db$revtot_i_par) & db$age > 17))/length(which(!is.na(db$revtot_i_par) & db$age > 17))
# share_40_50 <- length(which(((db$revtot_i_par < 1575*12 & db$revtot_i_par >= 1347*12) | (db$revenu_conjoint < 1575*12 & db$revenu_conjoint >= 1347*12 & db$revtot_i_par > 2095*12)) & !is.na(db$revtot_i_par) & db$age > 17))/length(which(!is.na(db$revtot_i_par) & db$age > 17))
# share_50_70 <- length(which(((db$revtot_i_par < 2095*12 & db$revtot_i_par >= 1575*12) | (db$revenu_conjoint < 2095*12 & db$revenu_conjoint >= 1575*12 & db$revtot_i_par > 2095*12)) & !is.na(db$revtot_i_par) & db$age > 17))/length(which(!is.na(db$revtot_i_par) & db$age > 17))
# share_70_ <- length(which(db$revtot_i_par >= 2095*12 & db$revenu_conjoint >= 2095*12 & !is.na(db$revtot_i_par) & db$age > 17))/length(which(!is.na(db$revtot_i_par) & db$age > 17))
# sum(c(share__20, share_20_30, share_30_40, share_40_50, share_50_70, share_70_))
# expected_target_proportions <- share_70_ / 4 + c('20' = share__20 + share_20_30/2, '30' = share_20_30/2 + share_30_40/2, '40' = share_30_40/2 + share_40_50/2, '50' = share_40_50/2 + share_50_70)
# round(expected_target_proportions, 3)
# # decrit(e$cible) # incredibly close!
# # shares <- c('_20' = share__20, '20_30'=share_20_30, '30_40'=share_30_40, '40_50'=share_40_50, '50_70'=share_50_70, '70_'=share_70_)
# # decrit(e$categorie_cible)
# wtd.mean(db$nb_adultes, db$wprm) # 2.033
# # wtd.mean(e$nb_adultes, e$weight) # 1.933
# 
# rm(db, temp, irft4, menage, indiv)
# setwd(wd)


##### Preparation #####

relabel_and_rename <- function(e) {
  # Notation: ~ means that it's a random variant; * means that another question is exactly the same (in another random branch)
  
  # The commented lines below should be executed before creating relabel_and_rename, to ease the filling of each name and label
  # for (i in 1:length(e)) {
  #   label(e[[i]]) <- paste(names(e)[i], ": ", label(e[[i]]), e[[i]][1], sep="");
  #   print(paste(i, label(e[[i]])))
  # }
  
  label(e[[1]]) <- "date:"
  label(e[[2]]) <- "date_fin:"
  label(e[[3]]) <- "statut_reponse:"
  label(e[[4]]) <- "ip:"
  label(e[[5]]) <- "progres:"
  label(e[[6]]) <- "duree:"
  label(e[[7]]) <- "fini:"
  label(e[[8]]) <- "date_enregistree:"
  label(e[[9]]) <- "ID_qualtrics:"
  label(e[[10]]) <- "nom:"
  label(e[[11]]) <- "prenom:"
  label(e[[12]]) <- "mmail:"
  label(e[[13]]) <- "ref:"
  label(e[[14]]) <- "lat:"
  label(e[[15]]) <- "long:"
  label(e[[16]]) <- "distr:"
  label(e[[17]]) <- "lang:"
  label(e[[18]]) <- "code_postal: Code Postal - Q93" 
  label(e[[19]]) <- "sexe: Sexe (Masculin/Féminin) - Q96"
  label(e[[20]]) <- "age: Tranche d'âge (18-24/25-34/35-49/50-64/65+) - Q184"
  label(e[[21]]) <- "statut_emploi: Statut d'emploi (Chômage/CDD/CDI/fonctionnaire/étudiant-e/retraité-e/précaire/autre actif/autre inactif) - Q35"
  label(e[[22]]) <- "csp: Catégorie Socio-Professionnelle: Agriculteur/Indépendant: Artisan, commerçant.e/Cadre: Profession libérale, cadre/Intermédiaire: Profession intermédiaire/Employé/Ouvrier/Retraité/Inactif: Autres inactif/ve - Q98"
  label(e[[23]]) <- "diplome: Diplôme le plus haut obtenu ou prévu: Aucun/Brevet/CAP/Bac/+2/+3/>+4) - Q102"
  label(e[[24]]) <- "taille_menage: Taille du ménage #(vous, membres de votre famille vivant avec vous et personnes à votre charge) - Q29"
  label(e[[25]]) <- "revenu: Revenu mensuel net du répondant - Q148"
  label(e[[26]]) <- "rev_tot: Revenu mensuel net du ménage - Q25"
  label(e[[27]]) <- "nb_14_et_plus: Nombre de personnes âgées d'au moins 14 ans dans le ménage - Q31"
  label(e[[28]]) <- "nb_adultes: Nombre de personnes majeures dans le ménage - Q149"
  label(e[[29]]) <- "locataire: Locataire - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(e[[30]]) <- "proprio_occupant: Propriétaire occupant - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(e[[31]]) <- "proprio_bailleur: Propriétaire bailleur - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(e[[32]]) <- "heberge_gratis: Hébergé gratuitement - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(e[[33]]) <- "patrimoine: Patrimoine net du ménage (ou de la personne si elle vit chez ses parents) (<10/10-60/60-180/180-350/350-550/>550k€/NSP) - Q129" # les quintiles + dernier décile 2018 https://www.insee.fr/fr/statistiques/2388851
  label(e[[34]]) <- "surface: Surface du logement (en m²) - Q175"
  label(e[[35]]) <- "chauffage: source d'énergie principale (Électricité/Gaz de ville/Butane, propane, gaz en citerne/Fioul, mazout, pétrole/Bois, solaire, géothermie, aérothermie (pompe à chaleur)/Autre/NSP)"
  label(e[[36]]) <- "transports_travail: Le répondant utilise principalement (la voiture/les TC/la marche ou le vélo/un deux roues motorisé/le covoiturage/non conerné) pour ses trajets domiciles-travail (ou études) - Q39"
  label(e[[37]]) <- "transports_courses: Le répondant utilise principalement (la voiture/les TC/la marche ou le vélo/un deux roues motorisé/le covoiturage/non conerné) pour faire ses courses - Q39"
  label(e[[38]]) <- "transports_loisirs: Le répondant utilise principalement (la voiture/les TC/la marche ou le vélo/un deux roues motorisé/le covoiturage/non conerné) pour ses loisirs (hors vacances) - Q39"
  label(e[[39]]) <- "nb_vehicules_texte: Nombre de véhicules motorisés dont dispose le ménage - Q37"
  label(e[[40]]) <- "km_0: (nb_vehicules=0) Nombre de kilomètres parcourus en voiture ou moto par le répondant lors des 12 derniers mois - Q142"
  label(e[[41]]) <- "fuel_1: (nb_vehicules=1) Carburant du véhicule (Essence/Diesel/Électrique ou hybride/Autre) - Q77"
  label(e[[42]]) <- "conso_1_choix: (nb_vehicules=1) Consommation moyenne du véhicule (L par 100km / NSP) - Q174"
  label(e[[43]]) <- "conso_1: (nb_vehicules=1) Consommation moyenne du véhicule (en litres aux 100 km) - Q174"
  label(e[[44]]) <- "km_1: (nb_vehicules=1) Nombre de kilomètres parcourus par le véhicule lors des 12 derniers mois - Q38"
  label(e[[45]]) <- "fuel_2_1: (nb_vehicules=2) Carburant du véhicule principal (Essence/Diesel/Électrique ou hybride/Autre) - Q100"
  label(e[[46]]) <- "fuel_2_2: (nb_vehicules=2) Carburant du deuxième véhicule (Essence/Diesel/Électrique ou hybride/Autre) - Q101"
  label(e[[47]]) <- "conso_2_choix: (nb_vehicules=2) Consommation moyenne des véhicules du ménage (L par 100km / NSP) - Q176"
  label(e[[48]]) <- "conso_2: (nb_vehicules=2) Consommation moyenne des véhicules du ménage (en litres aux 100 km) - Q176"
  label(e[[49]]) <- "km_2: (nb_vehicules=2) Nombre de kilomètres parcourus par l'ensemble des véhicules lors des 12 derniers mois - Q141"
  label(e[[50]]) <- "solution_CC_progres: Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(e[[51]]) <- "solution_CC_changer: Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(e[[52]]) <- "solution_CC_traite: C’est aux États de réglementer, au niveau mondial, le changement climatique - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(e[[53]]) <- "solution_CC_rien: Il n’y a rien à faire, le changement climatique est inévitable - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(e[[54]]) <- "echelle_politique_CC: Pensez-vous que le changement climatique exige d’être pris en charge par des politiques publiques ... (Nationales; Mondiales; Européennes; Locales; À toutes les échelles)"
  label(e[[55]]) <- "pour_taxe_distance: Augmenter le prix des produits de consommation qui sont acheminés par des modes de transport polluants - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[56]]) <- "pour_renouvelables: Développer les énergies renouvelables même si, dans certains cas, les coûts de production sont plus élevés, pour le moment - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[57]]) <- "pour_densification: Densifier les villes en limitant l’habitat pavillonnaire au profit d’immeubles collectifs - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[58]]) <- "pour_voies_reservees: Favoriser l’usage (voies de circulation, place de stationnement réservées) des véhicules peu polluants ou partagés (covoiturage) - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[59]]) <- "pour_cantines_vertes: Obliger la restauration collective publique à proposer une offre de menu végétarien, biologique et/ou de saison - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[60]]) <- "pour_fin_gaspillage: Réduire le gaspillage alimentaire de moitié - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[61]]) <- "France_CC: Pensez-vous que la France doit prendre de l’avance sur d’autres pays dans la lutte contre le changement climatique ? (Oui; Non; NSP)"
  label(e[[62]]) <- "obstacles_lobbies: Les lobbies - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[63]]) <- "obstacles_manque_volonte: Le manque de volonté politique - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[64]]) <- "obstacles_manque_cooperation: Le manque de coopération entre pays - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[65]]) <- "obstacles_inegalites: Les inégalités - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[66]]) <- "obstacles_incertitudes: Les incertitudes de la communauté scientifique - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[67]]) <- "obstacles_demographie: La démographie - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[68]]) <- "obstacles_technologies: Le manque de technologies alternatives - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[69]]) <- "obstacles_rien: Rien de tout cela - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[70]]) <- "test_qualite: Merci de sélectionner 'Un peu' (Pas du tout/Un peu/Beaucoup/Complètement/NSP) - Q177"
  label(e[[71]]) <- "cause_CC_CCC: Pensez-vous que le changement climatique est dû à (Uniquement à des processus naturels; Uniquement à l'activité humaine; Principalement à des processus naturels; Principalement à l'activité humaine; Autant à des processus naturels qu'à l'activité humaine; Je ne pense pas qu'il y ait un changement climatique; NSP)"
  label(e[[72]]) <- "cause_CC_AT: Cause principale du changement climatique selon le répondant (N'est pas une réalité / Causes naturelles / Activité humaine / NSP) - Q1"
  label(e[[73]]) <- "effets_CC_CCC: Si le changement climatique continue, à votre avis, quelles seront les conséquences en France d'ici une cinquantaine d'années ? (Les conditions de vie deviendront extrêmement pénibles à cause des dérèglements climatiques; Il y aura des modifications de climat mais on s'y adaptera sans trop de mal; Le changement climatique aura des effets positifs pour l'agriculture et les loisirs)"
  label(e[[74]]) <- "effets_CC_AT: Le répondant pense qu'en l'absence de mesures ambitieuse, les effets du changement climatiques seraient (Insignifiants / Faibles / Graves / Désastreux / Cataclysmiques / NSP) - Q5"
  label(e[[75]]) <- "responsable_CC_chacun: Le répondant estime que chacun d'entre nous est responsabe du changement climatique - Q6"
  label(e[[76]]) <- "responsable_CC_riches: Le répondant estime que les plus riches sont responsables du changement climatique - Q6"
  label(e[[77]]) <- "responsable_CC_govts: Le répondant estime que les gouvernements sont responsables du changement climatique - Q6"
  label(e[[78]]) <- "responsable_CC_etranger: Le répondant estime que certains pays étrangers sont responsables du changement climatique - Q6"
  label(e[[79]]) <- "responsable_CC_passe: Le répondant estime que les générations passées sont responsables du changement climatique - Q6"
  label(e[[80]]) <- "responsable_CC_nature: Le répondant estime que des causes naturelles sont responsables du changement climatique - Q6"
  label(e[[81]]) <- "issue_CC: Pensez-vous que le changement climatique sera limité à un niveau acceptable d’ici la fin du siècle  (Oui, certainement; probablement; Non, probablement; certainement pas)"
  label(e[[82]]) <- "parle_CC: Fréquence à laquelle le répondant parle du changement climatique (Plusieurs fois par mois / par an / Presque jamais / NSP) - Q60"
  label(e[[83]]) <- "part_anthropique: À votre avis, quelle est la part des Français qui estiment que le changement climatique est principalement dû à l'activité humaine ? (en %) - Q61"
  label(e[[84]]) <- "efforts_relatifs: ~ Répondant prêt à faire plus d'efforts que la majorité des Français [si variante_vous==1, sinon Est-ce que la majorité est prête à faire plus d'efforts que vous] (Beaucoup/Un peu plus/Autant/Un peu/Beaucoup moins) [réponses recodées pour que leur sens soit indépendant de vairante_vous]"
  label(e[[85]]) <- "soutenu_obligation_renovation: L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(e[[86]]) <- "soutenu_normes_isolation: Des normes plus strictes sur l'isolation pour les nouveaux bâtiments - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(e[[87]]) <- "soutenu_bonus_malus: Un renforcement du bonus/malus écologique pour l’achat d’un véhicule - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(e[[88]]) <- "soutenu_limitation_110: L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(e[[89]]) <- "pour_taxe_carbone_contre: ~ Sachant qu'une majorité est contre - Favorable à une augmentation de la taxe carbone (Oui/Non/NSP) - Q64" # https://www.ademe.fr/sites/default/files/assets/documents/rapport-representations-sociales-changement-climatique-20-vague.pdf 
  label(e[[90]]) <- "pour_taxe_carbone_pour: ~ Sachant qu'une majorité est pour - Favorable à une augmentation de la taxe carbone (Oui/Non/NSP) - Q92" # https://www.ademe.fr/sites/default/files/assets/documents/rapport-analyse-representations-sociales-changement-climatique-19-vague-2018.pdf
  label(e[[91]]) <- "pour_taxe_carbone_neutre: ~ Sans information - Favorable à une augmentation de la taxe carbone (Oui/Non/NSP) - Q92" 
  label(e[[92]]) <- "confiance_gens: D’une manière générale, diriez-vous que… ? (On peut faire confiance à la plupart des gens/On n’est jamais assez prudent quand on a affaire aux autres) - Q65"
  label(e[[93]]) <- "qualite_enfant_independance: l'indépendance - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[94]]) <- "qualite_enfant_tolerance: la tolérance et le respect des autres - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[95]]) <- "qualite_enfant_generosite: la générosité - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[96]]) <- "qualite_enfant_travail: l'assiduité au travail - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[97]]) <- "qualite_enfant_epargne: le sens de l'épargne - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[98]]) <- "qualite_enfant_obeissance: l'obéissance - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[99]]) <- "qualite_enfant_responsabilite: la responsabilité - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[100]]) <- "qualite_enfant_determination: la détermination et la persévérance - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[101]]) <- "qualite_enfant_expression: l'expression personnelle - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[102]]) <- "qualite_enfant_imagination: l'imagination - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[103]]) <- "qualite_enfant_foi: la foi religieuse - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[104]]) <- "redistribution: Que pensez-vous de l’affirmation suivante : « Pour établir la justice sociale, il faudrait prendre aux riches pour donner aux pauvres » ? (0-10)"
  label(e[[105]]) <- "problemes_invisibilises: Avez-vous le sentiment d’être confronté·e personnellement à des difficultés importantes que les pouvoirs publics ou les médias ne voient pas vraiment ? (Très; Assez; Peu souvent; Jamais)"
  label(e[[106]]) <- "importance_environnement: La protection de l'environnement - À quel point est-ce important pour vous ? (0-10)"
  label(e[[107]]) <- "importance_associatif:  L’action sociale et associative - À quel point est-ce important pour vous ? (0-10)"
  label(e[[108]]) <- "importance_confort: L’amélioration de mon niveau de vie et de confort - À quel point est-ce important pour vous ? (0-10)"
  label(e[[109]]) <- "trop_impots: Paie-t-on trop d'impôt en France ? (Oui/Non/Ça dépend qui et quels impôts/NSP)"
  label(e[[110]]) <- "confiance_sortition: Quel est votre niveau de confiance dans la capacité de citoyens tirés au sort à délibérer de manière productive sur des questions politiques complexes ? (Pas du tout/Plutôt pas/Plutôt/Tout à fait confiance)"
  label(e[[111]]) <- "pour_sortition: Seriez-vous favorable à une réforme constitutionnelle qui introduirait une assemblée constituée de 150 citoyens tirés au sort, et qui doterait cette assemblée d'un droit de veto sur les textes de lois votés au Parlement ?"
  label(e[[112]]) <- "connait_CCC: Avez-vous entendu parler de la Convention Citoyenne pour le Climat ? (Oui, je sais très/assez bien ce que c'est/J'en ai entendu parler mais je ne sais pas très bien ce que c'est/Non, je n'en ai jamais entendu parler)"
  label(e[[113]]) <- "connaissance_CCC: Décrivez ce que vous savez de la Convention Citoyenne pour le Climat. (champ libre)"
  label(e[[114]]) <- "sait_CCC_devoilee: [Si pas Non à connait_CCC] Savez-vous si des mesures proposées par la Convention Citoyenne pour le Climat ont déjà été dévoilées ? (Oui, des mesures ont déjà été dévoilées/Je crois avoir entendu parler de mesures de la Convention mais je ne suis pas sûr·e/Aucune mesure n'a été dévoilée à ma connaissance)"
  label(e[[115]]) <- "CCC_inutile: Inutile car le gouvernement ne reprendra que les mesures qui lui plaisent - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[116]]) <- "CCC_prometteuse_climat: Une méthode prometteuse pour définir la politique climatique de la France - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[117]]) <- "CCC_espoir_institutions: Un espoir pour le renouveau des institutions - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[118]]) <- "CCC_vouee_echec: Une expérience vouée à l’échec - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[119]]) <- "CCC_operation_comm: Une opération de communication du gouvernement - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[120]]) <- "CCC_initiative_sincere: Une initiative sincère du gouvernement en faveur de la démocratie - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[121]]) <- "CCC_pour_se_defausser: Une façon pour le gouvernement de se défausser de ses responsabilités - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[122]]) <- "CCC_entendre_francais: Une opportunité pour faire entendre la voix de l’ensemble des Français - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[123]]) <- "CCC_controlee_govt: Une assemblée manipulée ou contrôlée par le gouvernement - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[124]]) <- "CCC_representative: Une assemblée représentative de la population - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[125]]) <- "CCC_autre_choix: Autre - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[126]]) <- "CCC_autre: Autre (champ libre) - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[127]]) <- "CCC_devoile_fonds_mondial_info_CCC: ~ [Si pas Non à sait_CCC_devoilee] Une contribution à un fonds mondial pour le climat - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==1)"
  label(e[[128]]) <- "CCC_devoile_obligation_renovation_info_CCC: ~ [Si pas Non à sait_CCC_devoilee] L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==1)"
  label(e[[129]]) <- "CCC_devoile_taxe_viande_info_CCC: ~ [Si pas Non à sait_CCC_devoilee] Une taxe sur la viande rouge - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==1)"
  label(e[[130]]) <- "CCC_devoile_limitation_110_info_CCC: ~ [Si pas Non à sait_CCC_devoilee] L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==1)"
  label(e[[131]]) <- "first_click:"
  label(e[[132]]) <- "last_click:"
  label(e[[133]]) <- "duree_info_CCC: Temps passé sur la page affichant l'information sur la CCC (info_CCC==1)"
  label(e[[134]]) <- "click_count:"
  label(e[[135]]) <- "concentration_info_CCC: ~ (info_CCC==1) À votre avis, devrions-nous utiliser vos réponses ... ? (Oui, j'ai consacré toute mon attention aux questions jusqu'à présent et je pense que vous devriez utiliser mes réponses pour votre étude/Non, je n'ai pas consacré toute mon attention aux questions jusqu'à présent et je pense que vous ne devriez pas utiliser mes réponses pour votre étude)"
  label(e[[136]]) <- "first_click_:"
  label(e[[137]]) <- "last_click_:"
  label(e[[138]]) <- "duree_concentration: Temps passé sur la page affichant l'avertissement sur la concentration. (info_CCC==0)"
  label(e[[139]]) <- "click_count_:"
  label(e[[140]]) <- "concentration_no_info_CCC: ~ (info_CCC==0) À votre avis, devrions-nous utiliser vos réponses ... ? (Oui, j'ai consacré toute mon attention aux questions jusqu'à présent et je pense que vous devriez utiliser mes réponses pour votre étude/Non, je n'ai pas consacré toute mon attention aux questions jusqu'à présent et je pense que vous ne devriez pas utiliser mes réponses pour votre étude)"
  label(e[[141]]) <- "pour_obligation_renovation: ~ L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[142]]) <- "pour_limitation_110: ~ L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[143]]) <- "pour_restriction_centre_ville: ~ L'interdiction des véhicules les plus polluants dans les centre-villes - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[144]]) <- "pour_conditionner_aides: ~ Le conditionnement des aides à l'innovation versées aux entreprises à la baisse de leur bilan carbone - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[145]]) <- "pour_taxe_viande: ~ Une taxe sur la viande rouge - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[146]]) <- "pour_fonds_mondial: ~ Une contribution à un fonds mondial pour le climat - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[147]]) <- "pour_aides_train: ~ Une baisse des prix des billets de train grâce à des aides de l'État - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[148]]) <- "pour_bonus_malus: ~ Un renforcement du bonus/malus écologique pour l’achat d’un véhicule - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[149]]) <- "referendum_consigne: ~ La mise en place d'un système de consigne de verre et plastique d'ici 2025 - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[150]]) <- "referendum_taxe_dividendes: ~ Une taxe de 4% sur les dividendes des entreprises versant plus de 10 millions d'euros de dividendes, pour financer la transition écologique - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[151]]) <- "referendum_interdiction_polluants: ~ L'interdiction dès 2025 de la vente des véhicules neufs les plus polluants - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[152]]) <- "referendum_interdiction_publicite: ~ L'interdiction de la publicité pour les produits les plus polluants - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[153]]) <- "referendum_cheque_bio: ~ La mise en place de chèque alimentaires pour les plus démunis à utiliser dans les AMAP ou le bio - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[154]]) <- "referendum_obligation_renovation: ~ L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[155]]) <- "CCC_devoile_fonds_mondial_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] Une contribution à un fonds mondial pour le climat - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==0)"
  label(e[[156]]) <- "CCC_devoile_obligation_renovation_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==0)"
  label(e[[157]]) <- "CCC_devoile_taxe_viande_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] Une taxe sur la viande rouge -Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==0)"
  label(e[[158]]) <- "CCC_devoile_limitation_110_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==0)"
  label(e[[159]]) <- "confiance_dividende: ~ [Si question_confiance > 0] Avez-vous confiance dans le fait que l'État vous versera effectivement 110€ par an (220€ pour un couple) si une telle réforme est mise en place ? (Oui/À moitié/Non)"
  label(e[[160]]) <- "hausse_depenses_subjective: ~ À combien estimez-vous alors la hausse des dépenses de combustibles de votre ménage ? (aucune hausse : au contraire, mon ménage réduirait ses dépenses de combustibles/aucune hausse, aucune baisse/entre 1 et 30/30 et 70/70 et 120/120 et 190/à plus de 190 € par an /UC)"
  label(e[[161]]) <- "gagnant_categorie: ~ Ménage Gagnant/Non affecté/Perdant par hausse taxe carbone redistribuée à tous (+110€/an /adulte, +13/15% gaz/fioul, +0.11/13 €/L diesel/essence)"
  label(e[[162]]) <- "certitude_gagnant: ~ Degré de certitude à gain_subjectif (Je suis/suis moyennement/ne suis pas vraiment/ne suis pas du tout sûr·e de ma réponse)"
  label(e[[163]]) <- "taxe_approbation: ~ taxe_approbation: Approbation d'une hausse de la taxe carbone compensée (+110€/an /adulte, +13/15% gaz/fioul, +0.11/13 €/L diesel/essence) (Oui/Non/NSP) ~ origine_taxe (gouvernement/CCC/inconnue) / label_taxe (CCE/taxe)"
  label(e[[164]]) <- "gagnant_feedback_categorie: ~ info si le ménage est gagnant/perdant - Ménage Gagnant/Non affecté/Perdant par hausse taxe carbone redistribuée à tous (+110€/an /adulte, +13/15% gaz/fioul, +0.11/13 €/L diesel/essence)"
  label(e[[165]]) <- "certitude_gagnant_feedback: ~ Degré de certitude à gagnant_categorie (Je suis/suis moyennement/ne suis pas vraiment/ne suis pas du tout sûr·e de ma réponse)"
  label(e[[166]]) <- "taxe_feedback_approbation: ~ info si le ménage est gagnant/perdant - Approbation d'une hausse de la taxe carbone compensée (+110€/an /adulte, +13/15% gaz/fioul, +0.11/13 €/L diesel/essence) (Oui/Non/NSP)"
  label(e[[167]]) <- "interet_politique: Le répondant est intéressé par la politique (Presque pas/Un peu/Beaucoup)"
  label(e[[168]]) <- "confiance_gouvernement: En général, faites-vous confiance au gouvernement pour prendre de bonnes décisions ? (Toujours/La plupart/La moitié du temps/Parfois/Jamais/NSP)"
  label(e[[169]]) <- "extr_gauche: Le répondant se considère comme étant d'extrême gauche"
  label(e[[170]]) <- "gauche: Le répondant se considère comme étant de gauche"
  label(e[[171]]) <- "centre: Le répondant se considère comme étant du centre"
  label(e[[172]]) <- "droite: Le répondant se considère comme étant de droite"
  label(e[[173]]) <- "extr_droite: Le répondant se considère comme étant d'extrême droite"
  label(e[[174]]) <- "conservateur: Le répondant se considère comme étant conservateur"
  label(e[[175]]) <- "liberal: Le répondant se considère comme étant libéral"
  label(e[[176]]) <- "humaniste: Le répondant se considère comme étant humaniste"
  label(e[[177]]) <- "patriote: Le répondant se considère comme étant patriote"
  label(e[[178]]) <- "apolitique: Le répondant se considère comme étant apolitique"
  label(e[[179]]) <- "ecologiste: Le répondant se considère comme étant écologiste"
  label(e[[180]]) <- "actualite: Le répondant se tient principalement informé de l'actualité via la télévision / la presse (écrite ou en ligne) / les réseaux sociaux / la radio"
  label(e[[181]]) <- "gilets_jaunes_dedans: Le répondant déclare faire partie des gilets jaunes"
  label(e[[182]]) <- "gilets_jaunes_soutien: Le répondant soutient les gilets jaunes"
  label(e[[183]]) <- "gilets_jaunes_compris: Le répondant comprend les gilets jaunes"
  label(e[[184]]) <- "gilets_jaunes_oppose: Le répondant est opposé aux gilets jaunes"
  label(e[[185]]) <- "gilets_jaunes_NSP: Le répondant ne sait pas s'il fait partie / s'il soutient / s'il comprend / s'il s'oppose aux gilets jaunes"
  label(e[[186]]) <- "champ_libre: Le sondage touche à sa fin. Vous pouvez désormais inscrire toute remarque, commentaire ou suggestion dans le champ ci-dessous."
  label(e[[187]]) <- "mail: Si vous désirez recevoir les résultats de cette enquête ou participer à la deuxième partie de cette enquête (une fois que la Convention Citoyenne pour le Climat aura rendu ses propositions), vous pouvez inscrire ci-dessous votre adresse mail. Nous ne vous enverrons que deux e-mails en tout."
  label(e[[188]]) <- "id: identifiant Bilendi"
  label(e[[189]]) <- "Q_TotalDuration:"
  label(e[[190]]) <- "exclu: Vide si tout est ok (Screened/QuotaMet sinon)"
  label(e[[191]]) <- "taille_agglo: (PERSO1) Taille d'agglomération: [1;5]=rural/-20k/20-100k/+100k/Région parisienne - embedded data"
  label(e[[192]]) <- "region: Région calculée à partir du code postal: 9 nouvelles régions de l'hexagone + autre (ARA/Est/Ouest/Centre/Nord/IDF/SO/Occ/PACA/autre)"
  label(e[[193]]) <- "gaz: Indicatrice que chauffage = 'Gaz de ville' ou 'Butane, propane, gaz en citerne'"
  label(e[[194]]) <- "fioul: Indicatrice que chauffage = 'Fioul, mazout, pétrole'"
  label(e[[195]]) <- "nb_vehicules: Nombre de véhicules motorisés dont dispose le ménage"
  label(e[[196]]) <- "hausse_depenses: Hausse des dépenses énergétiques simulées pour le ménage, suite à la taxe (élasticité de 0.4/0.2 pour carburants/chauffage)"
  label(e[[197]]) <- "simule_gagnant: Indicatrice sur la prédiction que le ménage serait gagnant avec la taxe compensée, d'après nos simulations"
  label(e[[198]]) <- "hausse_chauffage: Hausse des dépenses de chauffage simulées pour le ménage, suite à la taxe (élasticité de 0.15 au lieu de 0.2)"
  label(e[[199]]) <- "hausse_diesel: Hausse des dépenses de diesel simulées pour le ménage, suite à la taxe (élasticité de 0.4)"
  label(e[[200]]) <- "hausse_essence: Hausse des dépenses d'essence simulées pour le ménage, suite à la taxe (élasticité de 0.4)"
  label(e[[201]]) <- "avant_modifs: indicatrice la version initiale du questionnaire, avant certains changements : séparation du bloc info_ccc et concentration; débuggage de efforts_relatif (avant la seule version était variante_vous=0); affichage de la question mail" # variable valant aléatoirement 0/1 au début du sondage, 2 à partir de 22/04/22h16(FR)
  label(e[[202]]) <- "info_CCC: Indicatrice (aléatoire 0/1) que l'information sur la CCC a été affichée: La Convention Citoyenne pour le Climat est une assemblée indépendante de 150 citoyens tirés au sort qui a pour mandat de faire des propositions permettant de réduire les émissions de gaz à effet de serre françaises dans un esprit de justice sociale. Elle se réunit régulièrement depuis septembre 2019 et va bientôt rendre compte de ses propositions."
  label(e[[203]]) <- "question_confiance: Indicatrice que la question confiance_dividende a été affichée" # Variable aléatoire 0/1/2/3
  label(e[[204]]) <- "variante_efforts_vous: Indicatrice (aléatoire 0/1) que efforts_relatifs est 'vous relativement aux autres' (au contraire, si variante_efforts_vous==0, efforts_relatifs est posée: Est-ce que la majorité est prête à plus d'efforts que vous)"
  label(e[[205]]) <- "origine_taxe: Variante à l'amorce pour la taxe carbone avec dividendes. (inconnue: Imaginez ... / CCC: Imaginez que la CCC propose ... / gouvernement: Imaginez que le gouvernement propsoe ...)"
  label(e[[206]]) <- "label_taxe: Variante à la description de la taxe carbone avec dividendes. (taxe: ... une augmentation de la taxe carbone ... / CCE: une augmentation de la contribution climat-énergie)"
  
  for (i in 1:length(e)) names(e)[i] <- sub(':.*', '', label(e[[i]]))
  return(e)
}

convert_e <- function(e, vague) {
  # lab <- label(e$csp)
  # e$csp <- factor(e$csp, levels=c(levels(e$csp), "Cadres", "Indépendants", "Ouvriers", 'Inactifs', "Professions intermédiaires", "Retraités", "Employés", "Agriculteurs"))
  # e$csp <- as.character(e$csp)
  e$csp[grepl("cadre",e$csp)] <- "Cadre"
  e$csp[grepl("Artisan",e$csp)] <- "Indépendant"
  e$csp[grepl("iaire",e$csp)] <- "Intermédiaire"
  e$csp[grepl("etrait",e$csp)] <- "Retraité"
  e$csp[grepl("Employ",e$csp)] <- "Employé"
  e$csp[grepl("Agricul",e$csp)] <- "Agriculteur"
  e$csp[grepl("Ouvrier",e$csp)] <- "Ouvrier"
  e$csp[grepl("Inactif",e$csp)] <- "Inactif"
  # label(e$csp) <- lab
  # e$csp <- as.factor(e$csp)
  
  for (i in 1:length(e)) {
    # levels(e[[i]]) <- c(levels(e[[i]]), "NSP")
    e[[i]][e[[i]] == "NSP (Ne sais pas, ne se prononce pas)"] <- "NSP"
    e[[i]][e[[i]] == "NSP (Ne sait pas, ne se prononce pas)"] <- "NSP"
    e[[i]][e[[i]] == "NSP (Ne sais pas, ne se prononce pas)."] <- "NSP"
    e[[i]][e[[i]] == "NSP (Ne sait pas, ne se prononce pas)."] <- "NSP"
    e[[i]][e[[i]] == "NSP (Ne sais pas, ne souhaite pas répondre)"] <- "NSP"
    e[[i]][e[[i]] == "NSP (Ne sait pas, ne veut pas répondre)"] <- "NSP"
    e[[i]][e[[i]] == "NSP (Ne veut pas répondre)"] <- "NSP"
    e[[i]][e[[i]] == "Ne se prononce pas"] <- "NSP"
  }

  e$mauvaise_qualite <- 0 # e1: 99% if we exclude those from revenu, 92% otherwise # TODO! (concentration)
  e$mauvaise_qualite[n(e$revenu) > n(e$rev_tot)] <- 1 + e$mauvaise_qualite[n(e$revenu) > n(e$rev_tot)] # e1: 50 (was written 164?); e2: 60
  e$mauvaise_qualite[n(e$revenu) > 10000] <- 1 + e$mauvaise_qualite[n(e$revenu) > 10000] # e1: 58
  e$mauvaise_qualite[n(e$rev_tot) > 10000] <- 1 + e$mauvaise_qualite[n(e$rev_tot) > 10000] # e1: 55
  e$revenu <- clean_number(e$revenu, high_numbers='divide') # TODO: traiter les revenu = 0
  e$rev_tot <- clean_number(e$rev_tot, high_numbers='divide') # TODO: check ça
  # e$revenu[e$revenu > 10000] <- wtd.mean(e$revenu[e$revenu < 10000], weights = e$weight[e$revenu < 10000], na.rm=T)
  # e$rev_tot[e$rev_tot > 10000] <- wtd.mean(e$rev_tot[e$rev_tot < 10000], weights = e$weight[e$rev_tot < 10000], na.rm=T)
  for (i in intersect(c( # TODO: check number outliers
    "revenu", "rev_tot", "taille_menage", "nb_adultes", "nb_14_et_plus", "duree", "km_0", "km_1", "km_2", "conso_1", "conso_2", "surface",
    "obstacles_lobbies", "obstacles_manque_volonte", "obstacles_manque_cooperation", "obstacles_inegalites", "obstacles_incertitudes",
    "obstacles_demographie", "obstacles_technologies", "obstacles_rien", "part_anthropique", "redistribution", "importance_environnement", 
    "importance_associatif", "importance_confort", "duree_info_CCC", "duree_concentration", "question_confiance", "variante_efforts_vous", # "simule_gagnant", # TODO!: create simule_gagnant, simule_gain, perte, gain_net, etc. (don't know if we should add simule_gagnant to this list, it wasn't in the list in May)
    "hausse_chauffage", "hausse_depenses", "hausse_diesel", "hausse_essence", "nb_vehicules"
  ), names(e))) {
    lab <- label(e[[i]])
    e[[i]] <- as.numeric(as.vector(e[[i]]))
    label(e[[i]]) <- lab
  }
  variables_importance <<- paste('importance', c('associatif', 'environnement', 'confort'), sep='_')
  
  # e$mauvaise_qualite[e$taille_menage < e$nb_adultes | e$taille_menage < e$nb_14_et_plus] <- 1.3 + e$mauvaise_qualite[e$taille_menage < e$nb_adultes | e$taille_menage < e$nb_14_et_plus] # 15
  # e$mauvaise_qualite[e$taille_menage > 12] <- 1.3 + e$mauvaise_qualite[e$taille_menage > 12] # 10
  # e$mauvaise_qualite[e$nb_14_et_plus > 10] <- 1 + e$mauvaise_qualite[e$nb_14_et_plus > 10] # 2
  e$taille_menage <- pmin(e$taille_menage, 12)
  e$nb_14_et_plus <- pmin(e$nb_14_et_plus, 10)
  e$nb_adultes <- pmin(e$nb_adultes, 5)
  # e$mauvaise_qualite[e$km > 10^6] <- 1 + e$mauvaise_qualite[e$km > 10^6] # 1
  # e$mauvaise_qualite[e$surface < 9] <- 1 + e$mauvaise_qualite[e$surface < 9] # 6
  # e$mauvaise_qualite[e$surface >= 1000] <- 1 + e$mauvaise_qualite[e$surface >= 1000] # 4
  # label(e$mauvaise_qualite) <- "mauvaise_qualite: Indicatrice d'une réponse aberrante à revenu, taille_menage, nb_14_et_plus, km ou surface."

  for (j in intersect(c("taxe_approbation", "taxe_feedback_approbation", "taxe_alternative_approbation", "pour_sortition"
              ), names(e))) {
    e[j][[1]] <- as.item(as.character(e[j][[1]]),
                labels = structure(c("","Non","NSP","Oui"), names = c("NA","Non","NSP","Oui")),
                missing.values = c("","NSP"), annotation=attr(e[j][[1]], "label"))
  }

  e$pour_taxe_carbone[!is.na(e$pour_taxe_carbone_contre)] <- e$pour_taxe_carbone_contre[!is.na(e$pour_taxe_carbone_contre)]
  e$pour_taxe_carbone[!is.na(e$pour_taxe_carbone_pour)] <- e$pour_taxe_carbone_pour[!is.na(e$pour_taxe_carbone_pour)]
  e$pour_taxe_carbone[!is.na(e$pour_taxe_carbone_neutre)] <- e$pour_taxe_carbone_neutre[!is.na(e$pour_taxe_carbone_neutre)]
  e$variante_taxe_carbone[!is.na(e$pour_taxe_carbone_neutre)] <- 'neutre'
  e$variante_taxe_carbone[!is.na(e$pour_taxe_carbone_contre)] <- 'contre'
  e$variante_taxe_carbone[!is.na(e$pour_taxe_carbone_pour)] <- 'pour'
  label(e$pour_taxe_carbone) <- "pour_taxe_carbone: ~ Favorable à une augmentation de la taxe carbone (Oui/Non/NSP) ~ sachant que majorité de Français pour/contre/no info (variante_taxe_carbone)"
  label(e$variante_taxe_carbone) <- "variante_taxe_carbone: Variante aléatoire pour pour_taxe_carbone: neutre/pour/contre: no info / Selon un sondage de 2018/2019, une majorité de Français est pour/contre une augmentation de la taxe carbone"
  for (j in c("pour_taxe_carbone_pour", "pour_taxe_carbone_contre", "pour_taxe_carbone_neutre", "pour_taxe_carbone"
              )) {
    temp <- as.character(e[j][[1]])
    temp[grepl('Non', temp)] <- 'Non'
    temp[grepl('Oui', temp)] <- 'Oui'
    e[j][[1]] <- as.item(temp,
                labels = structure(c("Non","NSP","Oui"), names = c("Non","NSP","Oui")), missing.values = c("NSP"), annotation=attr(e[j][[1]], "label"))
  }

  for (j in c("chauffage", "parle_CC", "cause_CC_AT", "cause_CC_CCC", "effets_CC_AT", "issue_CC" # , "interet_politique"
              )) {
    if (j %in% c("chauffage", "cause_CC_AT")) e[capitalize(j)] <- e[j][[1]]
    # e[j][[1]] <- as.item(as.character(e[j][[1]]),
    #             labels = structure(levels(factor(e[j][[1]])), names = levels(factor(e[j][[1]]))),
    #             missing.values = c("NSP", ""), annotation=paste(attr(e[j][[1]], "label"), "(char)"))
    e[j][[1]] <- as.item(as.factor(e[j][[1]]), missing.values = c("NSP", "", NA), annotation=paste(attr(e[j][[1]], "label"), "(char)")) 
  }

  for (j in names(e)) {
    if ((grepl('gilets_jaunes_|ecologiste|conservateur|liberal|patriote|humaniste|apolitique|locataire|proprio_|heberge_|solution_CC_|responsable_|centre$|droite|gauche', j)
        | grepl('soutenu_|qualite_enfant_|^CCC_', j))
        & !(grepl('autre$', j)) & !grepl('CCC_devoile_', j)) {
      temp <- label(e[[j]])
      e[[j]] <- e[[j]]!="" # e[[j]][e[[j]]!=""] <- TRUE
      e[[j]][is.na(e[[j]])] <- FALSE
      label(e[[j]]) <- temp
    }
  }
  variables_solution <<- names(e)[grepl('solution_CC', names(e))]
  variables_qualite_enfant <<- names(e)[grepl('qualite_enfant', names(e))]
  variables_responsable_CC <<- paste('responsable_CC', c('chacun', 'govts', 'etranger', 'riches', 'nature', 'passe'), sep='_')
  variables_CCC_avis <<- paste('CCC', c("inutile", "prometteuse_climat", "espoir_institutions", "vouee_echec", "operation_comm", "initiative_sincere", 
                                        "pour_se_defausser", "entendre_francais", "controlee_govt", "representative", "autre_choix"), sep='_')
  
  for (k in c(55:60)) { # pour_
    temp <-  3 * (e[k][[1]]=="Très souhaitable") + grepl("Assez", e[k][[1]]) - grepl("Pas vraiment", e[k][[1]]) - 3 * (e[k][[1]]=="Pas du tout souhaitable")
    e[k][[1]] <- as.item(temp, labels = structure(c(-3,-1,1,3),
                          names = c("Pas du tout","Pas vraiment","Assez","Très")),
                          # names = c("Non, pas du tout","Non, pas vraiment","Indifférent ou Ne sais pas","Oui, plutôt","Oui, tout à fait")),
                        annotation=Label(e[k][[1]]))
  }

  for (k in c(141:148)) { # pour_
    temp <-  2 * (e[k][[1]]=="Oui, tout à fait") + (e[k][[1]]=="Oui, plutôt") - (e[k][[1]]=="Non, pas vraiment") - 2 * (e[k][[1]]=="Non, pas du tout")
    e[k][[1]] <- as.item(temp, labels = structure(c(-2:2),
                          names = c("Pas du tout","Pas vraiment","Indifférent/NSP","Plutôt","Tout à fait")),
                          # names = c("Non, pas du tout","Non, pas vraiment","Indifférent ou Ne sais pas","Oui, plutôt","Oui, tout à fait")),
                        annotation=Label(e[k][[1]]))
  }
  
  if (vague==1) num_CCC_devoile <- c(127:130)
  else num_CCC_devoile <- c(127:130, 180)
  for (k in num_CCC_devoile) { # CCC_devoile_
    j <- ifelse(k==180, 210, k+28)
    temp1 <- -3*(e[k][[1]]=='Non, je suis sûr·e que non') - (e[k][[1]]=='Non, ça ne me dit rien') + (e[k][[1]]=='Oui, il me semble') + 3*(e[k][[1]]=="Oui, j'en suis sûr·e")
    temp2 <- -3*(e[j][[1]]=='Non, je suis sûr·e que non') - (e[j][[1]]=='Non, ça ne me dit rien') + (e[j][[1]]=='Oui, il me semble') + 3*(e[j][[1]]=="Oui, j'en suis sûr·e")
    temp[e$info_CCC==1] <- -3*(e[k][[1]][e$info_CCC==1]=='Non, je suis sûr·e que non') - (e[k][[1]][e$info_CCC==1]=='Non, ça ne me dit rien') + (e[k][[1]][e$info_CCC==1]=='Oui, il me semble') + 3*(e[k][[1]][e$info_CCC==1]=="Oui, j'en suis sûr·e")
    temp[e$info_CCC==0] <- -3*(e[j][[1]][e$info_CCC==0]=='Non, je suis sûr·e que non') - (e[j][[1]][e$info_CCC==0]=='Non, ça ne me dit rien') + (e[j][[1]][e$info_CCC==0]=='Oui, il me semble') + 3*(e[j][[1]][e$info_CCC==0]=="Oui, j'en suis sûr·e")
    e[k][[1]] <- as.item(temp1, labels=structure(c(-3, -1, 1, 3), names = c('Non, sûr', 'Non, me dit rien', 'Oui, me semble', 'Oui, sûr')), annotation=Label(e[k][[1]]))
    e[j][[1]] <- as.item(temp2, labels=structure(c(-3, -1, 1, 3), names = c('Non, sûr', 'Non, me dit rien', 'Oui, me semble', 'Oui, sûr')), annotation=Label(e[j][[1]]))
    e[[sub('_info_CCC', '', names(e)[k])]] <- as.item(temp, labels=structure(c(-3, -1, 1, 3), names = c('Non, sûr', 'Non, me dit rien', 'Oui, me semble', 'Oui, sûr')), 
                             annotation=sub('\\(info_CCC==1\\)', '~ info_CCC', sub('_info_CCC', '', Label(e[k][[1]]))))
  }
  
  if (vague==1) num_referendum <- c(149:154)
  else num_referendum <- c(149:154, 207:209)
  for (k in num_referendum) { # referendum_
    temp <-  0.1 * (e[k][[1]]=="NSP") + (e[k][[1]]=="Oui") - (e[k][[1]]=="Non")
    e[k][[1]] <- as.item(temp, labels = structure(c(0.1,-1:1), names = c("NSP","Non","Blanc","Oui")), missing.values=0.1, annotation=Label(e[k][[1]]))
  }
  
  temp[1:length(e$info_CCC)] <- 'Non'
  temp[grepl('Oui', e$concentration_info_CCC) | grepl('Oui', e$concentration_no_info_CCC)] <- 'Oui'
  e$concentration <- as.item(temp, labels=structure(c('Non', 'Oui'), names = c('Non', 'Oui')), annotation=sub('\\(info_CCC==1\\)', '(info_CCC)', sub('_info_CCC', '', Label(e$concentration_info_CCC))))

  # temp[grepl('Ça dépend',e$trop_impots)] <- 'Ça dépend'
  # temp[!grepl('Ça dépend',e$trop_impots)] <- e$trop_impots[!grepl('Ça dépend',e$trop_impots)] 
  # e$trop_impots <- as.item(as.character(temp), labels = structure(c("NSP", "Non","Ça dépend","Oui"), names = c("NSP","Non","Ça dépend","Oui")), missing.values = c("NSP"), annotation=attr(e$trop_impots, "label"))
  temp <- -1*grepl('Oui', e$trop_impots) + 1*grepl('Non', e$trop_impots) -0.1*grepl('NSP', e$trop_impots)
  e$trop_impots <- as.item(temp, labels = structure(c(-0.1, 1:-1), names = c("NSP","Non","Ça dépend","Oui")), missing.values = -0.1, annotation=attr(e$trop_impots, "label"))

  temp <- (e$parle_CC=='Plusieurs fois par an') + 2*(e$parle_CC=='Plusieurs fois par mois') - (e$parle_CC=="NSP")
  e$parle_CC <- as.item(temp, labels = structure(c(-1:2),
                          names = c("NSP","Presque jamais","Plusieurs fois par an","Plusieurs fois par mois")),
                        missing.values = -1, annotation=Label(e$parle_CC))
  
  temp <- grepl("Faibles", e$effets_CC_AT) + 2*grepl("Graves", e$effets_CC_AT) + 3*grepl("Désastreux", e$effets_CC_AT) + 4*grepl("Cataclysmiques", e$effets_CC_AT) - (e$effets_CC_AT=="NSP")
  e$effets_CC_AT <- as.item(temp, labels = structure(c(-1:4),
                          names = c("NSP","Insignifiants","Faibles","Graves","Désastreux","Cataclysmiques")),
                          # names = c("NSP","Insignifiants, voire bénéfiques","Faibles, car les humains sauraient vivre avec","Graves, car il y aurait plus de catastrophes naturelles","Désastreux, les modes de vie seraient largement altérés","Cataclysmiques, l'humanité disparaîtrait")),
                        missing.values = -1, annotation=Label(e$effets_CC_AT))
  
  # e$cause_CC_CCC <- relabel(e$cause_CC_CCC, "Uniquement à des processus naturels"="Uniquement naturel", "Principalement à des processus naturels"="Principalement naturel", "Autant à des processus naturels qu'à l'activité humaine"="Autant",  "Principalement à l'activité humaine"="Principalement anthropique", "Uniquement à l'activité humaine"="Uniquement anthropique")
  temp <- 1*grepl("uement à l'activité hu", e$cause_CC_CCC) - grepl("Autant", e$cause_CC_CCC) - 2*grepl("incipalement à des processus na", e$cause_CC_CCC) - 3*grepl("iquement à des processus nat", e$cause_CC_CCC) - 4*grepl("ne pense pas", e$cause_CC_CCC)
  temp[is.na(e$cause_CC_CCC)] <- NA
  e$cause_CC_CCC <- as.item(temp, labels = structure(c(-4:1),
                      names = c("N'existe pas","Uniquement naturel","Principalement naturel","Autant","Principalement anthropique","Uniquement anthropique")), annotation=Label(e$cause_CC_CCC))

  temp <- -1*grepl("positif", e$effets_CC_CCC) + grepl("pénible", e$effets_CC_CCC)
  temp[is.na(e$effets_CC_CCC)] <- NA
  e$effets_CC_CCC <- as.item(temp, labels = structure(-1:1, names = c("Effets positifs", "Adaptation sans problème", "Extrêmement pénible")), annotation = Label(e$effets_CC_CCC))
  
  temp <- -3*(e$problemes_invisibilises=='Jamais') - (e$problemes_invisibilises=='Peu souvent') + (e$problemes_invisibilises=='Assez souvent') + 3*(e$problemes_invisibilises=='Très souvent')
  e$problemes_invisibilises <- as.item(temp, labels=structure(c(-3, -1, 1, 3), names = c('Jamais', 'Peu souvent', 'Assez souvent', 'Très souvent')), annotation=Label(e$problemes_invisibilises))

  temp <- -3*(e$issue_CC=='Non, certainement pas') - (e$issue_CC=='Non, probablement pas') + (e$issue_CC=='Oui, probablement') + 3*(e$issue_CC=='Oui, certainement')
  e$issue_CC <- as.item(temp, labels=structure(c(-3, -1, 1, 3), names = c('Non, certainement pas', 'Non, probablement pas', 'Oui, probablement', 'Oui, certainement')), annotation=Label(e$issue_CC))

  if (vague == 2) {
  temp <- -1*grepl('trop petit', e$avis_estimation) - 0.1*grepl('NSP', e$avis_estimation) + 1*grepl('trop élevé', e$avis_estimation)
  e$avis_estimation <- as.item(temp, labels=structure(c(-1, -0.1, 0, 1), names = c('Trop petite', 'NSP', 'Correcte', 'Trop élevée')), missing.values = -0.1, annotation=Label(e$avis_estimation)) }
  # e$Avis_estimation <- as.factor(as.character(e$avis_estimation))
  # e$Avis_estimation <- relevel(e$Avis_estimation, "Trop petite")
  # label(e$Avis_estimation) <- Label(e$avis_estimation) # TODO: correct bug that forces to comment
  
  temp <- -3*(e$confiance_sortition=='Pas du tout confiance') - (e$confiance_sortition=='Plutôt pas confiance') + (e$confiance_sortition=='Plutôt confiance') + 3*(e$confiance_sortition=='Tout à fait confiance')
  e$confiance_sortition <- as.item(temp, labels=structure(c(-3, -1, 1, 3), names = c('Pas du tout confiance', 'Plutôt pas confiance', 'Plutôt confiance', 'Tout à fait confiance')), annotation=Label(e$confiance_sortition))

  temp <- -2*(e$certitude_gagnant=='Je ne suis pas du tout sûr·e de ma réponse') - (e$certitude_gagnant=='Je ne suis pas vraiment sûr·e de ma réponse') + (e$certitude_gagnant=='Je suis sûr·e de ma réponse')
  e$certitude_gagnant <- as.item(temp, labels=structure(c(-2:1), names = c('Pas du tout sûr', 'Pas vraiment sûr', 'Moyennement sûr', 'Sûr')), annotation=Label(e$certitude_gagnant))
  temp <- -1*(e$certitude_gagnant<0) + (e$certitude_gagnant==1)
  e$Certitude_gagnant <- as.item(temp, labels=structure(c(-1:1), names = c('Pas sûr', 'Moyennement sûr', 'Sûr')), annotation=Label(e$certitude_gagnant))
  
  if (vague==1) {
    temp <- -2*(e$certitude_gagnant_feedback=='Je ne suis pas du tout sûr·e de ma réponse') - (e$certitude_gagnant_feedback=='Je ne suis pas vraiment sûr·e de ma réponse') + (e$certitude_gagnant_feedback=='Je suis sûr·e de ma réponse')
    e$certitude_gagnant_feedback <- as.item(temp, labels=structure(c(-2:1), names = c('Pas du tout sûr', 'Pas vraiment sûr', 'Moyennement sûr', 'Sûr')), annotation=Label(e$certitude_gagnant_feedback))
  } else {
    temp <- -2*(e$certitude_gagnant_alternative=='Je ne suis pas du tout sûr·e de ma réponse') - (e$certitude_gagnant_alternative=='Je ne suis pas vraiment sûr·e de ma réponse') + (e$certitude_gagnant_alternative=='Je suis sûr·e de ma réponse')
    e$certitude_gagnant_alternative <- as.item(temp, labels=structure(c(-2:1), names = c('Pas du tout sûr', 'Pas vraiment sûr', 'Moyennement sûr', 'Sûr')), annotation=Label(e$certitude_gagnant_alternative))
  }
  temp <- -2*grepl("Jamais", e$confiance_gouvernement) - grepl("Parfois", e$confiance_gouvernement) + grepl("La plupart", e$confiance_gouvernement) + 2*grepl("Toujours", e$confiance_gouvernement) + 0.1*grepl("NSP", e$confiance_gouvernement)
  e$confiance_gouvernement <- as.item(temp, labels=structure(c(-2:2,0.1), names = c('Jamais', 'Parfois', 'Moitié du temps', 'Plupart du temps', 'Toujours', 'NSP')), missing.values=0.1, annotation=Label(e$confiance_gouvernement))
  
  if (vague==1) {
    temp <- 1*(e$confiance_dividende=='Oui') + 0.5*(e$confiance_dividende=='À moitié')
    e$confiance_dividende <- as.item(temp, labels=structure(c(0, 0.5, 1), names=c('Non', 'À moitié', 'Oui')), annotation=Label(e$confiance_dividende)) }

  temp <- - grepl("Non", e$connait_CCC) + grepl("Oui, je sais assez", e$connait_CCC) + 2*grepl("Oui, je sais très bien", e$connait_CCC)
  e$connait_CCC <- as.item(temp, labels=structure(c(-1:2), names = c('Non', 'Vaguement', 'Oui, assez', 'Oui, très')), annotation=Label(e$connait_CCC))

  temp <- - grepl("Aucune", e$sait_CCC_devoilee) + grepl("Oui", e$sait_CCC_devoilee)
  is.na(temp) <- is.na(e$sait_CCC_devoilee)
  e$sait_CCC_devoilee <- as.item(temp, labels=structure(c(-1:1), names = c('Non', 'Pas sûr', 'Oui')), annotation=Label(e$sait_CCC_devoilee))

  temp <- -1*grepl('Non', e$France_CC) + grepl('Oui', e$France_CC)
  e$France_CC <- as.item(temp, labels = structure(-1:1, names = c('Non', ' NSP ', 'Oui')), annotation=Label(e$France_CC)) # missing.values = 0, 

  if (vague==1) {
    e$question_confiance <- e$question_confiance > 0
    e$avant_modifs <- e$avant_modifs != 2
    e$duree_info_CCC[e$avant_modifs==T] <- NA # /!\ comment these two lines to see the duration avant_modifs, when info CCC & concentration were on the same page
    e$variante_efforts_vous[e$avant_modifs==T] <- 0 }

  temp <- e$efforts_relatifs
  e$efforts_relatifs[temp=='Un peu moins' & e$variante_efforts_vous==0] <- 'Un peu plus'
  e$efforts_relatifs[temp=='Un peu plus' & e$variante_efforts_vous==0] <- 'Un peu moins'
  e$efforts_relatifs[temp=='Beaucoup moins' & e$variante_efforts_vous==0] <- 'Beaucoup plus'
  e$efforts_relatifs[temp=='Beaucoup plus' & e$variante_efforts_vous==0] <- 'Beaucoup moins'
  temp <- -2*(e$efforts_relatifs=='Beaucoup moins') - (e$efforts_relatifs=='Un peu moins') + 2*(e$efforts_relatifs=='Beaucoup plus') + 1*(e$efforts_relatifs=='Un peu plus')
  e$efforts_relatifs <- as.item(temp, labels=structure(c(-2:2), names = c('Beaucoup moins', 'Un peu moins', 'Autant', 'Un peu plus', 'Beaucoup plus')), annotation=Label(e$efforts_relatifs))

  temp <- 20.90*(e$age == "18 à 24 ans") + 29.61*(e$age == "25 à 34 ans") + 42.14*(e$age == "35 à 49 ans") + 56.84*(e$age == "50 à 64 ans") + 75.43*(e$age == "65 ans ou plus")
  e$age <- as.item(temp, labels = structure(c(20.90, 29.61, 42.14, 56.84, 75.43), names = c("18-24", "25-34", "35-49", "50-64", "65+")), annotation=Label(e$age))
  # e$Age <- (e$age == "18 à 24 ans") + 2*(e$age == "25 à 34 ans") + 3.3*(e$age == "35 à 49 ans") + 4.6*(e$age == "50 à 64 ans") + 7*(e$age == "65 ans ou plus")
  e$taille_agglo <- as.numeric(sub('CC ', '', e$taille_agglo))
  e$taille_agglo <- as.item(as.numeric(e$taille_agglo), labels = structure(1:5, names = c("rural", "-20k", "20-100k", "+100k", "Paris")), annotation=Label(e$taille_agglo))
  temp <- 1*grepl('10 001', e$patrimoine) + 2*grepl('60 001', e$patrimoine) + 3*grepl('180 001', e$patrimoine) + 4*grepl('350 001', e$patrimoine) + 5*grepl('Plus de', e$patrimoine) - 1*grepl('NSP', e$patrimoine)
  e$patrimoine <- as.item(as.numeric(temp), missing.values=-1, labels = structure(-1:5, names = c("NSP", "< 10k", "10-60k", "60-180k", "180-350k", "350-550k", "> 550k")), annotation=Label(e$patrimoine))  
  
  e$Diplome <- (e$diplome == "Brevet des collèges") + 2*(e$diplome=="CAP ou BEP") + 3*(e$diplome=="Baccalauréat") + 4*(e$diplome=="Bac +2 (BTS, DUT, DEUG, écoles de formation sanitaires et sociales...)") + 5*(e$diplome=="Bac +3 (licence...)") + 6*(e$diplome=="Bac +5 ou plus (master, école d'ingénieur ou de commerce, doctorat, médecine, maîtrise, DEA, DESS...)") - (e$diplome=="NSP (Ne se prononce pas)")
  e$diplome4 <- as.item(pmin(pmax(e$Diplome, 1), 4), labels = structure(1:4, names = c("Aucun diplôme ou brevet", "CAP ou BEP", "Baccalauréat", "Supérieur")), annotation=Label(e$diplome))  

  e$chauffage <- relabel(e$chauffage, "Gaz de ville"="Gaz réseau", "Butane, propane, gaz en citerne"="Gaz bouteille", "Fioul, mazout, pétrole"="Fioul", "Électricité"="Électricité", "Bois, solaire, géothermie, aérothermie (pompe à chaleur)"="Bois, solaire...", "Autre"="Autre", "NSP"="NSP")
  e$cause_CC_AT <- relabel(e$cause_CC_AT, "n'est pas une réalité"="n'existe pas", "est principalement dû à la variabilité naturelle du climat"="naturel", "est principalement dû à l'activité humaine"="anthropique", "NSP"="NSP")
  # e$confiance_gens <- relabel(as.factor(e$confiance_gens), "On peut faire confiance à la plupart des gens"="Confiant", "On n’est jamais assez prudent quand on a affaire aux autres"="Méfiant")
  # label(e$confiance_gens) <- "confiance_gens: D’une manière générale, diriez-vous que… ? (On peut faire confiance à la plupart des gens/On n’est jamais assez prudent quand on a affaire aux autres) - Q65"
  
  e$confiance_gens <- as.item(as.character(e$confiance_gens), labels = structure(c("On peut faire confiance à la plupart des gens", "On n’est jamais assez prudent quand on a affaire aux autres"), names = c("Confiance", "Méfiance")), annotation=Label(e$confiance_gens))
  
  e$gauche_droite <- pmax(-2,pmin(2,-2 * e$extr_gauche - 1*e$gauche + 1*e$droite + 2 * e$extr_droite))
  is.na(e$gauche_droite) <- (e$gauche_droite == 0) & !e$centre
  e$Gauche_droite <- as.factor(e$gauche_droite)
  e$gauche_droite <- as.item(as.numeric(as.vector(e$gauche_droite)), labels = structure(c(-2:2),
                          names = c("Extrême gauche","Gauche","Centre","Droite","Extrême droite")), annotation="gauche_droite:échelle de -2 (extr_gauche) à +2 (extr_droite) - Orientation politique (Comment vous définiriez-vous ? Plusieurs réponses possibles: (D'extrême) gauche/Du centre/(D'extrême) droite/Libéral/Humaniste/Patriote/Apolitique/Écologiste/Conservateur (champ libre)/NSP)")
  levels(e$Gauche_droite) <- c("Extreme-left", "Left", "Center", "Right", "Extreme-right", "Indeterminate")
  e$Gauche_droite[is.na(e$Gauche_droite)] <- "Indeterminate"
  e$indeterminate <- e$Gauche_droite == "Indeterminate"
  e$gauche_droite_nsp <- as.character(e$gauche_droite)
  e$gauche_droite_nsp[e$Gauche_droite=='Indeterminate'] <- 'NSP'
  e$gauche_droite_nsp <- as.factor(e$gauche_droite_nsp)
  e$gauche_droite_nsp <- relevel(relevel(e$gauche_droite_nsp, "Gauche"), "Extrême gauche")
  
  temp <- Label(e$interet_politique)
  e$interet_politique <- 1*(e$interet_politique=='Un peu') + 2*(e$interet_politique=='Beaucoup')
  e$interet_politique <- as.item(e$interet_politique, labels=structure(c(0:2), names=c('Presque pas', 'Un peu', 'Beaucoup')), annotation=temp)

  e$gilets_jaunes[e$gilets_jaunes_NSP==T] <- -0.1
  e$gilets_jaunes[e$gilets_jaunes_compris==T] <- 0 # total à 115%
  e$gilets_jaunes[e$gilets_jaunes_oppose==T] <- -1 # 2 oppose et soutien en même temps
  e$gilets_jaunes[e$gilets_jaunes_soutien==T] <- 1
  e$gilets_jaunes[e$gilets_jaunes_dedans==T] <- 2
  e$gilets_jaunes <- as.item(e$gilets_jaunes, missing.values=-0.1, labels = structure(c(-0.1,-1:2), names=c('NSP', "s'oppose", 'comprend', 'soutient', 'en est')),
                             annotation="gilets_jaunes: Que pensez-vous des gilets jaunes ? -1: s'oppose / 0: comprend sans soutenir ni s'opposer / 1: soutient / 2: fait partie des gilets jaunes (gilets_jaunes_compris/oppose/soutien/dedans/NSP)" )
  e$Gilets_jaunes <- as.character(e$gilets_jaunes)
  e$Gilets_jaunes[e$gilets_jaunes=="NSP"] <- "NSP"
  e$Gilets_jaunes <- as.factor(e$Gilets_jaunes)
  e$Gilets_jaunes <- relevel(e$Gilets_jaunes, 'soutient')
  e$Gilets_jaunes <- relevel(e$Gilets_jaunes, 'comprend')
  e$Gilets_jaunes <- relevel(e$Gilets_jaunes, 'NSP')
  e$Gilets_jaunes <- relevel(e$Gilets_jaunes, "s'oppose")
  label(e$Gilets_jaunes) <- "Gilets_jaunes: Que pensez-vous des gilets jaunes ? -1: s'oppose / 0: comprend sans soutenir ni s'opposer / 1: soutient / 2: fait partie des gilets jaunes (gilets_jaunes_compris/oppose/soutien/dedans/NSP)"

  e$echelle_politique_CC <- -2*(e$echelle_politique_CC=='à toutes les échelles') -1*(e$echelle_politique_CC=='mondiales') + (e$echelle_politique_CC=='nationales') + 2*(e$echelle_politique_CC=='locales')
  e$echelle_politique_CC <- as.item(e$echelle_politique_CC, labels = structure(c(-2:2), names=c('à toutes les échelles', "mondiale", 'européenne', 'nationale', 'locale')), annotation=Label(e$echelle_politique_CC) )
  # e$echelle_politique_CC <- relevel(as.factor(e$echelle_politique_CC), 'nationales')
  # e$echelle_politique_CC <- relevel(e$echelle_politique_CC, 'européennes')
  # e$echelle_politique_CC <- relevel(e$echelle_politique_CC, 'mondiales')
  # e$echelle_politique_CC <- relevel(e$echelle_politique_CC, 'à toutes les échelles')
    
  e$statut_emploi[e$statut_emploi=="autre actif/ve"] <- "autre actif"
  e$statut_emploi[e$statut_emploi=="inactif/ve"] <- "inactif"
  e$retraites <- e$statut_emploi == 'retraité·e' 
  e$actifs <- e$statut_emploi %in% c("autre actif", "CDD", "CDI", "fonctionnaire", "intérimaire ou contrat précaire")
  e$etudiants <- e$statut_emploi == 'étudiant·e'
  e$inactif <- e$statut_emploi %in% c("inactif", "au chômage")
  label(e$retraites) <- "retraites: statut_emploi == 'retraité·e'"
  label(e$actifs) <- 'actifs: statut_emploi %in% c("autre actif", "CDD", "CDI", "fonctionnaire", "intérimaire ou contrat précaire")'
  label(e$etudiants) <- "etudiants: statut_emploi == 'étudiant·e'"
  label(e$inactif) <- 'inactif: statut_emploi %in% c("inactif", "au chômage")'
  e$single <- 1*(e$nb_adultes==1)
  label(e$single) <- "single: nb_adultes == 1"

	region_code <- function(code) {
	  reg <- "autre"
	  regions <- list(
      "ARA" = c('01', '03', '07', '15', '26', '38', '42', '43', '63', '69', '73', '74'),
    	"Est" = c('21', '25', '39', '58', '70', '71', '89', '90', '08', '10', '51', '52', '54', '55', '57', '67', '68', '88'),
    	"Ouest" = c('22', '29', '35', '56', '14', '27', '50', '61', '76' ),
    	"Centre" = c('18', '28', '36', '37', '41', '45', '44', '49', '53', '72', '85'),
    	"Nord" = c('02', '59', '60', '62', '80'),
    	"IDF" = c('75', '77', '78', '91', '92', '93', '94', '95'),
    	"SO" = c('16', '17', '19', '23', '24', '33', '40', '47', '64', '79', '86', '87'),
    	"Occ" = c('09', '11', '12', '30', '31', '32', '34', '46', '48', '65', '66', '81', '82'),
    	"PACA" = c( '04', '05', '06', '13', '83', '84')
	  )
  	for (i in 1:9) if (as.numeric(code) %in% as.numeric(regions[[i]])) reg <- names(regions)[i]
	  return(reg)
	} 
  region_dep <- rep("", 95)
  for (i in 1:95) region_dep[i] <- region_code(i)
  e$region_verif <- "autre"
  e$region_verif[as.numeric(substr(e$code_postal, 1, 2)) %in% 1:95] <- region_dep[as.numeric(substr(e$code_postal, 1, 2))][as.numeric(substr(e$code_postal, 1, 2)) %in% 1:95]
  e$region[is.na(e$region)] <- 'autre'
  e$nb_vehicules_verif <- (e$nb_vehicules_texte=='Un') + 2*(e$nb_vehicules_texte=='Deux ou plus')

  e$km[!is.na(e$km_0)] <- e$km_0[!is.na(e$km_0)]
  e$km[!is.na(e$km_1)] <- e$km_1[!is.na(e$km_1)]
  e$km[!is.na(e$km_2)] <- e$km_2[!is.na(e$km_2)]
  label(e$km) <- "km: Nombre de kilomètres parcourus lors des 12 derniers mois en voiture ou moto (par le répondant pour nb_vehicules=0, par les véhicules sinon)"
 
  if (vague==1) {
    e$conso[!is.na(e$conso_1)] <- e$conso_1[!is.na(e$conso_1)]
    e$conso[!is.na(e$conso_2)] <- e$conso_2[!is.na(e$conso_2)]
    e$conso[is.na(e$conso)] <- (6.39 + 7.31) / 2 # R round(0.5)=0 (JS = 1) and the code here does not exploit the fact that we may know whether it's diesel or essence: conso_embedded is better, but exists only for e2
  } else e$conso <- n(e$conso_embedded) 
  label(e$conso) <- "conso:  Consommation moyenne du véhicule (en litres aux 100 km)"
  
  # e$mauvaise_qualite[e$conso > 90] <- 1 + e$mauvaise_qualite[e$conso > 90] # 28
  e$km_original <- e$km
  e$conso_original <- e$conso
  e$surface_original <- e$surface
  e$km <- pmin(e$km, 200000) # TODO ?? e$km[877] <- 1130 [586] <- 2250
  e$conso <- pmin(e$conso, 30) # e$conso[851] <- 6.1
  e$surface <- pmin(e$surface, 650) # 
  e$conso_1 <- pmin(e$conso_1, 30) # 
  e$conso_2 <- pmin(e$conso_2, 30) # 
  
  e$age_18_24 <- 1*(e$age == '18-24')
  e$age_25_34 <- 1*(e$age == '25-34')
  e$age_35_49 <- 1*(e$age == '35-49')
  e$age_50_64 <- 1*(e$age == '50-64')
  e$age_65_plus <- 1*(e$age == '65+')
  
  e$tax_approval <- e$taxe_approbation=='Oui'
  e$tax_acceptance <- e$taxe_approbation!='Non'
  label(e$tax_approval) <- "tax_approval: Approbation initiale de la hausse de la taxe carbone compensée: taxe_approbation=='Oui'"
  label(e$tax_acceptance) <- "tax_acceptance: Acceptation initiale de la hausse de la taxe carbone compensée: taxe_approbation!='Non'"

  # TODO!: simule_gagnant faux (?), vague 2, gagnant_alternative_categorie/tax_alternative_acceptance
  if (vague==1) {
    e$tax_feedback_approval <- e$taxe_feedback_approbation=='Oui'
    e$tax_feedback_acceptance <- e$taxe_feedback_approbation!='Non'
    label(e$tax_feedback_approval) <- "tax_feedback_approval: Approbation après le feedback de la hausse de la taxe carbone compensée: taxe_feedback_approbation=='Oui'"
    label(e$tax_feedback_acceptance) <- "tax_feedback_acceptance: Acceptation après le feedback de la hausse de la taxe carbone compensée: taxe_feedback_approbation!='Non'"

    e$update_correct <- ((e$simule_gagnant==1 & e$gagnant_feedback_categorie=='Gagnant' & e$gagnant_categorie!='Gagnant')
                         + (e$simule_gagnant==0 & e$gagnant_feedback_categorie=='Perdant' & e$gagnant_categorie!='Perdant')
                         - (e$simule_gagnant==1 & e$gagnant_feedback_categorie=='Perdant' & e$gagnant_categorie!='Perdant')
                         - (e$simule_gagnant==0 & e$gagnant_feedback_categorie=='Gagnant' & e$gagnant_categorie!='Gagnant'))
    label(e$update_correct) <- "update_correct: Différence entre l'indicatrice de ne pas se penser gagnant/perdant et le penser après feedback infirmant, moins la même après feedback confirmant"
    e$update_correct_large <- ((e$simule_gagnant==1 & ((e$gagnant_feedback_categorie=='Gagnant' & e$gagnant_categorie!='Gagnant') | (e$gagnant_feedback_categorie!='Perdant' & e$gagnant_categorie=='Perdant')))
                               + (e$simule_gagnant==0 & ((e$gagnant_feedback_categorie=='Perdant' & e$gagnant_categorie!='Perdant') | (e$gagnant_feedback_categorie!='Gagnant' & e$gagnant_categorie=='Gagnant')))
                               - (e$simule_gagnant==1 & ((e$gagnant_feedback_categorie=='Perdant' & e$gagnant_categorie!='Perdant') | (e$gagnant_feedback_categorie!='Gagnant' & e$gagnant_categorie=='Gagnant')))
                               - (e$simule_gagnant==0 & ((e$gagnant_feedback_categorie=='Gagnant' & e$gagnant_categorie!='Gagnant') | (e$gagnant_feedback_categorie!='Perdant' & e$gagnant_categorie=='Perdant'))))
    label(e$update_correct_large) <- "update_correct_large: Différence entre faire un update dans la bonne direction quand le feedback y conduit et faire un update dans la mauvaise direction"


    e$feedback_confirme <- (e$gagnant_categorie=='Gagnant' & e$simule_gagnant==1) | (e$gagnant_categorie=='Perdant' & e$simule_gagnant==0)
    e$feedback_infirme <- (e$gagnant_categorie=='Perdant' & e$simule_gagnant==1) | (e$gagnant_categorie=='Gagnant' & e$simule_gagnant==0)
    e$feedback_confirme_large <- e$feedback_confirme | (e$gagnant_categorie!='Perdant' & e$simule_gagnant==1) | (e$gagnant_categorie!='Gagnant' & e$simule_gagnant==0)
    e$feedback_infirme_large <- e$feedback_infirme | (e$gagnant_categorie!='Perdant' & e$simule_gagnant==0) | (e$gagnant_categorie!='Gagnant' & e$simule_gagnant==1)
    label(e$feedback_confirme) <- "feedback_confirme: Indicatrice de se penser et être simulé gagnant/perdant (gagnant_categorie, simule_gagnant)"
    label(e$feedback_infirme) <- "feedback_infirme: Indicatrice de se penser gagnant et être simulé perdant, ou l'inverse (gagnant_categorie, simule_gagnant)"
    label(e$feedback_confirme_large) <- "feedback_confirme_large: Indicatrice de se penser non perdant et être simulé gagnant, ou de se penser non gagnant et être simulé perdant (gagnant_categorie, simule_gagnant)"
    label(e$feedback_infirme_large) <- "feedback_infirme_large: Indicatrice de se penser non gagnant et être simulé gagnant, ou de se penser non perdant et être simulé perdant (gagnant_categorie, simule_gagnant)"
     
    e$winning_category <- as.factor(e$gagnant_categorie)
    e$winning_feedback_category <- as.factor(e$gagnant_feedback_categorie)
    levels(e$winning_category) <- c('Winner', 'Unaffected', 'Loser')
    levels(e$winning_feedback_category) <- c('Winner', 'Unaffected', 'Loser')
    label(e$winning_category) <- "Winning category before feedback"
    label(e$winning_feedback_category) <- "Winning category after feedback"
  } else {
    e$variante_alternative <- ifelse(e$dividende != 170 & e$random != 0, "urba", "détaxe")
    label(e$variante_alternative) <- "variante_alternative: Variante affiché pour taxe avec dividende alternative: urba/détaxe. urba: Dividende différencié en fonction du lieu d'habitation (88-133e centre-ville - rural). détaxe: 1tCO2 gratuite/pers (50e remboursable e.g. en station-service), le reste reversé en dividende."
  }
#   e$gaz <- grepl('gaz', e$chauffage, ignore.case = T)
#   e$fioul <- grepl('fioul', e$chauffage, ignore.case = T)
#   e$hausse_chauffage <- -55.507189 + e$gaz * 124.578484 + e$fioul * 221.145441 + e$surface * 0.652174  
  # hausses telles que calculées sans bug. Ces calculs ne sont valables que pour e1; pour e2 on a mis à jour les prix de l'essence etc. dans qualtrics, donc la version non _verif est plus correcte
	e$hausse_diesel_verif[e$nb_vehicules == 0] <- (0.5*(6.39/100) * e$km * 1.4 * (1 - 0.4) * 0.090922)[e$nb_vehicules == 0] # share_diesel * conso * km * price * (1-elasticite) * price_increase
	e$hausse_diesel_verif[e$nb_vehicules == 1] <- ((e$fuel_1=='Diesel') * (ifelse(is.na(e$conso_1), 6.39, e$conso_1)/100) * e$km * 1.4 * (1 - 0.4) * 0.090922)[e$nb_vehicules == 1] # DONE: replaced e$conso
  e$hausse_diesel_verif[e$nb_vehicules == 2] <- (((e$fuel_2_1=='Diesel')*2/3 + (e$fuel_2_2=='Diesel')/3) * (ifelse(is.na(e$conso_2), 6.39, e$conso_2)/100) * e$km * 1.4 * (1 - 0.4) * 0.090922)[e$nb_vehicules == 2]
	e$hausse_essence_verif[e$nb_vehicules == 0] <- (0.5*(7.31/100) * e$km * 1.45 * (1 - 0.4) * 0.076128)[e$nb_vehicules == 0] # share_diesel * conso * km * price * (1-elasticite) * price_increase
	e$hausse_essence_verif[e$nb_vehicules == 1] <- ((e$fuel_1!='Diesel') * (ifelse(is.na(e$conso_1), 7.31, e$conso_1)/100) * e$km * 1.45 * (1 - 0.4) * 0.076128)[e$nb_vehicules == 1]
  e$hausse_essence_verif[e$nb_vehicules == 2] <- (((e$fuel_2_1!='Diesel')*2/3 + (e$fuel_2_2!='Diesel')/3) * (ifelse(is.na(e$conso_2), 7.31, e$conso_2)/100) * e$km * 1.45 * (1 - 0.4) * 0.076128)[e$nb_vehicules == 2]

  # hausses sans tenir compte de la conso renseignée
  e$hausse_diesel_verif_na[e$nb_vehicules == 0] <- (0.5*(6.39/100) * e$km * 1.4 * (1 - 0.4) * 0.090922)[e$nb_vehicules == 0] # share_diesel * conso * km * price * (1-elasticite) * price_increase
	e$hausse_diesel_verif_na[e$nb_vehicules == 1] <- ((e$fuel_1=='Diesel') * (6.39/100) * e$km * 1.4 * (1 - 0.4) * 0.090922)[e$nb_vehicules == 1] # DONE: replaced e$conso
  e$hausse_diesel_verif_na[e$nb_vehicules == 2] <- (((e$fuel_2_1=='Diesel')*2/3 + (e$fuel_2_2=='Diesel')/3) * (6.39/100) * e$km * 1.4 * (1 - 0.4) * 0.090922)[e$nb_vehicules == 2]
	e$hausse_essence_verif_na[e$nb_vehicules == 0] <- (0.5*(7.31/100) * e$km * 1.45 * (1 - 0.4) * 0.076128)[e$nb_vehicules == 0] # share_diesel * conso * km * price * (1-elasticite) * price_increase
	e$hausse_essence_verif_na[e$nb_vehicules == 1] <- ((e$fuel_1!='Diesel') * (7.31/100) * e$km * 1.45 * (1 - 0.4) * 0.076128)[e$nb_vehicules == 1]
  e$hausse_essence_verif_na[e$nb_vehicules == 2] <- (((e$fuel_2_1!='Diesel')*2/3 + (e$fuel_2_2!='Diesel')/3) * (7.31/100) * e$km * 1.45 * (1 - 0.4) * 0.076128)[e$nb_vehicules == 2]
  # bug: conso_2=NA pour conso_2_choix=NSP & fuel_2_1=Diesel, créant le même bug simule_gagnant=1 et hausse_depenses=NA decrit(e1$fuel_2_1[e1$bug==F & is.na(e1$hausse_depenses)]) decrit(e1$conso_2_choix[e1$bug==F & is.na(e1$hausse_depenses)]) (bug de nouveau dans le pilote 2)
  # c'était dû à une coquille (conso_2_1 était écrit au lieu de conso2_1). ça concerne 17 obs. parmi les 190 premières, i.e. pour date_enregistree <= "2020-10-09 03:06:24"
  e$bug <- e$date_enregistree < "2020-04-28 05:55:00" # 1:792: T / 793:1003: F
  e$bug_touche <- (e$fuel_2_1=='Diesel' &  !is.na(e$fuel_2_1)) & e$bug
  
  e$hausse_depenses_verif <- e$hausse_diesel_verif + e$hausse_essence_verif + e$hausse_chauffage # hausses telles que calculées sans bug (celle utilisée pour bug==F)
  e$hausse_depenses_verif_na <- e$hausse_diesel_verif_na + e$hausse_essence_verif_na + e$hausse_chauffage # hausses sans tenir compte de la conso renseignée (celle utilisée pour bug==T)
  e$feedback_correct <- (round(e$conso)==7 & !(e$fuel_2_1 %in% c('Diesel'))) | (!e$bug)

 # /!\ avant 28/04 18h55 FR, hausse_diesel et _essence correspondaient à _verif_na, i.e. la conso renseignée n'étaient pas prise en compte. Il y avait un bug quand fuel_2_1 == Diesel, de sorte que tous ces gens avaient le feedback Gagnant et conso = NaN
#   e$hausse_carburants <- e$hausse_diesel + e$hausse_essence
#   e$depense_carburants <- (e$hausse_diesel / 0.090922 + e$hausse_essence / 0.076128) / (1 - 0.4)
#   label(e$hausse_carburants) <- "hausse_carburant: Hausse des dépenses de carburants simulées pour le ménage, suite à la taxe (élasticité de 0.4) (hausse_diesel + hausse_essence)"
#   label(e$depense_carburants) <- "depense_carburants: Dépense de carburants annuelle estimée du ménage, avant la réforme"
#   e$hausse_depenses <- e$hausse_carburants + e$hausse_chauffage
  e$diesel <- (!is.na(e$fuel_1) & (e$fuel_1=='Diesel')) | (!is.na(e$fuel_2_2) & ((e$fuel_2_1=='Diesel') | (e$fuel_2_2=='Diesel')))
  e$essence <- (!is.na(e$fuel_1) & (e$fuel_1=='Essence')) | (!is.na(e$fuel_2_2) & ((e$fuel_2_1=='Essence') | (e$fuel_2_2=='Essence')))
  label(e$diesel) <- "diesel: Indicatrice de la possession d'un véhicule diesel par le ménage (fuel_1 ou fuel_2_1 ou fuel_2_2 = 'Diesel')"
  label(e$essence) <- "essence: Indicatrice de la possession d'un véhicule à essence par le ménage (fuel_1 ou fuel_2_1 ou fuel_2_2 = 'Essence')"

  e$revenu_conjoint <- e$rev_tot - e$revenu
  e$revdisp <- round((e$rev_tot -  irpp(e$rev_tot, e$nb_adultes, e$taille_menage)))
  e$uc <- uc(e$taille_menage, e$nb_14_et_plus)
  e$niveau_vie <- e$revdisp / e$uc
  
  e$fioul <- n(e$fioul)
  e$gaz <- n(e$gaz)
  if (vague==1) {
    e$perte <- 1 + round(as.numeric(gsub("\\D*", "", sub("\\set.*", "", sub("\\D*", "", e$hausse_depenses_subjective))))/45)
    e$perte[grepl('au contraire', e$hausse_depenses_subjective)] <- -1
    e$perte[grepl('aucune baisse', e$hausse_depenses_subjective)] <- 0
    label(e$perte) <- "perte: Catégorie de hausse_depenses_subjective par UC, suite à hausse taxe carbone compensée, dans [-1;5] (seuils: 0/1/30/70/120/190)"
  
    e$perte_echelle <- e$perte
    label(e$perte) <- "perte: Catégorie de hausse_depenses_subjective (€ par UC par an), suite à hausse taxe carbone compensée, dans [-1;5] (seuils: 0/1/30/70/120/190)"
  
    # cf. consistency_belief_losses.py pour les imputations. Average of BdF in each bin has been used.
    e$perte_min <- -30*(e$perte==-1) + 1*(e$perte==1) + 30*(e$perte==2) + 70*(e$perte==3) + 120*(e$perte==4) + 190*(e$perte==5)
    e$perte_max <-   0*(e$perte==-1) + 30*(e$perte==1) + 70*(e$perte==2) + 120*(e$perte==3) + 190*(e$perte==4) + 2000*(e$perte==5)
    temp <- 224.25*(e$perte==5) + 147.91*(e$perte==4) + 92.83*(e$perte==3) + 48.28*(e$perte==2) + 13.72*(e$perte==1) - 1.66*(e$perte==-1) # TODO?: recalculer, surtout perte==5 (qui correspond à [190;280] au lieu de >190) et perte==-1 (ne sait pas d'où il sort). Pour info 405.55*(perte==6)
    e$perte <- as.item(temp, labels = structure(c(224.25, 147.91, 92.83, 48.28, 13.72, 0, -1.66), names = c(">190", "120-190", "70-120", "30-70", "0-30", "0", "<0")), annotation=Label(e$perte))
    
    e$simule_gain_menage <- 16.1 + pmin(2, e$nb_adultes) * 110 - e$hausse_depenses # NA pour les répondants chez qui le fuel_2_1=='Diesel' créait un bug (et qui avait tout le temps simule_gagnant==1) (élasticité de 0.15 sur le gaz)
    e$simule_gain_repondant <- 16.1 + 110 - e$hausse_depenses
    label(e$simule_gain_repondant) <- "simule_gain_repondant: Gain net annuel simulé pour le répondant (sans tenir compte du potentiel versement reçu par les autres adultes du ménage) suite à une hausse de taxe carbone compensée: 116.1 - hausse_depenses"
    e$simule_gain_verif <- (16.1 + pmin(2, e$nb_adultes) * 110 - e$hausse_depenses_verif) / e$uc # élasticité de 0.15 sur le gaz
    label(e$simule_gain_verif) <- "simule_gain_verif: Gain net annuel simulé par UC suite à une hausse de taxe carbone compensée (avec le bon calcul)"
    
    # TODO: refaire pour vague==2
    e$hausse_carburants <- e$hausse_diesel_verif + e$hausse_essence_verif
    e$hausse_chauffage_interaction_inelastique <- 152.6786*e$fioul + e$surface * (1.6765*e$gaz + 1.1116*e$fioul) # TODO
    e$depense_chauffage <- ((1*(e$fioul) * (152.6786 + 1.1116*e$surface)) / 0.148079 + 1.6765*e$gaz*e$surface / 0.133456)
    e$hausse_depenses_interaction <- e$hausse_carburants + e$hausse_chauffage_interaction_inelastique * (1 - 0.2)
    e$hausse_depenses_interaction_inelastique <- e$hausse_carburants/(1 - 0.4) + e$hausse_chauffage_interaction_inelastique
    e$simule_gain_interaction <- (9.1 + pmin(2, e$nb_adultes) * 110 - e$hausse_depenses_interaction) / e$uc # élasticité de 0.2 pour le gaz
    e$simule_gagnant_interaction <- 1*(e$simule_gain_interaction > 0)
    e$simule_gain_inelastique <- (pmin(2, e$nb_adultes) * 110 - e$hausse_depenses_interaction_inelastique) / e$uc # élasticité nulle. Inclure + 22.4 rendrait le taux d'erreur uniforme suivant les deux catégories, on ne le fait pas pour être volontairement conservateur
    label(e$hausse_chauffage_interaction_inelastique) <- "hausse_chauffage_interaction_inelastique: Hausse des dépenses de chauffage simulées pour le ménage avec des termes d'interaction entre surface et gaz/fioul plutôt que sans, suite à la taxe (élasticité nulle)"
    label(e$depense_chauffage) <- "depense_chauffage: Dépense de chauffage annuelle estimée du ménage, avant la réforme"
    label(e$simule_gain_interaction) <- "simule_gain_interaction: Gain net par UC annuel simulé avec des termes d'interaction surface*fioul/gaz pour le ménage du répondant suite à une hausse de taxe carbone compensée: 9.1 + pmin(2, nb_adultes) * 110 - hausse_chauffage_interaction_inelastique * 0.8 - hausse_carburants"
    label(e$simule_gagnant_interaction) <- "simule_gagnant_interaction: Indicatrice sur la prédiction que le ménage serait gagnant avec la taxe compensée, d'après nos simulations avec des termes d'interaction surface*fioul/gaz: 1*(simule_gain_interaction > 0)"
    label(e$simule_gain_inelastique) <- "simule_gain_inelastique: Gain net par UC annuel simulé (avec interaction) avec une élasticité nulle, pour le ménage du répondant suite à une hausse de taxe carbone compensée:  nb_adultes * 110 - hausse_chauffage_interaction_inelastique - hausse_carburants / 0.6"
    # label(e$simule_gain_elast_perso) <- "simule_gain_elast_perso: Gain net par UC annuel simulé (avec interaction) avec l'élasticité renseignée par le répondant, pour le ménage du répondant suite à une hausse de taxe carbone compensée: pmin(2, nb_adultes) * 110 - hausse_partielle_inelastique * (1 - Elasticite_partielle_perso) - hausse_autre_partielle"
    label(e$hausse_depenses_interaction) <- "hausse_depenses_interaction: Hausse des dépenses énergétiques simulées pour le ménage avec les termes d'interaction, suite à la taxe (élasticité de 0.4/0.2 pour carburants/chauffage)"
    label(e$hausse_depenses_interaction_inelastique) <- "hausse_depenses_interaction_inelastique: Hausse des dépenses énergétiques simulées pour le ménage avec les termes d'interaction, suite à la taxe (élasticité nulle)"
  } else {
    e$dividende <- n(e$dividende)
    e$simule_gain_menage <- e$nb_adultes * e$dividende - e$hausse_depenses # gain fiscal utilisé pour hausse_depenses, alors que dans v1 c'est gain budget
  }
  e$simule_gain <- e$simule_gain_menage / e$uc
  label(e$simule_gain_menage) <- "simule_gain_menage: Gain net annuel simulé pour le ménage du répondant suite à une hausse de taxe carbone compensée, ajusté à la vague et valeur du dividende. Vague 1: 16.1 + pmin(2, nb_adultes) * 110 - hausse_depenses (gain budget). Vague 2: nb_adultes * dividende - hausse_depenses (gain fiscal)"
  label(e$simule_gain) <- "simule_gain: Gain net annuel simulé par UC pour le ménage du répondant suite à une hausse de taxe carbone compensée, ajusté à la vague et valeur du dividende. /!\ v1: gain budget / v2: gain fiscal utilisé. (simule_gain_menage/UC)"
  
  e$Revenu <- e$revenu/1e3 # TODO: labels
  e$Revenu_conjoint <- e$revenu_conjoint/1e3
  e$percentile_revenu <- 100*percentiles_revenu(e$revenu*12)
  e$percentile_revenu_conjoint  <- 100*percentiles_revenu(e$revenu_conjoint*12)
  e$Simule_gain <- e$simule_gain/1e3
  e$Revenu2 <- e$revenu^2/1e6
  e$Revenu_conjoint2 <- e$revenu_conjoint^2/1e6
  e$Simule_gain2 <- e$simule_gain^2/1e6
  
  if (vague==1) e$origine_taxe <- relevel(as.factor(e$origine_taxe), 'gouvernement') # inconnue
  else e$origine_taxe <- relevel(as.factor(e$origine_taxe), 'gouvernement')
  if (vague==1) e$label_taxe <- relevel(as.factor(e$label_taxe), 'taxe')
  e$variante_taxe_carbone <- relevel(as.factor(e$variante_taxe_carbone), 'neutre')
  label(e$variante_taxe_carbone) <- "variante_taxe_carbone: Variante aléatoire pour pour_taxe_carbone: neutre/pour/contre: no info / Selon un sondage de 2018/2019, une majorité de Français est pour/contre une augmentation de la taxe carbone"
  
  e$hausse_depenses_par_uc <- e$hausse_depenses/e$uc # TODO: hausse_depenses_interaction_par_uc
  label(e$hausse_depenses_par_uc) <- "hausse_depenses_par_uc: Hausse des dépenses énergétiques par UC suite à la taxe (utilise la variable buggué hausse_depenses) (élasticité de 0.4/0.2 pour carburants/chauffage)"
  e$hausse_depenses_verif_par_uc <- e$hausse_depenses_verif/e$uc # TODO: hausse_depenses_interaction_par_uc
  label(e$hausse_depenses_verif_par_uc) <- "hausse_depenses_verif_par_uc: Hausse des dépenses énergétiques par UC suite à la taxe (élasticité de 0.4/0.2 pour carburants/chauffage)"
  if (vague==1) { # TODO!
    e$biais <- e$hausse_depenses_verif_par_uc - as.numeric(e$perte)
    e$biais_plus <- e$hausse_depenses_verif_par_uc - as.numeric(e$perte_min)
    e$biais_moins <- e$hausse_depenses_verif_par_uc - as.numeric(e$perte_max)
    label(e$biais) <- "biais: hausse_depenses_par_uc - perte Différence entre la hausse objective et subjective (moyenne de l'intervalle) de dépenses par UC d'énergies fossiles:  (< 0 : pessimisme sur les dépenses)"
    label(e$biais_plus) <- "biais_plus: hausse_depenses_par_uc - perte_min Différence entre la hausse objective et subjective (min de l'intervalle) de dépenses par UC d'énergies fossiles: (< 0 : pessimisme sur les dépenses)"
    label(e$biais_moins) <- "biais_moins: hausse_depenses_par_uc - perte_max Différence entre la hausse objective et subjective (max de l'intervalle) de dépenses par UC d'énergies fossiles: (< 0 : pessimisme sur les dépenses)"
    e$gain <- (110/e$uc)*pmin(2, e$nb_adultes)*(e$confiance_dividende + 1)/2 - e$perte
    label(e$gain) <- "gain: (110/uc)*min(2, nb_adultes)*(confiance_dividende == Oui + 0.5*confiance_dividende == À moitié) - perte Gain net par UC subjectif du ménage suite à une taxe carbone avec dividende, en tenant compte que le répondant peut croire que son ménage ne recevra pas, ou à moitié, le dividende."
    e$gain_min <- (110/e$uc)*pmin(2, e$nb_adultes)*(e$confiance_dividende==1) - e$perte_max
    label(e$gain_min) <- "gain: (110/uc)*min(2, nb_adultes)*(confiance_dividende == Oui) - perte_max Gain net par UC subjectif du ménage suite à une taxe carbone avec dividende, où le dividende est ajouté seulement si le répondant y croit"
    e$biais_sur <- abs(e$simule_gain - e$gain) > 110
    label(e$biais_sur) <- "biais_sur: Certitude à 99% que le gain subjectif du répondant est biaisé à la baisse: abs(simule_gain - gain) > 110"
  }
  # e$nb_politiques_env <- 0
  # variables_politiques_environnementales <- c("taxe_kerosene", "taxe_viande", "normes_isolation", "normes_vehicules", "controle_technique", "interdiction_polluants",
  #                                             "peages_urbains", "fonds_mondial") # "rattrapage_diesel"
  # for (v in variables_politiques_environnementales) e$nb_politiques_env[e[[v]]>0] <- 1 + e$nb_politiques_env[e[[v]]>0]
  
  variables_politiques_1 <<- paste('pour', c("fin_gaspillage", "cantines_vertes", "voies_reservees", "densification", "renouvelables", "taxe_distance"), sep='_') # 6
  variables_politiques_2 <<- paste('pour', c("bonus_malus", "aides_train", "fonds_mondial", "taxe_viande", "conditionner_aides", "restriction_centre_ville", "limitation_110", "obligation_renovation"), sep='_') # 8
  variables_referendum <<- paste('referendum', c("obligation_renovation", "cheque_bio", "interdiction_publicite", "interdiction_polluants", "taxe_dividendes", "consigne"), sep='_') # 6
  variables_politiques_env <<- c(variables_politiques_1, variables_politiques_2, variables_referendum) # 20
  e$nb_referenda <- e$nb_politiques_2 <- e$nb_politiques_1 <- 0
  for (v in variables_referendum) e$nb_referenda[e[[v]]>0] <- 1 + e$nb_referenda[e[[v]]>0]
  for (v in variables_politiques_2) e$nb_politiques_2[e[[v]]>0] <- 1 + e$nb_politiques_2[e[[v]]>0]
  for (v in variables_politiques_1) e$nb_politiques_1[e[[v]]>0] <- 1 + e$nb_politiques_1[e[[v]]>0]
  e$nb_referenda_politiques_2 <- e$nb_referenda + e$nb_politiques_2
  e$nb_politiques_env <- e$nb_referenda + e$nb_politiques_1 # TODO: add carbon tax
  e$prop_referenda <- e$nb_referenda / 6
  e$prop_politiques_1 <- e$nb_politiques_1 / 6
  e$prop_politiques_2 <- e$nb_politiques_2 / 8
  e$prop_referenda_politiques_2 <- e$nb_referenda_politiques_2 / 14
  e$prop_politiques_env <- e$nb_politiques_env / 20
  label(e$nb_referenda) <- "nb_referenda: Nombre de referendum_ où le répondant voterait Oui (cf. les 6 variables_referendum) ~ info_CCC"
  label(e$nb_politiques_1) <- "nb_politiques_1: Nombre de politiques environnementales de la 1ère partie soutenues par le répondant (cf. les 6 variables_politiques_1)"
  label(e$nb_politiques_2) <- "nb_politiques_2: Nombre de politiques environnementales de la 2è partie soutenues par le répondant (cf. les 6 variables_politiques_2) ~ info_CCC"
  label(e$nb_politiques_env) <- "nb_politiques_env: Nombre de politiques environnementales soutenues par le répondant = nb_referenda + nb_politiques_1 + nb_politiques_2 (cf. les 20 variables_politiques_env)"
  label(e$nb_referenda_politiques_2) <- "nb_referenda_politiques_2: Nombre de politiques environnementales de la 2è partie soutenues par le répondant = nb_referenda + nb_politiques_2 (cf. les 14 variables_politiques_2 et variables_referendum)"
  label(e$prop_referenda) <- "prop_referenda: Proportion de referendum_ où le répondant voterait Oui (cf. les 6 variables_referendum) ~ info_CCC"
  label(e$prop_politiques_1) <- "prop_politiques_1: Proportion de politiques environnementales de la 1ère partie soutenues par le répondant (cf. les 6 variables_politiques_1)"
  label(e$prop_politiques_2) <- "prop_politiques_2: Proportion de politiques environnementales de la 2è partie soutenues par le répondant (cf. les 6 variables_politiques_2) ~ info_CCC"
  label(e$prop_politiques_env) <- "prop_politiques_env: Proportion de politiques environnementales soutenues par le répondant = prop_referenda + prop_politiques_1 + prop_politiques_2 (cf. les 20 variables_politiques_env)"
  label(e$prop_referenda_politiques_2) <- "prop_referenda_politiques_2: Proportion de politiques environnementales de la 2è partie soutenues par le répondant = nb_referenda + nb_politiques_2 (cf. les 14 variables_politiques_2 et variables_referendum)"

  e$correct_soutenu_bonus_malus <- e$soutenu_bonus_malus==T # ~65% pour
  e$correct_soutenu_normes_isolation <- e$soutenu_normes_isolation==T # AT: 72% pour
  e$correct_soutenu_obligation_renovation <- e$soutenu_obligation_renovation==T # referendum_obligation_renovation: ~75% Oui / pour_obligation_renovation: ~83% pour
  e$correct_soutenu_limitation_110 <- e$soutenu_limitation_110==F # pour_limitation_110: ~53% contre
  e$nb_correct_soutenu <- e$correct_soutenu_bonus_malus + e$correct_soutenu_normes_isolation + e$correct_soutenu_obligation_renovation + e$correct_soutenu_limitation_110
  label(e$correct_soutenu_bonus_malus) <- "correct_soutenu_bonus_malus: soutenu_bonus_malus==T - Un renforcement du bonus/malus écologique pour l’achat d’un véhicule - Réponse correcte à si cette politique est soutenue par une majorité de Français (obligation_renovation/normes_isolation/bonus_malus/limitation_110)"
  label(e$correct_soutenu_obligation_renovation) <- "correct_soutenu_obligation_renovation: soutenu_obligation_renovation==T - L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - Réponse correcte à si cette politique est soutenue par une majorité de Français (obligation_renovation/normes_isolation/bonus_malus/limitation_110)"
  label(e$correct_soutenu_limitation_110) <- "correct_soutenu_limitation_110: soutenu_limitation_110==F - L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - Réponse correcte à si cette politique est soutenue par une majorité de Français (obligation_renovation/normes_isolation/bonus_malus/limitation_110)"
  label(e$correct_soutenu_normes_isolation) <- "correct_soutenu_normes_isolation: soutenu_normes_isolation==T - Des normes plus strictes sur l'isolation pour les nouveaux bâtiments - Réponse correcte à si cette politique est soutenue par une majorité de Français (obligation_renovation/normes_isolation/bonus_malus/limitation_110)"
  label(e$nb_correct_soutenu) <- "nb_correct_soutenu: Nombre de réponses correctes à si cette politique est soutenue par une majorité de Français (obligation_renovation/normes_isolation/bonus_malus/limitation_110)"
  
  variables_devoile <<- paste("CCC_devoile", c("obligation_renovation", "limitation_110", "fonds_mondial", "taxe_viande"), sep='_')
  if (vague==2) {
    variables_devoile <- c(variables_devoile, "CCC_devoile_28_heures")
    e$correct_devoile_28_heures <- e$CCC_devoile_28_heures < 0
    label(e$correct_devoile_28_heures) <- "correct_devoile_28_heures: CCC_devoile_28_heures < 0 - [Si pas Aucun à sait_CCC_devoilee] La réduction du temps de travail légal à 28 heures par semaine - Réponse correcte à si cette mesure de la CCC a été dévoilée ~ info_CCC"
  }
  e$correct_devoile_obligation_renovation <- e$CCC_devoile_obligation_renovation > 0 # https://www.lemonde.fr/climat/article/2020/04/11/climat-les-50-propositions-de-la-convention-citoyenne-pour-porter-l-espoir-d-un-nouveau-modele-de-societe_6036293_1652612.html
  e$correct_devoile_limitation_110 <- e$CCC_devoile_limitation_110 < 0
  e$correct_devoile_fonds_mondial <- e$CCC_devoile_fonds_mondial < 0
  e$correct_devoile_taxe_viande <- e$CCC_devoile_taxe_viande < 0
  e$nb_correct_devoile <- e$correct_devoile_obligation_renovation + e$correct_devoile_limitation_110 + e$correct_devoile_fonds_mondial + e$correct_devoile_taxe_viande
  if (vague==2) e$nb_correct_devoile <- e$nb_correct_devoile + e$correct_devoile_28_heures
  label(e$correct_devoile_obligation_renovation) <- "correct_devoile_obligation_renovation: CCC_devoile_obligation_renovation > 0 - [Si pas Aucun à sait_CCC_devoilee] L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - Réponse correcte à si cette mesure de la CCC a été dévoilée ~ info_CCC"
  label(e$correct_devoile_limitation_110) <- "correct_devoile_limitation_110: CCC_devoile_limitation_110 < 0 - [Si pas Aucun à sait_CCC_devoilee] L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - Réponse correcte à si cette mesure de la CCC a été dévoilée ~ info_CCC"
  label(e$correct_devoile_fonds_mondial) <- "correct_devoile_fonds_mondial: CCC_devoile_fonds_mondial < 0 - [Si pas Aucun à sait_CCC_devoilee] Une contribution à un fonds mondial pour le climat - Réponse correcte à si cette mesure de la CCC a été dévoilée ~ info_CCC"
  label(e$correct_devoile_taxe_viande) <- "correct_devoile_taxe_viande: CCC_devoile_taxe_viande < 0 - [Si pas Aucun à sait_CCC_devoilee] Une taxe sur la viande rouge - Réponse correcte à si cette mesure de la CCC a été dévoilée ~ info_CCC"
  label(e$nb_correct_devoile) <- "nb_correct_devoile: Nombre de réponses correctes à si cette mesure de la CCC a été dévoilée (obligation_renovation=T/limitation_110=F/taxe_viande=F/fonds_mondial=F/[vague 2]28h=F)"
  
  obstacles <<- c("lobbies", "manque_volonte", "manque_cooperation", "inegalites", "incertitudes", "demographie", "technologies", "rien")
  variables_obstacles <<- paste("obstacles", obstacles, sep="_")
  for (i in 1:8)  {
    for (v in obstacles) e[[paste("obstacle", i, sep="_")]][e[[paste("obstacles", v, sep="_")]]==i] <- v
    label(e[[paste("obstacle", i, sep="_")]]) <- paste("obstacle_", i, ": Obstacle à la lutte contre le CC classé en position ", i, " (1: le plus - 7: le moins important) (", paste(obstacles, collapse = "/"), ")", sep="") }

  e$Connaissance_CCC <- NA 
  e$connaissance_CCC_bon_francais <- e$connaissance_CCC_sortition <- e$connaissance_CCC_mesures <- e$connaissance_CCC_temporalite <- e$connaissance_CCC_internet <- e$connaissance_CCC == "FALSE"
  e$connaissance_CCC_150 <- e$connaissance_CCC == "FALSE"
  if (vague==1) {
    e$Connaissance_CCC[c(1,3,10,13,17,19,29,30,34,45,49,51,54,57,64,68,74,77,78,86,93,97,103,121,129,136,139,151,153,155,156,159,162,163,164,174,179,181,182,183,184,187,191,194,196,197,201)] <- "aucune" #
    e$Connaissance_CCC[c(208,210,217,218,223,232,236,242,250,255,259,260,266,268,271,272,278,282,285,289,291,297,298,301,310,312,313,324,327,328,349,352,355,357,361,372)] <- "aucune" #
    e$Connaissance_CCC[c(383,385,389,390,394,402,410,411,415,416,417,419,421,422,424,425,429,431,442,444,446,450,451,457,458,461,463,465,466,468,469,472,476,485,487,488,492)] <- "aucune" # ex: "nsp" 19, 402, # doublons 450-451, 421-422, 468-469, 515-516?
    e$Connaissance_CCC[c(496,502,515,516,520,526,532,533,534,535,537,540,541,546,548,550,551,552,553,555,557,560,561,562,564,567,568,572,578,582,584,586,587,588,589,597,598,602,603,604)] <- "aucune" # ex: 598
    e$Connaissance_CCC[c(610,619,621,622,625,626,629,630,631,634,636,638,639,650,654,656,657,659,660,665,666,667,669,674,677,678,681,686,688,690,694,698,699,702,707,709,712,713,720,721,725,727)] <- "aucune" # ex: 598
    e$Connaissance_CCC[c(731,733,738,747,748,752,753,757,760,762,763,765,766,768,771,772,775,781,782,783,785,787,790,793,798,823,826,830,844,845,846,847,848,859,860,862,865,868,872,873)] <- "aucune" # ex: 598
    e$Connaissance_CCC[c(876,891,883,887,893,897,899,908,909,911,913,915,916,917,926,930,939,940,943,944,946,955,956,957,960,962,965,966,967,973,977,978,986,992,995,998,1000,1001,1002,1003)] <- "aucune" # ex: 598, 915
    e$Connaissance_CCC[c(73,118,143,239,248,270,280,283,326,381,388,471,489,491,504,590,592,632,743,866,871,929,951,952,993)] <- "faux" # ex: 239, 326
    e$Connaissance_CCC[c(6,22,25,66,72,80,90,100,107,110,111,152,166,170,177,188,214,227,238,276,281,316,319,320,323,339,360,387,393,396,399,408,432,452,454,474,498,503)] <- "hors sujet" # ex: 25, 71, 90, 107 # 25-110-432 doublon ?
    e$Connaissance_CCC[c(510,570,573,575,591,664,682,715,716,736,737,739,741,744,767,795,839,840,842,849,854,861,892,895,921,927,928,936,945,953,959,964,984,999)] <- "hors sujet" # ex: 25, 71, 90, 107, 570, 767, 839, 840, 861 # 25-110-432 570-573 1001-1003 doublon ? TODO
    e$Connaissance_CCC[c(9,31,33,35,37,38,55,59,81,101,120,193,202,233,235,237,249,252,273,293,294,311,358,359,363,367,374,414,434,455,457,460,479,482,484,490,508,519,522,524,538)] <- "trop vague" # ex: 374, 457, 490 [490 = 2.0?]
    e$Connaissance_CCC[c(581,614,623,624,628,642,643,645,655,663,671,687,703,704,705,724,746,754,773,780,792,818,886,888,900,901,902,912,934,954)] <- "trop vague" # ex: 374, 457, 490
    e$Connaissance_CCC[c(8,15,18,20,26,27,28,43,65,75,84,85,89,101,123,132,135,140,142,144,145,147,165,168,172,176,207,220,222,240,247,275,288,303,308,341,347,348,351,356,364,377,473,493)] <- "approximatif" # ex: 607
    e$Connaissance_CCC[c(401,404,423,427,505,506,507,530,531,618,670,672,693,695,696,728,729,732,740,751,758,776,786,796,800,802,831,832,857,875,877,906,914,920,937,938,972,982,987,988)] <- "approximatif"
    e$Connaissance_CCC[c(7,24,62,67,71,84,91,106,117,127,130,131,134,150,154,158,173,175,186,202,209,226,246,247,253,262,284,302,307,334,337,380,386,391,400,407,418,420,428,440,448,449,470,481)] <- "bonne" # ex: 24, 117, 334 ; contient généralement mesures, sortition, 150 ou date
    e$Connaissance_CCC[c(494,501,514,542,547,558,563,566,607,609,611,613,646,665,684,689,691,700,718,722,770,779,797,811,815,863,898,910,923,935,941,950,991)] <- "bonne" # ex: 24, 117, 334 ; contient généralement mesures, sortition, 150 ou date
    e$connaissance_CCC_bon_francais[c(6,15,18,20,24,27,62,84,85,91,130,134,140,145,154,158,165,170,175,193,202,207,220,226,242,247,248,253,262,288,347,348,351,356,360,364,377,380,386,387,391)] <- "bon français" # ex: ; pas de faute d'orthographe, grammaire correcte, phrase élaborée (i.e. pas juste "je ne sais pas")
    e$connaissance_CCC_bon_francais[c(399,404,418,419,423,425,434,448,449,454,457,460,470,471,473,481,488,493,501,507,508,522,542,562,581,598,609,611,613,665,691,700,728,729,732,741,752)] <- "bon français" # ex: ; pas de faute d'orthographe, grammaire correcte, phrase élaborée (i.e. pas juste "je ne sais pas")
    e$connaissance_CCC_bon_francais[c(770,776,779,796,797,875,877,895,898,935,937,988,991,993)] <- "bon français" # ex: ; pas de faute d'orthographe, grammaire correcte, phrase élaborée (i.e. pas juste "je ne sais pas")
    e$connaissance_CCC_sortition[c(7,62,67,71,91,106,127,130,131,134,150,154,158,165,173,175,186,202,207,209,239,246,247,253,262,284,302,308,334,348,380,407,420,428,440,448,449,470,481)] <- "sortition"
    e$connaissance_CCC_sortition[c(494,501,514,530,542,547,558,566,607,609,611,613,646,672,684,689,691,693,700,722,751,779,797,811,815,831,832,857,863,898,906,910,914,923,929,941,972,991)] <- "sortition"
    e$connaissance_CCC_mesures[c(7,62,67,71,130,135,142,154,175,186,202,226,246,262,302,307,337,356,386,400,404,407,428,448,449,481,494,505,531,558,563,566,607,609,611,613,646,670,689)] <- "mesures"
    e$connaissance_CCC_mesures[c(700,718,722,770,779,786,802,811,815,819,863,898,920,938,941,950,982,991,993)] <- "mesures"
    e$connaissance_CCC_internet[c(44,70,239,279,512,606,701)] <- "internet"
    e$connaissance_CCC_temporalite[c(84,117,131,150,172,235,249,293,302,427,501)] <- "temporalité"
    e$connaissance_CCC_150[which(c(grepl('150', e$connaissance_CCC)),470)] <- "150"
  } else {
    e$connaissance_CCC_opinion <- e$connaissance_CCC_choix <- e$connaissance_CCC_posterite <- e$connaissance_CCC == "FALSE"
    e$Connaissance_CCC[c(2,1001,8,14,15,16,17,19,23,24,28,41,44,58,59,64,67,69,76,83,84,90,94,96,98,100,104,105,106,107,112,130,132,133,134,143,145,150,156,157,158,163,164,167,168,171,173,186,428,187)] <- "aucune"
    e$Connaissance_CCC[c(191,193,199,206,208,210,214,227,242,248,249,251,255,264,272,274,280,294,309,312,314,316,320,321,323,324,329,331,333,338,340,341,347,349,355,357,364,367,374,376,379,386,387,391,393,394,395,397)] <- "aucune"
    e$Connaissance_CCC[c(6,25,26,27,30,35,36,42,49,73,85,87,116,122,123,127,135,147,152,159,166,172,175,180,189,196,203,204,205,222,256,266,277,283,285,291,304,311,319,330,334,337,343,365,369,377)] <- "trop vague" # Réponse aurait pu être déduit simplement à partir du nom "CCC". Impossible de savoir ce que le répondant sait réellement, ou bien le répondant sait des choses à moitié, commet des erreurs.
    e$Connaissance_CCC[c(1002,4,7,12,21,22,32,37,39,40,45,46,47,51,52,56,66,75,78,79,88,103,113,115,117,118,121,138,140,141,148,151,153,154,165,182,195,204,218,226,228,232,243,246,252,254,258,259,260,262)] <- "approximatif" # Contient un voire quelques éléments (mesures, sortition) mais mal formulés ou peu clair, ou avec une imprécision. Laisse penser que le répondant connaît mais ne dit pas tout ce qu'il sait. ex; 32
    e$Connaissance_CCC[c(275,284,290,293,300,303,306,322,325,326,327,344,346,356,359,363,367,390,396,403,405,406,407,410,416,421,422,431,433,435,440,447,455,453,458,459,463,464,469,480,481,487,490,497)] <- "approximatif" 
    e$Connaissance_CCC[c(9,18,29,33,34,50,55,57,60,61,65,70,77,109,119,129,136,139,142,145,155,162,178,185,190,197,200,202,209,213,215,217,221,225,229,233,235,237,253,257,265,271,281,288,296,298,302,305)] <- "bonne" # Contient généralement plusieurs éléments (mesures, sortition, 150 ou date) bien articulés permettant de s'assurer que le répondant connaît la CCC. ex: 155
    e$connaissance_CCC_mesures[c(1002,4,9,18,21,22,26,29,32,33,34,35,36,40,49,52,55,57,61,70,73,75,77,78,79,82,103,109,115,117,129,136,139,145,148,153,155,182,185,190,197,200,205,209,213,215,217,219)] <- "mesures" # mentionne que des propositions doivent être formulées / ont été formulées # TODO: check les 10 premières voir s'il y a des mesures spécifiques
    e$connaissance_CCC_mesures[c(222,228,233,235,236,237,243,246,252,253,254,257,258,260,275,281,288,290,291,293,296,298,302,303,305,317,322,325,326,344,346,350,353,356,358,359,363,366,367,370,371)] <- "mesures"
    e$connaissance_CCC_sortition[c(18,32,34,50,55,56,57,60,61,65,70,77,118,121,138,139,142,145,155,162,178,197,200,225,229,233,235,236,237,253,257,259,265,281,288,296,300,302,305,306,317,350,353,356,366)] <- "sortition"
    e$connaissance_CCC_bon_francais[c(1002,7,9,12,26,27,29,33,45,50,52,55,60,65,66,70,78,82,88,109,119,121,123,124,129,140,141,142,144,145,148,151,152,155,162,167,169,194,196,202,221,236,238,246,253,254,256)] <- "bon français" # pas de faute d'orthographe, grammaire correcte, phrase élaborée (i.e. pas juste "je ne sais pas")
    e$Connaissance_CCC[c(1003,1,5,31,48,114,124,144,198,238,241,278,279,297,328,351,352,354,466,471,493)] <- "hors sujet" 
    e$Connaissance_CCC[c(38,108,169,188,194,220,271,292,318,348,408,443)] <- "faux"
    e$Connaissance_CCC[c(397,399,402,413,415,423,436,437,441,442,444,445,451,452,457,460,472,474,476,479,484,488,489,498)] <- "aucune"
    e$Connaissance_CCC[c(380,384,392,398,411,420,425,428,446,450,468,470,475,477,483,491)] <- "trop vague" 
    e$Connaissance_CCC[c()] <- "approximatif" 
    e$Connaissance_CCC[c(317,350,353,358,366,370,371,373,375,378,385,389,400,401,409,417,424,430,438,448,453,462,465,478,485,492,495)] <- "bonne"
    e$connaissance_CCC_bon_francais[c(257,259,266,277,281,283,284,288,296,302,304,317,334,346,353,356,358,363,365,366,367,370,378,385,390,396,398,405,408,410,417,430,435,443,446,464,465,481)] <- "bon français"
    e$connaissance_CCC_sortition[c(371,377,378,385,389,400,401,403,407,409,417,424,438,448,455,465,478,485,492)] <- "sortition"
    e$connaissance_CCC_mesures[c(375,373,378,385,389,398,400,401,406,409,416,417,421,424,428,430,433,435,438,448,458,463,465,469,470,477,478,480,483,487,490,492,495,497)] <- "mesures"
    e$connaissance_CCC_choix[c(213,215,217,440,447,481)] <- "mesures spécifiques" # (mentionne des mesures spécifiques proposées par la CCC)
    e$connaissance_CCC_internet[c(453,462)] <- "internet"
    e$connaissance_CCC_temporalite[c(29,34,47,82,139,265,431,438,453)] <- "temporalité" # Évoque la durée ou les dates de la CCC
    e$connaissance_CCC_150[which(c(grepl('150', e$connaissance_CCC)),34)] <- "150" # not 75, 127, 139, 182, 190, 233, 359, 458, 487
    e$connaissance_CCC_opinion[c(1,5,38,39,42,45,52,66,70,75,108,122,135,138,140,142,151,162,188,195,215,241,243,259,271,279,285,352,359,384,390,428,468,475,477,485)] <- "opinion" # Exprime une opinion à propos de la CCC. ex: 1 "les vrais problemes non pas été traités". ex: 38, 42, 108
    e$connaissance_CCC_posterite[c(9,39,40,55,77,82,129,154,165,237,253,298,366,396,400,492)] <- "postérité" # Évoque la postérité réservée aux mesures proposées.
  } # TODO: corrélation bon_français et Connaissance / âge / sexe / CSP, mesures et postérité, Connaissance écolo, etc., distribution du nombre de trucs cochés parmi 150/mesures/sortition
  # Intéressant pour Laslier: 138 "Des citoyens tirés au sort qui ne représentent qu'eux-mêmes alors que nous avons des élu.e.s pour cela...", 285
  # TODO: doublon 400-401? 403-407?
  # variables_connaissance_CCC <<- c("bon_francais", "sortition", "mesures", "temporalite", "internet", "150")
  # for (v in variables_connaissance_CCC) e[[paste("connaissance_CCC", v, sep="_")]] <- e[[paste("connaissance_CCC", v, sep="_")]]!="FALSE"
  variables_connaissances_CCC <<- c("mesures", "choix", "sortition", "150", "temporalite", "internet", "opinion", "posterite", "bon_francais")
  for (v in variables_connaissances_CCC) if (paste("connaissance_CCC", v, sep="_") %in% names(e)) e[[paste("connaissance_CCC", v, sep="_")]] <- e[[paste("connaissance_CCC", v, sep="_")]]!="FALSE"
  temp <- -2*(e$Connaissance_CCC=="hors sujet") -1*(e$Connaissance_CCC=="faux") + 1*(e$Connaissance_CCC=="trop vague") + 2*(e$Connaissance_CCC=="approximatif") + 3*(e$Connaissance_CCC=="bonne")
  temp[e$connaissance_CCC_internet==T] <- 2
  e$Connaissance_CCC <- as.item(temp, labels = structure(c(-2:3), names=c("hors sujet", "faux", "aucune", "trop vague", "approximatif", "bonne")),
                                annotation="Connaissance_CCC: connaissance_CCC recodé en hors sujet/faux/aucune/approximatif/bonne (incl. internet) - Décrivez ce que vous savez de la Convention Citoyenne pour le Climat. (champ libre)")
  label(e$connaissance_CCC_bon_francais) <- "connaissance_CCC_bon_francais: Indicatrice que la réponse à connaissance_CCC est constituée d'une phrase grammaticalement correcte et sans faute d'orthographe (à l'exception des phrases très courtes type 'Je ne sais pas')"
  label(e$connaissance_CCC_sortition) <- "connaissance_CCC_sortition: Indicatrice que la réponse à connaissance_CCC mentionne le tirage au sort, ou du moins le caractère 'lambda' ou hétérogène des citoyens de la CCC"
  label(e$connaissance_CCC_mesures) <- "connaissance_CCC_mesures: Indicatrice que la réponse à connaissance_CCC mentionne le fait que la CCC rend des propositions de mesures"
  label(e$connaissance_CCC_temporalite) <- "connaissance_CCC_temporalite: Indicatrice que la réponse à connaissance_CCC mentionne un élément de la temporalité de la CCC (date de début ou de fin, ou fréquence de ses réunions)"
  label(e$connaissance_CCC_internet) <- "connaissance_CCC_internet: Indicatrice que la réponse à connaissance_CCC a été copiée à partir des résultats d'une requête internet"
  label(e$connaissance_CCC_150) <- "connaissance_CCC_150: Indicatrice que la réponse à connaissance_CCC mentionne le nombre de membres de la CCC (150)" # autre indicatrice qui aurait pu être intéressante : si ça mentionne que la CCC est française ou, au contraire, se méprend en parlant d'une initiative internationale
  
  if (vague==2) {
    e$gain_subjectif_original[grepl("pas affecté", e$gain_net_choix)] <- 0
    e$gain_subjectif_original[!is.na(e$gain_net_gain)] <- n(e$gain_net_gain[!is.na(e$gain_net_gain)])
    e$gain_subjectif_original[!is.na(e$gain_net_perte)] <- - n(e$gain_net_perte[!is.na(e$gain_net_perte)] )
    e$gain_subjectif <- e$gain_subjectif_original / e$uc
    label(e$gain_subjectif) <- "gain_subjectif: Gain net subjectif par UC pour la taxe avec dividende (variation en partie expliquée par trois valeurs de dividendes aléatoires: 0/110/170)."
    e$gain <- pmax(-500, pmin(170, e$gain_subjectif)) # TODO: trim at 110/0 for respective values of dividend / assign NA to outliers
    label(e$gain) <- "gain: Gain net subjectif par UC borné (trim) entre -500 et 170 pour la taxe avec dividende (variation en partie expliquée par trois valeurs de dividendes aléatoires: 0/110/170)."
    
    e$gagnant_categorie <- 1*grepl("gagne", e$gain_net_choix) - 0.1*grepl("NSP", e$gain_net_choix) - 1*grepl("perd", e$gain_net_choix)
  } else {
    e$gagnant_categorie <- 1*(e$gagnant_categorie=="Gagnant") - 0.1*(e$gagnant_categorie=="NSP") - 1*(e$gagnant_categorie=="Perdant")
  }
  label(e$gagnant_categorie) <- "gagnant_categorie: ~ Ménage Gagnant/Non affecté/Perdant/NSP par taxe avec dividende"
  e$gagnant_categorie <- as.item(n(e$gagnant_categorie), labels = structure(c(1:-1,-0.1), names=c('Gagnant', 'Non affecté', 'Perdant', 'NSP')), missing.values = -0.1, annotation=Label(e$gagnant_categorie))
  
  e$Gagnant_categorie <- as.character(e$gagnant_categorie)
  e$Gagnant_categorie[e$Gagnant_categorie=="NSP"] <- "NSP "
  e$Gagnant_categorie <- relevel(as.factor(as.character(e$Gagnant_categorie)), "Non affecté")
  
  if (vague==1) e$dividende <- 110
  else e$label_taxe <- "taxe"
  
  e <- e[, -c(9:17, 131, 132, 134, 136, 137, 139, 187)] # 39:49,
  return(e)
}
# e <- prepare_e()
# 
# export_stats_desc(e, paste(getwd(), 'externe_stats_desc.csv', sep='/'))

weighting_e <- function(data, printWeights = T) { # cf. google sheet
  d <- data 
  d$taille_agglo <- as.numeric(d$taille_agglo)
  # d$csp <- factor(d$csp)
  # d$region <- factor(d$region)
  # levels(d$csp) <- c(levels(d$csp),"missing")
  # levels(d$region) <- c(levels(d$region),"missing")
  # levels(d$taille_agglo) <- c(levels(d$taille_agglo),"missing")
  # levels(d$sexe) <- c(levels(d$sexe),"missing")
  # d$csp[is.na(d$csp) | d$csp=="" | d$csp=="NSP"] <- "missing"
  # d$taille_agglo[is.na(d$taille_agglo)] <- "missing"
  # d$sexe[d$sexe=="" | d$sexe=="Autre"] <- "missing"

  unweigthed <- svydesign(ids=~1, data=d)
  sexe <- data.frame(sexe = c("Féminin", "Masculin"), Freq=nrow(d)*c(0.516,0.484)) # http://www.insee.fr/fr/themes/detail.asp?ref_id=bilan-demo&reg_id=0&page=donnees-detaillees/bilan-demo/pop_age2.htm
  csp <- data.frame(csp = c("Inactif", "Ouvrier", "Cadre", "Indépendant", "Intermédiaire", "Retraité", "Employé", "Agriculteur"),
                    Freq=nrow(d)*c(0.129,0.114,0.101,0.035,0.136,0.325,0.15,0.008))
  region <- data.frame(region = c("autre","ARA", "Est", "Nord", "IDF", "Ouest", "SO", "Occ", "Centre", "PACA"), 
                       Freq=nrow(d)*c(0.0001,0.12446,0.12848,0.09237,0.1902,0.10294,0.09299,0.09178,0.09853,0.07831))
  age <- data.frame(age = c("18-24", "25-34", "35-49", "50-64", "65+"), 
                    Freq=nrow(d)*c(0.120,0.150,0.240,0.240,0.250)) # Données/estim-pop-reg-sexe...
  taille_agglo <- data.frame(taille_agglo = c(1:5), Freq=nrow(d)*c(0.2166,0.1710,0.1408,0.3083,0.1633))
  # revenu <- data.frame(revenu = c(), Freq=nrow(d)*c())
  diplome4 <- data.frame(diplome4 = c("Aucun diplôme ou brevet", "CAP ou BEP", "Baccalauréat", "Supérieur"),  # http://webcache.googleusercontent.com/search?q=cache:rUvf6u0uCnEJ:www.insee.fr/fr/themes/tableau.asp%3Freg_id%3D0%26ref_id%3Dnattef07232+&cd=1&hl=fr&ct=clnk&gl=fr&lr=lang_en%7Clang_es%7Clang_fr
                        Freq=nrow(d)*c(0.290, 0.248, 0.169, 0.293))

  if (length(which(is.na(d$taille_agglo)))>0) raked <- rake(design= unweigthed, sample.margins = list(~sexe,~diplome4,~region,~csp,~age),
                population.margins = list(sexe,diplome4,region,csp,age))    
  else raked <- rake(design= unweigthed, sample.margins = list(~sexe,~diplome4,~taille_agglo,~region,~csp,~age),
                population.margins = list(sexe,diplome4,taille_agglo,region,csp,age)) 

  if (printWeights) {    print(summary(weights(raked))  )
    print(paste("(mean w)^2 / (n * mean w^2): ", round(sum( weights(raked) )^2/(length(weights(raked))*sum(weights(raked)^2)), 3), " (pb if < 0.5)")) # <0.5 : problématique   
    print(paste("proportion not in [0.25; 4]: ", round(length(which(weights(raked)<0.25 | weights(raked)>4))/ length(weights(raked)), 3)))
  }
  return(weights(trimWeights(raked, lower=0.25, upper=4, strict=TRUE)))
}

# exclude_speeder=TRUE;exclude_screened=TRUE; only_finished=TRUE; only_known_agglo=T; duree_max=630
prepare_e <- function(exclude_speeder=TRUE, exclude_screened=TRUE, only_finished=TRUE, only_known_agglo=T, duree_max=390) { # , exclude_quotas_full=TRUE
  e <- read_csv("../donnees/externe1.csv")[-c(1:2),]

  e <- relabel_and_rename(e)
  
  print(paste(length(which(e$exclu=="QuotaMet")), "QuotaMet"))
  e$fini[e$exclu=="QuotaMet" | is.na(e$revenu)] <- "False" # To check the number of QuotaMet that shouldn't have incremented the quota, comment this line and: decrit(e$each_strate[e$exclu=="QuotaMet" & e$csp=="Employé" & !grepl("2019-03-04 07", e$date)])
  if (exclude_screened) { e <- e[is.na(e$exclu),] }
  if (exclude_speeder) { e <- e[as.numeric(as.vector(e$duree)) > duree_max,] } 
  # if (exclude_quotas_full) { e <- e[e[101][[1]] %in% c(1:5),]  } # remove those with a problem for the taille d'agglo
  # if (exclude_quotas_full) { e <- e[e$Q_TerminateFlag=="",]  } # remove those with a problem for the taille d'agglo
  if (only_finished) { # TODO: le faire marcher même pour les autres
    e <- e[e$fini=="True",] 
    e <- convert_e(e, vague=1) 
   
    e$weight <- weighting_e(e)
  
    e$gauche_droite_na <- as.numeric(e$gauche_droite)
    e$gauche_droite_na[e$indeterminate == T] <- wtd.mean(e$gauche_droite, weights = e$weight)
  } else {
    e$Diplome <- (e$diplome == "Brevet des collèges") + 2*(e$diplome=="CAP ou BEP") + 3*(e$diplome=="Baccalauréat") + 4*(e$diplome=="Bac +2 (BTS, DUT, DEUG, écoles de formation sanitaires et sociales...)") + 5*(e$diplome=="Bac +3 (licence...)") + 6*(e$diplome=="Bac +5 ou plus (master, école d'ingénieur ou de commerce, doctorat, médecine, maîtrise, DEA, DESS...)") - (e$diplome=="NSP (Ne se prononce pas)")
    e$diplome4 <- as.item(pmin(pmax(e$Diplome, 1), 4), labels = structure(1:4, names = c("Aucun diplôme ou brevet", "CAP ou BEP", "Baccalauréat", "Supérieur")), annotation=Label(e$diplome))  
    e <- e[, -c(9:17, 131, 132, 134, 136, 137, 139, 187)]    
  }
  
  e$sample <- "a"
  e$sample[e$fini=="True"] <- "e"
  e$sample[e$fini=="True" & n(e$duree) > duree_max] <- "p"
  e$sample[e$fini=="True" & n(e$duree) > duree_max & e$test_qualite=='Un peu'] <- "f" # "q"? excluded because out of quotas
  e$sample[e$fini=="True" & n(e$duree) > duree_max & e$exclu==""] <- "r"
  
  return(e)
}

ea <- prepare_e(exclude_screened=FALSE, exclude_speeder=FALSE, only_finished=FALSE)
# se <- prepare_e(exclude_screened=FALSE, exclude_speeder=FALSE)
# # sp <- prepare_e(exclude_screened=FALSE)

e <- prepare_e()

relabel_and_rename2 <- function(e) {
  # Notation: ~ means that it's a random variant; * means that another question is exactly the same (in another random branch)
  
  # The commented lines below should be executed before creating relabel_and_rename, to ease the filling of each name and label
  for (i in 1:length(e)) {
    label(e[[i]]) <- paste(names(e)[i], ": ", label(e[[i]]), e[[i]][1], sep="");
    # print(paste(i, label(e[[i]])))
  }
  e <- e[-c(1:2),]

  label(e[[1]]) <- "date:"
  label(e[[2]]) <- "date_fin:"
  label(e[[3]]) <- "statut_reponse:"
  label(e[[4]]) <- "ip:"
  label(e[[5]]) <- "progres:"
  label(e[[6]]) <- "duree:"
  label(e[[7]]) <- "fini:"
  label(e[[8]]) <- "date_enregistree:"
  label(e[[9]]) <- "ID_qualtrics:"
  label(e[[10]]) <- "nom:"
  label(e[[11]]) <- "prenom:"
  label(e[[12]]) <- "mmail:"
  label(e[[13]]) <- "ref:"
  label(e[[14]]) <- "lat:"
  label(e[[15]]) <- "long:"
  label(e[[16]]) <- "distr:"
  label(e[[17]]) <- "lang:"
  label(e[[18]]) <- "code_postal: Code Postal - Q93"
  label(e[[19]]) <- "sexe: Sexe (Masculin/Féminin) - Q96"
  label(e[[20]]) <- "age: Tranche d'âge (18-24/25-34/35-49/50-64/65+) - Q184"
  label(e[[21]]) <- "statut_emploi: Statut d'emploi (Chômage/CDD/CDI/fonctionnaire/étudiant-e/retraité-e/précaire/autre actif/autre inactif) - Q35"
  label(e[[22]]) <- "csp: Catégorie Socio-Professionnelle: Agriculteur/Indépendant: Artisan, commerçant.e/Cadre: Profession libérale, cadre/Intermédiaire: Profession intermédiaire/Employé/Ouvrier/Retraité/Inactif: Autres inactif/ve - Q98"
  label(e[[23]]) <- "diplome: Diplôme le plus haut obtenu ou prévu: Aucun/Brevet/CAP/Bac/+2/+3/>+4) - Q102"
  label(e[[24]]) <- "taille_menage: Taille du ménage #(vous, membres de votre famille vivant avec vous et personnes à votre charge) - Q29"
  label(e[[25]]) <- "revenu: Revenu mensuel net du répondant - Q148"
  label(e[[26]]) <- "rev_tot: Revenu mensuel net du ménage - Q25"
  label(e[[27]]) <- "nb_14_et_plus: Nombre de personnes âgées d'au moins 14 ans dans le ménage - Q31"
  label(e[[28]]) <- "nb_adultes: Nombre de personnes majeures dans le ménage - Q149"
  label(e[[29]]) <- "locataire: Locataire - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(e[[30]]) <- "proprio_occupant: Propriétaire occupant - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(e[[31]]) <- "proprio_bailleur: Propriétaire bailleur - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(e[[32]]) <- "heberge_gratis: Hébergé gratuitement - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(e[[33]]) <- "patrimoine: Patrimoine net du ménage (ou de la personne si elle vit chez ses parents) (<10/10-60/60-180/180-350/350-550/>550k€/NSP) - Q129" # les quintiles + dernier décile 2018 https://www.insee.fr/fr/statistiques/2388851
  label(e[[34]]) <- "surface: Surface du logement (en m²) - Q175"
  label(e[[35]]) <- "chauffage: source d'énergie principale (Électricité/Gaz de ville/Butane, propane, gaz en citerne/Fioul, mazout, pétrole/Bois, solaire, géothermie, aérothermie (pompe à chaleur)/Autre/NSP)"
  label(e[[36]]) <- "transports_travail: Le répondant utilise principalement (la voiture/les TC/la marche ou le vélo/un deux roues motorisé/le covoiturage/non conerné) pour ses trajets domiciles-travail (ou études) - Q39"
  label(e[[37]]) <- "transports_courses: Le répondant utilise principalement (la voiture/les TC/la marche ou le vélo/un deux roues motorisé/le covoiturage/non conerné) pour faire ses courses - Q39"
  label(e[[38]]) <- "transports_loisirs: Le répondant utilise principalement (la voiture/les TC/la marche ou le vélo/un deux roues motorisé/le covoiturage/non conerné) pour ses loisirs (hors vacances) - Q39"
  label(e[[39]]) <- "nb_vehicules_texte: Nombre de véhicules motorisés dont dispose le ménage - Q37"
  label(e[[40]]) <- "km_0: (nb_vehicules=0) Nombre de kilomètres parcourus en voiture ou moto par le répondant lors des 12 derniers mois - Q142"
  label(e[[41]]) <- "fuel_1: (nb_vehicules=1) Carburant du véhicule (Essence/Diesel/Électrique ou hybride/Autre) - Q77"
  label(e[[42]]) <- "conso_1_choix: (nb_vehicules=1) Consommation moyenne du véhicule (L par 100km / NSP) - Q174"
  label(e[[43]]) <- "conso_1: (nb_vehicules=1) Consommation moyenne du véhicule (en litres aux 100 km) - Q174"
  label(e[[44]]) <- "km_1: (nb_vehicules=1) Nombre de kilomètres parcourus par le véhicule lors des 12 derniers mois - Q38"
  label(e[[45]]) <- "fuel_2_1: (nb_vehicules=2) Carburant du véhicule principal (Essence/Diesel/Électrique ou hybride/Autre) - Q100"
  label(e[[46]]) <- "fuel_2_2: (nb_vehicules=2) Carburant du deuxième véhicule (Essence/Diesel/Électrique ou hybride/Autre) - Q101"
  label(e[[47]]) <- "conso_2_choix: (nb_vehicules=2) Consommation moyenne des véhicules du ménage (L par 100km / NSP) - Q176"
  label(e[[48]]) <- "conso_2: (nb_vehicules=2) Consommation moyenne des véhicules du ménage (en litres aux 100 km) - Q176"
  label(e[[49]]) <- "km_2: (nb_vehicules=2) Nombre de kilomètres parcourus par l'ensemble des véhicules lors des 12 derniers mois - Q141"
  label(e[[50]]) <- "solution_CC_progres: Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(e[[51]]) <- "solution_CC_changer: Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(e[[52]]) <- "solution_CC_traite: C’est aux États de réglementer, au niveau mondial, le changement climatique - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(e[[53]]) <- "solution_CC_rien: Il n’y a rien à faire, le changement climatique est inévitable - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(e[[54]]) <- "echelle_politique_CC: Pensez-vous que le changement climatique exige d’être pris en charge par des politiques publiques ... (Nationales; Mondiales; Européennes; Locales; À toutes les échelles)"
  label(e[[55]]) <- "pour_taxe_distance: Augmenter le prix des produits de consommation qui sont acheminés par des modes de transport polluants - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[56]]) <- "pour_renouvelables: Développer les énergies renouvelables même si, dans certains cas, les coûts de production sont plus élevés, pour le moment - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[57]]) <- "pour_densification: Densifier les villes en limitant l’habitat pavillonnaire au profit d’immeubles collectifs - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[58]]) <- "pour_voies_reservees: Favoriser l’usage (voies de circulation, place de stationnement réservées) des véhicules peu polluants ou partagés (covoiturage) - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[59]]) <- "pour_cantines_vertes: Obliger la restauration collective publique à proposer une offre de menu végétarien, biologique et/ou de saison - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[60]]) <- "pour_fin_gaspillage: Réduire le gaspillage alimentaire de moitié - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[61]]) <- "France_CC: Pensez-vous que la France doit prendre de l’avance sur d’autres pays dans la lutte contre le changement climatique ? (Oui; Non; NSP)"
  label(e[[62]]) <- "obstacles_lobbies: Les lobbies - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[63]]) <- "obstacles_manque_volonte: Le manque de volonté politique - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[64]]) <- "obstacles_manque_cooperation: Le manque de coopération entre pays - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[65]]) <- "obstacles_inegalites: Les inégalités - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[66]]) <- "obstacles_incertitudes: Les incertitudes de la communauté scientifique - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[67]]) <- "obstacles_demographie: La démographie - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[68]]) <- "obstacles_technologies: Le manque de technologies alternatives - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[69]]) <- "obstacles_rien: Rien de tout cela - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[70]]) <- "test_qualite: Merci de sélectionner 'Un peu' (Pas du tout/Un peu/Beaucoup/Complètement/NSP) - Q177"
  label(e[[71]]) <- "cause_CC_CCC: Pensez-vous que le changement climatique est dû à (Uniquement à des processus naturels; Uniquement à l'activité humaine; Principalement à des processus naturels; Principalement à l'activité humaine; Autant à des processus naturels qu'à l'activité humaine; Je ne pense pas qu'il y ait un changement climatique; NSP)"
  label(e[[72]]) <- "cause_CC_AT: Cause principale du changement climatique selon le répondant (N'est pas une réalité / Causes naturelles / Activité humaine / NSP) - Q1"
  label(e[[73]]) <- "effets_CC_CCC: Si le changement climatique continue, à votre avis, quelles seront les conséquences en France d'ici une cinquantaine d'années ? (Les conditions de vie deviendront extrêmement pénibles à cause des dérèglements climatiques; Il y aura des modifications de climat mais on s'y adaptera sans trop de mal; Le changement climatique aura des effets positifs pour l'agriculture et les loisirs)"
  label(e[[74]]) <- "effets_CC_AT: Le répondant pense qu'en l'absence de mesures ambitieuse, les effets du changement climatiques seraient (Insignifiants / Faibles / Graves / Désastreux / Cataclysmiques / NSP) - Q5"
  label(e[[75]]) <- "responsable_CC_chacun: Le répondant estime que chacun d'entre nous est responsabe du changement climatique - Q6"
  label(e[[76]]) <- "responsable_CC_riches: Le répondant estime que les plus riches sont responsables du changement climatique - Q6"
  label(e[[77]]) <- "responsable_CC_govts: Le répondant estime que les gouvernements sont responsables du changement climatique - Q6"
  label(e[[78]]) <- "responsable_CC_etranger: Le répondant estime que certains pays étrangers sont responsables du changement climatique - Q6"
  label(e[[79]]) <- "responsable_CC_passe: Le répondant estime que les générations passées sont responsables du changement climatique - Q6"
  label(e[[80]]) <- "responsable_CC_nature: Le répondant estime que des causes naturelles sont responsables du changement climatique - Q6"
  label(e[[81]]) <- "issue_CC: Pensez-vous que le changement climatique sera limité à un niveau acceptable d’ici la fin du siècle  (Oui, certainement; probablement; Non, probablement; certainement pas)"
  label(e[[82]]) <- "parle_CC: Fréquence à laquelle le répondant parle du changement climatique (Plusieurs fois par mois / par an / Presque jamais / NSP) - Q60"
  label(e[[83]]) <- "part_anthropique: À votre avis, quelle est la part des Français qui estiment que le changement climatique est principalement dû à l'activité humaine ? (en %) - Q61"
  label(e[[84]]) <- "efforts_relatifs: ~ Répondant prêt à faire plus d'efforts que la majorité des Français [si variante_vous==1, sinon Est-ce que la majorité est prête à faire plus d'efforts que vous] (Beaucoup/Un peu plus/Autant/Un peu/Beaucoup moins) [réponses recodées pour que leur sens soit indépendant de vairante_vous]"
  label(e[[85]]) <- "soutenu_obligation_renovation: L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(e[[86]]) <- "soutenu_normes_isolation: Des normes plus strictes sur l'isolation pour les nouveaux bâtiments - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(e[[87]]) <- "soutenu_bonus_malus: Un renforcement du bonus/malus écologique pour l’achat d’un véhicule - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(e[[88]]) <- "soutenu_limitation_110: L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(e[[89]]) <- "pour_taxe_carbone_contre: ~ Sachant qu'une majorité est contre - Favorable à une augmentation de la taxe carbone (Oui/Non/NSP) - Q64" # https://www.ademe.fr/sites/default/files/assets/documents/rapport-representations-sociales-changement-climatique-20-vague.pdf 
  label(e[[90]]) <- "pour_taxe_carbone_pour: ~ Sachant qu'une majorité est pour - Favorable à une augmentation de la taxe carbone (Oui/Non/NSP) - Q92" # https://www.ademe.fr/sites/default/files/assets/documents/rapport-analyse-representations-sociales-changement-climatique-19-vague-2018.pdf
  label(e[[91]]) <- "pour_taxe_carbone_neutre: ~ Sans information - Favorable à une augmentation de la taxe carbone (Oui/Non/NSP) - Q92"
  label(e[[92]]) <- "confiance_gens: D’une manière générale, diriez-vous que… ? (On peut faire confiance à la plupart des gens/On n’est jamais assez prudent quand on a affaire aux autres) - Q65"
  label(e[[93]]) <- "qualite_enfant_independance: l'indépendance - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[94]]) <- "qualite_enfant_tolerance: la tolérance et le respect des autres - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[95]]) <- "qualite_enfant_generosite: la générosité - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[96]]) <- "qualite_enfant_travail: l'assiduité au travail - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[97]]) <- "qualite_enfant_epargne: le sens de l'épargne - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[98]]) <- "qualite_enfant_obeissance: l'obéissance - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[99]]) <- "qualite_enfant_responsabilite: la responsabilité - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[100]]) <- "qualite_enfant_determination: la détermination et la persévérance - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[101]]) <- "qualite_enfant_expression: l'expression personnelle - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[102]]) <- "qualite_enfant_imagination: l'imagination - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[103]]) <- "qualite_enfant_foi: la foi religieuse - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[104]]) <- "redistribution: Que pensez-vous de l’affirmation suivante : « Pour établir la justice sociale, il faudrait prendre aux riches pour donner aux pauvres » ? (0-10)"
  label(e[[105]]) <- "problemes_invisibilises: Avez-vous le sentiment d’être confronté·e personnellement à des difficultés importantes que les pouvoirs publics ou les médias ne voient pas vraiment ? (Très; Assez; Peu souvent; Jamais)"
  label(e[[106]]) <- "importance_environnement: La protection de l'environnement - À quel point est-ce important pour vous ? (0-10)"
  label(e[[107]]) <- "importance_associatif:  L’action sociale et associative - À quel point est-ce important pour vous ? (0-10)"
  label(e[[108]]) <- "importance_confort: L’amélioration de mon niveau de vie et de confort - À quel point est-ce important pour vous ? (0-10)"
  label(e[[109]]) <- "trop_impots: Paie-t-on trop d'impôt en France ? (Oui/Non/Ça dépend qui et quels impôts/NSP)"
  label(e[[110]]) <- "confiance_sortition: Quel est votre niveau de confiance dans la capacité de citoyens tirés au sort à délibérer de manière productive sur des questions politiques complexes ? (Pas du tout/Plutôt pas/Plutôt/Tout à fait confiance)"
  label(e[[111]]) <- "pour_sortition: Seriez-vous favorable à une réforme constitutionnelle qui introduirait une assemblée constituée de 150 citoyens tirés au sort, et qui doterait cette assemblée d'un droit de veto sur les textes de lois votés au Parlement ?"
  label(e[[112]]) <- "connait_CCC: Avez-vous entendu parler de la Convention Citoyenne pour le Climat ? (Oui, je sais très/assez bien ce que c'est/J'en ai entendu parler mais je ne sais pas très bien ce que c'est/Non, je n'en ai jamais entendu parler)"
  label(e[[113]]) <- "connaissance_CCC: Décrivez ce que vous savez de la Convention Citoyenne pour le Climat. (champ libre)"
  label(e[[114]]) <- "sait_CCC_devoilee: [Si pas Non à connait_CCC] Savez-vous si des mesures proposées par la Convention Citoyenne pour le Climat ont déjà été dévoilées ? (Oui, des mesures ont déjà été dévoilées/Je crois avoir entendu parler de mesures de la Convention mais je ne suis pas sûr·e/Aucune mesure n'a été dévoilée à ma connaissance)"
  label(e[[115]]) <- "CCC_inutile: Inutile car le gouvernement ne reprendra que les mesures qui lui plaisent - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[116]]) <- "CCC_prometteuse_climat: Une méthode prometteuse pour définir la politique climatique de la France - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[117]]) <- "CCC_espoir_institutions: Un espoir pour le renouveau des institutions - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[118]]) <- "CCC_vouee_echec: Une expérience vouée à l’échec - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[119]]) <- "CCC_operation_comm: Une opération de communication du gouvernement - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[120]]) <- "CCC_initiative_sincere: Une initiative sincère du gouvernement en faveur de la démocratie - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[121]]) <- "CCC_pour_se_defausser: Une façon pour le gouvernement de se défausser de ses responsabilités - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[122]]) <- "CCC_entendre_francais: Une opportunité pour faire entendre la voix de l’ensemble des Français - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[123]]) <- "CCC_controlee_govt: Une assemblée manipulée ou contrôlée par le gouvernement - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[124]]) <- "CCC_representative: Une assemblée représentative de la population - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[125]]) <- "CCC_autre_choix: Autre - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[126]]) <- "CCC_autre: Autre (champ libre) - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[127]]) <- "CCC_devoile_fonds_mondial_info_CCC: ~ [Si pas Non à sait_CCC_devoilee] Une contribution à un fonds mondial pour le climat - Le répondant pense que la CCC a proposé cette mesure [e1: dévoilé] (info_CCC==1)"
  label(e[[128]]) <- "CCC_devoile_obligation_renovation_info_CCC: ~ [Si pas Non à sait_CCC_devoilee] L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - Le répondant pense que la CCC a proposé cette mesure [e1: dévoilé] (info_CCC==1)"
  label(e[[129]]) <- "CCC_devoile_taxe_viande_info_CCC: ~ [Si pas Non à sait_CCC_devoilee] Une taxe sur la viande rouge - Le répondant pense que la CCC a proposé cette mesure [e1: dévoilé] (info_CCC==1)"
  label(e[[130]]) <- "CCC_devoile_limitation_110_info_CCC: ~ [Si pas Non à sait_CCC_devoilee] L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - Le répondant pense que la CCC a proposé cette mesure [e1: dévoilé] (info_CCC==1)"
  label(e[[131]]) <- "first_click:"
  label(e[[132]]) <- "last_click:"
  label(e[[133]]) <- "duree_info_CCC: Temps passé sur la page affichant l'information sur la CCC (info_CCC==1)"
  label(e[[134]]) <- "click_count:"
  label(e[[135]]) <- "concentration_info_CCC: ~ (info_CCC==1) À votre avis, devrions-nous utiliser vos réponses ... ? (Oui, j'ai consacré toute mon attention aux questions jusqu'à présent et je pense que vous devriez utiliser mes réponses pour votre étude/Non, je n'ai pas consacré toute mon attention aux questions jusqu'à présent et je pense que vous ne devriez pas utiliser mes réponses pour votre étude)"
  label(e[[136]]) <- "first_click_:"
  label(e[[137]]) <- "last_click_:"
  label(e[[138]]) <- "duree_concentration: Temps passé sur la page affichant l'avertissement sur la concentration. (info_CCC==0)"
  label(e[[139]]) <- "click_count_:"
  label(e[[140]]) <- "concentration_no_info_CCC: ~ (info_CCC==0) À votre avis, devrions-nous utiliser vos réponses ... ? (Oui, j'ai consacré toute mon attention aux questions jusqu'à présent et je pense que vous devriez utiliser mes réponses pour votre étude/Non, je n'ai pas consacré toute mon attention aux questions jusqu'à présent et je pense que vous ne devriez pas utiliser mes réponses pour votre étude)"
  label(e[[141]]) <- "pour_obligation_renovation: ~ L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[142]]) <- "pour_limitation_110: ~ L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[143]]) <- "pour_restriction_centre_ville: ~ L'interdiction des véhicules les plus polluants dans les centre-villes - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[144]]) <- "pour_conditionner_aides: ~ Le conditionnement des aides à l'innovation versées aux entreprises à la baisse de leur bilan carbone - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[145]]) <- "pour_taxe_viande: ~ Une taxe sur la viande rouge - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[146]]) <- "pour_fonds_mondial: ~ Une contribution à un fonds mondial pour le climat - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[147]]) <- "pour_aides_train: ~ Une baisse des prix des billets de train grâce à des aides de l'État - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[148]]) <- "pour_bonus_malus: ~ Un renforcement du bonus/malus écologique pour l’achat d’un véhicule - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[149]]) <- "referendum_consigne: ~ La mise en place d'un système de consigne de verre et plastique d'ici 2025 - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[150]]) <- "referendum_taxe_dividendes: ~ Une taxe de 4% sur les dividendes des entreprises versant plus de 10 millions d'euros de dividendes, pour financer la transition écologique - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[151]]) <- "referendum_interdiction_polluants: ~ L'interdiction dès 2025 de la vente des véhicules neufs les plus polluants - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[152]]) <- "referendum_interdiction_publicite: ~ L'interdiction de la publicité pour les produits les plus polluants - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[153]]) <- "referendum_cheque_bio: ~ La mise en place de chèque alimentaires pour les plus démunis à utiliser dans les AMAP ou le bio - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[154]]) <- "referendum_obligation_renovation: ~ L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[155]]) <- "CCC_devoile_fonds_mondial_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] Une contribution à un fonds mondial pour le climat - Le répondant pense que la CCC a proposé cette mesure [e1: dévoilé] (info_CCC==0)"
  label(e[[156]]) <- "CCC_devoile_obligation_renovation_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - Le répondant pense que la CCC a proposé cette mesure [e1: dévoilé] (info_CCC==0)"
  label(e[[157]]) <- "CCC_devoile_taxe_viande_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] Une taxe sur la viande rouge - Le répondant pense que la CCC a proposé cette mesure [e1: dévoilé] (info_CCC==0)"
  label(e[[158]]) <- "CCC_devoile_limitation_110_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - Le répondant pense que la CCC a proposé cette mesure [e1: dévoilé] (info_CCC==0)"
  label(e[[159]]) <- "gain_net_choix: Choix - Gain ou perte ou non affecté ou NSP  pour le gain net face à la taxe avec dividende (cf. gain_net_choix, taxe_approbation)." # description + gain_net_NSP à partir de 150 réponses / 20/10 3h50 / bug jusqu'à 168 - 7h38: il était impossible de sélectionner NSP #"confiance_dividende: ~ [Si question_confiance > 0] Avez-vous confiance dans le fait que l'État vous versera effectivement 110€ par an (220€ pour un couple) si une telle réforme est mise en place ? (Oui/À moitié/Non)"
  label(e[[160]]) <- "gain_net_gain: Montant du gain du ménage pour le gain net face à la taxe avec dividende (cf. gain_net_choix, taxe_approbation)." #"hausse_depenses_subjective: ~ À combien estimez-vous alors la hausse des dépenses de combustibles de votre ménage ? (aucune hausse : au contraire, mon ménage réduirait ses dépenses de combustibles/aucune hausse, aucune baisse/entre 1 et 30/30 et 70/70 et 120/120 et 190/à plus de 190 € par an /UC)"
  label(e[[161]]) <- "gain_net_perte: Montant de la perte du ménage pour le gain net face à la taxe avec dividende (cf. gain_net_choix, taxe_approbation)." #"gagnant_categorie: ~ Ménage Gagnant/Non affecté/Perdant par hausse taxe carbone redistribuée à tous (+110€/an /adulte, +13/15% gaz/fioul, +0.11/13 €/L diesel/essence)"
  label(e[[162]]) <- "certitude_gagnant: ~ Degré de certitude à gagnant_categorie (Je suis/suis moyennement/ne suis pas vraiment/ne suis pas du tout sûr·e de ma réponse)"
  label(e[[163]]) <- "taxe_approbation: ~ taxe_approbation: Approbation d'une hausse de la taxe carbone compensée (+110€/an /adulte, +13/15% gaz/fioul, +0.11/13 €/L diesel/essence) (Oui/Non/NSP) ~ origine_taxe (gouvernement/CCC/inconnue) / label_taxe (CCE/taxe)"
  label(e[[164]]) <- "gagnant_alternative_categorie: ~ info si le ménage est gagnant/perdant - Ménage Gagnant/Non affecté/Perdant par taxe avec dividende alternative, i.e. variante urba (dividende de 88€ en centre-ville à 133€ rural) ou détaxe (1t/an non taxé)"
  label(e[[165]]) <- "certitude_gagnant_alternative: ~ Degré de certitude à gagnant_categorie (Je suis/suis moyennement/ne suis pas vraiment/ne suis pas du tout sûr·e de ma réponse) pour taxe avec dividende alternative, i.e. variante urba (dividende de 88€ en centre-ville à 133€ rural) ou détaxe (1t/an non taxé)"
  label(e[[166]]) <- "taxe_alternative_approbation: ~ info si le ménage est gagnant/perdant - Approbation d'une taxe avec dividende alternative, i.e. variante urba (dividende de 88€ en centre-ville à 133€ rural) ou détaxe (1t/an non taxé) (Oui/Non/NSP)" 
  label(e[[167]]) <- "interet_politique: Le répondant est intéressé par la politique (Presque pas/Un peu/Beaucoup)"
  label(e[[168]]) <- "confiance_gouvernement: En général, faites-vous confiance au gouvernement pour prendre de bonnes décisions ? (Toujours/La plupart/La moitié du temps/Parfois/Jamais/NSP)"
  label(e[[169]]) <- "extr_gauche: Le répondant se considère comme étant d'extrême gauche"
  label(e[[170]]) <- "gauche: Le répondant se considère comme étant de gauche"
  label(e[[171]]) <- "centre: Le répondant se considère comme étant du centre"
  label(e[[172]]) <- "droite: Le répondant se considère comme étant de droite"
  label(e[[173]]) <- "extr_droite: Le répondant se considère comme étant d'extrême droite"
  label(e[[174]]) <- "conservateur: Le répondant se considère comme étant conservateur"
  label(e[[175]]) <- "liberal: Le répondant se considère comme étant libéral"
  label(e[[176]]) <- "humaniste: Le répondant se considère comme étant humaniste"
  label(e[[177]]) <- "patriote: Le répondant se considère comme étant patriote"
  label(e[[178]]) <- "apolitique: Le répondant se considère comme étant apolitique"
  label(e[[179]]) <- "ecologiste: Le répondant se considère comme étant écologiste"
  label(e[[180]]) <- "CCC_devoile_28_heures_info_CCC: ~ [Si pas Non à sait_CCC_devoilee] La réduction du temps de travail légal à 28 heures par semaine - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==1)" 
  label(e[[181]]) <- "gilets_jaunes_dedans: Le répondant déclare faire partie des gilets jaunes"
  label(e[[182]]) <- "gilets_jaunes_soutien: Le répondant soutient les gilets jaunes"
  label(e[[183]]) <- "gilets_jaunes_compris: Le répondant comprend les gilets jaunes"
  label(e[[184]]) <- "gilets_jaunes_oppose: Le répondant est opposé aux gilets jaunes"
  label(e[[185]]) <- "gilets_jaunes_NSP: Le répondant ne sait pas s'il fait partie / s'il soutient / s'il comprend / s'il s'oppose aux gilets jaunes"
  label(e[[186]]) <- "champ_libre: Le sondage touche à sa fin. Vous pouvez désormais inscrire toute remarque, commentaire ou suggestion dans le champ ci-dessous."
  label(e[[187]]) <- "mail: Si vous désirez recevoir les résultats de cette enquête ou participer à la deuxième partie de cette enquête (une fois que la Convention Citoyenne pour le Climat aura rendu ses propositions), vous pouvez inscrire ci-dessous votre adresse mail. Nous ne vous enverrons que deux e-mails en tout."
  label(e[[188]]) <- "id: identifiant Bilendi"
  label(e[[189]]) <- "Q_TotalDuration:"
  label(e[[190]]) <- "exclu: Vide si tout est ok (Screened/QuotaMet sinon)"
  label(e[[191]]) <- "taille_agglo: (PERSO1) Taille d'agglomération: [1;5]=rural/-20k/20-100k/+100k/Région parisienne - embedded data"
  label(e[[192]]) <- "region: Région calculée à partir du code postal: 9 nouvelles régions de l'hexagone + autre (ARA/Est/Ouest/Centre/Nord/IDF/SO/Occ/PACA/autre)"
  label(e[[193]]) <- "gaz: Indicatrice que chauffage = 'Gaz de ville' ou 'Butane, propane, gaz en citerne'"
  label(e[[194]]) <- "fioul: Indicatrice que chauffage = 'Fioul, mazout, pétrole'"
  label(e[[195]]) <- "nb_vehicules: Nombre de véhicules motorisés dont dispose le ménage"
  label(e[[196]]) <- "hausse_depenses: Hausse des taxes énergétiques simulées pour le ménage, suite à la taxe (élasticité de 0.4/0.2 pour carburants/chauffage, gain fiscal utilisé, nb adultes non plafonné, seulement interaction pour chauffage)" # gain fiscal utilisé pck c'est dans l'intervalle gain net - gain inélastique, et ça somme à 0. heating_increase = 1.4999036*gas*surface + 2.6820197* fuel*surface - 0.0050740*fuel*surface^2
  label(e[[197]]) <- "conso_embedded:  Consommation moyenne du véhicule (en litres aux 100 km)" #"simule_gagnant: Indicatrice sur la prédiction que le ménage serait gagnant avec la taxe compensée, d'après nos simulations"
  label(e[[198]]) <- "representativite_CCC: Pensez-vous que les citoyens membres de la Convention Citoyenne pour le Climat sont représentatifs de l'ensemble des Français ? (Oui/Non/NSP)" #"hausse_chauffage: Hausse des dépenses de chauffage simulées pour le ménage, suite à la taxe (élasticité de 0.15 au lieu de 0.2)"
  label(e[[199]]) <- "CCC_non_representative_gauche: [Si Non à representativite_CCC] Ils sont plus à gauche politiquement - En quoi selon-vous ces citoyens diffèrent-ils de la moyenne des Français ? (Plusieurs réponses possibles.)" #
  label(e[[200]]) <- "CCC_non_representative_droite: [Si Non à representativite_CCC] Ils sont plus à droite politiquement - En quoi selon-vous ces citoyens diffèrent-ils de la moyenne des Français ? (Plusieurs réponses possibles.)" #
  label(e[[201]]) <- "CCC_non_representative_ecolo: [Si Non à representativite_CCC] Ils sont plus écologistes - En quoi selon-vous ces citoyens diffèrent-ils de la moyenne des Français ? (Plusieurs réponses possibles.)" #
  label(e[[202]]) <- "CCC_non_representative_anti_ecolo: [Si Non à representativite_CCC] Ils sont moins écologistes - En quoi selon-vous ces citoyens diffèrent-ils de la moyenne des Français ? (Plusieurs réponses possibles.)" #"info_CCC: Indicatrice (aléatoire 0/1) que l'information sur la CCC a été affichée: La Convention Citoyenne pour le Climat est une assemblée indépendante de 150 citoyens tirés au sort qui a pour mandat de faire des propositions permettant de réduire les émissions de gaz à effet de serre françaises dans un esprit de justice sociale. Elle se réunit régulièrement depuis septembre 2019 et va bientôt rendre compte de ses propositions."
  label(e[[203]]) <- "CCC_non_representative_pro_gouv: [Si Non à representativite_CCC] Ils sont plus pro-gouvernement - En quoi selon-vous ces citoyens diffèrent-ils de la moyenne des Français ? (Plusieurs réponses possibles.)" #"question_confiance: Indicatrice que la question confiance_dividende a été affichée" # Variable aléatoire 0/1/2/3
  label(e[[204]]) <- "CCC_non_representative_anti_gouv: [Si Non à representativite_CCC] Ils sont moins pro-gouvernement - En quoi selon-vous ces citoyens diffèrent-ils de la moyenne des Français ? (Plusieurs réponses possibles.)" #
  label(e[[205]]) <- "CCC_non_representative_autre_choix: [Si Non à representativite_CCC] Autre (choix) - En quoi selon-vous ces citoyens diffèrent-ils de la moyenne des Français ? (Plusieurs réponses possibles.)" #
  label(e[[206]]) <- "CCC_non_representative_autre: Autre (champ libre) - En quoi selon-vous ces citoyens diffèrent-ils de la moyenne des Français ? (Plusieurs réponses possibles.)" #label_taxe: Variante à la description de la taxe carbone avec dividendes. (taxe: ... une augmentation de la taxe carbone ... / CCE: une augmentation de la contribution climat-énergie)"
  label(e[[207]]) <- "referendum_ecocide: ~ La reconnaissance du crime d'«écocide» - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[208]]) <- "referendum_environnement_priorite_constit: ~ L'inscription dans la Constitution que la préservation de l'environnement passe avant tout - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[209]]) <- "referendum_environnement_constitution: ~ L'inscription dans la Constitution de la préservation de la biodiversité, de l'environnement et de la lutte contre le dérèglement climatique - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[210]]) <- "CCC_devoile_28_heures_no_info_CCC: ~ [Si pas Non à sait_CCC_devoilee] La réduction du temps de travail légal à 28 heures par semaine - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==0)"
  label(e[[211]]) <- "Q98_First Click"
  label(e[[212]]) <- "Q98_Last Click"
  label(e[[213]]) <- "duree_taxe: Temps passé (en secondes) sur le bloc de taxe_approbation et gain_net (avec variante 110/170/0 + EELV/gouv)"
  label(e[[214]]) <- "Q98_Click Count"
  label(e[[215]]) <- "avis_estimation: Que pensez-vous de notre estimation de [hausse taxe]€ par an pour l'augmentation de taxes payées lors des achats de combustibles de votre ménage ? (Trop élevé/Correct/Trop bas/NSP)"
  label(e[[216]]) <- "Q99_First Click"
  label(e[[217]]) <- "Q99_Last Click"
  label(e[[218]]) <- "duree_taxe_alternative: Temps passé (en secondes) sur le bloc proposant une variante à la taxe avec dividende (soit urba (si dividende != 170 & random != 0) soit detaxe sinon)" 
  label(e[[219]]) <- "Q99_Click Count"
  label(e[[220]]) <- "pour_28h: Êtes-vous favorable à la réduction du temps de travail légal à 28 heures par semaine ?"
  label(e[[221]]) <- "parti: Sans penser seulement aux élections, veuillez indiquer de quel parti politique vous vos sentez le plus proche ou du moins le moins éloigné ?"
  label(e[[222]]) <- "soutien_parti: Lorsque vous soutenez un parti\npolitique, c’est surtout parce que :"
  label(e[[223]]) <- "depute_devrait_votants: représenter ceux qui ont voté pour lui - Le rôle d'un député devrait être avant tout de... (0 à 10)"
  label(e[[224]]) <- "depute_devrait_circo: représenter sa circonscription - Le rôle d'un député devrait être avant tout de... (0 à 10)"
  label(e[[225]]) <- "depute_devrait_pays: représenter l'ensemble du pays - Le rôle d'un député devrait être avant tout de... (0 à 10)"
  label(e[[226]]) <- "depute_devrait_parti: représenter son parti - Le rôle d'un député devrait être avant tout de... (0 à 10)"
  label(e[[227]]) <- "depute_devrait_jugement: suivre son propre jugement - Le rôle d'un député devrait être avant tout de... (0 à 10)"
  label(e[[228]]) <- "depute_votants: représentent ceux qui ont voté pour eux - Et en réalité ? D'après vous, la plupart des députés... (0 à 10)"
  label(e[[229]]) <- "depute_circo: représentent leur circonscription - Et en réalité ? D'après vous, la plupart des députés... (0 à 10)"
  label(e[[230]]) <- "depute_pays: représentent l'ensemble du pays - Et en réalité ? D'après vous, la plupart des députés... (0 à 10)"
  label(e[[231]]) <- "depute_parti: représentent leurs partis - Et en réalité ? D'après vous, la plupart des députés... (0 à 10)"
  label(e[[232]]) <- "depute_jugement: suivent leur propre jugement - Et en réalité ? D'après vous, la plupart des députés... (0 à 10)"
  label(e[[233]]) <- "contre_parti: voter contre mon parti - À la prochaine élection législative, est-il envisageable pour vous de voter contre un candidat de votre parti préféré parce que vous ne lui faites pas confiance en tant que personne. (0 à 10)"
  label(e[[234]]) <- "hausse_chauffage: Hausse des dépenses de chauffage simulées pour le ménage, suite à la taxe (élasticité de 0.15 au lieu de 0.2)"
  label(e[[235]]) <- "hausse_diesel: Hausse des dépenses de diesel simulées pour le ménage, suite à la taxe (élasticité de 0.4)"
  label(e[[236]]) <- "hausse_essence: Hausse des dépenses d'essence simulées pour le ménage, suite à la taxe (élasticité de 0.4)"
  label(e[[237]]) <- "km_embedded: Nombre de kilomètres parcourus lors des 12 derniers mois en voiture ou moto (par le répondant pour nb_vehicules=0, par les véhicules sinon)"
  label(e[[238]]) <- "info_CCC: Indicatrice (aléatoire 0/1) que l'information sur la CCC a été affichée: La Convention Citoyenne pour le Climat est une assemblée indépendante de 150 citoyens tirés au sort qui a pour mandat de faire des propositions permettant de réduire les émissions de gaz à effet de serre françaises dans un esprit de justice sociale. Elle se réunit régulièrement depuis septembre 2019 et va bientôt rendre compte de ses propositions."
  label(e[[239]]) <- "random: Nombre aléatoire entre 0 et 3, déterminant la variante alternative à la taxe carbone présentée (urba ou détaxe)"
  label(e[[240]]) <- "variante_efforts_vous: Indicatrice (aléatoire 0/1) que efforts_relatifs est 'vous relativement aux autres' (au contraire, si variante_efforts_vous==0, efforts_relatifs est posée: Est-ce que la majorité est prête à plus d'efforts que vous)"
  label(e[[241]]) <- "origine_taxe: Variante à l'amorce pour la taxe carbone avec dividendes. (inconnue: Imaginez ... / CCC: Imaginez que la CCC propose ... / gouvernement: Imaginez que le gouvernement propsoe ... / EELV: Imaginez que lors de la prochaine campagne présidentielle, le parti Europe-Écologie-les Verts propose)"
  label(e[[242]]) <- "dividende: Variante à la valeur du dividende de la taxe carbone avec dividende. (0/110/170)"
  # label(e[[243]]) <- "gain_net_NSP:"
    
  for (i in 1:length(e)) names(e)[i] <- sub(':.*', '', label(e[[i]]))
  return(e)
}
relabel_and_rename2_pilote <- function(e) {
  # Notation: ~ means that it's a random variant; * means that another question is exactly the same (in another random branch)
  
  # The commented lines below should be executed before creating relabel_and_rename, to ease the filling of each name and label
  for (i in 1:length(e)) {
    label(e[[i]]) <- paste(names(e)[i], ": ", label(e[[i]]), e[[i]][1], sep="");
    # print(paste(i, label(e[[i]])))
  }
  e <- e[-c(1:2),]
  
  label(e[[1]]) <- "date:"
  label(e[[2]]) <- "date_fin:"
  label(e[[3]]) <- "statut_reponse:"
  label(e[[4]]) <- "ip:"
  label(e[[5]]) <- "progres:"
  label(e[[6]]) <- "duree:"
  label(e[[7]]) <- "fini:"
  label(e[[8]]) <- "date_enregistree:"
  label(e[[9]]) <- "ID_qualtrics:"
  label(e[[10]]) <- "nom:"
  label(e[[11]]) <- "prenom:"
  label(e[[12]]) <- "mmail:"
  label(e[[13]]) <- "ref:"
  label(e[[14]]) <- "lat:"
  label(e[[15]]) <- "long:"
  label(e[[16]]) <- "distr:"
  label(e[[17]]) <- "lang:"
  label(e[[18]]) <- "code_postal: Code Postal - Q93"
  label(e[[19]]) <- "sexe: Sexe (Masculin/Féminin) - Q96"
  label(e[[20]]) <- "age: Tranche d'âge (18-24/25-34/35-49/50-64/65+) - Q184"
  label(e[[21]]) <- "statut_emploi: Statut d'emploi (Chômage/CDD/CDI/fonctionnaire/étudiant-e/retraité-e/précaire/autre actif/autre inactif) - Q35"
  label(e[[22]]) <- "csp: Catégorie Socio-Professionnelle: Agriculteur/Indépendant: Artisan, commerçant.e/Cadre: Profession libérale, cadre/Intermédiaire: Profession intermédiaire/Employé/Ouvrier/Retraité/Inactif: Autres inactif/ve - Q98"
  label(e[[23]]) <- "diplome: Diplôme le plus haut obtenu ou prévu: Aucun/Brevet/CAP/Bac/+2/+3/>+4) - Q102"
  label(e[[24]]) <- "taille_menage: Taille du ménage #(vous, membres de votre famille vivant avec vous et personnes à votre charge) - Q29"
  label(e[[25]]) <- "revenu: Revenu mensuel net du répondant - Q148"
  label(e[[26]]) <- "rev_tot: Revenu mensuel net du ménage - Q25"
  label(e[[27]]) <- "nb_14_et_plus: Nombre de personnes âgées d'au moins 14 ans dans le ménage - Q31"
  label(e[[28]]) <- "nb_adultes: Nombre de personnes majeures dans le ménage - Q149"
  label(e[[29]]) <- "locataire: Locataire - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(e[[30]]) <- "proprio_occupant: Propriétaire occupant - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(e[[31]]) <- "proprio_bailleur: Propriétaire bailleur - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(e[[32]]) <- "heberge_gratis: Hébergé gratuitement - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(e[[33]]) <- "patrimoine: Patrimoine net du ménage (ou de la personne si elle vit chez ses parents) (<10/10-60/60-180/180-350/350-550/>550k€/NSP) - Q129" # les quintiles + dernier décile 2018 https://www.insee.fr/fr/statistiques/2388851
  label(e[[34]]) <- "surface: Surface du logement (en m²) - Q175"
  label(e[[35]]) <- "chauffage: source d'énergie principale (Électricité/Gaz de ville/Butane, propane, gaz en citerne/Fioul, mazout, pétrole/Bois, solaire, géothermie, aérothermie (pompe à chaleur)/Autre/NSP)"
  label(e[[36]]) <- "transports_travail: Le répondant utilise principalement (la voiture/les TC/la marche ou le vélo/un deux roues motorisé/le covoiturage/non conerné) pour ses trajets domiciles-travail (ou études) - Q39"
  label(e[[37]]) <- "transports_courses: Le répondant utilise principalement (la voiture/les TC/la marche ou le vélo/un deux roues motorisé/le covoiturage/non conerné) pour faire ses courses - Q39"
  label(e[[38]]) <- "transports_loisirs: Le répondant utilise principalement (la voiture/les TC/la marche ou le vélo/un deux roues motorisé/le covoiturage/non conerné) pour ses loisirs (hors vacances) - Q39"
  label(e[[39]]) <- "nb_vehicules_texte: Nombre de véhicules motorisés dont dispose le ménage - Q37"
  label(e[[40]]) <- "km_0: (nb_vehicules=0) Nombre de kilomètres parcourus en voiture ou moto par le répondant lors des 12 derniers mois - Q142"
  label(e[[41]]) <- "fuel_1: (nb_vehicules=1) Carburant du véhicule (Essence/Diesel/Électrique ou hybride/Autre) - Q77"
  label(e[[42]]) <- "conso_1_choix: (nb_vehicules=1) Consommation moyenne du véhicule (L par 100km / NSP) - Q174"
  label(e[[43]]) <- "conso_1: (nb_vehicules=1) Consommation moyenne du véhicule (en litres aux 100 km) - Q174"
  label(e[[44]]) <- "km_1: (nb_vehicules=1) Nombre de kilomètres parcourus par le véhicule lors des 12 derniers mois - Q38"
  label(e[[45]]) <- "fuel_2_1: (nb_vehicules=2) Carburant du véhicule principal (Essence/Diesel/Électrique ou hybride/Autre) - Q100"
  label(e[[46]]) <- "fuel_2_2: (nb_vehicules=2) Carburant du deuxième véhicule (Essence/Diesel/Électrique ou hybride/Autre) - Q101"
  label(e[[47]]) <- "conso_2_choix: (nb_vehicules=2) Consommation moyenne des véhicules du ménage (L par 100km / NSP) - Q176"
  label(e[[48]]) <- "conso_2: (nb_vehicules=2) Consommation moyenne des véhicules du ménage (en litres aux 100 km) - Q176"
  label(e[[49]]) <- "km_2: (nb_vehicules=2) Nombre de kilomètres parcourus par l'ensemble des véhicules lors des 12 derniers mois - Q141"
  label(e[[50]]) <- "solution_CC_progres: Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(e[[51]]) <- "solution_CC_changer: Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(e[[52]]) <- "solution_CC_traite: C’est aux États de réglementer, au niveau mondial, le changement climatique - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(e[[53]]) <- "solution_CC_rien: Il n’y a rien à faire, le changement climatique est inévitable - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(e[[54]]) <- "echelle_politique_CC: Pensez-vous que le changement climatique exige d’être pris en charge par des politiques publiques ... (Nationales; Mondiales; Européennes; Locales; À toutes les échelles)"
  label(e[[55]]) <- "pour_taxe_distance: Augmenter le prix des produits de consommation qui sont acheminés par des modes de transport polluants - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[56]]) <- "pour_renouvelables: Développer les énergies renouvelables même si, dans certains cas, les coûts de production sont plus élevés, pour le moment - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[57]]) <- "pour_densification: Densifier les villes en limitant l’habitat pavillonnaire au profit d’immeubles collectifs - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[58]]) <- "pour_voies_reservees: Favoriser l’usage (voies de circulation, place de stationnement réservées) des véhicules peu polluants ou partagés (covoiturage) - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[59]]) <- "pour_cantines_vertes: Obliger la restauration collective publique à proposer une offre de menu végétarien, biologique et/ou de saison - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[60]]) <- "pour_fin_gaspillage: Réduire le gaspillage alimentaire de moitié - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(e[[61]]) <- "France_CC: Pensez-vous que la France doit prendre de l’avance sur d’autres pays dans la lutte contre le changement climatique ? (Oui; Non; NSP)"
  label(e[[62]]) <- "obstacles_lobbies: Les lobbies - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[63]]) <- "obstacles_manque_volonte: Le manque de volonté politique - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[64]]) <- "obstacles_manque_cooperation: Le manque de coopération entre pays - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[65]]) <- "obstacles_inegalites: Les inégalités - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[66]]) <- "obstacles_incertitudes: Les incertitudes de la communauté scientifique - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[67]]) <- "obstacles_demographie: La démographie - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[68]]) <- "obstacles_technologies: Le manque de technologies alternatives - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[69]]) <- "obstacles_rien: Rien de tout cela - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(e[[70]]) <- "test_qualite: Merci de sélectionner 'Un peu' (Pas du tout/Un peu/Beaucoup/Complètement/NSP) - Q177"
  label(e[[71]]) <- "cause_CC_CCC: Pensez-vous que le changement climatique est dû à (Uniquement à des processus naturels; Uniquement à l'activité humaine; Principalement à des processus naturels; Principalement à l'activité humaine; Autant à des processus naturels qu'à l'activité humaine; Je ne pense pas qu'il y ait un changement climatique; NSP)"
  label(e[[72]]) <- "cause_CC_AT: Cause principale du changement climatique selon le répondant (N'est pas une réalité / Causes naturelles / Activité humaine / NSP) - Q1"
  label(e[[73]]) <- "effets_CC_CCC: Si le changement climatique continue, à votre avis, quelles seront les conséquences en France d'ici une cinquantaine d'années ? (Les conditions de vie deviendront extrêmement pénibles à cause des dérèglements climatiques; Il y aura des modifications de climat mais on s'y adaptera sans trop de mal; Le changement climatique aura des effets positifs pour l'agriculture et les loisirs)"
  label(e[[74]]) <- "effets_CC_AT: Le répondant pense qu'en l'absence de mesures ambitieuse, les effets du changement climatiques seraient (Insignifiants / Faibles / Graves / Désastreux / Cataclysmiques / NSP) - Q5"
  label(e[[75]]) <- "responsable_CC_chacun: Le répondant estime que chacun d'entre nous est responsabe du changement climatique - Q6"
  label(e[[76]]) <- "responsable_CC_riches: Le répondant estime que les plus riches sont responsables du changement climatique - Q6"
  label(e[[77]]) <- "responsable_CC_govts: Le répondant estime que les gouvernements sont responsables du changement climatique - Q6"
  label(e[[78]]) <- "responsable_CC_etranger: Le répondant estime que certains pays étrangers sont responsables du changement climatique - Q6"
  label(e[[79]]) <- "responsable_CC_passe: Le répondant estime que les générations passées sont responsables du changement climatique - Q6"
  label(e[[80]]) <- "responsable_CC_nature: Le répondant estime que des causes naturelles sont responsables du changement climatique - Q6"
  label(e[[81]]) <- "issue_CC: Pensez-vous que le changement climatique sera limité à un niveau acceptable d’ici la fin du siècle  (Oui, certainement; probablement; Non, probablement; certainement pas)"
  label(e[[82]]) <- "parle_CC: Fréquence à laquelle le répondant parle du changement climatique (Plusieurs fois par mois / par an / Presque jamais / NSP) - Q60"
  label(e[[83]]) <- "part_anthropique: À votre avis, quelle est la part des Français qui estiment que le changement climatique est principalement dû à l'activité humaine ? (en %) - Q61"
  label(e[[84]]) <- "efforts_relatifs: ~ Répondant prêt à faire plus d'efforts que la majorité des Français [si variante_vous==1, sinon Est-ce que la majorité est prête à faire plus d'efforts que vous] (Beaucoup/Un peu plus/Autant/Un peu/Beaucoup moins) [réponses recodées pour que leur sens soit indépendant de vairante_vous]"
  label(e[[85]]) <- "soutenu_obligation_renovation: L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(e[[86]]) <- "soutenu_normes_isolation: Des normes plus strictes sur l'isolation pour les nouveaux bâtiments - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(e[[87]]) <- "soutenu_bonus_malus: Un renforcement du bonus/malus écologique pour l’achat d’un véhicule - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(e[[88]]) <- "soutenu_limitation_110: L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(e[[89]]) <- "pour_taxe_carbone_contre: ~ Sachant qu'une majorité est contre - Favorable à une augmentation de la taxe carbone (Oui/Non/NSP) - Q64" # https://www.ademe.fr/sites/default/files/assets/documents/rapport-representations-sociales-changement-climatique-20-vague.pdf 
  label(e[[90]]) <- "pour_taxe_carbone_pour: ~ Sachant qu'une majorité est pour - Favorable à une augmentation de la taxe carbone (Oui/Non/NSP) - Q92" # https://www.ademe.fr/sites/default/files/assets/documents/rapport-analyse-representations-sociales-changement-climatique-19-vague-2018.pdf
  label(e[[91]]) <- "pour_taxe_carbone_neutre: ~ Sans information - Favorable à une augmentation de la taxe carbone (Oui/Non/NSP) - Q92"
  label(e[[92]]) <- "confiance_gens: D’une manière générale, diriez-vous que… ? (On peut faire confiance à la plupart des gens/On n’est jamais assez prudent quand on a affaire aux autres) - Q65"
  label(e[[93]]) <- "qualite_enfant_independance: l'indépendance - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[94]]) <- "qualite_enfant_tolerance: la tolérance et le respect des autres - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[95]]) <- "qualite_enfant_generosite: la générosité - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[96]]) <- "qualite_enfant_travail: l'assiduité au travail - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[97]]) <- "qualite_enfant_epargne: le sens de l'épargne - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[98]]) <- "qualite_enfant_obeissance: l'obéissance - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[99]]) <- "qualite_enfant_responsabilite: la responsabilité - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[100]]) <- "qualite_enfant_determination: la détermination et la persévérance - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[101]]) <- "qualite_enfant_expression: l'expression personnelle - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[102]]) <- "qualite_enfant_imagination: l'imagination - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[103]]) <- "qualite_enfant_foi: la foi religieuse - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(e[[104]]) <- "redistribution: Que pensez-vous de l’affirmation suivante : « Pour établir la justice sociale, il faudrait prendre aux riches pour donner aux pauvres » ? (0-10)"
  label(e[[105]]) <- "problemes_invisibilises: Avez-vous le sentiment d’être confronté·e personnellement à des difficultés importantes que les pouvoirs publics ou les médias ne voient pas vraiment ? (Très; Assez; Peu souvent; Jamais)"
  label(e[[106]]) <- "importance_environnement: La protection de l'environnement - À quel point est-ce important pour vous ? (0-10)"
  label(e[[107]]) <- "importance_associatif:  L’action sociale et associative - À quel point est-ce important pour vous ? (0-10)"
  label(e[[108]]) <- "importance_confort: L’amélioration de mon niveau de vie et de confort - À quel point est-ce important pour vous ? (0-10)"
  label(e[[109]]) <- "trop_impots: Paie-t-on trop d'impôt en France ? (Oui/Non/Ça dépend qui et quels impôts/NSP)"
  label(e[[110]]) <- "confiance_sortition: Quel est votre niveau de confiance dans la capacité de citoyens tirés au sort à délibérer de manière productive sur des questions politiques complexes ? (Pas du tout/Plutôt pas/Plutôt/Tout à fait confiance)"
  label(e[[111]]) <- "pour_sortition: Seriez-vous favorable à une réforme constitutionnelle qui introduirait une assemblée constituée de 150 citoyens tirés au sort, et qui doterait cette assemblée d'un droit de veto sur les textes de lois votés au Parlement ?"
  label(e[[112]]) <- "connait_CCC: Avez-vous entendu parler de la Convention Citoyenne pour le Climat ? (Oui, je sais très/assez bien ce que c'est/J'en ai entendu parler mais je ne sais pas très bien ce que c'est/Non, je n'en ai jamais entendu parler)"
  label(e[[113]]) <- "connaissance_CCC: Décrivez ce que vous savez de la Convention Citoyenne pour le Climat. (champ libre)"
  label(e[[114]]) <- "sait_CCC_devoilee: [Si pas Non à connait_CCC] Savez-vous si des mesures proposées par la Convention Citoyenne pour le Climat ont déjà été dévoilées ? (Oui, des mesures ont déjà été dévoilées/Je crois avoir entendu parler de mesures de la Convention mais je ne suis pas sûr·e/Aucune mesure n'a été dévoilée à ma connaissance)"
  label(e[[115]]) <- "CCC_inutile: Inutile car le gouvernement ne reprendra que les mesures qui lui plaisent - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[116]]) <- "CCC_prometteuse_climat: Une méthode prometteuse pour définir la politique climatique de la France - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[117]]) <- "CCC_espoir_institutions: Un espoir pour le renouveau des institutions - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[118]]) <- "CCC_vouee_echec: Une expérience vouée à l’échec - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[119]]) <- "CCC_operation_comm: Une opération de communication du gouvernement - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[120]]) <- "CCC_initiative_sincere: Une initiative sincère du gouvernement en faveur de la démocratie - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[121]]) <- "CCC_pour_se_defausser: Une façon pour le gouvernement de se défausser de ses responsabilités - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[122]]) <- "CCC_entendre_francais: Une opportunité pour faire entendre la voix de l’ensemble des Français - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[123]]) <- "CCC_controlee_govt: Une assemblée manipulée ou contrôlée par le gouvernement - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[124]]) <- "CCC_representative: Une assemblée représentative de la population - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[125]]) <- "CCC_autre_choix: Autre - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[126]]) <- "CCC_autre: Autre (champ libre) - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(e[[127]]) <- "CCC_devoile_fonds_mondial_info_CCC: ~ [Si pas Non à sait_CCC_devoilee] Une contribution à un fonds mondial pour le climat - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==1)"
  label(e[[128]]) <- "CCC_devoile_obligation_renovation_info_CCC: ~ [Si pas Non à sait_CCC_devoilee] L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==1)"
  label(e[[129]]) <- "CCC_devoile_taxe_viande_info_CCC: ~ [Si pas Non à sait_CCC_devoilee] Une taxe sur la viande rouge - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==1)"
  label(e[[130]]) <- "CCC_devoile_limitation_110_info_CCC: ~ [Si pas Non à sait_CCC_devoilee] L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==1)"
  label(e[[131]]) <- "first_click:" # TODO: formulation changed above (pilote osef)
  label(e[[132]]) <- "last_click:"
  label(e[[133]]) <- "duree_info_CCC: Temps passé sur la page affichant l'information sur la CCC (info_CCC==1)"
  label(e[[134]]) <- "click_count:"
  label(e[[135]]) <- "concentration_info_CCC: ~ (info_CCC==1) À votre avis, devrions-nous utiliser vos réponses ... ? (Oui, j'ai consacré toute mon attention aux questions jusqu'à présent et je pense que vous devriez utiliser mes réponses pour votre étude/Non, je n'ai pas consacré toute mon attention aux questions jusqu'à présent et je pense que vous ne devriez pas utiliser mes réponses pour votre étude)"
  label(e[[136]]) <- "first_click_:"
  label(e[[137]]) <- "last_click_:"
  label(e[[138]]) <- "duree_concentration: Temps passé sur la page affichant l'avertissement sur la concentration. (info_CCC==0)"
  label(e[[139]]) <- "click_count_:"
  label(e[[140]]) <- "concentration_no_info_CCC: ~ (info_CCC==0) À votre avis, devrions-nous utiliser vos réponses ... ? (Oui, j'ai consacré toute mon attention aux questions jusqu'à présent et je pense que vous devriez utiliser mes réponses pour votre étude/Non, je n'ai pas consacré toute mon attention aux questions jusqu'à présent et je pense que vous ne devriez pas utiliser mes réponses pour votre étude)"
  label(e[[141]]) <- "pour_obligation_renovation: ~ L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[142]]) <- "pour_limitation_110: ~ L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[143]]) <- "pour_restriction_centre_ville: ~ L'interdiction des véhicules les plus polluants dans les centre-villes - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[144]]) <- "pour_conditionner_aides: ~ Le conditionnement des aides à l'innovation versées aux entreprises à la baisse de leur bilan carbone - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[145]]) <- "pour_taxe_viande: ~ Une taxe sur la viande rouge - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[146]]) <- "pour_fonds_mondial: ~ Une contribution à un fonds mondial pour le climat - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[147]]) <- "pour_aides_train: ~ Une baisse des prix des billets de train grâce à des aides de l'État - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[148]]) <- "pour_bonus_malus: ~ Un renforcement du bonus/malus écologique pour l’achat d’un véhicule - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(e[[149]]) <- "referendum_consigne: ~ La mise en place d'un système de consigne de verre et plastique d'ici 2025 - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[150]]) <- "referendum_taxe_dividendes: ~ Une taxe de 4% sur les dividendes des entreprises versant plus de 10 millions d'euros de dividendes, pour financer la transition écologique - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[151]]) <- "referendum_interdiction_polluants: ~ L'interdiction dès 2025 de la vente des véhicules neufs les plus polluants - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[152]]) <- "referendum_interdiction_publicite: ~ L'interdiction de la publicité pour les produits les plus polluants - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[153]]) <- "referendum_cheque_bio: ~ La mise en place de chèque alimentaires pour les plus démunis à utiliser dans les AMAP ou le bio - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[154]]) <- "referendum_obligation_renovation: ~ L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(e[[155]]) <- "CCC_devoile_fonds_mondial_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] Une contribution à un fonds mondial pour le climat - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==0)"
  label(e[[156]]) <- "CCC_devoile_obligation_renovation_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==0)"
  label(e[[157]]) <- "CCC_devoile_taxe_viande_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] Une taxe sur la viande rouge -Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==0)"
  label(e[[158]]) <- "CCC_devoile_limitation_110_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==0)"
  label(e[[159]]) <- "confiance_dividende: ~ [Si question_confiance > 0] Avez-vous confiance dans le fait que l'État vous versera effectivement 110€ par an (220€ pour un couple) si une telle réforme est mise en place ? (Oui/À moitié/Non)"
  label(e[[160]]) <- "hausse_depenses_subjective: ~ À combien estimez-vous alors la hausse des dépenses de combustibles de votre ménage ? (aucune hausse : au contraire, mon ménage réduirait ses dépenses de combustibles/aucune hausse, aucune baisse/entre 1 et 30/30 et 70/70 et 120/120 et 190/à plus de 190 € par an /UC)"
  label(e[[161]]) <- "gagnant_categorie: ~ Ménage Gagnant/Non affecté/Perdant par hausse taxe carbone redistribuée à tous (+110€/an /adulte, +13/15% gaz/fioul, +0.11/13 €/L diesel/essence)"
  label(e[[162]]) <- "certitude_gagnant: ~ Degré de certitude à gagnant_categorie (Je suis/suis moyennement/ne suis pas vraiment/ne suis pas du tout sûr·e de ma réponse)"
  label(e[[163]]) <- "taxe_approbation: ~ taxe_approbation: Approbation d'une hausse de la taxe carbone compensée (+110€/an /adulte, +13/15% gaz/fioul, +0.11/13 €/L diesel/essence) (Oui/Non/NSP) ~ origine_taxe (gouvernement/CCC/inconnue) / label_taxe (CCE/taxe)"
  label(e[[164]]) <- "gagnant_feedback_categorie: ~ info si le ménage est gagnant/perdant - Ménage Gagnant/Non affecté/Perdant par hausse taxe carbone redistribuée à tous (+110€/an /adulte, +13/15% gaz/fioul, +0.11/13 €/L diesel/essence)"
  label(e[[165]]) <- "certitude_gagnant_feedback: ~ Degré de certitude à gagnant_categorie (Je suis/suis moyennement/ne suis pas vraiment/ne suis pas du tout sûr·e de ma réponse)"
  label(e[[166]]) <- "taxe_feedback_approbation: ~ info si le ménage est gagnant/perdant - Approbation d'une hausse de la taxe carbone compensée (+110€/an /adulte, +13/15% gaz/fioul, +0.11/13 €/L diesel/essence) (Oui/Non/NSP)"
  label(e[[167]]) <- "interet_politique: Le répondant est intéressé par la politique (Presque pas/Un peu/Beaucoup)"
  label(e[[168]]) <- "confiance_gouvernement: En général, faites-vous confiance au gouvernement pour prendre de bonnes décisions ? (Toujours/La plupart/La moitié du temps/Parfois/Jamais/NSP)"
  label(e[[169]]) <- "extr_gauche: Le répondant se considère comme étant d'extrême gauche"
  label(e[[170]]) <- "gauche: Le répondant se considère comme étant de gauche"
  label(e[[171]]) <- "centre: Le répondant se considère comme étant du centre"
  label(e[[172]]) <- "droite: Le répondant se considère comme étant de droite"
  label(e[[173]]) <- "extr_droite: Le répondant se considère comme étant d'extrême droite"
  label(e[[174]]) <- "conservateur: Le répondant se considère comme étant conservateur"
  label(e[[175]]) <- "liberal: Le répondant se considère comme étant libéral"
  label(e[[176]]) <- "humaniste: Le répondant se considère comme étant humaniste"
  label(e[[177]]) <- "patriote: Le répondant se considère comme étant patriote"
  label(e[[178]]) <- "apolitique: Le répondant se considère comme étant apolitique"
  label(e[[179]]) <- "ecologiste: Le répondant se considère comme étant écologiste"
  label(e[[180]]) <- "actualite: Le répondant se tient principalement informé de l'actualité via la télévision / la presse (écrite ou en ligne) / les réseaux sociaux / la radio"
  label(e[[181]]) <- "gilets_jaunes_dedans: Le répondant déclare faire partie des gilets jaunes"
  label(e[[182]]) <- "gilets_jaunes_soutien: Le répondant soutient les gilets jaunes"
  label(e[[183]]) <- "gilets_jaunes_compris: Le répondant comprend les gilets jaunes"
  label(e[[184]]) <- "gilets_jaunes_oppose: Le répondant est opposé aux gilets jaunes"
  label(e[[185]]) <- "gilets_jaunes_NSP: Le répondant ne sait pas s'il fait partie / s'il soutient / s'il comprend / s'il s'oppose aux gilets jaunes"
  label(e[[186]]) <- "champ_libre: Le sondage touche à sa fin. Vous pouvez désormais inscrire toute remarque, commentaire ou suggestion dans le champ ci-dessous."
  label(e[[187]]) <- "mail: Si vous désirez recevoir les résultats de cette enquête ou participer à la deuxième partie de cette enquête (une fois que la Convention Citoyenne pour le Climat aura rendu ses propositions), vous pouvez inscrire ci-dessous votre adresse mail. Nous ne vous enverrons que deux e-mails en tout."
  label(e[[188]]) <- "id: identifiant Bilendi"
  label(e[[189]]) <- "Q_TotalDuration:"
  label(e[[190]]) <- "exclu: Vide si tout est ok (Screened/QuotaMet sinon)"
  label(e[[191]]) <- "taille_agglo: (PERSO1) Taille d'agglomération: [1;5]=rural/-20k/20-100k/+100k/Région parisienne - embedded data"
  label(e[[192]]) <- "region: Région calculée à partir du code postal: 9 nouvelles régions de l'hexagone + autre (ARA/Est/Ouest/Centre/Nord/IDF/SO/Occ/PACA/autre)"
  label(e[[193]]) <- "gaz: Indicatrice que chauffage = 'Gaz de ville' ou 'Butane, propane, gaz en citerne'"
  label(e[[194]]) <- "fioul: Indicatrice que chauffage = 'Fioul, mazout, pétrole'"
  label(e[[195]]) <- "nb_vehicules: Nombre de véhicules motorisés dont dispose le ménage"
  label(e[[196]]) <- "hausse_depenses: Hausse des dépenses énergétiques simulées pour le ménage, suite à la taxe (élasticité de 0.4/0.2 pour carburants/chauffage)"
  label(e[[197]]) <- "simule_gagnant: Indicatrice sur la prédiction que le ménage serait gagnant avec la taxe compensée, d'après nos simulations"
  label(e[[198]]) <- "hausse_chauffage: Hausse des dépenses de chauffage simulées pour le ménage, suite à la taxe (élasticité de 0.15 au lieu de 0.2)"
  label(e[[199]]) <- "hausse_diesel: Hausse des dépenses de diesel simulées pour le ménage, suite à la taxe (élasticité de 0.4)"
  label(e[[200]]) <- "hausse_essence: Hausse des dépenses d'essence simulées pour le ménage, suite à la taxe (élasticité de 0.4)"
  label(e[[201]]) <- "avant_modifs: indicatrice la version initiale du questionnaire, avant certains changements : séparation du bloc info_ccc et concentration; débuggage de efforts_relatif (avant la seule version était variante_vous=0); affichage de la question mail" # variable valant aléatoirement 0/1 au début du sondage, 2 à partir de 22/04/22h16(FR)
  label(e[[202]]) <- "info_CCC: Indicatrice (aléatoire 0/1) que l'information sur la CCC a été affichée: La Convention Citoyenne pour le Climat est une assemblée indépendante de 150 citoyens tirés au sort qui a pour mandat de faire des propositions permettant de réduire les émissions de gaz à effet de serre françaises dans un esprit de justice sociale. Elle se réunit régulièrement depuis septembre 2019 et va bientôt rendre compte de ses propositions."
  label(e[[203]]) <- "question_confiance: Indicatrice que la question confiance_dividende a été affichée" # Variable aléatoire 0/1/2/3
  label(e[[204]]) <- "variante_efforts_vous: Indicatrice (aléatoire 0/1) que efforts_relatifs est 'vous relativement aux autres' (au contraire, si variante_efforts_vous==0, efforts_relatifs est posée: Est-ce que la majorité est prête à plus d'efforts que vous)"
  label(e[[205]]) <- "origine_taxe: Variante à l'amorce pour la taxe carbone avec dividendes. (inconnue: Imaginez ... / CCC: Imaginez que la CCC propose ... / gouvernement: Imaginez que le gouvernement propsoe ...)"
  label(e[[206]]) <- "label_taxe: Variante à la description de la taxe carbone avec dividendes. (taxe: ... une augmentation de la taxe carbone ... / CCE: une augmentation de la contribution climat-énergie)"
  
  for (i in 1:length(e)) names(e)[i] <- sub(':.*', '', label(e[[i]]))
  return(e)
}
prepare_e2 <- function(exclude_speeder=TRUE, exclude_screened=TRUE, only_finished=TRUE, only_known_agglo=T, duree_max=390, pilote = F) { # , exclude_quotas_full=TRUE
  
  if (pilote) {
    e <- read_csv("../donnees/externe2_pilote.csv")[,c(1:126,136:139,141:164,168:171,173:193,140,194:198,213:233,127:135,165:167,172,199:212)] #[-c(1:2),]
    e <- relabel_and_rename2_pilote(e)   
  } else {
    e <- read_csv("../donnees/externe2.csv")[,c(1:126,136:139,141:164,168:171,177:179,180,181,187:202,140,203:207,222:233,127:135,165:167,172:176,182:186,208:221,234:242)] #[,c(1:126,136:139,141:164,168:171,177:179,181:182,188:203,140,204:208,223:234,127:135,165:167,172:176,183:187,209:222,235:243,180)] 
    # e <- e[,c(1:158,163:165,166:167,173:176,186:233,159:162,168:172,177:185)]
    e <- relabel_and_rename2(e)  
  }
# 127:135: CCC rep / 140, 172: 28h / 165:167: referendum / 173:179: timing + gain_net_subj / 182:186: avis_estimation + timing / 208:221: 28h + députés
  
  print(paste(length(which(e$exclu=="QuotaMet")), "QuotaMet"))
  e$fini[e$exclu=="QuotaMet" | is.na(e$revenu)] <- "False" # To check the number of QuotaMet that shouldn't have incremented the quota, comment this line and: decrit(e$each_strate[e$exclu=="QuotaMet" & e$csp=="Employé" & !grepl("2019-03-04 07", e$date)])
  if (exclude_screened) { e <- e[is.na(e$exclu),] }
  if (exclude_speeder) { e <- e[as.numeric(as.vector(e$duree)) > duree_max,] } 
  # if (exclude_quotas_full) { e <- e[e[101][[1]] %in% c(1:5),]  } # remove those with a problem for the taille d'agglo
  # if (exclude_quotas_full) { e <- e[e$Q_TerminateFlag=="",]  } # remove those with a problem for the taille d'agglo
  if (only_finished) { # TODO: le faire marcher même pour les autres
    e <- e[e$fini=="True",] 
    e <- convert_e(e, vague=2) 
    
    e$weight <- weighting_e(e)
    
    e$gauche_droite_na <- as.numeric(e$gauche_droite)
    e$gauche_droite_na[e$indeterminate == T] <- wtd.mean(e$gauche_droite, weights = e$weight)
  } else {
    e$Diplome <- (e$diplome == "Brevet des collèges") + 2*(e$diplome=="CAP ou BEP") + 3*(e$diplome=="Baccalauréat") + 4*(e$diplome=="Bac +2 (BTS, DUT, DEUG, écoles de formation sanitaires et sociales...)") + 5*(e$diplome=="Bac +3 (licence...)") + 6*(e$diplome=="Bac +5 ou plus (master, école d'ingénieur ou de commerce, doctorat, médecine, maîtrise, DEA, DESS...)") - (e$diplome=="NSP (Ne se prononce pas)")
    e$diplome4 <- as.item(pmin(pmax(e$Diplome, 1), 4), labels = structure(1:4, names = c("Aucun diplôme ou brevet", "CAP ou BEP", "Baccalauréat", "Supérieur")), annotation=Label(e$diplome))  
    e <- e[, -c(9:17, 131, 132, 134, 136, 137, 139, 187)]    
  }
  
  e$sample <- "a"
  e$sample[e$fini=="True"] <- "e"
  e$sample[e$fini=="True" & n(e$duree) > duree_max] <- "p"
  e$sample[e$fini=="True" & n(e$duree) > duree_max & e$test_qualite=='Un peu'] <- "f" # "q"? excluded because out of quotas
  e$sample[e$fini=="True" & n(e$duree) > duree_max & e$exclu==""] <- "r"
  
  return(e)
}

# e2_pilote <- prepare_e2(pilote = T)
e1 <- prepare_e()
e2 <- prepare_e2()
# e1 <- e
# e <- e2

# e1a <- prepare_e(only_finished = F) # 40 ont abandonné avant la fin
# e2a <- prepare_e2(only_finished = F) # 49 ont abandonné avant la fin

e2$vague <- 2
e1$vague <- 1
eb <- rbind.fill(e1, e2)
for (i in names(eb)) { 
  if (i %in% names(e1)) label(eb[[i]]) <- label(e1[[i]])
  if (i %in% names(e2)) label(eb[[i]]) <- label(e2[[i]]) }

# export_stats_desc(e, paste(getwd(), 'externe_stats_desc.csv', sep='/'))

b <- readRDS("../donnees/beliefs_climate_policies.Rda") # données Adrien-Thomas 2019
c <- readRDS("../donnees/CCC.Rda") # données CCC 
objective_gains_inelastic <- readRDS("../donnees/objective_gains_inelastic.Rda") # données gain 

ccc <- read.dta13("../donnees/all_benedicte.dta")
ccc$appartenance_france <- grepl("France", ccc$s2_e_q10)
ccc$appartenance_monde <- grepl("monde", ccc$s2_e_q10)
ccc$appartenance_Europe <- grepl("Europe", ccc$s2_e_q10)
ccc$appartenance_commune <- grepl("commune", ccc$s2_e_q10)
ccc$appartenance_region <- grepl("region", ccc$s2_e_q10)
ccc$appartenance_departement <- grepl("departement", ccc$s2_e_q10)
ccc$appartenance_nr <- grepl("nr", ccc$s2_e_q10)
decrit(ccc$appartenance_france)
decrit(ccc$appartenance_monde)
decrit(ccc$appartenance_Europe)
decrit(ccc$appartenance_commune)
decrit(ccc$appartenance_region)
decrit(ccc$appartenance_departement)
decrit(ccc$appartenance_nr)

# write.csv2(e, "survey_prepared.csv", row.names=FALSE)

# Pooling variables
# variables_approbation <- c("taxe_approbation", "taxe_info_approbation", "taxe_cible_approbation") # "taxe_feedback_approbation", "taxe_progressif_approbation", 
# variables_qualite <- c("duree", "duree_info", "duree_champ_libre") # champ_libre != "", exclu, "test_qualite"
# variables_demo <- c("sexe", "age", "statut_emploi", "csp", "region", "diplome4", "taille_menage", "revenu", "rev_tot", "nb_14_et_plus", "nb_adultes", 
#                     "fume", "actualite", "taille_agglo", "uc", "niveau_vie", "age_18_24", "age_25_34", "age_35_49", "age_50_64", "age_65_plus") # weight, age_x_y, diplome
# variables_energie <- c("surface", "Mode_chauffage", "Chauffage", "km", "conso", "diesel", "essence", "nb_vehicules", "gaz", "fioul", # hausse_carburants "versement_cible", 
#                        "hausse_chauffage", "hausse_diesel", "hausse_essence", "hausse_depenses", "simule_gain") #, 
# variables_politiques <- c("interet_politique", "conservateur", "liberal", "humaniste", "patriote", "apolitique", "ecologiste", "Gauche_droite")
# variables_gilets_jaunes <- c("gilets_jaunes_dedans", "gilets_jaunes_soutien", "gilets_jaunes_compris", "gilets_jaunes_oppose", "gilets_jaunes_NSP") # , "gilets_jaunes"
# variables_politiques_environnementales <- c("taxe_kerosene", "taxe_viande", "normes_isolation", "normes_vehicules", "controle_technique", "interdiction_polluants", 
#                                             "peages_urbains", "fonds_mondial") # "rattrapage_diesel"
# variables_connaissances_CC <- c("Cause_CC", "ges_CO2", "ges_CH4", "ges_O2", "ges_pm", "ges_boeuf", "ges_nucleaire", "ges_avion", "region_CC", 
#                                 "emission_cible", "score_ges", "score_climate_call")
# variables_avis_CC <- c("parle_CC", "effets_CC", "generation_CC_1960", "generation_CC_1990", "generation_CC_2020", "generation_CC_2050", "generation_CC_aucune",
#                        "responsable_CC_chacun", "responsable_CC_riches", "responsable_CC_govts", "responsable_CC_etranger", "responsable_CC_passe", 
#                        "responsable_CC_nature", "enfant_CC", "enfant_CC_pour_lui", "enfant_CC_pour_CC", "generation_CC_min", "generation_CC_max") 
# variables_comportement_CC <- c("mode_vie_ecolo", "changer_si_politiques", "changer_si_moyens", "changer_si_tous", "changer_non_riches", "changer_non_interet", "changer_non_negation", "changer_deja_fait", "changer_essaie")
# variables_toutes <- c(variables_approbation, variables_qualite, variables_aleatoires, variables_demo, variables_energie, "simule_gagnant", 
#                       "simule_gain", variables_politiques, variables_gilets_jaunes, "gilets_jaunes", variables_connaissances_CC, variables_avis_CC, variables_comportement_CC)
