Organelle_assembler
**************************************

Step : 1 Blast reads against reference and Select pacbio reads matching reference 
Step : 2 Assemble them using canu,  on an SGE cluster
Step : 3 Select the longest contig and check if the longest contig is longer than the refereence provided. 
          if longest contig found continue to step 4 else 2
Step : 3 Iterate Step 1 and Step2 with the new reference assemblies ( < 10 iterations max )
Step : 5 Align the reads using bwa mem and plot coverage graphs for top 2 contigs

Step : 4 Align the assemblies to itself to check it the a single contig is split to 2 contigs

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
./organelle_assembler.sh ref.fa query.fa tmp_directory
```

This script automates the process of iterating and extending assemblies for circular genomes


***************************************

Questions or comments:
srividya.ramki@gmail.com
