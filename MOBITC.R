if(!require(shiny)){install.packages("shiny")}
library(shiny)
dirr=R.home()
chem_mobitc=paste(dirr,"/Cerema/MOBITC",sep="")
runApp(chem_mobitc)