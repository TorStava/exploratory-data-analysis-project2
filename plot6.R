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

## Filter the dataset for "on-road" type emission types in Baltimore or LA
NEI.filtered <- filter(NEI, (fips == "24510" | fips == "06037") & type == "ON-ROAD")

## Summarize the emissions per year by using the aggregate function.
NEI.sum <- aggregate(Emissions ~ year + fips, NEI.filtered, sum)

## Set up the graphics device.
png("plot6.png", width = 640, height = 480)

## Plotting using ggplot2
plot5 <- ggplot(data=NEI.sum, aes(x=year, y=Emissions, group=fips, colour=fips)) + 
                geom_line() + 
                geom_point() + 
                xlab("Year") + 
                ylab("Total Emissions (tons)") + 
                ggtitle("Total PM2.5 emissions in Baltimore City and Los Angeles County\n for motor vehicle sources in the period 1999 to 2008") + 
                scale_colour_discrete(name="County", 
                labels=c("Los Angeles \nCounty, California", "Baltimore City, Maryland"))

print(plot5)

## Close the graphics device.
dev.off()