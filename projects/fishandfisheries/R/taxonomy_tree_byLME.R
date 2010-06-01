##-----------------------------------------------------------------------------
## plot a taxonomy tree for srdb with the width of the lines proportional
## to the number of assessments
## DR, CM
## date: Fri Dec  4 15:47:22 AST 2009
## Last modified Time-stamp: <2010-04-13 15:15:34 (srdbadmin)>
##-----------------------------------------------------------------------------

require(RODBC); require(ape); require(gsubfn); require(IDPmisc)
## open a channel to the database
mychan<-odbcConnect(dsn="srdbusercalo") # note how the DSN is used here

##taxo.qu<-paste("select * from srdb.taxonomy as aa, (select tsn from srdb.stock where stockid in (select stockid from srdb.assessment where assessid not like '%MYERS%')) as bb where aa.tsn=bb.tsn;")
##taxo.qu<-paste("select * from srdb.taxonomy as aa, (select tsn from srdb.stock where stockid in (select stockid from srdb.assessment where assessid not like '%MYERS%' and assess=1)) as bb where aa.tsn=bb.tsn")
taxo.qu<-paste("select t.tsn, t.kingdom, t.phylum, t.classname, t.ordername, t.family, t.genus, t.species, t.scientificname, foo.lme_number, count(*) from srdb.stock s, srdb.taxonomy t, (select stockid, lme_number from srdb.lmetostocks where stocktolmerelation = 'primary' and stockid in (select distinct stockid from srdb.assessment where recorder != 'MYERS')) as foo where foo.stockid=s.stockid and s.tsn=t.tsn group by t.tsn, t.kingdom, t.phylum, t.classname, t.ordername, t.family, t.genus, t.species, t.scientificname, lme_number order by t.tsn, lme_number")


taxo.dat<-sqlQuery(mychan, taxo.qu)
taxo.dat<-taxo.dat[order(taxo.dat$scientificname),]
##taxo.dat[length(taxo.dat[,1]),]<-NA

##levels(taxo.dat[length(taxo.dat[,1]),"kingdom"])<-as.factor(c("Animalia","1"))
##taxo.dat[length(taxo.dat[,1]),"kingdom"]<-"1"
## to run the phylogram with edge widths proportional to the number of assessments
## we need to hiack the newick formulation for edge length
## and then pass this as an argument to the plot, e.g.

## regular tree
taxo.phylo<-as.phylo(~phylum/classname/ordername/family/genus/scientificname, data=taxo.dat)
## take a look at the contents using taxo.phylo[]
## edge width/length inclusion
taxo.2.phylo<-my.as.phylo.formula(~phylum/classname/ordername/family/genus/scientificname, data=taxo.dat)
##taxo.phylo$root.edge<-taxo.2.phylo$root.edge

## sqrt for plotting
taxo.2.phylo$sqrt.edge.length<-sqrt(taxo.2.phylo$edge.length+0.1)
##taxo.2.phylo$log.edge.length<-log(taxo.2.phylo$edge.length+0.1)

##

prelim.tip.labels<-rep("", length(taxo.phylo$tip.label))

for(i in 2:length(prelim.tip.labels)){
  print(i)
  if(taxo.phylo$tip.label[i]!=taxo.phylo$tip.label[i-1]){
    prelim.tip.labels[i]<-taxo.phylo$tip.label[i]
  }
}

taxo.phylo$tip.label<-prelim.tip.labels

#pdf("./taxonomic_coverage_byLME.pdf", width=10, height=10)
png("./taxonomic_coverage_byLME.png", width=1500, height=1500)

my.opaque.grey<-"#80808099"
plot(taxo.phylo, type="r", edge.width=taxo.2.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=TRUE, edge.col=c(my.opaque.grey,my.opaque.grey, rep(grey(0.5), length(taxo.2.phylo$sqrt.edge.length-2))))
points(0,0, col=1, pch=21, bg="darkgrey", cex=3)
my.cex=0.75
text(0.7,-0.17, labels="Arthropoda", srt=343.5, cex=my.cex, font=2)
text(0.85,-0.01, labels="Mollusca", srt=360, cex=my.cex, font=2)
text(0.55,-0.34, labels="Chondrichtyes", srt=332, cex=my.cex)
text(0.16,-0.45, labels="Gadiformes", srt=302, cex=my.cex)
text(-0.32,-0.28, labels="Pleuronectiformes", srt=53, cex=my.cex)
text(-0.55,0.09, labels="Clupeiformes", srt=350, cex=my.cex)
text(-0.18,0.5, labels="Scorpaeniformes", srt=276, cex=my.cex)
text(0.24,0.47, labels="Perciformes", srt=50, cex=my.cex)
text(0.2,0.1, labels="Animalia", srt=0, cex=1, font=2)
Arrows(0.08,0.1,0.015,0.04, open=FALSE, size=0.5)
text(-0.38,0.35, labels="Actinopterygii", srt=0, cex=my.cex)
Arrows(-0.37,0.31,-0.10,-0.02, open=FALSE, size=0.5)
text(0.22,-0.12, labels="Chordata", srt=343, cex=my.cex, font=2)
Arrows(0.12,-0.09,0.01,-0.09, open=FALSE, size=0.5)
dev.off()

#system("xpdf ./taxonomic_coverage_byLME.pdf")



odbcClose(mychan)

