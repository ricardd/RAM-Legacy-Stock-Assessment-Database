##-----------------------------------------------------------------------------
## plot a taxonomy tree for all orders in FishBase
## DR, CM
## date: Fri Dec  9 15:47:22 AST 2009
## Last modified Time-stamp: <2009-12-10 13:10:07 (srdbadmin)>
##-----------------------------------------------------------------------------

require(RODBC); require(ape); require(gsubfn); require(IDPmisc); require(doBy)
## load csv file from Rainer Froese
taxo.dat.fishbase <- read.table("fishbase-DendroRAM-FROMRAINER.csv", sep=",", header=TRUE)
taxo.dat.fishbase$scientificname <- as.factor(paste(taxo.dat.fishbase$Genus, taxo.dat.fishbase$Species, sep=" "))

taxo.dat.fishbase <- taxo.dat.fishbase[order(taxo.dat.fishbase$scientificname),]
## expand out the species row entries to be equal to the value of LME column
expanded.taxo.dat.fishbase<-taxo.dat.fishbase[rep(1:nrow(taxo.dat.fishbase), times=taxo.dat.fishbase$LME), ]

## get the counts by order
order.dat.fishbase<-summaryBy(Family~Class+Order, data=expanded.taxo.dat.fishbase, FUN=c(length))
taxo.phylo.fishbase<-as.phylo(~Class/Order, data=order.dat.fishbase)
## use the ammended version here
taxo.2.phylo.fishbase<-by.order.as.phylo.formula(~Class/Order, data=order.dat.fishbase)
## scale the branch widths
taxo.2.phylo.fishbase$div.edge.length<-taxo.2.phylo.fishbase$edge.length/(range(taxo.2.phylo.fishbase$edge.length)[2]/20)

## assign tip labels, again because they might be changed below
taxo.phylo.fishbase$tip.label<-taxo.2.phylo.fishbase$tip.label

## get the percentage in each order
percentage.by.order<-round(100*as.numeric(sapply(taxo.phylo.fishbase$tip.label, function(z){order.dat.fishbase$Family.length[order.dat.fishbase$Order==z]}))/sum(order.dat.fishbase$Family.length),2)
taxo.phylo.fishbase$tip.label<-paste(taxo.phylo.fishbase$tip.label,paste("(",percentage.by.order,")", sep=""), sep="\n")
## get the percentage in each class (smaller classes only have one order already represented)
percent.actinopterygii<-round(100*sum(order.dat.fishbase$Family.length[order.dat.fishbase$Class=="Actinopterygii (ray-finned fishes)"])/sum(order.dat.fishbase$Family.length),2)
percent.elasmobranchii<-round(100*sum(order.dat.fishbase$Family.length[order.dat.fishbase$Class=="Elasmobranchii (sharks and rays)"])/sum(order.dat.fishbase$Family.length),2)

## pdf output
pdf("./by_order_taxonomic_coverage_FishBase.pdf", width=10, height=10)
plot(taxo.phylo.fishbase, type="r", no.margin = TRUE, cex=0.8, root.edge=TRUE, show.tip.label=TRUE,
     edge.width=taxo.2.phylo.fishbase$div.edge.length, label.offset=0.5, srt=0, adj=0)
points(0,0, col=1, pch=21, bg="darkgrey", cex=3)
text(0.15,0.1,labels=paste("Actinopterygii",paste("(",percent.actinopterygii,")", sep=""), sep="\n"))
text(0.5,-0.4,labels=paste("Elasmobranchii",paste("(",percent.elasmobranchii,")", sep=""), sep="\n"))
dev.off()

system("xpdf ./by_order_taxonomic_coverage_FishBase.pdf")
 

