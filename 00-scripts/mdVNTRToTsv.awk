#!/usr/bin/awk -f

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# mdVNTRToTsv.awk SOF: Start Of File
#   - converts markdown VNTR table to tsv
#   o sec01:
#     - move past header
#   o sec02:
#     - get first entry + check if missed vrrA
#   o sec03:
#     - check if missed any loci
#   o sec04:
#     - add current loci to output
#   o sec05:
#     - final loci check and print results
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec01:
#   - move past header
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

BEGIN{
   getline; # get past header
   getline; # get past table separator
} # BEGIN

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec02:
#   - get first entry + check if missed vrrA
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

{ # MAIN
   if(lastStr == "")
   { # If: first round
      lastStr = "vrrA";

      if($2 != "vrrA")
      { # If: not the vrrA entry
         headStr = "vrrA";
         codeStr = "*";
      } # If: not the vrrA entry

      else
      { # Else: have vrrA locus
         headStr = $2;
         codeStr =  $4;
         next;
      } # Else: have vrrA locus
   } # If: first round

   #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
   # Sec03:
   #   - check if missed any loci
   #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

   if(lastStr == "vrrA")
   { # If: last entry was vrrA
      if($2 != "vrrB1")
      { # If: missed entry
         headStr = headStr "\tvrrB1";
         codeStr = codeStr "\t*";
         lastStr = "vrrB1"
      } # If: missed entry
   } # If: last entry was vrrA

   if(lastStr == "vrrB1")
   { # If: last entry was vrrB1
      if($2 != "vrrB2")
      { # If: missed entry
         headStr = headStr "\tvrrB2";
         codeStr = codeStr "\t*";
         lastStr = "vrrB2"
      } # If: missed entry
   } # If: last entry was vrrB1

   if(lastStr == "vrrB2")
   { # If: last entry was vrrB2
      if($2 != "vrrC1")
      { # If: missed entry
         headStr = headStr "\tvrrC1";
         codeStr = codeStr "\t*";
         lastStr = "vrrC1"
      } # If: missed entry
   } # If: last entry was vrrB2

   if(lastStr == "vrrC1")
   { # If: last entry was vrrC1
      if($2 != "vrrC2")
      { # If: missed entry
         headStr = headStr "\tvrrC2";
         codeStr = codeStr "\t*";
         lastStr = "vrrC2"
      } # If: missed entry
   } # If: last entry was vrrC1

   if(lastStr == "vrrC2")
   { # If: last entry was vrrC2
      if($2 != "CG3")
      { # If: missed entry
         headStr = headStr "\tCG3";
         codeStr = codeStr "\t*";
         lastStr = "CG3"
      } # If: missed entry
   } # If: last entry was vrrC2

   if(lastStr == "CG3")
   { # If: last entry was CG3
      if($2 != "pXO1")
      { # If: missed entry
         headStr = headStr "\tpXO1";
         codeStr = codeStr "\t*";
         lastStr = "pXO1"
      } # If: missed entry
   } # If: last entry was CG3

   if(lastStr == "pXO1")
   { # If: last entry was pXO1
      if($2 != "pXO2")
      { # If: missed entry
         headStr = headStr "\tpXO2";
         codeStr = codeStr "\t*";
         lastStr = "pXO2"
      } # If: missed entry
   } # If: last entry was pXO1

   if(lastStr == "pXO2")
   { # If: last entry was pXO2
      if($2 != "bams01")
      { # If: missed entry
         headStr = headStr "\tbams01";
         codeStr = codeStr "\t*";
         lastStr = "bams01"
      } # If: missed entry
   } # If: last entry was pXO2

   if(lastStr == "bams01")
   { # If: last entry was bams01
      if($2 != "bams03")
      { # If: missed entry
         headStr = headStr "\tbams03";
         codeStr = codeStr "\t*";
         lastStr = "bams03"
      } # If: missed entry
   } # If: last entry was pXO2

   if(lastStr == "bams03")
   { # If: last entry was bams03
      if($2 != "bams05")
      { # If: missed entry
         headStr = headStr "\tbams05";
         codeStr = codeStr "\t*";
         lastStr = "bams05"
      } # If: missed entry
   } # If: last entry was bams03

   if(lastStr == "bams05")
   { # If: last entry was bams05
      if($2 != "bams07")
      { # If: missed entry
         headStr = headStr "\tbams07";
         codeStr = codeStr "\t*";
         lastStr = "bams07"
      } # If: missed entry
   } # If: last entry was bams05

   if(lastStr == "bams07")
   { # If: last entry was bams07
      if($2 != "bams13")
      { # If: missed entry
         headStr = headStr "\tbams13";
         codeStr = codeStr "\t*";
         lastStr = "bams13"
      } # If: missed entry
   } # If: last entry was bams07

   if(lastStr == "bams13")
   { # If: last entry was bams13
      if($2 != "bams15")
      { # If: missed entry
         headStr = headStr "\tbams15";
         codeStr = codeStr "\t*";
         lastStr = "bams15"
      } # If: missed entry
   } # If: last entry was bams13

   if(lastStr == "bams15")
   { # If: last entry was bams15
      if($2 != "bams21")
      { # If: missed entry
         headStr = headStr "\tbams21";
         codeStr = codeStr "\t*";
         lastStr = "bams21"
      } # If: missed entry
   } # If: last entry was bams15

   if(lastStr == "bams21")
   { # If: last entry was bams21
      if($2 != "bams22")
      { # If: missed entry
         headStr = headStr "\tbams22";
         codeStr = codeStr "\t*";
         lastStr = "bams22"
      } # If: missed entry
   } # If: last entry was bams21

   if(lastStr == "bams22")
   { # If: last entry was bams22
      if($2 != "bams23")
      { # If: missed entry
         headStr = headStr "\tbams23";
         codeStr = codeStr "\t*";
         lastStr = "bams23"
      } # If: missed entry
   } # If: last entry was bams22

   if(lastStr == "bams23")
   { # If: last entry was bams23
      if($2 != "bams24")
      { # If: missed entry
         headStr = headStr "\tbams24";
         codeStr = codeStr "\t*";
         lastStr = "bams24"
      } # If: missed entry
   } # If: last entry was bams23

   if(lastStr == "bams24")
   { # If: last entry was bams24
      if($2 != "bams25")
      { # If: missed entry
         headStr = headStr "\tbams25";
         codeStr = codeStr "\t*";
         lastStr = "bams25"
      } # If: missed entry
   } # If: last entry was bams24

   if(lastStr == "bams25")
   { # If: last entry was bams25
      if($2 != "bams28")
      { # If: missed entry
         headStr = headStr "\tbams28";
         codeStr = codeStr "\t*";
         lastStr = "bams28"
      } # If: missed entry
   } # If: last entry was bams25

   if(lastStr == "bams28")
   { # If: last entry was bams28
      if($2 != "bams30")
      { # If: missed entry
         headStr = headStr "\tbams30";
         codeStr = codeStr "\t*";
         lastStr = "bams30"
      } # If: missed entry
   } # If: last entry was bams28

   if(lastStr == "bams30")
   { # If: last entry was bams30
      if($2 != "bams31")
      { # If: missed entry
         headStr = headStr "\tbams31";
         codeStr = codeStr "\t*";
         lastStr = "bams31"
      } # If: missed entry
   } # If: last entry was bams30

   if(lastStr == "bams31")
   { # If: last entry was bams31
      if($2 != "bams34")
      { # If: missed entry
         headStr = headStr "\tbams34";
         codeStr = codeStr "\t*";
         lastStr = "bams34"
      } # If: missed entry
   } # If: last entry was bams31

   if(lastStr == "bams34")
   { # If: last entry was bams34
      if($2 != "bams44")
      { # If: missed entry
         headStr = headStr "\tbams44";
         codeStr = codeStr "\t*";
         lastStr = "bams44"
      } # If: missed entry
   } # If: last entry was bams34

   if(lastStr == "bams44")
   { # If: last entry was bams44
      if($2 != "bams51")
      { # If: missed entry
         headStr = headStr "\tbams51";
         codeStr = codeStr "\t*";
         lastStr = "bams51"
      } # If: missed entry
   } # If: last entry was bams44

   if(lastStr == "bams51")
   { # If: last entry was bams51
      if($2 != "bams53")
      { # If: missed entry
         headStr = headStr "\tbams53";
         codeStr = codeStr "\t*";
         lastStr = "bams53"
      } # If: missed entry
   } # If: last entry was bams51

   if(lastStr == "bams53")
   { # If: last entry was bams53
      if($2 != "vntr12")
      { # If: missed entry
         headStr = headStr "\tvntr12";
         codeStr = codeStr "\t*";
         lastStr = "vntr12"
      } # If: missed entry
   } # If: last entry was bams53

   if(lastStr == "vntr12")
   { # If: last entry was vntr12
      if($2 != "vntr16")
      { # If: missed entry
         headStr = headStr "\tvntr16";
         codeStr = codeStr "\t*";
         lastStr = "vntr16"
      } # If: missed entry
   } # If: last entry was vntr12

   if(lastStr == "vntr16")
   { # If: last entry was vntr16
      if($2 != "vntr17")
      { # If: missed entry
         headStr = headStr "\tvntr17";
         codeStr = codeStr "\t*";
         lastStr = "vntr17"
      } # If: missed entry
   } # If: last entry was vntr16

   if(lastStr == "vntr17")
   { # If: last entry was vntr17
      if($2 != "vntr19")
      { # If: missed entry
         headStr = headStr "\tvntr19";
         codeStr = codeStr "\t*";
         lastStr = "vntr19"
      } # If: missed entry
   } # If: last entry was vntr17

   if(lastStr == "vntr19")
   { # If: last entry was vntr19
      if($2 != "vntr23")
      { # If: missed entry
         headStr = headStr "\tvntr23";
         codeStr = codeStr "\t*";
         lastStr = "vntr23"
      } # If: missed entry
   } # If: last entry was vntr19

   if(lastStr == "vntr23")
   { # If: last entry was vntr23
      if($2 != "vntr32")
      { # If: missed entry
         headStr = headStr "\tvntr32";
         codeStr = codeStr "\t*";
         lastStr = "vntr32"
      } # If: missed entry
   } # If: last entry was vntr23

   #>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
   # Sec04:
   #   - add current loci to output
   #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

   headStr = headStr "\t" $2;
   codeStr = codeStr "\t" $4;
   lastStr = $2;
}; # MAIN

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec05:
#   - final loci check and print results
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

END{
   if(lastStr != "vntr35")
   { # If: missed entry
      headStr = headStr "\tvntr35";
      codeStr = codeStr "\t*";
      lastStr = "vntr35"
   } # If: missed entry

   print headStr;
   print codeStr;
}; # END
