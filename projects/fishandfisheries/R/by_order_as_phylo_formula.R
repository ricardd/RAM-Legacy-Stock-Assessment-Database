by.order.as.phylo.formula<-
function (x, data) # = parent.frame(), ...) 
{
    err <- "Formula must be of the kind \"~A1/A2/.../An\"."
    if (length(x) != 2) 
        stop(err)
    if (x[[1]] != "~") 
        stop(err)
    f <- x[[2]]
    taxo <- list()
    while (length(f) == 3) {
        if (f[[1]] != "/") 
            stop(err)
        if (!is.factor(data[[deparse(f[[3]])]])) 
            stop(paste("Variable", deparse(f[[3]]), "must be a factor."))
        taxo[[deparse(f[[3]])]] <- data[[deparse(f[[3]])]]
        if (length(f) > 1) 
            f <- f[[2]]
      }
    if (!is.factor(data[[deparse(f)]])) 
        stop(paste("Variable", deparse(f), "must be a factor."))
    taxo[[deparse(f)]] <- data[[deparse(f)]]
    taxo.data <- as.data.frame(taxo)
    leaves.names <- as.character(taxo.data[, 1])
    taxo.data[, 1] <- 1:nrow(taxo.data)
    ##-------------------------------
    ## First run a typical phylogeny
    ##-------------------------------
    f.rec.1 <- function(subtaxo) {
        u <- ncol(subtaxo)
        levels <- unique(subtaxo[, u])
        if (u == 1) {
            if (length(levels) != nrow(subtaxo)) 
                warning("Error, leaves names are not unique.")
            return(as.character(subtaxo[, 1]))
        }
        t <- character(length(levels))
        for (l in 1:length(levels)) {
            x <- f.rec(subtaxo[subtaxo[, u] == levels[l], ][1:(u - 
                1)])
            if (length(x) == 1) 
                t[l] <- x
            else t[l] <- paste("(", paste(x, collapse = ","), 
                ")", sep = "")
        }
        return(t)
    }
    string <- paste("(", paste(f.rec.1(taxo.data), collapse = ","),");", sep = "")
    phy <- read.tree(text = string)
    ## Find out the number of times each order is present
    order.names.df<-data.frame(number=phy$tip.label, names.phy.1=leaves.names[as.numeric(phy$tip.label)])
    order.names.df$count<-sapply(seq(1, length(order.names.df[,1])), function(y){data$Family.length[data$Order==order.names.df$names.phy.1[y]]})
    phy$tip.label <- leaves.names[as.numeric(phy$tip.label)]
    ## CM 15/05/2010
    phy.names.df<-data.frame(number=as.numeric(phy$tip.label), name.phy.1=leaves.names[as.numeric(phy$tip.label)])
    phy.names.df<-phy.names.df[order(phy.names.df$number),]

    f.rec.2 <- function(subtaxo) {
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
            if (length(x) == 1){
              x1<-gsubfn("[0-9]+", function(x){
                paste(strapply(x, "[0-9]+")[[1]], ":", order.names.df$count[phy.names.df$number%in%x], sep="")
                                   }, x, backref=1, perl=TRUE)
              t[l] <- x1
               ##t[l] <- paste(x,":", 1, sep="")
            }else{
              ##count.elements<-order.names.df$count[phy.names.df$number%in%as.numeric(unlist(strapply(x, "[0-9]+", backref=1, perl=TRUE)))] ## ammended CM, Dec 23rd 2009              
              x1<-gsubfn("[0-9]+", function(x){
                paste(strapply(x, "[0-9]+")[[1]], ":", order.names.df$count[phy.names.df$number%in%x], sep="")
                                   }, x, backref=1, perl=TRUE)
              total.count.x<-sum(as.numeric(unlist(strapply(unlist(strapply(x1,":[0-9]+", perl=TRUE)),"[0-9]+"))))
              t[l] <- paste("(", paste(x1, collapse = ","),")",":",total.count.x, sep = "") ## ammended CM, Dec 6th 2009
              ##t[l] <- paste("(", paste(x1, collapse = ","),")", sep = "") ## ammended CM, Dec 6th 2009
              ##n.elements<-length(unlist(strapply(x, "(?<![:0-9])[0-9]+", backref=1, perl=TRUE))) ## ammended CM, Dec 6th 2009
              ##t[l] <- paste("(", paste(x, collapse = ","),")",":",n.elements, sep = "") ## ammended CM, Dec 6th 2009
            }
        }
        return(t)
      }
    string <- paste("(", paste(f.rec.2(taxo.data), collapse = ","), ")",":",sum(data$Family.length),";", sep = "")
     ## ammended CM, Dec 23rd 2009
    ##string2<-gsubfn("(?<=[\\,,\\(])[0-9]+", function(x){paste(strapply(x, "[0-9]+")[[1]], ":1", sep="")}, string, backref=1, perl=TRUE)
    string2<-gsubfn("(?<=[\\,,\\(])[0-9]+", function(x){paste(strapply(x, "[0-9]+")[[1]], ":1", sep="")}, string, backref=1, perl=TRUE)
    phy <- read.tree(text = string)
    phy$tip.label <- leaves.names[as.numeric(phy$tip.label)]
    ## CM 15/05/2010
    ##phy.names.df<-data.frame(number=as.numeric(phy$tip.label), name.phy.1=leaves.names[as.numeric(phy$tip.label)])
    ##phy.names.df<-phy.names.df[order(phy.names.df$number),]
    return(phy)
}
