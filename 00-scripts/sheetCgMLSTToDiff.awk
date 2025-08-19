BEGIN{
   OFS="\t";
   getline; # get off header

   if(matrixBl == "")
      matrixBl = 0;
} # BEGIN

{ # MAIN
    ++hitSI;

    for(iCol = 1; iCol <= NF; ++iCol)
       arySI[hitSI][iCol] = $iCol;

    if(NF > maxColSI)
       maxColSI = NF;
}; # MAIN

END{
   print "ref", "target", "match", "dist", "miss";

   if(matrixBl == 0)
   { # If: not printing distance matrix
      for(iRow = 1; iRow < hitSI; ++iRow)
      { # Loop: compare rows
         matchSI = 0;
         distSI = 0;
         missSI = 0;

         for(iCol = 2; iCol < maxColSI; ++iCol)
         { # Loop: compare reference to target (last entry)
            if(arySI[iRow][iCol] == "*")
               ++missSI;
            else if(arySI[iRow][iCol] == "")
               ++missSI;
            else if(arySI[hitSI][iCol] == "*")
               ++missSI;
            else if(arySI[hitSI][iCol] == "")
               ++missSI;
            else if(arySI[hitSI][iCol] != arySI[iRow][iCol])
               ++distSI;
            else
               ++matchSI;
         } # Loop: compare reference to target (last entry)

         print arySI[iRow][1],
               arySI[hitSI][1],
               matchSI,
               distSI,
               missSI;
      } # Loop: compare rows
   } # If: not printing distance matrix

   else
   { # Else: printing distance matrix
      for(iHit = 1; iHit <= hitSI; ++iHit)
      { # Loop: compare all hits
         for(iRow = 1; iRow <= hitSI; ++iRow)
         { # Loop: compare rows
            matchSI = 0;
            distSI = 0;
            missSI = 0;

            for(iCol = 2; iCol < maxColSI; ++iCol)
            { # Loop: compare reference to target (last entry)
               if(arySI[iRow][iCol] == "*")
                  ++missSI;
               else if(arySI[iRow][iCol] == "")
                  ++missSI;
               else if(arySI[iHit][iCol] == "*")
                  ++missSI;
               else if(arySI[iHit][iCol] == "")
                  ++missSI;
               else if(arySI[iHit][iCol] != arySI[iRow][iCol])
                  ++distSI;
               else
                  ++matchSI;
            } # Loop: compare reference to target (last entry)

            print arySI[iRow][1],
                  arySI[iHit][1],
                  matchSI,
                  distSI,
                  missSI;
         } # Loop: compare rows
      } # Loop: compare all hits
   } # Else: printing distance matrix
} # END
