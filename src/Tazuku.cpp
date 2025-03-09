#include <Rcpp.h>
#include <algorithm>
#include <random>

using namespace Rcpp;

// Функция для проверки правил Takuzu
bool is_valid(const IntegerMatrix &board, int row, int col, int value) {
  int n = board.nrow();

  // Проверка на количество 0 и 1 в строке и столбце
  int count_row = 0, count_col = 0;
  for (int i = 0; i < n; i++) {
    if (board(row, i) == value) count_row++;
    if (board(i, col) == value) count_col++;
  }
  if (count_row > n / 2 || count_col > n / 2) {
    return false;
  }

  // Проверка на три одинаковых значения подряд
  if (row >= 2 && board(row-1, col) == value && board(row-2, col) == value) {
    return false;
  }
  if (col >= 2 && board(row, col-1) == value && board(row, col-2) == value) {
    return false;
  }

  return true;
}

// Функция для генерации частично заполненной таблицы
// [[Rcpp::export]]
IntegerMatrix generate_takuzu(int n, double fill_percentage, bool chaotic = true) {
  IntegerMatrix board(n, n);
  std::fill(board.begin(), board.end(), NA_INTEGER); // Заполняем таблицу NA

  // Количество клеток для заполнения
  int cells_to_fill = round(n * n * fill_percentage);

  // Генератор случайных чисел
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_int_distribution<> dis(0, n - 1);

  // Заполняем клетки
  for (int i = 0; i < cells_to_fill; i++) {
    while (true) {
      int row = dis(gen);
      int col = dis(gen);

      // Если клетка уже заполнена, пропускаем
      if (board(row, col) != NA_INTEGER) continue;

      // Выбираем значение (0 или 1)
      int value = (chaotic) ? dis(gen) % 2 : (i % 2); // Хаотично или структурированно

      // Проверяем, что значение не нарушает правила
      board(row, col) = value;
      if (is_valid(board, row, col, value)) {
        break;
      } else {
        // Если нарушает, откатываем
        board(row, col) = NA_INTEGER;
      }
    }
  }

  return board;
}
