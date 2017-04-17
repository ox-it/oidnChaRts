#' Scatter plot.
#'
#' \code{scatter_plot} creates a scatter plot using the specified library, which can be used in the library's \%>\% workflow. Data must be provided in long format.
#'
#' @rdname map-scatter-plot
#' @import htmlwidgets
#' @import dplyr
#' @importFrom stats as.formula
#' @param data A dataframe, must be long-formatted.
#' @param library Which library to use, highchart is default.
#' @param x.column Column containing x-coordinates for data points, default to x
#' @param y.column Column containing y-cordinates for data points, default to y
#' @param traces.column Column containing the traces/trace names, no default
#' @param color.column Column containing trace colour, default to color
#' @param marker.size Size of markers (circles, by default)
#' @param fillOpacity Opacity of markers, default 0.66
#' @export
scatter_plot <- function(data = NA,
                         library = "highcharter",
                         x.column = ~x,
                         y.column = ~y,
                         color.column = ~color,
                         marker.size = 5,
                         traces.column,
                         fillOpacity = 0.66) {
  ## check library is supported
  if (!library %in% c("highcharter", "plotly")) {
    stop(
      paste(
        "The selected library is not supported, choose from; highcharter, plotly."
      )
    )
  }
  
  viz.args <-
    mget(names(formals()), sys.frame(sys.nframe())) # http://stackoverflow.com/a/14398674/1659890
  
  switch (
    library,
    "highcharter" = hc_scatter_plot(viz.args),
    "plotly" = plotly_scatter_plot(viz.args)
  )
}

#' \code{hc_scatter_plot} should not be used directly, it generates a scatter plot using highcharter.
#' @rdname map-scatter-plot
#' @param ... all arguments provided to \code{scatter_plot}.
hc_scatter_plot <- function(...) {
  viz.args <- list(...)[[1]]
  data <- viz.args$data
  
  trace_details <- data %>%
    select_(f_text(viz.args$traces.column),
            "color") %>%
    unique() %>%
    rename_("name" = f_text(viz.args$traces.column)) %>%
    mutate(safe.name = make.names(name))
  
  traces_data <- data %>%
    # select_(
    #   f_text(viz.args$x.column),
    #   f_text(viz.args$y.column),
    #   f_text(viz.args$traces.column)
    # ) %>%
    mutate(., row = 1:nrow(.)) # ensure enough rows to identify uniqueness http://stackoverflow.com/questions/25960394/unexpected-behavior-with-tidyr#comment40693047_25960394
  
  
  traces_data <- traces_data %>%
    spread_(f_text(viz.args$traces.column),
            f_text(viz.args$y.column))
  
  colnames(traces_data) <- make.names(colnames(traces_data))
  
  hc <- highchart()
  
  lapply(trace_details[["safe.name"]],
         function(safe.series.name) {
           hc <<- hc %>%
             df_to_hc_xy_series(
               data = traces_data,
               type = "bubble",
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
  
  hc %>%
    hc_chart(type = "scatter") %>%
    hc_plotOptions(
      bubble = list(
        minSize = viz.args$marker.size,
        # Only way to limit bubble size.
        maxSize = viz.args$marker.size,
        # Only way to limit bubble size.
        ## Remove the size from the tooltip
        tooltip = list(headerFormat = "<b>{series.name}</b><br>",
                       pointFormat = "({point.x}, {point.y})")
      )
    )
  
}

#' \code{plotly_scatter_plot} should not be used directly, it generates a scatter plot using highcharter.
#' @rdname map-scatter-plot
#' @param ... all arguments provided to \code{scatter_plot}.
plotly_scatter_plot <- function(...) {
  viz.args <- list(...)[[1]]
  plot_data <- viz.args$data
  
  
  plot_data %>%
    plot_ly(
      x = viz.args$x.column,
      y = viz.args$y.column,
      color = viz.args$traces.column,
      colors = ~color
    ) %>%
    add_markers(alpha = 0.5)
  
}

rbokeh_scatter_plot <- function(...) {
  viz.args <- list(...)[[1]]
  plot_data <- viz.args$data
  
  plot_data %>%
    figure() %>%
    ly_points(x = viz.args$x.column,
              y = viz.args$y.column)
  
}



