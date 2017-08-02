#!/bin/bash -l
# Written by Srividya Ramakrishnan, for questions: srividya.ramki@gmail.com
# Inputs:
#        - input fasta
#        - db_name
#        - threads 
#        - out_file        
date
pidty=80
time ${blast_path}/blastn -query $input_fasta -db $db_name -num_threads $threads  -perc_identity $pidty -outfmt "6 qseqid sseqid pident qlen length mismatch gapopen qstart qend sstart send evalue bitscore" -out $out_file
date
