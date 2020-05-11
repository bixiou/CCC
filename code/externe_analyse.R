###### Efforts relatifs #####
decrit(e$efforts_relatifs)
decrit(e$efforts_relatifs[e$variante_efforts_vous==1])
decrit(e$efforts_relatifs[e$variante_efforts_vous==0])
summary(lm(efforts_relatifs ~ variante_efforts_vous, data=e)) # +1


##### Taxe carbone ~ sondage #####
decrit(e$pour_taxe_carbone, miss=T)
decrit(e$pour_taxe_carbone[e$variante_taxe_carbone=='pour'], miss=T)
decrit(e$pour_taxe_carbone[e$variante_taxe_carbone=='contre'], miss=T)
decrit(e$pour_taxe_carbone[e$variante_taxe_carbone=='neutre'], miss=T)
summary(lm(pour_taxe_carbone!='Non' ~ variante_taxe_carbone, data=e)) # THE result


##### Taxe carbone ~ label_taxe * origine_taxe #####
summary(lm(taxe_approbation!='Non' ~ question_confiance, data=e))
summary(lm(taxe_approbation!='Non' ~ label_taxe, data=e))
summary(lm(taxe_approbation!='Non' ~ origine_taxe, data=e))
summary(lm(taxe_approbation!='Non' ~ label_taxe * origine_taxe, data=e))
summary(lm(taxe_approbation!='Non' ~ label_taxe * origine_taxe * question_confiance, data=e)) # no effect
summary(lm(gagnant_categorie=='Perdant' ~ question_confiance, data=e))
summary(lm(gagnant_categorie=='Perdant' ~ label_taxe * origine_taxe * question_confiance, data=e))


##### Confiance dividende ~ label_taxe * origine_taxe #####
decrit(e$confiance_dividende)
decrit(e$confiance_dividende[e$origine_taxe=='gouvernement'])
decrit(e$confiance_dividende[e$origine_taxe=='CCC'])
decrit(e$confiance_dividende[e$origine_taxe=='inconnue'])
summary(lm(confiance_dividende!='Non' ~ origine_taxe, data=e))
summary(lm(confiance_dividende!='Non' ~ label_taxe * origine_taxe, data=e)) # no effect


##### Incertitude #####
decrit(e$certitude_gagnant)
CrossTable(e$certitude_gagnant, e$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) 


##### Taxe carbone: Motivated reasoning ~ confiance_dividende ####
decrit(e$update_correct)
decrit(e$update_correct[e$confiance_dividende=='Oui'])
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') + Gilets_jaunes + taxe_approbation, subset = feedback_infirme_large==T, data=e))
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') * confiance_dividende, subset = feedback_infirme_large==T, data=e)) # 0.14*
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') + confiance_dividende + Gilets_jaunes + taxe_approbation, subset = feedback_infirme_large==T, data=e)) # 0.06*
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') + Gilets_jaunes + taxe_approbation, subset = feedback_infirme_large==T & feedback_correct==T, data=e))
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') * confiance_dividende, subset = feedback_infirme_large==T & feedback_correct==T, data=e)) # 0.14*
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') + confiance_dividende + Gilets_jaunes + taxe_approbation, subset = feedback_infirme_large==T & feedback_correct==T, data=e)) # 0.06*


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
decrit(e$biais)
plot(1:length(e$biais), sort(e$biais), type='l')
decrit(e$biais_plus)
decrit(e$biais_moins)
decrit(e$gain)
decrit(e$gain < 0)
decrit(e$gain_min < 0)
decrit(e$gagnant_categorie)
decrit(e$gagnant_categorie[e$question_confiance==F])
decrit(e$gagnant_categorie[e$gain > 0])
decrit(e$gagnant_categorie[e$gain < 0])
decrit(e$gagnant_categorie[e$gain_min > 0])
decrit(e$gagnant_categorie[e$gain_min < 0]) # gain meilleur que gain_min pour prédire Perdant (87 vs 80%) mais moins bon pour prédire Gagnant (16 vs 24%)
CrossTable(e$confiance_dividende, e$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # seuls ceux qui y croient se disent gagnants souvent
decrit(e$gagnant_categorie[e$gain > 0 & e$confiance_dividende=='Oui'])
decrit(e$gagnant_categorie[e$gain > 50 & e$confiance_dividende=='Oui']) # même parmi ceux qui croient à leur gain > 0 se disent souvent non affecté (40%) et parfois perdant (21%)
decrit(e$gagnant_categorie[e$gain_min > 0 & e$confiance_dividende=='Oui']) # gain_min pas meilleur prédicteur
CrossTable(e$simule_gagnant > 0, e$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # 
# TODO: confiance gouvernement


##### Politiques env ~ info_CCC #####
decrit(round(e$prop_referenda_politiques_2, 3))
summary(lm(prop_referenda_politiques_2 ~ info_CCC, data=e)) # no effect


##### Opinions politiques #####
decrit(e$Gilets_jaunes)


##### Obstacles #####
# pb: ne peut être utilisé que pour comparabilité. Le résultat en soit est biaisé car l'ordre des items n'a pas été randomisé.
decrit(e$obstacle_1) # lobbies 39%
decrit(e$obstacle_2) # manque_volonte 26%, manque_cooperation 26%
decrit(e$obstacle_3) # manque_cooperation 24%, manque_volonte 20%
decrit(e$obstacle_4) # inegalites 19%, demographie 17%
decrit(e$obstacle_5) # incertitudes 22%, technologies 19%, demographie 18%
decrit(e$obstacle_6) # incertitudes 23%, demographie 21%
decrit(e$obstacle_7) # technologies 23%, incertitudes 21%
decrit(e$obstacle_8) # rien de tout cela 60%


##### Problème conso L/100km #####
length(which(abs(e$hausse_essence_verif_na - e$hausse_essence) > 0.001))
length(which(abs(e$hausse_diesel_verif_na - e$hausse_diesel) > 0.001)) # hausse_diesel et _essence ont été calculées avec la conso moyenne (pas celle renseignée par le répondant)
length(which(abs(e$hausse_essence_verif - e$hausse_essence) > 0.001))
length(which(abs(e$hausse_diesel_verif - e$hausse_diesel) > 0.001))


##### Mécanismes : incertitude #####
decrit(e$certitude_gagnant, weights = e$weight)
# Il y a plus de perdants parmi ceux qui sont sûrs de leur réponse
CrossTable(e$certitude_gagnant, e$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) 
# Parmi les < 100 qui croient recevoir le dividende, est-ce que l'incertitude augmente la probabilité de se penser perdant ? Non, elle augmente la proba de Non affecté.
summary(lm(gagnant_categorie=='Perdant' ~ (certitude_gagnant < 1), data=e, subset = e$confiance_dividende=='Oui'))
summary(lm(gagnant_categorie=='Non affecté' ~ (certitude_gagnant < 1), data=e, subset = e$confiance_dividende=='Oui'))
summary(lm(gagnant_categorie=='Gagnant' ~ (certitude_gagnant < 1), data=e, subset = e$confiance_dividende=='Oui'))
decrit(e$certitude_gagnant[e$confiance_dividende=='Oui'])
summary(lm(tax_acceptance ~ (certitude_gagnant < 1) * gagnant_categorie, data=e, subset = e$confiance_dividende=='Oui')) # L'approbation augmente avec l'incertitude (en partie tiré par NSP).
summary(lm(tax_approval ~ (certitude_gagnant < 1) * gagnant_categorie, data=e, subset = e$confiance_dividende=='Oui')) # no effect


##### Mécanismes : confiance #####
decrit(e$confiance_gouvernement)
CrossTable((e$confiance_gouvernement >= 0), e$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) 
summary(lm(gagnant_categorie=='Perdant' ~ (confiance_gouvernement < 0) * (confiance_dividende < 0), data = s)) # dividende 0.31*** / gouv: 0.14**
summary(lm(gagnant_categorie=='Perdant' ~ (confiance_gouvernement < 0) * as.factor(confiance_dividende), data = s)) # dividende 0.31*** / gouv: 0.14**
summary(lm(tax_acceptance ~ (confiance_gouvernement < 0) * (confiance_dividende < 0), data = s)) # dividende -0.41***
# summary(ivreg(tax_acceptance ~ (gagnant_categorie!='Perdant') + confiance_gouvernement + Gilets_jaunes | (confiance_dividende < 0) + confiance_gouvernement + Gilets_jaunes, data=e),diagnostics=T)
summary(lm(update_correct ~ gagnant_categorie=='Gagnant', subset = feedback_infirme_large==T, data=e, weights = e$weight)) # not enough power (only 4 overly optimistic loser)
summary(lm(update_correct ~ gagnant_categorie=='Gagnant', subset = feedback_infirme_large==T & feedback_correct==T, data=e, weights = e$weight))
decrit(e$confiance_dividende) # seuls 11% croient recevoir le dividende : ça suffit à expliquer que quasiment tout le monde se pense perdant
CrossTable(e$simule_gain_verif > 0, e$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) 
# Parmi le peu qui croient recevoir le dividende, gagnant_categorie est bien plus alignée avec la réponse objective: +36***p.p.
CrossTable(e$simule_gain_verif[e$confiance_dividende=='Oui'] > 0, e$gagnant_categorie[e$confiance_dividende=='Oui'], prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) 
summary(lm(((simule_gain_verif > 0 & gagnant_categorie!='Perdant') | (simule_gain_verif < 0 & gagnant_categorie!='Gagnant')) ~ as.factor(confiance_dividende), data=e)) # 0.36***
decrit(e$perte - e$hausse_depenses_verif > 30) # 20% sur-estiment les hausses de dépenses de plus de 30€/UC
decrit(e$perte - e$hausse_depenses_verif < -30) # 57% sous-estiment les hausses de dépenses de plus de 30€/UC !
decrit(e$perte - e$hausse_depenses_verif_na < -30) # robuste quand on remplace conso par 7


##### Images #####
labels_variables_politiques_1_long <- c()
for (v in variables_politiques_1) labels_variables_politiques_1_long <- c(labels_variables_politiques_1_long, sub(' - .*', '', sub('.*: ', '', Label(e[[v]]))))
labels_variables_politiques_1 <- c("Réduire le gaspillage alimentaire", "Obliger les cantines à proposer des menus verts", "Favoriser l'usage des véhicules peu polluants ou partagés", 
                                        "Densifier les villes", "Développer les énergies renouvelables", "Taxer l'acheminement polluants des marchandises")
# (politiques_1 <- barres(title="", data=dataKN(variables_politiques_1, miss=FALSE, rev = T),  thin=T, 
#        nsp=FALSE, labels=labels_variables_politiques_1, legend = dataN(variables_politiques_1[1], return="legend", rev_legend = T), show_ticks=T))
(politiques_1 <- barres(vars = variables_politiques_1, miss=FALSE, labels=labels_variables_politiques_1))
save_plotly(politiques_1) 

labels_variables_politiques_2_long <- c()
for (v in variables_politiques_2) labels_variables_politiques_2_long <- c(labels_variables_politiques_2_long, sub(' - .*', '', sub('.*: ~ ', '', Label(e[[v]]))))
labels_variables_politiques_2 <- c("Renforcement du bonus/malus", "Subventions au train", "Contribution à un fonds mondial", "Taxe sur la viande rouge", 
                                   "Conditionnement des aides à l'innovation au bilan carbone", "Interdiction des véhicules polluants dans les centre-villes", 
                                   "Limitation de la vitesse sur autoroutes à 110 km/h", "Obligation de rénovation thermique assortie d'aides de l'État")
(politiques_2 <- barres(vars = variables_politiques_2, miss=FALSE, labels=labels_variables_politiques_2))
save_plotly(politiques_2)

labels_variables_referendum_long <- c()
for (v in variables_referendum) labels_variables_referendum_long <- c(labels_variables_referendum_long, sub(' - .*', '', sub('.*: ~ ', '', Label(e[[v]]))))
labels_variables_referendum <- c("Obligation de rénovation thermique assortie d'aides de l'État", "Chèque alimentaire aux plus démunis pour AMAP et bio", 
                                 "Interdiction de la publicité des produits polluants", "Interdiction dès 2025 des véhicules neufs les plus polluants", 
                                 "Taxe de 4% sur les dividendes des grandes entreprises\n finançant la transition", "Système de consigne de verre et plastique")
(referendum <- barres(vars = variables_referendum, miss=T, labels=labels_variables_referendum))
save_plotly(referendum)

labels_variables_devoile_long <- c()
for (v in variables_devoile) labels_variables_devoile_long <- c(labels_variables_devoile_long, sub(' - .*', '', sub('.*]', '', Label(e[[v]]))))
labels_variables_devoile <- c("Obligation de rénovation thermique + aides de l'État (V)", "Limitation de la vitesse sur autoroutes à 110 km/h (F)", 
                                 "Contribution à un fonds mondial (F)", "Taxe sur la viande rouge (F)")
(devoile <- barres(vars = variables_devoile, miss=F, labels=labels_variables_devoile))
save_plotly(devoile)

(confiance_sortition <- barres(vars = "confiance_sortition", miss = F, labels="Confiance dans la capacité de citoyens tirés au sort \nà délibérer de manière productive sur des questions politiques complexes"))
save_plotly(confiance_sortition)

(pour_sortition <- barres(vars = "pour_sortition", miss = T, thin=F, labels="Pour une assemblée constituée de 150 citoyens tirés au sort, \ndotée d'un droit de veto sur les textes votés au Parlement"))
save_plotly(pour_sortition)

(connait_CCC <- barres(vars = "connait_CCC", miss = F, labels="Avez-vous entendu parler de \nla Convention Citoyenne pour le Climat ?"))
save_plotly(connait_CCC)

(Connaissance_CCC <- barres(vars = "Connaissance_CCC", miss = F, labels="Connaissance de la Convention Citoyenne pour le Climat\n (évaluation du champ libre demandant de la décrire)"))
save_plotly(Connaissance_CCC)

(sait_CCC_devoilee <- barres(vars = "sait_CCC_devoilee", miss = F, labels="Des mesures proposées par la Convention \nCitoyenne pour le Climat ont déjà été dévoilées"))
save_plotly(sait_CCC_devoilee)

(gilets_jaunes <- barres(vars = "gilets_jaunes", miss = T, labels="Que pensez-vous des gilets jaunes ?"))
save_plotly(gilets_jaunes)

(gauche_droite <- barres(vars = "gauche_droite", miss = F, labels="Comment vous définiriez-vous ?", rev=F, rev_color = T))
save_plotly(gauche_droite) 
(gauche_droite_nsp <- barres(vars = "gauche_droite_nsp", miss = T, labels="Comment vous définiriez-vous ?", rev=F, rev_color = T))
save_plotly(gauche_droite_nsp) # TODO: NSP => Indeterminate

(confiance_gouvernement <- barres(vars = "confiance_gouvernement", miss = T, labels="En général, faites-vous confiance au gouvernement\n pour prendre de bonnes décisions ?"))
save_plotly(confiance_gouvernement) 

(interet_politique <- barres(vars = "interet_politique", miss = F, labels="À quel point êtes-vous intéressé·e par la politique ?"))
save_plotly(interet_politique) 

(gagnant_categorie <- barres(vars = "gagnant_categorie", miss = F, labels="Suite à une taxe carbone avec dividende, vous seriez ...", rev=F))
save_plotly(gagnant_categorie) 

(certitude_gagnant <- barres(vars = "certitude_gagnant", miss = F, labels="Degré de certitude à la cagéorie gagnant/perdant"))
save_plotly(certitude_gagnant) 

(taxe_approbation <- barres(vars = "taxe_approbation", thin=F, miss = T, labels="Approbation d'une taxe avec dividende\n", rev = F))
save_plotly(taxe_approbation) 

(confiance_dividende <- barres(vars = "confiance_dividende", miss = F, labels="Confiance dans le fait que l'État versera le dividende"))
save_plotly(confiance_dividende) 

(trop_impots <- barres(vars = "trop_impots", miss = T, labels="Paie-t-on trop d'impôt en France ?"))
save_plotly(trop_impots) 

(problemes_invisibilises <- barres(vars = "problemes_invisibilises", miss = F, rev=F, labels="Se sent confronté à des difficultés ignorées\n des pouvoirs publics et des médias"))
save_plotly(problemes_invisibilises) 

(confiance_gens <- barres(vars = "confiance_gens", miss = F, thin=F, labels=""))
save_plotly(confiance_gens) 

(efforts_relatifs <- barres(vars = "efforts_relatifs", miss = F, labels="Prêt à faire plus d'efforts que la majorité \ndes Français contre le changement climatique"))
save_plotly(efforts_relatifs) 

(parle_CC <- barres(vars = "parle_CC", miss = F, labels="À quelle fréquence parlez-vous du changement climatique ?"))
save_plotly(parle_CC) 

(issue_CC <- barres(vars = "issue_CC", miss = F, labels="Le changement climatique sera limité \nà un niveau acceptable d’ici la fin du siècle"))
save_plotly(issue_CC) 

(effets_CC_CCC <- barres(vars = "effets_CC_CCC", miss = F, labels="Quelles seront les conséquences en France d'ici 50 ans ?"))
save_plotly(effets_CC_CCC) # TODO, aussi effets_CC_AT

(effets_CC_AT <- barres(vars = "effets_CC_AT", rev = F, miss = T, labels="Effets du changement climatique, \nsi rien n'est fait pour le limiter ?"))
save_plotly(effets_CC_AT) 

(cause_CC_CCC <- barres(vars = "cause_CC_CCC", rev = F, miss = T, labels="Le changement climatique est dû à"))
save_plotly(cause_CC_CCC) # TODO: check NSP

(France_CC <- barres(vars = "France_CC", thin = F, rev = F, miss = T, labels="La France doit prendre de l’avance \nsur d’autres pays dans la lutte contre le changement climatique"))
save_plotly(France_CC) 

(echelle_politique_CC <- barres(vars = "echelle_politique_CC", thin = F, rev = F, miss = F, labels="Le changement climatique exige\n d’être pris en charge par des politiques ..."))
save_plotly(echelle_politique_CC)  # TODO: as.item

(patrimoine <- barres(vars = "patrimoine", rev = F, rev_color = T, miss = T, labels="Patrimoine net du ménage"))
save_plotly(patrimoine) 

(redistribution <- barres(vars = "redistribution", rev = F, miss = F, labels="Il faudrait prendre aux riches pour donner aux pauvres"))
save_plotly(redistribution) 

(importance <- barres(vars = variables_importance, rev = F, rev_color = T, miss = F, labels=c("L'action sociale et associative", "La protection de l'environnement", "L’amélioration de mon niveau de vie et de confort")))
save_plotly(importance) 

labels_responsible <- c("Each one of us", "Governments", "Certain foreign countries", "The richest", "Natural causes", "Past generations")
labels_responsable <- c("Chacun d'entre nous", "Les gouvernements", "Certains pays étrangers", "Les plus riches", "Des causes naturelles", "Les générations passées")
# barres(file="CC_responsible", data=data1(variables_responsable_CC), miss=F, rev = F, sort=T, showLegend=FALSE, labels=labels_responsable, hover=labels_responsable)
(responsable_CC <- barres(vars = variables_responsable_CC, rev = F, miss = F, showLegend=F, labels=labels_responsable, hover=labels_responsable))
save_plotly(responsable_CC) 

labels_CCC_avis_long <- c()
for (v in variables_CCC_avis) labels_CCC_avis_long <- c(labels_CCC_avis_long, sub(' - .*', '', sub('.*: ', '', Label(e[[v]]))))
(CCC_avis <- barres(vars = variables_CCC_avis, rev = F, miss = F, showLegend=F, labels=labels_CCC_avis_long))
save_plotly(CCC_avis) 

labels_qualite_enfant <- c()
for (v in variables_qualite_enfant) labels_qualite_enfant <- c(labels_qualite_enfant, sub(' - .*', '', sub('.*: ', '', Label(e[[v]]))))
(qualite_enfant <- barres(vars = variables_qualite_enfant, rev = F, miss = F, showLegend=F, labels=labels_qualite_enfant))
save_plotly(qualite_enfant) 

# TODO: pour_taxe_carbone, part_anthropique, obstacles, solution_CC, nb_politiques_env