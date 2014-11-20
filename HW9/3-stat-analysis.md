# 3-stat-analysis
Michelle Lee  


```r
library(ggplot2)
library(ggthemes)
library(plyr)
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
## The following objects are masked from 'package:plyr':
## 
##     arrange, count, desc, failwith, id, mutate, rename, summarise,
##     summarize
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
library(knitr)
# import data from previous R script!

gdat <- dget("sorted_gapminder.tsv")

# check to make sure the order is still in force
head(gdat)
```

```
##   country year      pop continent lifeExp gdpPercap
## 1 Algeria 1952  9279525    Africa  43.077  2449.008
## 2 Algeria 1957 10270856    Africa  45.685  3013.976
## 3 Algeria 1962 11000948    Africa  48.303  2550.817
## 4 Algeria 1967 12760499    Africa  51.407  3246.992
## 5 Algeria 1972 14760787    Africa  54.518  4182.664
## 6 Algeria 1977 17152804    Africa  58.014  4910.417
```

```r
levels(gdat)
```

```
## NULL
```

```r
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
```



|country           |continent | intercept|     slope|        sd|     adj.r|
|:-----------------|:---------|---------:|---------:|---------:|---------:|
|Mauritania        |Africa    |  40.02560| 0.4464175| 0.4075323| 0.9974417|
|Equatorial Guinea |Africa    |  34.43031| 0.3101706| 0.3286898| 0.9965555|
|Comoros           |Africa    |  39.99600| 0.4503909| 0.4786468| 0.9965358|
|Mali              |Africa    |  33.05123| 0.3768098| 0.4816026| 0.9949965|
|Brazil            |Americas  |  51.51204| 0.3900895| 0.3262359| 0.9978522|
|Nicaragua         |Americas  |  43.04513| 0.5565196| 0.5984214| 0.9964538|
|Guatemala         |Americas  |  42.11940| 0.5312734| 0.5811789| 0.9963301|
|Canada            |Americas  |  68.88385| 0.2188692| 0.2492483| 0.9960241|
|Australia         |Oceania   |  68.40051| 0.2277238| 0.6206086| 0.9776125|
|New Zealand       |Oceania   |  68.68692| 0.1928210| 0.8043472| 0.9489431|
|France            |Europe    |  67.79013| 0.2385014| 0.2200468| 0.9973870|
|Switzerland       |Europe    |  69.45372| 0.2222315| 0.2149115| 0.9971299|
|Sweden            |Europe    |  71.60500| 0.1662545| 0.2117679| 0.9950304|
|Belgium           |Europe    |  67.89192| 0.2090846| 0.2929025| 0.9939946|
|Pakistan          |Asia      |  43.72296| 0.4057923| 0.4029337| 0.9969746|
|Indonesia         |Asia      |  36.88312| 0.6346413| 0.6455478| 0.9968256|
|Iran              |Asia      |  44.97899| 0.4966399| 0.6646329| 0.9945169|
|Israel            |Asia      |  66.30041| 0.2671063| 0.3657401| 0.9942612|

```r
# 4 worst countries by slope
worst<-function(data) {
  head(arrange(data, adj.r), n=4)
}
worst<-ddply(mod, ~continent, worst)
kable(worst, format = "markdown")
```



|country             |continent | intercept|      slope|        sd|      adj.r|
|:-------------------|:---------|---------:|----------:|---------:|----------:|
|Rwanda              |Africa    |  42.74195| -0.0458315| 6.5582695| -0.0811244|
|Botswana            |Africa    |  52.92912|  0.0606685| 6.1121773| -0.0625743|
|Zimbabwe            |Africa    |  55.22124| -0.0930210| 7.2054307| -0.0381448|
|Zambia              |Africa    |  47.65803| -0.0604252| 4.5287128| -0.0341799|
|Trinidad and Tobago |Americas  |  62.05231|  0.1736615| 1.6519842|  0.7778082|
|Jamaica             |Americas  |  62.66099|  0.2213944| 2.0559436|  0.7862249|
|Puerto Rico         |Americas  |  66.94853|  0.2105748| 1.2687184|  0.8986010|
|Cuba                |Americas  |  62.21345|  0.3211503| 1.7406420|  0.9164739|
|New Zealand         |Oceania   |  68.68692|  0.1928210| 0.8043472|  0.9489431|
|Australia           |Oceania   |  68.40051|  0.2277238| 0.6206086|  0.9776125|
|Bulgaria            |Europe    |  65.73731|  0.1456888| 2.5091166|  0.5011964|
|Slovak Republic     |Europe    |  67.00987|  0.1340441| 1.2998295|  0.7709230|
|Hungary             |Europe    |  65.99282|  0.1236490| 1.1871261|  0.7745206|
|Montenegro          |Europe    |  62.24163|  0.2930014| 2.7538317|  0.7820517|
|Iraq                |Asia      |  50.11346|  0.2352105| 4.0570966|  0.5003626|
|Cambodia            |Asia      |  37.01542|  0.3959028| 5.6301432|  0.6025614|
|Korea, Dem. Rep.    |Asia      |  54.90560|  0.3164266| 3.8881763|  0.6733694|
|China               |Asia      |  47.19048|  0.5307149| 3.8569904|  0.8584051|

```r
lmDat <- rbind(best, worst)

lmDat <- lmDat %>%
  mutate(continent = reorder(continent, adj.r, max)) %>%
  arrange(continent)

dput(lmDat, file= "best-worst-gapminder.tsv")
```

