# chemin_rep_travail="C:\\R\\R-3.5.1\\Cerema\\MOBITC\\Rivages\\carnonsatpos"
# dirr=R.home()
# chem_mobitc=paste(dirr,"/Cerema/MOBITC",sep="")
# 
# fichier_intersection="20180502T124233--Env-C010-T0250-Sque-C001liersimpl-Carnon-Tra-P50-L0200-IntersTDC-v1.txt"
# fichier_trace="20180502T124233--Env-C010-T0250-Sque-C001liersimpl-Carnon-Tra-P50-L0200"
# produc="Cerema"
# ICtx=c("IC70","IC90")
# datedebgraph="2005"
# datefingraph="2020"
# dateprosp="2100"
# 
# fichier_intersection="20190517T152421-TPM-Sque-cont-Tra-P50-L0100sel-lisse-filtre3-mod-IntersTDC-v1.txt"
# fichier_sque="20190517T152421-TPM-Sque-cont"
# fichier_trace="20190517T152421-TPM-Sque-cont-Tra-P50-L0100sel-lisse-filtre3-mod"
# fichier_evolution="Sque_TPM_2154-Tra-P50-L0050b-IntersTDC-v1-toutesdates-MobiTC.txt"

MOBITC_Export_Graph_1p1_leger<-function(chem_mobitc,chemin_rep_travail,fichier_sque,fichier_trace,fichier_intersection,fichier_evolution,NAxe,NTrace,Loc)
{
  library(rgdal)
  library(sp)
  library(ggplot2)
  library(ggmap)
  library(Rmisc)
  library(grid)
  library(leaflet)
  library(png)
  
  #si probl?me avec google mettre 0
  plan=1

  chemin_rep_travail=as.character(chemin_rep_travail)
  chem_mobitc=as.character(chem_mobitc)
 fichier_intersection=as.character(fichier_intersection)
 fichier_trace=as.character(fichier_trace)
 fichier_sque=as.character(fichier_sque)
 fichier_evolution=as.character(fichier_evolution)
  
  #lecture du fichier intersection V1 normalement -> v0 pour avoir tous les limites
  chem_intersectionv1=paste(chemin_rep_travail,"\\",fichier_intersection,sep="")
  
  fichier_intersectionv0=paste(substr(fichier_intersection,1,nchar(fichier_intersection)-7),"-v0.txt",sep="")
  chem_intersectionv0=paste(chemin_rep_travail,"\\",fichier_intersectionv0,sep="")
  print(chem_intersectionv0)
  tab00=read.table(chem_intersectionv0,sep="\t",header=TRUE,row.names = NULL)
  print(chem_intersectionv1)
  tab11=read.table(chem_intersectionv1,sep="\t",header=TRUE,row.names = NULL)
  #modif des dates dans le tableau de d?part
  source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Convertdate_2.R",sep=""))	
  tab=MOBITC_Convertdate_2(tab00)
  #pour AOR
  tab1=MOBITC_Convertdate_2(tab11)
  
  #lecture fichier evolution
  nom_evol=fichier_evolution
  chem_evol=paste(chemin_rep_travail,"\\",nom_evol,sep="")
  print(chem_evol)
  ligneres0=read.table(chem_evol,sep="\t",header=TRUE,row.names = NULL)
  
  # lecture des param?tres
  
  fichier_init=paste(chem_mobitc,"\\Init_Routine_MobiTC.txt",sep="")
  fid=file(fichier_init, open = "r+")
  lignes=readLines(fid)
  produc=lignes[14]
  ICtx=lignes[16]
  datedebgraph=lignes[18]
  datefingraph=lignes[20]
  dateprosp=lignes[22]
  close(fid)
  
  #convertion IC
  IC=as.numeric(substr(ICtx,3,4))
  
  #Lecture du fichier LIM
  chem_lim=paste(chemin_rep_travail,"\\LIM.csv",sep="")
  LIM=read.table(chem_lim,sep="\t",header=TRUE,row.names = NULL,fileEncoding="UTF-8")
  
  # #lecture fichier trace
  # dsnlayer=chemin_rep_travail
  # Trace = readOGR(dsnlayer,fichier_trace)
  # Tracedeg=spTransform(Trace,CRS("+init=epsg:4326"))
  # 
  # #transformation du sque en deg
  # dsnlayer=chemin_rep_travail
  # Sque = readOGR(dsnlayer,fichier_sque)
  # Squedeg=spTransform(Sque,CRS("+init=epsg:4326"))
  
  #ouverture du fichier n?cessaire aux courbes (tabres)
  nomdirgraph=paste(chemin_rep_travail,"\\Graph",sep="")
  if (Loc==0)
  {
    nom_courbe=paste(substr(fichier_evolution,1,nchar(fichier_evolution)-4),"-Courbe-NAxe",NAxe,"-NTrace",NTrace,".txt",sep="")
  } else {
    #nom_courbe=paste(substr(fichier_evolution,1,nchar(fichier_evolution)-4),"-Courbe-NAxe",NAxe,"-NTrace",NTrace,"-Loc",as.character(formatC(as.numeric(Loc), width = 5, format = "d", flag = "0")),".txt",sep="")
    nom_courbe=paste(substr(fichier_evolution,1,nchar(fichier_evolution)-4),"-Courbe-NAxe",NAxe,"-NTrace",NTrace,"-Loc",Loc,".txt",sep="")
  }
  chem_courbe=paste(nomdirgraph,"\\",nom_courbe,sep="")
  if (file.exists(chem_courbe))
  {
    tabres=read.table(chem_courbe,sep="\t",header=TRUE,row.names = NULL)
  }
  else {
    tabres=data.frame()
  }
  

  
  #extrait de ligneres0
  if (Loc==0)
  {
    ligneresaxe=ligneres0[which(ligneres0$NAxe ==NAxe),]
    ligneres=ligneresaxe[which(ligneresaxe$NTrace ==NTrace),]
    
  } else {
    if (is.numeric(ligneres0$Loc)==TRUE)
    {
      Loci=as.numeric(Loc)
    } else {
      Loci=Loc
    }
    
    ligneresloc=ligneres0[which(ligneres0$Loc == Loci),]
    ligneresaxe=ligneresloc[which(ligneresloc$NAxe ==NAxe),]
    ligneres=ligneresaxe[which(ligneresaxe$NTrace ==NTrace),]
  }
  
  
  #axe et trace pr?c?dente
  #ordonner la table ligneres0
  ligneresord=ligneres0[order(ligneres0$NAxe,ligneres0$NTrace),]
  ligneresprec=ligneres0[which(ligneresord$NAxe==ligneres$NAxe & ligneresord$NTrace==ligneres$NTrace),]
  ligneressuiv=ligneres0[which(ligneresord$NAxe==ligneres$NAxe & ligneresord$NTrace==ligneres$NTrace),]
  # ligneresprec=ligneres0[which(ligneresord$NAxe==ligneres$NAxe & ligneresord$NTrace==ligneres$NTrace)-1,]
  # if(nrow(ligneresprec)>0)
  # {
  # k=2
  # while(is.na(ligneresprec$WLS))
  # {
  #   ligneresprec=ligneres0[which(ligneresord$NAxe==ligneres$NAxe & ligneresord$NTrace==ligneres$NTrace)-k,]
  #   k=k+1
  # }
  # }
  # 
  # ligneressuiv=ligneres0[which(ligneresord$NAxe==ligneres$NAxe & ligneresord$NTrace==ligneres$NTrace)+1,]
  # if(nrow(ligneressuiv)>0)
  # {
  # k=2
  # while(is.na(ligneressuiv$WLS))
  # {
  #   ligneressuiv=ligneres0[which(ligneresord$NAxe==ligneres$NAxe & ligneresord$NTrace==ligneres$NTrace)+k,]
  #   k=k+1
  # }
  # }
  if (Loc==0)
  {
    extraittab=tab[which(tab$NAxe == NAxe & tab$NTrace == NTrace),]
    #pour AOR
    extraittab1=tab1[which(tab1$NAxe == NAxe & tab1$NTrace == NTrace),]
    
  } else {
    extraittab=tab[which(tab$NAxe == NAxe & tab$NTrace == NTrace & tab$Loc == Loci),]
    #pour AOR
    extraittab1=tab1[which(tab1$NAxe == NAxe & tab1$NTrace == NTrace & tab1$Loc == Loci),]

  }
  
  
  # graphique que si plusieurs traits de c?te
  if (length(extraittab1$Distance)>1)
  {
    # limite de l'axe x
    xlimg=c(as.POSIXct(paste(datedebgraph,"-1-1",sep="")),as.POSIXct(paste(datefingraph,"-1-1",sep="")))
    xlimg2=as.POSIXct(paste(datedebgraph,"-1-1",sep=""),tz="CET",origin = "1970-01-01")
    xlimd=as.POSIXct(paste(datefingraph,"-1-1",sep=""),tz="CET",origin = "1970-01-01")
    Alab=seq(datedebgraph,datefingraph,length.out=7)
    if (file.exists(chem_courbe))
    {
    # limite de l'axe y (pas sur AOR, JK et MDL)
    colg=c(1,which(colnames(tabres) == "AORfit"))
    colg=c(colg,which(colnames(tabres) == "JKfit"))
    colg=c(colg,which(colnames(tabres) == "MDLOLSfit"))
    colg=c(colg,which(colnames(tabres) == "MDLpolyfit"))
      
      if (length(IC)>0)
      {
        for (ic in 1 : length(IC))
        {
          colg=c(colg,which(colnames(tabres) == paste("JK",IC[ic],"lwr",sep="")))
          colg=c(colg,which(colnames(tabres) == paste("JK",IC[ic],"up",sep="")))
        }
      }
    tabres3=tabres[,-colg]
    
    ylimg=c(min(min(tabres3[!is.na(tabres3)]),min(extraittab$Distance-extraittab$incert/2)),max(max(tabres3[!is.na(tabres3)]),max(extraittab$Distance+extraittab$incert/2)))
   #   min(tabres[,-colg],na.rm = TRUE),min(extraittab$Distance-extraittab$incert/2)),max(max(tabres[,-colg],na.rm = TRUE),max(extraittab$Distance+extraittab$incert/2)))
    # largeur des axes pour la position des l?gende
    } else {
      ylimg=c(min(extraittab$Distance-extraittab$incert/2),max(extraittab$Distance+extraittab$incert/2))
      
    }
    dx=xlimg[2]-xlimg[1]
    dy=ylimg[2]-ylimg[1]
    
    datecoup=as.numeric(substr(fichier_evolution,nchar(fichier_evolution)-14,nchar(fichier_evolution)-11))
    
    
    #EPR
    G1=ggplot()
    
    if (length(ligneres$EPR)==0)
    {
      G1=G1+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
    } else {
    if (!is.na(ligneres$EPR))
    {
      a=5
      G1=G1+geom_line(aes(x=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),y=tabres$EPRfit,color="red"))
    } else {
      a=6
      G1=G1+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
    }
    }
    
    G1=G1+ggtitle(paste('EPR =',ligneres$EPR,"m/an"))+theme(plot.title = element_text(size=10,hjust = 0.5))+
      xlab(NULL)+ylab(NULL)+
      # xlim(xlimg)+
      ylim(ylimg)+
      scale_x_datetime(limits=c(xlimg2,xlimd),breaks=seq(xlimg2,xlimd,length.out=7),labels=Alab)+
      geom_errorbar(aes(as.POSIXct(extraittab$Datemoynum,origin="1970-01-01"),extraittab$Distance,ymin=extraittab$Distance-extraittab$incert/2,ymax=extraittab$Distance+extraittab$incert/2),width=0)+
      theme(legend.position="none")+
      theme(panel.background = element_blank(),panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                                                               colour = "grey"),panel.border = element_rect(colour = "black", fill=NA, size=0.5))
    
    
    extraittablev=extraittab[which(extraittab$leve == "LEV"),]
    couleurlev=data.frame(R=LIM$R[extraittablev$marqueur],V=LIM$V[extraittablev$marqueur],B=LIM$B[extraittablev$marqueur])
    if (nrow(extraittablev)>0)
    {
      G1=G1+
        geom_point(data=extraittablev,aes(x=as.POSIXct(extraittablev$Datemoynum,origin="1970-01-01"),y=extraittablev$Distance),shape=rep(15,length(extraittablev[,1])),size=rep(2,length(extraittablev[,1])),color=rgb(couleurlev/256))
    }
    extraittabnum=extraittab[which(extraittab$leve == "NUM"),]
    couleurnum=data.frame(R=LIM$R[extraittabnum$marqueur],V=LIM$V[extraittabnum$marqueur],B=LIM$B[extraittabnum$marqueur])
    if (nrow(extraittabnum)>0)
    {
      G1=G1+
        geom_point(data=extraittabnum,aes(x=as.POSIXct(extraittabnum$Datemoynum,origin="1970-01-01"),y=extraittabnum$Distance),shape=rep(19,length(extraittabnum[,1])),size=rep(2,length(extraittabnum[,1])),color=rgb(couleurnum/256)) 
    }
    
    #AOR
   
    #choix ? partir de la date
    
    if (is.na(datecoup))
    {
      extraittab2=extraittab1
    } else {
    datecoupnum=as.numeric(as.POSIXct(strptime(paste0(as.character(datecoup),"-1-1 0:0:0"),"%Y-%m-%d %H:%M:%S")))
    extraittab2=extraittab1[which(extraittab1$Datemoynum>=datecoupnum),]
    }
    
    G2=ggplot()
    
    if (length(ligneres$AOR)==0)
    {
      G2=G2+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
    } else {
      if (!is.na(ligneres$AOR))
      {
        Combi=combn(seq(1,length(extraittab2$Distance)),2)
        Seg_AOR=data.frame(x=as.POSIXct(extraittab2$Datemoynum[Combi[1,]],origin="1970-01-01"),y=extraittab2$Distance[Combi[1,]],xend=as.POSIXct(extraittab2$Datemoynum[Combi[2,]],origin="1970-01-01"),yend=extraittab2$Distance[Combi[2,]])
        
        G2=G2+geom_segment(data=Seg_AOR,aes(x=x,y=y,xend=xend,yend=yend),colour="grey")+
          geom_line(aes(x=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),y=tabres$AORfit,color="red"))
      } else {
        G2=G2+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
      }
    }
    
    G2=G2+ggtitle(paste('AOR =',ligneres$AOR,"m/an"))+theme(plot.title = element_text(size=10,hjust = 0.5))+
      xlab(NULL)+ylab(NULL)+
      # xlim(xlimg)+
      ylim(ylimg)+
      scale_x_datetime(limits=c(xlimg2,xlimd),breaks=seq(xlimg2,xlimd,length.out=7),labels=Alab)+
      geom_errorbar(aes(as.POSIXct(extraittab$Datemoynum,origin="1970-01-01"),extraittab$Distance,ymin=extraittab$Distance-extraittab$incert/2,ymax=extraittab$Distance+extraittab$incert/2),width=0)+
      theme(legend.position="none")+
      theme(panel.background = element_blank(),panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                                                               colour = "grey"),panel.border = element_rect(colour = "black", fill=NA, size=0.5))
    
    extraittablev=extraittab[which(extraittab$leve == "LEV"),]
    couleurlev=data.frame(R=LIM$R[extraittablev$marqueur],V=LIM$V[extraittablev$marqueur],B=LIM$B[extraittablev$marqueur])
    if (nrow(extraittablev)>0)
    {
      G2=G2+
        geom_point(data=extraittablev,aes(x=as.POSIXct(extraittablev$Datemoynum,origin="1970-01-01"),y=extraittablev$Distance),shape=rep(15,length(extraittablev[,1])),size=rep(2,length(extraittablev[,1])),color=rgb(couleurlev/256))
    }
    extraittabnum=extraittab[which(extraittab$leve == "NUM"),]
    couleurnum=data.frame(R=LIM$R[extraittabnum$marqueur],V=LIM$V[extraittabnum$marqueur],B=LIM$B[extraittabnum$marqueur])
    if (nrow(extraittabnum)>0)
    {
      G2=G2+
        geom_point(data=extraittabnum,aes(x=as.POSIXct(extraittabnum$Datemoynum,origin="1970-01-01"),y=extraittabnum$Distance),shape=rep(19,length(extraittabnum[,1])),size=rep(2,length(extraittabnum[,1])),color=rgb(couleurnum/256)) 
    }
    
    #OLS
    G3=ggplot()
    if (length(ligneres$OLS)==0)
    {
      G3=G3+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
    } else {
      if (!is.na(ligneres$OLS))
      {
        G3=G3+geom_line(aes(x=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),y=tabres$OLSfit,color="red"))
      } else {
        G3=G3+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
      }
    }
    G3=G3+
      ggtitle(paste('OLS =',ligneres$OLS,"m/an"))+theme(plot.title = element_text(size=10,hjust = 0.5))+
      xlab(NULL)+ylab(NULL)+
      # xlim(xlimg)+
      ylim(ylimg)+
      scale_x_datetime(limits=c(xlimg2,xlimd),breaks=seq(xlimg2,xlimd,length.out=7),labels=Alab)+
      geom_errorbar(aes(as.POSIXct(extraittab$Datemoynum,origin="1970-01-01"),extraittab$Distance,ymin=extraittab$Distance-extraittab$incert/2,ymax=extraittab$Distance+extraittab$incert/2),width=0)+
      theme(legend.position="none")+
      theme(panel.background = element_blank(),panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                                                               colour = "grey"),panel.border = element_rect(colour = "black", fill=NA, size=0.5))
    if (length(ligneres$OLS)>0)
    {
    colo=c("magenta","green")
    if (length(IC)>0)
    {
      for (ic in 1 : length(IC))
      {
        lwr=(which(colnames(tabres) == paste("OLS",IC[ic],"lwr",sep="")))
        up=(which(colnames(tabres) == paste("OLS",IC[ic],"up",sep="")))
        if (!is.na(tabres[1,lwr]))
        {
          ICplwr=data.frame(xlwr=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),ylwr=tabres[,lwr])
          ICpup=data.frame(xup=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),yup=tabres[,up])
          G3=G3+
            geom_line(data=ICplwr,aes(x=xlwr,y=ylwr),linetype="longdash",col=colo[ic])+
            geom_line(data=ICpup,aes(x=xup,y=yup),linetype="longdash",col=colo[ic])
        }
      }
    }
    }
    
    extraittablev=extraittab[which(extraittab$leve == "LEV"),]
    couleurlev=data.frame(R=LIM$R[extraittablev$marqueur],V=LIM$V[extraittablev$marqueur],B=LIM$B[extraittablev$marqueur])
    if (nrow(extraittablev)>0)
    {
      G3=G3+
        geom_point(data=extraittablev,aes(x=as.POSIXct(extraittablev$Datemoynum,origin="1970-01-01"),y=extraittablev$Distance),shape=rep(15,length(extraittablev[,1])),size=rep(2,length(extraittablev[,1])),color=rgb(couleurlev/256))
    }
    extraittabnum=extraittab[which(extraittab$leve == "NUM"),]
    couleurnum=data.frame(R=LIM$R[extraittabnum$marqueur],V=LIM$V[extraittabnum$marqueur],B=LIM$B[extraittabnum$marqueur])
    if (nrow(extraittabnum)>0)
    {
      G3=G3+
        geom_point(data=extraittabnum,aes(x=as.POSIXct(extraittabnum$Datemoynum,origin="1970-01-01"),y=extraittabnum$Distance),shape=rep(19,length(extraittabnum[,1])),size=rep(2,length(extraittabnum[,1])),color=rgb(couleurnum/256)) 
    }
    
    
    #plan
    # #tous les axes toutes les traces
    # Seg_Trace=data.frame(x=sapply(Tracedeg@lines,function(x) x@Lines[[1]]@coords[1,1]),y=sapply(Tracedeg@lines,function(x) x@Lines[[1]]@coords[1,2]),xend=sapply(Tracedeg@lines,function(x) x@Lines[[1]]@coords[2,1]),yend=sapply(Tracedeg@lines,function(x) x@Lines[[1]]@coords[2,2]))
    # #Tiaxe=subset(Tracedeg,Tracedeg$NAxe==NAxe)
    # #axe et trace pour zoom et en rouge
    # T1=subset(Tracedeg@lines,Tracedeg$NAxe==NAxe & Tracedeg$NTrace==NTrace)
    # T11Coord=T1[[1]]@Lines[[1]]@coords
    # Tracesel=data.frame(lon=T11Coord[,1],lat=T11Coord[,2])
    # Traceligne=Line(Tracesel)
    # Traceselline=Lines(Traceligne,ID=1)
    # 
    # xmoy=mean(T11Coord[,1])
    # ymoy=mean(T11Coord[,2])
    # #Tracebox=c(T1@bbox[1,1],T1@bbox[2,1],T1@bbox[1,2],T1@bbox[2,2])
    # 
    # #T1=Tracedeg@lines[[itr]]@Lines[[1]]@coords
    # 
    # if (plan>0)
    # {
    #   Sys.setenv(http_proxy="http://user:password@proxy_server:port")
    #   nc_map <- get_map(location=c(xmoy,ymoy),maptype = "satellite",zoom=14, source = "google")
    #   
    #   G4=ggmap(nc_map)+
    #     geom_segment(data = Seg_Trace,aes(x = x, y = y,xend=xend,yend=yend))+
    #     geom_path(data = Tracesel,aes(x = lon, y = lat),color="red")+
    #     ggtitle("Plan de situation")+theme(plot.title = element_text(size=10,hjust = 0.5))+
    #     xlab(NULL)+ylab(NULL)
    # } else {
    #   G4=ggplot()+
    #     geom_segment(data = Seg_Trace,aes(x = x, y = y,xend=xend,yend=yend))+
    #     geom_path(data = T,aes(x = lon, y = lat),color="red")+
    #     ggtitle("Plan de situation")+theme(plot.title = element_text(size=10,hjust = 0.5))+
    #     xlab(NULL)+ylab(NULL)#+theme(axis.ticks=element_blank())
    # }
    # plot(G4)
    
    # #tous les axes toutes les traces
    # Seg_Trace=data.frame(x=sapply(Tracedeg@lines,function(x) x@Lines[[1]]@coords[1,1]),y=sapply(Tracedeg@lines,function(x) x@Lines[[1]]@coords[1,2]),xend=sapply(Tracedeg@lines,function(x) x@Lines[[1]]@coords[2,1]),yend=sapply(Tracedeg@lines,function(x) x@Lines[[1]]@coords[2,2]))
    # #Tiaxe=subset(Tracedeg,Tracedeg$NAxe==NAxe)
    # #axe et trace pour zoom et en rouge
    # T1=subset(Tracedeg@lines,Tracedeg$NAxe==NAxe & Tracedeg$NTrace==NTrace)
    # T11Coord=T1[[1]]@Lines[[1]]@coords
    # T=data.frame(lon=T11Coord[,1],lat=T11Coord[,2])
    # xmoy=mean(T11Coord[,1])
    # ymoy=mean(T11Coord[,2])
    # #Tracebox=c(T1@bbox[1,1],T1@bbox[2,1],T1@bbox[1,2],T1@bbox[2,2])
    # 
    # #axe et trace pour zoom et en rouge
    # T1=subset(Tracedeg@lines,Tracedeg$NAxe==NAxe & Tracedeg$NTrace==NTrace)
    # T11Coord=T1[[1]]@Lines[[1]]@coords
    # Tracesel=data.frame(lon=T11Coord[,1],lat=T11Coord[,2])
    # Traceligne=Line(Tracesel)
    # Traceselline=Lines(Traceligne,ID=1)
    # #T1=Tracedeg@lines[[itr]]@Lines[[1]]@coords
    # 
    # if (plan>0)
    # {
    #   #Sys.setenv(http_proxy="http://user:password@proxy_server:port")
    #   #nc_map <- get_map(location=c(xmoy,ymoy),maptype = "satellite",zoom=14, source = "google")
    #   if(!require(leaflet)){install.packages("leaflet")}
    #   library(leaflet)
    #   if(!require(mapview)){install.packages("mapview")}
    #   library(mapview)
    #   if(!require(webshot)){install.packages("webshot")}
    #   library(webshot)
    #   if(!require(jpeg)){install.packages("jpeg")}
    #   library(jpeg)
    #   
    #   nc_map=leaflet()%>%addPolylines(data=Tracedeg,color = "#5F04B4")%>%addPolylines(data=Traceselline,color = "#FF0000")%>%addProviderTiles(providers$Esri.WorldImagery)%>%setView(lng = xmoy, lat = ymoy, zoom = 16)
    #   
    #   mapshot(nc_map,file=paste0(chemin_rep_travail, "\\map.jpeg"),vwidth = 992,vheight = 744)
    #   img <- readJPEG(paste(chemin_rep_travail,"\\map.jpeg",sep=""))
    #   g <- rasterGrob(img, interpolate=TRUE)
    #   G4=ggplot()+plot(1:10, 1:10, geom="blank") +
    #     annotation_custom(g, xmin=-Inf, xmax=Inf, ymin=-Inf, ymax=Inf)+
    #     theme(panel.background = element_blank())+
    #     ggtitle("Plan de situation")+theme(plot.title = element_text(size=10,hjust = 0.5))
    #   
    #   
    # } else {
    #   G4=ggplot()+
    #     geom_segment(data = Seg_Trace,aes(x = x, y = y,xend=xend,yend=yend))+
    #     geom_path(data = T,aes(x = lon, y = lat),color="red")+
    #     ggtitle("Plan de situation")+theme(plot.title = element_text(size=10,hjust = 0.5))+
    #     xlab(NULL)+ylab(NULL)#+theme(axis.ticks=element_blank())
    # }
    # plot(G4)
    G4=ggplot()
    
    #RLS
    G5=ggplot()
    
    if (length(ligneres$RLS)==0)
    {
      G5=G5+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
    } else {
      if (!is.na(ligneres$RLS))
      {
        G5=G5+geom_line(aes(x=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),y=tabres$RLSfit,color="red"))
      } else {
        G5=G5+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
      }
    }
    G5=G5+
      ggtitle(paste('RLS =',ligneres$RLS,"m/an"))+theme(plot.title = element_text(size=10,hjust = 0.5))+
      xlab(NULL)+ylab(NULL)+
      # xlim(xlimg)+
      ylim(ylimg)+
      scale_x_datetime(limits=c(xlimg2,xlimd),breaks=seq(xlimg2,xlimd,length.out=7),labels=Alab)+
      geom_errorbar(aes(as.POSIXct(extraittab$Datemoynum,origin="1970-01-01"),extraittab$Distance,ymin=extraittab$Distance-extraittab$incert/2,ymax=extraittab$Distance+extraittab$incert/2),width=0)+
      theme(legend.position="none")+
      theme(panel.background = element_blank(),panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                                                               colour = "grey"),panel.border = element_rect(colour = "black", fill=NA, size=0.5))
    if (length(ligneres$RLS)>0)
    {
    colo=c("magenta","green")
    if (length(IC)>0)
    {
      for (ic in 1 : length(IC))
      {
        lwr=(which(colnames(tabres) == paste("RLS",IC[ic],"lwr",sep="")))
        up=(which(colnames(tabres) == paste("RLS",IC[ic],"up",sep="")))
        if (!is.na(tabres[1,lwr]))
        {
          ICplwr=data.frame(xlwr=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),ylwr=tabres[,lwr])
          ICpup=data.frame(xup=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),yup=tabres[,up])
          G5=G5+
            geom_line(data=ICplwr,aes(x=xlwr,y=ylwr),linetype="longdash",col=colo[ic])+
            geom_line(data=ICpup,aes(x=xup,y=yup),linetype="longdash",col=colo[ic])
        }
      }
    }
    }
    
    extraittablev=extraittab[which(extraittab$leve == "LEV"),]
    couleurlev=data.frame(R=LIM$R[extraittablev$marqueur],V=LIM$V[extraittablev$marqueur],B=LIM$B[extraittablev$marqueur])
    if (nrow(extraittablev)>0)
    {
      G5=G5+
        geom_point(data=extraittablev,aes(x=as.POSIXct(extraittablev$Datemoynum,origin="1970-01-01"),y=extraittablev$Distance),shape=rep(15,length(extraittablev[,1])),size=rep(2,length(extraittablev[,1])),color=rgb(couleurlev/256))
    }
    extraittabnum=extraittab[which(extraittab$leve == "NUM"),]
    couleurnum=data.frame(R=LIM$R[extraittabnum$marqueur],V=LIM$V[extraittabnum$marqueur],B=LIM$B[extraittabnum$marqueur])
    if (nrow(extraittabnum)>0)
    {
      G5=G5+
        geom_point(data=extraittabnum,aes(x=as.POSIXct(extraittabnum$Datemoynum,origin="1970-01-01"),y=extraittabnum$Distance),shape=rep(19,length(extraittabnum[,1])),size=rep(2,length(extraittabnum[,1])),color=rgb(couleurnum/256)) 
    }
    
    
    #RWLS
    G6=ggplot()
    if (length(ligneres$RWLS)==0)
    {
      G6=G6+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
    } else {
      if (!is.na(ligneres$RWLS))
      {
        G6=G6+geom_line(aes(x=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),y=tabres$RWLSfit,color="red"))
      } else {
        G6=G6+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
      }
    }
    
    G6=G6+ggtitle(paste('RWLS =',ligneres$RWLS,"m/an"))+theme(plot.title = element_text(size=10,hjust = 0.5))+
      xlab(NULL)+ylab(NULL)+
      # xlim(xlimg)+
      ylim(ylimg)+
      scale_x_datetime(limits=c(xlimg2,xlimd),breaks=seq(xlimg2,xlimd,length.out=7),labels=Alab)+
      geom_errorbar(aes(as.POSIXct(extraittab$Datemoynum,origin="1970-01-01"),extraittab$Distance,ymin=extraittab$Distance-extraittab$incert/2,ymax=extraittab$Distance+extraittab$incert/2),width=0)+
      theme(legend.position="none")+
      theme(panel.background = element_blank(),panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                                                               colour = "grey"),panel.border = element_rect(colour = "black", fill=NA, size=0.5))
    if (length(ligneres$RWLS)>0)
    {
    colo=c("magenta","green")
    if (length(IC)>0)
    {
      for (ic in 1 : length(IC))
      {
        lwr=(which(colnames(tabres) == paste("RWLS",IC[ic],"lwr",sep="")))
        up=(which(colnames(tabres) == paste("RWLS",IC[ic],"up",sep="")))
        if (!is.na(tabres[1,lwr]))
        {
          ICplwr=data.frame(xlwr=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),ylwr=tabres[,lwr])
          ICpup=data.frame(xup=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),yup=tabres[,up])
          G6=G6+
            geom_line(data=ICplwr,aes(x=xlwr,y=ylwr),linetype="longdash",col=colo[ic])+
            geom_line(data=ICpup,aes(x=xup,y=yup),linetype="longdash",col=colo[ic])
        }
      }
    }
    }
    
    extraittablev=extraittab[which(extraittab$leve == "LEV"),]
    couleurlev=data.frame(R=LIM$R[extraittablev$marqueur],V=LIM$V[extraittablev$marqueur],B=LIM$B[extraittablev$marqueur])
    if (nrow(extraittablev)>0)
    {
      G6=G6+
        geom_point(data=extraittablev,aes(x=as.POSIXct(extraittablev$Datemoynum,origin="1970-01-01"),y=extraittablev$Distance),shape=rep(15,length(extraittablev[,1])),size=rep(2,length(extraittablev[,1])),color=rgb(couleurlev/256))
    }
    extraittabnum=extraittab[which(extraittab$leve == "NUM"),]
    couleurnum=data.frame(R=LIM$R[extraittabnum$marqueur],V=LIM$V[extraittabnum$marqueur],B=LIM$B[extraittabnum$marqueur])
    if (nrow(extraittabnum)>0)
    {
      G6=G6+
        geom_point(data=extraittabnum,aes(x=as.POSIXct(extraittabnum$Datemoynum,origin="1970-01-01"),y=extraittabnum$Distance),shape=rep(19,length(extraittabnum[,1])),size=rep(2,length(extraittabnum[,1])),color=rgb(couleurnum/256)) 
    }
    
    #WLS
    G7=ggplot()
    if (length(ligneres$WLS)==0)
    {
      G7=G7+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
    } else {
      if (!is.na(ligneres$WLS))
      {
        G7=G7+geom_line(aes(x=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),y=tabres$WLSfit,color="red"))
      } else {
        G7=G7+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
      }
    }
    
    G7=G7+ggtitle(paste('NAxe :',NAxe,'- Ntrace :',NTrace,'- Loc :',Loc,'- WLS =',ligneres$WLS,"m/an"))+theme(plot.title = element_text(size=14,hjust = 0.5))+
      # xlim(xlimg)+
      ylim(ylimg)+
      scale_x_datetime(limits=c(xlimg2,xlimd),breaks=seq(xlimg2,xlimd,length.out=7),labels=Alab)+
      geom_errorbar(aes(as.POSIXct(extraittab$Datemoynum,origin="1970-01-01"),extraittab$Distance,ymin=extraittab$Distance-extraittab$incert/2,ymax=extraittab$Distance+extraittab$incert/2),width=0)+
      theme(legend.position="none")+
      theme(panel.background = element_blank(),panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                                                               colour = "grey"),panel.border = element_rect(colour = "black", fill=NA, size=0.5))+
      theme(plot.margin = unit(c(4, 4, 14, 4), "pt"))
    if (length(ligneres$WLS)>0)
    {
    colo=c("magenta","green")
    if (length(IC)>0)
    {
      for (ic in 1 : length(IC))
      {
        lwr=(which(colnames(tabres) == paste("WLS",IC[ic],"lwr",sep="")))
        up=(which(colnames(tabres) == paste("WLS",IC[ic],"up",sep="")))
        if (!is.na(tabres[1,lwr]))
        {
          ICplwr=data.frame(xlwr=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),ylwr=tabres[,lwr])
          ICpup=data.frame(xup=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),yup=tabres[,up])
          G7=G7+
            geom_line(data=ICplwr,aes(x=xlwr,y=ylwr),linetype="longdash",col=colo[ic])+
            geom_line(data=ICpup,aes(x=xup,y=yup),linetype="longdash",col=colo[ic])
        }
      }
    }
    }
    extraittablev=extraittab[which(extraittab$leve == "LEV"),]
    couleurlev=data.frame(R=LIM$R[extraittablev$marqueur],V=LIM$V[extraittablev$marqueur],B=LIM$B[extraittablev$marqueur])
    if (nrow(extraittablev)>0)
    {
      G7=G7+
        geom_point(data=extraittablev,aes(x=as.POSIXct(extraittablev$Datemoynum,origin="1970-01-01"),y=extraittablev$Distance),shape=rep(15,length(extraittablev[,1])),size=rep(3,length(extraittablev[,1])),color=rgb(couleurlev/256))
    }
    extraittabnum=extraittab[which(extraittab$leve == "NUM"),]
    couleurnum=data.frame(R=LIM$R[extraittabnum$marqueur],V=LIM$V[extraittabnum$marqueur],B=LIM$B[extraittabnum$marqueur])
    if (nrow(extraittabnum)>0)
    {
      G7=G7+
        geom_point(data=extraittabnum,aes(x=as.POSIXct(extraittabnum$Datemoynum,origin="1970-01-01"),y=extraittabnum$Distance),shape=rep(19,length(extraittabnum[,1])),size=rep(3,length(extraittabnum[,1])),color=rgb(couleurnum/256)) 
    }
   
    if (length(ligneres$WLS)!=0)
    {
      if (!is.na(ligneres$WLS))
      {
        G7=G7+
          geom_line(aes(x=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),y=tabres$WLSfit),linetype="solid",col="red")
      }
    }
    
    #l?gende des fournisseurs
    texte_fourn=paste("Fournisseurs")
    for (k in 1:length(unique(extraittab$product)))
    {
      texte_fourn=paste(texte_fourn,unique(extraittab$product)[k],sep=" - ")
    }
    G7=G7+
      labs(x=texte_fourn,y="Distance par rapport à la ligne de base (m)")+
      theme(axis.title.x=element_text(size=12,face="bold",vjust=-2))
    
    
    #l?gende des lim
    for (ilim in 1:length(unique(extraittab$marqueur)))
    {
      limi=unique(extraittab$marqueur)[ilim]
      texte=LIM$LIM[limi]
      G7=G7+
        annotation_custom(grid.text(label = texte,x=unit(0,"npc"),y=unit(1,"npc")-unit(ilim,"line"),hjust = 0,gp=gpar(col=rgb(LIM$R[limi]/256,LIM$V[limi]/256,LIM$B[limi]/256))))
    }
    
    #l?gende du graphique
    #2 cas : gauche si WLS neg et droite si WLS pos -> ? faire
    texte_legend=c("Trait de côte levé","Trait de côte digitalisé","Erreur sur le trait de côte","Tendance linéaire")
    taille=3
    #a gauche
    G7=G7+
      geom_point(aes(x=xlimg[1]+0.015*dx,y=ylimg[1]),shape=0,size=2)+
      annotate("text", x = xlimg[1]+0.04*dx, y = ylimg[1], label = texte_legend[1],hjust=0,size=taille)+
      geom_point(aes(x=xlimg[1]+0.015*dx,y=ylimg[1]+dy*0.03),shape=1,size=2)+
      annotate("text", x = xlimg[1]+0.04*dx, y = ylimg[1]+dy*0.03, label = texte_legend[2],hjust=0,size=taille)+
      geom_errorbar(aes(x=xlimg[1]+0.015*dx,ymin=ylimg[1]+dy*(0.03+0.02),ymax=ylimg[1]+dy*(0.03+0.04)),size=0.5,width=4)+
      annotate("text", x = xlimg[1]+0.04*dx, y = ylimg[1]+dy*(0.03+0.03), label = texte_legend[3],hjust=0,size=taille)+
      geom_segment(aes(x=xlimg[1], y=ylimg[1]+dy*(0.03*3),xend=xlimg[1]+0.03*dx,yend=ylimg[1]+dy*(0.03+0.04+0.02)),colour='red')+
      annotate("text", x = xlimg[1]+0.04*dx, y = ylimg[1]+dy*(0.03*3), label = texte_legend[4],hjust=0,size=taille)
    
    if (length(ligneres$WLS)>0)
    {
    if (length(IC)>0)
    {
      posIC=data.frame(x=rep(xlimg[1],length(IC)),
                       y=ylimg[1]+dy*(0.03*(3+seq(1,length(IC)))),
                       xend=rep(xlimg[1]+0.03*dx,length(IC)),
                       yend=ylimg[1]+dy*(0.03*(3+seq(1,length(IC)))))
      colIC=c("magenta","green")
      tx_ic=paste("Intervalle de confiance à", IC[length(IC):1],"%")
      G7=G7+
        geom_segment(aes(x=posIC$x, y=posIC$y,xend=posIC$xend,yend=posIC$yend,colour=colIC[1:length(IC)]),linetype=rep("longdash",length(IC)))+
        annotate("text", x = posIC$x+0.04*dx, y = posIC$y, label = tx_ic,hjust=0,size=taille)
    }
    }
    
    
    #JK
    
    G8=ggplot()
    if (length(ligneres$JK)==0)
    {
      G8=G8+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
    } else {
    
      if (!is.na(ligneres$JK))
      {
        G8=G8+
          geom_line(aes(x=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),y=tabres$JKfit,color="red"))
      }  else {
        G8=G8+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
      }
    }
    
    G8=G8+ggtitle(paste('JK =',ligneres$JK,"m/an"))+theme(plot.title = element_text(size=10,hjust = 0.5))+
      xlab(NULL)+ylab(NULL)+
      # xlim(xlimg)+
      ylim(ylimg)+
      scale_x_datetime(limits=c(xlimg2,xlimd),breaks=seq(xlimg2,xlimd,length.out=7),labels=Alab)+
      geom_errorbar(aes(as.POSIXct(extraittab$Datemoynum,origin="1970-01-01"),extraittab$Distance,ymin=extraittab$Distance-extraittab$incert/2,ymax=extraittab$Distance+extraittab$incert/2),width=0)+
      theme(legend.position="none")+
      theme(panel.background = element_blank(),panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                                                               colour = "grey"),panel.border = element_rect(colour = "black", fill=NA, size=0.5))
    if (length(ligneres$JK)>0)
    {
    colo=c("magenta","green")
    if (length(IC)>0)
    {
      for (ic in 1 : length(IC))
      {
        lwr=(which(colnames(tabres) == paste("JK",IC[ic],"lwr",sep="")))
        up=(which(colnames(tabres) == paste("JK",IC[ic],"up",sep="")))
        if (!is.na(tabres[1,lwr]))
        {
          ICplwr=data.frame(xlwr=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),ylwr=tabres[,lwr])
          ICpup=data.frame(xup=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),yup=tabres[,up])
          G8=G8+
            geom_line(data=ICplwr,aes(x=xlwr,y=ylwr),linetype="longdash",col=colo[ic])+
            geom_line(data=ICpup,aes(x=xup,y=yup),linetype="longdash",col=colo[ic])
        }
      }
    }
    }
    extraittablev=extraittab[which(extraittab$leve == "LEV"),]
    couleurlev=data.frame(R=LIM$R[extraittablev$marqueur],V=LIM$V[extraittablev$marqueur],B=LIM$B[extraittablev$marqueur])
    if (nrow(extraittablev)>0)
    {
      G8=G8+
        geom_point(data=extraittablev,aes(x=as.POSIXct(extraittablev$Datemoynum,origin="1970-01-01"),y=extraittablev$Distance),shape=rep(15,length(extraittablev[,1])),size=rep(2,length(extraittablev[,1])),color=rgb(couleurlev/256))
    }
    extraittabnum=extraittab[which(extraittab$leve == "NUM"),]
    couleurnum=data.frame(R=LIM$R[extraittabnum$marqueur],V=LIM$V[extraittabnum$marqueur],B=LIM$B[extraittabnum$marqueur])
    if (nrow(extraittabnum)>0)
    {
      G8=G8+
        geom_point(data=extraittabnum,aes(x=as.POSIXct(extraittabnum$Datemoynum,origin="1970-01-01"),y=extraittabnum$Distance),shape=rep(19,length(extraittabnum[,1])),size=rep(2,length(extraittabnum[,1])),color=rgb(couleurnum/256)) 
    }
    
    
    #MDL
    G9=ggplot()
    if (length(ligneres$K)==0)
    {
      G9=G9+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
    } else {
      if (!is.na(tabres$MDLOLSfit[1])) {
        G9=G9+geom_line(aes(x=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),y=tabres$MDLOLSfit,color="red"))
      } else {
        G9=G9+annotate("text", x = xlimg[1]+dx/2, y = ylimg[1]+dy/2, label = "calcul impossible",hjust=0.5,vjust=0.5,size=5)
      }
    }
    
    G9=G9+
      xlab(NULL)+ylab(NULL)+
      # xlim(xlimg)+
      ylim(ylimg)+
      scale_x_datetime(limits=c(xlimg2,xlimd),breaks=seq(xlimg2,xlimd,length.out=7),labels=Alab)+
      geom_errorbar(aes(as.POSIXct(extraittab$Datemoynum,origin="1970-01-01"),extraittab$Distance,ymin=extraittab$Distance-extraittab$incert/2,ymax=extraittab$Distance+extraittab$incert/2),width=0)+
      theme(legend.position="none")+
      theme(panel.background = element_blank(),panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                                                               colour = "grey"),panel.border = element_rect(colour = "black", fill=NA, size=0.5))      
    
    extraittablev=extraittab[which(extraittab$leve == "LEV"),]
    couleurlev=data.frame(R=LIM$R[extraittablev$marqueur],V=LIM$V[extraittablev$marqueur],B=LIM$B[extraittablev$marqueur])
    if (nrow(extraittablev)>0)
    {
      G9=G9+
        geom_point(data=extraittablev,aes(x=as.POSIXct(extraittablev$Datemoynum,origin="1970-01-01"),y=extraittablev$Distance),shape=rep(15,length(extraittablev[,1])),size=rep(2,length(extraittablev[,1])),color=rgb(couleurlev/256))
    }
    extraittabnum=extraittab[which(extraittab$leve == "NUM"),]
    couleurnum=data.frame(R=LIM$R[extraittabnum$marqueur],V=LIM$V[extraittabnum$marqueur],B=LIM$B[extraittabnum$marqueur])
    if (nrow(extraittabnum)>0)
    {
      G9=G9+
        geom_point(data=extraittabnum,aes(x=as.POSIXct(extraittabnum$Datemoynum,origin="1970-01-01"),y=extraittabnum$Distance),shape=rep(19,length(extraittabnum[,1])),size=rep(2,length(extraittabnum[,1])),color=rgb(couleurnum/256)) 
    }
    
    if (length(ligneres$K)!=0)
    {
      if (!is.na(ligneres$K))
      {
        if (ligneres$K<3)
        {
          G9=G9+
            ggtitle(paste('MDL =',ligneres$MDL,"m/an"))+theme(plot.title = element_text(size=10,hjust = 0.5))
        } else {
          Jkpoly=data.frame(x=as.POSIXct(tabres$numdateTDC, origin = "1970-01-01"),y= tabres$MDLpolyfit)
          G9=G9+
            ggtitle(paste('MDL-0 =',ligneres$MDL,"m/an - DateK =",ligneres$DateK))+theme(plot.title = element_text(size=10,hjust = 0.5))+
            geom_line(data=Jkpoly,aes(x=x,y=y),colour="grey")
        }
      } else {
        G9=G9+
          ggtitle(paste('MDL =',ligneres$MDL,"m/an"))+theme(plot.title = element_text(size=10,hjust = 0.5))
      }
    } else {
      #G9=G9+ggtitle(paste("MDL = NA m/an"))+theme(plot.title = element_text(size=10,hjust = 0.5))
    }
    
    texte_leg=c("  modèle linéaire","  modèle linéaire","  modèle parabolique","  modèle cubique")
    col_leg=c("red","red","grey","grey")
    
    if (length(ligneres$K)!=0)
    {
    G9=G9+
      annotate("segment",x=xlimg[1],xend=xlimg[1]+3/100*dx,y=ylimg[1],yend=ylimg[1],colour=col_leg[ligneres$K])+
      annotate("text", x = xlimg[1]+3/100*dx, y = ylimg[1], label = texte_leg[ligneres$K],hjust=0)
    }
    # 
    # #plot g?n?ral
    # 
    # multiplot(G1,G2,G3,G4,G5,G6,G7,G8,G9,layout=mise_en_page)
    # 
    # dev.off()
  
  
  
    if (!is.na(datecoup))
    {
      datecoupdate=as.POSIXct(strptime(paste0(as.character(datecoup),"-1-1 0:0:0"),"%Y-%m-%d %H:%M:%S"))
      G1=G1+geom_rect(aes(xmin=xlimg[1],xmax=datecoupdate,ymin=-Inf,ymax=Inf),colour="grey50",alpha=0.2)
      G2=G2+geom_rect(aes(xmin=xlimg[1],xmax=datecoupdate,ymin=-Inf,ymax=Inf),colour="grey50",alpha=0.2)
      G3=G3+geom_rect(aes(xmin=xlimg[1],xmax=datecoupdate,ymin=-Inf,ymax=Inf),colour="grey50",alpha=0.2)
      G5=G5+geom_rect(aes(xmin=xlimg[1],xmax=datecoupdate,ymin=-Inf,ymax=Inf),colour="grey50",alpha=0.2)
      G6=G6+geom_rect(aes(xmin=xlimg[1],xmax=datecoupdate,ymin=-Inf,ymax=Inf),colour="grey50",alpha=0.2)
      G7=G7+geom_rect(aes(xmin=xlimg[1],xmax=datecoupdate,ymin=-Inf,ymax=Inf),colour="grey50",alpha=0.2)
      G8=G8+geom_rect(aes(xmin=xlimg[1],xmax=datecoupdate,ymin=-Inf,ymax=Inf),colour="grey50",alpha=0.2)
      G9=G9+geom_rect(aes(xmin=xlimg[1],xmax=datecoupdate,ymin=-Inf,ymax=Inf),colour="grey50",alpha=0.2)
  
    }
    
    #pour pr?sentation
    G10=ggplot()
    
    G10=G10+ggtitle("Traits de côte sur la trace")+theme(plot.title = element_text(size=10,hjust = 0.5))+
      xlab(NULL)+ylab(NULL)+
      # xlim(xlimg)+
      ylim(ylimg)+
      geom_errorbar(aes(as.POSIXct(extraittab$Datemoynum,origin="1970-01-01"),extraittab$Distance,ymin=extraittab$Distance-extraittab$incert/2,ymax=extraittab$Distance+extraittab$incert/2),width=0)+
      scale_x_datetime(limits=c(xlimg2,xlimd),breaks=seq(xlimg2,xlimd,length.out=7),labels=Alab)+
      theme(legend.position="none")+
      theme(panel.background = element_blank(),panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                                                               colour = "grey"),panel.border = element_rect(colour = "black", fill=NA, size=0.5))
    
    extraittablev=extraittab[which(extraittab$leve == "LEV"),]
    couleurlev=data.frame(R=LIM$R[extraittablev$marqueur],V=LIM$V[extraittablev$marqueur],B=LIM$B[extraittablev$marqueur])
    if (nrow(extraittablev)>0)
    {
      G10=G10+
        geom_point(data=extraittablev,aes(x=as.POSIXct(extraittablev$Datemoynum,origin="1970-01-01"),y=extraittablev$Distance),shape=rep(15,length(extraittablev[,1])),size=rep(2,length(extraittablev[,1])),color=rgb(couleurlev/256))
    }
    extraittabnum=extraittab[which(extraittab$leve == "NUM"),]
    couleurnum=data.frame(R=LIM$R[extraittabnum$marqueur],V=LIM$V[extraittabnum$marqueur],B=LIM$B[extraittabnum$marqueur])
    if (nrow(extraittabnum)>0)
    {
      G10=G10+
        geom_point(data=extraittabnum,aes(x=as.POSIXct(extraittabnum$Datemoynum,origin="1970-01-01"),y=extraittabnum$Distance),shape=rep(19,length(extraittabnum[,1])),size=rep(2,length(extraittabnum[,1])),color=rgb(couleurnum/256)) 
    }
    #l?gende des fournisseurs
    texte_fourn=paste("Fournisseurs")
    for (k in 1:length(unique(extraittab$product)))
    {
      texte_fourn=paste(texte_fourn,unique(extraittab$product)[k],sep=" - ")
    }
    G10=G10+
      labs(x=texte_fourn,y="Distance par rapport à la ligne de base (m)")+
      theme(axis.title.x=element_text(size=12,face="bold",vjust=-1))
    
    
    #l?gende des lim
    for (ilim in 1:length(unique(extraittab$marqueur)))
    {
      limi=unique(extraittab$marqueur)[ilim]
      texte=LIM$LIM[limi]
      G10=G10+
        annotation_custom(grid.text(label = texte,x=unit(0,"npc"),y=unit(1,"npc")-unit(ilim,"line"),hjust = 0,gp=gpar(col=rgb(LIM$R[limi]/256,LIM$V[limi]/256,LIM$B[limi]/256))))
    }
    
    #l?gende du graphique
    #2 cas : gauche si WLS neg et droite si WLS pos -> ? faire
    texte_legend=c("Trait de côte levé","Trait de côte digitalisé","Erreur sur le trait de côte")
    taille=3
    #a gauche
    G10=G10+
      geom_point(aes(x=xlimg[1]+0.015*dx,y=ylimg[1]),shape=0,size=2)+
      annotate("text", x = xlimg[1]+0.04*dx, y = ylimg[1], label = texte_legend[1],hjust=0,size=taille)+
      geom_point(aes(x=xlimg[1]+0.015*dx,y=ylimg[1]+dy*0.03),shape=1,size=2)+
      annotate("text", x = xlimg[1]+0.04*dx, y = ylimg[1]+dy*0.03, label = texte_legend[2],hjust=0,size=taille)+
      geom_errorbar(aes(x=xlimg[1]+0.015*dx,ymin=ylimg[1]+dy*(0.03+0.02),ymax=ylimg[1]+dy*(0.03+0.04)),size=0.5,width=4)+
      annotate("text", x = xlimg[1]+0.04*dx, y = ylimg[1]+dy*(0.03+0.03), label = texte_legend[3],hjust=0,size=taille)
  }
 
  return(list(G1,G2,G3,G4,G5,G6,G7))#,G8,G9,Tracedeg,Traceselline,ligneres$NAxe,ligneres$NTrace,ligneres$WLS,length(extraittab2$Distance),LIM$LIM[extraittab1$marqueur[1]],Squedeg,G10,ligneresprec$NAxe,ligneresprec$NTrace,ligneressuiv$NAxe,ligneressuiv$NTrace,Loc))

  }

