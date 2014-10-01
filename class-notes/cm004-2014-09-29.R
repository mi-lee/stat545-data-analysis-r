# Writing functions
gDat<-read.delim("gapminderDataFiveYear.txt")
str(gDat)

## task
## input: a variable
## output: max - min


## practice input be gDat$lifeExp
max.minus.min <- function(x) {
  max(x) - min(x)
}
max.minus.min(gDat$lifeExp)
max.minus.min(runif(1000))
max.minus.min(1:5)

## test on other vars
max.minus.min(gDat$gdpPercap)
max.minus.min(gDat$pop)

# try to break the function
max.minus.min(c(1, "Hi", c(1:3)))
max.minus.min(c(Inf + 1, Inf))
max.minus.min(c(1:3), c(4,5))
max.minus.min(sqrt(-1))
max.minus.min(gDat$country)  # run on a factor
max.minus.min(gDat)
max.minus.min(gDat[c('lifeExp', 'pop', 'gdpPercap')])

# check validity
mmm <- function(x) {
  stopifnot(is.numeric(x)) 
  max(x) - min(x)
}
mmm(gDat) # Still breaks the function, but you get a better error message!
mmm("Hi")


mmm2 <- function(x) {
  if(!is.numeric(x)) {
    stop("This is not numeric!")
  }
  max(x) - min(x)
}

## packages that help!

################ 1. assertthat
library(assertthat)

mmm3 <- function(x) {
  require(assertthat)
  assert_that(is.numeric(x))
  max(x) - min(x)
}
mmm3(5)


############### 2. ensurer


################## Harder example
## make our function more general
## input: two numbers between 0 and 1, "probabilities"
## output: difference between the associated quantiles 

## GET IT WORKING IN AN EXAMPLE< INTERACTIVELY
p=pnorm(3, mean=2.5)
q=pnorm(4, mean=4.2334242)

sample.probs=c(0.25, 0.75)
sample.probs=c(p,q)
get.quantiles <- quantile(gDat$lifeExp, probs = sample.probs)
max(get.quantiles)- min(get.quantiles)


qdiff1 <- function(x, probs) {
  assert_that(is.numeric(x))
  max(x) - min(x)
  get.quantiles <- quantile(x, probs = probs)
  max(get.quantiles)- min(get.quantiles)
}
qdiff1(gDat$lifeExp, probs=c(0,1))
qdiff1(gDat$gdpPercap, probs=c(0,1))  ## Oops. this is wrong. Don't leave your example within the function!


# Add defaults
qdiff1 <- function(x, probs=c(0,1)) {
  assert_that(is.numeric(x))
  max(x) - min(x)
  get.quantiles <- quantile(x, probs = probs)
  max(get.quantiles)- min(get.quantiles)
}
qdiff1(gDat$lifeExp)


## revisit argument validity checking?
## probs must be [0,1]
## check that probs are numeric
