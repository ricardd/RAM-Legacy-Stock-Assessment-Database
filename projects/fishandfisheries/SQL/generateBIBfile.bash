#!/bin/bash
# bash script to generate a BibTex file of the citation information from srdb.referencedoc
# Time-stamp: <2010-05-27 20:13:05 (srdbadmin)>

rm srdb-references.ris srdb-references.xml srdb-references.bib srdb-citations.tex

# first, create an RIS file from the database contents
psql srdb -t -f produceRISfile.sql |   sed -e 's/^[ \t]*//' > srdb-references.ris

# turn RIS into XML
ris2xml srdb-references.ris > srdb-references.xml
# turn XML into BibTex
xml2bib srdb-references.xml > srdb-references.bib

# generate a list of LaTeX citations
# psql srdb -t -c "select '\\cite{' || a.assessid || '}' from (select distinct assessid from srdb.referencedoc) as a" > srdb-citations.tex

cp srdb-references.bib ../tex/