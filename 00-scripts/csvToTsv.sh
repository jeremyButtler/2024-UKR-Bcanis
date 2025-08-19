#!/usr/bin/env sh

# here to convert comples csv's to tsvs
# bit hacky, but works

helpStr="$(basename "$0") file.csv > file.tsv
   - hacky script to convert csv to tsv
";

if [ "$1" = "" ];
then
   printf "%s" "$helpStr";
   exit;
fi

case "$1" in
   -h) printf "%s" "$helpStr"; exit;;
   --h) printf "%s" "$helpStr"; exit;;
   help) printf "%s" "$helpStr"; exit;;
   -help) printf "%s" "$helpStr"; exit;;
   --help) printf "%s" "$helpStr"; exit;;
esac

sed 's/[ \t]/_/g;' "$1" |
  awk '
    BEGIN{headBl = 1;}
    {
      lenSI=split($0, rowStr, "");
      strBl = 0; # 1: in string
      outStr=""; # string to print empty string
      colSI = 0;
      siChar = 1;

      if(rowStr[lenSI] ~ /\r/)
         --lenSI;

      while(siChar <= lenSI)
      { # Loop: manualy replace all commas in strings

         if(rowStr[siChar] == "\"")
         { # If: on string

            if(strBl == 0)
               strBl = 1;
            else
               strBl = 0;

         } # If: on string

         else if(rowStr[siChar] == ",")
         { # Else If: on separator

            if(strBl == 0)
            { # If: column separator
               ++colSI;
               outStr = outStr "\t";

               if(rowStr[siChar + 1] == ",")
                  outStr = outStr "*";
            } # If: column separator

            else
               outStr = outStr "_";

         } # Else If: on separator

         else if(rowStr[siChar] !~ /\r/)
            outStr = outStr rowStr[siChar];

         ++siChar;
      } # Loop: manualy replace all commas in strings

      if(rowStr[lenSI] == ",")
         outStr = outStr "*";
         # if had empty last column

      if(maxColSI < colSI)
         maxColSI = colSI;

      else if(colSI < maxColSI)
      { # If: need to add missing columns
         while(colSI <= maxColSI)
         { # Loop: add missing entries
            outStr = outStr "\t*";
            ++colSI;
         } # Loop: add missing entries
      } # If: need to add missing columns


      printf "%s\n", outStr;
}';

