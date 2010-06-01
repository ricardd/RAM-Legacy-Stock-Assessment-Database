# TSNs_calls.R
# calls to TSN function to create a file with taxonomic hierarchy
# Daniel Ricard

source("TSNs_fct.R")

in.nmfs.tsn <- read.table("/home/ricardd/linux_sync_folder/SQL/SQLpg/srDB/srDB/data/fogarty_tsn.dat", header=TRUE, sep=",", na.string="")

# tsn.tax.tree.fct



# t(sapply(in.nmfs.tsn$TSN, tsn.tax.tree.fct))

n <- length(in.nmfs.tsn[,1])
my.overall <- data.frame(tsn=rep('blah',n), sciname=rep('blah',n), kingdom=rep('blah',n), phylum=rep('blah',n), classname=rep('blah',n), ordername=rep('blah',n), family=rep('blah',n), genus=rep('blah',n), species=rep('blah',n), myersname=rep('blah',n), com1=rep('blah',n), com2=rep('blah',n), ms=rep('blah',n), mf=rep('blah',n), stringsAsFactors=FALSE)

for(i in 1:n) {
tax.hierarchy <- tsn.tax.tree.fct(in.nmfs.tsn$TSN[i])

tt <- data.frame(tsn=in.nmfs.tsn$TSN[i], sciname=tax.hierarchy$sciname, kingdom=tax.hierarchy$kingdom, phylum=tax.hierarchy$phylum, classname=tax.hierarchy$class, ordername=tax.hierarchy$order, family=tax.hierarchy$family, genus=tax.hierarchy$genus, species=unlist(strsplit(tax.hierarchy$sciname, " "))[2], myersname=as.character(in.nmfs.tsn$myersname[i]), com1=as.character(in.nmfs.tsn$Fogarty_name[i]), com2=as.character(in.nmfs.tsn$other_name[i]), ms=paste('NULL'), mf=paste('NULL'), stringsAsFactors=FALSE)
print(tt)
my.overall[i,] <- tt
}



write.table(my.overall, "/home/ricardd/linux_sync_folder/SQL/SQLpg/srDB/srDB/data/fogarty_tsn_hierarchy.dat", row.names=FALSE, sep=",", na="NULL", quote=FALSE)
