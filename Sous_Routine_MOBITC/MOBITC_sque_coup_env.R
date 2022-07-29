#verif utf-8
#version 18-12-2020
#réalisée par C Trmal Cerema

# chem_mobitc = "C:\\R\\R-3.5.1\\Cerema\\MOBITC"
# chemin_rep_travail = "C:\\Mobitc_WACA\\Petite_Cote"
# 
# #chemin_rep_travail = "C:\\0_ENCOURS\\MOBITC_hotline\\Tuto_MOBITCR"
# # # 
# # fichier_env="SPpts"
# fichier_env="20190726T112606-toto-Env-C010-T0250"
# distcoupsque=1

# # 
MOBITC_sque_coup_env<-function(chem_mobitc,chemin_rep_travail,fichier_env,distcoupsque)
{
 
  library(rgdal)
  
  library(rgeos)
  
  dsnlayer=chemin_rep_travail
  nomlayerenv=fichier_env
  print(nomlayerenv)
  print(dsnlayer)
  Enveloppe = readOGR(dsnlayer,nomlayerenv)
  
  #Enveloppe=gBuffer(Enveloppe,width=distcoupsque)
 pascoup=distcoupsque
 Enveloppe=disaggregate(Enveloppe)
  
  nom_exp_sque=paste(fichier_env,"-Sque-C",as.character(formatC(pascoup, width = 3, format = "d", flag = "0")),sep="")
  nomlayersque=nom_exp_sque
  
  #ecriture dans le fichier parametre
  fichier_init=paste(chem_mobitc,"/Init_Routine_MobiTC.txt",sep="")
  fid=file(fichier_init, open = "r+")
  lignes=readLines(fid)
  lignes[6]=nomlayerenv
  lignes[8]=nom_exp_sque
  cat(lignes,file=fid,sep="\n")
  close(fid)
  
  pascoup=as.numeric(substr(nom_exp_sque,nchar(nom_exp_sque)-2,nchar(nom_exp_sque)))
  
  pts=data.frame()
  
  for (ienv in 1 : length(Enveloppe))
    {
      print(paste("Enveloppe n°", as.character(ienv)))
      crds=Enveloppe@polygons[[ienv]]@Polygons[[1]]@coords
      
      #couper l'enveloppe: 1/5 de la résolution donne qqch de bien souvent
      print(paste("coupure Enveloppe n°", as.character(ienv)))
      crdscoup=crds[1,]
      #crdscoup=crds
      for (itour in 2:dim(crds)[1]){
        #print(itour)
        dista=((crds[itour,1]-crds[itour-1,1])^2+(crds[itour,2]-crds[itour-1,2])^2)^0.5
        ncoup=round((dista+0.49*pascoup)/pascoup,0)
        if (ncoup>0)
        {
          sequ=seq(1/(ncoup), 1, length.out = ncoup)
          crdscoup=rbind(crdscoup,cbind(crds[itour-1,1]+sequ*(crds[itour,1]-crds[itour-1,1]),crds[itour-1,2]+sequ*(crds[itour,2]-crds[itour-1,2])))
        }
        
      }
      pts = rbind(pts, crdscoup)
  }
  pts=cbind(pts[,1]+runif(dim(pts)[1])*pascoup/10000,pts[,2]+runif(dim(pts)[1])*pascoup/10000)
  SPpts <- SpatialPoints(coords = pts)
  proj4string(SPpts)=Enveloppe@proj4string
  SPFpts = SpatialPointsDataFrame(SPpts, data=data.frame(rep(1,length(SPpts))))
  writeOGR(SPFpts, dsn=dsnlayer, layer=paste("Points_env"), driver="ESRI Shapefile",overwrite_layer=TRUE)
  
  texte=div(h3("Manipulations"),
               p("Suite à un problème de mise à jour dans un package R la création de la ligne de base ne peut pas se faire entièrement dans R.
                 Une solution temporaire a été trouvée en s'appuyant que Qgis"),
               p("Le fichier Points_env.shp vient d'être exporté dans le réprtoire de travail. Il faut suivre rigoureusement les étapes suivantes :"),
               p("1 - ouvrir Qgis"),
          p("2 - ouvrir le fichier Points_env.shp"),
          p("3 - aller dans le menu Vecteur, puis Outils de géométrie, puis Polygones de Voronoi..."),
          p("4 - dans la fenêtre Polygones de Voronoi, choisir comme couche d'entrée : Points_env, mettre 10 en Zone tampon, puis Exécuter. Le calcul peut être long. Quand le calcul est fini
                les polygones s'affichent à l'écran."),
          p("5 - aller dans le menu Vecteur, puis Outils de géométrie, puis Polygones vers lignes"),
          p("6 - dans la fenêtre Polygones vers lignes, choisir comme couche d'entrée : Polygones de Voronoi, puis Exécuter. Quand le calcul est fini
                les polylignes s'affichent à l'écran."),
          p("7 - exporter la couche Lignes au format ESRI shapefile la renommant voronoi dans le répertoire de travail."),
          p("Attention à la projection, celle-ci doit être identique aux traits de côte."),
          p("Cette étape est finie, il convient de passer au menu Création du squelette de MobiTC.")
  )

  return(list(texte))
}