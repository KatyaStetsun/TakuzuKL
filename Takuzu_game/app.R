library(shiny)
library(shinyjs)

ui <- fluidPage(
  useShinyjs(),  # Enable shinyjs
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")  # Link to CSS file
  ),
  uiOutput("welcome_ui"),  # Welcome screen
  uiOutput("choose_ui"),   # Difficulty and size selection screen
  uiOutput("rules_ui"),    # Rules screen
  uiOutput("game_ui"),     # Game screen
  uiOutput("victory_ui")   # Victory screen
)

server <- function(input, output, session) {
  
  # Reactive value to store the game board
  board <- reactiveVal()
  
  # Reactive value to track victory state
  victory <- reactiveVal(FALSE)
  
  # Logic to enable/disable the SOLVE button
  observe({
    if (is.null(board())) {
      shinyjs::disable("solver")  # Disable the SOLVE button if the board is not generated
    } else {
      shinyjs::enable("solver")   # Enable the SOLVE button
    }
  })
  
  # Welcome screen UI 
  output$welcome_ui <- renderUI({
    tagList(
      img(src = "title.png", class = "title-img"),  # Title image
      div(class = "btn-container",  
          actionButton("play", "PLAY", class = "btn btn-custom", title = "Start the game"),  # Play button
          actionButton("how_to_play", "HOW TO PLAY?", class = "btn btn-custom"),  # Rules button
          actionButton("exit", "EXIT", class = "btn btn-custom")  # Exit button
      )
    )
  })
  
  # Difficulty and size selection screen UI
  output$choose_ui <- renderUI({
    tagList(
      div(class = "panel-custom",
          div(
            radioButtons("board_size", "Choose Board Size:",  # Board size selection
                         choices = c("6x6", "8x8", "12x12"),
                         selected = "8x8")
          ),
          div(
            radioButtons("difficulty", "Choose Difficulty Level:",  # Difficulty selection
                         choices = c("Easy", "Normal", "Hard", "Extreme"),
                         selected = "Normal")
          )
      ),
      div(class = "button-container",
          actionButton("start_game", "START GAME", class = "btn btn-custom"),  # Start game button
          actionButton("return", "RETURN", class = "btn btn-custom")  # Return to welcome screen
      )
    )
  })
  
  # Rules screen UI
  output$rules_ui <- renderUI({
    tagList(
      div(class = "rules-container",
          img(src = "rules.png", class = "rules-img"),  # Rules image
          actionButton("return_from_rules", "RETURN", class = "btn btn-custom")  # Return to welcome screen
      )
    )
  })
  
  # Game screen UI
  output$game_ui <- renderUI({
    req(board())  # Ensure the board exists
    grid <- board()
    size <- nrow(grid)
    
    tagList(
      div(class = "game-container",  
          div(class = "difficulty-img-container",
              img(src = switch(input$difficulty,  # Display difficulty image
                               "Easy" = "easy_mode.png",
                               "Medium" = "medium_mode.png",
                               "Hard" = "hard_mode.png",
                               "Expert" = "expert_mode.png"),
                  class = "difficulty-img")
          ),
          
          div(class = "game-btn-container",
              actionButton("solver", "SOLVE", class = "btn btn-custom", title = "Automatically solve the puzzle"),  # Solve button
              actionButton("return_to_menu", "QUIT", class = "btn btn-custom")  # Quit button
          )
      ),
      
      div(class = "game-grid",
          h3("GAME GRID"),
          tags$table(
            class = "takuzu-grid",
            lapply(1:size, function(row) {
              tags$tr(
                lapply(1:size, function(col) {
                  value <- grid[row, col]
                  cell_class <- ifelse(is.na(value), "empty", "filled")  # Set cell class
                  if (!is_valid_cell(grid, row, col)) {  # Highlight invalid cells
                    cell_class <- paste(cell_class, "error")
                  }
                  tags$td(
                    class = cell_class,
                    onclick = sprintf("Shiny.setInputValue('cell_click', {row: %d, col: %d})", row, col),  # Handle cell clicks
                    ifelse(is.na(value), "", value)  # Display cell value
                  )
                })
              )
            })
          )
      )
    )
  })
  
  # Victory screen UI
  output$victory_ui <- renderUI({
    tagList(
      div(class = "victory-container",
          h2("Congratulations! You won!"),  # Victory message
          actionButton("play_again", "PLAY AGAIN", class = "btn btn-custom"),  # Play again button
          actionButton("exit_victory", "EXIT", class = "btn btn-custom")  # Exit button
      )
    )
  })
  
  # Hide all screens except the welcome screen initially
  shinyjs::hide("choose_ui")
  shinyjs::hide("rules_ui")
  shinyjs::hide("game_ui")
  shinyjs::hide("victory_ui")
  
  # Logic for switching between screens
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
  
  observeEvent(input$start_game, {
    size <- as.numeric(strsplit(input$board_size, "x")[[1]][1])  # Get board size
    difficulty <- tolower(input$difficulty)  # Get difficulty level
    
    # Generate the game board
    grid <- generateTakuzuGrid(size, difficulty)
    
    # Save the board in a reactive value
    board(grid)
    
    # Reset victory state
    victory(FALSE)
    
    # Show the game screen
    shinyjs::hide("choose_ui")
    shinyjs::show("game_ui")
  })
  
  observeEvent(input$return_to_menu, {
    shinyjs::hide("game_ui")
    shinyjs::show("choose_ui")
  })
  
  observeEvent(input$exit, {
    stopApp()  # Exit the app
  })
  
  observeEvent(input$exit_victory, {
    stopApp()  # Exit the app from victory screen
  })
  
  observeEvent(input$play_again, {
    shinyjs::hide("victory_ui")
    shinyjs::show("choose_ui")
  })
  
  # Handle cell clicks
  observeEvent(input$cell_click, {
    cell <- input$cell_click
    row <- cell$row
    col <- cell$col
    
    # Get the current board
    grid <- board()
    
    # Toggle cell value (0 or empty)
    grid[row, col] <- ifelse(is.na(grid[row, col]), 0, NA)
    
    # Check if the board is valid
    if (is_valid(grid)) {
      board(grid)
      
      # Check if the game is completed
      if (all(!is.na(grid))) {
        victory(TRUE)
        shinyjs::hide("game_ui")
        shinyjs::show("victory_ui")
      }
    } else {
      showNotification("Invalid move!", type = "error")  # Show error message
    }
  })
  
  # Solve button logic
  observeEvent(input$solver, {
    # Solve the Takuzu puzzle
    solved_board <- solveTakuzu(board())
    board(solved_board)
    
    # Show the victory screen
    victory(TRUE)
    shinyjs::hide("game_ui")
    shinyjs::show("victory_ui")
  })
}

shinyApp(ui, server)