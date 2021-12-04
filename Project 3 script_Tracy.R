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

# 1. Load data
house <- read.csv("house_2.csv", header = TRUE)
head(house, 10)
names(house)

# 2. Prepare data
## a. Remove unnecessary variables

house_filtered <- house[, -c(1,2,4,5,6,10,11,14,16,17,22,23)]
house_filtered <- drop_na(house_filtered)
names(house_filtered)
str(house_filtered)

names1 <- c("waterfront", "condition")
house_filtered[,names1] <- lapply(house_filtered[,names1], as.factor)
str(house_filtered)

#3. Building regression model

## Partition 
set.seed(666)
train_index <- sample(1:nrow(house_filtered), 0.6 * nrow(house_filtered))
valid_index <- setdiff(1:nrow(house_filtered), train_index)

## Inputting index to the variables
train_df <- house_filtered[train_index, ]
valid_df <- house_filtered[valid_index, ]

## Counting data of training and validiation
nrow(train_df)
nrow(valid_df)

## Comparing traning set and validation set
compare_df_cols(train_df, valid_df)

## Explore the relationship
## a. Corgram
corrgram(train_df)
## b. Scatterplot
ggplot(data = train_df) + aes(x = price, y = sqft_living15) +
  geom_point() +
  ggtitle ("The correlation between price and living") +
  geom_smooth(method=lm, se= TRUE) +
  stat_cor(method = "pearson", label.x = 1000, label.y = 3)

### Living room area in 2015 has the strongest relationship with Price
## Build model from the training set
price_model <- lm(price ~ ., data = train_df) 
summary(price_model) 

### Base on the summary, we could interpret:
### Base on the F stat and p-value, I could say this model is pretty significant
### The Adjusted R-squared is also relatively high : 54.19 %, which indicates a relatively good fit.
### There are 9 variables that are significant in predicting FARE : Year, bedrooms, bathrooms, floors,
### waterfront, sqft_basement, yr_built, yr_renovated and sqft_living15
### The most significant variable is Sqft_living15 (as expected) with the lowest p-value.

## Predicting
price_model_prediction_train <- predict(price_model, train_df)
price_model_prediction_valid <- predict(price_model, valid_df)

## Comparing errors between training and validation sets
accuracy(price_model_prediction_train, train_df$price)
accuracy(price_model_prediction_valid, valid_df$price)

####  The RMSE of the training set is slightly higher than the RMSE of validation set
#### => The model is good at prediction.
### The RMSE is relatively low, which indicates a good model.


# 4. Predict new prices for new houses
names(house_filtered)
## a. Import new records
house_test2 <- read.csv("house_test_2.csv", header = TRUE)
names(house_test_2)
house_test_filtered <- house_test2[, -c(1,2,4,5,6,9,10,13,15,16,21,22)]
names(house_test_filtered)
str(house_test_filtered)
## b.Convert "waterfront" and "condition" into factor
names2 <- c("waterfront", "condition")
house_test_filtered[,names2] <- lapply(house_test_filtered[,names2], as.factor)
str(house_test_filtered)
## Predict record 1
house_1 <- house_test_filtered[1,]
new_route_prediction <- predict(price_model, house_1)
new_route_prediction

#### The price of the first record is $181997.1

## Predict record 2
house_2 <- house_test_filtered[2,]
new_route_prediction <- predict(price_model, house_2)
new_route_prediction
#### The price of the second record is $434054.2

## Predict record 2
house_3 <- house_test_filtered[3,]
new_route_prediction <- predict(price_model, house_3)
new_route_prediction
#### The price of the last record is $517144.6 
