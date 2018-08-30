# Input dataset and additional conditions:
tar.loc.train = 17 # the location of target variable column in train data
tar.loc.test = 17 # the location of target variable column in test data

# input dataset:
split.need=FALSE # TRUE if input data need to be splitted into train & test data
{
if (split.need) { # data need to be splitted
  input.data <- read.csv("credit.csv", sep = ",", row.names = NULL)
  indx <- sample(1:nrow(input.data), as.integer(0.9*nrow(input.data)))
  
  train.data <- input.data[indx,]
  test.data  <- input.data[-indx,]
  }
else { # data doesn't need to be splitted
  train.data <- read.csv("credit_train.csv", 
                         sep = ",", row.names = NULL) # replace name as input data
  test.data  <- read.csv("credit_test.csv",
                         sep = ",", row.names = NULL) # replace name as input data
  }
}
# import conditions:
ord.var = TRUE # TRUE if dataset contains ordinal column(s), otherwise FALSE
# the location of ordinal column(s) 
ord.loc.train = c(1,3)
ord.loc.test  = c(1,3)
# the sorted ordinal variables in ascending order
vec1 = c("unknown", "< 0 DM", "1 - 200 DM", "> 200 DM")
vec2 = c("poor", "good", "very good", "critical", "perfect")
ord.vec <- list(vec1, vec2)


