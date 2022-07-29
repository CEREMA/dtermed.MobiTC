#verif utf-8
#version 18-12-2020
#réalisée par C Trmal Cerema

# dirr=R.home()
# fichier_env=""
# chem_mobitc=paste(dirr,"/Cerema/MOBITC",sep="")
# chemin_rep_travail="C:\\0_ENCOURS\\MOBITC\\DEPT06"
# fichier_trace="sque_Alpes_Maritimes_snake-Tra-P50-L0200"
# fichier_sque="sque_Alpes_Maritimes_snake"
# fichier_intersectionv1="sque_Alpes_Maritimes_snake-Tra-P50-L0200-IntersTDC-v1.txt"

MOBITC_Export_Rapport_Trace<-function(chem_mobitc,chemin_rep_travail,fichier_sque,fichier_trace,fichier_intersectionv1)
{
  
  library(rmarkdown)
 
  library(flexdashboard)
 
  library(rgdal)
  
  library(webshot)
 
  library(htmlwidgets)
  
  #type d'export
  export="png"
  
  # lecture des paramètres
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
  
  nomdirrapport=paste(chemin_rep_travail,"\\rapports",sep="")
  if (file.exists(nomdirrapport)=="FALSE"){dir.create(nomdirrapport)}
  
  #creation d'un fichier trace qui contient que les wls non NA
  
  fichier_evolution0=paste(substr(fichier_intersectionv1,1,nchar(fichier_intersectionv1)-4),"-toutesdates-MobiTC.txt",sep="")
  #lecture fichier evolution
  nom_evol=fichier_evolution0
  chem_evol=paste(chemin_rep_travail,"\\",nom_evol,sep="")
  print(chem_evol)
  ligneres0=read.table(chem_evol,sep="\t",header=TRUE,row.names = NULL)
  #ouverture du fichier trace
  Trace = readOGR(chemin_rep_travail,fichier_trace)
  #extrait des WLS non NA
  ligneWLS=ligneres0[which(!is.na(ligneres0$WLS)),]

  for (j in 1:nrow(ligneWLS))
  {
    print(j)
    if (length(Trace$Loc)>0)
    {
      if (is.numeric(ligneWLS$Loc[j])==TRUE)
      {
        Locj=as.character(formatC(as.numeric(ligneWLS$Loc[j]), width = 5, format = "d", flag = "0"))
      } else
      {
        Locj=ligneWLS$Loc[j]
      }
      Trace_extrait=subset(Trace,Trace$NAxe==ligneWLS$NAxe[j] & Trace$NTrace==ligneWLS$NTrace[j] & Trace$Loc==Locj)
      nloc=length(unique(Trace$Loc))
    }
    else
    {
      Trace_extrait=subset(Trace,Trace$NAxe==ligneWLS$NAxe[j] & Trace$NTrace==ligneWLS$NTrace[j])
      nloc=1
    }
    if (j==1)
    {
      traceR=Trace_extrait
      trace0=Trace_extrait
    }
    
    if (j>1)
    {
      #row.names(Trace_extrait)=as.character(as.numeric(row.names(Trace_extrait))+length(traceR))
      traceR=rbind(trace0,Trace_extrait)
      trace0=traceR
    }
  }
  
  #rajout d'une collone avec les rapports html
  traceR$html=paste0("rapports\\Rapport-MobiTC-","Loc",traceR$Loc,"-Naxe",traceR$NAxe, "-Ntrace", traceR$NTrace,".html")
  
  #export du fichier trace
  nom_exp_trace=paste0(fichier_trace,"-html")
  writeOGR(traceR, dsn=chemin_rep_travail, layer=nom_exp_trace, driver="ESRI Shapefile",overwrite_layer=TRUE)
  
  fichier_trace=nom_exp_trace
  for (iloc in 1 : nloc)
  {
    itemploc=which(tab$Loc ==unique(tab$Loc)[iloc])
    Nbaxe=length(unique(tab$NAxe[itemploc]))
    for (iaxe in 1 : Nbaxe)
    {
      itemp=which(tab$NAxe[itemploc] ==unique(tab$NAxe)[itemploc][iaxe])
      #calcul du nombre de trace
      NbTrace=length(unique(tab$NTrace[itemp]))
      for (itr in 1:NbTrace)
      {
        #extrait des valeurs du sque et de la trace
        NAxe=unique(tab$NAxe[itemploc])[iaxe]
        NTrace=unique(tab$NTrace[itemp])[itr]
        
        if (length(tab$Loc)>0)
        {
        Loc=unique(tab$Loc)[iloc]
        #Locc=as.character(formatC(as.numeric(Loci), width = 5, format = "d", flag = "0"))
        extraittab1=tab1[which(tab1$NAxe == NAxe & tab1$NTrace == NTrace & tab1$Loc == Loc),]
        } else {
          extraittab1=tab1[which(tab1$NAxe == NAxe & tab1$NTrace == NTrace),]
        }
        
        if (length(extraittab1$Distance)>1)
        {
          if (length(tab$Loc)>0)
          {
            if (is.numeric(Loc)==TRUE)
            {
              Loc=as.character(formatC(as.numeric(Loc), width = 5, format = "d", flag = "0"))
            }
            
          chem_rapport=paste0(chemin_rep_travail,"/rapports/Rapport-MobiTC-","Loc",Loc,"-Naxe",NAxe, "-Ntrace", NTrace,".html")
          #chem_rapport=paste0(chemin_rep_travail,"/rapports/Rapport-MobiTC-","Loc",Locc,"-Naxe",NAxe, "-Ntrace", NTrace,".html")
          } else {
            chem_rapport=paste0(chemin_rep_travail,"/rapports/Rapport-MobiTC-",nom_proj,"-Naxe",NAxe, "-Ntrace", NTrace, ".html")
            Loc=0
          }
          print(chem_rapport)
          # 
          # if (export=="vect")
          # {
          # chem_rmd=paste(chem_mobitc,"/Sous_Routine_MOBITC/Rivages_report_vect.Rmd",sep="")
          # params = list(chemin_rep_travail = chemin_rep_travail,chem_mobitc = chem_mobitc,fichier_sque=fichier_sque,fichier_intersectionv1=fichier_intersectionv1,fichier_trace=fichier_trace,NAxe=NAxe,NTrace=NTrace,Loc=Loci)
          # chem_logo=paste(chem_mobitc,"/Sous_Routine_MOBITC/logo_cerema_48.png",sep="")
          # rmarkdown::render(chem_rmd, params = params,output_file = chem_rapport,flex_dashboard(theme="cerulean",self_contained = TRUE,logo=chem_logo),encoding="UTF-8")
          # }
          
          if (export=="png")
          {
            chem_rmd=paste(chem_mobitc,"/Sous_Routine_MOBITC/Rivages_report_pngv2.Rmd",sep="")
            params = list(chemin_rep_travail = chemin_rep_travail,chem_mobitc = chem_mobitc,fichier_sque=fichier_sque,fichier_intersectionv1=fichier_intersectionv1,fichier_trace=fichier_trace,NAxe=NAxe,NTrace=NTrace,Loc=Loc)
           # chem_logo=paste(chem_mobitc,"/Sous_Routine_MOBITC/logo_cerema_48.png",sep="")
			      chem_logo=paste(chem_mobitc,"/Sous_Routine_MOBITC/Bloc-marque RF Cerema horizontal light.png",sep="")
            render(chem_rmd, params = params,output_file = chem_rapport,flex_dashboard(theme="cerulean",self_contained = TRUE,logo=chem_logo),encoding="UTF-8")
          }
      }
      }
    }
  }
  
  textexportrapport="Export fini"
  
  return(list(textexportrapport))
}

      