<div align="center">
  <img src="inst/takuzu_app/www/title_1.png" alt="Title" width="400" height="300" />
</div>

Welcome to our second-semester R project!

We're in first year of a **Master**'s program and we're creating a Takuzu game interface (also known as Binairo) using the [Shiny library](https://github.com/rstudio/shiny) available in the **RStudio** IDE.

---

## 🕹️ Game rules

Takuzu and Sudoku are somewhat similar: numbers into a grid, but this time you'll only come across *1*s and *0*s, in 4x4, 6x6 or 8x8 grids!

The rules are as follows:
- You can't have more than two *1*s (respectively *0*s) following, vertically and horizontally;
- You must have the same count of *1*s and *0*s in each column and each row (eg. in a 6x6 game, there are three *1*s and three *0*s);
- You can't have the same column or the same row twice.

***We hope you enjoy your time playing this pink lolita-themed Takuzu game as much as we enjoyed creating it!***

---

## 😉 Tips

We only wish you the best experience while playing our precious game, you might want to follow these few tips:
- Lower your volume before lauching the app, there are various copyright-free musics playing depending on the difficulty level;
- Go full screen for immersion;
- Carefully read the rules, either above up here or within the in-game user interface.

There are three distinct difficulty level:
- "Easy" that hids 1/4 of the grid cells;
- "Medium" that hids 1/2 of the grid cells;
- "Hard" that hids 3/4 of the grid cells.

---

## 🚀 How to launch the app

To get started with the Takuzu game, follow the steps below:

### 1️⃣ Clone the repository

If you have Git installed, you can clone the repository directly from GitHub:

```bash
git clone https://github.com/KatyaStetsun/Takuzu_game.git
```

Alternatively, click the green **Code** button on the GitHub page and choose **Download ZIP**, then extract it to a local folder.

### 2️⃣ Install R and RStudio

If not, you can download them here:

- 📥 [Download R (Windows/macOS/Linux)](https://cran.r-project.org/)
- 🖥️ [Download RStudio (Windows/macOS/Ubuntu)](https://posit.co/download/rstudio-desktop/)

### 3️⃣ Open the project in RStudio

- Launch RStudio.
- Open the project folder, or open the ``` TakuzuKL.Rproj ``` file inside it.

### 4️⃣ Install required packages

To run the application in your **R** based IDE, you will need some packages:
```r
install.packages(c('shiny', 'shinyjs', 'Rcpp', 'readr'))
```
***Shiny*** represents the entire basis of this project. It allows us to create various UIs (User Interfaces) and render them in a single reactive/responsive server.

***ShinyJS*** has a number of useful features that can be combined with Shiny. We use this package to display each user interface at different times.

***Rcpp*** lets us write *C++* functions directly in our R project, making the logic part of the game much faster and a little more aesthetically pleasing.

***ReadR*** is a tool to read *.csv* files, like the ones we hosted on [Zenodo](https://zenodo.org/records/15037448).

These will also be installed automatically if you run ```devtools::load_all()``` (for this option be sure to used ```install.packages('devtools')``` before) or open the app as a package.

### 5️⃣ Launch the application

Once all packages are installed, you can launch the game using:

```r
TakuzuKL::runTakuzuApp()
```

***Then you're all set to enjoy the game!***

---

## 🧮 Team members

Our team counts two students:
- [**Laura CLETZ**](https://github.com/lcletz)
- [**Kateryna STETSUN**](https://github.com/KatyaStetsun)
 
This R programming course and project is supervised by [**Jean-Michel MARIN**](https://imag.umontpellier.fr/~marin/).

---

## 📄 License 

This project is licensed under **MIT** license.  

For more details, please consult the [LICENSE](https://github.com/KatyaStetsun/Takuzu_game/blob/main/LICENSE) file.  
