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

## Find the SCC codes for coal combustion related sources
SCC.codes = SCC[which(grepl("coal", SCC$EI.Sector, ignore.case = TRUE) & grepl("comb", SCC$EI.Sector, ignore.case = TRUE)),]$SCC

## Filter the dataset using the SCC codes for coal combustion sources
NEI.filtered <- filter(NEI, SCC %in% SCC.codes)

## Summarize the emissions grouped by year by using the aggregate function.
NEI.sum <- aggregate(Emissions ~ year, data = NEI.filtered, FUN = sum)

## Set up the graphics device.
png("plot4.png", width = 480, height = 480)

## Generate plot using the ggplot2 package
with(NEI.sum,
     barplot(Emissions,
             names.arg = year,
             xlab = "Year",
             ylab = "PM2.5 Emission (Tons)",
             main = "Total PM2.5 emissions from\n coal combustion-related sources in US")
)

## Close the graphics device.
dev.off()