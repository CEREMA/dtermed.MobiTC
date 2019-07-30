#Mobitc ligne de base
#namze # choix des tdc au format shp
# 

# chem_mobitc = "C:\\R\\R-3.5.1\\Cerema\\MOBITC"
# 
# chemin_rep_travail = "C:\\Mobitc_WACA\\Petite_Cote"
# #chemNomTDCinit <- choose.files(caption="Selection des traits de cote")
# distcoup = 10
# disttri = 250
# nom_projet = "Tutorll"
# NomTDCinit = rbind(
#   "tdc_ancien_petite_cote_brut_MobiTC.shp",
#   "tdc_recent_petite_cote_brut_MobiTC.shp")
# #NomTDCinit=basename(chemNomTDCinit)
# export_tri = 0

MOBITC_Enveloppe <-
  function(chem_mobitc,
           chemin_rep_travail,
           NomTDCinit,
           distcoup,
           disttri,
           nom_projet,
           export_tri
  )
  {
    if(!require(sp)){install.packages("sp")}
    library(sp)
    if(!require(rgeos)){install.packages("rgeos")}
    library(rgeos)
    if(!require(rgdal)){install.packages("rgdal")}
    library(rgdal)
    #library(deldir)
    if(!require(tripack)){install.packages("tripack")}
    library(tripack)
    if(!require(maptools)){install.packages("maptools")}
    library(maptools)
    #library(cleangeo)
    
    dsnlayer = chemin_rep_travail
    
    #nom export de l'enveloppe automatique
    dateenv = as.character.Date(Sys.time())
    dateenv = gsub("-", "", dateenv)
    dateenv = gsub(":", "", dateenv)
    dateenv = gsub(" ", "T", dateenv)
    nom_exp_env = paste(
      dateenv,
      '-',
      nom_projet,
      '-Env-C',
      as.character(formatC(
        distcoup,
        width = 3,
        format = "d",
        flag = "0"
      )),
      '-T',
      as.character(formatC(
        disttri,
        width = 4,
        format = "d",
        flag = "0"
      )),
      sep = ""
    )
    
    #ecriture dans le fichier parametre
    fichier_init = paste(chem_mobitc, "/Init_Routine_MobiTC.txt", sep = "")
    fid = file(fichier_init, open = "r+")
    lignes = readLines(fid)
    lignes[4] = nom_projet
    lignes[6] = nom_exp_env
    cat(lignes, file = fid, sep = "\n")
    close(fid)
    
    # tdc=""
    #chemNomTDCinit <- choose.files(caption="Selection des traits de cote",multi=TRUE)
    #NomTDCinit=basename(chemNomTDCinit)
    NomTDC = substr(NomTDCinit, 1, nchar(NomTDCinit) - 4)
    
    
    ##coupure des tdc
    for (i in 1:length(NomTDCinit))
    {
      tdci = readOGR(dsnlayer, layer = NomTDC[i])
      for (kk in 1:length(tdci))
      {
        dist = 0
        for (k in 1:(length(tdci@lines[[kk]]@Lines[[1]]@coords) / 2 - 1))
        {
          dist = dist + sqrt((
            tdci@lines[[kk]]@Lines[[1]]@coords[k + 1, 1] - tdci@lines[[kk]]@Lines[[1]]@coords[k, 1]
          ) ^ 2 + (
            tdci@lines[[kk]]@Lines[[1]]@coords[k + 1, 2] - tdci@lines[[kk]]@Lines[[1]]@coords[k, 2]
          ) ^ 2
          )
          #print(dist)
        }
        nodecoordtdci = tdci@lines[[kk]]@Lines[[1]]@coords
        nbptscoup = floor(dist / distcoup)
        if (nbptscoup > 1)
        {
          ptstdci = spsample(tdci@lines[[kk]], nbptscoup, type = "regular")
          ptscoordtdci = ptstdci@coords
          if (i == 1 & kk == 1)
          {
            pts = rbind(nodecoordtdci, ptscoordtdci)
          } else {
            pts = rbind(pts, nodecoordtdci, ptscoordtdci)
          }
        } else {
          if (i == 1 & kk == 1)
          {
            pts = nodecoordtdci
          } else {
            pts = rbind(pts, nodecoordtdci)
          }
        }
      }
    }
    ptstdc1 <- SpatialPoints(coords = pts)
    
    #suppression des doublons
    ptstdc = ptstdc1
      #remove.duplicates(ptstdc1)
    
    
    #triangularisation
    
    trinoeuds = tri.mesh(ptstdc$coords.x1, ptstdc$coords.x2,duplicate="remove")
    tri = triangles(trinoeuds)
    ini = 0
    ID = 0
    
    for (j in 1:length(tri[, 1]))
    {
      if ((j/1000)%%1==0) {print(paste(j,"/",length(tri[, 1])))}
      coordspoly = cbind(trinoeuds$x[tri[j, 1:3]], trinoeuds$y[tri[j, 1:3]])
      coordspoly= rbind(coordspoly,coordspoly[1,])
      distance = cbind(sqrt((coordspoly[2, 1] - coordspoly[1, 1]) ^ 2 + (coordspoly[2, 2] -
                                                                           coordspoly[1, 2]) ^ 2
      ), sqrt((coordspoly[3, 1] - coordspoly[2, 1]) ^ 2 + (coordspoly[3, 2] -
                                                             coordspoly[2, 2]) ^ 2
      ), sqrt((coordspoly[3, 1] - coordspoly[1, 1]) ^ 2 + (coordspoly[3, 2] -
                                                             coordspoly[1, 2]) ^ 2
      ))
      if (distance[1] > disttri |
          distance[2] > disttri | distance[3] > disttri)
      {
        triok = 0
      } else {
        triok = 1
        ID = ID + 1
        Pl <- Polygon(coordspoly)
        Pls <- Polygons(list(Pl), ID = ID)
        SPls <- SpatialPolygons(list(Pls))
        #df <- data.frame(id=getSpPPolygonsIDSlots(SPls),value=1)#, row.names=ID
        df = data.frame(value = 1, row.names = ID)
        SPDFj <- SpatialPolygonsDataFrame(SPls, df)
        #SpatialLinesDataFrame(SP, data=data.frame(sapply(slot(SP, 'lines'), function(x) slot(x, 'ID'))))
        
        if (ini == 0)
        {
          SPDF = SPDFj
          ini = 1
        } else {
          SPDF = rbind(SPDF, SPDFj)
        }
      }
    }
    proj4string(SPDF) = tdci@proj4string
    
    #fusion des polygones
    SPDFb <- gBuffer(SPDF, byid = TRUE, width = 0)
    #SPDFb=SPDF
    SPDFU = unionSpatialPolygons(SPDFb, ID = SPDFb@data$value)
    #slot(SPDFU, "polygons") <- lapply(slot(SPDFU, "polygons"), checkPolygonsHoles)
    SPDFU <- gBuffer(SPDFU, byid=TRUE, width=0)
    SPDFUD = disaggregate(SPDFU)
    #SPDFUD <- gBuffer(SPDFUD, byid=TRUE, width=0)
    #SPDFUD=SPDFU
    SPDFF = SpatialPolygonsDataFrame(SPDFUD, data = data.frame(sapply(slot(SPDFUD, 'polygons'), function(x) slot(x, 'ID'))))
    # plus simple : SPDFF = SpatialPolygonsDataFrame(SPDFUD, data=data.frame(id=1:length(SPDFUD))
    
    names(SPDFF)[1] <- "NEnv"
    print(dsnlayer)
    print(nom_exp_env)
    writeOGR(
      SPDFF,
      dsn = dsnlayer,
      layer = nom_exp_env,
      driver = "ESRI Shapefile",
      overwrite_layer = TRUE
    )
    
    env4326=spTransform(SPDFF, CRS("+init=epsg:4326"))
    
    return(list(nom_exp_env, env4326))
  }