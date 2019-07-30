MOBITC_Stat_JK<-function(distTDC,numdateTDC,IC,datex,numdateprosp)
{
if (length(distTDC)>1)
	{
		Combi=combn(seq(1,length(distTDC)),length(distTDC)-1)
		for (icomb in 1 : ncol(Combi))
			{	
				distTDCi=distTDC[Combi[,icomb]]
				numdateTDCi=numdateTDC[Combi[,icomb]]
				datexi=data.frame(numdateTDCi=datex$numdateTDC)
				modeli=lm(distTDCi ~ as.vector(numdateTDCi))
				tauxi0=round(coef(modeli)[2]*365.25*24*3600,digits=2)
				resi0=coef(modeli)[2]*datex+coef(modeli)[1]
				#sauvegarde de tauxi et resi
				if (icomb==1)
				{
					tauxi=tauxi0
					resi=resi0
					} else {
					tauxi=rbind(tauxi,tauxi0)
					resi=cbind(resi,resi0)
				}					

				if (length(IC)>0)
				{
					for (ic in 1 : length(IC))
					{
						icConfi  <- predict(modeli,new=datexi,interval="confidence",level=IC[ic]/100)
						if (ic==1)
						{
							if (icomb==1)
								{
								resIC1lwr=icConfi[,2]
								resIC1up=icConfi[,3]
								} else {						
								resIC1lwr=cbind(resIC1lwr,icConfi[,2])
								resIC1up=cbind(resIC1up,icConfi[,3])
								}	
						}
						if (ic==2)
						{
							if (icomb==1)
								{
								resIC2lwr=icConfi[,2]
								resIC2up=icConfi[,3]
								} else {						
								resIC2lwr=cbind(resIC2lwr,icConfi[,2])
								resIC2up=cbind(resIC2up,icConfi[,3])
								}
						}				
					}			
				}
			}
			
		res=cbind(rowMeans(resi))
		
		if (length(IC)>0)
			{
				for (ic in 1 : length(IC))
				{
				if (ic==1)
					{
						res=cbind(res,rowMeans(resIC1lwr),rowMeans(resIC1up))
					}
				if (ic==2)
					{
						res=cbind(res,rowMeans(resIC2lwr),rowMeans(resIC2up))
					}
				}
			}
				
		taux = round(mean(tauxi[,1]),digits=2)
		
	} else {
	
		taux=NA
		res=cbind(NA*seq(1,1,length=length(datex[,1])))
		if (length(IC)>0)
		{
			for (ic in 1 : length(IC))
			{
				res=cbind(res,NA*seq(1,1,length=length(datex[,1])),NA*seq(1,1,length=length(datex[,1])))
			}		
		}	
	}
	
	#Nommage des colonnes
	resf=data.frame(res)
	colnames(resf)[1]="JKfit"
	if (length(IC)>0)
	{
			for (ic in 1 : length(IC))
			{
				colnames(resf)[2*ic]=paste("JK",IC[ic],"lwr",sep="")			
				colnames(resf)[2*ic+1]=paste("JK",IC[ic],"up",sep="")
			}		
		
	}
	return(list(taux,resf))
}

