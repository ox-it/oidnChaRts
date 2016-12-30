test_that("geo_lines_map(library='leaflet') makes a Leaflet object", {

  leaflet_map <- geo_lines_map(data_geo_lines_map,
                      library = "leaflet")

  expect_true(all(class(leaflet_map) %in% c("leaflet",  "htmlwidget")))

})

test_that(
  "geo_lines_map(library='foobar') returns a warning that this library is not currently supported",
  {
    expect_error(
      geo_lines_map(data = data_geo_lines_map,
                        library = "foobar"),
      "The selected library is not supported, choose from; leaflet."
    )

  }
)
