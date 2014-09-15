## get Gapminder data
gDat <- read.delim("gapminderDataFiveYear.txt")
str(gDat)
names(gDat)
dim(gDat)
ncol(gDat)
summary(gDat)
subset(gDat, country=="Luxembourg")
plot(lifeExp ~ year, gDat) # ugly plot
plot(gDat[, 5] ~ gDat[, 2])  # don't do this!
plot(lifeExp~ gdpPercap, gDat)
plot(lifeExp ~ log(gdpPercap), gDat)

summary(gDat$lifeExp)
levels(gDat$continent)
nlevels(gDat$continent)
table(gDat$continent)
barplot(table(gDat$continent))
