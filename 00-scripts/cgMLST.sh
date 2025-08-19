#!/usr/bin/sh

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name: cgMLST.sh
#   - detects cgMLST lineage for each allele
# Input:
#   - $1: sequence (as fasta) to get cgMLST lineages for
#   - $2: prefix to name output
#   - $3: cgMLST allele sequences; used to find lieage
#   - $4: tsv file with lengths of cgMLST allele/variants
#   - $5: name of run
# Output:
#   - prefix-cgMLST-map-lin-problem.tsv gets the
#     problematic alleles (unsure on lineage call)
#   - prefixStr-cgMLST-map-lin.tsv gets lineages for each
#     allele
#   - prefixStr-cgMLST-map.tsv gets stats (indels/SNPs)
#     for the sequence and each alleles variants
#   - prefixStr-cgMLST-map-lin-sheet.tsv gets lineage in
#     spreadsheet form
# Note:
#   - this is hacky and really was designed as a one use
#     script, that was latter expanded to a multi use
#     script. I am hoping to get something in C later
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec01:
#   - variable declarations and user input
#   o sec01 sub01:
#     - variable declarations
#   o sec01 sub02:
#     - get input for variables (prefix and databases)
#   o sec01 sub03:
#     - check for help message requests
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#*********************************************************
# Sec01 Sub01:
#   - variable declarations
#*********************************************************

refStr="$1";
prefixStr="$2";
lociDbStr="01-input/ba-cgMLST-refs.fa";
linDbStr="01-input/ba-cgMLST-refs-lenDb.tsv";
outFlagStr="$5";

helpStr="$(basename "$0") sequence.fasta prefix"
helpStr="$helpStr seq-database.fasta len-database.tsv";
helpStr="$helpStr <entry_name>
   - gets a rough cgMLST lineage for a sequence
   o sequence.fasta: sequence to get lineages for
   o prefix: what to name output
   o seq-database.fasta: fasta file with all allelse and
     their variants (lineages)
     - convert rimSphere database with rimSphCgMlstCnvt.sh
   o len-database.tsv: tsv with allele, variant number,
     and the variants length
     - convert rimSphere database with rimSphCgMlstCnvt.sh
   o <entry_name> [optional]: name to call genome in the
     output tsv file (reference name)
";

#*********************************************************
# Sec01 Sub02:
#   - get input for variables (prefix and databases)
#*********************************************************

if [ "$prefixStr" = "" ];
then
   prefixStr="out";
fi # If: no prefix input

# check if user input databases
if [ "$3" = "" ];
then
   lociDbStr="01-input/ba-cgMLST-refs.fa";
else
   lociDbStr="$3";
fi

if [ "$4" = "" ];
then
   linDbStr="01-input/ba-cgMLST-refs-lenDb.tsv";
else
   linDbStr="$4";
fi

if [ "$outFlagStr" = "" ];
then
   outFlagStr="out";
fi # If: no prefix input

#*********************************************************
# Sec01 Sub03:
#   - check for help message requests
#*********************************************************

if [ "$1" = "" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$1" = "-h" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$1" = "--h" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$1" = "help" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$1" = "-help" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$1" = "--help" ]; then
   printf "%s\n" "$helpStr"
   exit;
fi

if [ "$2" = "" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$2" = "-h" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$2" = "--h" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$2" = "help" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$2" = "-help" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$2" = "--help" ]; then
   printf "%s\n" "$helpStr"
   exit;
fi

if [ "$3" = "-h" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$3" = "--h" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$3" = "help" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$3" = "-help" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$3" = "--help" ]; then
   printf "%s\n" "$helpStr"
   exit;
fi

if [ "$4" = "-h" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$4" = "--h" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$4" = "help" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$4" = "-help" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$4" = "--help" ]; then
   printf "%s\n" "$helpStr"
   exit;
fi

if [ "$5" = "-h" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$5" = "--h" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$5" = "help" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$5" = "-help" ]; then
   printf "%s\n" "$helpStr"
   exit;
elif [ "$5" = "--help" ]; then
   printf "%s\n" "$helpStr"
   exit;
fi

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec02:
#   - map lineages to reference
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

minimap2 \
    -a \
    --eqx \
    --secondary-seq \
    "$refStr" \
    "$lociDbStr" |
  filtsam \
    -out-stats \
    -F 4 \
    -sam - |
  awk '
      BEGIN{
         OFS="\t";
         getline; # get past header (NR = 1)
         print "loci",
               "allele",
               "percDiff",
               "match",
               "snp",
               "ins",
               "del";
      }; # BEGIN block

      { # MAIN
         idStr = $1;
         lociStr = $1;

         sub(/.*--/, "", idStr); # get allele id
         sub(/--.*/, "", lociStr); # remove allele id

         matchSI = $8;
         snpSI = $11;
         insSI = $14;
         delSI = $17;
         diffSI = snpSI + insSI + delSI;

         if(lastLociStr != lociStr)
         { # If: changing loci

            if(NR != 2)
            { # If: not first allele for first loci
               edDistSI = lastSnpSI +lastInsSI +lastDelSI;
               lenSI = lastSnpSI +lastDelSI + lastMatchSI;

               if(lenSI == 0)
                  print lastLociStr, edDistSI;

               # hacky round method
               percDiffSI = (edDistSI / lenSI) * 10000;
               percDiffSI = int(percDiffSI) / 100;

               print lastLociStr,
                     lastIdStr,
                     percDiffSI,
                     lastMatchSI,
                     lastSnpSI,
                     lastInsSI,
                     lastDelSI;
            } # If: not first allele for first loci

            lastIdStr = idStr;
            lastLociStr = lociStr;

            lastMatchSI = $8;
            lastSnpSI = $11;
            lastInsSI = $14;
            lastDelSI = $17;

            lastDiffSI = lastSnpSI + lastIndelSI;
            lastDiffSI += lastDelSI;
         } # If: changing loci

        else if(matchSI == 0)
           next;
        else if(lastMatchSI == 0 ||
                diffSI /matchSI < lastDiffSI /lastMatchSI)
        { # Else If: better matching allele found
           lastMatchSI = matchSI;
           lastSnpSI = snpSI;
           lastInsSI = insSI;
           lastDelSI = delSI;
           lastDiffSI = diffSI;

           lastIdStr = idStr;
        }; # Else If: better matching allele found
      };

      END{
        edDistSI = lastSnpSI + lastInsSI + lastDelSI;
        lenSI = lastSnpSI + lastDelSI + lastMatchSI;

        # hacky round method
        percDiffSI = (edDistSI / lenSI) * 10000;
        percDiffSI = int(percDiffSI) / 100;

        print lastLociStr,
              lastIdStr,
              percDiffSI,
              lastMatchSI,
              lastSnpSI,
              lastInsSI,
              lastDelSI;
      };
    ' >> "$prefixStr-cgMLST-map.tsv";

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec03:
#   - find loci lineage
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

awk \
   '
      BEGIN{
         OFS="\t";

         if(minPercCoverF == "")
            minPercCoverF=99;

         if(largestIndelSI == "")
            largestIndelSI=5;

         if(maxPercDiffF == "")
            maxPercDiffF=2;

         if(maxSNPercDiffF == "")
            maxSnpPercDiffF=99.5;
      }; # BEGIN

      { # MAIN
         if(fileStr == "")
         { # If: first line of first file
            fileStr = FILENAME;
            getline; # move past hedaer
         } # If: first line of first file

         if(fileStr == FILENAME)
         { # If: reading length database

            if(numLociSI == 0 ||            # frist round
              $1 != lociAryStr[numLociSI])  # new loci
            { # If: new loci
               ++numLociSI;
               lociAryStr[numLociSI] = $1;
            } # If: new loci

            lenArySI[numLociSI][$2] = $3;
         } # If: reading length database

         else
         { # Else: on consensus cgMLST results
            if(linStr == "")
            { # If: first round
               linStr = FILENAME;
               print $0,
                     "percSnp",
                     "percCover",
                     "refLen",
                     "call";

               getline; # move past header
               lociCntSI = 1;
            } # If: first round

            else
               ++lociCntSI;

            alleleSI = $2;

            while($1 != lociAryStr[lociCntSI])
            { # Loop: print missing loci
               if(lociCntSI > numLociSI)
                  exit; # finished

               print lociAryStr[lociCntSI],
                     "NA",
                     "NA",
                     "NA",
                     "NA",
                     "NA",
                     "NA",
                     "NA",
                     "NA",
                     "NA",
                     "*";
               ++lociCntSI;
            } # Loop: print missing loci

            matchSI = $4;
            snpSI = $5;
            insSI = $6;
            delSI = $7;
            refLenSI = lenArySI[lociCntSI][alleleSI];

            if(refLenSI == 0)
            { # If: no reference length
               print lociAryStr[lociCntSI],
                     "NA",
                     "NA",
                     "NA",
                     "NA",
                     "NA",
                     "NA",
                     "NA",
                     "NA",
                     "NA",
                     "*";
               next;
            } # If: no reference length

            percCoverF = (matchSI + snpSI + delSI);
            percCoverF /= refLenSI;
            percCoverF *= 10000;
            percCoverF = int(percCoverF) / 100;

            percSNPF = snpSI / refLenSI;
            percSNPF *= 10000;
            percSNPF = int(percSNPF) / 100;

            if(percCoverF < minPercCoverF)
               classSC = "I";

            else if(insSI + delSI > largestIndelSI)
               classSC = "X";

            else if($3 > maxPercDiffF)
               classSC = "X";

            else if(percSNPF > maxSnpPercDiffF)
               classSC = "X";

            else
               classSC = "C";

            print $0,
                  percSNPF,
                  percCoverF,
                  refLenSI,
                  classSC;
         } # Else: on consensus cgMLST results
      }; MAIN

      END{
         # make sure all loci are present
         while(lociCntSI < numLociSI)
         { # Loop: print missing loci
            print lociAryStr[lociCntSI],
                  "NA",
                  "NA",
                  "NA",
                  "NA",
                  "NA",
                  "NA",
                  "NA",
                  "NA",
                  "NA",
                  "*";
            ++lociCntSI;
         } # Loop: print missing loci
      } # END
   ' \
   "$linDbStr" \
   "$prefixStr-cgMLST-map.tsv" \
  > "$prefixStr-cgMLST-map-lin.tsv";

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec04:
#   - detect problem loci
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

awk '
       BEGIN{
          getline;
          print $0;
       }; # BEGIN

      { # MAIN
         if($11 != "C")
            print $0;
      }; # MAIN
    ' \
   "$prefixStr-cgMLST-map-lin.tsv" \
  > "$prefixStr-cgMLST-map-lin-problem.tsv";

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec05:
#   - build spread sheet entry
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

tail \
    -n+2 \
    "$prefixStr-cgMLST-map-lin.tsv" |
  sort -k 1 |
  awk \
      -v outFlagStr="$outFlagStr" \
      '
         BEGIN{
            OFS= "\t";
            headStr = "id";
            linStr = outFlagStr;
            getline; # get off header
         };

         { # MAIN
            headStr = headStr "\t" $1;

            if($11 != "C")
               linStr = linStr "\t*";
            else
               linStr = linStr "\t" $2;
         }; # MAIN

         END{printf "%s\n%s\n", headStr, linStr};
    ' \
   "$prefixStr-cgMLST-map-lin.tsv" \
  > "$prefixStr-cgMLST-map-lin-sheet.tsv";
