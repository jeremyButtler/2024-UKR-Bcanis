#!/usr/bin/sh

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# adjustAln.sh SOF: Start Of File
#   - ajdusts a circlar query sequence to start at the
#     first base in the reference sequence
#   o sec01:
#     - variable declarations
#   o sec02:
#     - get input and check input
#   o sec03:
#     - ajdust query sequence
#   o sec04:
#     - clean up
#   * Requrements:
#     - filtsam from bioTools
#     - minimap2
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec01:
#   - variable declarations
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

refStr="";
qryStr="";
prefixStr="out";

extStr=""; # file extension

helpStr="$(basename "$0") -ref reference.fa -qry query.fa
  - ajdust query sequence so that its first base is the
    first base of the reference. This also trims off any
    extra overlapping bases
  -ref: fasta file with reference sequence(s) to adjust
        query to
  -qry: fasta file with query sequence(s) to adjust
  -prefix [$prefxiStr]: prefix to name output with 
";
        
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec02:
#   - get input and check input
#   o sec02 sub01:
#     - get input
#   o sec02 sub02:
#     - check input
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#*********************************************************
# Sec02 Sub01:
#   - get input
#*********************************************************

while [ $# -gt 0 ];
do   # get user input
   if [ "$1" = "-ref" ]; then refStr="$2"; shift;
   elif [ "$1" = "-qry" ]; then qryStr="$2"; shift;
   elif [ "$1" = "-prefix" ]; then prefixStr="$2"; shift;

   elif [ "$1" = "-h" ]; then
      printf "%s\n" "$helpStr"; exit;
   elif [ "$1" = "--h" ]; then
      printf "%s\n" "$helpStr"; exit;
   elif [ "$1" = "help" ]; then
      printf "%s\n" "$helpStr"; exit;
   elif [ "$1" = "-help" ]; then
      printf "%s\n" "$helpStr"; exit;
   elif [ "$1" = "--help" ]; then
      printf "%s\n" "$helpStr"; exit;

   else printf "%s is not recongnized\n" "$1"; exit;
   fi;

   shift;
done; # get user input

#*********************************************************
# Sec02 Sub02:
#   - check input
#*********************************************************

if [ ! -f "$refStr" ];
then
   if [ "$refStr" = "" ]; then
       printf "no input for -ref\n", "$refStr";
   else
      printf "-ref %s could not be opened\n", "$refStr";
   fi;

   exit;
fi;

if [ ! -f "$qryStr" ];
then
   if [ "$qryStr" = "" ]; then
       printf "no input for -qry\n", "$qryStr";
   else
      printf "-qry %s could not be opened\n", "$qryStr";
   fi;

   exit;
fi;

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec03:
#   - ajdust query sequence
#   o sec03 sub01:
#     - make sure the query sequence is in the forward
#       direction
#   o sec03 sub02:
#     - get unmapped starting bases
#   o sec03 sub03:
#     - get first reference base in query
#   o sec03 sub04:
#     - adjust and trim till have same start as reference
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#*********************************************************
# Sec03 Sub01:
#   - make sure the query sequence is in the forward
#     direction
#*********************************************************

awk '{
    if($0 ~ /^>/)
    { # If: reference genome
        if(headStr != "")
           printf "%s\n%s%s\n", headStr, seqStr, seqStr;
        seqStr = "";
        headStr = $0;
    } # If: reference genome

    else
       seqStr = seqStr $0;
   }; # MAIN

   END{printf "%s\n%s%s\n", headStr, seqStr, seqStr;};
  ' "$refStr" > "del-ref.fa";

minimap2 -a "$refStr" "$qryStr" |
 filtsam -F 4 -F 256 -F 2048 -out-fasta -out "del-qry.fa";

qryStr="del-qry.fa";
rm "del-ref.fa";

#*********************************************************
# Sec03 Sub02:
#   - get unmapped starting bases
#*********************************************************

minimap2 -a "$qryStr" "$refStr" |
  filtsam -F 4 -F 256 -F 2048 |
  awk \
    '  # goal is to take the mapping coordiantes and use
       #   them to find the start/end

       {  # MAIN
          if($1 ~ /^@/)
             next; # header

          refStr = $1;

          # get length of masking
          sub(/[0-9]*[M=XDI].*/, "", $6);
          sub("S", "", $6);
          startSI = $6;

          if(startSI == "" || startSI < 100)
             startSI = length($10);
             # in these cases I can not be 100% confident
             #  the alignment found the right spot or
             #  the sequence is already adjusted

          printf ">%s bases=1-%s\n%s\n",
                 refStr,
                 startSI,
                 substr($10, 1, startSI);
       }; # MAIN
    ' > del-subSeq.fa;

#*********************************************************
# Sec03 Sub02:
#   - get first reference base in query
#*********************************************************

minimap2 -a "$qryStr" del-subSeq.fa |
  filtsam -F 4 -F 256 -F 2048 -out-stats |
  awk \
    '
       BEGIN{
          OFS="\t";
          getline; # skip header
          print "sequence", "firstBase", "lastBase";
       }; # BEGIN

       {  # MAIN
          print $2, $5, $7 + $5;
       }; #MAIN
    ' > "$prefixStr-coords.tsv";

#*********************************************************
# Sec03 Sub03:
#   - adjust and trim till have same start as reference
#*********************************************************

awk '
      # converting query input to one line sequence
      {  # MAIN
        if($1 ~ />/)
        { # If: have header
           if(seqStr != "")
              printf "%s\n%s\n", headStr, seqStr;
           headStr = $0;
           seqStr = "";
        } # If: have header

        else
           seqStr = seqStr $0;
      }; # MAIN

      END{
         printf "%s\n%s\n", headStr, seqStr;
      }; # END
    ' "$qryStr" |
  awk \
    '
       # does the adjustment
       {  # MAIN
          if(fileStr == "")
             fileStr = FILENAME;

          if(fileStr == FILENAME)
          { # If: getting coordinates
             ++numSeqSI;

             idAryStr[numSeqSI] = $1;
             startArySI[numSeqSI] = $2;
             endArySI[numSeqSI] = $3;
          } # If: getting coordinates

          else
          { # Else: adjusting sequences
             print $0;
             sub(/^>/, "", $1);

             for(siSeq = 1; siSeq <= numSeqSI; ++siSeq)
                if($1 == idAryStr[siSeq])
                   break;

             getline; # move to sequence

             if(siSeq > numSeqSI)
                print $0; # not adjusting

             else
             { # Else: need to adjust the sequence
                startStr = substr($0,
                                  startArySI[siSeq],
                                  endArySI[siSeq]);
                 midStr = substr($0,
                                 1,
                                 startArySI[siSeq] - 1);
                 print startStr midStr;
             } # Else: need to adjust the sequence
          } # Else: adjusting sequences
       }; # MAIN
    ' \
    "$prefixStr-coords.tsv" \
    - \
  > "$prefixStr-adjust.fa";

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec04:
#   - clean up
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

minimap2 \
    -a \
    --eqx \
    "$refStr" \
    "$prefixStr-adjust.fa" |
  filtsam -F 4 -F 256 -F 2048 -out-fasta -out "tmp.fa";
mv "tmp.fa" "$prefixStr-adjust.fa";

rm del-subSeq.fa;
rm "del-qry.fa";
