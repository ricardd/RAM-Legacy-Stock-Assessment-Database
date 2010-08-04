# makefile for Fish and Fisheries manuscript
# last modified Time-stamp: <2010-07-15 15:17:53 (srdbadmin)>
#
#

fishandfisheries-finaldraft.pdf: fishandfisheries-finaldraft.tex abstract-dynamic.tex results-dynamic.tex fishandfisheries-finaldraft.bbl Table1-formatted.aux Table-S1-formatted.tex
	pdflatex fishandfisheries-finaldraft
	pdflatex fishandfisheries-finaldraft

abstract-dynamic.tex: fishandfisheries-abstract-dynamic.tex Table-S1-formatted.tex
	../perl/abstract-dynamic.pl # generate the dynamic abstract

results-dynamic.tex: fishandfisheries-results-dynamic.tex Table-S1-formatted.tex
	../perl/results-dynamic.pl # generate the dynamic results

fishandfisheries-finaldraft.bbl:
	bibtex fishandfisheries-finaldraft

Table1-formatted.aux: ../R/TL-quadrant-srdb.pdf Table1-formatted.tex
	R CMD BATCH ../R/generate-Table1.R
#	echo "\begin{tiny}" > Table1-formatted.tex
	sed '/begin{tabular/ r mytable1.txt' Table1.tex | sed 9,11d > temptable.tex
#	cat temptable.tex >> Table1-formatted.tex
#	echo "\end{tiny}" >> Table1-formatted.tex
#	sed '1 i \\\begin{small}' Table1-temp.tex | sed '$ a \\\end{small}' > Table1-formatted.tex

Table-S1-formatted.tex: ../R/TL-quadrant-srdb.pdf
	R CMD BATCH ../R/fried-egg-plots-MIXANDMATCH.R # generate Figs.5 and 6, the fried egg plots
	sed '/begin/ r mytable.txt' Table-S1.tex | sed 6,8d > Table-S1-formatted.tex

../R/TL-quadrant-srdb.pdf: ../R/trophic-level-plot.R ../R/friedegg-single.pdf
	R CMD BATCH ../R/trophic-level-plot.R # generate Fig.7, the trophic level barplot

../R/friedegg-single.pdf: ../R/fried-egg-plots-MIXANDMATCH.R ../R/orca_plot_v2.pdf
	R CMD BATCH ../R/fried-egg-plots-MIXANDMATCH.R # generate Figs.5 and 6, the fried egg plots

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
