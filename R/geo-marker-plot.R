#' Geo marker plot
#'
#' \code{geo_marker_plot} creates a geo scatter plot using the specified library, which can be used in the library's \%>\% workflow. Data must be provided in long format.
#'
#' @rdname map-geo-marker-plot
#' @import htmlwidgets
#' @import dplyr
#' @importFrom stats as.formula
#' @param data A dataframe, must be long-formatted.
#' @param library Which library to use, highchart is default.
#' @param popup.text  Content to display when a marker is clicked. Must be given as formula, i.e. ~country
#' @param mouseover.text  Content to display when the cursor passes over a marker. Must be given as formula, i.e. ~country
#' @export
#'
geo_marker_plot <- function(data = NA,
                         library = "leaflet",
                         popup.text = NULL,
                         mouseover.text = NULL) {
  ## check library is supported
  if (!library %in% c("leaflet")) {
    stop(paste(
      "The selected library is not supported, choose from; leaflet"
    ))
  }
  
  guess_latlons <- guessLatLongCols(colnames(data))
  
  
  viz.args <-
    mget(names(formals()), sys.frame(sys.nframe())) # http://stackoverflow.com/a/14398674/1659890
  
  viz.args$longitude <- as.formula(paste0("~",guess_latlons$lng))
  viz.args$latitude <- as.formula(paste0("~",guess_latlons$lat))
  
  switch (library,
          "leaflet" = leaflet_geo_marker_plot(viz.args))
}

#' \code{leaflet_stacked_bar_chart} should not be used directly, it generates a geo marker plot using leaflet.
#' @rdname map-geo-marker-plot
#' @param ... all arguments provided to \code{geo_marker_plot}.
leaflet_geo_marker_plot <- function(...) {
  viz.args <- list(...)[[1]]
  data <- viz.args$data
  
  data %>%
    leaflet() %>%
    addTiles() %>%
    addMarkers(lng = viz.args$longitude, 
               lat = viz.args$latitude,
               label = viz.args$mouseover.text,
               popup = viz.args$popup.text)
  
  
}