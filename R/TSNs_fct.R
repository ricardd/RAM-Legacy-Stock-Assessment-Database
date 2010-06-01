# TSNs_fct.R
# code to obtain full taxonomic hierarchies from CBIF by supplying a TSN and processing an incoming XML document
# Daniel Ricard
# Started: 2008-08-16 from earlier work
# Modification history:
# 

# rm(list=ls(all=TRUE))

require(httpRequest)
require(XML)

# FUNCTION DEFINITION
tsn.tax.tree.fct <- function (in.tsn) {
  print(in.tsn)
my.host <- paste("www.cbif.gc.ca")
my.path <- paste("/pls/itisca/taxa_xml.hierarchy")
my.referer <- paste("")

my.datatosend <- paste("p_tsn=", in.tsn, "&p_type=y&p_lang=", sep="")

my.incoming.xml <- simplePostToHost(my.host, my.path, my.referer, my.datatosend, port=80)

my.massaged.xml <- strsplit(my.incoming.xml, "\n")

# remove the header NOTE: HARD WIRED
my.massaged.xml2 <- my.massaged.xml[[1]][9:length(my.massaged.xml[[1]])]

my.parsed.xml <- xmlTreeParse(my.massaged.xml2)

rawcandy.dat <- my.parsed.xml[[1]]$children$itis[[2]]
candy.tsn <- rawcandy.dat[[1]][1]
candy.name <- rawcandy.dat[[1]][2]
candy.rank <- rawcandy.dat[[1]][5]
candy.kingdom<- rawcandy.dat[[1]][6]
candy.lineage <- rawcandy.dat[[1]][9]

l <- length(candy.lineage[[1]])
my.parent.lineage <- data.frame(tsn=c(1:l), sciname=c(1:l), rrank=c(1:l))

for (i in 1:l) {
# extract the parental lineage from the data
my.parent.lineage$tsn[i] <- paste(unlist(candy.lineage$parentlineage[[i]][1])[3])
my.parent.lineage$sciname[i] <- paste(unlist(candy.lineage$parentlineage[[i]][2])[3])
my.parent.lineage$rrank[i] <- paste(unlist(candy.lineage$parentlineage[[i]][5])[3])
}

# write final data frame
l <- 1
my.final.data <- data.frame(tsn=c(1:l), sciname=c(1:l), kingdom=c(1:l), phylum=c(1:l), class=c(1:l), order=c(1:l), family=c(1:l), genus=c(1:l))
my.final.data$tsn[1] <- unlist(candy.tsn)[3][[1]]
my.final.data$sciname[1] <- unlist(candy.name)[3][[1]]
my.final.data$kingdom[1] <- unlist(candy.kingdom)[3][[1]]

# now add lineage
my.final.data$phylum[1] <- my.parent.lineage$sciname[my.parent.lineage$rrank=="Phylum"]
my.final.data$class[1] <- my.parent.lineage$sciname[my.parent.lineage$rrank=="Class"]
my.final.data$order[1] <- my.parent.lineage$sciname[my.parent.lineage$rrank=="Order"]
my.final.data$family[1] <- my.parent.lineage$sciname[my.parent.lineage$rrank=="Family"]
my.final.data$genus[1] <- my.parent.lineage$sciname[my.parent.lineage$rrank=="Genus"]

return(my.final.data)
} # END FUNCTION tsn.tax.tree.fct 

# test the function with a few TSNs
#my.tree1 <- tsn.tax.tree.fct(179680)
#my.tree2 <- tsn.tax.tree.fct(119401)
#my.tree3 <- tsn.tax.tree.fct(164712)

# this works fine!
