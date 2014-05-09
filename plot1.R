# Assumption: you have set up a proper working directory
# Download file from UCI Machine Learning Repository and unzip
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, "powerdata.zip", mode="wb")
unzip("powerdata.zip")

#Set up tidy dataset variables, then read data table, skipping header line
variableNames=c("date","time","globalactivepower","globalreactivepower","voltage","globalintensity",
                "submetering1","submetering2","submetering3")

data<- read.table("household_power_consumption.txt",sep=";",skip=1,col.names=variableNames)

#Add variable column of Class POSIXct to plot based on date
data$DTuse<-as.POSIXct(strptime(paste(data$date,data$time,sep=" "),"%d/%m/%Y %H:%M:%S")) 

#load package chron to subset and parse full dataset based on dates
#Will need an internet connection
#If you already have chron you can skip the install command
install.packages("chron")
library(chron)
dts <- dates(as.character(data$date),format=c(dates="d/m/y"))
tms<-times(as.character(data$time))

#Add new variable to dataset with date and time combined to subset
data$datetime<-chron(dates = dts, times = tms) #new variable "datetime" is of Class "Chrono"
rm(dts,tms) #clean up work space and memory

#Subset dataset to dates of interest Feb 1, 2007 - Feb 2, 2007
datarel<-data[data$datetime >= "2/1/2007" & data$datetime < "2/3/2007" ,]

#Set class of variables 3-9 to "numeric"
for (i in 3:9){
  #datarel[,i]<-as.numeric(datarel[,i])
  datarel[,i]<-as.numeric(as.character(datarel[,i]))
}
#----------------
#Plot1 - open device, plot, then close device
#----------------
png(filename = "plot1.png", width = 480, height = 480, units = "px", pointsize = 12, bg = "transparent")
hist(datarel$globalactivepower,main="Global Active Power",col="red", xlab="Global Active Power (kilowatts)")
dev.off()
