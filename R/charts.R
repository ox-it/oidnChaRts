# Recall that devtools::document()devtools::document() is necessary as shortcut Cmd+Shift+D not working

#' Stacked Bar Chart.
#'
#' \code{stacked_bar_chart} creates a stacked bar chart using the specified library, which can be used in the library's \%>\% workflow. Data must be provided in long format.
#'
#' @param data A dataframe, must be long-formatted.
#' @param library Which library to use, highchart is default.
#' @param categories.column  Column containing the bar groupings (or categories), in a horizontally orientated barchart these will be the y-axis labels. Must be given as formula, i.e. ~country
#' @param categories.order Order for categories
#' @param subcategories.column Column containing different measures, i.e sub-categorisations. Must be given as formula, i.e. ~country
#' @param value.column Column containing bar values, i.e. lengths. Must be given as formula, i.e. ~country
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
                              subcategories.order = NA,
                              return.data = FALSE) {
  ## check library is supported
  if (!library %in% c("highcharter", "plotly")) {
    stop(paste(
      "The selected library is not supported, choose from; leaflet or plotly"
    ))
  }

  optnl.args <-
    mget(names(formals()), sys.frame(sys.nframe())) # http://stackoverflow.com/a/14398674/1659890

  switch (
    library,
    "highcharter" = hc_stacked_bar_chart(data = data,
                                         optnl.args = optnl.args),
    "plotly" = {
      plotly_stacked_bar_chart(data = data,
                               optnl.args = optnl.args)
    }
  )
}

#' highchart bar chart
hc_stacked_bar_chart <- function(data = NA,
                                 optnl.args = NA) {
  ## Compute categories.order, if necessary

  if (any(is.na(optnl.args$categories.order))) {
    categories_order <- f_eval(optnl.args$categories.column, data) %>%
      unique() %>%
      unlist(use.names = FALSE)
  } else {
    categories_order <- optnl.args$categories.order
  }

  ## TODO: Check duplicates as otherwise spread_ complains

  ## make wide
  ungroup(data) %>%
    spread_(f_text(optnl.args$subcategories.column),
            f_text(optnl.args$value.column)) %>%
    setNames(make.names(names(.))) -> wide_data

  ## order category columns by categories_order
  wide_data <-
    wide_data[match(categories_order, wide_data[[f_text(optnl.args$categories.column)]]),]

  data_columns <-
    setdiff(colnames(wide_data), f_text(optnl.args$categories.column))

  subcategories_order <- make.names(optnl.args$subcategories.order)

  if (optnl.args$return.data) {
    return(wide_data)
  }

  chart <-
    highchart() %>% hc_xAxis(categories = categories_order,
                             title = f_text(optnl.args$categories.column))

  invisible(lapply(data_columns, function(x) {
    chart <<-
      hc_add_series(
        hc = chart,
        name = gsub("[.]", " ", x),
        data = wide_data %>% select_(x) %>% unlist(use.names = F),
        index = {
          if (any(is.na(subcategories_order))) {
            if (is.na(optnl.args$stacking.type)) {
              length(subcategories_order) - which(subcategories_order == x) - 1
            } else {
              which(subcategories_order == x) - 1
            }
          } else

            if (is.na(optnl.args$stacking.type)) {
              length(subcategories_order) - which(rev(subcategories_order) == x) - 1
            } else {
              which(rev(subcategories_order) == x) - 1
            }

        }
      )
  }))

  chart %>%
    hc_chart(type = "bar") %>%
    hc_plotOptions(series = list(stacking = as.character(optnl.args$stacking.type))) %>%
    hc_legend(reversed = ifelse(is.na(optnl.args$stacking.type), FALSE, TRUE))

}

#' Plotly Stacked Bar Chart.
plotly_stacked_bar_chart <- function(data = NA,
                                     optnl.args = NA) {
  # sample_data %>% gather_("Activity", "Days", setdiff(colnames(sample_data), "Countries"))

  plot_data <- data

  if (!any(is.na(optnl.args$subcategories.order))) {
    ## grouped bars do not reverse the legend, but does reverse bar order
    if (is.na(optnl.args$stacking.type)) {
      plot_data[, f_text(optnl.args$subcategories.column)] <-
        factor(plot_data[, f_text(optnl.args$subcategories.column)], levels = optnl.args$subcategories.order)
    }
  } else {
    ## allow automated ordering
    plot_data
  }

  if (!any(is.na(optnl.args$categories.order))) {
    plot_data[, f_text(optnl.args$categories.column)] <-
      factor(plot_data[, f_text(optnl.args$categories.column)], levels = rev(optnl.args$categories.order))
  }

  chart <- plot_ly(
    data = plot_data,
    type = "bar",
    y = optnl.args$categories.column,
    x = optnl.args$value.column,
    color = optnl.args$subcategories.column,
    orientation = "h"
  ) %>%
    layout(xaxis = list(title = f_text(optnl.args$value.column)),
           yaxis = list(title = f_text(optnl.args$categories.column)))

  if (is.na(optnl.args$stacking.type)) {
    chart
  } else {
    chart %>%
      layout(barmode = "stack", barnorm = optnl.args$stacking.type) # See issue logger https://github.com/ox-it/oidnChaRts/issues/1
  }
}
