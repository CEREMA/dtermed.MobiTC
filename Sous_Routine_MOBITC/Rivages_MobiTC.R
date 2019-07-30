library(rgdal)
library(rgeos)

################################################################################################
################################################################################################
# Il faut basculer dans le referentiel local, non fait actuellement pour etre en cartesien
#attention ne marche qu'en L93 mis en dur au final

# L'objectif de cette routine est de ne garder des donnees rivages que les donnees "assez sures"
# Pour cela 2 methodes
# 1: Ne garder que les points assez proches, si une vitesse plus de 6km/h, on enleve
reglevitesse=8*1000/3600
# 2: Ensuite, on prend les regles de hdop, vdop, pdop accessible sur https://en.wikipedia.org/wiki/Dilution_of_precision_(navigation)
regledop=cbind(rbind(2,1,0),rbind(5,2,1),rbind(15,10,5))
# 3: Diff?rence de temps entre 2 points si >1s BUG
Dcritic=1.1
# 4: Avoir une ?l?vation entre +/- altitude m
Alt=15
# 5: Si moins de 25% ? garder avec ces filtres => Suppression de tout le segment
Rejet=0.25

# si que 10% pas bon alors on garde sauf les 1ers points

# 6: Garder si on a de 2 points bizarres au milieu de bcp de points tr?s biens
# si 1 regarder 2 avant et 2 apr?s
# si 2 regradre 4 avant et 4 apr?s
# MOYENNE MOBILE
Coef=as.matrix(1:5,nrow=1)
#Largeur de moyenne mobile
Multi=5
Coef=cbind(Coef,as.matrix(Multi*Coef,nrow=1))
#Taux acceptation 
TauxMob=0.8

# 7: Avoir des blocs d'a minima 10 points ok sinon boom
NPoints=10
# voir si on met des regles pour avoir un minimum de points par segment, en gros on ne chercherait ? garder que des endroits ou un segment est bon sur une grande longueur
# Voir pour intégrer le type de téléphone


chemin="C:\\RIVAGES_ZIP_TDC"
chemin="C:\\R\\R-3.3.2\\Cerema\\MOBITC\\Rivages\\Donnees_brutes\\Rivages_Points"
chemin="C:\\0_ENCOURS\\TPM\\Erosion\\TDC_brut\\RIVAGES"
chemin="C:\\0_ENCOURS\\MOBITC_hotline\\Tuto_MOBITCR"
nomlayer="TDC_Rivages_Points_L93"
# nomlayer="Rivages_Points_MobiTC_France"
# nomlayer="Rivages_Points_2154_extrait2"
# nomlayer="Rivages_points_TPM"
#nomlayer="Rivages_MobiTC_Rondi"
#nomlayer="Rivages_Points_Camargue"
#nomlayer="Rivages_Points_Beauduc"
dsnlayer=chemin
chem_routine=R.home(component = "cerema")

setwd(chemin)

print("#----- Lecture du fichier de points de rivages")
TDC = readOGR(dsnlayer,layer=nomlayer,encoding="UTF-8",use_iconv=TRUE)

print("#---- Travail sur la tableau pour faire des syntheses")
tableau=TDC@data

print("#----  Definition des parametres")
DistRel=matrix(0,dim(tableau)[1],ncol=1)
DTemps=matrix(9999,dim(tableau)[1],ncol=1)
Precisio=matrix(9999,dim(tableau)[1],ncol=1)
Agarder=matrix(0,dim(tableau)[1],ncol=1)
MoyMobil=matrix(0,dim(tableau)[1],ncol=1)

tableau=cbind(tableau,DistRel,DTemps,Precisio,Agarder)

print("#---- Boucle sur la qualite")
for (ireg in 1:3){
  nb=which(tableau[,"hdop"]<=regledop[ireg,2] & tableau[,"vdop"]<=regledop[ireg,2] & tableau[,"pdop"]<=regledop[ireg,2])
  tableau[nb,"Precisio"]=regledop[ireg,3]
}

print(unique(tableau[,"nsegment"]))

print("#---- Boucle sur les segments => calculs de delta de distance et de temps")
for (isegm in unique(tableau[,"nsegment"]))
{
  print(isegm)
  nisegm=which(tableau[,"nsegment"]==isegm)
  #---- Calcul des deltas de distance
  Dxy=coordinates(TDC[nisegm[-1],1])-coordinates(TDC[nisegm[-length(nisegm)],1])
  Dist=as.matrix((Dxy[,1]^2+Dxy[,2]^2)^0.5,nrow=1)
  tableau[nisegm,"DistRel"]=apply(cbind(rbind(0,Dist),rbind(Dist,0)),1,max)
  
  #---- Calcul des deltas de temps
  #t2=as.numeric(strftime(strptime(tableau[nisegm[-1],"time2"],"%Y/%m/%d %H:%M:%S"),"%Y%m%d%H%M%S"))
  #t1=as.numeric(strftime(strptime(tableau[nisegm[-length(nisegm)],"time2"],"%Y/%m/%d %H:%M:%S"),"%Y%m%d%H%M%S"))
  DeltaT=as.matrix(strptime(tableau[nisegm[-1],"time2"],"%Y/%m/%d %H:%M:%S")-strptime(tableau[nisegm[-length(nisegm)],"time2"],"%Y/%m/%d %H:%M:%S"),nrow=1)
  tableau[nisegm,"DTemps"]=apply(cbind(rbind(0,DeltaT),rbind(DeltaT,0)),1,max)
} 

print("#---- 1?re selection avec distance, delta temps et hdop, vdop, pdop altitude")
nb=which(!(tableau[,"DistRel"]>reglevitesse | tableau[,"DTemps"]>Dcritic | abs(tableau[,"ele"])>Alt | tableau[,"hdop"]>max(regledop[,2]) | tableau[,"vdop"]>max(regledop[,2])| tableau[,"pdop"]>max(regledop[,2])))
#nb=which(!(tableau[,"DistRel"]>reglevitesse | tableau[,"DTemps"]>Dcritic | tableau[,"hdop"]>max(regledop[,2]) | tableau[,"vdop"]>max(regledop[,2])| tableau[,"pdop"]>max(regledop[,2])))
tableau[nb,"Agarder"]=1
for (isegm in unique(tableau[,"nsegment"]))
{
  print(isegm)
  nisegm=which(tableau[,"nsegment"]==isegm)
  if (mean(tableau[nisegm,"Agarder"])<Rejet)
  {tableau[nisegm,"Agarder"]=0}
  
  
  for (filt in Coef[,1])
  { 
    nomcol=paste("MoyMobi",Coef[filt,1],sep="")
    if (filt==1)
    {
      tableau[nisegm,nomcol]=tableau[nisegm,"Agarder"]
    }else{
      tableau[nisegm,nomcol]=tableau[nisegm,paste("MoyMobi",(Coef[filt,1]-1),sep="")]
    }
    if (length(nisegm)>Coef[filt,2])
    {
      #---- Moyenne Mobile"
      moymob=filter(tableau[nisegm,nomcol],rep(1,Coef[filt,2]))/Coef[filt,2]
      
      var=as.matrix(((Coef[filt,2]-1)/2+1):(length(nisegm)-((Coef[filt,2]-1)/2)),nrow=1)
      
      nb=which(moymob[var]>=TauxMob)
      tableau[nisegm[var[nb]],nomcol]=1
      #tableau[nisegm[var[-nb]],"MoyMobil"]=0
      #tableau[nisegm[-var],"MoyMobil"]=moymob[-var]
    }
  }
}

#---- R?cup?ration des modifications du tableau



TDC@data=tableau

print("#---- Export des donn?es")
#TDC=TDC[nb,]
writeOGR(TDC, dsn=chemin,layer="Rivages_Points_MobiTC_Retenus",driver="ESRI Shapefile",overwrite_layer=TRUE)

#-------------------------------------------------------------------------------------------------------
print("#----------- Cr?ation des segments")
#----- Cr?ation des listes
list_Seg = list()
tableau_Seg = list()
idenSeg=0
for (isegm in unique(tableau[,"nsegment"]))
{
  print(paste("isegm",isegm))
  nisegm=which(tableau[,"nsegment"]==isegm)
  niok=which(tableau[nisegm,"Agarder"]==1)
  tab=cbind(0,matrix(tableau[nisegm,"Agarder"],nrow=1),0)
  saut=(tab[-1]-tab[-length(tab)])
  
  if (max(saut)>0)
  {
    ndeb=which(saut==1)
    nfin=which(saut==-1)
    for (isousseg in 1:length(ndeb))
    {
      #---- V?rification de segments avec au moins 10 points
      if ((nfin[isousseg]-ndeb[isousseg])>NPoints)
      {
        idenSeg=idenSeg+1
        ligne=Lines(Line(coordinates(TDC[nisegm[ndeb[isousseg]:(nfin[isousseg]-1)],1])[,1:2]), ID=as.integer(idenSeg))
        
        DATE=round(as.numeric(strftime(mean(strptime(tableau[nisegm[ndeb[isousseg]:(nfin[isousseg]-1)],"time2"],"%Y/%m/%d %H:%M:%S")),"%Y%m%d%H%M%S")))
        DATE1=as.character(as.numeric(strftime(strptime(tableau[nisegm[ndeb[isousseg]],"time2"],"%Y/%m/%d %H:%M:%S"),"%Y%m%d%H%M%S")))
        DATE2=as.character(as.numeric(strftime(strptime(tableau[nisegm[nfin[isousseg]-1],"time2"],"%Y/%m/%d %H:%M:%S"),"%Y%m%d%H%M%S")))
        
        LimTDC=-99
        print(paste("isousseg",isousseg))
        if (is.na(tableau[nisegm[ndeb[isousseg[1]]],"code_li"]))
        {LimTDC=25} else {
        if (tableau[nisegm[ndeb[isousseg[1]]],"code_li"]=='Limite du jet de rive')
        {LimTDC=3}
        if (tableau[nisegm[ndeb[isousseg[1]]],"code_li"]=='Dernière laisse de haute mer')
        {LimTDC=5}
        if (tableau[nisegm[ndeb[isousseg[1]]],"code_li"]=='Fond de plage')
        {LimTDC=7}
        if (tableau[nisegm[ndeb[isousseg[1]]],"code_li"]=='Limite côté mer de la végétation dunaire' | tableau[nisegm[ndeb[isousseg[1]]],"code_li"]=='Limite cÃ´tÃ© mer de la vÃ©gÃ©tation dunaire')
        {LimTDC=11}
        if (tableau[nisegm[ndeb[isousseg[1]]],"code_li"]=='Limite de végétation (hors dune)')
        {LimTDC=13}
        if (tableau[nisegm[ndeb[isousseg[1]]],"code_li"]=='Autre')
        {LimTDC=25}
        if (tableau[nisegm[ndeb[isousseg[1]]],"code_li"]=='Cordon de galets')
        {LimTDC=19}
        if (tableau[nisegm[ndeb[isousseg[1]]],"code_li"]=='Pied de dune - Pied de falaise dunaire')
        {LimTDC=8}
        }
        
        
        CODE_LI=as.integer(LimTDC)
        LimTDC=tableau[nisegm[ndeb[isousseg[1]]],"code_li"]
        Precisio=as.integer(max(tableau[nisegm[ndeb[isousseg]:(nfin[isousseg]-1)],"Precisio"]))
        prj_tdc="L93"
        LEVE="LEV"
        Producteur="RIVAGES"
        
        tableau_Seg[[idenSeg]] <- data.frame(ID = as.integer(idenSeg), date1 = DATE1, date2 = DATE2, marqueur = CODE_LI, CODE_LI = LimTDC, incert = Precisio,prj_tdc = prj_tdc , leve = LEVE , product = Producteur, row.names = idenSeg,stringsAsFactors=FALSE)
        list_Seg[[idenSeg]]=ligne
      }
    }
  }
} 

print("#--- Fusion des listes Segments")
Liga = SpatialLines(list_Seg)#,proj4string=CRS(paste("+init=epsg:",as.character(Points@proj4string),sep="")))
SLDF = SpatialLinesDataFrame(Liga, do.call(rbind, tableau_Seg))
proj4string(SLDF)=TDC@proj4string

print("#---- Export des donn?es")
writeOGR(SLDF, dsn=chemin,layer="Rivages_Segments_MobiTC_Retenus",driver="ESRI Shapefile",overwrite_layer=TRUE)
