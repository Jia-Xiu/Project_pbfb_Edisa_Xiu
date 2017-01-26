#Load librarES
library(vegan)
library(plyr)
library(doBy)
library(ggplot2)

# Set working directory
setwd("D:/Project_XE/DataAnalysis")

# Using the OTU table to calculate alpha diversity
otu_table <- read.table("OTUtable_nontaxon.txt",row.names=1,header=1,stringsAsFactors = FALSE)
otu_table <- data.matrix(otu_table)
otu_table<-t(otu_table) #Transpose the data
str(otu_table)
otu_table[1:10,1:20]

# Calculate alpha diversity
data.species <- specnumber(otu_table)
data.shannon <- diversity(otu_table, index="shannon")
data.simpson <- diversity(otu_table, index="simpson")
data<-rbind(data.species, data.shannon, data.simpson)
data<-t(data)
data <- data.frame(data)
data <- rename(data, c("data.species"="Richness", "data.shannon"="Shannon", "data.simpson"="Simpson"))
str(data)
head(data)
write.table(data, file="alpha_diversity.csv",row.names=T)

#################################
# plot theme
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
        legend.background=element_blank(), 
        legend.key=element_blank())

# Add group information
grouping_info<-data.frame(row.names=rownames(data),t(as.data.frame(strsplit(rownames(data),"_"))))
head(grouping_info)
alpha=data.frame(Richness=data[,1],Shannon=data[,2],Simpson=data[,3],Month=as.factor(grouping_info[,1]),Stages=as.factor(grouping_info[,2]),Replicates=as.factor(grouping_info[,3]))
head(alpha)

# Calculate the average, sd and se of Richness
dstats<-function(x)(c(n=length(x), mean=mean(x), sd=sd(x)))
result<-summaryBy(Richness~Month+Stages, data=alpha, FUN=dstats)
result$Richness.se <- result$Richness.sd/sqrt(result$Richness.n)
result
str(result)

# Plot richness
p<-ggplot(result,aes(x=Stages,y=Richness.mean,fill=Month))+
  scale_fill_manual(values=c("#FFFFFF","#999999"),labels=c("July", "May"))+
  geom_errorbar(aes(ymin=Richness.mean-Richness.se, ymax=Richness.mean+Richness.se), position=position_dodge(0.8), width=.2)+
  geom_bar(stat="identity",width=0.8,colour="black",position="dodge")+
  scale_x_discrete(breaks = c("A","B","C","D","E"),labels=c("0","5","35","65","105"))+
  labs(x="Stages of succession (in years)",y="OTU Richness")+
  mytheme
p
ppi=300
png("Richness.png",width=5*ppi,height=4*ppi,res=ppi)
print(p)
dev.off()

##########################################################################
# Calculate the average, sd and se of Shannon
dstats<-function(x)(c(n=length(x), mean=mean(x), sd=sd(x)))
result<-summaryBy(Shannon~Month+Stages, data=alpha, FUN=dstats)
result$Shannon.se <- result$Shannon.sd/sqrt(result$Shannon.n)
result
str(result)

# Plot Shannon
p<-ggplot(result,aes(x=Stages,y=Shannon.mean,fill=Month))+
  scale_fill_manual(values=c("#FFFFFF","#999999"),labels=c("July", "May"))+
  geom_errorbar(aes(ymin=Shannon.mean-Shannon.se, ymax=Shannon.mean+Shannon.se), position=position_dodge(0.8), width=.2)+
  geom_bar(stat="identity",width=0.8,colour="black",position="dodge")+
  scale_x_discrete(breaks = c("A","B","C","D","E"),labels=c("0","5","35","65","105"))+
  labs(x="Stages of succession (in years)",y="OTU Shannon")+
  mytheme
p
ppi=300
png("Shannon.png",width=5*ppi,height=4*ppi,res=ppi)
print(p)
dev.off()

##########################################################################
# Calculate the average, sd and se of Simpson
dstats<-function(x)(c(n=length(x), mean=mean(x), sd=sd(x)))
result<-summaryBy(Simpson~Month+Stages, data=alpha, FUN=dstats)
result$Simpson.se <- result$Simpson.sd/sqrt(result$Simpson.n)
result
str(result)

# Plot Simpson
p<-ggplot(result,aes(x=Stages,y=Simpson.mean,fill=Month))+
  scale_fill_manual(values=c("#FFFFFF","#999999"),labels=c("July", "May"))+
  geom_errorbar(aes(ymin=Simpson.mean-Simpson.se, ymax=Simpson.mean+Simpson.se), position=position_dodge(0.8), width=.2)+
  geom_bar(stat="identity",width=0.8,colour="black",position="dodge")+
  scale_x_discrete(breaks = c("A","B","C","D","E"),labels=c("0","5","35","65","105"))+
  labs(x="Stages of succession (in years)",y="OTU Simpson")+
  mytheme
p
ppi=300
png("Simpson.png",width=5*ppi,height=4*ppi,res=ppi)
print(p)
dev.off()