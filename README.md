# Centrifuge
Run Centrifuge on metagenomic samples and generate bubble plot visualizations.

QUICKSTART:

1. Edit config.sh
2. ./submit.sh


Edit the variables found in config.sh. Here is a description of each:

- Leave these two the same
export CWD=$PWD
export SCRIPT_DIR="CWD/scripts"

-State where the Centrifuge Database is located. Default for Hurwitz Lab
export CENT_DB="/rsgrps/bhurwitz/jetjr/cent-db/p_compressed+h+v"

-Directory with sample FASTA/Q files
export FASTA_DIR="/path/to/your/fasta/files"

-Single or Paired End? More information on paired end data below
export TYPE="paired"
or
export TYPE="single"

-FASTA/Q File Extension excluding the dot
export FILE_EXT="fq" 
or 
export FILE_EXT="fastq"
or
export FILE_EXT="fa"
etc...

-Report Directory is for Centrifuge Output and will be used for the generation of bubble plots

export REPORT_DIR="/centrifuge/output/reports"

-The output directory for the bubble plot
export PLOT_OUT="/plot/goes/here"

-Plot file name is the name of the file and will be placed in the PLOT_OUT directory. Only edit the actual title and do not include an extension
export PLOT_FILE="$PLOT_OUT"/bubble

-Plot title is the actual title found on the plot
export PLOT_TITLE="MY_BUBBLE_PLOT"

-File type is either "f" for fasta format or "q" for fastq format
export FILE_TYPE="q"

#Exclude hits by stating taxid in following format ("taxid1,taxid2")
export EXCLUDE="9606" (would exclude Homo sapiens). 

# Paired End Files
If you are using paired-end files you also must edit the script centrifuge_paired_tax.sh

The Centrifuge command looks like this in the script:

centrifuge -x $CENT_DB -1 $FASTA.paired.1.fastq -2 $FASTA.paired.2.fastq -U $FASTA.singletons.fastq -S $REPORT_DIR/$FASTA-centrifuge_hits.tsv --report-file $REPORT_DIR/$FASTA-centrifuge_report.tsv -$FILE_TYPE

-1 is the forward reads, -2 is the reverse, and -U is single reads. You must change the naming scheme of the paired end files. In this example the paired end files use paired.1.fastq for forward and paired.2.fastq for the reverse. A file of single reads singletons.fastq is also inputted. If you do not have single reads to accompany the paired end make sure to remove the -U option. 

# Using centrifuge_bubble.R on its own
If you already have centrifuge report files, there is no need to run the entire workflow to generate the bubble plot. Instead the bubble plot can be used on its own:

./centrifuge_bubble.R -d /report/directory/ -o /plot/out/dir -f file_name -t file_title

# Editing the centrifuge_bubble.R

Included in the script is a subset that only includes classifications reaching a specific threshold with the default being 1% (line 29). Simply change the proportion > 0.01 to whatever value you desire. Often it is necessary to increase this value if too many species are classified at the 1% level. 

It's likely that the image dimensions and/or text size will need to be adjusted in order to create the perfect plot:

Image Dimensions (line 41):
png(filename=paste0(out.dir, paste0(file_name,".png")), width = 800, height = 800)

Axis Text Size (43):
p2 <- p2 + theme(text = element_text(size=20), axis.text.x = element_text(angle = 90, hjust = 1)) 

# Extract Sequences Matching Specified Taxonomy ID

It is possible to extract sequences that were classified as a specified taxonomy ID by parsing the Centrifuge hits file. Instructions for doing so are as follows:

1) Navigate to the scripts folder.
2) Edit the get_seqs.sh file
   CENT_HIT should be the FULL path to the centrifuge hits file 
   FASTA should be the FULL path to the sequence file for the related centrifuge hit file
   ID is the NCBI taxonomy ID that you want to extract reads that match to
   OUT is the output directory of the ids and sequences
3) Write and close file after editing variables
4) Execute get_seqs.sh
