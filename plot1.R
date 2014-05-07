# Assumption: you have set up the proper working directory
# Download file from UCI Machine Learning Repository and unzip
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, "powerdata.zip", mode="wb")
unzip("powerdata.zip")

#load package chron to work with dates and times
library(chron)

#Read data table
variableNames=c("date","time","globalactivepower","globalreactivepower","voltage","globalintensity",
                "submetering1","submetering2","submetering3")
data<- read.table("household_power_consumption.txt",sep=";",skip=1,col.names=variableNames)

#reclassify dates and times
dts <- dates(as.character(data$date),format=c(dates="d/m/y"))
tms<-times(as.character(data$time))

#Add new variable with date and time combined
data$datetime<-chron(dates = dts, times = tms)

#Other variable columns to explore manipulating time
data$DT<-paste(data$date,data$time,sep=" ") 
data$DTuse<-strptime(data$DT,"%d/%m/%Y %H:%M:%S") #Class POSIX
data$DTjustdate<-strptime(data$date,"%d/%m/%Y") #Class POSIX - date only
data$DTjustdate<-as.Date(data$DTjustdate) #...converted to Class Date

#Subset dataset to dates of interest Feb 1, 2007 - Feb 2, 2007
datarel<-data[data$datetime >= "2/1/2007" & data$datetime < "2/3/2007" ,]

#Set class of variables 3-9 to "numeric"
#Note: the new variable "datetime" is of Class "Chrono"
names(datarel)
#datarel$voltage<-as.numeric(as.character(datarel$voltage))
for (i in 3:9){
  #datarel[,i]<-as.numeric(datarel[,i])
  datarel[,i]<-as.numeric(as.character(datarel[,i]))
}

#Plot1 Generation - open device, plot, then close device

png(filename = "plot1.png", width = 480, height = 480, units = "px",
    pointsize = 12, bg = "transparent")
hist(datarel$globalactivepower,main="Global Active Power",col="red",
     xlab="Global Active Power (kilowatts)",font=2)
dev.off()
