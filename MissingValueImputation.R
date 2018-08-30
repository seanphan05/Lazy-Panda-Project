# Function to imputate missing values
miss.imputate <- function(train.data, test.data)
{
 { # imputation for training data
  if (anyNA(train.data)) {
    # change all character columns into factor:
    train.data1    <- data.frame(train.data, stringsAsFactors = TRUE)
    # convert all missing values into NA
    name.train <- names(train.data1)
    for (i in 1:length(name.train)) { train.data1[train.data1==""] <- NA }
    # imputation for missing values
    library(missForest)
    imp.train <- missForest(train.data1)
    new.train <- as.data.frame(imp.train$ximp) }
  else { new.train <- train.data }
 } # imputation for training data  
  
  
 { # imputation for testing data
  if (anyNA(test.data)) {
    # change all character columns into factor:
    test.data1     <- data.frame(test.data, stringsAsFactors = TRUE)
    # convert all missing values into NA
    name.test <- names(test.data1)
    for (i in 1:length(name.test)) { test.data1[test.data1==""] <- NA }
    # imputation for missing values
    library(missForest)
    imp.test <- missForest(test.data1)
    new.test  <- as.data.frame(imp.test$ximp) }
  else { new.test <- test.data }
 } # imputation for testing data
  
  return(list(new.train, new.test))
}