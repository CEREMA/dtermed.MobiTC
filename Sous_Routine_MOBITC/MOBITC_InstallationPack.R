MOBITC_InstallationPack<-function()
{
  if(!require(shiny)){install.packages("shiny")}
  library(shiny)
  if(!require(leaflet)){install.packages("leaflet")}
  library(leaflet)
  if(!require(ggmap)){install.packages("ggmap")}
  library(ggmap)
  if(!require(flexdashboard)){install.packages("flexdashboard")}
  library(flexdashboard)
  
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
  
  if(!require(stplanr)){install.packages("stplanr")}
  library(stplanr)
  
  if(!require(mapview)){install.packages("mapview")}
  library(mapview)
  
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
  if(!require(leaflet)){install.packages("leaflet")}
  library(leaflet)
  
  return(list("Installation terminée"))	
}