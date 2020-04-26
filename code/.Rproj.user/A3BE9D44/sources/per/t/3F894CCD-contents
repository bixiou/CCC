###### Efforts relatifs #####
decrit(s$efforts_relatifs)
decrit(s$efforts_relatifs[s$variante_efforts_vous==1])
decrit(s$efforts_relatifs[s$variante_efforts_vous==0])
summary(lm(efforts_relatifs ~ variante_efforts_vous, data=s)) # +1


##### Taxe carbone ~ sondage #####
decrit(s$pour_taxe_carbone, miss=T)
decrit(s$pour_taxe_carbone[s$variante_taxe_carbone=='pour'], miss=T)
decrit(s$pour_taxe_carbone[s$variante_taxe_carbone=='contre'], miss=T)
decrit(s$pour_taxe_carbone[s$variante_taxe_carbone=='neutre'], miss=T)
summary(lm(pour_taxe_carbone!='Non' ~ variante_taxe_carbone, data=s)) # THE result


##### Taxe carbone ~ label_taxe * origine_taxe #####
summary(lm(taxe_approbation!='Non' ~ label_taxe, data=s))
summary(lm(taxe_approbation!='Non' ~ origine_taxe, data=s))
summary(lm(taxe_approbation!='Non' ~ label_taxe * origine_taxe, data=s))
summary(lm(taxe_approbation!='Non' ~ label_taxe * origine_taxe * question_confiance, data=s)) # no effect


##### Confiance dividende ~ label_taxe * origine_taxe #####
decrit(s$confiance_dividende)
decrit(s$confiance_dividende[s$origine_taxe=='gouvernement'])
decrit(s$confiance_dividende[s$origine_taxe=='CCC'])
decrit(s$confiance_dividende[s$origine_taxe=='inconnue'])
summary(lm(confiance_dividende!='Non' ~ origine_taxe, data=s))
summary(lm(confiance_dividende!='Non' ~ label_taxe * origine_taxe, data=s)) # no effect


##### Taxe carbone: Motivated reasoning ~ confiance_dividende ####
summary(lm(update_correct_large ~ Gilets_jaunes + taxe_approbation, data=s))
summary(lm(update_correct_large ~ confiance_dividende, data=s))
summary(lm(update_correct_large ~ Gilets_jaunes + taxe_approbation + confiance_dividende, data=s))


##### Politiques env ~ info_CCC #####
decrit(round(s$prop_referenda_politiques_2, 3))
summary(lm(prop_referenda_politiques_2 ~ info_CCC, data=s)) # no effect


##### Opinions politiques #####
decrit(s$Gilets_jaunes)


##### Obstacles #####
# pb: ne peut être utilisé que pour comparabilité. Le résultat en soit est biaisé car l'ordre des items n'a pas été randomisé.
