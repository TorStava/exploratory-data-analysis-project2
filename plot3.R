## The script expects that the datafile has been downloaded and unpacked
## to a subdirectory named 'data'.

library(dplyr)
library(ggplot2)

## Setting the correct work directory
setwd("I:/Dropbox/Coursera/exploratory-data-analysis-project2")

## Setting up filename variables.
## Not really required, but I believe it helps code readability, and makes it
## easy to modify the code later on.
dataDir <- "data"
fileNEI <- "summarySCC_PM25.rds"
fileSCC <- "Source_Classification_Code.rds"

# Include the file path
fileNEI <- paste(dataDir, fileNEI, sep="/")
fileSCC <- paste(dataDir, fileSCC, sep="/")
rm(dataDir) # Remove uneeded variable.

## The dataset is about 30 MBytes and might take a few moments to load.
## Be patient while loading the data :)
if(file.exists(fileNEI)) {
        NEI <- readRDS(fileNEI)
}

if(file.exists(fileSCC)) {
        SCC <- readRDS(fileSCC)

}

## Summarize the emissions grouped by type and year by using the aggregate function.
BCM <- filter(NEI, fips == "24510")
aggEmissionsBCM <- aggregate(Emissions ~ type + year, data = BCM, FUN = sum)

## Set up the graphics device.
png("plot3.png", width = 640, height = 480)

## Generate plot using the ggplot2 package
plot3 <- ggplot(aggEmissionsBCM, aes(year, Emissions, color = type)) +
        geom_line() +
        xlab("Year") +
        ylab(expression("Total PM"[2.5]* " Emissions (tons)")) +
        ggtitle(expression("Total PM"[2.5]* " Emissions in Baltimore City, Maryland"))

print(plot3)
        
## Close the graphics device.
dev.off()