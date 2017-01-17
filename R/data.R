#' Stacked bar chart data
#'
#' A (long-formatted) dataset designed to demonstrate different options for stacked bar charts.
#'
#' @format A data frame with 10 rows and 6 variables:
#' \describe{
#'   \item{country}{country where activity took place}
#'   \item{activity}{type of activity}
#'   \item{hours}{hours spent performing activity}
#' }
#' @source \url{http://www.diamondse.info/}
"data_stacked_bar_chart"

#' Line chart data
#'
#' A (long-formatted) dataset designed to demonstrate different options for line charts.
#'
#' @format A data frame with 35 rows and 4 variables:
#' \describe{
#'   \item{series}{Different series (analagous to different traces/lines in the chart)}
#'   \item{af}{x-values in sample charts}
#'   \item{fdr}{y-values in sample charts}
#'   \item{tpr}{y-values in sample charts}
#'   \item{color}{color for the trace/line}
#' }
#' @source \url{https://dx.doi.org/10.6084/m9.figshare.4555441.v1}
"data_line_chart"

#' Geolines data
#'
#' A (long-formatted) dataset designed to demonstrate different options for geoline charts (great circles between points on a map).
#' The dataset has been based on an academic dataset that will be cited after the embargo period has come to an end.
#'
#' @format A data frame with 617 rows and 9 variables:
#' \describe{
#'   \item{sender.location}{Country, City}
#'   \item{sender.latitude}{Sender latitude}
#'   \item{sender.longitude}{Sender longitude}
#'   \item{receiver.latitude}{Receiver latitude}
#'   \item{receiver.longitude}{Receiver longitude}
#'   \item{receiver.location}{Country, City}
#'   \item{date}{YYYY-MM-DD}
#'   \item{journey}{Concatenated sender - receiver coordinate}
#'   \item{number.of.letters}{Number of letters sent across route}
#'   ...
#' }
#' @source \url{http://www.idn.it.ox.ac.uk}
"data_geo_lines_map"

#' Geopoints data
#'
#' A (long-formatted) dataset designed to demonstrate different options for geoline charts (great circles between points on a map).
#' The dataset has been based on an academic dataset that will be cited after the embargo period has come to an end.
#'
#' @format A data frame with 617 rows and 9 variables:
#' \describe{
#'   \item{sender.location}{Country, City}
#'   \item{sender.latitude}{Sender latitude}
#'   \item{sender.longitude}{Sender longitude}
#'   \item{receiver.latitude}{Receiver latitude}
#'   \item{receiver.longitude}{Receiver longitude}
#'   \item{receiver.location}{Country, City}
#'   \item{date}{YYYY-MM-DD}
#'   \item{journey}{Concatenated sender - receiver coordinate}
#'   \item{number.of.letters}{Number of letters sent across route}
#'   ...
#' }
#' @source \url{http://www.idn.it.ox.ac.uk}
"data_geo_lines_map"
