#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q windfall
#PBS -l select=1:ncpus=12:mem=23gb
#PBS -l pvmem=20gb
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M jamesthornton@email.arizona.edu
#PBS -m bea

#MOVE INTO DIRECTORY WITH SEQUENCE FILES AND CREATE FILE LIST
cd "$FASTA_DIR"
export FASTA_LIST="$REPORT_DIR/fasta-list"
ls *.$FILE_EXT | uniq > $FASTA_LIST
echo "FASTA files to be processed:" $(cat $FASTA_LIST)

#RUN CENTRIFUGE ON ALL SEQUENCE FILES FOUND IN FASTA_DIR
while read FASTA; do
  FILE_NAME=$(basename $FASTA | cut -d '.' -f 1)
  /rsgrps/bhurwitz/jetjr/centrifuge/centrifuge -x $CENT_DB -U $FASTA -S $REPORT_DIR/$FILE_NAME-centrifuge_hits.tsv --report-file $REPORT_DIR/$FILE_NAME-centrifuge_report.tsv -$FILE_TYPE -p 12 --exclude-taxids $EXCLUDE

done < $FASTA_LIST

#LOAD REQUIRED R MODULES
module load unsupported
module load markb/R/3.1.1

#CREATE BUBBLE PLOT VISUALIZATION
$SCRIPT_DIR/centrifuge_bubble.R -d $REPORT_DIR -o $PLOT_OUT -f $PLOT_FILE -t $PLOT_TITLE

