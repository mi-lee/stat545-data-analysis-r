## get Gapminder data

gTable <- read.table("gapminderDataFiveYear.txt", header = TRUE, sep = "", dec = ".", fill = TRUE)
identical(gTable, gDelim)

gTable2 <- read.table("gapminderDataFiveYear.txt", header = TRUE, sep = "\t", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
gDelim <- read.delim("gapminderDataFiveYear.txt")
identical(gTable2, gDelim)

lifeExp <- read.csv("/Volumes/DATA/My Documents/Dropbox/STAT-545A/zz_michelle_lee-coursework/lifeExp.csv")
colnames(lifeExp)=c("Country", 1800:2012)
subset


# Basic facts
# Num of observations, which vars are there, what sort
# basic descriptie statistive

str(gDat)
names(gDat)
dim(gDat)
summary(gDat)


# Descriptive statistics by continent
africa=subset(gDat, subset=(continent=="Africa"))
dim(africa)
summary(africa)

asia=subset(gDat, subset=(continent=="Asia"))
dim(asia)
summary(asia)

europe=subset(gDat, subset=(continent=="Europe"))
dim(europe)
summary(europe)

americas=subset(gDat, subset=(continent=="Americas"))
dim(americas)
summary(americas)

oceania=subset(gDat, subset=(continent=="Oceania"))
dim(oceania)
summary(oceania)



# Which continent has countries with GDP per capita less than world average?
var(africa$gdpPercap)
var(asia$gdpPercap)
var(europe$gdpPercap)
var(oceania$gdpPercap)
var(americas$gdpPercap)

var(africa$lifeExp)
var(asia$lifeExp)
var(europe$lifeExp)
var(oceania$lifeExp)
var(americas$lifeExp)

var(africa$pop)
var(asia$pop)
var(europe$pop)
var(oceania$pop)
var(americas$pop)

var(africa$gdpPercap)gDat[(gDat$gdpPercap < mean(gDat$gdpPercap)) & (gDat$year > 2005),]


# How about within continents?
africa[(africa$gdpPercap > mean(africa$gdpPercap)) & (africa$year > 2005), "country"]
unique(asia[asia$gdpPercap < mean(asia$gdpPercap), "country"])



with(subset(gDat, subset=(continent=="Oceania")), min(gdpPercap))

# South vs North korea
nk=subset(gDat, subset=(country=="Korea, Dem. Rep."))
sk=subset(gDat, subset=(country=="Korea, Rep."))
bo=subset(gDat, subset=(country=="Botswana"))

library(ggplot2)
p <- ggplot(sk, aes(x = gdpPercap, y = lifeExp)) # just initializes
p <- ggplot(sk, aes(x = gdpPercap, y = lifeExp)) # just initializes
p <- p + scale_x_log10() # log the x axis the right way
p + geom_point() # scatterplot

b <- ggplot(bo, aes(y = lifeExp, x = year)) # just initializes
b <- ggplot(bo, aes(y = lifeExp, x = year)) # just initializes
b <- b + scale_x_log10() # log the x axis the right way
p + geom_point() + geom_line() # scatterplot


# World inequality
hist(gDat$lifeExp)
hist(gDat$gdpPercap)
hist(gDat$pop)

qu=subset(gDat, subset=(country=="Qatar")


with(subset(gDat, subset = country == "Colombia"), 
     cor(lifeExp, gdpPercap))


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
