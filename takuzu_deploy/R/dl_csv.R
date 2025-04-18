#' @title Downloading the valid grids
#' @description This function is required to download the valid grids from the distant folder on Zenodo.
#' This way, there is no need to run the Rcpp files "row_generator.cpp", "grid_generator.cpp",
#' "bigger_grid_generator.cpp".
#'
#' @export
# library(readr)
dl_csv <- function(){
  # Loading only 4x4
  grids_4 <- as.matrix(readr::read_csv(
    "https://zenodo.org/records/15037448/files/valid_grid_4x4.csv?download=1",
    col_names = FALSE,
    show_col_types = FALSE
  ))

  # processing only 4x4
  n <- 4
  num_grids <- nrow(grids_4) / n

  grids_list <- lapply(1:num_grids, function(i) {
    grids_4[((i - 1) * n + 1):(i * n), ]
  })

# Return a list with one element (for compatibility with app.R)
  list(grids_4 = grids_list)
}
