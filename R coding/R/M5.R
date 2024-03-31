
ls()
rm(list = ls())

#library
#install.packages("quantreg")

library(ggplot2)
library(quantreg)
##library end


#A-1 LOAD DATA SET:   <. Album Sales 2.dat >  & display the first 6 records
dataA2 <-read.table("AlbumSales2.dat", header = TRUE)
head(dataA2)

#A-2 EXPLORE the DATA SET: List the names of the 4 variables then display the dimensions of the dataset. 
#Finally display the basics quartile statistics of the 4 variables,  
colnames(dataA2)
summary(dataA2)

##length(dataA2[2,])


#A-3 CREATE the LINEAR REGRESSION MODEL of Sales vs Advertisements. Save the model as an R object named  < albumSales.3ad >
##dataA2_AS <- dataA2[1:2]
albumSales.3ad <- ggplot(data = dataA2[2:1], aes(x = adverts, y = sales)) + geom_point() + geom_quantile(formula = y~x ,quantiles = 0.5)
albumSales.3ad


#A-4 What is the CORRELATION COEFFICIENT between Advertisements and Album sales. Save the value as an object named  < r > 
r <- cor(dataA2[2], dataA2[1])
r
#[1] 0.5784877

#A-5 Display the 3 most basicC DESCRIPTIVE STATISTISD for Sales and Advertisements
sapply(dataA2[2:1], mean)
sapply(dataA2[2:1], sd)
sapply(dataA2[2:1], var)


#A-6 What is the COEFFICIENT OF DETERMINATION of Advertisements vs Sales
numad <- dataA2[["adverts"]]
numsa <- dataA2[["sales"]]
summary(lm(numsa ~ numad))$r.squared

#A-7 Compute Total Sum of Squares from a mathematics basic formula

tsssa <- sum((numsa-mean(numsa))^2)
tsssa
#A-8 Compute the Residual Sum of Squares from a mathematical formula

coeff <- lm(formula = numsa ~ numad)$coefficients
predd <- numad * coeff[2] + coeff[1]

rsssa <- sum((numsa-predd)^2)
rsssa
#A-9 Display the intercept and slope of the regression line of Sales vs Advertisements
coeff[1]
coeff[2]


#A10 Create the regression line equation (eg y = a + bx) and display the y coordinate at x = 500
 
ggplot(data.frame(numad, predd),aes(x = numad))+
  geom_line(aes(y=predd))+
  geom_point(aes(x= c(500),y=c(500 * coeff[2] + coeff[1])),color= "red")


#A-11 Create a plot identical to that which is shown: 
 #REPLACE THIS IMAGE WITH YOUR PLOT ANNOTATED WITH YOUR NAME AND CHANGE THE REGRESSION LINE TO RED AND THE ORANGE TRIANGLE TO 
 #BLUE Replace the Professor's last name with your own.
m <- ggplot(data.frame(numad, predd,numsa),aes(x = numad))+
  geom_point(aes(y=numsa), fill = "lightgray")+
  geom_smooth(aes(y = numsa),formula = y ~ x, method = lm, color = "red")+ 
  geom_point(aes(x= c(500),y=c(500 * coeff[2] + coeff[1])),color= "blue",size = 3)
m <- m + labs(x = "Advertising Expense($000)", 
              y = "Album Sales(000 units)",
              title = "Scatter Plot", 
              subtitle = "Sales vs Advertising",
              caption = "Wanqin Su") +
         theme(plot.title = element_text(hjust = 0.5),
               plot.subtitle = element_text(hjust = 0.5),
               plot.caption = element_text(color = "red",face = "italic"))
m 