#!/bin/bash

#Establish current working directory
export CWD=$PWD

#Directory where scripts are located
export SCRIPT_DIR="$CWD/scripts"

#Centrifuge Database Location
export CENT_DB="/rsgrps/bhurwitz/jetjr/cent-db/comprehensive/bvf"

#Directory containing FASTA/Q files (Centrifuge ran on these files)
export FASTA_DIR="/rsgrps/bhurwitz/jetjr/mockcommunity/fastq"

#Single or Paired End Reads? (single || paired)
#IMPORTANT: For paired end files see README.md for additional information
export TYPE="single"

#FASTA/Q File Extension (common extensions include fasta, fa, fastq, fastq)
#DO NOT INCLUDE the dot "."
export FILE_EXT="fq"

#Centrifuge Report Out Directory
export REPORT_DIR="/rsgrps/bhurwitz/jetjr/mockcommunity/fastq"

#Bubble Plot Out Directory
#IMPORTANT NOTE: Make sure to include the '/' at the end of the path to satisfy R
export PLOT_OUT="/rsgrps/bhurwitz/jetjr/mockcommunity/fastq"

#Plot file name and title (No spaces, use _)
export PLOT_FILE="mcom"
export PLOT_TITLE="mcom"

#File type (Fasta or Fastq | fasta = f; fastq = q)
export FILE_TYPE="q"

#Exclude hits by stating taxid in following format ("taxid1,taxid2")
export EXCLUDE="9606,32630"

#Standard Error/Out Directory
export STDERR_DIR="$CWD/std-err"
export STDOUT_DIR="$CWD/std-out"
