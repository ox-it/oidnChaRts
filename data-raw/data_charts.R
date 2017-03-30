library(tidyverse)

data_stacked_bar_chart <- data.frame(
  "country" = c(
    "United Kingdom",
    "France",
    "Saudi Arabia",
    "Egypt",
    "Germany",
    "China",
    "Slovakia",
    "Canada",
    "Estonia",
    "Ireland"
  ),
  "Business" =  c(8, 6, 7, 8, 9, 7, 9, 7, 9, 9),
  "Other" = c(22, 28, 11, 19, 11, 39, 22, 10, 30, 7),
  "Personal Visit" = c(19, 21, 21, 20, 19, 19, 21, 21, 20, 20),
  "Teleconference" = c(9, 29, 21, 44, 59, 11, 53, 16, 49, 36),
  "Unclassified" = c(42, 48, 50, 45, 49, 40, 42, 47, 48, 44),
  stringsAsFactors = F
)
# Columns
categories_column <- "country"
subcategories_column <- "activity"
value_column <- "hours"
# Convert to long-format
data_stacked_bar_chart <- data_stacked_bar_chart %>%
  gather(activity, hours, match(
    setdiff(colnames(data_stacked_bar_chart), categories_column),
    colnames(data_stacked_bar_chart)
  )) %>%
  as_data_frame()

save(data_stacked_bar_chart,
     file = "data/data_stacked_bar_chart.rdata")

library(tidyverse)

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

## ======================== data_scatter_chart

library(rfigshare)
library(tidyverse)

deposit_details <- fs_details("4555441")

deposit_files <- unlist(deposit_details$files)
deposit_files <-
  data.frame(split(deposit_files, names(deposit_files)), stringsAsFactors = FALSE)
data_url <- deposit_files %>%
  filter(grepl("thesaurus.fig4-MQ0.tsv", name)) %>%
  select(download_url) %>%
  .[[1]]

data_scatter_plot <- read_tsv(data_url)
colnames(data_scatter_plot) <- tolower(colnames(data_scatter_plot))


data_scatter_plot <- data_scatter_plot %>%
  mutate(color = ifelse(
    type == "Concordant",
    rgb(27 / 255, 158 / 255, 119 / 255, 0.3),
    rgb(177 / 255, 158 / 255, 119 / 255, 0.3)
  ))


# data_scatter_plot <- data.frame(
#   x = rnorm(100),
#   y = rnorm(100),
#   group = rep(c("A","B","C","D"), 25),
#   color = rep(c(rgb(0, 1, 0, 0.1), rgb(1, 1, 0, 0.1), rgb(0, 1, 1, 0.1), rgb(0, 0, 1, 0.1)), 25)
# ) %>%
#   as_data_frame()

save(data_scatter_plot,
     file = "data/data_scatter_plot.rdata")
