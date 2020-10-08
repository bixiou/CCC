library(foreign)
install.packages("psych")
library(psych)
#data_all <- read.dta("C:/Users/thoma/Documents/Github/CCC/donnees/1e.dta")
data_all <- read.dta("C:/Users/thoma/Documents/Github/CCC/donnees/all_benedicte.dta")



##### Sexe #####
# Analyse univariée
prop.table(table(data_all$sexe)) # 53% de femmes

# Intéraction avec age
prop.table(table(data_all$sexe, data_all$age), 2) # les hommes sont sur-représentés chez les 25-34 ans, les femmes chez les 65 ans et plus

# Intéraction avec diplome
prop.table(table(data_all$sexe, data_all$diplome), 2) # les proportions sont relativement équilibrées, à comparer avec données Insee




##### Confiance envers les autres #####
# Analyse univariée
prop.table(table(data_all$s1_e_q4)) # 72 on n'est jamais assez prudent, 67 on peut faire confiance
dotchart(as.matrix(table(data_all$s1_e_q4))[, 1], main = "Q4. D’une manière générale, diriez-vous que… ? :", 
         pch = 19)

# Intéraction avec les principaux obstacles à la lutte contre le CC
prop.table(table(data_all$s1_e_q4, (data_all$s1_e_q49_lobbies)==1), 1) # les citoyens qui ont plus de confiance envers les autres sont moins nombreux à identifier les lobbies comme principal obstacle
prop.table(table(data_all$s1_e_q4, (data_all$s1_e_q49_volonte)<3), 1) # Pas de différence très significative sur ce point




##### Confiance capacité citoyens tirés au sort #####
# Analyse univariée
prop.table(table(data_all$s1_e_q7)) # 2 pas du tout conf, 17 plutôt pas, 111 plutôt conf, 19 tout à fait conf
dotchart(as.matrix(table(data_all$s1_e_q7))[, 1], main = "Q7. Confiance capacité convention citoyenne :", 
         pch = 19)

# Interaction avec confiance envers les autres
prop.table(table(data_all$s1_e_q7, data_all$s1_e_q4), 2) # plus de confiance envers les autres -> plus de confiance envers capacité citoyens

# Intéraction avec les principaux obstacles à la lutte contre le CC
prop.table(table(data_all$s1_e_q7, (data_all$s1_e_q49_lobbies)==1), 1) # les citoyens qui ont plus de confiance envers la capacité de citoyens tirés au sort sont moins nombreux à identifier les lobbies comme principal obstacle
prop.table(table(data_all$s1_e_q7, (data_all$s1_e_q49_volonte)<3), 1) # les citoyens qui ont plus de confiance envers la capacité de citoyens tirés au sort sont plus nombreux à identifier le manque de volonté politique comme un des deux principaux obstacles

# Intéraction avec se sent mieux informé vie politique
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

# Intéraction avec les principaux obstacles à la lutte contre le CC
prop.table(table(data_all$s1_s_q17d_clean, (data_all$s1_e_q49_lobbies)==1), 1) # Rien de très clair qui se dégage, pas assez significatif
prop.table(table(data_all$s1_s_q17d_clean, (data_all$s1_e_q49_volonte)<3), 1) # Rien de très clair qui se dégage, pas assez significatif
prop.table(table(data_all$s1_s_q17c_clean, (data_all$s1_e_q49_lobbies)==1), 1) # Les citoyens les plus méfiants envers les réseaux sociaux sont plus nombreux à voir les lobbies comme le princpal obstacle
# De manière générale, pas de lien très clair entre Q49 S1E et Q17 S1S


# Interaction avec confiance envers les autres
prop.table(table(data_all$s1_e_q7, data_all$s1_e_q4), 2) # plus de confiance envers les autres -> plus de confiance envers capacité citoyens

# Intéraction avec les principaux obstacles à la lutte contre le CC
prop.table(table(data_all$s1_e_q7, (data_all$s1_e_q49_lobbies)==1), 1) # les citoyens qui ont plus de confiance envers la capacité de citoyens tirés au sort sont moins nombreux à identifier les lobbies comme principal obstacle
prop.table(table(data_all$s1_e_q7, (data_all$s1_e_q49_volonte)<3), 1) # les citoyens qui ont plus de confiance envers la capacité de citoyens tirés au sort sont plus nombreux à identifier le manque de volonté politique comme un des deux principaux obstacles

# Intéraction avec se sent mieux informé vie politique
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

# Intéraction avec les principaux obstacles à la lutte contre le CC
prop.table(table(data_all$s1_s_q17d_clean, (data_all$s1_e_q49_lobbies)==1), 1) # Rien de très clair qui se dégage, pas assez significatif
prop.table(table(data_all$s1_s_q17d_clean, (data_all$s1_e_q49_volonte)<3), 1) # Rien de très clair qui se dégage, pas assez significatif
prop.table(table(data_all$s1_s_q17c_clean, (data_all$s1_e_q49_lobbies)==1), 1) # Les citoyens les plus méfiants envers les réseaux sociaux sont plus nombreux à voir les lobbies comme le princpal obstacle
# De manière générale, pas de lien très clair entre Q49 S1E et Q17 S1S



##### Limitation 110km/h #####
# Analyse univariée
prop.table(table(data_all$s1_e_q36)) # 17 pas du tout souhaitable, 53 pas vraiment, 48 assez souhaitable, 25 très souhaitable
dotchart(as.matrix(table(data_all$s1_e_q36))[, 1], main = "Q36. Limitation à 110km/h :", 
         pch = 19)

# Intéraction avec ruraux/urbains
prop.table(table(data_all$s1_e_q1_clean, data_all$s1_e_q36), 1)

# Intéraction avec perception de l'effort demandé par les CP par rapport aux autres
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

# Intéraction avec ruraux/urbains
prop.table(table(data_all$s1_e_q1_clean, data_all$s1_e_q41_clean), 1)

# Intéraction avec perception de l'effort demandé par les CP par rapport aux autres
prop.table(table(data_all$s2_e_q41, data_all$s1_e_q41_clean), 1) # On ne discerne rien de précis, trop de catégories




##### Perception de l'effort demandé par les politiques climatiques par rapport à la moyenne #####
prop.table(table(data_all$s2_e_q41)) # 50% pensent que cela leur demandera davantage, 37% que ça leur demandera autant
dotchart(as.matrix(table(data_all$s2_e_q41))[, 1], main = "Les pol. clim. vous demanderont plus d'efforts qu'à la moyenne :", 
         pch = 19)

# Intéraction avec ruraux/urbains
prop.table(table(data_all$s1_e_q1_clean, data_all$s2_e_q41), 1) # les habitants des petites villes se sentent les plus concernés par ces efforts

# Intéraction avec age
prop.table(table(data_all$age, data_all$s2_e_q41), 1) # les 35-49 se sentent les plus concernés par ces efforts

# Intéraction avec difficultés ignorées par pouvoirs publics et médias
prop.table(table(data_all$s1_e_q11, data_all$s2_e_q41), 1) # Rien de précis n'en ressort

# Intéraction avec perception évolution propre situation éco et sociale
prop.table(table(data_all$s2_e_q41, (data_all$s2_e_q12 < 5)), 2) # Rien de précis n'en ressort

# Intéraction avec plus impacté par le CC que reste de ma génération
prop.table(table(data_all$s2_e_q41, data_all$s2_e_q42), 2) # Rien de précis n'en ressort, trop de catégories
mosaicplot(s2_e_q41 ~ s2_e_q42, data = data_all, shade = TRUE, main = "Plus exposé au CC et aux CP")




##### Plus impacté que le reste de ma génération par le CC #####
prop.table(table(data_all$s2_e_q42)) # la plupart des gens pensent être autant impactés, un certain nombre plus impactés, très peu moins impactés.
dotchart(as.matrix(table(data_all$s2_e_q42))[, 1], main = "Les pol. clim. vous demanderont plus d'efforts qu'à la moyenne :", 
         pch = 19)

# Intéraction avec difficultés financières
prop.table(table(data_all$s2_e_q42, data_all$s1_e_q3), 2) # Trop de catégories pour que quoique ce soit émerge de significatif



##### Echelle prise en charge CC #####
prop.table(table(data_all$s1_e_q35))
dotchart(as.matrix(table(data_all$s1_e_q35))[, 1], main = "Echelles politiques climatiques", 
         pch = 19)

# Intéraction avec obstacles
prop.table(table(data_all$s1_e_q35, (data_all$s1_e_q49_lobbies)==1), 2) # Rien de très clair qui se dégage
prop.table(table(data_all$s1_e_q35, (data_all$s1_e_q49_volonte)<3), 2) # Rien de très clair qui se dégage




#### Avance de la France dans la lutte face au CC #####
prop.table(table(data_all$s1_e_q48)) # Une écrasante majorité pense qu'il faut que la France prenne de l'avance (89% oui, 2% non, 8% NSP)
dotchart(as.matrix(table(data_all$s1_e_q48))[, 1], main = "La France doit-elle prendre de l'avance dans la lutte face au CC  ?", 
         pch = 19)
