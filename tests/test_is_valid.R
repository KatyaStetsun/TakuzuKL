library(testthat)
library(TakuzuKL)

# TEST is_valid
test_that("is_valid works correctly", {
  # Correct table
  valid_grid <- matrix(
    c(1, 0, NA, 0, NA, 1, NA, 1,
      0, 1, 1, NA, 0, NA, 1, NA,
      NA, 0, NA, 1, NA, 0, NA, 0,
      0, NA, 1, NA, 1, NA, 0, NA,
      NA, 1, NA, 0, NA, 1, NA, 1,
      1, NA, 0, NA, 0, NA, 1, NA,
      NA, 0, NA, 1, NA, 0, NA, 0,
      0, NA, 1, NA, 1, NA, 0, NA),
    nrow = 8, byrow = TRUE
  )
  expect_true(is_valid(valid_grid))

  # Table with three identical values in a row
  invalid_grid <- matrix(
    c(1, 1, 1, NA, NA, NA, NA, NA,
      NA, NA, NA, NA, NA, NA, NA, NA,
      NA, NA, NA, NA, NA, NA, NA, NA,
      NA, NA, NA, NA, NA, NA, NA, NA,
      NA, NA, NA, NA, NA, NA, NA, NA,
      NA, NA, NA, NA, NA, NA, NA, NA,
      NA, NA, NA, NA, NA, NA, NA, NA,
      NA, NA, NA, NA, NA, NA, NA, NA),
    nrow = 8, byrow = TRUE
  )
  expect_false(is_valid(invalid_grid))

  # Table with unequal number of 0 and 1
  invalid_grid2 <- matrix(
    c(1, 1, 1, 1, 1, 1, 1, 1,
      0, 0, 0, 0, 0, 0, 0, 0,
      NA, NA, NA, NA, NA, NA, NA, NA,
      NA, NA, NA, NA, NA, NA, NA, NA,
      NA, NA, NA, NA, NA, NA, NA, NA,
      NA, NA, NA, NA, NA, NA, NA, NA,
      NA, NA, NA, NA, NA, NA, NA, NA,
      NA, NA, NA, NA, NA, NA, NA, NA),
    nrow = 8, byrow = TRUE
  )
  expect_false(is_valid(invalid_grid2))
})
