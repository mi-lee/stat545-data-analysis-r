# 1-download-data
Michelle Lee  




```r
library(RCurl)
```

```
## Loading required package: bitops
```

```r
cat(file = "gapminder.tsv", getURL("https://raw.githubusercontent.com/STAT545-UBC/STAT545-UBC.github.io/master/gapminderDataFiveYear.txt"))
```

