#' geo_lines_map
#'
#' \code{geo_lines_map} creates a map with lines (great circles) between geo graphic locations using the specified library, which can be used in the library's \%>\% workflow. Data must be provided in long format.
#'
#' @rdname map-geo-lines-map
#' @param data A data.frame with sender-receiver pairs, needs the following columns
#' \itemize{
#'  \item{"sender.longitude"}{ : sender longitude}
#'  \item{"sender.latitude"}{ : sender latitude}
#'  \item{"receiver.longitude"}{ : receiver longitude}
#'  \item{"receiver.latitude"}{ : receiver latitude}
#'  }
#'
#' @param library must be one of the supported libraries, currently; "leaflet". Defaults to "leaflet".
#' @param line.color color for the geolines (great circles), defaults to #2c7bb6
#' @param line.popup expression used to populate popups displayed when a geoline is clicked, can use models/formula. For instance, ~paste(sender.longitude, receiver.longitude)
#' @param sender.color color of the dots representing sender locations, defaults to #fdae61
#' @param receiver.color color of the dots representing receiver locations, defaults to #d7191c
#' @param line.options named list of options for geolines
#' @param termini.options named list of options for the termini (sender/receiver dots)
#' \itemize{
#'   \item{sender.fill}{ : Fill sender termini? TRUE or FALSE, default FALSE.}
#'   \item{receiver.fill}{ : Fill receiver termini? TRUE or FALSE, default TRUE.}
#'   \item{sender.radius}{ : size of sender termini.}
#'   \item{receiver.radius}{ : size of sender termini.}
#'  }
#'
#' @export
geo_lines_map <-
  function(data = NA,
           library = "leaflet",
           line.color = "#2c7bb6",
           line.popup = NULL,
           sender.color = "#fdae61",
           receiver.color = "#d7191c",
           line.options = list(weight = 4),
           termini.options = list(
             sender.fill = FALSE,
             receiver.fill = TRUE,
             sender.radius = 1.2,
             receiver.radius = 1.2
           )) {
    ## check library is supported
    if (!library %in% c("leaflet")) {
      stop(paste("The selected library is not supported, choose from; leaflet."))
    }

    viz.args <-
      mget(names(formals()), sys.frame(sys.nframe())) # http://stackoverflow.com/a/14398674/1659890
    switch(library,
           "leaflet" = leaflet_geo_lines_map(viz.args))
  }


#' \code{leaflet_geo_lines_map} should not be used directly, it generates a map with great circles between points using Leaflet.
#' @rdname map-geo-lines-map
#' @param ... all arguments other than \code{data} and \code{library} provided to \code{geo_lines_map}.
leaflet_geo_lines_map <- function(...) {

  viz.args <- list(...)[[1]]
  data <- viz.args$data

  geo_lines <- geosphere::gcIntermediate(
    data %>%
      select_("sender.longitude", "sender.latitude"),
    data %>%
      select_("receiver.longitude", "receiver.latitude"),
    sp = TRUE,
    addStartEnd = TRUE
  )

  leaflet() %>%
    addTiles() %>%
    addPolylines(
      data = geo_lines,
      color = viz.args$line.color,
      popup = if (is.null(viz.args$line.popup)) {
        NULL
      } else
        f_eval(viz.args$line.popup, data),
      weight = viz.args$line.options$weight
    ) %>%
    addCircleMarkers(
      data = data,
      lng = as.formula("~sender.longitude"),
      lat = as.formula("~sender.latitude"),
      fill = viz.args$termini.options$sender.fill,
      radius = viz.args$termini.options$sender.radius,
      stroke = TRUE,
      color = viz.args$sender.color,
      opacity = 0.6
    ) %>%
    addCircleMarkers(
      data = data,
      lng = as.formula("~receiver.longitude"),
      lat = as.formula("~receiver.latitude"),
      fill = viz.args$termini.options$receiver.fill,
      radius = viz.args$termini.options$receiver.radius,
      stroke = TRUE,
      color = viz.args$receiver.color,
      opacity = 0.6
    )
}


## TODO: Generalise addLegendCustom
#' addLegendCustom
# addLegendCustom <-
#   function(map, colors, labels, sizes, opacity = 0.5) {
#     ## Inspired by http://stackoverflow.com/a/37482936/1659890
#     colorAdditions <-
#       paste0(colors, "; width:", sizes, "px; height:", sizes, "px")
#     labelAdditions <-
#       paste0(
#         "<div style='display: inline-block;height: ",
#         sizes,
#         "px;margin-top: 4px;line-height: ",
#         sizes,
#         "px;'>",
#         labels,
#         "</div>"
#       )
#
#     return(addLegend(
#       map,
#       colors = colorAdditions,
#       labels = labelAdditions,
#       opacity = opacity
#     ))
#   }
#
# #' leaflet_termini_legend
# leaflet_termini_legend <- function(map = NA,
#                                    colors = NA,
#                                    viz.args = NA) {
#   map %>%
#     addLegendCustom(
#       colors = c("#fdae61", "#d7191c"),
#       labels = c("Sender", "Receiver"),
#       sizes = c(10, 10)
#     )
# }
