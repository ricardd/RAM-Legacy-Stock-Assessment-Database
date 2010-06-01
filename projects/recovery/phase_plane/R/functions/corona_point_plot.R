# corona plot diagram
# See Wells 2000 "Are there alternatives to rose diagrams"

#library(circular)
test.dat<-runif(100, min=0, max=2*pi)
test.mat<-matrix(test.dat, ncol=1)
test.circ<-circular(test.dat, units="radians", rotation = c("clock"))

red.palette<-colorRampPalette(c("yellow", "orange", "red"))
circ.colors <- rainbow(length(test.circ))

#plot.circular2(test.circ, stack=TRUE, bins=100, col=circ.colors)
plot.circular2(test.circ, stack=TRUE, bins=100, col=sample(circ.colors,1))
points.circular2(test.circ, stack=TRUE, col=circ.colors)
#~~~~~~~~~~~ sandbox ~~~~~~~~~~~~~~~~~~~~~~~~~

# plot a circle
# coordinates of center
h<-0 # on x coordinate
k<-0 # on y coordinate
r<-1 # radius

theta<-seq(0, 2*pi, length=360)
x<-h+r*cos(theta)
y<-k+r*sin(theta)
plot(x,y, pch=19, col=rainbow(length(theta)), cex=.5, xlim=c(-1.4,1.4), ylim=c(-1.4,1.4), axes=FALSE, xlab="", ylab="")

r<-1.1 # radius
theta<-seq(0, 2*pi, length=360)
x<-h+r*cos(theta)
y<-k+r*sin(theta)
points(x,y, pch=19, col=rainbow(length(theta)), cex=.5)
abline(h=0, v=0, lty=2)

