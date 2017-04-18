## data_geo_marker_plot
## This dataset is based on data that will be published here: https://doi.org/10.6084/m9.figshare.4516772
## Scatter geo charts are a natural fit for this data, as the dataset simply includes a number of labeled longitude-latitude pairs.

library(tidyverse)

data_geo_marker_plot <- read_csv("data-raw/sample_geo_lines.csv")

send_locs <- data_geo_marker_plot %>%
  select(date, contains("sender")) %>%
  rename(location.name = sender.location,
         latitude = sender.latitude,
         longitude = sender.longitude)

receive_locs <- data_geo_marker_plot %>%
  select(date, contains("receiver")) %>%
  rename(location.name = receiver.location,
         latitude = receiver.latitude,
         longitude = receiver.longitude)

data_geo_marker_plot <- union(send_locs, receive_locs) %>%
  select(-date) %>%
  group_by(latitude, longitude) %>%
  mutate(count = n()) %>%
  ungroup() %>%
  unique()

data_geo_marker_plot <- data_geo_marker_plot %>%
  separate(location.name, c("country", "city"), ",") %>%
  mutate(city = trimws(city)) %>%
  mutate(color = plyr::mapvalues(
    country,
    from = unique(country),
    to = RColorBrewer::brewer.pal(11, "Paired")
  ))
  

save(data_geo_marker_plot,
     file = "data/data_geo_marker_plot.rdata")