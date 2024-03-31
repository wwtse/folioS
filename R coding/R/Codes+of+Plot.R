library(ggplot2, lib.loc = "D:/Program Files/R/R-4.0.3/library")
library(tidyverse)

#Import your dataset and change the assay type names.
data=mydata
data=data %>% drop_na(pChEMBL.Value)
data$Assay.Type<-ifelse(data$Assay.Type=="A","ADME",
                        ifelse(data$Assay.Type=="B","Binding","Functional"))

mydata$Assay.Type<-ifelse(mydata$Assay.Type=="A","ADME", ifelse(mydata$Assay.Type=="F","Functional","Binding"))

#create a function to get the mode
x=data$pChEMBL.Value
Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}
mode=Mode(x)
mean=mean(x)
median=median(x)

#Create a data frame like this
#          stas   value
# 1   mean=6.99 6.99373
# 2 median=6.91 6.91000
# 3    mode=6.1 6.10000
value=c(mean,median,mode)
stas=c("mean=6.99","median=6.91","mode=6.10") #Note! change the variable names with the values you calculated
statis=data.frame(stas,value)

#Create two graphs
plt1=ggplot(data, aes(x=pChEMBL.Value)) + 
  geom_histogram(colour="black", fill="#56B4E9",binwidth = 0.1)+
  ggtitle("The Histogram of pChembl Value of CHEMBL213")+
  geom_vline(data=statis, aes(xintercept = value, color= stas),linetype="dashed",size=1.1)+
  theme(legend.position = "top")+
  theme(legend.title= element_blank())+
  theme(legend.text= element_text(size=15))
plt1

plt2=ggplot(mydata, aes(x=Assay.Type))+geom_bar(colour="black", fill="#56B4E9")+
  geom_text(aes(label = ..count..), stat = "count", vjust = -0.25, colour = "black")+
  ggtitle("The Assay Type of CHEMBL213")

plt2