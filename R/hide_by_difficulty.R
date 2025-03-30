#' @export
hide_by_difficulty <- function(lvl, grid){
  stopifnot(lvl >= 0 && lvl <= 0.8)  # Protection against incorrect values
  n <- length(grid[1,])
  hidden_cells <- n*n*lvl

  i <- 0
  while(i < hidden_cells){
    row <- sample.int(n,1)
    col <- sample.int(n,1)

    if(grid[row,col]!=2){
      grid[row,col] <- 2
      i <- i+1
    }
  }

  return(grid)
}
