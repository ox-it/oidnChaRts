## ------------------------------------------------------------------------
library(oidnChaRts)

## ------------------------------------------------------------------------




## ------------------------------------------------------------------------
library(highcharter)
line_chart(data = data_line_chart,
           library = "highcharter",
           x.column = ~af,
           y.column = ~fdr,
           traces.column = ~series) %>%
  hc_yAxis(
        type = "logarithmic",
        title = list(text = "FDR"),
        labels = list(
          formatter = JS(
            "function () {
            var label = this.axis.defaultLabelFormatter.call(this);
            return this.value.toExponential(2);
            }"
))) %>%
  hc_plotOptions(series = list(marker = list(symbol = "circle")))

