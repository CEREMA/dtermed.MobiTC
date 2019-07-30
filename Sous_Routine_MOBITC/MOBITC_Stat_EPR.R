MOBITC_Stat_EPR<-function(distTDC,numdateTDC,IC,datex,numdateprosp)
{
if (length(distTDC)>1)
{
	model=lm(distTDC ~ as.vector(numdateTDC))
	res=coef(model)[2]*datex+coef(model)[1]
	taux=round(coef(model)[2]*365.25*24*3600,digits=2)
	} else {
	taux=NA
	res=cbind(NA*seq(1,1,length=length(datex[,1])))
}

colnames(res)[1]="EPRfit"

return(list(taux,res))
}