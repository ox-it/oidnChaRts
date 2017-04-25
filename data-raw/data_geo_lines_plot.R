## data_geo_lines_plot
## This dataset is based on data that will be published here: https://doi.org/10.6084/m9.figshare.4516772
## Geo lines plot are a natural fit for this data, as the dataset is comprised of "send"/"receive" geolocations.

library(tidyverse)

# data_geo_lines_plot %>%
#   select(-id.letter, -letter.series) %>% 
#   write_csv(path = "data-raw/german-letters.csv")

data_geo_lines_plot <- read_csv("data-raw/german-letters.csv")

data_geo_lines_plot <- data_geo_lines_plot %>%
  mutate(journey = paste(sender.longitude, sender.latitude, sender.longitude, sender.latitude)) %>%
  group_by(journey) %>% # unique journeys
  mutate(number.of.letters = n()) %>%
  ungroup() %>%
  distinct() %>%
  select(-sender.country, -receiver.country)

data_geo_lines_plot <- data_geo_lines_plot %>%
  rename_("start.location" = "sender.location",
         "start.latitude" = "sender.latitude",
         "start.longitude" = "sender.longitude",
         "end.location" = "receiver.location",
         "end.longitude" = "receiver.longitude",
         "end.latitude" = "receiver.latitude")


save(data_geo_lines_plot,
     file = "data/data_geo_lines_plot.rdata")

