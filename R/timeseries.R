#' Calendar Heatmap.
#'
#' \code{calendar_heatmap} creates a calendar heatmap using the specified library, which can be used in the library's \code{\%>\%} workflow. Data must be provided in long format.
#'
#' @import htmlwidgets
#' @importFrom googleVis gvisCalendar
#' @rdname map-calendar-heatmap
#' @param data Date to be included in the heatmap
#' @param library Which library to use, googleViz is default.
#' @return Stacked bar chart of the class specified by the specified library.
#' @section Warning: These should be considered utility functions only, the magic is contained within the htmlwidget library,
#'  it is perfectly possible breaking changes to the library and/or the underling JavaScript library will
#'  break these. In such case, refer to http://martinjhnhadley.github.io/OxfordIDN_htmlwidgets for generic tutorials on
#' the widely used htmlwidget libraries and how to select an alternative visualisation library.
#'
#' @export
calendar_heatmap <- function(data,
                             library = "googleVis") {
  if (!library %in% c("googleVis", "rCharts")) {
    stop(paste(
      "The selected library is not supported, choose from; googleVis or rCharts"
    ))
  }

  viz.args <-
    mget(names(formals()), sys.frame(sys.nframe())) # http://stackoverflow.com/a/14398674/1659890

  switch (library,
          "googleVis" = googleViz_calendar_map(viz.args))

}


#' \code{hc_stacked_bar_chart} should not be used directly, it generates a stacked barchart using Plotly.
#' @rdname map-stacked-bar-chart
#' @param ... all arguments other than \code{data} and \code{library} provided to \code{stacked_bar_chart}.
googleViz_calendar_map <- function(...) {
  ## see https://developers.google.com/chart/interactive/docs/gallery/calendar
  #   gvisCalendar(
  #     data,
  #     options = list(
  #       width = width,
  #       height = height,
  #       colorAxis = "{colors: ['FFFFFF', 'A52A2A']}",
  #       noDataPattern = "{
  #       backgroundColor: '#76a7fa',
  #       color: '#a0c3ff'
  # }",
  #       gvis.listener.jscode = "
  #       var selected_date = data.getValue(chart.getSelection()[0].row,0);
  #       var parsed_date = selected_date.getFullYear()+'-'+(selected_date.getMonth()+1)+'-'+selected_date.getDate();
  #       Shiny.onInputChange('selected_date',parsed_date)"
  #     )
  #     )

  # TODO: Inform user that tooltips cannot be easily modified, outside of package scope.

  stop("not implemented yet")
}

#' \code{rcharts_calendar_map} should not be used directly, it generates a calendar heatmap using rCharts.
#' @rdname map-calendar-heatmap
#' @param ... all arguments other than \code{data} and \code{library} provided to \code{calendar_heatmap}.
rcharts_calendar_map <- function(...) {
  viz.args <- list(...)[[1]]
  data <- viz.args$data


}
