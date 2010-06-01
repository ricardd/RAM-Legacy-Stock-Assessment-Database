# code to plot time-dependent circular/corona plots
# most important function is below
# code by Claudio Agostinelli and Ulric Lund
# ammended by Coilín Minto
# date: Thu Nov 20 12:09:57 AST 2008
# Time-stamp: <2008-11-20 18:24:16 (mintoc)>

plot.circular2<-
function (x, pch = 16, cex = 1, stack = FALSE, axes = TRUE, sep = 0.025, col,
    shrink = 1, bins = NULL, ticks = FALSE, tcl = 0.025, tcl.text = 0.125, tol = 0.04, uin = NULL, xlim = c(-1, 1), ylim = c(-1, 
        1), digits = 2, units = NULL, template = NULL, zero = NULL, 
    rotation = NULL, main = "", xlab = "", ylab = "", ...) 
{
    if (is.matrix(x) | is.data.frame(x)) {
        nseries <- ncol(x)
    }   else {
        nseries <- 1
    }
    xx <- as.data.frame(x)
    xcircularp <- attr(as.circular(xx[, 1]), "circularp")
    type <- xcircularp$type
    modulo <- xcircularp$modulo
    if (is.null(units)) 
        units <- xcircularp$units
    if (is.null(template)) 
        template <- xcircularp$template
    if (template == "geographics") {
        zero <- pi/2
        rotation <- "clock"
    } else {
        if (is.null(zero)) 
            zero <- xcircularp$zero
        if (is.null(rotation)) 
            rotation <- xcircularp$rotation
    }
    CirclePlotRad(xlim, ylim, uin, shrink, tol, 1000, main = main, 
        xlab = xlab, ylab = ylab)
    if (is.null(bins)) {
        bins <- NROW(x)
    }
    else {
        bins <- round(bins)
        if (bins <= 0) 
            stop("bins must be non negative")
    }
#      if (is.null(col)) {
#        col <- seq(nseries)
#    }
#    else {
#        if (length(col) != nseries) {
#            col <- col #rep(col, nseries)[1:nseries]
#        }
#    }
#    browser()
    pch <- rep(pch, nseries, length.out = nseries)
    if (axes) {
        axis.circular(units = units, template = template, zero = zero, 
            rotation = rotation, digits = digits, cex = cex, 
            tcl = tcl, tcl.text = tcl.text)
    }
    if (!is.logical(ticks)) 
        stop("ticks must be logical")
    if (ticks) {
        at <- circular((0:bins)/bins * 2 * pi, zero = zero, rotation = rotation)
        ticks.circular(at, tcl = tcl)
    }
    for (iseries in 1:nseries) {
        x <- xx[, iseries]
        x <- na.omit(x)
        n <- length(x)
        if (n) {
            x <- conversion.circular(x, units = "radians")
            attr(x, "circularp") <- attr(x, "class") <- NULL
            if (rotation == "clock") 
                x <- -x
            x <- x + zero
            x <- x%%(2 * pi)
         PointsCircularRad(x, bins, stack, col, pch, iseries,
                nseries, sep, 0, shrink, cex, ...)
        }
    }
    return(invisible(list(zero = zero, rotation = rotation, next.points = nseries * 
        sep)))
  }
#environment(plot.circular2) <- environment(plot.circular)

#~~~~~~~~~~~~~~~~ points.circular ~~~~~~~~~~~~~~~~~~~~~~~~
points.circular2 <- function(x, pch = 16, cex = 1, stack = FALSE, sep = 0.025, shrink=1, bins=NULL, col=NULL, next.points=NULL, plot.info=NULL, zero=NULL, rotation=NULL, ...) {
   if (is.matrix(x) | is.data.frame(x)) {
      nseries <- ncol(x)
   } else {
      nseries <- 1
   }
   xx <- as.data.frame(x)
  
   xcircularp <- attr(as.circular(xx[,1]), "circularp")
   type <- xcircularp$type
   modulo <- xcircularp$modulo
   if (is.null(plot.info)) {
      if (is.null(zero))
         zero <- xcircularp$zero
      if (is.null(rotation))
         rotation <- xcircularp$rotation
      if (is.null(next.points))
         next.points <- 0
   } else {
      zero <- plot.info$zero
      rotation <- plot.info$rotation
      if (is.null(next.points))
         next.points <- plot.info$next.points
   }
        
   if (is.null(bins)) {
      bins <- NROW(x)
   } else {
      bins <- round(bins)
      if (bins<=0)
         stop("bins must be non negative")
   }
   
#   if (is.null(col)) {
#      col <- seq(nseries)
#   } else {
#      if (length(col)!=nseries) {
#         col <- rep(col, nseries)[1:nseries]
#      }
#   }
   pch <- rep(pch, nseries, length.out=nseries)
            
   for (iseries in 1:nseries) {
      x <- xx[,iseries]
      x <- na.omit(x)
      n <- length(x)
      if (n) {
         x <- conversion.circular(x, units="radians")
         attr(x, "circularp") <- attr(x, "class") <- NULL
         if (rotation=="clock")
            x <- -x
         x <- x+zero
         x <- x%%(2*pi)
         PointsCircularRad(x, bins, stack, col, pch, iseries, nseries, sep, next.points, shrink, cex, ...) 
      }
   }
return(invisible(list(zero=zero, rotation=rotation, next.points=next.points+nseries*sep)))
}





# other functions needed

PointsCircularRad <- function(x, bins, stack, col, pch, iseries, nseries, sep, next.points, shrink, cex, ...) {
#### x must in modulo 2pi  
   if (!stack) {
      z <- cos(x)
      y <- sin(x)
      r <- 1+((iseries-1)*sep+next.points)*shrink
#      points.default(z*r, y*r, cex=cex, pch=pch[iseries], col = col[iseries], ...)
      points.default(z*r, y*r, cex=cex, pch=pch, col = col, ...)
   } else {
      arc <- (2 * pi)/bins
      pos.bins <- ((1:nseries)-1/2)*arc/nseries-arc/2
      bins.count <- c(1:bins) # here to understand what's going on
      bins.col <-data.frame(matrix(NA, ncol=10, nrow=bins))# color within bin
      for (i in 1:bins) {
         bins.count[i] <- sum(x <= i * arc & x > (i - 1) * arc)
         #browser()
         #print(c(as.character(length(x[x <= i * arc & x > (i - 1) * arc])),col[x <= i * arc & x > (i - 1) * arc]))
         if(length(x[x <= i * arc & x > (i - 1) * arc])>0){
         bins.col[i,1:length(x[x <= i * arc & x > (i - 1) * arc])]<-col[x <= i * arc & x > (i - 1) * arc]}
       }
      #print(bins.col)
      #print(cbind(bins,bins.count))
      mids <- seq(arc/2, 2 * pi - pi/bins, length = bins) + pos.bins[iseries]
      index <- cex*sep
      for (i in 1:bins) {
         if (bins.count[i] != 0) {
            for (j in 0:(bins.count[i] - 1)) {
               r <- 1 + j * index
               z <- r * cos(mids[i])
               y <- r * sin(mids[i])
#               points.default(z, y, cex=cex, pch=pch[iseries], col=col[iseries], ...)
               # print(cbind(i,j,z,y)) #see indexing structure
               points.default(z, y, cex=cex, pch=pch, col=bins.col[i,][!is.na(bins.col[i,])][j+1], ...)
               #points.default(z, y, cex=cex, pch=pch, col=bins.col[i,][!is.na(bins.col[i,])], ...)
            }
         }
      }
   }
 }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CirclePlotRad <- function(xlim=c(-1,1), ylim=c(-1,1), uin=NULL, shrink=1, tol=0.04, n=1000, ...) {
   xlim <- shrink * xlim
   ylim <- shrink * ylim
   midx <- 0.5 * (xlim[2] + xlim[1])
   xlim <- midx + (1 + tol) * 0.5 * c(-1, 1) * (xlim[2] - xlim[1])
   midy <- 0.5 * (ylim[2] + ylim[1])
   ylim <- midy + (1 + tol) * 0.5 * c(-1, 1) * (ylim[2] - ylim[1])
   oldpin <- par("pin")
   xuin <- oxuin <- oldpin[1]/diff(xlim)
   yuin <- oyuin <- oldpin[2]/diff(ylim)
   if (is.null(uin)) {
      if (yuin > xuin)
         yuin <- xuin
      else
         xuin <- yuin
   } else {
      if (length(uin) == 1)
         uin <- uin * c(1, 1)
      if (any(c(xuin, yuin) < uin))
         stop("uin is too large to fit plot in")
      xuin <- uin[1]; yuin <- uin[2]
   }
   xlim <- midx + oxuin/xuin * c(-1, 1) * diff(xlim) * 0.5
   ylim <- midy + oyuin/yuin * c(-1, 1) * diff(ylim) * 0.5
   plot.default(cos(seq(0, 2 * pi, length = n)), sin(seq(0, 2 * pi, length = n)), axes = FALSE, type = "l", xlim=xlim, ylim=ylim, xaxs="i", yaxs="i", ...)
}
