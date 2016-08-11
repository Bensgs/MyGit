#!/usr/bin/perl -w
use strict;
use warnings;
use IO::Handle;

#param###############################################################
#@CJ
#####################################################################
my $time;
my $workDate;
my $FILNM_OFFLINE;
my $FILNM_ALL;
my $FILNM_OUT_zhekou;
my $FILNM_OUT_quan;

#sub lastDay###########################################################
#@CJ
#######################################################################
sub lastDay{
 my( $d,$m,$y ) = (localtime(time()))[3,4,5];
 $y -=100;
 $m ++;
 if(($m == 2 || $m == 4 || $m == 6 || $m == 8 ||$m == 9 || $m == 11) && $d == 1){
  $m--;
  $d = 31;
 }
 elsif($m == 3 && $d ==1){
  $m--;
  if($y %4 == 0){
     if($y % 100 == 0){
        if($y % 400 == 0){
         $d = 29;}
        else{
         $d = 28;} }
     else{
       $d = 29;} }
  else{
     $d = 28;}
  }
 elsif(($m == 5 || $m == 7 || $m == 10 || $m ==12) && $d ==1){
  $m--;
  $d =30;
 }
 elsif($m == 1 &&  $d ==1){
  $y --;
  $m = 12;
  $d = 31;
 } 
 else{
  $d--;
 }
 return sprintf("%02d%02d%02d",$y,$m,$d);
}

#Begin proc###########################################################
#@CJ
######################################################################
$workDate = &lastDay();

$FILNM_OFFLINE = "/var/ftp/nmylswqs/00011900/20".$workDate."/OFFLINE_TRANS_00011900_20".$workDate.".csv";
$FILNM_ALL = "/var/ftp/nmylswqs/00011900/20".$workDate."/00011900_20".$workDate.".csv";
$FILNM_OUT_zhekou = "/var/ftp/nmylswqs/00011900/20".$workDate."/20".$workDate."_zhekou.csv";
$FILNM_OUT_quan = "/var/ftp/nmylswqs/00011900/20".$workDate."/20".$workDate."_quan.csv";

print"$FILNM_OFFLINE\n$FILNM_ALL\n$FILNM_OUT_zhekou\n$FILNM_OUT_quan\n";

open(FILEOFF,"<","$FILNM_OFFLINE") or die "cannot open the inputfile:$!\n";
open(OUTOFF,">","$FILNM_OUT_zhekou") or die "cannot open the outfile:$!\n";
my @linelist = <FILEOFF>;
foreach my $eachline(@linelist){
   if(substr($eachline,254,5) eq "39183")
    {
      print OUTOFF $eachline;
    }
}
close FILEOFF;
close OUTOFF;

my $FILNM_GZ = $FILNM_ALL.".gz";
`gunzip $FILNM_GZ`;
open(FILE,"<","$FILNM_ALL") or die "cannot open the output file:$!\n";
open(OUTALL,">","$FILNM_OUT_quan") or die "cannot open the input file:$!\n";
my @list = <FILE>;
foreach my $line(@list){
 my @word = split /,/,$line;
 #print "$word[18]\n";
 if(substr($word[18],11,5) eq "94302")
   {
     #print OUTALL $line;
     print "$word[18]\n";
   }
}
close FILE;
close OUTALL;



