MOBITC_Aide<-function(chem_mobitc)
{
  aide_pres=div(h3("Bienvenue dans MobiTC"),
				p("Le logiciel MobiTC (Mobilit� du Trait de C�te) est un outil automatis� de traitement des traits de c�te 
					historiques, d�velopp� au Cerema M�diterran�e. Il se base sur le traitement fortement automatis� des 
					traits de c�te pour effectuer les principaux calculs utilis�s en ing�nierie et en recherche."),
				p("La premi�re �tape consiste � cr�er une ligne de base issue du squelette des traits de c�te (algorithme de 
				Vorono�). Des traces perpendiculaires � cette ligne de base sont ensuite cr��es et leurs intersections 
				avec les traits de c�te font l'objet de traitements statistiques simples comme le calcul d�une r�gression 
				lin�aire et de ces intervalles de confiance."),
				p("Les r�sultats sont ensuite convertibles sous forme SIG afin de r�pondre � une visualisation simple de la 
				mobilit� du trait de c�te. La projection des traits de c�te � �ch�ance est aussi disponible en prenant � la 
				fois en compte la projection de la r�gression lin�aire et ses intervalles de confiance. "),
				span(style="color:green","Les champs/explications en vert dans les pages d'aide correspondent au tutoriel r�alis� � partir de 4 traits de c�te. Il est conseill� de d�rouler ce tutoriel lors de la premi�re utilisation de MobiTC. A chaque menu un onglet Aide donne les indications pour faire tourner MobiTC."),
				p(span(style="color:green","Les fichiers correspondant au tutoriel sont dans le r�pertoire TUTO : ")),
				a("https://github.com/CEREMA/dtermed.MobiTC/tree/master/TUTO",href="https://github.com/CEREMA/dtermed.MobiTC/tree/master/TUTO"),
				p(),
				p(span(style="color:green","Les 4 traits de c�tes sont fournis uniquement dans le cadre du tutoriel. Ne pas les utiliser pour une �tude de l'�voultion du trait de c�te de ce secteur."))
				)
  
  aide_pack=div(h3("Objectifs :"),
                p("Dans ce menu, les packages R n�cessaires � MobiTC sont install�s. Cela peut �tre plus ou moins long suivant la connection � Internet.")
  )
  
  aide_init=div(h3("Objectifs :"),
                p(paste("Dans ce menu, un fichier d'initialisation est cr�� ou mis � jour dans le r�pertoire", chem_mobitc ,"pour stocker le chemin du r�pertoire de travail et les principaux noms des fichiers cr��s par MobiTC.")),
                p("Ce fichier est mis � jour au fur et � mesure que les diff�rentes �tapes de MobiTC ont �t� lanc�es."),
                p("Ce fichier permet la mise � jour des noms des fichiers dans les diff�rents menus de MobiTC. Lorsque les boutons",
                  em("Actualiser le menu"),
                  "sont click�s, ce fichier est lu."),
                p("Ce fichier peut aussi �tre modifi� par un �diteur de texte."),
                h3("Entr�es :"),
                h4("- Chemin du r�pertoire de travail"),
				p("Mettre le chemin complet du r�pertoire o� sont stock�s les traits de c�te et o� seront stock�s les fichiers r�sultat."),
				span(style="color:green","xxxx\\TUTO"),
                h4("- Nom du projet"),
				p("Il est possible de donner un nom au projet en cours. Ce nom doit �tre court et sans espace, il sera �crit sur le nom des fichiers r�sultat."),
				span(style="color:green","Tuto")
				)
  
  aide_fourn=div(h3("Objectifs"),
                 p(paste("Dans ce menu, une liste de fournisseurs de trait de c�te est mise � jour. Elle est stock�e dans le r�pertoire de travail. Il faut appuyer sur le bouton voir la liste, pour que celle-ci s'exporte.")),
                 p("Cette �tape est obligatoire sinon au moment du Calcul de l'�volution le logiciel plantera."),
				 span(style="color:green","3 des traits de c�te du Tuto ont �t� produits par le Cerema et un par l'application Rivages. Ils sont d�j� renseign�s dans la liste de base.")
                 )
  
  aide_liste_tdc=div(h3("Objectifs"),
                     p(paste("Dans ce menu, une liste de trait de c�te est mise � jour. Il faut appuyer sur le bouton voir la liste, pour que celle-ci s'exporte.")),
					 p("Cette �tape est obligatoire sinon au moment du Calcul de l'�volution le logiciel plantera.")
  )
  
  aide_miseenforme_tdc=div(h3("Objectifs"),
                     p(paste("Ce menu est un m�mo pour rappeler comment les traits de c�te doivent �tre mis en forme avant d'utiliser MobiTC.")),
					 p("Cette mise en forme peut �tre r�alis�e sous Qgis"),
					 p("Les traits de c�te doivent �tre des fichiers shape contenant une table attributaire avec � minima les champs "),
					 p("- date1 : date du trait de c�te, au format AAAAMMJJHHMMSS (AAAA : Ann�e, MM : Mois, JJ : Jour, HH : Heure, MM : Minute, SS : Seconde), dans la majorit� des cas date1 contient juste une ann�e"),
					 p("- date2 : 2e date du trait de c�te, au format AAAAMMJJHHMMSS, dans le cas o� on connaitera un intervalle de dates d'acquisition du trait de c�te"),
					 p("- marqueur : num�ro du marqueur tel que d�finit au menu Marqueur TDC, par exemple 3 pour une limite de jet de rive"),
					 p("- incert : incertitude du trait de c�te exprim�e en m�tre, la position du trait de c�te se situe dans un intervalle compris entre +/- l'incertitude donn�e ici"),
					 p("- prj_tdc : indiquer la projection du trait de c�te, il est important que tous les traits de c�te soient dans la m�me projection et que cette projection soit en m�tre"),
					 p("- leve : 2 valeurs possible NUM si le trait de c�te a �t� digitalis� � partir d'un fond cartographique, LEV si le trait de c�te a �t� lev� sur le terrain, par exemple avec l'application Rivages"),
					 p("- product : nom court de l'organisme qui a r�alis� ou a fait r�aliser le trait de c�te"),
					 p(""),
					 p("Les traits de c�te peuvent contenir d'autres champs qui ne seront pas utilis�s dans les calculs")
  )
  
  aide_env=div(h3("Objectifs"),
				p("Ce menu est la premi�re �tape pour la r�alisation de la ligne de base."),
				p("Pour rappel, la ligne de base est une sorte de ligne moyenne g�n�r�e � partir des TDC disponibles qui 
va permettre de d�finir des lignes perpendiculaires, appel�es traces, o� l'�volution du TDC sera calcul�e. 
Cette ligne de base sera donc le � point 0 �, � partir duquel la distance aux diff�rents TDC sera calcul�e 
et transform�e en �volution du trait de c�te. "),
				p("Pour avoir une ligne de base coh�rente avec les TDC, il faut que celle-ci soit d'une forme repr�sentative 
des diff�rents TDC. C'est pourquoi, dans MobiTC, il a �t� choisi de r�aliser de fa�on automatique une 
ligne  de  base,  �  partir  de  l'ensemble  des  diff�rents  TDC  disponibles,  en  repr�sentant  une  sorte  de 
m�diane. Pour cela le principe de la squelettisation a �t� retenu. "),
				p("Dans ce menu, l'enveloppe contenant tous les TDC est trac�e. Au menu Ligne de base, le squelette de cette enveloppe est r�alis�."),
				h3("Entr�es :"),
				p("Commencez par actualiser le menu et pensez � actualiser les noms des fichiers/projets si ils ont �t� modifi�s."),
				h4("Distance de coupure des tdc"),
				p("Cette distance est donn�e en m�tre. Des points sur les TDC seront cr��s et leur espacement sera �gal � cette distance. La triangularisation s'appuiera sur ces points."),
				span(style="color:green","Valeur Tuto : 10"),
				h4("Longueur max des triangles � garder (m)"),
				p("Cette distance est donn�e en m�tre. Elle d�finir la longueur des c�t�s des triangles cr��s maximum � garder."),
				span(style="color:green","Valeur Tuto : 1000"),
				h4("Choisir les fichiers des tdc"),
				p("En appuyant sur browse une fen�tre s'ouvre, il faut aller chercher les traits de c�te dans le r�pertoire de travail et choisir ceux qu'on veut utiliser pour faire l'enveloppe. On n'est pas oblig� d'utiliser tous les traits de c�te. Il faut s�lectionner le shp de chaque trait de c�te."),
				span(style="color:green","Dans le tuto les 4 shp des traits de c�te sont s�lectionn�s"),
				h3("Sorties :"),
				p("A l'issue de cette �tape, le fichier de l'enveloppe est cr�� dans le r�pertoire de travail au format shape et une carte s'affiche."),
			    span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000.shp"),
				h3("Attention"),
			    p("Une fois l'enveloppe produite, il faut s'assurer que l'enveloppe ne contient pas d'�lot. Ceci peut �tre r�alis�e en parcourant l'enveloppe dans la carte r�sultat. Si il y a des ilots il faut les supprimer avec un logiciel SIG. 
				Si vous changez le nom du fichier shape de l'enveloppe, pensez � actualiser le nom dans les menus suivants ou dans le fichier Init_Routine_MobiTC.txt."),
				h3("Bon � savoir"),
				p("Il est possible de s'affranchir des �tapes de r�alisation de l'enveloppe et de la ligne de base lorsque les calculs sont trop longs.
				Il est possible de passer directement au menu Traces avec une ligne de base provenant d'une autre source. Il faut que cette ligne de base soit tout de m�me correctement orient�e.")
  )
  
  aide_sque=div(h3("Objectif"),
               p(paste("Dans ce menu, la ligne de base, appel�e aussi squelette, est calcul�e.")),
			   p("La squelettisation, c'est-�-dire la g�n�ration d'une ligne m�diane � travers l'enveloppe, s'effectue dans MobiTC � partir du diagramme de Vorono� et de points :"),
			   p("- situ�s sur les n�uds du contour de l'enveloppe,"),
			   p("- et situ�s tous les zzz m (distance de coupure de l'enveloppe)."),
			   h3("Entr�es :"),
			   h4("Distance de coupure de l'enveloppe"),
			   p("Cette distance est donn�e en m�tre. Sur de grandes �tendues le calcul peut devenir un peu long si cette distance est trop faible."),
			   span(style="color:green","Valeur Tuto : 1"),
			   h3("Sorties :"),
			   p("A l'issue de cette �tape, le fichier du squelette est cr�� dans le r�pertoire de travail au format shape."),
			   span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001.shp"),
			   p(" "),
			   p("Le squelette peut �tre compos� de plusieurs morceaux. Attention pour la suite, notamment le calcul des traces, le squelette doit contenir une colonne NAxe � remplir par un num�ro d'axe.")
			   )
  
  aide_squerac=div(h3("Objectifs"),
                   p(paste("Dans ce menu, il est possible de raccorder les morceaux de squelette entre eux. Ceci est int�ressant pour n'avoir que des gros morceaux � orienter")),
				   h3("Entr�es :"),
				   h4("Choisir le fichier du squelette"),
				   p("En appuyant sur browse une fen�tre s'ouvre, il faut aller chercher le fichier dans le r�pertoire de travail. Il faut s�lectionner le shp."),
				span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001.shp"),
				   h4("Distance de raccordement"),
				   p("Cette distance est donn�e en m�tre."),
				   span(style="color:green","Valeur Tuto : 5"),
				   h3("Sorties :"),
				   p("A l'issue de cette �tape, le nouveau fichier du squelette est cr�� dans le r�pertoire de travail au format shape."),
			       span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR.shp"),
				   p(" "),
			   p("Le squelette peut �tre compos� de plusieurs morceaux. Attention pour la suite, notamment le calcul des traces, le squelette doit contenir une colonne NAxe � remplir par un num�ro d'axe.")
				   )
  
  aide_squeorr=div(h3("Objectifs"),
                   p(paste("Ce menu est un m�mo qui explique comment orienter le squelette dans Qgis")),
				   p("La convention est prise dans MobiTC de parcourir les squelettes en laissant � gauche la terre et � droite la mer. Si ce n'est pas le cas pour certains des morceaux du squelette il faut les retourner dans Qgis."),
				   p("1 - ouvrir le squelette dans Qgis"),
				   p("2 - visualiser les orientations des morceaux en utilisant le style sque.qml qui se situe dans le repertoire du Tuto"),
				   p("3 - installer le plugin Swap Vector Direction dans Qgis"),
				   p("4 - s�lectionner les morceaux � inverser"),
				   p("5 - enregistrer le nouveau squelette"),
				   span(style="color:green","Valeur Tuto : non utile, le squelette est d�j� bien orient�."),
				   p(" "),
			   p("Le squelette peut �tre compos� de plusieurs morceaux. Attention pour la suite, notamment le calcul des traces, le squelette doit contenir une colonne NAxe � remplir par un num�ro d'axe.")
				   )
  
  aide_squelisse=div(h3("Objectif"),
                   p(paste("Ce menu est un m�mo qui explique comment lisser le squelette dans Qgis")),
				   p("A l'issu des calculs du squelette, si  on  zoom  tr�s fortement  (au  1/50 �me ),  des  zigzags  sont  visibles sur le squelette.  Il  est  possible  de  lisser  le 
squelette avec les outils Qgis. Cette �tape n�est pas obligatoire mais conseill� pour que les traces soient, 
au maximum, perpendiculaires � la c�te (l�ger biais sinon). ."),
				   p("1 - ouvrir le squelette dans Qgis"),
				   p("2 - installer le plugin Cartographic Line Generalization dans Qgis"),
				   p("3 - utiliser le plugin pour lisser"),
				   span(style="color:green","Valeur Tuto : input : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR ; map scale denominator : 2000 ; genralisation type: Simplification + smoothing"),
				   p("4 - enregistrer le nouveau squelette"),
				   span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl.shp"),
				   p(" "),
			   p("Le squelette peut �tre compos� de plusieurs morceaux. Attention pour la suite, notamment le calcul des traces, le squelette doit contenir une colonne NAxe � remplir par un num�ro d'axe.")
				   )
  
  aide_trace=div(h3("Objectifs"),
                  p(paste("Dans ce menu, des traces perpendiculaires � la ligne de base sonr cr�es en vue de faire des calculs de distance des traits de c�te � la ligne de base, puis de faire des statistiques.")),
				  p("Pour la r�alisation des traces, les diff�rents segments de la ligne de base doivent �tre correctement orient�s, en respectant la convention de la mer � droite et la terre � gauche."),				  
			      p("Cette ligne de base peut �tre compos�e de plusieurs morceaux. Attention le fichier doit contenir une colonne NAxe � remplir par un num�ro d'axe."),
				  h3("Entr�es :"),
				  h4("Nom du fichier de la ligne de base (sans l'extension)"),
				  p("Attention, mettre � jour le fichier si vous avez manipul� le squelette dans Qgis."),
				  span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl.shp"),
				  h4("Distance entre les traces"),
				  span(style="color:green","Valeur Tuto : 100"),
				  p(""),
				  h4("Longueur des traces"),
				  span(style="color:green","Valeur Tuto : 1000"),
				  p(""),
				  h3("Sorties :"),
				  p("A l'issue de cette �tape, le fichier des traces est cr�� dans le r�pertoire de travail au format shape."),
			      span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000.shp"),
				  p("Il est possible de contr�ler l'orientation de la ligne de base et donc des traces sur la carte de sortie. Les points verts doivent � terre et les points rouges en mer."),
				  p("Les traces ne doivent pas s'intersecter � des distances trop proches du littoral, pour la valider des calculs statistiques et aussi pour la repr�sentation des r�sultats sour forme d'histogrammes. Au
				  menu Traces/Lissage des traces il est possible d'homog�n�iser l'angle des traces pour �viter leur intersection."),
				  h3("Attention"),
				  p("Des traces peuvent venir intersecter plusieurs fois un trait de c�te.
				  Si une enveloppe a �t� cr�e , si le projet ne contient pas d'enveloppe il faut raccourcir les traces.
				  Les traces sans traits de c�te intersectant disparaitront des fichiers.
				  Il est possible de modifier sous SIG le fichier trace pour supprimer des traces, les bouger ou les rotationner")
				  )
  
  aide_tracelisse=div(h3("Objectifs"),
                      p(paste("Dans ce menu, trace lisse")))
  
  aide_ip=div(h3("Objectifs"),
              p(paste("Dans ce menu, les intersections ponctuelles entre les traces et les traits de c�te sont calcul�es. ")),
			  h3("Entr�es :"),
			  p("Commencez par actualiser le menu et pensez � actualiser les noms des fichiers si ils ont �t� modifi�s."),
			  h4("Methode de calcul : le plus au large ou le plus � la c�te"),
			  p("Un trait de c�te peut intersecter plusieurs fois une trace, l'utilisateur doit choisir quelque point d'intersection chosir. Ce choix sera appliqu� � toutes les traces."),
			  span(style="color:green","Valeur du Tuto : le plus au large"),
			  h4("Type de marqueurs : choix manuel ou choix auto sur le plus fr�quent"),
			  p("le long d'une trace, des marqueurs de traits de c�te diff�rents peuvent �tre intersect�s, par exemple 6 limites de jet de rive et 2 limites de v�g�tation. L'utilisateur doit choisir quel type de marqueur conserv� pour les analyses statistiques. Soit un choix manuel � faire trace par trace, soit laisser le logiciel choisir le marqueur le plus fr�quent trace par trace."),
			  span(style="color:green","Valeur du Tuto : choix auto sur le plus fr�quent"),
			  h4("Choisir les fichiers des tdc"),
				p("En appuyant sur browse une fen�tre s'ouvre, il faut aller chercher les traits de c�te dans le r�pertoire de travail et choisir ceux qu'on veut utiliser pour faire l'enveloppe. On n'est pas oblig� d'utiliser tous les traits de c�te. Il faut s�lectionner le shp de chaque trait de c�te."),
				span(style="color:green","Dans le tuto les 4 shp des traits de c�te sont s�lectionn�s"),
				h3("Sorties :"),
				  p("A l'issue de cette �tape, 3 fichiers txt sont cr��s dans le r�pertoire de travail."),
				  p("Ils contiennent les intersections de straits de c�te avec les traces"),
				  p("Le v00 contient toutes les intersections"),
				  p("Le v0 contient les intersections contenues dans l'enveloppe (si elle existe) et les intersections selon la m�thode de calcul."),
				  p("Le v1 contient les intersections d'un seul type de marqueur."),
			      p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v00.txt")),
				  p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v0.txt")),
				  p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1.txt"))
			  )
  
  aide_intersuf=div(h3("Objectifs"),
                    p(paste("Dans ce menu, intersection surfacique")))
  
  aide_evol=div(h3("Objectifs"),
                p(paste("Dans ce menu, trace par trace, des statistiques sont calcul�es avec les intersections de l'�tape pr�c�dente.")),
				h3("Entr�es :"),
				p("Commencez par actualiser le menu et pensez � actualiser les noms des fichiers si ils ont �t� modifi�s."),
				h4("Nom du producteur"),
				p("Mettre l'organisme qui effectue les calculs MobiTC. Cela alimente la table attributaire des r�sultats."),
				h4("Intervalles de confiance"),
				p("Suivant les m�thodes statistiques, le logiciel peut donner un intervalle de confiance sur les ajsutements statistiques."),
				p(span(style="color:green","Valeur du Tuto : IC 70%")),
				h4("Date de d�but des graphiques"),
				p("Donner l'ann�e de d�but des graphiques � produire"),
				p(span(style="color:green","Valeur du Tuto : 1940")),
				h4("Date de fin des graphiques"),
				p("Donner l'ann�e de fin des graphiques � produire"),
				p(span(style="color:green","Valeur du Tuto : 2030")),
				p("Pour avoir un axe des absisses correctement formatter, il faut que la diff�rence entre ces 2 dates soient un multiple de six." ),
				h4("Annee de l'extrapolation prospective"),
				p("Donner l'ann�e d'une �ventuelle extrapolation prospective, pour que le logiciel fasse d�s � pr�sent le calcul de la position du trait � cette date pour chaque statistique."),
				p(span(style="color:green","Valeur du Tuto : 2100")),
				h3("Sorties :"),
				p("A l'issue de cette �tape, un r�pertoire Graph est cr�� dans le r�pertoire de travail. Il contient trace par trace, tous �l�ments pour que le logiciel effectue les sorties graphiques des menus suivants."),
				p("Les calculs sont r�alis�s pour 4 p�riodes, avec toutes les traits de c�te (toutes dates), avec les traits de c�tes post 1950, avec les traits de c�tes post 2000 et avec les traits de c�tes post 2010"),
				p("4 fichiers txt sont aussi cr��s dans le r�pertoire de travail. Ils contiennent les taux d'�volution et leurs intervalles de confiance pour chaque loi statistique."),
				p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1-toutesdates-MobiTC.txt")),
				p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1-post1950-MobiTC.txt")),
				p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1-post2000-MobiTC.txt")),
				p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1-post2010-MobiTC.txt"))
				)
				  
  aide_graph=div(h3("Objectifs"),
                      p(paste("Dans ce menu, graph")))
					  
  aide_histo=div(h3("Objectifs"),
                  p(paste("Dans ce menu, il est possible de r�aliser un premier rendu sous forme d'histogrammes des taux d'�voultion du trait de c�te.")),
				  h3("Entr�es :"),
				  p("Commencez par actualiser le menu et pensez � actualiser les noms des fichiers si ils ont �t� modifi�s."),
				  h4("Choisir les fichiers de l'�volution (-MobiTC.txt)"),
				  p("Choisir le ou les fichiers sur lesquels seront bas�s le calcul des histogrammes. Pour �diter les rapports finaux il faut choisir les 4 fichiers r�alis�s � l'�tape pr�c�dente."),
				  p(span(style="color:green","Valeur du Tuto : choisir les 4 fichiers -MobiTC.txt.")),
				  h4("Largeur en m�tre des histogrammes"),
				  p("Donner la largeur en m�tre des histogrammes, ne pas mettre plus que l'espacement entre les traces."),
				  p(span(style="color:green","Valeur du Tuto : 80")),
				  h4("Longueur en m�tre representant un taux de 1m/an"),
				  p("Etant donn� que la longueur de l'histogramme repr�sente un taux d'�volution exprim� en m/an, il faut une correspondance pour l'appliquer sur la carte."),
				  p(span(style="color:green","Valeur du Tuto : 50")),
				  h4("Taux en m/an � partir duquel les histogrammes sont de longueurs constantes"),
				  p("Il peut �tre interessant de tronquer les histogrammes � partir d'un certain taux d'�voultion. Une fl�che au bout de l'histogramme mat�rialise les histogrammes tronqu�s"),
				  p(span(style="color:green","Valeur du Tuto : 10")),
				  h4("Choisir le type de taux"),
				  p("Plusieurs lois statistiques sont utilis�s, il s'agit de choisir laquelle r�pr�sent�e."),
				  p(span(style="color:green","Valeur du Tuto : WLS")),
				  h3("Sorties :"),
				  p("A l'issue de cette �tape, des fichiers shp r�pr�sentant des histogrammes sont cr��s dans le r�pertoire de travail."),
				  p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1-toutesdates-histo-WLS.shp")),
				p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1-post1950-histo-WLS.shp")),
				p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1-post2000-histo-WLS.shp")),
				p(span(style="color:green","Valeur Tuto : 20200623T105932-Tuto-Env-C010-T1000-Sque-C001_lierR_simpl-Tra-P100-L1000-IntersTDC-v1-post2010-histo-WLS.shp"))
				  )
					  
  aide_rapport=div(h3("Objectifs"),
                      p(paste("Dans ce menu, des rapports html r�sumant l'ensemble des calculs men�s sont �dit�s")),
					  h3("Entr�es :"),
				  p("Commencez par actualiser le menu et pensez � actualiser les noms des fichiers si ils ont �t� modifi�s."),
				  h4("Exporter les rapports complets par trace"),
					   h3("Sorties :"),
				  p("A l'issue de cette �tape, un r�pertoire Rapport est cr�� dans le r�pertoire de travail. Il contient tous les rapports html"),
				  p("le fichier trace a �t� mis � jour pour ne contenir que les traces pour lesquelles un rapport a �t� �dit�."),
				  p("Attention BUG : il faut lancer ce menu 2 fois pour que la palette de couleurs des histogrammes s'impl�mentent.")				  
					  )				  
  

  
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