MOBITC_Fournisseur<-function(chemin_rep_travail)
{
nom_exp="F.csv"
chem_exp=paste(chemin_rep_travail,"\\",nom_exp,sep="")
#Vérification de l'existance du tableau F.csv
if (file.exists(chem_exp)==TRUE) {
Data_Fourn=read.table(chem_exp,sep="\t",header=TRUE,row.names = NULL)#,fileEncoding="UTF-8")
} else {
#Construction du tableau ini
V1<-c(1:9)
V2<-c("CETE MED","CETE NP","CETE NC","CETE O","CETE SO","Cerema","Rivages","BRGM","CEREGE")
V3<-c("CETE Méditerranée","CETE Nord Picardie","CETE Normandie Centre","CETE Ouest","CETE Sud Ouest","Cerema","Rivages","BRGM","Université Aix-Marseille CEREGE")
Liste_Fourn<-list(V1,V2,V3)
Data_Fourn<-data.frame(Liste_Fourn)
colnames(Data_Fourn)<-c("ID","Nom_court","Nom_long")

write.table(Data_Fourn,chem_exp,sep="\t",eol="\n",append=FALSE,quote=FALSE,row.names=FALSE,col.names=TRUE)
}

return(list(Data_Fourn))	
}