# fichier_env="220190218T131915-nvx-Env-C010-T0250"
# fichier_trace="20190218T131915-nvx-Env-C010-T0250-Sque-C010-Tra-P200-L0200-lisse-filtre9"
# fichier_sque="20190218T131915-nvx-Env-C010-T0250-Sque-C010"
# methodecoup="methodelarge"
# methodelim="marqauto" #ou "marqmanu"
# dirr=R.home()
# chem_mobitc=paste(dirr,"/Cerema/MOBITC",sep="")
# chemin_rep_travail="C:\\R\\R-3.5.1\\Cerema\\MOBITC\\TARAVO4"
# NomTDCinit=rbind("tdc1_taravo.shp","tdc2_taravo.shp")

# fichier_env="20180502T124233--Env-C010-T0250-Carnon"
# fichier_trace="20180502T124233--Env-C010-T0250-Sque-C001liersimpl-Carnon-Tra-P200-L0200"
# fichier_sque="20180502T124233--Env-C010-T0250-Sque-C001liersimpl-Carnon"
# methodecoup="methodelarge"
# methodelim="marqauto" #ou "marqmanu"
# dirr=R.home()
# chem_mobitc=paste(dirr,"/Cerema/MOBITC",sep="")
# chemin_rep_travail = "C:\\Mobitc_WACA\\Petite_Cote"
# NomTDCinit=rbind("tdc_ancien_petite_cote_brut_MobiTC","tdc_recent_petite_cote_brut_MobiTC")
# fichier_env="20190726T112606-toto-Env-C010-T0250"
# fichier_sque="20190719T140404--Env-C010-T0250-T-Sque-C005Net-D0055_lierR"
# fichier_trace="20190719T140404--Env-C010-T0250-T-Sque-C005Net-D0055lier-Tra-P200-L0200"
# chemin_rep_travail="C:\\R\\R-3.3.2\\Cerema\\MOBITC\\Rivages\\carnon"
# NomTDCinit=rbind("N_traits_cote_naturels_recents_L_extrait2-Carnon.shp","Rivages_Segments_MobiTC_Retenus_extrait2-Carnon.shp")


MOBITC_IntersectionPonc_2<-function(chem_mobitc,chemin_rep_travail,fichier_env,fichier_sque,fichier_trace,NomTDCinit,methodecoup,methodelim)
{
  # tdc=""
  #setwd(chemin_rep_travail)
  if(!require(rgeos)){install.packages("rgeos")}
  library(rgeos)
  if(!require(rgdal)){install.packages("rgdal")}
  library(rgdal)
  if(!require(tcltk2)){install.packages("tcltk2")}
  library(tcltk2)
  #chemNomTDCinit <- choose.files(caption="Selection des traits de cote",multi=TRUE,filters = "*.shp")
  #NomTDCinit=basename(chemNomTDCinit)
  NomTDC=substr(NomTDCinit,1,nchar(NomTDCinit)-4)
  tdc.name=paste("tdc",seq(1,length(NomTDC)),sep="")
  
  dsnlayer=chemin_rep_travail
  #Fichier enveloppe pas obligatoire
  if (fichier_env!='')
  {
    Env = readOGR(dsnlayer,fichier_env)
    print("enveloppe")
  }
  Sque = readOGR(dsnlayer,fichier_sque)
  Trace = readOGR(dsnlayer,fichier_trace)
  
  #toutes les intersections
  nomexp_ip00=paste(fichier_trace,"-IntersTDC-v00.txt",sep="")
  #dans l'enveloppe+choix d'une coupure si plusieurs avec même attribut
  nomexp_ip0=paste(fichier_trace,"-IntersTDC-v0.txt",sep="")
  #choix d'un type de limite
  nomexp_ip1=paste(fichier_trace,"-IntersTDC-v1.txt",sep="")
  
  chemexp_ip00=paste(chemin_rep_travail,"\\",nomexp_ip00,sep="")
  chemexp_ip0=paste(chemin_rep_travail,"\\",nomexp_ip0,sep="")
  chemexp_ip1=paste(chemin_rep_travail,"\\",nomexp_ip1,sep="")
  
  #ecriture dans le fichier parametre
  fichier_init=paste(chem_mobitc,"/Init_Routine_MobiTC.txt",sep="")
  fid=file(fichier_init, open = "r+")
  lignes=readLines(fid)
  lignes[12]=nomexp_ip1
  cat(lignes,file=fid,sep="\n")
  close(fid)
  
  #lecture des traits de cotes	
  for (i in 1 :length(NomTDC))
  {
    assign(tdc.name[i],readOGR(chemin_rep_travail,NomTDC[i]))
    #plot(get(tdc.name[1]))
  }
  
  file.remove(chemexp_ip00)
  file.remove(chemexp_ip0)
  file.remove(chemexp_ip1)
  
  tab=data.frame()
  
  for (itr in 1:length(Trace))
  {
    NAxe=Trace[itr,1]@data
    NTrace=Trace[itr,2]@data
    Ptsintsque=gIntersection(Sque,Trace[itr,1])
    Xsque=round(Ptsintsque$x,digits=3)
    Ysque=round(Ptsintsque$y,digits=3)
    UV=(Trace@lines[[itr]]@Lines[[1]]@coords[2,]-Trace@lines[[itr]]@Lines[[1]]@coords[1,])/sqrt((Trace@lines[[itr]]@Lines[[1]]@coords[2,1]-Trace@lines[[itr]]@Lines[[1]]@coords[1,1])^2+(Trace@lines[[itr]]@Lines[[1]]@coords[2,2]-Trace@lines[[itr]]@Lines[[1]]@coords[1,2])^2)
    U=round(UV[1],digits=3)
    V=round(UV[2],digits=3)
    
    for (itdc in 1:length(NomTDC))
    {
      for (itdcfeat in 1:length(get(tdc.name[itdc])@data[,1]))
      {
        eletdcline=SpatialLines(get(tdc.name[itdc])@lines[itdcfeat])
        proj4string(eletdcline)=get(tdc.name[itdc])@proj4string
        Ptsinttdc=gIntersection(eletdcline,Trace[itr,1])
        if (length(Ptsinttdc)>0)
        {
          print(itdcfeat)
          Distance=round(sqrt((Ptsintsque$x-Ptsinttdc$x)^2+(Ptsintsque$y-Ptsinttdc$y)^2),digits=3)
          
          Coef=((Trace@lines[[itr]]@Lines[[1]]@coords[2,1]-Trace@lines[[itr]]@Lines[[1]]@coords[1,1])*(Ptsinttdc$x-Ptsintsque$x)+(Trace@lines[[itr]]@Lines[[1]]@coords[2,2]-Trace@lines[[itr]]@Lines[[1]]@coords[1,2])*(Ptsinttdc$y-Ptsintsque$y))/abs((Trace@lines[[itr]]@Lines[[1]]@coords[2,1]-Trace@lines[[itr]]@Lines[[1]]@coords[1,1])*(Ptsinttdc$x-Ptsintsque$x)+(Trace@lines[[itr]]@Lines[[1]]@coords[2,2]-Trace@lines[[itr]]@Lines[[1]]@coords[1,2])*(Ptsinttdc$y-Ptsintsque$y))
          
          Distance=Coef*Distance
          Nbcoup=length(Ptsinttdc)
          tab=rbind(tab,cbind(NAxe,NTrace,Xsque,Ysque,U,V,Distance,get(tdc.name[itdc])@data[itdcfeat,]$date1,get(tdc.name[itdc])@data[itdcfeat,]$date2,as.character(get(tdc.name[itdc])@data[itdcfeat,]$marqueur),as.character(get(tdc.name[itdc])@data[itdcfeat,]$incert),get(tdc.name[itdc])@data[itdcfeat,]$prj_tdc,get(tdc.name[itdc])@data[itdcfeat,]$leve,get(tdc.name[itdc])@data[itdcfeat,]$product,NomTDC[itdc],Nbcoup))
          rm(Distance)
        }
      }
    }	
  }
  #renome les colonnes car le get fait des noms de colonnes étranges
  names(tab)[8] <- "date1"
  names(tab)[9] <- "date2"
  names(tab)[10] <- "marqueur"
  names(tab)[11] <- "incert"
  names(tab)[12] <- "prj_tdc"
  names(tab)[13] <- "leve"
  names(tab)[14] <- "product"
  
  write.table(tab,chemexp_ip00,sep="\t",eol="\n",quote=FALSE,row.names=FALSE,col.names=TRUE)
  
  #purge de dÃ©passement de l'enveloppe
  tab4=tab
  if (exists("Env"))
  {
    for (itr in 1:length(Trace))
    {
      print(itr)
      Ptsintsque=gIntersection(Sque,Trace[itr,1])
      Ptsintenv=gIntersection(Env,Trace[itr,1])
      if (length(Ptsintenv)>0)
      {
      Distanceenv=round(sqrt((Ptsintsque$x-Ptsintenv@lines[[1]]@Lines[[1]]@coords[,1])^2+(Ptsintsque$y-Ptsintenv@lines[[1]]@Lines[[1]]@coords[,2])^2),digits=3)
      Coefenv=((Trace@lines[[itr]]@Lines[[1]]@coords[2,1]-Trace@lines[[itr]]@Lines[[1]]@coords[1,1])*(Ptsintenv@lines[[1]]@Lines[[1]]@coords[,1]-Ptsintsque$x)+(Trace@lines[[itr]]@Lines[[1]]@coords[2,2]-Trace@lines[[itr]]@Lines[[1]]@coords[1,2])*(Ptsintenv@lines[[1]]@Lines[[1]]@coords[,2]-Ptsintsque$y))/abs((Trace@lines[[itr]]@Lines[[1]]@coords[2,1]-Trace@lines[[itr]]@Lines[[1]]@coords[1,1])*(Ptsintenv@lines[[1]]@Lines[[1]]@coords[,1]-Ptsintsque$x)+(Trace@lines[[itr]]@Lines[[1]]@coords[2,2]-Trace@lines[[itr]]@Lines[[1]]@coords[1,2])*(Ptsintenv@lines[[1]]@Lines[[1]]@coords[,2]-Ptsintsque$y))
      Distanceenv=Coefenv*Distanceenv

      extraittab=tab4[which(tab4$NAxe == as.numeric(Trace[itr,1]@data) & tab4$NTrace == as.numeric(Trace[itr,2]@data)), ]
      todel=which(tab4$NAxe == as.numeric(Trace[itr,1]@data) & tab4$NTrace == as.numeric(Trace[itr,2]@data) & tab4$Distance > max(Distanceenv))
      if (length(todel)>0)
      {
        tab4=tab4[-todel,]
        row.names(tab4) <- 1:nrow(tab4)
      }
      todel=which(tab4$NAxe == as.numeric(Trace[itr,1]@data) & tab4$NTrace == as.numeric(Trace[itr,2]@data) & tab4$Distance < min(Distanceenv))
      if (length(todel)>0)
      {
        tab4=tab4[-todel,]
        row.names(tab4) <- 1:nrow(tab4)
      }
      }
    }
  }
  
  #purge des plusieurs coupures
  tab3=tab4
  
  att=tab3[,c(-7,-15,-16)]
  double=which(duplicated(att) | duplicated(att[nrow(att):1, ])[nrow(att):1])
  
  while (length(double)>0)
  {
    exttraitdouble=tab3[which(tab3$NAxe==tab3[double[1],]$NAxe & tab3$NTrace==tab3[double[1],]$NTrace & tab3$date1==tab3[double[1],]$date1 & tab3$marqueur==tab3[double[1],]$marqueur & tab3$incert==tab3[double[1],]$incert & tab3$leve==tab3[double[1],]$leve & tab3$product==tab3[double[1],]$product),]
    #le + au large
    if (methodecoup=="methodelarge")
    {
      todel=which(tab3$NAxe==tab3[double[1],]$NAxe & tab3$NTrace==tab3[double[1],]$NTrace & tab3$Distance < max(exttraitdouble$Distance) & tab3$date1==tab3[double[1],]$date1 & tab3$marqueur==tab3[double[1],]$marqueur & tab3$incert==tab3[double[1],]$incert & tab3$leve==tab3[double[1],]$leve & tab3$product==tab3[double[1],]$product)
      print(todel)
      if (length(todel)>=1)
      {
        tab3=tab3[-todel,]
        row.names(tab3) <- 1:nrow(tab3)
      }
    }
    #le + Ã  la cÃ´te
    if (methodecoup=="methodecote")
    {		
      todel=which(tab3$NAxe == as.numeric(Trace[itr,1]@data) & tab3$NTrace == as.numeric(Trace[itr,2]@data) & tab3$Distance > min(extraittab$Distance) & tab3$IDTDC == unique(extraittab$IDTDC)[itdc])
      if (length(todel)>=1)
      {
        tab3=tab3[-todel,]
        row.names(tab3) <- 1:nrow(tab3)
      }
    }
    att=tab3[,c(-7,-15,-16)]
    double=which(duplicated(att) | duplicated(att[nrow(att):1, ])[nrow(att):1])
  }
  
  write.table(tab3,chemexp_ip0,sep="\t",eol="\n",quote=FALSE,row.names=FALSE,col.names=TRUE)
  
  #purge de plusieurs limites
  tab5=tab3
  if (methodelim=="marqmanu")
  {
    for (itr in 1:length(Trace))
    {
      extraittab=tab5[which(tab5$NAxe == as.numeric(Trace[itr,1]@data) & tab5$NTrace == as.numeric(Trace[itr,2]@data)), ]
      nblim=length(unique(extraittab$marqueur))
      
      if (nblim>1)
      {	
        Choixlim=function(){		
          OnOK=function()
          {
            tkdestroy(fe)
          }
          
          fe=tktoplevel()
          tktitle(fe)="Choisir le marqueur"
          texte1=paste("Plusieurs marqueurs sur la trace ",Trace[itr,2]@data," de l'axe ",Trace[itr,1]@data,sep="")
          tkgrid(tklabel(fe,text=texte1))
          boutValue=tclVar("lim2")
          for (ibout in 1 : nblim)
          {
            valeur=unique(extraittab$marqueur)[ibout]
            textbout=paste("Lim",unique(extraittab$marqueur)[ibout],sep="")
            bout=tkradiobutton(fe)
            tkconfigure(bout,variable=boutValue,value=valeur)
            tkgrid(tklabel(fe,text=textbout),bout)
          }		
          butOK=ttkbutton(fe,text="OK",command=OnOK)
          tkgrid(butOK)
          tkfocus(fe)
          tkwait.window(fe)
          lim=as.numeric(tclvalue(boutValue))
          print(lim)
          return(lim)
        }
        
        Monchoix=Choixlim()		
        todel=which(tab5$NAxe == as.numeric(Trace[itr,1]@data) & tab5$NTrace == as.numeric(Trace[itr,2]@data) & tab5$marqueur != Monchoix)
        if (length(todel)>=1)
        {
          tab5=tab5[-todel,]
          row.names(tab5) <- 1:nrow(tab5)
          print("fait")
        }			
      }
    }
  }
  
  if (methodelim=="marqauto")
  {
    for (itr in 1:length(Trace))
    {
      extraittab=tab5[which(tab5$NAxe == as.numeric(Trace[itr,1]@data) & tab5$NTrace == as.numeric(Trace[itr,2]@data)), ]
      nblim=length(unique(extraittab$marqueur))
      if (nblim>1)
      {	
        lim=as.data.frame(table(extraittab$marqueur)) 
        Monchoix=lim$Var1[ which.max(lim$Freq)]
        todel=which(tab5$NAxe == as.numeric(Trace[itr,1]@data) & tab5$NTrace == as.numeric(Trace[itr,2]@data) & tab5$marqueur != Monchoix)
        if (length(todel)>=1)
        {
          tab5=tab5[-todel,]
          row.names(tab5) <- 1:nrow(tab5)
          print("fait")
        }
      }
    } 
  }
  
  write.table(tab5,chemexp_ip1,sep="\t",eol="\n",append=TRUE,quote=FALSE,row.names=FALSE,col.names=TRUE)
  
  texte="Calcul fini intersection ponctuelle"
  
  
  return(list(texte,tab5))
}