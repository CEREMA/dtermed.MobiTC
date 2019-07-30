MOBITC_CreationFichierInit = function(chem_mobitc,chemin_rep_travail,nom_projet)
{
  fichier_init=paste(chem_mobitc,"/Init_Routine_MobiTC.txt",sep="")
  file.create(fichier_init)
  fid=file(fichier_init, open = "w")
  lignes="#Chemin du repertoire de travail"
  lignes[2]=chemin_rep_travail
  lignes[3]="#Nom du projet"
  lignes[4]=nom_projet
  lignes[5]="#Nom du fichier enveloppe"
  lignes[6]=""
  lignes[7]="#Nom du fichier squelette"
  lignes[8]=""
  lignes[9]="#Nom du fichier trace"
  lignes[10]=""
  lignes[11]="#Nom du fichier des intersections"
  lignes[12]=""
  lignes[13]="#Producteur des graphiques"
  lignes[14]=""
  lignes[15]="#Intervalles de confiance"
  lignes[16]=""
  lignes[17]="#Date de début des graphiques"
  lignes[18]=""
  lignes[19]="#Date de fin des graphiques"
  lignes[20]=""
  lignes[21]="#Date de prospective"
  lignes[22]=""
  cat(lignes,file=fid,sep="\n")
  close(fid)
  #dir.create(Chemin_des_donnees_Grass)
  return(fichier_init)
}