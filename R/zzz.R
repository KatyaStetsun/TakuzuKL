.onLoad <- function(libname, pkgname) {
  cache_dir <- tools::R_user_dir("TakuzuKL", which = "cache")
  if (!dir.exists(cache_dir)) {
    dir.create(cache_dir, recursive = TRUE)
  }
}

#' @title Get Preloaded Takuzu Grids
#' @description Returns the Takuzu grids, loading them from cache or
#'              downloading them on first use.
#' @return A list of Takuzu grids.
#' @export
get_grids <- function() {
  pkgenv <- asNamespace("TakuzuKL")
  cache_file <- file.path(tools::R_user_dir("TakuzuKL", "cache"),
                          "grids_cache.rds")

  if (exists("takuzu_grids", envir = pkgenv)) {
    return(get("takuzu_grids", envir = pkgenv))
  }

  if (file.exists(cache_file)) {
    grids <- readRDS(cache_file)
  } else {
    grids <- dl_csv()
    saveRDS(grids, cache_file)
  }

  assign("takuzu_grids", grids, envir = pkgenv)
  grids
}
