.onLoad <- function(libname, pkgname) {
  
  # Checking if there are already loaded grids in the package environment
  if (!exists("takuzu_grids", envir = asNamespace(pkgname))) {
    
    grids <- dl_csv()  # load grids via dl_csv()

    # save them in the hidden package environment
    assign("takuzu_grids", grids, envir = asNamespace(pkgname))

    # cache on disk for future sessions
    cache_dir <- tools::R_user_dir("TakuzuKL", which = "cache")
    if (!dir.exists(cache_dir)) dir.create(cache_dir, recursive = TRUE)
    saveRDS(grids, file.path(cache_dir, "grids_cache.rds"))
  }
}


#' @title Get Preloaded Takuzu Grids
#' @description This function retrieves the preloaded set of Takuzu grids
#' 
#' @export
get_grids <- function() {
get("takuzu_grids", envir = asNamespace("TakuzuKL"))
}