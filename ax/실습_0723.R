
#---실습 0723---
# Tidyverse Coding Style

library(dplyr)
library(car)
library(psych)
library(moonBook)
library(ROCR)
library(Epi)

## ---Load Data---
dat <- read.csv("data/framingham2.csv")[, -1] %>%
  `colnames<-`(c(
    "성별", "나이", "흡연횟수", "콜레스트롤수치", "수축기혈압",
    "확장기혈압", "비만측정수치", "심작방독수", "포도당농도", "심장병여부"
  ))

str(dat)

dat$성별 <- as.factor(dat$성별)
dat$심장병여부 <- factor(dat$심장병여부,
  levels = 0:1, labels = c("없음", "있음")
)

## ---Set Train---

set.seed(1234)
idx <- sample(nrow(dat), 0.7 * nrow(dat))
train <- dat[idx, ]
test <- dat[-idx, ]

## ---Backward Stepwise Selection of GLM---

fit <- glm(심장병여부 ~ ., data = train, family = "binomial")

summary(fit)

fit.backward <- step(fit,
  scope = list(lower = 심장병여부 ~ 1),
  direction = "backward"
)
summary(fit.backward)

anova(fit.backward, test = "Chisq")

## ---다중공선성 확인---
pairs.panels(dat[names(dat[, -9])])

vif(fit.backward)

## ---Odds Ratio---

fit.backward$coefficients
exp(fit.backward$coefficients)

extractOR(fit.backward)

predict_prob <- predict(fit.backward, test, type = "response")
predict_prob

range(predict_prob, na.rm = T)
summary(predict_prob)

predict_CHD <- ifelse(
  predict_prob > 0.5,
  "있음", "없음"
)

result <- data.frame(
  actual = test$심장병여부,
  predicted = predict_CHD,
  pred_prob = predict_prob
)

table(result$actual,result$predicted)

misClasificError <- mean(predict_CHD !=test$심장병여부)

pr <- prediction(predict_prob,test$심장병여부)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

auc <- performance(pr, measure = "auc")
auc <- auc@y.values[[1]]
auc

ROC(form = fit.backward$formula, data = test, plot = "ROC")


