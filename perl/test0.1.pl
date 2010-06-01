#!/usr/bin/perl -w
# script to output a quality assured, quality controlled pdf for a loaded assessment
# Cóilín Minto
# date: Fri Nov 21 13:17:09 AST 2008
# Time-stamp: <2009-03-09 11:50:54 (mintoc)>
use strict;
use warnings;
use DBI;
use LaTeX::Table;
use File::chdir;
use File::Basename;

die "Need to supply an assessment ID\n" if @ARGV <1;
my $assessid=$ARGV[0];
print "Processing assessment: $assessid \n";
# open a connection to the database
my $dbh = DBI->connect("dbi:Pg:dbname=srdb;host=localhost;port=5432;" ,
                      "srdbuser", "srd6us3r!")
		      || die "Database connection not made: $DBI::errstr";

#----------------------------------------------------
# General details tables
#----------------------------------------------------
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ title ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
my $titlesql = qq{select ar.areaname, st.commonname, assess.recorder, assess.dateloaded, st.scientificname,ar.areaID from srdb.assessment as assess, srdb.area as ar, srdb.stock as st where assessid=\'$assessid\' and st.stockid=assess.stockid and ar.areaID=st.areaID};
my $titlehandle = $dbh -> prepare($titlesql);
$titlehandle -> execute();
my @titleresult = $titlehandle->fetchrow_array();
$titlehandle->finish();
my $area=$titleresult[0];
my $sp=lc $titleresult[1];
my $recorder=$titleresult[2];
my $datein=$titleresult[3];
my $sciname=$titleresult[4];
my $areaid=$titleresult[5];
# create an assessment-specific tex file
#my $temptex="/home/srdbadmin/SQLpg/srDB/tex/srDB-QAQC-template.tex";
#my $outtex="/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . ".tex";

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ assessment authors ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
my $authorsql = qq{select risentry from srdb.referencedoc where assessid=\'$assessid\' and risfield='A1'};
my $authorhandle = $dbh -> prepare($authorsql);
$authorhandle -> execute();
my @authorresult = $authorhandle->fetchrow_array();
$authorhandle->finish();
my $authors=join(",",@authorresult);
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ assessment publication year ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
my $pubyearsql = qq{select risentry from srdb.referencedoc where assessid=\'$assessid\' and risfield='Y1'};
my $pubyearhandle = $dbh -> prepare($pubyearsql);
$pubyearhandle -> execute();
my @pubyearresult = $pubyearhandle->fetchrow_array();
$pubyearhandle->finish();
my $pubyear=$pubyearresult[0];

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ first table: assess. details  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

my $tab1sql = qq{select mgmt, assessorfull, assessyear, pdffile, methodlong from srdb.assessment as a, srdb.assessmethod, srdb.assessor as b where  assessmethod=methodshort and a.assessorid=b.assessorid and assessid=\'$assessid\'};
my $tab1handle = $dbh -> prepare($tab1sql);
$tab1handle -> execute();
my @tab1result = $tab1handle->fetchrow_array();
$tab1handle->finish();
# replace the charatcers that latex finds difficult
# set up a hash of change strings
my %change = ( '_' => '\\_', '&' => '\\&', '%' => '\\%' );
my $list_item;
for $list_item(@tab1result)
{
  # loop through the changes hash
  for(keys %change)
  { $list_item =~ s/$_/$change{$_}/gs }
}

my $mgmt=$tab1result[0];
my $assessorfull=$tab1result[1];
my $assessyear=$tab1result[2];
my $pdffile=$tab1result[3];
# check if pdf is present

my $pdffilename = basename($pdffile);
my $pdfcheck;
if (-e "/home/srdbadmin/SQLpg/srDB/pdf/$pdffilename") {
#print "pdf file exists!";
$pdfcheck ="(pdf in database)";
}else {
#print "pdf file does not exist.";
$pdfcheck ="(pdf not in database)";
}
print "$pdfcheck\n";
my $methodlong=$tab1result[4];

## N.B. all replacements to the template are done at the end of this file
## make the latex tables
## latex first table 
  my $header = [[ 'Detail', 'Value']];
  
  my $data = [
      [ 'Management body',  "$mgmt" ],
      [ 'Assessment group', "$assessorfull" ],
      [ 'Assessment authors',           "$authors" ],
      [ 'Assessment method',           "$methodlong" ],
      [ 'Publication year',            "$pubyear" ], # need to find this field
      [ 'Timeseries span',            "$assessyear" ],
      [ 'Document',         "$pdffilename $pdfcheck" ],
      [ 'Recorder',         "$recorder"],
      [ 'Date entered',     "$datein"],
     ];
  my $assesstabfile= "/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . "assestab.tex";
# print "$assesstabfile \n";
$CWD = "/home/srdbadmin/SQLpg/srDB/tex";
  my $table1 = LaTeX::Table->new(
        {   
        filename    => "$assesstabfile",
        maincaption => '',
	caption_top => 1,
        caption     => '',
        label       => 'tab:assessdet',
	center        => 1,
	position    => 'htb',
        header      => $header,
        data        => $data,
	set_width   =>'\textwidth',
        }
  );
  $table1->set_coldef_strategy({
    LONG_COL => 'p{7cm}', # set the column width 
  });
  # write LaTeX code in $assesstabfile
  $table1->generate();

#----------------------------------------------------
# Life history details -now requisite values
#----------------------------------------------------
my $lhsql = qq{select * from (select bioid, biovalue, biounitsshort from srdb.bioparams b, srdb.biometrics c where assessid like \'$assessid\' and b.bioid=c.biounique) as a where a.bioid in ('REC-AGE-yr', 'SSB-AGE-yr', 'TB-AGE-yr', 'F-AGE', 'M-1/T', 'M-1/yr', 'NATMORT-1/yr', 'A50-yr', 'L50-cm', 'MORATOR-yr-yr')};
my $lhhandle = $dbh -> prepare($lhsql);
$lhhandle -> execute();

my @lharray;

while (my @lhrow = $lhhandle->fetchrow_array) {  # retrieve one row
      push(@lharray, [@lhrow]);
    }
# see if all the values are present
# need to get the B reference points if they exists
my @lharray2; # another array that doesn't use the latex-required array format so that we can search through it
    for my $aref ( @lharray ) {
      push(@lharray2,@$aref );
      print "@$aref,\n";
    };
# recruitment age
if (!grep /REC-AGE*/, @lharray2)
{
      push(@lharray, ["REC-AGE","",""]);
};
# ssb age
if (!grep /SSB-AGE*/, @lharray2)
{
      push(@lharray, ["SSB-AGE-yr","",""]);
};
# tb age
if (!grep /TB-AGE*/, @lharray2)
{
      push(@lharray, ["TB-AGE-yr","",""]);
};
# f age
if (!grep /F-AGE*/, @lharray2)
{
      push(@lharray, ["F-AGE-yr","",""]);
};
# natural mortality
if ((!grep /M-*/, @lharray2 && !grep /NATMORT-*/, @lharray2))
{
      push(@lharray, ["M","",""]);
};
# a50
if (!grep /A50*/, @lharray2)
{
      push(@lharray, ["A50-yr","",""]);
};
if (!grep /L50-*/, @lharray2)
{
      push(@lharray, ["L50-cm","",""]);
};
if (!grep /MORATOR-yr-yr*/, @lharray2)
{
      push(@lharray, ["MORATOR-yr-yr","",""]);
};

# LME
push(@lharray, ["LME","",""]);

#  my $lhheader = [["Life history:3c"],["Parameter", "Value", "Units"]];
  my $lhheader = [["Parameter", "Value", "Units"]];

  my $templhfile= "/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . "templhtab.tex";
  my $lhtable = LaTeX::Table->new(
	{
        filename    => "$templhfile",
        maincaption => '',
	caption_top => 1,
        caption     => '',
        label       => '',
	center      => 1,
	position    => 'htb',
        header      => $lhheader,
        data        => [@lharray],
	set_width   =>'\textwidth',
        coldef     => 'lll',
#        coldef     => "$coldef",
        }
  );

  $lhtable->set_coldef_strategy({
    LONG_COL => 'p{7cm}', # set the column width 
  });
  # write LaTeX code in $assesstabfile
  $lhtable->generate();

# replace the table definitions from the perl latex output

my $lhfile    = "/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . "lhtab.tex";

##~~~~~~~~~~~~~~~~ replacements ~~~~~~~~~~~~~~~~~~~~~~

## Open the file
open (IN, "$templhfile") || die $!;
## print the modified contents to out file
open (OUT, ">$lhfile") || die $!;
while ($_ = <IN> ) {
## If text exists, replace text
# area

if ($_ =~ /\\begin{table}\[htb\]|\\end{table}|\\centering/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/\\begin{table}\[htb\]|\\end{table}|\\centering//g;
       $_ =~ s/^\s*[\r\n]+//g; # replaces the blank lines
     }
if ($_ =~ /\\begin{table}\[htb\]|\\end{table}|\\centering/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/\\begin{table}\[htb\]|\\end{table}|\\centering//g;
       $_ =~ s/^\s*[\r\n]+//g; # replaces the blank lines
     }
if ($_ =~ /%/) { # change the percentage signs for latex
       $_ =~ s/\%/\\%/g
     }

     print OUT "$_";
}
close(IN);
close(OUT);

#----------------------------------------------------
# Reference points table
#----------------------------------------------------

#my $refsql = qq{select b.biolong, a.biovalue, b.biounitsshort from srdb.bioparams a, srdb.biometrics b where a.assessid like \'$assessid\' and b.biounique=a.bioid and b.subcategory='REFERENCE POINTS ETC.'};
my $refsql = qq{select b.biounique, a.biovalue, b.biounitsshort from srdb.bioparams a, srdb.biometrics b where a.assessid like \'$assessid\' and b.biounique=a.bioid and b.subcategory='REFERENCE POINTS ETC.'};
my $refhandle = $dbh -> prepare($refsql);
$refhandle -> execute();

my @refarray;

while (my @refrow = $refhandle->fetchrow_array) {  # retrieve one row
      push(@refarray, [@refrow]);
    }
#-----------------------
# ratios
#-----------------------
# need to get the B reference points if they exists
my @refarray2; # another array that doesn't use the latex-required array format so that we can search through it
    for my $aref ( @refarray ) {
      push(@refarray2,@$aref );
      #  print "@$aref,\n";
    }
#my $test=grep(/Blim-[A-Z]*/, @refarray2);
#print "value of $test\n";
#-----
# Blim
#-----
my($Blim, $Flim, $Bmsy, $Fmsy);
$Blim=""; $Flim=""; $Bmsy=""; $Fmsy="";
if (grep /Blim-[A-Z]*/, @refarray2)
{
# find out the index
my ( $index )= grep { $refarray2[$_] =~ /Blim-[A-Z]*/ } 0..$#refarray2;
      print "Blim present\n";
      $Blim="$refarray2[$index+1]\n";
};

#-----
# Flim
#-----
if (grep /Flim-[A-Z]*/, @refarray2)
{
# find out the index
my ( $index )= grep { $refarray2[$_] =~ /Flim-[A-Z]*/ } 0..$#refarray2;
      print "Flim present\n";
      $Flim="$refarray2[$index+1]\n";
};
#-----
# Bmsy
#-----
if (grep /Bmsy-[A-Z]*/, @refarray2)
{
# find out the index
my ( $index )= grep { $refarray2[$_] =~ /Bmsy-[A-Z]*/ } 0..$#refarray2;
      print "Bmsy present\n";
      $Bmsy="$refarray2[$index+1]\n";
};
#-----
# Fmsy
#-----
if (grep /Fmsy-[A-Z]*/, @refarray2)
{
# find out the index
my ( $index )= grep { $refarray2[$_] =~ /Fmsy-[A-Z]*/ } 0..$#refarray2;
      print "Fmsy present\n";
      $Fmsy="$refarray2[$index+1]\n";
};
#-----------------------
# current values
#-----------------------
# current ssb
my $ssbcurrsql = qq{select ssb from srdb.timeseries_values_view where tsyear=(select max(tsyear) as maxyear from srdb.timeseries_values_view where assessid like \'$assessid\') and assessid like \'$assessid\'};
my $ssbcurrhandle = $dbh -> prepare($ssbcurrsql);
$ssbcurrhandle -> execute();
my @ssbcurrresult = $ssbcurrhandle->fetchrow_array();
$ssbcurrhandle->finish();
my $ssbcurr=$ssbcurrresult[0];
print "$ssbcurr \n";
print "$ssbcurr\n $Blim \n";
# current tb -----------
my $tbcurrsql = qq{select total from srdb.timeseries_values_view where tsyear=(select max(tsyear) as maxyear from srdb.timeseries_values_view where assessid like \'$assessid\') and assessid like \'$assessid\'};
my $tbcurrhandle = $dbh -> prepare($tbcurrsql);
$tbcurrhandle -> execute();
my @tbcurrresult = $tbcurrhandle->fetchrow_array();
$tbcurrhandle->finish();
my $tbcurr=$tbcurrresult[0];
# current f ------------
my $fcurrsql = qq{select f from srdb.timeseries_values_view where tsyear=(select max(tsyear) as maxyear from srdb.timeseries_values_view where assessid like \'$assessid\') and assessid like \'$assessid\'};
my $fcurrhandle = $dbh -> prepare($fcurrsql);
$fcurrhandle -> execute();
my @fcurrresult = $fcurrhandle->fetchrow_array();
$fcurrhandle->finish();
my $fcurr=$fcurrresult[0];
# current year------------
my $yrcurrsql = qq{select max(tsyear) as maxyear from srdb.timeseries_values_view where assessid like \'$assessid\'};
my $yrcurrhandle = $dbh -> prepare($yrcurrsql);
$yrcurrhandle -> execute();
my @yrcurrresult = $yrcurrhandle->fetchrow_array();
$yrcurrhandle->finish();
my $yrcurr=$yrcurrresult[0];

#---------------
# add the ratios
#---------------
# Blim
if(!$Blim eq "" && !$ssbcurr eq ""){
my @ratio1=("\$SSB_{$yrcurr}/B_{lim}\$",sprintf("%.3f", $ssbcurr/$Blim),"");
push(@refarray,[@ratio1])}
# Flim
if(!$Flim eq "" && !$fcurr eq ""){
my @ratio2=("\$F_{$yrcurr}/F_{lim}\$",sprintf("%.3f", $fcurr/$Flim),"");
push(@refarray,[@ratio2])}
# Bmsy
if(!$Bmsy eq "" && !$tbcurr eq ""){
my @ratio3=("\$TB_{$yrcurr}/B_{msy}\$",sprintf("%.3f", $tbcurr/$Bmsy),"");
push(@refarray,[@ratio3])}
# Fmsy
if(!$Fmsy eq "" && !$fcurr eq ""){
my @ratio4=("\$F_{$yrcurr}/F_{msy}\$",sprintf("%.3f", $fcurr/$Fmsy),"");
push(@refarray,[@ratio4])}

  my $refheader = [["Reference points:3c"],["Parameter", "Value", "Units"]];
  my $tempreffile= "/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . "tempreftab.tex";
  my $reftable = LaTeX::Table->new(
	{
        filename    => "$tempreffile",
        maincaption => '',
	caption_top => 1,
        caption     => '',
        label       => '',
	center      => 1,
	position    => 'htb',
        header      => $refheader,
        data        => [@refarray],
	set_width   =>'\textwidth',
        coldef     => 'lll',
#        coldef     => "$coldef",
        }
  );

  $reftable->set_coldef_strategy({
    LONG_COL => 'p{7cm}', # set the column width 
  });
  # write LaTeX code in $assesstabfile
  $reftable->generate();

# replace the table definitions from the perl latex output

my $reffile    = "/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . "reftab.tex";

##~~~~~~~~~~~~~~~~ replacements ~~~~~~~~~~~~~~~~~~~~~~
# write the assumed timeseries that accompanies the reference point
my %refchange = (
 'Bbuf-MT'	 =>	 'Bbuf-MT (SSB)',
 'BH-h-dimensionless'	 =>	 'BH-h-dimensionless',
 'BH-h-R units per SSB units'	 =>	 'BH-h-R units per SSB units',
 'Blim-E00eggs'	 =>	 'Blim-E00eggs',
 'Blim-E09eggs'	 =>	 'Blim-E09eggs',
 'Blim-FemaleGonadMT'	 =>	 'Blim-FemaleGonadMT',
 'Blim-MT'	 =>	 'Blim-MT (SSB)',
 'Bmsy-MT'	 =>	 'Bmsy-MT (TB)',
 'Bpa-MT'	 =>	 'Bpa-MT (SSB)',
 'Brebuild-MT'	 =>	 'Brebuild-MT (SSB)',
 'F0.1-1/yr'	 =>	 'F0.1-1/yr (F)',
 'F35%-1/T'	 =>	 'F35%-1/T (F)',
 'F40%-1/T'	 =>	 'F40%-1/T (F)',
 'Fcurrent-1/T'	 =>	 'Fcurrent-1/T (F)',
 'Fext-1/yr'	 =>	 'Fext-1/yr (F)',
 'Flim-1/T'	 =>	 'Flim-1/T (F)',
 'Flim-1/yr'	 =>	 'Flim-1/yr (F)',
 'Fmax-1/yr'	 =>	 'Fmax-1/yr (F)',
 'Fmsy-1/T'	 =>	 'Fmsy-1/T (F)',
 'Fmsy-1/yr'	 =>	 'Fmsy-1/yr (F)',
 'Fpa-1/T'	 =>	 'Fpa-1/T (F)',
 'Fpa-1/yr'	 =>	 'Fpa-1/yr (F)',
 'Frebuild-1/T'	 =>	 'Frebuild-1/T (F)',
 'Fref-1/T'	 =>	 'Fref-1/T (F)',
 'Ftarget-1/yr'	 =>	 'Ftarget-1/yr (F)',
 'MORATOR-yr-yr'	 =>	 'MORATOR-yr-yr',
 'MSY-MT'	 =>	 'MSY-MT (TB)',
 'NATMORT-1/yr'	 =>	 'NATMORT-1/yr (M)',
 'R0-E03'	 =>	 'R0-E03 (R )',
 'R0-E06'	 =>	 'R0-E06 (R )',
 'R0-E09'	 =>	 'R0-E09 (R )',
 'SPRF0-E01'	 =>	 'SPRF0-E01 (SPR)',
 'SPRtarget-ratio'	 =>	 'SPRtarget-ratio (SPR)',
 'SSB0-E06eggs'	 =>	 'SSB0-E06eggs (SSB)',
 'SSB0-E06larvae'	 =>	 'SSB0-E06larvae (SSB)',
 'SSB0-E08eggs'	 =>	 'SSB0-E08eggs (SSB)',
 'SSB0-E09eggs'	 =>	 'SSB0-E09eggs (SSB)',
 'SSB0-MT'	 =>	 'SSB0-MT (SSB)',
 'SSBexceptional-MT'	 =>	 'SSBexceptional-MT (SSB)',
 'SSBmin-ratio'	 =>	 'SSBmin-ratio (SSB)',
 'SSBmsy-E06eggs'	 =>	 'SSBmsy-E06eggs (SSB)',
 'SSBmsy-E06larvae'	 =>	 'SSBmsy-E06larvae (SSB)',
 'SSBmsy-E08eggs'	 =>	 'SSBmsy-E08eggs (SSB)',
 'SSBmsy-E09eggs'	 =>	 'SSBmsy-E09eggs (SSB)',
 'SSBmsy-MT'	 =>	 'SSBmsy-MT (SSB)',
 'SSBtarget-E06eggs'	 =>	 'SSBtarget-E06eggs (SSB)',
 'SSBtarget-E06larvae'	 =>	 'SSBtarget-E06larvae (SSB)',
 'SSBtarget-E08eggs'	 =>	 'SSBtarget-E08eggs (SSB)',
 'SSBtarget-E09eggs'	 =>	 'SSBtarget-E09eggs (SSB)',
 'SSBtarget-MT'	 =>	 'SSBtarget-MT (SSB)',
 'Umsy-ratio'	 =>	 'Umsy-ratio (U)'
); 
## Open the file
open (IN, "$tempreffile") || die $!;
## print the modified contents to out file
open (OUT, ">$reffile") || die $!;
while ($_ = <IN> ) {
## If text exists, replace text
# area

if ($_ =~ /\\begin{table}\[htb\]|\\end{table}|\\centering/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/\\begin{table}\[htb\]|\\end{table}|\\centering//g;
       $_ =~ s/^\s*[\r\n]+//g; # replaces the blank lines
       $_ =~ s/%/\%/g; 
     }
if ($_ =~ /%/) { # change the percentage signs for latex
       $_ =~ s/\%/\\%/g
     }

  # loop through the ref. pt timeseries to be included
while ((my $key, my $value) = each(%refchange)){
#     print $key.", ".$value."<br />";
if ($_ =~ /$key/) { # change the percentage signs for latex
#     print "$value\n";
     $_ =~ s/$key/$value/gs; # note the gs substitution
     }
}

     print OUT "$_";
}
close(IN);
close(OUT);

#------------------------------------------
# Post-entry additions table
#------------------------------------------
## timeseries
#my $tab2sql = qq{select distinct tsshort from srdb.tsmetrics, srdb.timeseries where tsid=tsunique and assessid=\'$assessid\'};
#my $tab2handle = $dbh -> prepare($tab2sql);
#$tab2handle -> execute();
#my @row;
#my @tab2result;
#my $entrystring;
#while (@row = $tab2handle->fetchrow_array) {  # retrieve one row
#      $entrystring= "@row";
#      #print $entrystring;
#      push(@tab2result, $entrystring);
#    }
#$tab2handle->finish();
# print "@tab2result \n";
#my $timeseries=join(", ",@tab2result);

  my $header3 = [['Parameter', 'value']];

  my $data3 = [
      [ "LME", "" ],
      [ "Surplus production \$F_{msy}\$", "" ],
      [ "Surplus production \$B_{msy}\$", "" ],
     ];
  my $postentryfile= "/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . "postentrytab.tex";
  my $table3 = LaTeX::Table->new(
	{
        filename    => "$postentryfile",
        maincaption => '',
	caption_top => 1,
        caption     => '',
        label       => 'tab:posttab',
	center        => 1,
	position    => 'htb',
        header      => $header3,
        data        => $data3,
	set_width   =>'\textwidth',
        coldef      => 'lp{7cm}',
        }
  );

  $table3->set_coldef_strategy({
    LONG_COL => 'p{7cm}', # set the column width 
  });
  # write LaTeX code in $assesstabfile
#  $table3->generate();



#------------------------------------------
# Timeseries table
#------------------------------------------
## timeseries
my $tab2sql = qq{select distinct tsshort from srdb.tsmetrics, srdb.timeseries where tsid=tsunique and assessid=\'$assessid\'};
my $tab2handle = $dbh -> prepare($tab2sql);
$tab2handle -> execute();
my @row;
my @tab2result;
my $entrystring;
while (@row = $tab2handle->fetchrow_array) {  # retrieve one row
      $entrystring= "@row";
      #print $entrystring;
      push(@tab2result, $entrystring);
    }
$tab2handle->finish();
# print "@tab2result \n";
#my $timeseries=join(", ",@tab2result);

#-----------------------------------------------------
# max and min year (used to check if offset correctly)
#-----------------------------------------------------
# ssb
my $ssbyrminmaxsql = qq{select min(tsyear),max(tsyear) from srdb.timeseries_values_view where assessid like \'$assessid\' and (ssb is not null)};
my $ssbyrminmaxhandle = $dbh -> prepare($ssbyrminmaxsql);
$ssbyrminmaxhandle -> execute();
my @ssbyrminmaxresult = $ssbyrminmaxhandle->fetchrow_array();
$ssbyrminmaxhandle->finish();
my $ssbyrmin=$ssbyrminmaxresult[0];
my $ssbyrmax=$ssbyrminmaxresult[1];
# r
my $ryrminmaxsql = qq{select min(tsyear),max(tsyear) from srdb.timeseries_values_view where assessid like \'$assessid\' and (r is not null)};
my $ryrminmaxhandle = $dbh -> prepare($ryrminmaxsql);
$ryrminmaxhandle -> execute();
my @ryrminmaxresult = $ryrminmaxhandle->fetchrow_array();
$ryrminmaxhandle->finish();
my $ryrmin=$ryrminmaxresult[0];
my $ryrmax=$ryrminmaxresult[1];
# tb
my $tbyrminmaxsql = qq{select min(tsyear),max(tsyear) from srdb.timeseries_values_view where assessid like \'$assessid\' and (total is not null)};
my $tbyrminmaxhandle = $dbh -> prepare($tbyrminmaxsql);
$tbyrminmaxhandle -> execute();
my @tbyrminmaxresult = $tbyrminmaxhandle->fetchrow_array();
$tbyrminmaxhandle->finish();
my $tbyrmin=$tbyrminmaxresult[0];
my $tbyrmax=$tbyrminmaxresult[1];
# f
my $fyrminmaxsql = qq{select min(tsyear),max(tsyear) from srdb.timeseries_values_view where assessid like \'$assessid\' and (f is not null)};
my $fyrminmaxhandle = $dbh -> prepare($fyrminmaxsql);
$fyrminmaxhandle -> execute();
my @fyrminmaxresult = $fyrminmaxhandle->fetchrow_array();
$fyrminmaxhandle->finish();
my $fyrmin=$fyrminmaxresult[0];
my $fyrmax=$fyrminmaxresult[1];
# catch
my $catchyrminmaxsql = qq{select min(tsyear),max(tsyear) from srdb.timeseries_values_view where assessid like \'$assessid\' and (catch_landings is not null)};
my $catchyrminmaxhandle = $dbh -> prepare($catchyrminmaxsql);
$catchyrminmaxhandle -> execute();
my @catchyrminmaxresult = $catchyrminmaxhandle->fetchrow_array();
$catchyrminmaxhandle->finish();
my $catchyrmin=$catchyrminmaxresult[0];
my $catchyrmax=$catchyrminmaxresult[1];

# -----------------------
# historical min and max
# -----------------------
# ssb
my $ssbminmaxsql = qq{select min(ssb),max(ssb) from srdb.timeseries_values_view where assessid like \'$assessid\'};
my $ssbminmaxhandle = $dbh -> prepare($ssbminmaxsql);
$ssbminmaxhandle -> execute();
my @ssbminmaxresult = $ssbminmaxhandle->fetchrow_array();
$ssbminmaxhandle->finish();
my $ssbmin=$ssbminmaxresult[0];
my $ssbmax=$ssbminmaxresult[1];
# tb
my $tbminmaxsql = qq{select min(total),max(total) from srdb.timeseries_values_view where assessid like \'$assessid\'};
my $tbminmaxhandle = $dbh -> prepare($tbminmaxsql);
$tbminmaxhandle -> execute();
my @tbminmaxresult = $tbminmaxhandle->fetchrow_array();
$tbminmaxhandle->finish();
my $tbmin=$tbminmaxresult[0];
my $tbmax=$tbminmaxresult[1];
# r
my $rminmaxsql = qq{select min(r),max(r) from srdb.timeseries_values_view where assessid like \'$assessid\'};
my $rminmaxhandle = $dbh -> prepare($rminmaxsql);
$rminmaxhandle -> execute();
my @rminmaxresult = $rminmaxhandle->fetchrow_array();
$rminmaxhandle->finish();
my $rmin=$rminmaxresult[0];
my $rmax=$rminmaxresult[1];
# catch
my $catchminmaxsql = qq{select min(catch_landings),max(catch_landings) from srdb.timeseries_values_view where assessid like \'$assessid\'};
my $catchminmaxhandle = $dbh -> prepare($catchminmaxsql);
$catchminmaxhandle -> execute();
my @catchminmaxresult = $catchminmaxhandle->fetchrow_array();
$catchminmaxhandle->finish();
my $catchmin=$catchminmaxresult[0];
my $catchmax=$catchminmaxresult[1];
# f
my $fminmaxsql = qq{select min(f),max(f) from srdb.timeseries_values_view where assessid like \'$assessid\'};
my $fminmaxhandle = $dbh -> prepare($fminmaxsql);
$fminmaxhandle -> execute();
my @fminmaxresult = $fminmaxhandle->fetchrow_array();
$fminmaxhandle->finish();
my $fmin=$fminmaxresult[0];
my $fmax=$fminmaxresult[1];
#---------------
# get the units
#---------------

my $unitsminmaxsql = qq{select * from srdb.timeseries_units_view where assessid like \'$assessid\'};
my $unitsminmaxhandle = $dbh -> prepare($unitsminmaxsql);
$unitsminmaxhandle -> execute();
my @unitsminmaxresult = $unitsminmaxhandle->fetchrow_array();
$unitsminmaxhandle->finish();
my $ssbunit=$unitsminmaxresult[2];my $runit=$unitsminmaxresult[3];my $tbunit=$unitsminmaxresult[4];my $funit=$unitsminmaxresult[5];my $catchunit=$unitsminmaxresult[7];

#my @timeseries =("SSB","TB", "R", "F","Catch");
my $header2 = [['Time series minima and maxima:6c']];

  my $data2 = [
      ["","SSB", "R", "F","TB", "Catch"],
      ["Minimum year", "$ssbyrmin","$ryrmin","$fyrmin","$tbyrmin", "$catchyrmin"],
      ["Maximum year", "$ssbyrmax","$ryrmax","$fyrmax","$tbyrmax", "$catchyrmax"],
      ["Time series minimum", "$ssbmin","$rmin","$fmin","$tbmin", "$catchmin"],
      ["Time series maximum", "$ssbmax","$rmax","$fmax","$tbmax", "$catchmax"],
      ["Units", "$ssbunit", "$runit", "$funit", "$tbunit", "$catchunit"],
     ];
  my $timetabfile= "/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . "timetab.tex";
  my $table2 = LaTeX::Table->new(
	{
        filename    => "$timetabfile",
        maincaption => '',
	caption_top => 1,
        caption     => '',
        label       => 'tab:timetab',
	center        => 1,
	position    => 'htb',
        header      => $header2,
        data        => $data2,
	set_width   =>'\textwidth',
        coldef      => 'llllll',
        }
  );

  $table2->set_coldef_strategy({
    LONG_COL => 'p{7cm}', # set the column width 
  });
  # write LaTeX code in $assesstabfile
  $table2->generate();

#------------------------------------------
# R plot
#------------------------------------------
##~~~~~~~~~~~~~~~~ R file~~~~~~~~~~~~~~~~~~~~~~~~
# replaces the 
# create an assessment-specific R file
my $tempR="/home/srdbadmin/SQLpg/srDB/R/functions/srDB-QAQC-template.R";
my $outR="/home/srdbadmin/SQLpg/srDB/R/functions/" . $assessid . ".R";
print "$outR \n";
##~~~~~~~~~~~~~~~~ replacements ~~~~~~~~~~~~~~~~~~~~~~

## Open the file
open (IN, "$tempR") || die $!;
## print the modified contents to out file
open (OUT, ">$outR") || die $!;
while ($_ = <IN> ) {
## If text exists, replace text
# area

if ($_ =~ /ASSESSID/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/ASSESSID/$assessid/g;
     }
     print OUT "$_";
}
close(IN);
close(OUT);

#print "R --slave < $outR > /home/srdbadmin/SQLpg/srDB/R/functions/r.log";
system("R --slave < $outR > /home/srdbadmin/SQLpg/srDB/R/functions/r.log");
my $summaryplot="/home/srdbadmin/SQLpg/srDB/tex/figures/plot-". $assessid . ".pdf";
#print "$summaryplot /n";


#------------------------------------------
# LaTeX file replacements
#------------------------------------------
# create an assessment-specific tex file
my $temptex="/home/srdbadmin/SQLpg/srDB/tex/srDB-QAQC-template.tex";
my $outtex="/home/srdbadmin/SQLpg/srDB/tex/" . $assessid . ".tex";

## Open the file
open (IN, "$temptex") || die $!;
## print the modified contents to out file
#open (OUT, ">$outtex") || die $!;
open (OUT, ">$outtex") || die $!;
while ($_ = <IN> ) {
## If text exists, replace text
# area
if ($_ =~ /AREAID/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/AREAID/$areaid/g;
     }
if ($_ =~ /AREA/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/AREA/$area/g;
     }
# species
if ($_ =~ /SPECIES/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/SPECIES/$sp/g;
     }
# latiname
if ($_ =~ /LATINNAME/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/LATINNAME/$sciname/g;
     }
if ($_ =~ /ASSESSMENTID/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/ASSESSMENTID/$assessid/g;
     }
# recorder
#if ($_ =~ /RECORDER/) {
#       # Replace text, all instances on a line (/g)
#       $_ =~ s/RECORDER/$recorder/g;
#     }
#if ($_ =~ /DATEIN/) {
#       # Replace text, all instances on a line (/g)
#       $_ =~ s/DATEIN/$datein/g;
#     }
if ($_ =~ /ASSESSTABLE/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/ASSESSTABLE/$assesstabfile/g;
     }
if ($_ =~ /LHTABLE/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/LHTABLE/$lhfile/g;
     }
if ($_ =~ /REFTABLE/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/REFTABLE/$reffile/g;
     }
if ($_ =~ /TIMESERIESTABLE/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/TIMESERIESTABLE/$timetabfile/g;
     }
if ($_ =~ /POSTENTRYTAB/) {
       # Replace text, all instances on a line (/g)
       $_ =~ s/POSTENTRYTAB/$postentryfile/g;
     }

if ($_ =~ /SUMMARYPLOT/) {
       # this is for the plot which is generated from the R code
       $_ =~ s/SUMMARYPLOT/$summaryplot/g;
     }
     print OUT "$_";
  }
close(IN);
close(OUT);



$dbh->disconnect();
