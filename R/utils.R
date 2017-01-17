df_to_2d_lists <- function(df){
  output_list <- list()

  for(row in 1:nrow(df)){
    output_list[[row]] <- unlist(df[row,], use.names = F)
  }
  output_list
}

df_to_hc_xy_series <- function(hc,
                               data,
                               x.column,
                               trace,
                               name,
                               color){
  xy_series <- data %>%
    select_(x.column, trace) %>%
    as.data.frame()

  xy_series <- xy_series %>%
    df_to_2d_lists()

  hc %>%
  hc_add_series(data = xy_series,
                name = name,
                color = color)
}


