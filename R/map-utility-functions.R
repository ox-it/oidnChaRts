# Given the names of a data frame, list, matrix, etc., take a guess at
# which columns represent latitude and longitude.
# Taken verbatim from the leaflet library, see https://github.com/rstudio/leaflet/blob/24a7dfa68528e32265aa325610eca7f8fa7a8050/R/normalize.R
guessLatLongCols <- function(names, stopOnFailure = TRUE) {
  
  lats = names[grep("^(lat|latitude)$", names, ignore.case = TRUE)]
  lngs = names[grep("^(lon|lng|long|longitude)$", names, ignore.case = TRUE)]
  
  if (length(lats) == 1 && length(lngs) == 1) {
    if (length(names) > 2) {
      message("Assuming '", lngs, "' and '", lats,
              "' are longitude and latitude, respectively")
    }
    return(list(lng = lngs, lat = lats))
  }
  
  # TODO: More helpful error message with appropriate next steps
  if (stopOnFailure) {
    stop("Couldn't infer longitude/latitude columns. Ensure your dataset includes both the following: \nsingle column called either lat, latitude. \nsingle column called either lon, lng, long, longitude")
  }
  
  list(lng = NA, lat = NA)
}

# Generates lines between two geo-locations, using the geosphere library
geo_lines <- function(data, addStartEnd = TRUE, intermediate.points = 50){
  gcLines <- geosphere::gcIntermediate(
    data %>%
      select_("start.longitude", "start.latitude"),
    data %>%
      select_("end.longitude", "end.latitude"),
    n = intermediate.points,
    sp = TRUE,
    addStartEnd = addStartEnd
  )
  
  sp::SpatialLinesDataFrame(gcLines, data = data)
}

