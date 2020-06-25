setwd("C:\\0_ENCOURS\\TPM\\Erosion\\MobiTC_20200323\\Rapport")
fhtml=dir(pattern="-Carnon-")     # affiche les fichiers contenant un``r'
for (i in 1:length(fhtml))
{
  newnom=paste0("Rapport-MobiTC-TPM-",substr(fhtml[i],23,nchar(fhtml[i])))
  file.rename(fhtml[i], newnom)
}

# 'http://geolittoral.din.developpement-durable.gouv.fr/telechargement/tc_smartphone/rapports/' || 'Rapport-MobiTC-' || "secteur" || '-Naxe' || "naxe" || '-Ntrace' || "ntrace" || '.html'