get.admb.results<-function(foldername,filename){
  # provide the folder and file names where admb code was run
  # see if the file exists
  exists.bool<-length(grep(paste(filename, ".std", sep=""), system(paste("ls", foldername), intern=TRUE)))>0
  if(exists.bool<1){
    stop(paste("file:", paste(filename, ".std", sep=""), "does not exist in directory:", foldername))
  }else{
    infile<-paste(foldername,filename,".std", sep="")
    outfile<-paste(foldername,filename,"_results.dat", sep="")
    # replace the std dev
    system(paste('sed "s/std dev/SD/g"', infile, ">", outfile))
    dat<-read.table(outfile, header=TRUE)
    return(dat)
  }
}
