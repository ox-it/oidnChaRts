#' Geo bubble chart
#'
#' \code{geo_bubble_chart} creates a geo bubble chart using the specified library, which can be used in the library's \%>\% workflow. Data must be provided in long format.
#'
#' @rdname map-geo-bubble-chart
#' @import htmlwidgets
#' @import dplyr
#' @importFrom stats as.formula
#' @param data A dataframe, must be long-formatted.
#' @param library Which library to use, highchart is default.
#' @param bubble.radius Column containing the bubble radius for each point. Must be given as formula, i.e. ~radius
#' @param popup.text  Content to display when a marker is clicked. Must be given as formula, i.e. ~country
#' @param mouseover.text  Content to display when the cursor passes over a marker. Must be given as formula, i.e. ~country
#' @export
#'
geo_bubble_chart <- function(data = NA,
                            library = "leaflet",
                            bubble.radius = ~radius,
                            bubble.group,
                            bubble.opacity = 0.6,
                            color = ~color,
                            popup.text = NULL,
                            mouseover.text = NULL) {
  ## check library is supported
  if (!library %in% c("leaflet", "highcharter", "plotly")) {
    stop(paste(
      "The selected library is not supported, choose from; leaflet, highcharter, plotly"
    ))
  }
  
  guess_latlons <- guessLatLongCols(colnames(data))
  
  
  viz.args <-
    mget(names(formals()), sys.frame(sys.nframe())) # http://stackoverflow.com/a/14398674/1659890
  
  # viz.args$longitude <- as.formula(paste0("~",guess_latlons$lng))
  # viz.args$latitude <- as.formula(paste0("~",guess_latlons$lat))
  
  viz.args$longitude <- guess_latlons$lng
  viz.args$latitude <- guess_latlons$lat
  
  switch (library,
          "leaflet" = leaflet_geo_bubble_chart(viz.args),
          "highcharter" = hc_geo_bubble_chart(viz.args),
          "plotly" = plotly_geo_bubble_chart(viz.args))
}

#' \code{leaflet_geo_bubble_chart} should not be used directly, it generates a geo bubble plot using leaflet.
#' @rdname map-geo-bubble-chart
#' @param ... all arguments provided to \code{geo_bubble_chart}.
leaflet_geo_bubble_chart <- function(...) {
  viz.args <- list(...)[[1]]
  data <- viz.args$data
  
  color_list <- data %>%
    select_(f_text(viz.args$color)) %>%
    unique() %>%
    .[[1]]
  
  group_list <- data %>%
    select_(f_text(viz.args$bubble.group)) %>%
    unique() %>%
    .[[1]]
  
  data %>%
  leaflet() %>%
    addTiles() %>%
    addCircleMarkers(
      lng = as.formula(paste0("~", viz.args$longitude)), 
      lat = as.formula(paste0("~", viz.args$latitude)),
      radius = viz.args$bubble.radius, 
                     stroke = TRUE, 
                     fill = TRUE,
                     color = viz.args$color,
                     weight = 1,
                     fillColor = viz.args$color,
                     fillOpacity = viz.args$bubble.opacity,
                     label = viz.args$mouseover.text,
                     popup = viz.args$popup.text) %>%
    addLegend(colors = color_list,
              labels = group_list)
}


#' \code{hc_geo_bubble_chart} should not be used directly, it generates a geo bubble plot using highcharter.
#' @rdname map-geo-bubble-chart
#' @param ... all arguments provided to \code{geo_bubble_chart}.
hc_geo_bubble_chart <- function(...) {
  viz.args <- list(...)[[1]]
  data <- viz.args$data
  
  
  chr_bubble_radius <- f_text(viz.args$bubble.radius)
  chr_bubble_group <- f_text(viz.args$bubble.group)

  ## TODO: When hcaes support NSE change this as ugly
  data <- data %>%
    rename_("lat" = viz.args$latitude,
            "lon" = viz.args$longitude,
            "z" = chr_bubble_radius,
            "group" = chr_bubble_group)
  
  hcmap(showInLegend = FALSE) %>%
    hc_add_series(data = data,
                  type = "mapbubble",
                  hcaes(group = group))
 
}


#' \code{plotly_geo_bubble_chart} should not be used directly, it generates a geo bubble plot using plotly
#' @rdname map-geo-bubble-chart
#' @param ... all arguments provided to \code{geo_bubble_chart}.
plotly_geo_bubble_chart <- function(...) {
  viz.args <- list(...)[[1]]
  data <- viz.args$data

  the_colors <- unique(data$color)
  
  data %>%
    group_by_(f_text(viz.args$bubble.group)) %>%
    plot_geo(lat = as.formula(paste0("~", viz.args$latitude)),
             lon = as.formula(paste0("~", viz.args$longitude))
    ) %>%
    add_markers(size = viz.args$bubble.radius,
                marker = list(opacity = viz.args$bubble.opacity),
                color = viz.args$bubble.group,
                colors = the_colors,
                text = viz.args$mouseover.text)
  
}