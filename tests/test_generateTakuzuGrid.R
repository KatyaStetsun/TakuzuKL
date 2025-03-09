library(testthat)
library(Rcpp)
sourceCpp("D:/TakuzuKL/src/Takuzu.cpp")
source("D:/TakuzuKL/R/Tazuku.R")

# Тестирование функции generateTakuzuGrid
test_that("generateTakuzuGrid works correctly", {
  # Проверка, что функция возвращает матрицу
  grid <- generateTakuzuGrid(8, difficulty = "easy")
  expect_true(is.matrix(grid))
  expect_equal(dim(grid), c(8, 8))

  # Проверка, что таблица соответствует правилам Takuzu
  expect_true(is_valid(grid))

  # Проверка, что уровень сложности влияет на заполнение
  grid_easy <- generateTakuzuGrid(8, difficulty = "easy")
  grid_expert <- generateTakuzuGrid(8, difficulty = "expert")

  # В easy больше заполненных клеток, чем в expert
  expect_gt(sum(!is.na(grid_easy)), sum(!is.na(grid_expert)))
})

# Проверка обработки ошибок
test_that("generateTakuzuGrid handles errors correctly", {
  # Нечётный размер таблицы
  expect_error(generateTakuzuGrid(7, difficulty = "easy"))

  # Некорректный уровень сложности
  expect_error(generateTakuzuGrid(8, difficulty = "invalid"))
})