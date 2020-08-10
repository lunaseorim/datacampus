
# --- Global Environment in shiny ---

# Author : yd0010@20143311 김희수
# Date : 2020-07-28
# Tidyverse Coding Style

## ---Load Package---
library(dplyr)
library(plyr)
library(reshape2)
library(semantic.dashboard)

## --- 1 Global Environmnet // R.data ---

setwd("/home/yd0010/yd_10")

### --- 1.1 icudata.RDS ---
#### raw_icu : 전체데이터
raw_icu <- readRDS("icu_data.rds")


#### icu_data : 현재 시간대 데이터(단일)
icu_data <- readRDS("icu_data.rds") %>%
  `[`(nrow(.), ) %>%
  `colnames<-`(
    c(
      "date", "time", "서울", "부산", "대구", "인천",
      "광주", "대전", "울산", "세종",
      "경기", "강원", "충북", "충남", "전북",
      "전남", "경북", "경남", "제주"
    )
  ) %>%
  melt(id.vars = "date") %>%
  `[`(-1, -1)

### --- 1.2 icu_limit.RDS

beds_lim <- readRDS("total_beds.rds") %>%
  `colnames<-`(c("variable", "value"))

### --- 1.3 icu_global

icu_global <- join(icu_data, beds_lim, by = "variable") %>%
  `colnames<-`(c("variable", "beds", "limit"))

icu_global[,2:3] <- sapply(
  icu_global[,2:3],as.numeric
)


### --- 1.4 calc total_beds ---

tot <- apply(icu_global[2:3], 2, sum)

global_total <- data.frame(
  n1 = c("가용", "사용"),
  n2 = c(tot[1], tot[2] - tot[1]),
  stringsAsFactors = T
) %>%
  `rownames<-`(1:2)
## --- 2 Global Environment // Custom Functions ---

### --- 2.1 shiny box function ---

box_Card <- function(text_1,beds,lim,setid) {
  div(
    class = "column",
    div(
      class = "ui raised segment",
      div(
        class = "ui horizontal divider",
        div(style = "font-size:20px;", icon("procedures"), text_1)
      ),
      p(
        style = "font-size:25px; margin: 15px 0px; text-align: center;",
        paste0(beds, "/", lim)
      ),
      div(
        class = "ui blue progress",
        `data-percent` = round(beds / lim * 100, 2), id = "bar1",
        div(
          class = "bar",
          style = paste0("width:", round(beds / lim * 100, 2), "%;")
        ),
        div(
          class = "label", style = "font-size:15px;",
          paste0(round(beds / lim * 100, 2), "%")
        )
      ), 
      div(
        class = "ui horizontal divider",
        div(style = "font-size:20px;", icon("chart line"), "최근 가용수")
      ),
      div(
        style = "margin-top: 15px; height: 300px;",
        highchartOutput(setid, width = "100%", height = "100%")
      )
    )
  )
}

box_Card_semi <- function(text_1,i,j,setid) {
  div(
    class = "row", style = "width: 450px;",
    div(
      class = "ui raised segment",
      div(
        class = "ui horizontal divider",
        div(style = "font-size:20px;", icon("procedures"), text_1)
      ),
      p(
        style = "font-size:25px; margin: 15px 0px; text-align: center;",
        paste0(as.numeric(raw_icu[nrow(raw_icu), i]), "/", beds_lim$value[j])
      ),
      div(
        class = "ui blue progress",
        `data-percent` = round(as.numeric(raw_icu[nrow(raw_icu), i]) / beds_lim$value[j] * 100, 2), id = "bar1",
        div(
          class = "bar",
          style = paste0("width:", round(as.numeric(raw_icu[nrow(raw_icu), i]) / beds_lim$value[j] * 100, 2), "%;")
        ),
        div(
          class = "label", style = "font-size:15px;",
          paste0(round(as.numeric(raw_icu[nrow(raw_icu), i]) / beds_lim$value[j] * 100, 2), "%")
        )
      ), 
      div(
        class = "ui horizontal divider",
        div(style = "font-size:20px;", icon("chart line"), "최근 가용수")
      ),
      div(
        style = "margin-top: 15px; height: 300px;",
        highchartOutput(setid, width = "100%", height = "100%")
      )
    )
  )
}

list_local <- function(main_name,main_eng,i,j) {
  list(
    menu = main_name , id = paste0(main_eng,"_tab"),
    content =
      box_Card_semi(paste0(main_name," ","가용수"),i, j, paste0("line_","main_eng")))
}
