# Recall that devtools::document()devtools::document() is necessary as shortcut Cmd+Shift+D not working


#' Stacked Bar Chart.
#'
#' \code{stacked_bar_chart} creates a stacked bar chart using the specified library, which can be used in the librarie's \%>\% workflow..
#'
#' @param data A dataframe.
#' @param library Which library to use, highchart is default.
#' @param categories_column Divisions within each bar.
#' @param measure_columns Column names containing data for bars (each category is a specific bar),
#'  this could also be considered as the "y-axis" in a horizontally orientated bar chart.
#' @param stacking_type Stacking to apply to bars, default NULL. Possible values, c("percent", "normal")
#' @param ordering_function Function applied to bar segments to decide on order, default c.
#'  It is a good default to choose var.
#' @param explicit_order Overrides ordering_function, order must be given by index.
#'
#' @return Stacked bar chart of the class specified by the specified library.
#' @examples
#' stacked_bar_chart(1, 1)
#' stacked_bar_chart(1, "foo")
#'
#' #' @section Warning:
#' These should be considered utility functions only, the magic is contained within the htmlwidget library,
#' it is perfectly possible breaking changes to the library and/or the underling JavaScript library will
#' break these. In such case, refer to http://ox-it.github.io/OxfordIDN_htmlwidgets for generic tutorials on
#' the widely used htmlwidget libraries and how to select an alternative visualisation library.
#' @export
stacked_bar_chart <- function(data = NA,
                              library = "highcharter",
                              categories_column = NA,
                              measure_columns = NA,
                              stacking_type = NA,
                              ordering_function = c,
                              explicit_order = NA) {
  switch (
    library,
    "highcharter" = hc_stacked_bar_chart(
      data,
      categories_column,
      measure_columns,
      stacking_type,
      ordering_function,
      explicit_order
    ),
    "plotly" = {
      plotly_stacked_bar_chart(
        data,
        categories_column,
        measure_columns,
        stacking_type,
        ordering_function,
        explicit_order
      )
    }
  )
}

#' highchart bar chart
hc_stacked_bar_chart <- function(data = NA,
                                 categories_column = NA,
                                 measure_columns = NA,
                                 stacking_type = NA,
                                 ordering_function = c,
                                 explicit_order = NA) {
  ordered_measure <-
    order(unlist(lapply(measure_columns, function(x) {
      ordering_function(data[, x])
    })), decreasing = TRUE) - 1

  chart <-
    highchart() %>% hc_xAxis(categories = data[, categories_column], title = categories_column)

  invisible(lapply(1:length(measure_columns), function(colNumber) {
    chart <<-
      hc_add_series(
        hc = chart,
        name = measure_columns[colNumber],
        data = data[, measure_columns[colNumber]],
        index = {
          if (is.na(explicit_order)) {
            ordered_measure[colNumber]
          } else
            explicit_order[colNumber]
        }
      )
  }))

  chart %>% hc_chart(type = "bar") %>% hc_plotOptions(series = list(stacking = as.character(stacking_type))) %>% hc_legend(reversed = TRUE)

}

#' Plotly Stacked Bar Chart.
plotly_stacked_bar_chart <- function(data = NA,
                                     categories_column = NA,
                                     measure_columns = NA,
                                     stacking_type = NA,
                                     ordering_function = c,
                                     explicit_order = NA) {
  # sample_data %>% gather_("Activity", "Days", setdiff(colnames(sample_data), "Countries"))
  "not implemented yet"
}
