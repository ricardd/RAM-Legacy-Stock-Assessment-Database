##-----------------------------------------------------------------------------
## plot a taxonomy tree for all species in WoRMS
## DR, CM
## date: Fri Dec  9 15:47:22 AST 2009
## Last modified Time-stamp: <2009-12-10 11:33:10 (srdbadmin)>
## Modification history: WoRMS data has holes in the matrix, i.e. some species are not assigned to a family, etc., so I'm brute-force removing NAs from the data prior to using "as.phylo"
##-----------------------------------------------------------------------------

require(RODBC); require(ape); require(gsubfn); require(IDPmisc)
## open a channel to the database
mychan<-odbcConnect(dsn="obisdbcalo") # note how the DSN is used here

taxo.qu<-paste("select tu_displayname as scientificname, 
flattaxonomy.r10 as kingdom, 
flattaxonomy.r30 as phylum, 
flattaxonomy.r60 as classname, 
flattaxonomy.r100 as ordername,
flattaxonomy.r140 as family,
flattaxonomy.r180 as genus
from obis.flattaxonomy
where tu_id in (select worms_id from obis.cleannames inner join obis.tu on worms_id=id
                        where tu_sp like '#2#%' and tu_rank=220)")


taxo.dat.worms<-sqlQuery(mychan, taxo.qu)
## order by scientificname
taxo.dat.worms<-taxo.dat.worms[order(taxo.dat.worms$scientificname),]
## remove NA values
taxo.dat.worms<-na.omit(taxo.dat.worms)



## regular tree
taxo.phylo.worms<-as.phylo(~phylum/classname/ordername/family/genus/scientificname, data=taxo.dat.worms)
## take a look at the contents using taxo.phylo[]
## edge width/length inclusion
##taxo.2.phylo.worms<-my.as.phylo.formula(~phylum/classname/ordername/family/genus/scientificname, data=taxo.dat.worms)
taxo.2.phylo.worms<-my.as.phylo.formula(~phylum/classname/ordername/family, data=taxo.dat.worms)


## sqrt for plotting
taxo.2.phylo.worms$sqrt.edge.length<-sqrt(taxo.2.phylo.worms$edge.length+0.1)

prelim.tip.labels<-rep("", length(taxo.phylo.worms$tip.label))

for(i in 2:length(prelim.tip.labels)){
  print(i)
  if(taxo.phylo.worms$tip.label[i]!=taxo.phylo.worms$tip.label[i-1]){
    prelim.tip.labels[i]<-taxo.phylo.worms$tip.label[i]
  }
}

taxo.phylo.worms$tip.label<-prelim.tip.labels

pdf("./taxonomic_coverage_WoRMS.pdf", width=10, height=10)
#png("./taxonomic_coverage_WoRMS.png", width=1500, height=1500)

my.opaque.grey<-"#80808099"
plot(taxo.phylo.worms, type="r", edge.width=taxo.2.phylo.worms$sqrt.edge.length, no.margin = TRUE, cex=0.5, root.edge=TRUE, show.tip.label=TRUE, edge.col=c(my.opaque.grey,my.opaque.grey, rep(grey(0.5), length(taxo.2.phylo.worms$sqrt.edge.length-2))))
points(0,0, col=1, pch=21, bg="darkgrey", cex=3)
my.cex=0.75


dev.off()

#system("xpdf ./taxonomic_coverage_byLME.pdf")



odbcClose(mychan)

