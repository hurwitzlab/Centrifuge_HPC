#!/bin/bash

#CENTRIFUGE HIT FILE FULL PATH
export CENT_HIT="/rsgrps/bhurwitz/jetjr/mockcommunity/fastq/IonXpress_029_PR-CARTMAN-77_staggered-centrifuge_hits.tsv"

#FASTA FILE TO EXTRACT SEQS
export FASTA="/rsgrps/bhurwitz/jetjr/mockcommunity/fastq/IonXpress_029_PR-CARTMAN-77_staggered.fa"

#TAXONOMY ID TO EXTRACT
export ID="1505027"

#OUT DIRECTORY TO STORE SEQ IDS AND SEQUENCES
export OUT="/rsgrps/bhurwitz/jetjr/mockcommunity/phage"

#module load unsupported
#module load markb/R/3.1.1

#./centrifuge_tax_parse.R -f $CENT_HIT -i $ID -o $OUT

module load samtools/1/1.3.1

FASTA_BASE=$(basename $FASTA | cut -d '.' -f 1)
HIT_BASE=$(basename $CENT_HIT | cut -d '-' -f 1,2,3)

xargs samtools faidx $FASTA < $OUT/$HIT_BASE-$ID.ids > $OUT/$FASTA_BASE-$ID.seqs
