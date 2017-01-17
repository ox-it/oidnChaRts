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
            hc_line_chart(viz.args)
          })
}

#' \code{hc_line_chart} should not be used directly, it generates a stacked barchart using Plotly.
#' @rdname map-line-chart
#' @param ... all arguments provided to \code{line_chart}.
hc_line_chart <- function(...) {

  viz.args <- list(...)[[1]]
  data <- viz.args$data

  trace_details <- data %>%
    select_(f_text(viz.args$traces.column),
            "color") %>%
    unique() %>%
    rename_("name" = f_text(viz.args$traces.column)) %>%
    mutate(safe.name = make.names(name))

  traces_data <- data %>%
    select_(
      f_text(viz.args$x.column),
      f_text(viz.args$y.column),
      f_text(viz.args$traces.column)
    )

  traces_data <- traces_data %>%
    spread_(f_text(viz.args$traces.column),
            f_text(viz.args$y.column))

  colnames(traces_data) <- make.names(colnames(traces_data))

  hc <- highchart()
  lapply(trace_details[["safe.name"]],
         function(safe.series.name){

           hc <<- hc %>%
             df_to_hc_xy_series(
               data = traces_data,
               x.column = f_text(viz.args$x.column),
               trace = safe.series.name,
               color = trace_details %>%
                 filter_("safe.name" == safe.series.name) %>%
                 select(color) %>%
                 .[[1]],
               name = trace_details %>%
                 filter_("safe.name" == safe.series.name) %>%
                 select(name) %>%
                 .[[1]]
             )

         })
  hc

}
