library(shiny)
library(shinyjs)
library(TakuzuKL)

if ("grids" %in% ls(envir = .GlobalEnv)) {
 get("grids", envir = .GlobalEnv)
} else {
 grids <- dl_csv()
}

# grids <- get_grids()

ui <- fluidPage(
  useShinyjs(),
  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")),
  uiOutput("welcome_ui"),
  uiOutput("choose_ui"),
  uiOutput("rules_ui"),
  uiOutput("game_ui"),
  uiOutput("victory_ui")
)

server <- function(input, output, session) {

  game_data <- reactiveValues(grid = NULL, solution = NULL, observed = FALSE)

  # Welcome UI
  output$welcome_ui <- renderUI({
    tagList(
      img(src = "title.png", class = "title-img"),
      div(class = "btn-container",
          actionButton("play", "PLAY", class = "btn btn-custom"),
          actionButton("how_to_play", "HOW TO PLAY?", class = "btn btn-custom"),
          actionButton("exit", "EXIT", class = "btn btn-custom")
      )
    )
  })

  # Rules UI
  output$rules_ui <- renderUI({
    tagList(
      div(class = "rules-container",
          img(src = "rules.png", class = "rules-img"),
          actionButton("return_from_rules", "RETURN", class = "btn btn-custom rules-button")
      )
    )
  })

  # Choose Board UI
  output$choose_ui <- renderUI({
    tagList(
      div(class = "panel-custom",
          radioButtons("board_size", "Choose Board Size:",
                       choices = c("4x4", "6x6", "8x8"),
                       selected = "6x6"),
          radioButtons("difficulty", "Choose Difficulty Level:",
                       choices = c("Easy", "Medium", "Hard"),
                       selected = "Medium")
      ),
      div(class = "button-container",
          actionButton("start_game", "START GAME", class = "btn btn-custom"),
          actionButton("return", "RETURN", class = "btn btn-custom")
      )
    )
  })

  # Game UI
  output$game_ui <- renderUI({
    req(game_data$grid)

    n <- nrow(game_data$grid)

    cell_color <- switch(input$difficulty,
                         "Easy" = "easy",
                         "Medium" = "medium",
                         "Hard" = "hard")

    tagList(
      div(class = "game-container",
          div(class = "difficulty-img-container",
              img(src = switch(input$difficulty,
                               "Easy" = "easy_mode.png",
                               "Medium" = "medium_mode.png",
                               "Hard" = "hard_mode.png"),
                  class = "difficulty-img")
          ),
          div(class = "game-grid",
              do.call(tagList, lapply(1:n, function(i) {
                div(lapply(1:n, function(j) {
                  btn_id <- paste0("cell_", i, "_", j)
                  value <- game_data$grid[i, j]

                  is_editable <- game_data$original_grid[i, j] == 2

                  actionButton(
                    btn_id,
                    label = ifelse(value == 2, "", value),
                    class = ifelse(is_editable, paste0("cell-editable ", cell_color), paste0("cell-fixed ", cell_color))
                  )
                })
                )
              }))
          ),
          div(class = "game-btn-container",
              actionButton("check_solution", "CHECK", class = "btn btn-custom"),
              actionButton("solve_grid", "SOLVE", class = "btn btn-custom"),
              actionButton("return_to_menu", "QUIT", class = "btn btn-custom")
          )
      )
    )
  })


  # Handle Game Start
  observeEvent(input$start_game, {

    grid_size <- as.integer(strsplit(input$board_size, "x")[[1]][1])
    grid_name <- paste0("grids_", grid_size)
    chosen_grid <- as.matrix(sample(grids[[grid_name]], 1)[[1]])

    game_data$solution <- chosen_grid
    difficulty_level <- switch(input$difficulty,
                               "Easy" = 0.25,
                               "Medium" = 0.5,
                               "Hard" = 0.75)
    game_data$grid <- hide_by_difficulty(difficulty_level, chosen_grid)
    game_data$original_grid <- game_data$grid

    shinyjs::hide("choose_ui")
    shinyjs::show("game_ui")

  })

  # Handle Playable Cells
  observe({
    req(game_data$grid)

    n <- nrow(game_data$grid)

    for (i in seq_len(n)) {
      for (j in seq_len(n)) {
        if (game_data$grid[i, j] == 2) {
          local({
            ii <- i
            jj <- j
            btn_id <- paste0("cell_", ii, "_", jj)

            observeEvent(input[[btn_id]], {
              isolate({
                current_val <- game_data$grid[ii, jj]
                new_val <- switch(as.character(current_val),
                                  "2" = 1,
                                  "1" = 0,
                                  "0" = 2)

                game_data$grid[ii, jj] <- new_val

                updateActionButton(session, btn_id,
                                   label = ifelse(new_val == 2, "", as.character(new_val)))
              })
            }, ignoreInit = TRUE, ignoreNULL = TRUE)
          })
        }
      }
    }
  })


  # Handle Solution Check
  observeEvent(input$check_solution, {
    req(game_data$grid, game_data$solution)

    if (all(game_data$grid == game_data$solution)) {
      shinyjs::hide("game_ui")
      shinyjs::show("victory_ui")
    } else {
      showModal(modalDialog(
        title = "Incorrect",
        "The grid is not solved correctly. Keep trying!"
      ))
    }
  })

  # Share Solution
  observeEvent(input$solve_grid, {
    req(game_data$grid, game_data$solution)

    game_data$grid <- game_data$solution

    showModal(modalDialog(
      title = "Nice try",
      "Let's try another one!",
      easyClose = TRUE,
      footer = tagList(
        actionButton("return_to_menu_modal", "RETURN TO MENU")
      )
    ))
  })


  # Victory UI
  output$victory_ui <- renderUI({
    req(game_data$grid)
    tagList(
      div(class = "rules-container",
          img(src = "victory.png", class = "rules-img"),
          div("Congratulations! You solved the puzzle!", class = "victory-message"),
          actionButton("return_to_menu_victory", "RETURN TO MENU", class = "btn btn-custom rules-button")
      )
    )
  })

  # Handle UI Navigation
  shinyjs::hide("choose_ui")
  shinyjs::hide("rules_ui")
  shinyjs::hide("game_ui")
  shinyjs::hide("victory_ui")


  observeEvent(input$play, {
    shinyjs::hide("welcome_ui")
    shinyjs::show("choose_ui")
  })


  observeEvent(input$how_to_play, {
    shinyjs::hide("welcome_ui")
    shinyjs::show("rules_ui")
  })


  observeEvent(input$return, {
    shinyjs::hide("choose_ui")
    shinyjs::show("welcome_ui")
  })


  observeEvent(input$return_from_rules, {
    shinyjs::hide("rules_ui")
    shinyjs::show("welcome_ui")
  })


  observeEvent(input$return_to_menu_victory, {
    shinyjs::hide("victory_ui")
    shinyjs::show("choose_ui")
  })


  observeEvent(input$return_to_menu, {
    shinyjs::hide("game_ui")
    shinyjs::show("choose_ui")
  })


  observeEvent(input$return_to_menu_modal, {
    removeModal()

    shinyjs::hide("game_ui")
    shinyjs::show("choose_ui")
  })


  observeEvent(input$exit, {
    stopApp()
  })
}

shinyApp(ui, server)
