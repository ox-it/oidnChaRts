#' geo_choropleth_chart
#'
#' \code{geo_choropleth_chart} creates a map comprised of shaded regions (where colour is used to allow visual comparison betweem region) using the specified library, which can be used in the library's \%>\% workflow. Data must be provided in long format.
#'
#' @rdname map-geo-choropleth-chart
#' @import htmltools
#' @param spdf A SpatialPolygonsDataFrame
#' 
#'
#' @export
geo_choropleth_chart <-
  function(spdf = NA,
           library = "leaflet",
           line.color = "#2c7bb6",
           line.popup = NULL,
           line.mouseover = NULL,
           start.color = "#fdae61",
           end.color = "#d7191c",
           both.color = "#7570b3",
           line.options = list(weight = 4),
           termini.legend = TRUE,
           termini.options = list(
             termini.radius = 4
           )) {
    ## check library is supported
    if (!library %in% c("leaflet")) {
      stop(paste("The selected library is not supported, choose from; leaflet."))
    }
    
    viz.args <-
      mget(names(formals()), sys.frame(sys.nframe())) # http://stackoverflow.com/a/14398674/1659890
    
    switch(library,
           "leaflet" = leaflet_geo_choropleth_chart(viz.args))
  }

#' \code{journey_termini_data} should not be used directly.
journey_termini_data <- function(data) {
  end_points <- data %>%
    group_by(end.location) %>%
    mutate(end.frequency = n()) %>%
    ungroup() %>%
    select(contains("end")) %>%
    unique() %>%
    rename(
      location.name = end.location,
      latitude = end.latitude,
      longitude = end.longitude
    )
  
  start_points <- data %>%
    group_by(start.location) %>%
    mutate(start.frequency = n()) %>%
    ungroup() %>%
    select(contains("start")) %>%
    unique() %>%
    rename(
      location.name = start.location,
      latitude = start.latitude,
      longitude = start.longitude
    )
  
  suppressMessages(full_join(end_points, start_points))
}

#' \code{leaflet_geo_choropleth_chart} should not be used directly, it generates a map with great circles between points using Leaflet.
#' @rdname map-geo-choropleth-chart
#' @param ... all arguments other than \code{data} and \code{library} provided to \code{geo_choropleth_chart}.
leaflet_geo_choropleth_chart <- function(...) {
  
  viz.args <- list(...)[[1]]
  data <- viz.args$data
  
  ## generate start_only_markers
  start_only_markers <- function(map, termini.data) {
    start.only.locs <- journey_termini_data(termini.data) %>%
      filter(start.frequency > 0 & is.na(end.frequency))
    
    addCircleMarkers(
      map,
      data = start.only.locs,
      fill = TRUE,
      radius = viz.args$termini.options$termini.radius,
      stroke = FALSE,
      color = viz.args$start.color,
      popup = ~ paste0(
        "<p>Start Location: ",
        location.name,
        "</p>",
        "<p>Number of times appears as start location: ",
        start.frequency,
        "</p>"
      )
    )
  }
  
  end_only_markers <- function(map, termini.data) {
    end.only.locs <- journey_termini_data(termini.data) %>%
      filter(end.frequency > 0 & is.na(start.frequency))
    
    addCircleMarkers(
      map,
      data = end.only.locs,
      fill = TRUE,
      radius = viz.args$termini.options$termini.radius,
      stroke = FALSE,
      color = viz.args$end.color,
      popup = ~ paste0(
        "<p>End Location: ",
        location.name,
        "</p>",
        "<p>Number of times appears as start location: ",
        end.frequency,
        "</p>"
      )
    )
  }
  
  two_way_markers <- function(map, termini.data) {
    receive.only.locs <- journey_termini_data(termini.data) %>%
      filter(start.frequency > 0 & end.frequency > 0)
    
    addCircleMarkers(
      map,
      data = receive.only.locs,
      fill = TRUE,
      radius = viz.args$termini.options$termini.radius,
      stroke = FALSE,
      color = viz.args$both.color,
      popup = ~ paste0(
        "<p>Two-way Location: ",
        location.name,
        "</p>",
        "<p>Number of times appears as end location: ",
        end.frequency,
        "</p>",
        "<p>Number of times appears as start location: ",
        start.frequency,
        "</p>"
      )
    )
  }
  
  
  
  leaflet_geolines <- leaflet() %>%
    addTiles() %>%
    addPolylines(
      data = geo_lines(data), # geo_lines is in map-utility-functions
      color = viz.args$line.color,
      popup = viz.args$line.popup,
      label = viz.args$line.mouseover,
      weight = viz.args$line.options$weight
    ) %>%
    start_only_markers(data) %>%
    end_only_markers(data) %>%
    two_way_markers(data)
  
  if(viz.args$termini.legend){
    
    addLegendCustom <-
      function(map, colors, labels, sizes, opacity = 0.5) {
        ## Inspired by http://stackoverflow.com/a/37482936/1659890
        colorAdditions <-
          paste0(colors, "; width:", sizes, "px; height:", sizes, "px")
        labelAdditions <-
          paste0(
            "<div style='display: inline-block;height: ",
            sizes,
            "px;margin-top: 4px;line-height: ",
            sizes,
            "px;'>",
            labels,
            "</div>"
          )
        
        return(addLegend(
          map,
          colors = colorAdditions,
          labels = labelAdditions,
          opacity = opacity
        ))
      }
    
    leaflet_geolines %>%
      addLegendCustom(
        colors = c(viz.args$start.color, viz.args$end.color, viz.args$both.color),
        labels = c("start", "end", "both"),
        sizes = c(10, 10, 10)
      )
    
    ## TODO: Add this css to make legend icons circles
    #  ".leaflet .legend i{
    #  border-radius: 50%;
    #                               width: 10px;
    #                               height: 10px;
    #                               margin-top: 4px;
    # }"
    
  } else {
    leaflet_geolines
  }
  
}
