#!/usr/bin/sh

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Name: rimSphCgMlstCnvt.sh
#   - convets a rimSphere cgMLST database to something my
#     scripts can handel
# Input:
#   - $1: output prefix for database
#   - $2 to $#: fasta files to convert
# Sections:
#   o sec01:
#     - variable declarations and help message
#   o sec02:
#     - do conversion
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec01:
#   - variable declarations and help message
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

prefixStr="$1";
helpStr="$(basename "$0")
   - converts remSphere cgMLST fasta database something
     that my scripts can handel
   - $1 (1st item): prefix to name new database
     - use $(basename "$0") -h to get help message
   - $2 to $# (2nd to last item): fasta files to convert
";

alleleStr=""; # allele working on

shift; # get off first argument

if [ $# -le 0 ]; then
   printf "%s\n" "$helpStr";
   exit; # no more input
elif [ "$prefixStr" = "" ]; then
   printf "%s\n" "$helpStr";
   exit; # no input
elif [ "$prefixStr" = "-h" ]; then
   printf "%s\n" "$helpStr";
   exit;
elif [ "$prefixStr" = "--h" ]; then
   printf "%s\n" "$helpStr";
   exit;
elif [ "$prefixStr" = "help" ]; then
   printf "%s\n" "$helpStr";
   exit;
elif [ "$prefixStr" = "-help" ]; then
   printf "%s\n" "$helpStr";
   exit;
elif [ "$prefixStr" = "--help" ]; then
   printf "%s\n" "$helpStr";
   exit;
fi

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec02:
#   - do conversion
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

while [ $# -gt 0 ];
do   # get fasta files input by user
   alleleStr="$(basename "$1" | sed 's/.*\.//;')";

   if [ "$alleleStr" != "fasta" ];
   then # If: fasta file does not end in .fasta

      if [ "$alleleStr" != "fa" ];
      then # If: file is not a fasta file
         printf "%s is not a fasta file\n" "$1";
         exit;
      fi   # If: file is not a fasta file
   fi   # If: fasta file does not end in .fasta

   alleleStr="$(basename "$1" | sed 's/\.fas*t*a*//;')";

   awk \
      -v alleleStr="$alleleStr" \
      -v prefixStr="$prefixStr" \
      '
         BEGIN{
            faDbStr = prefixStr "--seqDb.fa";
            tsvDbStr = prefixStr "--lenDb.tsv";
         } # BEGIN

         { # Main
            if($0 ~ /^$/)
               next; # blank line

            getline; # get sequence (always one line)
            ++cntSI;

            printf ">%s", alleleStr >> faDbStr;
            printf "--%i\n", cntSI >> faDbStr;
            printf "%s\n", $0 >> faDbStr;

            printf "%s\t%i", alleleStr, cntSI >> tsvDbStr;
            printf "\t%i\n", length($0) >> tsvDbStr;
         } # Main
      ' \
      < "$1";

   shift; # move to next argument
done # get fasta files input by user
