##-----------------------------------------------------------------------------
## plot a taxonomy tree for srdb with the width of the lines proportional
## to the number of assessments
## DR, CM
## date: Fri Dec  4 15:47:22 AST 2009
## Time-stamp: <2010-07-15 05:14:51 (mintoc)>
##-----------------------------------------------------------------------------

require(RODBC); require(ape); require(gsubfn); require(IDPmisc)
## open a channel to the database
mychan<-odbcConnect(dsn="srdbusercalo") # note how the DSN is used here

##taxo.qu<-paste("select * from srdb.taxonomy as aa, (select tsn from srdb.stock where stockid in (select stockid from srdb.assessment where assessid not like '%MYERS%')) as bb where aa.tsn=bb.tsn;")
taxo.qu<-paste("select * from srdb.taxonomy as aa, (select tsn from srdb.stock where stockid in (select stockid from srdb.assessment where assessid not like '%MYERS%')) as bb where aa.tsn=bb.tsn;")

taxo.dat<-sqlQuery(mychan, taxo.qu)
taxo.dat<-taxo.dat[order(taxo.dat$scientificname),]
## output this data for Coilin
## write.table(taxo.dat, "./taxo_dat.csv", row.names=FALSE, sep=",")
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

pdf("./taxonomic_coverage.pdf", width=10, height=10)
my.opaque.grey<-"#80808099"
par(bg="white")
plot(taxo.phylo, type="r", edge.width=taxo.2.phylo$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=TRUE, edge.col=c(my.opaque.grey,my.opaque.grey, rep(grey(0.5), length(taxo.2.phylo$sqrt.edge.length-2))))
points(0,0, col=1, pch=21, bg="darkgrey", cex=3)
my.cex=0.75
text(0.7,-0.27, labels="Arthropoda", srt=335, cex=my.cex, font=2)
text(0.85,-0.01, labels="Mollusca", srt=360, cex=my.cex, font=2)
text(0.55,-0.55, labels="Chondrichtyes", srt=322.5, cex=my.cex)
text(0.19,-0.6, labels="Gadiformes", srt=295, cex=my.cex)
text(-0.57,-0.2, labels="Pleuronectiformes", srt=32, cex=my.cex)
text(-0.57,0.44, labels="Clupeiformes", srt=318, cex=my.cex)
text(0.08,0.68, labels="Scorpaeniformes", srt=69, cex=my.cex)
text(0.47,0.51, labels="Perciformes", srt=38, cex=my.cex)
text(-0.33,-0.38, labels="Actinopterygii", srt=63, cex=my.cex)
Arrows(-0.27,-0.27,-0.13,0.0, open=FALSE, size=0.5)
text(-0.19,-0.4, labels="Chordata", srt=66, cex=my.cex, font=2)
Arrows(-0.145,-0.31,-0.06,-0.12, open=FALSE, size=0.5)
dev.off()

system("xpdf ./taxonomic_coverage.pdf")

##--------------
## SANDBOX
##--------------
##test.dat<-taxo.dat[taxo.dat$phylum=="Mollusca" | taxo.dat$phylum=="Arthropoda",c("phylum","classname","ordername", "family", "genus")]
test.dat<-taxo.dat[taxo.dat$phylum=="Chordata",c("phylum","classname","ordername", "family", "genus")]
test.dat<-test.dat[order(test.dat$genus),]

##test.phylo<-as.phylo.formula(~phylum/classname/ordername/family/genus, data=test.dat)
test.phylo<-as.phylo.formula(~classname/ordername/family/genus, data=test.dat)
test2.phylo<-my.as.phylo.formula(~phylum/classname/ordername/family/genus, data=test.dat)
plot(test.phylo, edge.width=test2.phylo$edge.length, type="p")


test.df<-data.frame(phylum.n=NA, class.n=NA, order.n=NA, family.n=NA, genus.n=NA, genus=as.character(taxo.phylo$tip.label))

for(i in 1:length(test.df[,1])){
  print(i)
  my.genus<-as.character(test.df$genus[i])
  my.family<-unique(test.dat$family[test.dat$genus==my.genus])
  my.order<-unique(test.dat$ordername[test.dat$genus==my.genus])
  my.class<-unique(test.dat$classname[test.dat$genus==my.genus])
  my.phylum<-unique(test.dat$phylum[test.dat$genus==my.genus])
  test.df [i,"genus.n"]<-length(test.dat$genus[test.dat$genus==my.genus])
  test.df [i,"family.n"]<-length(test.dat$family[test.dat$family==my.family])
  test.df [i,"order.n"]<-length(test.dat$ordername[test.dat$ordername==my.order])
  test.df [i,"class.n"]<-length(test.dat$classname[test.dat$classname==my.class])
  test.df [i,"phylum.n"]<-length(test.dat$phylum[test.dat$phylum==my.phylum])
}

## "((1,(2,3),6,(8,9,11),(10,13,14),12,15,17),((4,5),7,16));"

test.new<-read.tree(text="(B:6.0,(A:5.0,C:3.0,E:4.0):5.0,D:11.0);")

edge.length.vec<-rep(1,dim(test.phylo$edge)[1])
edge.length.vec[c(2,3)]<-test.df[1,1]

plot(test.phylo, type="c", cex=1, edge.width=edge.length.vec)


lines(c(0, taxo.phylo$edge[2,1]),c(75, taxo.phylo$edge[2,2]), col="red")

data(carnivora)
plot(as.phylo(~SuperFamily/Family/Genus/Species, data=carnivora))

plot(bird.orders, edge.width = sample(1:10, length(bird.orders$edge)/2, replace = TRUE))


odbcClose(mychan)

