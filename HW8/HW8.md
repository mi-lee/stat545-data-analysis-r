# Homework 8: Gapminder Data Cleaning
Michelle Lee  


First, I loaded the packages and data.

```r
# Load packages
library(knitr)
library(stringr)
library(plyr)
suppressPackageStartupMessages(library(dplyr))
```

I loaded both the dirty and clean Gapminder data.


```r
# load uncleaned data
ddat <- read.delim("gapminderDataFiveYear_dirty.txt")

# load clean data
cdat <- read.delim("gapminderDataFiveYear.txt")
```

Here's the dirty Gapminder data...


```r
# show top of the dirty dataset
knitr::kable(head(ddat), format = "markdown")
```



| year|      pop| lifeExp| gdpPercap|region           |
|----:|--------:|-------:|---------:|:----------------|
| 1952|  8425333|  28.801|  779.4453|Asia_Afghanistan |
| 1957|  9240934|  30.332|  820.8530|Asia_Afghanistan |
| 1962| 10267083|  31.997|  853.1007|Asia_Afghanistan |
| 1967| 11537966|  34.020|  836.1971|Asia_Afghanistan |
| 1972| 13079460|  36.088|  739.9811|Asia_Afghanistan |
| 1977| 14880372|  38.438|  786.1134|Asia_Afghanistan |

... and the clean Gapminder data:

```r
# show top of the clean dataset
kable(head(cdat), format = "markdown")
```



|country     | year|      pop|continent | lifeExp| gdpPercap|
|:-----------|----:|--------:|:---------|-------:|---------:|
|Afghanistan | 1952|  8425333|Asia      |  28.801|  779.4453|
|Afghanistan | 1957|  9240934|Asia      |  30.332|  820.8530|
|Afghanistan | 1962| 10267083|Asia      |  31.997|  853.1007|
|Afghanistan | 1967| 11537966|Asia      |  34.020|  836.1971|
|Afghanistan | 1972| 13079460|Asia      |  36.088|  739.9811|
|Afghanistan | 1977| 14880372|Asia      |  38.438|  786.1134|

I like to use `str` to check any dataset first. 


```r
str(cdat)
```

```
## 'data.frame':	1704 obs. of  6 variables:
##  $ country  : Factor w/ 142 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
##  $ pop      : num  8425333 9240934 10267083 11537966 13079460 ...
##  $ continent: Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
##  $ lifeExp  : num  28.8 30.3 32 34 36.1 ...
##  $ gdpPercap: num  779 821 853 836 740 ...
```

```r
str(ddat)
```

```
## 'data.frame':	1704 obs. of  5 variables:
##  $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
##  $ pop      : num  8425333 9240934 10267083 11537966 13079460 ...
##  $ lifeExp  : num  28.8 30.3 32 34 36.1 ...
##  $ gdpPercap: num  779 821 853 836 740 ...
##  $ region   : Factor w/ 151 levels "    Asia_Jordan",..: 86 86 86 86 86 86 86 86 86 86 ...
```

Using `str` makes obvious the differences between the two datasets, namely: there are 142 levels in the clean dataset, but 151 levels in the 'region' column of the dirty dataset. Therefore, it can't be as simple as splitting up the region column. 


## Splitting up the region column

I split up `region` of the dirty dataset into two, using `strsplit`. 

```r
# split region column into two
splitCountr<-as.data.frame(matrix(unlist(strsplit(as.character(ddat$region), "_")), ncol=2, byrow=T))

# rename the split columns
colnames(splitCountr)<- c("continent", "country")
```

Then we can see the top of the split column:


```r
# show top of the split columns
kable(head(splitCountr), format = "markdown")
```



|continent |country     |
|:---------|:-----------|
|Asia      |Afghanistan |
|Asia      |Afghanistan |
|Asia      |Afghanistan |
|Asia      |Afghanistan |
|Asia      |Afghanistan |
|Asia      |Afghanistan |

We can check to see if the dimensions of the clean and dirty datasets of the country/continents are the same:


```r
dim(splitCountr)
```

```
## [1] 1704    2
```

```r
dim(as.data.frame(cbind(cdat$continent, cdat$country)))
```

```
## [1] 1704    2
```

They are! But are they identical?


```r
identical(splitCountr, as.data.frame(cbind(cdat$continent, cdat$country)))
```

```
## [1] FALSE
```

They are not, therefore more investigation is needed. 

First, let's replace `region` with the split columns.

```r
ddat<- ddat %>%
  # get rid of the region column
  select(-region) %>% 
  # add the split columns 
  cbind(splitCountr)

# show top of the head column
kable(head(ddat), format = "markdown")
```



| year|      pop| lifeExp| gdpPercap|continent |country     |
|----:|--------:|-------:|---------:|:---------|:-----------|
| 1952|  8425333|  28.801|  779.4453|Asia      |Afghanistan |
| 1957|  9240934|  30.332|  820.8530|Asia      |Afghanistan |
| 1962| 10267083|  31.997|  853.1007|Asia      |Afghanistan |
| 1967| 11537966|  34.020|  836.1971|Asia      |Afghanistan |
| 1972| 13079460|  36.088|  739.9811|Asia      |Afghanistan |
| 1977| 14880372|  38.438|  786.1134|Asia      |Afghanistan |

Now we've split up the `region` column into two. We can move onto cleaning each column separately.

## Cleaning the country column

I can create af function `%notin%` to define the opposite of `%in%`. Using that, we can see exactly which countries are different:


```r
# create custom function
`%notin%` <- function(x,y) !(x %in% y) 

# isolate which countries are not correctly spelled
splitCountr[(splitCountr$country %notin% cdat$country),]
```

```
##     continent                          country
## 258    Africa         Central african republic
## 259    Africa         Central african republic
## 260    Africa         Central african republic
## 261    Africa         Central african republic
## 294      Asia                            china
## 295      Asia                            china
## 296      Asia                            china
## 297      Asia                            china
## 303  Americas                     Colombia    
## 304  Americas                     Colombia    
## 329    Africa Democratic Republic of the Congo
## 334    Africa       Congo, Democratic Republic
## 370    Africa                     Cote d'Ivore
```

We can also see that the levels of the countries are different:

```r
length(levels(ddat$country))
```

```
## [1] 148
```

```r
length(levels(cdat$country))
```

```
## [1] 142
```

Let's try isolating the misspelled countries to the correct name, from the clean dataset:


```r
# isolate countries that are not correctly spelled
countSpellWrong<-ddat[(ddat$country %notin% cdat$country),]

# isolate the correct spelling of the misspelled countries
countSpellRight<-cdat[(ddat$country %notin% cdat$country),]$country

# show the two merged
kable(cbind(countSpellWrong, countSpellRight), format = "markdown")
```



|    | year|        pop|  lifeExp| gdpPercap|continent |country                          |countSpellRight          |
|:---|----:|----------:|--------:|---------:|:---------|:--------------------------------|:------------------------|
|258 | 1977|    2167533| 46.77500| 1109.3743|Africa    |Central african republic         |Central African Republic |
|259 | 1982|    2476971| 48.29500|  956.7530|Africa    |Central african republic         |Central African Republic |
|260 | 1987|    2840009| 50.48500|  844.8764|Africa    |Central african republic         |Central African Republic |
|261 | 1992|    3265124| 49.39600|  747.9055|Africa    |Central african republic         |Central African Republic |
|294 | 1977|  943455000| 63.96736|  741.2375|Asia      |china                            |China                    |
|295 | 1982| 1000281000| 65.52500|  962.4214|Asia      |china                            |China                    |
|296 | 1987| 1084035000| 67.27400| 1378.9040|Asia      |china                            |China                    |
|297 | 1992| 1164970000| 68.69000| 1655.7842|Asia      |china                            |China                    |
|303 | 1962|   17009885| 57.86300| 2492.3511|Americas  |Colombia                         |Colombia                 |
|304 | 1967|   19764027| 59.96300| 2678.7298|Americas  |Colombia                         |Colombia                 |
|329 | 1972|   23007669| 45.98900|  904.8961|Africa    |Democratic Republic of the Congo |Congo, Dem. Rep.         |
|334 | 1997|   47798986| 42.58700|  312.1884|Africa    |Congo, Democratic Republic       |Congo, Dem. Rep.         |
|370 | 1997|   14625967| 47.99100| 1786.2654|Africa    |Cote d'Ivore                     |Cote d'Ivoire            |

Everything seems to make sense - except for Colombia, which doesn't look misspelled. A closer look, however, shows:


```r
# isolate the levels that include Colombia
levels(ddat$country)[28:29]
```

```
## [1] "Colombia"     "Colombia    "
```

The extra spaces in "Columbia   " turned it into a different level of a country. We can get rid of this pesky mistake, along with the other misspelled countries, by replacing the wrongly spelled countries with the right ones. 


```r
# replace the misspelled countries with the correct ones
ddat[(ddat$country %in% countSpellWrong$country),]$country <- countSpellRight
```

Now let's check if there are any misspelled countries left:


```r
# isolate which countries are misspelled
ddat[(ddat$country %in% countSpellWrong$country),]
```

```
## [1] year      pop       lifeExp   gdpPercap continent country  
## <0 rows> (or 0-length row.names)
```

Great! Now are they all correctly spelled?


```r
length(levels(droplevels(ddat$country)))
```

```
## [1] 142
```

```r
length(levels(cdat$country))
```

```
## [1] 142
```

```r
identical(levels(droplevels(ddat$country)), levels(cdat$country))
```

```
## [1] TRUE
```

Same length; and they are identical in levels. Therefore, `country` is complete!

## Cleaning the continent column

Now we can do the same for the continent column. Using our custom `%notin%` function, we can see which continents are misspelled.


```r
# isolate the misspelled continents
wrongCont<-ddat[(ddat$continent %notin% cdat$continent),]

# isolate the correct spelling of the misspelled continents
rightCont<-cdat[(ddat$continent %notin% cdat$continent),]$continent

# merge the two together to compare
kable(cbind(wrongCont, rightCont), format = "markdown")
```



|    | year|      pop| lifeExp| gdpPercap|continent |country          |rightCont |
|:---|----:|--------:|-------:|---------:|:---------|:----------------|:---------|
|241 | 1952| 14785584|  68.750| 11367.161|          |Canada           |Americas  |
|242 | 1957| 17010154|  69.960| 12489.950|          |Canada           |Americas  |
|243 | 1962| 18985849|  71.300| 13462.486|          |Canada           |Americas  |
|816 | 2007|  6053193|  72.535|  4519.461|    Asia  |Jordan           |Asia      |
|829 | 1952|  8865488|  50.056|  1088.278|    Asia  |Korea, Dem. Rep. |Asia      |
|830 | 1957|  9411381|  54.081|  1571.135|    Asia  |Korea, Dem. Rep. |Asia      |

We can see that Canada is missing 'Americas'. However, 'Asia' doesn't look misspelled. A closer look shows:


```r
levels(cdat$continent)
```

```
## [1] "Africa"   "Americas" "Asia"     "Europe"   "Oceania"
```

```r
levels(ddat$continent)
```

```
## [1] ""         "    Asia" "Africa"   "Americas" "Asia"     "Europe"  
## [7] "Oceania"
```

Like Colombia, Asia has extra spaces that changes it into a different level, along with the empty factor (for Canada). We can get rid of these pesky errors by replacing it with the correct name. 


```r
# replace the misspelled continents with the correct spelling
ddat[(ddat$continent %in% wrongCont$continent),]$continent <- rightCont

# isolate the misspelled countries
ddat[(ddat$continent %in% wrongCont$continent),]
```

```
## [1] year      pop       lifeExp   gdpPercap continent country  
## <0 rows> (or 0-length row.names)
```

None of the continents are spelled wrong! Let's check to see if the levels are the same. 


```r
identical(levels(cdat$continent), levels(droplevels(ddat$continent)))
```

```
## [1] TRUE
```

Great! Now let's check to see if all the numbers for GDP, life expectancy, etc. are the same:


```r
identical(ddat[,c(1:4)], cdat[,c(2,3,5,6)])
```

```
## [1] TRUE
```

Great! Now let's put it all together:

```r
# drop the unused levels in the dirty dataset
ddat<-droplevels(ddat)

# reorder the columns so it has the same order as the clean set
ddat<-ddat[,c(6,1,2,5,3,4)]
identical(ddat, cdat)
```

```
## [1] TRUE
```

And we are done!

## Summary
* using custom functions such as `%notin%` was very useful in this exercise, though I could have used functions like `inner_join` or `anti_join` as well.
* extra spacing creates all sorts of havoc in factors. Another easier way may be to convert the countries into character before factors? 
