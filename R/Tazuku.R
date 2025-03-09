#' Generating Takuzu Grid
#'
#' @param size Grid size (e.g., 8 for 8x8)
#' @param difficulty Level of difficulty ("easy", "medium", "hard", "expert")
#' @return Generated Takuzu grid as a matrix
#' @export
generateTakuzuGrid <- function(size, difficulty = "easy") {
  # Проверка на четность размера
  if (size %% 2 != 0) {
    stop("Grid size must be even!")
  }

  # Параметры уровней сложности
  levels <- list(
    easy = list(fill_percentage = 0.5, chaotic = FALSE),
    medium = list(fill_percentage = 0.4, chaotic = TRUE),
    hard = list(fill_percentage = 0.3, chaotic = TRUE),
    expert = list(fill_percentage = 0.2, chaotic = TRUE)
  )

  # Проверка корректности уровня сложности
  if (!difficulty %in% names(levels)) {
    stop("Invalid difficulty level. Choose from: easy, medium, hard, expert.")
  }

  # Получаем параметры для выбранного уровня сложности
  params <- levels[[difficulty]]

  # Генерация таблицы с использованием Rcpp-функции
  grid <- generate_takuzu(size, params$fill_percentage, params$chaotic)

  return(grid)
}
=======
#' @param size Grid size (eg 8 for 8x8)
#' @return Generated Takuzu Mesh Matrix
#' @export
generateTakuzuGrid <- function(size) {
  .Call(`_TakuzuKL_generateTakuzuGrid`, size)
}
