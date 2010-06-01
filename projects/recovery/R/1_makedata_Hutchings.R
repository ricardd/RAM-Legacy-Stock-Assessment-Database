# Purpose: generate the data for recovery analysis from the srdb views
# Started: Thu Oct 30 13:42:00 ADT 2008
# JB
# Last modified: Time-stamp: <>

# Load necessaries
require(RODBC)
require(MASS)
# connect to the srDB
chan <- odbcConnect(dsn="srdbusercalo", uid = "srdbuser", pwd="srd6us3r!", case='postgresql',believeNRows=FALSE)

# GET DATA from the SRDB DATABASE 
# get all unique assessids
assessid.query <- 'SELECT DISTINCT assessid FROM srdb.timeseries_values_view';
assessid.unique<- sqlQuery(chan,assessid.query) #currently n=148
# join timeseries and reference points views
join.query<- 'SELECT * FROM srdb.timeseries_values_view LEFT JOIN srdb.reference_point_values_view ON
                timeseries_values_view.assessid=reference_point_values_view.assessid';
jointview <- sqlQuery(chan,join.query)
#NEED to also get TAXONOMY Table with Family, Scientific Name
##**NEED to exclude all the MYERS assessments**##
# close the connection at the end of a session or after retrieval 
odbcClose(chan)


#MANIPULATE DATA in R
minTSlen <- 15  
crash.def <- 0.5 # defined as crashed of less than 10% of max ssb
cons.thresh <- 0.5
store <- data.frame(assessid=NA,biomass_syr=NA,biomass_nyr=NA,biomass_type=NA,maxByr=NA,maxB=NA,minByr=NA,minB=NA,Bcurr=NA,Bbeg=NA,Brelbeg=NA,Bmax=NA,Brelmax=NA,max.pr.change=NA,position=NA,B1=NA,B15=NA,B20=NA,B25=NA,B30=NA,recov5=NA,num.crashes=NA) #define data frame to store results
u.names <- as.character(with(jointview,unique(assessid)))
length(u.names)

#for(i in 1:length(u.names))
  for(i in 1)
  {
    temp <- subset(jointview, assessid %in% u.names[i]) #subsets: calls out all the data for a single assessment
     if(length(which(!is.na(temp$ssb))) >= minTSlen){   #if the SSB time series is 15 years or longer, do the following calculations on it:
          temp2<- temp[!is.na(temp$ssb),]               #get rid of all the rows for which ssb is NA
       sub_jointview_ssb <- temp2[order(temp2[,2]),]    #within the assessment order the data by year
          assessid <- as.character(sub_jointview_ssb$assessid)[1]
          biomass_syr <- head(sub_jointview_ssb$tsyear,n=1)
          biomass_nyr <- tail(sub_jointview_ssb$tsyear,n=1)
          biomass_type <- "ssb"
          y1<- sub_jointview_ssb[with(sub_jointview_ssb,which.max(ssb)),]   #extracts row with max SSB, including name, years
          y2 <-y1[,c(2,4)]                              #extracts the year and ssb columns     
          names(y2)<-c("maxByr","maxB")
          y3 <- sub_jointview_ssb[with(sub_jointview_ssb,which.min(ssb)),]   #extracts row with min SSB, including name, years
          y4 <-y3[,c(2,4)]                              #extracts the year and ssb coluumns 
          names(y4)<-c("minByr","minB")
          Bcurr <- tail(sub_jointview_ssb$ssb,n=1)
          Bbeg  <- mean(head(sub_jointview_ssb$ssb,n=5)) #average of the first 5 years of SSB
          Brelbeg <- Bcurr/Bbeg
          Bmax  <- mean(tail(sort(sub_jointview_ssb$ssb),n=5))
          Brelmax <- Bcurr/Bmax
          #cons_dep <- ifelse(
          t <- sub_jointview_ssb$tsyear[15:(length(sub_jointview_ssb$tsyear)-5)] #REDO Jeff's analysis to see what it looks like w RAMII data
          pr.change <- t*NA #define empty vector to store the maximum 15 year proportional change
          for(j in 1:length(t))
            {
              pr.change[j] <- 1-(sub_jointview_ssb$ssb[j+14]/sub_jointview_ssb$ssb[j]) #15 year change
            } 
          max.pr.change <- max(pr.change)  
          position <- which.max(pr.change)+14       #the last year of the greatest 15-year prop. change 
          B15 <- sub_jointview_ssb$ssb[position]
          B1 <- sub_jointview_ssb$ssb[position-14]
          B20 <- sub_jointview_ssb$ssb[position+5]
          B25 <- sub_jointview_ssb$ssb[position+10]
          B30 <- sub_jointview_ssb$ssb[position+15]
          recov5 <- B20/B1   #END of Jeff's analysis - fig. code is in JB's Toshiba/PhD/Recovery/... 
          num.crashes <- nrow(subset(sub_jointview_ssb, ssb <= y2$maxB*crash.def))  #num. of times stock was <= 10% of max SSB
          xx <- data.frame(assessid,biomass_syr,biomass_nyr,biomass_type,y2,y4,Bcurr,Bbeg,Brelbeg,Bmax,Brelmax,max.pr.change,position,B1,B15,B20,B25,B30,recov5,num.crashes)
          store <- rbind(store,xx)}    else
        if(length(which(!is.na(temp$total)))>=minTSlen){      #else if the TB time series is 15 years or longer do calculations on it
          temp3 <- temp[!is.na(temp$total),]
          sub_jointview_tot <- temp3[order(temp3[,2]),]       #within the assessment order the data by year 
          assessid <- as.character(sub_jointview_ssb$assessid)[1]
          biomass_syr <- head(sub_jointview_tot$tsyear,n=1)
          biomass_nyr <- tail(sub_jointview_tot$tsyear,n=1)
          biomass_type <- "totalb"
          z1 <- sub_jointview_tot[with(sub_jointview_tot,which.max(total)),] #extracts row w. max tot. biomass, including name, yrs
          z2 <- z1[,c(2,6)]
          names(z2)<-c("maxByr","maxB")
          z3 <- sub_jointview_tot[with(sub_jointview_tot,which.min(total)),]   #extracts row with max SSB, including name, years
          z4 <-z3[,c(2,4)]
          names(z4)<-c("minByr","minB")
          Bcurr <- tail(sub_jointview_tot$total,n=1)
          Bbeg  <- mean(head(sub_jointview_tot$total,n=5)) #average of the first 5 years of totalB
          Brelbeg <- Bcurr/Bbeg
          Bmax  <- mean(tail(sort(sub_jointview_tot$total),n=5))  #average of the max 5 years of totalB
          Brelmax <- Bcurr/Bmax
          num.crashes <- nrow(subset(sub_jointview_tot, total <= z2$maxB*crash.def)) #num of times stock was <= 10% of max totalB
        }
  }
store <- store[-1,]  # remove annoying first row

recov.dat <- subset(store, store$max.pr.change >=0.1
plot(recov.dat$max.pr.change,recov.dat$recov5,xlim=c(0.1,1),ylim=c(0,2.4))
abline(a=0.9,b=-1)
abline(h=1.0,lty=2)
                    

#Simple Boolean Example:
bool1 <- FALSE
bool2 <- FALSE
bool3 <- TRUE
if(bool1){"1"}else
  if(bool2){"2"}else
   if(bool3){"3"}

#CODE FOR SSB ONLY (NO BOOLEANS)
u.names <- as.character(with(jointview2,unique(assessid))) #get the unique stock names for which there is ssb data n=143

for (i in 1:length(u.names))        #for(i in 10)
{               
x1 <- subset(jointview2, assessid %in% u.names[i])  # subsets: calls out all the data for a single assessment
x2 <- x1[order(x1[,2]), ]           #within the assessment order the data by year 
y1<- x2[with(x2,which.max(ssb)),]   #extracts row with max SSB, including the name, years, SSB
y2 <-y1[,c(1,2,4)]
names(y2)<-c("assessid","maxyear","maxSSB")
SSB_syr <- head(x2$tsyear,n=1)
SSB_nyr <- tail(x2$tsyear,n=1)
SSBcurr <- tail(x2$ssb,n=1)
SSBbeg  <- mean(head(x2$ssb,n=1)) #average of the first 5 years of SSB
SSBrelbeg <- SSBcurr/SSBbeg
SSBmax  <- mean(tail(sort(x2$ssb),n=5))
SSBrelmax <- SSBcurr/SSBmax
num.crashes <- nrow(subset(x2, ssb <= y2$maxSSB*crash.def)) #num of times stock was less than or equal to 10% of max SSB
store <- rbind(store,data.frame(y2,SSB_syr,SSB_nyr,SSBcurr,SSBbeg,SSBrelbeg,SSBmax,SSBrelmax,num.crashes))
}

store <- store[-1,]  # remove annoying first row
length(store$num.crashes[store$num.crashes>=1]) #count how many of the stocks 'crashed'

#PLOTS
store2 <-store[,c(1,8)] #assessid, SSBrelmax
max(store2$SSBrelmax)
hist(store2$SSBrelmax, breaks=seq(0,1,0.1))

store3 <- store[,c(1,6)]
max(store3$SSBrelbeg) 
hist(log10(store3$SSBrelbeg), breaks=seq(

#plot as log10(SSBcurr/ref.point)

#############################
minTSlen = 20        #minimum time series length (years) for inclusion in analysis
cons_thresh = 0.50   #conservation reference point: fraction of Bmax

#need to define output dataframe here before loop


xx <- subset(jointview, jointview$assessid=='AFSC-PCODGA-1977-2007-BAUM')

#for(i in assessid.unique)
for(i in 1)
  {
  xx <- subset(jointview, jointview$assessid==[i])    
   print(xx)
  }


