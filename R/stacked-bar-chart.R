#' Stacked Bar Chart.
#'
#' \code{stacked_bar_chart} creates a stacked bar chart using the specified library, which can be used in the library's \%>\% workflow. Data must be provided in long format.
#'
#' @import htmlwidgets
#' @importFrom stats as.formula
#' @rdname map-stacked-bar-chart
#' @param data A dataframe, must be long-formatted.
#' @param library Which library to use, highchart is default.
#' @param categories.column  Column containing the bar groupings (or categories), in a horizontally orientated barchart these will be the y-axis labels. Must be given as formula, i.e. ~country
#' @param categories.order Order for categories to appear in the bar chart, a character vector containing as many unique
#' categories as there ar in \code{data}. For \code{data_stacked_bar_chart} the order might be c("United Kingdom",
#' "Canada", "China", "Estonia", "Egypt", "France", "Germany", "Ireland", "Saudi Arabia", "Slovakia").
#' Default to NA, the categories order will be determined by their appearance in \code{data}.
#' @param subcategories.column Column containing different measures, i.e sub-categorisations. Must be given as formula, i.e. ~country
#' @param value.column Column containing bar values, i.e. lengths. Must be given as formula, i.e. ~country
#' @param stacking.type Stacking to apply to bars, default NULL. Possible values, c("percent", "normal")
#' @param subcategories.order Order for sub-categories, note for plotly the legend is ordered correctly but bars are reverse ordered
#' @param return.data Useful tool for debugging libraries that perform internal data wrangling, for instance highcharter. If TRUE the function will return the restructured data provided to the htmlwidget generating the output. Default to FALSE.
#'
#' @return Stacked bar chart of the class specified by the specified library.
#' @examples
#' \dontrun{
#' ## Generate a stacked bar chart using highcharter
#' stacked_bar_chart(data = data_stacked_bar_chart,
#' library = "highcharter",
#' categories.column = ~country,
#' subcategories.column = ~activity,
#' value.column = ~hours)
#'
#' ## Generate a staced bar chart with bars stacked such that the subcategories totals within a
#' ## category sum to 100%, using plotly.
#' activity_order <- c("Unclassified", "Business", "Overlay", "Personal", "Teleconference")
#' country_order <- c("Canada", "China", "Egypt", "Estonia", "France", "Germany", "Ireland",
#' "Saudi Arabia", "Slovakia", "United Kingdom")
#'stacked_bar_chart(data = data_stacked_bar_chart,
#'                library = "plotly",
#'                categories.column = ~country,
#'                categories.order = country_order,
#'                subcategories.column = ~activity,
#'                value.column = ~hours,
#'                subcategories.order = activity_order,
#'                stacking.type = "percent")
#' }
#'
#' @section Warning: These should be considered utility functions only, the magic is contained within the htmlwidget library,
#'  it is perfectly possible breaking changes to the library and/or the underling JavaScript library will
#'  break these. In such case, refer to http://ox-it.github.io/OxfordIDN_htmlwidgets for generic tutorials on
#' the widely used htmlwidget libraries and how to select an alternative visualisation library.
#'
#' @export
stacked_bar_chart <- function(data,
                              library = "highcharter",
                              categories.column,
                              categories.order = NA,
                              subcategories.column,
                              value.column,
                              stacking.type = NA,
                              subcategories.order = NA,
                              return.data = FALSE) {
  ## check library is supported
  if (!library %in% c("highcharter", "plotly")) {
    stop(paste(
      "The selected library is not supported, choose from; leaflet or plotly"
    ))
  }
  
  viz.args <-
    mget(names(formals()), sys.frame(sys.nframe())) # http://stackoverflow.com/a/14398674/1659890
  
  switch (library,
          "highcharter" = hc_stacked_bar_chart(viz.args),
          "plotly" = {
            plotly_stacked_bar_chart(viz.args)
          })
}

#' \code{hc_stacked_bar_chart} should not be used directly, it generates a stacked barchart using Plotly.
#' @rdname map-stacked-bar-chart
#' @param ... all arguments provided to \code{stacked_bar_chart}.
hc_stacked_bar_chart <- function(...) {
  viz.args <- list(...)[[1]]
  data <- viz.args$data
  
  ## Compute categories.order, if necessary
  if (any(is.na(viz.args$categories.order))) {
    categories_order <- f_eval(viz.args$categories.column, data) %>%
      unique() %>%
      unlist(use.names = FALSE)
  } else {
    categories_order <- viz.args$categories.order
  }
  
  
  
  data <- ungroup(data) %>%
    select_(
      f_text(viz.args$value.column),
      f_text(viz.args$categories.column),
      f_text(viz.args$subcategories.column)
    ) # select only columns in visualisation
  
  ## TODO: Add an appropriate testthat
  if (data %>% # if any duplicated
      select_(f_text(viz.args$categories.column),
              f_text(viz.args$subcategories.column)) %>%
      duplicated() %>%
      any()) {
    stop(
      print(
        "There must NOT be duplicate entries for category/subcategory pairs, check that the data is indeed long formatted"
      )
    )
  }
  
  ## make wide
  wide_data <- data %>%
    spread_(f_text(viz.args$subcategories.column),
            f_text(viz.args$value.column))
  
  valid_names_lookup <- data.frame(
    original = names(wide_data),
    replacement = make.names(names(wide_data))
  )
  
  wide_data <-
    stats::setNames(wide_data, make.names(names(wide_data)))

  ## order category columns by categories_order
  wide_data <-
    wide_data[match(categories_order, wide_data[[f_text(viz.args$categories.column)]]),]
  
  data_columns <-
    setdiff(colnames(wide_data), f_text(viz.args$categories.column))
  
  subcategories_order <- make.names(viz.args$subcategories.order)
  
  if (viz.args$return.data) {
    return(wide_data)
  }
  
  chart <-
    highchart() %>% hc_xAxis(categories = categories_order,
                             title = f_text(viz.args$categories.column))
  
  invisible(lapply(data_columns, function(x) {
    chart <<-
      hc_add_series(
        hc = chart,
        name = valid_names_lookup %>%
          filter(replacement == x) %>%
          select(original) %>%
          .[[1]],
        data = wide_data %>% select_(x) %>% unlist(use.names = F),
        index = {
          if (any(is.na(subcategories_order))) {
            if (is.na(viz.args$stacking.type)) {
              length(subcategories_order) - which(subcategories_order == x) - 1
            } else {
              which(subcategories_order == x) - 1
            }
          } else
            
            if (is.na(viz.args$stacking.type)) {
              length(subcategories_order) - which(rev(subcategories_order) == x) - 1
            } else {
              which(rev(subcategories_order) == x) - 1
            }
          
        }
      )
  }))
  
  chart %>%
    hc_chart(type = "bar") %>%
    hc_plotOptions(series = list(stacking = as.character(viz.args$stacking.type))) %>%
    hc_legend(reversed = ifelse(is.na(viz.args$stacking.type), FALSE, TRUE))
  
}

#' \code{plotly_stacked_bar_chart} should not be used directly, it generates a stacked barchart using Plotly.
#' @rdname map-stacked-bar-chart
plotly_stacked_bar_chart <- function(...) {
  viz.args <- list(...)[[1]]
  viz.args <- list(...)[[1]]
  data <- viz.args$data
  
  plot_data <- data
  
  if (!any(is.na(viz.args$subcategories.order))) {
      plot_data[, f_text(viz.args$subcategories.column)] <-
        factor(plot_data %>%
                 select_(f_text(viz.args$subcategories.column)) %>%
                 .[[1]],
               levels = rev(viz.args$subcategories.order))
  }

  
  if (!any(is.na(viz.args$categories.order))) {
    plot_data[, f_text(viz.args$categories.column)] <-
      factor(plot_data %>%
               select_(f_text(viz.args$categories.column)) %>%
               .[[1]],
             levels = rev(viz.args$categories.order))
  }
  
  chart <- plot_ly(
    data = plot_data,
    type = "bar",
    y = viz.args$categories.column,
    x = viz.args$value.column,
    color = viz.args$subcategories.column,
    orientation = "h"
  ) %>%
    layout(xaxis = list(title = f_text(viz.args$value.column)),
           yaxis = list(title = f_text(viz.args$categories.column)))
  
  if (is.na(viz.args$stacking.type)) {
    chart
  } else {
    chart %>%
      layout(barmode = "stack", barnorm = viz.args$stacking.type) # See issue logger https://github.com/ox-it/oidnChaRts/issues/1
  }
}
