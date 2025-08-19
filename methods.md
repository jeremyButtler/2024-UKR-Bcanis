## Sequencing

... For library prepration we used a rapid barcodind kit
  (RBK114.24 V14). We then sequence using an ONT Mininon
  with a R9.4 flow cell.

## assembly

For assembly, we merged to the separate barcodes for the
  *B. canis* sample together and then ran the merged fastq
  file through Raven (citation) version 1.8.3. We then
  used blast (reference) to identify which contig belonged
  to which *B. canis* chromosome.

Next, we reduced the number of errors in our contigs by
  polishing and an indel clean up step. For polishing we
  used minimap2 (citations) version 2.28-r1209 with the
  -a to map reads to the assembly. Then, we polished the
  assembly with tbCon version 2024-08-07 from bioTools
  [https://github.com/jeremyButtler/bioTools](
   https://github.com/jeremyButtler/bioTools) using a
  percent SNP support of 30% (-perc-snp-sup 0.3), a
  mininum read depth of 5 (-min-depth 5), a minimum base
  q-score of 3 (-min-q 3), and a minimum insertion q-score
  of 3 (-min-q-ins 3). We polished the first chromosome
  twice and the second chromosome once.

For indel clean up we mapped the assembly to the
  *B. canis* CP016977 and CP016978 reference genomes
  using minimap2 with the -a flag. We then removed all
  indels less then four bases using rmHomo from bioTools
  version 2025-07-28 with the `-homo 1` flag.

## cgMLST tree

We then built a cgMLST reference database for our in house
  cgMSLT scripts using the Rimsphere database *B. canis*
  (citation). Then we used inhouse scripts to find the
  cgMLST linages for the 31 full length reference genomes
  we found on Genbank (Supplmental 1,
  Eric this is in the 01-input/01-references.acc file) and
  our cleaned assembly. We then built a minimum spanning
  cgMLST tree with our database using GrapeTree
  (citation) with the --matrix MSTreeV2 flag. The final
  tree was edited and saved using Phylo.io
  [https://beta.phylo.io/viewer](
   https://beta.phylo.io/viewer).

For the genomic tree, we extracted all cgMLST genes from
  the references, assembly, and our outgroup (CP000911; a
  *B. susis* genome) using in house scripts. We then ...
  (Eric this is your part if you took this further).

To see our in house scripts or more detailed step by
  step instructions please visit
  [https://github.com/jeremyButt/2024-UKR-Bcanis](
   https://github.com/jeremyButt/2024-UKR-Bcanis).
