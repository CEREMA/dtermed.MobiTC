#rename Varsel dans Graph WLS
chemin_rep_travail="C:\\0_ENCOURS\\MOBITC\\DEPT83_sup50m_horsCAVEM\\temp"
setwd(chemin_rep_travail)
nomfichieri=list.files(path=chemin_rep_travail,pattern="Var")
nomfichierf=gsub("Var","Varsel",nomfichieri)
for (k in 1:length(nomfichieri))
{
file.rename(nomfichieri[k],nomfichierf[k])
}

chemin_rep_travail="C:\\0_ENCOURS\\MOBITC\\DEPT83_sup50m_horsCAVEM"
#fusion de fichier intersection
ini="sque_Var_sup50-Tra-P50-L0200-IntersTDC-v1 - Copie.txt"
temp="sque_Varsel_sup50-Tra-P50-L0200-IntersTDC-v1.txt"
fin="sque_Var_sup50-Tra-P50-L0200-IntersTDC-v1.txt"

chem_intersection=paste(chemin_rep_travail,"\\",ini,sep="")
tab0=read.table(chem_intersection,sep="\t",header=TRUE,row.names = NULL)

tab1=read.table(paste(chemin_rep_travail,"\\",temp,sep=""),sep="\t",header=TRUE,row.names = NULL)

for (i in 1:nrow(tab1))
{
  nb=which(tab0$NAxe == tab1$NAxe[i] & tab0$NTrace == tab1$NTrace[i] & tab0$Loc == tab1$Loc[i])
  if (length(nb)>0)
  {
  tab0=tab0[-c(nb),]
  }
}
#↔on rajoute
tab2=rbind(tab0,tab1)
write.table(tab2,paste0(chemin_rep_travail,"\\",fin),sep="\t",eol="\n",append=FALSE,quote=FALSE,row.names=FALSE,col.names=TRUE)

#fusion de fichier évolution
ini=c("sque_Var_sup50-Tra-P50-L0200-IntersTDC-v1-toutesdates-MobiTC - Copie.txt",
                 "sque_Var_sup50-Tra-P50-L0200-IntersTDC-v1-post1950-MobiTC - Copie.txt",
                 "sque_Var_sup50-Tra-P50-L0200-IntersTDC-v1-post1980-MobiTC - Copie.txt",
                 "sque_Var_sup50-Tra-P50-L0200-IntersTDC-v1-post2000-MobiTC - Copie.txt",
                 "sque_Var_sup50-Tra-P50-L0200-IntersTDC-v1-post2010-MobiTC - Copie.txt")
temp=c("sque_Varsel_sup50-Tra-P50-L0200-IntersTDC-v1-toutesdates-MobiTC.txt",
      "sque_Varsel_sup50-Tra-P50-L0200-IntersTDC-v1-post1950-MobiTC.txt",
      "sque_Varsel_sup50-Tra-P50-L0200-IntersTDC-v1-post1980-MobiTC.txt",
      "sque_Varsel_sup50-Tra-P50-L0200-IntersTDC-v1-post2000-MobiTC.txt",
      "sque_Varsel_sup50-Tra-P50-L0200-IntersTDC-v1-post2010-MobiTC.txt")
fin=c("sque_Var_sup50-Tra-P50-L0200-IntersTDC-v1-toutesdates-MobiTC.txt",
      "sque_Var_sup50-Tra-P50-L0200-IntersTDC-v1-post1950-MobiTC.txt",
      "sque_Var_sup50-Tra-P50-L0200-IntersTDC-v1-post1980-MobiTC.txt",
      "sque_Var_sup50-Tra-P50-L0200-IntersTDC-v1-post2000-MobiTC.txt",
      "sque_Var_sup50-Tra-P50-L0200-IntersTDC-v1-post2010-MobiTC.txt")

for (k in 1:5)
{
chem_intersection=paste(chemin_rep_travail,"\\",ini[k],sep="")
tab0=read.table(chem_intersection,sep="\t",header=TRUE,row.names = NULL)

tab1=read.table(paste(chemin_rep_travail,"\\",temp[k],sep=""),sep="\t",header=TRUE,row.names = NULL)

for (i in 1:nrow(tab1))
{
  nb=which(tab0$NAxe == tab1$NAxe[i] & tab0$NTrace == tab1$NTrace[i] & tab0$Loc == tab1$Loc[i])
  if (length(nb)>0)
  {
    tab0=tab0[-c(nb),]
  }
}
#↔on rajoute
tab2=rbind(tab0,tab1)
write.table(tab2,paste0(chemin_rep_travail,"\\",fin[k]),sep="\t",eol="\n",append=FALSE,quote=FALSE,row.names=FALSE,col.names=TRUE)
}