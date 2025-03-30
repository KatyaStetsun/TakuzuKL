.onLoad <- function(libname, pkgname) {
# Check if there are already loaded grids in the package environment
if (!exists("takuzu_grids", envir = asNamespace(pkgname))) {
# Load grids via dl_csv()
grids <- dl_csv() # Your function from dl_csv.R

# Save them in the hidden package environment
assign("takuzu_grids", grids, envir = asNamespace(pkgname))

# Optional: cache on disk for future sessions
cache_dir <- tools::R_user_dir("TakuzuKL", which = "cache")
if (!dir.exists(cache_dir)) dir.create(cache_dir, recursive = TRUE)
saveRDS(grids, file.path(cache_dir, "grids_cache.rds"))
}
}

# Function to access grids from other parts of the package
#' @export
get_grids <- function() {
get("takuzu_grids", envir = asNamespace("TakuzuKL"))
}