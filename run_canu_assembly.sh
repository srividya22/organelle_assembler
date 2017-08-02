#!/bin/bash
dir="l_pine_canu_asm1_revised_high"
canu -p $dir -d $dir -pacbio-raw ./pacbio_filtered_sequences.fasta genomeSize=1.3m rawErrorRate=0.30 corMhapSensitivity=high usegrid=true gridOptions="--partition shared,lrgmem,parallel,unlimited,bw-parallel,bw-gpu --time 1-0:0:0"  gnuplotTested=true
