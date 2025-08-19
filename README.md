# Use:

Describe steps used to get the *B. canis* genomes from
  the 2024 Ukraine fastq files.

# Tools used:

- versions:
  - other peoples programs
    - raven: 1.8.3
      - [https://github.com/lbcb-sci/raven](
         https://github.com/lbcb-sci/raven)
    - minimap2 2.28-r1209
      - [https://github.com/lh3/minimap2](
         https://github.com/lh3/minimap2)
    - GrapeTree 1.5.0
      - [https://github.com/achtman-lab/GrapeTree](
         https://github.com/achtman-lab/GrapeTree)
  - my bioTools programs (pre-dates global bioTools
    version):
    - filtsam 2024-05-14
    - tbCon 2024-08-07
    - rmHomo 2025-07-28

# Citations

The `references.bibtex` file has all references in bibtex
  format. The only exception is Phylo.io veiwer, which I
  could not find a reference for.

## Phylo tree

Could not find citation.

[https://beta.phylo.io/viewer](
  https://beta.phylo.io/viewer)

## raven

Vaser, R., Šikić, M. Time- and memory-efficient genome
  assembly with Raven. Nat Comput Sci 1, 332–336 (2021).
  https://doi.org/10.1038/s43588-021-00073-4

## minimap2

Li, H. (2018). Minimap2: pairwise alignment for nucleotide
  sequences. Bioinformatics, 34:3094-3100.
  doi:10.1093/bioinformatics/bty191

Li, H. (2021). New strategies to improve minimap2
  alignment accuracy. Bioinformatics, 37:4572-4574.
  doi:10.1093/bioinformatics/btab705

## Grapetree

Z Zhou, NF Alikhan, MJ Sergeant, N Luhmann, C Vaz,
  AP Francisco, JA Carrico, M Achtman (2018)
  "GrapeTree: Visualization of core genomic
   relationships among 100,000 bacterial pathogens",
   Genome Res; doi: https://doi.org/10.1101/gr.232397.117

## Rimsphere database

Publication: Abdel-Glil MY, Thomas P, Brandt C,
  Melzer F, Subbaiyan A, Chaudhuri P, Harmsen D,
  Jolley KA, Janowicz A, Garofolo G, Neubauer H,
  and Pletz MW. Core Genome Multilocus Sequence Typing
  Scheme for Improved Characterization and Epidemiological
  Surveillance of Pathogenic Brucella.
  J Clin Microbiol. 2022, 60: e0031122
  [PubMed 35852343]

[https://www.cgmlst.org/ncs/schema/Brucella2114/](
 https://www.cgmlst.org/ncs/schema/Brucella2114/).

# sequencing notes

- Run: BG\_EBS\_0924
  - Date: 20240919
  - ONT Library Kit: RBK114.24 V14 chem RB Rapid Barcoding
    Kit

# 02 assembly

The original fastq files came from two separate runs. They
  were mereged with `cat` and then uncompressed
  with `gzip`. The data on the SRA is the merged data.
  The data was saved in the input directory, for the rest
  of this document we will refere to it
  as `01-input/merged-reads.fq`.

Raven was used to assemble the genomes.

```
raven \
    data_from_SRA.fastq \
  > 02-raven/02-BG_EMBS-bar08_11.fa;
```

# 03 polishing

For a quick polishing we did two rounds with tbCon for
  chromosome 1 and one round of polshing for chromosome 2.

We really did 5 rounds, but found that chromsome one was
  best with two rounds, while chromosome two was best
  with one round.

We also identified which chromosomes the contigs belong to
  before this step. However, for clarity this is shown in
  the next step.

## first chromosome

```
minimap2 \
    -a \
    <(head -n 2 02-raven/02-BG_EMBS-bar08_11.fa) \
    01-input/merged-reads.fq |
  tbCon \
    -sam - \
    -perc-snp-sup 0.3 \
    -min-depth 5 \
    -min-q 3 \
    -min-q-ins 3 |
  filtsam \
     -out-fasta \
     -sam - |
  sed \
     "1s/.*/>bar08_11-chrom01-delete/;" \
    > del.fasta;

minimap2 \
    -a \
    del.fasta \
    01-input/merged-reads.fq |
  tbCon \
    -sam - \
    -perc-snp-sup 0.3 \
    -min-depth 5 \
    -min-q 3 \
    -min-q-ins 3 |
  filtsam -out-fasta -sam - |
  sed \
     "1s/.*/>bar08_11-chrom01-polish/;" \
    > 03-polishing/03-BG_EMBS-bar08_11-chrom1-polish.fa;

rm del.fasta;
```

## second chromosome

```
minimap2 \
    -a \
    <(tail -n 2 02-raven/02-BG_EMBS-bar08_11.fa) \
    01-input/merged-reads.fq |
  tbCon \
    -sam - \
    -perc-snp-sup 0.3 \
    -min-depth 5 \
    -min-q 3 \
    -min-q-ins 3 |
  filtsam -out-fasta -sam - |
  sed \
     "1s/.*/>bar08_11-chrom02-polish/;" \
    > 03-polishing/03-BG_EMBS-bar08_11-chrom1-polish.fa;
```

# 04 curation

We wanted to curate the genomes before further analysis,
  so we found a close hit on blast. We then used the
  reference and `rmHomo -homo 1` to remove indels smaller
  than 4 bases long.

## find reference genome

The genomes from Raven were large contigs, so I split the
  genomes into roughly 1 megabase pair chunks and used
  blast to identify the host species for each. In all
  cases *B. canis* was present.

I downloaded a *B. canis* genome (CP016977) from Genbank 
  to act as a reference. I split chromosone one
  (01-input/CP016977-B_canis_chrom1.fa) and chromosome two
  (01-input/CP016978-B_canis_chrom2.fa) into
  separate files. To prevent mapping errors when mapping
  the assembly to the reference I circularized both
  chromosomes using `awk`.

```
awk \
    '
      { # MAIN
         if(NR == 1)
            headStr = $0;
         else
            seqStr = seqStr $0;
      }; # MAIN

      END{printf "%s\n%s%s\n", headStr, seqStr, seqStr;};
    ' \
    01-input/CP016977-B_canis-chrom1.fa \
  > 01-input/CP016977-B_canis-chrom1-circ.fa;

awk \
    '
      { # MAIN
         if(NR == 1)
            headStr = $0;
         else
            seqStr = seqStr $0;
      }; # MAIN

      END{printf "%s\n%s%s\n", headStr, seqStr, seqStr;};
    ' \
    01-input/CP016978-B_canis-chrom2.fa \
  > 01-input/CP016978-B_canis-chrom2-circ.fa;
```

## chromosome 1

```
minimap2 \
    -a \
    --eqx \
    01-input/CP016977-B_canis-chrom1-circ.fa \
    03-polishing/03-BG_EMBS-bar08_11-chrom1-polish.fa |
  rmHomo \
    -homo 1 \
    -ref 01-input/CP016977-B_canis-chrom1-circ.fa |
  filtsam \
    -out-fasta \
    -sam - \
    -out 04-curation/04-BG_EMBS-bar08_11-chrom1-polish-rmHomo.fa;
```

## chromosome 2

```
minimap2 \
    -a \
    --eqx \
    01-input/CP016978-B_canis-chrom2-circ.fa \
    03-polishing/03-BG_EMBS-bar08_11-chrom2-polish.fa |
  rmHomo \
    -homo 1 \
    -ref 01-input/CP016978-B_canis-chrom2-circ.fa |
  filtsam \
    -out-fasta \
    -sam - \
    -out 04-curation/04-BG_EMBS-bar08_11-chrom2-polish-rmHomo.fa;
```

## 04 notes

For both chromosome 1 and 2 we noticed several large
  indels remained, including a six G insert in a 10
  base long G homopolymer in chromsome two. The other
  indels in chromosome one and two were in VNTR regions
  and so, might affect lineage calls.

# 05 database

We needed to build up a cgMLST database before we could
   run a cgMLST analysis. So, we downloaded as many
   *B. canis* full reference genomes from Genbank as
   possible (see 01-input/01-references.acc for accession
   numbers).

Then we used in house scripts to convert the reference
  genomes into cgMLST lineages.

## getting cgMLST genes

The *Brucella spp.* version 1.0 cgMLST genes were
  downloaded from rimshpere
  [https://www.cgmlst.org/ncs/schema/Brucella2114/](
   https://www.cgmlst.org/ncs/schema/Brucella2114/).

The database was extracted using `unzip`.

```
   mkdir 01-input/rimsphere;
   cd 01-input/rimsphere;
   mv <rimshpere_cgMLST_database>.zip rimshpere;
   unzip <rimshpere_cgMLST_database>.zip;
   cd ../../;
```

The database was then converted to my cgMLST scripts
  format using in house scripts.

```
sh 00-scripts/rimSphCgMlstCnvt.sh \
    01-input/01-B_canis-cgMLS-db \
    01-input/rimsphere/*.fasta;
rm -r "rimsphere";
```

The final names were `01-B_canis-cgMLST-db--lenDb.tsv`
  and `01-B_canis-cgMLST-db--seqDb.fa`.

The sequence database `01-B_canis-cgMLST-db--seqDb.fa` was
  compressed using `gzip` to avoid the github large upload
  size limit.

## building the cgMLST reference database

The cgMLST reference database for our in house scripts was
  built using in house scripts and the rimsphere cgMLST
  database. The converted reference database was named
  `05-linRef/0t-linDb.tsv`.

```
firstBl="TRUE";

for strFa in 01-input/01-Bcanis-refs/*.fa;
do   # Loop: add references to database
   accStr="$(\
      basename "$strFa" | sed 's/Bcanis-//; s/.fa//;' \
   )";

   if [ ! -d "05-canisRefs/05-$accStr" ];
   then
      mkdir "05-canisRefs/05-$accStr";
   fi

   sh 00-scripts/cgMLST.sh \
       "$strFa" \
       "05-refLin/05-$accStr/05-$accStr" \
       01-input/01-B_canis-cgMLST-db--seqDb.fa.gz \
       01-input/01-B_canis-cgMLST-db--lenDb.tsv \
       $accStr;

   if [ "$firstBl" = "TRUE" ];
   then
      cat \
          "05-refLin/05-$accStr/05-$accStr-cgMLST-map-lin-sheet.tsv" \
        > "05-refLin/05-linDb.tsv";
      firstBl="FALSE";
   else
      tail -n+2 \
          "05-refLin/05-$accStr/05-$accStr-cgMLST-map-lin-sheet.tsv" \
        >> "05-refLin/05-linDb.tsv";
   fi
done # Loop: add references to database
```

# 06 adding sequence to database

The Ukraine sequence was added to the database and the
  closet

```
cat 04-curation/*.fa > del.fa;
sh 00-scripts/cgMLST.sh \
    del.fa \
    06-ukrLin/06-BG_EMBS-bar08_11-polish-rmHomo-cgMLST \
    01-input/01-B_canis-cgMLST-db--seqDb.fa.gz \
    01-input/01-B_canis-cgMLST-db--lenDb.tsv;
rm del.fa
```

I checked to make sure the four base G homopolymer had
  little effect using awk. None of the lineages detected
  had more then a one base insertion. I also checked the
  problem lineages and no lineage had an insertion or
  deletion.

```
awk '{if($6 > 0) print $0;};' \
   06-ukrLin/06-BG_EMBS-bar08_11-polish-rmHomo-cgMLST-cgMLST-map.tsv;
```

I then merged the reference and lineage databases with
  `cat` to get one lineage database.

```
cat \
    05-linDb.tsv \
    06-ukrLin/06-BG_EMBS-bar08_11-polish-rmHomo-cgMLST-cgMLST-map-lin-sheet.tsv \
  > 06-ukrLin/06-linDb-UKR.tsv;
```

# 07 cgMLST tree

I made a minimum spanning cgMLST using the reference
  database and grapetree. The output `.newick` was
  converted to an svg image using `phylo.io`
  [https://beta.phylo.io/viewer](
   https://beta.phylo.io/viewer). The svg image was then
  converted to a tiff image using `inkscape`.

First I needed to prepare the database for grape tree.

```
sed \
   '1s/^/#/; s/\*/0/g;' \
   06-ukrLin/06-linDb-UKR.tsv \
  > 07-tree/07-linDb-UKR-set.tsv;
```

Need to install grape tree by virtual envrioment, so to
  activate it I did `. ~/files/pythonEnv/bin/activate`.

```
grapetree \
    --profile 07-tree/07-linDb-UKR-set.tsv \
    --matrix MSTreeV2 \
  > 07-tree/07-linDb-UKR-set-grapTree.newick
```

# 08 gene extaction

## get UKR sequence genes

I then extracted the genes useing an in house script and
  concatinated them together using `cat`.

```
cat 04-curation/*.fa > del.fa;
sh 00-scripts/extractGenes.sh \
    del.fa \
    01-input/01-B_canis-cgMLST-db--seqDb.fa.gz;
rm del.fa
mv \
    coordinates.tsv \
    08-extract/08-BG-EMBS-bar08_11-geneCoords.tsv
mv genes.fa 08-extract/08-BG-EMBS-bar08_11-genes.fa;
```

## get reference genes

Next I needed to get the cgMLST genes in the references
  and cocatinate all genes into sequences. I included a
  *B. suis* as an outgroup.

```
for strFa in ./01-input/01-Bcanis-refs/*.fa;
do
   bash 00-scripts/extractGenes.sh \
       "$strFa" \
       01-input/01-B_canis-cgMLST-db--seqDb.fa.gz &&
     awk \
       -v idStr="$(\
           basename "$strFa" |
           sed 's/Bcanis-//; s/\.fa//;' \
         )" \
       '{
           if($0 ~ /^>/ || $0 ~ /^$/)
              next;
           seqStr = seqStr $0;
         }
         END{printf ">%s\n%s\n", idStr, seqStr;};
       ' genes.fa  \
  >> 08-extract/08-Bcanis-concate.fa &&
  rm genes.fa coordinates.tsv;
done
```

## get outgroup genes

Then I needed to add in the concatinated ukraine sequence
  to the database.

```
awk \
    -v idStr="UKR-2024" \
    '{
        if($0 ~ /^>/ || $0 ~ /^$/)
           next;
        seqStr = seqStr $0;
      }
      END{printf ">%s\n%s\n", idStr, seqStr;};
    ' 08-extract/08-BG-EMBS-bar08_11-genes.fa \
  >> 08-extract/08-Bcanis-concate.fa;
```

Then I added the concatinated outgroup sequence

```
bash 00-scripts/extractGenes.sh \
    01-canis-input/Bsuis-CP000911.fa \
    01-canis-input/01-B_canis-cgMLST-db--seqDb.fa &&
  awk \
    -v idStr="Bsuis-CP000911" \
    '{
        if($0 ~ /^>/ || $0 ~ /^$/)
           next;
        seqStr = seqStr $0;
      }
      END{printf ">%s\n%s\n", idStr, seqStr;};
    ' genes.fa  \
  >> 08-extract/08-Bcanis-concate.fa &&
  rm genes.fa coordinates.tsv;
```

At this point the genomes should be ready for alignment
  and tree building.
