# Recall that devtools::document()devtools::document() is necessary as shortcut Cmd+Shift+D not working


#' Stacked Bar Chart.
#'
#' \code{stacked_bar_chart} creates a stacked bar chart using the specified library, which can be used in the librarie's \%>\% workflow. Data must be provided in long format.
#'
#' @param data A dataframe, must be long-formatted.
#' @param library Which library to use, highchart is default.
#' @param categories_column  Column containing the bar groupings (or categories), in a horizontally orientated barchart these will be the y-axis labels.
#' @param subcategories_column Column containing different measures, i.e sub-categorisations.
#' @param value_column Column containing bar values, i.e. lengths.
#' @param stacking_type Stacking to apply to bars, default NULL. Possible values, c("percent", "normal")
#' @param ordering_function Function applied to bar segments to decide on order, default c.
#'  It is a good default to choose var.
#' @param subcategories_order Overrides ordering_function, order must be given by index.
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
                              categories_order = NA,
                              subcategories_column = NA,
                              value_column = NA,
                              stacking_type = NA,
                              ordering_function = NA,
                              subcategories_order = NA) {
  switch (
    library,
    "highcharter" = hc_stacked_bar_chart(
      data = data,
      categories_column = categories_column,
      categories_order = categories_order,
      subcategories_column = subcategories_column,
      value_column = value_column,
      stacking_type = stacking_type,
      ordering_function = ordering_function,
      subcategories_order = subcategories_order
    ),
    "plotly" = {
      plotly_stacked_bar_chart(
        data = data,
        categories_column = categories_column,
        categories_order = categories_order,
        subcategories_column = subcategories_column,
        value_column = value_column,
        stacking_type = stacking_type,
        ordering_function = ordering_function,
        subcategories_order = subcategories_order
      )
    }
  )
}

#' highchart bar chart
hc_stacked_bar_chart <- function(data = NA,
                                 categories_column = NA,
                                 categories_order = NA,
                                 subcategories_column = NA,
                                 value_column = NA,
                                 stacking_type = NA,
                                 ordering_function = NA,
                                 subcategories_order = NA) {
  ## Compute categories_order, if necessary
  if (any(is.na(categories_order))) {
    categories_order <-unique(data[, categories_column])
  } else {
    categories_order <- categories_order
  }

  ## make wide
  ungroup(data) %>%
    spread_(subcategories_column, value_column) %>%
    setNames(make.names(names(.))) -> wide_data
  ## order category columns by categories_order
  wide_data <- wide_data[match(categories_order, wide_data[[categories_column]]), ]

  data_columns <- setdiff(colnames(wide_data), categories_column)

  subcategories_order <- make.names(subcategories_order)

  # if (is.na(ordering_function)) {
  #   ordered_measures <- data_columns
  # } else {
  #   ordered_measures <-
  #     data_columns[order(unlist(lapply(data_columns, function(x) {
  #       ordering_function(wide_data[, x])
  #     })), decreasing = TRUE)]
  # }
  chart <-
    highchart() %>% hc_xAxis(categories = categories_order, title = categories_column)

  invisible(lapply(data_columns, function(x) {
    chart <<-
      hc_add_series(
        hc = chart,
        name = gsub("[.]", " ", x),
        data = wide_data %>% select_(x) %>% unlist(use.names = F),
        index = {
          if (any(is.na(subcategories_order))) {
            if (is.na(stacking_type)) {
              length(subcategories_order) - which(subcategories_order == x) - 1
            } else {
              which(subcategories_order == x) - 1
            }


          } else

            if (is.na(stacking_type)) {
              length(subcategories_order) - which(rev(subcategories_order) == x) - 1
            } else {
              which(rev(subcategories_order) == x) - 1
            }

        }
      )
  }))

  chart %>%
    hc_chart(type = "bar") %>%
    hc_plotOptions(series = list(stacking = as.character(stacking_type))) %>%
    hc_legend(reversed = ifelse(is.na(stacking_type), FALSE, TRUE))

}

#' Plotly Stacked Bar Chart.
plotly_stacked_bar_chart <- function(data = NA,
                                     categories_column = NA,
                                     categories_order = NA,
                                     subcategories_column = NA,
                                     value_column = NA,
                                     stacking_type = NA,
                                     ordering_function = NA,
                                     subcategories_order = NA) {
  # sample_data %>% gather_("Activity", "Days", setdiff(colnames(sample_data), "Countries"))

  if (!any(is.na(categories_order))) {
    suppressWarnings(data <- left_join({
      df <- data.frame(rev(categories_order))
      colnames(df) <- categories_column
      df
    }, data, by = categories_column))
  }

  data_columns <- setdiff(colnames(data), categories_column)

  if (is.na(ordering_function)) {
    ordered_measures <- data_columns
  } else {
    ordered_measures <-
      data_columns[order(unlist(lapply(data_columns, function(x) {
        ordering_function(wide_data[, x])
      })), decreasing = TRUE)]
  }

  if (!any(is.na(subcategories_order))) {
    data[, subcategories_column] <-
      factor(data[, subcategories_column], levels = rev(subcategories_order))
  }

  chart <- plot_ly(
    data = data,
    type = "bar",
    y = ~eval(as.name(categories_column)),
    x = ~eval(as.name(value_column)),
    color = ~eval(as.name(subcategories_column)),
    orientation = "h"
  ) %>%
    layout(
      xaxis = list(title = value_column),
      yaxis = list(title = categories_column)
    )

  if (is.na(stacking_type)) {
    chart
  } else {
    chart %>%
      layout(barmode = "stack", barnorm = stacking_type)
  }
}
