setwd("D:/R Directory/Coursera/Exploratory data Analysis")

#Code to Download the zip file
strptime(household_power_consumption)

file.name <- "./household_power_consumption.txt"
url       <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip.file  <- "./data.zip"

# review if the data is downloaded and download when applicable
if (!file.exists("./household_power_consumption.txt")) {
  download.file(url, destfile = zip.file)
  unzip(zip.file)
  file.remove(zip.file)
}

# Reading the file
library(data.table)
Assignment <- fread(file.name,
            sep = ";",
            header = TRUE,
            colClasses = rep("character",9))
# Convert "?" in NAs
Assignment[Assignment == "?"] <- NA

# Subsetting only tha dated request
Assignment$Date <- as.Date(Assignment$Date, format = "%d/%m/%Y")
Assignment <- Assignment[Assignment$Date >= as.Date("2007-02-01") & Assignment$Date <= as.Date("2007-02-02"),]

# Joining day and time to create a new posix date
Assignment$posix <- as.POSIXct(strptime(paste(Assignment$Date, Assignment$Time, sep = " "),
                                format = "%Y-%m-%d %H:%M:%S"))

# Convert column that we will use to correct class
Assignment$Global_active_power <- as.numeric(Assignment$Global_active_power)

# Do the Plot 4
png(file = "plot4.png", width = 480, height = 480, units = "px")

## Setting 4 graphs
par(mfrow = c(2, 2))

## Graph 1
with(Assignment,
     plot(posix,
          Global_active_power,
          type = "l",
          xlab = "",
          ylab = "Global Active Power"))

## Graph 2
with(Assignment,
     plot(posix,
          Voltage,
          type = "l",
          xlab = "datetime",
          ylab = "Voltage"))

## Graph 3
with(Assignment,
     plot(posix,
          Sub_metering_1,
          type = "l",
          xlab = "",
          ylab = "Energy sub metering"))
with(Assignment,
     points(posix,
            type = "l",
            Sub_metering_2,
            col = "red")
)
with(Assignment,
     points(posix,
            type = "l",
            Sub_metering_3,
            col = "blue")
)
legend("topright", col = c("black", "blue", "red"),
       legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), lty = 1)
## Graph 4
with(Assignment,
     plot(posix,
          Global_reactive_power,
          type = "l",
          xlab = "datetime",
          ylab = "Global_reactive_power"))
dev.off()  # Close the png file device

