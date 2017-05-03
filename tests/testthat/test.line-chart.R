test_that("line_chart(library='highcharter') makes a highchart object",
          {
            
            library("tidyverse")
            hc <- data_line_chart %>% mutate(color = plyr::mapvalues(
              trace,
              from = c("[MQ 16] Local", "[MQ 16] Thesaurus", "[MQ 1] Local", "[MQ 1] Thesaurus", "Mutect"),
              to = c("#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E")
            )) %>%
              line_chart(library = "highcharter",
                           x.column = ~x,
                           y.column = ~y,
                           color.column = ~color,
                           traces.column = ~trace)
            
            expect_true(all(class(hc) %in% c("highchart",  "htmlwidget")))
            
          })

test_that("line_chart(library='plotly') makes a plotly object",
          {
            chart <- data_line_chart %>% mutate(color = plyr::mapvalues(
              trace,
              from = c("[MQ 16] Local", "[MQ 16] Thesaurus", "[MQ 1] Local", "[MQ 1] Thesaurus", "Mutect"),
              to = c("#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E")
            )) %>%
              line_chart(library = "plotly",
                         x.column = ~x,
                         y.column = ~y,
                         color.column = ~color,
                         traces.column = ~trace)
            
            expect_true(all(class(chart) %in% c("plotly",  "htmlwidget")))
            
          })