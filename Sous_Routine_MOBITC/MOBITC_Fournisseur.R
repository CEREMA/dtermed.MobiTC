MOBITC_Fournisseur<-function(chemin_rep_travail)
{
nom_exp="F.csv"
chem_exp=paste(chemin_rep_travail,"\\",nom_exp,sep="")
#Vérification de l'existance du tableau F.csv
if (file.exists(chem_exp)==TRUE) {
Data_Fourn=read.table(chem_exp,sep="\t",header=TRUE,row.names = NULL,fileEncoding="UTF-8")
} else {
#Construction du tableau ini

V2<-c("Cerema","Rivages","BRGM","CEREGE","CRIGE","CD83","DDTM66","Artelia","Créocéean")
V3<-c("Cerema","Rivages","BRGM","CEREGE-UMR7330","CRIGE PACA","CD83","DDTM66","Artelia","Créocéean")
V1<-c(1:length(V2))
Liste_Fourn<-list(V1,V2,V3)
Data_Fourn<-data.frame(Liste_Fourn)
colnames(Data_Fourn)<-c("ID","Nom_court","Nom_long")

write.table(Data_Fourn,chem_exp,sep="\t",eol="\n",append=FALSE,quote=FALSE,row.names=FALSE,col.names=TRUE,fileEncoding="UTF-8")
}

return(list(Data_Fourn))	
}