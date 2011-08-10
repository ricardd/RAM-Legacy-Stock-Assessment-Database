# makefile for Fish and Fisheries manuscript
# last modified Time-stamp: <2011-08-09 23:43:43 (srdbadmin)>
# this is after the paper was accepted, I am just generating a document to compare the numbers in teh database to those that appear in the proof

all: fandf-ACCEPTED-AUG2011-results.pdf fandf-ACCEPTED-AUG2011-figures.pdf fandf-ACCEPTED-AUG2011-supporting-tables.pdf fandf-ACCEPTED-AUG2011-supporting-figures.pdf

## PDF with results
fandf-ACCEPTED-AUG2011-results.pdf: fandf-ACCEPTED-AUG2011-results.tex abstract-dynamic.tex results-dynamic.tex Table1-formatted.tex ../../SQL/queries-for-results.log
	pdflatex fandf-ACCEPTED-AUG2011-results

fandf-ACCEPTED-AUG2011-results.tex: lastDB-update.txt

results-dynamic.tex: lastDB-update.txt ../../SQL/queries-for-results.log ../../R/PROOFS-final/orca-plot.pdf ../../R/PROOFS-final/three-panel-phylo.pdf ../../R/PROOFS-final/friedegg-8plots-fandf.pdf ../../R/PROOFS-final/friedegg-taxo.pdf ../../R/PROOFS-final/friedegg-MTLs.pdf ../../R/Schaefer-correlations-Kbounds-comparison.pdf ../../R/PROOFS-final/friedegg-ICES-SSBlim.pdf
	./results-dynamic.pl

abstract-dynamic.tex: lastDB-update.txt ../../SQL/queries-for-results.log ../../R/PROOFS-final/orca-plot.pdf ../../R/PROOFS-final/three-panel-phylo.pdf ../../R/PROOFS-final/friedegg-8plots-fandf.pdf ../../R/PROOFS-final/friedegg-taxo.pdf ../../R/PROOFS-final/friedegg-MTLs.pdf ../../R/Schaefer-correlations-Kbounds-comparison.pdf
	./abstract-dynamic.pl 

Table1-formatted.tex: lastDB-update.txt 
	R CMD BATCH ../../R/PROOFS-final/generate-Table1.R
	sed '/label{tab/ r mytable1head.txt' Table1.tex | sed '/begin{tabular/ r mytable1.txt' | sed 10,12d | sed '/end{tabular}/ r mytable1foot.txt' > Table1-formatted.tex

## PDF with figures
fandf-ACCEPTED-AUG2011-figures.pdf: fandf-ACCEPTED-AUG2011-figures.tex ../../GMT/stocks-byLME.pdf ../../R/PROOFS-final/orca-plot.pdf ../../R/PROOFS-final/three-panel-phylo.pdf ../../R/PROOFS-final/friedegg-8plots-fandf.pdf ../../R/PROOFS-final/friedegg-taxo.pdf ../../R/PROOFS-final/friedegg-MTLs.pdf ../../SQL/queries-for-results.log
	pdflatex fandf-ACCEPTED-AUG2011-figures

fandf-ACCEPTED-AUG2011-figures.tex: lastDB-update.txt

../../GMT/stocks-byLME.pdf: lastDB-update.txt
	../../GMT/stocks-by-LME.bash

../../R/PROOFS-final/orca-plot.pdf: ../../R/PROOFS-final/orca-plot.R lastDB-update.txt   ../../SQL/queries-for-results.log
	R CMD BATCH ../../R/PROOFS-final/orca-plot.R

../../R/PROOFS-final/three-panel-phylo.pdf: ../../R/PROOFS-final/taxo-dendrogram.R lastDB-update.txt  ../../SQL/queries-for-results.log
	R CMD BATCH ../../R/PROOFS-final/taxo-dendrogram.R

../../R/PROOFS-final/friedegg-8plots-fandf.pdf: ../../R/PROOFS-final/fried-eggs.R lastDB-update.txt  ../../SQL/queries-for-results.log
	R CMD BATCH ../../R/PROOFS-final/fried-eggs.R

../../R/PROOFS-final/friedegg-taxo.pdf: ../../R/PROOFS-final/fried-eggs.R lastDB-update.txt  ../../SQL/queries-for-results.log
	R CMD BATCH ../../R/PROOFS-final/fried-eggs.R

../../R/PROOFS-final/friedegg-MTLs.pdf: ../../R/PROOFS-final/MTL-friedegg.R lastDB-update.txt  ../../SQL/queries-for-results.log
	R CMD BATCH ../../R/PROOFS-final/MTL-friedegg.R

## PDF with Supporting Tables
fandf-ACCEPTED-AUG2011-supporting-tables.pdf: fandf-ACCEPTED-AUG2011-supporting-tables.tex Table-S1-formatted.tex Table-S2.tex
	pdflatex fandf-ACCEPTED-AUG2011-supporting-tables

Table-S1-formatted.tex: lastDB-update.txt
	sed '/begin/ r mytableS1.txt' Table-S1.tex | sed 6,8d > Table-S1-formatted.tex

Table-S2.tex: lastDB-update.txt ../../R/PROOFS-final/Schaefer-correlations-FigS1.R 
	R CMD BATCH ../../R/PROOFS-final/Schaefer-correlations-FigS1.R

## PDF with Supporting Figures
fandf-ACCEPTED-AUG2011-supporting-figures.pdf: fandf-ACCEPTED-AUG2011-supporting-figures.tex ../../R/Schaefer-correlations-Kbounds-comparison.pdf ../../R/PROOFS-final/srdb-by-assessment.pdf ../../R/PROOFS-final/friedegg-ICES-SSBlim.pdf
	pdflatex fandf-ACCEPTED-AUG2011-supporting-figures

../../R/Schaefer-correlations-Kbounds-comparison.pdf: ../../R/PROOFS-final/Schaefer-correlations-FigS1.R lastDB-update.txt 
	R CMD BATCH ../../R/PROOFS-final/Schaefer-correlations-FigS1.R

../../R/PROOFS-final/friedegg-ICES-SSBlim.pdf: ../../R/PROOFS-final/ICES-SSBlim-friedegg.R lastDB-update.txt
	R CMD BATCH  ../../R/PROOFS-final/ICES-SSBlim-friedegg.R

../../R/PROOFS-final/srdb-by-assessment.pdf:  ../../R/PROOFS-final/taxo-dendrogram.R lastDB-update.txt
	R CMD BATCH ../../R/PROOFS-final/taxo-dendrogram.R

../../SQL/queries-for-results.log: lastDB-update.txt
	psql srdb -f ../../SQL/queries-for-results.sql 1> ../../SQL/queries-for-results.log
