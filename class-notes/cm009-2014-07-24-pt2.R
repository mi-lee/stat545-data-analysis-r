
library(plyr)
# library(dplyr)

gDat<-read.delim("gapminderDataFiveYear.txt")


## challenge
# write a function where: 
## input: data frame with at least two variables, one named year, one named lifeExp
## output: a numeric vector = est.intercept and slope from lm(lifeExp ~ year, data)

my.lm.fcn <- function(x, ...) {
  model=lm(lifeExp ~ year, x, ...)
  estCoefs <- coef(model)
  names(estCoefs) <- c("intercept", "slope")
  the_residuals <- residuals(model)
  the_effects <- effects(model)
  the_fitted_vals <- fitted.values(model)
  total.frame <- cbind(estCoefs, the_residuals, the_effects, the_fitted_vals)
  names(total.frame) <- c("intercept", "slope", "residuals", "effects", "fitted vals")
  return(total.frame)
}
Coefs <- ddply(gDat, ~ continent + country, my.lm.fcn)
head(Coefs)


library(testthat)

test_that('invalid args are detected', {
  expect_error(qdiff7("eggplants are purple"))
  expect_error(qdiff7(iris))
})
test_that('NA handling works', {
  expect_error(qdiff7(c(1:5, NA), na.rm = FALSE))
  expect_equal(qdiff7(c(1:5, NA)), 4)
})
