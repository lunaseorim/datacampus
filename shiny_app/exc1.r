
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
  tabset(
    tabs =
      list(
        ### --- 1.0 Logo Tab ---
        list(menu = div(icon("procedures"),"icu_beds"), id = "logo_tab"),
        list(
          menu = "Home", id = "Home_tab",
          content =
            ### --- 1.1 HOME TAB CONTENT ---
          div(
            class = "ui two column grid", id = "Home_tab",
            div(
              class = "column",
              div(
                class = "ui raised segment",
                style = "width: 90%; height= 500px;",
                highchartOutput("hc_global",width = "100%",height = "500px"
                )
              )
            )
          )
        ),
        ###--- 1.2 Second tab ---
        list(
          menu = "Local", id = "Local_tab",
          content = div(
            
          )
        ),
        list(
          menu = "info", id = "info_tab")
        ),
    active = "Home_tab",
    id = "exampletabset",
    menu_class = "ui top four item",
    tab_content_class = "ui bottom stackable segment"
  )
)
)
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

shiny::shinyApp(ui, server)
