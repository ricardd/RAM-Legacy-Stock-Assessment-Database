my.tree.build<-
function (tp) 
{
    add.internal <- function() {
        edge[j, 1] <<- current.node
        edge[j, 2] <<- current.node <<- node <<- node + 1L
        j <<- j + 1L
    }
    add.terminal <- function() {
        edge[j, 1] <<- current.node
        edge[j, 2] <<- tip
        X <- unlist(strsplit(tpc[k], ":"))
        tip.label[tip] <<- X[1]
        edge.length[j] <<- as.numeric(X[2])
        k <<- k + 1L
        tip <<- tip + 1L
        j <<- j + 1L
    }
    go.down <- function() {
        l <- which(edge[, 2] == current.node)
        X <- unlist(strsplit(tpc[k], ":"))
        node.label[current.node - nb.tip] <<- X[1]
        print(current.node)
        edge.length[l] <<- as.numeric(X[2])
        k <<- k + 1L
        current.node <<- edge[l, 1]
    }
    if (!length(grep(",", tp))) {
        obj <- list(edge = matrix(c(2L, 1L), 1, 2))
        tp <- unlist(strsplit(tp, "[\\(\\):;]"))
        obj$edge.length <- as.numeric(tp[3])
        obj$Nnode <- 1L
        obj$tip.label <- tp[2]
        if (length(tp) == 4) 
            obj$node.label <- tp[4]
        class(obj) <- "phylo"
        return(obj)
    }
    tpc <- unlist(strsplit(tp, "[\\(\\),;]"))
    tpc <- tpc[nzchar(tpc)]
    tsp <- unlist(strsplit(tp, NULL))
    skeleton <- tsp[tsp %in% c("(", ")", ",", ";")]
    nsk <- length(skeleton)
    nb.node <- sum(skeleton == ")")
    nb.tip <- sum(skeleton == ",") + 1
    nb.edge <- nb.node + nb.tip
    node.label <- character(nb.node)
    tip.label <- character(nb.tip)
    edge.length <- numeric(nb.edge)
    edge <- matrix(0L, nb.edge, 2)
    current.node <- node <- as.integer(nb.tip + 1)
    edge[nb.edge, 2] <- node
    j <- k <- tip <- 1L
    for (i in 2:nsk) {
        if (skeleton[i] == "(") 
            add.internal()
        if (skeleton[i] == ",") {
            if (skeleton[i - 1] != ")") 
                add.terminal()
        }
        if (skeleton[i] == ")") {
            if (skeleton[i - 1] == ",") {
                add.terminal()
                go.down()
            }
            if (skeleton[i - 1] == ")") 
                go.down()
        }
    }
    edge <- edge[-nb.edge, ]
    obj <- list(edge = edge, Nnode = nb.node, tip.label = tip.label)
    root.edge <- edge.length[nb.edge]
    edge.length <- edge.length[-nb.edge]
    if (!all(is.na(edge.length))) 
        obj$edge.length <- edge.length
    if (is.na(node.label[1])) 
        node.label[1] <- ""
    if (any(nzchar(node.label))) 
        obj$node.label <- node.label
    if (!is.na(root.edge)) 
        obj$root.edge <- root.edge
    class(obj) <- "phylo"
    obj
}
