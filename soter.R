

## Charger les librairies necessaires 

library(leaflet)
library(RColorBrewer)
library(tidyverse)
final<-read_csv2("C:/Users/pc/Desktop/memoire de fin d'etude/donnees soter.csv")

##Nettoyage du fichier importer
final<-final%>%dplyr::filter(!is.na(LNGI),!is.na(LATI),!is.na(total_carbone))

## Transformation pour obtenir donnee spatial 

coordinates(final)<-~LNGI+LATI

# Modifier la projection

proj4string(final)<-crs("+init=epsg:4326")
##Map of senegal with data_set overlayed
## Construction du popup
pas<-paste0("<strong>Profile:</strong>",final$PRID,"<br>\n <strong>Carbone Total:</strong>",round(final$total_carbone,3),"<br> \n <strong> Azote Total</stong>",round(final$total_azote,3),"<br>\n<strong>Capacite d'echange:</strong>",round(final$CECS,3),"<br>\n<strong>Epaisseur : </stong>",round(final$epais_hor,3),"<br>\n<strong>Munselle:</strong>",
            final$Munshell_col_hud)

## Construire la rampe de couleur

pal1 <- colorQuantile("YlOrBr", domain = final$OC)

## leaflet propement dit

leaflet() %>%
  addProviderTiles("Esri.WorldImagery") %>%
  addCircleMarkers(data = final, color = ~pal1(total_carbone),
                   popup = pas) %>%
  addLegend("bottomright", pal = pal1,
            values = final$total_carbone, title = "Soil Organic Carbon (%) quantiles",
            opacity = 0.8)
