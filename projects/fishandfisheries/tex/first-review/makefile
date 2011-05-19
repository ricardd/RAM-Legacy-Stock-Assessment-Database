# makefile for Fish and Fisheries manuscript
# last modified Time-stamp: <2011-05-19 14:36:38 (srdbadmin)>
# this is after the first submission, a lot of the writing is now handled in Word and this makefile is meant to generate the plots and tables and a "data and results" bundle to be integrated into the main manuscript in Word
#
fandf-RESUBMIT-2011-bundle.pdf: fandf-RESUBMIT2011-bundle.tex fandf-RESUBMIT2011-bundle.bbl abstract-dynamic.tex results-dynamic.tex Figures-RESUBMIT.tex Table1-formatted.tex Table-S1-formatted.tex
	pdflatex fandf-RESUBMIT2011-bundle

fandf-RESUBMIT2011-bundle.bbl: fandf-RESUBMIT2011-bundle.aux
	bibtex fandf-RESUBMIT2011-bundle

abstract-dynamic.tex: fandf-abstract-dynamic.tex lastDB-update.txt ../../R/first-review/friedegg-bymgmt.pdf ../../R/first-review/three-panel-phylo.pdf ../../R/first-review/orca-plot.pdf
	./abstract-dynamic.pl

results-dynamic.tex:  ../../SQL/queries-for-results.log fandf-results-dynamic.tex lastDB-update.txt ../../R/first-review/friedegg-bymgmt.pdf ../../R/first-review/three-panel-phylo.pdf ../../R/first-review/orca-plot.pdf ../../R/first-review/Schaefer-correlations.pdf
	./results-dynamic.pl

Figures-RESUBMIT.tex:  ../../GMT/stocks-byLME.pdf ../../R/first-review/three-panel-phylo.pdf ../../R/first-review/orca-plot.pdf  ../../R/first-review/friedegg-bymgmt.pdf ../../R/first-review/Schaefer-correlations.pdf ../../R/first-review/friedegg-ICES-SSBlim.pdf ../../R/first-review/friedegg-MTLs.pdf

../../GMT/stocks-byLME.pdf: lastDB-update.txt
	../../GMT/stocks-by-LME.bash

../../R/first-review/three-panel-phylo.pdf: ../../R/first-review/taxo-dendrogram.R ../../SQL/queries-for-results.log
	R CMD BATCH ../../R/first-review/taxo-dendrogram.R

../../R/first-review/Schaefer-correlations.pdf:  ../../R/first-review/Schaefer-correlations-FigS1.R ../../SQL/queries-for-results.log
	R CMD BATCH ../../R/first-review/Schaefer-correlations-FigS1.R

../../R/first-review/taxo-dendrogram.R:
	R CMD BATCH ../../R/first-review/taxo-dendrogram.R

../../R/first-review/orca-plot.pdf: ../../R/first-review/orca-plot.R ../../SQL/queries-for-results.log
	R CMD BATCH ../../R/first-review/orca-plot.R

../../R/first-review/orca-plot.R:
	R CMD BATCH ../../R/first-review/orca-plot.R

../../R/first-review/friedegg-bymgmt.pdf: ../../R/first-review/fried-eggs.R ../../SQL/queries-for-results.log
	R CMD BATCH ../../R/first-review/fried-eggs.R

../../R/first-review/friedegg-ICES-SSBlim.pdf: ../../R/first-review/ICES-SSBlim-friedegg.R
	R CMD BATCH ../../R/first-review/ICES-SSBlim-friedegg.R

../../R/first-review/friedegg-MTLs.pdf: ../../R/first-review/MTL-friedegg.R
	R CMD BATCH ../../R/first-review/MTL-friedegg.R

../../R/first-review/fried-eggs.R: 
	R CMD BATCH ../../R/first-review/fried-eggs.R

../../R/first-review/MTL-friedegg.R:
	R CMD BATCH ../../R/first-review/MTL-friedegg.R

../../R/first-review/Schaefer-correlations-FigS1.R:
	R CMD BATCH ../../R/first-review/Schaefer-correlations-FigS1.R


Table1-formatted.tex: lastDB-update.txt
	R CMD BATCH ../../R/first-review/generate-Table1.R
	sed '/begin{tabular/ r mytable1.txt' Table1.tex | sed 9,11d > Table1-formatted.tex

Table-S1-formatted.tex: lastDB-update.txt ../../R/first-review/friedegg-bymgmt.pdf
	sed '/begin/ r mytableS1.txt' Table-S1.tex | sed 6,8d > Table-S1-formatted.tex

../../SQL/queries-for-results.log: lastDB-update.txt
	psql srdb -f ../../SQL/queries-for-results.sql 1> ../../SQL/queries-for-results.log
