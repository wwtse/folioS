

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


Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}


pchem=read.csv("pchembl.csv",header = TRUE, sep =";")

ttest= na.omit(select(pchem,starts_with("pChEMBL")))
pcVmean = summarise(pchem,mean(pChEMBL.Value, na.rm = TRUE))
pcVmed = summarise(pchem,median(pChEMBL.Value, na.rm = TRUE))
pcVmode = Mode(ttest$pChEMBL.Value)

ttable = matrix(c(round(pcVmean,3),pcVmed,pcVmode))
rownames(ttable) <- c("mean","median","mode")


hhist = ggplot(ttest,aes(x=pChEMBL.Value))+
  geom_histogram(aes(y=..density..),binwidth=0.2,color="white",fill="lightblue")+
  geom_vline(xintercept = as.numeric(pcVmean),size=0.8,color='#FF0099')+ 
  geom_vline(xintercept = as.numeric(pcVmed),size=0.8,color='chartreuse3')+
  geom_vline(xintercept = as.numeric(pcVmode),size=0.8,color='#9900FF')+
  theme_classic()+
  geom_density(color='#66CCFF',size=1, linetype='dashed')+
  annotation_custom(tableGrob(ttable),xmin= 8.7,ymin = 0.55)+
  geom_segment(aes(x = 9.2,xend = 9.2, y = 0.661, yend = 0.7),size=0.8,color='#FF0099')+
  geom_segment(aes(x = 9.2,xend = 9.2, y = 0.621, yend = 0.66),size=0.8,color='chartreuse3')+
  geom_segment(aes(x = 9.2,xend = 9.2, y = 0.581, yend = 0.62),size=0.8,color='#9900FF')

hhist

