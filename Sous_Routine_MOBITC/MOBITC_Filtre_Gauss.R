MOBITC_Filtre_Gauss<-function(vecteur,vale)
{
  if(!require(Matrix)){install.packages("Matrix")}
  library(Matrix)
  
n=length(vecteur)
ndiag=(vale+1)/2-1
Gauss=matrix(0, n, n)
for (inc in 0:min(ndiag,n))
  {
    if (inc>0)
    {
    A=rbind(cbind(matrix(0,n-inc,inc),(vale-2*inc)*diag(1,n-inc)),matrix(0,inc,n))
    Gauss=Gauss+A
    Gauss=forceSymmetric(Gauss)
    } else {
      Gauss=Gauss+(vale-2*inc)*diag(1,n)
    }
}

B=1/rowSums(Gauss)
vecteur=B * (Gauss %*% vecteur)

return (vecteur)
}