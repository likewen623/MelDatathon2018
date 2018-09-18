#####################################################
# Some R code to get you going for the 
# 2018 Melbourne Datathon

# Step 2
# Merge all the OFF files together

# 2018/07/28
#####################################################

#install and load required libraries
#install.packages('data.table')
library(data.table)
library(R.utils)


#tell R where it can find the data
ScanOnFolderMaster <- 'D:/Desktop/MelbDatathon2018/Samp_0/ScanOnTransaction'
ScanOffFolderMaster <- 'D:/Desktop/MelbDatathon2018/Samp_0/ScanOffTransaction'

mySamp <- 0

ScanOnFolder <- sub("x",mySamp,ScanOnFolderMaster)
ScanOffFolder <- sub("x",mySamp,ScanOffFolderMaster)

#list the files
onFiles <- list.files(ScanOnFolder,recursive = TRUE,full.names = TRUE)
offFiles <- list.files(ScanOffFolder,recursive = TRUE,full.names = TRUE)

#how many
allFiles <- union(onFiles,offFiles)
cat("\nthere are", length(allFiles),'files')


first <- TRUE
count <- 0
=
#look at all the files
myFiles <- offFiles

for (myOn in myFiles){
  
  cmd <- gunzip(myOn, ext="gz", FUN=gzfile)
  
  #grab all the columns
  dt <- fread(cmd)
  
  #create a sample based on column 4 values
  #note the samples are already sampled!
  #dt <- subset(dt,V4 %% 100 == mySamp)
  
  #stack the records together
  if (first == TRUE){
    allON <- dt
    first <- FALSE
  } else {
    l = list(dt,allON)
    allON <- rbindlist(l)
  }
  
  count <- count + 1
  cat('\n',count,' of ',length(myFiles))
  
}

 
cat('\n there are ', format(nrow(allON),big.mark = ","),'rows')

colnames(allON) <- c('Mode','BusinessDate','DateTime','CardID','CardType','VehicleID','ParentRoute','RouteID','StopID')

fwrite(allON,'D:/Desktop/MelbDatathon2018/alloff.v1.csv')