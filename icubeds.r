
# ---call data. ICU Beds ---

# Author : yd0010@20143311
# Date : 2020-07-21
# Tidyverse Coding Style

## ---Load Package---
library(XML)
library(dplyr)
#library(telegram.bot)

setwd("/home/yd0010/yd_10")

## ---Set @rds & api call ---

service_url <- "http://apis.data.go.kr/B552657/ErmctInfoInqireService/getEmrrmRltmUsefulSckbdInfoInqire"

key <- "U4w7BijQ6qci%2FlbAiD8etN%2BUCpUpfoGtgobjwPUiyhe8MFvYoT977SnWBGvU9KSZdCR%2Foyz67FZHx7IEWfL%2FRw%3D%3D"

icu_data <- readRDS("icu_data.rds")

geo_name <- c(
  "서울특별시", "부산광역시", "대구광역시", "인천광역시",
  "광주광역시", "대전광역시", "울산광역시", "세종특별자치시",
  "경기도", "강원도", "충청북도", "충청남도", "전라북도",
  "전라남도", "경상북도", "경상남도", "제주특별자치도"
)

xpath_result <- "/response/body/items/item"

a2 <- NULL

## ---Load data from api---

for (i in 1:17) {
  url <- paste0(
    service_url,
    paste0(
      "?STAGE1=", URLencode(iconv(geo_name[i], to = "UTF-8")),
      "&pageNo=1&numOfRows=1000"
    ),
    paste0("&ServiceKey=", key)
  )

  res2 <- xpathApply(xmlRoot(xmlParse(url)), xpath_result)

  a1 <- xmlToDataFrame(res2)

  a2[i + 2] <- if (is.factor(a1$hvicc)) {
    sum(as.numeric(
      levels(a1$hvicc)
    )[a1$hvicc], na.rm = T)
  } else {
    sum(as.numeric(a1$hvicc), na.rm = T)
  }
}

a2[1:2] <- c(
  as.character(Sys.Date()),
  format(Sys.time(), "%H")
)

icu_data <- rbind(icu_data, a2)

## ---Save RDS < icu_data.rds >---

saveRDS(icu_data, "icu_data.rds")


## ---Report @telegram.bot---
#seor_bot <- Bot(token = "1366384353:AAE2uhGZI-ucKS4TSqwomdaNepU7l8nP1gw")
#my_id <- "939729298" # id : 939729298
#beds_cond <- any(is.na(a2)) | any(a2 == 0)
#if (beds_cond) {
#  seor_bot$sendMessage(my_id,
#    text = paste0("데이터 이상 발생","\n",Sys.time())
#  )
#}
