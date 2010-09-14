## spoked wheel dendrogram for Fish and Fisheries manuscript
## Started: 2010-02-16 DR from earlier work in this directory
## Last modified Time-stamp: <2010-08-04 16:10:36 (srdbadmin)>
## Modification history:
## 2010-04-08: we decided on not using LMEs for weighting the dendrograms, modifying the code to reflect that (DR)
## 2010-05-27: system upgrade broke R and I had to revert to an earlier version for this code to work

setwd("/home/srdbadmin/srdb/projects/fishandfisheries/R")
require(RODBC); require(ape); require(gsubfn); require(IDPmisc); require(doBy)

    f.rec <- function(subtaxo) {
        u <- ncol(subtaxo)
        levels <- unique(subtaxo[, u])
        if (u == 1) {
            if (length(levels) != nrow(subtaxo)) 
                warning("Error, leaves names are not unique.")
            return(as.character(subtaxo[, 1]))
          }
        t <- character(length(levels))
        for (l in 1:length(levels)) {
            x <- f.rec(subtaxo[subtaxo[, u] == levels[l], ][1:(u - 1)])
           if (length(x) == 1) 
              t[l] <- x
               ##t[l] <- paste(x,":", 1, sep="")
            else{
              n.elements<-length(unlist(strapply(x, "(?<![:0-9])[0-9]+", backref=1, perl=TRUE))) ## ammended CM, Dec 6th 2009
              t[l] <- paste("(", paste(x, collapse = ","),")",":",n.elements, sep = "") ## ammended CM, Dec 6th 2009
            }
          }
        return(t)
      }

source("my_as_phylo_formula.R")
source("by_order_as_phylo_formula.R")

chan <- odbcConnect(dsn="srdbcalo")

### FishBase
fishbase.dat <- read.table("fishbase-DendroRAM-FROMRAINER.csv", sep=",", header=TRUE)
fishbase.dat$scientificname <- as.factor(paste(fishbase.dat$Genus, fishbase.dat$Species, sep=" "))
fishbase.dat <- fishbase.dat[order(fishbase.dat$scientificname),]

# number of species in FishBase
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMSPPFISHBASE'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMSPPFISHBASE',",dim(fishbase.dat)[1] ,")", sep="")
sqlQuery(chan,insert.qu)

# number of orders in FishBase
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:NUMORDERSFISHBASE'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:NUMORDERSFISHBASE',",length(unique(fishbase.dat$Order)) ,")", sep="")
sqlQuery(chan,insert.qu)


## expand out the species row entries to be equal to the value of LME column
##expanded.fishbase.dat<-fishbase.dat[rep(1:nrow(fishbase.dat), times=fishbase.dat$LME), ]
expanded.fishbase.dat<-fishbase.dat
## get the counts by order
fishbase.dat.order<-summaryBy(Family~Class+Order, data=expanded.fishbase.dat, FUN=c(length))

taxo.phylo.fishbase<-as.phylo(~Class/Order, data=fishbase.dat.order)
my.taxo.phylo.fishbase<-my.as.phylo.formula(~Class/Order, data=fishbase.dat.order)

## by.order.as.phylo.formula(~Class/Order, data=fishbase.dat.order)

taxo.2.phylo.fishbase<-by.order.as.phylo.formula(~Class/Order, data=fishbase.dat.order)
taxo.2.phylo.fishbase$div.edge.length<-taxo.2.phylo.fishbase$edge.length/(range(taxo.2.phylo.fishbase$edge.length)[2]/20)
taxo.phylo.fishbase$tip.label<-taxo.2.phylo.fishbase$tip.label

## get the percentage in each order
percentage.by.order<-round(100*as.numeric(sapply(taxo.phylo.fishbase$tip.label, function(z){fishbase.dat.order$Family.length[fishbase.dat.order$Order==z]}))/sum(fishbase.dat.order$Family.length),2)
taxo.phylo.fishbase$tip.label<-paste(taxo.phylo.fishbase$tip.label,paste("(",percentage.by.order,")", sep=""), sep="\n")
## get the percentage in each class (smaller classes only have one order already represented)
percent.actinopterygii<-round(100*sum(fishbase.dat.order$Family.length[fishbase.dat.order$Class=="Actinopterygii (ray-finned fishes)"])/sum(fishbase.dat.order$Family.length),2)
percent.elasmobranchii<-round(100*sum(fishbase.dat.order$Family.length[fishbase.dat.order$Class=="Elasmobranchii (sharks and rays)"])/sum(fishbase.dat.order$Family.length),2)

## pdf output
pdf("/home/srdbadmin/srdb/projects/fishandfisheries/R/FishBase-byorder.pdf", width=10, height=10)
plot(taxo.phylo.fishbase, type="r", no.margin = TRUE, cex=0.8, root.edge=TRUE, show.tip.label=TRUE,
     edge.width=taxo.2.phylo.fishbase$div.edge.length, label.offset=0.5, srt=0, adj=0)
points(0,0, col=1, pch=21, bg="darkgrey", cex=3)
text(0.22,0.1,labels=paste("Actinopterygii",paste("(",percent.actinopterygii,")", sep=""), sep="\n"))
text(0.55,-0.35,labels=paste("Elasmobranchii",paste("(",percent.elasmobranchii,")", sep=""), sep="\n"))
dev.off()
## system("xpdf ./FishBase-byorder.pdf")

### SAUP


#### DATA obtained from SAUP website by copying the contents of an HTML form for search
## not elegant but a start
saup.dat.in <- read.csv("SAUP-species-list.csv")

fishbase.saup.merged <- merge(fishbase.dat, saup.dat.in, "scientificname")
saup.dat <- data.frame(Kingdom = fishbase.saup.merged$Kingdom, Phylum = fishbase.saup.merged$Phylum, Class = fishbase.saup.merged$Class, Order = fishbase.saup.merged$Order, Family = fishbase.saup.merged$Family, Genus = fishbase.saup.merged$Genus, Species = fishbase.saup.merged$Species, LME = fishbase.saup.merged$LME, scientificname = fishbase.saup.merged$scientificname)

saup.dat$Order <- as.factor(as.character(saup.dat$Order))
saup.dat$Class <- as.factor(as.character(saup.dat$Class))


# number of species in SAUP
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:SAUPNUMSPP'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:SAUPNUMSPP',",dim(saup.dat)[1] ,")", sep="")
sqlQuery(chan,insert.qu)

# number of orders in SAUP
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:SAUPNUMORDERS'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:SAUPNUMORDERS',",length(unique(saup.dat$Order)) ,")", sep="")
sqlQuery(chan,insert.qu)

## SAUP vs. FishBase in percentages
delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:SAUPPERCENTSPPFISHBASE'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:SAUPPERCENTSPPFISHBASE',",round(dim(saup.dat)[1]/dim(fishbase.dat)[1]*100,0) ,")", sep="")
sqlQuery(chan,insert.qu)

delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:SAUPPERCENTORDERSFISHBASE'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:SAUPPERCENTORDERSFISHBASE',",round(length(unique(saup.dat$Order))/length(unique(fishbase.dat$Order))*100,0) ,")", sep="")
sqlQuery(chan,insert.qu)

##

### note subsample of fishbase for now
#n.sample<-floor(0.3*length(fishbase.dat[,1]))
#index<-sample(seq(1,length(fishbase.dat[,1])),size=n.sample)
#saup.data<-fishbase.dat[index,]
#saup.dat <- saup.dat[order(saup.dat$scientificname),]
#saup.dat$scientificname <- as.factor(paste(saup.dat$Genus, saup.dat$Species, sep=" "))
#saup.levels <- as.character(unique((saup.dat$Order)))
#saup.dat$Order <- as.factor(as.character(saup.dat$Order))


##expanded.saup.dat<-saup.dat[rep(1:nrow(saup.dat), times=saup.dat$LME), ]
expanded.saup.dat<-saup.dat

## get the counts by order2
saup.dat.order<-summaryBy(Family~Class+Order, data=expanded.saup.dat, FUN=c(length))

taxo.phylo.saup <- as.phylo(~Class/Order, data=saup.dat.order)

taxo.2.phylo.saup <- by.order.as.phylo.formula(~Class/Order, data=saup.dat.order)

taxo.2.phylo.saup$div.edge.length<-taxo.2.phylo.saup$edge.length/(range(taxo.2.phylo.saup$edge.length)[2]/20)
taxo.phylo.saup$tip.label<-taxo.2.phylo.saup$tip.label

## get the percentage in each order
percentage.by.order<-round(100*as.numeric(sapply(taxo.phylo.saup$tip.label, function(z){saup.dat.order$Family.length[saup.dat.order$Order==z]}))/sum(saup.dat.order$Family.length),2)
taxo.phylo.saup$tip.label<-paste(taxo.phylo.saup$tip.label,paste("(",percentage.by.order,")", sep=""), sep="\n")
percent.actinopterygii<-round(100*sum(saup.dat.order$Family.length[saup.dat.order$Class=="Actinopterygii (ray-finned fishes)"])/sum(saup.dat.order$Family.length),2)
percent.elasmobranchii<-round(100*sum(saup.dat.order$Family.length[saup.dat.order$Class=="Elasmobranchii (sharks and rays)"])/sum(saup.dat.order$Family.length),2)

pdf("/home/srdbadmin/srdb/projects/fishandfisheries/R/SAUP-byorder.pdf", width=10, height=10)
plot(taxo.phylo.saup, type="r", no.margin = TRUE, cex=0.8, root.edge=TRUE, show.tip.label=TRUE,
     edge.width=taxo.2.phylo.saup$div.edge.length, label.offset=0.5, srt=0, adj=0)
points(0,0, col=1, pch=21, bg="darkgrey", cex=3)
text(0.15,0.1,labels=paste("Actinopterygii",paste("(",percent.actinopterygii,")", sep=""), sep="\n"))
text(0.53,-0.35,labels=paste("Elasmobranchii",paste("(",percent.elasmobranchii,")", sep=""), sep="\n"))
dev.off()

##system("xpdf ./SAUP-byorder.pdf")
### srdb
## one entry per assessment
taxo.qu<-paste("select * from srdb.taxonomy as aa, (select tsn from srdb.stock where stockid in (select stockid from srdb.assessment where assessid not like '%MYERS%' and assess=1)) as bb where aa.tsn=bb.tsn")

taxo.dat<-sqlQuery(chan, taxo.qu)
taxo.dat<-taxo.dat[order(taxo.dat$scientificname),]

taxo.phylo<-as.phylo(~phylum/classname/ordername/family/genus/scientificname, data=taxo.dat)
## take a look at the contents using taxo.phylo[]
## edge width/length inclusion
taxo.2.phylo<-my.as.phylo.formula(~phylum/classname/ordername/family/genus/scientificname, data=taxo.dat)
##taxo.phylo$root.edge<-taxo.2.phylo$root.edge

## sqrt for plotting
taxo.2.phylo$sqrt.edge.length<-sqrt(taxo.2.phylo$edge.length+0.1)

prelim.tip.labels<-rep("", length(taxo.phylo$tip.label))
for(i in 2:length(prelim.tip.labels)){
  print(i)
  if(taxo.phylo$tip.label[i]!=taxo.phylo$tip.label[i-1]){
    prelim.tip.labels[i]<-taxo.phylo$tip.label[i]
  }
}

taxo.phylo$tip.label<-prelim.tip.labels

#pdf("/home/srdbadmin/srdb/projects/fishandfisheries/R/srdb-by-assessment.pdf", width=10, height=10, title="Taxonomic dendrogram of RAM Legacy database"
png("/home/srdbadmin/srdb/projects/fishandfisheries/R/srdb-by-assessment.png", width=1000, height=1000)
my.opaque.grey<-"#80808099"
plot(taxo.phylo, type="r", edge.width=taxo.2.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.65, root.edge=TRUE, show.tip.label=TRUE, edge.col=c(my.opaque.grey,my.opaque.grey, rep(grey(0.5), length(taxo.2.phylo$sqrt.edge.length-2))))
points(0,0, col=1, pch=21, bg="darkgrey", cex=3)
my.cex=0.75
text(0.68,-0.09, labels="Arthropoda", srt=351, cex=my.cex, font=2)
text(0.6,-0.34, labels="Mollusca", srt=330, cex=my.cex, font=2)
text(0.45,-0.41, labels="Chondrichtyes", srt=325, cex=my.cex)
text(0.35,0.41, labels="Perciformes", srt=40, cex=my.cex)
text(-0.09,0.5, labels="Scorpaeniformes", srt=80, cex=my.cex)
text(-0.5,0.35, labels="Clupeiformes", srt=320, cex=my.cex)
text(-0.47,-0.15, labels="Pleuronectiformes", srt=33, cex=my.cex)
text(0.1,-0.45, labels="Gadiformes", srt=295, cex=my.cex)
text(0.20,0.1, labels="Animalia", srt=0, cex=1, font=2)
Arrows(0.08,0.1,0.015,0.04, open=FALSE, size=0.5)
#text(-0.38,0.35, labels="Actinopterygii", srt=0, cex=my.cex)
#Arrows(-0.37,0.31,-0.10,-0.02, open=FALSE, size=0.5)
#text(0.22,-0.12, labels="Chordata", srt=343, cex=my.cex, font=2)
#Arrows(0.12,-0.09,0.01,-0.09, open=FALSE, size=0.5)
dev.off()


## taxo.qu<-paste("select t.tsn, t.kingdom, t.phylum, t.classname, t.ordername, t.family, t.genus, t.species, t.scientificname, foo.lme_number, count(*)  as numlme from srdb.stock s, srdb.taxonomy t, (select stockid, lme_number from srdb.lmetostocks where stocktolmerelation = 'primary' and stockid in (select distinct stockid from srdb.assessment where recorder != 'MYERS')) as foo where foo.stockid=s.stockid and s.tsn=t.tsn group by t.tsn, t.kingdom, t.phylum, t.classname, t.ordername, t.family, t.genus, t.species, t.scientificname, lme_number order by t.tsn, lme_number")
## order-level
taxo.qu<-paste("select t.tsn, t.kingdom, t.phylum, t.classname, t.ordername, t.family, t.genus, t.species, t.scientificname, a.assessid from srdb.assessment a, srdb.stock s, srdb.taxonomy t  where a.assess=1 AND a.recorder != \'MYERS\' AND a.stockid=s.stockid and s.tsn=t.tsn order by t.tsn")
srdb.dat <- sqlQuery(chan,taxo.qu)

srdb.dat <- srdb.dat[order(srdb.dat$scientificname),]
srdb.levels <- as.character(unique((srdb.dat$ordername)))
srdb.dat$Family <- as.factor(as.character(srdb.dat$family))
srdb.dat$Class <- as.factor(as.character(srdb.dat$classname))
srdb.dat$Order <- as.factor(as.character(srdb.dat$ordername))


delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:SRDBPERCENTSPPSAUP'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:SRDBPERCENTSPPSAUP',",round(length(unique(srdb.dat$scientificname))/dim(saup.dat)[1]*100,0) ,")", sep="")
sqlQuery(chan,insert.qu)

delete.qu <- paste("DELETE FROM fishfisheries.results WHERE flag= 'REF:SQL:SRDBPERCENTSPPFISHBASE'",sep="" )
sqlQuery(chan,delete.qu)
insert.qu <- paste("INSERT INTO fishfisheries.results VALUES ('REF:SQL:SRDBPERCENTSPPFISHBASE',",round(length(unique(srdb.dat$scientificname))/dim(fishbase.dat)[1]*100,0) ,")", sep="")
sqlQuery(chan,insert.qu)

# REF:SQL:SRDBPERCENTSPPSAUP
# REF:SQL:SRDBPERCENTSPPFISHBASE



## expanded.srdb.dat<-srdb.dat[rep(1:nrow(srdb.dat), times=srdb.dat$numlme), ]
expanded.srdb.dat<-srdb.dat
## get the counts by order2
srdb.dat.order<-summaryBy(Family~Class+Order, data=expanded.srdb.dat, FUN=c(length))

taxo.phylo.srdb<-as.phylo(~Class/Order, data=srdb.dat.order)
taxo.2.phylo.srdb<-by.order.as.phylo.formula(~Class/Order, data=srdb.dat.order)
taxo.2.phylo.srdb$div.edge.length<-taxo.2.phylo.srdb$edge.length/(range(taxo.2.phylo.srdb$edge.length)[2]/20)
taxo.phylo.srdb$tip.label<-taxo.2.phylo.srdb$tip.label

## get the percentage in each order
percentage.by.order<-round(100*as.numeric(sapply(taxo.phylo.srdb$tip.label, function(z){srdb.dat.order$Family.length[srdb.dat.order$Order==z]}))/sum(srdb.dat.order$Family.length),2)
taxo.phylo.srdb$tip.label<-paste(taxo.phylo.srdb$tip.label,paste("(",percentage.by.order,")", sep=""), sep="\n")

percent.actinopterygii<-round(100*sum(srdb.dat.order$Family.length[srdb.dat.order$Class=="Actinopterygii"])/sum(srdb.dat.order$Family.length),2)
percent.chondrichthyes <-round(100*sum(srdb.dat.order$Family.length[srdb.dat.order$Class=="Chondrichthyes"])/sum(srdb.dat.order$Family.length),2)


pdf("/home/srdbadmin/srdb/projects/fishandfisheries/R/srdb-byorder.pdf", width=10, height=10)
plot(taxo.phylo.srdb, type="r", no.margin = TRUE, cex=0.8, root.edge=TRUE, show.tip.label=TRUE,
     edge.width=taxo.2.phylo.srdb$div.edge.length, label.offset=0.5, srt=0, adj=0)
points(0,0, col=1, pch=21, bg="darkgrey", cex=3)
text(0.26,0.16,labels=paste("Actinopterygii",paste("(",percent.actinopterygii,")", sep=""), sep="\n"))
text(0.5,-0.4,labels=paste("Chondrichthyes",paste("(",percent.chondrichthyes,")", sep=""), sep="\n"))
dev.off()


odbcClose(chan)

## now do the same for fish and shark species only, eliminate the inverts from srdb
srdb.dat <- subset(srdb.dat, phylum=='Chordata')

srdb.dat <- srdb.dat[order(srdb.dat$scientificname),]
srdb.levels <- as.character(unique((srdb.dat$ordername)))
srdb.dat$Family <- as.factor(as.character(srdb.dat$family))
srdb.dat$Class <- as.factor(as.character(srdb.dat$classname))
srdb.dat$Order <- as.factor(as.character(srdb.dat$ordername))


## get the counts by order2
srdb.dat.order<-summaryBy(Family~Class+Order, data=expanded.srdb.dat, FUN=c(length))

taxo.phylo.srdb<-as.phylo(~Class/Order, data=srdb.dat.order)
taxo.2.phylo.srdb<-by.order.as.phylo.formula(~Class/Order, data=srdb.dat.order)
taxo.2.phylo.srdb$div.edge.length<-taxo.2.phylo.srdb$edge.length/(range(taxo.2.phylo.srdb$edge.length)[2]/20)
taxo.phylo.srdb$tip.label<-taxo.2.phylo.srdb$tip.label

## get the percentage in each order
percentage.by.order<-round(100*as.numeric(sapply(taxo.phylo.srdb$tip.label, function(z){srdb.dat.order$Family.length[srdb.dat.order$Order==z]}))/sum(srdb.dat.order$Family.length),2)
taxo.phylo.srdb$tip.label<-paste(taxo.phylo.srdb$tip.label,paste("(",percentage.by.order,")", sep=""), sep="\n")

percent.actinopterygii<-round(100*sum(srdb.dat.order$Family.length[srdb.dat.order$Class=="Actinopterygii"])/sum(srdb.dat.order$Family.length),2)
percent.chondrichthyes <-round(100*sum(srdb.dat.order$Family.length[srdb.dat.order$Class=="Chondrichthyes"])/sum(srdb.dat.order$Family.length),2)


pdf("/home/srdbadmin/srdb/projects/fishandfisheries/R/srdb-fishonly-byorder.pdf", width=10, height=10)
plot(taxo.phylo.srdb, type="r", no.margin = TRUE, cex=0.8, root.edge=TRUE, show.tip.label=TRUE,
     edge.width=taxo.2.phylo.srdb$div.edge.length, label.offset=0.5, srt=0, adj=0)
points(0,0, col=1, pch=21, bg="darkgrey", cex=3)
text(0.26,0.16,labels=paste("Actinopterygii",paste("(",percent.actinopterygii,")", sep=""), sep="\n"))
text(0.5,-0.4,labels=paste("Chondrichthyes",paste("(",percent.chondrichthyes,")", sep=""), sep="\n"))
dev.off()


## compare FishBase and SAUP
source("./maintain_branching_phylo_formula_noLME.R")
fishbase.saup.phylo <- maintain.branching.phylo.formula.nolme(~Class/Order, data1=fishbase.dat.order, data2=saup.dat.order)
fishbase.phylo <- fishbase.saup.phylo[[1]]
saup.phylo <- fishbase.saup.phylo[[2]]

fishbase.phylo$sqrt.edge.length<-fishbase.phylo$edge.length/(range(fishbase.phylo$edge.length)[2]/20)
saup.phylo$sqrt.edge.length<-saup.phylo$edge.length/(range(fishbase.phylo$edge.length)[2]/20)

fishbase.percentage.by.order<-round(100*as.numeric(sapply(fishbase.phylo$tip.label, function(z){fishbase.dat.order$Family.length[fishbase.dat.order$Order==z]}))/sum(fishbase.dat.order$Family.length),2)
fishbase.phylo$tip.label<-paste(fishbase.phylo$tip.label,paste("(",fishbase.percentage.by.order,")", sep=""), sep="\n")

saup.percentage.by.order<-round(100*as.numeric(sapply(saup.phylo$tip.label, function(z){saup.dat.order$Family.length[saup.dat.order$Order==z]}))/sum(saup.dat.order$Family.length),2)
saup.phylo$tip.label<-paste(saup.phylo$tip.label,paste("(",saup.percentage.by.order,")", sep=""), sep="\n")
saup.phylo$tip.label[saup.phylo$tip.label=="\n(NA)"] <- ""

pdf("/home/srdbadmin/srdb/projects/fishandfisheries/R/fishbase_saup_two_panel_phylo.pdf", width=10, height=6)
par(mfrow=c(1,2), mar=c(0,0,0,0))
## Fishbase
plot(fishbase.phylo, type="r", edge.width=fishbase.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=TRUE, use.edge.length = FALSE, edge.col=grey(0.5))
legend("topleft", legend="FishBase", bty="n", cex=1.2)
## srdb
plot(saup.phylo, type="r", edge.width=saup.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=TRUE, use.edge.length = FALSE, edge.col=grey(0.5), edge.lty=ifelse(saup.phylo$sqrt.edge.length>0,1,0))
legend("topleft", legend="SAUP", bty="n", cex=1.2)
dev.off()


# three-panel plot, showing FishBase, SAUP and srdb
fishbase.srdb.phylo <- maintain.branching.phylo.formula.nolme(~Class/Order, data1=fishbase.dat.order, data2=srdb.dat.order)
srdb.phylo <- fishbase.srdb.phylo[[2]]

srdb.phylo$sqrt.edge.length<-srdb.phylo$edge.length/(range(fishbase.phylo$edge.length)[2]/20)

srdb.percentage.by.order<-round(100*as.numeric(sapply(srdb.phylo$tip.label, function(z){srdb.dat.order$Family.length[srdb.dat.order$Order==z]}))/sum(srdb.dat.order$Family.length),2)
srdb.phylo$tip.label<-paste(srdb.phylo$tip.label,paste("(",srdb.percentage.by.order,")", sep=""), sep="\n")
srdb.phylo$tip.label[srdb.phylo$tip.label=="\n(NA)"] <- ""

# send some results to fishfisheries.results
# REF:SQL:FISHBASENUMORDERS
# REF:SQL:FISHBASENUMSPP
# REF:SQL:SRDBPERCENTSPPSAUP
# REF:SQL:SRDBPERCENTSPPFISHBASE
# REF:SQL:SAUPNUMORDERS
# REF:SQL:SAUPNUMSPP
# REF:SQL:SAUPPERCENTSPPFISHBASE
# REF:SQL:SAUPPERCENTORDERSFISHBASE


#pdf("/home/srdbadmin/srdb/projects/fishandfisheries/R/three_panel_phylo.pdf", width=6, height=10)
png("/home/srdbadmin/srdb/projects/fishandfisheries/R/three_panel_phylo.png", width=600, height=1000)
par(mfrow=c(3,1), mar=c(0,0,0,0))
## Fishbase
plot(fishbase.phylo, type="r", edge.width=fishbase.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.6, root.edge=TRUE, show.tip.label=TRUE, use.edge.length = FALSE, edge.col=grey(0.5))
legend("topleft", legend="FishBase", bty="n", cex=1.2)
## SAUP
plot(saup.phylo, type="r", edge.width=saup.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.65, root.edge=TRUE, show.tip.label=TRUE, use.edge.length = FALSE, edge.col=grey(0.5), edge.lty=ifelse(saup.phylo$sqrt.edge.length>0,1,0))
legend("topleft", legend="SAUP", bty="n", cex=1.2)
## srdb
plot(srdb.phylo, type="r", edge.width=srdb.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.65, root.edge=TRUE, show.tip.label=TRUE, use.edge.length = FALSE, edge.col=grey(0.5), edge.lty=ifelse(srdb.phylo$sqrt.edge.length>0,1,0))
legend("topleft", legend="RAM Legacy", bty="n", cex=1.2)
dev.off()
