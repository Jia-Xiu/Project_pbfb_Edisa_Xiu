library(ggplot2)
library(RColorBrewer)
library(vegan)

setwd("D:/Project_XE/DataAnalysis")

otu_table <- read.table("OTUtable_nontaxon.txt",row.names=1,header=1,stringsAsFactors = FALSE)
otu_table <- data.matrix(otu_table)
otu_table<-t(otu_table)
str(otu_table)
otu_table[1:5,1:6]

#Get grouping information
grouping_info<-data.frame(row.names=rownames(otu_table),t(as.data.frame(strsplit(rownames(otu_table),"_"))))
head(grouping_info)

#Get MDS stats
sol<-metaMDS(otu_table,distance = "bray", k = 2, trymax = 50)
summary(sol)

# Make a new data frame, adding Month and Stages information
NMDS=data.frame(x=sol$point[,1],y=sol$point[,2],Month=as.factor(grouping_info[,1]),Stages=as.factor(grouping_info[,2]),Replicates=as.factor(grouping_info[,3]))
NMDS

# Make NMDS plot
# Set the plot theme
mytheme<-theme_bw()+
  theme(plot.title=element_text(size=rel(1.2),
                                face="bold",colour="black",hjust=0.5),
        panel.border=element_rect(colour="black",fill=NA,size=1.2),
        strip.text=element_text(face="bold",size=rel(1.2)),
        strip.background=element_blank(),
        axis.text.x=element_text(colour="black",size=rel(1.2)),
        axis.text.y=element_text(colour="black",size=rel(1.2)),
        axis.ticks=element_line(colour="black",size=rel(1.2)),
        axis.title=element_text(size=rel(1.2)),
        legend.text=element_text(size=rel(1.2),face="italic"),
        legend.title=element_blank(),
        legend.position=c(0.85,0.45), 
        legend.background=element_blank(), 
        legend.key=element_blank())

# Set the color
palette<-c("#000099","#33CC00","#660033","#FF0000","#FFFF00")

p<-ggplot(data=NMDS,aes(x,y,colour= Stages))+
  annotate("text",x=-0.4,y=0.6,label="Stress=0.0748")+
  geom_point(aes(shape = Month),size=3)+
  labs(x="",y="", title=" ")+
  scale_fill_brewer()+
  scale_colour_manual(values=palette,breaks = c("A","B","C","D","E"),labels=c("0","5","35","65","105"))
  scale_shape_manual(values=c(23,15))+
  mytheme
p

ppi<-300
png("NMDS_Month.png",width=5*ppi,height=4*ppi,res=ppi)
print(p)
dev.off()

