# makefile for Fish and Fisheries manuscript
# last modified Time-stamp: <2010-06-14 15:16:07 (srdbadmin)>
#
#

fishandfisheries-v3.pdf: fishandfisheries-v3.tex abstract-dynamic.tex results-dynamic.tex fishandfisheries-v3.bbl Table1-formatted.tex Table-S1-formatted.tex
	pdflatex fishandfisheries-v3
	pdflatex fishandfisheries-v3

fishandfisheries-v3.bbl: fishandfisheries-v3.aux
	bibtex fishandfisheries-v3

abstract-dynamic.tex: fishandfisheries-abstract-dynamic.tex Table-S1-formatted.tex
	../perl/abstract-dynamic.pl # generate the dynamic abstract

results-dynamic.tex: fishandfisheries-results-dynamic.tex Table-S1-formatted.tex
	../perl/results-dynamic.pl # generate the dynamic results

Table1-formatted.tex: ../R/TL-quadrant-srdb.pdf
	R CMD BATCH ../R/generate-Table1.R
	sed '/begin{tabular/ r mytable1.txt' Table1.tex | sed 9,11d > Table1-formatted.tex

Table-S1-formatted.tex: ../R/TL-quadrant-srdb.pdf
	R CMD BATCH ../R/fried-egg-plots.R # generate Figs.5 and 6, the fried egg plots
	sed '/begin/ r mytable.txt' Table-S1.tex | sed 6,8d > Table-S1-formatted.tex

../R/TL-quadrant-srdb.pdf: ../R/trophic-level-plot.R ../R/friedegg-single.pdf
	R CMD BATCH ../R/trophic-level-plot.R # generate Fig.7, the trophic level beanplot

../R/friedegg-single.pdf: ../R/fried-egg-plots.R ../R/orca_plot_v2.pdf
	R CMD BATCH ../R/fried-egg-plots.R # generate Figs.5 and 6, the fried egg plots

../R/orca_plot_v2.pdf:  ../R/orca_plot.R ../R/srdb-by-assessment.pdf #../SQL/queries-for-results.log
	R CMD BATCH ../R/orca_plot.R # generate Fig.4, the orca plot

../R/srdb-by-assessment.pdf: ../R/taxonomic-dendrogram.R ../GMT/stocks-byLME.pdf
	R CMD BATCH ../R/taxonomic-dendrogram.R # generate Figs.2 and 3, the taxonomic dendrograms

../GMT/stocks-byLME.pdf: ../GMT/stocks-by-LME.bash lastDBupdate-timestamp.txt
	../GMT/stocks-by-LME.bash # generate Fig.1, the LME map

fishandfisheries-Suppl.pdf: fishandfisheries-Suppl.tex lastDBupdate-timestamp.txt Table-S1-formatted.tex
	../SQL/generateBIBfile.bash
	pdflatex fishandfisheries-Suppl.tex
	bibtex fishandfisheries-Suppl
	pdflatex fishandfisheries-Suppl.tex
	pdflatex fishandfisheries-Suppl.tex
