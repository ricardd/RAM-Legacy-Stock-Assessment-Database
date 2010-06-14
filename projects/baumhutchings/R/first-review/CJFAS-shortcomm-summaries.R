## write the data and results for the CJFAS Short Comm. paper to a file
## Last modified Time-stamp: <2010-06-14 09:41:00 (srdbadmin)>
##
require(xtable)

summary.nstocks <- dim(par.estimates.1010)[1]
sink(file="CJFAS-summaries.txt")
print("Number of stocks used in the slope analyses")
print(summary.nstocks)
print("Number of species used in the slope analyses")
print(length(unique(dat.1010$scientificname)))
summary.geo <- table(par.estimates.1010$geo)
print("Number of stocks per geographical region")
print(summary.geo)


print("Number of stocks with negative pre-1992 slope")
print(dim(par.estimates.1010[par.estimates.1010$mcont.pre.positive==0,])[1])
print("Number of stocks with negative pre-1992 slope and negative post-1992 slope (i.e. still declining)")
print(dim(par.estimates.1010[par.estimates.1010$mcont.pre.positive==0 & par.estimates.1010$mcont.post.positive==0,])[1])
print("Number of stocks with negative pre-1992 slope and negative slope difference")
print(dim(par.estimates.1010[par.estimates.1010$mcont.pre.positive==0 & par.estimates.1010$mcont.diff<0,])[1])
print("Number of stocks with negative pre-1992 slope and positive slope difference")
print(dim(par.estimates.1010[par.estimates.1010$mcont.pre.positive==0 & par.estimates.1010$mcont.diff>0,])[1])
print("Number of stocks with negative pre-1992 slope, positive slope difference and negative post-1992 slope")
print(dim(par.estimates.1010[par.estimates.1010$mcont.pre.positive==0 & par.estimates.1010$mcont.post.positive==0 & par.estimates.1010$mcont.diff>0,])[1])

print("Number of pre-1992 negative (0) and pre-1992 positive (1) per region")
print(table(par.estimates.1010$geo, par.estimates.1010$mcont.pre.positive))

print("Number of stocks with BRP with negative pre-1992 slope")
print(dim(par.estimates.1010.brp.both[par.estimates.1010.brp.both$mcont.pre.positive==0 & !is.na(par.estimates.1010.brp.both$fromassessment.x),])[1])
print("Number of stocks with BRP with negative pre-1992 slope and negative post-1992 slope (i.e. still declining)")
print(dim(par.estimates.1010.brp.both[par.estimates.1010.brp.both$mcont.pre.positive==0 & par.estimates.1010.brp.both$mcont.post.positive==0  & !is.na(par.estimates.1010.brp.both$fromassessment.x),])[1])
print("Number of stocks with BRP with negative pre-1992 slope and negative slope difference")
print(dim(par.estimates.1010.brp.both[par.estimates.1010.brp.both$mcont.pre.positive==0 & par.estimates.1010.brp.both$mcont.diff<0  & !is.na(par.estimates.1010.brp.both$fromassessment.x),])[1])
print("Number of stocks with BRP with negative pre-1992 slope and positive slope difference")
print(dim(par.estimates.1010.brp.both[par.estimates.1010.brp.both$mcont.pre.positive==0 & par.estimates.1010.brp.both$mcont.diff>0  & !is.na(par.estimates.1010.brp.both$fromassessment.x),])[1])
print("Number of stocks with BRP with negative pre-1992 slope, positive slope difference and negative post-1992 slope")
print(dim(par.estimates.1010.brp.both[par.estimates.1010.brp.both$mcont.pre.positive==0 & par.estimates.1010.brp.both$mcont.post.positive==0 & par.estimates.1010.brp.both$mcont.diff>0  & !is.na(par.estimates.1010.brp.both$fromassessment.x),])[1])


#dim(par.estimates.1010.brp.both[par.estimates.1010.brp.both$mcont.pre.positive==0,])
temp.pre.negative <- par.estimates.1010.brp.both[par.estimates.1010.brp.both$mcont.pre.positive==0,]
temp.post.negative <- par.estimates.1010.brp.both[par.estimates.1010.brp.both$mcont.post.positive==0,]

#print("1992 ratio for stocks with BRP with negative pre-1992 slope")

print("Number of pre-1992 negative stocks with BRP from assessment")
print(table(temp.pre.negative$fromassessment.x))
print("1992 ratio for pre-1992 negative ")
print(table(temp.pre.negative$colour1992))
print("1992 ratio for pre-1992 negative by type")
print(table(temp.pre.negative$colour1992, temp.pre.negative$fromassessment.x))

print("Ratios for stocks still declining, by region")
print(table(temp.post.negative$geo, temp.post.negative$colour1992))

temp.pre.negative.noNA <- na.omit(temp.pre.negative)
temp.pre.negative.noNA.belowBmsy <- temp.pre.negative.noNA[temp.pre.negative.noNA$bratio1992<1,]

print("Number of stocks with 1992 ratio < 1 and pre-1992 negative")
print(dim(temp.pre.negative.noNA.belowBmsy)[1])
print("Number of stocks with 1992 ratio < 1, pre-1992 negative and positive slope difference")
print(dim(temp.pre.negative.noNA.belowBmsy[temp.pre.negative.noNA.belowBmsy$mcont.diff>0,])[1])

##print(table(temp.pre.negative$colour1992, temp.pre.negative$mcont.diff))

print("1992 ratio per region for pre-1992 negative ")
print(table(temp.pre.negative$geo, temp.pre.negative$colour1992))

print("current ratio for pre-1992 negative ")
print(table(temp.pre.negative$colourcurrent))
print("current ratio for pre-1992 negative by type")
print(table(temp.pre.negative$colourcurrent, temp.pre.negative$fromassessment.x))
print("current ratio per region for pre-1992 negative ")
print(table(temp.pre.negative$geo, temp.pre.negative$colourcurrent))

#print("1992 ratio per region")
#table(temp.pre.negative$geo, temp.pre.negative$colour1992, temp.pre.negative$fromassessment.x)
#table(temp.pre.negative$geo, temp.pre.negative$colourcurrent, temp.pre.negative$fromassessment.x)


temp.pre.negative$diff <- ifelse(temp.pre.negative$mcont.diff>0,"positive","negative")
print("Slope difference by region")
print(table(temp.pre.negative$geo,temp.pre.negative$diff))
print(table(temp.pre.negative$geo,temp.pre.negative$colourcurrent,temp.pre.negative$diff))

temp.post.negative <- temp.pre.negative[temp.pre.negative$mcont.post.positive==0 & temp.pre.negative$mcont.diff>0,]

print("pre-1992 negative, positive difference and post-1992 negative by region and ratio")
print(table(temp.post.negative$geo,temp.post.negative$colourcurrent))

temp.post.negative <- temp.pre.negative[temp.pre.negative$mcont.diff<0,]

print("pre-1992 negative, negative difference by region and ratio")
print(table(temp.post.negative$geo,temp.post.negative$colourcurrent))

## multi-species analysis
print("Multi-species")
print("Number of stocks used in multi-species analysis")
print(as.character(length(unique(ts.dat2$assessid))))
print("Overall percentage decline 1970-1974 to 2005-2009")
print(as.character(orig.percent.change.df$percent.decline[orig.percent.change.df$region=='All' & orig.percent.change.df$category=='All']))
print("Pelagic percentage decline 1970-1974 to 2005-2009")
print(as.character(orig.percent.change.df$percent.decline[orig.percent.change.df$region=='All' & orig.percent.change.df$category=='Pelagic']))
print("Demersal percentage decline 1970-1974 to 2005-2009")
print(as.character(orig.percent.change.df$percent.decline[orig.percent.change.df$region=='All' & orig.percent.change.df$category=='Demersal']))



print("Number of stocks used in multi-species analysis with BRP")
print(length(unique(brp.ratio.dat2$assessid)))
print("Overall decline 1970-1974 to 2005-2009, with BRP")
print(as.character(brp.percent.change.df$percent.decline[brp.percent.change.df$region=='All' & brp.percent.change.df$category=='All']))
print(as.character(brp.percent.change.df$index.start[brp.percent.change.df$region=='All' & brp.percent.change.df$category=='All']))
print(as.character(brp.percent.change.df$index.end[brp.percent.change.df$region=='All' & brp.percent.change.df$category=='All']))

print("Pelagic decline 1970-1974 to 2005-2009, with BRP")
print(as.character(brp.percent.change.df$percent.decline[brp.percent.change.df$region=='All' & brp.percent.change.df$category=='Pelagic']))
print(as.character(brp.percent.change.df$index.start[brp.percent.change.df$region=='All' & brp.percent.change.df$category=='Pelagic']))
print(as.character(brp.percent.change.df$index.end[brp.percent.change.df$region=='All' & brp.percent.change.df$category=='Pelagic']))

print("Demersal decline 1970-1974 to 2005-2009, with BRP")
print(as.character(brp.percent.change.df$percent.decline[brp.percent.change.df$region=='All' & brp.percent.change.df$category=='Demersal']))
print(as.character(brp.percent.change.df$index.start[brp.percent.change.df$region=='All' & brp.percent.change.df$category=='Demersal']))
print(as.character(brp.percent.change.df$index.end[brp.percent.change.df$region=='All' & brp.percent.change.df$category=='Demersal']))

print("Demersal decline by region, with BRP")
print("NWAtl")
print(as.character(brp.percent.change.df$percent.decline[brp.percent.change.df$region == 'NWAtl' & brp.percent.change.df$category=='Demersal']))
print(as.character(brp.percent.change.df$index.start[brp.percent.change.df$region == 'NWAtl' & brp.percent.change.df$category=='Demersal']))
print(as.character(brp.percent.change.df$index.end[brp.percent.change.df$region == 'NWAtl' & brp.percent.change.df$category=='Demersal']))
print("NEAtl")
print(as.character(brp.percent.change.df$percent.decline[brp.percent.change.df$region == 'NEAtl' & brp.percent.change.df$category=='Demersal']))
print(as.character(brp.percent.change.df$index.start[brp.percent.change.df$region == 'NEAtl' & brp.percent.change.df$category=='Demersal']))
print(as.character(brp.percent.change.df$index.end[brp.percent.change.df$region == 'NEAtl' & brp.percent.change.df$category=='Demersal']))
print("NorthMidAtl")
print(as.character(brp.percent.change.df$percent.decline[brp.percent.change.df$region == 'NorthMidAtl' & brp.percent.change.df$category=='Demersal']))
print(as.character(brp.percent.change.df$index.start[brp.percent.change.df$region == 'NorthMidAtl' & brp.percent.change.df$category=='Demersal']))
print(as.character(brp.percent.change.df$index.end[brp.percent.change.df$region == 'NorthMidAtl' & brp.percent.change.df$category=='Demersal']))
print("Aust-NZ")
print(as.character(brp.percent.change.df$percent.decline[brp.percent.change.df$region == 'Aust-NZ' & brp.percent.change.df$category=='Demersal']))
print(as.character(brp.percent.change.df$index.start[brp.percent.change.df$region == 'Aust-NZ' & brp.percent.change.df$category=='Demersal']))
print(as.character(brp.percent.change.df$index.end[brp.percent.change.df$region == 'Aust-NZ' & brp.percent.change.df$category=='Demersal']))
                                                  
sink()


write.csv(dat.1010,"CBD-dat-1010.csv")
write.csv(par.estimates.1010,"CBD-parestimates-1010.csv")
write.csv(par.estimates.1010.brp.both,"CBD-parestimates-BRP-1010.csv")
write.csv(stocklist.1010, "CBD-stocklist-1010.csv")

supp.table.dat <- merge(stocklist.1010, par.estimates.1010.brp.both, by="stockid", all.x=TRUE)
supp.table.dat$typesymbol <- ifelse(supp.table.dat$type.x=="salt","*"," ")
supp.table.dat$taxotable <- ifelse(supp.table.dat$taxocategory=="Pelagic","Pelagic","Demersal")



  supp.table <- data.frame(StockID = supp.table.dat$stockid, Area=supp.table.dat$areaname, Commonname=supp.table.dat$commonname, Scientificname=supp.table.dat$scientificname, Category=supp.table.dat$taxotable, type=supp.table.dat$typesymbol, ratio1992=round(supp.table.dat$bratio1992,2), ratiocurrent=round(supp.table.dat$bratiocurrent,2), mcontpre=round(supp.table.dat$mcont.slope.before,4), mcontpost=round(supp.table.dat$mcont.slope.after,4), mpre=round(supp.table.dat$m.slope.before,4), mpost=round(supp.table.dat$m.slope.after,4), msspre=round(supp.table.dat$mss.slope.before,4), msspost=round(supp.table.dat$mss.slope.after,4))

write.csv(supp.table, "CBD-TableS1.csv")

supp.table$Scientificname <- paste("\\textit{",supp.table$Scientificname,"}",sep="")

# now generate a good looking LaTeX table to be picked up by CJFAS-shortcomm-bundle.tex


#my.tableS1.caption <- c("A description of each population's alphanumeric identification code, geographic location, common and scientific names, taxonomic category, reference point type, ratios of biomass to MSY reference point for 1992 and the current year and values for the slopes under the three different models.")
#my.tableS1.caption <- c("")
#caption=my.tableS1.caption, 
  my.table.S1 <- xtable(supp.table, label=c("tab:S1"), digits=4, align="cp{2.6cm}p{1.9cm}p{1.7cm}p{1.6cm}p{1cm}p{0.3cm}p{1cm}p{1cm}p{1cm}p{1.1cm}p{1cm}p{1.1cm}p{1cm}p{1.1cm}")

print(my.table.S1, type="latex", file="Table-S1.tex", include.rownames=FALSE, floating=FALSE, tabular.environment="longtable", caption.placement="top", sanitize.text.function=I)
#  print(my.table.S1, type="latex", file="Table-S1.tex", include.rownames=FALSE, floating=FALSE, tabular.environment="longtable", caption.placement="bottom", sanitize.text.function=I)

#  \hline \\ Continued on next page \endfoot

# \hline  & & & & & &  \multicolumn{2}{c}{Continuous} & \multicolumn{2}{c}{Discontinuous} & \multicolumn{2}{c}{Drift} & & \\ 
# Stock ID & Area & Common name & Scientific name & Category & type & pre-1992 & post-1992 & pre-1992 & post-1992 & pre-1992 & post1992 & ratio 1992 & ratio current \\ \hline \endhead

# final, write and Excel file with all the required data
