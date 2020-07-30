
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

icu_global$beds <- as.numeric(icu_global$beds)
icu_global$limit <- as.numeric(icu_global$limit)

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
box_geo <- function(a) {
  box(
    color = "blue", ribbon = T,
    title = as.character(icu_global$variable[a - 2]), width = 2, solidHeader = TRUE, status = "primary",
    paste0(icu_global$beds[a - 2], "/", icu_global$limit[a - 2])
  )
}
