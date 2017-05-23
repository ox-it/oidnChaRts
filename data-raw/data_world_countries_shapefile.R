## Obtained maps from http://www.naturalearthdata.com/downloads/50m-cultural-vectors/
# download.file(url = "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
#               destfile = "data-raw/world-shape-files.zip")
# unzip("data-raw/world-shape-files.zip", exdir = "data-raw/world-shape-files")

# library("GISTools")
# library("rgdal")
library("sf")
library("tidyverse")

## Load shapefiles
world_shapefiles <- st_read("data-raw/world-shape-files/")

world_shapefiles <- world_shapefiles %>%
  mutate_if(is.factor, as.character) %>%
  select(name, name_long, type, continent, region_un, subregion, 
         sovereignt,subunit, postal)

## Test visualisation
library(leaflet)
world_shapefiles %>%
leaflet() %>%
  addTiles() %>%
  addPolygons()

## Let's get just Asia!
# asia_polygons <- world_shapefiles[world_shapefiles$continent %in% c("Asia"), ]
# asia_polygons %>%
#   leaflet() %>%
#   addTiles() %>%
#   addPolygons()

# Export the SpatialPolygonsDataFrame object for use
data_world_shapefiles <- world_shapefiles

save(data_world_shapefiles, file = "data/data_world_shapefiles.rdata")






