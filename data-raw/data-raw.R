library(readr)
data_geo_lines_map <- read_csv("data-raw/sample_geo_lines.csv")

data_geo_lines_map <- data_geo_lines_map %>%
  mutate(journey = paste(sender.longitude, sender.latitude, sender.longitude, sender.latitude)) %>%
  group_by(journey) %>% # unique journeys
  mutate(number.of.letters = n()) %>%
  ungroup() %>%
  distinct()

save(data_geo_lines_map,
     file = "data/data_geo_lines_map.rdata")

