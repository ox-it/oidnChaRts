test_that("geo_bubble_chart(library='leaflet') makes a leaflet object",
          {
            chart <- data_geo_bubble_chart %>%
              filter(count > 5) %>%
              mutate(count = scales::rescale(count, to = c(3,20))) %>%
              mutate(color = plyr::mapvalues(
                country,
                from = unique(country),
                to = RColorBrewer::brewer.pal(length(unique(country)), "Dark2")
              )) %>%
              geo_bubble_chart(
                library = "leaflet",
                bubble.radius = ~count,
                bubble.group = ~country,
                color = ~color
              )
            
            expect_true(all(class(chart) %in% c("leaflet",  "htmlwidget")))
            
          })


test_that("geo_bubble_chart(library='highcharter') makes a highcharter object",
          {
            chart <- data_geo_bubble_chart %>%
              filter(count > 5) %>%
              mutate(count = scales::rescale(count, to = c(3,20))) %>%
              mutate(color = plyr::mapvalues(
                country,
                from = unique(country),
                to = RColorBrewer::brewer.pal(length(unique(country)), "Dark2")
              )) %>%
              geo_bubble_chart(
                library = "highcharter",
                bubble.radius = ~count,
                bubble.group = ~country,
                color = ~color
              )
            
            expect_true(all(class(chart) %in% c("highchart",  "htmlwidget")))
            
          })

test_that("geo_bubble_chart(library='plotly') makes a plotly object",
          {
            chart <- data_geo_bubble_chart %>%
              filter(count > 5) %>%
              mutate(count = scales::rescale(count, to = c(3,20))) %>%
              mutate(color = plyr::mapvalues(
                country,
                from = unique(country),
                to = RColorBrewer::brewer.pal(length(unique(country)), "Dark2")
              )) %>%
              geo_bubble_chart(
                library = "plotly",
                bubble.radius = ~count,
                bubble.group = ~country,
                color = ~color
              )
            
            expect_true(all(class(chart) %in% c("plotly",  "htmlwidget")))
            
          })
