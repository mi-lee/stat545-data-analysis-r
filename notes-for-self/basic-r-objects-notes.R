## The many flavours of R objects

# operations are vectorized, so no need to write unnecessary for loops
# for example, mean and standard deviation of random normal RVs

# set.seed: random number generator; can be saved and restored
set.seed(1999)
rnorm(5, mean= 10^(1:5))

# R recycles vectors if not necessary length
y=1:3
z=3:7
y+z
y=1:10
z=3:7
y+z # no mention of recycling

# str(): display internal structure 

# R objects can be coerced to lowest common denom, e.g. string

# most important atomic vector types:
# logical
# numeric
# character

n=8
set.seed(1)
w=round(rnorm(n), 2)
x=1:n
y=LETTERS[1:n]

# Indexing vectors
# - logical vectors: keep only TRUEs; keep only positives, keep only certain characters
names(w) = letters[seq_along(w)]
w<0
which(w<0)
w[w>0]


# ways to filter:
w[seq(from=1, to=length(w), by=2)] # make a sequence vector ahead of time
w[-c(2,5)] # subtract col by num
w[c('c', 'a','f')] # select by name


# Lists
# - like data frames; no requirement each element is same type
# can name lists like:
names(a) = c("hi", "hello")

# Indexing a list
# [] one bracket: list of length 1
# [[]]: just the element itself 
# can also use list$Name

# Want more than 1 element? Return is always a lsit. 


## Data frames
n <- 8
set.seed(1)
(jDat <- data.frame(w = round(rnorm(n), 2),
                    x = 1:n,
                    y = I(LETTERS[1:n]),
                    z = runif(n) > 0.3,
                    v = rep(LETTERS[9:12], each = 2)))
str(jDat)
mode(jDat)
class(jDat)
# Data frames are just lists! Each col names up 1 element of a list
is.list(jDat)
jDat[5]
class(jDat[[5]])


# List to data frame:
(qDat <- list(w = round(rnorm(n), 2),
              x = 1:(n-1), ## <-- LOOK HERE! I MADE THIS VECTOR SHORTER!
              y = I(LETTERS[1:n])))
as.data.frame(qDat) # doesn't work b/c not same length


# Indexing arrays/matrices
jMat <- outer(as.character(1:4), as.character(1:4),
              function(x, y) {
                paste0('x', x, y)
              })
jMat
# Label row names!
rownames(jMat) <- paste0("row", seq_len(nrow(jMat)))
colnames(jMat) <- paste0("col", seq_len(ncol(jMat)))
dimnames(jMat) # also useful for assignment

# Indexing a matrix is similar to indexing a vector/list - square brackets!
jMat[, 3, drop=F] # the FALSE drop indicates keep as a matrix

# R is column-major order, e.g. columns are stacked up one after another, not by row. 
jMat[7] # gives you 7th num by going DOWN columns!


# Ways to create a matrix
# 1. fill a matrix with a vector
# 2. Glue vectors by row/col
# 3. conversion of data.frame
matrix(1:15, nrow=5) # go down a column order
matrix(1:15, nrow=5, byrow=TRUE) # go across row order

# Glue: cbind, rbind


# Implications for data frames
# - data frames are just lists
# - the list elements are the variables
jDat$z # or
jDat["y"]
jDat[, "v"] # select by name!!!!!!!!
jDat[4,"w"]
jDat[jDat$z,] # select rows in which z = TRUE!!!!!
subset(jDat, subset=z)


# Flavours: character/logical/num/factor
# Typeof: character/logical/ INT OR DOUBLE / INT
# Mode: character/logical/numeric/NUMERIC
# Class: character/logical/ INT OR DOUBLE/ factor


