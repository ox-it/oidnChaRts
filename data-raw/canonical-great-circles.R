library("tidyverse")
library("sf")


## =========== Basic example
sf = st_sf(a=1, geom=st_sfc(st_linestring(rbind(c(0,0),c(1,1)))), crs = 4326)
seg = st_segmentize(sf, units::set_units(100, km))

my_locations <- tribble(
  ~long, ~lat,
  -1.2599604, 51.7567909,
  -119.5155058, 34.3869745
)


my_linestring <- st_sf(geom = st_sfc(st_linestring(rbind(
  c(-1.2599604, 51.7567909), c(-119.5155058, 34.3869745)
)), crs = st_crs(shp_all_us_states)))

st_segmentize(my_linestring, units::set_units(100, km))


leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = my_locations) %>%
  addPolylines(data = st_segmentize(my_linestring, units::set_units(100, km)))

many_linestrings <- st_sf(geom = st_sfc(st_linestring(rbind(
  c(-1.2599604, 51.7567909), c(-119.5155058, 34.3869745),
  c(40, 40), c(10,10)
)), crs = st_crs(shp_all_us_states)))

## =========== Create one multilinestring

start_and_end_locs <- tribble(
  ~start.long, ~start.lat, ~end.long, ~end.lat,
  -1.2599604, 51.7567909, 10, 10,
  -119.5155058, 34.3869745, 40, 40
)

start_locs <- start_and_end_locs %>%
  select(contains("start")) %>%
  rename(long = start.long,
         lat = start.lat) %>%
  as.matrix()

end_locs <- start_and_end_locs %>%
  select(contains("end")) %>%
  rename(long = end.long,
         lat = end.lat) %>%
  as.matrix()

## This draws the straight lines
st_multilinestring(list(start_locs, end_locs)) %>%
  leaflet() %>%
  addPolylines()

## Try to make curved lines!

my_multilinestring <- st_sf(geom = st_sfc(st_multilinestring(list(start_locs, end_locs))),
      crs = st_crs(shp_all_us_states))

st_segmentize(my_multilinestring, units::set_units(100, km)) %>%
  leaflet() %>%
  addTiles() %>%
  addPolylines()

## =========== Create an sf tibble (when only TWO sets of points...)


journey_data <- tribble(
  ~start.long, ~start.lat, ~end.long, ~end.lat, ~year, ~name,
  -1.2599604, 51.7567909, 10, 10, 1999, "George",
  -119.5155058, 34.3869745, 40, 40, 2000, "Jo"
)

start_locs <- journey_data %>%
  select(contains("start")) %>%
  rename(long = start.long,
         lat = start.lat) %>%
  as.matrix()

end_locs <- journey_data %>%
  select(contains("end")) %>%
  rename(long = end.long,
         lat = end.lat) %>%
  as.matrix()


my_multilinestring <- st_sf(geom = st_sfc(st_multilinestring(list(start_locs, end_locs))),
                            crs = st_crs(shp_all_us_states))


raw_linestrings <- st_sfc(st_multilinestring(list(start_locs, end_locs)), crs = st_crs(shp_all_us_states)) %>%
  st_cast("LINESTRING")

st_geometry(journey_data) <- raw_linestrings

journey_data <- st_set_crs(journey_data, st_crs(shp_all_us_states))


journey_data %>%
  st_segmentize(units::set_units(100, km)) %>%
  leaflet() %>%
  addTiles() %>%
  addPolylines()


## =========== Create an sf tibble (for unlimited points...)


journey_data <- tribble(
  ~start.long, ~start.lat, ~end.long, ~end.lat, ~year, ~name,
  -1.2599604, 51.7567909, 10, 10, 1999, "George",
  -119.5155058, 34.3869745, 40, 40, 2000, "Jo",
  -130, 40, 15, 20, 2001, "Charlie"
)

start_locs <- journey_data %>%
  select(contains("start")) %>%
  rename(long = start.long,
         lat = start.lat) %>%
  mutate(journey.id = row_number())

end_locs <- journey_data %>%
  select(contains("end")) %>%
  rename(long = end.long,
         lat = end.lat) %>%
  mutate(journey.id = row_number())

df_with_linestrings <- start_locs %>%
  bind_rows(end_locs) %>%
  sf::st_as_sf(coords = c("long","lat")) %>%
  group_by(journey.id) %>%
  arrange(journey.id) %>%
  summarise() %>%
  sf::st_cast("LINESTRING")

st_geometry(df_with_linestrings)

st_geometry(journey_data) <- st_geometry(df_with_linestrings)

journey_data <- st_set_crs(journey_data, st_crs(shp_all_us_states))

journey_data %>%
  st_segmentize(units::set_units(100, km)) %>%
  leaflet() %>%
  addTiles() %>%
  addPolylines()
