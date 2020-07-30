library(highcharter)
library(dplyr)
library(reshape2)

icu_data <- readRDS("icu_data.rds")

global_1 <- icu_data[47,]

global_2 <- melt(global_1,id.vars = "date") %>%
  `[`(-1,) %>%
  cbind(data.frame(x = rnorm(17),
                   y = rnorm(17)))

global_2$value <- as.numeric(global_2$value)

hchart(global_2,"scatter",
       hcaes(x,y,
             color = rep("#D1B2FF",17),
             group = variable,
             size = 10),
       showInLegend = FALSE) %>% 
  hc_plotOptions(format =list(
    name = rep("value",17),
    data = global_2$value)) %>%
  hc_plotOptions()

global_total <- c(500,2500-500) %>%
  data.frame() %>%
  `colnames<-`("value") %>%
  cbind(test = c("가용","사용"))

highchart() %>%
  hc_add_series(type = "pie", data = global_total,
                hcaes(x=test,y=value)) %>%
  hc_tooltip(pointFormat = '<b>{point.percentage:.1f}%</b>') %>%
  hc_plotOptions(pie = list(innerSize = "50%", bordercolor = NULL)) %>%
  hc_title(text = "전국",
           verticalAlign = "middle", style = list(fontSize = "100px"))

highchart() %>%
  hc_add_series(
    type = "pie", data = global_total,
    hcaes(x = n1, y = n2)
  ) %>%
  hc_tooltip(pointFormat = "<b>{point.percentage:.1f}%</b>") %>%
  hc_title(
    text = "전국",
    y = 175, style = list(fontSize = "20px")
  ) %>%
  hc_plotOptions(
    pie = list(innerSize = "50%", bordercolor = NULL),
    series = list(dataLabels = F)
  )



