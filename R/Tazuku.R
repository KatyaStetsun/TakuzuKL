#' Generating Takuzu Grid
#'
#' @param size Grid size (e.g., 8 for 8x8)
#' @param difficulty Level of difficulty ("easy", "medium", "hard", "expert")
#' @return Generated Takuzu grid as a matrix
#' @export
generateTakuzuGrid <- function(size, difficulty = "easy") {
  # Check for even size
  if (size %% 2 != 0) {
    stop("Grid size must be even!")
  }

  # Difficulty level parameters
  levels <- list(
    easy = list(fill_percentage = 0.5, chaotic = FALSE),
    medium = list(fill_percentage = 0.4, chaotic = TRUE),
    hard = list(fill_percentage = 0.3, chaotic = TRUE),
    expert = list(fill_percentage = 0.2, chaotic = TRUE)
  )

  # Checking the correctness of the difficulty level
  if (!difficulty %in% names(levels)) {
    stop("Invalid difficulty level. Choose from: easy, medium, hard, expert.")
  }

  # Get parameters for the selected difficulty level
  params <- levels[[difficulty]]

  # Generate table using Rcpp function
  grid <- generate_takuzu(size, params$fill_percentage, params$chaotic)

  return(grid)
}
