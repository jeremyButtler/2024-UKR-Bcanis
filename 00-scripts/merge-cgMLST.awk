#!/usr/bin/awk -f

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# merge-cgMLST SOF: Start Of File
#   - merges cgMLST tsv reports
#   o sec01:
#     - setup and check if print help message
#   o sec02:
#     - Get lineages for the sample and references
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec01:
#   - setup and check if print help message
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

BEGIN{
   OFS="\t";
   fileBl = 1;

   helpStr = "awk -f merge-clustMLST sample-cgMLST.tsv ";
   helpStr = helpStr "refs-cgMLST.tsv ...\n";

   helpStr = helpStr "  o outStr: prefix to name files\n";

   helpStr = helpStr "  o sample-cgMLST.tsv: sample";
   helpStr = helpStr " to find\n";
   helpStr = helpStr "    close lineages for\n";

   helpStr = helpStr "  o refs-cgMLST.tsv: one or more";
   helpStr = helpStr " files\n";
   helpStr = helpStr "    with cgMLST lineages to compare";
   helpStr = helpStr " sample to\n";

   if(help != "")
   { # If: user input nothing
      printf "%s", helpStr;
      helpBl = 1;
      exit;
   } # If: user input nothing

   else
      helpBl = 0;
}; # BEGIN

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec02:
#   - get lineages for the sample and references
#   o sec02 sub01:
#     - moving to new file + find differences
#   o sec02 sub02:
#     - add new allele to array
#   o sec04:
#     - get final ref difference + print all totals
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#********************************************************
# Sec02 Sub01:
#   - moving to new file + find differences
#********************************************************

{  # MAIN

   if(fileStr != FILENAME)
   { # If: changing files

      if(fileStr != "")
      { # If: not first sample
         firstBl = 0;            # first line

         if(conSI > 1)
         { # If: finished second or later sample

            # find differences between samples
            diffArySI[conSI] = 0;

            for(siCnt= 1; siCnt <= maxSI; ++siCnt)
            { # Loop: find number of differences
               if(arySI[1][siCnt] != arySI[conSI][siCnt])
                  ++diffArySI[conSI];

            } # Loop: find number of differences

         } # If: finished second or later sample

      } # If: not first sample

      fileStr = FILENAME;
      ++conSI;                # consensus one
      getline;                # get off header
      getline;                # get off spacer row

   } # If: changing files

   #******************************************************
   # Sec02 Sub02:
   #   - add new allele to array
   #******************************************************

   sub("GBAA_RS", "", $1); # remove non-numeric char
   $1 = int($1);

   arySI[conSI][int($1)] = $2; # allele for consensus

   if(int($1) > maxSI)
      maxSI = int($1);
}; # MAIN

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec04:
#   - get final ref difference + print all totals
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

END{
   # find the final references difference count

   if(helpBl == 0)
   { # If: did not pring help message

      diffArySI[conSI] = 0;

      for(siCnt = 1; siCnt <= maxSI; ++siCnt)
      { # Loop: find number of differences

         if(arySI[1][siCnt] != arySI[conSI][siCnt])
         { # If: had difference
            ++diffArySI[conSI];
         } # If: had difference

      } # Loop: find number of differences

      printf "total\t*";

      for(siCnt = 2; siCnt <= conSI; ++siCnt)
         printf "\t%i", diffArySI[siCnt];

      printf "\n";

   } # If: did not pring help message
};   # END
