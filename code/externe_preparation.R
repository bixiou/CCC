# setwd("/var/www/beliefs_climate_policies/code")

source("packages_functions.R")

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
# sum(communes$Population[is.na(communes$taille_agglo)], na.rm=T) # 750k missing because of Code.INSEE renaming
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
#   s <- vector("numeric", length=5)
#   for (i in 1:9) s[i] <- q(i/10)
#   # s[1] <- q(0.1, weights = weights)
#   # s[2] <- q(0.2, weights = weights)
#   # s[3] <- q(0.3, weights = weights)
#   # s[4] <- q(0.4, weights = weights)
#   # s[5] <- q(0.5, weights = weights)
#   # s[6] <- q(0.6, weights = weights)
#   # s[7] <- q(0.7, weights = weights)
#   # s[8] <- q(0.8, weights = weights)
#   # s[9] <- q(0.9, weights = weights)
#   return(round(s,0))
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
# # plot(distribution_revenu_erfs$x, distribution_revenu_erfs$ecdf, type='l', xlim=c(0,60000), col="blue")
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
# # decrit(s$cible) # incredibly close!
# # shares <- c('_20' = share__20, '20_30'=share_20_30, '30_40'=share_30_40, '40_50'=share_40_50, '50_70'=share_50_70, '70_'=share_70_)
# # decrit(s$categorie_cible)
# wtd.mean(db$nb_adultes, db$wprm) # 2.033
# # wtd.mean(s$nb_adultes, s$weight) # 1.933
# 
# rm(db, temp, irft4, menage, indiv)
# setwd(wd)


##### Preparation #####

relabel_and_rename <- function(s) {
  # Notation: ~ means that it's a random variant; * means that another question is exactly the same (in another random branch)
  
  # The commented lines below should be executed before creating relabel_and_rename, to ease the filling of each name and label
  # for (i in 1:length(s)) {
  #   label(s[[i]]) <- paste(names(s)[i], ": ", label(s[[i]]), s[[i]][1], sep="");
  #   print(paste(i, label(s[[i]])))
  # }
  
  label(s[[1]]) <- "date:"
  label(s[[2]]) <- "date_fin:"
  label(s[[3]]) <- "statut_reponse:"
  label(s[[4]]) <- "ip:"
  label(s[[5]]) <- "progres:"
  label(s[[6]]) <- "duree:"
  label(s[[7]]) <- "fini:"
  label(s[[8]]) <- "date_enregistree:"
  label(s[[9]]) <- "ID_qualtrics:"
  label(s[[10]]) <- "nom:"
  label(s[[11]]) <- "prenom:"
  label(s[[12]]) <- "mmail:"
  label(s[[13]]) <- "ref:"
  label(s[[14]]) <- "lat:"
  label(s[[15]]) <- "long:"
  label(s[[16]]) <- "distr:"
  label(s[[17]]) <- "lang:"
  label(s[[18]]) <- "code_postal: Code Postal - Q93"
  label(s[[19]]) <- "sexe: Sexe (Masculin/Féminin) - Q96"
  label(s[[20]]) <- "age: Tranche d'âge (18-24/25-34/35-49/50-64/65+) - Q184"
  label(s[[21]]) <- "statut_emploi: Statut d'emploi (Chômage/CDD/CDI/fonctionnaire/étudiant-e/retraité-e/précaire/autre actif/autre inactif) - Q35"
  label(s[[22]]) <- "csp: Catégorie Socio-Professionnelle: Agriculteur/Indépendant: Artisan, commerçant.e/Cadre: Profession libérale, cadre/Intermédiaire: Profession intermédiaire/Employé/Ouvrier/Retraité/Inactif: Autres inactif/ve - Q98"
  label(s[[23]]) <- "diplome: Diplôme le plus haut obtenu ou prévu: Aucun/Brevet/CAP/Bac/+2/+3/>+4) - Q102"
  label(s[[24]]) <- "taille_menage: Taille du ménage #(vous, membres de votre famille vivant avec vous et personnes à votre charge) - Q29"
  label(s[[25]]) <- "revenu: Revenu mensuel net du répondant - Q148"
  label(s[[26]]) <- "rev_tot: Revenu mensuel net du ménage - Q25"
  label(s[[27]]) <- "nb_14_et_plus: Nombre de personnes âgées d'au moins 14 ans dans le ménage - Q31"
  label(s[[28]]) <- "nb_adultes: Nombre de personnes majeures dans le ménage - Q149"
  label(s[[29]]) <- "locataire: Locataire - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(s[[30]]) <- "proprio_occupant: Propriétaire occupant - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(s[[31]]) <- "proprio_bailleur: Propriétaire bailleur - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(s[[32]]) <- "heberge_gratis: Hébergé gratuitement - Êtes-vous propriétaire ou locataire ? (Locataire/Propriétaire occupant/bailleur/Hébergé gratuitement) - Q127"
  label(s[[33]]) <- "patrimoine: Patrimoine net du ménage (ou de la personne si elle vit chez ses parents) (<10/10-60/60-180/180-350/350-550/>550k€/NSP) - Q129" # les quintiles + dernier décile 2018 https://www.insee.fr/fr/statistiques/2388851
  label(s[[34]]) <- "surface: Surface du logement (en m²) - Q175"
  label(s[[35]]) <- "chauffage: source d'énergie principale (Électricité/Gaz de ville/Butane, propane, gaz en citerne/Fioul, mazout, pétrole/Bois, solaire, géothermie, aérothermie (pompe à chaleur)/Autre/NSP)"
  label(s[[36]]) <- "transports_travail: Le répondant utilise principalement (la voiture/les TC/la marche ou le vélo/un deux roues motorisé/le covoiturage/non conerné) pour ses trajets domiciles-travail (ou études) - Q39"
  label(s[[37]]) <- "transports_courses: Le répondant utilise principalement (la voiture/les TC/la marche ou le vélo/un deux roues motorisé/le covoiturage/non conerné) pour faire ses courses - Q39"
  label(s[[38]]) <- "transports_loisirs: Le répondant utilise principalement (la voiture/les TC/la marche ou le vélo/un deux roues motorisé/le covoiturage/non conerné) pour ses loisirs (hors vacances) - Q39"
  label(s[[39]]) <- "nb_vehicules_texte: Nombre de véhicules motorisés dont dispose le ménage - Q37"
  label(s[[40]]) <- "km_0: (nb_vehicules=0) Nombre de kilomètres parcourus en voiture ou moto par le répondant lors des 12 derniers mois - Q142"
  label(s[[41]]) <- "fuel_1: (nb_vehicules=1) Carburant du véhicule (Essence/Diesel/Électrique ou hybride/Autre) - Q77"
  label(s[[42]]) <- "conso_1_choix: (nb_vehicules=1) Consommation moyenne du véhicule (L par 100km / NSP) - Q174"
  label(s[[43]]) <- "conso_1: (nb_vehicules=1) Consommation moyenne du véhicule (en litres aux 100 km) - Q174"
  label(s[[44]]) <- "km_1: (nb_vehicules=1) Nombre de kilomètres parcourus par le véhicule lors des 12 derniers mois - Q38"
  label(s[[45]]) <- "fuel_2_1: (nb_vehicules=2) Carburant du véhicule principal (Essence/Diesel/Électrique ou hybride/Autre) - Q100"
  label(s[[46]]) <- "fuel_2_2: (nb_vehicules=2) Carburant du deuxième véhicule (Essence/Diesel/Électrique ou hybride/Autre) - Q101"
  label(s[[47]]) <- "conso_2_choix: (nb_vehicules=2) Consommation moyenne des véhicules du ménage (L par 100km / NSP) - Q176"
  label(s[[48]]) <- "conso_2: (nb_vehicules=2) Consommation moyenne des véhicules du ménage (en litres aux 100 km) - Q176"
  label(s[[49]]) <- "km_2: (nb_vehicules=2) Nombre de kilomètres parcourus par l'ensemble des véhicules lors des 12 derniers mois - Q141"
  label(s[[50]]) <- "solution_CC_progres: Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(s[[51]]) <- "solution_CC_changer: Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(s[[52]]) <- "solution_CC_traite: C’est aux États de réglementer, au niveau mondial, le changement climatique - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(s[[53]]) <- "solution_CC_rien: Il n’y a rien à faire, le changement climatique est inévitable - De ces quatre opinions, laquelle se rapproche le plus de la vôtre (Le progrès technique permettra de trouver des solutions pour empêcher le changement climatique; Il faudra modifier de façon importante nos modes de vie pour empêcher le changement climatique; C’est aux États de réglementer, au niveau mondial, le changement climatique; Il n’y a rien à faire, le changement climatique est inévitable) - Q50"
  label(s[[54]]) <- "echelle_politique_CC: Pensez-vous que le changement climatique exige d’être pris en charge par des politiques publiques ... (Nationales; Mondiales; Européennes; Locales; À toutes les échelles)"
  label(s[[55]]) <- "pour_taxe_distance: Augmenter le prix des produits de consommation qui sont acheminés par des modes de transport polluants - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(s[[56]]) <- "pour_renouvelables: Développer les énergies renouvelables même si, dans certains cas, les coûts de production sont plus élevés, pour le moment - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(s[[57]]) <- "pour_densification: Densifier les villes en limitant l’habitat pavillonnaire au profit d’immeubles collectifs - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(s[[58]]) <- "pour_voies_reservees: Favoriser l’usage (voies de circulation, place de stationnement réservées) des véhicules peu polluants ou partagés (covoiturage) - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(s[[59]]) <- "pour_cantines_vertes: Obliger la restauration collective publique à proposer une offre de menu végétarien, biologique et/ou de saiso - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(s[[60]]) <- "pour_fin_gaspillage: Réduire le gaspillage alimentaire de moitié - Pour limiter les émissions de GES, est-il souhaitable de ... (Très; Assez; Pas vraiment; Pas du tout souhaitable)"
  label(s[[61]]) <- "France_CC: Pensez-vous que la France doit prendre de l’avance sur d’autres pays dans la lutte contre le changement climatique ? (Oui; Non; NSP)"
  label(s[[62]]) <- "obstacles_lobbies: Les lobbies - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(s[[63]]) <- "obstacles_manque_volonte: Le manque de volonté politique - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(s[[64]]) <- "obstacles_manque_cooperation: Le manque de coopération entre pays - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(s[[65]]) <- "obstacles_inegalites: Les inégalités - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(s[[66]]) <- "obstacles_incertitudes: Les incertitudes de la communauté scientifique - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(s[[67]]) <- "obstacles_demographie: La démographie - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(s[[68]]) <- "obstacles_technologies: Le manque de technologies alternatives - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(s[[69]]) <- "obstacles_rien: Rien de tout cela - Classer les obstacles à la lutte contre le CC suivants (1: le plus - 7: le moins important)"
  label(s[[70]]) <- "test_qualite: Merci de sélectionner 'Un peu' (Pas du tout/Un peu/Beaucoup/Complètement/NSP) - Q177"
  label(s[[71]]) <- "cause_CC_CCC: Pensez-vous que le changement climatique est dû à (Uniquement à des processus naturels; Uniquement à l'activité humaine; Principalement à des processus naturels; Principalement à l'activité humaine; Autant à des processus naturels qu'à l'activité humaine; Je ne pense pas qu'il y ait un changement climatique; NSP)"
  label(s[[72]]) <- "cause_CC_AT: Cause principale du changement climatique selon le répondant (N'est pas une réalité / Causes naturelles / Activité humaine / NSP) - Q1"
  label(s[[73]]) <- "effets_CC_CCC: Si le changement climatique continue, à votre avis, quelles seront les conséquences en France d'ici une cinquantaine d'années ? (Les conditions de vie deviendront extrêmement pénibles à cause des dérèglements climatiques; Il y aura des modifications de climat mais on s'y adaptera sans trop de mal; Le changement climatique aura des effets positifs pour l'agriculture et les loisirs)"
  label(s[[74]]) <- "effets_CC_AT: Le répondant pense qu'en l'absence de mesures ambitieuse, les effets du changement climatiques seraient (Insignifiants / Faibles / Graves / Désastreux / Cataclysmiques / NSP) - Q5"
  label(s[[75]]) <- "responsable_CC_chacun: Le répondant estime que chacun d'entre nous est responsabe du changement climatique - Q6"
  label(s[[76]]) <- "responsable_CC_riches: Le répondant estime que les plus riches sont responsables du changement climatique - Q6"
  label(s[[77]]) <- "responsable_CC_govts: Le répondant estime que les gouvernements sont responsables du changement climatique - Q6"
  label(s[[78]]) <- "responsable_CC_etranger: Le répondant estime que certains pays étrangers sont responsables du changement climatique - Q6"
  label(s[[79]]) <- "responsable_CC_passe: Le répondant estime que les générations passées sont responsables du changement climatique - Q6"
  label(s[[80]]) <- "responsable_CC_nature: Le répondant estime que des causes naturelles sont responsables du changement climatique - Q6"
  label(s[[81]]) <- "issue_CC: Pensez-vous que le changement climatique sera limité à un niveau acceptable d’ici la fin du siècle  (Oui, certainement; probablement; Non, probablement; certainement pas)"
  label(s[[82]]) <- "parle_CC: Fréquence à laquelle le répondant parle du changement climatique (Plusieurs fois par mois / par an / Presque jamais / NSP) - Q60"
  label(s[[83]]) <- "part_anthropique: À votre avis, quelle est la part des Français qui estiment que le changement climatique est principalement dû à l'activité humaine ? (en %) - Q61"
  label(s[[84]]) <- "efforts_relatifs: ~ Répondant prêt à faire plus d'efforts que la majorité des Français [si variante_vous==1, sinon Est-ce que la majorité est prête à faire plus d'efforts que vous] (Beaucoup/Un peu plus/Autant/Un peu/Beaucoup moins) [réponses recodées pour que leur sens soit indépendant de vairante_vous]"
  label(s[[85]]) <- "soutenu_obligation_renovation: L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(s[[86]]) <- "soutenu_normes_isolation: Des normes plus strictes sur l'isolation pour les nouveaux bâtiments - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(s[[87]]) <- "soutenu_bonus_malus: Un renforcement du bonus/malus écologique pour l’achat d’un véhicule - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(s[[88]]) <- "soutenu_limitation_110: L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - Politiques soutenues par une majorité de Français ? (obligation_renovation/normes_isolation/bonus_malus/limitation_110) - Q63"
  label(s[[89]]) <- "pour_taxe_carbone_contre: ~ Sachant qu'une majorité est contre - Favorable à une augmentation de la taxe carbone (Oui/Non/NSP) - Q64" # https://www.ademe.fr/sites/default/files/assets/documents/rapport-representations-sociales-changement-climatique-20-vague.pdf 
  label(s[[90]]) <- "pour_taxe_carbone_pour: ~ Sachant qu'une majorité est pour - Favorable à une augmentation de la taxe carbone (Oui/Non/NSP) - Q92" # https://www.ademe.fr/sites/default/files/assets/documents/rapport-analyse-representations-sociales-changement-climatique-19-vague-2018.pdf
  label(s[[91]]) <- "pour_taxe_carbone_neutre: ~ Sans information - Favorable à une augmentation de la taxe carbone (Oui/Non/NSP) - Q92"
  label(s[[92]]) <- "confiance_gens: D’une manière générale, diriez-vous que… ? (On peut faire confiance à la plupart des gens/On n’est jamais assez prudent quand on a affaire aux autres) - Q65"
  label(s[[93]]) <- "qualite_enfant_independance: l'indépendance - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(s[[94]]) <- "qualite_enfant_tolerance: la tolérance et le respect des autres - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(s[[95]]) <- "qualite_enfant_generosite: la générosité - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(s[[96]]) <- "qualite_enfant_travail: l'assiduité au travail - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(s[[97]]) <- "qualite_enfant_epargne: le sens de l'épargne - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(s[[98]]) <- "qualite_enfant_obeissance: l'obéissance - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(s[[99]]) <- "qualite_enfant_responsabilite: la responsabilité - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(s[[100]]) <- "qualite_enfant_determination: la détermination et la persévérance - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(s[[101]]) <- "qualite_enfant_expression: l'expression personnelle - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(s[[102]]) <- "qualite_enfant_imagination: l'imagination - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(s[[103]]) <- "qualite_enfant_foi: la foi religieuse - Quelles sont les qualités les plus importantes chez les enfants ? (indépendance; tolérance; générosité; travail; épargne; obéissance; responsabilité; détermination; expression; imagination; foi)"
  label(s[[104]]) <- "redistribution: Que pensez-vous de l’affirmation suivante : « Pour établir la justice sociale, il faudrait prendre aux riches pour donner aux pauvres » ? (0-10)"
  label(s[[105]]) <- "problemes_invisibilises: Avez-vous le sentiment d’être confronté·e personnellement à des difficultés importantes que les pouvoirs publics ou les médias ne voient pas vraiment ? (Très; Assez; Peu souvent; Jamais)"
  label(s[[106]]) <- "importance_environnement: La protection de l'environnement - À quel point est-ce important pour vous ? (0-10)"
  label(s[[107]]) <- "importance_associatif:  L’action sociale et associative - À quel point est-ce important pour vous ? (0-10)"
  label(s[[108]]) <- "importance_confort: L’amélioration de mon niveau de vie et de confort - À quel point est-ce important pour vous ? (0-10)"
  label(s[[109]]) <- "trop_impots: Paie-t-on trop d'impôt en France ? (Oui/Non/Ça dépend qui et quels impôts/NSP)"
  label(s[[110]]) <- "confiance_sortition: Quel est votre niveau de confiance dans la capacité de citoyens tirés au sort à délibérer de manière productive sur des questions politiques complexes ? (Pas du tout/Plutôt pas/Plutôt/Tout à fait confiance)"
  label(s[[111]]) <- "pour_sortition: Seriez-vous favorable à une réforme constitutionnelle qui introduirait une assemblée constituée de 150 citoyens tirés au sort, et qui doterait cette assemblée d'un droit de veto sur les textes de lois votés au Parlement ?"
  label(s[[112]]) <- "connait_CCC: Avez-vous entendu parler de la Convention Citoyenne pour le Climat ? (Oui, je sais très/assez bien ce que c'est/J'en ai entendu parler mais je ne sais pas très bien ce que c'est/Non, je n'en ai jamais entendu parler)"
  label(s[[113]]) <- "connaissance_CCC: Décrivez ce que vous savez de la Convention Citoyenne pour le Climat. (champ libre)"
  label(s[[114]]) <- "sait_CCC_devoilee: [Si pas Non à connait_CCC] Savez-vous si des mesures proposées par la Convention Citoyenne pour le Climat ont déjà été dévoilées ? (Oui, des mesures ont déjà été dévoilées/Je crois avoir entendu parler de mesures de la Convention mais je ne suis pas sûr·e/Aucune mesure n'a été dévoilée à ma connaissance)"
  label(s[[115]]) <- "CCC_inutile: Inutile car le gouvernement ne reprendra que les mesures qui lui plaisent - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(s[[116]]) <- "CCC_prometteuse_climat: Une méthode prometteuse pour définir la politique climatique de la France - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(s[[117]]) <- "CCC_espoir_institutions: Un espoir pour le renouveau des institutions - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(s[[118]]) <- "CCC_vouee_echec: Une expérience vouée à l’échec - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(s[[119]]) <- "CCC_operation_comm: Une opération de communication du gouvernement - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(s[[120]]) <- "CCC_initiative_sincere: Une initiative sincère du gouvernement en faveur de la démocratie - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(s[[121]]) <- "CCC_pour_se_defausser: Une façon pour le gouvernement de se défausser de ses responsabilités - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(s[[122]]) <- "CCC_entendre_francais: Une opportunité pour faire entendre la voix de l’ensemble des Français - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(s[[123]]) <- "CCC_controlee_govt: Une assemblée manipulée ou contrôlée par le gouvernement - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(s[[124]]) <- "CCC_representative: Une assemblée représentative de la population - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(s[[125]]) <- "CCC_autre_choix: Autre - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(s[[126]]) <- "CCC_autre: Autre (champ libre) - Pensez-vous que la Convention Citoyenne pour le Climat est … (inutile/prometteuse_climat/espoir_institutions/vouee_echec/operation_comm/initiative_sincere/pour_se_defausser_entendre_francais/controlee_govt/representative)"
  label(s[[127]]) <- "CCC_devoile_fonds_mondial_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] Une contribution à un fonds mondial pour le climat - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==1)"
  label(s[[128]]) <- "CCC_devoile_obligation_renovation_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==1)"
  label(s[[129]]) <- "CCC_devoile_taxe_viande_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] Une taxe sur la viande rouge -Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==1)"
  label(s[[130]]) <- "CCC_devoile_limitation_110_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==1)"
  label(s[[131]]) <- "first_click:"
  label(s[[132]]) <- "last_click:"
  label(s[[133]]) <- "duree_info_CCC: Temps passé sur la page affichant l'information sur la CCC (info_CCC==1)"
  label(s[[134]]) <- "click_count:"
  label(s[[135]]) <- "concentration_info_CCC: ~ (info_CCC==1) À votre avis, devrions-nous utiliser vos réponses ... ? (Oui, j'ai consacré toute mon attention aux questions jusqu'à présent et je pense que vous devriez utiliser mes réponses pour votre étude/Non, je n'ai pas consacré toute mon attention aux questions jusqu'à présent et je pense que vous ne devriez pas utiliser mes réponses pour votre étude)"
  label(s[[136]]) <- "first_click_:"
  label(s[[137]]) <- "last_click_:"
  label(s[[138]]) <- "duree_concentration: Temps passé sur la page affichant l'avertissement sur la concentration. (info_CCC==0)"
  label(s[[139]]) <- "click_count_:"
  label(s[[140]]) <- "concentration_no_info_CCC: ~ (info_CCC==0) À votre avis, devrions-nous utiliser vos réponses ... ? (Oui, j'ai consacré toute mon attention aux questions jusqu'à présent et je pense que vous devriez utiliser mes réponses pour votre étude/Non, je n'ai pas consacré toute mon attention aux questions jusqu'à présent et je pense que vous ne devriez pas utiliser mes réponses pour votre étude)"
  label(s[[141]]) <- "pour_obligation_renovation: ~ L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(s[[142]]) <- "pour_limitation_110: ~ L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(s[[143]]) <- "pour_restriction_centre_ville: ~ L'interdiction des véhicules les plus polluants dans les centre-villes - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(s[[144]]) <- "pour_conditionner_aides: ~ Le conditionnement des aides à l'innovation versées aux entreprises à la baisse de leur bilan carbone - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(s[[145]]) <- "pour_taxe_viande: ~ Une taxe sur la viande rouge - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(s[[146]]) <- "pour_fonds_mondial: ~ Une contribution à un fonds mondial pour le climat - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(s[[147]]) <- "pour_aides_train: ~ Une baisse des prix des billets de train grâce à des aides de l'État - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(s[[148]]) <- "pour_bonus_malus: ~ Un renforcement du bonus/malus écologique pour l’achat d’un véhicule - [La CCC va proposer plusieurs mesures ~ affiché ssi info_CCC==1] Seriez-vous favorables ... ? (Oui, tout à fait/plutôt/Indifférent·e ou ne sais pas/Non, pas vraiment/Non, pas du tout)"
  label(s[[149]]) <- "referendum_consigne: ~ La mise en place d'un système de consigne de verre et plastique d'ici 2025 - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(s[[150]]) <- "referendum_taxe_dividendes: ~ Une taxe de 4% sur les dividendes des entreprises versant plus de 10 millions d'euros de dividendes, pour financer la transition écologique - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(s[[151]]) <- "referendum_interdiction_polluants: ~ L'interdiction dès 2025 de la vente des véhicules neufs les plus polluants - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(s[[152]]) <- "referendum_interdiction_publicite: ~ L'interdiction de la publicité pour les produits les plus polluants - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(s[[153]]) <- "referendum_cheque_bio: ~ La mise en place de chèque alimentaires pour les plus démunis à utiliser dans les AMAP ou le bio - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(s[[154]]) <- "referendum_obligation_renovation: ~ L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - [Les membres de la CCC vont sélectionner lesquelles de ces mesures seront soumises à référendum ~ affiché ssi info_CCC==1] S'il y avait un référendum, que voteriez-vous ... ? (Oui/Non/Abstention, blanc ou nul/NSP)"
  label(s[[155]]) <- "CCC_devoile_fonds_mondial_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] Une contribution à un fonds mondial pour le climat - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==0)"
  label(s[[156]]) <- "CCC_devoile_obligation_renovation_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] L'obligation de rénovation thermique des logements les moins bien isolés assortie d'aides de l'État - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==0)"
  label(s[[157]]) <- "CCC_devoile_taxe_viande_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] Une taxe sur la viande rouge -Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==0)"
  label(s[[158]]) <- "CCC_devoile_limitation_110_no_info_CCC: ~ [Si pas Aucun à sait_CCC_devoilee] L'abaissement de la limitation de vitesse sur les autoroutes à 110 km/h - Le répondant pense que cette mesure de la CCC a été dévoilée (info_CCC==0)"
  label(s[[159]]) <- "confiance_dividende: ~ [Si question_confiance > 0] Avez-vous confiance dans le fait que l'État vous versera effectivement 110€ par an (220€ pour un couple) si une telle réforme est mise en place ? (Oui/À moitié/Non)"
  label(s[[160]]) <- "hausse_depenses_subjective: ~ À combien estimez-vous alors la hausse des dépenses de combustibles de votre ménage ? (aucune hausse : au contraire, mon ménage réduirait ses dépenses de combustibles/aucune hausse, aucune baisse/entre 1 et 30/30 et 70/70 et 120/120 et 190/à plus de 190 € par an /UC)"
  label(s[[161]]) <- "gagnant_categorie: ~ Ménage Gagnant/Non affecté/Perdant par hausse taxe carbone redistribuée à tous (+110€/an /adulte, +13/15% gaz/fioul, +0.11/13 €/L diesel/essence)"
  label(s[[162]]) <- "certitude_gagnant: ~ Degré de certitude à gagnant_categorie (Je suis/suis moyennement/ne suis pas vraiment/ne suis pas du tout sûr·e de ma réponse)"
  label(s[[163]]) <- "taxe_approbation: ~ taxe_approbation: Approbation d'une hausse de la taxe carbone compensée (+110€/an /adulte, +13/15% gaz/fioul, +0.11/13 €/L diesel/essence) (Oui/Non/NSP) ~ origine_taxe (gouvernement/CCC/inconnue) / label_taxe (CCE/taxe)"
  label(s[[164]]) <- "gagnant_feedback_categorie: ~ info si le ménage est gagnant/perdant - Ménage Gagnant/Non affecté/Perdant par hausse taxe carbone redistribuée à tous (+110€/an /adulte, +13/15% gaz/fioul, +0.11/13 €/L diesel/essence)"
  label(s[[165]]) <- "certitude_gagnant_feedback: ~ Degré de certitude à gagnant_categorie (Je suis/suis moyennement/ne suis pas vraiment/ne suis pas du tout sûr·e de ma réponse)"
  label(s[[166]]) <- "taxe_feedback_approbation: ~ info si le ménage est gagnant/perdant - Approbation d'une hausse de la taxe carbone compensée (+110€/an /adulte, +13/15% gaz/fioul, +0.11/13 €/L diesel/essence) (Oui/Non/NSP)"
  label(s[[167]]) <- "interet_politique: Le répondant est intéressé par la politique (Presque pas/Un peu/Beaucoup)"
  label(s[[168]]) <- "confiance_gouvernement: En général, faites-vous confiance au gouvernement pour prendre de bonnes décisions ? (Toujours/La plupart/La moitié du temps/Parfois/Jamais/NSP)"
  label(s[[169]]) <- "extr_gauche: Le répondant se considère comme étant d'extrême gauche"
  label(s[[170]]) <- "gauche: Le répondant se considère comme étant de gauche"
  label(s[[171]]) <- "centre: Le répondant se considère comme étant du centre"
  label(s[[172]]) <- "droite: Le répondant se considère comme étant de droite"
  label(s[[173]]) <- "extr_droite: Le répondant se considère comme étant d'extrême droite"
  label(s[[174]]) <- "conservateur: Le répondant se considère comme étant conservateur"
  label(s[[175]]) <- "liberal: Le répondant se considère comme étant libéral"
  label(s[[176]]) <- "humaniste: Le répondant se considère comme étant humaniste"
  label(s[[177]]) <- "patriote: Le répondant se considère comme étant patriote"
  label(s[[178]]) <- "apolitique: Le répondant se considère comme étant apolitique"
  label(s[[179]]) <- "ecologiste: Le répondant se considère comme étant écologiste"
  label(s[[180]]) <- "actualite: Le répondant se tient principalement informé de l'actualité via la télévision / la presse (écrite ou en ligne) / les réseaux sociaux / la radio"
  label(s[[181]]) <- "gilets_jaunes_dedans: Le répondant déclare faire partie des gilets jaunes"
  label(s[[182]]) <- "gilets_jaunes_soutien: Le répondant soutient les gilets jaunes"
  label(s[[183]]) <- "gilets_jaunes_compris: Le répondant comprend les gilets jaunes"
  label(s[[184]]) <- "gilets_jaunes_oppose: Le répondant est opposé aux gilets jaunes"
  label(s[[185]]) <- "gilets_jaunes_NSP: Le répondant ne sait pas s'il fait partie / s'il soutient / s'il comprend / s'il s'oppose aux gilets jaunes"
  label(s[[186]]) <- "champ_libre: Le sondage touche à sa fin. Vous pouvez désormais inscrire toute remarque, commentaire ou suggestion dans le champ ci-dessous."
  label(s[[187]]) <- "mail: Si vous désirez recevoir les résultats de cette enquête ou participer à la deuxième partie de cette enquête (une fois que la Convention Citoyenne pour le Climat aura rendu ses propositions), vous pouvez inscrire ci-dessous votre adresse mail. Nous ne vous enverrons que deux e-mails en tout."
  label(s[[188]]) <- "ID: identifiant Bilendi"
  label(s[[189]]) <- "Q_TotalDuration:"
  label(s[[190]]) <- "exclu: Vide si tout est ok (Screened/QuotaMet sinon)"
  label(s[[191]]) <- "taille_agglo: (PERSO1) Taille d'agglomération: [1;5]=rural/-20k/20-100k/+100k/Région parisienne - embedded data"
  label(s[[192]]) <- "region: Région calculée à partir du code postal: 9 nouvelles régions de l'hexagone + autre (ARA/Est/Ouest/Centre/Nord/IDF/SO/Occ/PACA/autre)"
  label(s[[193]]) <- "gaz: Indicatrice que chauffage = 'Gaz de ville' ou 'Butane, propane, gaz en citerne'"
  label(s[[194]]) <- "fioul: Indicatrice que chauffage = 'Fioul, mazout, pétrole'"
  label(s[[195]]) <- "nb_vehicules: Nombre de véhicules motorisés dont dispose le ménage"
  label(s[[196]]) <- "hausse_depenses: Hausse des dépenses énergétiques simulées pour le ménage, suite à la taxe (élasticité de 0.4/0.2 pour carburants/chauffage)"
  label(s[[197]]) <- "simule_gagnant: Indicatrice sur la prédiction que le ménage serait gagnant avec la taxe compensée, d'après nos simulations"
  label(s[[198]]) <- "hausse_chauffage: Hausse des dépenses de chauffage simulées pour le ménage, suite à la taxe (élasticité de 0.15 au lieu de 0.2)"
  label(s[[199]]) <- "hausse_diesel: Hausse des dépenses de diesel simulées pour le ménage, suite à la taxe (élasticité de 0.4)"
  label(s[[200]]) <- "hausse_essence: Hausse des dépenses d'essence simulées pour le ménage, suite à la taxe (élasticité de 0.4)"
  label(s[[201]]) <- "avant_modifs: indicatrice la version initiale du questionnaire, avant certains changements : séparation du bloc info_ccc et concentration; débuggage de efforts_relatif (avant la seule version était variante_vous=0); affichage de la question mail" # variable valant aléatoirement 0/1 au début du sondage, 2 à partir de 22/04/22h16(FR)
  label(s[[202]]) <- "info_CCC: Indicatrice (aléatoire 0/1) que l'information sur la CCC a été affichée: La Convention Citoyenne pour le Climat est une assemblée indépendante de 150 citoyens tirés au sort qui a pour mandat de faire des propositions permettant de réduire les émissions de gaz à effet de serre françaises dans un esprit de justice sociale. Elle se réunit régulièrement depuis septembre 2019 et va bientôt rendre compte de ses propositions."
  label(s[[203]]) <- "question_confiance: Indicatrice que la question confiance_dividende a été affichée" # Variable aléatoire 0/1/2/3
  label(s[[204]]) <- "variante_efforts_vous: Indicatrice (aléatoire 0/1) que efforts_relatifs est 'vous relativement aux autres' (au contraire, si variante_efforts_vous==0, efforts_relatifs est posée: Est-ce que la majorité est prête à plus d'efforts que vous)"
  label(s[[205]]) <- "origine_taxe: Variante à l'amorce pour la taxe carbone avec dividendes. (inconnue: Imaginez ... / CCC: Imaginez que la CCC propose ... / gouvernement: Imaginez que le gouvernement propsoe ...)"
  label(s[[206]]) <- "label_taxe: Variante à la description de la taxe carbone avec dividendes. (taxe: ... une augmentation de la taxe carbone ... / CCE: une augmentation de la contribution climat-énergie)"
  
  for (i in 1:length(s)) names(s)[i] <- sub(':.*', '', label(s[[i]]))
  return(s)
}

convert_s <- function(s) {
  # lab <- label(s$csp)
  # s$csp <- factor(s$csp, levels=c(levels(s$csp), "Cadres", "Indépendants", "Ouvriers", 'Inactifs', "Professions intermédiaires", "Retraités", "Employés", "Agriculteurs"))
  # s$csp <- as.character(s$csp)
  s$csp[grepl("cadre",s$csp)] <- "Cadre"
  s$csp[grepl("Artisan",s$csp)] <- "Indépendant"
  s$csp[grepl("iaire",s$csp)] <- "Intermédiaire"
  s$csp[grepl("etrait",s$csp)] <- "Retraité"
  s$csp[grepl("Employ",s$csp)] <- "Employé"
  s$csp[grepl("Agricul",s$csp)] <- "Agriculteur"
  s$csp[grepl("Ouvrier",s$csp)] <- "Ouvrier"
  s$csp[grepl("Inactif",s$csp)] <- "Inactif"
  # label(s$csp) <- lab
  # s$csp <- as.factor(s$csp)
  
  for (i in 1:length(s)) {
    # levels(s[[i]]) <- c(levels(s[[i]]), "NSP")
    s[[i]][s[[i]] == "NSP (Ne sais pas, ne se prononce pas)"] <- "NSP"
    s[[i]][s[[i]] == "NSP (Ne sait pas, ne se prononce pas)"] <- "NSP"
    s[[i]][s[[i]] == "NSP (Ne sais pas, ne se prononce pas)."] <- "NSP"
    s[[i]][s[[i]] == "NSP (Ne sait pas, ne se prononce pas)."] <- "NSP"
    s[[i]][s[[i]] == "NSP (Ne sais pas, ne souhaite pas répondre)"] <- "NSP"
    s[[i]][s[[i]] == "NSP (Ne sait pas, ne veut pas répondre)"] <- "NSP"
    s[[i]][s[[i]] == "NSP (Ne veut pas répondre)"] <- "NSP"
    s[[i]][s[[i]] == "Ne se prononce pas"] <- "NSP"
  }
  
  # s$mauvaise_qualite <- 0 # 99% if we exclude those from revenu, 92% otherwise
  # s$mauvaise_qualite[n(s$revenu) > n(s$rev_tot)] <- 1 + s$mauvaise_qualite[n(s$revenu) > n(s$rev_tot)] # 164
  # s$mauvaise_qualite[n(s$revenu) > 10000] <- 1 + s$mauvaise_qualite[n(s$revenu) > 10000] # 58
  # s$mauvaise_qualite[n(s$rev_tot) > 10000] <- 1 + s$mauvaise_qualite[n(s$rev_tot) > 10000] # 55
  s$revenu <- clean_number(s$revenu, high_numbers='divide')
  s$rev_tot <- clean_number(s$rev_tot, high_numbers='divide') # TODO: check ça et patrimoine
  # s$revenu[s$revenu > 10000] <- wtd.mean(s$revenu[s$revenu < 10000], weights = s$weight[s$revenu < 10000], na.rm=T)
  # s$rev_tot[s$rev_tot > 10000] <- wtd.mean(s$rev_tot[s$rev_tot < 10000], weights = s$weight[s$rev_tot < 10000], na.rm=T)
  for (i in c( # TODO: check number outliers
     "revenu", "rev_tot", "taille_menage", "nb_adultes", "nb_14_et_plus", "duree", "km_0", "km_1", "km_2", "conso_1", "conso_2", "surface",
     "obstacles_lobbies", "obstacles_manque_volonte", "obstacles_manque_cooperation", "obstacles_inegalites", "obstacles_incertitudes",
     "obstacles_demographie", "obstacles_technologies", "obstacles_rien", "part_anthropique", "redistribution", "importance_environnement", 
     "importance_associatif", "importance_confort", "duree_info_CCC", "duree_concentration", "question_confiance", "variante_efforts_vous", # "simule_gagnant", 
     "hausse_chauffage", "hausse_depenses", "hausse_diesel", "hausse_essence", "nb_vehicules"
              )) {
    lab <- label(s[[i]])
    s[[i]] <- as.numeric(as.vector(s[[i]]))
    label(s[[i]]) <- lab
  }
  
  # s$mauvaise_qualite[s$taille_menage < s$nb_adultes | s$taille_menage < s$nb_14_et_plus] <- 1.3 + s$mauvaise_qualite[s$taille_menage < s$nb_adultes | s$taille_menage < s$nb_14_et_plus] # 15
  # s$mauvaise_qualite[s$taille_menage > 12] <- 1.3 + s$mauvaise_qualite[s$taille_menage > 12] # 10
  # s$mauvaise_qualite[s$nb_14_et_plus > 10] <- 1 + s$mauvaise_qualite[s$nb_14_et_plus > 10] # 2
  s$taille_menage <- pmin(s$taille_menage, 12)
  s$nb_14_et_plus <- pmin(s$nb_14_et_plus, 10)
  s$nb_adultes <- pmin(s$nb_adultes, 5)
  # s$mauvaise_qualite[s$km > 10^6] <- 1 + s$mauvaise_qualite[s$km > 10^6] # 1
  # s$mauvaise_qualite[s$surface < 9] <- 1 + s$mauvaise_qualite[s$surface < 9] # 6
  # s$mauvaise_qualite[s$surface >= 1000] <- 1 + s$mauvaise_qualite[s$surface >= 1000] # 4
  # label(s$mauvaise_qualite) <- "mauvaise_qualite: Indicatrice d'une réponse aberrante à revenu, taille_menage, nb_14_et_plus, km ou surface."

  for (j in c("taxe_approbation", "taxe_feedback_approbation", "pour_sortition"
              )) {
    s[j][[1]] <- as.item(as.character(s[j][[1]]),
                labels = structure(c("","Non","NSP","Oui"), names = c("NA","Non","NSP","Oui")),
                missing.values = c("","NSP"), annotation=attr(s[j][[1]], "label"))
  }

  s$pour_taxe_carbone[!is.na(s$pour_taxe_carbone_contre)] <- s$pour_taxe_carbone_contre[!is.na(s$pour_taxe_carbone_contre)]
  s$pour_taxe_carbone[!is.na(s$pour_taxe_carbone_pour)] <- s$pour_taxe_carbone_pour[!is.na(s$pour_taxe_carbone_pour)]
  s$pour_taxe_carbone[!is.na(s$pour_taxe_carbone_neutre)] <- s$pour_taxe_carbone_neutre[!is.na(s$pour_taxe_carbone_neutre)]
  s$variante_taxe_carbone[!is.na(s$pour_taxe_carbone_neutre)] <- 'neutre'
  s$variante_taxe_carbone[!is.na(s$pour_taxe_carbone_contre)] <- 'contre'
  s$variante_taxe_carbone[!is.na(s$pour_taxe_carbone_pour)] <- 'pour'
  label(s$pour_taxe_carbone) <- "pour_taxe_carbone: ~ Favorable à une augmentation de la taxe carbone (Oui/Non/NSP) ~ sachant que majorité de Français pour/contre/no info (variante_taxe_carbone)"
  label(s$variante_taxe_carbone) <- "variante_taxe_carbone: Variante aléatoire pour pour_taxe_carbone: neutre/pour/contre: no info / Selon un sondage de 2018/2019, une majorité de Français est pour/contre une augmentation de la taxe carbone"
  for (j in c("pour_taxe_carbone_pour", "pour_taxe_carbone_contre", "pour_taxe_carbone_neutre", "pour_taxe_carbone"
              )) {
    temp <- as.character(s[j][[1]])
    temp[grepl('Non', temp)] <- 'Non'
    temp[grepl('Oui', temp)] <- 'Oui'
    s[j][[1]] <- as.item(temp,
                labels = structure(c("Non","NSP","Oui"), names = c("Non","NSP","Oui")), missing.values = c("NSP"), annotation=attr(s[j][[1]], "label"))
  }

  for (j in c("chauffage", "parle_CC", "cause_CC_AT", "cause_CC_CCC", "effets_CC_AT", "issue_CC" # , "interet_politique"
              )) {
    if (j %in% c("chauffage", "cause_CC_AT")) s[capitalize(j)] <- s[j][[1]]
    # s[j][[1]] <- as.item(as.character(s[j][[1]]),
    #             labels = structure(levels(factor(s[j][[1]])), names = levels(factor(s[j][[1]]))),
    #             missing.values = c("NSP", ""), annotation=paste(attr(s[j][[1]], "label"), "(char)")) # TODO: pb with numbers=T
    s[j][[1]] <- as.item(as.factor(s[j][[1]]), missing.values = c("NSP", ""), annotation=paste(attr(s[j][[1]], "label"), "(char)")) # TODO: pb with numbers=T
  }

  for (j in names(s)) {
    if ((grepl('gilets_jaunes_|ecologiste|conservateur|liberal|patriote|humaniste|apolitique|locataire|proprio_|heberge_|solution_CC_|responsable_', j)
        | grepl('soutenu_|qualite_enfant_|^CCC_', j))
        & !(j %in% c('CCC_autre')) & !grepl('CCC_devoile_', j)) { # TODO: extr_gauche à extr_droite
      s[[j]][s[[j]]!=""] <- TRUE
      s[[j]][is.na(s[[j]])] <- FALSE
    }
  }

  for (k in c(55:60)) {
    temp <-  3 * (s[k][[1]]=="Très souhaitable") + grepl("Assez", s[k][[1]]) - grepl("Pas vraiment", s[k][[1]]) - 3 * (s[k][[1]]=="Pas du tout souhaitable")
    s[k][[1]] <- as.item(temp, labels = structure(c(-3,-1,1,3),
                          names = c("Pas du tout","Pas vraiment","Assez","Très")),
                          # names = c("Non, pas du tout","Non, pas vraiment","Indifférent ou Ne sais pas","Oui, plutôt","Oui, tout à fait")),
                        annotation=Label(s[k][[1]]))
  }
  
  for (k in c(141:148)) {
    temp <-  2 * (s[k][[1]]=="Oui, tout à fait") + (s[k][[1]]=="Oui, plutôt") - (s[k][[1]]=="Non, pas vraiment") - 2 * (s[k][[1]]=="Non, pas du tout")
    s[k][[1]] <- as.item(temp, labels = structure(c(-2:2),
                          names = c("Pas du tout","Pas vraiment","Indifférent/NSP","Plutôt","Tout à fait")),
                          # names = c("Non, pas du tout","Non, pas vraiment","Indifférent ou Ne sais pas","Oui, plutôt","Oui, tout à fait")),
                        annotation=Label(s[k][[1]]))
  }
  
  for (k in c(127:130)) {
    temp1 <- -3*(s[k][[1]]=='Non, je suis sûr·e que non') - (s[k][[1]]=='Non, ça ne me dit rien') + (s[k][[1]]=='Oui, il me semble') + 3*(s[k][[1]]=="Oui, j'en suis sûr·e")
    temp2 <- -3*(s[k+28][[1]]=='Non, je suis sûr·e que non') - (s[k+28][[1]]=='Non, ça ne me dit rien') + (s[k+28][[1]]=='Oui, il me semble') + 3*(s[k+28][[1]]=="Oui, j'en suis sûr·e")
    temp[s$info_CCC==1] <- -3*(s[k][[1]][s$info_CCC==1]=='Non, je suis sûr·e que non') - (s[k][[1]][s$info_CCC==1]=='Non, ça ne me dit rien') + (s[k][[1]][s$info_CCC==1]=='Oui, il me semble') + 3*(s[k][[1]][s$info_CCC==1]=="Oui, j'en suis sûr·e")
    temp[s$info_CCC==0] <- -3*(s[k+28][[1]][s$info_CCC==0]=='Non, je suis sûr·e que non') - (s[k+28][[1]][s$info_CCC==0]=='Non, ça ne me dit rien') + (s[k+28][[1]][s$info_CCC==0]=='Oui, il me semble') + 3*(s[k+28][[1]][s$info_CCC==0]=="Oui, j'en suis sûr·e")
    s[k][[1]] <- as.item(temp1, labels=structure(c(-3, -1, 1, 3), names = c('Non, sûr', 'Non, me dit rien', 'Oui, me semble', 'Oui, sûr')), annotation=Label(s[k][[1]]))
    s[k+28][[1]] <- as.item(temp2, labels=structure(c(-3, -1, 1, 3), names = c('Non, sûr', 'Non, me dit rien', 'Oui, me semble', 'Oui, sûr')), annotation=Label(s[k+28][[1]]))
    s[[sub('_info_CCC', '', names(s)[k])]] <- as.item(temp, labels=structure(c(-3, -1, 1, 3), names = c('Non, sûr', 'Non, me dit rien', 'Oui, me semble', 'Oui, sûr')), 
                             annotation=sub('\\(info_CCC==1\\)', '~ info_CCC', sub('_info_CCC', '', Label(s[k][[1]]))))
  }
  
  for (k in c(149:153)) {
    temp <-  0.1 * (s[k][[1]]=="NSP") + (s[k][[1]]=="Oui") - (s[k][[1]]=="Non")
    s[k][[1]] <- as.item(temp, labels = structure(c(0.1,-1:1), names = c("NSP","Non","Blanc","Oui")), missing.values=0.1, annotation=Label(s[k][[1]]))
  }
  
  temp[1:length(s$info_CCC)] <- 'Non'
  temp[grepl('Oui', s$concentration_info_CCC) | grepl('Oui', s$concentration_no_info_CCC)] <- 'Oui'
  s$concentration <- as.item(temp, labels=structure(c('Non', 'Oui'), names = c('Non', 'Oui,')), annotation=sub('\\(info_CCC==1\\)', '(info_CCC)', sub('_info_CCC', '', Label(s$concentration_info_CCC))))
  
  temp[grepl('Ça dépend',s$trop_impots)] <- 'Ça dépend'
  temp[!grepl('Ça dépend',s$trop_impots)] <- s$trop_impots[!grepl('Ça dépend',s$trop_impots)] 
  s$trop_impots <- as.item(as.character(temp), labels = structure(c("NSP", "Non","Ça dépend","Oui"), names = c("NSP","Non","Ça dépend","Oui")), missing.values = c("NSP"), annotation=attr(s$trop_impots, "label"))

  temp <- (s$parle_CC=='Plusieurs fois par an') + 2*(s$parle_CC=='Plusieurs fois par mois') - (s$parle_CC=="NSP")
  s$parle_CC <- as.item(temp, labels = structure(c(-1:2),
                          names = c("NSP","Presque jamais","Plusieurs fois par an","Plusieurs fois par mois")),
                        missing.values = -1, annotation=Label(s$parle_CC))
  
  temp <- grepl("Faibles", s$effets_CC_AT) + 2*grepl("Graves", s$effets_CC_AT) + 3*grepl("Désastreux", s$effets_CC_AT) + 4*grepl("Cataclysmiques", s$effets_CC_AT) - (s$effets_CC_AT=="NSP")
  s$effets_CC_AT <- as.item(temp, labels = structure(c(-1:4),
                          names = c("NSP","Insignifiants","Faibles","Graves","Désastreux","Cataclysmiques")),
                          # names = c("NSP","Insignifiants, voire bénéfiques","Faibles, car les humains sauraient vivre avec","Graves, car il y aurait plus de catastrophes naturelles","Désastreux, les modes de vie seraient largement altérés","Cataclysmiques, l'humanité disparaîtrait")),
                        missing.values = -1, annotation=Label(s$effets_CC_AT))
  
  s$cause_CC_CCC <- relabel(s$cause_CC_CCC, c("Uniquement à des processus naturels"="Uniquement naturel", "Principalement à des processus naturels"="Principalement naturel", "Autant à des processus naturels qu'à l'activité humaine"="Autant",  "Principalement à l'activité humaine"="Principalement anthropique", "Uniquement à l'activité humaine"="Uniquement anthropique"))
  temp <- grepl("Uniquement anthropique", s$cause_CC_CCC) - grepl("Autant", s$cause_CC_CCC) - 2*grepl("Principalement naturel", s$cause_CC_CCC) - 3*grepl("Uniquement naturel", s$cause_CC_CCC)
  s$cause_CC_CCC <- as.item(temp, labels = structure(c(-3:1),
                      names = c("Uniquement naturel","Principalement naturel","Autant","Principalement anthropique","Uniquement anthropique")), annotation=Label(s$cause_CC_CCC))

  temp <- -3*(s$problemes_invisibilises=='Jamais') - (s$problemes_invisibilises=='Peu souvent') + (s$problemes_invisibilises=='Assez souvent') + 3*(s$problemes_invisibilises=='Très souvent')
  s$problemes_invisibilises <- as.item(temp, labels=structure(c(-3, -1, 1, 3), names = c('Jamais', 'Peu souvent', 'Assez souvent', 'Très souvent')), annotation=Label(s$problemes_invisibilises))
# TODO: confiance_dividende -1:1?
  temp <- -3*(s$issue_CC=='Non, certainement pas') - (s$issue_CC=='Non, probablement pas') + (s$issue_CC=='Oui, probablement') + 3*(s$issue_CC=='Oui, certainement')
  s$issue_CC <- as.item(temp, labels=structure(c(-3, -1, 1, 3), names = c('Non, certainement pas', 'Non, probablement pas', 'Oui, probablement', 'Oui, certainement')), annotation=Label(s$issue_CC))

  temp <- -3*(s$confiance_sortition=='Pas du tout confiance') - (s$confiance_sortition=='Plutôt pas confiance') + (s$confiance_sortition=='Plutôt confiance') + 3*(s$confiance_sortition=='Tout à fait confiance')
  s$confiance_sortition <- as.item(temp, labels=structure(c(-3, -1, 1, 3), names = c('Pas du tout confiance', 'Plutôt pas confiance', 'Plutôt confiance', 'Tout à fait confiance')), annotation=Label(s$confiance_sortition))

  temp <- -2*(s$certitude_gagnant=='Je ne suis pas du tout sûr·e de ma réponse') - (s$certitude_gagnant=='Je ne suis pas vraiment sûr·e de ma réponse') + (s$certitude_gagnant=='Je suis sûr·e de ma réponse')
  s$certitude_gagnant <- as.item(temp, labels=structure(c(-2:1), names = c('Pas du tout sûr', 'Pas vraiment sûr', 'Moyennement sûr', 'Sûr')), annotation=Label(s$certitude_gagnant))
  temp <- -2*(s$certitude_gagnant_feedback=='Je ne suis pas du tout sûr·e de ma réponse') - (s$certitude_gagnant_feedback=='Je ne suis pas vraiment sûr·e de ma réponse') + (s$certitude_gagnant_feedback=='Je suis sûr·e de ma réponse')
  s$certitude_gagnant_feedback <- as.item(temp, labels=structure(c(-2:1), names = c('Pas du tout sûr', 'Pas vraiment sûr', 'Moyennement sûr', 'Sûr')), annotation=Label(s$certitude_gagnant_feedback))

  temp <- -2*grepl("Jamais", s$confiance_gouvernement) - grepl("Parfois", s$confiance_gouvernement) + grepl("La plupart", s$confiance_gouvernement) + 2*grepl("Toujours", s$confiance_gouvernement) + 0.1*grepl("NSP", s$confiance_gouvernement)
  s$confiance_gouvernement <- as.item(temp, labels=structure(c(-2:2,0.1), names = c('Jamais', 'Parfois', 'Moitié du temps', 'Plupart du temps', 'Toujours', 'NSP')), missing.values=0.1, annotation=Label(s$confiance_gouvernement))

  temp <- - grepl("Non", s$connait_CCC) + grepl("Oui, je sais assez", s$connait_CCC) + 2*grepl("Oui, je sais très bien", s$connait_CCC)
  s$connait_CCC <- as.item(temp, labels=structure(c(-1:2), names = c('Non', 'Vaguement', 'Oui, assez', 'Oui, très')), annotation=Label(s$connait_CCC))

  temp <- - grepl("Aucune", s$sait_CCC_devoilee) + grepl("Oui", s$sait_CCC_devoilee) 
  s$sait_CCC_devoilee <- as.item(temp, labels=structure(c(-1:1), names = c('Non', 'Pas sûr', 'Oui')), annotation=Label(s$sait_CCC_devoilee))
  
  s$question_confiance <- s$question_confiance > 0
  s$avant_modifs <- s$avant_modifs != 2
  s$duree_info_CCC[s$avant_modifs==T] <- NA # /!\ comment these two lines to see the duration avant_modifs, when info CCC & concentration were on the same page
  s$variante_efforts_vous[s$avant_modifs==T] <- 0
  temp <- s$efforts_relatifs
  s$efforts_relatifs[temp=='Un peu moins' & s$variante_efforts_vous==0] <- 'Un peu plus'
  s$efforts_relatifs[temp=='Un peu plus' & s$variante_efforts_vous==0] <- 'Un peu moins'
  s$efforts_relatifs[temp=='Beaucoup moins' & s$variante_efforts_vous==0] <- 'Beaucoup plus'
  s$efforts_relatifs[temp=='Beaucoup plus' & s$variante_efforts_vous==0] <- 'Beaucoup moins'
  temp <- -2*(s$efforts_relatifs=='Beaucoup moins') - (s$efforts_relatifs=='Un peu moins') + 2*(s$efforts_relatifs=='Beaucoup plus') + 1*(s$efforts_relatifs=='Un peu plus')
  s$efforts_relatifs <- as.item(temp, labels=structure(c(-2:2), names = c('Beaucoup moins', 'Un peu moins', 'Autant', 'Un peu plus', 'Beaucoup plus')), annotation=Label(s$efforts_relatifs))
 
  temp <- 20.90*(s$age == "18 à 24 ans") + 29.61*(s$age == "25 à 34 ans") + 42.14*(s$age == "35 à 49 ans") + 56.84*(s$age == "50 à 64 ans") + 75.43*(s$age == "65 ans ou plus")
  s$age <- as.item(temp, labels = structure(c(20.90, 29.61, 42.14, 56.84, 75.43), names = c("18-24", "25-34", "35-49", "50-64", "65+")), annotation=Label(s$age))
  # s$Age <- (s$age == "18 à 24 ans") + 2*(s$age == "25 à 34 ans") + 3.3*(s$age == "35 à 49 ans") + 4.6*(s$age == "50 à 64 ans") + 7*(s$age == "65 ans ou plus")
  s$taille_agglo <- as.item(as.numeric(s$taille_agglo), labels = structure(1:5, names = c("rural", "-20k", "20-100k", "+100k", "Paris")), annotation=Label(s$taille_agglo))  
  temp <- 1*grepl('10 001', s$patrimoine) + 2*grepl('60 001', s$patrimoine) + 3*grepl('180 001', s$patrimoine) + 4*grepl('350 001', s$patrimoine) + 5*grepl('Plus de', s$patrimoine) - 1*grepl('NSP', s$patrimoine) # TODO: check if NA
  s$patrimoine <- as.item(as.numeric(temp), missing.values=-1, labels = structure(-1:5, names = c("NSP", "< 10k", "10-60k", "60-180k", "180-350k", "350-550k", "> 550k")), annotation=Label(s$patrimoine))  
  
  s$Diplome <- (s$diplome == "Brevet des collèges") + 2*(s$diplome=="CAP ou BEP") + 3*(s$diplome=="Baccalauréat") + 4*(s$diplome=="Bac +2 (BTS, DUT, DEUG, écoles de formation sanitaires et sociales...)") + 5*(s$diplome=="Bac +3 (licence...)") + 6*(s$diplome=="Bac +5 ou plus (master, école d'ingénieur ou de commerce, doctorat, médecine, maîtrise, DEA, DESS...)") - (s$diplome=="NSP (Ne se prononce pas)")
  s$diplome4 <- as.item(pmin(pmax(s$Diplome, 1), 4), labels = structure(1:4, names = c("Aucun diplôme ou brevet", "CAP ou BEP", "Baccalauréat", "Supérieur")), annotation=Label(s$diplome))  
# TODO
  s$chauffage <- relabel(s$chauffage, c("Gaz de ville"="Gaz réseau", "Butane, propane, gaz en citerne"="Gaz bouteille", "Fioul, mazout, pétrole"="Fioul", "Électricité"="Électricité", "Bois, solaire, géothermie, aérothermie (pompe à chaleur)"="Bois, solaire...", "Autre"="Autre", "NSP"="NSP"))
  s$cause_CC_AT <- relabel(s$cause_CC_AT, c("n'est pas une réalité"="n'existe pas", "est principalement dû à la variabilité naturelle du climat"="naturel", "est principalement dû à l'activité humaine"="anthropique", "NSP"="NSP"))
  s$confiance_gens <- relabel(s$confiance_gens, c("On n’est jamais assez prudent quand on a affaire aux autres"="Confiant", "On n’est jamais assez prudent quand on a affaire aux autres"="Méfiant"))
  
  s$gauche_droite <- pmax(-2,pmin(2,-2 * grepl("extrême gauche", s$extr_gauche) - grepl("De gauche", s$gauche) + grepl("De droite", s$droite) + 2 * grepl("extrême droite", s$extr_droite)))
  is.na(s$gauche_droite) <- (s$gauche_droite == 0) & !grepl("centre", s$centre)
  s$Gauche_droite <- as.factor(s$gauche_droite)
  s$gauche_droite <- as.item(as.numeric(as.vector(s$gauche_droite)), labels = structure(c(-2:2),
                          names = c("Extrême gauche","Gauche","Centre","Droite","Extrême droite")), annotation="gauche_droite:échelle de -2 (extr_gauche) à +2 (extr_droite) - Orientation politique (Comment vous définiriez-vous ? Plusieurs réponses possibles: (D'extrême) gauche/Du centre/(D'extrême) droite/Libéral/Humaniste/Patriote/Apolitique/Écologiste/Conservateur (champ libre)/NSP)") 
  levels(s$Gauche_droite) <- c("Extreme-left", "Left", "Center", "Right", "Extreme-right", "Indeterminate")
  s$Gauche_droite[is.na(s$Gauche_droite)] <- "Indeterminate"
  s$indeterminate <- s$Gauche_droite == "Indeterminate"
  
  temp <- Label(s$interet_politique)
  s$interet_politique <- 1*(s$interet_politique=='Un peu') + 2*(s$interet_politique=='Beaucoup')
  s$interet_politique <- as.item(s$interet_politique, labels=structure(c(0:2), names=c('Presque pas', 'Un peu', 'Beaucoup')), annotation=temp)

  s$gilets_jaunes[s$gilets_jaunes_NSP==T] <- -0.1
  s$gilets_jaunes[s$gilets_jaunes_compris==T] <- 0 # total à 115%
  s$gilets_jaunes[s$gilets_jaunes_oppose==T] <- -1 # 2 oppose et soutien en même temps
  s$gilets_jaunes[s$gilets_jaunes_soutien==T] <- 1
  s$gilets_jaunes[s$gilets_jaunes_dedans==T] <- 2
  s$gilets_jaunes <- as.item(s$gilets_jaunes, missing.values=-0.1, labels = structure(c(-0.1,-1:2), names=c('NSP', 'oppose', 'comprend', 'soutient', 'est_dedans')),
                             annotation="gilets_jaunes: -1: s'oppose / 0: comprend sans soutenir ni s'opposer / 1: soutient / 2: fait partie des gilets jaunes (gilets_jaunes_compris/oppose/soutien/dedans/NSP)" )
  s$Gilets_jaunes <- as.factor(as.character(s$gilets_jaunes))
  s$Gilets_jaunes <- relevel(s$Gilets_jaunes, 'soutient')
  s$Gilets_jaunes <- relevel(s$Gilets_jaunes, 'comprend')
  s$Gilets_jaunes <- relevel(s$Gilets_jaunes, 'NSP')
  s$Gilets_jaunes <- relevel(s$Gilets_jaunes, 'oppose')
  
  s$revenu_conjoint <- s$rev_tot - s$revenu
  s$revdisp <- round((s$rev_tot -  irpp(s$rev_tot, s$nb_adultes, s$taille_menage)))
  s$uc <- uc(s$taille_menage, s$nb_14_et_plus)
  s$niveau_vie <- s$revdisp / s$uc
  
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
	} # TODO: pourquoi Centre excède de 20% le quota? Pourquoi y a-t-il aussi des excès de quotas dans taille_agglo?
  region_dep <- rep("", 95)
  for (i in 1:95) region_dep[i] <- region_code(i)
  s$region_verif <- "autre"
  s$region_verif[as.numeric(substr(s$code_postal, 1, 2)) %in% 1:95] <- region_dep[as.numeric(substr(s$code_postal, 1, 2))]
  s$nb_vehicules_verif <- (s$nb_vehicules_texte=='Un') + 2*(s$nb_vehicules_texte=='Deux ou plus')

  s$perte <- 1 + round(as.numeric(gsub("\\D*", "", sub("\\set.*", "", sub("\\D*", "", s$hausse_depenses_subjective))))/45)
  s$perte[grepl('au contraire', s$hausse_depenses_subjective)] <- -1
  s$perte[grepl('aucune baisse', s$hausse_depenses_subjective)] <- 0
  label(s$perte) <- "perte: Catégorie de hausse_depenses_subjective par UC, suite à hausse taxe carbone compensée, dans [-1;5] (seuils: 0/1/30/70/120/190)"

  s$perte_echelle <- s$perte
  label(s$perte) <- "perte: Catégorie de hausse_depenses_subjective (€ par UC par an), suite à hausse taxe carbone compensée, dans [-1;5] (seuils: 0/1/30/70/120/190)"

  # cf. consistency_belief_losses.py pour les imputations. Average of BdF in each bin has been used.
  s$perte_min <- -30*(s$perte==-1) + 1*(s$perte==1) + 30*(s$perte==2) + 70*(s$perte==3) + 120*(s$perte==4) + 190*(s$perte==5)
  s$perte_max <-   0*(s$perte==-1) + 30*(s$perte==1) + 70*(s$perte==2) + 120*(s$perte==3) + 190*(s$perte==4) + 2000*(s$perte==5)
  temp <- 224.25*(s$perte==5) + 147.91*(s$perte==4) + 92.83*(s$perte==3) + 48.28*(s$perte==2) + 13.72*(s$perte==1) - 1.66*(s$perte==-1) # TODO: recalculer, surtout perte==5 (qui correspond à [190;280] au lieu de >190) et perte==-1 (ne sait pas d'où il sort). Pour info 405.55*(perte==6)
  s$perte <- as.item(temp, labels = structure(c(224.25, 147.91, 92.83, 48.28, 13.72, 0, -1.66), names = c(">190", "120-190", "70-120", "30-70", "0-30", "0", "<0")), annotation=Label(s$perte))

  s$km[!is.na(s$km_0)] <- s$km_0[!is.na(s$km_0)]
  s$km[!is.na(s$km_1)] <- s$km_1[!is.na(s$km_1)]
  s$km[!is.na(s$km_2)] <- s$km_2[!is.na(s$km_2)]
  label(s$km) <- "km: Nombre de kilomètres parcourus lors des 12 derniers mois en voiture ou moto (par le répondant pour nb_vehicules=0, par les véhicules sinon)"
 
  s$conso[!is.na(s$conso_1)] <- s$conso_1[!is.na(s$conso_1)]
  s$conso[!is.na(s$conso_2)] <- s$conso_2[!is.na(s$conso_2)]
  s$conso[is.na(s$conso)] <- (6.39 + 7.31) / 2
  label(s$conso) <- "conso:  Consommation moyenne du véhicule (en litres aux 100 km)"

  # s$mauvaise_qualite[s$conso > 90] <- 1 + s$mauvaise_qualite[s$conso > 90] # 28
  s$km_original <- s$km
  s$conso_original <- s$conso
  s$surface_original <- s$surface
  s$km <- pmin(s$km, 200000) # 4
  s$conso <- pmin(s$conso, 30) # 75
  s$surface <- pmin(s$surface, 650) # 5
  
#   s$gaz <- grepl('gaz', s$chauffage, ignore.case = T) # TODO: check efforts_relatifs & fuel_2_1 in new survey test
#   s$fioul <- grepl('fioul', s$chauffage, ignore.case = T)
#   s$hausse_chauffage <- -55.507189 + s$gaz * 124.578484 + s$fioul * 221.145441 + s$surface * 0.652174  
# 	s$hausse_diesel[s$nb_vehicules == 0] <- (0.5*(6.39/100) * s$km * 1.4 * (1 - 0.4) * 0.090922)[s$nb_vehicules == 0] # share_diesel * conso * km * price * (1-elasticite) * price_increase
# 	s$hausse_diesel[s$nb_vehicules == 1] <- ((s$fuel_1=='Diesel') * (s$conso/100) * s$km * 1.4 * (1 - 0.4) * 0.090922)[s$nb_vehicules == 1]
#   s$hausse_diesel[s$nb_vehicules == 2] <- (((s$fuel_2_1=='Diesel')*2/3 + (s$fuel_2_2=='Diesel')/3) * (s$conso/100) * s$km * 1.4 * (1 - 0.4) * 0.090922)[s$nb_vehicules == 2]
# 	s$hausse_essence[s$nb_vehicules == 0] <- (0.5*(7.31/100) * s$km * 1.45 * (1 - 0.4) * 0.076128)[s$nb_vehicules == 0] # share_diesel * conso * km * price * (1-elasticite) * price_increase
# 	s$hausse_essence[s$nb_vehicules == 1] <- ((s$fuel_1!='Diesel') * (s$conso/100) * s$km * 1.45 * (1 - 0.4) * 0.076128)[s$nb_vehicules == 1]
#   s$hausse_essence[s$nb_vehicules == 2] <- (((s$fuel_2_1!='Diesel')*2/3 + (s$fuel_2_2!='Diesel')/3) * (s$conso/100) * s$km * 1.45 * (1 - 0.4) * 0.076128)[s$nb_vehicules == 2]
#   s$hausse_carburants <- s$hausse_diesel + s$hausse_essence
#   s$depense_carburants <- (s$hausse_diesel / 0.090922 + s$hausse_essence / 0.076128) / (1 - 0.4)
#   label(s$hausse_carburants) <- "hausse_carburant: Hausse des dépenses de carburants simulées pour le ménage, suite à la taxe (élasticité de 0.4) (hausse_diesel + hausse_essence)"
#   label(s$depense_carburants) <- "depense_carburants: Dépense de carburants annuelle estimée du ménage, avant la réforme"
#   s$hausse_depenses <- s$hausse_carburants + s$hausse_chauffage
  s$diesel <- (!is.na(s$fuel_1) & (s$fuel_1=='Diesel')) | (!is.na(s$fuel_2_2) & ((s$fuel_2_1=='Diesel') | (s$fuel_2_2=='Diesel')))
  s$essence <- (!is.na(s$fuel_1) & (s$fuel_1=='Essence')) | (!is.na(s$fuel_2_2) & ((s$fuel_2_1=='Essence') | (s$fuel_2_2=='Essence')))
  label(s$diesel) <- "diesel: Indicatrice de la possession d'un véhicule diesel par le ménage (fuel_1 ou fuel_2_1 ou fuel_2_2 = 'Diesel')"
  label(s$essence) <- "essence: Indicatrice de la possession d'un véhicule à essence par le ménage (fuel_1 ou fuel_2_1 ou fuel_2_2 = 'Essence')"
  
  s$simule_gain_menage <- 16.1 + pmin(2, s$nb_adultes) * 110 - s$hausse_depenses # élasticité de 0.15 sur le gaz
  s$simule_gain <- s$simule_gain_menage / s$uc
  s$simule_gain_repondant <- 16.1 + 110 - s$hausse_depenses
  label(s$simule_gain_menage) <- "simule_gain_menage: Gain net annuel simulé pour le ménage du répondant suite à une hausse de taxe carbone compensée: 16.1 + pmin(2, nb_adultes) * 110 - hausse_depenses"
  label(s$simule_gain) <- "simule_gain: Gain net annuel simulé par UC pour le ménage du répondant suite à une hausse de taxe carbone compensée: (16.1 + pmin(2, nb_adultes) * 110 - hausse_depenses)/UC"
  label(s$simule_gain_repondant) <- "simule_gain_repondant: Gain net annuel simulé pour le répondant (sans tenir compte du potentiel versement reçu par les autres adultes du ménage) suite à une hausse de taxe carbone compensée: 116.1 - hausse_depenses"

  # s$hausse_chauffage_interaction_inelastique <- 152.6786*s$fioul + s$surface * (1.6765*s$gaz + 1.1116*s$fioul)
  # s$depense_chauffage <- ((1*(s$fioul) * (152.6786 + 1.1116*s$surface)) / 0.148079 + 1.6765*s$gaz*s$surface / 0.133456)
  # s$hausse_depenses_interaction <- s$hausse_carburants + s$hausse_chauffage_interaction_inelastique * (1 - 0.2)
  # s$hausse_depenses_interaction_inelastique <- s$hausse_carburants/(1 - 0.4) + s$hausse_chauffage_interaction_inelastique
  # s$simule_gain_interaction <- (9.1 + pmin(2, s$nb_adultes) * 110 - s$hausse_depenses_interaction) / s$uc # élasticité de 0.2 pour le gaz
  # s$simule_gagnant_interaction <- 1*(s$simule_gain_interaction > 0)
  # s$simule_gain_inelastique <- (pmin(2, s$nb_adultes) * 110 - s$hausse_depenses_interaction_inelastique) / s$uc # élasticité nulle. Inclure + 22.4 rendrait le taux d'erreur uniforme suivant les deux catégories, on ne le fait pas pour être volontairement conservateur
  # s$simule_gain_cible_interaction <- (s$versement_cible - s$hausse_depenses_interaction) / s$uc
  # s$simule_gain_cible_interaction_inelastique <- (s$versement_cible - s$hausse_depenses_interaction_inelastique) / s$uc
  # s$simule_gain_elast_perso[s$variante_partielle=='c'] <- (pmin(2, s$nb_adultes[s$variante_partielle=='c']) * 110 - (s$hausse_chauffage_interaction_inelastique[s$variante_partielle=='c'] * (1 + s$Elasticite_chauffage_perso[s$variante_partielle=='c']) + s$hausse_carburants[s$variante_partielle=='c'])) / s$uc[s$variante_partielle=='c']
  # s$simule_gain_elast_perso[s$variante_partielle=='f'] <- (pmin(2, s$nb_adultes[s$variante_partielle=='f']) * 110 - (s$hausse_carburants[s$variante_partielle=='f'] * (1 + s$Elasticite_fuel_perso[s$variante_partielle=='f']) / (1 - 0.4) + s$hausse_chauffage_interaction_inelastique[s$variante_partielle=='f'] * (1 - 0.2))) / s$uc[s$variante_partielle=='f']
  # label(s$hausse_chauffage_interaction_inelastique) <- "hausse_chauffage_interaction_inelastique: Hausse des dépenses de chauffage simulées pour le ménage avec des termes d'interaction entre surface et gaz/fioul plutôt que sans, suite à la taxe (élasticité nulle)"
  # label(s$depense_chauffage) <- "depense_chauffage: Dépense de chauffage annuelle estimée du ménage, avant la réforme"
  # label(s$simule_gain_interaction) <- "simule_gain_interaction: Gain net par UC annuel simulé avec des termes d'interaction surface*fioul/gaz pour le ménage du répondant suite à une hausse de taxe carbone compensée: 9.1 + pmin(2, nb_adultes) * 110 - hausse_chauffage_interaction_inelastique * 0.8 - hausse_carburants"
  # label(s$simule_gagnant_interaction) <- "simule_gagnant_interaction: Indicatrice sur la prédiction que le ménage serait gagnant avec la taxe compensée, d'après nos simulations avec des termes d'interaction surface*fioul/gaz: 1*(simule_gain_interaction > 0)"
  # label(s$simule_gain_inelastique) <- "simule_gain_inelastique: Gain net par UC annuel simulé (avec interaction) avec une élasticité nulle, pour le ménage du répondant suite à une hausse de taxe carbone compensée:  nb_adultes * 110 - hausse_chauffage_interaction_inelastique - hausse_carburants / 0.6"
  # label(s$simule_gain_elast_perso) <- "simule_gain_elast_perso: Gain net par UC annuel simulé (avec interaction) avec l'élasticité renseignée par le répondant, pour le ménage du répondant suite à une hausse de taxe carbone compensée: pmin(2, nb_adultes) * 110 - hausse_partielle_inelastique * (1 - Elasticite_partielle_perso) - hausse_autre_partielle"
  # label(s$hausse_depenses_interaction) <- "hausse_depenses_interaction: Hausse des dépenses énergétiques simulées pour le ménage avec les termes d'interaction, suite à la taxe (élasticité de 0.4/0.2 pour carburants/chauffage)"
  # label(s$hausse_depenses_interaction_inelastique) <- "hausse_depenses_interaction_inelastique: Hausse des dépenses énergétiques simulées pour le ménage avec les termes d'interaction, suite à la taxe (élasticité nulle)"
  # label(s$simule_gain_cible_interaction) <- "simule_gain_cible_interaction: Gain net par UC annuel simulé avec des termes d'interaction surface*fioul/gaz pour le ménage du répondant suite à une hausse de taxe carbone avec compensation ciblée: versement_cible - hausse_depenses_interaction) / uc"
  # label(s$simule_gain_cible_interaction_inelastique) <- "simule_gain_cible_interaction_inelastique: Gain net par UC annuel simulé avec des termes d'interaction surface*fioul/gaz pour le ménage du répondant suite à une hausse de taxe carbone avec compensation ciblée: versement_cible - hausse_depenses_interaction_inelastique) / uc"
  
  s$age_18_24 <- 1*(s$age == '18-24')
  s$age_25_34 <- 1*(s$age == '25-34')
  s$age_35_49 <- 1*(s$age == '35-49')
  s$age_50_64 <- 1*(s$age == '50-64')
  s$age_65_plus <- 1*(s$age == '65+')
  
  s$tax_approval <- s$taxe_approbation=='Oui'
  s$tax_acceptance <- s$taxe_approbation!='Non'
  label(s$tax_approval) <- "tax_approval: Approbation initiale de la hausse de la taxe carbone compensée: taxe_approbation=='Oui'"
  label(s$tax_acceptance) <- "tax_acceptance: Acceptation initiale de la hausse de la taxe carbone compensée: taxe_approbation!='Non'"
  s$tax_feedback_approval <- s$taxe_feedback_approbation=='Oui'
  s$tax_feedback_acceptance <- s$taxe_feedback_approbation!='Non'
  label(s$tax_feedback_approval) <- "tax_feedback_approval: Approbation après le feedback de la hausse de la taxe carbone compensée: taxe_feedback_approbation=='Oui'"
  label(s$tax_feedback_acceptance) <- "tax_feedback_acceptance: Acceptation après le feedback de la hausse de la taxe carbone compensée: taxe_feedback_approbation!='Non'"

  s$update_correct <- ((s$simule_gagnant==1 & s$gagnant_feedback_categorie=='Gagnant' & s$gagnant_categorie!='Gagnant')
                       + (s$simule_gagnant==0 & s$gagnant_feedback_categorie=='Perdant' & s$gagnant_categorie!='Perdant')
                       - (s$simule_gagnant==1 & s$gagnant_feedback_categorie=='Perdant' & s$gagnant_categorie!='Perdant')
                       - (s$simule_gagnant==0 & s$gagnant_feedback_categorie=='Gagnant' & s$gagnant_categorie!='Gagnant'))
  label(s$update_correct) <- "update_correct: Différence entre l'indicatrice de ne pas se penser gagnant/perdant et le penser après feedback infirmant, moins la même après feedback confirmant"
  s$update_correct_large <- ((s$simule_gagnant==1 & ((s$gagnant_feedback_categorie=='Gagnant' & s$gagnant_categorie!='Gagnant') | (s$gagnant_feedback_categorie!='Perdant' & s$gagnant_categorie=='Perdant')))
                             + (s$simule_gagnant==0 & ((s$gagnant_feedback_categorie=='Perdant' & s$gagnant_categorie!='Perdant') | (s$gagnant_feedback_categorie!='Gagnant' & s$gagnant_categorie=='Gagnant')))
                             - (s$simule_gagnant==1 & ((s$gagnant_feedback_categorie=='Perdant' & s$gagnant_categorie!='Perdant') | (s$gagnant_feedback_categorie!='Gagnant' & s$gagnant_categorie=='Gagnant')))
                             - (s$simule_gagnant==0 & ((s$gagnant_feedback_categorie=='Gagnant' & s$gagnant_categorie!='Gagnant') | (s$gagnant_feedback_categorie!='Perdant' & s$gagnant_categorie=='Perdant'))))
  label(s$update_correct_large) <- "update_correct_large: Différence entre faire un update dans la bonne direction quand le feedback y conduit et faire un update dans la mauvaise direction"

  s$feedback_confirme <- (s$gagnant_categorie=='Gagnant' & s$simule_gagnant==1) | (s$gagnant_categorie=='Perdant' & s$simule_gagnant==0)
  s$feedback_infirme <- (s$gagnant_categorie=='Perdant' & s$simule_gagnant==1) | (s$gagnant_categorie=='Gagnant' & s$simule_gagnant==0)
  s$feedback_confirme_large <- s$feedback_confirme | (s$gagnant_categorie!='Perdant' & s$simule_gagnant==1) | (s$gagnant_categorie!='Gagnant' & s$simule_gagnant==0)
  s$feedback_infirme_large <- s$feedback_infirme | (s$gagnant_categorie!='Perdant' & s$simule_gagnant==0) | (s$gagnant_categorie!='Gagnant' & s$simule_gagnant==1)
  label(s$feedback_confirme) <- "feedback_confirme: Indicatrice de se penser et être simulé gagnant/perdant (gagnant_categorie, simule_gagnant)"
  label(s$feedback_infirme) <- "feedback_infirme: Indicatrice de se penser gagnant et être simulé perdant, ou l'inverse (gagnant_categorie, simule_gagnant)"
  label(s$feedback_confirme_large) <- "feedback_confirme_large: Indicatrice de se penser non perdant et être simulé gagnant, ou de se penser non gagnant et être simulé perdant (gagnant_categorie, simule_gagnant)"
  label(s$feedback_infirme_large) <- "feedback_infirme_large: Indicatrice de se penser non gagnant et être simulé gagnant, ou de se penser non perdant et être simulé perdant (gagnant_categorie, simule_gagnant)"
   
  s$winning_category <- as.factor(s$gagnant_categorie)
  s$winning_feedback_category <- as.factor(s$gagnant_feedback_categorie)
  levels(s$winning_category) <- c('Winner', 'Unaffected', 'Loser')
  levels(s$winning_feedback_category) <- c('Winner', 'Unaffected', 'Loser')
  label(s$winning_category) <- "Winning category before feedback"
  label(s$winning_feedback_category) <- "Winning category after feedback"
  
  s$Revenu <- s$revenu/1e3 # TODO: labels
  s$Revenu_conjoint <- s$revenu_conjoint/1e3
  s$percentile_revenu <- 100*percentiles_revenu(s$revenu*12)
  s$percentile_revenu_conjoint  <- 100*percentiles_revenu(s$revenu_conjoint*12)
  s$Simule_gain <- s$simule_gain/1e3
  s$Revenu2 <- s$revenu^2/1e6
  s$Revenu_conjoint2 <- s$revenu_conjoint^2/1e6
  s$Simule_gain2 <- s$simule_gain^2/1e6
  # s$biais_sur <- abs(s$simule_gain - s$gain) > 110
  # label(s$biais_sur) <- "biais_sur: Certitude à 99% que le gain subjectif du répondant est biaisé à la baisse: abs(simule_gain - gain) > 110"
  
  s$origine_taxe <- relevel(as.factor(s$origine_taxe), 'inconnue')
  s$label_taxe <- relevel(as.factor(s$label_taxe), 'taxe')
  
  s$retraites <- s$statut_emploi == 'retraité·e' 
  s$actifs <- s$statut_emploi %in% c("autre actif", "CDD", "CDI", "fonctionnaire", "intérimaire ou contrat précaire")
  s$etudiants <- s$statut_emploi == 'étudiant·e'
  s$inactif <- s$statut_emploi %in% c("inactif", "au chômage")
  label(s$retraites) <- "retraites: statut_emploi == 'retraité·e'"
  label(s$actifs) <- 'actifs: statut_emploi %in% c("autre actif", "CDD", "CDI", "fonctionnaire", "intérimaire ou contrat précaire")'
  label(s$etudiants) <- "etudiants: statut_emploi == 'étudiant·e'"
  label(s$inactif) <- 'inactif: statut_emploi %in% c("inactif", "au chômage")'
  s$single <- 1*(s$nb_adultes==1)
  label(s$single) <- "single: nb_adultes == 1"
  s$hausse_depenses_par_uc <- s$hausse_depenses/s$uc # TODO: hausse_depenses_interaction_par_uc
  label(s$hausse_depenses_par_uc) <- "hausse_depenses_par_uc: Hausse des dépenses énergétiques par UC suite à la taxe (élasticité de 0.4/0.2 pour carburants/chauffage)"

  # s$nb_politiques_env <- 0
  # variables_politiques_environnementales <- c("taxe_kerosene", "taxe_viande", "normes_isolation", "normes_vehicules", "controle_technique", "interdiction_polluants",
  #                                             "peages_urbains", "fonds_mondial") # "rattrapage_diesel"
  # for (v in variables_politiques_environnementales) s$nb_politiques_env[s[[v]]>0] <- 1 + s$nb_politiques_env[s[[v]]>0]
  
  variables_politiques_1 <<- c("fin_gaspillage", "cantines_vertes", "voies_reservees", "densification", "renouvelables", "taxe_distance") # 6
  variables_politiques_2 <<- c("bonus_malus", "aides_train", "fonds_mondial", "taxe_viande", "conditionner_aides", "restriction_centre_ville", "limitation_110", "obligation_renovation") # 8
  variables_referendum <<- c("obligation_renovation", "cheque_bio", "interdiction_publicite", "interdiction_polluants", "taxe_dividendes", "consigne") # 6
  variables_politiques_env <<- c(variables_politiques_1, variables_politiques_2, variables_referendum) # 20
  s$nb_referenda <- s$nb_politiques_2 <- s$nb_politiques_1 <- 0
  for (v in variables_referendum) s$nb_referenda[s[[paste('referendum', v, sep='_')]]>0] <- 1 + s$nb_referenda[s[[paste('referendum', v, sep='_')]]>0]
  for (v in variables_politiques_2) s$nb_politiques_2[s[[paste('pour', v, sep='_')]]>0] <- 1 + s$nb_politiques_2[s[[paste('pour', v, sep='_')]]>0]
  for (v in variables_politiques_1) s$nb_politiques_1[s[[paste('pour', v, sep='_')]]>0] <- 1 + s$nb_politiques_1[s[[paste('pour', v, sep='_')]]>0]
  s$nb_referenda_politiques_2 <- s$nb_referenda + s$nb_politiques_2
  s$nb_politiques_env <- s$nb_referenda + s$nb_politiques_1 # TODO: add carbon tax
  s$prop_referenda <- s$nb_referenda / 6
  s$prop_politiques_1 <- s$nb_politiques_1 / 6
  s$prop_politiques_2 <- s$nb_politiques_2 / 8
  s$prop_referenda_politiques_2 <- s$nb_referenda_politiques_2 / 14
  s$prop_politiques_env <- s$nb_politiques_env / 20
  label(s$nb_referenda) <- "nb_referenda: Nombre de referendum_ où le répondant voterait Oui (cf. les 6 variables_referendum) ~ info_CCC"
  label(s$nb_politiques_1) <- "nb_politiques_1: Nombre de politiques environnementales de la 1ère partie soutenues par le répondant (cf. les 6 variables_politiques_1)"
  label(s$nb_politiques_2) <- "nb_politiques_2: Nombre de politiques environnementales de la 2è partie soutenues par le répondant (cf. les 6 variables_politiques_2) ~ info_CCC"
  label(s$nb_politiques_env) <- "nb_politiques_env: Nombre de politiques environnementales soutenues par le répondant = nb_referenda + nb_politiques_1 + nb_politiques_2 (cf. les 20 variables_politiques_env)"
  label(s$nb_referenda_politiques_2) <- "nb_referenda_politiques_2: Nombre de politiques environnementales de la 2è partie soutenues par le répondant = nb_referenda + nb_politiques_2 (cf. les 14 variables_politiques_2 et variables_referendum)"
  label(s$prop_referenda) <- "prop_referenda: Proportion de referendum_ où le répondant voterait Oui (cf. les 6 variables_referendum) ~ info_CCC"
  label(s$prop_politiques_1) <- "prop_politiques_1: Proportion de politiques environnementales de la 1ère partie soutenues par le répondant (cf. les 6 variables_politiques_1)"
  label(s$prop_politiques_2) <- "prop_politiques_2: Proportion de politiques environnementales de la 2è partie soutenues par le répondant (cf. les 6 variables_politiques_2) ~ info_CCC"
  label(s$prop_politiques_env) <- "prop_politiques_env: Proportion de politiques environnementales soutenues par le répondant = prop_referenda + prop_politiques_1 + prop_politiques_2 (cf. les 20 variables_politiques_env)"
  label(s$prop_referenda_politiques_2) <- "prop_referenda_politiques_2: Proportion de politiques environnementales de la 2è partie soutenues par le répondant = nb_referenda + nb_politiques_2 (cf. les 14 variables_politiques_2 et variables_referendum)"
  
  # TODO: obstacles, soutenu, devoile
  
  s <- s[, -c(9:17, 39:49, 131, 132, 134, 136, 137, 139)]
  return(s)
}
s <- prepare_s()

export_stats_desc(s, paste(getwd(), 'externe_stats_desc.csv', sep='/'))

# convert_s()
# prepare_s(exclude_screened=FALSE, exclude_speeder=FALSE, only_finished=T)
# sa <- s
# prepare_s()

weighting_s <- function(data, printWeights = T) { # cf. google sheet
  d <- data
  d$region[is.na(d$region)] <- 'autre'
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
    print(sum( weights(raked) )^2/(length(weights(raked))*sum(weights(raked)^2)) ) # <0.5 : problématique   
    print( length(which(weights(raked)<0.25 | weights(raked)>4))/ length(weights(raked)))
  }
  return(weights(trimWeights(raked, lower=0.25, upper=4, strict=TRUE)))
}

# exclude_speeder=TRUE;exclude_screened=TRUE; only_finished=TRUE; only_known_agglo=T; duree_max=630
prepare_s <- function(exclude_speeder=TRUE, exclude_screened=TRUE, only_finished=TRUE, only_known_agglo=T, duree_max=390) { # , exclude_quotas_full=TRUE
  s <- read_csv("../données/externe1.csv")[-c(1:2),]

  s <- relabel_and_rename(s)
  
  print(paste(length(which(s$exclu=="QuotaMet")), "QuotaMet"))
  s$fini[s$exclu=="QuotaMet" | is.na(s$revenu)] <- "False" # To check the number of QuotaMet that shouldn't have incremented the quota, comment this line and: decrit(s$each_strate[s$exclu=="QuotaMet" & s$csp=="Employé" & !grepl("2019-03-04 07", s$date)])
  # if (exclude_screened) { s <- s[is.na(s$exclu),] } # remove Screened TODO: seems to be TRUE/FALSE now
  if (exclude_speeder) { s <- s[as.numeric(as.vector(s$duree)) > duree_max,] } 
  # if (exclude_quotas_full) { s <- s[s[101][[1]] %in% c(1:5),]  } # remove those with a problem for the taille d'agglo
  # if (exclude_quotas_full) { s <- s[s$Q_TerminateFlag=="",]  } # remove those with a problem for the taille d'agglo
  if (only_finished) { s <- s[s$fini=="True",] }
  
  s <- convert_s(s) 
  
  s$sample <- "a"
  s$sample[s$fini=="True"] <- "e"
  s$sample[s$fini=="True" & n(s$duree) > duree_max] <- "p"
  s$sample[s$fini=="True" & n(s$duree) > duree_max & s$test_qualite=='Un peu'] <- "f" # "q"? excluded because out of quotas
  s$sample[s$fini=="True" & n(s$duree) > duree_max & s$exclu==""] <- "r"
  
  # s <- s[-which(is.element(s$id, s$id[duplicated(s$id)]) & !duplicated(s$id)),] # TODO: check duplicates

  s$weight <- weighting_s(s)
  
  s$gauche_droite_na <- as.numeric(s$gauche_droite)
  s$gauche_droite_na[s$indeterminate == T] <- wtd.mean(s$gauche_droite, weights = s$weight)
  
  return(s)
}

# sa <- prepare_s(exclude_screened=FALSE, exclude_speeder=FALSE, only_finished=T) # TODO: let only_finished = FALSE
# # se <- prepare_s(exclude_screened=FALSE, exclude_speeder=FALSE)
# # sp <- prepare_s(exclude_screened=FALSE)

s <- prepare_s()

export_stats_desc(s, paste(getwd(), 'externe_stats_desc.csv', sep='/'))
# 
# write.csv2(s, "survey_prepared.csv", row.names=FALSE)

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


# Pearson's chi-square test of equality of distributions
fq <- list()
fq[['sexe']] <- list(name=c("Féminin", "Masculin"), 
                     freq=c(0.516,0.484))
fq[['csp']] <- list(name=c("Inactif", "Ouvrier", "Cadre", "Indépendant", "Intermédiaire", "Retraité", "Employé", "Agriculteur"), 
                    freq=c(0.129,0.114,0.101,0.035,0.136,0.325,0.15,0.008))
fq[['region']] <- list(name=c("autre","ARA", "Est", "Nord", "IDF", "Ouest", "SO", "Occ", "Centre", "PACA"), 
                       freq=c(0.00001,0.12446,0.12848,0.09237,0.1902,0.10294,0.09299,0.09178,0.09853,0.07831))
fq[['age']] <- list(name=c("18-24", "25-34", "35-49", "50-64", "65+"), 
                    freq=c(0.120,0.150,0.240,0.240,0.250))
fq[['taille_agglo']] <- list(name=c(1:5), 
                             freq=c(0.2166,0.1710,0.1408,0.3083,0.1633))
fq[['diplome4']] <- list(name=c("Aucun diplôme ou brevet", "CAP ou BEP", "Baccalauréat", "Supérieur"), 
                         freq=c(0.290, 0.248, 0.169, 0.293))
for (v in c('sexe', 'age', 'csp', 'diplome4', 'taille_agglo', 'region')) {
  freq_sample <- c()
  for (i in fq[[v]]$name) freq_sample <- c(freq_sample, sum((s[[v]]==i))) # *s$weight
  print(paste(v, round(chisq.test(freq_sample, p = fq[[v]]$freq)$p.value, 3)))
} # Equality rejected at .01 except for sex and CSP

# TODO: pb cause_CC: la variante paraît pas 50/50