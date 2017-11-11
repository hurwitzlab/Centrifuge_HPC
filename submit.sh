#!/bin/sh

#GET AND CHECK VARIABLE DECLARATIONS
source ./config.sh

if [[ ! -d "$FASTA_DIR" ]]; then
    echo "$FASTA_DIR does not exist. Job terminated."
    exit 1
fi

if [[ ! -d "$SCRIPT_DIR" ]]; then
    echo "$SCRIPT_DIR does not exist. Job terminated."
    exit 1
fi

if [[ ! "$FILE_EXT" ]]; then
    echo "You must provide a FASTA extension (.fa, .fasta). Job terminated."
    exit 1
fi

if [[ ! -d "$REPORT_DIR" ]]; then
    echo "$REPORT_DIR does not exist. Directory created for Centrifuge output."
    mkdir -p "$REPORT_DIR"
fi

if [[ ! -d "$PLOT_OUT" ]]; then
    echo "$PLOT_OUT does not exist. Directory created for plot output"
    mkdir -p "$PLOT_OUT"
fi

if [[ ! -d "$STDERR_DIR" ]]; then
    echo "$STDERR_DIR does not exist. Directory created for standard error."
    mkdir -p "$STDERR_DIR"
fi

if [[ ! -d "$STDOUT_DIR" ]]; then
    echo "$STDOUT_DIR does not exist. Directory created for standard out."
    mkdir -p "$STDOUT_DIR"
fi


#JOB SUBMISSION FOR SINGLE END DATA
if [[ "$TYPE" = "single" ]]; then
  
  JOB1=`qsub -v FASTA_DIR,SCRIPT_DIR,CENT_DB,FILE_EXT,REPORT_DIR,FILE_TYPE,PLOT_OUT,PLOT_FILE,PLOT_TITLE,EXCLUDE -N S_Centrifuge -e "$STDERR_DIR" -o "$STDOUT_DIR" $SCRIPT_DIR/centrifuge_single_tax.sh`

#JOB SUBMISSION FOR PAIRED END DATA
elif [[ "$TYPE" = "paired" ]]; then

  JOB1=`qsub -v FASTA_DIR,SCRIPT_DIR,CENT_DB,FILE_EXT,REPORT_DIR,FILE_TYPE,PLOT_OUT,PLOT_FILE,PLOT_TITLE,EXCLUDE -N P_Centrifuge -e "$STDERR_DIR" -o "$STDOUT_DIR" $SCRIPT_DIR/centrifuge_paired_tax.sh`

else

  echo "TYPE must be either 'single' or 'paired'. Edit config.sh. Job terminated."
  exit 1
fi


