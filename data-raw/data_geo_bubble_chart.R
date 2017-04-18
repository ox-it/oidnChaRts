## data_geo_bubble_chart
## This dataset is based on data that will be published here: https://doi.org/10.6084/m9.figshare.4516772
## Scatter geo charts are a natural fit for this data, as the dataset simply includes a number of labeled longitude-latitude pairs.

library(tidyverse)

data_geo_bubble_chart <- read_csv("data-raw/sample_geo_lines.csv")

send_locs <- data_geo_bubble_chart %>%
  select(date, contains("sender")) %>%
  rename(location.name = sender.location,
         latitude = sender.latitude,
         longitude = sender.longitude)

receive_locs <- data_geo_bubble_chart %>%
  select(date, contains("receiver")) %>%
  rename(location.name = receiver.location,
         latitude = receiver.latitude,
         longitude = receiver.longitude)

data_geo_bubble_chart <- union(send_locs, receive_locs) %>%
  select(-date) %>%
  group_by(latitude, longitude) %>%
  mutate(count = n()) %>%
  ungroup() %>%
  unique()

data_geo_bubble_chart <- data_geo_bubble_chart %>%
  separate(location.name, c("country", "city"), ",") %>%
  mutate(city = trimws(city))

save(data_geo_bubble_chart,
     file = "data/data_geo_bubble_chart.rdata")