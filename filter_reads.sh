#!/bin/bash
# Written by Srividya Ramakrishnan, for questions: srividya.ramki@gmail.com
# Inputs:
#        - Pacbio hits to the reference genome
#        - asm fasta (assembly fasta from previous assembly)
#        - asm input fasta (assembly fasta from previous assembly)
#        - out fasta with the filtered reads ( tmp fasta + new filtered reads fasta)
#        - fasta index for the whole input fasta file
#        - the whole input fasta file
### get blast reseults
blast_out=$1
asm_fasta=$2
asm_input_fasta=$3
out_fasta=$4
pac_fai=$5
full_fasta=$6

min_args=6
dir=$(dirname $blast_out)
prefix_1=$(basename ${blast_out} | awk -F "." '{print $1}')
prefix_2=$(basename ${asm_fasta} | awk -F "." '{print $1}')
echo "Filename : $blast_out"
echo "Output path Set : ${dir}"

#### params ####
min_alignment_length=500
min_pident=80
check_ends=5000

#### Filter the blsat output 
echo "Filtereing Blast output"
filt_file="${dir}/${prefix_1}_filt.out"
awk '$5 > 500 && $3 > 79{print $0}' ${blast_out} | awk '{if($11 > $10){print $2"\t"$10"\t"$11"\t"$1"\t"$8"\t"$9} else {print $2"\t"$11"\t"$10"\t"$1"\t"$8"\t"$9}}' > ${filt_file}

#check if user specified the requried parameters
if [ $# -ne ${min_args} ]; then        
   filtered_reads=$dir/filtered_reads.txt
   awk '{print $4}' ${filt_file} > ${filtered_reads}
else
   #### Make bed files from fasta file 
   f_bed="${dir}/${prefix_2}_ends.bed"
   overlap_bed="${dir}/overlapped_ends.bed"
   getlengths ${asm_fasta} | awk '{print $1"\t"0"\t"5000"\n"$1"\t"$2-5000"\t"$2}' > ${f_bed}
   bedtools intersect -a ${filt_file} -b ${f_bed} > ${overlap_bed}

   #### Filter out Existing Reads ###
   input_reads="${dir}/input_read_ids.txt"
   filt_overlaps="${dir}/uniq_overlapped_ends.bed"
   getlengths ${asm_input_fasta} > ${input_reads} 
   awk 'NR==FNR{a[$1];next} !($4 in a)' ${input_reads} ${overlap_bed} > ${filt_overlaps}

   #### Get Read lengths 
   tmp_header="${dir}/tmp_header.txt"
   tmp_file="${dir}/tmp_file.txt"
   map_tmp_file="${dir}/map_tmp_file.txt"
   awk '{print $4}' ${filt_overlaps} | sort -V | uniq > ${tmp_header}
   awk 'NR==FNR{a[$1];next} ($1 in a)' ${tmp_header} ${pac_fai} > ${tmp_file}
   join -1 4 -2 1 -o  1.4,1.5,1.6,2.2 <(sort -k4,4 -V ${filt_overlaps}) <(sort -k1,1 -V ${tmp_file}) > ${map_tmp_file}

   #### Filter 2 : Selecting reads with starting coordinates  
   awk '(($4-$3) < 5000) && (($2 - 0 ) < 5000) {print $1}' ${map_tmp_file} | sort -V | uniq  > ${filtered_reads} 

   
fi

#### Extract filtered reads #####
cat ${filtered_reads} | xargs samtools faidx ${full_fasta} > ${out_fasta}
#### Perforn cleanup 
   
####
echo "Filtered Reads and extracted reads successfully"
