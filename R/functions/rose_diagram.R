# rose diagrams for F-S phase diagram
# CM
# date: Wed Oct 29 09:50:38 ADT 2008
# Time-stamp: <2008-10-30 23:37:50 (mintoc)>

xy2angle.func<-function(x1,x2,y1,y2){
  m1<-0
  m2<-(y2-y1)/(x2-x1)
  tantheta<-(m2-m1)/(1+m1*m2)  
  theta<-abs(atan(tantheta)*180/pi) # absolute theta in degrees
  # find out what compass quadrant
  if(x2>x1& y2>y1){return(90-theta)}
  if(x2>x1& y2<y1){return(90+theta)}
  if(x2<x1& y2<y1){return(180+(90-theta))}
  if(x2<x1& y2>y1){return(270+theta)}
}


X<-0
Y<-0
for(i in 2:500){
  X[i]<-X[i-1]+rnorm(1,mean=0, sd=2)+2
  Y[i]<-Y[i-1]+rnorm(1,mean=0, sd=2)
}
plot(X,Y, type="l")


xy.bearing<-sapply(seq(1, length(X)-1), function(z){print(z);xy2angle.func(x1=X[z],x2=X[z+1],y1=Y[z],y2=Y[z+1])})

#library(circular)
X.Y.circ<-circular(xy.bearing, type = c("angles"), units = c("degrees"))
plot(X.Y.circ)
rose.diag(X.Y.circ, bins=50, axes=FALSE, shrink=.5, prop=1.5, ticks=FALSE, yaxt="n", rotation=90)
abline(h=0, v=0)
# need to rotate this
