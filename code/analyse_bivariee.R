library(foreign)
install.packages("psych")
library(psych)
#data_all <- read.dta("C:/Users/thoma/Documents/Github/CCC/donnees/1e.dta")
data_all <- read.dta("C:/Users/thoma/Documents/Github/CCC/donnees/all_benedicte.dta")

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
