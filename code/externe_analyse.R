###### Efforts relatifs #####
decrit(s$efforts_relatifs)
decrit(s$efforts_relatifs[s$variante_efforts_vous==1])
decrit(s$efforts_relatifs[s$variante_efforts_vous==0])
summary(lm(efforts_relatifs ~ variante_efforts_vous, data=s))


##### Taxe carbone ~ sondage #####
decrit(s$pour_taxe_carbone, miss=T)
decrit(s$pour_taxe_carbone[s$variante_taxe_carbone=='pour'], miss=T)
decrit(s$pour_taxe_carbone[s$variante_taxe_carbone=='contre'], miss=T)
decrit(s$pour_taxe_carbone[s$variante_taxe_carbone=='neutre'], miss=T)
summary(lm(pour_taxe_carbone!='Non' ~ variante_taxe_carbone, data=s))


##### Taxe carbone ~ label_taxe * origine_taxe #####
summary(lm(taxe_approbation!='Non' ~ label_taxe * origine_taxe, data=s))
summary(lm(taxe_approbation!='Non' ~ label_taxe * origine_taxe * question_confiance, data=s))


##### Politiques env ~ info_CCC #####
decrit(round(s$prop_referenda_politiques_2, 3))
summary(lm(prop_referenda_politiques_2 ~ info_CCC, data=s))
