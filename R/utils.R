df_to_2d_lists <- function(df){
  output_list <- list()

  for(row in 1:nrow(df)){
    output_list[[row]] <- unlist(df[row,], use.names = F)
  }
  output_list
}

df_to_3d_lists <- function(df) {
  output_list <- list()

  for (row in 1:nrow(df)) {
    output_list[[row]] <-
      c(unlist(df[row, ], use.names = F), 1) # non-zero size needed for bubbles)
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
    na.omit() %>%
    as.data.frame()

  xy_series <- xy_series %>%
    df_to_2d_lists()

  hc %>%
    hc_add_series(data = xy_series,
                  name = name,
                  color = color)
}

df_to_hc_xyz_series <- function(hc,
                               data,
                               x.column,
                               trace,
                               name,
                               color,
                               opacity){
  xyz_series <- data %>%
    select_(x.column, trace) %>%
    na.omit() %>%
    as.data.frame()

  xyz_series <- xyz_series %>%
    df_to_3d_lists()

  hc %>%
    hc_add_series(data = xyz_series,
                  type = "bubble",
                  name = name,
                  color = color,
                  marker = list(fillOpacity = opacity)
                  )
}

