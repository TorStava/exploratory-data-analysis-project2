## The script expects that the datafile has been downloaded and unpacked
## to a subdirectory named 'data'.

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

## Filter the dataset for "on-road" type emission types om Baltimore
NEI.filtered <- filter(NEI, fips == "24510" & type == "ON-ROAD")

## Summarize the emissions per year by using the aggregate function.
NEI.sum <- aggregate(Emissions ~ year, NEI.filtered, sum)

## Set up the graphics device.
png("plot5.png", width = 480, height = 480)

## Plotting as barplot (part of the base plotting system).
with(NEI.sum,
     barplot(Emissions,
             names.arg = year,
             xlab = "Year",
             ylab = "PM2.5 Emission (Tons)",
             main = "Total PM2.5 Emissions from\nmotor vehicle sources in Baltimore")
)

## Close the graphics device.
dev.off()