# 
# chem_mobitc="C:\\R\\R-3.5.1\\Cerema\\MOBITC"
# #chemin_rep_travail="C:\\R\\R-3.3.2\\Cerema\\MOBITC\\Rivages"
# #fichier_sque="20180502T124233--Env-C010-T0250-Sque-C001v0_1_2"
# distrac=100
# fichier_sque="20190719T140404--Env-C010-T0250-T-Sque-C005Net-D0055.shp"
# fichier_sque="20190726T112606-toto-Env-C010-T0250-Sque-C001.shp"
# distrac=500
MOBITC_SqueRac2<-function(chem_mobitc,fichier_sque,distrac)
{
  if(!require(rgdal)){install.packages("rgdal")}
  library(rgdal)
  if(!require(rgeos)){install.packages("rgeos")}
  library(rgeos)
  if(!require(mapview)){install.packages("mapview")}
  library(mapview)
  
  fichier_init=paste(chem_mobitc,"\\Init_Routine_MobiTC.txt",sep="")
  fid=file(fichier_init, open = "r+")
  lignes=readLines(fid)
  chemin_rep_travail=lignes[2]
  close(fid)
  
  dsnlayer=chemin_rep_travail
  nomlayersque = substr(fichier_sque, 1, nchar(fichier_sque) - 4)
  print(nomlayersque)
  print(dsnlayer)
  Squelette0 = readOGR(dsnlayer,nomlayersque)
  
  #verif pour voir si les bouts sont déjà bien fusionnés
  Sque1=gLineMerge(Squelette0)
  print(length(Sque1))
  Sque1=disaggregate(Sque1)
  print(length(Sque1))
  Squelette1 = SpatialLinesDataFrame(Sque1, data=data.frame(sapply(slot(Sque1, 'lines'), function(x) slot(x, 'ID'))))
  #à virer par la suite
  #writeOGR(Squelette1, dsn=dsnlayer, layer=paste(fichier_sque,"_2",sep=""), driver="ESRI Shapefile",overwrite_layer=TRUE)
  
  Squelette1=Squelette0
  
  poly_axes=data.frame()
  for (j in 1:length(Squelette1))
  {
    poly_axes=rbind(poly_axes,cbind(rep(j,length(Squelette1@lines[[j]]@Lines[[1]]@coords)/2),Squelette1@lines[[j]]@Lines[[1]]@coords[,1],Squelette1@lines[[j]]@Lines[[1]]@coords[,2]))
  }
  
  i=1
  axe=1
  
  mcx0=max(poly_axes[,1])

  # for (j in 1:mcx0)
  # {
  #   i=1
  while (max(poly_axes[,1])>i)
  {
    nb0=which(poly_axes[,1]==i)
    dist=data.frame(matrix(nrow=max(poly_axes[,1]),ncol=3))
    if (length(nb0)>0)
    {
      poly_axes_i=poly_axes[nb0,]
      
      for (k in 1: max(poly_axes[,1]))
      {
        nb1=which(poly_axes[,1]==k)
        
        if (k-i==0 | length(nb1)==0)
        {
          dist[k,]=c(k,9999999,9999999)
        }
        else
        {
          poly_axes_k=poly_axes[nb1,]
          dist_temp=data.frame(matrix(nrow=4,ncol=1))
          dist_temp[1,1]=sqrt((abs(poly_axes_k[1,2]-poly_axes_i[1,2]))^2+(abs(poly_axes_k[1,3]-poly_axes_i[1,3]))^2)
          dist_temp[2,1]=sqrt((abs(poly_axes_k[length(poly_axes_k[,1]),2]-poly_axes_i[1,2]))^2+(abs(poly_axes_k[length(poly_axes_k[,1]),3]-poly_axes_i[1,3]))^2)
          dist_temp[3,1]=sqrt((abs(poly_axes_k[1,2]-poly_axes_i[length(poly_axes_i[,1]),2]))^2+(abs(poly_axes_k[1,3]-poly_axes_i[length(poly_axes_i[,1]),3]))^2)
          dist_temp[4,1]=sqrt((abs(poly_axes_k[length(poly_axes_k[,1]),2]-poly_axes_i[length(poly_axes_i[,1]),2]))^2+(abs(poly_axes_k[length(poly_axes_k[,1]),3]-poly_axes_i[length(poly_axes_i[,1]),3]))^2)
          a=min(dist_temp)
          b=which(dist_temp==min(dist_temp))
          dist[k,]=c(k,a,b)
        }  
      }
      a=min(dist[,2])
      b=which(dist[,2]==a)
      
      if (a<= distrac)
      {
        cas=dist[b,3]
        # ii=i
        # kk=dist[b,1]
        ii=min(dist[b,1],i)
        kk=max(dist[b,1],i)
        
        if (cas==1)
        {
          #inverse i
          nbi=which(poly_axes[,1]==ii)
          poly_axes[nbi,]=poly_axes[sort(nbi,decreasing = TRUE),]
          nbk=which(poly_axes[,1]==kk)
          poly_axes[nbk,1]=ii
        }
        
        if (cas==2)
        {
          
          # #pas d'inversion
          # nbk=which(poly_axes[,1]==kk)
          # poly_axes[nbk,1]=ii
          #inverse les 2
          nbi=which(poly_axes[,1]==ii)
          poly_axes[nbi,]=poly_axes[sort(nbi,decreasing = TRUE),]
          nbk=which(poly_axes[,1]==kk)
          poly_axes[nbk,]=poly_axes[sort(nbk,decreasing = TRUE),]
          poly_axes[nbk,1]=ii
        }
        
        if (cas==3)
        {
          #pas d'inversion
          nbk=which(poly_axes[,1]==kk)
          poly_axes[nbk,1]=ii
        }
        
        if (cas==4)
        {
          #inverse k
          nbk=which(poly_axes[,1]==kk)
          poly_axes[nbk,]=poly_axes[sort(nbk,decreasing = TRUE),]
          poly_axes[nbk,1]=ii
        }
      } else {
        i=i+1
        axe=axe+1
      }
    } else 
    {
      i=i+1
    }
  A=sort(poly_axes[,1],index.return=TRUE)
  poly_axes=poly_axes[A$ix,]
  }
  #fin du while
  
  #transformation de poly_axes en shp
  
  #ligne = vector(mode='list', length=length(unique(poly_axes[,1])))
  
  for (ij in seq(along=unique(poly_axes[,1])))
  {
    poly_axes_ij=poly_axes[which(poly_axes[,1]==unique(poly_axes[,1])[ij]),]
    pcrds=cbind(poly_axes_ij[,2],poly_axes_ij[,3])
    
    ligne=coords2Lines(pcrds, ID=as.character(ij))
    if (ij==1)
    {SP=ligne} else {SP=rbind(SP,ligne)}
    #mapview(ligne)
  }
  # mapview(SP)
  #SP = SpatialLines(ligne)
  proj4string(SP)=Squelette1@proj4string
  Squelette2=SpatialLinesDataFrame(SP, data=data.frame(ID=sapply(slot(SP, 'lines'), function(x) slot(x, 'ID'))))
  nom_exp_sque=paste(nomlayersque,"_lierR",sep="")
  writeOGR(Squelette2, dsn=dsnlayer, layer=paste(nomlayersque,"_lierR",sep=""), driver="ESRI Shapefile",overwrite_layer=TRUE)
  
  #ecriture dans le fichier parametre
  fichier_init=paste(chem_mobitc,"/Init_Routine_MobiTC.txt",sep="")
  fid=file(fichier_init, open = "r+")
  lignes=readLines(fid)
  lignes[8]=nom_exp_sque
  cat(lignes,file=fid,sep="\n")
  close(fid)
  
  sque4326=spTransform(Squelette2, CRS("+init=epsg:4326"))
  print("essai")
  sortie="calcul fini sque rac"
  
  return(list(sortie,sque4326))
}