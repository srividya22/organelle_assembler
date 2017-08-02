#!/bin/bash
# Written by Srividya Ramakrishnan, for questions: srividya.ramki@gmail.com
# Inputs:
#        - reference fasta
#        - db name
#    
ref=$1
db_name=$2
${blast_path}/makeblastdb -in $ref  -out $db_name  -dbtype nucl
