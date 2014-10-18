gDat<-read.delim("gapminderDataFiveYear.txt")
str(gDat)

library(assertthat)

qdiff4<- function(x, probs = c(0,1)) {
  assert_that(is.numeric(x)) 
  the_quantiles <- quantile(x, probs, names = TRUE) #True means it will remove names
  max(the_quantiles) - min(the_quantiles)
}

qdiff4(gDat$lifeExp)

# NAs
z <- gDat$lifeExp
z[3] <- NA
head(z)
quantile(z)
mean(z) # propagates NA's
quantile(z, na.rm=T)

qdiff5<- function(x, probs = c(0,1), na.rm=TRUE) {
  assert_that(is.numeric(x)) 
  the_quantiles <- quantile(x, probs, names = TRUE, na.rm) #True means it will remove names
  max(the_quantiles) - min(the_quantiles)
}

qdiff4(z)
qdiff4(z) # taking control of the NA's. 


# The ... argument

set.seed(123)
rnorm(10)

qdiff7 <- function(x, probs = c(0, 1), na.rm = TRUE, ...) {
  the_quantiles <- quantile(x = x, probs = probs, na.rm = na.rm, ...)
  return(max(the_quantiles) - min(the_quantiles))
}


# Unit testing

library(testthat)
test_that('invalid args are detected', {
  expect_error(qdiff7("eggplants are purple"))
  expect_error(qdiff7(iris))
})
test_that('NA handling works', {
  expect_error(qdiff7(c(1:5, NA), na.rm = FALSE))
  expect_equal(qdiff7(c(1:5, NA)), 4)
})


library(plyr)
