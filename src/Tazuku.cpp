#include <Rcpp.h>
using namespace Rcpp;
// [[Rcpp::export]]
IntegerMatrix generateTakuzuGrid(int size) {
  IntegerMatrix grid(size, size);

  // Заполняем сетку случайными 0 и 1
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      grid(i, j) = rand() % 2; // 0 или 1
    }
  }
  return grid;
}


