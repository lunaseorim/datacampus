
# --- SHINY APP ---

# Author : yd0010@20143311
# Date : 2020-07-28
# Tidyverse Coding Style

## --- 0.1 packages ---

library(dplyr)
library(reshape2)
library(highcharter)
library(shinyjs)
library(shiny.semantic)

ui <- function() {
  shinyUI(
    semanticPage(
      title = "My page",
      div(class = "ui button", uiicon("user"),  "Icon button")
    )
  )
}
server <- shinyServer(function(input, output) {
})
shinyApp(ui = ui(), server = server)