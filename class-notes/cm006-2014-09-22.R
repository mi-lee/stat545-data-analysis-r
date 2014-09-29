gDat <- read.delim("gapminderDataFiveYear.txt")
str(gDat)
library(ggplot2)


# aethetic: position, colour, line type
# geom: specifics of what people see (points, lines)
# scae: map data values into computer values
# stat: summarize/transform data


# mapping: aes() - picking a variable and mapping to aesthetic property
# setting: setting alpha to a single hardwired number 

ggplot(gDat, aes(x = gdpPercap, y = lifeExp)) # haven't made a plot
p <- ggplot(gDat, aes(x = gdpPercap, y = lifeExp))
p + geom_point()
p <- p + scale_x_log10()
p + geom_point(aes(color = continent))
ggplot(gDat, aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point() + scale_x_log10()
p + geom_point(alpha = (1/3), size = 2)
p + geom_point() + geom_smooth()
p + geom_point() + geom_smooth(lwd = 3, se = FALSE)
p + geom_point() + geom_smooth(lwd = 3, se = FALSE, method = "lm")
p + aes(color = continent) + geom_point() + geom_smooth(lwd = 3, se = FALSE)
p + geom_point(alpha = (1/3), size = 3) + facet_wrap(~ continent)
p + geom_point(alpha = (1/3), size = 3) + facet_wrap(~ continent) +
  geom_smooth(lwd = 2, se = FALSE)


# plot lifeExp against year

# Mini plots by continent

# Fitted smooth/regression line, with/w/o facetting

(y <- ggplot(gDat, aes(x = year, y = lifeExp)) + geom_point())

y + facet_wrap(~ continent)

y + geom_smooth(se = FALSE, lwd = 2) +
  geom_smooth(se = FALSE, method ="lm", color = "orange", lwd = 2)

y + geom_smooth(se = FALSE, lwd = 2) +
  facet_wrap(~ continent)

y + facet_wrap(~ continent) + geom_line() # uh, no



y + facet_wrap(~ continent) + geom_line(aes(group = country)) # yes!

y + facet_wrap(~ continent) + geom_line(aes(group = country)) +
  geom_smooth(se = FALSE, lwd = 2) 
ggplot(subset(gDat, country == "Zimbabwe"),
       aes(x = year, y = lifeExp)) + geom_line() + geom_point()

jCountries <- c("Canada", "Rwanda", "Cambodia", "Mexico")
ggplot(subset(gDat, country %in% jCountries),
       aes(x = year, y = lifeExp, color = country)) + geom_line() + geom_point()
ggplot(subset(gDat, country %in% jCountries),
       aes(x = year, y = lifeExp, color = reorder(country, -1 * lifeExp, max))) +
  geom_line() + geom_point()

