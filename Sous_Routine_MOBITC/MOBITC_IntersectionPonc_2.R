#verif utf-8
#version 08-11-2022 #correction d'un bug sur tab5
#réalisée par C Trmal Cerema

MOBITC_IntersectionPonc_2<-function(chem_mobitc,chemin_rep_travail,fichier_env,fichier_sque,fichier_trace,NomTDCinit,methodecoup,methodelim)
{
  # tdc=""
  #setwd(chemin_rep_travail)
 
  library(rgeos)
 
  library(rgdal)
  
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
    print(paste("itr :",itr))
    NAxe=data.frame(NAxe=Trace$NAxe[itr])#Trace[itr,1]@data
    NTrace=data.frame(NTrace=Trace$NTrace[itr])#Trace[itr,2]@data
    print(paste("Axe- Ntrace :",NAxe,"-",NTrace))
    if (length(Trace$Loc)>0)
    {Loc=data.frame(Loc=Trace$Loc[itr])
    inc=1
    nloc=nrow(Loc)
    } else {
      Loc=0
      inc=0
      nloc=1}
    
    Ptsintsque=gIntersection(Sque,Trace[itr,1])
    Xsque=round(Ptsintsque$x,digits=3)
    Ysque=round(Ptsintsque$y,digits=3)
    UV=(Trace@lines[[itr]]@Lines[[1]]@coords[2,]-Trace@lines[[itr]]@Lines[[1]]@coords[1,])/sqrt((Trace@lines[[itr]]@Lines[[1]]@coords[2,1]-Trace@lines[[itr]]@Lines[[1]]@coords[1,1])^2+(Trace@lines[[itr]]@Lines[[1]]@coords[2,2]-Trace@lines[[itr]]@Lines[[1]]@coords[1,2])^2)
    U=round(UV[1],digits=3)
    V=round(UV[2],digits=3)
    
    for (itdc in 1:length(NomTDC))
    {
      print(paste("itdc :",itdc))
      for (itdcfeat in 1:length(get(tdc.name[itdc])@data[,1]))
      {
        #print(paste("itdcfeat :",itdcfeat))
        eletdcline=SpatialLines(get(tdc.name[itdc])@lines[itdcfeat])
        proj4string(eletdcline)=get(tdc.name[itdc])@proj4string
        Ptsinttdc=gIntersection(eletdcline,Trace[itr,1])
        if (length(Ptsinttdc)>0)
        {
          print(paste("nb coupure : ",length(Ptsinttdc)))
          Distance=round(sqrt((Ptsintsque$x-Ptsinttdc$x)^2+(Ptsintsque$y-Ptsinttdc$y)^2),digits=3)
          
          Coef=((Trace@lines[[itr]]@Lines[[1]]@coords[2,1]-Trace@lines[[itr]]@Lines[[1]]@coords[1,1])*(Ptsinttdc$x-Ptsintsque$x)+(Trace@lines[[itr]]@Lines[[1]]@coords[2,2]-Trace@lines[[itr]]@Lines[[1]]@coords[1,2])*(Ptsinttdc$y-Ptsintsque$y))/abs((Trace@lines[[itr]]@Lines[[1]]@coords[2,1]-Trace@lines[[itr]]@Lines[[1]]@coords[1,1])*(Ptsinttdc$x-Ptsintsque$x)+(Trace@lines[[itr]]@Lines[[1]]@coords[2,2]-Trace@lines[[itr]]@Lines[[1]]@coords[1,2])*(Ptsinttdc$y-Ptsintsque$y))
          
          Distance=Coef*Distance
          Nbcoup=length(Ptsinttdc)
          if (Loc==0)
          {
          tab=rbind(tab,cbind(NAxe=NAxe,NTrace=NTrace,Xsque,Ysque,U,V,Distance,date1=get(tdc.name[itdc])$date1[itdcfeat],date2=get(tdc.name[itdc])@data[itdcfeat,]$date2,as.character(get(tdc.name[itdc])@data[itdcfeat,]$marqueur),as.character(get(tdc.name[itdc])@data[itdcfeat,]$incert),get(tdc.name[itdc])@data[itdcfeat,]$leve,get(tdc.name[itdc])@data[itdcfeat,]$product,NomTDC[itdc],Nbcoup))
          #get(tdc.name[itdc])@data[itdcfeat,]$prj_tdc,
          } else {
            tab=rbind(tab,cbind(NAxe=NAxe,NTrace=NTrace,Loc=Loc,Xsque,Ysque,U,V,Distance,date1=get(tdc.name[itdc])$date1[itdcfeat],date2=get(tdc.name[itdc])@data[itdcfeat,]$date2,as.character(get(tdc.name[itdc])@data[itdcfeat,]$marqueur),as.character(get(tdc.name[itdc])@data[itdcfeat,]$incert),get(tdc.name[itdc])@data[itdcfeat,]$leve,get(tdc.name[itdc])@data[itdcfeat,]$product,NomTDC[itdc],Nbcoup))
          }#get(tdc.name[itdc])@data[itdcfeat,]$prj_tdc,
          rm(Distance)
        }
      }
    }	#fin itdc
  } #fin itr
  
  if (Loc==0)
  {
     tab=tab[ order( tab[,1],tab[,2]),]
  } else {
     tab=tab[ order( tab[,3],tab[,1],tab[,2]),]
  }
  
  #renome les colonnes car le get fait des noms de colonnes étranges
  names(tab)[1] <- "NAxe"
  names(tab)[2] <- "NTrace"
  
  names(tab)[8+inc] <- "date1"
  names(tab)[9+inc] <- "date2"
  names(tab)[10+inc] <- "marqueur"
  names(tab)[11+inc] <- "incert"
 # names(tab)[12+inc] <- "prj_tdc"
  names(tab)[12+inc] <- "leve"
  names(tab)[13+inc] <- "product"
  
  
  write.table(tab,chemexp_ip00,sep="\t",eol="\n",quote=FALSE,row.names=FALSE,col.names=TRUE)
  
  #tab=read.table(chemexp_ip00,sep="\t",header=TRUE,row.names = NULL)
  
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
      if (Loc==0)
      {
        todel=which(tab4$NAxe == as.numeric(Trace[itr,1]@data) & tab4$NTrace == as.numeric(Trace[itr,2]@data) & tab4$Distance > max(Distanceenv))
      } else {
        todel=which(tab4$NAxe == as.numeric(Trace[itr,1]@data) & tab4$NTrace == as.numeric(Trace[itr,2]@data) & tab4$Loc == as.character(Trace[itr,3]@data) & tab4$Distance > max(Distanceenv))
      }
      
      if (length(todel)>0)
      {
        tab4=tab4[-todel,]
        row.names(tab4) <- 1:nrow(tab4)
      }
      if (Loc==0)
      {
        todel=which(tab4$NAxe == as.numeric(Trace[itr,1]@data) & tab4$NTrace == as.numeric(Trace[itr,2]@data) & tab4$Distance < min(Distanceenv))
      } else {
        todel=which(tab4$NAxe == as.numeric(Trace[itr,1]@data) & tab4$NTrace == as.numeric(Trace[itr,2]@data) & tab4$Loc == as.character(Trace[itr,3]@data) & tab4$Distance < min(Distanceenv))
      }
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
  
  att=tab3[,c(-7-inc,-15-inc,-16-inc)]
  double=which(duplicated(att) | duplicated(att[nrow(att):1, ])[nrow(att):1])
  
  while (length(double)>0)
  {
    if (Loc==0)
    {
      exttraitdouble=tab3[which(tab3$NAxe==tab3[double[1],]$NAxe & tab3$NTrace==tab3[double[1],]$NTrace  & tab3$date1==tab3[double[1],]$date1 & tab3$marqueur==tab3[double[1],]$marqueur & tab3$incert==tab3[double[1],]$incert & tab3$leve==tab3[double[1],]$leve & tab3$product==tab3[double[1],]$product),]
    } else {
      exttraitdouble=tab3[which(tab3$NAxe==tab3[double[1],]$NAxe & tab3$NTrace==tab3[double[1],]$NTrace & tab3$Loc == tab3[double[1],]$Loc & tab3$date1==tab3[double[1],]$date1 & tab3$marqueur==tab3[double[1],]$marqueur & tab3$incert==tab3[double[1],]$incert & tab3$leve==tab3[double[1],]$leve & tab3$product==tab3[double[1],]$product),]
    }
    #le + au large
    if (methodecoup=="methodelarge")
    {
      if (Loc==0)
      {
        todel=which(tab3$NAxe==tab3[double[1],]$NAxe & tab3$NTrace==tab3[double[1],]$NTrace & tab3$Distance < max(exttraitdouble$Distance) & tab3$date1==tab3[double[1],]$date1 & tab3$marqueur==tab3[double[1],]$marqueur & tab3$incert==tab3[double[1],]$incert & tab3$leve==tab3[double[1],]$leve & tab3$product==tab3[double[1],]$product)
      } else {
        todel=which(tab3$NAxe==tab3[double[1],]$NAxe & tab3$NTrace==tab3[double[1],]$NTrace & tab3$Loc == tab3[double[1],]$Loc & tab3$Distance < max(exttraitdouble$Distance) & tab3$date1==tab3[double[1],]$date1 & tab3$marqueur==tab3[double[1],]$marqueur & tab3$incert==tab3[double[1],]$incert & tab3$leve==tab3[double[1],]$leve & tab3$product==tab3[double[1],]$product) }
     }
     
    print(todel)
      if (length(todel)==0) #ça veut dire qu'ils sont égaux
      {
        todel=double[2:length(double)]
      }
      if (length(todel)>=1)
      {
        tab3=tab3[-todel,]
        row.names(tab3) <- 1:nrow(tab3)
      }
      
    #le + à la côte
    if (methodecoup=="methodecote")
    {		
      if (Loc==0)
      {
        todel=which(tab3$NAxe == as.numeric(Trace[itr,1]@data) & tab3$NTrace == as.numeric(Trace[itr,2]@data) & tab3$Distance > min(extraittab$Distance) & tab3$IDTDC == unique(extraittab$IDTDC)[itdc])
      } else {
        todel=which(tab3$NAxe == as.numeric(Trace[itr,1]@data) & tab3$NTrace == as.numeric(Trace[itr,2]@data) & tab3$Loc == tab3[double[1],]$Loc & tab3$Distance > min(extraittab$Distance) & tab3$IDTDC == unique(extraittab$IDTDC)[itdc])
      }
      
       if (length(todel)>=1)
      {
        tab3=tab3[-todel,]
        row.names(tab3) <- 1:nrow(tab3)
      }
    }
  att=tab3[,c(-7-inc,-15-inc,-16-inc)]
    double=which(duplicated(att) | duplicated(att[nrow(att):1, ])[nrow(att):1])
  }
  
  write.table(tab3,chemexp_ip0,sep="\t",eol="\n",quote=FALSE,row.names=FALSE,col.names=TRUE)
  
  #purge de plusieurs limites
  tab5=tab3
  if (methodelim=="marqmanu")
  {
    for (itr in 1:length(Trace))
    {
      if (Loc==0)
      {
      extraittab=tab5[which(tab5$NAxe == as.numeric(Trace[itr,1]@data) & tab5$NTrace == as.numeric(Trace[itr,2]@data)), ]
      } else {
        extraittab=tab5[which(tab5$NAxe == as.numeric(Trace[itr,1]@data) & tab5$NTrace == as.numeric(Trace[itr,2]@data) & tab5$Loc == as.character(Trace[itr,3]@data)) , ]
        
      }
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
        if (Loc==0)
        {
        todel=which(tab5$NAxe == as.numeric(Trace[itr,1]@data) & tab5$NTrace == as.numeric(Trace[itr,2]@data) & tab5$marqueur != Monchoix)
        } else {
          todel=which(tab5$NAxe == as.numeric(Trace[itr,1]@data) & tab5$NTrace == as.numeric(Trace[itr,2]@data) & tab5$Loc == as.character(Trace[itr,3]@data) & tab5$marqueur != Monchoix)
        }
        
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
      if (Loc==0)
      {
        extraittab=tab5[which(tab5$NAxe == as.numeric(Trace[itr,1]@data) & tab5$NTrace == as.numeric(Trace[itr,2]@data)), ]
      } else {
        extraittab=tab5[which(tab5$NAxe == as.numeric(Trace[itr,1]@data) & tab5$NTrace == as.numeric(Trace[itr,2]@data) & tab5$Loc == as.character(Trace[itr,3]@data)) , ]
        
      }
      nblim=length(unique(extraittab$marqueur))
      if (nblim>1)
      {	
        lim=as.data.frame(table(extraittab$marqueur)) 
        Monchoix=lim$Var1[which.max(lim$Freq)]
        if (Loc==0)
        {
          todel=which(tab5$NAxe == as.numeric(Trace[itr,1]@data) & tab5$NTrace == as.numeric(Trace[itr,2]@data) & tab5$marqueur != Monchoix)
        } else {
          todel=which(tab5$NAxe == as.numeric(Trace[itr,1]@data) & tab5$NTrace == as.numeric(Trace[itr,2]@data) & tab5$Loc == as.character(Trace[itr,3]@data) & tab5$marqueur != Monchoix)
        }
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