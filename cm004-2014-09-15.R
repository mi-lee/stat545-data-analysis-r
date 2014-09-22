## get Gapminder data
gDat <- read.delim("gapminderDataFiveYear.txt")
str(gDat)
names(gDat)
dim(gDat)
ncol(gDat)
summary(gDat)
subset(gDat, subset=(country=="Luxembourg"))
plot(lifeExp ~ year, gDat) # ugly plot
plot(gDat[, 5] ~ gDat[, 2])  # don't do this!
plot(lifeExp~ gdpPercap, gDat)
plot(lifeExp ~ log(gdpPercap), gDat)

summary(gDat$lifeExp)
levels(gDat$continent)
nlevels(gDat$continent)
table(gDat$continent)


barplot(table(gDat$continent))
dotchart(table(gDat$continent))


# ggplot2
library(ggplot2)
p <- ggplot(gDat, aes(x = gdpPercap, y = lifeExp)) # just initializes
p <- ggplot(subset(gDat, year == 2007),
            aes(x = gdpPercap, y = lifeExp)) # just initializes
p <- p + scale_x_log10() # log the x axis the right way
p + geom_point() # scatterplot
p + geom_point(aes(color = continent))
p + geom_point(alpha=(1/3), size=3)
p + geom_point() + geom_smooth(lwd = 3, se = FALSE)
p + geom_point(alpha = (1/3), size = 3) + facet_wrap(~ continent)

# Subset by rows
subset(gDat, subset = (country=="Uruguay"))
# Use subset and select to simultaneously filter
subset(gDat, subset = country == "Mexico",
       select = c(country, year, lifeExp))
# Use subset as substitute for data
p <- ggplot(subset(gDat, country == "Colombia"), aes(x = year, y = lifeExp))
p + geom_point() + geom_smooth(lwd = 1, se = FALSE, method = "lm")

minYear=min(gDat$year)
myFit = lm(lifeExp~I(year - minYear), gDat, subset = (country=="Colombia"))
summary(myFit)


# Create subsets in situ - don't make little copies that clutter workspace
# Leave behind self-documenting code

# How to compute correlation of lifeExp, GDP for Colombia?
# cor() doesn't allow the usual data=
# use with() and subset() to avoid creating more objects
with(subset(gDat, subset = country == "Colombia"), 
     cor(lifeExp, gdpPercap))

# with() : create a temporary environment of data; refers to the named variable without creating a new object