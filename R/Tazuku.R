#' Generating Takuzu Grid
#'
#' @param size Grid size (eg 8 for 8x8)
#' @return Generated Takuzu Mesh Matrix
#' @export
generateTakuzuGrid <- function(size) {
  .Call(`_TakuzuKL_generateTakuzuGrid`, size)
}

