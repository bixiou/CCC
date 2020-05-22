###### Efforts relatifs #####
decrit(e$efforts_relatifs)
decrit(e$efforts_relatifs, which = e$variante_efforts_vous==1)
decrit(e$efforts_relatifs, which = e$variante_efforts_vous==0)
summary(lm(efforts_relatifs ~ variante_efforts_vous, data=e, weights = e$weight)) # +1***


##### Taxe carbone ~ sondage #####
decrit(e$pour_taxe_carbone, miss=T)
decrit(e$pour_taxe_carbone, which = e$variante_taxe_carbone=='pour', miss=T)
decrit(e$pour_taxe_carbone, which = e$variante_taxe_carbone=='contre', miss=T)
decrit(e$pour_taxe_carbone, which = e$variante_taxe_carbone=='neutre', miss=T)
summary(lm(pour_taxe_carbone!='Non' ~ variante_taxe_carbone, data=e, weights = e$weight)) # THE result +12**


##### Taxe carbone ~ label_taxe * origine_taxe #####
summary(lm(taxe_approbation!='Non' ~ question_confiance, data=e, weights = e$weight))
summary(lm(taxe_approbation!='Non' ~ label_taxe, data=e, weights = e$weight))
summary(lm(taxe_approbation!='Non' ~ origine_taxe, data=e, weights = e$weight))
summary(lm(taxe_approbation!='Non' ~ label_taxe * origine_taxe, data=e, weights = e$weight))
summary(lm(taxe_approbation!='Non' ~ label_taxe * origine_taxe * question_confiance, data=e, weights = e$weight)) # no effect
summary(lm(gagnant_categorie=='Perdant' ~ question_confiance, data=e, weights = e$weight))
summary(lm(gagnant_categorie=='Perdant' ~ label_taxe * origine_taxe * question_confiance, data=e, weights = e$weight))


##### Confiance dividende ~ label_taxe * origine_taxe #####
decrit(e$confiance_dividende)
decrit(e$confiance_dividende, which = e$origine_taxe=='gouvernement')
decrit(e$confiance_dividende, which = e$origine_taxe=='CCC')
decrit(e$confiance_dividende, which = e$origine_taxe=='inconnue')
summary(lm(confiance_dividende!='Non' ~ origine_taxe, data=e, weights = e$weight))
summary(lm(confiance_dividende!='Non' ~ label_taxe * origine_taxe, data=e, weights = e$weight)) # no effect


##### Incertitude #####
decrit(e$certitude_gagnant)
CrossTable(e$certitude_gagnant, e$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) 


##### Taxe carbone: Motivated reasoning ~ confiance_dividende ####
decrit(e$update_correct)
decrit(e$update_correct, which = e$confiance_dividende=='Oui')
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') + Gilets_jaunes + taxe_approbation, subset = feedback_infirme_large==T, data=e, weights = e$weight))
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') * confiance_dividende, subset = feedback_infirme_large==T, data=e, weights = e$weight)) # 0.14*
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') + confiance_dividende + Gilets_jaunes + taxe_approbation, subset = feedback_infirme_large==T, data=e, weights = e$weight)) # 0.06*
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') + Gilets_jaunes + taxe_approbation, subset = feedback_infirme_large==T & feedback_correct==T, data=e, weights = e$weight))
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') * confiance_dividende, subset = feedback_infirme_large==T & feedback_correct==T, data=e, weights = e$weight)) # 0.14*
summary(lm(update_correct ~ (gagnant_categorie=='Gagnant') + confiance_dividende + Gilets_jaunes + taxe_approbation, subset = feedback_infirme_large==T & feedback_correct==T, data=e, weights = e$weight)) # 0.06*


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
plot((1:length(e$biais))/length(e$biais), sort(e$biais), type='l') + grid()
lines((1:length(e$biais_plus))/length(e$biais_plus), sort(e$biais_plus), type='l', lty=2) + grid()
lines((1:length(e$biais_moins))/length(e$biais_moins), sort(e$biais_moins), type='l', lty=2) + grid()
decrit(e$biais_plus)
decrit(e$biais_moins)
decrit(e$gain)
decrit(e$gain < 0)
decrit(e$gain_min < 0)
decrit(e$gagnant_categorie) # gain_min does a better job than gain overall, truth is somewhere in between (cf. below)
decrit(e$gagnant_categorie, which = e$question_confiance==F)
decrit(e$gagnant_categorie, which = e$gain > 0) # TODO: study non affecté
decrit(e$gagnant_categorie, which = e$gain < 0)
decrit(e$gagnant_categorie, which = e$gain_min > 0)
decrit(e$gagnant_categorie, which = e$gain_min < 0) # gain meilleur que gain_min pour prédire Perdant (84 vs 77%) mais beaucoup moins bon pour prédire Gagnant (14 vs 34%)
CrossTable(e$confiance_dividende, e$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # seuls ceux qui y croient se disent gagnants souvent
decrit(e$gagnant_categorie, which = e$gain > 0 & e$confiance_dividende=='Oui')
decrit(e$gagnant_categorie, which = e$gain > 50 & e$confiance_dividende=='Oui') # même parmi ceux qui croient à leur gain > 0 se disent souvent non affecté (40%) et parfois perdant (21%)
decrit(e$gagnant_categorie, which = e$gain_min > 0 & e$confiance_dividende=='Oui') # gain_min pas tellement meilleur prédicteur
CrossTable(e$simule_gagnant > 0, e$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # 


##### Politiques env ~ info_CCC #####
decrit(round(e$prop_referenda_politiques_2, 3))
summary(lm(prop_referenda_politiques_2 ~ info_CCC, data=e, weights = e$weight)) # 0.03*


##### Opinions politiques #####
decrit(e$Gilets_jaunes)


##### Obstacles #####
# pb: ne peut être utilisé que pour comparabilité. Le résultat en soit est biaisé car l'ordre des items n'a pas été randomisé.
decrit(e$obstacle_1) # lobbies 38%
decrit(e$obstacle_2) # manque_volonte 27%, manque_cooperation 27%
decrit(e$obstacle_3) # manque_cooperation 23%, manque_volonte 19%
decrit(e$obstacle_4) # inegalites 20%, demographie 18%
decrit(e$obstacle_5) # incertitudes 21%, technologies 18%, demographie 18%
decrit(e$obstacle_6) # incertitudes 24%, demographie 21%
decrit(e$obstacle_7) # technologies 24%, incertitudes 21%
decrit(e$obstacle_8) # rien de tout cela 67%


##### Problème conso L/100km #####
length(which(abs(e$hausse_essence_verif_na - e$hausse_essence) > 0.001)) # toutes dans e$bug==F
length(which(abs(e$hausse_diesel_verif_na - e$hausse_diesel) > 0.001)) # hausse_diesel et _essence ont été calculées avec la conso moyenne (pas celle renseignée par le répondant) pour bug = T
length(which(abs(e$hausse_essence_verif - e$hausse_essence) > 0.001)) # toutes dans e$bug==T
length(which(abs(e$hausse_diesel_verif - e$hausse_diesel) > 0.001))


##### Mécanismes : incertitude #####
decrit(e$certitude_gagnant)
decrit(e$certitude_gagnant, numbers=T)
# Il y a plus de perdants parmi ceux qui sont sûrs de leur réponse
CrossTable(e$certitude_gagnant, e$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) 
# Parmi les < 100 qui croient recevoir le dividende, est-ce que l'incertitude augmente la probabilité de se penser perdant ? Non, elle augmente la proba de Non affecté, i.e. Non affecté ~ NSP
summary(lm(gagnant_categorie=='Perdant' ~ (certitude_gagnant < 1), data=e, subset = e$confiance_dividende=='Oui', weights = e$weight))
summary(lm(gagnant_categorie=='Non affecté' ~ (certitude_gagnant < 1), data=e, subset = e$confiance_dividende=='Oui', weights = e$weight))
summary(lm(gagnant_categorie=='Gagnant' ~ (certitude_gagnant < 1), data=e, subset = e$confiance_dividende=='Oui', weights = e$weight))
decrit(e$certitude_gagnant, which = e$confiance_dividende=='Oui')
summary(lm(tax_acceptance ~ (certitude_gagnant < 1) * gagnant_categorie, data=e, subset = e$confiance_dividende=='Oui', weights = e$weight)) # no strong effect of uncertainty
summary(lm(tax_approval ~ (certitude_gagnant < 1) * gagnant_categorie, data=e, subset = e$confiance_dividende=='Oui', weights = e$weight)) # no effect


##### Mécanismes : confiance #####
decrit(e$confiance_gouvernement)
CrossTable((e$confiance_gouvernement >= 0), e$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) # la confiance augmente la proba de se penser Non affecté plutôt que Perdant
summary(lm(gagnant_categorie=='Perdant' ~ (confiance_gouvernement < 0) * (confiance_dividende < 0), data = e, weights = e$weight)) # dividende 0.33*** / gouv: 0.13**
summary(lm(gagnant_categorie=='Perdant' ~ (confiance_gouvernement < 0) * as.factor(confiance_dividende), data = e, weights = e$weight)) # confiance_gouv pas significatif / dividende -0.27*** et -0.45***
summary(lm(tax_acceptance ~ (confiance_gouvernement < 0) * (confiance_dividende < 0), data = e, weights = e$weight)) # dividende -0.41*** / gouv -10*
summary(lm(tax_acceptance ~ (confiance_gouvernement < 0) * as.factor(confiance_dividende), data = e, weights = e$weight)) # confiance_gouv pas significatif / dividende 0.38*** et 0.46***
# summary(ivreg(tax_acceptance ~ (gagnant_categorie!='Perdant') + confiance_gouvernement + Gilets_jaunes | (confiance_dividende < 0) + confiance_gouvernement + Gilets_jaunes, data=e),diagnostics=T)
summary(lm(update_correct ~ gagnant_categorie=='Gagnant', subset = feedback_infirme_large==T, data=e, weights = e$weight)) # not enough power (only 4 overly optimistic loser)
summary(lm(update_correct ~ gagnant_categorie=='Gagnant', subset = feedback_infirme_large==T & feedback_correct==T, data=e, weights = e$weight))
decrit(e$confiance_dividende) # seuls 12% croient recevoir le dividende : ça suffit à expliquer que quasiment tout le monde se pense perdant
CrossTable(e$simule_gain_verif > 0, e$gagnant_categorie, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) 
# Parmi le peu qui croient recevoir le dividende, gagnant_categorie est bien plus alignée avec la réponse objective: +32***p.p.
CrossTable(e$simule_gain_verif[e$confiance_dividende=='Oui'] > 0, e$gagnant_categorie[e$confiance_dividende=='Oui'], prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE) 
summary(lm(((simule_gain_verif > 0 & gagnant_categorie!='Perdant') | (simule_gain_verif < 0 & gagnant_categorie!='Gagnant')) ~ as.factor(confiance_dividende), data=e, weights = e$weight)) # 0.36***
decrit(e$perte - e$hausse_depenses_verif > 30) # 19% sur-estiment les hausses de dépenses de plus de 30€/UC
decrit(e$perte - e$hausse_depenses_verif < -30) # 56% sous-estiment les hausses de dépenses de plus de 30€/UC !
decrit(e$perte - e$hausse_depenses_verif_na < -30) # robuste quand on remplace conso par 7


##### Images #####
labels_variables_politiques_1_long <- c()
for (v in variables_politiques_1) labels_variables_politiques_1_long <- c(labels_variables_politiques_1_long, sub(' - .*', '', sub('.*: ', '', Label(e[[v]]))))
labels_variables_politiques_1 <- c("Réduire le gaspillage alimentaire", "Obliger les cantines à proposer des menus verts", "Favoriser l'usage des véhicules peu polluants ou partagés", 
                                        "Densifier les villes", "Développer les énergies renouvelables", "Taxer l'acheminement polluants des marchandises")
# (politiques_1 <- barres(title="", data=dataKN(variables_politiques_1, miss=FALSE, rev = T),  thin=T, 
#        nsp=FALSE, labels=labels_variables_politiques_1, legend = dataN(variables_politiques_1[1], return="legend", rev_legend = T), show_ticks=T))
(politiques_1 <- barres(vars = variables_politiques_1, miss=FALSE,  labels=labels_variables_politiques_1))
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

(pour_sortition <- barres(vars = "pour_sortition", miss = T, rev=F, thin=F, labels="Pour une assemblée constituée de 150 citoyens tirés au sort, \ndotée d'un droit de veto sur les textes votés au Parlement"))
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

(effets_CC_CCC <- barres(vars = "effets_CC_CCC", miss = F, rev = F, labels="Quelles seront les conséquences en France d'ici 50 ans ?"))
save_plotly(effets_CC_CCC) 

(effets_CC_AT <- barres(vars = "effets_CC_AT", rev = F, miss = T, labels="Effets du changement climatique, \nsi rien n'est fait pour le limiter ?"))
save_plotly(effets_CC_AT) 

(cause_CC_CCC <- barres(vars = "cause_CC_CCC", miss = F, labels="Cause du changement climatique"))
save_plotly(cause_CC_CCC)

(France_CC <- barres(vars = "France_CC", thin = F, rev = F, miss = T, labels="La France doit prendre de l’avance \nsur d’autres pays dans la lutte contre le changement climatique"))
save_plotly(France_CC) 

(echelle_politique_CC <- barres(vars = "echelle_politique_CC", thin = F, rev = F, miss = F, labels="Le changement climatique exige\n d’être pris en charge par des politiques ..."))
save_plotly(echelle_politique_CC) 

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

# TODO: pour_taxe_carbone, part_anthropique, obstacles, solution_CC, nb_politiques_env, qualite_enfant, cause_CC_AT

##### Champ libre #####
# 988: "Bonjour !.\nDepuis des lustres je n'ai aucune confiance dans notre système de gouvernance.\nTrop de Députés,\ndes Sénateurs inutiles,\nles Régions sont une entité faisant double emploi avec les Départements,\n
#       donc à supprimer.\nLes salaires et tous les défraiements de nos politiques doivent être revus à la baisse. \nL'état fera ainsi des économies et nous n'auront pas à subir des taxes supplémentaires !\nVoilà !!!"
# 947: "Je ne veux pas que le monde que connaîtra plut tard mes enfants, petit enfant (etc) soit polluer en mauvais état et c'est pour ça que je suis pour tout ce qui est bio"
# 935: "Je ne comprends pas l'utilité d'augmenter le coût des énergie et ensuite verser cette prime unitaire à tous.\nCertes cela devrait pousser à rouler moins en voiture.\n
#       Mais la consommation d'énergie pour le chauffage est une première nécessité pour tous."
# 929: "Un seul tour de vote présidentiel,il devrait y avoir,pendant un an 2 présidents à la tête du pays et se partagerait un seul revenu et vivre en colocation.\n
#       A l'issu de la fin de la première année d’exercice un vote aura lieu pour élire le seul président,suivant les résultats du meilleur, qui gouvernera le pays.
#       Il y va de la confiance du peuple et de la reconnaissance du gouvernement."
# 883: "faisant partie de la classe moyenne (inférieure),1650 salaire monsieur et notre fils chômage (490€)on a droit a aucune aide (pas d'apl,pas d'aide complémentaire santé, pas de cheque énergie etc..)
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
# 481: "Concernant la mesure décrite, je suis favorable à la mise en place d’une taxe carbone, mais pas à la redistribution vers TOUS les ménages. \nJe pense que la redistribution 
#       devrait se faire uniquement vers les plus faibles revenus, ce qui permettrait d’augmenter celle-ci." [a répondu Non à approbation]
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
decrit("pour_fonds_mondial", data=e)
decrit("pour_fonds_mondial", data=e, which=e$info_CCC==0) # ne s'explique pas par l'info_CCC
decrit("interdiction_polluants", data=b)
decrit("pour_restriction_centre_ville", data=e) # + CCC
decrit("pour_taxe_viande", data=b)
decrit("taxe_viande", data=b)
# responsable_, taxe_approbation, parle/cause/effets_CC + parth_anthropique, revenu, caracs énergie, compo ménage, socio-démo (+ mail), transports_courses/travail/loisir, politique, champ libre


##### Comparaison avec sondage Fabrice Étilé ##### TODO


##### Comparaison avec sondages CCC ####
decrit(c$solution_CC_1e) # changer 75%, états 15%, progres et rien 5%
decrit(e$solution_CC_changer, weight=F) # 67%
decrit(e$solution_CC_progres, weight=F) # 13%
decrit(e$solution_CC_traite, weight=F) # 19%
decrit(e$solution_CC_rien, weight=F) # 12%
decrit(c$echelle_politique_CC_1e) # pareil
decrit(e$echelle_politique_CC) # TODO: recoder labels pour qu'ils coïncident
decrit(c$pour_taxe_distance_1e) # CCC plus écolo
decrit(e$pour_taxe_distance)
decrit(c$pour_renouvelables_1e)
decrit(e$pour_renouvelables)
decrit(c$pour_densification_1e)
decrit(e$pour_densification)
decrit(c$pour_voies_reservees_1e) # CCC plus écolo
decrit(e$pour_voies_reservees)
decrit(c$pour_cantines_vertes_1e) # CCC plus écolo
decrit(e$pour_cantines_vertes)
decrit(c$pour_fin_gaspillage_1e) # CCC plus écolo
decrit(e$pour_fin_gaspillage)
decrit(c$France_CC_1e) # CCC plus écolo
decrit(e$France_CC)
# obstacles
decrit(c$cause_CC_1e)
decrit(e$cause_CC_CCC)
decrit(c$effets_CC_1e)
decrit(grepl("pénible", e$effets_CC_CCC))
decrit(c$confiance_gens_1e)
decrit(e$confiance_gens) # CCC beaucoup moins méfiante 
# qualite_enfant
decrit(c$redistribution_1e)
decrit(e$redistribution) # CCC moins pro-redistribution
decrit(c$problemes_invisibilises_1e)
decrit(e$problemes_invisibilises) # assez représentatif
decrit(c$importance_associatif_1e)
decrit(e$importance_associatif) # CCC + pro-asso
decrit(c$importance_environnement_1e)
decrit(e$importance_environnement) # CCC plus écolo
decrit(c$importance_confort_1e)
decrit(e$importance_confort) # same
decrit(c$pour_obligation_renovation_1e)
decrit(e$pour_obligation_renovation) # similaire mais échelles pas comparables
decrit(c$pour_vitesse_110_1e)
decrit(e$pour_limitation_110) # CCC plus écolo
decrit(c$tirage_sort_1e)
decrit(e$confiance_sortition) # Différence énorme : serait-ce ça qui détermine la participation (et est corrélé avec être écolo) ?
decrit(c$issue_CC_1e)
decrit(e$issue_CC) # same
# socio-demo, proprio, 

## Tests
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
decrit(c$agis) # ADEME (2019: 115)
decrit(c$importance_environnement_1e) # ADEME (2019: 174) 
decrit(c$pour_) # 102
decrit(c$obstacles_) # 

decrit(c$situation_revenus_1e) # Ipsos (2017) mais résultats non donnés
decrit(c$redistribution_1e) # Ipsos (2019) 66% d'accord 
decrit(c$problemes_invisibilises_1e) # Très: 18% (12%) / Assez souvent: 33% (45%) / Rarement: 17% (peu souvent: 41%) / jamais: 31% (3%) / NSP: 2%.  CREDOC, Enquête « Conditions de vie et Aspirations », 2015 

# TODO: Étilé, socio-démos, Ipsos