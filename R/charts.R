# Recall that devtools::document()devtools::document() is necessary as shortcut Cmd+Shift+D not working


#' Stacked Bar Chart.
#'
#' \code{stacked_bar_chart} creates a stacked bar chart using the specified library, which can be used in the library's \%>\% workflow. Data must be provided in long format.
#'
#' @param data A dataframe, must be long-formatted.
#' @param library Which library to use, highchart is default.
#' @param categories.column  Column containing the bar groupings (or categories), in a horizontally orientated barchart these will be the y-axis labels.
#' @param categories.order Order for categories
#' @param subcategories.column Column containing different measures, i.e sub-categorisations.
#' @param value.column Column containing bar values, i.e. lengths.
#' @param stacking.type Stacking to apply to bars, default NULL. Possible values, c("percent", "normal")
#' @param subcategories.order Order for sub-categories, note for plotly the legend is ordered correctly but bars are reverse ordered
#'
#' @return Stacked bar chart of the class specified by the specified library.
#' @examples
#' \dontrun{
#' stacked_bar_chart(1, 1)
#' stacked_bar_chart(1, "foo")
#' }
#'
#' @section Warning: These should be considered utility functions only, the magic is contained within the htmlwidget library,
#'  it is perfectly possible breaking changes to the library and/or the underling JavaScript library will
#'  break these. In such case, refer to http://ox-it.github.io/OxfordIDN_htmlwidgets for generic tutorials on
#' the widely used htmlwidget libraries and how to select an alternative visualisation library.
#' @export
stacked_bar_chart <- function(data = NA,
                              library = "highcharter",
                              categories.column = NA,
                              categories.order = NA,
                              subcategories.column = NA,
                              value.column = NA,
                              stacking.type = NA,
                              subcategories.order = NA) {
  switch (
    library,
    "highcharter" = hc_stacked_bar_chart(
      data = data,
      categories.column = categories.column,
      categories.order = categories.order,
      subcategories.column = subcategories.column,
      value.column = value.column,
      stacking.type = stacking.type,
      subcategories.order = subcategories.order
    ),
    "plotly" = {
      plotly_stacked_bar_chart(
        data = data,
        categories.column = categories.column,
        categories.order = categories.order,
        subcategories.column = subcategories.column,
        value.column = value.column,
        stacking.type = stacking.type,
        subcategories.order = subcategories.order
      )
    }
  )
}

#' highchart bar chart
hc_stacked_bar_chart <- function(data = NA,
                                 categories.column = NA,
                                 categories.order = NA,
                                 subcategories.column = NA,
                                 value.column = NA,
                                 stacking.type = NA,
                                 subcategories.order = NA) {
  ## Compute categories.order, if necessary
  if (any(is.na(categories.order))) {
    categories_order <-unique(data[, categories.column])
  } else {
    categories_order <- categories.order
  }

  ## make wide
  ungroup(data) %>%
    spread_(subcategories.column, value.column) %>%
    setNames(make.names(names(.))) -> wide_data
  ## order category columns by categories_order
  wide_data <- wide_data[match(categories_order, wide_data[[categories.column]]), ]

  data_columns <- setdiff(colnames(wide_data), categories.column)

  subcategories_order <- make.names(subcategories.order)

  chart <-
    highchart() %>% hc_xAxis(categories = categories_order, title = categories.column)

  invisible(lapply(data_columns, function(x) {
    chart <<-
      hc_add_series(
        hc = chart,
        name = gsub("[.]", " ", x),
        data = wide_data %>% select_(x) %>% unlist(use.names = F),
        index = {
          if (any(is.na(subcategories_order))) {
            if (is.na(stacking.type)) {
              length(subcategories_order) - which(subcategories_order == x) - 1
            } else {
              which(subcategories_order == x) - 1
            }
          } else

            if (is.na(stacking.type)) {
              length(subcategories_order) - which(rev(subcategories_order) == x) - 1
            } else {
              which(rev(subcategories_order) == x) - 1
            }

        }
      )
  }))

  chart %>%
    hc_chart(type = "bar") %>%
    hc_plotOptions(series = list(stacking = as.character(stacking.type))) %>%
    hc_legend(reversed = ifelse(is.na(stacking.type), FALSE, TRUE))

}

#' Plotly Stacked Bar Chart.
plotly_stacked_bar_chart <- function(data = NA,
                                     categories.column = NA,
                                     categories.order = NA,
                                     subcategories.column = NA,
                                     value.column = NA,
                                     stacking.type = NA,
                                     # ordering.function = NA,
                                     subcategories.order = NA) {
  # sample_data %>% gather_("Activity", "Days", setdiff(colnames(sample_data), "Countries"))

  plot_data <- data

  if (!any(is.na(subcategories.order))) {
    ## grouped bars do not reverse the legend, but does reverse bar order
    if(is.na(stacking.type)){
      plot_data[, subcategories.column] <-
        factor(plot_data[, subcategories.column], levels = subcategories.order)
    }
    } else {
      ## allow automated ordering
      plot_data
    }

  if (!any(is.na(categories.order))) {
    plot_data[, categories.column] <-
      factor(plot_data[, categories.column], levels = rev(categories.order))
  }

  chart <- plot_ly(
    data = plot_data,
    type = "bar",
    y = ~eval(as.name(categories.column)),
    x = ~eval(as.name(value.column)),
    color = ~eval(as.name(subcategories.column)),
    orientation = "h"
  ) %>%
    layout(
      xaxis = list(title = value.column),
      yaxis = list(title = categories.column)
    )

  if (is.na(stacking.type)) {
    chart
  } else {
    chart %>%
      layout(barmode = "stack", barnorm = stacking.type) # See issue logger https://github.com/ox-it/oidnChaRts/issues/1
  }
}
