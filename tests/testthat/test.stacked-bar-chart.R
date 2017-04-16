test_that("stacked_bar_chart(library='highcharter') makes a highchart object",
          {
            hc <- data_stacked_bar_chart %>%
              group_by(country_group, occupation) %>%
              summarise(total = sum(count)) %>%
              ungroup() %>%
              stacked_bar_chart(
              library = "highcharter",
              categories.column = ~ country_group,
              value.column = ~ total,
              subcategories.column = ~ occupation
            )
            
            expect_true(all(class(hc) %in% c("highchart",  "htmlwidget")))
            
          })


test_that("stacked_bar_chart(library='plotly') makes a plotly object", {
  chart <- data_stacked_bar_chart %>%
    group_by(country_group, occupation) %>%
    summarise(total = sum(count)) %>%
    ungroup() %>%
    stacked_bar_chart(
      library = "plotly",
      categories.column = ~ country_group,
      value.column = ~ total,
      subcategories.column = ~ occupation
    )
  expect_true(all(class(chart) %in% c("plotly",  "htmlwidget")))
})

test_that("stacked_bar_chart(library='plotly', stacking.type) makes a plotly object", {
  chart <- data_stacked_bar_chart %>%
    group_by(country_group, occupation) %>%
    summarise(total = sum(count)) %>%
    ungroup() %>%
    stacked_bar_chart(
      library = "plotly",
      stacking.type = "percent",
      categories.column = ~ country_group,
      value.column = ~ total,
      subcategories.column = ~ occupation
    )
  
  expect_true(all(class(chart) %in% c("plotly",  "htmlwidget")))
})

test_that("stacked_bar_chart(library='highcharter', stacking.type) makes a highcharter object", {
  chart <- data_stacked_bar_chart %>%
    group_by(country_group, occupation) %>%
    summarise(total = sum(count)) %>%
    ungroup() %>%
    stacked_bar_chart(
      library = "highcharter",
      stacking.type = "percent",
      categories.column = ~ country_group,
      value.column = ~ total,
      subcategories.column = ~ occupation
    )
  
  expect_true(all(class(chart) %in% c("highchart",  "htmlwidget")))
})

test_that(
  "stacked_bar_chart(library='highcharter', categories.order, subcategories.order) makes a highchart object",
  {
    descending_order_of_occupations <- data_stacked_bar_chart %>%
      group_by(country_group, occupation) %>%
      mutate(total = sum(count)) %>%
      mutate(total.in.group = sum(total)) %>%
      arrange(desc(total.in.group)) %>%
      ungroup() %>%
      select(occupation) %>%
      unique() %>%
      .[[1]]
    
    descending_order_of_regions <- data_stacked_bar_chart %>%
      group_by(country_group, occupation) %>%
      summarise(total = sum(count)) %>%
      mutate(total.in.group = sum(total)) %>%
      arrange(desc(total.in.group)) %>%
      select(country_group) %>%
      unique() %>%
      .[[1]]
    
    hc <- data_stacked_bar_chart %>%
      group_by(country_group, occupation) %>%
      summarise(total = sum(count)) %>%
      ungroup() %>%
      stacked_bar_chart(library = "highcharter",
                        categories.column = ~country_group,
                        categories.order = descending_order_of_regions,
                        subcategories.column = ~occupation,
                        subcategories.order = descending_order_of_occupations,
                        value.column = ~total)
    
    expect_true(all(class(hc) %in% c("highchart",  "htmlwidget")))
    
  }
)

test_that(
  "stacked_bar_chart(library='plotly', categories.order, subcategories.order) makes a plotly object",
  {
    descending_order_of_occupations <- data_stacked_bar_chart %>%
      group_by(country_group, occupation) %>%
      mutate(total = sum(count)) %>%
      mutate(total.in.group = sum(total)) %>%
      arrange(desc(total.in.group)) %>%
      ungroup() %>%
      select(occupation) %>%
      unique() %>%
      .[[1]]
    
    descending_order_of_regions <- data_stacked_bar_chart %>%
      group_by(country_group, occupation) %>%
      summarise(total = sum(count)) %>%
      mutate(total.in.group = sum(total)) %>%
      arrange(desc(total.in.group)) %>%
      select(country_group) %>%
      unique() %>%
      .[[1]]
    
    chart <- data_stacked_bar_chart %>%
      group_by(country_group, occupation) %>%
      summarise(total = sum(count)) %>%
      ungroup() %>%
      stacked_bar_chart(library = "plotly",
                        categories.column = ~country_group,
                        categories.order = descending_order_of_regions,
                        subcategories.column = ~occupation,
                        subcategories.order = descending_order_of_occupations,
                        value.column = ~total)
    
    expect_true(all(class(chart) %in% c("plotly",  "htmlwidget")))
    
  }
)

test_that(
  "stacked_bar_chart(library='foobar') returns a warning that this library is not currently supported",
  {
    expect_error(
      stacked_bar_chart(data = data_stacked_bar_chart,
                        library = "foobar"),
      "The selected library is not supported, choose from; leaflet or plotly"
    )
    
  }
)
