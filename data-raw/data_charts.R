data_stacked_bar_chart <- data.frame(
  "Country" = c(
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
  "Overlay" = c(22, 28, 11, 19, 11, 39, 22, 10, 30, 7),
  "Personal" = c(19, 21, 21, 20, 19, 19, 21, 21, 20, 20),
  "Teleconference" = c(9, 29, 21, 44, 59, 11, 53, 16, 49, 36),
  "Unclassified" = c(42, 48, 50, 45, 49, 40, 42, 47, 48, 44),
  stringsAsFactors = F
)

save(data_stacked_bar_chart %>%
       gather("Activity",
              "Hours",
              which(
                colnames(data_stacked_bar_chart) %in% setdiff(colnames(data_stacked_bar_chart), "Country")
              )),
     file = "data/data_stacked_bar_chart.rdata")
