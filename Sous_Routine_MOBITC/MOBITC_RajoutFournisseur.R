MOBITC_RajoutFournisseur<-function(chemin_rep_travail,NCF,NLF)
{
#lecture du csv
nom_exp="F.csv"
chem_exp=paste(chemin_rep_travail,"\\",nom_exp,sep="")
Liste_Fourn=read.table(chem_exp,sep="\t",header=TRUE,row.names = NULL,fileEncoding="UTF-8")
Raj=cbind(ID=max(Liste_Fourn[1])+1,Nom_court=NCF,Nom_long=NLF)
Data_Fourn=rbind(Liste_Fourn,Raj)
write.table(Data_Fourn,chem_exp,sep="\t",eol="\n",append=FALSE,quote=FALSE,row.names=FALSE,col.names=TRUE,fileEncoding="UTF-8")

return(list(Data_Fourn))	
}