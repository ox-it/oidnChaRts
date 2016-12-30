test_that("stacked_bar_chart(library='highcharter') makes a highchart object",
          {
            hc <- stacked_bar_chart(
              data = data_stacked_bar_chart,
              library = "highcharter",
              categories.column = ~ country,
              value.column = ~ hours,
              subcategories.column = ~ activity
            )

            expect_true(all(class(hc) %in% c("highchart",  "htmlwidget")))

          })

test_that(
  "stacked_bar_chart(library='highcharter', return.data = TRUE) returns a data.frame",
  {
    hc <- stacked_bar_chart(
      data = data_stacked_bar_chart,
      library = "highcharter",
      categories.column = ~ country,
      value.column = ~ hours,
      subcategories.column = ~ activity,
      return.data = TRUE
    )

    expect_true(all(class(hc) %in% c("data.frame")))

  }
)


test_that("stacked_bar_chart(library='plotly') makes a plotly object", {
  chart <- stacked_bar_chart(
    data = data_stacked_bar_chart,
    library = "plotly",
    categories.column = ~ country,
    value.column = ~ hours,
    subcategories.column = ~ activity
  )

  expect_true(all(class(chart) %in% c("plotly",  "htmlwidget")))
})

test_that("stacked_bar_chart(library='plotly', stacking.type) makes a plotly object", {
  chart <- stacked_bar_chart(
    data = data_stacked_bar_chart,
    library = "plotly",
    categories.column = ~ country,
    value.column = ~ hours,
    subcategories.column = ~ activity,
    stacking.type = "percent"
  )

  expect_true(all(class(chart) %in% c("plotly",  "htmlwidget")))
})

test_that("stacked_bar_chart(library='highcharter', stacking.type) makes a highcharter object", {
  chart <- stacked_bar_chart(
    data = data_stacked_bar_chart,
    library = "highcharter",
    categories.column = ~ country,
    value.column = ~ hours,
    subcategories.column = ~ activity,
    stacking.type = "percent"
  )

  expect_true(all(class(chart) %in% c("highchart",  "htmlwidget")))
})

test_that(
  "stacked_bar_chart(library='highcharter', categories.order, subcategories.order) makes a highchart object",
  {
    activity_order <-
      c("Unclassified",
        "Business",
        "Overlay",
        "Personal Visit",
        "Teleconference")
    country_order <-
      c(
        "Canada",
        "China",
        "Egypt",
        "Estonia",
        "France",
        "Germany",
        "Ireland",
        "Saudi Arabia",
        "Slovakia",
        "United Kingdom"
      )

    hc <- stacked_bar_chart(
      data = data_stacked_bar_chart,
      library = "highcharter",
      categories.column = ~ country,
      categories.order = country_order,
      subcategories.column = ~ activity,
      value.column = ~ hours,
      subcategories.order = activity_order,
      stacking.type = "percent"
    )


    expect_true(all(class(hc) %in% c("highchart",  "htmlwidget")))

  }
)

test_that(
  "stacked_bar_chart(library='plotly', categories.order, subcategories.order) makes a plotly object",
  {
    activity_order <-
      c("Unclassified",
        "Business",
        "Overlay",
        "Personal Visit",
        "Teleconference")
    country_order <-
      c(
        "Canada",
        "China",
        "Egypt",
        "Estonia",
        "France",
        "Germany",
        "Ireland",
        "Saudi Arabia",
        "Slovakia",
        "United Kingdom"
      )

    hc <- stacked_bar_chart(
      data = data_stacked_bar_chart,
      library = "plotly",
      categories.column = ~ country,
      categories.order = country_order,
      subcategories.column = ~ activity,
      value.column = ~ hours,
      subcategories.order = activity_order
    )


    expect_true(all(class(hc) %in% c("plotly",  "htmlwidget")))

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
