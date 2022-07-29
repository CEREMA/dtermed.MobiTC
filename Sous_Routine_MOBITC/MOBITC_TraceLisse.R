#verif utf-8
#version 18-12-2020
#réalisée par C Trmal Cerema

# dirr=R.home()
# chem_mobitc=paste(dirr,"/Cerema/MOBITC",sep="")
# chemin_rep_travail="C:\\R\\R-3.5.1\\Cerema\\MOBITC\\TARAVO4"
# fichier_trace="20190218T131915-nvx-Env-C010-T0250-Sque-C010-Tra-P50-L0200"
# gauss="9"

MOBITC_TraceLisse<-function(chem_mobitc,chemin_rep_travail,fichier_trace,gauss)
{
 
  library(rgdal)
 
  library(sp)
  
  #ouverture du fichier trace
  dsnlayer=chemin_rep_travail
  nomlayer=fichier_trace
  Trace=readOGR(dsnlayer, nomlayer)
  
  nom_exp_trace_lisse=paste0(nomlayer,"-lisse-filtre",gauss)
  
  #ecriture dans le fichier parametre
  fichier_init=paste(chem_mobitc,"/Init_Routine_MobiTC.txt",sep="")
  fid=file(fichier_init, open = "r+")
  lignes=readLines(fid)
  lignes[10]=nom_exp_trace_lisse
  cat(lignes,file=fid,sep="\n")
  close(fid)
  
  groupe=1
  Trace@data$Groupe=cbind(rep(1,length(Trace)))
  
  for (i in 2: length(Trace))
  {
    if (Trace@data$NAxe[i]==Trace@data$NAxe[i-1])
    {
      if (Trace@data$NTrace[i]==Trace@data$NTrace[i-1]+1)
      {
        Trace@data$Groupe[i]=groupe
      } else {
        groupe=groupe+1
        Trace@data$Groupe[i]=groupe
      }
    } else {
      groupe=groupe+1
      Trace@data$Groupe[i]=groupe
    }
  }
  
  for (i in 1: length(Trace))
  {
  UV=(Trace@lines[[i]]@Lines[[1]]@coords[2,]-Trace@lines[[i]]@Lines[[1]]@coords[1,])/sqrt((Trace@lines[[i]]@Lines[[1]]@coords[2,1]-Trace@lines[[i]]@Lines[[1]]@coords[1,1])^2+(Trace@lines[[i]]@Lines[[1]]@coords[2,2]-Trace@lines[[i]]@Lines[[1]]@coords[1,2])^2)
    Trace@data$U[i]=round(UV[1],digits=3)
    Trace@data$V[i]=round(UV[2],digits=3)
  }
  
  #filtre de Gauss par groupe
  
  nbgr=groupe
  Trace_lisse_data=data.frame()
  for (j in 1:nbgr)
  {
    Trace_data=data.frame(Trace@data)
    U=cbind(Trace_data[which (Trace_data$Groupe==j),]$U)
    V=cbind(Trace_data[which (Trace_data$Groupe==j),]$V)
    chemsource=paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Filtre_Gauss.R",sep="")
    source(chemsource)
    U_lisse=MOBITC_Filtre_Gauss(U,as.numeric(gauss))
    V_lisse=MOBITC_Filtre_Gauss(V,as.numeric(gauss))
    if (length(Trace$Loc)>0)
    {
      Trace_lisse_data=rbind(Trace_lisse_data,data.frame(NAxe=Trace_data[which (Trace_data$Groupe==j),]$NAxe,NTrace=Trace_data[which (Trace_data$Groupe==j),]$NTrace,Loc=Trace_data[which (Trace_data$Groupe==j),]$Loc,U_lisse=as.vector(U_lisse),V_lisse=as.vector(V_lisse)))
      
    }
    else
    {
      Trace_lisse_data=rbind(Trace_lisse_data,data.frame(NAxe=Trace_data[which (Trace_data$Groupe==j),]$NAxe,NTrace=Trace_data[which (Trace_data$Groupe==j),]$NTrace,U_lisse=as.vector(U_lisse),V_lisse=as.vector(V_lisse)))
      
    }
  }
  
  #creation des traces lissées
  ligne <- vector("list", length(Trace))
  coords_deb=data.frame()
  coords_end=data.frame()
  for (j in 1:length(Trace))
  {
    #trace de la terre vers la mer - Rotation autour du point du squelette
    Xmid=mean(Trace@lines[[j]]@Lines[[1]]@coords[,1])
    Ymid=mean(Trace@lines[[j]]@Lines[[1]]@coords[,2])
    LongT=sqrt((Trace@lines[[j]]@Lines[[1]]@coords[1,1]-Trace@lines[[j]]@Lines[[1]]@coords[2,1])^2+(Trace@lines[[j]]@Lines[[1]]@coords[1,2]-Trace@lines[[j]]@Lines[[1]]@coords[2,2])^2)
    Xdeb=Xmid-Trace_lisse_data$U_lisse[j]*LongT/2
    Ydeb=Ymid-Trace_lisse_data$V_lisse[j]*LongT/2
    
    Xend=Xmid+Trace_lisse_data$U_lisse[j]*LongT/2   
    Yend=Ymid+Trace_lisse_data$V_lisse[j]*LongT/2
    
    coords=rbind(cbind(Xdeb,Ydeb),cbind(Xend,Yend))
    ligne[[j]]=Lines(list(Line(coords)), ID=as.character(j))
    
    coords_deb=rbind(coords_deb,c(x=Xdeb,y=Ydeb))
    coords_end=rbind(coords_end,c(x=Xend,y=Yend))
  }
  
  tracelisse = SpatialLines(ligne)
  proj4string(tracelisse)=Trace@proj4string
  
  if (length(Trace$Loc)>0)
  {tab=Trace_lisse_data[,1:3]
  }
  else
  {
    tab=Trace_lisse_data[,1:2]
  }
  
  
  tracelisseshp = SpatialLinesDataFrame(tracelisse, data=tab)
  
  trace_lisse_ptsdeb=SpatialPoints(coords_deb, proj4string=Trace@proj4string)
  trace_lisse_ptsend=SpatialPoints(coords_end, proj4string=Trace@proj4string)
  trace_lisse_ptsdebshp=SpatialPointsDataFrame(trace_lisse_ptsdeb,data=tab)
  trace_lisse_ptsendshp=SpatialPointsDataFrame(trace_lisse_ptsend,data=tab)
  
  writeOGR(tracelisseshp, dsn=dsnlayer, layer=nom_exp_trace_lisse, driver="ESRI Shapefile",overwrite_layer=TRUE)
  
sortie="Le calcul est fini. Le début de la trace est en vert (côté terre) et la fin en rouge (côté mer)."

trace4326=spTransform(tracelisseshp, CRS("+init=epsg:4326"))

trace_lisse_ptsdeb4326=spTransform(trace_lisse_ptsdebshp, CRS("+init=epsg:4326"))
trace_lisse_ptsend4326=spTransform(trace_lisse_ptsendshp, CRS("+init=epsg:4326"))

return(list(sortie,trace4326,trace_lisse_ptsdeb4326,trace_lisse_ptsend4326))
}