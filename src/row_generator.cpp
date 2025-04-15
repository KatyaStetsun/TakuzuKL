#include <Rcpp.h>
#include <vector>
#include <fstream>

using namespace Rcpp;
using namespace std;

// First step: Create valid rows of size 4, 6 and 8.

bool isValidRow(const vector<int>& row, int size) {
  int zeros = 0, ones = 0;

  // set counters for 1s and 0s
  for (int i = 0; i < size; i++) {
    if (row[i] == 0) zeros++;
    else ones++;

    // check successive 1s and 0s
    if (i >= 2 && row[i] == row[i - 1] && row[i] == row[i - 2]) {
      return false;
    }
  }

  // check number of 1s and 0s
  if (zeros != ones) return false;
  return true;
}


// Function that converts integers to their binary value for different sizes:
vector<int> intToBinaryRow(int num, int size) {
  vector<int> row(size);
  for (int i = 0; i < size; i++) {
    row[i] = (num >> (size - 1 - i)) & 1;
  }
  return row;
}


// Function that generates valid rows for an indicated size:
List generateValidRows(int size) {

  vector<int> row(size);
  int total = 1 << size;       // 2^size, better than pow(2, size)
  vector<vector<int>> validRows;
  validRows.reserve(total);

  // Generate binary row
  for (int num = 0; num < total; num++) {
    row = intToBinaryRow(num, size);

    // If the row is valid, it is added at the end of the vector validRows:
    if (isValidRow(row, size)) {
      validRows.push_back(row);
    }
  }

  // Create the list to be saved
  int n = validRows.size();
  List result(n);
  for (int i = 0; i < n; i++) {
    result[i] = IntegerVector(validRows[i].begin(), validRows[i].end());
  }
  return result;
}


// Void function that saves the list of valid rows of sizes 4, 6 and 8 in a .txt file:
void saveValidRows(const String& filename) {

  ofstream outfile(filename);      // Output file stream

  for(int i = 4; i < 9; i++) {     // From 4 included to 8 included
    if(i % 2 == 0) {        // Even sizes only

      List validRowsList = generateValidRows(i);

      for (int j = 0; j < validRowsList.size(); j++) {
        IntegerVector row = validRowsList[j];

        for (int k = 0; k < row.size(); k++) {
          outfile << row[k] << " ";       // Add spaces between numbers in the .txt file
        }
        outfile << endl;
      }
    }
  }

  outfile.close();
}

/*** R
saveValidRows("valid_rows.txt")
*/
