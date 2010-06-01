## save the results to the database
## CM
## date: Wed Feb 17 14:17:06 AST 2010
## Time-stamp: <Last modified: 21 FEBRUARY 2010  (srdbadmin)>


parameter.vals<-par.estimates.1010[,c("stockid","mcont.slope.before","mcont.slope.after","m.slope.before","m.slope.after", "mss.slope.before", "mss.slope.after")]

parameter.vals[,c("mcont.slope.before","mcont.slope.after","m.slope.before","m.slope.after","mss.slope.before", "mss.slope.after")]<-round(parameter.vals[,c("mcont.slope.before","mcont.slope.after","m.slope.before","m.slope.after","mss.slope.before", "mss.slope.after")],4)

stock.details<-stocklist.1010[,c("stockid","areaname","commonname", "scientificname", "taxocategory")]
stock.details$scientificname<-paste("\\textit{", stock.details$scientificname,"}", sep="")
sql.save.table<-merge(stock.details, parameter.vals, by="stockid")

## produce LaTeX table
column.alignment<-c("l",rep("p{3cm}",2),rep("l",3),rep("c",6))

colnames(sql.save.table) <- c("Stock ID","Area","Common name", "Scientific name","Category","$\\beta_{1,pre-1992}$", "$\\beta_{1,post-1992}$","$\\beta_{2, pre-1992}$","$\\beta_{2,post-1992}$", "Drift pre-1992","Drift post-1992")   

results.xtable<-xtable(sql.save.table, type="latex", align=column.alignment,digits=4)
print(file="/home/srdbadmin/SQLpg/srdb/trunk/projects/baumhutchings/tex/CBD-Supp-table1-table.tex",results.xtable,type="latex",tabular.environment="longtable", floating=FALSE, include.rownames=FALSE, sanitize.text.function = function(x){x}, add.to.row=list(pos=list(0.5), command=c('\\endhead')))

## note that the header we use is just copied and pasted manually from below -multicolumns are difficult with xtable

\begin{longtable}{p{3cm}p{3cm}lllcccccc}
  \hline
  & & & & &\multicolumn{2}{c}{Continuous} & \multicolumn{2}{c}{Discontinuous} & \multicolumn{2}{c}{Drift}\\
  \cline{6-7}
  \cline{8-9}
  \cline{10-11}  
Stock ID & Area & Common name & Scientific name & Category & pre-1992 & post-1992 & pre-1992 & post-1992 & pre-1992 & post-1992 \\
\hline
\endhead
\hline Continued on next page
\endfoot
\hline 
\endlastfoot
