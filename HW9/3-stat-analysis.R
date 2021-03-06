library(ggplot2)
library(ggthemes)
library(plyr)
library(dplyr)
library(knitr)
# import data from previous R script!

gdat <- dget("sorted_gapminder.tsv")

# check to make sure the order is still in force
head(gdat)
levels(gdat)

# Fit linear regression of life expectancy on year
gapminderFun <- function(data, offset = 1952) {
	model <- lm(lifeExp ~ I(year - offset), data)
	intercept <- model$coef[1]
	slope <- model$coef[2]
	sd <- summary(model)$sigma
	adj.r <- summary(model)$adj.r.squared
	cbind(intercept, slope, sd, adj.r)
}
mod <- ddply(gdat, ~ country + continent, gapminderFun)

# 4 best countries by slope
best<-function(data) {
	head(arrange(data, -adj.r), n=4)
}
best<-ddply(mod, ~continent, best)
kable(best, format = "markdown")

# 4 worst countries by slope
worst<-function(data) {
	head(arrange(data, adj.r), n=4)
}
worst<-ddply(mod, ~continent, worst)
kable(worst, format = "markdown")

lmDat <- rbind(best, worst)

lmDat <- lmDat %>%
	mutate(continent = reorder(continent, adj.r, max)) %>%
	arrange(continent)

dput(lmDat, file= "best-worst-gapminder.tsv")