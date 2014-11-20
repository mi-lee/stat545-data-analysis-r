# 5-automate-pipeline
Michelle Lee  


```r
source("1-download-data.R")
```

```
## Loading required package: bitops
```

```r
source("2-exploratory-analysis.R")
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
## 
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
```

```r
source("3-stat-analysis.R")
source("4-generate-figures.R")
```

```
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
## Saving 7 x 5 in image
```

```r
files<- c("best-worst-gapminder.tsv","gapminder.tsv", "sorted_gapminder.tsv", "plots/gdp-quantile.png", "plots/lifeExp-density.png","plots/lifeExp-quantile.png","plots/r-sq-africa.png", "plots/r-sq-americas.png", "plots/r-sq-asia.png","plots/r-sq-europe.png","plots/r-sq-oceania.png")

unlink(files)
```

