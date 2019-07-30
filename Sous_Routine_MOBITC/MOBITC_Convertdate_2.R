MOBITC_Convertdate_2=function(tab)
{
  datecompl<-function(x){
    if (!is.na(x))
      {
      if (floor(log10(x))+1==14) {x=x} #AAAAMMJJHHMMSS
      if (floor(log10(x))+1==12) {x=x*100+30} #AAAAMMJJHHMM30
      if (floor(log10(x))+1==10) {x=x*10000+3000} #AAAAMMJJHH3000
      if (floor(log10(x))+1==8) {x=x*1000000+120000} #AAAAMMJJ120000
      if (floor(log10(x))+1==6) {x=x*100000000+15000000} #AAAAMM15000000
      if (floor(log10(x))+1==4) {x=x*10000000000+0701000000} #AAAA0701000000
      x=format(x,scientific = FALSE)
      y=paste(substr(x,start=1,stop=4),"-",substr(x,start=5,stop=6),"-",substr(x,start=7,stop=8)," ",
              substr(x,start=9,stop=10),":",substr(x,start=11,stop=12),":",substr(x,start=13,stop=14),sep="")
    } else {y=x}
    return (y)
  }
  
  dd1= lapply(tab$date1,datecompl)
  dd1_t=strptime(dd1,"%Y-%m-%d %H:%M:%S")
  dd1_n=cbind(as.numeric(as.POSIXct(dd1_t)))
  #as.POSIXct(dd1_n,origin = "1970-01-01")
  
  dd2= lapply(tab$date2,datecompl)
  dd2_t=strptime(dd2,"%Y-%m-%d %H:%M:%S")
  dd2_n=cbind(as.numeric(as.POSIXct(dd2_t)))
  dd_n=dd1_n
  for (itdc in 1:nrow(dd1_n))
  {
    if (!is.na(dd2_n[itdc]))
    {
      dd_n[itdc]=(dd1_n[itdc]+dd2_n[itdc])/2
    } 
  }
  
  tab$Datemoynum=as.numeric(dd_n)
		
		return(tab)
}