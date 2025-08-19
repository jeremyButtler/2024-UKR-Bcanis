#!/usr/bin/awk -f

BEGIN{
  getline; # get past header
  printf "|    id    | code | amp len |";
  printf " expec len | rep len | def unit |\n";
  printf "|:---------|:-----|:--------|";
  printf ":----------|:--------|:---------|\n";
}; # BEGIN block (print header)

{ # MAIN
   # get gene name from primer name
   idStr = $2;
   sub(/_.*/, "", idStr); # gene name

   # get repeat size from primer name
   repLenSI = $2;
   sub(/[^_]*_/, "", repLenSI); # remove gene name
   sub(/b*p*_.*/, "", repLenSI); # isloate number

   # get max gene length from primer name
   maxLenSI = $2;
   sub(/[^_]*.[^_]*./, "", maxLenSI);
   sub(/b*p*_.*/, "", maxLenSI); # isloate number

   # max (?) number repeat units from primer name
   maxUnitSI = $2;
   sub(/U.*/, "", maxUnitSI); # remove U/id ending
   sub(/.*_/, "", maxUnitSI); # remove id/lengths

   # find code
   codeSI = maxLenSI - $3;
   offsetSI = codeSI / repLenSI;

   if((offsetSI ? -offsetSI: offsetSI) % 1 >= 0.5)
   { # If: can round
      if(offsetSI >= 1)
         --offsetSI;
      else if(offsetSI < 0)
         --offsetSI;
      else
         offsetSI = 0;
   } # If: can round

   offsetSI = int(offsetSI);
   codeSI = maxUnitSI - offsetSI;

   printf "| %-8s | %-4s | %-7s |", idStr, codeSI, $3;
   printf " %-9s | %-7s |", maxLenSI, repLenSI;
   printf " %-8s |\n", maxUnitSI;
}; # MAIN
