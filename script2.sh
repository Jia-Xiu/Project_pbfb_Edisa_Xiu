#!/bin/bash
#SBATCH --job-name=project_EX
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --partition=short
pwd
module load QIIME/1.9.1-foss-2016a-Python-2.7.11-tmp
module list

# Pick representative OTU sequences
pick_rep_set.py -i seqs_otus.txt -f seqs.fa -o rep.fna

# Assign_taxonomy
assign_taxonomy.py -i rep_edited.fa -m uclust -o uclust_assigned_taxonomy -r 94_otus.fasta -t 94_otu_taxonomy.txt

####### Make_otu_table with taxonomy######
make_otu_table.py -i seqs_otus.txt -t uclust_assigned_taxonomy/rep_tax_assignments.txt -o otu_table1.biom

# Remove singletons (Alternate step):
filter_otus_from_otu_table.py -i otu_table1.biom -o otu_table2.biom -n 2

# Remove Unassigned
filter_taxa_from_otu_table.py -i otu_table2.biom -n Unassigned -o otu_table.biom

# convert to txt file with taxonomy:
biom convert -i otu_table.biom -o OTUtable.from_biom_w_taxonomy.txt --header-key taxonomy --to-tsv