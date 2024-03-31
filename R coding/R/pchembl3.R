
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("reshape2")
install.packages("ggthemes")
install.packages("dplyr")
install.packages("gridExtra")
library(ggplot2)
library(reshape2)
library(ggthemes)
library(dplyr)
library(gridExtra)
library(tidyverse)


Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

pchem=read.csv("pchembl.csv",header = TRUE, sep =";")
ttest= na.omit(select(pchem,starts_with("pChEMBL"),ends_with(".type")))

pcVmean = summarise(pchem,mean(pChEMBL.Value, na.rm = TRUE))
pcVmed = summarise(pchem,median(pChEMBL.Value, na.rm = TRUE))
pcVmode = Mode(ttest$pChEMBL.Value)


table=c(pcVmean,pcVmed,pcVmode)
stas=c(paste("mean=",round(pcVmean,3)),paste("median=",pcVmed),paste("mode=",pcVmode)) #Note! change the variable names with the values you calculated
statis=data.frame(stas,table)


#Create two graphs
plt1=ggplot(ttest, aes(x=pChEMBL.Value)) + 
  geom_histogram(colour="lightblue", fill="lightblue",binwidth = 0.1)+
  ggtitle("The Histogram of pChembl Value of CHEMBL402")+
  geom_vline(data=statis, aes(xintercept = as.numeric(table), color=stas),linetype="dashed",size=1.1)+
  theme(legend.position = "top")+
  theme(legend.title= element_blank())+
  theme(legend.text= element_text(size=15))
plt1


plt2=ggplot(ttest, aes(x=Assay.Type))+geom_bar(colour="lightblue", fill="lightblue")+
  geom_text(aes(label = ..count..), stat = "count", vjust = -0.25, colour = "black")+
  ggtitle("The Assay Type of CHEMBL402")


plt2

