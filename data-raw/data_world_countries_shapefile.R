## Obtained maps from http://www.naturalearthdata.com/downloads/50m-cultural-vectors/
# download.file(url = "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
#               destfile = "data-raw/world-shape-files.zip")
# unzip("data-raw/world-shape-files.zip", exdir = "data-raw/world-shape-files")

library("GISTools")
library("rgdal")
library("tidyverse")

## Load shapefiles
world_shapefiles <- readOGR(
  dsn = "data-raw/world-shape-files/",
  layer = "ne_50m_admin_0_countries",
  verbose = F
)

## coerce to tidyverse for cleaning
world_shpfiles_data <- as_data_frame(world_shapefiles@data)

world_shpfiles_data <- world_shpfiles_data %>%
  mutate_if(is.factor, as.character) %>% # remove factors
  select(name, name_long, type, continent, region_un, subregion, 
         sovereignt,subunit, postal)

world_shpfiles_data %>% colnames()

world_shapefiles$postal

## Update! 
world_shapefiles@data <- as.data.frame(world_shpfiles_data, stringsAsFactors = FALSE)

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






