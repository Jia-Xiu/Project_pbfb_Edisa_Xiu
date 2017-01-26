#!/bin/bash
#SBATCH --job-name=project_EX
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --partition=short
pwd

# size annotation and remove singletons
/data/miceco/software/usearch9.2.64_i86linux32 -fastx_uniques seqs.fa -fastaout uniques.fa -sizeout -relabel Uniq
head uniques.fasta

# pick OTUs
/data/miceco/software/usearch9.2.64_i86linux32 -cluster_otus uniques.fa -otus otus.fa -relabel OTU -minsize 2
grep -c "^>" otus.fa

# make otu table
/data/miceco/software/usearch9.2.64_i86linux32 -usearch_global seqs.fa -db otus.fa -strand plus -id 0.97 -otutabout otu_table.txt 








