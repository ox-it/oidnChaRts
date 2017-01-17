#' Line Charts.
#'
#' \code{stacked_bar_chart} creates a stacked bar chart using the specified library, which can be used in the library's \%>\% workflow. Data must be provided in long format.
#'
#' @rdname map-line_chart
#' @import htmlwidgets
#' @importFrom stats as.formula
#' @param data A dataframe, must be long-formatted.
#' @param library Which library to use, highchart is default.
#' @param categories.column  Column containing the bar groupings (or categories), in a horizontally orientated barchart these will be the y-axis labels. Must be given as formula, i.e. ~country
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
#' @rdname map-line_chart
hc_line_chart <- function(...) {

  viz.args <- list(...)[[1]]
  data <- viz.args$data

  trace_details <- data %>%
    select_(f_text(viz.args$traces.column),
            "color") %>%
    unique() %>%
    rename_("name" = f_text(viz.args$traces.column)) %>%
    mutate(safe.name = make.names(name))

  print(trace_details)

  trace_names <- data %>%
    select_(f_text(viz.args$traces.column)) %>%
    unique() %>%
    .[[1]]

  trace_names <- stats::setNames(make.names(trace_names), trace_names)

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

  print("after spread")
  print(traces_data)

  # setdiff(colnames(traces_data), f_text(viz.args$x.column))

  hc <- highchart()
  lapply(trace_details[["safe.name"]],
         function(safe.series.name){

           hc <<- hc %>%
             df_to_hc_xy_series(
               data = traces_data,
               x.column = f_text(viz.args$x.column),
               trace = safe.series.name,
               color = trace_details %>%
                 filter(safe.name == safe.series.name) %>%
                 select(color) %>%
                 .[[1]],
               name = trace_details %>%
                 filter(safe.name == safe.series.name) %>%
                 select(name) %>%
                 .[[1]]
             )

         })

  hc

  # highchart() %>%
  #   df_to_hc_xy_series(
  #     data = traces_data,
  #     x.column = f_text(viz.args$x.column),
  #     trace = "X.MQ.1..Local"
  #   )

}
