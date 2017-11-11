#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=12:mem=23gb
#PBS -l pvmem=22gb
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M jamesthornton@email.arizona.edu
#PBS -m bea

#MOVE INTO DIRECTORY CONTAINING SEQUENCE DATA
cd "$FASTA_DIR"
export FASTA_LIST="$FASTA_DIR/fasta-list"
ls *.$FILE_EXT | cut -d '_' -f 1 | uniq > $FASTA_LIST
echo "FASTA files to be processed:" $(cat $FASTA_LIST)

#RUN CENTRIFUGE ON ALL SEQUENCE FILES FOUND IN FASTA_DIR
while read FASTA; do

  centrifuge -x $CENT_DB -1 $FASTA"_forward.fa" -2 $FASTA"_reverse.fa" -S $REPORT_DIR/$FASTA-centrifuge_hits.tsv --report-file $REPORT_DIR/$FASTA-centrifuge_report.tsv -$FILE_TYPE --exclude-taxids $EXCLUDE

done < $FASTA_LIST

#LOAD REQUIRED R MODULES
module load unsupported
module load markb/R/3.1.1

#CREATE BUBBLE PLOT VISUALIZATION
$SCRIPT_DIR/centrifuge_bubble.R -d $REPORT_DIR -o $PLOT_OUT -f $PLOT_FILE -t $PLOT_TITLE
