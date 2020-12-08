##### Socio-démos #####
length(intersect(e1$ip, e2$ip)) # seules deux personnes sont les mêmes que dans la vague 1 !
decrit(e2$diplome4, weight = F)
decrit(e1$diplome4, weight = F) # similar, though less CAP and more Bac in e2
decrit("diplome4", data=e2) 
decrit("diplome4", data=e1)
decrit("age", data=e2)
decrit("age", data=e1)
decrit(e2$age, weight = F)
decrit("age", weight = F, data=e1) 
decrit("csp", data=e1)
decrit("csp", data=e2)
decrit(e1$csp, weight = F)
decrit(e2$csp, weight = F)
decrit("sexe", data=e1)
decrit("sexe", data=e2)
decrit(e1$sexe, weight = F) 
decrit(e2$sexe, weight = F)
decrit(e1$region, miss=T)
decrit(e2$region, miss=T)
decrit(e1$region, weight = F, miss=T) 
decrit(e2$region, weight = F, miss=T)
sum(is.na(e2$region))
sum(is.na(e1$region))
decrit(e1$code_postal[is.na(e1$region)])
decrit(e2$code_postal[is.na(e2$region)])
decrit(e1$region_verif, weight = F, miss=T) 
decrit(e2$region_verif, weight = F, miss=T) # region_verif good
sum(e1$region_verif != e1$region, na.rm=T)
sum(e2$region_verif != e2$region, na.rm=T) 
decrit(e1$taille_agglo)
decrit(e2$taille_agglo)
decrit(e1$taille_agglo, weight = F)
decrit(e2$taille_agglo, weight = F)


###### Efforts relatifs #####
decrit(e$efforts_relatifs)
decrit(e$efforts_relatifs, which = e$variante_efforts_vous==1)
decrit(e$efforts_relatifs, which = e$variante_efforts_vous==0)
summary(lm(efforts_relatifs ~ variante_efforts_vous, data=e, weights = e$weight)) # +1***


##### Politiques env ~ info_CCC #####
decrit(round(e1$prop_referenda_politiques_2, 3), data=e1) # TODO: image
decrit(round(e2$prop_referenda_politiques_2, 3), data=e2)
summary(lm(prop_referenda_politiques_2 ~ info_CCC, data=e1, weights = e1$weight)) # 0.03*
summary(lm(prop_referenda_politiques_2 ~ info_CCC, data=e2, weights = e2$weight)) # 0.03*


##### Opinions politiques #####
decrit("Gilets_jaunes", data=e1)
decrit("Gilets_jaunes", data=e2)


##### Obstacles #####
# pb: ne peut être utilisé que pour comparabilité. Le résultat en soit est biaisé car l'ordre des items n'a pas été randomisé.
decrit(e$obstacle_1) # lobbies 38%
decrit(e$obstacle_2) # manque_volonte 27%, manque_cooperation 27%
decrit(e$obstacle_3) # manque_cooperation 23%, manque_volonte 19%
decrit(e$obstacle_4) # inegalites 20%, demographie 18%
decrit(e$obstacle_5) # incertitudes 21%, technologies 18%, demographie 18%
decrit(e$obstacle_6) # incertitudes 24%, demographie 21%
decrit(e$obstacle_7) # technologies 24%, incertitudes 21%
decrit(e$obstacle_8) # rien de tout cela 67% (mais n = 50 au lieu de ~900)


##### Images e1 #####
labels_variables_politiques_1_long <- c()
for (v in variables_politiques_1) labels_variables_politiques_1_long <- c(labels_variables_politiques_1_long, sub(' - .*', '', sub('.*: ', '', Label(e1[[v]]))))
labels_variables_politiques_1_v1 <- c("Réduire le gaspillage alimentaire", "Obliger les cantines à proposer des menus verts", "Favoriser l'usage des véhicules peu polluants ou partagés", 
                                        "Densifier les villes", "Développer les énergies renouvelables", "Taxer l'acheminement polluant des marchandises")
# (politiques_1 <- barres(title="", data=dataKN(variables_politiques_1, miss=FALSE, rev = T),  thin=T, 
#        nsp=FALSE, labels=labels_variables_politiques_1, legend = dataN(variables_politiques_1[1], return="legend", rev_legend = T), show_ticks=T))
(politiques_1_v1 <- barres(vars = variables_politiques_1, miss=FALSE,  labels=labels_variables_politiques_1))
save_plotly(politiques_1_v1) 

(politiques_1_en_v1 <- barres(vars = variables_politiques_1, miss=FALSE,  labels=labels_variables_politiques_1_en, legend = c("Very", "Rather", "Rather not", "Not at all")))
save_plotly(politiques_1_en_v1) 

labels_variables_politiques_2_long <- c()
for (v in variables_politiques_2) labels_variables_politiques_2_long <- c(labels_variables_politiques_2_long, sub(' - .*', '', sub('.*: ~ ', '', Label(e1[[v]]))))
labels_variables_politiques_2 <- c("Renforcement du bonus/malus", "Subventions au train", "Contribution à un fonds mondial", "Taxe sur la viande rouge", 
                                   "Conditionnement des aides à l'innovation au bilan carbone", "Interdiction des véhicules polluants dans les centre-villes", 
                                   "Limitation de la vitesse sur autoroutes à 110 km/h", "Obligation de rénovation thermique assortie d'aides de l'État")
(politiques_2_v1 <- barres(vars = variables_politiques_2, miss=FALSE, labels=labels_variables_politiques_2))
save_plotly(politiques_2_v1)

labels_variables_politiques_2_en <- c("Reinforcement of the bonus/malus", "Train subsidies", "Contribution to a global fund", "Red meat tax", "Conditioning of innovation aid to a carbon balance", "Ban on polluting vehicles in city centers", "Limiting speed on freeways to 110 km/h", "Obligation of thermal renovation\n accompanied by State aid")
(politiques_2_en_v1 <- barres(vars = variables_politiques_2, miss=FALSE, labels=labels_variables_politiques_2_en, legend = c("Completely", "Rather", "Indifferent/NR", "Not really", "Not at all")))
save_plotly(politiques_2_en_v1)

labels_variables_referendum_long <- c()
for (v in variables_referendum) labels_variables_referendum_long <- c(labels_variables_referendum_long, sub(' - .*', '', sub('.*: ~ ', '', Label(e1[[v]]))))
labels_variables_referendum <- c("Obligation de rénovation thermique assortie d'aides de l'État", "Chèque alimentaire aux plus démunis pour AMAP et bio", 
                                 "Interdiction de la publicité des produits polluants", "Interdiction dès 2025 des véhicules neufs les plus polluants", 
                                 "Taxe de 4% sur les dividendes des grandes entreprises\n finançant la transition", "Système de consigne de verre et plastique")
(referendum_v1 <- barres(vars = variables_referendum, miss=T, labels=labels_variables_referendum))
save_plotly(referendum_v1)

labels_variables_referendum_en <- c("Obligation of thermal renovation accompanied by State aid", "Food voucher to the poorest for CSA and bio", "Ban on advertising of polluting products", "Ban from 2025 of the most polluting new vehicles", "Tax of 4% on dividends from large companies\n to finance the transition", "Deposit system for glass and plastic")
(referendum_en_v1 <- barres(vars = variables_referendum, miss=T, labels=labels_variables_referendum_en, legend=c("Yes", "Blank", "No", "NR")))
save_plotly(referendum_en_v1)

# variables_politiques_c <- c("pour_vitesse_110", "pour_taxe_avions", "pour_obligation_renovation", "pour_compteurs_intelligents", "pour_taxe_distance", "pour_taxe_carbone", "pour_renouvelables", "pour_densification", "pour_taxe_vehicules", "pour_voies_reservees", "pour_cantines_vertes", "pour_fin_gaspillage")
variables_politiques_c <- names(c)[375:386] #sub('_1e', '', names(c)[49:60])
# labels_politiques_c <- c()
# for (v in variables_politiques_c) labels_politiques_c <- c(labels_politiques_c, sub('.*: ', '', sub(' -.*', '', Label(c[[paste(v, '1e', sep='_')]]))))
labels_politiques_c <- c("Abaisser la vitesse limite sur autoroute à 110 km/heure", "Taxer le transport aérien pour favoriser le transport par train", 
                         "Obliger les propriétaires à rénover et à isoler\n les logements lors d'une vente ou d'une location", " Installer dans les foyers des compteurs électriques qui analysent les \nconsommations pour permettre aux gens des faire des économies d'énergie",
                         "Augmenter le prix des produits de consommation \nqui sont acheminés par des modes de transport polluants", "Augmenter la taxe carbone",
                         "Développer les énergies renouvelables même si, dans certains cas,\n les coûts de production sont plus élevés, pour le moment", "Densifier les villes en limitant l'habitat\n pavillonnaire au profit d'immeubles collectifs",
                         "Taxer les véhicules les plus émetteurs de gaz à effet de serre", "Favoriser l'usage (voies de circulation, place de stationnement réservées)\n des véhicules peu polluants ou partagés (covoiturage)",
                         "Obliger la restauration collective publique à proposer\n une offre de menu végétarien, biologique et/ou de saison", "Réduire le gaspillage alimentaire de moitié")
(politiques_c2 <- barres(vars = variables_politiques_c, df = c, miss=F, labels=labels_politiques_c))
save_plotly(politiques_c2_v1) # TODO renommer CCC

(politiques_c1 <- barres(vars = variables_politiques_1, df = c, miss=F, labels=labels_variables_politiques_1))
save_plotly(politiques_c1) 

labels_variables_politiques_1_en <- c("Reducing food waste", "Obliging canteens to offer green menus", "Encouraging the use of \nlow-polluting or shared vehicles", "Densifying cities", "Developing renewable energies", "Taxing the polluting transport of goods")
(politiques_c1_en <- barres(vars = variables_politiques_1, df = c, miss=F, labels=labels_variables_politiques_1_en, legend = c("Very", "Rather", "Rather not", "Not at all")))
save_plotly(politiques_c1_en) 

labels_variables_devoile_long <- c()
for (v in variables_devoile) labels_variables_devoile_long <- c(labels_variables_devoile_long, sub(' - .*', '', sub('.*]', '', Label(e1[[v]]))))
labels_variables_devoile <- c("Obligation de rénovation thermique + aides de l'État (V)", "Limitation de la vitesse sur autoroutes à 110 km/h (F)", 
                                 "Contribution à un fonds mondial (F)", "Taxe sur la viande rouge (F)")
(devoile_v1 <- barres(vars = variables_devoile, miss=F, labels=labels_variables_devoile))
save_plotly(devoile_v1)

(confiance_sortition_v1 <- barres(vars = "confiance_sortition", miss = F, labels="Confiance dans la capacité de citoyens tirés au sort \nà délibérer de manière productive sur des questions politiques complexes"))
save_plotly(confiance_sortition_v1)

(confiance_sortition_CCC <- barres(vars = "confiance_sortition", df = c, miss = F, labels="Confiance dans la capacité de citoyens tirés au sort \nà délibérer de manière productive sur des questions politiques complexes"))
save_plotly(confiance_sortition_CCC)

# (confiance_sortition_both <- barres(data=dataN2("confiance_sortition", miss = F), sort = F, miss = F, rev_color = T, labels = c('CCC', 'Population (PSE)'), legend=dataN2("confiance_sortition", miss = F, return = 'legend')))
# save_plotly(confiance_sortition_both)
# 
# (confiance_sortition_both_en <- barres(data=dataN2("confiance_sortition", miss = F), sort = F, miss = F, rev_color = T, labels = c('CCC', 'Population (PSE)'), legend=c("Not at all confident", "Rather not confident", "Rather confident", "Completely confident")))
# save_plotly(confiance_sortition_both_en)

(pour_sortition_v1 <- barres(vars = "pour_sortition", miss = T, rev=F, thin=F, labels="Pour une assemblée constituée de 150 citoyens tirés au sort, \ndotée d'un droit de veto sur les textes votés au Parlement"))
save_plotly(pour_sortition_v1)

(connait_CCC_v1 <- barres(vars = "connait_CCC", miss = F, labels="Avez-vous entendu parler de \nla Convention Citoyenne pour le Climat ?"))
save_plotly(connait_CCC_v1)

(Connaissance_CCC_v1 <- barres(vars = "Connaissance_CCC", miss = F, labels="Connaissance de la Convention Citoyenne pour le Climat\n (évaluation du champ libre demandant de la décrire)"))
save_plotly(Connaissance_CCC_v1)

(sait_CCC_devoilee_v1 <- barres(vars = "sait_CCC_devoilee", miss = F, labels="Des mesures proposées par la Convention \nCitoyenne pour le Climat ont déjà été dévoilées"))
save_plotly(sait_CCC_devoilee_v1)

(gilets_jaunes_v1 <- barres(vars = "gilets_jaunes", miss = T, labels="Que pensez-vous des gilets jaunes ?"))
save_plotly(gilets_jaunes_v1)

(gauche_droite_v1 <- barres(vars = "gauche_droite", miss = F, labels="Comment vous définiriez-vous ?", rev=F, rev_color = T))
save_plotly(gauche_droite_v1) 
(gauche_droite_nsp_v1 <- barres(vars = "gauche_droite_nsp", miss = T, labels="Comment vous définiriez-vous ?", rev=F, rev_color = T))
save_plotly(gauche_droite_nsp_v1) 

(confiance_gouvernement_v1 <- barres(vars = "confiance_gouvernement", miss = T, labels="En général, faites-vous confiance au gouvernement\n pour prendre de bonnes décisions ?"))
save_plotly(confiance_gouvernement_v1) 

(interet_politique_v1 <- barres(vars = "interet_politique", miss = F, labels="À quel point êtes-vous intéressé·e par la politique ?"))
save_plotly(interet_politique_v1) 

(gagnant_categorie_v1 <- barres(vars = "gagnant_categorie", miss = F, labels="Suite à une taxe carbone avec dividende, vous seriez ...", rev=F))
save_plotly(gagnant_categorie_v1) 

data_gagnant_by_confiance_div <- cbind(dataN("gagnant_categorie", data = e1[which(e1$confiance_dividende=="Oui"),]), dataN("gagnant_categorie", data = e1[which(e1$confiance_dividende=="À moitié"),]), dataN("gagnant_categorie", data = e1[which(e1$confiance_dividende=="Non"),]))
(gagnant_by_confiance_div <- barres(data = data_gagnant_by_confiance_div[3:1,], sort=F, thin=T, miss = F, rev = F, labels=rev(c("Catégorie de gain subjectif lorsque\n la confiance dans le dividende est... Non", "... À moitié", "... Oui")), legend=c("Gagnant", "Non affecté", "Perdant")))
save_plotly(gagnant_by_confiance_div)

data_gagnant_by_confiance_div_all <- cbind(data_gagnant_by_confiance_div, dataN("gagnant_categorie", data = e1))
(gagnant_by_confiance_div_all <- barres(data = data_gagnant_by_confiance_div_all[3:1,], sort=F, thin=T, miss = F, labels=rev(c("Catégorie de gain subjectif\n toute réponses confondues", "lorsque la confiance dans le dividende est\n ... Non", "... À moitié", "... Oui")), legend=c("Gagnant", "Non affecté", "Perdant"), rev = F))
save_plotly(gagnant_by_confiance_div_all)

data_gagnant_by_Certitude_gagnant <- cbind(dataN("gagnant_categorie", data = e1[which(e1$Certitude_gagnant=="Pas sûr"),]), dataN("gagnant_categorie", data = e1[which(e1$Certitude_gagnant=="Moyennement sûr"),]), dataN("gagnant_categorie", data = e1[which(e1$Certitude_gagnant=="Sûr"),]), dataN("gagnant_categorie", data = e1))
(gagnant_by_Certitude_gagnant <- barres(data = data_gagnant_by_Certitude_gagnant[3:1,], sort=F, thin=T, miss = F, rev = F, labels=rev(c("Catégorie de gain subjectif", "lorsque le répondant en est... Sûr", "... Moyennement sûr", "... Pas sûr")), legend=c("Gagnant", "Non affecté", "Perdant")))
save_plotly(gagnant_by_Certitude_gagnant)

(certitude_gagnant_v1 <- barres(vars = "certitude_gagnant", miss = F, labels="Degré de certitude à la cagéorie gagnant/perdant"))
save_plotly(certitude_gagnant_v1) 

(taxe_approbation_v1 <- barres(vars = "taxe_approbation", thin=F, miss = T, labels="Approbation d'une taxe avec dividende\n", rev = F))
save_plotly(taxe_approbation_v1) 

data_approbation_by_confiance_div <- cbind(dataN("taxe_approbation", data = e1[which(e1$confiance_dividende=="Oui"),]), dataN("taxe_approbation", data = e1[which(e1$confiance_dividende=="À moitié"),]), dataN("taxe_approbation", data = e1[which(e1$confiance_dividende=="Non"),]))
(approbation_by_confiance_div <- barres(data = data_approbation_by_confiance_div, sort=F, thin=T, miss = T, labels=rev(c("Approbation d'une taxe avec dividende lorsque\n la confiance dans le dividende est: Non", "... À moitié", "... Oui")), legend=c("Oui ", "Non", "NSP"), rev = F))
save_plotly(approbation_by_confiance_div)

data_approbation_by_confiance_div_all <- cbind(data_approbation_by_confiance_div, dataN("taxe_approbation", data = e1))
(approbation_by_confiance_div_all <- barres(data = data_approbation_by_confiance_div_all, sort=F, thin=T, miss = T, labels=rev(c("Approbation d'une taxe avec dividende\n toutes réponses confondues", "lorsque la confiance dans le dividende est\n ... Non", "... À moitié", "... Oui")), legend=c("Oui ", "Non", "NSP"), rev = F))
save_plotly(approbation_by_confiance_div_all)

(confiance_dividende_v1 <- barres(vars = "confiance_dividende", miss = F, labels="Confiance dans le fait que l'État versera le dividende"))
save_plotly(confiance_dividende_v1) 

(confiance_dividende_en <- barres(vars = "confiance_dividende", miss = F, labels="Trusts that the State will pay the dividend", legend=c("Yes", "Half", "No")))
save_plotly(confiance_dividende_en) 

(trop_impots_v1 <- barres(vars = "trop_impots", miss = T, labels="Paie-t-on trop d'impôt en France ?"))
save_plotly(trop_impots_v1) 

(problemes_invisibilises_v1 <- barres(vars = "problemes_invisibilises", miss = F, rev=F, labels="Se sent confronté à des difficultés ignorées\n des pouvoirs publics et des médias"))
save_plotly(problemes_invisibilises_v1) 

(problemes_invisibilises_CCC_v1 <- barres(vars = "problemes_invisibilises", df = c, miss = F, labels="Se sent confronté à des difficultés ignorées\n des pouvoirs publics et des médias"))
save_plotly(problemes_invisibilises_CCC_v1)

(problemes_invisibilises_both_v1 <- barres(data=dataN2("problemes_invisibilises", miss = F), miss = F, sort = F, rev_color = T, labels = c('CCC', 'Population (PSE)'), legend=dataN2("problemes_invisibilises", miss = F, return = 'legend')))
save_plotly(problemes_invisibilises_both_v1) # « Condi^ons de vie et aspira^ons », CREDOC, janvier 2019: donne 58% d'invisibilisés (contre 61% ici)

(problemes_invisibilises_both_en_v1 <- barres(data=dataN2("problemes_invisibilises", miss = F), miss = F, sort = F, rev_color = T, labels = c('CCC', 'Population (PSE)'), legend=c("Never", "Not often", "Quite often", "Very often")))
save_plotly(problemes_invisibilises_both_en_v1) # « Condi^ons de vie et aspira^ons », CREDOC, janvier 2019: donne 58% d'invisibilisés (contre 61% ici)

(confiance_gens2_v1 <- barres(vars = "confiance_gens", miss = F, labels="Confiance dans les autres"))
save_plotly(confiance_gens2_v1) 

(confiance_gens_CCC_v1 <- barres(vars = "confiance_gens", df = c, miss = F, labels="Confiance dans les autres"))
save_plotly(confiance_gens_CCC_v1)

(confiance_gens_both <- barres(data=dataN2("confiance_gens", miss = F), miss = F, sort = F, rev_color = T, labels = c('CCC', 'Population'), legend=dataN2("confiance_gens", miss = F, return = 'legend')))
save_plotly(confiance_gens_both)

(confiance_gens_both_en <- barres(data=dataN2("confiance_gens", miss = F), fr = F, miss = F, sort = F, rev_color = T, labels = c('CCC', 'Population'), legend=c("Mistrust", "Trust")))
save_plotly(confiance_gens_both_en)

# /!\ gros écart entre sondage Cevipof et Bilendi : comment ça se fait ??
confiance_gens_cevipof <- dataN2("confiance_gens", miss = F) 
confiance_gens_cevipof[,2] <- c(0.65, 0.35) # baromètre confiance Cevipof avril 2020 toplot
(confiance_gens_both_cevipof <- barres(data=confiance_gens_cevipof, miss = F, sort = F, rev_color = T, labels = c('CCC', 'Population'), legend=dataN2("confiance_gens", miss = F, return = 'legend')))
save_plotly(confiance_gens_both_cevipof)

(confiance_gens_triple <- barres(data=cbind(dataN2("confiance_gens", miss = F), c(0.65, 0.35)), miss = F, sort = F, rev_color = T, labels = c('CCC', 'Population (PSE)', 'Population (Cevipof 04/2020)'), legend=dataN2("confiance_gens", miss = F, return = 'legend')))
save_plotly(confiance_gens_triple) # toplot!

(confiance_gens_triple_en <- barres(data=cbind(dataN2("confiance_gens", miss = F), c(0.65, 0.35)), miss = F, sort = F, rev_color = T, labels = c('CCC', 'Population (PSE)', 'Population (Cevipof 04/2020)'), legend=c("Mistrust", "Trust"), fr = F))
save_plotly(confiance_gens_triple_en) # toplot!

(efforts_relatifs_v1 <- barres(vars = "efforts_relatifs", miss = F, labels="Prêt à faire plus d'efforts que la majorité \ndes Français contre le changement climatique"))
save_plotly(efforts_relatifs_v1) 

(parle_CC_v1 <- barres(vars = "parle_CC", miss = F, labels="À quelle fréquence parlez-vous du changement climatique ?"))
save_plotly(parle_CC_v1) 

(issue_CC_v1 <- barres(vars = "issue_CC", miss = F, labels="Le changement climatique sera limité \nà un niveau acceptable d'ici la fin du siècle"))
save_plotly(issue_CC_v1) 

(issue_CC_CCC <- barres(vars = "issue_CC", df = c, miss = F, labels="Le changement climatique sera limité \nà un niveau acceptable d'ici la fin du siècle"))
save_plotly(issue_CC_CCC)

(issue_CC_both <- barres(data=dataN2("issue_CC", miss = F), miss = F, sort = F, rev_color = T, labels = c('CCC', 'Population'), legend=dataN2("issue_CC", miss = F, return = 'legend')))
save_plotly(issue_CC_both)

data_issue_ademe <- dataN2("issue_CC", miss = F)
data_issue_ademe1[,2] <- c(13, 50, 31, 5)/99
(issue_CC_both_ademe <- barres(data=data_issue_ademe, miss = F, sort = F, rev_color = T, labels = c('CCC', 'Population'), legend=dataN2("issue_CC", miss = F, return = 'legend')))
save_plotly(issue_CC_both_ademe) # ADEME octobre 2019 toplot

(issue_CC_triple <- barres(data=cbind(dataN2("issue_CC", miss = F), c(13, 50, 31, 5)/99), miss = F, sort = F, rev_color = T, labels = c('CCC', 'Population (PSE)', 'Population (ADEME)'), legend=dataN2("issue_CC", miss = F, return = 'legend')))
save_plotly(issue_CC_triple) # ADEME octobre 2019 toplot!

(issue_CC_triple_en <- barres(data=cbind(dataN2("issue_CC", miss = F), c(13, 50, 31, 5)/99), miss = F, sort = F, rev_color = T, labels = c('CCC', 'Population (PSE)', 'Population (ADEME)'), legend=c("No, certainly not", "No, probably not", "Yes, probably", "Yes, certainly")))
save_plotly(issue_CC_triple_en) # ADEME octobre 2019 toplot!

(effets_CC_CCC2_v1 <- barres(vars = "effets_CC_CCC", miss = F, rev = F, labels="Quelles seront les conséquences en France d'ici 50 ans ?"))
save_plotly(effets_CC_CCC2_v1) 

(effets_CC_CCC_CCC <- barres(vars = "effets_CC_CCC", df = c, miss = F, rev = F, labels="Quelles seront les conséquences en France d'ici 50 ans ?"))
save_plotly(effets_CC_CCC_CCC)

(effets_CC_CCC_both <- barres(data=dataN2("effets_CC_CCC", miss = F), miss = F, sort = F, labels = c('CCC', 'Population'), legend=dataN2("effets_CC_CCC", miss = F, return = 'legend')))
save_plotly(effets_CC_CCC_both)

(effets_CC_CCC_both_en <- barres(data=dataN2("effets_CC_CCC", miss = F), miss = F, sort = F, labels = c('CCC', 'Population'), legend=c("Positive effects", "Adaptation without problem", "Extremely strenuous")))
save_plotly(effets_CC_CCC_both_en)

(effets_CC_CCC_both_ademe <- barres(data=cbind(dataN("effets_CC_CCC", miss = F), c(0.02, 0.32, 0.65)/0.99), miss = F, sort = F, labels = c('CCC', 'Population'), legend=dataN2("effets_CC_CCC", miss = F, return = 'legend')))
save_plotly(effets_CC_CCC_both_ademe) # ADEME 2019 toplot

(effets_CC_CCC_triple <- barres(data=cbind(dataN2("effets_CC_CCC", miss = F), c(0.02, 0.32, 0.65)/0.99), miss = F, sort = F, labels = c('CCC', 'Population (PSE)', 'Population (ADEME)'), legend=dataN2("effets_CC_CCC", miss = F, return = 'legend')))
save_plotly(effets_CC_CCC_triple) # ADEME 2019 toplot!

(effets_CC_AT_v1 <- barres(vars = "effets_CC_AT", rev = F, miss = T, labels="Effets du changement climatique, \nsi rien n'est fait pour le limiter ?"))
save_plotly(effets_CC_AT_v1) 

(cause_CC_CCC2_v1 <- barres(vars = "cause_CC_CCC", miss = F, labels="Cause du changement climatique"))
save_plotly(cause_CC_CCC2_v1)

(cause_CC_CCC_CCC <- barres(vars = "cause_CC_CCC", df = c, miss = F, labels="Cause du changement climatique"))
save_plotly(cause_CC_CCC_CCC)

(cause_CC_CCC_both <- barres(data=dataN2("cause_CC_CCC", miss = F, rev = T), miss = F, sort = F, labels = c('CCC', 'Population (PSE)'), legend=rev(dataN2("cause_CC_CCC", miss = F, return = 'legend'))))
save_plotly(cause_CC_CCC_both)

(cause_CC_CCC_both_en <- barres(data=dataN2("cause_CC_CCC", miss = F, rev = T), miss = F, sort = F, labels = c('CCC', 'Population (PSE)'), legend=c("Only anthropogenic", "Mostly anthropogenic", "As much", "Mostly natural", "Only natural", "Does not exist")))
save_plotly(cause_CC_CCC_both_en)

(France_CC2_v1 <- barres(vars = "France_CC", thin = F, miss = F, labels="La France doit prendre de l'avance \nsur d'autres pays dans la lutte contre le changement climatique"))
save_plotly(France_CC2_v1) 

(France_CC_CCC <- barres(vars = "France_CC", df = c, thin = F, miss = F, labels="La France doit prendre de l'avance \nsur d'autres pays dans la lutte contre le changement climatique"))
save_plotly(France_CC_CCC)

(France_CC_both <- barres(data=dataN2("France_CC", miss=F, rev = T), miss = F, sort = F, labels = c('CCC', 'Population (PSE)'), legend=rev(dataN2("France_CC", return = 'legend', miss=F))))
save_plotly(France_CC_both)

(France_CC_both_en <- barres(data=dataN2("France_CC", miss=F, rev = T), miss = F, sort = F, labels = c('CCC', 'Population (PSE)'), legend=c("Yes", "NR", "No")))
save_plotly(France_CC_both_en)

(echelle_politique_CC2_v1 <- barres(vars = "echelle_politique_CC", thin = F, rev = F, miss = F, labels="Le changement climatique exige\n d'être pris en charge par des politiques ..."))
save_plotly(echelle_politique_CC2_v1) 

(echelle_politique_CC_CCC <- barres(vars = "echelle_politique_CC", df = c, thin = F, rev = F,  miss = F, labels="Le changement climatique exige\n d'être pris en charge par des politiques ..."))
save_plotly(echelle_politique_CC_CCC)

(echelle_politique_CC_both <- barres(data=dataN2("echelle_politique_CC", miss = F), miss = F, sort = F, labels = c('CCC', 'Population (PSE)'), legend=dataN2("echelle_politique_CC", miss = F, return = 'legend')))
save_plotly(echelle_politique_CC_both)

(echelle_politique_CC_both_en <- barres(data=dataN2("echelle_politique_CC", miss = F), miss = F, sort = F, labels = c('CCC', 'Population (PSE)'), legend=c("At all scales", "Global", "European", "National", "Local")))
save_plotly(echelle_politique_CC_both_en)

(patrimoine_v1 <- barres(vars = "patrimoine", rev = F, rev_color = T, miss = T, labels="Patrimoine net du ménage"))
save_plotly(patrimoine_v1) 

(redistribution2_v1 <- barres(vars = "redistribution", rev = F, miss = F, labels="Il faudrait prendre aux riches pour donner aux pauvres"))
save_plotly(redistribution2_v1) 

(redistribution_CCC <- barres(vars = "redistribution", df = c, rev = F,  miss = F, labels="Il faudrait prendre aux riches pour donner aux pauvres"))
save_plotly(redistribution_CCC)

(redistribution_both <- barres(data=dataN2("redistribution", miss = F), rev = F,  miss = F, sort = F, labels = c('CCC', 'Population (PSE)'), legend=dataN2("redistribution", miss = F, return = 'legend')))
save_plotly(redistribution_both)

(importance_v1 <- barres(vars = variables_importance, rev = F, rev_color = T, miss = F, labels=c("L'action sociale et associative", "La protection de l'environnement", "L'amélioration de mon niveau de vie et de confort")))
save_plotly(importance_v1) 

data_importance_CCC <- matrix(0, nrow = 11, ncol = 3)
for (i in 0:10) for (j in 1:3) data_importance_CCC[i+1, j] <- length(which(c[[paste(variables_importance1[j], '_1e', sep='')]]==i))/length(which(!is.na(c[[paste(variables_importance1[j], '_1e', sep='')]])))
(variables_importance_CCC_v1 <- barres(data = data_importance_CCC, rev = F,  rev_color = T, miss = F, legend = 0:10, labels=c("L'action sociale et associative", "La protection de l'environnement", "L'amélioration de mon niveau de vie et de confort")))
save_plotly(variables_importance_CCC_v1)

(importance_associatif_both <- barres(data=cbind(data_importance_CCC[,1], dataN("importance_associatif", miss = F)), rev = F, rev_color = T,  miss = F, sort = F, labels = c('CCC', 'Population (PSE)'), legend=0:10))
save_plotly(importance_associatif_both)

(importance_environnement_both <- barres(data=cbind(data_importance_CCC[,2], dataN("importance_environnement", miss = F)), rev = F, rev_color = T,  miss = F, sort = F, labels = c('CCC', 'Population (PSE)'), legend=0:10))
save_plotly(importance_environnement_both)

(importance_confort_both <- barres(data=cbind(data_importance_CCC[,3], dataN("importance_confort", miss = F)), rev = F, rev_color = T,  miss = F, sort = F, labels = c('CCC', 'Population (PSE)'), legend=0:10))
save_plotly(importance_confort_both)

labels_responsible <- c("Each one of us", "Governments", "Certain foreign countries", "The richest", "Natural causes", "Past generations")
labels_responsable <- c("Chacun d'entre nous", "Les gouvernements", "Certains pays étrangers", "Les plus riches", "Des causes naturelles", "Les générations passées")
# barres(file="CC_responsible", data=data1(variables_responsable_CC), miss=F, rev = F, sort=T, showLegend=FALSE, labels=labels_responsable, hover=labels_responsable)
(responsable_CC_v1 <- barres(vars = variables_responsable_CC, rev = F, miss = F, showLegend=F, labels=labels_responsable, hover=labels_responsable))
save_plotly(responsable_CC_v1) 

labels_CCC_avis_long <- c()
for (v in variables_CCC_avis) labels_CCC_avis_long <- c(labels_CCC_avis_long, sub(' - .*', '', sub('.*: ', '', Label(e1[[v]]))))
(CCC_avis_v1 <- barres(vars = variables_CCC_avis, rev = F, miss = F, showLegend=F, labels=labels_CCC_avis_long))
save_plotly(CCC_avis_v1) 

labels_qualite_enfant <- c()
for (v in variables_qualite_enfant) labels_qualite_enfant <- c(labels_qualite_enfant, sub(' - .*', '', sub('.*: ', '', Label(e1[[v]]))))
(qualite_enfant2_v1 <- barres(vars = variables_qualite_enfant, rev = F, miss = F, showLegend=F, labels=labels_qualite_enfant))
save_plotly(qualite_enfant2_v1) 

(qualite_enfant_CCC <- barres(vars = variables_qualite_enfant, df = c, rev = F, weights = F, miss = F, showLegend=F, labels=labels_qualite_enfant))
save_plotly(qualite_enfant_CCC) 

data_qualite_enfant <- matrix(NA, ncol = length(variables_qualite_enfant), nrow = 2)
c$qualite_enfant_foi <- c$qualite_enfant_foi_1e
for (j in 1:length(variables_qualite_enfant)) data_qualite_enfant[1,j] <- length(which(c[[variables_qualite_enfant[j]]]==T))/length(which(!is.na(c[[variables_qualite_enfant[j]]])))
for (j in 1:length(variables_qualite_enfant)) data_qualite_enfant[2,j] <- sum(e1$weight[e1[[variables_qualite_enfant[j]]]==T])/sum(e1$weight)
(qualite_enfant_both <- barres(data = data_qualite_enfant, grouped = T, rev = F, miss=F, labels=labels_qualite_enfant, legend = c('CCC', 'Population (PSE)')))
save_plotly(qualite_enfant_both) 

labels_qualite_enfant_en <- c("Independence", "Tolerance and respect for others", "Generosity", "Assiduity at work", "The sense of saving", "Obedience", "Responsibility", "Determination and perseverance", "Self-expression", "Imagination", "Religious faith")
(qualite_enfant_both_en <- barres(data = data_qualite_enfant, grouped = T, rev = F, miss=F, labels=labels_qualite_enfant_en, legend = c('CCC', 'Population (PSE)')))
save_plotly(qualite_enfant_both_en) 

(cause_CC_AT_v1 <- barres(vars = "cause_CC_AT", miss = T, rev = F, labels="Cause du changement climatique"))
save_plotly(cause_CC_AT_v1)
decrit(b$cause_CC, data = b)
decrit(b$cause_CC) # part anthropique objective : ~ 75%

plot(Ecdf(e1$part_anthropique)$x, Ecdf(e1$part_anthropique)$y, type='s', xlab='Pourcentage estimé de Français estimant que le changement climatique est anthropique', ylab='Proportion < x') + grid()
data_anthropique_v1 <- (rbind(length(which(e1$part_anthropique <= 45)), length(which(e1$part_anthropique %between% c(46, 55))), length(which(e1$part_anthropique %between% c(56, 65))), length(which(e1$part_anthropique %between% c(66, 75))), length(which(e1$part_anthropique >75)))/nrow(e))
(part_anthropique_v1 <- barres(data = data_anthropique_v1, rev = F, rev_color = T,  miss = F, sort = F, labels = "Part des Français considérant que \nle changement climatique est anthropique ?", legend=c("Moins de 45%", "De 46 à 55%", "De 56 à 65%", "De 66 à 75%", "Plus de 75%")))
save_plotly(part_anthropique_v1)

data_taxe_carbone_v1 <- cbind(dataN("pour_taxe_carbone", data = e1[e1$variante_taxe_carbone=='pour',]), dataN("pour_taxe_carbone", data = e1[e1$variante_taxe_carbone=='contre',]), dataN("pour_taxe_carbone", data = e1[e1$variante_taxe_carbone=='neutre',]))
(pour_taxe_carbone2_v1 <- barres(data = data_taxe_carbone_v1, rev = F, miss = T, sort = F, labels = c("Favorable à une augmentation de la taxe carbone\nVariante: sachant qu'une majorité de Français est pour", "Favorable à une augmentation de la taxe carbone\nVariante: sachant qu'une majorité de Français est contre", "Favorable à une augmentation de la taxe carbone\nVariante: sans information"), legend=c('Oui', 'Non', 'NSP')))
save_plotly(pour_taxe_carbone2_v1) 

(pour_taxe_carbone_neutre_v1 <- barres(vars = "pour_taxe_carbone", df = e1[e1$variante_taxe_carbone=='neutre',], rev = F, thin = F, miss = T, sort = F, labels = c("Favorable à une augmentation de la taxe carbone\nVariante: sans information")))
save_plotly(pour_taxe_carbone_neutre_v1)

(pro_tax_carbon <- barres(vars = "taxe_approbation", df = e1, rev = F, thin = F, miss = T, sort = F, labels = c("Favorable to a carbon tax and dividend"), legend = c("Yes", "No", "PNR")))
save_plotly(pro_tax_carbon) # TODO here Yes/No works btw

# labels_solution <- c()
# for (v in variables_solution) labels_solution <- c(labels_solution, sub(' - .*', '', sub('.*: ', '', Label(e1[[v]]))))
labels_solution <- c("Le progrès technique permettra de trouver des\n solutions pour empêcher le changement climatique", "Il faudra modifier de façon importante nos \nmodes de vie pour empêcher le changement climatique", "C'est aux États de réglementer, \nau niveau mondial, le changement climatique", "Il n'y a rien à faire, \nle changement climatique est inévitable")
(solution_CC_v1 <- barres(vars = variables_solution, rev = F, miss = F, showLegend=F, labels=labels_solution))
save_plotly(solution_CC_v1) 

(solution_CC_CCC <- barres(vars = variables_solution, df = c, rev = F, weights = F, miss = F, showLegend=F, labels=labels_solution))
save_plotly(solution_CC_CCC) # /!\ Choix multiples dans externe mais pas dans CCC

data_solution <- matrix(NA, ncol = length(variables_solution), nrow = 2)
for (j in 1:length(variables_solution)) data_solution[1,j] <- length(which(c[[variables_solution[j]]]==T))/length(which(!is.na(c[[variables_solution[j]]])))
for (j in 1:length(variables_solution)) data_solution[2,j] <- sum(e1$weight[e1[[variables_solution[j]]]==T])/sum(e1$weight)
(solution_CC_both <- barres(data = data_solution, grouped = T, rev = F, miss=F, labels=labels_solution, legend = c('CCC', 'Population')))
save_plotly(solution_CC_both) # TODO! utiliser les données non _clean

data_solution_ademe <- data_solution
data_solution_ademe1[,2] <- c(11, 52, 19, 17)/99
(solution_CC_both_ademe <- barres(data = data_solution_ademe, grouped = T, rev = F, miss=F, labels=labels_solution, legend = c('CCC', 'Population')))
save_plotly(solution_CC_both_ademe) # ADEME octobre 2019 toplot

call$solution_CC_changer <- grepl('modifier nos modes de vie', call$s1_e_q19)
call$solution_CC_rien <- grepl('rien a fraire', call$s1_e_q19)
call$solution_CC_progres <- grepl('technique permettra de trouver des solutions', call$s1_e_q19)
call$solution_CC_traite <- grepl('est aux etats de reglementer au niveau mond', call$s1_e_q19)
call$solution_CC_changer[call$s1_e_q19==''] <- NA
call$solution_CC_progres[call$s1_e_q19==''] <- NA
call$solution_CC_traite1[call$s1_e_q19==''] <- NA
call$s1_e_q19[call$s1_e_q19==''] <- NA
data_solution_good <- data_solution
for (j in 1:length(variables_solution)) data_solution_good[1,j] <- length(which(call[[variables_solution[j]]]==T))/length(which(!is.na(call[[variables_solution[j]]])))

(solution_CC_triple <- barres(data = rbind(data_solution_good, c(11, 52, 19, 17)/99), color = color(4)[c(1,3,4)], grouped = T, rev = F, miss=F, labels=labels_solution, legend = c('CCC', 'Population (PSE)', 'Population (ADEME)')))
save_plotly(solution_CC_triple) # ADEME octobre 2019 toplot!

labels_solution_en <- c("Technological progress will make it possible to\n find solutions to prevent climate change", "It will be necessary to significantly modify \nour lifestyles to prevent climate change", "It is up to States to regulate\n climate change at the global level", "There is nothing to be done,\n climate change is inevitable")
(solution_CC_triple_en <- barres(data = rbind(data_solution_good, c(11, 52, 19, 17)/99), color = color(4)[c(1,3,4)], grouped = T, rev = F, miss=F, labels=labels_solution_en, legend = c('CCC', 'Population (PSE)', 'Population (ADEME)')))
save_plotly(solution_CC_triple_en) # ADEME octobre 2019 toplot!

labels_obstacles <- c()
for (v in variables_obstacles) labels_obstacles <- c(labels_obstacles, sub(' - .*', '', sub('[a-z_]*: ', '', Label(e1[[v]]))))
data_obstacles_e_v1 <- matrix(NA, nrow = 7, ncol = length(variables_obstacles))
for (j in 1:length(variables_obstacles)) for (i in 1:7) data_obstacles_e_v1[i,j] <- sum(e1$weight[e1[[variables_obstacles[j]]]==i], na.rm=T)/sum(e1$weight)
(obstacles_v1 <- barres(data = data_obstacles_e1[,c(5,7,6,4,2,3,1)], rev = F, miss = F, sort = F, showLegend=T, legend = 1:7, labels=labels_obstacles[c(5,7,6,4,2,3,1)])) # rev(1:7): ordre d'apparition dans questionnaire
save_plotly(obstacles_v1) 

data_obstacles_c <- matrix(NA, nrow = 7, ncol = length(variables_obstacles))
for (j in 1:length(variables_obstacles)) for (i in 1:7) data_obstacles_c[i,j] <- sum(c[[variables_obstacles[j]]]==i, na.rm=T)/sum(!is.na(c[[variables_obstacles[j]]]))
(obstacles_CCC <- barres(data = data_obstacles_c[,c(5,7,6,4,2,3,1)], rev = F, weights = F, sort = F, miss = F, showLegend=T, legend = 1:7, labels=labels_obstacles[c(5,7,6,4,2,3,1)]))
save_plotly(obstacles_CCC) 

data_obstacles_both <- matrix(NA, ncol = length(variables_obstacles), nrow = 2)
for (j in 1:length(variables_obstacles)) data_obstacles_both[1,j] <- length(which(c[[variables_obstacles[j]]]<=2))/length(which(!is.na(c[[variables_obstacles[j]]])))
for (j in 1:length(variables_obstacles)) data_obstacles_both[2,j] <- sum(e1$weight[e1[[variables_obstacles[j]]]<=2],na.rm=T)/sum(e1$weight)
(obstacles_both <- barres(data = data_obstacles_both, grouped = T, rev = F, miss=F, labels=labels_obstacles[1:7], legend = c('CCC', 'Population (PSE)')))
save_plotly(obstacles_both)

(obstacles_both_en <- barres(data = data_obstacles_both, grouped = T, rev = F, miss=F, labels=c("Lobbies", "Lack of political will", "Lack of cooperation between countries", "Inequalities", "Uncertainties of scientific community", "Demography", "Lack of alternative technologies"), legend = c('CCC', 'Population (PSE)')))
save_plotly(obstacles_both_en)

plot(Ecdf(e1$nb_politiques_env)$x, Ecdf(e1$nb_politiques_env)$y, type='s', xlab='Nombre de politiques environnementales soutenues', ylab='Proportion < x') + grid()
data_nb_politiques_env_v1 <- (rbind(length(which(e1$nb_politiques_env <= 6)), length(which(e1$nb_politiques_env %between% c(7, 8))), length(which(e1$nb_politiques_env == 9)), length(which(e1$nb_politiques_env == 10)), length(which(e1$nb_politiques_env >10)))/nrow(e))
(nb_politiques_env_v1 <- barres(data = data_nb_politiques_env_v1, rev = F, rev_color = T,  miss = F, sort = F, labels = "Nombre de politiques climatiques soutenues", legend=c("De 0 à 6", "7 ou 8", "9", "10", "11 ou 12")))
save_plotly(nb_politiques_env_v1)

data_satisfaction <- cbind(c(sum(dataN("satisfaction_vie_1e", c, miss = F)[1:3]), sum(dataN("satisfaction_vie_1e", c, miss = F)[4:6]), sum(dataN("satisfaction_vie_1e", c, miss = F)[7:10])), c(0.05, 0.33, 0.62))
(satisfaction_both <- barres(data=data_satisfaction, miss = F, sort = F, rev_color = T, labels = c('CCC', 'Population (Cevipof 06/2019)'), legend=c('1 à 3', '4 à 6', '7 à 10')))
save_plotly(satisfaction_both) # Cevipof Juin 2019 toplot
 
data_satisfaction <- cbind(c(sum(dataN("satisfaction_vie_1e", c, miss = F)[1:3]), sum(dataN("satisfaction_vie_1e", c, miss = F)[4:6]), sum(dataN("satisfaction_vie_1e", c, miss = F)[7:10])), c(0.05, 0.33, 0.62))
(satisfaction_both_en <- barres(data=data_satisfaction, miss = F, sort = F, rev_color = T, labels = c('CCC', 'Population (Cevipof 06/2019)'), legend=c('1 to 3', '4 to 6', '7 to 10')))
save_plotly(satisfaction_both_en) # Cevipof Juin 2019 toplot

data_causes_catastrophe <- cbind(dataN("cause_catastrophes_1e", c, miss = F), c(0.2, 0.2, 0.58, 0.02))
(causes_catastrophe <- barres(data=data_causes_catastrophe, miss = F, color = c(color(3), "#D3D3D3"), sort = F, rev_color = T, labels = c('CCC', 'Population (ADEME)'), legend=c("Personne n'est sûr", "Ont toujours eu lieu", "Dues au changement climatique", "NR")))
save_plotly(causes_catastrophe) # ADEME octobre 2019 toplot!!

(causes_catastrophe_en <- barres(data=data_causes_catastrophe, miss = F, color = c(color(3), "#D3D3D3"), sort = F, rev_color = T, labels = c('CCC', 'Population (ADEME)'), legend=c("Have always taken place", "No one is sure", "Due to climate change", "NR")))
save_plotly(causes_catastrophe_en) # ADEME octobre 2019 toplot!!

data_ecole <- cbind(dataN("ecole_2e", c[c$ecole_2e!="",], miss = F), c(0.41, 0.56, 0.03))
(ecole <- barres(data=data_ecole, miss = F, color = c(color(2), "#D3D3D3"), sort = F, rev_color = T, labels = c('CCC', 'Population (ADEME)'), legend=c("Discipline et effort", "Esprit éveillé et critique", "NR")))
save_plotly(ecole) # ADEME octobre 2019 toplot!!

(ecole_en <- barres(data=data_ecole, miss = F, color = c(color(2), "#D3D3D3"), sort = F, rev_color = T, labels = c('CCC', 'Population (ADEME)'), legend=c("Discipline and effort", "Sharp and critical mind", "NR")))
save_plotly(ecole_en) # ADEME octobre 2019 toplot!!

# data_appartenance <- cbind(dataN("appartenance_2e", c[c$appartenance_2e!="",], miss = F), c(39, 21, 16, 10, 6, 6, 2)/100) # TODO: bug (France absente)
# (appartenance <- barres(data=data_appartenance, miss = T, sort = F, rev_color = T, labels = c('CCC', 'Population'), legend=dataN("appartenance_2e", c[c$appartenance_2e!="",], miss = F, return = 'legend')))
data_appartenance <- cbind(c(31,3,4,29,1,11,0)/79, c(39, 21, 16, 10, 6, 6, 2)/100) #
(appartenance <- barres(data=data_appartenance1[c(2,5,3,7,1,6,4),], miss = F, sort = F, rev_color = T, labels = c('CCC', 'Population'), legend=c("la France", "ma commune, mon quartier", "ma région", "le monde", "mon département", "l'Europe", "un autre pays")[c(2,5,3,7,1,6,4)]))
save_plotly(appartenance) # ADEME octobre 2019 toplot

data_inegalite_repandue <- rbind(c(dataN("inegalite_repandue_2e", c[c$inegalite_repandue_2e!="",], miss = F)), c(11, 5, 7, 5, 6, 9, 40, 8, 8)/100)
(inegalite_repandue <- barres(data=data_inegalite_repandue, rev = F, miss = F, grouped = T, labels = dataN("inegalite_repandue_2e", c[c$inegalite_repandue_2e!="",], miss = F, return='legend'), legend=c('CCC', 'Population')))
save_plotly(inegalite_repandue) # baromètre opinion DREES 2018 toplot

data_inegalite_inacceptable <- rbind(c(0, dataN("inegalite_inacceptable_2e", c[c$inegalite_inacceptable_2e!="",], miss = F)), c(7, 8, 6, 10, 3, 8, 16, 22, 20)/100)
(inegalite_inacceptable <- barres(data=data_inegalite_inacceptable, rev = F, miss = F, grouped = T, labels = c("type d'emploi", dataN("inegalite_inacceptable_2e", c[c$inegalite_inacceptable_2e!="",], miss = F, return='legend')), legend=c('CCC', 'Population')))
save_plotly(inegalite_inacceptable) # baromètre opinion DREES 2018 toplot

data_inquietant_CC <- rbind(c(dataN("inquietant_CC_premier_2e", c[c$inquietant_CC_premier_2e!="",], miss = F), 0, 0, 0), c(52, 3, 11, 14, 12, 5, 3)/100)
(inquietant_CC <- barres(data=data_inquietant_CC, rev = F, miss = F, grouped = T, labels = c("catastrophe naturelle", "conflits entre états", "conflits sociaux", "température", "migrations", "maladies", "aucun"), legend=c('CCC', 'Population')))
save_plotly(inquietant_CC) # ADEME octobre 2019 toplot

data_cause_pauvrete <- cbind(dataN("cause_pauvrete_1e", c[!(c$cause_pauvrete_1e %in% c('NR', '')),], miss = F), c(0.63, 0.37))
(cause_pauvrete <- barres(data=data_cause_pauvrete, miss = F, sort = F, rev_color = T, labels = c('CCC', 'Population (Crédoc)'), legend=c("Pas eu de chance", "Pas fait d'effort")))
save_plotly(cause_pauvrete) # CREDOC janvier 2019 toplot /!\ 50% de non réponses dans la CCC toplot!

# TODO mais ne trouve pas la source: cause_pauvrete_1e (q12 p. 15), mieux_informe_1e (q11 p. 24), quand_preoccupation_CC_1e (q17 p. 28), 


##### Images e2 #####
(politiques_1_v2 <- barres(vars = variables_politiques_1, df=e2, miss=FALSE,  labels=labels_variables_politiques_1))
save_plotly(politiques_1_v2) 

(politiques_1_en_v2 <- barres(vars = variables_politiques_1, df=e2, miss=FALSE,  labels=labels_variables_politiques_1_en, legend = c("Very", "Rather", "Rather not", "Not at all")))
save_plotly(politiques_1_en_v2) 

(politiques_2_v2 <- barres(vars = variables_politiques_2, df=e2, miss=FALSE, labels=labels_variables_politiques_2))
save_plotly(politiques_2_v2) # TODO: comparer avant/après, et avec autres sondages externes (diigo CCC)

(politiques_2_en_v2 <- barres(vars = variables_politiques_2, df=e2, miss=FALSE, labels=labels_variables_politiques_2_en, legend = c("Completely", "Rather", "Indifferent/NR", "Not really", "Not at all")))
save_plotly(politiques_2_en_v2)

new_variables_referendum <- c("referendum_environnement_priorite_constit", "referendum_environnement_constitution", "referendum_ecocide") 
variables_referendum_v2 <- c(variables_referendum, new_variables_referendum)
labels_variables_referendum_v2 <- c(labels_variables_referendum, "L'inscription dans la Constitution que la \n préservation de l'environnement passe avant tout", "L'inscription dans la Constitution de la préservation de la biodiversité,\n de l'environnement et de la lutte contre le dérèglement climatique", "La reconnaissance du crime d'«écocide»")
(referendum_v2 <- barres(vars = variables_referendum_v2, df=e2, miss=T, labels=labels_variables_referendum_v2))
save_plotly(referendum_v2) 

labels_variables_referendum_en_v2 <- c(labels_variables_referendum_en, "The inscription in the Constitution that \n the preservation of the environment comes first", "The inclusion in the Constitution of the preservation of biodiversity,\n the environment and the fight against climate change.", "The recognition of the crime of 'ecocide'")
(referendum_en_v2 <- barres(vars = variables_referendum_v2, df=e2, miss=T, labels=labels_variables_referendum_en_v2, legend=c("Yes", "Blank", "No", "NR")))
save_plotly(referendum_en_v2)

variables_devoile_v2 <- c(variables_devoile, "CCC_devoile_28_heures")
labels_variables_devoile_v2 <- c(labels_variables_devoile, "La réduction du temps de travail légal \n à 28 heures par semaine (F)")
labels_variables_devoile_v2[2] <- "Limitation de la vitesse sur autoroutes à 110 km/h (V)"
(devoile_v2 <- barres(vars = variables_devoile_v2, df=e2, miss=F, labels=labels_variables_devoile_v2))
save_plotly(devoile_v2) 

(confiance_sortition_v2 <- barres(vars = "confiance_sortition", df=e2, miss = F, labels="Confiance dans la capacité de citoyens tirés au sort \nà délibérer de manière productive\n sur des questions politiques complexes"))
save_plotly(confiance_sortition_v2)

(pour_sortition_v2 <- barres(vars = "pour_sortition", df=e2, miss = T, rev=F, thin=F, labels="Pour une assemblée constituée de 150 citoyens tirés au sort, \ndotée d'un droit de veto sur les textes votés au Parlement"))
save_plotly(pour_sortition_v2)

(connait_CCC_v2 <- barres(vars = "connait_CCC", df=e2, miss = F, labels="Avez-vous entendu parler de \nla Convention Citoyenne pour le Climat ?"))
save_plotly(connait_CCC_v2)

(Connaissance_CCC_v2 <- barres(vars = "Connaissance_CCC", df=e2, miss = F, labels="Connaissance de la Convention Citoyenne pour le Climat\n (évaluation du champ libre demandant de la décrire)"))
save_plotly(Connaissance_CCC_v2) 

(sait_CCC_devoilee_v2 <- barres(vars = "sait_CCC_devoilee", df=e2, miss = F, labels="Des mesures proposées par la Convention \nCitoyenne pour le Climat ont déjà été dévoilées"))
save_plotly(sait_CCC_devoilee_v2)

(gilets_jaunes_v2 <- barres(vars = "gilets_jaunes", df=e2, miss = T, labels="Que pensez-vous des gilets jaunes ?"))
save_plotly(gilets_jaunes_v2)

(gauche_droite_v2 <- barres(vars = "gauche_droite", df=e2, miss = F, labels="Comment vous définiriez-vous ?", rev=F, rev_color = T))
save_plotly(gauche_droite_v2) 
(gauche_droite_nsp_v2 <- barres(vars = "gauche_droite_nsp", df=e2, miss = T, labels="Comment vous définiriez-vous ?", rev=F, rev_color = T))
save_plotly(gauche_droite_nsp_v2)

(confiance_gouvernement_v2 <- barres(vars = "confiance_gouvernement", df=e2, miss = T, labels="En général, faites-vous confiance au gouvernement\n pour prendre de bonnes décisions ?"))
save_plotly(confiance_gouvernement_v2) 

(interet_politique_v2 <- barres(vars = "interet_politique", df=e2, miss = F, labels="À quel point êtes-vous intéressé·e par la politique ?"))
save_plotly(interet_politique_v2) 

(gagnant_categorie_v2 <- barres(vars = "gagnant_categorie", df=e2, miss = T, labels="Suite à une taxe carbone avec dividende, vous seriez ...", rev=T))
save_plotly(gagnant_categorie_v2) 

(avis_estimation <- barres(vars = "avis_estimation", df=e2, miss = T, labels="Que pensez-vous de notre estimation\n de l'augmentation de taxes payées ?", rev=T))
save_plotly(avis_estimation) 

(certitude_gagnant_v2 <- barres(vars = "certitude_gagnant", df=e2, miss = F, labels="Degré de certitude à la cagéorie gagnant/perdant"))
save_plotly(certitude_gagnant_v2) 

(taxe_approbation_v2 <- barres(vars = "taxe_approbation", df=e2, thin=F, miss = T, labels="Approbation d'une taxe avec dividende\n", rev = F))
save_plotly(taxe_approbation_v2) 

data_approbation_by_gagnant_cat <- cbind(dataN("taxe_approbation", data = e2[which(e2$gagnant_categorie=="Gagnant"),]), dataN("taxe_approbation", data = e2[which(e2$gagnant_categorie=="Non affecté"),]), dataN("taxe_approbation", data = e2[which(e2$gagnant_categorie=="Perdant"),]), dataN("taxe_approbation", data = e2[which(e2$gagnant_categorie=="NSP"),]))
(approbation_by_gagnant_cat <- barres(data = data_approbation_by_gagnant_cat, sort=F, thin=T, miss = T, labels=rev(c("Approbation d'une taxe avec dividende lorsque\n la catégorie de gain subjectif est: NSP", "... Perdant", "... Non affecté", "... Gagnant")), legend=c("Oui ", "Non", "NSP"), rev = F))
save_plotly(approbation_by_gagnant_cat)

data_approbation_by_avis_estim <- cbind(dataN("taxe_approbation", data = e2[which(e2$avis_estimation=="Trop élevée"),]), dataN("taxe_approbation", data = e2[which(e2$avis_estimation=="Correcte"),]), dataN("taxe_approbation", data = e2[which(e2$avis_estimation=="Trop petite"),]), dataN("taxe_approbation", data = e2[which(e2$avis_estimation=="NSP"),]))
(approbation_by_avis_estim <- barres(data = data_approbation_by_avis_estim, sort=F, thin=T, miss = T, labels=rev(c("Approbation d'une taxe avec dividende lorsque\n l'estimation des dépenses est perçue comme: NSP", "... Trop petite", "... Correcte", "... Trop élevée")), legend=c("Oui ", "Non", "NSP"), rev = F))
save_plotly(approbation_by_avis_estim)

(trop_impots_v2 <- barres(vars = "trop_impots", df=e2, miss = T, labels="Paie-t-on trop d'impôt en France ?"))
save_plotly(trop_impots_v2) 

(problemes_invisibilises_v2 <- barres(vars = "problemes_invisibilises", df=e2, miss = F, rev=F, labels="Se sent confronté à des difficultés ignorées\n des pouvoirs publics et des médias"))
save_plotly(problemes_invisibilises_v2) 

(confiance_gens2_v2 <- barres(vars = "confiance_gens", df=e2, miss = F, labels="Confiance dans les autres"))
save_plotly(confiance_gens2_v2) 

(efforts_relatifs_v2 <- barres(vars = "efforts_relatifs", df=e2, miss = F, labels="Prêt à faire plus d'efforts que la majorité \ndes Français contre le changement climatique"))
save_plotly(efforts_relatifs_v2) 

(parle_CC_v2 <- barres(vars = "parle_CC", df=e2, miss = F, labels="À quelle fréquence parlez-vous du changement climatique ?"))
save_plotly(parle_CC_v2) 

(issue_CC_v2 <- barres(vars = "issue_CC", df=e2, miss = F, labels="Le changement climatique sera limité \nà un niveau acceptable d'ici la fin du siècle"))
save_plotly(issue_CC_v2) 

(effets_CC_CCC2_v2 <- barres(vars = "effets_CC_CCC", df=e2, miss = F, rev = F, labels="Quelles seront les conséquences en France d'ici 50 ans ?"))
save_plotly(effets_CC_CCC2_v2) 

(effets_CC_AT_v2 <- barres(vars = "effets_CC_AT", df=e2, rev = F, miss = T, labels="Effets du changement climatique, \nsi rien n'est fait pour le limiter ?"))
save_plotly(effets_CC_AT_v2) 

(cause_CC_CCC2_v2 <- barres(vars = "cause_CC_CCC", df=e2, miss = F, labels="Cause du changement climatique"))
save_plotly(cause_CC_CCC2_v2)

(France_CC2_v2 <- barres(vars = "France_CC", df=e2, thin = F, miss = F, labels="La France doit prendre de l'avance \nsur d'autres pays dans la lutte contre le changement climatique"))
save_plotly(France_CC2_v2) # TODO: with oui_non, pareil pour pour_taxe_carbone

(echelle_politique_CC2_v2 <- barres(vars = "echelle_politique_CC", df=e2, thin = F, rev = F, miss = F, labels="Le changement climatique exige\n d'être pris en charge par des politiques ..."))
save_plotly(echelle_politique_CC2_v2) 

(patrimoine_v2 <- barres(vars = "patrimoine", df=e2, rev = F, rev_color = T, miss = T, labels="Patrimoine net du ménage"))
save_plotly(patrimoine_v2) 

(redistribution2_v2 <- barres(vars = "redistribution", df=e2, rev = F, miss = F, labels="Il faudrait prendre aux riches pour donner aux pauvres"))
save_plotly(redistribution2_v2) 

(importance_v2 <- barres(vars = variables_importance, df=e2, rev = F, rev_color = T, miss = F, labels=c("L'action sociale et associative", "La protection de l'environnement", "L'amélioration de mon niveau de vie et de confort")))
save_plotly(importance_v2) 

(responsable_CC_v2 <- barres(vars = variables_responsable_CC, df=e2, rev = F, miss = F, showLegend=F, labels=labels_responsable, hover=labels_responsable))
save_plotly(responsable_CC_v2) 

(CCC_avis_v2 <- barres(vars = variables_CCC_avis, df=e2, rev = F, miss = F, showLegend=F, labels=labels_CCC_avis_long))
save_plotly(CCC_avis_v2)

(representativite_CCC <- barres(vars="representativite_CCC", df=e2, labels="La CCC est représentative", rev = F, miss = F))
save_plotly(representativite_CCC) 

(qualite_enfant2_v2 <- barres(vars = variables_qualite_enfant, df=e2, rev = F, miss = F, showLegend=F, labels=labels_qualite_enfant))
save_plotly(qualite_enfant2_v2) 

plot(Ecdf(e2$part_anthropique)$x, Ecdf(e2$part_anthropique)$y, type='s', xlab='Pourcentage estimé de Français estimant que le changement climatique est anthropique', ylab='Proportion < x') + grid()
data_anthropique_v2 <- (rbind(length(which(e2$part_anthropique <= 45)), length(which(e2$part_anthropique %between% c(46, 55))), length(which(e2$part_anthropique %between% c(56, 65))), length(which(e2$part_anthropique %between% c(66, 75))), length(which(e2$part_anthropique >75)))/nrow(e2))
(part_anthropique_v2 <- barres(data = data_anthropique_v2, df=e2, rev = F, rev_color = T,  miss = F, sort = F, labels = "Part des Français considérant que \nle changement climatique est anthropique ?", legend=c("Moins de 45%", "De 46 à 55%", "De 56 à 65%", "De 66 à 75%", "Plus de 75%")))
save_plotly(part_anthropique_v2)

data_taxe_carbone_v2 <- cbind(dataN("pour_taxe_carbone", data = e2[e2$variante_taxe_carbone=='pour',]), dataN("pour_taxe_carbone", data = e2[e2$variante_taxe_carbone=='contre',]), dataN("pour_taxe_carbone", data = e2[e2$variante_taxe_carbone=='neutre',]))
(pour_taxe_carbone2_v2 <- barres(data = data_taxe_carbone_v2, df=e2, rev = F, miss = T, sort = F, labels = c("Favorable à une augmentation de la taxe carbone\nVariante: sachant qu'une majorité de Français est pour", "Favorable à une augmentation de la taxe carbone\nVariante: sachant qu'une majorité de Français est contre", "Favorable à une augmentation de la taxe carbone\nVariante: sans information"), legend=c('Oui ', 'Non ', 'NSP')))
save_plotly(pour_taxe_carbone2_v2) # TODO: margin errors

(pour_taxe_carbone_neutre_v2 <- barres(vars = "pour_taxe_carbone", df = e2[e2$variante_taxe_carbone=='neutre',], rev = F, thin = F, miss = T, sort = F, labels = c("Favorable à une augmentation de la taxe carbone\nVariante: sans information")))
save_plotly(pour_taxe_carbone_neutre_v2)

(solution_CC_v2 <- barres(vars = variables_solution, df=e2, rev = F, miss = F, showLegend=F, labels=labels_solution))
save_plotly(solution_CC_v2) 

data_obstacles_e_v2 <- matrix(NA, nrow = 7, ncol = length(variables_obstacles))
for (j in 1:length(variables_obstacles)) for (i in 1:7) data_obstacles_e_v2[i,j] <- sum(e2$weight[e2[[variables_obstacles[j]]]==i], na.rm=T)/sum(e2$weight)
(obstacles_v2 <- barres(data = data_obstacles_e_v2[,c(5,7,6,4,2,3,1)], df=e2, rev = F, miss = F, sort = F, showLegend=T, legend = 1:7, labels=labels_obstacles[c(5,7,6,4,2,3,1)])) # rev(1:7): ordre d'apparition dans questionnaire
save_plotly(obstacles_v2) 

plot(Ecdf(e2$nb_politiques_env)$x, Ecdf(e2$nb_politiques_env)$y, type='s', xlab='Nombre de politiques environnementales soutenues', ylab='Proportion < x') + grid()
data_nb_politiques_env_v2 <- (rbind(length(which(e2$nb_politiques_env <= 6)), length(which(e2$nb_politiques_env %between% c(7, 8))), length(which(e2$nb_politiques_env == 9)), length(which(e2$nb_politiques_env == 10)), length(which(e2$nb_politiques_env >10)))/nrow(e2))
(nb_politiques_env_v2 <- barres(data = data_nb_politiques_env_v2, df=e2, rev = F, rev_color = T,  miss = F, sort = F, labels = "Nombre de politiques climatiques soutenues", legend=c("De 0 à 6", "7 ou 8", "9", "10", "11 ou 12")))
save_plotly(nb_politiques_env_v2)


##### Images e1 & e2 #####
# barres(data=dataN3("confiance_sortition", miss = F, rev = T), sort = F, miss = F, labels = c('Population (V2)', 'Population (V1)', 'CCC'), legend=rev(dataN2("confiance_sortition", miss = F, return = 'legend'))))

(politiques_1_v1c <- barres12(variables_politiques_1, df=list(e1, c), labels = labels_variables_politiques_1, miss=F, comp = "(CCC)"))
save_plotly(politiques_1_v1c) 

(politiques_1_v12 <- barres12(variables_politiques_1, labels = labels_variables_politiques_1, miss=F))
save_plotly(politiques_1_v12) 

# barres(data = data_solution_ademe, grouped = T, rev = F, miss=F, labels=labels_solution, legend = c('CCC', 'Population'))
# barres(data = barres12(variables_politiques_1, miss=F, return="data"), grouped = T, rev = F, miss=F, labels=labels_variables_politiques_1, legend = c('CCC', 'Population'))
# TODO!: tenter grouped=T avec des barres12 multiples

(politiques_1_en_v12 <- barres12(variables_politiques_1, labels=labels_variables_politiques_1_en, legend = c("Very", "Rather", "Rather not", "Not at all"), miss=F, fr = F))
save_plotly(politiques_1_en_v12) 

(politiques_2_v12 <- barres12(variables_politiques_2, labels = labels_variables_politiques_2, miss=F))
save_plotly(politiques_2_v12) # TODO!: politiques all

(politiques_2_en_v12 <- barres12(variables_politiques_2, labels=labels_variables_politiques_2_en, legend = c("Completely", "Rather", "Indifferent/NR", "Not really", "Not at all"), miss=F))
save_plotly(politiques_2_en_v12) 

new_variables_referendum <- c("referendum_environnement_priorite_constit", "referendum_ecocide", "referendum_environnement_constitution") 
# variables_referendum_v2 <- c(variables_referendum, new_variables_referendum)
new_labels_variables_referendum <- c("L'inscription dans la Constitution que la \n préservation de l'environnement passe avant tout (V2)", "La reconnaissance du crime d'«écocide» (V2)", "L'inscription dans la Constitution de la préservation de la biodiversité,\n de l'environnement et de la lutte contre le dérèglement climatique (V2)")
# labels_variables_referendum_v2 <- c(labels_variables_referendum, new_labels_variables_referendum)
(referendum_v12 <- barres(data = cbind(dataKN(vars = new_variables_referendum, data=e2, rev = T), barres12(variables_referendum, return="data")), sort=F, miss=T, labels=c(new_labels_variables_referendum, barres12(variables_referendum, labels=labels_variables_referendum, return="labels")), legend=barres12(variables_referendum, return="legend")))
save_plotly(referendum_v12) 

new_labels_variables_referendum_en <- c("The inscription in the Constitution that \n the preservation of the environment comes first (W2)", "The recognition of the crime of 'ecocide' (W2)", "The inclusion in the Constitution of the preservation of biodiversity,\n the environment and the fight against climate change (W2)")
labels_variables_referendum_v2_en <- c(labels_variables_referendum_en, new_labels_variables_referendum_en)
(referendum_en_v12 <- barres(data = cbind(dataKN(vars = new_variables_referendum, data=e2, rev = T), barres12(variables_referendum, return="data")), sort=F, fr=F, miss=T, labels=c(new_labels_variables_referendum_en, barres12(variables_referendum, labels=labels_variables_referendum_en, return="labels", fr=F)), legend=c("Yes", "Blank", "No", "NR")))
save_plotly(referendum_en_v12) 

# labels_variables_devoile_long <- c() 
# for (v in variables_devoile) labels_variables_devoile_long <- c(labels_variables_devoile_long, sub(' - .*', '', sub('.*]', '', Label(e[[v]]))))
variables_devoile_v2 <- c(variables_devoile, "CCC_devoile_28_heures")
variables_devoile_v2 <- c(labels_variables_devoile, "La réduction du temps de travail légal \n à 28 heures par semaine (F)")
variables_devoile_v2[2] <- "Limitation de la vitesse sur autoroutes à 110 km/h (V)"
labels_devoile_v12 <- c("La réduction du temps de travail légal \n à 28 heures par semaine (F) (V2)", barres12(variables_devoile, labels=labels_variables_devoile, return="labels"))
labels_devoile_v12[4] <- "(V: a été dévoilé entre temps) (V2)"
(devoile_v12 <- barres(data = cbind(dataN(var = "CCC_devoile_28_heures", data=e2, rev = T, miss=F), barres12(variables_devoile, return="data", miss=F)), sort=F, miss=F, labels=labels_devoile_v12, legend=barres12(variables_devoile, return="legend")))
save_plotly(devoile_v12) # TODO: parmi qui ?

(confiance_sortition <- barres(data=dataN3("confiance_sortition", miss = F, rev = T), sort = F, miss = F, labels = c('Population (V2)', 'Population (V1)', 'CCC'), legend=rev(dataN2("confiance_sortition", miss = F, return = 'legend'))))
save_plotly(confiance_sortition)

(confiance_sortition_en <- barres(data=dataN3("confiance_sortition", miss = F, rev = T), sort = F, miss = F, labels = c('Population (W2)', 'Population (W1)', 'CCC'), legend=rev(c("Not at all confident", "Rather not confident", "Rather confident", "Completely confident"))))
save_plotly(confiance_sortition_en)

(pour_sortition <- barres12("pour_sortition", rev = F, legend = c("Oui ", "Non ", "NSP"), labels = "Pour une assemblée constituée de 150 citoyens tirés au sort, \ndotée d'un droit de veto sur les textes votés au Parlement", miss=T))
save_plotly(pour_sortition) # Oui Non

(pour_sortition_en <- barres12("pour_sortition", rev = F, fr=F, legend = c("Yes ", "No ", "PNR"), labels = "For an assembly made up of 150 citizens drawn by lot,\n with a right of veto on the texts voted in the Parliament", miss=T))
save_plotly(pour_sortition_en) # Oui Non

(connait_CCC <- barres12(vars = "connait_CCC", miss = F, labels="Avez-vous entendu parler de \nla Convention Citoyenne pour le Climat ?"))
save_plotly(connait_CCC)

(connait_CCC_en <- barres12(vars = "connait_CCC", miss = F, fr=F, labels="Have you heard of the \n Citizens'Convention for Climate?", legend=c("Yes, a lot", "Yes, somewhat", "Vaguely", "No")))
save_plotly(connait_CCC_en)

(Connaissance_CCC <- barres(vars = "Connaissance_CCC", df=e2, miss = F, labels="Connaissance de la Convention Citoyenne pour le Climat\n (évaluation du champ libre demandant de la décrire)"))
save_plotly(Connaissance_CCC) # TODO

(sait_CCC_devoilee <- barres12(vars = "sait_CCC_devoilee", miss = F, labels="Des mesures proposées par la Convention \nCitoyenne pour le Climat ont déjà été dévoilées"))
save_plotly(sait_CCC_devoilee) # TODO: parmi qui ?

(gilets_jaunes <- barres12(vars = "gilets_jaunes", miss = T, labels="Que pensez-vous des gilets jaunes ?"))
save_plotly(gilets_jaunes)

(gauche_droite <- barres12(vars = "gauche_droite", miss = F, labels="Comment vous définiriez-vous ?", rev=F, rev_color = T))
save_plotly(gauche_droite) 
(gauche_droite_nsp <- barres12(vars = "gauche_droite_nsp", miss = T, labels="Comment vous définiriez-vous ?", rev=F, rev_color = T))
save_plotly(gauche_droite_nsp) 

(confiance_gouvernement <- barres12(vars = "confiance_gouvernement", miss = T, labels="En général, faites-vous confiance au gouvernement\n pour prendre de bonnes décisions ?"))
save_plotly(confiance_gouvernement) 

(interet_politique <- barres12(vars = "interet_politique", miss = F, labels="À quel point êtes-vous intéressé·e par la politique ?"))
save_plotly(interet_politique) 

(gagnant_categorie <- barres12(vars = "gagnant_categorie", miss = T, labels="Suite à une taxe carbone avec dividende, vous seriez ..."))
save_plotly(gagnant_categorie) # TODO: écrire: qq soit dividende

# (Gagnant_categorie <- barres12(vars = "Gagnant_categorie", miss = T, labels="Suite à une taxe carbone avec dividende, vous seriez ..."))
# save_plotly(Gagnant_categorie) # TODO: pour dividende = 110

data_gagnant_categorie_evol <- cbind(dataN("gagnant_categorie", data = e2[which(e2$dividende==110),])[c(3:1,4)], dataN("gagnant_categorie", data = e1)[c(3:1,4)], dataN("gagnant_categorie", data = b))
(gagnant_categorie_evol <- barres(data = data_gagnant_categorie_evol, sort=F, thin=T, miss = T, labels=rev(c("Catégorie de gain subjectif\n en 02/19", "... en 04/20", "... en 10/20")), legend=c("Gagnant", "Non affecté", "Perdant", "NSP"), rev = F))
save_plotly(gagnant_categorie_evol)

data_gagnant_categorie_evol2 <- cbind(dataN("gagnant_categorie", data = e2[which(e2$dividende==110),])[c(3:1,4)]/sum(dataN("gagnant_categorie", data = e2[which(e2$dividende==110),])), dataN("gagnant_categorie", data = e1)[c(3:1,4)], dataN("gagnant_categorie", data = b))
(gagnant_categorie_evol2 <- barres(data = data_gagnant_categorie_evol2, sort=F, thin=T, miss = F, color = c(color(3), "lightgrey"), labels=rev(c("Catégorie de gain subjectif\n en 02/19", "... en 04/20", "... en 10/20")), legend=c("Gagnant", "Non affecté", "Perdant", "NSP "), rev = F))
save_plotly(gagnant_categorie_evol2)

(certitude_gagnant <- barres12(vars = "certitude_gagnant", miss = F, labels="Degré de certitude à la cagéorie gagnant/perdant"))
save_plotly(certitude_gagnant) 

(taxe_approbation_110 <- barres12(vars = "taxe_approbation", df = list(e1, e2[which(e2$dividende==110),]), thin=T, miss = T, legend=c("Oui ", "Non ", "NSP"), labels="Approbation d'une taxe avec dividende\n de 110€/an", rev = F))
save_plotly(taxe_approbation_110) # TODO: oui_non ici et dessous

data_taxe_div_approbation <- cbind(dataN("taxe_approbation", data = e2[which(e2$dividende==170),]), dataN("taxe_approbation", data = e2[which(e2$dividende==110),]), dataN("taxe_approbation", data = e2[which(e2$dividende==0),]))
(taxe_div_approbation <- barres(data = data_taxe_div_approbation, sort=F, thin=T, miss = T, labels=rev(c("Approbation d'une hausse de la taxe carbone", "... avec en plus un dividende de 110€/an", "... de 170€/an")), legend=c("Oui ", "Non", "NSP"), rev = F))
save_plotly(taxe_div_approbation)

data_taxe_approbation_all_v2 <- cbind(dataN("taxe_alternative_approbation", data = e2[which(e2$variante_alternative=="détaxe"),]), dataN("taxe_alternative_approbation", data = e2[which(e2$variante_alternative=="urba"),]), data_taxe_div_approbation)
(taxe_approbation_all_v2 <- barres(data = data_taxe_approbation_all_v2, sort=F, thin=T, miss = T, labels=rev(c("Approbation d'une hausse de la taxe carbone...", "... redistribuée en un dividende de 110€/an", "... de 170€/an", 
                                                                                                         expression("... seulement au-delà d'1tCO<sub>2</sub>/an\n redistribuée en un dividende de 60€/an"), "... redistribuée en un dividende différencié allant de\n 88€/an en centre-ville à 133€/an en zone rurale")), legend=c("Oui ", "Non", "NSP"), rev = F))
save_plotly(taxe_approbation_all_v2)

data_taxe_approbation_evol <- cbind(dataN("taxe_approbation", data = e2[which(e2$dividende==110),]), dataN("taxe_approbation", data = e1), dataN("taxe_approbation", data = b))
(taxe_approbation_evol <- barres(data = data_taxe_approbation_evol, sort=F, thin=T, miss = T, labels=rev(c("Approbation d'une taxe carbone avec dividende\n en 02/19", "... en 04/20", "... en 10/20")), legend=c("Oui ", "Non", "NSP"), rev = F))
save_plotly(taxe_approbation_evol)

(trop_impots <- barres12(vars = "trop_impots", miss = T, labels="Paie-t-on trop d'impôt en France ?"))
save_plotly(trop_impots) 

(problemes_invisibilises_v12 <- barres12(vars = "problemes_invisibilises", miss = F, rev=F, labels="Se sent confronté à des difficultés ignorées\n des pouvoirs publics et des médias"))
save_plotly(problemes_invisibilises_v12) 

(problemes_invisibilises <- barres(data=dataN3("problemes_invisibilises", miss = F), miss = F, sort = F, rev_color = F, labels = c('Population (V2)', 'Population (V1)', 'CCC'), legend=dataN2("problemes_invisibilises", miss = F, return = 'legend')))
save_plotly(problemes_invisibilises) # « Condi^ons de vie et aspira^ons », CREDOC, janvier 2019: donne 58% d'invisibilisés (contre 61% ici)

(problemes_invisibilises_en <- barres(data=dataN3("problemes_invisibilises", miss = F), miss = F, sort = F, rev_color = F, labels = c('Population (W2)', 'Population (W1)', 'CCC'), legend=c("Never", "Not often", "Quite often", "Very often")))
save_plotly(problemes_invisibilises_en) # « Condi^ons de vie et aspira^ons », CREDOC, janvier 2019: donne 58% d'invisibilisés (contre 61% ici)

(confiance_gens2_v12 <- barres12(vars = "confiance_gens", miss = F, labels="Confiance dans les autres"))
save_plotly(confiance_gens2_v12) 

(confiance_gens3 <- barres(data=dataN3("confiance_gens", miss = F, rev = T), miss = F, sort = F, labels = c('Population (V2)', 'Population (V1)', 'CCC'), legend=rev(dataN3("confiance_gens", miss = F, return = 'legend'))))
save_plotly(confiance_gens3)

(confiance_gens3_en <- barres(data=dataN3("confiance_gens", miss = F, rev = T), fr = F, miss = F, sort = F, labels = c('Population (W2)', 'Population (W1)','CCC'), legend=c("Trust", "Mistrust")))
save_plotly(confiance_gens3_en)

(confiance_gens <- barres(data=cbind(c(0.35, 0.65), dataN3("confiance_gens", miss = F, rev=T)), miss = F, sort = F, labels = c('Population (Cevipof 04/2020)', 'Population (V2)', 'Population (V1)', 'CCC'), legend=c("Confiance", "Méfiance")))
save_plotly(confiance_gens) # toplot!

(confiance_gens_en <- barres(data=cbind(c(0.35, 0.65), dataN3("confiance_gens", miss = F, rev=T)), miss = F, sort = F, labels = c('Population (Cevipof 04/2020)', 'Population (W2)', 'Population (W1)', 'CCC'), legend=c("Trust", "Mistrust"), fr = F))
save_plotly(confiance_gens_en) # toplot!

(efforts_relatifs <- barres12(vars = "efforts_relatifs", miss = F, labels="Prêt à faire plus d'efforts que la majorité \ndes Français contre le changement climatique"))
save_plotly(efforts_relatifs) 

(parle_CC <- barres12(vars = "parle_CC", miss = F, labels="À quelle fréquence parlez-vous du changement climatique ?"))
save_plotly(parle_CC) 

(issue_CC_v12 <- barres12(vars = "issue_CC", miss = F, labels="Le changement climatique sera limité \nà un niveau acceptable d'ici la fin du siècle"))
save_plotly(issue_CC_v12) 

(issue_CC <- barres(data=cbind(rev(c(13, 50, 31, 5))/99, dataN3("issue_CC", miss = F, rev = T)), miss = F, sort = F, labels = c('Population (ADEME)', 'Population (V2)', 'Population (V1)','CCC'), legend=rev(dataN2("issue_CC", miss = F, return = 'legend'))))
save_plotly(issue_CC) # ADEME octobre 2019 toplot!

(issue_CC_en <- barres(data=cbind(rev(c(13, 50, 31, 5))/99, dataN3("issue_CC", miss = F, rev = T)), miss = F, sort = F, labels = c('Population (ADEME)', 'Population (W2)', 'Population (W1)', 'CCC'), legend=rev(c("No, certainly not", "No, probably not", "Yes, probably", "Yes, certainly"))))
save_plotly(issue_CC_en) # ADEME octobre 2019 toplot!

(effets_CC_CCC_v12 <- barres12(vars = "effets_CC_CCC", miss = F, rev = F, labels="Quelles seront les conséquences en France d'ici 50 ans ?"))
save_plotly(effets_CC_CCC_v12) 

(effets_CC_CCC <- barres(data=cbind(c(0.02, 0.32, 0.65)/0.99, dataN3("effets_CC_CCC", miss = F)), miss = F, sort = F, labels = c('Population (ADEME)', 'Population (V2)', 'Population (V1)', 'CCC'), legend=dataN2("effets_CC_CCC", miss = F, return = 'legend')))
save_plotly(effets_CC_CCC) # ADEME 2019 toplot!

(effets_CC_AT <- barres12(vars = "effets_CC_AT", rev = F, miss = T, labels="Effets du changement climatique, \nsi rien n'est fait pour le limiter ?"))
save_plotly(effets_CC_AT) 

(cause_CC_CCC_v12 <- barres12(vars = "cause_CC_CCC", miss = F, labels="Cause du changement climatique"))
save_plotly(cause_CC_CCC_v12)

(cause_CC_CCC <- barres(data=dataN3("cause_CC_CCC", miss = F, rev = T), miss = F, sort = F, labels = c('Population (V2)', 'Population (V1)', 'CCC'), legend=rev(dataN2("cause_CC_CCC", miss = F, return = 'legend'))))
save_plotly(cause_CC_CCC)
# TODO: add European Social Survey data (see JMF ST prez)

(cause_CC_CCC_en <- barres(data=dataN3("cause_CC_CCC", miss = F, rev = T), miss = F, sort = F, labels = c('Population (W2)', 'Population (W1)', 'CCC'), legend=c("Only anthropogenic", "Mostly anthropogenic", "As much", "Mostly natural", "Only natural", "Does not exist")))
save_plotly(cause_CC_CCC_en)

(France_CC_v12 <- barres12(vars = "France_CC", thin = T, miss = F, labels="La France doit prendre de l'avance \nsur d'autres pays dans la lutte contre le changement climatique"))
save_plotly(France_CC_v12) 

(France_CC <- barres(data=dataN3("France_CC", miss=F, rev = T), miss = F, sort = F, labels = c('Population (V2)', 'Population (V1)', 'CCC'), legend=rev(dataN2("France_CC", return = 'legend', miss=F))))
save_plotly(France_CC)

(France_CC_en <- barres(data=dataN3("France_CC", miss=F, rev = T), miss = F, sort = F, labels = c('Population (W2)', 'Population (W1)', 'CCC'), legend=c("Yes", "NR", "No")))
save_plotly(France_CC_en)

(echelle_politique_CC_v12 <- barres12(vars = "echelle_politique_CC", thin = T, rev = F, miss = F, labels="Le changement climatique exige\n d'être pris en charge par des politiques ..."))
save_plotly(echelle_politique_CC_v12) 

(echelle_politique_CC <- barres(data=dataN3("echelle_politique_CC", miss = F), miss = F, sort = F, labels = c('Population (V2)', 'Population (V1)', 'CCC'), legend=dataN2("echelle_politique_CC", miss = F, return = 'legend')))
save_plotly(echelle_politique_CC) 

(echelle_politique_CC_en <- barres(data=dataN3("echelle_politique_CC", miss = F), miss = F, sort = F, labels = c('Population (W2)', 'Population (W1)', 'CCC'), legend=c("At all scales", "Global", "European", "National", "Local")))
save_plotly(echelle_politique_CC_en)

(patrimoine_v12 <- barres12(vars = "patrimoine", rev = F, rev_color = T, miss = T, labels="Patrimoine net du ménage"))
save_plotly(patrimoine_v12) 

(redistribution_v12 <- barres12(vars = "redistribution", rev = F, miss = F, labels="Il faudrait prendre aux riches pour donner aux pauvres"))
save_plotly(redistribution_v12) 

(redistribution <- barres(data=dataN3("redistribution", miss = F), rev = F,  miss = F, sort = F, labels = c('Population (V2)', 'Population (V1)', 'CCC'), legend=dataN2("redistribution", miss = F, return = 'legend')))
save_plotly(redistribution)

# (importance_v12 <- barres(data=cbind(dataN3("redistribution", miss = F), dataN3("redistribution", miss = F), dataN3("redistribution", miss = F)), rev = F, rev_color = T, miss = F, labels=c("L'action sociale et associative", "La protection de l'environnement", "L'amélioration de mon niveau de vie et de confort")))
# save_plotly(importance_v12) # TODO

(importance_associatif <- barres(data=cbind(dataN("importance_associatif", data = e2, miss = F), dataN("importance_associatif", data = e1, miss = F), data_importance_CCC[,1]), rev = F, rev_color = T,  miss = F, sort = F, labels = c('Population (V2)', 'Population (V1)', 'CCC'), legend=0:10))
save_plotly(importance_associatif)

(importance_environnement <- barres(data=cbind(dataN("importance_environnement", data = e2, miss = F), dataN("importance_environnement", data = e1, miss = F), data_importance_CCC[,2]), rev = F, rev_color = T,  miss = F, sort = F, labels = c('Population (V2)', 'Population (V1)', 'CCC'), legend=0:10))
save_plotly(importance_environnement)

(importance_confort <- barres(data=cbind(dataN("importance_confort", data = e2, miss = F), dataN("importance_confort", data = e1, miss = F), data_importance_CCC[,3]), rev = F, rev_color = T,  miss = F, sort = F, labels = c('Population (V2)', 'Population (V1)', 'CCC'), legend=0:10))
save_plotly(importance_confort)

(responsable_CC_v12 <- barres12(vars = variables_responsable_CC, miss = F, showLegend=F, labels=labels_responsable))
save_plotly(responsable_CC_v12) 

(responsable_CC <- barres(data=rbind(dataKN(variables_responsable_CC, e1, miss=F), dataKN(variables_responsable_CC, e2, miss=F)), labels=labels_responsable, legend = c("Vague 1", "Vague 2"), sort = T, grouped=T, rev = F, miss = F))
save_plotly(responsable_CC) 

(CCC_avis <- barres(data=rbind(dataKN(variables_CCC_avis, e1, miss=F), dataKN(variables_CCC_avis, e2, miss=F)), labels=labels_CCC_avis_long, legend = c("Vague 1", "Vague 2"), sort = T, grouped=T, rev = F, miss = F))
save_plotly(CCC_avis) 

(Connaissance_CCC_v12 <- barres12(vars = "Connaissance_CCC", color = color(7)[c(1,2,4:7)], miss = F, labels="Connaissance de la Convention Citoyenne pour le Climat\n (évaluation du champ libre demandant de la décrire)"))
save_plotly(Connaissance_CCC_v12) # TODO: ajouter barre grise pour les NA

# TODO: appartenance
(Connaissance_CCC_v12_wo_label <- barres12(vars = "Connaissance_CCC", color = color(7)[c(1,2,4:7)], miss = F, labels="Synhtèse du champ libre"))
save_plotly(Connaissance_CCC_v12_wo_label) 

(qualite_enfant2 <- barres(vars = variables_qualite_enfant, df=e2, rev = F, miss = F, showLegend=F, labels=labels_qualite_enfant))
save_plotly(qualite_enfant2) 

data_qualite_enfant_all <- matrix(NA, ncol = length(variables_qualite_enfant), nrow = 3)
data_qualite_enfant_all[1:2,] <- data_qualite_enfant
for (j in 1:length(variables_qualite_enfant)) data_qualite_enfant_all[3,j] <- sum(e$weight[e2[[variables_qualite_enfant[j]]]==T])/sum(e2$weight)
(qualite_enfant <- barres(data = data_qualite_enfant_all, color = color(4)[c(1,3,4)], grouped = T, rev = F, miss=F, labels=labels_qualite_enfant, legend = c('CCC', 'Population (V1)', "Population (V2)")))
save_plotly(qualite_enfant)

(qualite_enfant_en <- barres(data = data_qualite_enfant_all, color = color(4)[c(1,3,4)], grouped = T, rev = F, miss=F, labels=labels_qualite_enfant_en, legend = c('CCC', 'Population (W1)', "Population (W2)")))
save_plotly(qualite_enfant_en) 

data_anthropique_v1 <- (rbind(length(which(e1$part_anthropique <= 45)), length(which(e1$part_anthropique %between% c(46, 55))), length(which(e1$part_anthropique %between% c(56, 65))), length(which(e1$part_anthropique %between% c(66, 75))), length(which(e1$part_anthropique >75)))/nrow(e1))
data_anthropique_v2 <- (rbind(length(which(e2$part_anthropique <= 45)), length(which(e2$part_anthropique %between% c(46, 55))), length(which(e2$part_anthropique %between% c(56, 65))), length(which(e2$part_anthropique %between% c(66, 75))), length(which(e2$part_anthropique >75)))/nrow(e2))
data_anthropique <- cbind(data_anthropique_v2, data_anthropique_v1)
(part_anthropique <- barres(data = data_anthropique, rev = F, rev_color = T,  miss = F, sort = F, labels = c("Vague 2 (V2)", "Part des Français considérant que \nle changement climatique est anthropique ? (V1)"), legend=c("Moins de 45%", "De 46 à 55%", "De 56 à 65%", "De 66 à 75%", "Plus de 75%")))
save_plotly(part_anthropique)

data_taxe_carbone_v1 <- cbind(dataN("pour_taxe_carbone", data = e1[e1$variante_taxe_carbone=='pour',]), dataN("pour_taxe_carbone", data = e1[e1$variante_taxe_carbone=='contre',]), dataN("pour_taxe_carbone", data = e1[e1$variante_taxe_carbone=='neutre',]))
data_taxe_carbone_v2 <- cbind(dataN("pour_taxe_carbone", data = e2[e2$variante_taxe_carbone=='pour',]), dataN("pour_taxe_carbone", data = e2[e2$variante_taxe_carbone=='contre',]), dataN("pour_taxe_carbone", data = e2[e2$variante_taxe_carbone=='neutre',]))
data_taxe_carbone_all <- cbind(data_taxe_carbone_v2[,1], data_taxe_carbone_v1[,1], data_taxe_carbone_v2[,2], data_taxe_carbone_v1[,2], data_taxe_carbone_v2[,3], data_taxe_carbone_v1[,3])
(pour_taxe_carbone_all <- barres(data = data_taxe_carbone_all, rev = F, miss = T, sort = F, labels = labels12(c("Favorable à une augmentation de la taxe carbone\nVariante: sachant qu'une majorité de Français est <b>pour</b>", "Favorable à une augmentation de la taxe carbone\nVariante: sachant qu'une majorité de Français est <b>contre</b>", "Favorable à une augmentation de la taxe carbone\nVariante: sans information")), legend=c('Oui ', 'Non ', 'NSP')))
save_plotly(pour_taxe_carbone_all) 

data_taxe_carbone_b <- cbind(dataN("pour_taxe_carbone", data = eb[eb$variante_taxe_carbone=='pour',]), dataN("pour_taxe_carbone", data = eb[eb$variante_taxe_carbone=='contre',]), dataN("pour_taxe_carbone", data = eb[eb$variante_taxe_carbone=='neutre',]))
(pour_taxe_carbone <- barres(data = data_taxe_carbone_b, rev = F, miss = T, sort = F, labels = c("... sachant qu'une majorité de Français est <i>pour</i>", "... sachant qu'une majorité de Français est <i>contre</i>", "Favorable à une augmentation de la taxe carbone\nVariante... <i>sans information</i>"), legend=c('Oui ', 'Non ', 'NSP')))
save_plotly(pour_taxe_carbone) 

(pour_taxe_carbone_neutre <- barres12(vars = "pour_taxe_carbone", df = list(e1[e1$variante_taxe_carbone=='neutre',], e2[e2$variante_taxe_carbone=='neutre',]), legend=c("Oui ", "Non ", "NSP"), rev = F, miss = T, sort = F, labels = c("Favorable à une augmentation de la taxe carbone\nVariante: sans information")))
save_plotly(pour_taxe_carbone_neutre)

(pour_taxe_carbone_evol <- barres12(vars = "pour_taxe_carbone", legend=c("Oui ", "Non ", "NSP"), rev = F, miss = T, sort = F, labels = c("Favorable à une augmentation de la taxe carbone")))
save_plotly(pour_taxe_carbone_evol)

(solution_CC_v12 <- barres(data=rbind(dataKN(variables_solution, e1, miss=F), dataKN(variables_solution, e2, miss=F)), labels=labels_solution, legend = c("Vague 1", "Vague 2"), sort = T, grouped=T, rev = F, miss = F))
save_plotly(solution_CC_v12)

data_solution_all <- matrix(NA, ncol = length(variables_solution), nrow = 4)
data_solution_all[c(1:2,4),] <- rbind(data_solution_good, c(11, 52, 19, 17)/99)
for (j in 1:length(variables_solution)) data_solution_all[3,j] <- sum(e2$weight[e2[[variables_solution[j]]]==T])/sum(e2$weight)
(solution_CC <- barres(data = data_solution_all, color = color(7)[c(1,5:7)], grouped = T, rev = F, miss=F, labels=labels_solution, legend = c('CCC', 'Population (V1)', 'Population (V2)', 'Population (ADEME)')))
save_plotly(solution_CC) # TODO!: use color(7)[c(5:6)] for all V1, V2

(solution_CC_en <- barres(data = data_solution_all, color = color(7)[c(1,5:7)], grouped = T, rev = F, miss=F, labels=labels_solution_en, legend = c('CCC', 'Population (W)', 'Population (W2)', 'Population (ADEME)')))
save_plotly(solution_CC_en)  # TODO: check whether answers are multiple or not => ADEME sum to 1, CCC to 1.006, and externe to 1.1 rowSums(data_solution_all)

data_obstacles_e <- matrix(NA, nrow = 7, ncol = length(variables_obstacles))
for (j in 1:length(variables_obstacles)) for (i in 1:7) data_obstacles_e[i,j] <- sum(e2$weight[e2[[variables_obstacles[j]]]==i], na.rm=T)/sum(e2$weight)
(obstacles_v2 <- barres(data = data_obstacles_e[,c(5,7,6,4,2,3,1)], df=e2, rev = F, miss = F, sort = F, showLegend=T, legend = 1:7, labels=labels_obstacles[c(5,7,6,4,2,3,1)])) # rev(1:7): ordre d'apparition dans questionnaire
save_plotly(obstacles_v2) 

data_obstacles <- matrix(NA, ncol = length(variables_obstacles), nrow = 3)
data_obstacles[1:2,] <- data_obstacles_both
for (j in 1:length(variables_obstacles)) data_obstacles[3,j] <- sum(e2$weight[e2[[variables_obstacles[j]]]<=2],na.rm=T)/sum(e2$weight)
(obstacles_all <- barres(data = data_obstacles, color = color(4)[c(1,3,4)], grouped = T, rev = F, miss=F, labels=labels_obstacles[1:7], legend = c('CCC', 'Population (V1)', 'Population (V2)')))
save_plotly(obstacles)

(obstacles_en <- barres(data = data_obstacles, color = color(4)[c(1,3,4)], grouped = T, rev = F, miss=F, labels=c("Lobbies", "Lack of political will", "Lack of cooperation between countries", "Inequalities", "Uncertainties of scientific community", "Demography", "Lack of alternative technologies"), legend = c('CCC', 'Population (W1)', 'Population (W2)')))
save_plotly(obstacles_en)

data_nb_politiques_env_v1 <- (rbind(length(which(e1$nb_politiques_env <= 6)), length(which(e1$nb_politiques_env %between% c(7, 8))), length(which(e1$nb_politiques_env == 9)), length(which(e1$nb_politiques_env == 10)), length(which(e1$nb_politiques_env >10)))/nrow(e1))
data_nb_politiques_env_v2 <- (rbind(length(which(e2$nb_politiques_env <= 6)), length(which(e2$nb_politiques_env %between% c(7, 8))), length(which(e2$nb_politiques_env == 9)), length(which(e2$nb_politiques_env == 10)), length(which(e2$nb_politiques_env >10)))/nrow(e2))
data_nb_politiques_env <- cbind(data_nb_politiques_env_v2, data_nb_politiques_env_v1)
(nb_politiques_env <- barres(data = data_nb_politiques_env, rev = F, rev_color = T,  miss = F, sort = F, labels = labels12("Nombre de politiques climatiques soutenues"), legend=c("De 0 à 6", "7 ou 8", "9", "10", "11 ou 12")))
save_plotly(nb_politiques_env)

# TODO: ecologiste_v12 / autres_politique, non_representatif, Connaissance_CCC
e2$CCC_non_representative_autre[e2$CCC_non_representative_autre!="" & !is.na(e2$CCC_non_representative_autre)]
# 57: grandes villes: 2 / certaines classes sociales (ex: pauvre): 6 / positions passées: 2 / loin du terrain: 2 / incompétent: 4 / plus intelligents: 1 / ne sais pas: 11
# "s'ils sont pris au hasard, ça craint" "ils ne representent qu'eux memes ce qui est peu" "Différent de la composition démographique de la France" 
# "Ils se pensent dans un monde de bisounours" "ils sont cons" "Le hasard n est pas scientifique" "ils sont volontaires c'est tout"
variables_CCC_non_representative <- paste("CCC_non_representative", c("gauche", "droite", "ecolo", "anti_ecolo", "pro_gouv", "anti_gouv", "autre_choix"), sep="_")
labels_CCC_non_representative <- c("Plus à gauche", "Plus à droite", "Plus écologistes", "Moins écologistes", "Plus pro-gouvernement", "Moins pro-gouvernement", "Autre")
(CCC_non_representative <- barres(vars = variables_CCC_non_representative, df=e2, showLegend=F, rev=F, miss = F, sort = T, labels = labels_CCC_non_representative))
save_plotly(CCC_non_representative)

# TODO! hausse dépenses v1 (avec comparaison); biais (v1; v0, v2; v0, v1, v2)
par(mar = c(3.4, 3.4, 1.1, 0.1), cex=1.5)
# gain v1 TODO: hline at 61/90 to show Perdants/Gagnants
cdf_gain_e1<- Ecdf(e1$gain) 
plot(Ecdf(e1$gain_min), type="s", lwd=2, col="red", lty=2, xlim=c(-300, 150), main="", ylab="", xlab="") + grid()
lines(cdf_gain_e1$x, cdf_gain_e1$y, lwd=2, type='s', col="red")
title(ylab=expression("Proportion "<=" x"), xlab="Gain (in €/year per c.u.)", line=2.3)
# legend("topleft", col=c("red", "red"), cex = 0.85, lty = c(1,2), lwd=2, legend = c("Subjective (imputed)", "Subjective (imputed, minimum)"))
legend("topleft", col=c("red", "red"), cex = 0.85, lty = c(1,2), lwd=2, legend = c("Subjectif (imputé)", "Subjectif (imputé, minimum)"))
par(mar = mar_old, cex = cex_old)

# gain v2 TODO: reproduire figures avec weights (elles sont enregistrées sans)
par(mar = c(3.4, 3.4, 1.1, 0.1), cex=1.5)
cdf_gain_e2 <- Ecdf(e2$gain[e2$dividende==110], weights = e2$weight[e2$dividende==110]) 
cdf_gain <- Ecdf(objective_gains$all) 
cdf_simule_gain <- Ecdf(e2$simule_gain[e2$dividende==110], weights = e2$weight[e2$dividende==110]) # TODO: données BdF
cdf_all_inelastic <- Ecdf(objective_gains_inelastic$all) # TODO: données e2
plot(cdf_gain_e2$x, cdf_gain_e2$y, lwd=2, type='s', col="red", xlim=c(-400, 150), main="", ylab="", xlab="") + grid()
lines(Ecdf(b$gain), type="s", lwd=2, col="orange")
lines(cdf_simule_gain$x, cdf_simule_gain$y, lwd=2, col="darkblue")
lines(cdf_all_inelastic$x, cdf_all_inelastic$y, lwd=2, lty=2, col="darkblue")
title(ylab=expression("Proportion "<=" x"), xlab="Gain (in €/year per c.u.)", line=2.3)
# abline(v=c(-280, -190, -120, -70, -30, 0, 20, 40, 60, 80), lty=3, col="orange")
# axis(3, at=c(-280, -190, -120, -70, -30, 0, 20, 40, 60, 80), tck=0.0, lwd=0, lwd.ticks = 0, padj=1.5, col.axis="orange", cex.axis=0.9)
# legend("topleft", col=c("red", "darkblue", "darkblue"), cex = 0.85, lty = c(1,1,2), lwd=2, legend = c("Subjective", "Objective", "Objective inelastic"))
# legend("topleft", col=c("orange", "red", "darkblue", "darkblue"), cex = 0.85, lty = c(1,1,1,2), lwd=2, legend = c("Subjective: Wave 0", "Subjective: Wave 2", "Objective", "Objective inelastic"))
legend("topleft", col=c("orange", "red", "darkblue", "darkblue"), cex = 0.85, lty = c(1,1,1,2), lwd=2, legend = c("Subjectif: Vague 0", "Subjectif: Vague 2", "Objectif", "Objectif inélastique"))
# legend("topleft", col=c("red", "darkblue", "darkblue"), cex = 0.85, lty = c(1,1,2), lwd=2, legend = c("Subjectif", "Objectif", "Objectif inélastique"))
# legend("topleft", col=c("red", "darkblue"), cex = 0.85, lwd=2, legend = c("Subjective", "Objective"))
# restore graphical parameters
par(mar = mar_old, cex = cex_old)

# gain imputé v2 TODO! 170, add weights (same above)
par(mar = c(3.4, 3.4, 1.1, 0.1), cex=1.5)
cdf_gain_e2_without0 <- Ecdf(e2$gain[e2$gain!=0 & e2$dividende==110], weights = e2$weight[e2$gain!=0 & e2$dividende==110])
gain_impute_110 <- as.numeric(e2$simule_gain + e2$dividende_escompte_ajuste - (e2$dividende * pmin(2, e2$nb_adultes)/e2$uc))[e2$dividende==110]
plot(Ecdf(gain_impute_110, weights = e2$weight[e2$dividende==110]), type="s", lwd=2, col="black", xlim=c(-400, 150), main="", ylab="", xlab="") + grid()
lines(cdf_gain_e2$x, cdf_gain_e2$y, lwd=2, type='s', col="red")
# lines(cdf_gain_e2_without0$x, cdf_gain_e2_without0$y, lwd=2, type='s', lty=2, col="red")
# lines(cdf_simule_gain$x, cdf_simule_gain$y, lwd=2, col="darkblue")
# lines(cdf_all_inelastic$x, cdf_all_inelastic$y, lwd=2, lty=2, col="darkblue")
title(ylab=expression("Proportion "<=" x"), xlab="Gain (in €/year per c.u.)", line=2.3)
# abline(v=c(-280, -190, -120, -70, -30, 0, 20, 40, 60, 80), lty=3, col="red")
# axis(3, at=c(-280, -190, -120, -70, -30, 0, 20, 40, 60, 80), tck=0.0, lwd=0, lwd.ticks = 0, padj=1.5, col.axis="orange", cex.axis=0.9)
# legend("topleft", col=c("red", "red", "darkblue", "darkblue"), cex = 0.85, lty = c(1,1,1,2), lwd=2, legend = c("Subjective: Wave 0", "Subjective: Wave 2", "Objective", "Objective inelastic"))
legend("topleft", col=c("black", "red"), cex = 0.85, lty = c(1,1), lwd=2, legend = c("Imputé (dépenses obj., div. subj.)", "Subjectif"))
# legend("topleft", col=c("black", "red", "red"), cex = 0.85, lty = c(1,1), lwd=2, legend = c("Imputé (dépenses obj., div. subj.)", "Subjectif", "Subjectif, hors Non affecté"))
par(mar = mar_old, cex = cex_old)
wtd.mean((e2$simule_gain + e2$dividende_escompte_ajuste - (e2$dividende * pmin(2, e2$nb_adultes)/e2$uc))[e2$dividende==110] < 0, weights = e2$weight[e2$dividende==110])

##### Champ libre #####
# 988: "Bonjour !.\nDepuis des lustres je n'ai aucune confiance dans notre système de gouvernance.\nTrop de Députés,\ndes Sénateurs inutiles,\nles Régions sont une entité faisant double emploi avec les Départements,\n
#       donc à supprimer.\nLes salaires et tous les défraiements de nos politiques doivent être revus à la baisse. \nL'état fera ainsi des économies et nous n'auront pas à subir des taxes supplémentaires !\nVoilà !!!"
# 947: "Je ne veux pas que le monde que connaîtra plut tard mes enfants, petit enfant (etc) soit polluer en mauvais état et c'est pour ça que je suis pour tout ce qui est bio"
# 935: "Je ne comprends pas l'utilité d'augmenter le coût des énergie et ensuite verser cette prime unitaire à tous.\nCertes cela devrait pousser à rouler moins en voiture.\n
#       Mais la consommation d'énergie pour le chauffage est une première nécessité pour tous."
# 929: "Un seul tour de vote présidentiel,il devrait y avoir,pendant un an 2 présidents à la tête du pays et se partagerait un seul revenu et vivre en colocation.\n
#       A l'issu de la fin de la première année d'exercice un vote aura lieu pour élire le seul président,suivant les résultats du meilleur, qui gouvernera le pays.
#       Il y va de la confiance du peuple et de la reconnaissance du gouvernement."
# 883: "faisant partie de la classe moyenne (inférieure),1650 salaire monsieur et notre fils chômage (490???)on a droit a aucune aide (pas d'apl,pas d'aide complémentaire santé, pas de cheque énergie etc..)
#       on ne s'en sort passion a tous a payé plein pot.Pourquoi?on galère pour manger,etc..." 
# 865: "A ce jour je ne sais plus quoi penser de ce monde politique. Il tire la couverture pour se remplir les poches. Il ni a pas d'argent sauf quand il le faut. On nous balade sur tous les points."
# 858: "quand il s'agit de taxe c'est toujours les plus démunie qui trinque"
# 828: "ce sondage m'a etait tres positif merci"
# 827: "Très bon sondage"
# 802: "J'ai encore bien peur que ce soit toujours les même qui seront gagnant et nous autres les plus petits ou moyen pendant.\nLes pleureurs avec des familles de gamins nombreux s'en tireront encore avec 
#       des avantages que les smicards qui se lèvent tôt et travaillent dur seront les perdant encore"
# 794: "Je suis plutôt pessimiste par rapport à tous ce que le Président et le 1er ministre dit vouloir faire. On dirait qu' ils sont sur une balançoire, temps tôt c'est  blanc ,temps tôt noir. On nous mènent en bateau."
# 791: "Pour éviter un avenir incertain à notre planète terre, seul un contrôle mondial des naissances ( maxi 1 enfant par famille ) permettra de préserver le réchauffement climatique et la bio diversité ."
# 776: "L'environnement lié au climat est une vaste question qui trouvera une réponse si tous les grands pays comme la Chine, les états Unis, l'Inde agissent réellement alors oui des petits pays 
#       comme la France pourront suivre. Si non que la France serve d'exemple ne sert à rien"
# 763: "je me pose le question sur quelles critéres a été fait ce tirage au sort pour la convention citoyenne !!!!!!!!!!"
# 733: "JE RAPELLE QUE LES PLUS NOMBREUX SONT LES PETITS DONC ON VOIS TRES BIEN QUI VA PAYER"
# 731: "Je ne sais pas quoi dire,vu ce qui ce passe actuellement(covid19). Et vu que notre gouvernement nous ment depuis le debut de cette crise,alors comment lui faire confiance sur les questions que vous avez posées"
# 712: "J ai aimé ce questionner je ne sent rassuré"
# 481: "Concernant la mesure décrite, je suis favorable à la mise en place d'une taxe carbone, mais pas à la redistribution vers TOUS les ménages. \nJe pense que la redistribution 
#       devrait se faire uniquement vers les plus faibles revenus, ce qui permettrait d'augmenter celle-ci." [a répondu Non à approbation]
# 432: "Intéressant et remarquablement bien fait. On ne s'ennuie pas même lorsque les questions sont redondantes..."
# 360: "Sondage très tendancieux et manipulateur"
# 339: [...] Si l'on descend de plus en plus la vitesse, les moteurs s'encrasseront plus vite et donc pollueront beaucoup plus [...]
# 302: "enfin un sondage bien rédigé et non \"biaisé\""
# 193: "Vous avez beaucoup vérifié notre attention au test... un peu de confiance serait mieux."
# 152: "le fait d'augmenter les carburants impacte l'augmentation de beaucoup d'autres produits!!!"
# 140: "Je suis opposé  en général  a toute augmentation des impots et taxes  pour résoudre un problème"
#  84: "Je suis favorable à des mécanismes de redistribution à condition qu'ils soient simples et compréhensibles ... et pas aux usines à gaz !"
#  70: "Le  Réchauffement climatique est un problème majeur  aussi parce qu' il provoque  beaucoup de  discussions   et de dissensions  dans les familles.  Par exemple  certains  végans voudraient nous imposer  
#       leur régime alimentaire  comme une religion.  lls   brandissent  le spectre d un cataclysme éminent si nous ne changeons pas totalement notre mode  de vie. et c 'est très angoissant.."
#   1: "je souhaite de vivre bien"
# critiques questionnaire: trop long, questions pas assez précises ou réponses manquant de nuances, la police devrait être noire plutôt que grise, et plus petite


##### Comparaison avec sondage Adrien Thomas #####
decrit("fonds_mondial", data=b) # énorme différence ! (même formulation pourtant, mais pas les mêmes items autour)
decrit("pour_fonds_mondial", data=e) # TODO: check
decrit("pour_fonds_mondial", data=e, which=e$info_CCC==0) # ne s'explique pas par l'info_CCC
decrit("interdiction_polluants", data=b)
decrit("pour_restriction_centre_ville", data=e) # + CCC
decrit("pour_taxe_viande", data=b)
decrit("taxe_viande", data=b)
# responsable_, taxe_approbation, parle/cause/effets_CC + parth_anthropique, revenu, caracs énergie, compo ménage, socio-démo (+ mail), transports_courses/travail/loisir, politique, champ libre


##### Comparaison avec sondage Fabrice Étilé #####
# Le sondage de Fabrice n'est pas représentatif (moyenne d'âge 26 ans, public éduqué) donc ça ne sert pas à grand chose de l'exploiter.
# Il contient une matrice de questions sur les préférences de politiques climatiques, cause_CC_AT, et effets_CC_AT.
# Ces questions ont l'air d'avoir la même distribution de réponses que dans les autres sondages, et sont de bons candidats pour des questions à réponses stables dans le temps.


##### Comparaison avec sondages CCC ####
decrit(c$solution_CC_1e) # changer 75%, états 15%, progres et rien 5%
decrit(e$solution_CC_changer, weight=F) # 67%
decrit(e$solution_CC_progres, weight=F) # 13%
decrit(e$solution_CC_traite, weight=F) # 19%
decrit(e$solution_CC_rien, weight=F) # 12%
decrit(c$echelle_politique_CC) # pareil
decrit(e$echelle_politique_CC)
decrit(c$pour_taxe_distance) # CCC plus écolo
decrit(e$pour_taxe_distance)
decrit(c$pour_renouvelables)
decrit(e$pour_renouvelables)
decrit(c$pour_densification)
decrit(e$pour_densification)
decrit(c$pour_voies_reservees) # CCC plus écolo
decrit(e$pour_voies_reservees)
decrit(c$pour_cantines_vertes) # CCC plus écolo
decrit(e$pour_cantines_vertes)
decrit(c$pour_fin_gaspillage) # CCC plus écolo
decrit(e$pour_fin_gaspillage)
decrit(c$France_CC) # CCC plus écolo
decrit(e$France_CC)
# obstacles
decrit(c$cause_CC_CCC)
decrit(e$cause_CC_CCC)
decrit(c$effets_CC_CCC) # cause et effets assez semblables et questions stables dans le temps
decrit(e$effets_CC_CCC)
decrit(c$confiance_gens)
decrit(e$confiance_gens) # CCC beaucoup moins méfiante 
# qualite_enfant
decrit(c$redistribution)
decrit(e$redistribution) # CCC moins pro-redistribution
decrit(c$problemes_invisibilises)
decrit(e$problemes_invisibilises) # assez représentatif
decrit(c$importance_associatif)
decrit(e$importance_associatif) # CCC + pro-asso
decrit(c$importance_environnement)
decrit(e$importance_environnement) # CCC plus écolo
decrit(c$importance_confort)
decrit(e$importance_confort) # same
decrit(c$pour_obligation_renovation)
decrit(e$pour_obligation_renovation) # similaire mais échelles pas comparables
decrit(c$pour_vitesse_110)
decrit(e$pour_limitation_110) # CCC plus écolo
decrit(c$confiance_sortition)
decrit(e$confiance_sortition) # Différence énorme : serait-ce ça qui détermine la participation (et est corrélé avec être écolo) ?
decrit(c$issue_CC)
decrit(e$issue_CC) # same
  # socio-demo, proprio, 

##### Tests #####
# Problèmes pour évaluer la représentativité:
# a. les tests sont trop conservateurs, et tendent à toujours rejeter la similarité des distributions
# b. la similarité des distributions est rejetée entre les résultats d'autres sondages représentatifs et le nôtre
# c. l'opinion fluctue d'une saison à l'autre (ce qui peut suffire à expliquer b.), de façon significative (or, les sondages CCC vs. externe sont séparés de ~7 mois)
# d. les citoyens de la CCC étaient dans un contexte particulier et avaient déjà pu endosser un rôle différent ou appris des choses lorsqu'ils ont répondu au questionnaire à la fin de la première journée
# => pour ces raisons, on pourra difficilement trancher sur la représentativité à partir des questions d'opinion ou de personnalité (type importance_environnement ou confiance_gens) dès lors qu'on rejette la similarité
#    On peut :
#-1. s'en remettre aux graphes et ne pas faire de tests
# 0. utiliser les variables socio-démos
# 1. faire des tests d'équivalence (pour voir "de combien" les distributions sont éloignées, i.e. à partir de quelle tolérance d'écart on rejette que les distributions sont différentes)
#    => chercher des tests d'équivalence pour autre chose que l'égalité des moyennes
# 2. utiliser une mesure de la dissimilarité: cf. comp.prop
#(3. faire des tests multivariés, dans l'espoir qu'ils soient moins conservateurs: ces tests "moyennent" effectivement les résultats, mais avec un fort rejet de la dissimilarité quelque part, rejettent la similarité)
#(4. utiliser les poids pour l'échantillon CCC externe: ça ne change pas les résultats, cf. par ex. confiance_gens)
# 5. exploiter le sondage Étilé et la deuxième vague du sondage externe pour sélectionner les variables qui ont une distribution stable

# 4. confiance_gens: 
t.test(c$confiance_gens=='Confiant', e$confiance_gens=='Confiant') # p < 1e-8
t.test(rep(c(F,T), c(67,33)*20), e$confiance_gens=='Confiant') # p < 1%: différence entre 12/2019 CEVIPOF et 04/2020 CCC_externe
t.test(rep(c(F,T), c(67,33)*20), rep(c(F,T), c(70,30)*20)) # p = 4%: différence entre 12/2018 et 12/2019 CEVIPOF
decrit(e$confiance_gens, weight = F)
decrit(e$confiance_gens, weight = T) # utiliser les poids ne changera rien

# redistribution: différent
npunitest(as.numeric(c$redistribution_1e[!is.na(c$redistribution_1e)]), as.numeric(e$redistribution)) # p < 2e-16 Maasoumi & Racine: 400 bootstraps takes 10 min
npdeneqtest(as.data.frame(list(as.numeric(c$redistribution[!is.na(c$redistribution)])), col.names=c('redistr')), as.data.frame(list(as.numeric(e$redistribution)), col.names=c('redistr'))) # p < 2e-16 
# Hellinger = 0.19 (rule of thumb: close if H < 0.05). Bhattacharyya coef = 0.96 (almost equal: 1), dissimilarity (L^1 distance in frequencies): 21%, Pearson > q5%, d.h0: equality rejected
comp.prop(c("1"=0.0001, table(c$redistribution_1e)), table(e$redistribution), length(which(!is.na(c$redistribution_1e))), ref=T)
comp.prop(c("1"=0.0001, table(c$redistribution_1e)), table(e$redistribution), length(which(!is.na(c$redistribution_1e))), length(which(!is.na(e$redistribution)))) # Hellinger
g.test(c("1"=0.0001, table(c$redistribution_1e)), table(e$redistribution), rescale.p = T) # NA G-test
disc_ks_test(c$redistribution_1e, ecdf(e$redistribution), exact=T) # p = 2e-4 Kolmogorov - Smirnov 
cvm.test(c$redistribution_1e, ecdf(e$redistribution)) # Error Cramer - von Mises
tost(c$redistribution_1e - mean(e$redistribution), epsilon = 1) # difference > 1 not rejected p = .15
tost(c$redistribution_1e - mean(e$redistribution), epsilon = 1.2) # difference > 1.2 rejected p = .06
t.test(c$redistribution_1e, e$redistribution) # p < 1e-3 mean different

# importance_confort: moyenne semblables, différence < 0.6 (tost), tests plus conservateurs rejettent égalité
npunitest(as.numeric(c$importance_confort_1e[!is.na(c$importance_confort_1e)]), as.numeric(e$importance_confort)) # p = 2% Maasoumi & Racine: 400 bootstraps takes 10 min
npdeneqtest(as.data.frame(list(as.numeric(c$importance_confort_1e[!is.na(c$importance_confort_1e)])), col.names=c('x')), as.data.frame(list(as.numeric(e$importance_confort)), col.names=c('x'))) # p = 1%
# Hellinger = 0.14 (rule of thumb: close if H < 0.05). Bhattacharyya coef = 0.98 (almost equal: 1), dissimilarity (L^1 distance in frequencies): 15%, Pearson > q5%, d.h0: equality rejected
# TODO: mesure robuste au nombre de catégories
comp.prop(c("1"=0.0001, table(c$importance_confort_1e)), table(e$importance_confort), length(which(!is.na(c$importance_confort_1e))), ref=T)
comp.prop(c("1"=0.0001, table(c$importance_confort_1e)), table(e$importance_confort), length(which(!is.na(c$importance_confort_1e))), length(which(!is.na(e$importance_confort)))) # Hellinger
g.test(c("1"=0.0001, table(c$importance_confort_1e)), table(e$importance_confort), rescale.p = T) # NA G-test
disc_ks_test(c$importance_confort_1e, ecdf(e$importance_confort), exact=T) # p = 1% Kolmogorov - Smirnov 
cvm.test(c$importance_confort_1e, ecdf(e$importance_confort)) # Error Cramer - von Mises
tost(c$importance_confort_1e - mean(e$importance_confort), epsilon = 0.6) # difference > 0.6 rejected p = 2%
t.test(c$importance_confort_1e, e$importance_confort) # p = 19% mean not different

# importance_environnement: mean différents, y compris entre ADEME et externe
ademe_importance_environnement <- rep(1:10, round(c(0,0,1,1,7,6,15,26,21,22)*15.7))
t.test(ademe_importance_environnement, e$importance_environnement) # means different => t.test ineploitable (cela dit, formulations différentes / et ça reste très proche)
t.test(ademe_importance_environnement, c$importance_environnement_1e)

# 3. cas multivarié: "moyenne" les résultats : la combinaison d'un test rejetant la similarité (p = 1%) et d'un ne la rejetant pas (p = 66%), la p-value est intermédiaire (p = 10%). 
#                                           Quand on ajoute une variable où la similarité est fortement rejetée (p < 2e-16), c'est la dissimilarité qui l'emporte
npdeneqtest(as.data.frame(list(as.numeric(c$importance_confort_1e[c$not_any_imp_na==T])), col.names=c('imp_conf')), as.data.frame(list(as.numeric(e$importance_confort)), col.names=c('imp_conf'))) # Tn=4 p = 1%
npdeneqtest(as.data.frame(list(as.numeric(c$importance_environnement_1e[c$not_any_imp_na==T])), col.names=c('imp_env')), as.data.frame(list(as.numeric(e$importance_environnement)), col.names=c('imp_env'))) # Tn=16 p < 2e-16
npdeneqtest(as.data.frame(list(as.numeric(c$importance_associatif_1e[c$not_any_imp_na==T])), col.names=c('imp_asso')), as.data.frame(list(as.numeric(e$importance_associatif)), col.names=c('imp_asso'))) # Tn=260 p = 66% 
c$not_any_imp_na <- !is.na(c$importance_confort_1e) & !is.na(c$importance_associatif_1e) & !is.na(c$importance_environnement_1e)
npdeneqtest(as.data.frame(list(as.numeric(c$importance_confort_1e[c$not_any_imp_na==T]), as.numeric(c$importance_environnement_1e[c$not_any_imp_na==T]), 
                               as.numeric(c$importance_associatif_1e[c$not_any_imp_na==T])), col.names=c('imp_conf', 'imp_env', 'imp_asso')),
            as.data.frame(list(as.numeric(e$importance_confort), as.numeric(e$importance_environnement), as.numeric(e$importance_associatif)), col.names=c('imp_conf', 'imp_env', 'imp_asso'))) # Tn=12 p < 2e-16
npdeneqtest(as.data.frame(list(as.numeric(c$importance_confort_1e[c$not_any_imp_na==T]), as.numeric(c$importance_associatif_1e[c$not_any_imp_na==T])), col.names=c('imp_conf', 'imp_asso')),
            as.data.frame(list(as.numeric(e$importance_confort), as.numeric(e$importance_associatif)), col.names=c('imp_conf', 'imp_asso'))) # Tn=66 p = 10.03%
npdeneqtest(as.data.frame(list(as.numeric(c$importance_environnement_1e[c$not_any_imp_na==T]), as.numeric(c$importance_associatif_1e[c$not_any_imp_na==T])), col.names=c('imp_env', 'imp_asso')),
            as.data.frame(list(as.numeric(e$importance_environnement), as.numeric(e$importance_associatif)), col.names=c('imp_env', 'imp_asso'))) # Tn=66 p = 10.03%

# 0. socio-démos: c'est globalement représentatif, cf. sociodemo.pdf (de Jérôme Lang)
# CSP: représentatif, même si les étudiants et inactifs sont sur-représentés
decrit(c$statut_emploi_2s)
chisq.test(c(27, 10, 16, 16, 9, 4, 1, 18)*1.5, p = c(325,114,150,136,101,35,8,129)/998, simulate.p.value = T) # similarité pas rejetée
t.test(rep(c(T,F), c(16*1.5, 150-16*1.5)), mu = 0.193) # égalité de la proportion de cadres ne peut pas être rejetée (p = 19%)
t.test(rep(c(T,F), c(29*1.5, 150-29*1.5)), mu = 0.256) # égalité de la proportion d'intermédiaires ne peut pas être rejetée (p = 26%)
# chisq.test(c(18, 29, 29, 16, 7, 2)*1.5, p = c(19.6, 26.8, 25.6, 19.3, 6.7, 1.5)/99.5, simulate.p.value = T) # similarité pas rejetée (p = 80%)
# chisq.test(c(18, 29, 29, 16, 7, 2)*1.5, p = c(11.4+8.1,15+10.2,13.6+6.7,10.1+4,3.5+2.4,0.8+1.1)/86.9, simulate.p.value = T) # similarité pas rejetée en intégrant les inactifs (p = 66%) insee.fr/fr/statistiques/2381478
t.test(rep(c(T,F), c(13,87)*1.5), mu = 0.078) # égalité de la proportion d'étudiants rejetée à 10% (p = 8%)
t.test(rep(c(T,F), c(18,82)*1.5), mu = 0.129) # égalité de la proportion d'étudiants rejetée à 15% (p = 11%)

# age: représentatif des 16-79 ans (mais pas des 16-120 ans)
chisq.test(c(18,28,24,14,14)*1.5, p = c(4.2+6.8+7.5,7.9+8.4+8.6,8.7+7.9+8.2,7.8+7.2,7.3+0.8*8.1)/96.98, simulate.p.value = T) # similarité pas rejetée (p = 96%)
chisq.test(c(0,18,28,24,14,14)*1.5, p = c(12.1,4.2+6.8+7.5,7.9+8.4+8.6,8.7+7.9+8.2,7.8+7.2,7.3+0.8*8.1)/109.08, simulate.p.value = T) # similarité rejetée quand on tient compte des > 80 ans (p = 0.1%)

# statut logement: il faudrait comparer avec l'Insee mais similarité rejetée à 10% (p = 8%): les propriétaies sont sous-représentés dans la CCC
decrit(c$statut_logement_1e) # 51% de proprios, 36% de locataires, 12% hébergé
decrit(e$proprio_occupant) # 58%
decrit(e$locataire) # 34% 
decrit(e$heberge_gratis) # 8%
decrit(e$heberge_gratis + e$locataire + e$proprio_occupant == 1) # 99%
decrit(e$proprio_bailleur) # 3%
chisq.test(c(50.7,35.8,12.2)*1.5, p = c(58,34,8)/100, simulate.p.value = T) # similarité rejetée à 10% (p = 8%)
t.test(rep(c(T,F), c(50.7,49.3)*1.5), mu = 0.58) # égalité rejetée ) 9%

# diplome: représentatif
chisq.test(c(26,21,19,21,13), c(c(0.290,0.248,0.169,0.293)*(1-0.1085),0.1085)) # similarité non rejetée (p = 24%)

# region: représentatif TODO: autres régions que outre-mer
t.test(rep(c(T,F), c(5,95)*1.5), mu = 2165749/67063703) # similarité de la population outre-mer non rejetée


##### Comparaison CCC avec AT #####
decrit(c$pour_taxe_transports_2e) # rien dans 1e, la seule qu'on peut vraiment exploiter


#### Comparaison CCC avec autres sondages ####
c$satisfaction_vie_1e
# agis_CC, date_preoccupation_CC_1e, cause_catastrophes_1e, cause_pauvrete_1e, satisfaction_vie_1e
# (outres celles ci-dessus, e.g. cause_CC_CCC, importance_, problemes_invisibilises, redistribution, confiance_gens, pour_taxe_carbone, qualite_enfant)

# changement climatique: CCC 20-30% plus préoccupés et pessimistes concernant le CC. ADEME: juillet 2019 => trouver données solange.martin@ademe.fr
decrit(c$cause_catastrophes_1e) # *** ADEME (2019: 43) changement: 58% (88%) / personne: 20% (9%) / naturels: 20% (3%) / NSP: 2%
decrit(c$effets_CC_1e) # ** ADEME (2019: 54) pénibles: 65% (85%) / s'adaptera: 32% (15%) / positif: 2% / NSP: 1%
decrit(c$issue_CC_1e) # ~ ADEME (2019: 69) -2: 13% (6%) / -1: 50% (52%) / 1: 31% (39%) / 2: 5% (3%)
decrit(c$solution_CC_1e) # ** modifier: 52% (75%) / états: 19% (15%) / inévitable: 17% (4%) / progrès: 11% (5%)
decrit(c$agis_) # ADEME (2019: 115)
decrit(c$importance_environnement_1e) # ADEME (2019: 174) aussi http://www.batiment-energie.org/doc/31/Livrable-N-4.2-CERTOP-V1-22072014-F.pdf p. 67
decrit(c$pour_vitesse_110_1e) # 102
decrit(c$obstacles_) # 

decrit(c$situation_revenus_1e) # Ipsos (2017) mais résultats non donnés
decrit(c$redistribution_1e) # Ipsos (2019) 66% d'accord 
decrit(c$problemes_invisibilises_1e) # Très: 18% (12%) / Assez souvent: 33% (45%) / Rarement: 17% (peu souvent: 41%) / jamais: 31% (3%) / NSP: 2%.  CREDOC, Enquête « Conditions de vie et Aspirations », 2015 

# TODO: socio-démos CCC CoGouv
# TODO: indice méfiance/confiance CCC (variables_CCC_avis)


##### Avis CCC #####
decrit(e$connait_CCC)
e$avis_CCC <- (e$CCC_prometteuse_climat + e$CCC_espoir_institutions + e$CCC_initiative_sincere + e$CCC_entendre_francais + e$CCC_representative
               - e$CCC_inutile - e$CCC_vouee_echec - e$CCC_operation_comm - e$CCC_pour_se_defausser - e$CCC_controlee_govt)
e$avis_CCC[e$connait_CCC=='Non'] <- NA # TODO: labels, y.c. dans CCC_inutile etc. pour dire où sont NA
decrit(e$avis_CCC) # médiane : -1
e$confiance_CCC <- (e$CCC_prometteuse_climat + e$CCC_espoir_institutions + e$CCC_initiative_sincere + e$CCC_entendre_francais + e$CCC_representative) > 0
e$confiance_CCC[e$connait_CCC=='Non'] <- NA
e$mefiance_CCC <- (e$CCC_inutile + e$CCC_vouee_echec + e$CCC_operation_comm + e$CCC_pour_se_defausser + e$CCC_controlee_govt) > 0
e$mefiance_CCC[e$connait_CCC=='Non'] <- NA
e$mitige_CCC <- e$confiance_CCC & e$mefiance_CCC
decrit(!(e$confiance_CCC | e$mefiance_CCC | e$CCC_autre_choix)) # 0 tous les répondants ont répondu
decrit(e$confiance_CCC) # 54%
decrit(e$mefiance_CCC) # 68%
decrit(e$mitige_CCC) # 24%
decrit(e$CCC_inutile)
decrit(e$CCC_inutile, which = e$connait_CCC=='Non')
decrit(e$CCC_representative) # 11%
decrit(e$CCC_controlee_govt) # 16%
e$nb_avis_CCC <- (e$CCC_prometteuse_climat + e$CCC_espoir_institutions + e$CCC_initiative_sincere + e$CCC_entendre_francais + e$CCC_representative
               + e$CCC_inutile + e$CCC_vouee_echec + e$CCC_operation_comm + e$CCC_pour_se_defausser + e$CCC_controlee_govt + e$CCC_autre_choix)
e$nb_avis_CCC[e$connait_CCC=='Non'] <- NA 
decrit(e$nb_avis_CCC) # mean 2.5, median 2
# TODO: voir les déterminants

# TODO: clusters mesures incitatif/contraignant, sur quoi ça porte
# TODO: combien il faudrait faire varier gauche/droite pour retrouver les réponses qualite_enfant CCC à partir de externe
# TODO: variable importance_preferee

# TODO: working paper avec principaux résultats + mesure dissimilarité robuste au nombre de catégories


##### 2è vague #####
decrit(e$duree/60)
decrit(e$region)
decrit(e$random)
decrit(e$dividende) #
decrit(e$origine_taxe) #
decrit(e$conso)
decrit(e$conso_embedded) # better than conso
# round(e$conso[which(round(e$conso)!=n(e$conso_embedded))])
# n(e$conso_embedded[which(round(e$conso)!=n(e$conso_embedded))])
decrit(e$km)
decrit(n(e$km_embedded))
decrit(e$surface)
summary(lm(taxe_approbation!="Non" ~ dividende * origine_taxe, data=e))
summary(lm(taxe_feedback_approbation!='Non' ~ variante_taxe_alternative, data=e))
decrit(e$taxe_approbation, miss=T)
decrit(e$taxe_feedback_approbation, miss=T)
decrit(e$soutien_parti)
decrit(e$pour_28h)
decrit(e$referendum_ecocide)
decrit(e$referendum_environnement_constitution)
decrit(e$referendum_environnement_priorite_constit)
decrit(e$avis_estimation) #
decrit(e$gain_net_choix) #
decrit(n(e$gain_net_gain)) #
decrit(n(e$gain_net_perte)) #
decrit(e$gain_subjectif) #
summary(lm(gain_subjectif==0 ~ dividende, data = e)) #
decrit(e$hausse_depenses) #
decrit(e$uc)
decrit(e$hausse_depenses/e$uc) #
decrit(e$gagnant_feedback_categorie) #
decrit(e$certitude_gagnant, numbers=T) #
decrit(e$certitude_gagnant_feedback) #
summary(lm(certitude_gagnant <= 0 ~ gain_net_choix + dividende, data=e)) #
summary(lm(certitude_gagnant < 0 ~ gain_net_choix + dividende, data=e)) #
summary(lm(gain_subjectif == 0 ~ dividende, data=e)) #
decrit(e$gain_subjectif == 0) #


##### Représentativité CCC #####
e2$nombre_non_representative <- 0
for (i in variables_CCC_non_representative) e2$nombre_non_representative <- e2$nombre_non_representative + 1*e2[[i]]
decrit(e2$representativite_CCC)
decrit("nombre_non_representative", data = e2, which = e2$representativite_CCC=="Non")


##### Financement #####
for (i in 1:20) {
  print(i)
  print(table(ccc[[paste("s7_q29", i, sep="_")]])) }
print(table(ccc$s7_q29_20))


##### Évolution suite à CCC #####
# signes faibles: pour_sortition, problemes_invisibilises, obligation_renovation (y.c. referendum), CCC_avis


##### Externe non CCC ####
# responsable_CC cause_CC_AT et autres questions perceptions CC
# part_anthropique efforts_relatifs soutenu_ (majorité) pour_taxe_carbone : perceptions des croyances
# champ_libre, politique, parti, pour_28h, rôle député, voter_contre

# confiance: pour_taxe_carbone ; origine*label y.c. urba/détaxe ; confiance_dividende (gagnant_categorie = ça + hausse_depenses) ; hause_depenses (écart à réalité) ; 
#            certitude (qui ?) ; confiance_gouvernement ; dividende + gain_net ; avis_estimation
# feedback: effet sur certitude, sur gagnant_categorie, sur approval
# perceptions des croyances: soutenu_ part_anthropique efforts_relatifs
# déterminants/corrélats: trop_impots redistribution confiance_gens problemes_invisibilises

# pour_taxe_carbone: *** bandwagon 3
# confiance_gouvernement: autre "cue" 3
# origine*label: pas spécifique au gouv/label, EELV pas mieux 3
# urba/détaxe: pas spécifique à la formule 3
# évolution depuis 2019: post GJ, mais ptet cadrage joue 3
# confiance_dividende: pas confiance 1
# confiance_gouvernement ~ confiance_dividende: imputer le dividende escompté à partir de confiance_gouv et déduire le % de perdants que ça explique 1
# dividende + gain_net: confirmation plus subtile 1
# hause_depenses: biais existe... TODO
# bénéfices/problèmes, gagnants/perdants: biais existent 0
# certitude: perdants + sûrs va contre hypothèse aversion perte 2
# perte_relatif: faible écart à la moyenne, plutôt contre hyp qu'ils s'imaginent à tort particuliers 2 TODO
# avis_estimation: peut expliquer un peu la croyance incidence: ~20% 2
# effet du feedback: 26% des gagnants pessimistes s'alignent, 53% maintiennent 2

# 0 Carbon tax aversion + b/p g/p
# 1 nouveau mécanisme pour croyance incidence: le dividende: joue, mais n'explique pas tout
#     ptet un proxy pour exprimé doute plus général / moins verbalisable ("ça sent la douille") mais qui peut traduire des craintes légitimes e.g. actifs échoués, hausse prix (éq gen)
# 2 autres mécanismes potentiels pour croyance incidence
# 3 rôle du contexte, des acteurs et de la formule


##### *** Plan présentation Cired *** #####
# Pourquoi tant de Perdant (v0, v1)?
# 1 confiance_dividende
# 1.a semble tout expliquer dans v1
decrit(e1$confiance_dividende) # 46/42/12 Non/Moitié/Oui
summary(lm(gagnant_categorie=="Perdant" ~ as.factor(confiance_dividende), data=e1, weights = e1$weight)) # +28/48*** 30% de Perdant parmi ceux qui croient au dividende: le bon chiffre
# summary(lm(gagnant_categorie=='Perdant' ~ (confiance_gouvernement < 0) * as.factor(confiance_dividende), data = e1, weights = e1$weight)) # capture confiance_gouv: tout passe par là
summary(lm(taxe_approbation!="Non" ~ as.factor(confiance_dividende), data=e1, weights = e1$weight)) # +37/46***
decrit(e1$gain < 0) # 53%
decrit(e1$gain_min < 0) # 69%
#     gain, gain_min bon prédicteurs de Perdant (84 vs 77%) et Gagnant (14 vs 34%) (cf. Biais & ...)
#     Parmi le peu qui croient recevoir le dividende, gagnant_categorie est bien plus alignée avec la réponse objective: +32***p.p.
summary(lm(((simule_gain_verif > 0 & gagnant_categorie!='Perdant') | (simule_gain_verif < 0 & gagnant_categorie!='Gagnant')) ~ as.factor(confiance_dividende), data=e1, weights = e1$weight)) # 0.36***
#     plus d'update correct parmi ceux qui ont confiance dans dividende, les non GJ et ceux qui approuvent
summary(lm(update_correct ~ confiance_dividende, subset = feedback_infirme_large==T, data=e1, weights = e1$weight)) # 0.14***
summary(lm(taxe_approbation!="Non" ~ question_confiance, data=e1, weights = e1$weight)) # pas d'influence de la question
summary(lm(gagnant_categorie=="Perdant" ~ question_confiance, data=e1, weights = e1$weight)) # pas d'influence de la question
# 1.b cet effet peut être mesuré plus finement dans v2
summary(lm(gain ~ as.factor(dividende), data = e2, weights = e2$weight)) # 70/75% du dividende pris en compte
summary(lm(gain ~ as.factor(dividende) * (origine_taxe=="EELV"), data = e2, weights = e2$weight)) # 61/70% du dividende pris en compte qd gouv, mais...
impute_dividende_escompte(print=T) # .33 part du dividende pris en compte d'après gain, gain_min (imputée)
impute_dividende_escompte(escompte_moitie = 0.8, escompte_non = 0.3, print=T) # .59 ajustement nécessaire pour se rapprocher de l'escompte réel: marche encore, mais pas si extrême que ce qu'on pensait
#  => confiance_dividende: ptet un proxy pour exprimé doute plus général / moins verbalisable ("ça sent la douille") mais qui peut traduire des craintes légitimes e.g. actifs échoués, hausse prix (éq gen)
#     37% Perdants hors NSP: le dividende escompté ajusté (+ gain fiscal) suffit à l'expliquer (pas aussi extrême que v1)
wtd.mean(e2$simule_gain[e2$dividende==110] < 0, weights = e2$weight[e2$dividende==110]) # 36% gain fiscal
# wtd.mean(e2$simule_gain[e2$dividende==170] < 0, weights = e2$weight[e2$dividende==170]) # 11% gain fiscal
decrit("gagnant_categorie", data=e1) # 60/9
decrit("gagnant_categorie", data=e2, which = e2$dividende==110, miss=T) # 25/24 perdants Pk telle différence ? ajout de "NSP" explique 20 p.p., cadrage 15 p.p. (v1: juste avant: hausse dépenses, v2 formulation plus douce)
summary(lm(pour_taxe_carbone!="Non" ~ vague, data=eb)) # ne s'explique pas par évolution des préférences a priori
decrit("gagnant_categorie", data=e2, which = e2$dividende==0, miss=T) # 48/4 Perdants gagne 20 p.p. au profit de Gagnant (qui passe à 4%), les autres restent stables: logique
decrit("gagnant_categorie", data=e2, which = e2$dividende==170, miss=T) # 11/30 Plus que 11% de Perdants, les 14% en moins se sont répartis en trois tiers entre NSP, NA et G
wtd.mean((e2$simule_gain + e2$dividende_escompte_ajuste - (e2$dividende * pmin(2, e2$nb_adultes)/e2$uc))[e2$dividende==110] < 0, weights = e2$weight[e2$dividende==110]) # 56% explique le 25/24
wtd.mean((e2$simule_gain + e2$dividende_escompte_ajuste - (e2$dividende * pmin(2, e2$nb_adultes)/e2$uc))[e2$dividende==170] < 0, weights = e2$weight[e2$dividende==170]) # 34% explique le 11/30
wtd.mean((e2$simule_gain + e2$dividende_escompte_impute - (e2$dividende * pmin(2, e2$nb_adultes)/e2$uc))[e2$dividende==110] < 0, weights = e2$weight[e2$dividende==110]) # 69% prédit trop de perdants
wtd.mean((e2$simule_gain + e2$dividende_escompte_impute - (e2$dividende * pmin(2, e2$nb_adultes)/e2$uc))[e2$dividende==170] < 0, weights = e2$weight[e2$dividende==170]) # 58% prédit trop de perdants
#     effet de AEJ:EP confirmé (pas de rapport avec explication de l'origine d'autant de perdants)
summary(ivreg(taxe_approbation!='Non' ~ gain | as.factor(dividende), data=e2, weights = e2$weight), diagnostics = TRUE) # F-stat: 57 $diagnostics[1,3]
summary(ivreg(taxe_approbation!='Non' ~ (gain > 0) | as.factor(dividende), data=e2, weights = e2$weight), diagnostics = TRUE) # effet 0.46***
summary(lm(taxe_approbation!='Non' ~ as.factor(dividende), data=e2, subset = origine_taxe=="gouvernement", weights = e2$weight)) # 2/6
summary(lm((gain > 0) ~ as.factor(dividende), data=e2, subset = origine_taxe=="gouvernement", weights = e2$weight)) # 2/6
# 1.c Mais le dividende n'explique pas tout
#     Potentiellement sa non-prise en compte est largement inintentionnelle
#     L'évolution de gagnant_categorie ne s'explique pas par dividende puisque celui-ci ne varie pas pour 110
# 2 autres mécanismes 
# 2.a o effet de cadrage 
#     ajout de "NSP" explique 20 p.p., contexte & formulation 15 p.p. (v1: juste avant: hausse dépenses, v2 formulation plus douce)
e2$Gagnant_categorie <- relevel(as.factor(as.character(e2$Gagnant_categorie)), "Non affecté")
summary(lm(taxe_approbation=='Oui' ~ Gagnant_categorie, data=e2, weights = e2$weight)) 
summary(lm(pour_taxe_carbone!="Non" ~ vague, data=eb)) # c'est bien cadrage et pas évolution des croyances entre deux vagues (qui aurait affecté approbation); effet limité à l'explication des réponses à Perdant: biais plus faible qu'on pensait mais pas des biais restent
# 2.b o biais: s'imaginent à tort particuliers
decrit("perte_relative_partielle", data=b) # v0 environ 60% pensent perdre plus que la moyenne (proportions similaires pour TVA, fioul, gaz)
summary(lm(gagnant_categorie == "Perdant" ~ perte_relative_partielle > 0, data = b, weights = b$weight)) # +21***
decrit(e1$perte - e1$hausse_depenses_verif > 30) # 19% sur-estiment les hausses de dépenses de plus de 30€/UC
decrit(e1$perte - e1$hausse_depenses_verif < -30) # 56% sous-estiment les hausses de dépenses de plus de 30€/UC ! TODO comparer à v0, voir dans v0 s'ils surestiment aussi plus perte_partielle
# 2.c o méfiance envers l'estimation: le biais précédent doublé d'une meilleure confiance en eux qu'en nous
decrit("avis_estimation", data = e2) #  34/31/12 Trop peu/Correct/Trop
#     Comme ceux qui croient à notre estimation intègrent le dividende, l'effet doit passer par hausse_depenses et pas seulement dividende.
decrit(e2$gain + e2$hausse_depenses_par_uc, which = (e2$avis_estimation %in% c("Correcte", "NSP")) & e2$dividende==0, weights = e2$weight) # mean 4 / médiane 3 : dividende qu'ils croient recevoir s'ils acceptent notre estimation
decrit(e2$gain + e2$hausse_depenses_par_uc, which = (e2$avis_estimation %in% c("Correcte", "NSP")) & e2$dividende==110, weights = e2$weight) # 110 / 125
decrit(e2$gain + e2$hausse_depenses_par_uc, which = (e2$avis_estimation %in% c("Correcte", "NSP")) & e2$dividende==170, weights = e2$weight) # 150 / 172
#     Ceux qui nous croient approuvent +.24*** (TODO!: corrélation avec confiance_gouv), sauf pour ceux qui répondent gagnant_categorie=NSP, qui doutent probablement du dividende
summary(lm(taxe_approbation=="Oui" ~ as.character(avis_estimation), data = e2, weights = e2$weight)) # 46% Oui quand estimation correcte, ***26 p.p. de plus que les autres
summary(lm(taxe_approbation=="Oui" ~ (avis_estimation=="Correcte") * I(gagnant_categorie %in% c("NSP")), data = e2, weights = e2$weight))
#     Pour résumé: il n'y pas qu'un manque de confiance dividende, aussi la croyance de perdre plus que ce qu'on leur dit, et il y a des doutes dividende non pris en compte plus haut car ils s'expriment comme NSP
# 2.d x incertitude + aversion à la perte: prédit faible certitude et que les moins sûrs se pensent plus perdants, c'est le contraire qu'on observe
decrit("certitude_gagnant", data=e1)  # 
CrossTable(e1$certitude_gagnant, e1$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # Il y a plus de perdants parmi ceux qui sont sûrs de leur réponse
# 2.e x raisonnement motivé: lié à méfiance mais ici la non-intégration d'une info n'est pas liée à la source de l'info mais à sa teneur. On s'attend à asymétrie dans update.
#     contrairement à v0, on ne peut pas mettre en évidence asymétrie dans l'update: les perdants optimistes sont 40% (4) à s'aligner (contre 82% (~45) en v0) et les gagnants pessimistes 26% (contre 12%), échantillon trop faible
#     pourquoi ça aurait changé ? Évolution des opinions; cadrage (certitude, (question_confiance, hausse_depenses plutôt que gain)); hasard (on ne peut pas exclure qu'il y ait de l'asymétrie); 
#       ou bien l'asymétrie était drivée par les diesel_2_1 = T TODO!: check
CrossTable(e1$gagnant_categorie[e1$simule_gagnant==1 & e1$bug_touche==F], e1$gagnant_feedback_categorie[e1$simule_gagnant==1 & e1$bug_touche==F], prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
CrossTable(e1$gagnant_categorie[e1$simule_gagnant==0 & e1$bug_touche==F], e1$gagnant_feedback_categorie[e1$simule_gagnant==0 & e1$bug_touche==F], prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
# Conclusions: dividende, cadrage, biais: on a toujours plusieurs façons différentes d'expliquer les données, on a éliminé des explications mais on ne peut pas en singulariser une seule. Mtn on se demande presque pourquoi il n'y a pas plus de gens qui se disent Perdants.
# Quoi d'autre que les 3 motifs influent sur approbation ? Confiance est une raison omniprésente
# 3 rôle du contexte, des acteurs et de la formule: 
# 3.a Évolution de l'opinion, singularité de l'épisode des GJ mais on ne peut pas excluse que cadrage joue. TODO!: ajouter autres sources
decrit(b$taxe_approbation, miss = T) # 71/10 Non/Oui 
decrit(e1$taxe_approbation, miss = T) # 47/23
decrit(e2$taxe_approbation, which=e2$dividende==110 & e2$origine_taxe=="gouvernement", miss = T) # 42/29
# 3.b Effet du dividende (recherche a montré effet de montant taxe, ici on montre le dual)
decrit(e2$taxe_approbation, which=e2$dividende==0 & e2$origine_taxe=="gouvernement", miss = T) # 44/31
decrit(e2$taxe_approbation, which=e2$dividende==170 & e2$origine_taxe=="gouvernement", miss = T) # 35/36
# decrit(e2$taxe_approbation, which=e2$dividende==110, miss = T) # 45/25
# decrit(e2$taxe_approbation, which=e2$dividende==0, miss = T) # 51/26 TODO: image des 5
# decrit(e2$taxe_approbation, which=e2$dividende==170, miss = T) # 34/33
# 3.c Effet de la formule: change pas grand chose
decrit(e2$taxe_alternative_approbation[e2$variante_alternative=="détaxe"], miss = T) # 46/25 Non/Oui
decrit(e2$taxe_alternative_approbation[e2$variante_alternative=="urba"], miss = T) # 46/28
# 3.d Effet origine, label: faibles
summary(lm(taxe_approbation!='Non' ~ label_taxe * origine_taxe * question_confiance, data=e1, weights = e1$weight)) # pas d'effect
summary(lm(taxe_approbation!='Non' ~ origine_taxe * as.factor(dividende), data=e2, weights = e2$weight)) # l'effet du gouv/EELV ne passe que pour dividende=0, donc pas lié à confiance_dividende
summary(lm(confiance_dividende!='Non' ~ label_taxe * origine_taxe, data=e1, weights = e1$weight)) # no effect
# 3.d Effet de confiance_gouvernement
#     méfiance gouv est capturée par méfiance dividende pour expliquer Perdant. confiance_gouv augmente proba NA (v1) mais pas corrélé avec gagnant_categorie (v2)
decrit("confiance_gouvernement", data=e1, miss=T) # 26/38/18/14 jamais/parfois/moitié/plupart temps
summary(lm(gagnant_categorie=='Perdant' ~ (confiance_gouvernement < 0), data = e1, weights = e1$weight)) # gouv: 0.16**
# summary(lm(gagnant_categorie=='Perdant' ~ (confiance_gouvernement < 0), data = e2, weights = e2$weight)) # gouv: 0.03 Pas corrélé suggère encore une fois que ceux qui doutent du gouv/dividende répondent NSP
summary(lm(gagnant_categorie=='Perdant' ~ (confiance_gouvernement < 0) * as.factor(confiance_dividende), data = e1, weights = e1$weight)) # confiance_gouv pas significatif / dividende -0.27*** et -0.45***
summary(lm(tax_acceptance ~ (confiance_gouvernement < 0), data = e1, weights = e1$weight)) # -.14***
summary(lm(tax_acceptance ~ (confiance_gouvernement < 0) * as.factor(confiance_dividende), data = e1, weights = e1$weight)) # confiance_gouv pas significatif / dividende 0.38*** et 0.46***
summary(lm(tax_acceptance ~ (confiance_gouvernement < 0), data = e2, weights = e2$weight)) # -.09***
# 3.e Effet bandwagon 
summary(lm(pour_taxe_carbone!='Non' ~ variante_taxe_carbone, data=eb, weights = eb$weight)) # +10**
summary(lm(pour_taxe_carbone=='Oui' ~ variante_taxe_carbone, data=eb, weights = eb$weight)) # +8***


##### Problème conso L/100km ##### 
length(which(abs(e$hausse_essence_verif_na - e$hausse_essence) > 0.001)) # toutes dans e$bug==F
length(which(abs(e$hausse_diesel_verif_na - e$hausse_diesel) > 0.001)) # hausse_diesel et _essence ont été calculées avec la conso moyenne (pas celle renseignée par le répondant) pour bug = T
length(which(abs(e$hausse_essence_verif - e$hausse_essence) > 0.001)) # toutes dans e$bug==T # pour e2 les problèmes n'en sont pas, c'est que les calculs de _verif sont moins corrects que les autres
length(which(abs(e$hausse_diesel_verif - e$hausse_diesel) > 0.001))


##### Gagnant catégorie #####
# v1: 60% perdants 9% G (v0: 64%/14%) / v2: 37% (s'explique par cadrage, pas par évolution préf)
decrit("gagnant_categorie", data=e1) # TODO!: image Séparer e1 et e2. Si possible utiliser plus que 3 couleurs pour voir intensité des gains
decrit("gagnant_categorie", data=e1, which = e1$question_confiance==T) # pas d'influence de la question
decrit("gagnant_categorie", data=e2, which = e2$dividende==110, miss=T) # 37% perdants Pk telle différence ? ajout de "NSP" explique 20 p.p., cadrage 15 p.p. (v1: juste avant: hausse dépenses, v2 formulation plus douce)
summary(lm(pour_taxe_carbone!="Non" ~ vague, data=eb)) # ne s'explique pas par évolution des préférences a priori
decrit("gagnant_categorie", data=e2, which = e2$dividende==0, miss=T) # Perdants gagne 20 p.p. au profit de Gagnant (qui passe à 4%), les autres restent stables: logique
decrit("gagnant_categorie", data=e2, which = e2$dividende==170, miss=T) # Plus que 11% de Perdants, les 14% en moins se sont répartis en trois tiers entre NSP, NA et G
decrit("hausse_depenses", data=e2, which = e2$dividende==0 & e2$gagnant_categorie=="Non affecté") # Ces NA ont des hausses_depenses 70€ plus faibles que les autres
decrit("hausse_depenses", data=e2, which = e2$dividende>0 & e2$gagnant_categorie=="Non affecté") # Ceux-là ont les mêmes hausses_depenses que les autres
decrit("hausse_depenses", data=e2)


##### Feedback #####
# contrairement à v0, pas d'asymétrie dans l'update: les perdants optimistes sont 40% (4) à s'aligner (contre 82% (~45) en v0) et les gagnants pessimistes 26% (contre 12%)
# pourquoi ça a changé ? Évolution des opinions; cadrage (certitude, (question_confiance, hausse_depenses plutôt que gain)); hasard (on ne peut pas exclure qu'il y ait de l'asymétrie); 
#   ou bien l'asymétrie était drivée par les diesel_2_1 = T TODO: check
decrit("simule_gagnant", data=e1)
decrit("bug_touche", data=e1) # 80% des ménages avec 2 voitures dont la pcpale au diesel sont touchés par un bug
decrit("simule_gagnant", data=e1, which = e1$bug_touche==F) # 77% (v0: 76%) Crosstab similaire à v0 (D.2 p. 55)
CrossTable(e1$gagnant_categorie[e1$simule_gagnant==1 & e1$bug_touche==F], e1$gagnant_feedback_categorie[e1$simule_gagnant==1 & e1$bug_touche==F], prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
CrossTable(e1$gagnant_categorie[e1$simule_gagnant==0 & e1$bug_touche==F], e1$gagnant_feedback_categorie[e1$simule_gagnant==0 & e1$bug_touche==F], prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
# CrossTable(e1$gagnant_categorie[e1$simule_gagnant==1 & e1$bug_touche==F & e1$confiance_dividende=="Oui"], e1$gagnant_feedback_categorie[e1$simule_gagnant==1 & e1$bug_touche==F & e1$confiance_dividende=="Oui"], prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
# CrossTable(e1$gagnant_categorie[e1$simule_gagnant==0 & e1$bug_touche==F & e1$confiance_dividende=="Oui"], e1$gagnant_feedback_categorie[e1$simule_gagnant==0 & e1$bug_touche==F & e1$confiance_dividende=="Oui"], prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
# CrossTable(e1$gagnant_categorie[e1$simule_gagnant==1 & e1$bug_touche==F & e1$confiance_dividende!="Non"], e1$gagnant_feedback_categorie[e1$simule_gagnant==1 & e1$bug_touche==F & e1$confiance_dividende!="Non"], prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
# CrossTable(e1$gagnant_categorie[e1$simule_gagnant==0 & e1$bug_touche==F & e1$confiance_dividende!="Non"], e1$gagnant_feedback_categorie[e1$simule_gagnant==0 & e1$bug_touche==F & e1$confiance_dividende!="Non"], prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)


##### Expliquer que 60% se pensent perdants au lieu de 27% #####
# gain fiscal (N) gains_losses_data.py; pas croire au dividende (N); élasticité nulle (B): à eux seuls, expliquent beaucoup (si ce n'est tout)
# pourquoi pas de biais dans v2? pck ceux qui ne sont pas sûrs cochent NSP plutôt que Perdant + effet de cadrage (pour expliquer évolution Gagnants).  
   # Pb: non confirmé par certitude_gagnant: Perdant sont aussi + sûrs qu'autres dans v1 que dans v2 (on devrait plus + sûr dans v2 pour confirmer). Cela dit questions pas comparable pck l'une porte sur gagnant_categorie (v1) et l'autre sur gain (v2)
# effets de cadrage (B). Gens pensent perdre et ne croit pas au dividende pck on leur suggère, ds v2 c'est plutôt qu'ils pensent notre estimation surestimée mais intègrent dividende. 
#   pb de cette explication: pas d'effet sur approbation
# potentiellement dû à MR: pensent perdre plus que les autres (B) perte_relative; pensent que tout le monde perd tout en croyant au dividende (B). Il aurait fallu avoir question dividende + perdants/gagnants dans le même sondage pour savoir
# peu crédible: intentional misreporting (N); uncertainty + loss-aversion (N)
# (B): explication impliquant un biais, (N): n'en impliquant pas
# explications de l'asymétrie dans l'update (pour v0):
#  MR: possible mais pas détectable car pas d'asymétrie dans l'update (a fortiori parmi ceux qui croient au dividende) TODO: check régression update ~ gj + g_d voir si on a au moins ça
#  sont "biaisés" (par prudence e.g.) et update imparfait donc seuls ceux proches de zéro impactés TODO: checker si meilleur update proche de 0
wtd.mean(e1$simule_gain_verif < 0, weights = e1$weight) # 27%
wtd.mean(e2$simule_gain[e2$dividende==0] < 0, weights = e2$weight[e2$dividende==0]) # 95% gain fiscal
wtd.mean(e2$simule_gain[e2$dividende==110] < 0, weights = e2$weight[e2$dividende==110]) # 36% gain fiscal
wtd.mean(e2$simule_gain[e2$dividende==170] < 0, weights = e2$weight[e2$dividende==170]) # 11% gain fiscal
decrit("gagnant_categorie", data=e1) # 60/9% Perdants/Gagnants
decrit("gagnant_categorie", data=e1, which = e1$question_confiance==F) # 59/11
decrit("gagnant_categorie", data=e2, which = e2$dividende==0, miss=T) # 48/4
decrit("gagnant_categorie", data=e2, which = e2$dividende==110, miss=T) # 25/24
decrit("gagnant_categorie", data=e2, which = e2$dividende==170, miss=T) # 11/30
summary(lm(gagnant_categorie=="Perdant" ~ as.factor(confiance_dividende), data=e1, weights = e1$weight)) # +28/48*** 30% de Perdant parmi ceux qui croient au dividende: le bon chiffre
wtd.mean(e1$simule_gain_verif < 26.55 * pmin(2, e1$nb_adultes) / e1$uc, weights = e1$weight) # 38% 26.55 c'est ce qu'en moyenne les gens escomptent d'un dividende de 110
wtd.mean(e1$simule_gain_verif < 110 * pmin(2, e1$nb_adultes) / e1$uc, weights = e1$weight) # 86%: notre spécification avec le +16 pose pb ici
wtd.mean(e1$simule_gain_interaction < 110 * pmin(2, e1$nb_adultes) / e1$uc, weights = e1$weight) # 90% là aussi y a un +9: TODO corriger erreur python pour équilibrer
wtd.mean((e2$simule_gain - 110 * e2$nb_adultes / e2$uc)[e2$dividende==110] < 0, weights = e2$weight[e2$dividende==110]) # 100% when <= instead of <
0.25 + 0.75*wtd.mean(e1$simule_gain_verif < 0, weights = e1$weight) # 45% cas extrême où 25% pensent recevoir 0 et 75% 110
 0.25 + 0.75*wtd.mean(e2$simule_gain[e2$dividende==110] < 0, weights = e2$weight[e2$dividende==110]) # 52% cas extrême où 25% pensent recevoir 0 et 75% 110 (mieux calculé)
wtd.mean(e1$simule_gain_verif < 110 * pmin(2, e1$nb_adultes) / e1$uc, weights = e1$weight)*0.25 + 0.75*wtd.mean(e1$simule_gain_verif < 0, weights = e1$weight) # 40% pareil mais faux car < 110 devrait donner 1
wtd.mean(e1$simule_gain_inelastique < 0, weights = e1$weight) # 44% Plutôt qu'inélastique, utiliser gain_fiscal comme définition => d'où le fait d'utiliser e2
wtd.mean(e1$simule_gain_inelastique < 26.55 * pmin(2, e1$nb_adultes) / e1$uc, weights = e1$weight) # 53%
0.25 + 0.75*wtd.mean(e1$simule_gain_inelastique < 0, weights = e1$weight) # 58%: les gens raisonnant sans élasticité avec 25% pensant rien recevoir expliquent quasiment tout
# imputer le dividende escompté à partir de confiance_gouv et déduire le % de perdants que ça explique 
impute_dividende_escompte <- function(escompte_moitie = 0.5, escompte_non = 0, print = F) { # un escompte_moitie de 0.6 signifie que 60% du dividende est pris en compte par ceux qui répondent "À moitié"
  escompte_dividende_by_confiance_gouv <- rep(NA, 6)
  names(escompte_dividende_by_confiance_gouv) <- c(labels(e1$confiance_gouvernement))
  for (i in c(labels(e1$confiance_gouvernement))) {
    escompte_dividende_by_confiance_gouv[i] <- sum((((e1$confiance_dividende=="Oui") * e1$weight)[e1$confiance_gouvernement==i] + escompte_non * ((e1$confiance_dividende=="Non") * e1$weight)[e1$confiance_gouvernement==i] +
        escompte_moitie * ((e1$confiance_dividende=="À moitié") * e1$weight)[e1$confiance_gouvernement==i]), na.rm=T)/sum((!is.na(e1$confiance_dividende) * e1$weight)[e1$confiance_gouvernement==i]) }
  # data_modified[["dividende_escompte_impute"]] <<- escompte_dividende_by_confiance_gouv[as.character(data_modified[["confiance_gouvernement"]])]
  if (print) print(paste("escompte moyen:", round(.46*escompte_non + .423*escompte_moitie + .117, 2)))
  return(escompte_dividende_by_confiance_gouv)
}
impute_dividende_escompte(print=T) # part du dividende que les gens pensent recevoir (imputée)
impute_dividende_escompte(escompte_moitie = 0.8, escompte_non = 0.3, print=T)
e1$dividende_escompte_impute <- impute_dividende_escompte()[as.character(e1$confiance_gouvernement)] * 110 * pmin(2, e1$nb_adultes)/e1$uc # dividende par UC que les gens pensent recevoir (imputé)
e2$dividende_escompte_impute <- impute_dividende_escompte()[as.character(e2$confiance_gouvernement)] * e2$dividende * pmin(2, e2$nb_adultes)/e2$uc
e1$dividende_escompte_ajuste <- impute_dividende_escompte(escompte_moitie = 0.8, escompte_non = 0.3)[as.character(e1$confiance_gouvernement)] * 110 * pmin(2, e1$nb_adultes)/e1$uc
e2$dividende_escompte_ajuste <- impute_dividende_escompte(escompte_moitie = 0.8, escompte_non = 0.3)[as.character(e2$confiance_gouvernement)] * e2$dividende * pmin(2, e2$nb_adultes)/e2$uc
# wtd.mean(e1$simule_gain_verif + e1$dividende_escompte_impute - (110 * pmin(2, e1$nb_adultes)/e1$uc) < 0, weights = e1$weight) # 63% explique tout pour escompte non,moitié = 0, 0.5 /!\ débile de faire ça pour e1 puisqu'on a les données individuelles, cf. gain_min etc.
# wtd.mean(e1$simule_gain_verif + e1$dividende_escompte_ajuste - (110 * pmin(2, e1$nb_adultes)/e1$uc) < 0, weights = e1$weight) # 47% mais pas qd on ajuste le dividende escompté à la valeur de v2
wtd.mean((e2$simule_gain + e2$dividende_escompte_impute - (e2$dividende * pmin(2, e2$nb_adultes)/e2$uc))[e2$dividende==0] < 0, weights = e2$weight[e2$dividende==0]) # 95%
wtd.mean((e2$simule_gain + e2$dividende_escompte_ajuste - (e2$dividende * pmin(2, e2$nb_adultes)/e2$uc))[e2$dividende==0] < 0, weights = e2$weight[e2$dividende==0]) # 95%
wtd.mean((e2$simule_gain + e2$dividende_escompte_impute - (e2$dividende * pmin(2, e2$nb_adultes)/e2$uc))[e2$dividende==110] < 0, weights = e2$weight[e2$dividende==110]) # 69% explique tout pour escompte non,moitié = 0, 0.5
wtd.mean((e2$simule_gain + e2$dividende_escompte_ajuste - (e2$dividende * pmin(2, e2$nb_adultes)/e2$uc))[e2$dividende==110] < 0, weights = e2$weight[e2$dividende==110]) # 56% explique tout même qd on ajuste le dividende escompté à la valeur de v2
wtd.mean((e2$simule_gain + e2$dividende_escompte_impute - (e2$dividende * pmin(2, e2$nb_adultes)/e2$uc))[e2$dividende==170] < 0, weights = e2$weight[e2$dividende==170]) # 58% explique tout pour escompte non,moitié = 0, 0.5
wtd.mean((e2$simule_gain + e2$dividende_escompte_ajuste - (e2$dividende * pmin(2, e2$nb_adultes)/e2$uc))[e2$dividende==170] < 0, weights = e2$weight[e2$dividende==170]) # 34% mais pas qd on ajuste le dividende escompté à la valeur de v2
summary(lm(dividende_escompte_impute ~ (gain_net_choix=="NSP"), data=e2, weights = e2$weight)) # pas d'effet
summary(lm(dividende_escompte_ajuste ~ (gain_net_choix=="NSP"), data=e2, weights = e2$weight)) 
summary(lm(dividende_escompte_impute ~ (gain_net_choix=="NSP")*as.factor(dividende), data=e2, weights = e2$weight))
decrit("confiance_gouvernement", data=e1)
decrit("confiance_gouvernement", data=e2) # same
decrit("confiance_gouvernement", data=e1, which = e1$question_confiance==T)
decrit("dividende_escompte_impute", data=e1)
decrit("dividende_escompte_impute", data=e2)
decrit("dividende_escompte_impute", data=eb) # TODO bug label eb confiance_gouvernement*
decrit(impute_dividende_escompte(escompte_moitie = 0.8, escompte_non = 0.3)[as.character(e1$confiance_gouvernement)])
summary(lm(n(confiance_gouvernement) ~ question_confiance, data=e1))
summary(lm((confiance_gouvernement>=0) ~ question_confiance, data=e1)) # étonnant: question_confiance suscite +10** confiance_gouv
summary(lm((confiance_gouvernement>=-1) ~ question_confiance, data=e1))


##### Avis estimation #####
# 34/31/12 Trop peu/Correct/Trop. Ceux qui nous croient n'escomptent pas bcp le dividende et approuvent +.26*** (TODO: corrélation avec confiance_gouv), et ceux qui le font répondent gain=NA ou NSP
decrit("avis_estimation", data=e2) # TODO!: image 
decrit(e2$gain + e2$hausse_depenses_par_uc, which = grepl("Correct", e2$avis_estimation) & e2$dividende==0, weights = e2$weight) # mean 4 / médiane 3 : dividende qu'ils croient recevoir s'ils acceptent notre estimation
decrit(e2$gain + e2$hausse_depenses_par_uc, which = grepl("Correct", e2$avis_estimation) & e2$dividende==110, weights = e2$weight) # 110 / 125
decrit(e2$gain + e2$hausse_depenses_par_uc, which = grepl("Correct", e2$avis_estimation) & e2$dividende==170, weights = e2$weight) # 150 / 172
summary(lm((gain + hausse_depenses_par_uc) ~ as.factor(dividende), data=e2, subset = e2$avis_estimation=="Correcte", weights = e2$weight)) # tout dividende pris en compte
summary(lm((gain + hausse_depenses_par_uc) ~ as.factor(dividende), data=e2, subset = e2$avis_estimation!="Trop élevée", weights = e2$weight)) # seul dividende=170 pas tout à fait pris en compte
summary(lm((gain + hausse_depenses_par_uc) ~ as.factor(dividende), data=e2, subset = e2$avis_estimation=="Trop élevée", weights = e2$weight)) # dividende pas bien pris en compte / hausse_depenses subj diffère
decrit(e2$gain + e2$hausse_depenses_par_uc - e2$dividende, which = grepl("Correct", e2$avis_estimation)) # dividende qu'ils croient recevoir moins le vrai
decrit(e2$gain + e2$hausse_depenses_par_uc - e2$dividende, which = grepl("Correct", e2$avis_estimation) & e2$gain==0) # bcp intuitent qu'ils perdent mais croient à notre estimation alors disent gain=0 ce qui naturellement impliquent qu'ils ne se trompent pas en moyenne (mais c'est fortuit). Interprétation appuyée par la variance plus faible.
# decrit(e2$gain + e2$hausse_depenses_par_uc - e2$dividende, which = grepl("Correct", e2$avis_estimation) & e2$gain!=0) # dividende qu'ils croient recevoir moins le vrai
head((e2$gain * e2$uc)[grepl("Correct", e2$avis_estimation)], 30) # bcp sont à 0 au lieu d'un nombre >0: check s'ils sont plus à désapprouver (ce qui sous-entendrait que les 0=NA~NSP sont dûs à un doute sur le dividende: confirmé ci-dessous)
head(round((e2$simule_gain * e2$uc)[grepl("Correct", e2$avis_estimation)]), 30)
summary(lm(taxe_approbation!="Non" ~ as.character(avis_estimation), data = e2, weights = e2$weight)) # 68% !Non qd estimation correction correcte ou NSP, ***20 p.p. de plus que les autres
summary(lm(taxe_approbation=="Oui" ~ as.character(avis_estimation), data = e2, weights = e2$weight)) # 46% Oui quand estimation correcte, ***26 p.p. de plus que les autres
summary(lm(taxe_approbation=="Oui" ~ (avis_estimation=="Correcte") * (gain == 0), data = e2, weights = e2$weight))
summary(lm(taxe_approbation=="Oui" ~ I(avis_estimation %in% c("Correcte", "NSP")) * I(gagnant_categorie %in% c("NSP", "Non affecté")), data = e2, weights = e2$weight))

##### Gain #####
# 75% du dividende pris en compte. 
decrit("gain", data=e1) # mean -32.44. Imputé à partir de réponse au dividende. Marche plutôt bien
decrit("gain", data=e2) 
decrit("gain", data=e2, which = e2$dividende==0) # -108.90 TODO!: image cdf
decrit("gain", data=e2, which = e2$dividende==110) # -25.45 en moyenne, 83.45€/110 i.e. 75% (26.55) du dividende pris en compte
decrit("gain", data=e2, which = e2$dividende==170) # 16.69 en moyenne, 42.14€/60 i.e. 70% (17.86) du dividende additionnel pris en compte (74% du total i.e. 125.59 vs. 44.41)
decrit("gagnant_categorie", data=e1)
decrit("gagnant_feedback_categorie", data=e1)
decrit("gagnant_alternative_categorie", data=e2) # 15% plus de gagnants, 15% moins de perdant TODO! exploiter ça 
summary(lm(gagnant_alternative_categorie=="Perdant" ~ variante_alternative, data=e2, weights = e2$weight)) # pas d'effet
summary(lm(gagnant_alternative_categorie=="Gagnant" ~ variante_alternative, data=e2, weights = e2$weight)) # pas d'effet
summary(ivreg(taxe_approbation!="Non" ~ (gagnant_feedback_categorie!="Perdant") + simule_gain | simule_gagnant + simule_gain, data = e1, weights = e1$weight)) # TODO! faire placebo test pour notre 1er papier
summary(ivreg(taxe_feedback_approbation!="Non" ~ (gagnant_feedback_categorie!="Perdant") + taxe_approbation + Simule_gain + origine_taxe + label_taxe + uc + revenu | 
  simule_gagnant + taxe_approbation + Simule_gain + origine_taxe + label_taxe + uc + revenu, subset = abs(e1$simule_gain) < 100, data = e1, weights = e1$weight), diagnostics = T) # < 50: pas assez de puissance
summary(ivreg(taxe_feedback_approbation!="Non" ~ (gagnant_feedback_categorie!="Perdant") + taxe_approbation + simule_gain | 
                simule_gagnant + taxe_approbation + simule_gain, data = e1, weights = e1$weight))
# TODO dans papier comment on peut avoir à la fois Simule_gain et hausse_depenses_par_uc ? pk on a un pb en ajoutant Simule_gain2? 
# TODO IV app ~ confiance_div | origine, label
summary(ivreg(taxe_approbation!="Non" ~ (confiance_dividende!="Non") | origine_taxe + label_taxe, data=e1, weights = e1$weight), diagnostics = T)

##### Mécanismes : incertitude #####
# assez sûrs d'eux, surtout les perdants (v1)
# v1: 18/40/42 pas/moyennement/sûr par rapport à gagnant_categorie, v2: 30/42/29 par rapport à gain (hors NSP)
decrit("certitude_gagnant", data=e1)  
decrit("certitude_gagnant", data=e2, which = e2$gagnant_categorie!="NSP") # moins sûrs vague == 2 car il s'agit de gain subjectif, pas gagnant_categorie
summary(lm(certitude_gagnant ~ as.factor(dividende) + vague, data = eb)) # certitude sur gain varie pas avec dividende, c'est logique
# Il y a plus de perdants parmi ceux qui sont sûrs de leur réponse
CrossTable(e1$certitude_gagnant, e1$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # perdant~sûr gagnant~moyennement non affecté~pas sûr du tout
CrossTable(e2$certitude_gagnant, e2$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # NSP~pas sûr du tout perdant~moyennement
# Parmi les < 100 qui croient recevoir le dividende, est-ce que l'incertitude augmente la probabilité de se penser perdant ? Non, elle augmente la proba de Non affecté, i.e. Non affecté ~ NSP
summary(lm(gagnant_categorie=='Perdant' ~ (certitude_gagnant < 1), data=e, subset = e$confiance_dividende=='Oui', weights = e$weight))
summary(lm(gagnant_categorie=='Non affecté' ~ (certitude_gagnant < 1), data=e, subset = e$confiance_dividende=='Oui', weights = e$weight))
summary(lm(gagnant_categorie=='Gagnant' ~ (certitude_gagnant < 1), data=e, subset = e$confiance_dividende=='Oui', weights = e$weight))
decrit(e$certitude_gagnant, which = e$confiance_dividende=='Oui')
summary(lm(tax_acceptance ~ (certitude_gagnant < 1) * gagnant_categorie, data=e, subset = e$confiance_dividende=='Oui', weights = e$weight)) # no strong effect of uncertainty
summary(lm(tax_approval ~ (certitude_gagnant < 1) * gagnant_categorie, data=e, subset = e$confiance_dividende=='Oui', weights = e$weight)) # no effect
CrossTable(e1$gagnant_categorie, e1$certitude_gagnant, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # Perdants + sûrs que autres
CrossTable(e2$gagnant_categorie, e2$certitude_gagnant, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # Perdants aussi sûrs que autres
CrossTable(e2$gagnant_categorie[e2$dividende==110], e2$certitude_gagnant[e2$dividende==110], prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # Perdants + sûrs que autres
CrossTable(e2$gagnant_categorie[e2$dividende==170], e2$certitude_gagnant[e2$dividende==170], prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # Perdants un peu + sûrs que autres


##### Mécanismes : confiance #####
# méfiance gouv est capturée par méfiance dividende pour expliquer Perdant. confiance_gouv augmente proba NA (v1) mais pas corrélé avec gagnant_categorie (v2)
# Parmi le peu qui croient recevoir le dividende, gagnant_categorie est bien plus alignée avec la réponse objective: +32***p.p.
decrit(e1$confiance_gouvernement, miss=T) # 26/38/18/14 jamais/parfois/moitié/plupart temps
decrit(e2$confiance_gouvernement, miss=T) # pareil
CrossTable((e1$confiance_gouvernement >= 0), e1$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # la confiance augmente la proba de se penser Non affecté plutôt que Perdant
CrossTable((e2$confiance_gouvernement >= 0), e2$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # v2 pas de corrélation entre confiance_gouv et gagnant_categorie<:gain
summary(lm(gagnant_categorie=='Perdant' ~ (confiance_gouvernement < 0) * (confiance_dividende < 0), data = e1, weights = e1$weight)) # dividende 0.33*** / gouv: 0.13**
summary(lm(gagnant_categorie=='Perdant' ~ (confiance_gouvernement < 0) * as.factor(confiance_dividende), data = e1, weights = e1$weight)) # confiance_gouv pas significatif / dividende -0.27*** et -0.45***
summary(lm(tax_acceptance ~ (confiance_gouvernement < 0) * (confiance_dividende < 0), data = e1, weights = e1$weight)) # dividende -0.41*** / gouv -10*
summary(lm(tax_acceptance ~ (confiance_gouvernement < 0) * as.factor(confiance_dividende), data = e1, weights = e1$weight)) # confiance_gouv pas significatif / dividende 0.38*** et 0.46***
# summary(ivreg(tax_acceptance ~ (gagnant_categorie!='Perdant') + confiance_gouvernement + Gilets_jaunes | (confiance_dividende < 0) + confiance_gouvernement + Gilets_jaunes, data=e),diagnostics=T)
summary(lm(update_correct ~ gagnant_categorie=='Gagnant', subset = feedback_infirme_large==T, data=e, weights = e$weight)) # not enough power (only 4 overly optimistic loser)
summary(lm(update_correct ~ gagnant_categorie=='Gagnant', subset = feedback_infirme_large==T & feedback_correct==T, data=e1, weights = e$weight)) # pas d'asymétrie
decrit("confiance_dividende", data=e1) # seuls 12% croient recevoir le dividende : ça suffit à expliquer que quasiment tout le monde se pense perdant
CrossTable(e1$simule_gain_verif > 0, e1$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) 
# Parmi le peu qui croient recevoir le dividende, gagnant_categorie est bien plus alignée avec la réponse objective: +32***p.p.
CrossTable(e1$simule_gain_verif[e1$confiance_dividende=='Oui'] > 0, e1$gagnant_categorie[e1$confiance_dividende=='Oui'], prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) 
summary(lm(((simule_gain_verif > 0 & gagnant_categorie!='Perdant') | (simule_gain_verif < 0 & gagnant_categorie!='Gagnant')) ~ as.factor(confiance_dividende), data=e1, weights = e1$weight)) # 0.36***
decrit(e1$perte - e1$hausse_depenses_verif > 30) # 19% sur-estiment les hausses de dépenses de plus de 30€/UC
decrit(e1$perte - e1$hausse_depenses_verif < -30) # 56% sous-estiment les hausses de dépenses de plus de 30€/UC ! TODO comparer à v0
decrit(e1$perte - e1$hausse_depenses_verif_na < -30) # robuste quand on remplace conso par 7


##### Taxe carbone ~ sondage #####
# approbation +.1*** qd on dit que majorité est pour. cf. Bursztyn et al. 2020
decrit("pour_taxe_carbone", data = eb, miss=T) # TODO: solve bug
decrit("pour_taxe_carbone", data = eb, which = eb$variante_taxe_carbone=='pour', miss=T)
decrit("pour_taxe_carbone", data = eb, which = eb$variante_taxe_carbone=='contre', miss=T)
decrit("pour_taxe_carbone", data = eb, which = eb$variante_taxe_carbone=='neutre', miss=T)
summary(lm(pour_taxe_carbone!='Non' ~ variante_taxe_carbone, data=eb, weights = eb$weight)) # THE result +10**
summary(lm(pour_taxe_carbone=='Oui' ~ variante_taxe_carbone, data=eb, weights = eb$weight)) # +8


##### Taxe carbone ~ label_taxe * origine_taxe #####
# pas d'effet du label, de question_confiance. Effet du dividende 7/13p.p. Effet de origine=EELV -.13-21** seulement pour dividende<170 (donc passe pas par confiance_dividende mais anti-EELV activé qd anti-social (ou attention à incidence accrue qd anti-EELV))
decrit("origine_taxe", data=e1)
summary(lm(taxe_approbation!='Non' ~ question_confiance, data=e1, weights = e1$weight)) # -.03 pas d'effet
summary(lm(taxe_approbation!='Non' ~ label_taxe, data=e1, weights = e1$weight)) # CCE +.03 pas d'effet
summary(lm(taxe_approbation!='Non' ~ origine_taxe, data=e1, weights = e1$weight)) # pas d'effet
summary(lm(taxe_approbation!='Non' ~ (origine_taxe!='inconnue'), data=e1, weights = e1$weight)) # -.03  pas d'effet
summary(lm(taxe_approbation!='Non' ~ label_taxe * origine_taxe, data=e1, weights = e1$weight)) # pas d'effet
summary(lm(taxe_approbation!='Non' ~ label_taxe * origine_taxe * question_confiance, data=e1, weights = e1$weight)) # no effect
summary(lm(gagnant_categorie=='Perdant' ~ question_confiance, data=e1, weights = e1$weight)) # pas d'effet
summary(lm(gagnant_categorie=='Perdant' ~ label_taxe * origine_taxe * question_confiance, data=e1, weights = e1$weight)) # pas d'effet
decrit("taxe_feedback_approbation", data=e1, which=e1$origine_taxe=="inconnue", miss = T)
decrit("taxe_feedback_approbation", data=e1, which=e1$origine_taxe=="CCC", miss = T)
decrit("taxe_feedback_approbation", data=e1, which=e1$origine_taxe=="gouvernement", miss = T)
summary(lm(taxe_approbation!='Non' ~ origine_taxe * as.factor(dividende), data=e2, weights = e2$weight)) # l'effet du gouv/EELV ne passe que pour dividende=0, donc pas lié à confiance_dividende
summary(lm(taxe_approbation!='Non' ~ origine_taxe, data=e2, subset=dividende>0, weights = e2$weight)) # .02 pas d'effet
summary(lm(taxe_approbation!='Non' ~ origine_taxe, data=e2, subset=dividende==0, weights = e2$weight)) # +.15**
summary(lm(taxe_approbation!='Non' ~ origine_taxe, data=e2, weights = e2$weight)) # gouv +7* TODO: comparer avec pilote
summary(lm(taxe_approbation!='Non' ~ as.factor(dividende), data=e2, weights = e2$weight)) # 7./13***
summary(lm(taxe_approbation!='Non' ~ as.factor(dividende), data=e2, subset = origine_taxe=="EELV", weights = e2$weight)) # 13*/21***
summary(lm(taxe_approbation!='Non' ~ as.factor(dividende), data=e2, subset = origine_taxe=="gouvernement", weights = e2$weight)) # 2/6
decrit(e2$taxe_alternative_approbation[e2$dividende==170], miss = T)
decrit(e2$taxe_alternative_approbation[e2$dividende==170 & e2$origine_taxe=='gouvernement'], miss = T)
decrit(e2$taxe_alternative_approbation[e2$dividende==110], miss = T)
decrit(e2$taxe_alternative_approbation[e2$dividende==0], miss = T)


##### Confiance dividende ~ label_taxe * origine_taxe #####
# Moitié a pas du tout confiance, 10% y croit. Pas d'effet significatif de label et origine sur confiance dividende (inconnue faible effet)
decrit(e1$confiance_dividende) # 46/42/12 Non/Moitié/Oui
decrit(e1$confiance_dividende, which = e1$origine_taxe=='gouvernement')
decrit(e1$confiance_dividende, which = e1$origine_taxe=='CCC')
decrit(e1$confiance_dividende, which = e1$origine_taxe=='inconnue')
summary(lm(confiance_dividende!='Non' ~ origine_taxe, data=e1, weights = e1$weight)) # inconnue -.04 no effect
summary(lm(confiance_dividende!='Non' ~ label_taxe * origine_taxe, data=e1, weights = e1$weight)) # no effect


##### Incertitude #####
# gagnants moins sûrs; plus sûr après feedback car on fait douter ceux qu'on infirme; NA moins sûrs que autres;
decrit(e$certitude_gagnant)
CrossTable(e$certitude_gagnant, e$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) 
cert <- e1[,which(names(e1) %in% c("certitude_gagnant_feedback", "simule_gagnant", "bug_touche", "feedback_confirme", "feedback_infirme"))]
cert$feedback <- T
e1$feedback <- F
names(cert)[1] <- "certitude_gagnant"
cert <- rbind(cert, e1[,which(names(e1) %in% c("certitude_gagnant", "simule_gagnant", "bug_touche", "feedback", "feedback_confirme", "feedback_infirme"))])
summary(lm(certitude_gagnant ~ feedback * bug_touche * simule_gagnant, data = cert)) # -14* les gagnants moins sûrs
summary(lm(certitude_gagnant ~ feedback * bug_touche, data = cert)) # 9* plus sûr lors du feedback
summary(lm(certitude_gagnant ~ feedback + simule_gagnant, data = cert)) # confirmé
summary(lm(certitude_gagnant ~ feedback * feedback_confirme, data = cert)) # 20* ceux avec qui ont est d'accord sont plus sûr
summary(lm(certitude_gagnant ~ feedback * feedback_infirme, data = cert)) # 23* ceux qu'on infirme sont plus sûr mais avant le feedback seulement
summary(lm(certitude_gagnant ~ feedback, data = cert)) # 8*
e1$certitude_augmente <- e1$certitude_gagnant_feedback - e1$certitude_gagnant
summary(lm(certitude_augmente ~ feedback_infirme + feedback_confirme, data = e1, subset = bug_touche==F)) # certitude baisse 20* qd on infirme
summary(lm(certitude_augmente ~ feedback_infirme + feedback_confirme, data = e1)) # la variable omise est les non affectés
# la certitude augmente chez les non affectés et quand on confirme, elle baisse légèrement quand on infirme TODO vérifier interprétation
summary(lm(certitude_augmente ~ bug_touche, data = e1)) # -7 la variable omise est les non affectés


##### Taxe carbone: Motivated reasoning ~ confiance_dividende ####
#  plus d'update correct parmi ceux qui ont confiance dans dividende, les non GJ et ceux qui approuvent
decrit(e1$update_correct) # 24%
decrit(e1$update_correct, which = e1$confiance_dividende=='Oui') # 29%
summary(lm(update_correct ~ confiance_dividende, subset = feedback_infirme_large==T, data=e1, weights = e1$weight)) # 0.14***
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') + Gilets_jaunes + taxe_approbation, subset = feedback_infirme_large==T, data=e1, weights = e1$weight))
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') * confiance_dividende, subset = feedback_infirme_large==T, data=e1, weights = e1$weight)) # 0.14***
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') + confiance_dividende + Gilets_jaunes + taxe_approbation, subset = feedback_infirme_large==T, data=e1, weights = e1$weight)) # 0.06*
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') + Gilets_jaunes + taxe_approbation, subset = feedback_infirme_large==T & feedback_correct==T, data=e1, weights = e1$weight))
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') * confiance_dividende, subset = feedback_infirme_large==T & feedback_correct==T, data=e1, weights = e1$weight)) # 0.14*
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') + confiance_dividende + Gilets_jaunes + taxe_approbation, subset = feedback_infirme_large==T & feedback_correct==T, data=e1, weights = e1$weight)) # 0.06*


##### Update correct #####
mar_old <- par()$mar
cex_old <- par()$cex
par(mar = c(0.1, 3.1, 2.1, 0), cex.lab=1.2)

# (a) winners
crosstab_simule_gagnant <- crosstab(e$winning_category[e$simule_gagnant==1], e$winning_feedback_category[e$simule_gagnant==1], 
                                    e$weight[e$simule_gagnant==1], # dnn=c(expression('Winning category,'~bold(Before)~feedback), ''),
                                    prop.r=T, sort=2:1, cex.axis=0.9) # sort=2:1, dir=c("h", "v"), inv.x=T, inv.y=T, color = FALSE # see mosaicplot
crosstab_simule_gagnant
# (b) losers
crosstab_simule_perdant <- crosstab(e$winning_category[e$simule_gagnant==0], e$winning_feedback_category[e$simule_gagnant==0], 
                                    e$weight[e$simule_gagnant==0], # dnn=c(expression('Winning category, '~bold(Before)~feedback), ''),
                                    prop.r=T, sort=2:1, cex.axis=0.9) # sort=2:1, dir=c("h", "v"), inv.x=T, inv.y=T, color = FALSE # see mosaicplot
crosstab_simule_perdant

## only feedback correct
# (a) winners
crosstab_simule_gagnant <- crosstab(e$winning_category[e$simule_gagnant==1], e$winning_feedback_category[e$simule_gagnant==1], 
                                    e$weight[e$simule_gagnant==1], # dnn=c(expression('Winning category,'~bold(Before)~feedback), ''),
                                    prop.r=T, sort=2:1, cex.axis=0.9) # sort=2:1, dir=c("h", "v"), inv.x=T, inv.y=T, color = FALSE # see mosaicplot
crosstab_simule_gagnant
# (b) losers
crosstab_simule_perdant <- crosstab(e$winning_category[e$simule_gagnant==0], e$winning_feedback_category[e$simule_gagnant==0], 
                                    e$weight[e$simule_gagnant==0], # dnn=c(expression('Winning category, '~bold(Before)~feedback), ''),
                                    prop.r=T, sort=2:1, cex.axis=0.9) # sort=2:1, dir=c("h", "v"), inv.x=T, inv.y=T, color = FALSE # see mosaicplot
crosstab_simule_perdant
par(mar = mar_old, cex = cex_old)


##### Biais & gagnant_categorie #####
# v1: gain_min mieux que gain en moyenne (vraiment?), gain meilleur que gain_min pour prédire Perdant (84 vs 77%) mais beaucoup moins bon pour prédire Gagnant (14 vs 34%)
#  même parmi ceux qui croient à leur gain > 0 se disent souvent non affecté (40%) et parfois perdant (21%) cadrage
decrit(e1$biais) # TODO create in v2, check bien défini (0)
plot((1:length(e1$biais))/length(e1$biais), sort(e1$biais), type='l') + grid()
lines((1:length(e1$biais_plus))/length(e1$biais_plus), sort(e1$biais_plus), type='l', lty=2) + grid()
lines((1:length(e1$biais_moins))/length(e1$biais_moins), sort(e1$biais_moins), type='l', lty=2) + grid()
decrit(e1$biais_plus)
decrit(e1$biais_moins)
decrit(e1$gain)
decrit(e1$gain_min)
decrit(e1$gain < 0) # 53%
decrit(e1$gain_min < 0) # 69%
decrit(e1$gagnant_categorie) # gain_min does a better job than gain overall, truth is somewhere in between (cf. below)
decrit(e1$gagnant_categorie, which = e1$question_confiance==F)
decrit(e1$gagnant_categorie, which = e1$gain > 0) # TODO: study non affecté
decrit(e1$gagnant_categorie, which = e1$gain < 0)
decrit(e1$gagnant_categorie, which = e1$gain_min > 0)
decrit(e1$gagnant_categorie, which = e1$gain_min < 0) # gain meilleur que gain_min pour prédire Perdant (84 vs 77%) mais beaucoup moins bon pour prédire Gagnant (14 vs 34%)
CrossTable(e1$confiance_dividende, e1$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # seuls ceux qui y croient se disent gagnants souvent
decrit(e1$gagnant_categorie, which = e1$gain > 0 & e1$confiance_dividende=='Oui')
decrit(e1$gagnant_categorie, which = e1$gain > 50 & e1$confiance_dividende=='Oui') # même parmi ceux qui croient à leur gain > 0 se disent souvent non affecté (40%) et parfois perdant (21%)
decrit(e1$gagnant_categorie, which = e1$gain_min > 0 & e1$confiance_dividende=='Oui') # gain_min pas tellement meilleur prédicteur
CrossTable(e1$simule_gagnant > 0, e1$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # 


##### approbation y.c. détaxe urba #####
# Valeur du dividende accroît approbation mais formule alternative correspond à dividende <110
decrit("taxe_approbation", data=e1, miss = T) # 47/23
decrit("taxe_approbation", data=e2, miss = T) # 42/28 Non/Oui # TODO: régression entre base/détaxe/urba
decrit("taxe_approbation", data=e2, which=e2$dividende==0, miss = T) # 49/26 Non/Oui TODO!: image des 5
decrit("taxe_approbation", data=e2, which=e2$dividende==110, miss = T) # 42/26
decrit("taxe_approbation", data=e2, which=e2$dividende==170, miss = T) # 35/32
decrit("taxe_approbation", data=e2, which=e2$dividende==0 & e2$origine_taxe=="gouvernement", miss = T) # 41/31
decrit("taxe_approbation", data=e2, which=e2$dividende==110 & e2$origine_taxe=="gouvernement", miss = T) # 39/30
decrit("taxe_alternative_approbation", data=e2, which=e2$variante_alternative=="détaxe", miss = T) # 44/27 Non/Oui
decrit("taxe_alternative_approbation", data=e2, which=e2$variante_alternative=="urba", miss = T) # 44/29


##### Confiance #####
# 61/70% du dividende 110/170 pris en compte qd gouv. Gain en baisse qd EELV et dividende==0 ou 170
CrossTable(as.character(eb$diplome4), as.character(eb$confiance_gens), prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # 85% diplome 1 / 76% 4
summary(lm(gain ~ as.factor(dividende), data = e2, weights = e2$weight))
summary(lm(gain ~ as.factor(dividende) * (origine_taxe=="EELV"), data = e2, weights = e2$weight))
summary(lm(gain ~ as.factor(dividende), data = e2, subset=origine_taxe=="gouvernement", weights = e2$weight)) # 67.35***/119.14*** i.e. 61/70% du dividende pris en compte TODO! update ci-dessus
summary(lm(gain ~ as.factor(dividende), data = e2, subset=origine_taxe=="EELV", weights = e2$weight)) # 99/130 -28 i.e. les gens croient perdre plus qd EELV, surtout quand dividende==0 ou 170
# decrit(e2$gain_subjectif[e2$dividende==0])
# decrit(e2$gain_subjectif[e2$dividende==110])
# decrit(e2$gain_subjectif[e2$dividende==170])
decrit(e2$gain[e2$dividende==0])
decrit(e2$gain[e2$dividende==110])
decrit(e2$gain[e2$dividende==170])
decrit(e2$origine_taxe)


