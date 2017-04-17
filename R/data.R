#' Stacked bar chart data
#'
#' A (long-formatted) dataset sourced from https://doi.org/10.6084/m9.figshare.3761562 which demonstrates the utility of grouped and stacked bar charts for comparing datasets which contain two-levels of categorisation, i.e. which types of jobs are most often listed on freelance websites in each continent?
#'
#' @format A data frame with 691 rows and 5 variables:
#' \describe{
#'   \item{timestamp}{Date when the Online Labour Index was sampled for projects, this date is updated at least as often as every new releaste of the oidnChaRts library}
#'   \item{count}{Number of job adverts on the freelancer websites}
#'   \item{country}{Country listed for job poster}
#'   \item{country_group}{groupings determined by the researchers, i.e. "other Europe" and "all Africa"}
#'   \item{occupation}{classification of the job posting}
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

#' Scatter plot data
#'
#' A (long-formatted) dataset designed to demonstrate different options for scatter plot
#'
#' @format A data frame with 2163 rows and 7 variables:
#' \describe{
#'   \item{chromosome}{Chromosome and genomic position of gene}
#'   \item{type}{Concordant (both sites are identical) or Discordant (mutations only in one replicate)}
#'   \item{x}{Allelic frequencies of gene in replicate 1}
#'   \item{y}{Allelic frequencies of gene in replicate 2}
#' }
#' @source \url{https://dx.doi.org/10.6084/m9.figshare.4555441.v1}
"data_scatter_plot"


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
