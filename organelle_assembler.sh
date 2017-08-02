#!/bin/bash
# Written by Srividya Ramakrishnan, for questions: srividya.ramki@gmail.com
# Inputs:
#        - reference fasta
#        - input fasta
#        - tmp directory
 
min_args=3
#path to the mumer install directory:
script_path=${HOME}/work/sramakr4/assembly/scripts/organelle_assembler
#path to the mumer install directory:
export blast_path=${HOME}/bin/miniconda2/bin/
export canu_path=${HOME}/bin/canu
export bwa_path=${HOME}/bin/miniconda2/bin/
export mummer_path=${HOME}/bin/miniconda2/bin/

#check if user specified the requried parameters
if [ $# -eq $min_args ]; then        
	#get full paths:
	ref=$1
	input_fasta=$2
	tmp_dir=$3
        tmp_fasta=''
        
        # Set the report file
        asm_report_file=$tmp_dir/asm_report.txt  
	
        #Bait reads for the analysis
        #Blast fasta against reads
        
	mkdir -p $tmp_dir
        # Initializing ref size to the size of organelle genome
        ref_size=$(getlengths $ref | awk '{sum+=$2} END{print sum}')
        echo "Reference Genome Size : $ref_size"
        lcontig_size=0
        iter=0
        while ref_size >= lcontig_size:
        do 
            iter+=1
            echo " Step 1: Make blastdb for the reference fasta" 
            db_name=$tmp_dir/ref$iter
            # ${script_path}/makeblastdb.sh $ref $db_name
             
	    echo " Step 2: Run blastn against the reference blast db"
            out_file=$tmp_dir/ref$iter_blastn.out
	    #$script_path/run_blastn.sh $input_fasta $db_name $out_file
            
            echo " Step 3: Filter reads from blastn ouput "
            if $iter== 1;then
               asm_fasta=''
            fi   
            out_fasta=$tmp_dir/input$iter.fasta
 	    #$script_path/filter_reads.sh $out_file $asm_fasta $input_fasta $tmp_fasta $out_fasta
                
            echo " Step 4: Run canu assembly " 
            assembly_dir=asm$iter
            genome_size=$(echo "scale=2; $ref_size /1000000" | bc)M 
            #$script_path/run_canu_assembly.sh $out_fasta $genome_size $tmp_dir/$assembly_dir

	    #create sge job:

	    #num=$(wc -l < $work/summary)
	    #sed "s/NUMMER/$num/g" $script_path/sge_mummer_helper.sh > $work'/mummer.sh'
	    #qsub -sync y -N mummersplit -o $work/output.txt -e $work/error.txt -v PATHMUM=\'$mummer_path\',REF_FASTA_LIST=\'$work/summary\',QRY=\'$query\',WORK=\'$work\' $work'/mummer.sh'
	    echo "waiting for canu to finish"
	
            echo " Step 5 : Get assembly stats "
            asm_fasta=$tmp_dir/$assembly_dir/${assembly_dir}.contigs.fasta
            #$script_path/get_assembly_stats.sh $asm_fasta >> $asm_report_file 
 
            echo " Step 6: Updating longest contig size "
            lcontig_size=$(getlengths $asm_fasta | awk '{print $2}' | sort -nr | head -n1)

        done
        
        # At this point we have a longest contig greater than reference
        # Check for circularity
        echo " Checking for circularity in the genome. Run post processing after assembly"
        $script_path/post_process.sh $asm_fasta
        
	#cleaning up the working directory
	#tmp=1
	#for i in $(cat $work/summary)
	#do
	#	rm $i
        #	rm -r $work/$tmp 
	#	tmp=$((tmp+1))
	#done
	echo "Finished succesfully."
else
        echo "usage: organelle_assembler.sh ref.fa input.fa tmp_dir"
        echo "- ref.fa = File path Reference organelle genome"
        echo "- input.fa = File path of the Input fasta Long reads "
	echo "- tmp_dir = Temporary working directory"
fi

