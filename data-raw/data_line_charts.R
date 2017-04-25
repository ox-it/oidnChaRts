## data_line_chart
## This dataset comes from https://doi.org/10.6084/m9.figshare.4555441
## Scatter plots provide a natural visualisation option for this data.

library(rfigshare)
library(tidyverse)

fs_deposit_id <- 4555441
deposit_details <- fs_details(fs_deposit_id)

deposit_details <- unlist(deposit_details$files)
deposit_details <- data.frame(split(deposit_details, names(deposit_details)),stringsAsFactors = F)

data_line_chart <- deposit_details %>%
  dplyr::filter(name == "thesaurus.fig2.tsv") %>%
  select(download_url) %>%
  .[[1]] %>%
  read_tsv()
colnames(data_line_chart) <- tolower(colnames(data_line_chart))

data_line_chart <- data_line_chart %>%
  rename(x = af,
         y = fdr) %>%
  select(-tpr)

x.column = ~af,
y.column = ~fdr,



## ======================== data_line_chart

data_line_chart <- read_tsv("data-raw/thesaurus.fig2.tsv")
colnames(data_line_chart) <- tolower(colnames(data_line_chart))

line_colours_scheme <- read_csv("data-raw/color_scheme.csv")
colnames(line_colours_scheme) <-
  tolower(make.names(colnames(line_colours_scheme)))

data_line_chart <- data_line_chart %>%
  mutate(color = plyr::mapvalues(series,
                                 line_colours_scheme$name,
                                 line_colours_scheme$colour))

save(data_line_chart,
     file = "data/data_line_chart.rdata")