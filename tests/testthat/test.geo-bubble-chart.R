test_that("geo_bubble_chart(library='leaflet') makes a leaflet object",
          {
            chart <- data_geo_bubble_chart %>%
              geo_bubble_chart(library = "leaflet",
                               bubble.group = ~country,
                               bubble.radius = ~count)
            
            expect_true(all(class(chart) %in% c("leaflet",  "htmlwidget")))
            
          })


test_that("geo_bubble_chart(library='highcharter') makes a highcharter object",
          {
            chart <- data_geo_bubble_chart %>%
              geo_bubble_chart(library = "highcharter",
                               bubble.group = ~country,
                               bubble.radius = ~count)
            
            expect_true(all(class(chart) %in% c("highchart",  "htmlwidget")))
            
          })

test_that("geo_bubble_chart(library='plotly') makes a plotly object",
          {
            chart <- data_geo_bubble_chart %>%
              geo_bubble_chart(library = "plotly",
                               bubble.group = ~country,
                               bubble.radius = ~count)
            
            expect_true(all(class(chart) %in% c("plotly",  "htmlwidget")))
            
          })
