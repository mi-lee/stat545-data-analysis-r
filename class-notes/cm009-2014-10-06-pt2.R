library(plyr)
library(dplyr)
library(ggplot2)
gDat <- read.delim("gapminderDataFiveYear.txt")


j_coefs <- ddply(gDat, ~country + continent, 
                 function(x, offset= 1952) {
                   the_fit <- lm(lifeExp ~ I(year - offset), x)  # I inhibits c  oercion
                   setNames(coef(the_fit), c("intercept", "slope"))}
)

str(j_coefs)
class(j_coefs$country)
mode(j_coefs$country)
typeof(j_coefs$country)
levels(j_coefs$country)
nlevels(j_coefs$country)

ggplot(j_coefs, aes(x=slope, y= country)) + geom_point(size=3)

ggplot(j_coefs, aes(x=slope, y= reorder(country, slope))) + geom_point(size=3)

## filter Egypt
gtbl=tbl_df(gDat)
hDat<- gtbl %>%
  filter(country %in% c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela"))

str(hDat) # still has 142 levels in country

table(hDat$country)
levels(hDat$country) # still has 142 - just deleting rows doesn't mean it isn't a factor still

# get rid of unusued factors

# Two ways: 

# old way:
iDat <- droplevels(hDat)

# dplyr way:
iDat <- hDat %>%
  droplevels

## reorder
## get a new data frame with the max life expectancy for each country in iDat
max_le <- iDat %>%
  group_by(country) %>%
  summarise_each(funs(max), lifeExp) %>%
  print

# OR!
i_max_le <- iDat %>%
  group_by(country) %>%
  summarize(max_le = max(lifeExp))

ggplot(i_max_le, aes(x=country, y=max_le, group=1)) + geom_path() + geom_point(size=3)
ggplot(iDat, aes(x=year, y=lifeExp, group=country)) + geom_line(aes(color=country))

## reorder(your_factor, your_quant_var, your_summarization_function

jDat<- iDat %>%
  mutate(country = reorder(country, lifeExp, max))


data.frame(before=levels(iDat$country), after=levels(jDat$country)) # reordered!!!!

j_le_max<- jDat %>%
  group_by(country) %>%
  summarize(max_le = max(lifeExp))

ggplot(jDat, aes(x=year, y=lifeExp, group=country)) + 
  geom_line(aes(color=country)) +
  guides(color=guide_legend(reverse=TRUE))
