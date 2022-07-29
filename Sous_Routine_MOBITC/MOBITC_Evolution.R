#verif utf-8
#version 22-07-2022
#réalisée par C Trmal Cerema

# chemin_rep_travail="C:\\0_ENCOURS\\TPM\\Erosion\\MobiTC"
# dirr=R.home()
# chem_mobitc=paste(dirr,"/Cerema/MOBITC",sep="")

# fichier_intersection="20190517T152421-TPM-Sque-cont-Tra-P50-L0100sel-lisse-filtre3-mod-IntersTDC-v1.txt"
# 
# produc="Cerema"
# ICtx=c("IC70"),"IC90")
# datedebgraph="1920"
# datefingraph="2040"
# dateprosp1="2050"
# dateprosp2="2100"
# #fichier_intersection="20180502T124233--Env-C010-T0250-Sque-C001liersimpl-Carnon-Tra-P50-L0200-select-IntersTDC-v1.txt"
# fichier_intersection="sque_Alpes_Maritimes_snake-Tra-P50-L0200-IntersTDC-v1.txt"

MOBITC_Evolution<-function(chem_mobitc,chemin_rep_travail,fichier_intersection,produc,ICtx,datedebgraph,datefingraph,dateprosp1,dateprosp2,datedebevol)
{
  # datedebevol="1950;1980;2000;2010"
  # datedebevol="1980;2000"
  
#lecture du fichier intersection V1 normalement
chem_intersection=paste(chemin_rep_travail,"\\",fichier_intersection,sep="")
tab0=read.table(chem_intersection,sep="\t",header=TRUE,row.names = NULL)

#ecriture dans le fichier parametre 
	fichier_init=paste(chem_mobitc,"\\Init_Routine_MobiTC.txt",sep="")
	fid=file(fichier_init, open = "r+")
	lignes=readLines(fid)
	lignes[14]=produc
	lignes[16]=ICtx
	lignes[18]=datedebgraph
	lignes[20]=datefingraph
	lignes[22]=dateprosp1
	lignes[23]=dateprosp2
	lignes[25]=datedebevol
	cat(lignes,file=fid,sep="\n")
	close(fid)

nomdirgraph=paste(chemin_rep_travail,"\\Graph",sep="")
if (file.exists(nomdirgraph)=="FALSE"){dir.create(nomdirgraph)}

#modif des dates dans le tableau de départ
source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Convertdate_2.R",sep=""))	
tab00=MOBITC_Convertdate_2(tab0)
datedebgraph_c=paste(datedebgraph,"-01-01 00:00:00",sep="")
numdatedebgraph=as.numeric(as.POSIXct(strptime(datedebgraph_c,"%Y-%m-%d %H:%M:%S")))

datefingraph_c=paste(datefingraph,"-01-01 00:00:00",sep="")
numdatefingraph=as.numeric(as.POSIXct(strptime(datefingraph_c,"%Y-%m-%d %H:%M:%S")))

dateprosp1_c=paste(dateprosp1,"-01-01 00:00:00",sep="")
numdateprosp1=as.numeric(as.POSIXct(strptime(dateprosp1_c,"%Y-%m-%d %H:%M:%S")))
dateprosp2_c=paste(dateprosp2,"-01-01 00:00:00",sep="")
numdateprosp2=as.numeric(as.POSIXct(strptime(dateprosp2_c,"%Y-%m-%d %H:%M:%S")))

#convertion IC
IC=as.numeric(substr(ICtx,3,4))

#conversion datedebevol
datecoup=as.data.frame(strsplit(datedebevol,";"))
nrow(datecoup)

for (ievol in 1:(nrow(datecoup)+1))
{

  if (ievol==1)
  {
    #export
    tab=tab00
    nomexp=paste(substr(fichier_intersection,1,nchar(fichier_intersection)-4),"-toutesdates-MobiTC.txt",sep="")
  } else {
    datecoupnum=as.numeric(as.POSIXct(strptime(paste0(as.character(datecoup[[1]][ievol-1]),"-1-1 0:0:0"),"%Y-%m-%d %H:%M:%S")))
    tab=tab00[which(tab00$Datemoynum>=datecoupnum),]
    #export
    nomexp=paste(substr(fichier_intersection,1,nchar(fichier_intersection)-4),"-post",as.character(datecoup[[1]][ievol-1]),"-MobiTC.txt",sep="")
  }
  tabloc=tab
  print(nomexp)
  chemexp=paste(chemin_rep_travail,"\\",nomexp,sep="")
    
    file.remove(chemexp)
   
    if (length(tab$Loc)>0)
    {
      nloc=length(unique(tab$Loc))
      Loc=tab$Loc
    } else {
      Loc=0
      nloc=1}
  
    for (iloc in 1 :nloc)
    {
      if (length(Loc)>1)
      {
      tab=tabloc
      } else {
        tab=tabloc[which(tabloc$Loc==unique(tabloc$Loc)[iloc]),]
      }
      
  
    for (iaxe in 1 : length(unique(tab$NAxe)))
    {
  	itemp=which(tab$NAxe ==unique(tab$NAxe)[iaxe])
  	#calcul du nombre de trace
  	NbTrace=length(unique(tab$NTrace[itemp]))
  	print(NbTrace)
  	#boucle sur les traces
  	for (itr in 1:NbTrace)
  	{
  		#print(itr)
  	  Loci=as.character(unique(tab$Loc))
  	  if (is.na(as.numeric(Loci)))
  	  {
  	    Locc=Loci
  	  } else {
  	    Locc=as.character(formatC(as.numeric(Loci), width = 5, format = "d", flag = "0"))
  	  }
  	  
  		NAxe=unique(tab$NAxe)[iaxe]
  		NTrace=unique(tab$NTrace[itemp])[itr]
  		extraittab=tab[which(tab$NAxe == NAxe & tab$NTrace == NTrace),]
  		Xsque=extraittab$Xsque[1]
  		Ysque=extraittab$Ysque[1]
  		U=extraittab$U[1]
  		V=extraittab$V[1]
  		Angle=round(atan(V)/atan(U),digits=3)
  		Marqueur=extraittab$marqueur[1]
  		NDate=nrow(extraittab)
  		DateTDCvieux=as.POSIXct(min(extraittab$Datemoynum,na.rm = TRUE),origin = "1970-01-01")
  		DateTDCrecent=as.POSIXct(max(extraittab$Datemoynum,na.rm = TRUE),origin = "1970-01-01")
  		
  		Duree=round(difftime(DateTDCrecent,DateTDCvieux,units="days")/365.25,digits = 3)
  		
  		Amplitude=round(max(extraittab$Distance,na.rm = TRUE)-min(extraittab$Distance,na.rm = TRUE),digits=3)
  		
  		if (length(Loc)>1)
  		{
  		  ligneres=cbind(NAxe,NTrace,Xsque,Ysque,U,V,Angle,NDate,Duree,Amplitude,DateTDCvieux=format(DateTDCvieux,"%Y-%m-%d"),DateTDCrecent=format(DateTDCrecent,"%Y-%m-%d"),Marqueur)
  		  } else {
  		  ligneres=cbind(NAxe,NTrace,Loc=Locc,Xsque,Ysque,U,V,Angle,NDate,Duree,Amplitude,DateTDCvieux=format(DateTDCvieux,"%Y-%m-%d"),DateTDCrecent=format(DateTDCrecent,"%Y-%m-%d"),Marqueur)
  		  }
  		  ligneres=as.data.frame(ligneres)
  		
  		if (length(Loc)>1)
  		{
  		
    		if (ievol==1)
    		{
    		nomexp2=paste(substr(fichier_intersection,1,nchar(fichier_intersection)-4),"-toutesdates-MobiTC-Courbe-NAxe",NAxe,"-NTrace",NTrace,".txt",sep="")
    		} else {
    	  nomexp2=paste(substr(fichier_intersection,1,nchar(fichier_intersection)-4),"-post",as.character(datecoup[[1]][ievol-1]),"-MobiTC-Courbe-NAxe",NAxe,"-NTrace",NTrace,".txt",sep="")
    		}
  		  } else {
  		  if (ievol==1)
  		  {
  		    nomexp2=paste(substr(fichier_intersection,1,nchar(fichier_intersection)-4),"-toutesdates-MobiTC-Courbe-NAxe",NAxe,"-NTrace",NTrace,"-Loc",Locc,".txt",sep="")
  		  } else {
  		    nomexp2=paste(substr(fichier_intersection,1,nchar(fichier_intersection)-4),"-post",as.character(datecoup[[1]][ievol-1]),"-MobiTC-Courbe-NAxe",NAxe,"-NTrace",NTrace,"-Loc",Locc,".txt",sep="")
  		  }
  		}
  		chemexp2=paste(nomdirgraph,"\\",nomexp2,sep="")
  		
  		file.remove(chemexp2)
  		
  		datex <- data.frame(numdateTDC=c(seq(numdatedebgraph,numdatefingraph,length.out=100),numdateprosp1,numdateprosp2))
  		numdateprosp=numdateprosp1
  			#EPR
  			source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_EPR.R",sep=""))
  			extraittabEPR=extraittab[which(extraittab$Datemoynum == min(extraittab$Datemoynum,na.rm = TRUE) | extraittab$Datemoynum == max(extraittab$Datemoynum,na.rm = TRUE)),]
  			sortieEPR=MOBITC_Stat_EPR(extraittabEPR$Distance,extraittabEPR$Datemoynum,IC,datex,numdateprosp)
  			
  			if (nrow(sortieEPR[[2]])==nrow(datex))
  			{tabres=cbind(datex,sortieEPR[[2]])} else
  			{ sortiemod=data.frame(rep("NaN",nrow(datex)))
    			for (i in 2 : ncol(sortieEPR[[2]]))
    			{
    			  sortiemod=cbind(sortiemod,rep("NaN",nrow(datex)))
    			}
    			colnames(sortiemod)=colnames(sortieEPR[[2]])
    			tabres=cbind(tabres,sortiemod)
  			}
  	    ligneres$EPR=sortieEPR[[1]]
  			
  			
  			#AOR		
  			source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_AOR.R",sep=""))	
  			sortieAOR=MOBITC_Stat_AOR(extraittab$Distance,extraittab$Datemoynum,IC,datex,numdateprosp)
  			
  			if (nrow(sortieAOR[[2]])==nrow(datex))
  			{tabres=cbind(tabres,sortieAOR[[2]])} else
  			{ sortiemod=data.frame(rep("NaN",nrow(datex)))
  			for (i in 2 : ncol(sortieAOR[[2]]))
  			{
  			  sortiemod=cbind(sortiemod,rep("NaN",nrow(datex)))
  			}
  			colnames(sortiemod)=colnames(sortieAOR[[2]])
  			tabres=cbind(tabres,sortiemod)
  			}
      	ligneres$AOR=sortieAOR[[1]]
      			
  			
  			#OLS
  			source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_OLS.R",sep=""))	
  			sortieOLS=MOBITC_Stat_OLS(extraittab$Distance,extraittab$Datemoynum,IC,datex,numdateprosp)
  			
  			if (nrow(sortieOLS[[2]])==nrow(datex))
  			{tabres=cbind(tabres,sortieOLS[[2]])} else
  			{ sortiemod=data.frame(rep("NaN",nrow(datex)))
  			for (i in 2 : ncol(sortieOLS[[2]]))
  			{
  			  sortiemod=cbind(sortiemod,rep("NaN",nrow(datex)))
  			}
  			colnames(sortiemod)=colnames(sortieOLS[[2]])
  			tabres=cbind(tabres,sortiemod)
  			}
      	ligneres$OLS=sortieOLS[[1]]
    	
  			#WLS
  			source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_WLS.R",sep=""))	
  			sortieWLS=MOBITC_Stat_WLS(extraittab$Distance,extraittab$Datemoynum,extraittab$incert,IC,datex,numdateprosp)
  
  			if (nrow(sortieWLS[[2]])==nrow(datex))
  			{tabres=cbind(tabres,sortieWLS[[2]])} else
  			{ sortiemod=data.frame(rep("NaN",nrow(datex)))
  			for (i in 2 : ncol(sortieWLS[[2]]))
  			{
  			  sortiemod=cbind(sortiemod,rep("NaN",nrow(datex)))
  			}
  			colnames(sortiemod)=colnames(sortieWLS[[2]])
  			tabres=cbind(tabres,sortiemod)
  			}
      	ligneres$WLS=sortieWLS[[1]]
      			
  			#RLS
  			source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_RLS.R",sep=""))	
  			sortieRLS=MOBITC_Stat_RLS(extraittab$Distance,extraittab$Datemoynum,IC,datex,numdateprosp)
  			if (nrow(sortieRLS[[2]])==nrow(datex))
  			{tabres=cbind(tabres,sortieRLS[[2]])} else
    			{ sortiemod=data.frame(rep("NaN",nrow(datex)))
    			  for (i in 2 : ncol(sortieRLS[[2]]))
    			  {
    			  sortiemod=cbind(sortiemod,rep("NaN",nrow(datex)))
    			  }
    			  colnames(sortiemod)=colnames(sortieRLS[[2]])
    			  tabres=cbind(tabres,sortiemod)
    			}
  			ligneres$RLS=sortieRLS[[1]]
  
  			#RWLS
  			source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_RWLS.R",sep=""))	
  			sortieRWLS=MOBITC_Stat_RWLS(extraittab$Distance,extraittab$Datemoynum,extraittab$incert,IC,datex,numdateprosp)
  			
  			if (nrow(sortieRWLS[[2]])==nrow(datex))
  			{tabres=cbind(tabres,sortieRWLS[[2]])} else
    			{ sortiemod=data.frame(rep("NaN",nrow(datex)))
      			for (i in 2 : ncol(sortieRWLS[[2]]))
      			{
      			  sortiemod=cbind(sortiemod,rep("NaN",nrow(datex)))
      			}
      			colnames(sortiemod)=colnames(sortieRWLS[[2]])
      			tabres=cbind(tabres,sortiemod)
    			}
        ligneres$RWLS=sortieRWLS[[1]]
  			
  			#JK
  			source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_JK.R",sep=""))	
  			sortieJK=MOBITC_Stat_JK(extraittab$Distance,extraittab$Datemoynum,IC,datex,numdateprosp)
  			
  			if (nrow(sortieJK[[2]])==nrow(datex))
  			{tabres=cbind(tabres,sortieJK[[2]])} else
  			{ sortiemod=data.frame(rep("NaN",nrow(datex)))
  			for (i in 2 : ncol(sortieJK[[2]]))
  			{
  			  sortiemod=cbind(sortiemod,rep("NaN",nrow(datex)))
  			}
  			colnames(sortiemod)=colnames(sortieJK[[2]])
  			tabres=cbind(tabres,sortiemod)
  			}
        ligneres$JK=sortieJK[[1]]			
  			
  			#MDL
  			source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_MDL.R",sep=""))	
  			sortieMDL=MOBITC_Stat_MDL(chem_mobitc,extraittab$Distance,extraittab$Datemoynum,IC,datex,numdateprosp,extraittab$incert)
  			tabres=cbind(tabres,sortieMDL[[2]])
  			ligneres$K=sortieMDL[[3]]
  			ligneres$MDL=sortieMDL[[1]]
  			ligneres$DateK=sortieMDL[[4]]
  			
  		write.table(tabres,chemexp2,sep="\t",eol="\n",append=TRUE,quote=FALSE,row.names=FALSE,col.names=TRUE)
  	
  		
  		if (iloc==1 & itr==1 & iaxe==1)
  		{
  			tabf=ligneres
  		} else {
  			tabf=rbind(tabf,ligneres)
  		}
  		
  		#graphique
  		
  	} #fin des traces
  } #fin des axes
    } #fin des locs

  	tabf=cbind(tabf,Product=rep(produc,nrow(tabf)),DateProd=format(Sys.time(),"%Y-%m-%d"))
  	write.table(tabf,chemexp,sep="\t",eol="\n",append=TRUE,quote=FALSE,row.names=FALSE,col.names=TRUE)
  	
} #fin des boucles sur dates evol

textsortie="calcul fini evolution"

return(list(textsortie,tabf))
}

