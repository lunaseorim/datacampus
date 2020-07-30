
# --- SHINY APP ---

# Author : yd0010@20143311
# Date : 2020-07-28
# Tidyverse Coding Style

## --- 0.1 packages ---

library(dplyr)
library(reshape2)
library(shinydashboard)
library(highcharter)
library(shinyjs)

## --- 0.2 set @Rstudio ---

setwd("/home/yd0010/yd_10")

source("shiny_app/global.r")
source("shiny_app/highcharts.r")

## --- 1. SHINY : UI ---



ui <- dashboardPage(
  dashboardHeader(
    title = "icu beds"
  ),
  dashboardSidebar(
    size = "thin", color = "teal",
    sidebarMenu(
      menuItem(tabName = "overview", "개요"),
      menuItem(tabName = "region", "지역")
    )
  ),
  dashboardBody(
    fluidRow(
      box(
        color = "blue", ribbon = T,
        title = "전국 가용 중환자실", width = 5, solidHeader = TRUE, status = "primary",
        paste0(global_total[1,2],"/",global_total[2,2])
      )),
    fluidRow(
      column(
        width = 8, title = "전국 현황", height = "700px",
        highchartOutput("hc_global", height = "700px")
      )
    )
  )
)


## output



server <- function(input, output) {
  
  output$hc_global <- renderHighchart({
    hcmap(
      map = "countries/kr/kr-all",
      data = hc_key,
      value = "perc",
      dataLabels = list(enabled = F)
    )
  })
}


shinyApp(ui, server)
