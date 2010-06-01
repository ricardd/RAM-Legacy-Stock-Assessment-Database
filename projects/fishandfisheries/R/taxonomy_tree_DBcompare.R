## generate a multi-panel figure showing the taxonomic coverage of different databases (hypothetical for now, to be applied to DFO data)
## DR
## Time-stamp: <2009-12-17 11:44:30 (srdbadmin)>
## 
require(RODBC); require(ape); require(gsubfn); require(IDPmisc)

source("maintain_branching_phylo_formula.R")

taxo.dat.fishbase <- read.table("fishbase-DendroRAM-FROMRAINER.csv", sep=",", header=TRUE)
taxo.dat.fishbase$scientificname <- as.factor(paste(taxo.dat.fishbase$Genus, taxo.dat.fishbase$Species, sep=" "))
taxo.dat.fishbase<-taxo.dat.fishbase[rep(seq(1, length(taxo.dat.fishbase[,1])), times=taxo.dat.fishbase$LME),]

# a sample of 10% of species from fishbase as the base case
n.sample<-floor(0.1*length(taxo.dat.fishbase[,1]))
index<-sample(seq(1,length(taxo.dat.fishbase[,1])),size=n.sample)
taxo.dat.base<-taxo.dat.fishbase[index,]

# simulate 3 different databases each containing a 30% sample of the previous sample
n.sample<-floor(0.3*length(taxo.dat.base[,1]))
index<-sample(seq(1,length(taxo.dat.base[,1])),size=n.sample)
taxo.dat.DB1<-taxo.dat.base[index,]

n.sample<-floor(0.3*length(taxo.dat.base[,1]))
index<-sample(seq(1,length(taxo.dat.base[,1])),size=n.sample)
taxo.dat.DB2<-taxo.dat.base[index,]

n.sample<-floor(0.3*length(taxo.dat.base[,1]))
index<-sample(seq(1,length(taxo.dat.base[,1])),size=n.sample)
taxo.dat.DB3<-taxo.dat.base[index,]


A.B.phylos<-maintain.branching.phylo.formula(~Class/Order/Family/Genus/scientificname, data1=taxo.dat.base, data2=taxo.dat.DB1)
A.phylo<-A.B.phylos[[1]]
A.phylo$sqrt.edge.length<-sqrt(A.phylo$edge.length)
B1.phylo<-A.B.phylos[[2]]
B1.phylo$sqrt.edge.length<-sqrt(B1.phylo$edge.length)

A.C.phylos<-maintain.branching.phylo.formula(~Class/Order/Family/Genus/scientificname, data1=taxo.dat.base, data2=taxo.dat.DB2)
C1.phylo<-A.C.phylos[[2]]
C1.phylo$sqrt.edge.length<-sqrt(C1.phylo$edge.length)

A.D.phylos<-maintain.branching.phylo.formula(~Class/Order/Family/Genus/scientificname, data1=taxo.dat.base, data2=taxo.dat.DB3)
D1.phylo<-A.D.phylos[[2]]
D1.phylo$sqrt.edge.length<-sqrt(D1.phylo$edge.length)


pdf("taxonomic_coverage_DBcompare.pdf", height=11, width = 11/1.6)
par(mfrow=c(4,1), mar=c(0,0,0,0))

plot(A.phylo, type="r", edge.width=A.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=TRUE, use.edge.length = FALSE, edge.col=grey(0.5))
legend("topleft", legend="Base", bty="n", cex=1.2)

plot(B1.phylo, type="r", edge.width=B1.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=TRUE, use.edge.length = FALSE, edge.col=grey(0.5))
legend("topleft", legend="Database A", bty="n", cex=1.2)

plot(C1.phylo, type="r", edge.width=C1.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=TRUE, use.edge.length = FALSE, edge.col=grey(0.5))
legend("topleft", legend="Database B", bty="n", cex=1.2)


plot(D1.phylo, type="r", edge.width=D1.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=TRUE, use.edge.length = FALSE, edge.col=grey(0.5))
legend("topleft", legend="Database C", bty="n", cex=1.2)

dev.off()
system("xpdf taxonomic_coverage_DBcompare.pdf")
