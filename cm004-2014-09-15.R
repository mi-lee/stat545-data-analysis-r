## get Gapminder data
gDat <- read.delim("gapminderDataFiveYear.txt")
str(gDat)
names(gDat)
dim(gDat)
ncol(gDat)
summary(gDat)
subset(gDat, country=="Luxembourg")