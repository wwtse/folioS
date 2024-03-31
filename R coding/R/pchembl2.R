
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

ttest= na.omit(select(pchem,starts_with("pChEMBL"),ends_with(".type")))

pcVmean = summarise(pchem,mean(pChEMBL.Value, na.rm = TRUE))
pcVmed = summarise(pchem,median(pChEMBL.Value, na.rm = TRUE))
pcVmode = Mode(ttest$pChEMBL.Value)

ttable = matrix(c(round(pcVmean,3),pcVmed,pcVmode))
rownames(ttable) <- c("mean","median","mode")


#output size 710x546

pic1 <- ggplot(ttest,aes(x=pChEMBL.Value,color=Standard.Type,fill=Standard.Type))+
  geom_histogram(binwidth=0.2)+
  geom_vline(xintercept = as.numeric(pcVmean),size=0.8,color='#FF0099',linetype='dashed')+ 
  geom_vline(xintercept = as.numeric(pcVmed),size=0.8,color='chartreuse3',linetype='dashed')+
  geom_vline(xintercept = as.numeric(pcVmode),size=0.8,color='#9900FF',linetype='dashed')+
  scale_color_manual(values=c("lightblue","#568fe9" ))+
  scale_fill_manual(values=c("lightblue","#568fe9" ))+
  theme_classic()+
  theme(legend.position=c(0.9, 0.55),plot.title=element_text(hjust = 0.5),panel.border=element_rect(colour = "black", fill=NA, size=0.1))+
  annotation_custom(tableGrob(ttable),xmin= 4, xmax = 5,ymin = 35)+
  geom_segment(aes(x = 5.24,xend = 5.24, y = 43.15, yend = 45.95),size=0.8,color='#FF0099')+
  geom_segment(aes(x = 5.24,xend = 5.24, y = 40.15, yend = 42.95),size=0.8,color='chartreuse3')+
  geom_segment(aes(x = 5.24,xend = 5.24, y = 37.15, yend = 39.95),size=0.8,color='#9900FF')+
  labs(title="pChEMBL value Distribution in Standard Types")

pic1


pic2 <- ggplot(ttest,aes(x=pChEMBL.Value,color=Assay.Type,fill=Assay.Type))+
  geom_histogram(binwidth=0.2)+
  geom_vline(xintercept = as.numeric(pcVmean),size=0.8,color='#FF0099',linetype='dashed')+ 
  geom_vline(xintercept = as.numeric(pcVmed),size=0.8,color='chartreuse3',linetype='dashed')+
  geom_vline(xintercept = as.numeric(pcVmode),size=0.8,color='#9900FF',linetype='dashed')+
  scale_color_manual(values=c("#ffb5bb","#ff6773" ))+
  scale_fill_manual(values=c("#ffb5bb","#ff6773" ))+
  theme_classic()+
  theme(legend.position=c(0.9, 0.55),plot.title=element_text(hjust = 0.5),panel.border=element_rect(colour = "black", fill=NA, size=0.1))+
  annotation_custom(tableGrob(ttable),xmin= 4, xmax = 5,ymin = 35)+
  geom_segment(aes(x = 5.24,xend = 5.24, y = 43.15, yend = 45.95),size=0.8,color='#FF0099')+
  geom_segment(aes(x = 5.24,xend = 5.24, y = 40.15, yend = 42.95),size=0.8,color='chartreuse3')+
  geom_segment(aes(x = 5.24,xend = 5.24, y = 37.15, yend = 39.95),size=0.8,color='#9900FF')+
  labs(title="pChEMBL value Distribution in Assay Types")

pic2


