
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
source("global.r")
source("highcharts.r")
## --- 1 Shiny Ui ---

ui <- shinyUI(semanticPage(
  style = "margin-top: 20px;",
  div(
    style = "margin-left: 20px; font-size: 20px;",
    icon("procedures"), "중환자실 모니터링"
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
            box_Card("전국 가용병상수", global_total[1, 2], global_total[2, 2], "line_global"),
            div(
              class = "column",
              div(
                class = "ui raised segment",
                style = "width: 100%; height: 700px;",
                highchartOutput("hc_global", width = "100%", height = "100%")
              )
            )
          )
        ),
        ### --- 1.2 Second tab ---
        list(
          menu = "Local", id = "Local_tab",
          content = div(
            class = "ui grid", style = "margin-top: 15px;",
            tabset(
              list(
                list_local("서울", "seoul", 3, 1),
                list_local("부산", "bs", 4, 2),
                list_local("대구", "dg", 5, 3),
                list_local("인천", "ic", 6, 4),
                list_local("광주", "gj", 7, 5),
                list_local("대전", "dj", 8, 6),
                list_local("울산", "ul", 9, 7),
                list_local("세종", "se", 10, 8),
                list_local("경기", "gg", 11, 9),
                list_local("강원", "kw", 12, 10),
                list_local("충북", "cb", 13, 11),
                list_local("충남", "cn", 14, 12),
                list_local("전북", "jb", 15, 13),
                list_local("전남", "jn", 16, 14),
                list_local("경북", "kb", 17, 15),
                list_local("경남", "kn", 18, 16),
                list_local("제주", "jj", 19, 17)
              ),
              active = "seoul_tab",
              id = "localtabset",
              menu_class = "ui vertical menu",
              tab_content_class = "ui bottom stackable"
            )
          )
        ),
        list(
          menu = "Info", id = "info_tab",
          content = div(
            class = "row", class = "margin-left: 15px;",
            div(
              class = "ui segment", style = "width: 700px;",
              h2("Contributor"),
              div(class = "row", h3("김희수"), div(class = "text", "github.com@lunaseorim"))
            ),
            div(
              class = "ui segment", style = "width: 700px; height: 170px;",
              div(class = "text", "LICENSES", style = "font-size:20px;"),
              div(
                class = "row",
                div(
                  class = "inline-block",
                  img(align = "right", src = "hexsticker.png", style = "display: inline; width: 100px; height: 110px;"),
                  h1("shiny.semantic", style = "font-size: 30px; display: inline;"),
                  p("Copyright © 2016 Appsilon Sp. z o.o.", style = "margin-top:15px;")
                )
              )
            ),
            div(
              class = "ui segment", style = "width: 700px;  height: 190px;",
              div(class = "text", "LICENSES", style = "font-size:20px;"),
              div(
                class = "row",
                div(
                  class = "inline-block",
                  img(align = "right", src = "pngegg.png", style = "display: inline; width: 200px;  margin-top:25px;"),
                  h1("highcharts", style = "font-size: 30px; display: inline;"),
                  p("Highcharts (www.highcharts.com) is a Highsoft software product which is
not free for commercial and Governmental use", style = "margin-top:15px;")
                )
              )
            )
          )
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
  output$line_bs <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 부산광역시))
  })
  output$line_dg <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 대구광역시))
  })
  output$line_ic <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 인천광역시))
  })
  output$line_gj <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 광주광역시))
  })
  output$line_dj <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 대전광역시))
  })
  output$line_ul <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 울산광역시))
  })
  output$line_se <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 세종특별자치시))
  })
  output$line_gg <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 경기도))
  })
  output$line_kw <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 강원도))
  })
  output$line_cb <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 충청북도))
  })
  output$line_cn <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 충청남도))
  })
  output$line_jb <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 전라북도))
  })
  output$line_jn <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 전라남도))
  })
  output$line_kb <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 경상북도))
  })
  output$line_kn <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 경상남도))
  })
  output$line_jj <- renderHighchart({
    rec24_beds %>%
      hchart("line", hcaes(x = rc, y = 제주특별자치도))
  })
})

shiny::shinyApp(ui, server)
