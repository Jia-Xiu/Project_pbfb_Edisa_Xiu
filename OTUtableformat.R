setwd("D:/Project_XE/DataAnalysis")
#changing the OTU table from the output of QIIME to R
otu_table <- read.table("OTUtable.from_biom_w_taxonomy.txt",stringsAsFactors = FALSE)
otu_table <- data.matrix(otu_table)
otu_table <- otu_table[,1:30]
head(otu_table)
write.csv(otu_table,"OTUtable_nontaxon1.txt")

#change the header of "OTUtable_nontaxon1.txt" to "OTUtable_nontaxon.txt" by using "Header_mapping.csv"