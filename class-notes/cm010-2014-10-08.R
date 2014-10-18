library(plyr)
library(dplyr)

gDat<-read.delim("gapminderDataFiveYear.txt")

countries <- c("Thailand", "Rwanda", "Algeria", "Canada")

hDat <- gDat %>%
  filter(country %in% countries) %>%
  droplevels

hDat %>%
  dim
table(hDat$country)
levels(hDat$country)


# write
write.table(hDat, file = "hDat.csv", sep = ",", row.names = FALSE, quote= F)
# there are row numbers!



# reorder according to: intercept,slope, life exp max/min, pop in 2007, etc.

iDat<- hDat %>%
  mutate(country = reorder(country, lifeExp, min))

data.frame(levels(hDat$country), levels(iDat$country))

# main read-write pair!
saveRDS(iDat, "iDat.rds")

# not something you would inspect!!!!!! it's an R object 

rm(iDat)
iDat

# re-import it!
iDat <- readRDS("iDat.rds")
head(iDat) # it's back!!!!!!!!!!!



# write to file with dput!
dput # writes and saves RDS
dput(iDat, "iDat-dput.txt")
rm(iDat)
iDat
iDat <- dget("iDat-dput.txt")
iDat