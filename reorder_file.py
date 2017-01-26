#!/usr/bin/env python

filename = "otu_table.txt"

outfile = "otu_table_reformatted.txt"


out = file(outfile, "wb")

with open(filename, "rb") as f:
    header = f.readline().split("\t")
    for line in f:
        splitline = line.split("\t")
        out.write(splitline[0])
	for i in range(1,len(splitline)):
            if splitline[i] == "1":
                out.write("\t" + header[i])
        out.write("\n")

out.close()
