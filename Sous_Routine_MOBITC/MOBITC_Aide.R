MOBITC_Aide<-function(chem_mobitc)
{
  aide_pres=div(h3("Bienvenue dans MobiTC"),
				p("Le logiciel MobiTC (Mobilité du Trait de Côte) est un outil automatisé de traitement des traits de côte 
					historiques, développé au Cerema Méditerranée. Il se base sur le traitement fortement automatisé des 
					traits de côte pour effectuer les principaux calculs utilisés en ingénierie et en recherche."),
				p("La première étape consiste à créer une ligne de base issue du squelette des traits de côte (algorithme de 
				Voronoï). Des traces perpendiculaires à cette ligne de base sont ensuite créées et leurs intersections 
				avec les traits de côte font l'objet de traitements statistiques simples comme le calcul d’une régression 
				linéaire et de ces intervalles de confiance."),
				p("Les résultats sont ensuite convertibles sous forme SIG afin de répondre à une visualisation simple de la 
				mobilité du trait de côte. La projection des traits de côte à échéance est aussi disponible en prenant à la 
				fois en compte la projection de la régression linéaire et ses intervalles de confiance. "),
				span(style="color:green","Les champs/explications en vert dans les pages d'aide correspondent au tutoriel réalisé à partir de 4 traits de côte. Il est conseillé de dérouler ce tutoriel lors de la première utilisation de MobiTC. A chaque menu un onglet Aide donne les indications pour faire tourner MobiTC.")
				)
  
  aide_pack=div(h3("Objectifs :"),
                p("Dans ce menu, les packages R nécessaires à MobiTC sont installés. Cela peut être plus ou moins longs suivant la connection à Internet.")
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
				p("Mettre le chemin complet du répertoire où sont stockés les traits de côte et où seront stockés les fichiers résultat"),
				span(style="color:green","xxxx\\Tuto_MOBITCR"),
                h4("- Nom du projet"),
				p("Il est possible de donner un nom au projet en cours. Ce nom doit être court et sans espace, il sera écrit sur le nom des fichiers résultat"),
				span(style="color:green","Tuto")
				)
  
  aide_fourn=div(h3("Objectifs"),
                 p(paste("Dans ce menu, une liste de fournisseurs de trait de côte est mise à jour. Elle est stockée dans le répertoire de travail. Il faut appuyer sur le bouton voir la liste, pour que celle-ci s'exporte."))
                 )
  
  aide_liste_tdc=div(h3("Objectifs"),
                     p(paste("Dans ce menu, une liste de trait de côte est mise à jour. Il faut appuyer sur le bouton voir la liste, pour que celle-ci s'exporte."))
  )
  
  aide_miseenforme_tdc=div(h3("Objectifs"),
                     p(paste("Ce menu est un mémo pour rappeler comment les traits de côte doivent être mis en forme avant d'utiliser MobiTC.")),
					 p("Cette mise en forme peut être réalisée sous Qgis"),
					 p("Les traits de côte doivent être des fichiers shape contenant une table attributaire avec à minima les champs "),
					 p("- date1 : date du trait de côte, au format AAAAMMJJHHMMSS (AAAA : Année, MM : Mois, JJ : Jour, HH : Heure, MM : Minute, SS : Seconde), dans la majorité des cas date1 contient juste une année"),
					 p("- date2 : 2e date du trait de côte, au format AAAAMMJJHHMMSS, dans le cas où on connaitera un intervalle de dates d'acquisition du trait de côte"),
					 p("- marqueur : numéro du marqueur tel que définit au menu Marqueur TDC, par exemple 3 pour une limite de jet de rive"),
					 p("- incert : incertitude du trait de côte exprimée en mètre, la position du trait de côte se situe dans un intervalle compris entre +/- l'incertitude donnée ici"),
					 p("- prj_tdc : indiquer la projection du trait de côte, il est important que tous les traits de côte soient dans la même projection et que cette projection soit en mètre"),
					 p("- leve : 2 valeurs possible NUM si le trait de côte a été digitalisé à partir d'un fond cartographique, LEV si le trait de côte a été levé sur le terrain, par exemple avec l'application Rivages"),
					 p("- product : nom court de l'organisme qui a réalisé ou a fait réaliser le trait de côte, tel que définit dans le menu Fournisseur TDC"),
					 p(""),
					 p("Les traits de côte peuvent contenir d'autres champs qui ne seront pas utilisés dans les calculs")
  )
  
  aide_env=div(h3("Objectifs"),
				p("Ce menu est la première étape pour la réalisation de la ligne de base."),
				p("Pour rappel, la ligne de base est une sorte de ligne moyenne générée à partir des TDC disponibles qui 
va permettre de définir des lignes perpendiculaires, appelées traces, où l'évolution du TDC sera calculée. 
Cette ligne de base sera donc le « point 0 », à partir duquel la distance aux différents TDC sera calculée 
et transformée en évolution du trait de côte. "),
				p("Pour avoir une ligne de base cohérente avec les TDC, il faut que celle-ci soit d'une forme représentative 
des différents TDC. C'est pourquoi, dans MobiTC, il a été choisi de réaliser de façon automatique une 
ligne  de  base,  à  partir  de  l'ensemble  des  différents  TDC  disponibles,  en  représentant  une  sorte  de 
médiane. Pour cela le principe de la squelettisation a été retenu. "),
				p("Dans ce menu, l'enveloppe contenant tous les TDC est tracée. Au menu Ligne de base, le squelette de cette enveloppe est réalisé."),
				h3("Entrées :"),
				p("Commencez par actualiser le menu et pensez à actualiser les noms des fichiers/projets si ils ont été modifiés."),
				h4("Distance de coupure des tdc"),
				p("Cette distance est donnée en mètre. Des points sur les TDC seront créés et leur espacement sera égal à cette distance. La triangularisation s'appuiera sur ces points."),
				span(style="color:green","Valeur Tuto : 10"),
				h4("Longueur max des triangles à garder (m)"),
				p("Cette distance est donnée en mètre. Elle définir la longueur des côtés des triangles créés maximum à garder."),
				span(style="color:green","Valeur Tuto : 1000"),
				h4("Choisir les fichiers des tdc"),
				p("En appuyant sur browse une fenêtre s'ouvre, il faut aller chercher les traits de côte dans le répertoire de travail et choisir ceux qu'on veut utiliser pour faire l'enveloppe. On n'est pas obligé d'utiliser tous les traits de côte. Il faut sélectionner le shp de chaque trait de côte."),
				span(style="color:green","Dans le tuto les 4 shp des traits de côte sont sélectionnés"),
				h3("Sorties :"),
				p("A l'issue de cette étape, le fichier de l'enveloppe est créé dans le répertoire de travail au format shape."),
			    span(style="color:green","Valeur Tuto : 20190614T111201-Tuto-Env-C010-T1000.shp"),
				h3("Attention"),
			    p("Une fois l'enveloppe produite, il faut s'assurer que l'enveloppe ne contient pas d'îlot. Ceci peut être réalisée en parcourant l'enveloppe que la carte résultat. Si il y a des ilots il faut les supprimer avec un logiciel SIG. 
				Si vous changez le nom du fichier shape, pensez à actualiser le nom dans les menus suivants ou dans le fichier Init_Routine_MobiTC.txt."),
				h3("Bon à savoir"),
				p("Il est possible de s'affranchir des étapes de réalisation de l'enveloppe et de la ligne de base lorsque les calculs sont trop longs.
				Il est possible de passer directement au menu Traces avec une ligne de base provenant d'une autre source. Il faut que cette ligne de base soit tout de même correctement orientée.")
  )
  
  aide_sque=div(h3("Objectif"),
               p(paste("Dans ce menu, la ligne de base, appelée aussi squelette, est calculée.")),
			   p("La squelettisation, c'est-à-dire la génération d'une ligne médiane à travers l'enveloppe, s'effectue dans MobiTC à partir du diagramme de Voronoï et de points :"),
			   p("- situés sur les nœuds du contour de l'enveloppe,"),
			   p("- et situés tous les zzz m (distance de coupure de l'enveloppe)."),
			   h3("Entrées :"),
			   h4("Distance de coupure de l'enveloppe"),
			   p("Cette distance est donnée en mètre. Sur de grandes étendues le calcul peut devenir un peu long si cette distance est trop faible."),
			   span(style="color:green","Valeur Tuto : 50"),
			   h3("Sorties :"),
			   p("A l'issue de cette étape, le fichier du squelette est créé dans le répertoire de travail au format shape."),
			   span(style="color:green","Valeur Tuto : 20190614T111201-Tuto-Env-C010-T1000-Sque-C050.shp")
			   )
  
  aide_squerac=div(h3("Objectifs"),
                   p(paste("Dans ce menu, il est possible de raccorder les morceaux de squelette entre eux. Ceci est intéressant pour n'avoir que des gros morceaux à orienter")),
				   h3("Entrées :"),
				   h4("Choisir le fichier du squelette"),
				   p("En appuyant sur browse une fenêtre s'ouvre, il faut aller chercher le fichier dans le répertoire de travail. Il faut sélectionner le shp."),
				 span(style="color:green","Valeur Tuto : 20190614T111201-Tuto-Env-C010-T1000-Sque-C050.shp"),
				   h4("Distance de raccordement"),
				   p("Cette distance est donnée en mètre."),
				   span(style="color:green","Valeur Tuto : 1000"),
				   h3("Sorties :"),
				   p("A l'issue de cette étape, le nouveau fichier du squelette est créé dans le répertoire de travail au format shape."),
			       span(style="color:green","Valeur Tuto : 20170510T114559-test-Env-C010-T1000-T-Sque-C001.shp")
				   )
  
  aide_squeorr=div(h3("Objectifs"),
                   p(paste("Ce menu est un mémo qui explique comment orienter le squelette dans Qgis")),
				   p("La convention est prise dans MobiTC de parcourir les squelettes en laissant à gauche la terre et à droite la mer. Si ce n'est pas le cas pour certains des morceaux du squelette il faut les retourner dans Qgis."),
				   p("1 - ouvrir le squelette dans Qgis"),
				   p("2 - visualiser les orientations des morceaux en utilisant le style sque.qml qui se situe dans le repertoire du Tuto"),
				   p("3 - installer le plugin Swap Vector Direction dans Qgis"),
				   p("4 - sélectionner les morceaux à inverser"),
				   p("5 - enregistrer le nouveau squelette")
				   )
  
  aide_squelisse=div(h3("Objectif"),
                   p(paste("Ce menu est un mémo qui explique comment orienter le squelette dans Qgis")),
				   p("A l'issu des calculs du squelette, si  on  zoom  très fortement  (au  1/50 ème ),  des  zigzags  sont  visibles sur squelette.  Il  est  possible  de  lisser  le 
squelette avec les outils Qgis. Cette étape n’est pas obligatoire mais conseillé pour que les traces soient, 
au maximum, perpendiculaires à la côte (léger biais sinon). ."),
				   p("1 - ouvrir le squelette dans Qgis"),
				   p("2 - installer le plugin Cartographic Line Generalization dans Qgis"),
				   p("3 - utiliser le plugin avec les paramètres suivants"),
				   p("4 - enregistrer le nouveau squelette")
				   )
  
  aide_trace=div(h3("Objectifs"),
                  p(paste("Dans ce menu, des traces perpendiculaires à la ligne de base sonr crées en vue de faire des calculs de distance des traits de côte à la ligne de base, puis de faire des statistiques.")),
				  p("Pour la réalisation des traces, les différents segments de la ligne de base doivent être correctement orientés, en respectant la convention de la mer à droite et la terre à gauche."),
				  h3("Entrées :"),
				  h4("Distance entre les traces"),
				  p(""),
				  h4("Longueur des traces"),
				  p(""),
				  h3("Sorties :"),
				  p("A l'issue de cette étape, le fichier des traces est créé dans le répertoire de travail au format shape.
			      Par exemple : 20170510T114559-test-Env-C010-T1000-T-Sque-C001-T.shp"),
				  p("Il est possible de contrôler l'orientation de la ligne de base et donc des traces sur la carte de sortie. Les points verts doivent à terre et les points rouges en mer."),
				  p("Les traces ne doivent pas s'intersecter à des distances trop proches du littoral, pour la valider des calculs statistiques et aussi pour la représentation des résultats sour forme d'histogrammes. Au
				  menu Traces/Lissage des traces il est possible d'homogénéiser l'angle des traces pour éviter leur intersection."),
				  h3("Attention"),
				  p("Des traces peuvent venir intersecter plusieurs fois un trait de côte.
				  Si une enveloppe a été crée , si le projet ne contient pas d'enveloppe il faut raccourcir les traces.
				  Les traces sans traits de côte intersectant disparaitront des fichiers.
				  Il est possible de modifier sous SIG le fichier trace pour supprimer des traces, les bouger ou les rotationner")
				  )
  
  aide_tracelisse=div(h3("Objectifs"),
                      p(paste("Dans ce menu, trace lisse")))
  
  aide_ip=div(h3("Objectifs"),
              p(paste("Dans ce menu, intersection ponctuelle")))
  
  aide_intersuf=div(h3("Objectifs"),
                    p(paste("Dans ce menu, intersection surfacique")))
  
  aide_evol=div(h3("Objectifs"),
                p(paste("Dans ce menu, évolution")))
				  
  aide_graph=div(h3("Objectifs"),
                      p(paste("Dans ce menu, graph")))
					  
  aide_rapport=div(h3("Objectifs"),
                      p(paste("Dans ce menu, rapport")))				  
  
  aide_histo=div(h3("Objectifs"),
                  p(paste("Dans ce menu, histogramme")))
  
  sortie=list(aide_pres,aide_pack,aide_init,aide_fourn,aide_liste_tdc,aide_miseenforme_tdc,aide_env,
              aide_sque,aide_squerac,aide_squeorr,aide_squelisse,
              aide_trace,aide_tracelisse,
              aide_ip,aide_intersuf,
              aide_evol,aide_graph,aide_rapport,aide_histo)
  
  names(sortie) <- c("aide_pres","aide_pack","aide_init", "aide_fourn", "aide_liste_tdc","aide_miseenforme_tdc","aide_env",
                     "aide_sque","aide_squerac","aide_squeorr","aide_squelisse",
                     "aide_trace","aide_tracelisse",
                     "aide_ip","aide_intersuf",
                     "aide_evol","aide_graph","aide_rapport","aide_histo")
  
  return(sortie)
}