#' @title Run the Takuzu Shiny App
#' @description This function launches the Shiny app included in the TakuzuKL package.
#'
#' @export
runTakuzuApp <- function() {
  appDir <- system.file("takuzu_app", package = "TakuzuKL")
  if (appDir == "") {
    stop("Could not find the Shiny app. Try re-installing the package.", call. = FALSE)
  }
  shiny::runApp(appDir, display.mode = "normal")
}
