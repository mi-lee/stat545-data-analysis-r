# Homework 8: Gapminder Data Cleaning
Michelle Lee  



## Loading dirty Gapminder

First, I loaded the libraries and data.

```r
# Load packages
library(knitr)
library(stringr)
library(plyr)
suppressPackageStartupMessages(library(dplyr))
```

### Strip.white

First, I experimented with `strip.white()`, and compared the two datasets using `str`. 


```r
# load uncleaned data
ddat2 <- read.delim("gapminderDataFiveYear_dirty.txt")
ddat <- read.delim("gapminderDataFiveYear_dirty.txt", strip.white=T)
str(ddat2); str(ddat)
```

```
## 'data.frame':	1704 obs. of  5 variables:
##  $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
##  $ pop      : num  8425333 9240934 10267083 11537966 13079460 ...
##  $ lifeExp  : num  28.8 30.3 32 34 36.1 ...
##  $ gdpPercap: num  779 821 853 836 740 ...
##  $ region   : Factor w/ 151 levels "    Asia_Jordan",..: 86 86 86 86 86 86 86 86 86 86 ...
```

```
## 'data.frame':	1704 obs. of  5 variables:
##  $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
##  $ pop      : num  8425333 9240934 10267083 11537966 13079460 ...
##  $ lifeExp  : num  28.8 30.3 32 34 36.1 ...
##  $ gdpPercap: num  779 821 853 836 740 ...
##  $ region   : Factor w/ 148 levels "_Canada","Africa_Algeria",..: 83 83 83 83 83 83 83 83 83 83 ...
```

THe main difference I can see is that the factor levels are different - with `strip.white`, there are only 148 levels, not 151. To find which levels are not in the `strip.white` dataset:


```r
ddat2$region[!(ddat$region %in% ddat2$region)]
```

```
## factor(0)
## 151 Levels:     Asia_Jordan     Asia_Korea, Dem. Rep. ... Oceania_New Zealand
```

```r
ddat$region[!(ddat$region %in% ddat2$region)]
```

```
## factor(0)
## 148 Levels: _Canada Africa_Algeria Africa_Angola ... Oceania_New Zealand
```

This is not entirely unexpected, because `strip.white` probably strips the white space around the region names. Since we would have to do that eventually, `strip.white` is probably a good option to use when importing data!

I also imported the clean dataset for comparison purposes:


```r
# load clean data
cdat <- read.delim("gapminderDataFiveYear.txt")
```

## Splitting or merging

I decided to split up the column using string splitting `strsplit`. 

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

Since the clean dataset has separated the country and continent, I split up the region column into 2. 

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

Then, I replaced `region` with the split columns.


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

We can check to see if the dimensions of the clean and dirty datasets of the country/continents are the same:


```r
dim(as.data.frame(cbind(ddat$continent, ddat$country)))
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

and to check if they are identical:


```r
identical(as.data.frame(cbind(ddat$continent, ddat$country)), as.data.frame(cbind(cdat$continent, cdat$country)))
```

```
## [1] FALSE
```

They are not. At closer investigation, I realized what I was missing:


```r
levels(ddat$continent)
```

```
## [1] ""         "Africa"   "Americas" "Asia"     "Europe"   "Oceania"
```

```r
levels(cdat$continent)
```

```
## [1] "Africa"   "Americas" "Asia"     "Europe"   "Oceania"
```

This leads to the next section, Missing Values:

## Missing values

The goal was to find and fix the "" level within the continents.


```r
ddat %>%
	filter(continent == "") %>%
	kable
```



 year        pop   lifeExp   gdpPercap  continent   country 
-----  ---------  --------  ----------  ----------  --------
 1952   14785584     68.75    11367.16              Canada  
 1957   17010154     69.96    12489.95              Canada  
 1962   18985849     71.30    13462.49              Canada  

The error only comes from Canada, which makes fixing this much easier. I can imagine how much more difficult it would be if there were many countries that had errors. 

Fixing it was easy - just replace "" with "Americas". Then I dropped the unused level.


```r
ddat$continent[ddat$continent == ""] <- "Americas"
ddat$continent <- droplevels(ddat$continent)
```

Then I checked to make sure everything was identical:


```r
identical(ddat$continent, cdat$continent)
```

```
## [1] TRUE
```

No more missing continents!

## Inconsistent capitalization and spelling

This was the hardest (and most important!) section, as I have never worked with regular expressions before. It took me a lot of experimentation to get used to `grep`.

I fixed inconsistent capitalization first. My first attempt was to look for countries starting with small letters:


```r
grep("^[a-z]", levels(ddat$country), value=T)
```

```
## [1] "china"
```

However, I knew there had to more more countries that had errors, since working with the Gapminder dataset had got me well acquainted with tricky country names such as Cote d'Ivoire. 

My second attempt: `[ab]` was used to look for non-capitalized words, `\b` was used to look for the pattern at the ends of the words (not strings). 


```r
grep("\\b[a-z]", levels(ddat$country), value=T)
```

```
## [1] "Bosnia and Herzegovina"           "Central african republic"        
## [3] "china"                            "Cote d'Ivoire"                   
## [5] "Cote d'Ivore"                     "Democratic Republic of the Congo"
## [7] "Sao Tome and Principe"            "Trinidad and Tobago"             
## [9] "West Bank and Gaza"
```

I checked the clean dataset to make sure we don't capitalize the "and"'s. 


```r
grep("\\b[a-z]", levels(cdat$country), value=T)
```

```
## [1] "Bosnia and Herzegovina" "Cote d'Ivoire"         
## [3] "Sao Tome and Principe"  "Trinidad and Tobago"   
## [5] "West Bank and Gaza"
```

I then tried to have a `grep` command that did not include of's, and's and other words that are not capitalized. Perhaps a bit overkill for this dataset, but I could imagine needing to know it when working with messier ones in the future.


```r
grep("\\b[a-z][^and][^d'I][^of][^the]", levels(ddat$country), value=T)
```

```
## [1] "Central african republic"         "china"                           
## [3] "Democratic Republic of the Congo"
```

I am still mystified why "Democratic Republic of the Congo" is still there. 

But, returning to our task at hand: I used `gsub` to replace the uncapitalized countries. 


```r
ddat$country <- gsub("china", "China", ddat$country)
ddat$country <- gsub("Central african republic", "Central African Republic", ddat$country)
```

We can check that it has been replaced successfully - and it has:


```r
unique(ddat$country)[20:30]
```

```
##  [1] "Cameroon"                         "Canada"                          
##  [3] "Central African Republic"         "Chad"                            
##  [5] "Chile"                            "China"                           
##  [7] "Colombia"                         "Comoros"                         
##  [9] "Congo, Dem. Rep."                 "Democratic Republic of the Congo"
## [11] "Congo, Democratic Republic"
```

### Inconsistent spelling

Now to deal with inconsistent spelling: previous commands showed dupliates such as 


```r
unique(ddat$country)[29:31]
```

```
## [1] "Democratic Republic of the Congo" "Congo, Democratic Republic"      
## [3] "Congo, Rep."
```

Another mistake I made previously: I forgot that Congo and Democratic Republic of Congo are two different countries! Since these words all have the word "Congo" in common, I used that to replace with the correct spelling (before realizing I erased a country off the dataset). 

The clean dataset indicates that the proper spelling is: 


```r
grep("*Congo", levels(cdat$country), value=T)
```

```
## [1] "Congo, Dem. Rep." "Congo, Rep."
```

Then, I searched for the countries in the dirty dataset that included the word "Congo": 

```r
grep("*Congo", unique(ddat$country), value=T)
```

```
## [1] "Congo, Dem. Rep."                 "Democratic Republic of the Congo"
## [3] "Congo, Democratic Republic"       "Congo, Rep."
```

Therefore, we should replace "Democratic Republic of the Congo" to "Congo, Dem. Rep." and so on. 


```r
wrong <- c("Congo, Democratic Republic", "Democratic Republic of the Congo")
ddat$country[ddat$country %in% wrong] <- "Congo, Dem. Rep."
```

It is fixed! I tried another way, using gsub only:


```r
ddat$country <- gsub(wrong[1], "Congo, Dem. Rep.", ddat$country)
ddat$country <- gsub(wrong[2], "Congo, Dem. Rep.", ddat$country)
grep("*Congo", unique(ddat$country), value=T)
```

```
## [1] "Congo, Dem. Rep." "Congo, Rep."
```

And it is fixed. 

One thing I will try to figure out after this assignment is to use `gsub` to filter through multiple items that have no elements in common. I could imagine it being a painful process if I had to use gsub for every entry that was spelled incorrectly.

I had one more thing to fix:


```r
ddat$country[!(ddat$country %in% cdat$country)]
```

```
## [1] "Cote d'Ivore"
```

```r
cdat$country[!(ddat$country %in% cdat$country)]
```

```
## [1] Cote d'Ivoire
## 142 Levels: Afghanistan Albania Algeria Angola Argentina ... Zimbabwe
```

This was how I knew I wasn't done yet, but if I had known, I could have used grep:


```r
grep("*Cote", unique(ddat$country), value=T)
```

```
## [1] "Cote d'Ivoire" "Cote d'Ivore"
```

I then replaced it with the correct spelling:


```r
ddat$country <- gsub("Cote d'Ivore", "Cote d'Ivoire", ddat$country)
grep("*Cote", unique(ddat$country), value=T)
```

```
## [1] "Cote d'Ivoire"
```

And now it is fixed.


## Final check


```r
str(ddat); str(cdat)
```

```
## 'data.frame':	1704 obs. of  6 variables:
##  $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
##  $ pop      : num  8425333 9240934 10267083 11537966 13079460 ...
##  $ lifeExp  : num  28.8 30.3 32 34 36.1 ...
##  $ gdpPercap: num  779 821 853 836 740 ...
##  $ continent: Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
##  $ country  : chr  "Afghanistan" "Afghanistan" "Afghanistan" "Afghanistan" ...
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
identical(ddat$country, cdat$country)
```

```
## [1] FALSE
```

I saw that country was not yet a factor and the columns were unordered, so to wrap up the last details:


```r
ddat$country <- as.factor(ddat$country)
ddat<-ddat[,c(6,1,2,5,3,4)]
```

Lastly, final check:


```r
identical(ddat, cdat)
```

```
## [1] TRUE
```

And we are done. 

![hooray](http://adamrecord.com/wp-content/uploads/2012/03/HoorayLogo.jpg)


## Summary

* `grep` is a godsend for working with character data. After this assignment I went back to my old datasets and found it extremely easy to use (unlike previous efforts where I had to spell out everything!)
* I found terms like `\b` and `\\` hard to remember when I did the `grep` for the countries, and it is very tricky to give exact instructions (capitalize every word, not the entire string) and so on. 
* extra spacing creates all sorts of havoc in factors, but `strip.white` saved me a lot of time. 
