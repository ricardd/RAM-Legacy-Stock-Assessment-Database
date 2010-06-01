my.as.phylo.formula<-
function (x, data = parent.frame(), ...) 
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
    string <- paste("(", paste(f.rec(taxo.data), collapse = ","), ")",":",dim(taxo.data)[1],";", sep = "")
     ## ammended CM, Dec 6th 2009
    string2<-gsubfn("(?<=[\\,,\\(])[0-9]+", function(x){paste(strapply(x, "[0-9]+")[[1]], ":1", sep="")}, string, backref=1, perl=TRUE)
    phy <- read.tree(text = string2)
    phy$tip.label <- leaves.names[as.numeric(phy$tip.label)]
    phy.names.df<-data.frame(number=as.numeric(phy$tip.label), name.phy.1=leaves.names[as.numeric(phy$tip.label)])
    phy.names.df<-phy.names.df[order(phy.names.df$number),]
    return(phy)
  }

##--------------------------
## SANDBOX
##--------------------------

##test.vec<-seq(1,20)
##test.sub.vec<-sample(test.vec,10)
##sapply(test.vec, function(x){x%in%test.sub.vec})
