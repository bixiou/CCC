# cf. bit.ly/Francais_taxe_carbone et https://www.overleaf.com/project/5fccdb8350520ddcb427cd33
# TODO! utiliser e2$gagnant_alternative_categorie comme proxy pour e2$gagnant_categorie (et pallier la non comparabilité des formats)
##### *** Détails présentation Cired *** #####
# Pourquoi tant de Perdant (v0, v1)?
# 1 confiance_dividende
# 1.a semble tout expliquer dans v1
decrit(e1$confiance_dividende) # 46/42/12 Non/Moitié/Oui
summary(lm(gagnant_categorie=="Perdant" ~ as.factor(confiance_dividende), data=e1, weights = e1$weight)) # +28/48*** 30% de Perdant parmi ceux qui croient au dividende: le bon chiffre
# summary(lm(gagnant_categorie=='Perdant' ~ (confiance_gouvernement < 0) * as.factor(confiance_dividende), data = e1, weights = e1$weight)) # capture confiance_gouv: tout passe par là
summary(lm(taxe_approbation!="Non" ~ as.factor(confiance_dividende), data=e1, weights = e1$weight)) # +37/46***
decrit(e1$gain < 0) # 53%
decrit(e1$gain_min < 0) # 69% TODO! do the same with hausse_depenses_obj instead of perte
#     gain, gain_min bon prédicteurs de Perdant qd <0 (84 vs 77%) et >0 (36 vs 17%) (e.g. 84% de Perdants pour gain<0)
#     Parmi le peu qui croient recevoir le dividende, gagnant_categorie est bien plus alignée avec la réponse objective: +32***p.p.
reg_correct <- lm(((simule_gain_verif > 0 & gagnant_categorie!='Perdant') | (simule_gain_verif < 0 & gagnant_categorie!='Gagnant')) ~ as.factor(confiance_dividende), data=e1, weights = e1$weight) # 0.32***
Table_correct <- stargazer(reg_correct, title="Ceux qui croient au dividende répondent plus correctement à la catégorie de gain", model.names = F, model.numbers = FALSE, header = FALSE, single.row = T, omit.table.layout = 'n', 
                                     covariate.labels = c("Constante", "Confiance dividende: ``À moitié''", "Confiance dividende: ``Oui''"),
                                     dep.var.labels = c("Réponse correcte à la catégorie de gain"), dep.var.caption = "",
                                     no.space=TRUE, intercept.bottom=FALSE, intercept.top=TRUE, omit.stat=c("adj.rsq", "f", "ser", "ll", "aic"), label="tab:correct")
write_clip(gsub('\\end{table}', "} {\\footnotesize \\parbox[t]{10.5cm}{\\linespread{1.2}\\selectfont \\textsc{Note:}  Erreurs type entre parenthèses. Modalité omise: \\textit{Non}. $^{*}$p$<$0.1; $^{**}$p$<$0.05; $^{***}$p$<$0.01.  }} \\end{table}",
                gsub('\\begin{tabular}{@', '\\makebox[\\textwidth][c]{ \\begin{tabular}{@', Table_correct, fixed=TRUE), fixed=TRUE), collapse=' ') # gsub("\\textit{Note:}", "", Table_correct)
  #     plus d'update correct parmi ceux qui ont confiance dans dividende, les non GJ et ceux qui approuvent
summary(lm(update_correct ~ confiance_dividende, subset = feedback_infirme_large==T, data=e1, weights = e1$weight)) # 0.14*** TODO
summary(lm(taxe_approbation!="Non" ~ question_confiance, data=e1, weights = e1$weight)) # pas d'influence de la question
summary(lm(gagnant_categorie=="Perdant" ~ question_confiance, data=e1, weights = e1$weight)) # pas d'influence de la question
# 1.b cet effet peut être mesuré plus finement dans v2
reg_gain_div <- lm(gain ~ as.factor(dividende), data = e2, weights = e2$weight) # 70/75% du dividende pris en compte
# reg_gain_div_eelv <- lm(gain ~ as.factor(dividende) * (origine_taxe=="EELV"), data = e2, weights = e2$weight) # 61/70% du dividende pris en compte qd gouv, mais...
reg_gain_div_gouv <- lm(gain ~ as.factor(dividende), data = e2, subset = e2$origine_taxe=="gouvernement", weights = e2$weight) # 61/70% du dividende pris en compte qd gouv, mais...
summary(reg_gain_div_eelv)
Table_gain_div <- stargazer(reg_gain_div, reg_gain_div_gouv, title="Entre 61 et 75\\% du dividende est pris en compte", model.names = F, model.numbers = FALSE, header = FALSE, single.row = T, omit.table.layout = 'n', 
                                     dep.var.labels = c("Gain subjectif"), dep.var.caption = "",
                                     covariate.labels = c("Constante", "Dividende: 110 €/an", "Dividende: 170 €/an"), #, "Origine: EELV", "110 $\\times$ EELV", "170 $\\times$ EELV"),
                                     add.lines = list(c("Origine: gouvernement", "", "\\checkmark ")),
                                     no.space=TRUE, intercept.bottom=FALSE, intercept.top=TRUE, omit.stat=c("adj.rsq", "f", "ser", "ll", "aic"), label="tab:gain_div")
write_clip(gsub('\\end{table}', "} {\\footnotesize \\parbox[t]{10cm}{\\linespread{1.2}\\selectfont \\textsc{Note:} Erreurs type entre parenthèses. Modalité omise: \\textit{aucun dividende}. $^{***}$p$<$0.01.  }} \\end{table}", 
                gsub('\\begin{tabular}{@', '\\makebox[\\textwidth][c]{ \\begin{tabular}{@', Table_gain_div, fixed=TRUE), fixed=TRUE), collapse=' ') # gsub("\\textit{Note:}", "", Table_correct) # Erreurs type entre parenthèses. 

round(impute_dividende_escompte(print=T), 2) # .33 part du dividende pris en compte d'après gain, gain_min (imputée)
round(impute_dividende_escompte(escompte_moitie = 0.8, escompte_non = 0.3, print=T), 2) # .59 ajustement nécessaire pour se rapprocher de l'escompte réel: marche encore, mais pas si extrême que ce qu'on pensait
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
iv_app_Gain_div <- summary(ivreg(taxe_approbation!='Non' ~ (!is.na(gain) & gain >= 0) | as.factor(dividende), data=e2, weights = e2$weight), diagnostics = TRUE) # effet 0.46***
iv_app_gain_div <- summary(ivreg(taxe_approbation!='Non' ~ gain | as.factor(dividende), data=e2, weights = e2$weight), diagnostics = TRUE) # F-stat: 57 $diagnostics[1,3]
# iv_app_gain_div_gouv <- summary(ivreg(taxe_approbation!='Non' ~ gain | as.factor(dividende), data=e2, subset = origine_taxe=="gouvernement", weights = e2$weight), diagnostics = TRUE) # F-stat: 30 $diagnostics[1,3]
iv_app_Gain_div_gouv <- summary(ivreg(taxe_approbation!='Non' ~ (!is.na(gain) & gain >= 0) | as.factor(dividende), data=e2, subset = origine_taxe=="gouvernement", weights = e2$weight), diagnostics = TRUE) # effet 0.19***
f_stats_app_gain_div <- sprintf("%.1f", round(c(iv_app_Gain_div$diagnostics[1,3], iv_app_gain_div$diagnostics[1,3], iv_app_Gain_div_gouv$diagnostics[1,3]), 1))
summary(reg_app_div_gouv <- lm(taxe_approbation!='Non' ~ as.factor(dividende), data=e2, subset = origine_taxe=="gouvernement", weights = e2$weight)) # 2/6
# reg_gain_div_gouv <- lm((gain > 0) ~ as.factor(dividende), data=e2, subset = origine_taxe=="gouvernement", weights = e2$weight) #
summary(reg_gain_div_gouv <- lm((!is.na(gain) & gain >= 0) ~ as.factor(dividende), data=e2, subset = origine_taxe=="gouvernement", weights = e2$weight)) #
summary(iv_app_gain_div <- ivreg(taxe_approbation!='Non' ~ gain | as.factor(dividende), data=e2, weights = e2$weight)) # F-stat: 57 $diagnostics[1,3]
# iv_app_Gain_div <- ivreg(taxe_approbation!='Non' ~ (gain > 0) | as.factor(dividende), data=e2, weights = e2$weight) # effet 0.46***
# iv_app_Gain_div_gouv <- ivreg(taxe_approbation!='Non' ~ (gain > 0) | as.factor(dividende), data=e2, subset = origine_taxe=="gouvernement", weights = e2$weight) # effet 0.19***
summary(iv_app_Gain_div <- ivreg(taxe_approbation!='Non' ~ (!is.na(gain) & gain >= 0) | as.factor(dividende), data=e2, weights = e2$weight)) # effet 0.46***
summary(iv_app_Gain_div_gouv <- ivreg(taxe_approbation!='Non' ~ (!is.na(gain) & gain >= 0) | as.factor(dividende), data=e2, subset = origine_taxe=="gouvernement", weights = e2$weight)) # effet 0.19***
Table_app_gain_div <- stargazer(reg_gain_div_gouv, reg_app_div_gouv, iv_app_Gain_div, iv_app_gain_div, iv_app_Gain_div_gouv, 
                                title="Aparté : effet du dividende sur l'acceptation médié par le gain subjectif.", model.names = T, model.numbers = FALSE, header = FALSE, single.row = F, omit.table.layout = 'n', 
                                     dep.var.labels = c("non \\emph{Perdant}", "Acceptation de la taxe carbone avec dividende"), dep.var.caption = "",
                                     covariate.labels = c("Constante", "Dividende: 110 €/an", "Dividende: 170 €/an", "non \\emph{Perdant}", "gain subjectif"), #, "Origine: EELV", "110 $\\times$ EELV", "170 $\\times$ EELV"),
                                     add.lines = list(c("Origine: gouvernement", "\\checkmark ", "\\checkmark ", "", "", "\\checkmark "),
                                                      c("F-statistique effective", "", "", f_stats_app_gain_div)),
                                     no.space=TRUE, intercept.bottom=FALSE, intercept.top=TRUE, omit.stat=c("adj.rsq", "f", "ser", "ll", "aic"), label="tab:app_gain_div")
write_clip(gsub('\\end{table}', "} {\\footnotesize \\parbox[t]{10cm}{\\linespread{1.2}\\selectfont \\textsc{Note:} Erreurs type entre parenthèses. Modalité omise: \\textit{aucun dividende}. $^{***}$p$<$0.01.  }} \\end{table}", 
                gsub('\\begin{tabular}{@', '\\makebox[\\textwidth][c]{ \\begin{tabular}{@', Table_app_gain_div, fixed=TRUE), fixed=TRUE), collapse=' ') # gsub("\\textit{Note:}", "", Table_correct) # Erreurs type entre parenthèses. 
# \\[-1.8ex] & \multicolumn{2}{c}{\textit{OLS}} & \multicolumn{3}{c}{\textit{IV}} \\ \hline \\[-1.8ex] 
# 1.c Mais le dividende n'explique pas tout
#     Potentiellement sa non-prise en compte est largement inintentionnelle : oubli, instinct, ancrage
#       Ancrage: certains estiment leurs gains nets à partir du dividende comme proxy pour les hausses de dépenses moyennes. Pensant perdre un peu plus que la moyenne, ils répondent alors disons -30. 
#                On a alors l'impression qu'ils ne croient pas au dividende, alors que c'est juste qu'ils ne font pas le calcul, et c'est plutôt un biais sur hausse_depenses. 
#     L'évolution de gagnant_categorie ne s'explique pas par dividende puisque celui-ci ne varie pas pour 110
# 2 autres mécanismes 
# 2.a o effet de cadrage 
#     ajout de "NSP" explique 20 p.p., contexte & formulation 15 p.p. (v1: juste avant: hausse dépenses, v2 formulation plus douce)
summary(lm(taxe_approbation=='Oui' ~ Gagnant_categorie, data=e2, weights = e2$weight)) 
summary(lm(pour_taxe_carbone!="Non" ~ vague * variante_taxe_carbone, data=eb)) # c'est bien cadrage et pas évolution des croyances entre deux vagues (qui aurait affecté approbation); effet limité à l'explication des réponses à Perdant: biais plus faible qu'on pensait mais pas des biais restent
# 2.b o biais: s'imaginent à tort particuliers
(perte_relative_partielle <- barres(vars = "perte_relative_partielle", df = b, miss = T, rev=F, labels="Une hausse des taxes sur les énergies fossiles\n ferait perdre plus à votre ménage que la moyenne"))
save_plotly(perte_relative_partielle) 
decrit("perte_relative_partielle", data=b) # v0 environ 60% pensent perdre plus que la moyenne (proportions similaires pour TVA, fioul, gaz)
summary(lm(gagnant_categorie == "Perdant" ~ perte_relative_partielle > 0, data = b, weights = b$weight)) # +21***
decrit(e1$perte - e1$hausse_depenses_verif > 30) # 19% sur-estiment les hausses de dépenses de plus de 30€/UC (biais)
decrit(e1$perte - e1$hausse_depenses_verif < -30) # 56% sous-estiment les hausses de dépenses de plus de 30€/UC ! TODO comparer à v0, voir dans v0 s'ils surestiment aussi plus perte_partielle
# 2.c o méfiance envers l'estimation: le biais précédent doublé d'une meilleure confiance en eux qu'en nous
decrit("avis_estimation", data = e2) #  34/31/12 Trop peu/Correct/Trop
#     Comme ceux qui croient à notre estimation intègrent le dividende, l'effet doit passer par hausse_depenses et pas seulement dividende.
decrit(e2$gain + e2$hausse_depenses_par_uc, which = (e2$avis_estimation %in% c("Correcte", "NSP")) & e2$dividende==0, weights = e2$weight) # mean 4 / médiane 3 : dividende qu'ils croient recevoir s'ils acceptent notre estimation
decrit(e2$gain + e2$hausse_depenses_par_uc, which = (e2$avis_estimation %in% c("Correcte", "NSP")) & e2$dividende==110, weights = e2$weight) # 110 / 125
decrit(e2$gain + e2$hausse_depenses_par_uc, which = (e2$avis_estimation %in% c("Correcte", "NSP")) & e2$dividende==170, weights = e2$weight) # 150 / 172
#     Ceux qui nous croient approuvent +.24***, sauf pour ceux qui répondent gagnant_categorie=NSP, qui doutent probablement du dividende
summary(reg_app_estim <- lm(taxe_approbation=="Oui" ~ (Avis_estimation=="Correcte") + Avis_estimation, data = e2, weights = e2$weight)) # 46% Oui quand estimation correcte, ***26 p.p. de plus que les autres
summary(reg_app_estim_inter <- lm(taxe_approbation=="Oui" ~ (Avis_estimation=="Correcte") * I(gagnant_categorie %in% c("NSP")), data = e2, weights = e2$weight))
summary(reg_acc_estim <- lm(taxe_approbation!="Non" ~ (Avis_estimation=="Correcte") + Avis_estimation, data = e2, weights = e2$weight)) # 46% Oui quand estimation correcte, ***26 p.p. de plus que les autres
summary(reg_acc_estim_inter <- lm(taxe_approbation!="Non" ~ (Avis_estimation=="Correcte") * I(gagnant_categorie %in% c("NSP")), data = e2, weights = e2$weight))
Table_app_estim <- stargazer(reg_app_estim, reg_app_estim_inter, reg_acc_estim, reg_acc_estim_inter,
                              title="Soutien à la taxe avec dividende en fonction de l'avis sur notre estimation de la hausse des dépenses", model.names = T, model.numbers = FALSE, header = FALSE, single.row = F, omit.table.layout = 'n', 
                               dep.var.labels = c("Soutien à T\\&D: ``Oui''", "Soutien à T\\&D: pas ``Non''"), dep.var.caption = "", omit = "estimationCorrecte",
                               covariate.labels = c("Constante", "Estimation: Correcte", "Estimation: NSP", "Estimation: Trop élevée", "Catégorie gain subjectif: NSP", "Estim: Correcte $\\times$ Gain: NSP"), #, "Origine: EELV", "110 $\\times$ EELV", "170 $\\times$ EELV"),
                               no.space=TRUE, intercept.bottom=FALSE, intercept.top=TRUE, omit.stat=c("adj.rsq", "f", "ser", "ll", "aic"), label="tab:app_estim")
write_clip(gsub('\\end{table}', "} {\\footnotesize \\parbox[t]{12cm}{\\linespread{1.2}\\selectfont \\textsc{Note:} Erreurs type entre parenthèses. Modalité omise: \\textit{Estimation: Trop petite}. $^{**}$p$<$0.05; $^{***}$p$<$0.01.  }} \\end{table}", 
                gsub('\\begin{tabular}{@', '\\makebox[\\textwidth][c]{ \\begin{tabular}{@', Table_app_estim, fixed=TRUE), fixed=TRUE), collapse=' ') # gsub("\\textit{Note:}", "", Table_correct) # Erreurs type entre parenthèses. 

#     Pour résumé: il n'y pas qu'un manque de confiance dividende, aussi la croyance de perdre plus que ce qu'on leur dit, et il y a des doutes dividende non pris en compte plus haut car ils s'expriment comme NSP
cor(e2$avis_estimation, e2$confiance_gouvernement) # 0.02
cor(e2$avis_estimation=="Correcte", e2$confiance_gouvernement) # 0.09
cor(e2$avis_estimation=="Correcte", e2$confiance_gouvernement >= 0) # 0.07
cor(e2$avis_estimation[e2$Avis_estimation!="NSP" & e2$confiance_gouvernement!="NSP"], e2$confiance_gouvernement[e2$confiance_gouvernement!="NSP" & e2$Avis_estimation!="NSP"]) # 0.02
# CrossTable(e2$confiance_gouvernement, e2$Avis_estimation, prop.c = FALSE, prop.t = F, prop.chisq = FALSE, total.r = F) # 
# CrossTable(e2$Avis_estimation, e2$confiance_gouvernement, prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE, total.r = F) # 
# 2.d x incertitude + aversion à la perte: prédit faible certitude et que les moins sûrs se pensent plus perdants, c'est le contraire qu'on observe
decrit("certitude_gagnant", data=e1)  # 
CrossTable(e1$Certitude_gagnant, (e1$gagnant_categorie=='Perdant'), prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE, total.r = F) # Il y a plus de perdants parmi ceux qui sont sûrs de leur réponse
# 2.e x raisonnement motivé: lié à méfiance mais ici la non-intégration d'une info n'est pas liée à la source de l'info mais à sa teneur. On s'attend à asymétrie dans update.
#     contrairement à v0, on ne peut pas mettre en évidence asymétrie dans l'update: les perdants optimistes sont 40% (4) à s'aligner (contre 82% (~45) en v0) et les gagnants pessimistes 26% (contre 12%), échantillon trop faible
#     pourquoi ça aurait changé ? Évolution des opinions; cadrage (certitude, (question_confiance, hausse_depenses plutôt que gain)); hasard (on ne peut pas exclure qu'il y ait de l'asymétrie); 
CrossTable(e1$gagnant_categorie[e1$simule_gagnant==1 & e1$bug_touche==F], e1$gagnant_feedback_categorie[e1$simule_gagnant==1 & e1$bug_touche==F], prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
CrossTable(e1$gagnant_categorie[e1$simule_gagnant==0 & e1$bug_touche==F], e1$gagnant_feedback_categorie[e1$simule_gagnant==0 & e1$bug_touche==F], prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
#        ou bien l'asymétrie était drivée par les fuel_2_1=="Diesel" ? Non: ils ont le même update que les autres
CrossTable(b$gagnant_categorie[b$simule_gagnant==1], (b$gagnant_feedback_categorie[b$simule_gagnant==1]=="Gagnant"), prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
CrossTable(b$gagnant_categorie[b$simule_gagnant==0], (b$gagnant_feedback_categorie[b$simule_gagnant==0]=="Perdant"), prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
CrossTable(b$gagnant_categorie[b$simule_gagnant==1 & (is.na(b$fuel_2_1) | b$fuel_2_1!="Diesel")], (b$gagnant_feedback_categorie[b$simule_gagnant==1 & (is.na(b$fuel_2_1) | b$fuel_2_1!="Diesel")]=="Gagnant"), prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
CrossTable(b$gagnant_categorie[b$simule_gagnant==0 & (is.na(b$fuel_2_1) | b$fuel_2_1!="Diesel")], (b$gagnant_feedback_categorie[b$simule_gagnant==0 & (is.na(b$fuel_2_1) | b$fuel_2_1!="Diesel")]=="Perdant"), prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
CrossTable(b$gagnant_categorie[b$simule_gagnant==1 & (is.na(b$fuel_2_1) | b$fuel_2_1=="Diesel")], (b$gagnant_feedback_categorie[b$simule_gagnant==1 & (is.na(b$fuel_2_1) | b$fuel_2_1=="Diesel")]=="Gagnant"), prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
CrossTable(b$gagnant_categorie[b$simule_gagnant==0 & (is.na(b$fuel_2_1) | b$fuel_2_1=="Diesel")], (b$gagnant_feedback_categorie[b$simule_gagnant==0 & (is.na(b$fuel_2_1) | b$fuel_2_1=="Diesel")]=="Perdant"), prop.c = FALSE, prop.t = FALSE, prop.chisq = FALSE)
# Conclusions: dividende, cadrage, biais: on a toujours plusieurs façons différentes d'expliquer les données, on a éliminé des explications mais on ne peut pas en singulariser une seule. Mtn on se demande presque pourquoi il n'y a pas plus de gens qui se disent Perdants.
# Quoi d'autre que les 3 motifs influent sur approbation ? Confiance est une raison omniprésente
# 3 rôle du contexte, des acteurs et de la formule: 
# 3.a Évolution de l'opinion, singularité de l'épisode des GJ mais on ne peut pas excluse que cadrage joue. 
decrit(b$taxe_approbation, miss = T) # 71/10 Non/Oui 
decrit(e1$taxe_approbation, miss = T) # 47/23
decrit(e2$taxe_approbation, which=e2$dividende==110 & e2$origine_taxe=="gouvernement", miss = T) # 42/29
# 3.b Effet du dividende et des modalités
#     Effet du dividende (recherche a montré effet de montant taxe, ici on montre le dual)
decrit(e2$taxe_approbation, which=e2$dividende==0 & e2$origine_taxe=="gouvernement", miss = T) # 44/31
decrit(e2$taxe_approbation, which=e2$dividende==170 & e2$origine_taxe=="gouvernement", miss = T) # 35/36
# decrit(e2$taxe_approbation, which=e2$dividende==110, miss = T) # 45/25
# decrit(e2$taxe_approbation, which=e2$dividende==0, miss = T) # 51/26 TODO: image des 5
# decrit(e2$taxe_approbation, which=e2$dividende==170, miss = T) # 34/33
#    Effet des modalités: change pas grand chose
decrit(e2$taxe_alternative_approbation[e2$variante_alternative=="détaxe"], miss = T) # 46/25 Non/Oui
decrit(e2$taxe_alternative_approbation[e2$variante_alternative=="urba"], miss = T) # 46/28
# 3.d Effet origine, label: faibles
summary(reg_app_contexte_v1 <- lm(taxe_approbation!='Non' ~ question_confiance * label_taxe * origine_taxe, data=e1, weights = e1$weight)) # pas d'effect
summary(reg_app_contexte_v2 <- lm(taxe_approbation!='Non' ~ origine_taxe * ((dividende==0) + (dividende==170)), data=e2, weights = e2$weight)) # l'effet du gouv/EELV ne passe que pour dividende=0, donc pas lié à confiance_dividende
summary(reg_div_contexte_v1 <- lm(confiance_dividende=='Non' ~ label_taxe * origine_taxe, data=e1, weights = e1$weight)) # no effect
Table_contexte <- stargazer(reg_app_contexte_v1, reg_app_contexte_v2, reg_div_contexte_v1, 
                              title="Acceptation de la T\\&D et confiance dans le dividende en fonction du contexte", model.names = F, model.numbers = FALSE, header = FALSE, single.row = T, omit.table.layout = 'n', 
                               dep.var.labels = c("Acceptation de la T\\&D", "Défiance envers le dividende"), dep.var.caption = "", omit = c("E:", "C:", "t:"),
                               covariate.labels = c("Constante", "Confiance dividende: demandée", "Label: CCE", "Origine: inconnue", "Origine: CCC", "Origine: EELV", "Dividende: aucun", "Dividende: 170 €/an", "EELV $\\times$ Div: aucun", "EELV $\\times$ Div: 170"),
                               add.lines = list(c("Vague ", "1", "2", "1")),
                               no.space=TRUE, intercept.bottom=FALSE, intercept.top=TRUE, omit.stat=c("adj.rsq", "f", "ser", "ll", "aic"), label="tab:contexte")
write_clip(gsub('\\end{table}', "} {\\footnotesize \\parbox[t]{15cm}{\\linespread{1.2}\\selectfont \\textsc{Note:} Erreurs type entre parenthèses. Modalités omises: \\textit{Label: taxe}; \\textit{Origine: gouvernement}; \\textit{Dividende: 110}. $^{***}$p$<$0.01.  }} \\end{table}", 
                gsub('\\begin{tabular}{@', '\\makebox[\\textwidth][c]{ \\begin{tabular}{@', Table_contexte, fixed=TRUE), fixed=TRUE), collapse=' ') # gsub("\\textit{Note:}", "", Table_correct) # Erreurs type entre parenthèses. 

# 3.d Effet de confiance_gouvernement
#     méfiance gouv est capturée par méfiance dividende pour expliquer Perdant. confiance_gouv augmente proba NA (v1) mais pas corrélé avec gagnant_categorie (v2)
decrit("confiance_gouvernement", data=e1, miss=T) # 26/38/18/14 jamais/parfois/moitié/plupart temps
summary(reg_perd_gouv_v1 <- lm(gagnant_categorie=='Perdant' ~ (confiance_gouvernement < 0), data = e1, weights = e1$weight)) # gouv: 0.16**
# summary(lm(gagnant_categorie=='Perdant' ~ (confiance_gouvernement < 0), data = e2, weights = e2$weight)) # gouv: 0.03 Pas corrélé suggère encore une fois que ceux qui doutent du gouv/dividende répondent NSP
summary(reg_perd_conf <- lm(gagnant_categorie=='Perdant' ~ (confiance_gouvernement < 0) * as.factor(confiance_dividende), data = e1, weights = e1$weight)) # confiance_gouv pas significatif / dividende -0.27*** et -0.45***
summary(reg_acc_gouv_v2 <- lm(tax_acceptance ~ (confiance_gouvernement < 0), data = e1, weights = e1$weight)) # -.14***
summary(reg_acc_conf <- lm(tax_acceptance ~ (confiance_gouvernement < 0) * as.factor(confiance_dividende), data = e1, weights = e1$weight)) # confiance_gouv pas significatif / dividende 0.38*** et 0.46***
summary(reg_acc_gouv_v2 <- lm(tax_acceptance ~ (confiance_gouvernement < 0), data = e2, weights = e2$weight)) # -.09***
Table_gouv <- stargazer(reg_perd_gouv_v1, reg_perd_conf, reg_acc_gouv_v2, reg_acc_conf, reg_acc_gouv_v2,
                              title="Soutien et croyances sur la taxe avec dividende en fonction de la confiance dans l'État", model.names = F, model.numbers = FALSE, header = FALSE, single.row = F, omit.table.layout = 'n', 
                               dep.var.labels = c("Perdant subjectif", "Acceptation de la T\\&D"), dep.var.caption = "", #omit = c("E:", "C:", "t:"),
                               covariate.labels = c("Constante", "Pas confiance gouvernement", "Confiance dividende: À moitié", "Confiance dividende: Oui", "Pas confiance gouv. $\\times$ div: À moitié", "Pas confiance gouv. $\\times$ div: Oui"),
                               add.lines = list(c("Vague ", "1", "1", "1", "1", "2")),
                               no.space=TRUE, intercept.bottom=FALSE, intercept.top=TRUE, omit.stat=c("adj.rsq", "f", "ser", "ll", "aic"), label="tab:gouv")
write_clip(gsub('\\end{table}', "} {\\footnotesize \\parbox[t]{8cm}{\\linespread{1.2}\\selectfont \\textsc{Note:} (SE) Modalité omise: \\textit{Confiance dividende: Non}. $^{***}$p$<$0.01.  }} \\end{table}", 
                gsub('\\begin{tabular}{@', '\\makebox[\\textwidth][c]{ \\begin{tabular}{@', Table_gouv, fixed=TRUE), fixed=TRUE), collapse=' ') # gsub("\\textit{Note:}", "", Table_correct) # Erreurs type entre parenthèses. 

# 3.e Effet bandwagon 
summary(lm(pour_taxe_carbone!='Non' ~ variante_taxe_carbone, data=eb, weights = eb$weight)) # +10**
summary(lm(pour_taxe_carbone=='Oui' ~ variante_taxe_carbone, data=eb, weights = eb$weight)) # +8***
