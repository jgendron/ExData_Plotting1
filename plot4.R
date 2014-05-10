# NOTE: set up a proper working directory
# Download file from UCI Machine Learning Repository and unzip
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, "powerdata.zip", mode="wb")
unzip("powerdata.zip")

#Set up tidy dataset variables, then read data table, skipping header line
variableNames=c("date","time","globalactivepower","globalreactivepower",
                "voltage","globalintensity", "submetering1",
                "submetering2","submetering3")

data<- read.table("household_power_consumption.txt",sep=";",skip=1,
                  col.names=variableNames)

#Add variable column of Class POSIXct to plot based on date
data$DTuse<-as.POSIXct(strptime(paste(data$date,data$time,sep=" "),
                                "%d/%m/%Y %H:%M:%S")) 

#load package chron to subset and parse full dataset based on dates
#Will need an internet connection if the package is not installed
#If the package is already installed it will just load the package
if (!"chron" %in% installed.packages()) {install.packages("chron")}
library(chron)
dts <- dates(as.character(data$date),format=c(dates="d/m/y"))
tms<-times(as.character(data$time))

#Add new variable to dataset with date and time combined to subset
data$datetime<-chron(dates = dts, times = tms) #new variable of Class "Chrono"
rm(dts,tms) #clean up work space and memory

#Subset dataset to dates of interest Feb 1, 2007 - Feb 2, 2007
datarel<-data[data$datetime >= "2/1/2007" & data$datetime < "2/3/2007" ,]

#Set class of variables 3-9 to "numeric"
for (i in 3:9){
        #datarel[,i]<-as.numeric(datarel[,i])
        datarel[,i]<-as.numeric(as.character(datarel[,i]))
}
#----------------
#Plot4 - open device, plot, then close device
#----------------
png(filename = "plot4.png", width = 480, height = 480, pointsize=11.8,
    units = "px", bg = "transparent")

#Reset parameters to allow four plot grid populate by row
par(mfrow=c(2,2))

#Plot upperleft - replicate from plot2 code with change in y label
plot(datarel$DTuse, datarel$globalactivepower,  type = "l", xlab = "", 
     ylab = "Global Active Power")

#Plot upperright - new plot of Voltage over time
plot(datarel$DTuse, datarel$voltage,  type = "l", xlab = "datetime", 
     ylab = "Voltage")

#Plot lowerleft - replicate from plot3 code but remove border around legend
plot(datarel$DTuse, datarel$submetering1, type = "l", xlab = "", 
     ylab = "Energy sub metering", col="black")
lines(datarel$DTuse, datarel$submetering2, type = "l", col="red")
lines(datarel$DTuse, datarel$submetering3, type = "l", col="blue")
legend("topright", lty=1,col=c("black","red","blue"), box.lty=0,
     legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

#Plot lowerright - new plot of global reactive power over time
plot(datarel$DTuse, datarel$globalreactivepower,  type = "l", xlab = "datetime", 
     ylab = "Global_reactive_power")

dev.off()

