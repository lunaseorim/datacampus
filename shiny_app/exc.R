library(shiny)
library(shiny.semantic)
library(highcharter)
library(semantic.dashboard)
library(shinyjs)


ui <- function() {
  shinyUI(
    semanticPage(includeScript("www/tab.js"),
      title = "My page", theme = "united",
      div(
        ### --- ui set ---
        class = "ui top large secondary pointing menu",
        style = "margin-top: 25px;",
        a(icon("procedures icon")),
        a(
          class = "active item",`data-tab` = "home", "개요"
        ),
        a(
          class = "item",`data-tab` = "local", "지역별"
        )
      ),
      ### --- first tab ---
      div(
        class = "ui bottom stackable grid active segment active",`data-tab` = "home",
        div(
          class = "row",
          box(
            color = "grey", ribbon = F,
            title = "전국 가용 중환자실", width = 6, solidHeader = TRUE,
            paste0(global_total[1, 2], "/", global_total[2, 2])
          ),
          box(
            color = "grey", ribbon = F,
            title = "전국 가용 중환자실 (%)", width = 6, solidHeader = TRUE,
            paste0(round(global_total[1, 2] / global_total[2, 2] * 100, 2), "%")
          )
        ),
        div(
          class = "row",
          box(
            ribbon = F, color = "grey",
            width = 8, title = "전국 현황", height = "500px",
            highchartOutput("hc_global", height = "500px")
          )
        )
      ),
      ### Seconds tab ---
      div(class = "ui bottom stackable grid segment",`data-tab` = "local",
          div())
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
 runjs("shiny_app/www/tab.js")
})

shinyApp(ui = ui(), server = server)
