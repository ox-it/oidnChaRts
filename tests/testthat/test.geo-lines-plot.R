test_that("geo_lines_plot(library='leaflet') makes a leaflet object",
          {
            chart <- data_geo_lines_plot %>%
              geo_lines_plot(library = "leaflet")
            
            expect_true(all(class(chart) %in% c("leaflet",  "htmlwidget")))
            
          })
