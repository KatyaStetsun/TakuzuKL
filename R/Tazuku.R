#' Get Difficulty Level Parameters
#'
#' This function retrieves the parameters for a given difficulty level.
#'
#' @param difficulty A string indicating the difficulty level ("easy", "medium", "hard", "expert").
#' @return A list containing the fill percentage and chaotic flag.
#' @export
get_difficulty_params <- function(difficulty) {
  .Call(`_TakuzuKL_get_difficulty_params`, difficulty)
}

#' Generating Takuzu Grid
#'
#' @param size Grid size (e.g., 6 for 6x6). Default is 8x8.
#' @param difficulty Level of difficulty ("easy", "medium", "hard", "expert"). Default is "easy".
#' @return Generated Takuzu grid as a matrix
#' @export
generateTakuzuGrid <- function(size = 8, difficulty = "easy") {
  # Check for even size
  if (size %% 2 != 0) {
    stop("Grid size must be even!")
  }

  # Get parameters for the selected difficulty level
  params <- get_difficulty_params(difficulty)

  # Generate table using Rcpp function
  grid <- generate_takuzu(size, params$fill_percentage, params$chaotic)

  return(grid)
}
