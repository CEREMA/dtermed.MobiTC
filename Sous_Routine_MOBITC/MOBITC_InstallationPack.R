#verif utf-8
#version 18-12-2020
#réalisée par C Trmal Cerema

MOBITC_InstallationPack<-function()
{
  dirr=R.home()
  chem_pack=paste(dirr,"/Cerema/MOBITC/Package",sep="")
  
  if(!require(shiny)){install.packages("shiny")}
  library(shiny)
  if(!require(leaflet)){install.packages("leaflet")}
  library(leaflet)
  
  if(!require(ggmap)){install.packages("ggmap")}
  
  install.packages(paste0(chem_pack,'/sp_1.4-7.zip'), repos = NULL, type = "win.binary")
  library(sp)
  library(ggmap)
  
  if(!require(flexdashboard)){install.packages("flexdashboard")}
  library(flexdashboard)
  
  if(!require(rgeos)){install.packages("rgeos")}
  library(rgeos)
  if(!require(rgdal)){install.packages("rgdal")}
  library(rgdal) #fin en 2023
  #library(deldir)
  if(!require(tripack)){install.packages("tripack")}
  library(tripack)
  if(!require(maptools)){install.packages("maptools")}
  library(maptools) #fin en 2023
  
  if(!require(stplanr)){install.packages("stplanr")}
  library(stplanr)
  if(!require(Orcs)){install.packages("Orcs")}
  library(Orcs)
  if(!require(mapview)){install.packages("mapview")}
  library(mapview) #manque uuid_1.1-0.zip
  
  if(!require(tcltk2)){install.packages("tcltk2")}
  library(tcltk2)
  
  if(!require(ggplot2)){install.packages("ggplot2")}
  library(ggplot2)
  if(!require(grid)){install.packages("grid")}
  library(grid)
  
  if(!require(rmarkdown)){install.packages("rmarkdown")}
  library(rmarkdown)
  
  if(!require(Rmisc)){install.packages("Rmisc")}
  library(Rmisc)
    
   if(!require(png)){install.packages("png")}
  library(png)
  
  if(!require(webshot)){install.packages("webshot")}
  library(webshot)
  if(!require(jpeg)){install.packages("jpeg")}
  library(jpeg)
  #if(!require(raster)){install.packages("raster")}  dans orcs
	library(raster)
	
	if(!require(knitr)){install.packages("knitr")}
  library(knitr)

if(!require(htmltools)){install.packages("htmltools")}
  library(htmltools)
 
  return(list("Installation terminée"))	
}