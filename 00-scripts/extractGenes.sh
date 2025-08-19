#!/usr/bin/sh

# $1 is consensus to extraxt from
# $2 is database with loci/alleles

minimap2 -a --eqx --secondary=no $1 $2 |
  filtsam -F 4 -F 256 -F 2048 -out-stats -sam - |
  awk 'BEGIN{getline;}; {print $5, $5 + $7, $2;};' |
  sort -V |
  awk ' # remove duplicate coordinates
       { # MAIN
          startSI = $1; # starting coordinate
          endSI = $2;   # ending coordinate

          if(NR == 1)
          { # If: first row (no data read in yet)
             print "ref", "start", "end"; # print header
             lastStartSI = startSI;
             lastEndSI = endSI;
          } # If: first row (no data read in yet)

          else if(lastEndSI <= startSI || lastStartSI >= endSI)
          { # Else If: one new allele/locus
             print $3, lastStartSI, lastEndSI;
             lastStartSI = startSI;
             lastEndSI = endSI;
          } # Else If: one new allele/locus

         else
         { # Else: is variant of last allele
            if(lastStartSI > startSI)
               lastStartSI = startSI;
            if(lastEndSI < endSI)
               lastEndSI = endSI;
         } # Else: is variant of last allele
       } # MAIN
    ' > coordinates.tsv &&
  awk ' # extract genes
     BEGIN{getline;} # get off header

     { # MAIN
        if(fileStr == "")
           fileStr = FILENAME;

        if(fileStr == FILENAME)
        { # If: getting coordaintes
           ++numCoordsSI;
           startArySI[numCoordsSI] = $2;
           endArySI[numCoordsSI] = $3;
           refIdAryStr[numCoordsSI] = $1;
        } # If: getting coordaintes

        else
        { # Else: reading in sequence
           if($0 ~ /^>/)
           { # If: header for fasta entry
              ++numRefSI;
              sub(/^>/, "", $1); # remove header marker
              usedBl = 0;

              for(siCoord = 1;
                  siCoord <= numCoordsSI;
                  ++siCoord)
              { # Loop: find reference coordinate
                 if(refIdAryStr[siCoord] == $1)
                 { # If: reference used in coordiante
                    indexArySI[siCoord] = numRefSI;
                    usedBl = 1;
                 } # If: reference used in coordiante
              } # Loop: find reference coordinate

              if(usedBl != 1)
                 siIndex = 0; # reference not used
              else
                 siIndex = numRefSI; # mark reference
           } # If: header for fasta entry

           else if(siIndex > 0)
              seqAryStr[siIndex] = seqAryStr[siIndex] $0;
        } # Else: reading in sequence
     } # MAIN

     END{
        for(siCoord = 1; siCoord <= numCoordsSI; ++siCoord)
        { # Loop: get target region of sequence
           lenSI = endArySI[siCoord] - startArySI[siCoord];
           refIndexSI = indexArySI[siCoord];
              # getting index of reference sequence

           if(refIndexSI == "")
              continue;
              # no reference sequence for coordinate

           printf ">%i-%i-%s\n%s\n",
                startArySI[siCoord],
                endArySI[siCoord],
                refIdAryStr[siCoord],
                substr(seqAryStr[refIndexSI],
                       startArySI[siCoord],
                       lenSI);
        } # Loop: get target region of sequence
     } # END
   ' coordinates.tsv \
     $1 \
  > genes.fa;
