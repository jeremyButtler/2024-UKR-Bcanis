#!/usr/bin/env sh

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# getCoord.sh SOF: Start Of File
#   - gets coordinates for genomes with multiple sequences
#   o sec01:
#     - variable declarations
#   o sec02:
#     - get and check user input
#   o sec03:
#     - get primer coordinates
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec01:
#   - variable declarations
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

primStr="01-input/bAnthracis-prim.tsv";
prefixStr="out"
primArgStr="-prim-tsv";
faStr="";

helpStr="$(basename "$0") -fa genome.fa
  - scans genomes for Bacillus VNTR primer coordinats
Input:
   -fa genome.fa [Required]:
     o fasta file to scan for VNTR primer coordinates
   -prim-fa primers.fa [Optional; not used]:
     o fasta file with primers (reverse comes right after
       forward)
   -prim-tsv primers.tsv [Default: $primStr]:
     o tsv file with primers (primFind -h to get format)
   -prefix $prefixStr: [Option; out]
     o prefix for output
"

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec02:
#   - get and check user input
#   o sec01 sub01:
#     - get input (and setup input)
#   o sec01 sub02:
#     - check user input
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#*********************************************************
# Sec01 Sub01:
#   - get input (and setup input)
#*********************************************************

while [ $# -gt 0 ];
do   # Loop: get user input
   case $1 in
      -prim-fa) primStr="$2";
                primArgStr="-prim-fa";
                shift;;
      -prim-tsv) primStr="$2";
                 primArgStr="-prim-tsv";
                 shift;;
      -fa) faStr="$2"; shift;;
      -prefix) prefixStr="$2"; shift;;

      -h) printf "%s" "$helpStr"; exit;;
      --h) printf "%s" "$helpStr"; exit;;
      help) printf "%s" "$helpStr"; exit;;
      -help) printf "%s" "$helpStr"; exit;;
      --help) printf "%s" "$helpStr"; exit;;

      *) printf "%s not recognized" "$1"; exit;;
    esac

    shift;
done # Loop: get user input

#*********************************************************
# Sec01 Sub02:
#   - check user input
#*********************************************************

if [ ! -f "$faStr" ];
then # If: no fasta file input
   if [ "$faStr" != "" ];
   then # If: something was input
      printf " -fa %s is not a file\n" "$faStr" >&2;
      # need space to remove "-" error with printf
   else
      printf "no fasta file (seq to scan) input\n" >&2;
   fi   # If: something was input

   exit;
fi   # If: no fasta file input


if [ ! -f "$primStr" ];
then # If: no primers input

   if [ "$primStr" != "" ];
   then # If: something was input
      printf "%s %s is not a file\n" \
             "$primArgStr" \
             "$primStr" \
        >&2;
   else
      printf "no primer file input\n" >&2;
   fi   # If: something was input

   exit;

fi   # If: no primers input


if [ "$prefixStr" = "" ];
then # If: no prefix input
  printf "no prefix (-prefix) input; using \"out\"\n" >&2;
  prefixStr="out";
fi   # If: no prefix input


#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec03:
#   - get primer coordinates
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

awk '
      BEGIN{getline; print $0;};
      {if($1 !~ /^>/) print $0;};
      # merging sequences into one big sequence because
      # primFind does not have multi-ref support
    ' \
    "$faStr" |
  primFind \
    "$primArgStr" "$primStr" \
    -fa - \
    -min-perc-score 0.9 \
  > "$prefixStr.tsv";
