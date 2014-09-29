## rename doesn't work!!! not even rename-vars

install.packages("dplyr", dependencies=TRUE)
install.packages("plyr",dependencies=TRUE)
library(dplyr)
library(plyr)



## Missed stuff

suppressPackageStartupMessages(library(dplyr))
gd_url <- "http://tiny.cc/gapminder"
gtbl <- gd_url %>% read.delim %>% tbl_df

gtbl <- gtbl %>%
  mutate(gdp = pop * gdpPercap)

just_canada <- gtbl %>% filter(country == "Canada")
gtbl <- gtbl %>%
  mutate(canada = just_canada$gdpPercap[match(year, just_canada$year)],
         gdpPercapRel = gdpPercap / canada)
gtbl %>%
  select(country, year, gdpPercap, canada, gdpPercapRel)


# transmute(): throws it away (mutate: keeps it)
###################
gtbl <- gtbl %>%
  rename(life_exp = lifeExp, gdp_percap = gdpPercap,
         gdp_percap_rel = gdpPercapRel)


gtbl %>%
  group_by(continent)


##########
gtbl %>%
  group_by(continent) %>%
  summarize(n_obs = n())


############
gtbl %>%
  group_by(continent) %>%
  summarize(n_obs = n(), n_countries = n_distinct(country))

gtbl %>%
  group_by(continent) %>%
  tally

########### (does not group)
gtbl %>%
  group_by(continent) %>%
  summarize(avg_life_exp = mean(lifeExp))

gtbl %>%
  filter(year %in% c(1952, 2007)) %>%
  group_by(continent, year) %>%
  summarise_each(funs(mean, median), lifeExp, gdpPercap)

gtbl %>%
  filter(continent == "Asia") %>%
  group_by(year) %>%
  summarise(min_life_exp = min(lifeExp), max_life_exp = max(lifeExp))



gtbl %>%
  filter(continent == "Asia") %>%
  group_by(year) %>%
  select(year, country, lifeExp) %>%
  filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2) %>%
  arrange(year)


gtbl %>%
  group_by(continent, country)%>%
  select(country, year, continent, lifeExp) %>%
  mutate(le_delta = lifeExp - lag(lifeExp)) %>%
  summarize(worst_le_delta = min(le_delta, na.rm = TRUE)) %>%
  filter(min_rank(worst_le_delta) < 2) %>%
  arrange(worst_le_delta)

