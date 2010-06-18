#!/bin/bash
# bash script to generate a BibTex file of the citation information from srdb.referencedoc
# Time-stamp: <2010-06-15 10:31:03 (srdbadmin)>

# echo "The script you are running has basename `basename $0`, dirname `dirname $0`"
# echo "The present working directory is `pwd`"

# DIR=$(cd $(dirname $0); pwd)

cd "`dirname $0`"

rm srdb-references.ris srdb-references.xml srdb-references.bib
rm srdb-references-pdfasID.ris srdb-references-pdfasID.xml srdb-references-pdfasID.bib

# first, create an RIS file from the database contents
psql srdb -t -f produceRISfile.sql |   sed -e 's/^[ \t]*//' > srdb-references.ris
psql srdb -t -f produceRISfile-pdfasID.sql |   sed -e 's/^[ \t]*//' > srdb-references2.ris

# remove "ZZID" from the RIS file
sed '/^ZZID/d' srdb-references2.ris > srdb-references-pdfasID.ris

# turn RIS into XML
ris2xml srdb-references.ris > srdb-references.xml
ris2xml srdb-references-pdfasID.ris > srdb-references-pdfasID.xml


# turn XML into BibTex
xml2bib srdb-references.xml -nl > srdb-references.bib
xml2bib srdb-references-pdfasID.xml -nl > srdb-references-pdfasID.bib

# generate a list of LaTeX citations
# psql srdb -t -c "select '\\cite{' || a.assessid || '}' from (select distinct assessid from srdb.referencedoc) as a" > srdb-citations.tex

#cp srdb-references.bib ../tex/
cp srdb-references-pdfasID.bib ../tex/srdb-references.bib
 