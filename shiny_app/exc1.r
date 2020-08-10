
# --- SHINY APP ---

# Author : yd0010@20143311
# Date : 2020-08-09
# Tidyverse Coding Style

## --- 0.1 packages ---
library(shiny)
library(shiny.semantic)
library(highcharter)
library(semantic.dashboard)

## --- 0.2 set @Rstudio ---

setwd("/home/yd0010/yd_10")

source("shiny_app/global.r")
source("shiny_app/highcharts.r")

## --- 1 Shiny Ui ---

ui <- shinyUI(semanticPage(
  style = "margin-top: 20px;",
  div(
    style = "margin-left: 20px; font-size: 20px;",
    icon("procedures"), "icu_beds"
  ),
  tabset(
    tabs =
      list(
        ### --- 1.1.0 HOME TAB
        list(
          menu = "Home", id = "Home_tab",
          content =
            ### --- 1.1 HOME TAB CONTENT ---
          div(
            class = "ui two column grid",
            box_Card("전국가용수", global_total[1, 2], global_total[2, 2], "line_global"),
            div(
              class = "column",
              div(
                class = "ui raised segment",
                style = "width: 100%; height: 525px;",
                highchartOutput("hc_global", width = "100%", height = "100%")
              )
            )
          )
        ),
        ### --- 1.2 Second tab ---
        list(
          menu = "Local", id = "Local_tab",
          content =div(class= "ui grid",style = "margin-top: 15px;",
            tabset(
              list(
                list_local,
                list(menu = "경기", id = "gg_tab", 
                     content = div())
              ),
              active = "seoul_tab",
              id = "localtabset",
              menu_class = "ui vertical menu",
              tab_content_class = "ui bottom stackable"
            )
        )),
        list(
          menu = "Info", id = "info_tab"
        )
      ),
    active = "Home_tab",
    id = "exampletabset",
    menu_class = "ui fluid three item menu",
    tab_content_class = "ui bottom stackable"
  )
))
server <- shinyServer(function(input, output) {
  output$hc_global <- renderHighchart({
    hcmap(
      map = "countries/kr/kr-all",
      data = hc_key,
      value = "perc",
      dataLabels = list(enabled = F)
    )
  })
  output$line_global <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = total))
  })
  output$line_seoul <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 서울특별시))
  })
})

shiny::shinyApp(ui, server)
