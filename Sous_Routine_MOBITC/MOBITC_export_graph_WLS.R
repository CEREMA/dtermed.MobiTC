#verif utf-8
#version 22-04-2022
#réalisée par C Trmal Cerema

# #nécessaire
# chemin_rep_travail="C:\\0_ENCOURS\\MOBITC\\DEPT06_v2sup50m"
# chemin_rep_travail="C:\\0_ENCOURS\\MOBITC\\DEPT13_sup50"
# chemin_rep_travail="C:\\0_ENCOURS\\MOBITC\\DEPT83_sup50m_horsCAVEM"
# dirr=R.home()
# chem_mobitc=paste(dirr,"/Cerema/MOBITC",sep="")
# 
# fichier_intersection ="sque_Alpes_Maritimes_sup50-Tra-P50-L0200-IntersTDC-v1.txt"
# fichier_trace = "sque_Alpes_Maritimes_sup50-Tra-P50-L0200"
# fichier_sque ="sque_Alpes_Maritimes_sup50"
# fichier_intersection ="sque_BdR_sup50-Tra-P50-L0200-IntersTDC-v1.txt"
# fichier_trace = "sque_BdR_sup50-Tra-P50-L0200"
# fichier_sque ="sque_BdR_sup50"
# fichier_intersection ="sque_Varsel_sup50-Tra-P50-L0200-IntersTDC-v1.txt"
# fichier_trace = "sque_Varsel_sup50-Tra-P50-L0200"
# fichier_sque ="sque_Varsel_sup50"
# 
# fichier_intersectionv1=fichier_intersection



MOBITC_export_graph_WLS<-function(chem_mobitc,chemin_rep_travail,fichier_sque,fichier_trace,fichier_intersectionv1)
{

  params = list(chemin_rep_travail = chemin_rep_travail,chem_mobitc = chem_mobitc,fichier_sque=fichier_sque,fichier_intersectionv1=fichier_intersectionv1,fichier_trace=fichier_trace)
  
# sortie graph png

library(rgdal)

#type d'export
export="png"

# lecture des param?tres
fichier_init=paste(chem_mobitc,"\\Init_Routine_MobiTC.txt",sep="")
fid=file(fichier_init, open = "r+")
lignes=readLines(fid)
produc=lignes[14]
ICtx=lignes[16]
datedebgraph=lignes[18]
datefingraph=lignes[20]
dateprosp=lignes[22]
nom_proj=lignes[4]
close(fid)

#lecture du fichier intersection V1 normalement (limites retenue)
chem_intersectionv1=paste(chemin_rep_travail,"\\",fichier_intersectionv1,sep="")
#lecture de toutes les intersections
fichier_intersectionv0=paste(substr(fichier_intersectionv1,1,nchar(fichier_intersectionv1)-7),"-v0.txt",sep="")
chem_intersectionv0=paste(chemin_rep_travail,"\\",fichier_intersectionv0,sep="")
print(chem_intersectionv0)
tab00=read.table(chem_intersectionv0,sep="\t",header=TRUE,row.names = NULL)
print(chem_intersectionv1)
tab11=read.table(chem_intersectionv1,sep="\t",header=TRUE,row.names = NULL)
#modif des dates dans le tableau de départ
source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Convertdate_2.R",sep=""))	
tab=MOBITC_Convertdate_2(tab00) #ttes
#pour AOR
tab1=MOBITC_Convertdate_2(tab11) #que les retenues

Trace = readOGR(chemin_rep_travail,fichier_trace)
nloc=length(unique(Trace$Loc))

listefichMobiTC=list.files(path=params$chemin_rep_travail,pattern=paste0(substr(params$fichier_intersectionv1,1,nchar(params$fichier_intersectionv1)-4),"-post"))
        #retrouver les dates de coupure
        datecoup=as.numeric(substr(listefichMobiTC,nchar(params$fichier_intersectionv1)+2,nchar(params$fichier_intersectionv1)+5))
        datecoup=unique(datecoup)
        nbfeuille=length(datecoup)+1
 nomcourt=c("toutesdates",paste0("post",datecoup))
 
 #toutesdates
 fichier_evolution=paste(substr(params$fichier_intersectionv1,1,nchar(params$fichier_intersectionv1)-4),"-",nomcourt,"-MobiTC.txt",sep="")

nomdirpng=paste(chemin_rep_travail,"\\Graph_WLS",sep="")
  if (file.exists(nomdirpng)=="FALSE"){dir.create(nomdirpng)}

for (iloc in 1:nloc)
{
  
  itemploc=which(tab$Loc ==unique(tab$Loc)[iloc])
  Nbaxe=length(unique(tab$NAxe[itemploc]))
  for (iaxe in 1 : Nbaxe)
  {
    itemp=which(tab$NAxe[itemploc] ==unique(tab$NAxe[itemploc])[iaxe])
    #calcul du nombre de trace
    NbTrace=length(unique(tab$NTrace[itemploc[itemp]]))
  
    for (itr in 1:NbTrace)#)c(61:64)
    {
      #extrait des valeurs du sque et de la trace
      NAxe=unique(tab$NAxe[itemploc])[iaxe]
      NTrace=unique(tab$NTrace[itemploc[itemp]])[itr]
      Loc=unique(tab$Loc)[iloc]     
      extraittab1=tab1[which(tab1$NAxe == NAxe & tab1$NTrace == NTrace & tab1$Loc == Loc),]
	  
	  if (is.numeric(Loc)==TRUE)
            {
              Loc=as.character(formatC(as.numeric(Loc), width = 5, format = "d", flag = "0"))
            }

      if (length(extraittab1$Distance)>1)
      {
        
        
        for (k in 1:(length(datecoup)+1))
        {
          nom_fiche=paste0("\\Graph_WLS\\",substr(fichier_intersectionv1,1,nchar(fichier_intersectionv1)-4),"-",nomcourt[k],"-Graph-NAxe",NAxe,"-NTrace",NTrace,"-Loc",Loc,".png")
          img1_path=paste(chemin_rep_travail,nom_fiche,sep="")
         # if (file.exists(img1_path)=="FALSE")
        #  {
          source(paste0(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Export_Graph_1p1_leger.R"),encoding = "UTF-8")
          
          sortie=MOBITC_Export_Graph_1p1_leger(chem_mobitc,chemin_rep_travail,fichier_sque,fichier_trace,
                                                         fichier_intersectionv1,fichier_evolution[k],NAxe,NTrace,Loc)

          png(filename =  img1_path, width = 15, height = 10, units = "cm", res = 96)
          plot(sortie[[7]])
          invisible(dev.off())
          #}
          
        }
      }
    } #fin itr
  }
}
textexportgraph_wls="Export fini"

return(list(textexportgraph_wls))
}
