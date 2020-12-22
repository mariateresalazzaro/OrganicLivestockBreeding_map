setwd("C:/Users/mariateresa.lazzaro/data_pc_only_Teresa/ENGAGEMENT_BIOBREED_pc_only/01 MAPPING Plant Breeding Initiatives/OrganicLivestockBreeding_map_R/")

#Call the libraries
library(leaflet)
library(sp)
library(rgdal)
library(RColorBrewer)
library(leaflet.extras)
library(leaflet.minicharts)
library(htmlwidgets)
library(raster)
library(mapview)
library(leafem)
library(leafpop)
library(sf)
library(htmltools)
library(dplyr)


## PART 1 - IN THIS PART THE CODE READS THE FILES AND ATTRIBUTES COLORS AND ICONS TO ELEMENTS

## Read the csv
data<-read.delim("OrganicLivestockBreeding_MapEU.txt", header = T, fileEncoding = "UTF-8")

#html hyperlink
data <- data %>% 
  mutate(tag = paste0("Web Link: <a href=", link," target=_blank>",  link, "</a>"))


## Create a html popup all
content <- paste(sep = "<br/>",
                 paste0("<div class='leaflet-popup-scrolled' style='max-width:300px;max-height:400px'>"),
                 paste0("<b>", data$name),
                 paste0(data$tag),
                 paste0("Description:"),
                 paste0(data$info),
                 paste0("</div>"))



## PART 2 - IN THIS PART THE CODE ADDS ELEMENT ON THE MAP LIKE POLYGONS, POINTS AND IMAGES.

m <- leaflet() %>%
  ## Basemap
  addProviderTiles(providers$OpenStreetMap)  %>%
  
  ## Add a zoom reset button
  addResetMapButton() %>%
  ## Add a Minimap to better navigate the map
  addMiniMap() %>%
  ## Add a coordinates reader
  leafem::addMouseCoordinates() %>%
  ## define the view
  setView(lng = 3, 
          lat = 60, 
          zoom = 3 ) %>%
  

## Add Markers with clustering options
addAwesomeMarkers(data = data, 
                  lng = ~long,
                  lat = ~lat, 
                  popup = c(content), 
                  group = "All Organisations mapped",
                  options = popupOptions(maxWidth = 100, maxHeight = 150), 
                  clusterOptions = markerClusterOptions())%>%
  
  
  ## Add a legend with the credits
  addLegend("topright", 
            
            colors = c("trasparent"),
            labels=c("Organic Livestock Breeding Initiatives"),
            
            title="")%>%
  
  
  ## PART 3 - IN THIS PART THE CODE MANAGE THE LAYERS' SELECTOR
  
  ## Add the layer selector which allows you to navigate the possibilities offered by this map
  
  addLayersControl(baseGroups = c("All Organisations mapped",
                                  "Empty layer"),
                   
                   #overlayGroups = c("Number by Country"),
                   
                   options = layersControlOptions(collapsed = F)) %>%
  
  ## Hide the layers that the users can choose as they like
  hideGroup(c("Empty"))

## Show the map  
m

