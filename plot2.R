library(data.table)
library(dplyr)
library(lubridate)

file1Url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if (!file.exists("data")) {
        dir.create("data")
}

if (!file.exists("./data/household_power_consumption.zip")) {
        download.file(file1Url, destfile ="./data/household_power_consumption.zip", mode="wb")
        dateDownloaded <- date()
}
rm(file1Url)



if (!file.exists("./data/household_power_consumption.txt")) {
        unzip("./data/household_power_consumption.zip", exdir="./data")
}


hpc <- fread("./data/household_power_consumption.txt", 
             colClasses=list(character=1:9), data.table=F, na.strings="?")

hpc <- filter(hpc, Date=='1/2/2007'|Date=='2/2/2007')
hpc <- tbl_df(hpc)
hpc$Date <- dmy(hpc$Date)
hpc$Time <- hms(hpc$Time)
hpc[,3:9] <- sapply(hpc[,3:9], as.numeric)
#hpc<-mutate(hpc, Date_time=Date+Time)

Sys.setlocale("LC_TIME", "English")

png(filename = "plot2.png")
par(bg="transparent")
plot(hpc$Date+hpc$Time, hpc$Global_active_power, type="l", ann=F)
title(ylab="Global Active Power (kilowatts)")
dev.off()