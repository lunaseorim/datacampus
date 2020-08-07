library(shiny)
library(shiny.semantic)
library(highcharter)

ui <- function() {
  shinyUI(
    semanticPage(
      title = "My page",theme = "united",
      div(
        ### --- ui set ---
        class = "ui large secondary pointing menu",
        style = "margin-top: 25px;",
        a(icon("procedures icon")),
        a(
          class = "active item", label = "home", "개요"
        ),
        a(
          class = "item", label = "local","지역별"
        )
      ),
      div(class="ui stackable container grid",
          div(class="row",
        box(
          color = "grey", ribbon = T,
          title = "전국 가용 중환자실", width = 6, solidHeader = TRUE,
          paste0(global_total[1,2],"/",global_total[2,2])
        ),
        box(
          color = "grey", ribbon = T,
          title = "전국 가용 중환자실 (%)", width = 6, solidHeader = TRUE,
          paste0(round(global_total[1,2]/global_total[2,2]*100,2),"%")
        )
      ),
      div(class="row",
        box(ribbon = T, color="grey",
            width = 8, title = "전국 현황", height = "500px",
            highchartOutput("hc_global", height = "500px")
        )
      )
      )
    )
  )
}
server <- shinyServer(function(input, output) {
  
  
  output$hc_global <- renderHighchart({
    hcmap(
      map = "countries/kr/kr-all",
      data = hc_key,
      value = "perc",
      dataLabels = list(enabled = F)
    )
  })
})

shinyApp(ui = ui(), server = server)
