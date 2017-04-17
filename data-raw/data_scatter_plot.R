## data_scatter_chart
## This dataset comes from https://doi.org/10.6084/m9.figshare.4555441
## Scatter plots provide a natural visualisation option for this data.


library(rfigshare)
library(tidyverse)

fs_deposit_id <- 4555441
deposit_details <- fs_details(fs_deposit_id)

deposit_details <- unlist(deposit_details$files)
deposit_details <- data.frame(split(deposit_details, names(deposit_details)),stringsAsFactors = F)

data_scatter_plot <- deposit_details %>%
  dplyr::filter(name == "thesaurus.fig4-MQ16.tsv") %>%
  select(download_url) %>%
  .[[1]] %>%
  read_tsv()
colnames(data_scatter_plot) <- tolower(colnames(data_scatter_plot))


data_scatter_plot <- data_scatter_plot %>%
  mutate(chromosome = paste0(chr, ":", position)) %>%
  select(na12882_2_s1.naive.baf, # x
         na12882_s1.naive.baf, # y
         type,
         chromosome) %>%
  rename(x = na12882_2_s1.naive.baf,
         y =na12882_s1.naive.baf)



save(data_scatter_plot,
     file = "data/data_scatter_plot.rdata")
