#!/usr/bin/env sh

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# getVNTR.sh SOF: Start Of File
#   - gets VNTR counts
#   o dependencies:
#     - files/programs this script depends on
#   o sec01:
#     - variable declarations
#   o sec02:
#     - get and check user input
#   o sec03:
#     - get primer coordinates and VNTR
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Dependencies:
#   - files/programs this script depends on
#   - getCoord.sh
#     - primFind from bioTools
#     - sh
#   - lenToVNTR.awk
#     - awk
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec01:
#   - variable declarations
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

primStr="01-input/bAnthracis-prim.tsv";
prefixStr="out"
primArgStr="-prim-tsv";
faStr="";

scriptDirStr="$(dirname "$0")";

helpStr="$(basename "$0") -fa genome.fa
  - scans Bacillus anthracis genomes for VNTR sites
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
Output:
   - Files:
     o prefix-primFind.tsv has VNTR primer coorindates
     o prefix-primFind-VNTR.md has VNTR tables (markdown)
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
#   - get primer coordinates and VNTR
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

sh "$scriptDirStr/getCoord.sh" \
    -prefix "$prefixStr-primFind" \
    "$primArgStr" "$primStr" \
    -fa "$faStr";

awk \
    -f "$scriptDirStr/lenToVNTR.awk" \
    "$prefixStr-primFind.tsv" \
  > "$prefixStr-primFind-VNTR.md";

awk \
   -f "$scriptDirStr/mdVNTRToTsv.awk" \
   "$prefixStr-primFind-VNTR.md" \
   > "$prefixStr-primFind-VNTR.tsv";
     
