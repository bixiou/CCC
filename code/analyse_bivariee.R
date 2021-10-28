library(foreign)
install.packages("psych")
library(psych)
#data_all <- read.dta("C:/Users/thoma/Documents/Github/CCC/donnees/1e.dta")
data_all <- read.dta("C:/Users/thoma/Documents/Github/CCC/donnees/all_benedicte.dta")


##### Approval to funding measures #####
temp <- data_CCC_funding <- matrix(c(59, 36, 0, 2, 8,
                             41, 32, 7, 16, 9,
                             54, 26, 9, 8, 8,
                             49, 24, 6, 13, 13,
                             62, 28, 4, 7, 4,
                             55, 27, 10, 7, 6,
                             62, 34, 2, 4, 3,
                             55, 38, 4, 5, 3,
                             54, 35, 6, 4, 6,
                             67, 25, 1, 3, 9)/105, nrow = 5)
for (j in 1:ncol(data_CCC_funding)) data_CCC_funding[,ncol(data_CCC_funding)+1-j] <- temp[,j]/sum(temp[1:4,j])
labels_CCC_funding <- rev(c("Targeting regulated savings<br>to low carbon projects",
                            "State borrowing",
                            "Higher income tax above 250k€",
                            "Wealth tax",
                            "Higher tax on dividends",
                            "Stronger bonus/malus on new cars",
                            "Tax on advertising", 
                            "Tax on noxious food",
                            "Carbon-border adjustment",
                            "Funding global climate policies"))
(CCC_funding <- barres(data = data_CCC_funding, miss=T, nsp = T, rev_color = F, weights = F, fr = T, sort = F, rev = F, labels=labels_CCC_funding, legend = rev(c("PNR", "Totally disagree", "Somewhat disagree", "Somewhat agree", "Totally agree")))) # c("Tout à fait d'accord", "Plutôt d'accord", "Plutôt en désaccord", "Pas du tout d'accord", "NSP")
save_plotly_new_filename(CCC_funding, width= 750, height=430)



##### Sexe #####
# Analyse univariée
prop.table(table(data_all$sexe)) # 53% de femmes

# Interaction avec age
prop.table(table(data_all$sexe, data_all$age), 2) # les hommes sont sur-représentés chez les 25-34 ans, les femmes chez les 65 ans et plus

# Interaction avec diplome
prop.table(table(data_all$sexe, data_all$diplome), 2) # les proportions sont relativement équilibrées, à comparer avec données Insee

### Interaction avec politiques environnementales
# Interaction avec taxe carbone
prop.table(table(data_all$s1_e_q41_clean, data_all$sexe), 2)

# Interaction avec taxe aviation financant ferré
prop.table(table(data_all$s1_e_q37, data_all$sexe), 2)

# Interaction avec limitation 110 km/h
prop.table(table(data_all$s1_e_q36, data_all$sexe), 2)

# Interaction avec obligation rénovation thermique
prop.table(table(data_all$s1_e_q38, data_all$sexe), 2)

# Interaction avec installation compteurs intelligents
prop.table(table(data_all$s1_e_q39, data_all$sexe), 2)

# Interaction avec augmenter prix produits acheminés par transports polluants
prop.table(table(data_all$s1_e_q40_clean, data_all$sexe), 2)

# Interaction avec développer énergies renouvelables même si plus cher
prop.table(table(data_all$s1_e_q42, data_all$sexe), 2) # politique plébiscitée, mêmes résultats pour les 2 sexes

# Interaction avec densifier villes
prop.table(table(data_all$s1_e_q43, data_all$sexe), 2)

# Interaction avec taxer véhicules plus émetteurs de GES
prop.table(table(data_all$s1_e_q44, data_all$sexe), 2) # Les hommes sont moins favorables à la taxation des véhicules plus émetteurs

# Interaction avec menus végé/bios/de saison
prop.table(table(data_all$s1_e_q46, data_all$sexe), 2) # Les femmes sont plus favorables à la promotion de ces menus écolos

# Interaction avec la France doit-elle prendre de l'avance
prop.table(table(data_all$s1_e_q48, data_all$sexe), 2) # Davantage d'hommes pensent que la France doit prendre de l'avance




##### Confiance envers les autres #####
# Analyse univariée
prop.table(table(data_all$s1_e_q4)) # 72 on n'est jamais assez prudent, 67 on peut faire confiance
dotchart(as.matrix(table(data_all$s1_e_q4))[, 1], main = "Q4. D’une manière générale, diriez-vous que… ? :", 
         pch = 19)

# Interaction avec les principaux obstacles à la lutte contre le CC
prop.table(table(data_all$s1_e_q4, (data_all$s1_e_q49_lobbies)==1), 1) # les citoyens qui ont plus de confiance envers les autres sont moins nombreux à identifier les lobbies comme principal obstacle
prop.table(table(data_all$s1_e_q4, (data_all$s1_e_q49_volonte)<3), 1) # Pas de différence très significative sur ce point




##### Confiance capacité citoyens tirés au sort #####
# Analyse univariée
prop.table(table(data_all$s1_e_q7)) # 2 pas du tout conf, 17 plutôt pas, 111 plutôt conf, 19 tout à fait conf
dotchart(as.matrix(table(data_all$s1_e_q7))[, 1], main = "Q7. Confiance capacité convention citoyenne :", 
         pch = 19)

# Interaction avec confiance envers les autres
prop.table(table(data_all$s1_e_q7, data_all$s1_e_q4), 2) # plus de confiance envers les autres -> plus de confiance envers capacité citoyens

# Interaction avec les principaux obstacles à la lutte contre le CC
prop.table(table(data_all$s1_e_q7, (data_all$s1_e_q49_lobbies)==1), 1) # les citoyens qui ont plus de confiance envers la capacité de citoyens tirés au sort sont moins nombreux à identifier les lobbies comme principal obstacle
prop.table(table(data_all$s1_e_q7, (data_all$s1_e_q49_volonte)<3), 1) # les citoyens qui ont plus de confiance envers la capacité de citoyens tirés au sort sont plus nombreux à identifier le manque de volonté politique comme un des deux principaux obstacles

# Interaction avec se sent mieux informé vie politique
prop.table(table(data_all$s2_e_q11 < 5))
prop.table(table(data_all$s1_e_q7, (data_all$s2_e_q11)>6), 2) # les citoyens qui se sentent le mieux informés par rapport aux autres ont aussi plus confiance dans les capacités des citoyens tirés au sort



##### Confiance différentes sources d’information #####
# Analyse univariée
prop.table(table(data_all$s1_s_q17a_clean)) # anecdotes perso : 7-27-50-10 de pas du tout à totalement
prop.table(table(data_all$s1_s_q17b_clean)) # journaux et émissions TV : 10-32-44-2
prop.table(table(data_all$s1_s_q17c_clean)) # réseaux sociaux : 18-44-26-2
prop.table(table(data_all$s1_s_q17d_clean)) # sources gouvernementales : 6-22-55-5
prop.table(table(data_all$s1_s_q17e_clean)) # document dossier participant CCC : 0-3-72-21
prop.table(table(data_all$s1_s_q17f_clean)) # rapports d'experts : 0-2-47-47
dotchart(as.matrix(table(data_all$s1_s_q17b_clean))[, 1], main = "Confiance journaux/émissions TV comme source d'info :", 
         pch = 19)
dotchart(as.matrix(table(data_all$s1_s_q17d_clean))[, 1], main = "Confiance gouvernement comme source d'info :", 
         pch = 19)
dotchart(as.matrix(table(data_all$s1_s_q17e_clean))[, 1], main = "Confiance dossier CCC comme source d'info :", 
         pch = 19)
dotchart(as.matrix(table(data_all$s1_s_q17f_clean))[, 1], main = "Confiance experts comme source d'info :", 
         pch = 19)

# Interaction avec confiance envers les autres
prop.table(table(data_all$s1_s_q17a_clean, data_all$s1_e_q4), 2) # plus de confiance envers les autres -> plus de confiance envers anecdotes
prop.table(table(data_all$s1_s_q17b_clean, data_all$s1_e_q4), 2)
prop.table(table(data_all$s1_s_q17c_clean, data_all$s1_e_q4), 2) # moins de confiance envers les autres -> défiance plus forte envers réseaux sociaux
prop.table(table(data_all$s1_s_q17d_clean, data_all$s1_e_q4), 2) # plus de confiance envers les autres -> plus de confiance envers gouvernement
prop.table(table(data_all$s1_s_q17e_clean, data_all$s1_e_q4), 2)
prop.table(table(data_all$s1_s_q17f_clean, data_all$s1_e_q4), 2)

# Interaction avec les principaux obstacles à la lutte contre le CC
prop.table(table(data_all$s1_s_q17d_clean, (data_all$s1_e_q49_lobbies)==1), 1) # Rien de très clair qui se dégage, pas assez significatif
prop.table(table(data_all$s1_s_q17d_clean, (data_all$s1_e_q49_volonte)<3), 1) # Rien de très clair qui se dégage, pas assez significatif
prop.table(table(data_all$s1_s_q17c_clean, (data_all$s1_e_q49_lobbies)==1), 1) # Les citoyens les plus méfiants envers les réseaux sociaux sont plus nombreux à voir les lobbies comme le princpal obstacle
# De manière générale, pas de lien très clair entre Q49 S1E et Q17 S1S


# Interaction avec confiance envers les autres
prop.table(table(data_all$s1_e_q7, data_all$s1_e_q4), 2) # plus de confiance envers les autres -> plus de confiance envers capacité citoyens

# Interaction avec les principaux obstacles à la lutte contre le CC
prop.table(table(data_all$s1_e_q7, (data_all$s1_e_q49_lobbies)==1), 1) # les citoyens qui ont plus de confiance envers la capacité de citoyens tirés au sort sont moins nombreux à identifier les lobbies comme principal obstacle
prop.table(table(data_all$s1_e_q7, (data_all$s1_e_q49_volonte)<3), 1) # les citoyens qui ont plus de confiance envers la capacité de citoyens tirés au sort sont plus nombreux à identifier le manque de volonté politique comme un des deux principaux obstacles

# Interaction avec se sent mieux informé vie politique
prop.table(table(data_all$s2_e_q11 < 5))
prop.table(table(data_all$s1_e_q7, (data_all$s2_e_q11)>6), 2) # les citoyens qui se sentent le mieux informés par rapport aux autres ont aussi plus confiance dans les capacités des citoyens tirés au sort



##### Confiance différentes sources d’information #####
# Analyse univariée
prop.table(table(data_all$s1_s_q17a_clean)) # anecdotes perso : 7-27-50-10 de pas du tout à totalement
prop.table(table(data_all$s1_s_q17b_clean)) # journaux et émissions TV : 10-32-44-2
prop.table(table(data_all$s1_s_q17c_clean)) # réseaux sociaux : 18-44-26-2
prop.table(table(data_all$s1_s_q17d_clean)) # sources gouvernementales : 6-22-55-5
prop.table(table(data_all$s1_s_q17e_clean)) # document dossier participant CCC : 0-3-72-21
prop.table(table(data_all$s1_s_q17f_clean)) # rapports d'experts : 0-2-47-47
dotchart(as.matrix(table(data_all$s1_s_q17b_clean))[, 1], main = "Confiance journaux/émissions TV comme source d'info :", 
         pch = 19)
dotchart(as.matrix(table(data_all$s1_s_q17d_clean))[, 1], main = "Confiance gouvernement comme source d'info :", 
         pch = 19)
dotchart(as.matrix(table(data_all$s1_s_q17e_clean))[, 1], main = "Confiance dossier CCC comme source d'info :", 
         pch = 19)
dotchart(as.matrix(table(data_all$s1_s_q17f_clean))[, 1], main = "Confiance experts comme source d'info :", 
         pch = 19)

# Interaction avec confiance envers les autres
prop.table(table(data_all$s1_s_q17a_clean, data_all$s1_e_q4), 2) # plus de confiance envers les autres -> plus de confiance envers anecdotes
prop.table(table(data_all$s1_s_q17b_clean, data_all$s1_e_q4), 2)
prop.table(table(data_all$s1_s_q17c_clean, data_all$s1_e_q4), 2) # moins de confiance envers les autres -> défiance plus forte envers réseaux sociaux
prop.table(table(data_all$s1_s_q17d_clean, data_all$s1_e_q4), 2) # plus de confiance envers les autres -> plus de confiance envers gouvernement
prop.table(table(data_all$s1_s_q17e_clean, data_all$s1_e_q4), 2)
prop.table(table(data_all$s1_s_q17f_clean, data_all$s1_e_q4), 2)

# Interaction avec les principaux obstacles à la lutte contre le CC
prop.table(table(data_all$s1_s_q17d_clean, (data_all$s1_e_q49_lobbies)==1), 1) # Rien de très clair qui se dégage, pas assez significatif
prop.table(table(data_all$s1_s_q17d_clean, (data_all$s1_e_q49_volonte)<3), 1) # Rien de très clair qui se dégage, pas assez significatif
prop.table(table(data_all$s1_s_q17c_clean, (data_all$s1_e_q49_lobbies)==1), 1) # Les citoyens les plus méfiants envers les réseaux sociaux sont plus nombreux à voir les lobbies comme le princpal obstacle
# De manière générale, pas de lien très clair entre Q49 S1E et Q17 S1S



##### Limitation 110km/h #####
# Analyse univariée
prop.table(table(data_all$s1_e_q36)) # 17 pas du tout souhaitable, 53 pas vraiment, 48 assez souhaitable, 25 très souhaitable
dotchart(as.matrix(table(data_all$s1_e_q36))[, 1], main = "Q36. Limitation à 110km/h :", 
         pch = 19)

# Interaction avec ruraux/urbains
prop.table(table(data_all$s1_e_q1_clean, data_all$s1_e_q36), 1)

# Interaction avec perception de l'effort demandé par les CP par rapport aux autres
prop.table(table(data_all$s2_e_q41, data_all$s1_e_q36), 1) # On ne discerne rien de précis, trop de catégories



##### Taxe transport aérien pour financer train #####
# Analyse univariée
prop.table(table(data_all$s1_e_q37)) # Environ 20% sont défavorables
dotchart(as.matrix(table(data_all$s1_e_q37))[, 1], main = "Q37. Taxer transport aérien pour financer ferré :", 
         pch = 19)



##### Obligation rénovation thermique pour les propriétaires #####
# Analyse univariée
prop.table(table(data_all$s1_e_q38)) # Environ 20% sont défavorables
dotchart(as.matrix(table(data_all$s1_e_q38))[, 1], main = "Q38. Obliger les propriétaires à rénover/isoler logement avant vente ou location :", 
         pch = 19)




##### Taxe carbone #####
### Augmenter la taxe carbone (question générale, usage du revenu non spécifié)
# Analyse univariée
prop.table(table(data_all$s1_e_q41_clean)) # Une majorité des citoyen est favorable
dotchart(as.matrix(table(data_all$s1_e_q41_clean))[, 1], main = "Q41. Augmenter la taxe carbone :", 
         pch = 19)

### Interaction socio-démos :
# Interaction avec ruraux/urbains
prop.table(table(data_all$s1_e_q1_clean, data_all$s1_e_q41_clean), 1)

# Interaction avec nombre de voitures
prop.table(table(data_all$s1_s_q22, data_all$s1_e_q41_clean), 1)

# Interaction avec distance domicile-travail
prop.table(table(data_all$s1_s_q23, data_all$s1_e_q41_clean), 1) # Attention, question mal posée

# Interaction avec âge
prop.table(table(data_all$age, data_all$s1_e_q41_clean), 1) # Les plus jeunes sont les plus réfractaires

# Interaction avec sexe
prop.table(table(data_all$sexe, data_all$s1_e_q41_clean), 1) # Les hommes sont nettement plus réfractaires que les femmes

# Interaction avec diplôme
prop.table(table(data_all$diplome, data_all$s1_e_q41_clean), 1)

# Interaction avec CSP
prop.table(table(data_all$pcs, data_all$s1_e_q41_clean), 1)

### Interaction autres politiques :
# Interaction avec 110km/h
prop.table(table(data_all$s1_e_q36, data_all$s1_e_q41_clean), 1)

# Interaction avec taxe aviation
prop.table(table(data_all$s1_e_q37, data_all$s1_e_q41_clean), 1)

# Interaction avec infrastructures pour favoriser les véhicules propres
prop.table(table(data_all$s1_e_q45_clean, data_all$s1_e_q41_clean), 1)

# Interaction avec menu écolos
prop.table(table(data_all$s1_e_q46, data_all$s1_e_q41_clean), 1)


### Interaction avec valeurs / perceptions
# Interaction avec perception de l'effort demandé par les CP par rapport aux autres
prop.table(table(data_all$s2_e_q41, data_all$s1_e_q41_clean), 1) # On ne discerne rien de précis, trop de catégories

# Interaction avec confiance envers les autres
prop.table(table(data_all$s1_e_q4, data_all$s1_e_q41_clean), 1)

# Interaction avec confiance capacité citoyens tirés au sort
prop.table(table(data_all$s1_e_q7, data_all$s1_e_q41_clean), 1)

# Interaction avec confiance médias
prop.table(table(data_all$s1_s_q17b_clean, data_all$s1_e_q41_clean), 1)
# Interaction avec confiance gouvernement
prop.table(table(data_all$s1_s_q17d_clean, data_all$s1_e_q41_clean), 1)
# Interaction avec confiance experts
prop.table(table(data_all$s1_s_q17f_clean, data_all$s1_e_q41_clean), 1)

# Interaction avec déterminants pauvreté
prop.table(table(data_all$s1_e_q12_clean, data_all$s1_e_q41_clean), 1) #

# Interaction avec mieux informé vie politique
prop.table(table((data_all$s2_e_q11 > 7), data_all$s1_e_q41_clean), 1) # Les mieux informés sont plus favorables
prop.table(table((data_all$s2_e_q11 < 4), data_all$s1_e_q41_clean), 1) # Les moins bien informés sont moins favorables

# Interaction avec importance amélioration niveau de vie
prop.table(table(data_all$s1_e_q15, data_all$s1_e_q41_clean), 1) # rien de clair qui se dégage
prop.table(table((data_all$s1_e_q15 > 6), data_all$s1_e_q41_clean), 1)
prop.table(table((data_all$s1_e_q15 < 5), data_all$s1_e_q41_clean), 1)

# Interaction avec anticipation situation éco perso future
prop.table(table(data_all$s2_e_q12, data_all$s1_e_q41_clean), 1)
prop.table(table((data_all$s2_e_q12 > 5), data_all$s1_e_q41_clean), 1)
prop.table(table((data_all$s2_e_q12 < 4), data_all$s1_e_q41_clean), 1)

# Interaction avec satisfaction dans la vie
prop.table(table(data_all$s1_e_q8, data_all$s1_e_q41_clean), 1)
prop.table(table((data_all$s1_e_q8 > 7), data_all$s1_e_q41_clean), 1)
prop.table(table((data_all$s1_e_q8 < 6), data_all$s1_e_q41_clean), 1)

# Interaction avec origine CC
prop.table(table(data_all$s1_e_q20, data_all$s1_e_q41_clean), 1)

# Interaction avec salaire moyen de la profession
prop.table(table((data_all$s2_e_q14_clean > 1800), data_all$s1_e_q41_clean), 1)

# Interaction avec salaire moyen de la profession
prop.table(table(data_all$s1_e_q10_tranche, data_all$s1_e_q41_clean), 1)

# Interaction avec difficultés ignorées des dirigeants/médias
prop.table(table(data_all$s1_e_q11_clean, data_all$s1_e_q41_clean), 1)




##### Taxe carbone sondage 2019 #####
### Analyse univariée
decrit(s$si_pauvres, weights = s$weight) # 45% - 17% - 38% (Oui, NSP, Non)
decrit(s$si_compensee, weights = s$weight) # 37% - 17% - 46%
decrit(s$si_contraints, weights = s$weight) # 55% - 22% - 23%
decrit(s$si_baisse_cotsoc, weights = s$weight) # 51% - 23% - 26%
decrit(s$si_baisse_tva, weights = s$weight) # 61% - 18% - 21%
decrit(s$si_baisse_deficit, weights = s$weight) # 44% - 29% - 27%
decrit(s$si_renovation, weights = s$weight) # 55% - 24% - 20%
decrit(s$si_renouvelables, weights = s$weight) # 59% - 22% - 20%
decrit(s$si_transports, weights = s$weight) # 65% - 18% - 17%

### Socio démo taxe compensée tous les Français
# Sexe
prop.table(table(s$sexe, s$si_compensee), 1) # approbation légèrement supérieure chez les femmes : 37,9% vs. 35,5%
prop.table(table(data_all$sexe, (data_all$s2_e_q32 > 5)), 1) # approbation très supérieure chez les femmes : 34,0% vs 23,3%

# Age
prop.table(table(s$age, s$si_compensee), 1) # Approbation décroit avec l'âge
prop.table(table(data_all$age, (data_all$s2_e_q32 > 5)), 1) # Approbation non-monotone en fonction de l'âge

# Rural-urbain
prop.table(table(s$taille_agglo, s$si_compensee), 1) # pas de différence géographique notable
prop.table(table(data_all$s1_e_q1_clean, (data_all$s2_e_q32 > 5)), 1) # Approbation nettement plus faible en campagne

# Nombre véhicules
prop.table(table(s$nb_vehicules, s$si_compensee), 1) # Rien de clairement discernable
prop.table(table(data_all$s1_s_q22, (data_all$s2_e_q32 > 5)), 1) # Rien de clairement discernable



##### Taxe carbone selon mode de redistribution #####
prop.table(table((data_all$s2_e_q31 > 5))) # Majorité favorabe (57%) si les 50% les plus modestes sont compensés
prop.table(table((data_all$s2_e_q32 > 5))) # Majorité défavorable (28% pour) si finance versement à tous les Français
prop.table(table((data_all$s2_e_q33 > 5))) # Majorité favorabe (65%) si finance versement pour ménages contraints
prop.table(table((data_all$s2_e_q34 > 5))) # Majorité défavorable (38% pour) si finance baisse cotisations sociales
prop.table(table((data_all$s2_e_q35 > 5))) # Majorité défavorabe (45% pour) si finance baisse TVA
prop.table(table((data_all$s2_e_q36 > 5))) # Majorité défavorabe (45% pour) si finance baisse déficit public
prop.table(table((data_all$s2_e_q37 > 5))) # Majorité favorabe (86%) si finance la rénovation thermique des bâtiments
prop.table(table((data_all$s2_e_q38 > 5))) # Majorité favorabe (85%) si finance des énergies renouvelables
prop.table(table((data_all$s2_e_q39 > 5))) # Majorité favorabe (90%) si finance des transports non-polluants

### Interaction avec approbation taxe carbone 1ere session
prop.table(table(data_all$s1_e_q41_clean, (data_all$s2_e_q31 > 5)), 1)
prop.table(table(data_all$s1_e_q41_clean, (data_all$s2_e_q32 > 5)), 1)
prop.table(table(data_all$s1_e_q41_clean, (data_all$s2_e_q33 > 5)), 1)
prop.table(table(data_all$s1_e_q41_clean, (data_all$s2_e_q34 > 5)), 1)
prop.table(table(data_all$s1_e_q41_clean, (data_all$s2_e_q35 > 5)), 1)
prop.table(table(data_all$s1_e_q41_clean, (data_all$s2_e_q36 > 5)), 1)

### Interaction avec confiance
# Taxe compensée 50% des plus modestes
prop.table(table(data_all$s1_s_q17a_clean, (data_all$s2_e_q31 > 5)), 1) #
prop.table(table(data_all$s1_s_q17b_clean, (data_all$s2_e_q31 > 5)), 1) #
prop.table(table(data_all$s1_s_q17d_clean, (data_all$s2_e_q31 > 5)), 1) #
prop.table(table(data_all$s1_s_q17e_clean, (data_all$s2_e_q31 > 5)), 1) #
prop.table(table(data_all$s1_e_q4, (data_all$s2_e_q31 > 5)), 1) #
prop.table(table(data_all$s1_e_q7, (data_all$s2_e_q31 > 5)), 1) #

# Taxe compensée tous les Français
prop.table(table(data_all$s1_s_q17a_clean, (data_all$s2_e_q32 > 5)), 1) # Aucun effet
prop.table(table(data_all$s1_s_q17b_clean, (data_all$s2_e_q32 > 5)), 1) # Effet très fort : plus de confiance envers les médias, plus d'approbation envers T&D
prop.table(table(data_all$s1_s_q17d_clean, (data_all$s2_e_q32 > 5)), 1) # Effet très fort : plus de confiance envers le gvt, plus d'approbation envers T&D
prop.table(table(data_all$s1_s_q17e_clean, (data_all$s2_e_q32 > 5)), 1) # Effet fort : plus de confiance envers le dossier CCC, plus d'approbation envers T&D
prop.table(table(data_all$s1_e_q4, (data_all$s2_e_q32 > 5)), 1) # Plus de confiance envers les autres, moins d'approbation de T&D
prop.table(table(data_all$s1_e_q7, (data_all$s2_e_q32 > 5)), 1) # Plus de confiance envers capacité des citoyens, moins d'approbation de T&D

# Taxe compensée pour les plus contraints
prop.table(table(data_all$s1_s_q17a_clean, (data_all$s2_e_q33 > 5)), 1) #
prop.table(table(data_all$s1_s_q17b_clean, (data_all$s2_e_q33 > 5)), 1) #
prop.table(table(data_all$s1_s_q17d_clean, (data_all$s2_e_q33 > 5)), 1) #
prop.table(table(data_all$s1_s_q17e_clean, (data_all$s2_e_q33 > 5)), 1) #
prop.table(table(data_all$s1_e_q4, (data_all$s2_e_q33 > 5)), 1) #
prop.table(table(data_all$s1_e_q7, (data_all$s2_e_q33 > 5)), 1) #

# Taxe finance baisse cot soc (double dividende)
prop.table(table(data_all$s1_s_q17b_clean, (data_all$s2_e_q34 > 5)), 1) # 
prop.table(table(data_all$s1_s_q17d_clean, (data_all$s2_e_q34 > 5)), 1) # 
prop.table(table(data_all$s1_s_q17e_clean, (data_all$s2_e_q34 > 5)), 1) #
prop.table(table(data_all$s1_e_q4, (data_all$s2_e_q34 > 5)), 1) #
prop.table(table(data_all$s1_e_q7, (data_all$s2_e_q34 > 5)), 1) #

# Taxe finance baisse TVA
prop.table(table(data_all$s1_s_q17b_clean, (data_all$s2_e_q35 > 5)), 1) # 
prop.table(table(data_all$s1_s_q17d_clean, (data_all$s2_e_q35 > 5)), 1) # 
prop.table(table(data_all$s1_s_q17e_clean, (data_all$s2_e_q35 > 5)), 1) #
prop.table(table(data_all$s1_e_q4, (data_all$s2_e_q35 > 5)), 1) #
prop.table(table(data_all$s1_e_q7, (data_all$s2_e_q35 > 5)), 1) #

# Taxe finance baisse déficit public
prop.table(table(data_all$s1_s_q17b_clean, (data_all$s2_e_q36 > 5)), 1) # 
prop.table(table(data_all$s1_s_q17d_clean, (data_all$s2_e_q36 > 5)), 1) # 
prop.table(table(data_all$s1_s_q17e_clean, (data_all$s2_e_q36 > 5)), 1) #
prop.table(table(data_all$s1_e_q4, (data_all$s2_e_q36 > 5)), 1) #
prop.table(table(data_all$s1_e_q7, (data_all$s2_e_q36 > 5)), 1) #


##### Sources financement CCC #####
table(data_all$s7_q29_9) # 3 sont favorables à la taxe carbone comme source de financement, vs. 60 qui n'y sont pas.
table(data_all$s7_q29_1)



##### Gagnants et perdants taxe carbone #####
prop.table(table(data_all$s2_e_q40_flag)) # Réponses souvent incohérentes, à traiter avec prudence. La matrice est effectivement peu claire
prop.table(table(data_all$s2_e_q40_1))
prop.table(table(data_all$s2_e_q40_2)) # 62% pensent que les pauvres sont gagnants
prop.table(table(data_all$s2_e_q40_3)) # 58% pensent que les classes moyennes sont perdantes
prop.table(table(data_all$s2_e_q40_4)) # 50% pensent que les riches sont gagnants/perdants
prop.table(table(data_all$s2_e_q40_5)) # 71% pensent que tous les Français sont gagnants ???!!!!
prop.table(table(data_all$s2_e_q40_6)) # 50% pensent que les ruraux et péri-urbains sont gagnants/perdants
prop.table(table(data_all$s2_e_q40_7))
prop.table(table(data_all$s2_e_q40_8))



##### Perception de l'effort demandé par les politiques climatiques par rapport à la moyenne #####
prop.table(table(data_all$s2_e_q41)) # 50% pensent que cela leur demandera davantage, 37% que ça leur demandera autant
dotchart(as.matrix(table(data_all$s2_e_q41))[, 1], main = "Les pol. clim. vous demanderont plus d'efforts qu'à la moyenne :", 
         pch = 19)

# Interaction avec ruraux/urbains
prop.table(table(data_all$s1_e_q1_clean, data_all$s2_e_q41), 1) # les habitants des petites villes se sentent les plus concernés par ces efforts

# Interaction avec age
prop.table(table(data_all$age, data_all$s2_e_q41), 1) # les 35-49 se sentent les plus concernés par ces efforts

# Interaction avec difficultés ignorées par pouvoirs publics et médias
prop.table(table(data_all$s1_e_q11, data_all$s2_e_q41), 1) # Rien de précis n'en ressort

# Interaction avec perception évolution propre situation éco et sociale
prop.table(table(data_all$s2_e_q41, (data_all$s2_e_q12 < 5)), 2) # Rien de précis n'en ressort

# Interaction avec plus impacté par le CC que reste de ma génération
prop.table(table(data_all$s2_e_q41, data_all$s2_e_q42), 2) # Rien de précis n'en ressort, trop de catégories
mosaicplot(s2_e_q41 ~ s2_e_q42, data = data_all, shade = TRUE, main = "Plus exposé au CC et aux CP")




##### Plus impacté que le reste de ma génération par le CC #####
prop.table(table(data_all$s2_e_q42)) # la plupart des gens pensent être autant impactés, un certain nombre plus impactés, très peu moins impactés.
dotchart(as.matrix(table(data_all$s2_e_q42))[, 1], main = "Les pol. clim. vous demanderont plus d'efforts qu'à la moyenne :", 
         pch = 19)

# Interaction avec difficultés financières
prop.table(table(data_all$s2_e_q42, data_all$s1_e_q3), 2) # Trop de catégories pour que quoique ce soit émerge de significatif



##### Echelle prise en charge CC #####
prop.table(table(data_all$s1_e_q35))
dotchart(as.matrix(table(data_all$s1_e_q35))[, 1], main = "Echelles politiques climatiques", 
         pch = 19)

# Interaction avec obstacles
prop.table(table(data_all$s1_e_q35, (data_all$s1_e_q49_lobbies)==1), 2) # Rien de très clair qui se dégage
prop.table(table(data_all$s1_e_q35, (data_all$s1_e_q49_volonte)<3), 2) # Rien de très clair qui se dégage




#### Avance de la France dans la lutte face au CC #####
prop.table(table(data_all$s1_e_q48)) # Une écrasante majorité pense qu'il faut que la France prenne de l'avance (89% oui, 2% non, 8% NSP)
dotchart(as.matrix(table(data_all$s1_e_q48))[, 1], main = "La France doit-elle prendre de l'avance dans la lutte face au CC  ?", 
         pch = 19)




##### Corrélation politiques environnementales #####
table(data_all$s1_e_q47)
data_all$limitation_110_num <- (
  - 2*(data_all$s1_e_q36 == "Pas du tout souhaitable")
  - 1*(data_all$s1_e_q36 == "Pas vraiment souhaitable")
  + 1*(data_all$s1_e_q36 == "Assez souhaitable")
  + 2*(data_all$s1_e_q36 == "Tres souhaitable")
  )
data_all$taxe_aerien_num <- (
  - 2*(data_all$s1_e_q37 == "Pas du tout souhaitable")
  - 1*(data_all$s1_e_q37 == "Pas vraiment souhaitable")
  + 1*(data_all$s1_e_q37 == "Assez souhaitable")
  + 2*(data_all$s1_e_q37 == "Tres souhaitable")
)
data_all$obligation_renovation_thermique_num <- (
  - 2*(data_all$s1_e_q38 == "Pas du tout souhaitable")
  - 1*(data_all$s1_e_q38 == "Pas vraiment souhaitable")
  + 1*(data_all$s1_e_q38 == "Assez souhaitable")
  + 2*(data_all$s1_e_q38 == "Tres souhaitable")
)
data_all$compteur_intelligent_num <- (
  - 2*(data_all$s1_e_q39 == "Pas du tout souhaitable")
  - 1*(data_all$s1_e_q39 == "Pas vraiment souhaitable")
  + 1*(data_all$s1_e_q39 == "Assez souhaitable")
  + 2*(data_all$s1_e_q39 == "Tres souhaitable")
)
data_all$prix_produits_transport_polluant_num <- (
  - 2*(data_all$s1_e_q40_clean == "Pas du tout souhaitable")
  - 1*(data_all$s1_e_q40_clean == "Pas vraiment souhaitable")
  + 1*(data_all$s1_e_q40_clean == "Assez souhaitable")
  + 2*(data_all$s1_e_q40_clean == "Tres souhaitable")
)
data_all$taxe_carbone_num <- (
  - 2*(data_all$s1_e_q41_clean == "Pas du tout souhaitable")
  - 1*(data_all$s1_e_q41_clean == "Pas vraiment souhaitable")
  + 1*(data_all$s1_e_q41_clean == "Assez souhaitable")
  + 2*(data_all$s1_e_q41_clean == "Tres souhaitable")
)
data_all$dev_energies_renouvelables_cheres_num <- (
  - 2*(data_all$s1_e_q42 == "Pas du tout souhaitable")
  - 1*(data_all$s1_e_q42 == "Pas vraiment souhaitable")
  + 1*(data_all$s1_e_q42 == "Assez souhaitable")
  + 2*(data_all$s1_e_q42 == "Tres souhaitable")
)
data_all$densifier_villes_num <- (
  - 2*(data_all$s1_e_q43 == "Pas du tout souhaitable")
  - 1*(data_all$s1_e_q43 == "Pas vraiment souhaitable")
  + 1*(data_all$s1_e_q43 == "Assez souhaitable")
  + 2*(data_all$s1_e_q43 == "Tres souhaitable")
)
data_all$taxe_vehicules_GES_num <- (
  - 2*(data_all$s1_e_q44 == "Pas du tout souhaitable")
  - 1*(data_all$s1_e_q44 == "Pas vraiment souhaitable")
  + 1*(data_all$s1_e_q44 == "Assez souhaitable")
  + 2*(data_all$s1_e_q44 == "Tres souhaitable")
)
data_all$infrastructures_vehicules_propres_num <- (
  - 2*(data_all$s1_e_q45_clean == "Pas du tout souhaitable")
  - 1*(data_all$s1_e_q45_clean == "Pas vraiment souhaitable")
  + 1*(data_all$s1_e_q45_clean == "Assez souhaitable")
  + 2*(data_all$s1_e_q45_clean == "Tres souhaitable")
)
data_all$menus_ecolos_num <- (
  - 2*(data_all$s1_e_q46 == "Pas du tout souhaitable")
  - 1*(data_all$s1_e_q46 == "Pas vraiment souhaitable")
  + 1*(data_all$s1_e_q46 == "Assez souhaitable")
  + 2*(data_all$s1_e_q46 == "Tres souhaitable")
)
data_all$gaspillage_alimentaire_num <- (
  - 2*(data_all$s1_e_q47 == "Pas du tout souhaitable")
  - 1*(data_all$s1_e_q47 == "Pas vraiment souhaitable")
  + 1*(data_all$s1_e_q47 == "Assez souhaitable")
  + 2*(data_all$s1_e_q47 == "Tres souhaitable")
)

data_cor <- data_all[,c("limitation_110_num", "taxe_aerien_num", "obligation_renovation_thermique_num",
                        "compteur_intelligent_num", "prix_produits_transport_polluant_num", "taxe_carbone_num",
                        "dev_energies_renouvelables_cheres_num", "densifier_villes_num", "taxe_vehicules_GES_num",
                        "infrastructures_vehicules_propres_num", "menus_ecolos_num", "gaspillage_alimentaire_num")]
#names(data_cor) <- c("Limitation 110km/h", "Taxe transport aérien", "Obligation rénovation thermique",
#                     "Compteurs intelligents", "Augmenter prix produits polluants", "Taxe carbone",
#                     "Développer énergies renouvelables", "Densifier villes", "Taxer véhicules GES",
#                     "Infrastructures véhicules propres", "Menus écolos", "Réduire gaspillage alimentaire")
names(data_cor) <- c("Limitation 110km/h", "Taxe avion", "Obligation rénovation",
                     "Compteurs intelligents", "Prix prod. polluants", "Taxe carbone",
                     "Dev. energ. ren.", "Densifier villes", "Taxer veh. GES",
                     "Infrastructures veh. propres", "Oblig. menus verts", "Réduire gaspillage")
corr <- cor(data_cor, use="complete.obs")
corrplot(corr, method='color', diag=FALSE, tl.col='black', insig = 'blank', addCoef.col = 'black', addCoefasPercent = T , type='upper') #, order='hclust'


### Correlation avec socio-démos :
data_all$femme <- 0 + 1*(data_all$sexe == "Femme")
data_all$age_num <- 2020 - data_all$annee_de_naissance
data_all$taille_ville <- (
  4 * (data_all$s1_e_q1_clean == "grande ville")
  + 3 * (data_all$s1_e_q1_clean == "banlieue")
  + 2 * (data_all$s1_e_q1_clean == "petite ville")
  + 1 * (data_all$s1_e_q1_clean == "campagne")
  )
data_all$diplome_num <- (
  4 * (data_all$diplome == "5. Actuellement etudiant")
  + 4 * (data_all$diplome == "4. Diplome superieur au bac")
  + 3 * (data_all$diplome == "3. Baccalaureat")
  + 2 * (data_all$diplome == "2. CAP ou BEP")
  + 1 * (data_all$diplome == "1. Sans diplome ou CEP ou BEPC")
  )

data_cor <- data_all[,c("femme", "age_num", "taille_ville", "diplome_num", "limitation_110_num", "taxe_aerien_num", "obligation_renovation_thermique_num",
                        "compteur_intelligent_num", "prix_produits_transport_polluant_num", "taxe_carbone_num",
                        "dev_energies_renouvelables_cheres_num", "densifier_villes_num", "taxe_vehicules_GES_num",
                        "infrastructures_vehicules_propres_num", "menus_ecolos_num", "gaspillage_alimentaire_num")]
names(data_cor) <- c("Femme", "Age", "Taille ville", "Diplome", "Limitation 110km/h", "Taxe avion", "Obligation rénovation",
                     "Compteurs intelligents", "Prix prod. polluants", "Taxe carbone",
                     "Dev. energ. ren.", "Densifier villes", "Taxer veh. GES",
                     "Infrastructures veh. propres", "Oblig. menus verts", "Réduire gaspillage")
corr <- cor(data_cor, use="complete.obs")
corrplot(as.matrix(corr[1:4,5:16]), method = "color", tl.srt=35, tl.col='black', insig = 'blank', addCoef.col = 'black', addCoefasPercent = T)


### Correlation avec valeurs :
data_all$confiance_interpersonnelle_num <- (
  + 1*(data_all$s1_e_q4 == "On peut faire confiance a la plupart des gens")
  - 1*(data_all$s1_e_q4 == "On n est jamais assez prudent quand on a affaire aux autres")
)
data_all$confiance_capacite_citoyens_num <- (
  + 2*(data_all$s1_e_q7 == "Tout a fait confiance")
  + 1*(data_all$s1_e_q7 == "Plutot confiance")
  - 1*(data_all$s1_e_q7 == "Plutot pas confiance")
  - 2*(data_all$s1_e_q7 == "Pas du tout confiance")
)
data_all$satisfaction_vie_num <- data_all$s1_e_q8
data_all$redistribution_num <- data_all$s1_e_q10 # 10 = plus de redistribution
data_all$lien_efforts_pauvrete_num <- (
  + 1*(data_all$s1_e_q12_clean == "pas de chance")
  + 0*(data_all$s1_e_q12_clean == "NR")
  - 1*(data_all$s1_e_q12_clean == "pas fait deffort")
)
data_all$confiance_gouvernement_num <- (
  + 2*(data_all$s1_s_q17d_clean == "Totalement")
  + 1*(data_all$s1_s_q17d_clean == "Plutot")
  - 1*(data_all$s1_s_q17d_clean == "Plutot pas")
  - 2*(data_all$s1_s_q17d_clean == "Pas du tout")
)
data_all$anticipation_situation_eco_num <- data_all$s2_e_q12

data_cor <- data_all[,c("confiance_interpersonnelle_num", "confiance_capacite_citoyens_num", "confiance_gouvernement_num",
                        "satisfaction_vie_num", "anticipation_situation_eco_num", "limitation_110_num", "taxe_aerien_num", "obligation_renovation_thermique_num",
                        "compteur_intelligent_num", "prix_produits_transport_polluant_num", "taxe_carbone_num",
                        "dev_energies_renouvelables_cheres_num", "densifier_villes_num", "taxe_vehicules_GES_num",
                        "infrastructures_vehicules_propres_num", "menus_ecolos_num", "gaspillage_alimentaire_num")]
names(data_cor) <- c("Conf. aux autres", "Conf. capacité citoyens", "Conf. gouvernement",
                     "Satisfaction vie", "Anticipation situ. éco.",  "Limitation 110km/h", "Taxe avion", "Obligation rénovation",
                     "Compteurs intelligents", "Prix prod. polluants", "Taxe carbone",
                     "Dev. energ. ren.", "Densifier villes", "Taxer veh. GES",
                     "Infrastructures veh. propres", "Oblig. menus verts", "Réduire gaspillage")
corr <- cor(data_cor, use="complete.obs")
corrplot(as.matrix(corr[1:5,6:17]), method = "color", tl.srt=35, tl.col='black', insig = 'blank', addCoef.col = 'black', addCoefasPercent = T)




##### Corrélation recyclage taxe carbone #####
data_cor <- data_all[,c("s2_e_q31", "s2_e_q32", "s2_e_q33", "s2_e_q34", "s2_e_q35", "s2_e_q36", "s2_e_q37", "s2_e_q38", "s2_e_q39")]
names(data_cor) <- c("Transfert modestes", "Transfert tous", "Transfert contraints", "Baisse cot. soc.",
                     "Baisse TVA", "Baisse déficit", "Rénovation therm.", "Energies renouv.", "Transports propres")
corr <- cor(data_cor, use="complete.obs")
corrplot(corr, method='color', diag=FALSE, tl.srt=35, tl.col='black', insig = 'blank', addCoef.col = 'black', addCoefasPercent = T , type='upper') #, order='hclust'




##### Corrélation gestes environnementaux #####
data_all$trier_dechets_num <- (
  + 2*(data_all$s1_e_q22 == "Le fait deja")
  + 1*(data_all$s1_e_q22 == "Pourrait le faire facilement")
  - 1*(data_all$s1_e_q22 == "Pourrait le faire mais difficilement")
  - 2*(data_all$s1_e_q22 == "Ne peut pas le faire")
)
data_all$eteindre_appareils_num <- (
  + 2*(data_all$s1_e_q23 == "Le fait deja")
  + 1*(data_all$s1_e_q23 == "Pourrait le faire facilement")
  - 1*(data_all$s1_e_q23 == "Pourrait le faire mais difficilement")
  - 2*(data_all$s1_e_q23 == "Ne peut pas le faire")
)
data_all$transports_communs_num <- (
  + 2*(data_all$s1_e_q24 == "Le fait deja")
  + 1*(data_all$s1_e_q24 == "Pourrait le faire facilement")
  - 1*(data_all$s1_e_q24 == "Pourrait le faire mais difficilement")
  - 2*(data_all$s1_e_q24 == "Ne peut pas le faire")
)
data_all$baisse_temperature_num <- (
  + 2*(data_all$s1_e_q25_clean == "Le fait deja")
  + 1*(data_all$s1_e_q25_clean == "Pourrait le faire facilement")
  - 1*(data_all$s1_e_q25_clean == "Pourrait le faire mais difficilement")
  - 2*(data_all$s1_e_q25_clean == "Ne peut pas le faire")
)
data_all$legumes_saison_num <- (
  + 2*(data_all$s1_e_q26 == "Le fait deja")
  + 1*(data_all$s1_e_q26 == "Pourrait le faire facilement")
  - 1*(data_all$s1_e_q26 == "Pourrait le faire mais difficilement")
  - 2*(data_all$s1_e_q26 == "Ne peut pas le faire")
)
data_all$limiter_viande_num <- (
  + 2*(data_all$s1_e_q27_clean == "Le fait deja")
  + 1*(data_all$s1_e_q27_clean == "Pourrait le faire facilement")
  - 1*(data_all$s1_e_q27_clean == "Pourrait le faire mais difficilement")
  - 2*(data_all$s1_e_q27_clean == "Ne peut pas le faire")
)
data_all$velo_marche_num <- (
  + 2*(data_all$s1_e_q28 == "Le fait deja")
  + 1*(data_all$s1_e_q28 == "Pourrait le faire facilement")
  - 1*(data_all$s1_e_q28 == "Pourrait le faire mais difficilement")
  - 2*(data_all$s1_e_q28 == "Ne peut pas le faire")
)
data_all$covoiturage_num <- (
  + 2*(data_all$s1_e_q29 == "Le fait deja")
  + 1*(data_all$s1_e_q29 == "Pourrait le faire facilement")
  - 1*(data_all$s1_e_q29 == "Pourrait le faire mais difficilement")
  - 2*(data_all$s1_e_q29 == "Ne peut pas le faire")
)
data_all$limiter_emballages_num <- (
  + 2*(data_all$s1_e_q30_clean == "Le fait deja")
  + 1*(data_all$s1_e_q30_clean == "Pourrait le faire facilement")
  - 1*(data_all$s1_e_q30_clean == "Pourrait le faire mais difficilement")
  - 2*(data_all$s1_e_q30_clean == "Ne peut pas le faire")
)
data_all$produits_ecolos_num <- (
  + 2*(data_all$s1_e_q31_clean == "Le fait deja")
  + 1*(data_all$s1_e_q31_clean == "Pourrait le faire facilement")
  - 1*(data_all$s1_e_q31_clean == "Pourrait le faire mais difficilement")
  - 2*(data_all$s1_e_q31_clean == "Ne peut pas le faire")
)
data_all$consommer_moins_num <- (
  + 2*(data_all$s1_e_q32_clean == "Le fait deja")
  + 1*(data_all$s1_e_q32_clean == "Pourrait le faire facilement")
  - 1*(data_all$s1_e_q32_clean == "Pourrait le faire mais difficilement")
  - 2*(data_all$s1_e_q32_clean == "Ne peut pas le faire")
)
data_all$couper_chauffage_num <- (
  + 2*(data_all$s1_e_q33_clean == "Le fait deja")
  + 1*(data_all$s1_e_q33_clean == "Pourrait le faire facilement")
  - 1*(data_all$s1_e_q33_clean == "Pourrait le faire mais difficilement")
  - 2*(data_all$s1_e_q33_clean == "Ne peut pas le faire")
)
data_all$arreter_avion_num <- (
  + 2*(data_all$s1_e_q34 == "Le fait deja")
  + 1*(data_all$s1_e_q34 == "Pourrait le faire facilement")
  - 1*(data_all$s1_e_q34 == "Pourrait le faire mais difficilement")
  - 2*(data_all$s1_e_q34 == "Ne peut pas le faire")
)


data_cor <- data_all[,c("trier_dechets_num", "eteindre_appareils_num", "transports_communs_num", "baisse_temperature_num",
                        "legumes_saison_num", "limiter_viande_num", "velo_marche_num", "covoiturage_num", "limiter_emballages_num",
                        "produits_ecolos_num", "consommer_moins_num", "couper_chauffage_num", "arreter_avion_num")]
names(data_cor) <- c("Trier déchets", "Eteindre appareils veille", "Transports en commun", "Baisser température hiver",
                     "Légumes de saison", "Limiter viande", "Vélo et/ou marche", "Covoiturage", "Limiter emballages",
                     "Produits écolos", "Consommer moins", "Couper chauffage", "Arrêter avion")
corr <- cor(data_cor, use="complete.obs")
corrplot(corr, method='color', diag=FALSE, tl.srt=35, tl.col='black', insig = 'blank', addCoef.col = 'black', addCoefasPercent = T , type='upper') #, order='hclust'



##### Corrélation confiance-optimisme-valeurs #####
table(data_all$s1_s_q17f_clean)
data_all$confiance_interpersonnelle_num <- (
  + 1*(data_all$s1_e_q4 == "On peut faire confiance a la plupart des gens")
  - 1*(data_all$s1_e_q4 == "On n est jamais assez prudent quand on a affaire aux autres")
)
data_all$confiance_capacite_citoyens_num <- (
  + 2*(data_all$s1_e_q7 == "Tout a fait confiance")
  + 1*(data_all$s1_e_q7 == "Plutot confiance")
  - 1*(data_all$s1_e_q7 == "Plutot pas confiance")
  - 2*(data_all$s1_e_q7 == "Pas du tout confiance")
)
data_all$satisfaction_vie_num <- data_all$s1_e_q8
data_all$redistribution_num <- data_all$s1_e_q10 # 10 = plus de redistribution
data_all$lien_efforts_pauvrete_num <- (
  + 1*(data_all$s1_e_q12_clean == "pas de chance")
  + 0*(data_all$s1_e_q12_clean == "NR")
  - 1*(data_all$s1_e_q12_clean == "pas fait deffort")
)
data_all$importance_environnement_num <- data_all$s1_e_q13
data_all$importance_action_sociale_num <- data_all$s1_e_q14
data_all$importance_niveau_vie_num <- data_all$s1_e_q15
data_all$confiance_anecdotes_num <- (
  + 2*(data_all$s1_s_q17a_clean == "totalement")
  + 1*(data_all$s1_s_q17a_clean == "plutot")
  - 1*(data_all$s1_s_q17a_clean == "plutot pas")
  - 2*(data_all$s1_s_q17a_clean == "pas du tout")
)
data_all$confiance_medias_num <- (
  + 2*(data_all$s1_s_q17b_clean == "totalement")
  + 1*(data_all$s1_s_q17b_clean == "plutot")
  - 1*(data_all$s1_s_q17b_clean == "plutot pas")
  - 2*(data_all$s1_s_q17b_clean == "pas du tout")
)
data_all$confiance_reseaux_sociaux_num <- (
  + 2*(data_all$s1_s_q17c_clean == "totalement")
  + 1*(data_all$s1_s_q17c_clean == "plutot")
  - 1*(data_all$s1_s_q17c_clean == "plutot pas")
  - 2*(data_all$s1_s_q17c_clean == "pas du tout")
)
data_all$confiance_gouvernement_num <- (
  + 2*(data_all$s1_s_q17d_clean == "Totalement")
  + 1*(data_all$s1_s_q17d_clean == "Plutot")
  - 1*(data_all$s1_s_q17d_clean == "Plutot pas")
  - 2*(data_all$s1_s_q17d_clean == "Pas du tout")
)
data_all$confiance_dossier_CCC_num <- (
  + 2*(data_all$s1_s_q17e_clean == "totalement")
  + 1*(data_all$s1_s_q17e_clean == "plutot")
  - 1*(data_all$s1_s_q17e_clean == "plutot pas")
  - 2*(data_all$s1_s_q17e_clean == "pas du tout")
)
data_all$confiance_experts_num <- (
  + 2*(data_all$s1_s_q17f_clean == "totalement")
  + 1*(data_all$s1_s_q17f_clean == "plutot")
  - 1*(data_all$s1_s_q17f_clean == "plutot pas")
  - 2*(data_all$s1_s_q17f_clean == "pas du tout")
)
data_all$mieux_informe_num <- data_all$s2_e_q11
data_all$anticipation_situation_eco_num <- data_all$s2_e_q12
data_all$plus_defforts_CP_num <- (
  + 2*(data_all$s2_e_q41 == "Non beaucoup moins")
  + 1*(data_all$s2_e_q41 == "Non un peu moins")
  + 0*(data_all$s2_e_q41 == "Autant")
  + 0*(data_all$s2_e_q41 == "NR")
  - 1*(data_all$s2_e_q41 == "Oui un peu plus")
  - 2*(data_all$s2_e_q41 == "Oui beaucoup plus")
)
data_all$plus_impacte_CC_num <- (
  + 2*(data_all$s2_e_q42_clean == "Non beaucoup moins")
  + 1*(data_all$s2_e_q42_clean == "Non un peu moins")
  + 0*(data_all$s2_e_q42_clean == "Autant")
  + 0*(data_all$s2_e_q42_clean == "NR")
  - 1*(data_all$s2_e_q42_clean == "Oui un peu plus")
  - 2*(data_all$s2_e_q42_clean == "Oui beaucoup plus")
)

data_cor <- data_all[,c("confiance_interpersonnelle_num", "confiance_capacite_citoyens_num", "satisfaction_vie_num",
                        "confiance_anecdotes_num", "confiance_medias_num", "confiance_reseaux_sociaux_num", "confiance_gouvernement_num",
                        "confiance_dossier_CCC_num", "confiance_experts_num", "anticipation_situation_eco_num",
                        "plus_defforts_CP_num", "plus_impacte_CC_num")]
names(data_cor) <- c("Conf. aux autres", "Conf. capacité citoyens", "Satisfaction vie",
                     "Conf. anecdotes", "Conf. médias", "Conf. réseaux soc.", "Conf. gouvernement",
                     "Conf. dossier CCC", "Conf. experts", "Anticipation situ. éco.",
                     "Efforts perso CP", "Impacts perso CC")
corr <- cor(data_cor, use="complete.obs")
corrplot(corr, method='color', diag=FALSE, tl.srt=35, tl.col='black', insig = 'blank', addCoef.col = 'black', addCoefasPercent = T , type='upper') #, order='hclust'


data_cor <- data_all[,c("confiance_interpersonnelle_num", "redistribution_num", "lien_efforts_pauvrete_num",
                        "importance_environnement_num", "importance_action_sociale_num", "importance_niveau_vie_num",
                        "mieux_informe_num")]
names(data_cor) <- c("Conf. aux autres", "Redistribution", "Lien efforts-pauvreté",
                     "Importance environnement", "Importance action sociale", "Importance niveau vie",
                     "Mieux informé")
corr <- cor(data_cor, use="complete.obs")
corrplot(corr, method='color', diag=FALSE, tl.srt=35, tl.col='black', insig = 'blank', addCoef.col = 'black', addCoefasPercent = T , type='upper') #, order='hclust'
