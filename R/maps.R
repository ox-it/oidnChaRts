#' geo_lines_map
#'
#' \code{geo_lines_map} creates a map with lines (great circles) between geo graphic locations using the specified library, which can be used in the library's \%>\% workflow. Data must be provided in long format.
#'
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
    if(!library %in% c("leaflet")){
      stop(paste("The selected library is not supported, choose from; leaflet."))
    }

    optnl.args <-
      mget(names(formals()), sys.frame(sys.nframe())) # http://stackoverflow.com/a/14398674/1659890
    switch(
      library,
      "leaflet" = leaflet_geo_lines_map(data = data,
                                        optnl.args = optnl.args)
    )
  }

#' leaflet_geo_lines_map
leaflet_geo_lines_map <- function(data = NA,
                                  optnl.args = NA) {
  geo_lines <- gcIntermediate(
    data %>%
      select(sender.longitude, sender.latitude),
    data %>%
      select(receiver.longitude, receiver.latitude),
    sp = TRUE,
    addStartEnd = TRUE
  )

  leaflet() %>%
    addTiles() %>%
    addPolylines(
      data = geo_lines,
      color = optnl.args$line.color,
      popup = if (is.null(optnl.args$line.popup)) {
        NULL
      } else
        f_eval(optnl.args$line.popup, data),
      weight = optnl.args$line.options$weight
    ) %>%
    addCircleMarkers(
      data = data,
      lng = ~ sender.longitude,
      lat = ~ sender.latitude,
      fill = optnl.args$termini.options$sender.fill,
      radius = optnl.args$termini.options$sender.radius,
      stroke = TRUE,
      color = optnl.args$sender.color,
      opacity = 0.6
    ) %>%
    addCircleMarkers(
      data = data,
      lng = ~ receiver.longitude,
      lat = ~ receiver.latitude,
      fill = optnl.args$termini.options$receiver.fill,
      radius = optnl.args$termini.options$receiver.radius,
      stroke = TRUE,
      color = optnl.args$receiver.color,
      opacity = 0.6
    )

}
