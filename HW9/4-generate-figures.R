library(ggplot2)
library(ggthemes)
library(plyr)
library(dplyr)
library(knitr)
# import data from previous R script!

gdat <- dget("sorted_gapminder.tsv")
bw <- dget("best-worst-gapminder.tsv")

dat<- inner_join(gdat, bw, by=c("country", "continent"))

dat <- dat %>%
  mutate(country = reorder(country, adj.r)) %>%
  arrange(country)

ggplot(dat  %>% filter(continent=="Asia"), aes(x = year, y = lifeExp, color = adj.r)) + facet_wrap(~ country, nrow=4) + geom_point() + geom_smooth(method = "lm", se = T) + ggtitle("Adjusted R squared - best and worst fits") + theme(legend.position="right", plot.title = element_text(size = 15, face="bold"), panel.background = element_rect(fill='white')) + xlab("Year") + ylab("Life Expectancy")

ggsave("plots/r-sq-asia.png");

ggplot(dat  %>% filter(continent=="Africa"), aes(x = year, y = lifeExp, color = adj.r)) + facet_wrap(~ country, nrow=4) + geom_point() + geom_smooth(method = "lm", se = T) + ggtitle("Adjusted R squared - best and worst fits") + theme(legend.position="right", plot.title = element_text(size = 15, face="bold"), panel.background = element_rect(fill='white')) + xlab("Year") + ylab("Life Expectancy")

ggsave("plots/r-sq-africa.png");

ggplot(dat  %>% filter(continent=="Oceania"), aes(x = year, y = lifeExp, color = adj.r)) + facet_wrap(~ country, nrow=4) + geom_point() + geom_smooth(method = "lm", se = T) + ggtitle("Adjusted R squared - best and worst fits") + theme(legend.position="right", plot.title = element_text(size = 15, face="bold"), panel.background = element_rect(fill='white')) + xlab("Year") + ylab("Life Expectancy")

ggsave("plots/r-sq-oceania.png");

ggplot(dat  %>% filter(continent=="Europe"), aes(x = year, y = lifeExp, color = adj.r)) + facet_wrap(~ country, nrow=4) + geom_point() + geom_smooth(method = "lm", se = T) + ggtitle("Adjusted R squared - best and worst fits") + theme(legend.position="right", plot.title = element_text(size = 15, face="bold"), panel.background = element_rect(fill='white')) + xlab("Year") + ylab("Life Expectancy")

ggsave("plots/r-sq-europe.png");

ggplot(dat  %>% filter(continent=="Americas"), aes(x = year, y = lifeExp, color = adj.r)) + facet_wrap(~ country, nrow=4) + geom_point() + geom_smooth(method = "lm", se = T) + ggtitle("Adjusted R squared - best and worst fits") + theme(legend.position="right", plot.title = element_text(size = 15, face="bold"), panel.background = element_rect(fill='white')) + xlab("Year") + ylab("Life Expectancy")

ggsave("plots/r-sq-americas.png");
