# chem_mobitc = "C:\\R\\R-3.5.1\\Cerema\\MOBITC"
# chemin_rep_travail = "C:\\Mobitc_WACA\\Petite_Cote"
# 
# fichier_voro="voronoi"

MOBITC_Sque_net2<-function(chem_mobitc,chemin_rep_travail,fichier_voro)
{
  if(!require(rgdal)){install.packages("rgdal")}
  library(rgdal)
  # if(!require(deldir)){install.packages("deldir")}
  # library(deldir)
  if(!require(rgeos)){install.packages("rgeos")}
  library(rgeos)
  if(!require(stplanr)){install.packages("stplanr")}
  library(stplanr)
  
  #lecture dans le fichier parametre
  fichier_init=paste(chem_mobitc,"/Init_Routine_MobiTC.txt",sep="")
  fid=file(fichier_init, open = "r")
  lignes=readLines(fid)
  nomlayerenv=lignes[6]
  nom_exp_sque=lignes[8]
  close(fid)
  
  
  pascoup=as.numeric(substr(nom_exp_sque,nchar(nom_exp_sque)-2,nchar(nom_exp_sque)))
  
  
  dsnlayer=chemin_rep_travail
  print(nomlayerenv)
  print(dsnlayer)
  Enveloppe = readOGR(dsnlayer,nomlayerenv)
  
  sauve=0
  #########################################
  rayon=cbind(1,0.9,0.8,0.7,0.65,0.65,0.65,0.65,0.65,0.65,0.65,0.65,0.65,0.65,0.65,0.65,0.65,0.65,0.65,0.65,0.65,0.65,0.65,0.65)
  npointC=16
  
    squebrut=readOGR(dsnlayer,fichier_voro)
    SP=SpatialLines(squebrut@lines)
    proj4string(SP)=squebrut@proj4string
    
    # nombre de seg
    nbseg=0
    for (j in 1 : length(SP))
    {
      nbseg=nbseg+length(SP@lines[[j]]@Lines[[1]]@coords[,1])-1
    }
    
    ligne = vector(mode='list', length=nbseg)
    nbsegi=1
    for (j in 1 : length(SP))
    {
      for (ic in 1:(length(SP@lines[[j]]@Lines[[1]]@coords[,1])-1))
      {
        pcrds=rbind(cbind(SP@lines[[j]]@Lines[[1]]@coords[ic,1],SP@lines[[j]]@Lines[[1]]@coords[ic,2]),
                    cbind(SP@lines[[j]]@Lines[[1]]@coords[ic+1,1],SP@lines[[j]]@Lines[[1]]@coords[ic+1,2]))
        ligne[[nbsegi]]=Lines(list(Line(pcrds)), ID=as.character(nbsegi))
        nbsegi=nbsegi+1
      }
    }
    SPeclat = SpatialLines(ligne)
    proj4string(SPeclat)=squebrut@proj4string
    
    # Travail par enveloppe
    isque=0
for (ienv in 1 : length(Enveloppe))
    {
      print(paste("Suppression segment hors Enveloppe n", as.character(ienv)))
      
    envi=SpatialPolygons (Enveloppe@polygons[ienv])
    proj4string(envi)=Enveloppe@proj4string      
    SP=SPeclat
    # récupération des segments contenus dans l'enveloppe
    nb=which(gContains(envi,SP,byid=TRUE)==TRUE)
    SP=SP[nb]
    
    #suppression des doublons
    print(paste("Suppression doublons", as.character(ienv)))
    
    if (length(SP)>0)
    {
      coord_ligne=data.frame()
    for (j in 1 : length(SP))
    {
      coord_ligne=rbind(coord_ligne, c(SP@lines[[j]]@Lines[[1]]@coords[1,1],SP@lines[[j]]@Lines[[1]]@coords[1,2],
                                       SP@lines[[j]]@Lines[[1]]@coords[2,1],SP@lines[[j]]@Lines[[1]]@coords[2,2])) 
    }
    
    coord_ligne_inv=data.frame(a=coord_ligne[,3],b=coord_ligne[,4],c=coord_ligne[,1],d=coord_ligne[,2])
    A=data.frame(a=coord_ligne[,1],b=coord_ligne[,2],c=coord_ligne[,3],d=coord_ligne[,4])

    tosupp=data.frame()
    for (j in 1:length(A[,1]))
    {
      nb=which(A$c==A$a[j] & A$d==A$b[j] & A$a==A$c[j] & A$b==A$d[j])
      if (length(nb)>0)
      {
        if (nb>j)
        {
          tosupp=rbind(tosupp,nb)
        }
      }
    }
    
    coord_ligne1=A[-tosupp[,1],]
    lignebis = vector(mode='list', length=length(coord_ligne1[,1]))
    
    for (j in 1 : length(coord_ligne1[,1]))
    {
      pcrds=rbind(cbind(coord_ligne1[j,1],coord_ligne1[j,2]),
                  cbind(coord_ligne1[j,3],coord_ligne1[j,4]))
      lignebis[[j]]=Lines(list(Line(pcrds)), ID=as.character(j))
    }
    SPpurge = SpatialLines(lignebis)
    proj4string(SPpurge)=squebrut@proj4string   
  
    SPpurge=gLineMerge(SPpurge)
    #désagrégation
    print(length(SPpurge))
    SPpurge=disaggregate(SPpurge)
    print(length(SPpurge))
    
    SP=SPpurge
    
    
    # boucle pour supprimer les extrémités par des cercles
    rempli=1
    tour=0
    while (rempli==1)
      {
      tour=tour+1
      print(paste("Tour de nettoyage n°",as.character(tour)))
      #nettoyer cercle sur extrémité...
      #fusion des lignes  
      print(length(SP))
      if (length(SP)>0)
        {
          SP=gLineMerge(SP)
          #désagrégation
          print(length(SP))
          SP=disaggregate(SP)
          print(length(SP))
          
          if (sauve!=0) {
            voronoiline = SpatialLinesDataFrame(SP, data=data.frame(sapply(slot(SP, 'lines'), function(x) slot(x, 'ID'))))
            print(paste("Export Squelette n° ", as.character(ienv),"tour n°",as.character(tour)))
            writeOGR(voronoiline, dsn=dsnlayer, layer=paste("SqueletteR_",as.character(ienv),"_",as.character(tour),sep=""), driver="ESRI Shapefile",overwrite_layer=TRUE)
          }
        
		  # Bug s'il n'y a qu'un segment!
		  rempli=0
		  inc=0
		  asupp=NULL
		  #pb si plusieurs morceaux
			if (length(SP)>1)
  			{        
    			long=gLength(SP)
    			tol=10
    			if (long<100)
    			{          
    			tol=long-1
    			}
  			reseau=SpatialLinesNetwork(SP,tolerance=tol)
  		
        
			# Création des mini-cercles
			for (ires in 1:length(reseau@nb))
			{
			  # Récupération des axes finaux
			  if (length(reseau@nb[[ires]])==1){
				inc=inc+1
				
				ligne=SP[reseau@nb[[ires]]]@lines[[1]]@Lines[[1]]@coords
				Xdeb=ligne[1,1]
				Ydeb=ligne[1,2]
				Xfin=ligne[dim(ligne)[1],1]
				Yfin=ligne[dim(ligne)[1],2]
				dist=((Xfin-Xdeb)^2+(Yfin-Ydeb)^2)^0.5
				coefB=dist/2*rayon[tour]
				crds=cbind((Xdeb+Xfin)/2 + coefB*cos(seq(0,2*pi,length.out = npointC)),(Ydeb+Yfin)/2 + coefB*sin(seq(0,2*pi,length.out = npointC)))
				
				# Création d'un polygones
				Pa <- Polygon (crds)
				Psa <- Polygons (list ( Pa ), inc)
				pola <- SpatialPolygons (list ( Psa ))
				proj4string(pola)=Enveloppe@proj4string 
				tableau <- data.frame(IDENT = inc, row.names = inc)
				
				SPDFa <- SpatialPolygonsDataFrame(pola, tableau)
				
				if (inc==1)
				{
				  SPDFb=SPDFa
				  SPDF=SPDFa
				}
				if (inc>1)
				{
				  SPDF=rbind(SPDFb,SPDFa)
				  SPDFb=SPDF
				}
				
				nb=which(gContains(envi,pola,byid=TRUE)==TRUE)
				if (length(nb)>0)
				{
				  if (nb==1)
				  {
					if (rempli==0){
					  asupp=reseau@nb[[ires]]
					  rempli=1
					}else{
					  asupp=cbind(asupp,reseau@nb[[ires]])
					}
				  }
				}
			  }
			}
  		}#fin du for
        
		}else{
				rempli=0
		}
      
      print("On ne garde que les bons")
      if (length(asupp)>0)
      {SP=SP[-asupp]}
      
      if (sauve!=0) {
        writeOGR(SPDF, dsn=dsnlayer, layer=paste("SqueletteR_",as.character(ienv),"_",as.character(tour),'_Cercle',sep=""), driver="ESRI Shapefile",overwrite_layer=TRUE)
        plot(SP)
      }
    } #fin du while
    
    #fusion des lignes  
    print(length(SP))
    SP=gLineMerge(SP)
    #désagrégation
    print(length(SP))
    SP=disaggregate(SP)
    print(length(SP))
    
    #dernière vérif et suppression des derniers petits bouts à 4 sommets
    tosupp2=data.frame()
    for (jjj in 1 : length(SP))
    {
      nbsommet=length(SP@lines[[jjj]]@Lines[[1]]@coords[,1])
      if (nbsommet<5)
      {
        tosupp2=rbind(tosupp2,jjj)
      }
    }
    
    
    
    if (nrow(tosupp2)!=0)
    {
    SP=SP[-tosupp2[,1],]
    print(length(SP))
    SP=gLineMerge(SP)
    #désagrégation
    print(length(SP))
    SP=disaggregate(SP)
    print(length(SP))
    }
    
    #dernière vérif et suppression des jonctions à 3 morceaux
    tokeep=data.frame()
    Extremite=data.frame()
      for (e in 1 : length(SP))
      {
      nbpts=length(SP@lines[[e]]@Lines[[1]]@coords[,1])
      Extremite=rbind(Extremite, c(e,nbpts,SP@lines[[e]]@Lines[[1]]@coords[1,1],SP@lines[[e]]@Lines[[1]]@coords[1,2]),
                                 c(e,nbpts,SP@lines[[e]]@Lines[[1]]@coords[nbpts,1],SP@lines[[e]]@Lines[[1]]@coords[nbpts,2])) 
      }
    AA=cbind(Extremite[,3],Extremite[,4])
    B=duplicated(AA)
    if (length(B)>0)
    {
      nb=which(B==TRUE)
      if (length(nb)>0)
      {
        for (ee in 1:length(nb))
        {
          nba=which(Extremite[,3]==Extremite[nb[ee],3])
          tokeep=rbind(tokeep,Extremite[nba[which(Extremite[nba,2]==max(Extremite[nba,2]))],1])
        }
      }
    }
    tokeep=unique(tokeep)
    if (length(tokeep>0))
    {
      print("suppression de mcx")
    SP=SP[tokeep[,1]]
    }
    
    # Vérification que les squelettes ne soient pas trop petits
    boite=SP@bbox[,2]-SP@bbox[,1]
		if ((boite[1]^2+boite[2]^2)^0.5>pascoup)
		{
		  isque=isque+1
		  #voronoiline = SpatialLinesDataFrame(SP, data=data.frame(sapply(slot(SP, 'lines'), function(x) slot(x, 'ID'))))
		  pid <- sapply(slot(SP, "lines"), function(x) slot(x, "ID"))
		  p.df <- data.frame( ID=1:length(SP), row.names = pid) 
		  voronoiline = SpatialLinesDataFrame(SP,p.df)
		  voronoiline@data=cbind(voronoiline@data,ienv)
		  colnames(voronoiline@data)=cbind("IDENT","Enveloppe")
		  
		  if (sauve!=0) {
		  print(paste("Export Squelette n° ", as.character(ienv),"tour n°",as.character(tour)))
		  writeOGR(voronoiline, dsn=dsnlayer, layer=paste("SqueletteR_",as.character(ienv),"_",as.character(tour),sep=""), driver="ESRI Shapefile",overwrite_layer=TRUE)
		  }
		  
		  
		  if (isque==1)
		  {
		    SLDFb=SP
		    SLDF=SP
		  }
		  if (isque>1)
		  {
		    row.names(SP)=as.character(as.numeric(row.names(SP))+length(SLDF))
		    SLDF=rbind(SLDFb,SP)
		    SLDFb=SLDF
		  }
		}
    
    
    
  }#fin length(SP)>0
  }#fin de l'enveloppe
    print("Export Squelette fINAL")
    SLDF=disaggregate(gLineMerge(SLDF))
    SLDFF = SpatialLinesDataFrame(SLDF, data=data.frame(sapply(slot(SLDF, 'lines'), function(x) slot(x, 'ID'))))
    ###############
    names(SLDFF)[1] <- "NAxe"
    writeOGR(SLDFF, dsn=dsnlayer, layer=nom_exp_sque, driver="ESRI Shapefile",overwrite_layer=TRUE)
    ####################
    texte="calcul fini"
    
    sque4326=spTransform(SLDFF, CRS("+init=epsg:4326"))
    
    return(list(texte,sque4326))
}