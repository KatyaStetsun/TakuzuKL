#include <Rcpp.h>
#include <fstream>
#include <vector>
#include <sstream>
#include <algorithm>

using namespace Rcpp;
using namespace std;

// Second step: Create valid grids of sizes 4 and 6 using the rows from 'valid_rows.txt'.

bool isValidGrid(const vector<vector<int>>& grid, int size) {
  if (grid.size() < size) {
    return true;
  }

  // set counters for 1s and 0s
  for (int col = 0; col < size; col++) {
    int zeros = 0, ones = 0;
    for (int row = 0; row < size; row++) {
      if (grid[row][col] == 0) zeros++;
      else ones++;

      // check succesive 1s and 0s
      if (row >= 2 && grid[row][col] == grid[row - 1][col] && grid[row][col] == grid[row - 2][col]) {
        return false;
      }
    }

    // check number of 1s and 0s
    if (zeros != ones) {
      return false;
    }

    // check for duplicates
    for (int col1 = 0; col1 < size; col1++) {
      for (int col2 = col1 + 1; col2 < size; col2++) {
        bool isDuplicate = true;
        for (int row = 0; row < size; row++) {
          if (grid[row][col1] != grid[row][col2]) {
            isDuplicate = false;
            break;
          }
        }
        //
        if (isDuplicate) {
          return false;
        }
      }
    }
  }

  return true;
}


// Function that will read the rows from the file 'valid_rows.txt':
map<int, vector<vector<int>>> readValidRowsFromFile(const string& filename) {
  ifstream infile(filename);      // Input file stream
  string line;
  map<int, vector<vector<int>>> validRowsBySize;

  while (getline(infile, line)) {
    stringstream ss(line);
    vector<int> row;
    int value;

    // Get String from .txt file and convert it to Vector
    while (ss >> value) {
      row.push_back(value);
    }

    // If the converted vector is not empty (if it's not a line break), it's kept:
    if (!row.empty()) {
      validRowsBySize[row.size()].push_back(row);
    }
  }

  infile.close();
  return validRowsBySize;
}


// Void function that will save the valid grids in .csv files:
void saveValidGridsToFile(const vector<vector<vector<int>>>& grids, int size, const string& output_dir) {
  string filename = output_dir + "/valid_grid_" + to_string(size) + "x" + to_string(size) + ".csv";
  ofstream outfile(filename);      // Output file stream

  if (!outfile) {
    Rcout << "Error opening file: " << filename << "\n";
    return;
  }

  for (const auto& grid : grids) {
    for (const auto& row : grid) {
      for (size_t i = 0; i < row.size(); i++) {
        outfile << row[i];
        if (i < row.size() - 1) outfile << ",";
      }
      outfile << "\n";    // Line break between rows
    }
    outfile << "\n";    // Bigger line break between grids
  }

  outfile.close();
  Rcout << "Saved " << grids.size() << " valid grids to " << filename << "\n";
}


// Void function that generates the valid grids for an indicated size:
void generateValidGrids(const std::string& filename, const std::string& output_dir, int size) {
  std::map<int, std::vector<std::vector<int>>> validRowsBySize = readValidRowsFromFile(filename);

  if (validRowsBySize.find(size) == validRowsBySize.end()) {
    Rcout << "No valid rows found for size " << size << ".\n";
    return;
  }

  const std::vector<std::vector<int>>& validRows = validRowsBySize[size];

  Rcout << "Size " << size << ": " << validRows.size() << " rows.\n";

  std::vector<std::vector<std::vector<int>>> validGrids;
  int nRows = validRows.size();

  std::vector<int> indices(size, 0);
  int validGridCount = 0;  // Initialize the counter for valid grids

  while (true) {
    std::vector<std::vector<int>> grid;
    for (int i = 0; i < size; i++) {
      grid.push_back(validRows[indices[i]]);
    }

    if (isValidGrid(grid, size)) {
      validGrids.push_back(grid);
      validGridCount++;           // Debugging count
      Rcout << "Added valid grid #" << validGridCount << "\n";      // Debugging Rcout
    }

    // Add valid rows one after the other until there are enough row in the grid:
    int idx = size - 1;
    while (idx >= 0 && indices[idx] == nRows - 1) {
      indices[idx] = 0;
      idx--;
    }
    if (idx < 0) break;
    indices[idx]++;
  }

  saveValidGridsToFile(validGrids, size, output_dir);
}

/*** R
# generateValidGrids("src/valid_rows.txt", "src", 4)
# generateValidGrids("src/valid_rows.txt", "src", 6)
*/
