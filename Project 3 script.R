library(rpart)
library(rpart.plot)
library(forecast)
library(caret)
library(ISLR)
require(tree)
library(tidyr)
library(dplyr)
library(janitor)
library(ROSE)
library(ggplot2)
library(corrgram)
library(forecast)
#install.packages("ggsignif")
#install.packages("rstatix")
library(ggpubr)
library(forecast)
house <- read.csv("house_2.csv", header = TRUE)
head(house, 10)
names(house)

house_filtered <- house[, -c(1,2,4,5,6,10,11,14,16,17,22,23)]
house_filtered <- drop_na(house_filtered)
names(house_filtered)
str(house_filtered)

names1 <- c("waterfront", "condition")
house_filtered[,names1] <- lapply(house_filtered[,names1], as.factor)
str(house_filtered)




set.seed(666)
train_index <- sample(1:nrow(house_filtered), 0.6 * nrow(house_filtered))
valid_index <- setdiff(1:nrow(house_filtered), train_index)

# Inputting index to the variables
train_df <- house_filtered[train_index, ]
valid_df <- house_filtered[valid_index, ]

# Counting data of training and validiation
nrow(train_df)
nrow(valid_df)

compare_df_cols(train_df, valid_df)

corrgram(train_df)

ggplot(data = train_df) + aes(x = price, y = sqft_living15) +
  geom_point() +
  ggtitle ("The correlation between price and living") +
  geom_smooth(method=lm, se= TRUE) +
  stat_cor(method = "pearson", label.x = 1000, label.y = 3)

price_model <- lm(price ~ ., data = train_df) 
summary(price_model) 

# Base on the summary, we could interpret:
# Base on the F stat and p-value, I could say this model is pretty significant
# and base on the r-square and adjusted r-square, it's a good model too.
# Some other factors that are significant in predicting the airfare are listed:
# bathrooms, floors, waterfront1, sqft_basement, yr_built, sqft_living15
# And once again, with the smallest p-value, Square Living is the best predictor for airfare

price_model_prediction <- predict(price_model, valid_df)
accuracy(price_model_prediction, valid_df$price)
sd(valid_df$price)

names(house_filtered)
### Predict new prices for new houses
house_test2 <- read.csv("house_test_2.csv", header = TRUE)
names(house_test_2)
house_test_filtered <- house_test2[, -c(1,2,4,5,6,9,10,13,15,16,21,22)]
names(house_test_filtered)
str(house_test_filtered)

names2 <- c("waterfront", "condition")
house_test_filtered[,names2] <- lapply(house_test_filtered[,names2], as.factor)
str(house_test_filtered)

house_1 <- house_test_filtered[1,]
new_route_prediction <- predict(price_model, house_1)
new_route_prediction

house_2 <- house_test_filtered[2,]
new_route_prediction <- predict(price_model, house_2)
new_route_prediction

house_3 <- house_test_filtered[3,]
new_route_prediction <- predict(price_model, house_3)
new_route_prediction
