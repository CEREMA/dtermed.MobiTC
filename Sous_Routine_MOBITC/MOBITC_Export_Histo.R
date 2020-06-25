# chemin_rep_travail="C:\\0_ENCOURS\\TPM\\Erosion\\MobiTC"
# dirr=R.home()
# chem_mobitc=paste(dirr,"/Cerema/MOBITC",sep="")
# fichier_trace="20190517T152421-TPM-Sque-cont-Tra-P50-L0100sel-lisse-filtre3-mod"
# fichier_mobitc="20190517T152421-TPM-Sque-cont-Tra-P50-L0100sel-lisse-filtre3-mod-IntersTDC-v1-MobiTC.txt"
largeur_histo=30
longueur_histo=150
tronqu_histo=1.5
taux_histo=c("WLS")
fichier_mobitc="Sque_TPM_2154-Tra-P50-L0050b-IntersTDC-v1-toutesdates-MobiTC.txt"
fichier_mobitc="Sque_TPM_2154-Tra-P50-L0050b-IntersTDC-v1-post1950-MobiTC.txt"
fichier_mobitc="Sque_TPM_2154-Tra-P50-L0050b-IntersTDC-v1-post2000-MobiTC.txt"
fichier_mobitc="Sque_TPM_2154-Tra-P50-L0050b-IntersTDC-v1-post2010-MobiTC.txt"

MOBITC_Export_Histo<-function(chem_mobitc,chemin_rep_travail,fichier_trace,fichier_mobitc,largeur_histo,longueur_histo,tronqu_histo,taux_histo)
{
  
  if(!require(sp)){install.packages("sp")}
  library(sp)
  if(!require(rgdal)){install.packages("rgdal")}
  library(rgdal)
  
  #ouverture du fichier trace
  dsnlayer=chemin_rep_travail
  Trace = readOGR(dsnlayer,fichier_trace)
  
   for (i in 1:length(fichier_mobitc))
  {
  
  #lecture du fichier résultat MobiTC
  chem_resultat=paste0(chemin_rep_travail,"\\",fichier_mobitc[i])
  print(chem_resultat)
  tab=read.table(chem_resultat,sep="\t",header=TRUE,row.names = NULL)
 
  
  for (j in 1:length(taux_histo))
  {
    
    #nom export histo
    nom_export=paste0(substr(fichier_mobitc[i],1,nchar(fichier_mobitc[i])-10),"histo-",taux_histo[j])
    coltab=which(colnames(tab) == taux_histo[j])
    taux0=tab[,coltab]
    tab=tab[which(!is.na(taux0)),]
    rownames(tab) <- 1:nrow(tab)
    taux=tab[,coltab]
    ini=0
    ID=1
    for (i in 1:nrow(tab))
    {
      X1=tab$Xsque[i]+tab$V[i]*largeur_histo/2
      Y1=tab$Ysque[i]-tab$U[i]*largeur_histo/2
      X2=tab$Xsque[i]-tab$V[i]*largeur_histo/2
      Y2=tab$Ysque[i]+tab$U[i]*largeur_histo/2
      
      if (is.na(taux[i]))
      {
        X3=X2+tab$U[i]*10
        Y3=Y2+tab$V[i]*10
        X4=X1+tab$U[i]*10
        Y4=Y1+tab$V[i]*10
      }
      else
      {
        if (abs(taux[i])>tronqu_histo) {
          X3=X2+tab$U[i]*longueur_histo*tronqu_histo*taux[i]/abs(taux[i])
          Y3=Y2+tab$V[i]*longueur_histo*tronqu_histo*taux[i]/abs(taux[i])
          X4=X1+tab$U[i]*longueur_histo*tronqu_histo*taux[i]/abs(taux[i])
          Y4=Y1+tab$V[i]*longueur_histo*tronqu_histo*taux[i]/abs(taux[i])
          #5e point pour la fleche
          X5=tab$Xsque[i]+tab$U[i]*1.1*longueur_histo*tronqu_histo*taux[i]/abs(taux[i])
          Y5=tab$Ysque[i]+tab$V[i]*1.1*longueur_histo*tronqu_histo*taux[i]/abs(taux[i])
          
          x_coord=c(X1,X2,X3,X5,X4,X1)
          y_coord=c(Y1,Y2,Y3,Y5,Y4,Y1)
          xym <- cbind(x_coord, y_coord)
          
        } else {
          X3=X2+tab$U[i]*longueur_histo*taux[i]
          Y3=Y2+tab$V[i]*longueur_histo*taux[i]
          X4=X1+tab$U[i]*longueur_histo*taux[i]
          Y4=Y1+tab$V[i]*longueur_histo*taux[i]
          
          x_coord=c(X1,X2,X3,X4,X1)
          y_coord=c(Y1,Y2,Y3,Y4,Y1)
          xym <- cbind(x_coord, y_coord)
          
        }
      }

      p = Polygon(xym)
      ps = Polygons(list(p),ID = ID)
      sps = SpatialPolygons(list(ps))
      proj4string(sps) =Trace@proj4string
      #plot(sps)
      data=tab[i,]
      SPDFj = SpatialPolygonsDataFrame(sps,data)
      ID = ID + 1
      
      if (ini == 0)
      {
        SPDF = SPDFj
        ini = 1
      } else {
        SPDF = rbind(SPDF, SPDFj)
      }
    }
    writeOGR(SPDF,dsn = dsnlayer,layer = nom_export,driver = "ESRI Shapefile",overwrite_layer = TRUE)
  }
  }
  
  textexporthisto="Export fini"
  
  return(list(textexporthisto))
}