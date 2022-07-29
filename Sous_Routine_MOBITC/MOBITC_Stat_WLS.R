#verif utf-8
#version 18-12-2020
#réalisée par C Trmal Cerema

MOBITC_Stat_WLS<-function(distTDC,numdateTDC,incertitude,IC,datex,numdateprosp)
{

if (length(distTDC)>1)
{
	model=lm(distTDC ~ as.vector(numdateTDC),weights = (1/(incertitude/2))^2)
	taux=round(coef(model)[2]*365.25*24*3600,digits=2)
	} else {
	taux=NA
}

if (length(IC)>0)
{
	for (ic in 1 : length(IC))
	{
		if (length(distTDC)==1)
		{ 
		  if (ic==1)
			{
				res=NA*seq(1,1,length=length(datex[,1])) #pour la distance
			}
			res=cbind(res,NA*seq(1,1,length=length(datex[,1])),NA*seq(1,1,length=length(datex[,1]))) #pour les ic
		}
	  
	  if (length(distTDC)==2)
	  {
	    if (ic==1)
	    {
	      res=coef(model)[2]*datex+coef(model)[1]
	      res=cbind(res,NA*seq(1,1,length=length(datex[,1])),NA*seq(1,1,length=length(datex[,1])))
	      
	      distTDC1=c(distTDC[1]-1/6*incertitude[1],distTDC[2]+1/6*incertitude[2])
	      model1=lm(distTDC1 ~ as.vector(numdateTDC),weights = (1/(incertitude/2))^2)
	      res1=coef(model1)[2]*datex+coef(model1)[1]
	      
	      res[length(datex[,1])-1,2]=res1[length(datex[,1])-1,1]
	      res[length(datex[,1]),2]=res1[length(datex[,1]),1]
	      
	      distTDC2=c(distTDC[1]+1/6*incertitude[1],distTDC[2]-1/6*incertitude[2])
	      model2=lm(distTDC2 ~ as.vector(numdateTDC),weights = (1/(incertitude/2))^2)
	      res2=coef(model2)[2]*datex+coef(model2)[1]
	      
	      res[length(datex[,1])-1,3]=res2[length(datex[,1])-1,1]
	      res[length(datex[,1]),3]=res2[length(datex[,1]),1]
	        
	    } else {
	    res=cbind(res,NA*seq(1,1,length=length(datex[,1])),NA*seq(1,1,length=length(datex[,1])))
	    }
	  }
	    
	  if (length(distTDC)>2)  
		{
			icConf  <- predict(model,new=datex,interval="confidence",level=IC[ic]/100)
			if (ic==1)
			{
				res=icConf[,1]
			}
			res=cbind(res,icConf[,2:3])
	  }
			
		colnames(res)[2*ic]=paste("WLS",IC[ic],"lwr",sep="")
		colnames(res)[2*ic+1]=paste("WLS",IC[ic],"up",sep="")
	}
} else {
  #pas d'intervalle de confiance
	if (length(distTDC)>1)
	{
		res=coef(model)[2]*datex+coef(model)[1]
	} else {
		res=cbind(NA*seq(1,1,length=length(datex[,1])))
	}
}

colnames(res)[1]="WLSfit"
return(list(taux,res))
}