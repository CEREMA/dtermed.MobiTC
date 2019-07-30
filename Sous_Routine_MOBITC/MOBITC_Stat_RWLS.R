MOBITC_Stat_RWLS<-function(distTDC,numdateTDC,incertitude,IC,datex,numdateprosp)
{
if (length(distTDC)>1)
{
	poids=(1/incertitude/2)^2
	model1=lm(distTDC ~ as.vector(numdateTDC),weights = poids)
	ecart_type= sd(distTDC)
	err=abs(distTDC-(coef(model1)[2]*numdateTDC+coef(model1)[1]))
	poids[which(err>ecart_type)]=0
	model=lm(distTDC ~ as.vector(numdateTDC),weights = poids)
	taux=round(coef(model)[2]*365.25*24*3600,digits=2)
	} else {
	taux=NA
}

if (length(IC)>0)
{
	for (ic in 1 : length(IC))
	{
		if (length(distTDC)>1)
		{
			icConf  <- predict(model,new=datex,interval="confidence",level=IC[ic]/100)
			if (ic==1)
			{
				res=icConf[,1]
			}
			res=cbind(res,icConf[,2:3])
		} else {
			if (ic==1)
			{
				res=NA*seq(1,1,length=length(datex[,1]))
			}
			res=cbind(res,NA*seq(1,1,length=length(datex[,1])),NA*seq(1,1,length=length(datex[,1])))
		}
			
		colnames(res)[2*ic]=paste("RWLS",IC[ic],"lwr",sep="")
		colnames(res)[2*ic+1]=paste("RWLS",IC[ic],"up",sep="")
	}
} else {
	if (length(distTDC)>1)
	{
		res=coef(model)[2]*datex+coef(model)[1]
	} else {
		res=cbind(NA*seq(1,1,length=length(datex[,1])))
	}
}

colnames(res)[1]="RWLSfit"
return(list(taux,res))
}