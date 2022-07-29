#verif utf-8
#version 18-12-2020
#réalisée par C Trmal Cerema

# distTDC=extraittab$Distance
# numdateTDC=extraittab$Datemoynum
# Incertitude=extraittab$incert

MOBITC_Stat_MDL<-function(chem_mobitc,distTDC,numdateTDC,IC,datex,numdateprosp,Incertitude)
{
  AdateK=NA
  if (length(distTDC)>1)
	{
		Incertdata=mean(Incertitude,na.rm=TRUE)/2
		if (is.na(Incertdata)) {Incertdata=50}
		Ek=cbind(rep(0, 4))
		MDL=cbind(rep(0, 4))		
		
	  for (K in seq(1,4))
		{
	    if (K==1) {
	    cst=mean(distTDC)
	    Ek[K]=sum((cst-distTDC)^2)/length(distTDC)
	    MDL[K]= Ek[K]+log(length(distTDC))*K*Incertdata/length(distTDC)
	    } else {
  		model=lm(distTDC ~ poly(as.vector(numdateTDC), K-1, raw=TRUE))
  		Ek[K]=sum(residuals(model)^2)/length(distTDC)
  		MDL[K]= Ek[K]+log(length(distTDC))*K*Incertdata/length(distTDC)
	    }
	  }
		
		K=which(MDL==min(MDL))
		MDLmin=min(MDL)
		
		if (K<3)
		{
		  source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_OLS.R",sep=""))	
		  sortieOLS=MOBITC_Stat_OLS(distTDC,numdateTDC,IC,datex,numdateprosp)
		  res=cbind(sortieOLS[[2]][,1]) #une courbe avec droite OLS
		  taux=sortieOLS[[1]]
		}
		
		if (K==3)
		{
		  model=lm(distTDC ~ poly(as.vector(numdateTDC), K-1, raw=TRUE))
		  dateK=-coefficients(model)[2]/(2*coefficients(model)[3])
		  AdateK=format(as.POSIXct(dateK,origin = "1970-01-01"),"%Y")
		  
		  nb=which(numdateTDC>=dateK)
		  if (length(nb)>0)
		  {
		    extraitdistTDC=distTDC[nb]
		    extraitnumdateTDC=numdateTDC[nb]
			
		    #calcul de MDL-0
		    source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_OLS.R",sep=""))	
		    sortieOLS=MOBITC_Stat_OLS(extraitdistTDC,extraitnumdateTDC,IC,datex,numdateprosp)
		    res=cbind(sortieOLS[[2]][,1]) #MDL-0 une courbe avec droite OLS
		    taux=sortieOLS[[1]] #MDL-0
		    #calcul de MDL-low
		    # poids=
		    # source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_WLS.R",sep=""))	
		    # sortieWLS=MOBITC_Stat_WLS(distTDC,numdateTDC,poids,IC,datex,numdateprosp)
		    # tabres=cbind(tabres,sortieWLS[[2]])
		    # ligneres$WLS=sortieWLS[[1]]
		    #res du polygone
		    res=cbind(res,predict(model,data.frame(x=datex))) #avec le polynome
		  } else {
		    K=2
		    source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_OLS.R",sep=""))	
		    sortieOLS=MOBITC_Stat_OLS(distTDC,numdateTDC,IC,datex,numdateprosp)
		    res=cbind(sortieOLS[[2]][,1]) #une courbe avec droite OLS
		    taux=sortieOLS[[1]]
		  }
		}
		
		if (K==4)
		{
		  model=lm(distTDC ~ poly(as.vector(numdateTDC), K-1, raw=TRUE))
		  racine=polyroot(coefficients(model))
		  racineR=Re(racine)
		  Adate=format(as.POSIXct(racineR,origin = "1970-01-01"),"%Y")
		  dateK=max(racineR)
		  AdateK=max(Adate)
		  
		  nb=which(numdateTDC>=dateK)
		  if (length(nb)>0)
		  {
		    extraitdistTDC=distTDC[nb]
		    extraitnumdateTDC=numdateTDC[nb]
			
		    #calcul de MDL-0
		    source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_OLS.R",sep=""))	
		    sortieOLS=MOBITC_Stat_OLS(extraitdistTDC,extraitnumdateTDC,IC,datex,numdateprosp)
		    res=cbind(sortieOLS[[2]][,1]) #MDL-0 une courbe avec droite OLS
		    taux=sortieOLS[[1]] #MDL-0
		    
		    #res du polygone
		    res=cbind(res,predict(model,data.frame(x=datex))) #avec le polynome
		  } else {
		    K=3
		    model=lm(distTDC ~ poly(as.vector(numdateTDC), K-1, raw=TRUE))
		    dateK=-coefficients(model)[3]/(2*coefficients(model)[2])
		    AdateK=format(as.POSIXct(dateK,origin = "1970-01-01"),"%Y")
		    
		    nb=which(numdateTDC>=dateK)
		    if (length(nb)>0)
		    {
		      extraitdistTDC=distTDC[nb]
		      extraitnumdateTDC=numdateTDC[nb]

		      #calcul de MDL-0
		      source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_OLS.R",sep=""))	
		      sortieOLS=MOBITC_Stat_OLS(extraitdistTDC,extraitnumdateTDC,IC,datex,numdateprosp)
		      res=cbind(sortieOLS[[2]][,1]) #MDL-0 une courbe avec droite OLS
		      taux=sortieOLS[[1]] #MDL-0
		      
		      #res du polygone
		      res=cbind(res,predict(model,data.frame(x=datex))) #avec le polynome
		      #calcul de MDL-low
		      # poids=
		      # source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_WLS.R",sep=""))	
		      # sortieWLS=MOBITC_Stat_WLS(distTDC,numdateTDC,poids,IC,datex,numdateprosp)
		      # tabres=cbind(tabres,sortieWLS[[2]])
		      # ligneres$WLS=sortieWLS[[1]]
		    } else {
		      K=2
		      source(paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Stat_OLS.R",sep=""))	
		      sortieOLS=MOBITC_Stat_OLS(distTDC,numdateTDC,IC,datex,numdateprosp)
		      res=cbind(sortieOLS[[2]][,1])#une courbe avec droite OLS
		      taux=sortieOLS[[1]]
		    }
		  }
		}
	}
	else
	{
	K=NA
	taux=NA
	res=cbind(NA*seq(1,1,length=length(datex[,1])))
	}	
	res=as.data.frame(res)
  
	if (ncol(res)>1)
	{
		colnames(res)[1]="MDLOLSfit"
		colnames(res)[2]= "MDLpolyfit"
	}
	else
	{
	  colnames(res)[1]="MDLOLSfit"
	}
	
  return(list(taux,res,K,AdateK))
}