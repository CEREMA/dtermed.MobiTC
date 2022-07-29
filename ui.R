# MOBITC

###########################
#reopen with encoding utf8#
###########################
options(encoding = "UTF-8")

dirr=R.home()
chem_mobitc=paste(dirr,"/Cerema/MOBITC",sep="")

if(!require(shiny)){install.packages("shiny")}
library(shiny)
if(!require(leaflet)){install.packages("leaflet")}
library(leaflet)

chemsource=paste(chem_mobitc,"/Sous_Routine_MOBITC/MOBITC_Aide.R",sep="")
source(chemsource)
aide=MOBITC_Aide(chem_mobitc)

shinyUI(
	fluidPage(
		titlePanel(
			fluidRow(
		column(9, "MobiTC - Mobilité du Trait de Côte"), 
		column(3, img(height = 60, width = 200, src = "Bloc-marque RF Cerema horizontal.jpg", type="image/jpg"))
			)),
  navbarPage(title = "",#"MobiTC",
########### MENU ACCUEIL##########
  tabPanel(title="Présentation",
      mainPanel(aide$aide_pres)),

########### MENU INITIALISATION ##################"
  navbarMenu(title = "Initialisation",
           tabPanel(title="Packages",
                    headerPanel("Installation des packages R"),
                    sidebarPanel(
                      actionButton("pack", "Lancer")
                    ),
                    mainPanel(
                      tabsetPanel(
                        tabPanel("Aide", icon=icon("info-circle"),aide$aide_pack)),
                        tabPanel("Résultats",icon=icon("align-justify"),textOutput("textpack"))
                    )	
           ),	#fin tabPanel(title="Répertoire",           
		tabPanel(title="Répertoire",
			headerPanel("Initialisation des répertoires de travail"),
			sidebarPanel(
				textInput(inputId="chemin_rep_travail", "Chemin du répertoire de travail", value = ""),
				textInput(inputId="nom_projet", "Nom du projet", value = ""),
				actionButton("rep", "Lancer")
				),
			mainPanel(
			  tabsetPanel(
			    tabPanel("Aide", icon=icon("info-circle"),aide$aide_init)),
			    tabPanel("Résultats",icon=icon("align-justify"),textOutput("textrep"))
		  )	
		),	#fin tabPanel(title="Répertoire",
		# 		tabPanel(title="Fournisseur TDC",
		# 			headerPanel("Liste des fournisseurs de traits de côte"),
		# 			sidebarPanel(
		# 				actionButton("voirF", "voir la liste"),
		# 				textInput(inputId = "NCF",
		#                     label = "Nom court",
		#                     value = ""),
		# 				textInput(inputId = "NLF",
		#                     label = "Nom long",
		#                     value = ""),
		# 				actionButton("rajoutF", "insérer")
		# 				),
		# 			mainPanel(
		# 			  tabsetPanel(
		# 			    tabPanel("Résultats",icon=icon("table"),tableOutput("tabF")),
		# 			    tabPanel("Aide", icon=icon("info-circle"),aide$aide_fourn)
		# 			  ))
		# 		),#fin tabPanel(title="Fournisseur TDC",
  		tabPanel(title="Marqueur TDC",
  			headerPanel("Liste des marqueurs du trait de côte"),
  			sidebarPanel(
  				actionButton("voirL", "voir la liste")
  				),
  			mainPanel(
  			  tabsetPanel(
  			    tabPanel("Aide", icon=icon("info-circle"),aide$aide_liste_tdc),
  			    tabPanel("Résultats",icon=icon("table"),span(tableOutput("tabL"))) #,style="color: #A7FC00"
  			   
  				))
  		), #fin tabPanel(title="Marqueur TDC",
		tabPanel(title = "Mise en forme des tdc",
      headerPanel("Mise en forme des tdc"),
      sidebarPanel(
        #actionButton("voirL", "voir la liste")
      ),
      mainPanel(
        tabsetPanel(
         # tabPanel("Résultats",icon=icon("table")),
          tabPanel("Aide", icon=icon("info-circle"),aide$aide_miseenforme_tdc)
        ))
  # 		mainPanel(
  # 					  fileInput(inputId="fichier_tdc_i", "Choisir un trait de côte en .shp", multiple = TRUE,accept=".shp"),
  # 					  #dateInput(inputId="date_tdc_1", "Date du trait de cÃ´te"),
  # 					  textInput(inputId = "AAAA1",label = "Année 1",value=""),
  #                       actionButton("form", "Lancer")
  # 					  )
     ) # fin tabPanel(title = "Mise en forme des tdc",
		), #fin navbarMenu(title = "Initialisation",
#############""MENU ENVELOPPE###############"
    tabPanel(title = "Enveloppe",
		headerPanel("Création de l'enveloppe qui comprend tous les traits de côte"),
        sidebarPanel(
			       uiOutput("actu_menu_env"),
			       uiOutput("actu_fich_travail_env"),
			       uiOutput("actu_nom_projet_env"),
             numericInput(inputId = "distcoup",
                          label = "Distance de coupure des tdc",
                          value = 10, min = 5, max = 1000 , step=5),
             numericInput(inputId = "disttri",
                           label = "Longueur max des triangles à garder (m)",
                           value = 250, min = 5, max = 5000 , step=5),
             checkboxInput(inputId="export_tri", "Export des triangles de l'enveloppe (hors fonction)", value = FALSE),
			 fileInput(inputId="fichier_tdc_env", "Choisir les fichiers des tdc", multiple = TRUE,accept=".shp"),
             actionButton("env", "Lancer")
		),
		mainPanel(
		  tabsetPanel(
		    tabPanel("Aide", icon=icon("info-circle"),aide$aide_env),
		    tabPanel("Résultats",icon=icon("map"),textOutput("textenv"),leafletOutput("mapenv"))
		    
			)
		)
    ), #fin tabPanel(title = "Enveloppe",
#############MENU LIGNE DE BASE############"
    navbarMenu(title = "Ligne de base",
               tabPanel(title="Coupure de l'enveloppe",
                        headerPanel("Coupure de l'enveloppe"),
                        sidebarPanel(
                          uiOutput("actu_menu_sque_coup"),
                          uiOutput("actu_fich_travail_sque_coup"),
                          uiOutput("actu_fich_env_sque_coup"),
                          numericInput(inputId = "distcoupsque",
                                       label = "Distance de coupure de l'enveloppe",
                                       value = 1, min = 1, max = 250 , step=1),
                          actionButton("sque_coup", "Lancer")
                        ),
                        mainPanel(
                          tabsetPanel(
                            tabPanel("Aide", icon=icon("info-circle"),aide$aide_sque_coup)
                            #tabPanel("Résultats",icon=icon("map"),texte_sque_coup)
                          )
                        )
               ),# fin tabPanel(title="Coupure de l'enveloppe",         
			tabPanel(title="Création du squelette",
				headerPanel("Création du squelette de l'enveloppe"),
				sidebarPanel(
					uiOutput("actu_menu_sque"),
					uiOutput("actu_fich_travail_sque"),
					textInput(inputId="fichier_voro", "Nom du fichier du voronoi réalisé dans Qgis (sans l'extension)", value = "voronoi"),
					actionButton("sque", "Lancer")
					),
				mainPanel(
				  tabsetPanel(
				    tabPanel("Aide", icon=icon("info-circle"),aide$aide_sque_voro),
				    tabPanel("Résultats",icon=icon("map"),textOutput("textsque"),leafletOutput("mapsque"))
				    
					)
				)
			),# fin tabPanel(title="Création du squelette",
			
			tabPanel(title="Raccordement du squelette",
				headerPanel("Raccordement des morceaux de squelette proches"),
				sidebarPanel(
					fileInput(inputId="fichier_sque_rac", "Choisir le fichier du squelette", multiple = FALSE,accept="mif"),
					numericInput(inputId = "distrac",
							  label = "Distance de raccordement en mètre",
							  value = 500, min = 1, max = 5000, step=1),
					actionButton("squerac", "Lancer")
				),
				mainPanel(
				  tabsetPanel(
				    tabPanel("Aide", icon=icon("info-circle"),aide$aide_squerac),
				    tabPanel("Résultats",icon=icon("map"),textOutput("textsquerac"),leafletOutput("mapsquerac"))
				    
				  )
				)
			), #fin tabPanel(title="Raccordement du squelette",
			
			tabPanel(title="Orientation du squelette",
				headerPanel("Orientation des axes du squelette"),
# 				sidebarPanel(
# 					p("Reperez au prealable dans qgis les axes pas correctement orientés"),
# 					fileInput(inputId="fichier_sque2", "Choisir le fichier du squelette", multiple = FALSE,accept="mif"),
# 					textInput(inputId = "axesens",
#                         label = "Axes du squelette a changer de sens (par ex 1;3;7)",
#                         value = ""),
# 					actionButton("squeorr", "Lancer")
# 					),
				mainPanel(
				  tabsetPanel(
				    tabPanel("Aide", icon=icon("info-circle"),aide$aide_squeorr)
				    #tabPanel("Résultats",icon=icon("map"),textOutput("textsqueorr"),plotOutput("mapsqueorr"))
				    
					)
				)
        ), # fin tabPanel(title="Orientation du squelette",
			  tabPanel(title="Lissage du squelette",
				headerPanel("Lissage du squelette"),
				# sidebarPanel(
				# 	actionButton("squelisse", "Lancer")
				# 	),
				mainPanel(
				  tabsetPanel(
				     tabPanel("Aide", icon=icon("info-circle"),aide$aide_squelisse)#,
				    #tabPanel("Résultats",icon=icon("map"),textOutput("textsquelisse"),plotOutput("mapsquelisse"))
				   
				  )
				)
			) # fin tabPanel(title="Lissage du squelette",
    ),# fin navbarMenu(title = "Ligne de base",

###########MENU TRACES############
    navbarMenu(title = "Traces",
        tabPanel(title="Création des traces",
				headerPanel("Création des traces perpendiculaires à la ligne de base"),
				sidebarPanel(
						uiOutput("actu_menu_trace"),
						uiOutput("actu_fich_travail_tr"),
						uiOutput("actu_fich_sque_tr"),
						numericInput(inputId = "disttrace",
                                    label = "Distance entre les traces",
                                    value = 200, min = 0, max = 1000 , step=50),
						numericInput(inputId = "longtrace",
                                    label = "Longeur des traces (+/- m)",
                                    value = 200, min = 0, max = 1000 , step=50),
						actionButton("trace", "Lancer")
                    ),
				mainPanel(
				  tabsetPanel(
				    tabPanel("Aide", icon=icon("info-circle"),aide$aide_trace),
				    tabPanel("Résultats",icon=icon("map"),textOutput("texttrace"),leafletOutput("maptrace"))
				  )
				)
			), #fin tabPanel(title="Création des traces",
			
        tabPanel(title="Lissage des traces",
				headerPanel("Lissage des traces pour éviter leur croisement"),
				sidebarPanel(
                       uiOutput("actu_menu_trace_lisse"),
                       uiOutput("actu_fich_travail_tr_lisse"),
                       uiOutput("actu_fich_trace_tr_lisse"),
					   #fileInput(inputId="fichier_trace", "Choisir le fichier des traces", multiple = FALSE,accept="mif"),
					selectInput(inputId="gauss", "Choisir le filtre pour le lissage",c("Filtre 1"="1","Filtre 3"="3","Filtre 9"="9","Filtre 25"="25"),
							selected = NULL, multiple = FALSE,selectize = FALSE,  size = 3),
                    actionButton("tracelisse", "Lancer")
					),
				mainPanel(
				  tabsetPanel(
				    tabPanel("Aide", icon=icon("info-circle"),aide$aide_tracelisse),
				    tabPanel("Résultats",icon=icon("map"),textOutput("texttracelisse"),leafletOutput("maptracelisse"))
				  )
				)
        ) # fin tabPanel(title="Lissage des traces",
    ), #fin  navbarMenu(title = "Traces",

#############MENU INTERSECTIONS##########

    navbarMenu(title="Intersections",
			tabPanel(title="ponctuelles",
				headerPanel("Intersections des tdc avec les traces - calcul ponctuel"),
				sidebarPanel(
					uiOutput("actu_menu_interponc"),
					uiOutput("actu_fich_travail_ip"),
					uiOutput("actu_fich_env_ip"),
					uiOutput("actu_fich_sque_ip"),
					uiOutput("actu_fich_trace_ip"),
					# fileInput(inputId="fichier_tracef1", "Choisir le fichier des traces", multiple = FALSE),
					# fileInput(inputId="fichier_tdc2", "Choisir les fichiers tdc", multiple = TRUE),
					radioButtons(inputId="methode_ip", "Methode de calcul",c("le plus au large"="methodelarge","le plus a la côte"="methodecote")),
					radioButtons(inputId="methode_ip_lim","Type de marqueurs",c("choix manuel"="marqmanu","choix auto sur le plus fréquent"="marqauto"),selected="marqauto"),
					fileInput(inputId="fichier_tdc_ip", "Choisir les fichiers des tdc", multiple = TRUE,accept=".shp"),
					actionButton("interponc", "Lancer")
				),
				mainPanel(
				  tabsetPanel(
				      tabPanel("Aide", icon=icon("info-circle"),aide$aide_ip),
				    tabPanel("Résultats",icon=icon("table"),textOutput("textip"),tableOutput("tableip"))
				  
				  )
				)
			) #fin tabPanel(title="ponctuelles",
    ), # fin navbarMenu(title="Intersections",
			
			
# 			tabPanel(title="surfaciques",
# 				headerPanel("Intersections des tdc avec les traces - calcul surfacique"),
# 				sidebarPanel(
# 				fileInput(inputId="fichier_tracef2", "Choisir le fichier des traces", multiple = FALSE),
# 				fileInput(inputId="fichier_tdc3", "Choisir les fichiers tdc", multiple = TRUE),
# 				actionButton("intersurf", "Lancer")
# 				),
# 				mainPanel(
# 				  tabsetPanel(
# 				    tabPanel("Résultats",icon=icon("table"),textOutput("textintersurf"),tableOutput("textintersurf")), 
# 				    tabPanel("Aide", icon=icon("info-circle"),aide$aide_intersuf)
# 				  )
# 				)
# 			)

##########"MENU CALCUL EVOLUTION##########
navbarMenu(title="Evolution",
    tabPanel(title="Calcul évolution",
		headerPanel("Statistiques des évolutions"),
		sidebarPanel(
			 uiOutput("actu_menu_evol"),
			 uiOutput("actu_fich_travail_evol"),
			 uiOutput("actu_fich_trace_evol"),
			 uiOutput("actu_fich_intersection_evol"),
             textInput(inputId="produc", "Nom du producteur", value = "Cerema"),
             checkboxGroupInput(inputId="IC","Intervalles de confiance",c("IC 70%"="IC70","IC 90%"="IC90"), selected = NULL, inline = FALSE),
             numericInput(inputId = "datedebgraph",
                          label = "Date de debut des graphiques",
                          value = 1920, min = 1800, max = 2200 , step=10),
			 numericInput(inputId = "datefingraph",
                          label = "Date de fin des graphiques",
                          value = 2040, min = 1800, max = 2200 , step=10),
			 numericInput(inputId = "dateprosp1",
                          label = "Annee de l'extrapolation prospective 1",
                          value = 2050, min = 2020, max = 2200 , step=10),
			 numericInput(inputId = "dateprosp2",
			              label = "Annee de l'extrapolation prospective 2",
			              value = 2100, min = 2020, max = 2200 , step=10),
			 textInput(inputId="datedebevol", "Date de césure", value = "1980;2000"),
             actionButton("evol", "Lancer")
		),
		mainPanel(
		  tabsetPanel(
		    tabPanel("Aide", icon=icon("info-circle"),aide$aide_evol),
		    tabPanel("Résultats",icon=icon("table"),textOutput("textevol"),tableOutput("tableevol"))
		    
		  )
		)
    )# fin tabPanel(title="Calcul évolution",
), # fin navbarMenu(title="Evolution",

##########MENU EXPORT SIG #############
navbarMenu(title="Export SIG",
           tabPanel(title="Histogrammes",
                    headerPanel("Export SIG des taux calculés sous forme d'histogrammes"),
                    sidebarPanel(
                      uiOutput("actu_menu_histo"),
                      uiOutput("actu_fich_travail_histo"),
                      uiOutput("actu_fich_trace_histo"),
                      fileInput(inputId="fichier_evolution_hist", "Choisir les fichiers de l'évolution (-MobiTC.txt)", multiple = TRUE,accept="txt"),
                      #uiOutput("actu_fich_mobitc_histo"),
                      numericInput(inputId = "largeur_histo",
                                   label = "Largeur en mètre des histogrammes",
                                   value = 100, min = 1, max = 5000, step=1),
                      numericInput(inputId = "longueur_histo",
                                   label = "Longueur en mètre representant un taux de 1m/an",
                                   value = 100, min = 1, max = 5000, step=1),
                      numericInput(inputId = "tronqu_histo",
                                   label = "Taux en m/an à partir duquel les histogrammes sont de longueurs constantes",
                                   value = 10, min = 0.1, max = 5000, step=1),
                      selectInput(inputId="taux_histo", "Choisir le type de taux",c("EPR"="EPR","AOR"="AOR","OLS"="OLS","WLS"="WLS","RLS"="RLS","RWLS"="RWLS","JK"="JK","MDL"="MDL"),
                                  selected = "WLS", multiple = TRUE,selectize = FALSE,  size = 8),
                      actionButton("histo", "Lancer")
                    ),
                    mainPanel(
                      tabsetPanel(
                         tabPanel("Aide", icon=icon("info-circle"),aide$aide_histo),
                        tabPanel("Résultats",icon=icon("map"),textOutput("texthisto"),leafletOutput("maphisto"))
                       
                      )
                    )
           ) # fin 	tabPanel(title="Histogrammes",
), # fin navbarMenu(title="Export SIG",

##########"MENU Export Graph##########
navbarMenu(title="Export Graphiques",
tabPanel(title="Graph évolution WLS",
   headerPanel("Export des graphiques des évolutions WLS"),
   sidebarPanel(
     uiOutput("actu_menu_graph_wls"),
     uiOutput("actu_fich_travail_graph_wls"),
     uiOutput("actu_fich_sque_graph_wls"),
     uiOutput("actu_fich_trace_graph_wls"),
     uiOutput("actu_fich_intersection_graph_wls"),
     actionButton("export_graphb_wls", "Exporter les graphiques WLS par trace")
   ),
   mainPanel(
     tabsetPanel(
       tabPanel("Résultats",icon=icon("table"),textOutput("textexportgraph_wls")),
       tabPanel("Aide", icon=icon("info-circle"),aide$aide_graph_wls)
   )
   )
  )# fin tabPanel(title="Graph évolution",
),# navbarMenu(title="Export Graphiques",


##########"MENU Export Rapport html##########
  		tabPanel(title="Export Rapport html",
  		         headerPanel("Export de rapport sur l'évolution"),
  		         sidebarPanel(
  		           uiOutput("actu_menu_rapport"),
  		           uiOutput("actu_fich_travail_rapport"),
  		           uiOutput("actu_fich_sque_rapport"),
  		           uiOutput("actu_fich_trace_rapport"),
  		           uiOutput("actu_fich_intersection_rapport"),
  		           actionButton("export_rapport", "Exporter les rapports complets par trace")
  		         ),
  		         mainPanel(
  		           tabsetPanel(
  		             tabPanel("Aide", icon=icon("info-circle"),aide$aide_rapport),
  		             tabPanel("Résultats",icon=icon("table"),textOutput("textexportrapport"))
  		             
  		           ))
		) #fin tabPanel(title="Rapport évolution",


# # 	tabPanel(title="Graphiques",
# # 		headerPanel("Visualisation des graphiques par traces"),
# # 		sidebarPanel(
# #              a(href= "Aide MOBITC 1.htm",target="_blank","Afficher l'aide",fileEncoding="UTF-8"),
# #              br(),
# #              br(),
# # 			 uiOutput("actu_menu_graph"),
# # 			 uiOutput("actu_fich_travail_graph"),
# # 			 uiOutput("actu_fich_mobitc_graph"),
# # 			 uiOutput("choix_axe"),
# # 			 uiOutput("choix_trace"),
# # 			 uiOutput("choix_stat"),
# # 			 numericInput(inputId = "pas",
# #                           label = "Pas en annee de l'axe des dates",
# #                           value = 20, min = 0, max = 50 , step=0.5),
# # 			 actionButton("graph", "Lancer")
# # 			 ),
# # 		mainPanel(
# # 			#textOutput("textegraph"),
# # 			plotOutput("graphi")
# # 			 )
# # 		),


# 		
# 	tabPanel(title="Quitter",
# 		headerPanel("Quitter MobiTC"),
# 		         sidebarPanel(
# 		           actionButton("quit", "Quitter")
# 		         ),
# 		         mainPanel(
# 		           textOutput("Au revoir !")
# 		         )
#     )
# 
) #fin de navbar mobitc
) #fin de fluidpage
) #fin de shiny
