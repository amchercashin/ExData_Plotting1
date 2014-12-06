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

png(filename = "plot4.png")

par(bg="transparent", mfrow=c(2,2))

plot(hpc$Date+hpc$Time, hpc$Global_active_power, type="l", ann=F)
title(ylab="Global Active Power")

plot(hpc$Date+hpc$Time, hpc$Voltage, type="l", ann=F)
title(ylab="Voltage", xlab="datetime")

with(hpc, plot(Date+Time, Sub_metering_1, type="l", ann=F))
with(hpc, lines(Date+Time, Sub_metering_2, col="red"))
with(hpc, lines(Date+Time, Sub_metering_3, col="blue"))
title(ylab="Energy sub metering")
legend("topright", lty=1, col=c("black","red","blue"), legend=colnames(hpc[7:9]), box.lty=0)

with(hpc,plot(Date+Time, Global_reactive_power, type="l", ann=F))
title(ylab="Global_reactive_power", xlab="datetime")

dev.off()