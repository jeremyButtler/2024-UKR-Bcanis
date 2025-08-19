#!/usr/bin/env Rscript

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec01:
#   - variable declarations
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

inStr = commandArgs(); # user input

dbStr = "01-input/bAnthracis-VNTR-linDb.tsv";
dbDF = read.csv(dbStr, header = TRUE, sep = "\t");
lenDbSI = length(dbDF$vrrA);
siRow = 1; # row on in database


dataDF = NA; # holds input data
matchSI = 0; # number of matchs
misSI = 0;   # number of mismatches
naSI = 0;   # number of NAs

outDF =
   data.frame(
      scoreSI = rep(0, lenDbSI),
      matchSI = rep(0, lenDbSI),
      misSI = rep(0, lenDbSI),
      naSI = rep(0, lenDbSI),
      key = dbDF$key,
      collection = dbDF$collection,
      strain = dbDF$strain,
      canSNP = dbDF$canSNP
   ); # make output dataframe

#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Sec02:
#   - find score
#   o sec02 sub01:
#     - find scores for each primer
#   o sec02 sub02:
#     - print score for reference
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

if(length(inStr) < 6 ||
   inStr[6] == "-h" ||
   inStr[6] == "--h" ||
   inStr[6] == "help" ||
   inStr[6] == "-help" ||
   inStr[6] == "--help"
){ # If: wanted help message
   print("linSearch.r lineages.tsv");
   print(
      paste(
         "  - searches for close lineages to input in",
         dbStr
      )
   );

   q("no");
} # If: wanted help message

dataDF = read.csv(inStr[6], header = TRUE, sep = "\t");

#*********************************************************
# Sec02 Sub01:
#   - find scores for each primer
#   o sec01 Sub01 Cat02:
#     - print header and start lineage search loop
#   o sec01 sub01 cat02:
#     - vrr loci
#   o sec01 sub01 cat03:
#     - CG3 and pOX loci
#   o sec01 sub01 cat04:
#     - bams loci
#   o sec01 sub01 cat05:
#     - vntr loci
#*********************************************************

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Sec01 Sub01 Cat02:
#   - print header and start lineage search loop
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

cat("score\tnum_match\tnum_miss\tnum_NA\tkey");
cat("\tcollection\tstrain\tcanSNP\n");

while(siRow <= lenDbSI)
{ # Loop: search database for lineage

   #++++++++++++++++++++++++++++++++++++++++++++++++++++++
   # Sec01 Sub01 Cat02:
   #   - vrr loci
   #++++++++++++++++++++++++++++++++++++++++++++++++++++++

   if(! grepl("^[0-9]*$", dbDF$vrrA[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$vrrA)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
      as.numeric(dbDF$vrrA[siRow]) ==
      as.numeric(dataDF$vrrA)
   ){ 
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: vrrA type mates

   if(! grepl("^[0-9]*$", dbDF$vrrB1[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$vrrB1)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
      as.numeric(dbDF$vrrB1[siRow]) ==
      as.numeric(dataDF$vrrB1)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: vrrB1 type mates

   if(! grepl("^[0-9]*$", dbDF$vrrB2[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$vrrB2)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
       as.numeric(dbDF$vrrB2[siRow]) ==
       as.numeric(dataDF$vrrB2)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: vrrB2 type mates

   if(! grepl("^[0-9]*$", dbDF$vrrC1[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$vrrC1)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$vrrC1[siRow]) ==
        as.numeric(dataDF$vrrC1)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: vrrC1 type mates

   if(! grepl("^[0-9]*$", dbDF$vrrC2[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$vrrC2)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$vrrC2[siRow]) ==
        as.numeric(dataDF$vrrC2)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: vrrC2 type mates

   #++++++++++++++++++++++++++++++++++++++++++++++++++++++
   # Sec01 Sub01 Cat03:
   #   - CG3 and pOX loci
   #++++++++++++++++++++++++++++++++++++++++++++++++++++++

   if(! grepl("^[0-9]*$", dbDF$CG3[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$CG3)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$CG3[siRow]) ==
        as.numeric(dataDF$CG3)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
     if(
        abs(as.numeric(dbDF$CG3[siRow]) -
            as.numeric(dataDF$CG3)
        ) > 1
     ){
         outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
     } else {
         outDF$misSI[siRow] = outDF$misSI[siRow] + 0.5;
     } # can be 2bp difference, check if 2bp off
   } # If: CG3 type mates

   if(! grepl("^[0-9]*$", dbDF$pXO1[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$pXO1)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$pXO1[siRow]) ==
        as.numeric(dataDF$pXO1)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: pXO1 type mates

   if(! grepl("^[0-9]*$", dbDF$pXO2[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$pXO2)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$pXO2[siRow]) ==
        as.numeric(dataDF$pXO2)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: pXO2 type mates

   #++++++++++++++++++++++++++++++++++++++++++++++++++++++
   # Sec01 Sub01 Cat04:
   #   - bams loci
   #++++++++++++++++++++++++++++++++++++++++++++++++++++++

   if(! grepl("^[0-9]*$", dbDF$bams01[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams01)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams01[siRow]) ==
        as.numeric(dataDF$bams01)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams01 type mates

   if(! grepl("^[0-9]*$", dbDF$bams03[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams03)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams03[siRow]) ==
        as.numeric(dataDF$bams03)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams03 type mates

   if(! grepl("^[0-9]*$", dbDF$bams05[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams05)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams05[siRow]) ==
        as.numeric(dataDF$bams05)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams05 type mates
   
   if(! grepl("^[0-9]*$", dbDF$bams07[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams07)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams07[siRow]) ==
        as.numeric(dataDF$bams07)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams07 type mates
   
   if(! grepl("^[0-9]*$", dbDF$bams13[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams13)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams13[siRow]) ==
        as.numeric(dataDF$bams13)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams13 type mates
   
   if(! grepl("^[0-9]*$", dbDF$bams15[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams15)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams15[siRow]) ==
        as.numeric(dataDF$bams15)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams15 type mates
   
   if(! grepl("^[0-9]*$", dbDF$bams21[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams21)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams21[siRow]) ==
        as.numeric(dataDF$bams21)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams21 type mates

   if(! grepl("^[0-9]*$", dbDF$bams22[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams22)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams22[siRow]) ==
        as.numeric(dataDF$bams22)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams22 type mates
   
   if(! grepl("^[0-9]*$", dbDF$bams23[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams23)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams23[siRow]) ==
        as.numeric(dataDF$bams23)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams23 type mates

   if(! grepl("^[0-9]*$", dbDF$bams24[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams24)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams24[siRow]) ==
        as.numeric(dataDF$bams24)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams24 type mates
   
   if(! grepl("^[0-9]*$", dbDF$bams25[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams25)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams25[siRow]) ==
        as.numeric(dataDF$bams25)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams25 type mates
   
   if(! grepl("^[0-9]*$", dbDF$bams28[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams28)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams28[siRow]) ==
        as.numeric(dataDF$bams28)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams28 type mates
   
   if(! grepl("^[0-9]*$", dbDF$bams30[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams30)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams30[siRow]) ==
        as.numeric(dataDF$bams30)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams30 type mates
   
   if(! grepl("^[0-9]*$", dbDF$bams31[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams31)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams31[siRow]) ==
        as.numeric(dataDF$bams31)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams31 type mates
   
   if(! grepl("^[0-9]*$", dbDF$bams34[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams34)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams34[siRow]) ==
        as.numeric(dataDF$bams34)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams34 type mates
   
   if(! grepl("^[0-9]*$", dbDF$bams44[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams44)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams44[siRow]) ==
        as.numeric(dataDF$bams44)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams44 type mates

   if(! grepl("^[0-9]*$", dbDF$bams51[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams51)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams51[siRow]) ==
        as.numeric(dataDF$bams51)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams51 type mates

   if(! grepl("^[0-9]*$", dbDF$bams53[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$bams53)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$bams53[siRow]) ==
        as.numeric(dataDF$bams53)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: bams53 type mates
   
   #++++++++++++++++++++++++++++++++++++++++++++++++++++++
   # Sec01 Sub01 Cat05:
   #   - vntr loci
   #++++++++++++++++++++++++++++++++++++++++++++++++++++++

   if(! grepl("^[0-9]*$", dbDF$vntr12[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$vntr12)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$vntr12[siRow]) ==
        as.numeric(dataDF$vntr12)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else if(
      abs(
          as.numeric(dbDF$vntr12[siRow]) -
          as.numeric(dataDF$vntr12)
      ) > 1
   ){
      outDF$misSI[siRow] = outDF$misSI[siRow] + 0.25;
      # making 0.25 so is distinct from CG3 (0.5)
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: vntr12 type mates

   if(! grepl("^[0-9]*$", dbDF$vntr16[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$vntr16)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$vntr16[siRow]) ==
        as.numeric(dataDF$vntr16)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: vntr16 type mates

   if(! grepl("^[0-9]*$", dbDF$vntr17[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$vntr17)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$vntr17[siRow]) ==
        as.numeric(dataDF$vntr17)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: vntr17 type mates

   if(! grepl("^[0-9]*$", dbDF$vntr19[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$vntr19)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$vntr19[siRow]) ==
        as.numeric(dataDF$vntr19)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: vntr19 type mates

   if(! grepl("^[0-9]*$", dbDF$vntr23[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$vntr23)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$vntr23[siRow]) ==
        as.numeric(dataDF$vntr23)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: vntr23 type mates
   
   if(! grepl("^[0-9]*$", dbDF$vntr32[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$vntr32)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$vntr32[siRow]) ==
        as.numeric(dataDF$vntr32)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: vntr32 type mates

   if(! grepl("^[0-9]*$", dbDF$vntr35[siRow])) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(! grepl("^[0-9]*$", dataDF$vntr35)) {
      outDF$naSI[siRow] = outDF$naSI[siRow] + 1;
   } else if(
        as.numeric(dbDF$vntr35[siRow]) ==
        as.numeric(dataDF$vntr35)
   ){
      outDF$matchSI[siRow] = outDF$matchSI[siRow] + 1;
   } else {
      outDF$misSI[siRow] = outDF$misSI[siRow] + 1;
   } # If: vntr35 type mates
   
   #***************************************************
   # Sec02 Sub02:
   #   - print score for reference
   #***************************************************

   outDF$scoreSI[siRow] = 
         outDF$matchSI[siRow] - outDF$misSI[siRow];

   siRow = siRow + 1;
} # Loop: search database for lineage

# sort data greatest to least
outDF = outDF[order(outDF$matchSI, decreasing = TRUE),];
outDF = outDF[order(outDF$scoreSI, decreasing = TRUE),];

write.table(
   outDF,
   quote=FALSE,
   sep='\t',
   col.names = FALSE,
   row.names = FALSE
);
