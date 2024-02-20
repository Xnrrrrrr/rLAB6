#Step 1: Load the dat file "lesson6.dat" in R using read.delim() function.

breachData <- read.delim("lesson6.dat", header = TRUE)

#Step 2: Check the trend that we have in data. We want to make sure if there is a linear trend in the data.
library(ggplot2)
breachPlot <- ggplot(breachData, aes(per_sensitive, cost_controls)) # this command is used to create the empty canvas (first layer)
breachPlot + geom_point() # this command is used to create the base plot representing data with data points


#Step 3: Run a regression analysis using the lm() function.

regBreach <- lm(cost_controls ~ per_sensitive, data = breachData)
#where const_controls is outcome variable and per_sensitive is predictor.

#Step 4: Use summary () function to generate output of the regression analysis.

summary(regBreach)

#Step 5: Insert the regression model into ggplot in order to add a line to the scatterplot. 

breachPlot + geom_point() + geom_line(data=fortify(regBreach), aes(x=per_sensitive, y=.fitted)) # use geom_line () function. It adds the line to the base plot by using the fortified fit data, plotting the x vs. the fitted values.



# Step 6: Test the assumption of 'Independence of Observations' running the Durbin-Watson test on your regression model.
          #we use the dwt() function for running this test.
          #To run this test, you’ll first need to install and load the “car” package.

install.packages("car")
library(car)
dwt(regBreach)


# Step 7: Evaluate the homogeniety of variance by plotting the residuals agains the fitted/predicted values.
    # substitute regBreach with the name of your regression model.   
    # In the syntax below, the argument “which = 1” specifies that we would like to see only the first set of diagnostics on our linear model, which is a plot of residuals against our fitted/predicted values.

plot(regBreach, which = 1)   


#Step 8: Evaluate the normality by plotting the residuals against what we would theoretically expect them to be if our data was normal.
    #substitute regBreach with the name of your regression model.       
    #In the syntax below, the argument "which = 2" specifies that we would like to see only the second set of diagnostics on our linear model, which is a Normal Q-Q plot

plot(regBreach, which = 2)   

# Step 9: The normality can also be evaluated by using the Shapiro-Wilk Test. To do so, we should first create residuals in our data frame by using the following sytax.

breachData$residuals <- resid(regBreach) # where regBreachk is the object used to store the results of our analysis.
                                    # resid() is the function that is used to create residuals
                                    # residuals is the name of new column that consists of residuals.
                                    # cyberdata is our data frame
shapiro.test(breachData$residuals)


#Step 10: Use the following syntax to standardize your residuals. We will use standardized residuals to detect if you have outliers and where they are.
#You’ll need to replace breachData with the name of your data frame and regBreach with your regression model
# When you run the following syntax, a new variable called "std.r" is added to your data frame.
# An observation with a standardized residual that is larger than 2 (in absolute value) is deemed to be an outlier.
breachData$std.r <- rstandard(regBreach) 
