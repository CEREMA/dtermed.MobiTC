
# 
# dirr=R.home()
# chem_mobitc=paste(dirr,"/Cerema/MOBITC",sep="")
# chemin_rep_travail="C:\\R\\R-3.3.2\\Cerema\\MOBITC\\TARAVO2"
# fichier_squef="20180124T111059--Env-C010-T0250-Sque-C001"
# 
# chem_squef=paste(chemin_rep_travail,"\\",fichier_squef,sep="")
# disttrace=200
# longtrace=500

MOBITC_Trace<-function(chem_mobitc,chemin_rep_travail,fichier_squef,disttrace,longtrace)
{
  if(!require(rgdal)){install.packages("rgdal")}
  library(rgdal)
  if(!require(sp)){install.packages("sp")}
  library(sp)
  
  print(fichier_squef)
  #chemNomRastinit <- choose.files(caption="Selection des rasters")
  #print(chemNomRastinit)
  dsnlayer=chemin_rep_travail
  nomlayer=fichier_squef
  #nomlayer=substr(basename(fichier_squef),1,nchar(basename(fichier_squef))-4)
  print(dsnlayer)
  print(nomlayer)
  sque=readOGR(dsnlayer, nomlayer)
  
  nom_exp_trace=paste(fichier_squef,"-Tra-P",as.character(disttrace),"-L",as.character(formatC(longtrace, width = 4, format = "d", flag = "0")),sep="")
  #ecriture dans le fichier parametre
	fichier_init=paste(chem_mobitc,"/Init_Routine_MobiTC.txt",sep="")
	fid=file(fichier_init, open = "r+")
	lignes=readLines(fid)
	lignes[10]=nom_exp_trace
	cat(lignes,file=fid,sep="\n")
	close(fid)

  for (i in 1 : length(sque))
    {
      print(paste("Axe n°", as.character(i)))
      xy=sque@lines[[i]]@Lines[[1]]@coords
      dx <- c(0,diff(xy[,1]))
      dy <- c(0,diff(xy[,2]))
      dseg <- sqrt(dx^2+dy^2)
      dtotal <- cumsum(dseg)
      linelength = sum(dseg)
      pos = seq(disttrace/2,linelength, by=disttrace)
      whichseg = unlist(lapply(pos, function(x){sum(dtotal<=x)}))
      pos=data.frame(pos=pos,whichseg=whichseg,
                      x0=xy[whichseg,1],
                      y0=xy[whichseg,2],
                      dseg = dseg[whichseg+1],
                      dtotal = dtotal[whichseg],
                      x1=xy[whichseg+1,1],
                      y1=xy[whichseg+1,2]
                     )
      pos$further = pos$pos - pos$dtotal
      pos$f = pos$further/pos$dseg
      pos$x = pos$x0 + pos$f * (pos$x1-pos$x0)
      pos$y = pos$y0 + pos$f * (pos$y1-pos$y0)
      pos$theta = atan2(pos$y0-pos$y1,pos$x0-pos$x1)
      pos=pos[,c("x","y","x0","y0","x1","y1","theta")]
      pos$thetaT = pos$theta+pi/2
      dl = longtrace*cos(pos$thetaT)
      dL = longtrace*sin(pos$thetaT)
      transect=data.frame(x0 = pos$x - dl,
                   y0 = pos$y - dL,
                   x1 = pos$x + dl,
                   y1 = pos$y + dL)
      
      ligne = vector(mode='list', length=length(transect$x0))
      
      for (j in 1:length(transect$x0))
        {
        coords=rbind(cbind(transect$x0[j],transect$y0[j]),cbind(transect$x1[j],transect$y1[j]))
        ligne[[j]]=Lines(list(Line(coords)), ID=as.character(j))
      }
      traceini = SpatialLines(ligne)
      proj4string(traceini)=sque@proj4string
      tab=data.frame(
             NAxe=rep(i,length(transect$x0)),
             NTrace=seq(1,length(transect$x0)))
             
      trace = SpatialLinesDataFrame(traceini, data=tab)
      
      if (i==1)
      {
        traceR=trace
        trace0=trace
      }
      
      if (i>1)
      {
        row.names(trace)=as.character(as.numeric(row.names(trace))+length(traceR))
        traceR=rbind(trace0,trace)
        trace0=traceR
      }
      
  }
  
	coords_deb=data.frame()
	coords_end=data.frame()
	for (j in 1:length(traceR))
	{
	  #trace de la terre vers la mer
	  Xdeb=traceR@lines[[j]]@Lines[[1]]@coords[1,1]
	  Ydeb=traceR@lines[[j]]@Lines[[1]]@coords[1,2]
	  Xend=traceR@lines[[j]]@Lines[[1]]@coords[2,1] 
	  Yend=traceR@lines[[j]]@Lines[[1]]@coords[2,2]
	  
	  coords_deb=rbind(coords_deb,c(x=Xdeb,y=Ydeb))
	  coords_end=rbind(coords_end,c(x=Xend,y=Yend))
	}
	
	trace_ptsdeb=SpatialPoints(coords_deb, proj4string=traceR@proj4string)
	trace_ptsend=SpatialPoints(coords_end, proj4string=traceR@proj4string)
	
  writeOGR(traceR, dsn=dsnlayer, layer=nom_exp_trace, driver="ESRI Shapefile",overwrite_layer=TRUE)
  
#modification de la projection pour affichage google  

  texte="calcul fini trace"

  trace4326=spTransform(traceR, CRS("+init=epsg:4326"))
  sque4326=spTransform(sque, CRS("+init=epsg:4326"))
  trace_ptsdeb4326=spTransform(trace_ptsdeb, CRS("+init=epsg:4326"))
  trace_ptsend4326=spTransform(trace_ptsend, CRS("+init=epsg:4326"))
  
return(list(texte,sque4326,trace4326,trace_ptsdeb4326,trace_ptsend4326))
}