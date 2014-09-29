# Meeting # 7

# dplyr is from plyr (split-apply-combine)
# except it focuses on data frames

install.packages("dplyr", dependencies=TRUE)
library(dplyr)



url="http://tiny.cc/gapminder"
gdf=read.delim(file=url)
str(gdf)
head(gdf)

gtbl=tbl_df(gdf)
gtbl
glimpse(gtbl)

# Should I create a snippet? 
# NO: when mini datasets to compute or graph
# YES: Try to use the subset argument in functions as much as you can.

# Filter(): to subset
filter(gtbl, lifeExp < 29)
filter(gtbl, country=="Rwanda")
filter(gtbl, country %in% c("Rwanda", "Afghanistan"))

# Pipe operator from magrittr: SO NEAT!
# ALT-SHIFT->
gdf %>%
  head(3)


# Instead of select()
gtbl %>%
  select(year, lifeExp) %>%
  head(4)

gtbl %>%
  filter(country == "Cambodia") %>%
  select(year, lifeExp)


#### Part 2

url="http://tiny.cc/gapminder"
gtbl = url %>%
  read.delim %>%
  tbl_df
gtbl %>%
  glimpse

# Imported the data by url, into delim, changed to tbl_df; glimpse

# Add new variables
gtbl = gtbl %>%
  mutate(gdp = pop * gdpPercap)
gtbl %>%
  glimpse

# Create a benchmark

just.canada = gtbl %>%
  filter(country == "Canada")
gtbl=gtbl %>%
  mutate(canada = just.canada$gdpPercap[match(year, just.canada$year)],
         gdpPercapRel = gdpPercap / canada)
gtbl %>%
  select(country, year, gdpPercap, canada, gdpPercapRel)

gtbl %>%
  select(gdpPercapRel) %>%
  summary


# Using Arrange() to row-order data in a principled way
gtbl %>%
  arrange(year, country)

# just data in 2007, sorted by life expectancy?
gtbl %>%
  filter(year == 2007) %>%
  arrange(lifeExp)

# Descending
gtbl %>%
  filter(year==2007) %>%
  arrange(desc(lifeExp))

# Renaming variables
gtbl %>%
  rename(lifeExp = lifeExp)

# DO NOT ASSIGN IT BACK

# GROUP BY:
# Group by: groups information
# Summarize: takes dataset of n obs, computes summaries, returns dataset with 1 observation. 
# Window functions (returns dataset with n obs)

# How many obs per continent?
gtbl %>%
  group_by(continent) %>%
  summarize(n_obs = n())
# by year?
gtbl %>%
  group_by(year) %>%
  summarize(n_obs = n())
# by country?
gtbl %>%
  group_by(country) %>%
  summarize(n_obs = n())

# Tally: convienent!
gtbl %>%
  group_by(continent) %>%
  tally

# How many countries per continent?
gtbl %>%
  group_by(continent) %>%
  summarize(n_obs = n(), n_countries = n_distinct(country))


# General summarization
# Summarize: distills to 1 output
gtbl %>%
  group_by(continent) %>%
  summarize(avgLifeExp = mean(lifeExp))

# compute average, median LE and GDP by continent by year, only for 1952
gtbl %>%
  filter(year %in% c(1952, 2007)) %>%
  group_by(continent, year) %>%
  summarise_each(funs(mean, max), lifeExp, gdpPercap)

# How about JUST asia? Min/max life expectancy?
gtbl %>%
  filter(continent == "Asia") %>%
  group_by(year) %>%
  summarise_each(funs(min, max), lifeExp)

# Which country is it that's the min/max? 
# Answer: Window functions!!

Which country contributes the extreme values?
gtbl %>%
  filter(continent =="Asia") %>%
  select(year, country, lifeExp) %>%
  arrange(year) %>%
  group_by(year) %>%
  filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2)


Window functions!!!!
  1. row_number(x): same as rank
2. ntile(x, n): rough rank (into n buckets)
3. min_rank(x): rank, min
4. dense_rank: like min_rank, but no gaps between
5. percent_rank: between 0-1 by rescaling min_rank.
6. cume_dist: cumuative distribution function - porp of all values less than or equal to rank


x <- c(5, 1, 3, 2, 2)
row_number(x) # whatever is first
min_rank(x) # 2 2 if a tie
dense_rank(x) # doesn't skip if there's a tie
percent_rank(x) # what percentage is it? 0 if first, 1 if last
cume_dist(x) # same as above, but in cumulative

ntile(x, 2)
ntile(runif(100), 10)


One row per year?
asia=gtbl %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  arrange(year) %>%
  group_by(year)
asia

# Use min_rank to operate within! the rank of each country's life exp. 
asia %>%
  mutate(life.rank = min_rank(lifeExp), life.drank = min_rank(desc(lifeExp)))

# Want just min or max? Use top_n()
gtbl %>%
  filter(continent == "Asia") %>%
  select(year, country, lifeExp) %>%
  arrange(year) %>%
  group_by(year) %>%
  top_n(1, desc(lifeExp)) ## gets the max


# what country had the sharpest 5-year drop in life expectacy?
gtbl %>%
  group_by(continent, country) %>%
  select(country, year, continent, lifeExp) %>%
  mutate(le_delta = lifeExp - lag(lifeExp)) %>%
  summarize(worst_le_delta = min(le_delta, na.rm = TRUE)) %>%
  filter(min_rank(worst_le_delta) < 2) %>%
  arrange(worst_le_delta)

