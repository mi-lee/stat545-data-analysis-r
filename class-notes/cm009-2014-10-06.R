library(plyr)
library(dplyr)
gDat <- read.delim("gapminderDataFiveYear.txt")
max_le_by_cont <- ddply(gDat, ~ continent, summarize, max_le = max(lifeExp))
max_le_by_cont

ddply(gDat, ~ continent, summarize, n_uniq_countries = length(unique(country)))

levels(max_le_by_cont$continent)

ddply(gDat, ~ continent,
      function(x) c(n_uniq_countries = length(unique(x$country))))


le_lin_fit <- function(dat, offset = 1952) {
  the_fit <- lm(lifeExp ~ I(year - offset), dat)
  setNames(coef(the_fit), c("intercept", "slope"))
}

le_lin_fit(subset(gDat, country == "Canada"))

j_coefs <- ddply(gDat, ~ country, le_lin_fit)
str(j_coefs)

tail(j_coefs)


