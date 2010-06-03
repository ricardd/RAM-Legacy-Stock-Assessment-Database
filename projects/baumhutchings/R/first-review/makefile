# makefile for CJFAS Short Communication 2010 manuscript
# last modified Time-stamp: <2010-06-03 00:01:04 (srdbadmin)>

CJFAS-shortcomm-bundle.pdf: CJFAS-shortcomm-bundle.tex CJFAS-shortcomm-fig1-1010_withBRP.pdf CJFAS-shortcomm-fig2-BRPratio-1010.pdf CBD-Supp-fig1_v1.pdf CBD-Supp-fig2.pdf Table-S1-formatted.tex
	pdflatex CJFAS-shortcomm-bundle
	pdflatex CJFAS-shortcomm-bundle

stocklist-CJFAS-shortcomm-1010.csv: timestamp.txt
	R CMD BATCH CJFAS-shortcomm-data-1010.R

all-timestamp.csv: stocklist-CJFAS-shortcomm-1010.csv
	R CMD BATCH CJFAS-shortcomm-all-1010.R

BRP-timestamp.csv: all-timestamp.csv CJFAS-shortcomm-fig1-1010-withBRP.R
	R CMD BATCH CJFAS-shortcomm-BRP-1010.R

CJFAS-shortcomm-fig1-1010_withBRP.pdf: BRP-timestamp.csv CJFAS-shortcomm-fig1-1010-withBRP.R 
	R CMD BATCH CJFAS-shortcomm-fig1-1010-withBRP.R

CJFAS-shortcomm-fig2-BRPratio-1010.pdf: BRP-timestamp.csv CJFAS-shortcomm-fig2.R CJFAS-shortcomm-fig2-functions.R
	R CMD BATCH CJFAS-shortcomm-fig2-prep.R
	R CMD BATCH CJFAS-shortcomm-fig2.R

CBD-Supp-fig1_v1.pdf: all-timestamp.csv
	R CMD BATCH CJFAS-shortcomm-all-1010.R

CBD-Supp-fig2.pdf: all-timestamp.csv
	R CMD BATCH CJFAS-shortcomm-all-1010.R

Table-S1-formatted.tex: CJFAS-shortcomm-summaries.R CBD-TableS1.csv mytable.txt
	R CMD BATCH CJFAS-shortcomm-summaries.R
	sed '/begin/ r mytable.txt' Table-S1.tex | sed 8,10d > Table-S1-formatted.tex
