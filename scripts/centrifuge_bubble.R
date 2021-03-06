#!/usr/bin/env Rscript

library(optparse)
library(plyr)
library(ggplot2)

args = commandArgs(trailingOnly=TRUE)

option_list = list(
  make_option(
    c("-d", "--dir"),
    default = "",
    type = "character",
    help = "Centrifuge outdir",
    metavar = "character"
  ),
  make_option(
    c("-e", "--exclude"),
    default = "",
    type = "character",
    help = "Species to exclude",
    metavar = "character"
  ),
  make_option(
    c("-o", "--outdir"),
    default = file.path(getwd(), "plots"),
    type = "character",
    help = "out directory",
    metavar = "character"
  ),
  make_option(
    c("-f", "--outfile"),
    default = 'bubble',
    type = "character",
    help = "out file",
    metavar = "character"
  ),
  make_option(
    c("-t", "--title"),
    default = 'bubble',
    type = "character",
    help = "plot title",
    metavar = "character"
  )
);

opt_parser = OptionParser(option_list = option_list);
opt        = parse_args(opt_parser);
cent.dir   = opt$dir
out.dir    = opt$outdir
file_name  = opt$outfile
plot_title = opt$title
exclude    = unlist(strsplit(opt$exclude,","))

#SETWD: Location of centrifuge_report.tsv files. Should all be in same directory
setwd(cent.dir)

temp = list.files(pattern="*centrifuge_report.tsv")
myfiles = lapply(temp, read.delim)
sample_names <- as.list(sub("*centrifuge_report.tsv", "", temp))
myfiles = Map(cbind, myfiles, sample = sample_names)

#Filter settings, default is to remove human and synthetic constructs
for (i in exclude) {
    myfiles <- llply(myfiles, function(x)x[x$name!=i,])
}

#Proportion calculations: Each species "Number of Unique Reads" is divided by total "Unique Reads"

props = lapply(myfiles, function(x) {
  x$proportion <- ((x$numUniqueReads / sum(x$numUniqueReads)) * 100)
  x$abundance <- x$abundance * 100
  x$hitratio <- x$numUniqueReads / x$numReads
  return(x[,c("name","proportion", "abundance", "genomeSize", "sample", "numReads", "numUniqueReads", "taxID", "hitratio")])
})

#Final dataframe created for plotting, can change proportion value (Default 1%)
final <- llply(props, subset, abundance > 1)
final <- llply(final, subset, proportion > 1)
df <- ldply(final, data.frame)

names(df) <- c("Name", "Proportion", "Abundance", "genomeSize", "sample", "numReads", "numUniqueReads", "taxID", "hitratio")

#SCATTER PLOT WITH POINT SIZE
#Set file name and bubble plot title. Stored in out.dir

jpeg(filename=paste0(out.dir, paste0(file_name,".jpeg")), width = 800, height = 800)
p2 <- ggplot(df, aes(as.factor(sample), as.factor(Name))) + geom_point(aes(size = Proportion))
p2 <- p2 + theme(text = element_text(size=20), axis.text.x = element_text(angle = 90, hjust = 1))
p2 <- p2 + labs(y = "Organism", x = "Sample")
p2 <- p2 + ggtitle(plot_title) + theme(plot.title = element_text(hjust = 0.5))
p2 <- p2 + guides(color=F)
print(p2)
dev.off()

write.csv(df, file = paste0(out.dir, file_name, ".csv"))

