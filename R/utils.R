df_to_1d_lists <- function(df) {
  
  if(!all(c("x","y") %in% colnames(df))){
    stop("Conversion to lists requires x, y columns")
  }
  
  output_list <- list()
  
  for (row in 1:nrow(df)) {
    output_list[[row]] <-
      append(df[row,],
             list(z = 1)) # non-zero size
  } 
  output_list
}

df_to_hc_xy_series <- function(hc,
                               data,
                               type,
                               x.column,
                               trace,
                               name,
                               color){
  xy_series <- data %>%
    filter_(paste0("!is.na(",trace,")")) %>%
    rename_("x" = x.column,
            "y" = trace)
  
  xy_series <- xy_series %>%
    df_to_1d_lists()
  
  hc %>%
    hc_add_series(data = xy_series,
                  name = name,
                  color = color,
                  type = type)
}
