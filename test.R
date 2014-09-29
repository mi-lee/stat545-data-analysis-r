install.packages("dplyr", dependencies=TRUE)
#install.packages("plyr",dependencies=TRUE)
library(dplyr)
#library(plyr)



## Missed stuff

gd_url <- "http://tiny.cc/gapminder"
gtbl <- gd_url %>% read.delim %>% tbl_df





gtbl %>%
  group_by(continent) %>%
  summarize(n_obs = n())

gtbl %>%
  group_by(continent) %>%
  summarize(avg_life_exp = mean(lifeExp))

gtbl %>%
  group_by(continent, country)%>%
  select(country, year, continent, lifeExp) %>%
  mutate(le_delta = lifeExp - lag(lifeExp)) %>%
  summarize(worst_le_delta = min(le_delta, na.rm = TRUE)) %>%
  filter(min_rank(worst_le_delta) < 2) %>%
  arrange(worst_le_delta)

