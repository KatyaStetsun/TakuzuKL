#include <Rcpp.h>
#include <algorithm>
#include <random>

using namespace Rcpp;

// Function for checking Takuzu rules
bool is_valid(const IntegerMatrix &board, int row, int col, int value) {
  int n = board.nrow();

  // Check for number of 0 and 1 in row and column
  int count_row = 0, count_col = 0;
  for (int i = 0; i < n; i++) {
    if (board(row, i) == value) count_row++;
    if (board(i, col) == value) count_col++;
  }
  if (count_row > n / 2 || count_col > n / 2) {
    return false;
  }

  // Check for three identical values in a row
  if (row >= 2 && board(row-1, col) == value && board(row-2, col) == value) {
    return false;
  }
  if (col >= 2 && board(row, col-1) == value && board(row, col-2) == value) {
    return false;
  }

  return true;
}

// Function to generate a partially filled table
// [[Rcpp::export]]
IntegerMatrix generate_takuzu(int n, double fill_percentage, bool chaotic = true) {
  IntegerMatrix board(n, n);
  std::fill(board.begin(), board.end(), NA_INTEGER); // putting NA

  // Number of cells to fill
  int cells_to_fill = round(n * n * fill_percentage);

  // Random number generator
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_int_distribution<> dis(0, n - 1);

  // Fill the cells
  for (int i = 0; i < cells_to_fill; i++) {
    while (true) {
      int row = dis(gen);
      int col = dis(gen);

      // If the cell is already filled, skip
      if (board(row, col) != NA_INTEGER) continue;

      // Select a value (0 or 1)
      int value = (chaotic) ? dis(gen) % 2 : (i % 2); // Chaotic or structured

      // Check that the value does not violate the rules
      board(row, col) = value;
      if (is_valid(board, row, col, value)) {
        break;
      } else {
        // If it violates, we roll back
        board(row, col) = NA_INTEGER;
      }
    }
  }

  return board;
}
