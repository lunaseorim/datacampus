library(shiny)
library(shiny.semantic)

ui <- function() {
  shinyUI(
    semanticPage(
      title = "My page",style = "min-height: 611px;",
      div(
        class = "ui large top fixed hidden menu",
        div(
          class = "ui container",
          a(class = "active item", "Home"),
          a(class = "item", "지역별")
        )
      )
    )
  )
}
server <- shinyServer(function(input, output) {
})

shinyApp(ui = ui(), server = server)
