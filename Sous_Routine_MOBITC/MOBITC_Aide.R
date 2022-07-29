#verif utf-8
#version 18-12-2020
#réalisée par C Trmal Cerema

MOBITC_Aide<-function(chem_mobitc)
{
  aide_pres=div(h3("Bienvenue dans MobiTC"),
				p("Le logiciel MobiTC (Mobilité du Trait de Côte) est un outil automatisé de traitement des traits de côte 
					historiques, développé au Cerema Méditerranée. Il se base sur le traitement fortement automatisé des 
					traits de côte pour effectuer les principaux calculs utilisés en ingénierie et en recherche."),
				p("La première étape consiste à créer une ligne de base issue du squelette des traits de côte (algorithme de 
				Voronoï). Des traces perpendiculaires à cette ligne de base sont ensuite créées et leurs intersections 
				avec les traits de côte font l'objet de traitements statistiques simples comme le calcul d'une régression 
				linéaire et de ces intervalles de confiance."),
				p("Les résultats sont ensuite convertibles sous forme SIG afin de répondre à une visualisation simple de la 
				mobilité du trait de côte. La projection des traits de côte à une échéance est aussi disponible en prenant à la 
				fois en compte la projection de la régression linéaire et ses intervalles de confiance. "),
				span(style="color:green","Les champs/explications en vert dans les pages d'aide correspondent au tutoriel réalisé à partir de 4 traits de côte. Il est conseillé de dérouler ce tutoriel lors de la première utilisation de MobiTC. A chaque menu un onglet Aide donne les indications pour faire tourner MobiTC."),
				p(span(style="color:green","Les fichiers correspondant au tutoriel sont dans le répertoire TUTO : ")),
				a("https://github.com/CEREMA/dtermed.MobiTC/tree/master/TUTO",href="https://github.com/CEREMA/dtermed.MobiTC/tree/master/TUTO"),
				p(),
				p(span(style="color:green","Les 4 traits de côtes sont fournis uniquement dans le cadre du tutoriel. Ne pas les utiliser pour une étude de l'évolution du trait de côte de ce secteur."))
				)
  
  aide_pack=div(h3("Objectifs :"),
                p("Dans ce menu, les packages R nécessaires à MobiTC sont installés. Cela peut être plus ou moins long suivant la connection à Internet.")
  )
  
  aide_init=div(h3("Objectifs :"),
                p(paste("Dans ce menu, un fichier d'initialisation est créé ou mis à jour dans le répertoire", chem_mobitc ,"pour stocker le chemin du répertoire de travail et les principaux noms des fichiers créés par MobiTC.")),
                p("Ce fichier est mis à jour au fur et à mesure que les différentes étapes de MobiTC ont été lancées."),
                p("Ce fichier permet la mise à jour des noms des fichiers dans les différents menus de MobiTC. Lorsque les boutons",
                  em("Actualiser le menu"),
                  "sont clickés, ce fichier est lu."),
                p("Ce fichier peut aussi être modifié par un éditeur de texte."),
                h3("Entrées :"),
                h4("- Chemin du répertoire de travail"),
				p("Mettre le chemin complet du répertoire où sont stockés les traits de côte et où seront stockés les fichiers résultat."),
				span(style="color:green","xxxx\\TUTO"),
                h4("- Nom du projet"),
				p("Il est possible de donner un nom au projet en cours. Ce nom doit être court et sans espace, il sera écrit sur le nom des fichiers résultat."),
				span(style="color:green","Tuto")
				)
  
  aide_fourn=div(h3("Objectifs"),
                 p(paste("Dans ce menu, une liste de fournisseurs de trait de côte est mise à jour. Elle est stockée dans le répertoire de travail. Il faut appuyer sur le bouton voir la liste, pour que celle-ci s'exporte.")),
                 p("Cette étape est obligatoire sinon au moment du Calcul de l'évolution le logiciel plantera."),
				 span(style="color:green","3 des traits de côte du Tuto ont été produits par le Cerema et un par l'application Rivages. Ils sont déjà renseignés dans la liste de base.")
                 )
  
  aide_liste_tdc=div(h3("Objectifs"),
                     p(paste("Dans ce menu, une liste de trait de côte est mise à jour. Il faut appuyer sur le bouton voir la liste, pour que celle-ci s'exporte.")),
					 p("Cette étape est obligatoire sinon au moment du Calcul de l'évolution le logiciel plantera.")
  )
  
  aide_miseenforme_tdc=div(h3("Objectifs"),
                     p(paste("Ce menu est un mémo pour rappeler comment les traits de côte doivent être mis en forme avant d'utiliser MobiTC.")),
					 p("Cette mise en forme peut être réalisée sous Qgis"),
					 p("Les traits de côte doivent être des fichiers shape contenant une table attributaire avec à minima les champs "),
					 p("- date1 : date du trait de côte, au format AAAAMMJJHHMMSS (AAAA : Année, MM : Mois, JJ : Jour, HH : Heure, MM : Minute, SS : Seconde), dans la majorité des cas date1 contient juste une année"),
					 p("- date2 : 2e date du trait de côte, au format AAAAMMJJHHMMSS, dans le cas où on connaitera un intervalle de dates d'acquisition du trait de côte"),
					 p("- marqueur : numéro du marqueur tel que défini au menu Marqueur TDC, par exemple 3 pour une limite de jet de rive"),
					 p("- incert : incertitude du trait de côte exprimée en mètre, la position du trait de côte se situe dans un intervalle compris entre +/- l'incertitude donnée ici"),
					 p("- leve : 2 valeurs possible NUM si le trait de côte a été digitalisé à partir d'un fond cartographique, LEV si le trait de côte a été levé sur le terrain, par exemple avec l'application Rivages"),
					 p("- product : nom court de l'organisme qui a réalisé ou a fait réaliser le trait de côte"),
					 p(""),
					 p("Les traits de côte peuvent contenir d'autres champs qui ne seront pas utilisés dans les calculs")
  )
  
  aide_env=div(h3("Objectifs"),
				p("Ce menu est la première étape pour la réalisation de la ligne de base."),
				p("Pour rappel, la ligne de base est une sorte de ligne moyenne générée à partir des TDC disponibles qui 
va permettre de définir des lignes perpendiculaires, appelées traces, où l'évolution du TDC sera calculée. 
Cette ligne de base sera donc le point 0, à partir duquel la distance aux différents TDC sera calculée 
et transformée en évolution du trait de côte. "),
				p("Pour avoir une ligne de base cohérente avec les TDC, il faut que celle-ci soit d'une forme représentative 
des différents TDC. C'est pourquoi, dans MobiTC, il a été choisi de réaliser de façon automatique une 
ligne  de  base,  à  partir  de  l'ensemble  des  différents  TDC  disponibles,  en  représentant  une  sorte  de 
médiane. Pour cela le principe de la squelettisation a été retenu. "),
				p("Dans ce menu, l'enveloppe contenant tous les TDC est tracée. Au menu Ligne de base, le squelette de cette enveloppe est réalisé."),
				h3("Entrées :"),
				p("Commencez par actualiser le menu et pensez à actualiser les noms des fichiers/projets si ils ont été modifiés."),
				h4("Distance de coupure des tdc"),
				p("Cette distance est donnée en mêtre. Des points sur les TDC seront créés et leur espacement sera égal à cette distance. La triangularisation s'appuiera sur ces points."),
				span(style="color:green","Valeur Tuto : 10"),
				h4("Longueur max des triangles à garder (m)"),
				p("Cette distance est donnée en mètre. Elle définit la longueur des cotés des triangles créés maximum à garder."),
				span(style="color:green","Valeur Tuto : 1000"),
				h4("Choisir les fichiers des tdc"),
				p("En appuyant sur browse une fenêtre s'ouvre, il faut aller chercher les traits de côte dans le répertoire de travail et choisir ceux qu'on veut utiliser pour faire l'enveloppe. On n'est pas obligé d'utiliser tous les traits de côte. Il faut sélectionner le shp de chaque trait de côte."),
				span(style="color:green","Dans le tuto les 4 shp des traits de côte sont sélectionnés"),
				h3("Sorties :"),
				p("A l'issue de cette étape, le fichier de l'enveloppe est créé dans le répertoire de travail au format shape et une carte s'affiche."),
			    span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000.shp"),
				h3("Attention"),
			    p("Une fois l'enveloppe produite, il faut s'assurer que l'enveloppe ne contient pas d'ilot. Ceci peut être réalisée en parcourant l'enveloppe dans la carte résultat. Si il y a des ilots il faut les supprimer avec un logiciel SIG. 
				Si vous changez le nom du fichier shape de l'enveloppe, pensez à actualiser le nom dans les menus suivants ou dans le fichier Init_Routine_MobiTC.txt."),
				h3("Bon à savoir"),
				p("Il est possible de s'affranchir des étapes de réalisation de l'enveloppe et de la ligne de base lorsque les calculs sont trop longs.
				Il est possible de passer directement au menu Traces avec une ligne de base provenant d'une autre source. Il faut que cette ligne de base soit tout de même correctement orientée.")
  )
  
  aide_sque=div(h3("Objectif"),
               p(paste("Dans ce menu, la ligne de base, appelée aussi squelette, est calculée.")),
			   p("La squelettisation, c'est-à-dire la génération d'une ligne médiane à travers l'enveloppe, s'effectue dans MobiTC à partir du diagramme de Voronoï et de points :"),
			   p("- situés sur les noeuds du contour de l'enveloppe,"),
			   p("- et situés tous les zzz m (distance de coupure de l'enveloppe)."),
			   h3("Entrées :"),
			   h4("Distance de coupure de l'enveloppe"),
			   p("Cette distance est donnée en mètre. Sur de grandes étendues le calcul peut devenir un peu long si cette distance est trop faible."),
			   span(style="color:green","Valeur Tuto : 1"),
			   h3("Sorties :"),
			   p("A l'issue de cette étape, le fichier du squelette est créé dans le répertoire de travail au format shape."),
			   span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001.shp"),
			   p(" "),
			   p("Le squelette peut être composé de plusieurs morceaux. Attention pour la suite, notamment le calcul des traces, le squelette doit contenir une colonne NAxe à remplir par un numéro d'axe.")
			   )
			   
	aide_sque_coup=div(
          p("Suite à un problème de mise à jour dans un package R la création de la ligne de base ne peut pas se faire entièrement dans R.
                 Une solution temporaire a été trouvée en s'appuyant que Qgis"),
          p("Commencer par actualiser le menu, le chemin du répertoire de travail et le nom du fichier enveloppe s'affichent."),
          p("La squelettisation, c'est-à-dire la génération d'une ligne médiane à travers l'enveloppe, s'effectue dans MobiTC à partir du diagramme de Voronoï et de points :"),
          p("- situés sur les nœuds du contour de l'enveloppe,"),
          p("- et situés tous les zzz m (distance de coupure de l'enveloppe)."),
          h3("Entrées :"),
          h4("Distance de coupure de l'enveloppe"),
          p("Cette distance est donnée en mètre. Sur de grandes étendues le calcul peut devenir un peu long si cette distance est trop faible."),
          span(style="color:green","Valeur Tuto : 1"),
          p("Après avoir appuyer sur Lancer, le fichier Points_env.shp se crée dans le répertoire de travail. Il faut suivre rigoureusement les étapes suivantes :"),
          h3("Manipulations dans Qgis :"),
          p("1 - ouvrir Qgis"),
          p("2 - ouvrir le fichier Points_env.shp"),
          p("3 - aller dans le menu Vecteur, puis Outils de géométrie, puis Polygones de Voronoi..."),
          p("4 - dans la fenêtre Polygones de Voronoi, choisir comme couche d'entrée : Points_env, mettre 10 en Zone tampon, puis Exécuter. Le calcul peut être long. Quand le calcul est fini
                les polygones s'affichent à l'écran."),
          p("5 - aller dans le menu Vecteur, puis Outils de géométrie, puis Polygones vers lignes"),
          p("6 - dans la fenêtre Polygones vers lignes, choisir comme couche d'entrée : Polygones de Voronoi, puis Exécuter. Quand le calcul est fini
                les polylignes s'affichent à l'écran."),
          p("7 - exporter la couche Lignes au format ESRI shapefile la renommant voronoi dans le répertoire de travail."),
          p("Attention à la projection, celle-ci doit être identique aux traits de côte."),
          p("Cette étape est finie, il convient de passer au menu Création du squelette de MobiTC.")
)

aide_sque_voro=div(
		p(paste("Dans ce menu, la ligne de base, appelée aussi squelette, est calculée.")),
			   p("La squelettisation, c'est-à-dire la génération d'une ligne médiane à travers l'enveloppe, s'effectue dans MobiTC à partir du diagramme de Voronoï."),
			   p("Il s'agit dans ce menu de nettoyer les lignes de voronoi générées sous Qgis au menu précédent pour obtenir la ligne de base."),
			   h3("Entrées :"),
			   h4("Nom du fichier du voronoi réalisé dans Qgis (sans l'extension)"),
			   span(style="color:green","Valeur Tuto : voronoi"),
			   h3("Sorties :"),
			   p("A l'issue de cette étape, le fichier du squelette est créé dans le répertoire de travail au format shape."),
			   span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001.shp"),
			   p(" "),
			   p("Le squelette peut être composé de plusieurs morceaux. Attention pour la suite, notamment le calcul des traces, le squelette doit contenir une colonne NAxe à remplir par un numéro d'axe et une colonne Loc à remplir par une localisation. Par défaut NAxe est issu des étapes précédentes et Loc est le nom du projet.")
)
  
  aide_squerac=div(h3("Objectifs"),
                   p(paste("Dans ce menu, il est possible de raccorder les morceaux de squelette entre eux. Ceci est intéressant pour n'avoir que des gros morceaux à orienter")),
				   h3("Entrées :"),
				   h4("Choisir le fichier du squelette"),
				   p("En appuyant sur browse une fenêtre s'ouvre, il faut aller chercher le fichier dans le répertoire de travail. Il faut sélectionner le shp."),
				span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001.shp"),
				   h4("Distance de raccordement"),
				   p("Cette distance est donnée en mètre."),
				   span(style="color:green","Valeur Tuto : 5"),
				   h3("Sorties :"),
				   p("A l'issue de cette étape, le nouveau fichier du squelette est créé dans le répertoire de travail au format shape."),
			       span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR.shp"),
				   p(" "),
			   p("Le squelette peut être composé de plusieurs morceaux. Attention pour la suite, notamment le calcul des traces, le squelette doit contenir une colonne NAxe à remplir par un numéro d'axe.")
				   )
  
  aide_squeorr=div(h3("Objectifs"),
                   p(paste("Ce menu est un mémo qui explique comment orienter le squelette dans Qgis")),
				   p("La convention est prise dans MobiTC de parcourir les squelettes en laissant à gauche la terre et à droite la mer. Si ce n'est pas le cas pour certains des morceaux du squelette il faut les retourner dans Qgis."),
				   p("1 - ouvrir le squelette dans Qgis"),
				   p("2 - visualiser les orientations des morceaux en utilisant le style sque.qml qui se situe dans le repertoire du Tuto"),
				   p("3 - installer le plugin Swap Vector Direction dans Qgis"),
				   p("4 - sélectionner les morceaux à inverser"),
				   p("5 - enregistrer le nouveau squelette"),
				   span(style="color:green","Valeur Tuto : non utile, le squelette est déjà bien orienté."),
				   p(" "),
			   p("Le squelette peut être composé de plusieurs morceaux. Attention pour la suite, notamment le calcul des traces, le squelette doit contenir une colonne NAxe à remplir par un numéro d'axe.")
				   )
  
  aide_squelisse=div(h3("Objectif"),
                   p(paste("Ce menu est un mémo qui explique comment lisser le squelette dans Qgis")),
				   p("A l'issu des calculs du squelette, si  on  zoom  très fortement  (au  1/50 ème ),  des  zigzags  sont  visibles sur le squelette.  Il  est  possible  de  lisser  le 
squelette avec les outils Qgis. Cette étape n'est pas obligatoire mais conseillée pour que les traces soient, 
au maximum, perpendiculaires à la côte (léger biais sinon). ."),
				   p("1 - ouvrir le squelette dans Qgis"),
				   p("2 - installer le plugin Cartographic Line Generalization dans Qgis"),
				   p("3 - utiliser le plugin pour lisser"),
				   span(style="color:green","Valeur Tuto : input : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR ; map scale denominator : 2000 ; genralisation type: Simplification + smoothing"),
				   p("4 - enregistrer le nouveau squelette"),
				   span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl.shp"),
				   p(" "),
			   p("Le squelette peut être composé de plusieurs morceaux. Attention pour la suite, notamment le calcul des traces, le squelette doit contenir une colonne NAxe à remplir par un numéro d'axe.")
				   )
  
  aide_trace=div(h3("Objectifs"),
                  p(paste("Dans ce menu, des traces perpendiculaires à la ligne de base sont créées en vue de faire des calculs de distance des traits de côte à la ligne de base, puis de faire des statistiques.")),
				  p("Pour la réalisation des traces, les différents segments de la ligne de base doivent être correctement orientés, en respectant la convention de la mer à droite et la terre à gauche."),				  
			      p("Cette ligne de base peut être composée de plusieurs morceaux. Attention le fichier doit contenir une colonne NAxe à remplir par un numéro d'axe."),
				  h3("Entrées :"),
				  h4("Nom du fichier de la ligne de base (sans l'extension)"),
				  p("Attention, mettre à jour le fichier si vous avez manipulé le squelette dans Qgis."),
				  span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl.shp"),
				  h4("Distance entre les traces"),
				  span(style="color:green","Valeur Tuto : 100"),
				  p(""),
				  h4("Longueur des traces"),
				  span(style="color:green","Valeur Tuto : 1000"),
				  p(""),
				  h3("Sorties :"),
				  p("A l'issue de cette étape, le fichier des traces est créé dans le répertoire de travail au format shape."),
			      span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000.shp"),
				  p("Il est possible de contrôler l'orientation de la ligne de base et donc des traces sur la carte de sortie. Les points verts doivent à terre et les points rouges en mer."),
				  p("Les traces ne doivent pas s'intersecter à des distances trop proches du littoral, pour la valider des calculs statistiques et aussi pour la représentation des résultats sous forme d'histogrammes. Au
				  menu Traces/Lissage des traces il est possible d'homogénéiser l'angle des traces pour éviter leur intersection."),
				  h3("Attention"),
				  p("Des traces peuvent venir intersecter plusieurs fois un trait de côte.
				  Si une enveloppe a été créée , si le projet ne contient pas d'enveloppe il faut raccourcir les traces.
				  Les traces sans traits de côte intersectant disparaitront des fichiers.
				  Il est possible de modifier sous SIG le fichier trace pour supprimer des traces, les bouger ou les rotationner")
				  )
  
  aide_tracelisse=div(h3("Objectifs"),
                      p(paste("Dans ce menu, trace lisse")))
  
  aide_ip=div(h3("Objectifs"),
              p(paste("Dans ce menu, les intersections ponctuelles entre les traces et les traits de côte sont calculées. ")),
			  h3("Entrées :"),
			  p("Commencez par actualiser le menu et pensez à actualiser les noms des fichiers si ils ont été modifiés."),
			  h4("Methode de calcul : le plus au large ou le plus à la côte"),
			  p("Un trait de côte peut intersecter plusieurs fois une trace, l'utilisateur doit choisir quelque point d'intersection chosir. Ce choix sera appliqué à toutes les traces."),
			  span(style="color:green","Valeur du Tuto : le plus au large"),
			  h4("Type de marqueurs : choix manuel ou choix auto sur le plus fréquent"),
			  p("le long d'une trace, des marqueurs de traits de côte différents peuvent être intersectés, par exemple 6 limites de jet de rive et 2 limites de végétation. L'utilisateur doit choisir quel type de marqueur conservé pour les analyses statistiques. Soit un choix manuel à faire trace par trace, soit laisser le logiciel choisir le marqueur le plus fréquent trace par trace."),
			  span(style="color:green","Valeur du Tuto : choix auto sur le plus fréquent"),
			  h4("Choisir les fichiers des tdc"),
				p("En appuyant sur browse une fenêtre s'ouvre, il faut aller chercher les traits de côte dans le répertoire de travail et choisir ceux qu'on veut utiliser pour faire l'enveloppe. On n'est pas obligé d'utiliser tous les traits de côte. Il faut sélectionner le shp de chaque trait de côte."),
				span(style="color:green","Dans le tuto les 4 shp des traits de côte sont sélectionnés"),
				h3("Sorties :"),
				  p("A l'issue de cette étape, 3 fichiers txt sont créés dans le répertoire de travail."),
				  p("Ils contiennent les intersections de straits de côte avec les traces"),
				  p("Le v00 contient toutes les intersections"),
				  p("Le v0 contient les intersections contenues dans l'enveloppe (si elle existe) et les intersections selon la méthode de calcul."),
				  p("Le v1 contient les intersections d'un seul type de marqueur."),
			      p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v00.txt")),
				  p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v0.txt")),
				  p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1.txt"))
			  )
  
  aide_intersuf=div(h3("Objectifs"),
                    p(paste("Dans ce menu, intersection surfacique")))
  
  aide_evol=div(h3("Objectifs"),
                p(paste("Dans ce menu, trace par trace, des statistiques sont calculées avec les intersections de l'étape précédente.")),
				h3("Entrées :"),
				p("Commencez par actualiser le menu et pensez à actualiser les noms des fichiers si ils ont été modifiés."),
				h4("Nom du producteur"),
				p("Mettre l'organisme qui effectue les calculs MobiTC. Cela alimente la table attributaire des résultats."),
				h4("Intervalles de confiance"),
				p("Suivant les méthodes statistiques, le logiciel peut donner un intervalle de confiance sur les ajsutements statistiques."),
				p(span(style="color:green","Valeur du Tuto : IC 70%")),
				h4("Date de début des graphiques"),
				p("Donner l'année de début des graphiques à produire"),
				p(span(style="color:green","Valeur du Tuto : 1940")),
				h4("Date de fin des graphiques"),
				p("Donner l'année de fin des graphiques à produire"),
				p(span(style="color:green","Valeur du Tuto : 2030")),
				p("Pour avoir un axe des absisses correctement formatter, il faut que la différence entre ces 2 dates soient un multiple de six." ),
				h4("Annee de l'extrapolation prospective"),
				p("Donner l'année d'une éventuelle extrapolation prospective, pour que le logiciel fasse dès à présent le calcul de la position du trait à cette date pour chaque statistique."),
				p(span(style="color:green","Valeur du Tuto : 2100")),
				h4("Date de césure"),
				p("Donner les années de césure pour le calcul des évolution."),
				p(span(style="color:green","Valeur du Tuto : 1980;2000")),
				h3("Sorties :"),
				p("A l'issue de cette étape, un répertoire Graph est créé dans le répertoire de travail. Il contient trace par trace, tous les éléments pour que le logiciel effectue les sorties graphiques des menus suivants."),
				p("Les calculs sont réalisés pour 3 périodes, avec tous les traits de côte (toutes dates), avec les traits de côtes post 1980, avec les traits de côtes post 2000."),
				p("3 fichiers txt sont aussi créés dans le répertoire de travail. Ils contiennent les taux d'évolution et leurs intervalles de confiance pour chaque loi statistique."),
				p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1-toutesdates-MobiTC.txt")),
				p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1-post1980-MobiTC.txt")),
				p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1-post2000-MobiTC.txt"))
				)
				  
  aide_graph_wls=div(h3("Objectifs"),
                p(paste("Dans ce menu, les graphiques de l'ajustement WLS sont exportés.")),
				h3("Entrées :"),
				p("Commencez par actualiser le menu et pensez à actualiser les noms des fichiers si ils ont été modifiés."),
				h3("Sorties :"),
				p("A l'issue de cette étape, un répertoire Graph_WLS est créé dans le répertoire de travail. Il contient tous les graphiques des ajustements WLS."),
				p("Il est alors possible d'utiliser pleinement la couche SIG des histogrammes, et d'ouvrir ces graphiques.")
				)
					  
  aide_histo=div(h3("Objectifs"),
                  p(paste("Dans ce menu, il est possible de réaliser un premier rendu sous forme d'histogrammes des taux d'évolution du trait de côte.")),
				  h3("Entrées :"),
				  p("Commencez par actualiser le menu et pensez à actualiser les noms des fichiers si ils ont été modifiés."),
				  h4("Choisir les fichiers de l'évolution (-MobiTC.txt)"),
				  p("Choisir le ou les fichiers sur lesquels seront basés le calcul des histogrammes. Pour éditer les rapports finaux il faut choisir les 3 fichiers réalisés à l'étape précédente."),
				  p(span(style="color:green","Valeur du Tuto : choisir les 4 fichiers -MobiTC.txt.")),
				  h4("Largeur en mètre des histogrammes"),
				  p("Donner la largeur en mètre des histogrammes, ne pas mettre plus que l'espacement entre les traces."),
				  p(span(style="color:green","Valeur du Tuto : 80")),
				  h4("Longueur en mètre representant un taux de 1m/an"),
				  p("Etant donné que la longueur de l'histogramme représente un taux d'évolution exprimé en m/an, il faut une correspondance pour l'appliquer sur la carte."),
				  p(span(style="color:green","Valeur du Tuto : 50")),
				  h4("Taux en m/an à partir duquel les histogrammes sont de longueurs constantes"),
				  p("Il peut être interessant de tronquer les histogrammes à partir d'un certain taux d'évoultion. Une flèche au bout de l'histogramme matérialise les histogrammes tronqués"),
				  p(span(style="color:green","Valeur du Tuto : 10")),
				  h4("Choisir le type de taux"),
				  p("Plusieurs lois statistiques sont utilisés, il s'agit de choisir laquelle réprésentée."),
				  p(span(style="color:green","Valeur du Tuto : WLS")),
				  h3("Sorties :"),
				  p("A l'issue de cette étape, des fichiers shp réprésentant des histogrammes sont créés dans le répertoire de travail."),
				  p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1-toutesdates-histo-WLS.shp")),
				p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1-post1980-histo-WLS.shp")),
				p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1-post2000-histo-WLS.shp")),
				p("La table attributaire contient par ligne (autant que de traces), les valeurs des différents paramètres statistiques et une colonne Graph_WLS qui permet l'ouverture des graphiques avec Qgis."),
				p("Les graphiques WLS se créent à l'étape suivante."),
				p("Une fois ouvert dans Qgis, il est possible d'appliquer un style à la couche. Il est disponible dans le répertoire du TUTO et se nomme histo.qml.")
				  )
					  
  aide_rapport=div(h3("Objectifs"),
                      p(paste("Dans ce menu, des rapports html résumant l'ensemble des calculs menés sont édités par trace.")),
					  p("Attention l'export est rapport en html est long."),
					  h3("Entrées :"),
				  p("Commencez par actualiser le menu et pensez à actualiser les noms des fichiers si ils ont été modifiés."),
				 	   h3("Sorties :"),
				  p("A l'issue de cette étape, un répertoire rapports est créé dans le répertoire de travail. Il contient tous les rapports html"),
				  p("Le fichier trace a été mis à jour pour ne contenir que les traces pour lesquelles un rapport a été édité : nouveau shp nom du fichier trace_html.shp."),
				  p("Ce nouveau fichier shp permet de lier la couche SIG des traces au rapport html, par une action d'ouverture ou un formulaire, en les applicant à la colonne html."),
				  p("Une fois ouvert dans Qgis, il est possible d'appliquer un style à la couche. Il est disponible dans le répertoire du TUTO et se nomme html.qml."),
				  p("Un autre répertoire Graph_png est créé dans le répertoire de travail. Il contient tous les graphiques contenus dans les rapports html. Il est également possible de les utiliser dans les formulaires de Qgis, en adaptant le nom des colonnes."),
				  p("Attention BUG : il faut lancer ce menu 2 fois pour que la palette de couleurs des histogrammes s'implémentent.")			  
					  )				  
  

  
  sortie=list(aide_pres,aide_pack,aide_init,aide_fourn,aide_liste_tdc,aide_miseenforme_tdc,aide_env,
              aide_sque,aide_sque_coup,aide_sque_voro,aide_squerac,aide_squeorr,aide_squelisse,
              aide_trace,aide_tracelisse,
              aide_ip,aide_intersuf,
              aide_evol,aide_graph_wls,aide_rapport,aide_histo)
  
  names(sortie) <- c("aide_pres","aide_pack","aide_init", "aide_fourn", "aide_liste_tdc","aide_miseenforme_tdc","aide_env",
                     "aide_sque","aide_sque_coup","aide_sque_voro","aide_squerac","aide_squeorr","aide_squelisse",
                     "aide_trace","aide_tracelisse",
                     "aide_ip","aide_intersuf",
                     "aide_evol","aide_graph_wls","aide_rapport","aide_histo")
  
  return(sortie)
}