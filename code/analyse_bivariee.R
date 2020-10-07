library(foreign)
install.packages("psych")
library(psych)
data_1e <- read.dta("C:/Users/thoma/Documents/Github/CCC/donnees/1e.dta")


##### Q1-Q36 Urbains-Ruraux / Position 110km/h #####
table(data_1e$s1_e_q1_clean) # 2 manquants, 24 banlieue, 47 campagne, 44 grande ville, 35 petite ville
dotchart(as.matrix(table(data_1e$s1_e_q1_clean))[, 1], main = "Q1. Vous habitez :", 
         pch = 19)
table(data_1e$s1_e_q36) # 8 manquants, 17 pas du tout souhaitable, 53 pas vraiment, 49 assez souhaitable, 25 très souhaitable
dotchart(as.matrix(table(data_1e$s1_e_q36))[, 1], main = "Q36. Limitation à 110km/h :", 
         pch = 19)
table_q1_q36 <- table(data_1e$s1_e_q1_clean, data_1e$s1_e_q36)
prop.table(table_q1_q36, 2)
mosaicplot(s1_e_q1_clean ~ s1_e_q36, data = data_1e, shade = TRUE, main = "Title")

##### Q3-Q41 Difficultés financières / Taxe carbone #####
table(data_1e$s1_e_q3) # 8 manquants, 13 très difficile, 51 plutôt difficile, 74 plutôt facile, 6 très facile
dotchart(as.matrix(table(data_1e$s1_e_q3))[, 1], main = "Q3. Comment vous en sortez-vous avec les revenus de votre ménage ? :", 
         pch = 19)
table(data_1e$s1_e_q41_clean) # 15 manquants, 26 pas du tout (souhaitable), 39 pas vraiment, 52 assez, 20 très
dotchart(as.matrix(table(data_1e$s1_e_q41_clean))[, 1], main = "Q41. Taxe carbone :", 
         pch = 19)
table_q3_q41 <- table(data_1e$s1_e_q3, data_1e$s1_e_q41_clean)
prop.table(table_q3_q41, 1)
mosaicplot(s1_e_q3 ~ s1_e_q41_clean, data = data_1e, shade = TRUE, main = "Title")


##### Q3-Q37 Difficultés financières / Taxe avions #####
table(data_1e$s1_e_q3) # 8 manquants, 13 très difficile, 51 plutôt difficile, 74 plutôt facile, 6 très facile
dotchart(as.matrix(table(data_1e$s1_e_q3))[, 1], main = "Q3. Comment vous en sortez-vous avec les revenus de votre ménage ? :", 
         pch = 19)
table(data_1e$s1_e_q37) # 3 manquants, 66 pas du tout (souhaitable), 23 pas vraiment, 47 assez, 73 très
dotchart(as.matrix(table(data_1e$s1_e_q37))[, 1], main = "Q41. Taxe avions :", 
         pch = 19)
table_q3_q37 <- table(data_1e$s1_e_q3, data_1e$s1_e_q37)
prop.table(table_q3_q37, 1)
mosaicplot(s1_e_q3 ~ s1_e_q37, data = data_1e, shade = TRUE, main = "Title")


##### Q4-Q7 Confiance aux gens / Confiance capacité convention citoyenne #####
table(data_1e$s1_e_q4) # 12 manquants, 73 on n'est jamais assez prudent, 67 on peut faire confiance
dotchart(as.matrix(table(data_1e$s1_e_q4))[, 1], main = "Q4. D’une manière générale, diriez-vous que… ? :", 
         pch = 19)
table(data_1e$s1_e_q7) # 2 manquants, 2 pas du tout conf, 17 plutôt pas, 112 plutôt conf, 19 tout à fait conf
dotchart(as.matrix(table(data_1e$s1_e_q7))[, 1], main = "Q7. Confiance capacité convention citoyenne :", 
         pch = 19)
table_q4_q7 <- table(data_1e$s1_e_q4, data_1e$s1_e_q7)
prop.table(table_q4_q7, 1)
mosaicplot(s1_e_q4 ~ s1_e_q7, data = data_1e, shade = TRUE, main = "Title")



##### Q7 Confiance capacité convention citoyenne / Q49 Principaux obstacles (lobbies=True) #####
table(data_1e$s1_e_q7) # 2 manquants, 2 pas du tout conf, 17 plutôt pas, 112 plutôt conf, 19 tout à fait conf
dotchart(as.matrix(table(data_1e$s1_e_q7))[, 1], main = "Q7. Confiance capacité convention citoyenne :", 
         pch = 19)
table(data_1e$s1_e_q49_lobbies) # manquants: 13; 1: 79; 2: 24; 3: 11; 4: 11; 5: 6; 6: 6; autre: 2
dotchart(as.matrix(table(data_1e$s1_e_q49_lobbies))[, 1], main = "Q49. Classement lobbies parmis les principaux obstacles :", 
         pch = 19)
table_q7_q49lobbies <- table(data_1e$s1_e_q7, data_1e$s1_e_q49_lobbies)
prop.table(table_q7_q49lobbies, 1)
mosaicplot(s1_e_q7 ~ s1_e_q49_lobbies, data = data_1e, shade = TRUE, main = "Title")
