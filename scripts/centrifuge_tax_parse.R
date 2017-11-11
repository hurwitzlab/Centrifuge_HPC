#!/usr/bin/env Rscript

library(optparse)
library(data.table)

args = commandArgs(trailingOnly=TRUE)

option_list = list(
  make_option(
    c("-f", "--file"),
    default = "",
    type = "character",
    help = "Centrifuge Hits File",
    metavar = "character"
  ),
  make_option(
    c("-i", "--id"),
    default = "",
    type = "character",
    help = "Taxonomy ID",
    metavar = "character"
  ),
  make_option(
    c("-o", "--out"),
    default = "",
    type = "character",
    help = "Output Directory",
    metavar = "character"
  )
);

opt_parser = OptionParser(option_list = option_list);
opt        = parse_args(opt_parser);
cent.hit   = opt$file
tax.id     = as.character(opt$id)
out.dir    = opt$out

base <- basename(cent.hit)
file.name = sub("*centrifuge_hits.tsv", "", base)

#READ CENTRIFUGE HITS FILES
df <- fread(cent.hit)

#GET SEQUENCE IDS FOR SPECIFIED TAX ID
seq.id <- unique(df$readID[which(df$taxID == tax.id)])

#WRITE IDS TO FILE
cat(seq.id, file = paste(out.dir,paste0(file.name, tax.id, ".ids"), sep = "/"), sep = "\n") 
