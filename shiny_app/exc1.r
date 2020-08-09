
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
        ### --- 1.0 Logo Tab ---
        # list(menu = div(icon("procedures"),"icu_beds"), id = "logo_tab"),
        list(
          menu = "Home", id = "Home_tab",
          content =
            ### --- 1.1 HOME TAB CONTENT ---
          div(
            class = "ui two column grid",
            div(
              class = "column",
              div(
                class = "ui raised segment",
                div(
                  class = "ui horizontal divider",
                  div(style = "font-size:20px;", icon("procedures"), "전국가용현황")
                ),
                p(
                  style = "font-size:25px; margin: 15px 0px; text-align: center;",
                  paste0(global_total[1, 2], "/", global_total[2, 2])
                ),
                div(
                  class = "ui blue progress",
                  `data-percent` = round(global_total[1, 2] / global_total[2, 2] * 100, 2), id = "bar1",
                  div(
                    class = "bar",
                    style = paste0("width:", round(global_total[1, 2] / global_total[2, 2] * 100, 2), "%;")
                  ),
                  div(
                    class = "label", style = "font-size:15px;",
                    paste0(round(global_total[1, 2] / global_total[2, 2] * 100, 2), "%")
                  )
                ), 
                div(
                  class = "ui horizontal divider",
                  div(style = "font-size:20px;", icon("chart line"), "최근 가용수")
                ),
                div(
                  style = "margin-top: 15px; height: 300px;",
                  highchartOutput("main_line", width = "100%", height = "100%")
                )
              )
            ),
            div(
              class = "column",
              div(
                class = "ui raised segment",
                style = "width: 100%; height: 500px;",
                highchartOutput("hc_global", width = "100%", height = "100%")
              )
            )
          )
        ),
        ### --- 1.2 Second tab ---
        list(
          menu = "Local", id = "Local_tab",
          content = div()
        ),
        list(
          menu = "Info", id = "info_tab"
        )
      ),
    active = "Home_tab",
    id = "exampletabset",
    menu_class = "ui stackable menu",
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
  output$main_line <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = total))
  })
})

shiny::shinyApp(ui, server)
