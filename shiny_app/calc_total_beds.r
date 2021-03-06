
# --- Load Total_ICU_Beds ---

# Author : yd0010@20143311
# Date : 2020-07-24
# Tidyverse Coding Style

## ---Load Package---
library(XML)
library(dplyr)

## ---Set @rds & api call ---

service_url1 <- "http://apis.data.go.kr/B552657/ErmctInfoInqireService/getEmrrmRltmUsefulSckbdInfoInqire"

service_url2 <- "http://apis.data.go.kr/B552657/ErmctInfoInqireService/getEgytBassInfoInqire"

key <- "U4w7BijQ6qci%2FlbAiD8etN%2BUCpUpfoGtgobjwPUiyhe8MFvYoT977SnWBGvU9KSZdCR%2Foyz67FZHx7IEWfL%2FRw%3D%3D"

geo_name <- c(
  "서울특별시", "부산광역시", "대구광역시", "인천광역시",
  "광주광역시", "대전광역시", "울산광역시", "세종특별자치시",
  "경기도", "강원도", "충청북도", "충청남도", "전라북도",
  "전라남도", "경상북도", "경상남도", "제주특별자치도"
)

xpath_result <- "/response/body/items/item"

a2 <- NULL
total_beds <- data.frame(
  geo = geo_name,
  value = 0
)

## ---Load data from api---

for (i in 8) {
  url <- paste0(
    service_url1,
    paste0(
      "?STAGE1=", URLencode(iconv(geo_name[i], to = "UTF-8")),
      "&pageNo=1&numOfRows=1000"
    ),
    paste0("&ServiceKey=", key)
  )

  res2 <- xpathApply(xmlRoot(xmlParse(url)), xpath_result)

  a1 <- xmlToDataFrame(res2)

  a2 <- a1$hpid

  for (j in 1:length(a2)) {
    url2 <- paste0(
      service_url2,
      paste0(
        "?HPID=", a2[j],
        "&pageNo=1&numOfRows=1000"
      ),
      paste0("&ServiceKey=", key)
    )

    res2_1 <- xpathApply(xmlRoot(xmlParse(url2)), xpath_result)

    a2_1 <- xmlToDataFrame(res2_1)

    b1 <- rbind(b1, c(
      a2[j],
      if (!is.null(a2_1$hpicuyn)) {
        as.numeric(levels(a2_1$hpicuyn))
      } else {
        NA
      }
    ))

    total_beds[i, 2] <- total_beds[i, 2] + if (!is.null(a2_1$hpicuyn)) {
      as.numeric(levels(a2_1$hpicuyn))
    } else {
      0
    }
  }
}


b1 <- data.frame(
  x = "asd",
  value = 0,
  stringsAsFactors = F
)
