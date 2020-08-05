library(shiny)
library(shiny.semantic)

ui <- function() {
  shinyUI(
    semanticPage(
      title = "My page",
      div(
        class = "ui large secondary pointing menu",
        style = "margin-top: 25px; margin-left: 15px;",
        a(
          class = "text", "ICU-Beds",
          style = "font-size: 15px; margin-right: 10px; margin-bottom: 10px;"
        ),
        a(
          class = "active item", "HOME"
        ),
        a(
          class = "item", "GEO"
        )
      )
      )
    )
}
server <- shinyServer(function(input, output) {
})

shinyApp(ui = ui(), server = server)
