 #' Line Charts.
#'
#' \code{stacked_bar_chart} creates a stacked bar chart using the specified library, which can be used in the library's \%>\% workflow. Data must be provided in long format.
#'
#' @rdname map-line-chart
#' @import htmlwidgets
#' @importFrom stats as.formula
#' @importFrom stats na.omit
#' @param data A dataframe, must be long-formatted.
#' @param library Which library to use, highchart is default.
#' @param x.column Column containing x-coordinates for data points
#' @param y.column Column containing y-cordinates for data points
#' @param traces.column Column containing the traces/trace names
#' @param markers Show plot markers on lines? TRUE or FALSE.
#' @export
line_chart <- function(data = NA,
                       library = "highcharter",
                       x.column,
                       y.column,
                       traces.column,
                       color.column,
                       markers = TRUE) {
  ## check library is supported
  if (!library %in% c("highcharter", "plotly")) {
    stop(paste(
      "The selected library is not supported, choose from; leaflet or plotly"
    ))
  }

  viz.args <-
    mget(names(formals()), sys.frame(sys.nframe())) # http://stackoverflow.com/a/14398674/1659890

  switch (library,
          "highcharter" = hc_line_chart(viz.args),
          "plotly" = {
            plotly_line_chart(viz.args)
          })
}

#' \code{hc_line_chart} should not be used directly, it generates a line chart using Highchart.
#' @rdname map-line-chart
#' @param ... all arguments provided to \code{line_chart}.
hc_line_chart <- function(...) {

  viz.args <- list(...)[[1]]
  data <- viz.args$data


  ## TODO: Highchart hcaes doesn't have NSE yet, reimplement this so it's not HORRIBLE.
  traces_data <- data %>%
    rename_("x" = viz.args$x.column,
            "y" = viz.args$y.column,
            "color" = viz.args$color.column,
            "group" = viz.args$traces.column)
  
  group_colors <- traces_data %>%
    select(color) %>%
    unique() %>%
    .[[1]]

  highchart() %>%
    hc_add_series(traces_data,
                  "line",
                  hcaes(
                    x = x,
                    y = y,
                    group = group
                  )) %>%
    hc_colors(group_colors)
  
}

#' \code{plotly_line_chart} should not be used directly, it generates a line chart using using Plotly.
#' @rdname map-line-chart
#' @param ... all arguments provided to \code{line_chart}.
plotly_line_chart <- function(...) {
  
  viz.args <- list(...)[[1]]
  data <- viz.args$data
 
  plot_ly() %>%
    add_trace(data = data,
              x = viz.args$x.column,
              y = viz.args$y.column,
              color = viz.args$traces.column,
              colors = viz.args$color.column,
              mode='lines+markers', 
              type='scatter')
   
}
