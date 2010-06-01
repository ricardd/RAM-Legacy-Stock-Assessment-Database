##---------------------------------------------------------
## taxonomy dendograms for fishbase, saup, srdb
## DR, CM
## date: Tue Dec 15 14:07:12 AST 2009
## Time-stamp: <2009-12-15 16:11:18 (srdbadmin)>
##---------------------------------------------------------
require(RODBC); require(ape); require(gsubfn); require(IDPmisc)

## FishBase data
## load csv file from Rainer Froese
taxo.dat.fishbase <- read.table("fishbase-DendroRAM-FROMRAINER.csv", sep=",", header=TRUE)
taxo.dat.fishbase$scientificname <- as.factor(paste(taxo.dat.fishbase$Genus, taxo.dat.fishbase$Species, sep=" "))
taxo.dat.fishbase<-taxo.dat.fishbase[rep(seq(1, length(taxo.dat.fishbase[,1])), times=taxo.dat.fishbase$LME),]

## SAUP data
## note subsample of fishbase for now
n.sample<-floor(0.3*length(taxo.dat.fishbase[,1]))
index<-sample(seq(1,length(taxo.dat.fishbase[,1])),size=n.sample)
taxo.dat.saup<-taxo.dat.fishbase[index,]

## srdb data
mychan<-odbcConnect(dsn="srdbusercalo") # note how the DSN is used here

##taxo.qu<-paste("select * from srdb.taxonomy as aa, (select tsn from srdb.stock where stockid in (select stockid from srdb.assessment where assessid not like '%MYERS%')) as bb where aa.tsn=bb.tsn;")

taxo.qu<-paste("select t.tsn, t.kingdom, t.phylum, t.classname, t.ordername, t.family, t.genus, t.species, t.scientificname, foo.lme_number, count(*) from srdb.stock s, srdb.taxonomy t, (select stockid, lme_number from srdb.lmetostocks where stocktolmerelation = 'primary' and stockid in (select distinct stockid from srdb.assessment where recorder != 'MYERS')) as foo where foo.stockid=s.stockid and s.tsn=t.tsn group by t.tsn, t.kingdom, t.phylum, t.classname, t.ordername, t.family, t.genus, t.species, t.scientificname, lme_number order by t.tsn, lme_number")
taxo.dat.srdb<-sqlQuery(mychan, taxo.qu)
taxo.dat.srdb<-taxo.dat.srdb[order(taxo.dat.srdb$scientificname),]

##----------------------------------------------------------
## trial on Fishbase, hypothetical SAUP subsample, and srdb
##----------------------------------------------------------
## ensure that the names match up
names(taxo.dat.fishbase)[c(2,3,4,5,6)]<-c("phylum","classname","ordername","family","genus")
names(taxo.dat.srdb)[10]<-"LME."
## Fishbase versus srdb
Fishbase.srdb.phylo<-maintain.branching.phylo.formula(~classname/ordername/family/genus/scientificname, data1=taxo.dat.fishbase, data2=taxo.dat.srdb)

fishbase.phylo<-Fishbase.srdb.phylo[[1]]
##fishbase.phylo$sqrt.edge.length<-sqrt(fishbase.phylo$edge.length)
fishbase.phylo$sqrt.edge.length<-fishbase.phylo$edge.length/(range(fishbase.phylo$edge.length)[2]/40)
srdb.phylo<-Fishbase.srdb.phylo[[2]]
##srdb.phylo$sqrt.edge.length<-sqrt(srdb.phylo$edge.length)
srdb.phylo$sqrt.edge.length<-srdb.phylo$edge.length/(range(fishbase.phylo$edge.length)[2]/40)
pdf("./fishbase_srdb_two_panel_phylo.pdf", width=10, height=6)
par(mfrow=c(1,2), mar=c(0,0,0,0))
## Fishbase
plot(fishbase.phylo, type="r", edge.width=fishbase.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=FALSE, use.edge.length = FALSE, edge.col=grey(0.5))
legend("topleft", legend="FishBase", bty="n", cex=1.2)
## srdb
plot(srdb.phylo, type="r", edge.width=srdb.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=FALSE, use.edge.length = FALSE, edge.col=grey(0.5), edge.lty=ifelse(srdb.phylo$sqrt.edge.length>0,1,0))
legend("topleft", legend="SRDB", bty="n", cex=1.2)
dev.off()

system("xpdf ./fishbase_srdb_two_panel_phylo.pdf")

##---------------------------------------------------
## small sample testing -four panels (A,B,C,D)
##---------------------------------------------------
source("./maintain_branching_phylo_formula.R")
n.sample.A<-100
index.A<-sample(seq(1,length(taxo.dat.fishbase[,1])),size=n.sample.A)
A.dat<-taxo.dat.fishbase[index.A,]

## subsample B
n.sample.B<-floor(0.3*length(A.dat[,1]))
index.B<-sample(seq(1,length(A.dat[,1])),size=n.sample.B)
B.dat<-A.dat[index.B,]

## subsample C
n.sample.C<-floor(0.3*length(B.dat[,1]))
index.C<-sample(seq(1,length(B.dat[,1])),size=n.sample.C)
C.dat<-B.dat[index.C,]

A.B.phylos<-maintain.branching.phylo.formula(~Class/Order/Family/Genus/scientificname, data1=A.dat, data2=B.dat)
A.phylo<-A.B.phylos[[1]]
A.phylo$sqrt.edge.length<-sqrt(A.phylo$edge.length)
B1.phylo<-A.B.phylos[[2]]
B1.phylo$sqrt.edge.length<-sqrt(B1.phylo$edge.length)

B.C.phylos<-maintain.branching.phylo.formula(~Class/Order/Family/Genus/scientificname, data1=B.dat, data2=C.dat)
B2.phylo<-B.C.phylos[[1]]
B2.phylo$sqrt.edge.length<-sqrt(B2.phylo$edge.length)
C.phylo<-B.C.phylos[[2]]
C.phylo$sqrt.edge.length<-sqrt(C.phylo$edge.length)

pdf("./four_panel_phylo.pdf", width=10, height=10)
par(mfrow=c(2,2), mar=c(0,0,0,0))
## A
plot(A.phylo, type="r", edge.width=A.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=TRUE, use.edge.length = FALSE, edge.col=grey(0.5))
legend("topleft", legend="FishBase", bty="n", cex=1.2)
## B1
plot(B1.phylo, type="r", edge.width=B1.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=TRUE, use.edge.length = FALSE, edge.col=grey(0.5), edge.lty=ifelse(B1.phylo$sqrt.edge.length>0,1,0))
legend("topleft", legend="SAUP Catch", bty="n", cex=1.2)
## B2
plot(B2.phylo, type="r", edge.width=B2.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=TRUE, use.edge.length = FALSE, edge.col=grey(0.5))
legend("topleft", legend="SAUP Catch", bty="n", cex=1.2)
## B
plot(C.phylo, type="r", edge.width=C.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=TRUE, use.edge.length = FALSE, edge.col=grey(0.5), edge.lty=ifelse(C.phylo$sqrt.edge.length>0,1,0))
legend("topleft", legend="SRDB", bty="n", cex=1.2)
dev.off()

system("xpdf ./four_panel_phylo.pdf")

##system("gs ./outer_inner_phylo.ps")


## dendogram for test
test.phylo<-as.phylo(~Class/Order/Family/Genus/scientificname, data=test.dat)
test.2.phylo<-my.as.phylo.formula(~Class/Order/Family/Genus/scientificname, data=test.dat)
## sqrt for plotting
test.2.phylo$sqrt.edge.length<-sqrt(test.2.phylo$edge.length+0.1)
##test.2.phylo$log.edge.length<-log(test.2.phylo$edge.length+0.1)

prelim.tip.labels<-rep("", length(test.phylo$tip.label))

for(i in 2:length(prelim.tip.labels)){
  print(i)
  if(test.phylo$tip.label[i]!=test.phylo$tip.label[i-1]){
    prelim.tip.labels[i]<-test.phylo$tip.label[i]
  }
}

test.phylo$tip.label<-prelim.tip.labels



plot(test.phylo, type="r", edge.width=test.2.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=TRUE, edge.col=c(my.opaque.grey,my.opaque.grey, rep(grey(0.5), length(test.2.phylo$sqrt.edge.length-2))))


test.sub.phylo<-as.phylo(~Class/Order/Family/Genus/scientificname, data=test.sub.dat)
test.sub.2.phylo<-my.as.phylo.formula(~Class/Order/Family/Genus/scientificname, data=test.sub.dat)
## sqrt for plotting
test.sub.2.phylo$sqrt.edge.length<-sqrt(test.sub.2.phylo$edge.length+0.1)
##test.sub.2.phylo$log.edge.length<-log(test.sub.2.phylo$edge.length+0.1)

prelim.tip.labels<-rep("", length(test.sub.phylo$tip.label))

for(i in 2:length(prelim.tip.labels)){
  print(i)
  if(test.sub.phylo$tip.label[i]!=test.sub.phylo$tip.label[i-1]){
    prelim.tip.labels[i]<-test.sub.phylo$tip.label[i]
  }
}

test.sub.phylo$tip.label<-prelim.tip.labels

plot(test.sub.phylo, type="r", edge.width=test.sub.2.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=TRUE, edge.col=c(my.opaque.grey,my.opaque.grey, rep(grey(0.5), length(test.sub.2.phylo$sqrt.edge.length-2))))

dev.off()

system("xpdf ./taxo_test.pdf")

data1<-test.dat
data2<-test.sub.dat
