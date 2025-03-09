library(testthat)
library(Rcpp)
sourceCpp("D:/TakuzuKL/src/Takuzu.cpp")
source("D:/TakuzuKL/R/Tazuku.R")

# test generateTakuzuGrid
test_that("generateTakuzuGrid works correctly", {
  # Check that the function returns a matrix
  grid <- generateTakuzuGrid(8, difficulty = "easy")
  expect_true(is.matrix(grid))
  expect_equal(dim(grid), c(8, 8))

  # Check that the table complies with Takuzu rules
  expect_true(is_valid(grid))

  # Check that the difficulty level affects the filling
  grid_easy <- generateTakuzuGrid(8, difficulty = "easy")
  grid_expert <- generateTakuzuGrid(8, difficulty = "expert")

  # Easy has more filled cells than expert
  expect_gt(sum(!is.na(grid_easy)), sum(!is.na(grid_expert)))
})

# Check error handling
test_that("generateTakuzuGrid handles errors correctly", {
  # Odd table size
  expect_error(generateTakuzuGrid(7, difficulty = "easy"))

  # Incorrect difficulty level
  expect_error(generateTakuzuGrid(8, difficulty = "invalid"))
})
