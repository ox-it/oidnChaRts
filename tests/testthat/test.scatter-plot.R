test_that("scatter_plot(library='highcharter') makes a highchart object",
          {
            hc <- data_scatter_plot %>% mutate(color = plyr::mapvalues(
              type,
              from = c("Discordant", "Concordant"),
              to = c(rgb(251, 106, 74, max = 255), rgb(203, 24, 29, max = 255))
            )) %>%
              scatter_plot(library = "highcharter",
                           x.column = ~x,
                           y.column = ~y,
                           color.column = ~color,
                           traces.column = ~type)
            
            expect_true(all(class(hc) %in% c("highchart",  "htmlwidget")))
            
          })

test_that("scatter_plot(library='plotly') makes a plotly object",
          {
            chart <- data_scatter_plot %>% mutate(color = plyr::mapvalues(
              type,
              from = c("Discordant", "Concordant"),
              to = c(rgb(251, 106, 74, max = 255), rgb(203, 24, 29, max = 255))
            )) %>%
              scatter_plot(library = "plotly",
                           x.column = ~x,
                           y.column = ~y,
                           color.column = ~color,
                           traces.column = ~type)
            
            expect_true(all(class(chart) %in% c("plotly",  "htmlwidget")))
            
          })