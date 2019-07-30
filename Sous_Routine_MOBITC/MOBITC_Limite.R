MOBITC_Limite<-function(chemin_rep_travail)
{
nom_exp="LIM.csv"
chem_exp=paste(chemin_rep_travail,"\\",nom_exp,sep="")
#Vérification de l'existance du tableau LIM.csv
if (file.exists(chem_exp)==TRUE) {
Data=read.table(chem_exp,sep="\t",header=TRUE,quote="",row.names = NULL,fileEncoding="UTF-8")
} else {
#Construction du tableau ini
V1<-c(1:25)
V2<-c("-","Talus pré-littoral","Limite du jet de rive","Limite supérieure du sable mouillée","Dernière laisse de haute mer","Crête de la berme","Fond de plage","Pied de dune","Haut de falaise dunaire","Crête de dune","Limite côté mer de la végétation dunaire","Limite côté mer de la végétation dunaire pérenne (arbres, arbustes,...)","Limite de végétation (hors dune)","Pied de falaise","Haut de falaise","Haut du cône d'éboulis","Limite supérieure du schorre","Limite supérieure de la slikke","Cordon de galets","Position de la 1ère barre d'avant-côte","Position de la 2nde barre d'avant-côte","Limite générée par MNT","Limite du Domaine Public Maritime","Limite parcellaire","Autre")
V3<-c(0,255,255,0,0,255,0,150,255,128,128,255,51,204,255,51,0,192,0,128,204,0,51,51,255)
V4<-c(0,255,0,255,0,0,255,150,102,0,0,153,153,153,153,51,0,192,128,128,255,51,51,51,255)
V5<-c(0,0,0,0,255,255,255,150,0,128,0,204,102,255,0,0,128,192,0,0,255,102,153,51,153)
Liste<-list(V1,V2,V3,V4,V5)
Data0<-data.frame(Liste)
colnames(Data0)<-c("ID","LIM","R","V","B")
write.table(Data0,chem_exp,sep="\t",eol="\n",append=FALSE,quote=FALSE,row.names=FALSE,col.names=TRUE)#,fileEncoding="UTF-8")
Data=read.table(chem_exp,sep="\t",header=TRUE,quote="",row.names = NULL,fileEncoding="UTF-8")
}

#écriture du tableau avec couleur à chaque ligne



return(list(Data))	
}