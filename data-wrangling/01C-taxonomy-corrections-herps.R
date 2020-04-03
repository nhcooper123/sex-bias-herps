# Taxonomy correction script
# These are the names that are not correct
# Some are simple changes/errors/typos
#--------------------------------------------------------

ds3 <- ds2 %>%
  
#------------------------------------------------------------------
# AMPHIBIANS
# Correcting taxonomy/spellings/typos
# Checked against Frost taxonomy
# Where I coudn't find the species I replaced it with NA_character_
# and it will drop out of the analysis
#-------------------------------------------------------------------
  mutate(binomial = str_replace(binomial, 'Philautus williamsii', 'Philautus surdus')) %>%
  mutate(binomial = str_replace(binomial, 'Hyla freycineti', 'Litoria freycineti')) %>%
  mutate(binomial = str_replace(binomial, 'Rana johnstoni', 'Amietia johnstoni')) %>%
  mutate(binomial = str_replace(binomial, 'Hyla lateralis', 'Hyla cinerea')) %>%
  mutate(binomial = str_replace(binomial, 'Hyla stadelmanni', 'Tlalocohyla loquax')) %>%
  mutate(binomial = str_replace(binomial, 'Pipa americana', 'Pipa pipa')) %>%
  mutate(binomial = str_replace(binomial, 'Rana macrognathus', 'Limnonectes macrognathus')) %>%  
  mutate(binomial = str_replace(binomial, 'Pelophylax kl', NA_character_)) %>%
  
  # Fix family names
  mutate(family = case_when(genus == "Dicamptodon"  
                            ~ "Dicamptodontidae",
                            genus == "Allobates" |
                            genus == "Anomaloglossus" |
                            genus == "Aromobates" |
                            genus == "Mannophryne" |
                            genus == "Rheobates" |
                            ~ "Dendrobatidae",
                            genus == "Boulengerula" |
                            genus == "Herpele"
                            ~ "Herpelidae",
                            genus == "Gegeneophis" |
                            genus == "Grandisonia" |
                            genus == "Hypogeophis" |  
                            genus == "Idiocranium" |
                            genus == "Indotyphlus" |
                            genus == "Praslinia" |
                            genus == "Sylvacaecilia"
                            ~ "Indotyphlidae",
                            genus == "Geotrypetes" |
                            genus == "Gymnopis"
                            ~ "Dermophiidae",
                            genus == "Microcaecilia" |
                            genus == "Parvicaecilia" |
                            genus == "Brasilotyphlus" |
                            genus == "Siphonops"
                            ~ "Siphonopidae",
                            genus == "Schistometopum"
                            ~ "Dermophiidae",
                            genus == "Typhlonectes" |
                              genus == "Nectocaecilia" |
                              genus == "Chthonerpeton" 
                            ~ "Typhlonectidae",
                            genus == "Scolecomorphus" |
                            genus == "Crotaphatrema" 
                            ~ "Scolecomorphidae",
                            genus == "Allophryne" 
                            ~ "Allophrynidae",
                            genus == "Atelognathus" |
                            genus == "Batrachyla"  |
                            genus == "Hylorina"  
                            ~ "Batrachylidae",
                            genus == "Telmatobius"  
                            ~ "Telmatobiidae",
                            genus == "Alsodes"  |
                            genus == "Limnomedusa" |
                            genus == "Eupsophus"
                            ~ "Alsodidae",
                            genus == "Insuetophrynus"  
                            ~ "Rhinodermatidae",
                            genus == "Rhinoderma"  
                            ~ "Rhinodermatidae",
                            genus == "Ascaphus"  
                            ~ "Ascaphidae",
                            genus == "Macrogenioglottus"  |
                            genus == "Odontophrynus" |
                            genus == "Proceratophrys"
                            ~ "Odontophrynidae",
                            genus == "Crossodactylodes"  |
                            genus == "Rupirana" |
                            genus == "Edalorhina" |
                            genus == "Engystomops"  |
                            genus == "Eupemphix" |
                            genus == "Physalaemus" |
                            genus == "Pleurodema"  |
                            genus == "Pseudopaludicola" |
                            genus == "Somuncuria" 
                            ~ "Leptodactylidae",
                            genus == "Adelotus"  |
                            genus == "Heleioporus" |
                            genus == "Lechriodus" |
                            genus == "Limnodynastes"  |
                            genus == "Neobatrachus" |
                            genus == "Notaden" |
                            genus == "Philoria"  |
                            genus == "Platyplectrum"
                            ~ "Myobatrachidae",
                            genus == "Conraua"
                            ~ "Conrauidae",
                            genus == "Ericabatrachus"
                            ~ "Petropedetidae",
                            genus == "Amietia"
                            ~ "Pyxicephalidae",
                            genus == "Limnonectes"
                            ~ "Dicroglossidae",
                            genus == "Pithecopus"
                            ~ "Hylidae",
                            TRUE ~ as.character(family))) %>%
#------------------------------------------------------------------------------------------------ 
# REPTILES
# Correcting taxonomy/spellings/typos
# Checked against Uetz taxonomy
# Where I coudn't find the species I replaced it with NA_character_
# and it will drop out of the analysis
#-------------------------------------------------------------------------------------------------  
mutate(binomial = str_replace(binomial, "Acanthophis antarticus", "Acanthophis antarcticus")) %>%
mutate(binomial = str_replace(binomial, "Ameiva desechensis", "Pholidoscelis exsul")) %>%
mutate(binomial = str_replace(binomial, "Ameiva undulata", "Holcosus undulatus")) %>%
mutate(binomial = str_replace(binomial, "Anolis wattsii", "Anolis wattsi")) %>%
mutate(binomial = str_replace(binomial, "Arrhyton exiguum", "Magliophis exiguum")) %>%
mutate(binomial = str_replace(binomial, "Bothrops bilineata", "Bothrops bilineatus")) %>%
mutate(binomial = str_replace(binomial, "Chamaeleo basilicus", "Chamaeleo africanus ")) %>%
mutate(binomial = str_replace(binomial, "Chamaeleo cephalolepis", "Furcifer cephalolepis ")) %>%
mutate(binomial = str_replace(binomial, "Chamaeleo fischeri", "Kinyongia fischeri")) %>%
mutate(binomial = str_replace(binomial, "Chamaeleo willsi", "Furcifer willsii")) %>%
mutate(binomial = str_replace(binomial, "Cuora evelynae", "Cuora flavomarginata")) %>%
mutate(binomial = str_replace(binomial, "Cylindraspis inepta", "Aldabrachelys gigantea")) %>%
mutate(binomial = str_replace(binomial, "Cylindraspis triserrata", "Aldabrachelys gigantea")) %>%
mutate(binomial = str_replace(binomial, "Dinodon rufozonatum", "Lycodon rufozonatus")) %>%
mutate(binomial = str_replace(binomial, "Elaphe longissima", "Zamenis longissimus")) %>%
mutate(binomial = str_replace(binomial, "Enhydrina schistosa", "Hydrophis schistosus")) %>%
mutate(binomial = str_replace(binomial, "Enhydris chinensis", "Myrrophis chinensis")) %>%
mutate(binomial = str_replace(binomial, "Enhydris plumbea", "Hypsiscopus plumbea")) %>%
mutate(binomial = str_replace(binomial, "Hemidactylus haitianus", "Hemidactylus angulatus")) %>%
mutate(binomial = str_replace(binomial, "Leposoma dispar", "Loxopholis rugiceps")) %>%
mutate(binomial = str_replace(binomial, "Microcephalophis gracilis", "Hydrophis gracilis")) %>%
mutate(binomial = str_replace(binomial, "Neusticurus cochranae", "Gelanesaurus cochranae")) %>%
mutate(binomial = str_replace(binomial, "Panaspis wahlbergii", "Panaspis wahlbergi")) %>%
mutate(binomial = str_replace(binomial, "Pelamis platura", "Hydrophis platurus")) %>%
mutate(binomial = str_replace(binomial, "Phrynonax sexcarinatus", "Chironius quadricarinatus")) %>%
mutate(binomial = str_replace(binomial, "Pseustes sulphureus", "Spilotes sulphureus")) %>%
mutate(binomial = str_replace(binomial, "Python reticulatus", "Malayopython reticulatus")) %>%
mutate(binomial = str_replace(binomial, "Ramphotyphlops braminus", "Indotyphlops braminus")) %>%
mutate(binomial = str_replace(binomial, "Rhamphiophis togoensis", "Psammophylax togoensis")) %>%
mutate(binomial = str_replace(binomial, "Tenuidactylus kohsulaimanai", "Cyrtopodion kohsulaimanai")) %>%
mutate(binomial = str_replace(binomial, "Testudo cyrenaica", "Testudo graeca")) %>%
mutate(binomial = str_replace(binomial, "Trimeresurus mucrosquamatus", "Protobothrops mucrosquamatus")) %>%
mutate(binomial = str_replace(binomial, "Typhlops geotomus", "Antillotyphlops geotomus")) %>%
mutate(binomial = str_replace(binomial, "Uta antiquus", "Uta stansburiana")) %>%
mutate(binomial = str_replace(binomial, "Vipera nikolskii", "Vipera berus")) %>%
mutate(binomial = str_replace(binomial, "Waglerophis merremi", "Xenodon merremii")) %>%

  

  
  
  
  
    
# Fix family names
mutate(family = case_when(genus == "Anniella"  
                          ~ "Anguidae",
                          binomial == "Bolyeria multocarinata" |
                          binomial == "Casarea dussumieri"
                          ~ "Bolyeriidae",
                          genus == "Cyclocorus" 
                          ~ "Lamprophiidae",
                          binomial == "Poecilopholis cameronensis" 
                          ~ "Atractaspididae",
                          genus == "Xylophis" 
                          ~ "Pareidae",
                          genus == "Alopoglossus" 
                          ~ "Alopoglossidae",
                          genus == "Alluaudina" 
                          ~ "Pseudoxyrhophiidae",
                          genus == "Prosymna" 
                          ~ "Prosymnidae",
                          genus == "Psammodynastes" 
                          ~ "Pseudaspididae",
                          genus == "Psammophis" 
                          ~ "Psammophiidae",
                          genus == "Psammophylax" 
                          ~ "Psammophiidae",
                          genus == "Pseudaspis" 
                          ~ "Pseudaspididae",
                          genus == "Pseudoxyrhopus" 
                          ~ "Pseudoxyrhophiidae",
                          genus == "Pythonodipsas" 
                          ~ "Pseudaspididae",
                          genus == "Rhamphiophis" 
                          ~ "Psammophiidae",
                          genus == "Thamnosophis" 
                          ~ "Pseudoxyrhophiidae",
                          genus == "Xenocalamus" 
                          ~ "Atractaspididae",
                          TRUE ~ as.character(family))) %>%

  mutate(family = str_replace(family, "Dipsadidae", "Colubridae")) %>%
  mutate(family = str_replace(family, "Natricidae", "Colubridae")) %>%
  mutate(family = str_replace(family, "Pseudoxenodontidae", "Colubridae")) %>%
  mutate(family = str_replace(family, "Pareatidae", "Pareidae")) %>%
  mutate(family = str_replace(family, "Xenodermatidae", "Xenodermidae"))