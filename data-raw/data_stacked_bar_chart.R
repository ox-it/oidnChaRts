## data_stacked_bar_chart
## This dataset comes from https://doi.org/10.6084/m9.figshare.3761562
## Stacked barcharts provide a natural visualisation option for this data.


library(rfigshare)
library(tidyverse)


fs_deposit_id <- 3761562
deposit_details <- fs_details(fs_deposit_id)

deposit_details <- unlist(deposit_details$files)
deposit_details <- data.frame(split(deposit_details, names(deposit_details)),stringsAsFactors = F)

region_import <- read_csv(deposit_details[grepl("bcountrydata_",deposit_details$name),"download_url"])
region_import$timestamp <- as.Date(region_import$timestamp)

data_stacked_bar_chart <- region_import %>%
  filter(timestamp == max(timestamp))

save(data_stacked_bar_chart,
     file = "data/data_stacked_bar_chart.rdata")
