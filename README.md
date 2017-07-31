Organelle_assembler
**************************************

-Step : 1 Blast reads against reference and Select pacbio reads matching reference 
-Step : 2 Assemble them using canu,  on an SGE cluster
-Step : 3 Select the longest contig and check if the longest contig is longer than the refereence provided. 
          if longest contig found continue to step 4 else 2
-Step : 3 Iterate Step 1 and Step2 with the new reference assemblies ( < 10 iterations max )
-Step : 5 Align the reads using bwa mem and plot coverage graphs for top 2 contigs

-Step : 4 Align the assemblies to itself to check it the a single contig is split to 2 contigs

**************************************

INSTALL:

Download all three scripts:
```
git clone https://github.com/srividya22/organelle_assembler.git
```

Edit the main script: oraganelle_assembler.sh

Open and correct the paths to the blastn , canu, and Mummer installation paths. 

**************************************

USAGE:

```
./sge_mummer.sh ref.fa query.fa tmp_directory
```

This script automates the process of "exploding" the reference multi-fasta file into a directory of individual fasta files, and then running in parallel MUMmer/nucmer of the full query dataset against each reference sequence. After the successful completion of the run the tmp_directory will include a merged_results.delta, which is the resulting file from the MUMmer alignments with the headers fixed to point to the original files. This delta file can be used as-if it had been computed directly from the full reference fasta file against the full query fasta file.


***************************************

Questions or comments:
fritz.sedlazeck@gmail.com
