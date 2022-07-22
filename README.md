# BUAN 4310 Project 3: Predicting home prices in King County

## Objectives:
Regarding this problem, we will analyze a sample from the larger dataset 'kc_house_data_2.csv'. Based on the sample, 
we will build and select an appropriate model for the business, predicting the home prices in King County.

## Data Description:
The house_2.csv dataset represents ten of thousands information from customers, which includes many variables,
like year, prices, number of bathroom, number of bedrooms, zipcode, square feet, etc.

## Data Import:
For the data, we decided to remove all variables that were deemed unecessary. For that, we used scatterplot, correlogram, and domain knowledge.

Some of the removed variables are day of the week, and day of the sale,
since we usually don't know exactly when a person will want to sell. We also removed sqft_living and sqft_lot,
because the sqft_living15 and lot15 variants has post-renovations numbers, so are more up-to-date. 
We kept variables like condition and zipcode, because customers usually care about a house's condition and location.

Outside of removing variables, we turned all the categorical variables into factors 
and remove all the missing values.

## Building & evaluating the model
For the model, we chose a linear regression model because we feel that it is a good fit for this problem, and that it will tell us which variables are the most significant in predicting housing prices.

For actual training, we used seed number 669, and 60/40 training validation split. This means that 60% of the data is used to train the model, while 40% is used for validating whether the model is still good when used on an unfamiliar set of data.

After building the model and checking for errors, we determined that:
- The model is a good fit, with Adjusted R-squared of 80.87%.
- There are 10 variables that are significant in predicting price : Year, bathroom, floors, waterfront, grade, sqft_basement, yr_built, yr_renovated , zipcode and sqft_living15
- Comparing the training set with the validation set, we didn't find any evidence of overfitting.

## Discussion & Evaluation

The final model was fairly accurate, as the RMSE is relatively low, and the adjusted R-squared is also relatively high.

In the real world, many of these variables can be utilized, such as grade. Having a high grade means that the house can sell for higher prices. 
However, A grading system might not be available in all counties, but we also have other variables, such as condition, bathroom, and zipcode, which are all significant and can affect housing prices.
