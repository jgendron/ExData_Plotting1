# Assumption: you have set up the proper working directory
# Download file from UCI Machine Learning Repository and unzip
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, "powerdata.zip", mode="wb")
unzip("powerdata.zip")

