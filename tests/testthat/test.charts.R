library(stringr)
context("String length")

data_stacked_bar_chart <- data.frame(
  "Country" = c(
    "United Kingdom","France","Saudi Arabia","Egypt","Germany","China","Slovakia","Canada","Estonia","Ireland"
  ),
  "Business" =  c(8, 6, 7, 8, 9, 7, 9, 7, 9, 9),
  "Overlay" = c(22, 28, 11, 19, 11, 39, 22, 10, 30, 7),
  "Personal" = c(19, 21, 21, 20, 19, 19, 21, 21, 20, 20),
  "Teleconference" = c(9, 29, 21, 44, 59, 11, 53, 16, 49, 36),
  "Unclassified" = c(42, 48, 50, 45, 49, 40, 42, 47, 48, 44),
  stringsAsFactors = F
)

library(tidyr)
data_stacked_bar_chart <- gather(data_stacked_bar_chart,
       "activity",
       "hours",
       which(
         colnames(data_stacked_bar_chart) %in% setdiff(colnames(data_stacked_bar_chart), "Country")
       ))

categories_order <- c("China","United Kingdom","France","Slovakia","Canada","Estonia","Ireland","Saudi Arabia","Egypt","Germany")
subcategories_order <- c("Personal", "Teleconference", "Unclassified", "Business", "Overlay")


test_that("stacked_bar_chart(library='highcharter') makes a highchart object", {

  hc <- stacked_bar_chart(
    data = data_stacked_bar_chart,
    library = "highcharter",
    categories.column = ~Country,
    value.column = ~hours,
    subcategories.column = ~activity,
    stacking.type = "percent"
  )

  expect_true(all(class(hc) %in% c("highchart",  "htmlwidget")))

})


test_that(
  "stacked_bar_chart(library='plotly') is not yet implemented", {

  chart <- stacked_bar_chart(
    data = data_stacked_bar_chart,
    library = "plotly",
    categories.column = ~Country,
    categories.order = categories_order,
    value.column = ~hours,
    subcategories.column = ~activity,
    subcategories.order = subcategories_order
  )

  expect_true(all(class(chart) %in% c("plotly",  "htmlwidget")))
  }
)
