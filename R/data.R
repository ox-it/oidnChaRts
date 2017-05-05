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


#' Geo Marker plot data
#'
#' A (long-formatted) dataset designed to demonstrate different options for geo marker plots.
#' The dataset has been based on an academic dataset that will be published here https://doi.org/10.6084/m9.figshare.4516772
#'
#' @format A data frame with 157 rows and 5 variables:
#' \describe{
#'   \item{country}{Country in which point resides}
#'   \item{city}{City in which point resides, with state name in brackets where appropriate}
#'   \item{latitude}{latitude}
#'   \item{longitude}{longitude}
#'   \item{count}{Number of events at the location}
#' }
#' @source \url{https://doi.org/10.6084/m9.figshare.4516772}
"data_geo_marker_plot"

#' Geo bubble chart data
#'
#' A (long-formatted) dataset designed to demonstrate different options for geo bubble charts.
#' The dataset has been based on an academic dataset that will be published here https://doi.org/10.6084/m9.figshare.4516772
#'
#' @format A data frame with 157 rows and 5 variables:
#' \describe{
#'   \item{country}{Country in which point resides}
#'   \item{city}{City in which point resides, with state name in brackets where appropriate}
#'   \item{latitude}{latitude}
#'   \item{longitude}{longitude}
#'   \item{count}{Number of events at the location}
#' }
#' @source \url{https://doi.org/10.6084/m9.figshare.4516772}
"data_geo_bubble_chart"


#' Geolines data
#'
#' A (long-formatted) dataset designed to demonstrate different options for geoline charts (great circles between points on a map).
#' The dataset has been based on an academic dataset that will be cited after the embargo period has come to an end.
#'
#' @format A data frame with 617 rows and 9 variables:
#' \describe{
#'   \item{sender.location}{Country, City}
#'   \item{start.latitude}{start latitude}
#'   \item{start.longitude}{start longitude}
#'   \item{end.latitude}{end latitude}
#'   \item{end.longitude}{end longitude}
#'   \item{end.location}{Country, City}
#'   \item{date}{YYYY-MM-DD}
#'   \item{journey}{Concatenated start - end coordinate}
#'   \item{number.of.letters}{Number of letters sent across route}
#'   ...
#' }
#' @source \url{http://www.idn.it.ox.ac.uk}
"data_geo_lines_plot"

#' World Shapefiles
#'
#' A SpatialPolygonsDataFrame dataset sourced from http://www.naturalearthdata.com/downloads/50m-cultural-vectors/ which includes shapefiles for all countries, with a scale of 1:50m.
#' 
#' Note that data_world_shapefiles@data is a data.frame containing exclusively identifying information about each country, i.e. it does not contain any information on the population or other metrics of the country.
#' 
#' At present, the best way to subset SpatialPolygonsDataFrame objects is with base R, i.e. data_world_shapefiles[data_world_shapefiles$continent %in% c("Asia"), ] will return only those countries where the continent is listed as "Asia".
#'
#'
#' @format A SpatialPolygonsDataFrame with 241 elements, the @data subcomponent is a data.frame containing 241 observatiosn with 9 variables:
#' \describe{
#'   \item{timestamp}{Date when the Online Labour Index was sampled for projects, this date is updated at least as often as every new releaste of the oidnChaRts library}
#'   \item{name}{Abbreviated Name of the country, i.e. N. Mariana Is. vs Northern Mariana Islands}
#'   \item{name_long}{Full name of the country, i.e. N. Mariana Is. vs Northern Mariana Islands}
#'   \item{type}{Type of country, i.e. Sovereign country, Dependency, etc}
#'   \item{continent}{Continent country belongs to}
#'   \item{region_un}{Region assignment from the UN}
#'   \item{subregion}{Subregion country belongs to, as per UN}
#'   \item{sovereignt}{Full name of country holding sovereignty over the country}
#'   \item{subunit}{UN subunit the country belongs to}
#'   \item{postal}{Postal shortcode for country}
#' }
#' @source \url{http://www.diamondse.info/}
"data_world_shapefiles"
