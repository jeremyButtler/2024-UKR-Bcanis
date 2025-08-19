#!/usr/bin/awk -f

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# se.awk SOF: Start Of File
#   - awk script to view spread sheets
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Usage:
#   - -v delim="<delimnator>":
#     o deliminator for spread sheet (default tab/space)
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BEGIN{
   if(delim != "")
      FS = delim;
} # BEGIN

{ # MAIN
   ++numRowSI;

   for(siCol = 1; siCol <= NF; ++siCol)
   { # Loop: read in columns + get length
      valAryStr[numRowSI][siCol] = $siCol;

      lenColSI = length($siCol);

      if(lenColSI > lenArySI[siCol])
         lenArySI[siCol] = lenColSI;
   } # Loop: read in columns + get length

   if(siCol > maxColSI)
      maxColSI = siCol - 1;
} # MAIN

END{

   for(siRow = 1; siRow <= numRowSI; ++siRow)
   { # Loop: print out spread sheet
      printf "|";

      if(siRow == 1)
         mdSepStr = "|";

      for(siCol = 1; siCol <= maxColSI; ++siCol)
      { # Loop: print out one row
         printf " %-*s |",
                lenArySI[siCol],
                valAryStr[siRow][siCol];

         if(siRow == 1)
         { # If: header
            mdSepStr = mdSepStr ":";

            for(siSep=1; siSep <= lenArySI[siCol];++siSep)
               mdSepStr = mdSepStr "-"

            mdSepStr = mdSepStr "-|";
         } # If: header
      } # Loop: print out one row

      printf "\n";

      if(siRow == 1)
         printf "%s\n", mdSepStr;
   } # Loop: print out spread sheet

   printf "\nTable:";
} # END
