#' Learning non-standard evaluation
#'
#' \code{fancy_chart} is not to be used, it is only a place to learn non-standard evaluation.
#'
#'
#' @export

fancy_chart <- function(data = NA, library = "plotly", x.axis = NA, y.axis = NA, ...){
  chart_options <- mget(names(formals()),sys.frame(sys.nframe()))
  switch(
    library,
    "ggplot2" = {
      # print(fancy_chart_options)
      ggplot_fancy_chart(data, chart_options)
    },
    "highcharter"
  )
}

ggplot_fancy_chart <- function(data = NA, chart_options = NA){
  print(f_eval(chart_options$x.axis, data))
  ggplot(data, aes(x = f_eval(chart_options$x.axis, data), y = f_eval(chart_options$x.axis, data))) + geom_point()
}

# ## Call the function
# fancy_chart(data = iris, library = "ggplot2", x.axis = ~Petal.Length, y.axis = ~Sepal.Length, send.arg = 5, receive.list = list(arg1 = 1))

