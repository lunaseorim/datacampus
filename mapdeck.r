
## --- ggmap ---
## Tidyverse coding style

library(mapdeck)
library(plyr)

key <- "pk.eyJ1IjoibHVuYXNlb3JpbSIsImEiOiJjazJjd3A0Z3IwajAzM2RvMjJvNWdqOGM5In0.C8bch4gbQBoRMccrAeCv8Q"

cctv <- read.csv("CCTV2.csv", fileEncoding = "CP949")

cctv1 <- cctv[!is.na(cctv$위도) | !is.na(cctv$경도), ]

cctv2 <- cctv1[1:3000, c(5, 11, 12)] %>%
  `colnames<-`(c("value", "lat", "lon"))


mapdeck(token = key, style = mapdeck_style("dark"), pitch = 40) %>%
  add_grid(
    data = cctv2,
    lat = "lat",
    lon = "lon",
    layer_id = "hex_layer",
    elevation_scale = 200,
    elevation = "value"
  )
