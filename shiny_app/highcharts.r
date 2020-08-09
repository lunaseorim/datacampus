
# --- Highcharts in shiny ---

# Author : yd0010@20143311
# Date : 2020-07-28
# Tidyverse Coding Style

## ---Load Package---
library(highcharter)

setwd("/home/yd0010/yd_10")
source("shiny_app/global.r")

## --- 1. Set Map ---

mapdata <- get_data_from_map(download_map_data("countries/kr/kr-all"))

hc_key <- mapdata %>%
  select("hc-key") %>%
  mutate(variable = c(
    NA, "경기", "전북", "경남", "전남", "부산", "경북", "세종", "대전", "울산",
    "인천", "강원", "충남", "제주", "충북", "서울", "대구", "광주"
  )) %>%
  join(., icu_global, match = "all", "variable") %>%
  mutate(perc = round(beds / limit, 2))

#hcmap(
#  map = "countries/kr/kr-all",
#  data = hc_key,
#  value = "perc",
#  dataLabels = list(enabled = F)
#)

rec24_beds <- raw_icu %>%
  `[`(,-1:-2) %>%
  filter(서울특별시 != 0 , 경상북도 != 0) %>%
  sapply(as.numeric) %>%
  data.frame() %>%
  mutate(total = rowSums(.),
         rc = 1:nrow(.))






