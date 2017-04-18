test_that("geo_marker_plot(library='leaflet') makes a leaflet object",
          {
            chart <- data_geo_marker_plot %>%
              geo_marker_plot(library = "leaflet")
            
            expect_true(all(class(chart) %in% c("leaflet",  "htmlwidget")))
            
          })
